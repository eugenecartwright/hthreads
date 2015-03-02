/*
 * Copyright (c) 2001-2003 Swedish Institute of Computer Science.
 * All rights reserved. 
 *
 * Copyright (c) 2001, 2002, 2003 Xilinx, Inc.
 * All rights reserved. 
 * 
 * Redistribution and use in source and binary forms, with or without 
 * modification, are permitted provided that the following conditions 
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission. 
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED 
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF 
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO 
 * EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; 
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF 
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS".
 * BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS ONE POSSIBLE 
 * IMPLEMENTATION OF THIS FEATURE, APPLICATION OR STANDARD, XILINX 
 * IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION IS FREE FROM 
 * ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE FOR OBTAINING 
 * ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.  XILINX 
 * EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO THE 
 * ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY 
 * WARRANTIES OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE 
 * FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY 
 * AND FITNESS FOR A PARTICULAR PURPOSE.
 * 
 * This file is part of the lwIP TCP/IP stack.
 * 
 * Author: Sathya Thammanur <sathyanarayanan.thammanur@xilinx.com>
 * 
 * Based on example ethernetif.c, Adam Dunkels <adam@sics.se>
 *
 */

/*---------------------------------------------------------------------------*/
/* EDK Include Files                                                         */
/*---------------------------------------------------------------------------*/
#include "xemac.h"
#include "xparameters.h"
#include "xstatus.h"

#ifdef __PPC__
#include "xcache_l.h"
#endif

/*---------------------------------------------------------------------------*/
/* LWIP Include Files                                                        */
/*---------------------------------------------------------------------------*/
#include "lwip/debug.h"
#include "lwip/opt.h"
#include "lwip/def.h"
#include "lwip/mem.h"
#include "lwip/pbuf.h"
#include "lwip/stats.h"
#include "lwip/sys.h"
#include "lwip/netif.h"
#include "netif/etharp.h"
#include "eth/netif.h"

#include "lwip/tcp.h"

/*---------------------------------------------------------------------------*/
/* Emac Options                                                              */
/*---------------------------------------------------------------------------*/
#define DEFAULT_OPTIONS      (XEM_UNICAST_OPTION | XEM_INSERT_PAD_OPTION | \
                              XEM_INSERT_FCS_OPTION | XEM_BROADCAST_OPTION | \
                              XEM_STRIP_PAD_FCS_OPTION)

/*---------------------------------------------------------------------------*/
/* Describe network interface                                                */
/*---------------------------------------------------------------------------*/
#define IFNAME0 'e'
#define IFNAME1 '0'

/*---------------------------------------------------------------------------*/
/* Constant Definitions                                                      */
/*---------------------------------------------------------------------------*/
#define XEM_MAX_FRAME_SIZE_IN_WORDS ((XEM_MAX_FRAME_SIZE/sizeof(Xuint32))+1)

/*
 * Define the number of buffer descriptors available and the size of the
 * memory required for them.  Also define the size of the buffer memory
 * to be used for the network buffers.  This size will allow for twice the
 * number of buffers as there are buffer descriptors.
 */

#define NUM_DESCRIPTORS      32

#define DESCRIPTOR_MEM_SIZE  (sizeof(XBufDescriptor) * NUM_DESCRIPTORS)
#define BUFFER_MEM_SIZE      (XEM_MAX_FRAME_SIZE_IN_WORDS * NUM_DESCRIPTORS * 2)

#ifdef __MICROBLAZE__
#define RECV_ALIGN           4 
#else /* PPC */
#define RECV_ALIGN           8
#endif

#define RX_PSEUDO_HEADER_DATA_START     26
#define RX_PSEUDO_HEADER_DATA_END       32

#define TX_PSEUDO_HEADER_DATA_START     26
#define TX_PSEUDO_HEADER_DATA_END       32

#define MB_DCE_MASK 0x00000080 /* 24-bit is 1 */

static const struct eth_addr ethbroadcast = {{0xff,0xff,0xff,0xff,0xff,0xff}};
//extern XEmacIf_Config XEmacIf_ConfigTable[];
XEmacIf_Config XEmacIf_ConfigTable[1];

/*---------------------------------------------------------------------------*/
/* Forward declarations                                                      */
/*---------------------------------------------------------------------------*/
static err_t xemacif_output(struct netif *netif, struct pbuf *p,
                struct ip_addr *ipaddr);
static void xemacif_send_handler(void *CallBackRef, XBufDescriptor*Bdptr, Xuint32 NumBds);
static void xemacif_error_handler(void *CallBackRef, XStatus Code);
static void low_level_input(void *CallBackRef, XBufDescriptor *BdPtr, Xuint32 NumBds);
static XStatus InitReceiveBuffers(XEmac *InstancePtr);
static void flush_dcache_range(Xuint8* data_p,Xuint32 len);
static void invalidate_dcache_range(Xuint8* data_p,Xuint32 len);

static Xuint16 AddCsumTxPseudoHeader(struct pbuf *p, Xuint16 InitCSum,
				     Xuint16 IpPayloadLen, Xuint16 ProtoTTL);
static Xuint16 AddCsumRxPseudoHeader(struct pbuf *p, Xuint16 InitCSum,
				     Xuint16 IpPayloadLen, Xuint16 ProtoTTL);


/*
 * Define buffer descriptor and buffer memory. We allocate twice as many
 * buffers as there are descriptors. The descriptor memory needs to be
 * 32-bit aligned. The buffer memory needs to be 64-bit aligned if using
 * the PLB 10/100 EMAC, or 32-bit aligned if using the OPB 10/100 EMAC. We
 * chose to use a gnu compiler attribute to get the alignment in this example,
 * but you may need to implement another mechanism based on your needs.
 */
#ifdef __MICROBLAZE__
static Xuint32 SendBdMem[DESCRIPTOR_MEM_SIZE / sizeof(Xuint32)] __attribute__ ((aligned (128), section(".data")));
static Xuint32 RecvBdMem[DESCRIPTOR_MEM_SIZE / sizeof(Xuint32)] __attribute__ ((aligned (128), section(".data")));
#else
static Xuint32 SendBdMem[DESCRIPTOR_MEM_SIZE / sizeof(Xuint32)] __attribute__ ((aligned (8), section(".data")));
static Xuint32 RecvBdMem[DESCRIPTOR_MEM_SIZE / sizeof(Xuint32)] __attribute__ ((aligned (8), section(".data")));
#endif


//static Xuint32 RecvBufferMem[BUFFER_MEM_SIZE] __attribute__ ((aligned (8)));

/*
 * Keep track of the memory used for send buffers
 */
//#ifdef NO_DRE
static Xuint32 SendBufferMem[BUFFER_MEM_SIZE] __attribute__ ((aligned (8)));
static Xuint32 *NextSendBuffer = SendBufferMem;
//#endif

typedef struct {
  struct pbuf* buf;
  Xuint32 buf_full;
} rcv_pkt_buf_t;

typedef struct {
  Xuint32 Buffer[XEM_MAX_FRAME_SIZE_IN_WORDS];
  Xuint32 buf_full;
} snd_pkt_buf_t;

//static snd_pkt_buf_t send_pkt_buf[SEND_BUF_SIZE] = {{1}, 0};
static rcv_pkt_buf_t recv_pkt_buf[NUM_DESCRIPTORS] = {NULL, 0};

Xuint32 rcv_pkt_dropped = 0;
Xuint32 rcv_pos_insert = 0;
Xuint32 rcv_pos_remove = 0;

Xuint32 snd_pkt_dropped = 0;
Xuint32 snd_pos_insert = 0;
Xuint32 snd_pos_remove = -1;

/*---------------------------------------------------------------------------*/
/* low_level_init function                                                   */
/*    - hooks up the data structures and sets the mac options and mac        */
/*---------------------------------------------------------------------------*/
static err_t 
low_level_init(struct netif *netif_ptr)
{
   XEmac *InstancePtr = mem_malloc(sizeof(XEmac));
   XEmacIf_Config *xemacif_ptr = (XEmacIf_Config *) netif_ptr->state;
   Xuint16 DeviceId = xemacif_ptr->DevId;
   XStatus Result, Status;
   Xuint32 Options;
   XEmac_Config *ConfigPtr;
   Xuint32 i;

   xemacif_ptr->instance_ptr = InstancePtr;
   
   /*
    * We change the configuration of the device to indicate no DMA just in
    * case it was built with DMA. In order for this example to work, you
    * either need to do this or, better yet, build the hardware without DMA.
    */
   ConfigPtr = XEmac_LookupConfig(DeviceId);
   
   /* Call Initialize Function of EMAC driver */
   Result = XEmac_Initialize(InstancePtr, DeviceId);
   if (Result != XST_SUCCESS) {
     LWIP_DEBUGF(NETIF_DEBUG, ("XEmac_Initialize failed \r\n"));
     return ERR_MEM;
   }

   /*
    * We check here to be sure the device is configured with DMA
    */
   if (!XEmac_mIsSgDma(InstancePtr))
     {
       /*
	* OOPS! not configured for DMA
	*/
       return ERR_MEM;
     }  
   
   /* Set MAC Options */   
   Options = ( XEM_INSERT_FCS_OPTION | 
               XEM_INSERT_PAD_OPTION | 
               XEM_UNICAST_OPTION | 
               XEM_BROADCAST_OPTION | 
               XEM_STRIP_PAD_FCS_OPTION);

   Result = XEmac_SetOptions(InstancePtr, Options);
   if (Result != XST_SUCCESS) {
     LWIP_DEBUGF(NETIF_DEBUG, ("Failed to Set XEmac Options \r\n"));
     return ERR_MEM;
   }

   /* Set MAC Address of EMAC */
   Result = XEmac_SetMacAddress(InstancePtr, (Xuint8*) netif_ptr->hwaddr);
   if (Result != XST_SUCCESS) return ERR_MEM;

   /*
    * Give the driver the memory it needs for buffer descriptors, then
    * initialize the receive buffer descriptors by attaching buffers to
    * them.
    */
   if (XEmac_SetSgSendSpace(InstancePtr, SendBdMem, DESCRIPTOR_MEM_SIZE) != XST_SUCCESS)
     return ERR_MEM;
   if (XEmac_SetSgRecvSpace(InstancePtr, RecvBdMem, DESCRIPTOR_MEM_SIZE) != XST_SUCCESS)
     return ERR_MEM;
   
    Status = InitReceiveBuffers(InstancePtr);
    if (Status != XST_SUCCESS)
      {
        return ERR_MEM;
      }
    
    /* Stop the EMAC hardware */
    XEmac_Stop(InstancePtr);
    
    /*
     * For the upcoming loopback test, set the receive packet threshold to
     * one packet to avoid any delays on receive.
     */
    XEmac_SetPktThreshold(InstancePtr, XEM_RECV, 10);
    XEmac_SetPktThreshold(InstancePtr, XEM_SEND, 5);  

    /*
     * Set the DMA callbacks and error handler. These callbacks are invoked
     * by the driver during interrupt processing.
     */
    (void)XEmac_SetSgSendHandler(InstancePtr, netif_ptr, xemacif_send_handler);
    (void)XEmac_SetSgRecvHandler(InstancePtr, netif_ptr, low_level_input);
    (void)XEmac_SetErrorHandler(InstancePtr, netif_ptr, xemacif_error_handler);

   /* Start the EMAC hardware */
   Result = XEmac_Start(InstancePtr);
   if (Result != XST_SUCCESS) {
     LWIP_DEBUGF(NETIF_DEBUG, ("Failed to Start XEmac Hardware \r\n"));
     return ERR_MEM;
   }

   /* Clear driver stats */
   XEmac_ClearStats(InstancePtr);

   for(i= 0; i < NUM_DESCRIPTORS; i++) {
     recv_pkt_buf[i].buf = pbuf_alloc(PBUF_RAW, XEM_MAX_FRAME_SIZE - 4, PBUF_POOL);
     recv_pkt_buf[i].buf_full = 0;
   }
   
   /*   for(i= 0; i < SEND_BUF_SIZE; i++) {
	send_pkt_buf[i].buf_full = 0;
	}
   */
   return ERR_OK;
}

/*****************************************************************************/
/**
* This function initializes the receive buffer memory.  For every buffer
* descriptor, we attach a buffer to it and give the descriptor to the XEmac
* driver. The driver will fill the buffer when an Ethernet frame is received.
*
* @param    InstancePtr contains a pointer to the instance of the EMAC device
*           for which the receive buffers are being initialized.
*
* @return   XST_SUCCESS if successful, otherwise XST_FAILURE
*
* @note     None.
*
******************************************************************************/
static XStatus InitReceiveBuffers(XEmac *InstancePtr)
{
    Xuint8 *FramePtr;
    XStatus Status;
    int Index;
    XBufDescriptor Bd  __attribute__ ((aligned(128)));
    struct pbuf *p = NULL;

    /*
     * Attach buffers to the receive descriptor list by calling the driver's
     * SgRecv function for each buffer/descriptor
     */
    //    FramePtr = (Xuint8 *)RecvBufferMem;
    for (Index=0; Index < NUM_DESCRIPTORS; Index++)
    {
      p = pbuf_alloc(PBUF_RAW, XEM_MAX_FRAME_SIZE - 4, PBUF_POOL);
      if (p == NULL){
	LWIP_DEBUGF(NETIF_DEBUG, ("[init]pbuf not allocated error ... \r\n", FramePtr));
	return ERR_MEM;
      }
      FramePtr = (Xuint8*) p->payload;

      if (((Xuint32)FramePtr % RECV_ALIGN) != 0){
	LWIP_DEBUGF(NETIF_DEBUG, ("[init]pbuf_payload alignment error %x\r\n", FramePtr));
	return ERR_MEM;
      }
      
      /*
       * Initialize the descriptor and set the buffer address to point to
       * the next frame. Buffer length gets max frame size.
       */
      XBufDescriptor_Initialize(&Bd);
      XBufDescriptor_Lock(&Bd);
      XBufDescriptor_SetDestAddress(&Bd, (Xuint32)FramePtr);
      XBufDescriptor_SetLength(&Bd, XEM_MAX_FRAME_SIZE);
      XBufDescriptor_SetId(&Bd, p);
      
      /*
       * Now give the descriptor with attached buffer to the driver and
       * let it make it ready for frame reception
       */
      Status = XEmac_SgRecv(InstancePtr, &Bd);
      if (Status != XST_SUCCESS)
        {
	  return ERR_MEM;
        }
    }

    return XST_SUCCESS;
}

/*---------------------------------------------------------------------------*/
/* low_level_output()                                                        */
/*                                                                           */
/* Should do the actual transmission of the packet. The packet is            */
/* contained in the pbuf that is passed to the function. This pbuf           */
/* might be chained.                                                         */
/*---------------------------------------------------------------------------*/
static XBufDescriptor bd[10]  __attribute__ ((aligned(128)));

static err_t low_level_output(struct netif *netif, struct pbuf *p)
{
   struct pbuf *q;
   Xuint8 *frame_ptr;
   XStatus Result;
   XEmacIf_Config *xemacif_ptr = netif->state;
   XEmac *EmacPtr = (XEmac *) xemacif_ptr->instance_ptr;

   XBufDescriptor *prev_p, *cur_p;
   Xuint32 tot_len = p->tot_len;
   Xuint32 ActualLen = p->tot_len;
   Xuint32 tot_links = 0, i;
   Xuint16 csum_insert_offset;
   Xuint16 PhCSum, IpDataLen;
   Xuint16 IpHeaderLength, ProtoTTL;
   struct eth_hdr * ethernet_header;
   struct ethip_hdr* ethernet_ip_header;

   cur_p = &bd[0];
   prev_p = NULL;

   ethernet_header = p->payload;
   ethernet_ip_header = p->payload;

   if (p->next)
     tot_links++;

#if XEMAC_V1_04_A_VER
   if (!XEmac_mIsTxDre(EmacPtr))
     {
       q = p;   
       if (tot_links) 
	 {
	   frame_ptr = (Xuint8*)NextSendBuffer;
	   tot_len = 0;
	   NextSendBuffer += XEM_MAX_FRAME_SIZE_IN_WORDS;
	   if (NextSendBuffer > (SendBufferMem + BUFFER_MEM_SIZE))
	     NextSendBuffer = SendBufferMem;
	   do {
	     memcpy((Xuint8*)frame_ptr+tot_len,q->payload, q->len);
	     tot_len += q->len;
	     q = q->next;
	   } while (q != NULL);
	 } 
       else 
	 {
	   frame_ptr = (Xuint8*) q->payload;
	   if ((unsigned long)frame_ptr %8)
	     {
	       memcpy((Xuint8*)NextSendBuffer,q->payload, q->len);
	       frame_ptr = (Xuint8*)NextSendBuffer;
	       /*
		* Adjust the next send buffer pointer, wrap to the beginning of the
		* send memory if necessary. Be sure the next buffer is word-aligned.
		*/
	       NextSendBuffer += XEM_MAX_FRAME_SIZE_IN_WORDS;
	       if (NextSendBuffer > (SendBufferMem + BUFFER_MEM_SIZE))
		 NextSendBuffer = SendBufferMem;
	     }
	   tot_len = q->len;
	 }
       XBufDescriptor_Initialize(&bd[0]);
       XBufDescriptor_Lock(&bd[0]);
       XBufDescriptor_SetSrcAddress(&bd[0], frame_ptr);
       XBufDescriptor_SetLength(&bd[0], tot_len);
       XBufDescriptor_SetLast(&bd[0]);
       
       Result = XEmac_SgSend(xemacif_ptr->instance_ptr, &bd[0], XEM_SGDMA_NODELAY);
       
       if (Result != XST_SUCCESS) {
	 snd_pkt_dropped++;
	 return ERR_MEM;
       } 
     }
   else /* DRE IS PRESENT */
     {
       cur_p = &bd[0];
       prev_p = NULL;
       
       /*
	* Return to the default configuration for the driver
	*/
       XEmac_mDisableTxHwCsum(EmacPtr);
       
       
       for(q = p; q != NULL; q = q->next) 
	 {
	   /*
	    * Initialize the buffer desctiptor and then
	    * lock the buffer descriptor to prevent lower layers from reusing
	    * it before the adapter has a chance to deallocate the buffer
	    * attached to it. The adapter will unlock it in the callback function
	    * that handles confirmation of transmits
	    */
	   XBufDescriptor_Initialize(cur_p);
	   XBufDescriptor_Lock(cur_p);
	   frame_ptr = (Xuint8*) q->payload;
	   tot_len -= q->len;
	   
	   if (prev_p) {
	     XBufDescriptor_SetNextPtr(prev_p, cur_p);
	   }
	   
	   if (p == q) // First Buffer of the packet
	     { 
	       XBufDescriptor_SetId(cur_p, p);
	       /*
		* set initial value if the CHECKSUM_HARDWARE is set
		* the default for the TX is to not use the checksum offload
		* functionality except in one specific, zero-copy case
		*/
	       
	       if ( (XEmac_mIsTxHwCsum(EmacPtr) && 
		     (ethernet_header->type == ETHTYPE_IP && 
		      ((IPH_PROTO(&(ethernet_ip_header->ip)) == IP_PROTO_UDP) || 
		       (IPH_PROTO(&(ethernet_ip_header->ip)) == IP_PROTO_TCP)))) ) 
		 {
		   
		   XEmac_mEnableTxHwCsum(EmacPtr);
		   
		   /*
		    * Determine the length of the IP header which is used
		    * for the offset into the data for the protocol field.
		    */
		   IpHeaderLength = (IPH_HL(&(ethernet_ip_header->ip)) * 4);
		   
		   /* Grab protocol */
		   ProtoTTL = IPH_PROTO(&(ethernet_ip_header->ip));
		   
		   /*
		    * Determine the proper offset for the insert
		    * TCP offset is 16, UDP offset is 6
		    */
		   if ((ProtoTTL & 0x00FF) == 6) {
		     csum_insert_offset = IpHeaderLength + 16 + XEM_HDR_SIZE;
		   }
		   else {
		     csum_insert_offset = IpHeaderLength + 6 + XEM_HDR_SIZE;
		   }
		   
		   /*
		    * 0 works for the TCP TX checksum offload initial value
		    */
		   IpDataLen = (IPH_LEN(&(ethernet_ip_header->ip))) - IpHeaderLength;
		   PhCSum = AddCsumTxPseudoHeader(q, 0,IpDataLen, ProtoTTL);

		   XBufDescriptor_SetCSInit(cur_p, PhCSum);
		   XBufDescriptor_SetCSInsertLoc(cur_p, csum_insert_offset);
		   XBufDescriptor_SetCSBegin(cur_p, IpHeaderLength + XEM_HDR_SIZE);
		 }
	       XBufDescriptor_SetLength(cur_p, q->len);	   
	       XBufDescriptor_SetSrcAddress(cur_p, frame_ptr);
	     }
	   else /* Not First buffer of the packet */
	     {
	       XBufDescriptor_SetSrcAddress(cur_p, frame_ptr);
	       XBufDescriptor_SetLength(cur_p, q->len);
	       
	       if (XEmac_mIsTxHwCsum(EmacPtr)) {
		 XBufDescriptor_SetCSInit(cur_p, 0);
		 XBufDescriptor_SetCSInsertLoc(cur_p, csum_insert_offset);
		 XBufDescriptor_SetCSBegin(cur_p, IpHeaderLength + XEM_HDR_SIZE);
	       }
	     }
	   
	   if (tot_len == 0)
	     {
	       /*
		* This is the last descriptor in the chain
		*/
	       
	       XBufDescriptor_SetLast(cur_p);
	     }
	   prev_p = cur_p;
	   cur_p++;
	 }
       
       for(i = 0, q = p; q != NULL; q = q->next, i++) 
	 {
	   Result = XEmac_SgSend(xemacif_ptr->instance_ptr, &bd[i], XEM_SGDMA_NODELAY);
	   
	   if (Result != XST_SUCCESS) {
	     snd_pkt_dropped++;
	     return ERR_MEM;
	   } 
	 }
     }						
#else /* XEMAC_V1_04_A_VER */
   {
     q = p;   
     if (tot_links) 
       {
	 frame_ptr = (Xuint8*)NextSendBuffer;
	 tot_len = 0;
	 NextSendBuffer += XEM_MAX_FRAME_SIZE_IN_WORDS;
	 if (NextSendBuffer > (SendBufferMem + BUFFER_MEM_SIZE))
	   NextSendBuffer = SendBufferMem;
	 do {
	   memcpy((Xuint8*)frame_ptr+tot_len,q->payload, q->len);
	   tot_len += q->len;
	   q = q->next;
	 } while (q != NULL);
       } 
     else 
       {
	 frame_ptr = (Xuint8*) q->payload;

	 if ((Xuint32)frame_ptr & 7)
	   {
	     memcpy((Xuint8*)NextSendBuffer,q->payload, q->len);
	     frame_ptr = (Xuint8*)NextSendBuffer;
	     /*
	      * Adjust the next send buffer pointer, wrap to the beginning of the
	      * send memory if necessary. Be sure the next buffer is word-aligned.
	      */
	     NextSendBuffer += XEM_MAX_FRAME_SIZE_IN_WORDS;
	     if (NextSendBuffer > (SendBufferMem + BUFFER_MEM_SIZE))
	       NextSendBuffer = SendBufferMem;
	   }
	 tot_len = q->len;
       }
#ifdef __PPC__
     unsigned int dccr = mfspr(XREG_SPR_DCCR);
     if (dccr != 0) {
       flush_dcache_range(frame_ptr, tot_len);
     }   
#endif
     XBufDescriptor_Initialize(&bd[0]);
     XBufDescriptor_Lock(&bd[0]);
     XBufDescriptor_SetSrcAddress(&bd[0], frame_ptr);
     XBufDescriptor_SetLength(&bd[0], tot_len);
     XBufDescriptor_SetLast(&bd[0]);
     
     Result = XEmac_SgSend(xemacif_ptr->instance_ptr, &bd[0], XEM_SGDMA_NODELAY);
     
     if (Result != XST_SUCCESS) {
	LWIP_DEBUGF(NETIF_DEBUG, ("Error in SgSend. Result : %d \r\n", Result));
       snd_pkt_dropped++;
       return ERR_MEM;
     } 
   }
#endif
   return ERR_OK;
}

/*---------------------------------------------------------------------------*/
/* low_level_input                                                         */
/*                                                                           */
/* Allocates a pbuf pool and transfers bytes of                              */
/* incoming packet from the interface into the pbuf.                         */
/*---------------------------------------------------------------------------*/
static void low_level_input(void *CallBackRef, XBufDescriptor *BdPtr,
			    Xuint32 NumBds)
{
  struct netif * netif_ptr = (struct netif *) CallBackRef;
  XEmacIf_Config * xemacif_ptr = netif_ptr->state;
  XEmac *EmacPtr = (XEmac *) xemacif_ptr->instance_ptr;
  Xuint8 *FramePtr;
  XStatus Status;
  int ActualLen;
  Xuint16 HwCSum, PhCSum;
  Xuint16 IpDataLen, IpHeaderLength, ProtoTTL;
  Xuint32 CalcCSum;
  Xuint32 EmacFCS;
  Xuint8 *EmacFCSPtr = (Xuint8*)&EmacFCS;
  XBufDescriptor *curbd;

  struct pbuf *p = NULL, *q = NULL;
  struct eth_hdr * ethernet_header;
  struct ethip_hdr * ethernet_ip_header;
  //struct ip_hdr *iphdr;

  while (NumBds != 0) 
    {
      if (recv_pkt_buf[rcv_pos_insert].buf_full) {
	rcv_pkt_dropped++;
	return;
      }

      NumBds--;
      /* Get ptr to pbuf and the total length */
      ActualLen = XBufDescriptor_GetLength(BdPtr);
      FramePtr = (Xuint8*)XBufDescriptor_GetDestAddress(BdPtr);
      p = (struct pbuf*)XBufDescriptor_GetId(BdPtr);

#if XEMAC_V1_04_A_VER
      /*
       * Retrieve hardware Checksum regardless, check later if
       * valid to use
       */
      if (XEmac_mIsRxHwCsum(EmacPtr)) 
	HwCSum = XBufDescriptor_GetCSRaw(BdPtr);
#endif 

#ifdef __MICROBLAZE__
      /* Flush the cache for packet data*/
      unsigned int dce = mfmsr() & MB_DCE_MASK;
      if (dce != 0) {
	flush_dcache_range(FramePtr,ActualLen);
      }
#else /* PPC */ 
      unsigned int dccr = mfspr(XREG_SPR_DCCR);
      if (dccr != 0) {
	/* Invalidate the cache for packet data*/
	invalidate_dcache_range(FramePtr,ActualLen);
      }
#endif     
      /* set the length of the pbuf */
      p->tot_len = ActualLen;
      p->len = ActualLen;
      
      /* Flush the cache for packet data*/
      flush_dcache_range(FramePtr,ActualLen);
#if 0
      {
	int i;
	unsigned char* frame_ptr = FramePtr ;
	xil_printf("FrameLen:: %d \r\n", ActualLen);
	for (i = 0; i < ActualLen; i++) {
	  xil_printf("%x ", frame_ptr[i]);
	  if ( !((i+1) % 16))
	    print("\r\n");      
	}
      }
#endif

#if XEMAC_V1_04_A_VER

      ethernet_header = p->payload;
      ethernet_ip_header = p->payload;

      if (XEmac_mIsRxHwCsum(EmacPtr)) {
	//print("RxHwCsum is Set \r\n");
	/*
	 * Check if Checksum offload in in the hardware, if so
	 * verify the checksum here and then sent up the stack
	 */

	if ((ActualLen > 76) && 
	    (ethernet_header->type == ETHTYPE_IP && 
	     ((IPH_PROTO(&(ethernet_ip_header->ip)) == IP_PROTO_UDP) || 
	      (IPH_PROTO(&(ethernet_ip_header->ip)) == IP_PROTO_TCP)))
	    && (XEmac_mIsRxHwCsum(EmacPtr))) {
	  
	  EmacFCS = 0;
	  EmacFCSPtr = (Xuint8*)&EmacFCS;
	  
	  IpHeaderLength = (IPH_HL(&(ethernet_ip_header->ip))) * 4;
	  
	  /* Grab protocol */
	  ProtoTTL = IPH_PROTO(&(ethernet_ip_header->ip));
	  
	  /*
	   * Set the length of the IP payload for the CS calculation
	   */
	  IpDataLen = ActualLen - IpHeaderLength - XEM_HDR_SIZE;
	  
	  //xil_printf("Rx IpDataLen : %d \r\n", IpDataLen);
	  
	  /*
	   * Adjust the hardware checksum due to the fact that it ALWAYS includes
	   * the FCS field in the RX data, regardless of whether the.
	   * XEM_STRIP_PAD_FCS_OPTION is set or not set around 2400.
	   */
	  CalcCSum = HwCSum;
	  //	  xil_printf("HwCSum is 0x%x \r\n", HwCSum);

	  if (((IpDataLen & 0x0003) == 2) || ((IpDataLen & 0x0003) == 0)) {
	    /*
	     * 16-bit alignment case
	     */
	    /*EmacFCSPtr[0] = (*(Xuint8*)(p->payload + ActualLen - 4 ));
	      EmacFCSPtr[1] = (*(Xuint8*)(p->payload + ActualLen - 3 ));
	      EmacFCSPtr[2] = (*(Xuint8*)(p->payload + ActualLen - 2 ));
	      EmacFCSPtr[3] = (*(Xuint8*)(p->payload + ActualLen - 1 ));
	    */
	    EmacFCSPtr[0] = (((Xuint8*)p->payload)[ActualLen - 4]); 
	    EmacFCSPtr[1] = (((Xuint8*)p->payload)[ActualLen - 3]); 
	    EmacFCSPtr[2] = (((Xuint8*)p->payload)[ActualLen - 2]); 
	    EmacFCSPtr[3] = (((Xuint8*)p->payload)[ActualLen - 1]); 
	  }
	  else if ((IpDataLen & 0x0003) == 1) {
	    /*
	     * 8-bit alignment case one
	     */
	    /*EmacFCSPtr[0] = (*(Xuint8*)(p->payload + ActualLen - 3 ));
	      EmacFCSPtr[1] = (*(Xuint8*)(p->payload + ActualLen - 2 ));
	      EmacFCSPtr[2] = (*(Xuint8*)(p->payload + ActualLen - 1 ));
	      EmacFCSPtr[3] = (*(Xuint8*)(p->payload + ActualLen - 4 ));
	    */
	    EmacFCSPtr[0] = (((Xuint8*)p->payload)[ActualLen - 3]); 
	    EmacFCSPtr[1] = (((Xuint8*)p->payload)[ActualLen - 2]); 
	    EmacFCSPtr[2] = (((Xuint8*)p->payload)[ActualLen - 1]); 
	    EmacFCSPtr[3] = (((Xuint8*)p->payload)[ActualLen - 4]); 
	  }
	  else if ((IpDataLen & 0x0003) == 3) {
	    /*
	     * 8-bit alignment case two
	     */
	    /*EmacFCSPtr[0] = (*(Xuint8*)(p->payload + ActualLen - 1 ));
	    EmacFCSPtr[1] = (*(Xuint8*)(p->payload + ActualLen - 4 ));
	    EmacFCSPtr[2] = (*(Xuint8*)(p->payload + ActualLen - 3 ));
	    EmacFCSPtr[3] = (*(Xuint8*)(p->payload + ActualLen - 2 ));
	    */
	    EmacFCSPtr[0] = (((Xuint8*)p->payload)[ActualLen - 1]); 
	    EmacFCSPtr[1] = (((Xuint8*)p->payload)[ActualLen - 4]); 
	    EmacFCSPtr[2] = (((Xuint8*)p->payload)[ActualLen - 3]); 
	    EmacFCSPtr[3] = (((Xuint8*)p->payload)[ActualLen - 2]); 
	  }

	  //CalcCSum += (Xuint32) ((*(Xuint16*)(&(EmacFCSPtr[0]))) ^ 0xFFFF);
	  CalcCSum += (Xuint32) ((((Xuint16)((EmacFCSPtr[0] << 8))) | (EmacFCSPtr[1])) ^ 0xFFFF);
	  //CalcCSum += (Xuint32) ((*(Xuint16*)(&(EmacFCSPtr[2]))) ^ 0xFFFF);
	  CalcCSum += (Xuint32) ((((Xuint16)((EmacFCSPtr[2] << 8))) | (EmacFCSPtr[3])) ^ 0xFFFF);

	  CalcCSum += (Xuint32) (0xFFFB); /* this is the subtraction of 4, trust me */
	  HwCSum = ((CalcCSum >> 16) + (CalcCSum & 0x0000FFFF));

	  PhCSum = AddCsumRxPseudoHeader(p, HwCSum, IpDataLen, ProtoTTL);
	  
	  /*
	   * The resulting checksum should be equal to 0xFFFF. If not, the upper
	   * layers can calculate where the error is and retransmit if needed.
	   */

	  /*	  if (PhCSum == 0xFFFF) {
	    //print("Rx checksum right \r\n");
	    } else {
	    xil_printf("PhCSum: 0x%x \r\n", PhCSum);
	    xil_printf("FCS: %x %x %x %x \r\n", EmacFCSPtr[0], EmacFCSPtr[1], EmacFCSPtr[2], EmacFCSPtr[3]);
	    xil_printf("ActualLen: %d IpDataLen: %d \r\n", ActualLen, IpDataLen);
	    // discard packet right here..
	    }
	  */
	}
      }
#endif /* XEMAC_DRIVER_VER == 1.01.a */

      q = recv_pkt_buf[rcv_pos_insert].buf;
      FramePtr = (Xuint8*)q->payload;
      
      if ((!FramePtr) || ((((unsigned long )FramePtr % RECV_ALIGN)) != 0)){
	LWIP_DEBUGF(NETIF_DEBUG, ("[low_level_input]: FramePtr Not aligned error \r\n"));
	return;
      }
      recv_pkt_buf[rcv_pos_insert].buf = p;
      recv_pkt_buf[rcv_pos_insert].buf_full = 1;
      rcv_pos_insert = (rcv_pos_insert + 1) % NUM_DESCRIPTORS;
      
      curbd = BdPtr;
      BdPtr = (XBufDescriptor *)XBufDescriptor_GetNextPtr(BdPtr);

      /* Allocate a new buffer and attach to the BD */
      /*
       * Reset the length, id, then unlock the descriptor for re-use. Note
       * that in this example we have not replaced the buffer attached
       * to the descriptor. Usually, you would want to attach a new buffer
       * to the descriptor and pass the buffer just filled to the upper
       * layer.
       */
      XBufDescriptor_SetDestAddress(curbd, FramePtr);
      XBufDescriptor_SetLength(curbd, q->len);
      XBufDescriptor_SetId(curbd, q);
      XBufDescriptor_Unlock(curbd);
      
      /*
       * Give the descriptor back to the driver.
       */
      Status = XEmac_SgRecv(EmacPtr, curbd);
      if (Status != XST_SUCCESS)
        {
	  LWIP_DEBUGF(NETIF_DEBUG, ("[low_level_input]SgRecv Error \r\n"));
	  return;
        }
      
#ifdef LINK_STATS
      lwip_stats.link.recv++;
#endif /* LINK_STATS */      
      
    }
  return;
}

/*---------------------------------------------------------------------------*/
/* xemacif_output():                                                         */
/*                                                                           */
/* This function is called by the TCP/IP stack when an IP packet             */
/* should be sent. It calls the function called low_level_output() to        */
/* do the actuall transmission of the packet.                                */
/*---------------------------------------------------------------------------*/
static err_t xemacif_output(struct netif *netif_ptr,
                            struct pbuf *p,
                            struct ip_addr *ipaddr)
{
   XEmacIf_Config *xemacif_ptr = xemacif_ptr = netif_ptr->state;
   
   p = etharp_output(netif_ptr, ipaddr, p);
   
   if (p != NULL) {
    return low_level_output(netif_ptr, p);
   }

   return ERR_OK;

}

/*---------------------------------------------------------------------------*/
/* xemacif_input():                                                          */
/*                                                                           */
/* This function should be called when a packet is ready to be read          */
/* from the interface. It uses the function low_level_input() that           */
/* should handle the actual reception of bytes from the network              */
/* interface.                                                                */
/*---------------------------------------------------------------------------*/
void xemacif_input(void *CallBackRef)   
{
   struct netif * netif_ptr = (struct netif *) CallBackRef;
   XEmacIf_Config * xemacif_ptr;
   struct eth_hdr * ethernet_header;
   struct pbuf *p = NULL;
   struct pbuf *q = NULL;
   Xuint8* FramePtr;

   xemacif_ptr = netif_ptr->state;
   
#ifdef __MICROBLAZE_INTERRUPT__	
   SYS_ARCH_PROTECT( __MICROBLAZE_INTERRUPT__);
#elif __PPC_INTERRUPT__
   SYS_ARCH_PROTECT(__PPC_INTERRUPT__);
#endif

   if (recv_pkt_buf[rcv_pos_remove].buf_full)
     p = recv_pkt_buf[rcv_pos_remove].buf;

#ifdef __MICROBLAZE_INTERRUPT__	
   SYS_ARCH_UNPROTECT( __MICROBLAZE_INTERRUPT__);
#elif __PPC_INTERRUPT__
   SYS_ARCH_UNPROTECT(__PPC_INTERRUPT__);
#endif


   if (p != NULL) {

     //print("[xemacif_input] \r\n");

     ethernet_header = p->payload;

     q = NULL;
      switch (htons(ethernet_header->type)) {
      case ETHTYPE_IP:
	/* update ARP table */
	etharp_ip_input(netif_ptr, p);
	/* skip Ethernet header */
	pbuf_header(p, -14);
	/* pass to network layer */
	netif_ptr->input(p, netif_ptr);
	break;
      case ETHTYPE_ARP:
	//print("ARP packet \r\n");
	etharp_arp_input(netif_ptr, &(xemacif_ptr->ethaddr), p);
	break;
      default:
	pbuf_free(p);
	break;
      }
      
      /*
      if (q != NULL) {
	low_level_output(netif_ptr, q);
	pbuf_free(q);
      }
      */

#ifdef __MICROBLAZE_INTERRUPT__	
   SYS_ARCH_PROTECT( __MICROBLAZE_INTERRUPT__);
#elif __PPC_INTERRUPT__
   SYS_ARCH_PROTECT(__PPC_INTERRUPT__);
#endif

   recv_pkt_buf[rcv_pos_remove].buf = pbuf_alloc(PBUF_RAW, XEM_MAX_FRAME_SIZE - 4, PBUF_POOL);
   recv_pkt_buf[rcv_pos_remove].buf_full = 0;
   rcv_pos_remove = (rcv_pos_remove + 1) % NUM_DESCRIPTORS;

   FramePtr = (Xuint8*) recv_pkt_buf[rcv_pos_remove].buf->payload;
   if (((Xuint32)FramePtr % RECV_ALIGN) != 0){
     LWIP_DEBUGF(NETIF_DEBUG, ("[recv_replace]pbuf_payload alignment error %x\r\n", FramePtr));
   }

#ifdef __MICROBLAZE_INTERRUPT__	
   SYS_ARCH_UNPROTECT( __MICROBLAZE_INTERRUPT__);
#elif __PPC_INTERRUPT__
   SYS_ARCH_UNPROTECT(__PPC_INTERRUPT__);
#endif
   
   }
}

/*---------------------------------------------------------------------------*/
/* xemacif_setmac():                                                         */
/*                                                                           */
/* Sets the MAC address of the system.                                       */
/* Note:  Should only be called before xemacif_init is called.               */
/*          - the stack calls xemacif_init after the user calls netif_add    */
/*---------------------------------------------------------------------------*/
void xemacif_setmac(u32_t index, u8_t *addr)
{
   XEmacIf_ConfigTable[index].ethaddr.addr[0] = addr[0];
   XEmacIf_ConfigTable[index].ethaddr.addr[1] = addr[1];
   XEmacIf_ConfigTable[index].ethaddr.addr[2] = addr[2];
   XEmacIf_ConfigTable[index].ethaddr.addr[3] = addr[3];
   XEmacIf_ConfigTable[index].ethaddr.addr[4] = addr[4];
   XEmacIf_ConfigTable[index].ethaddr.addr[5] = addr[5];
}

/*---------------------------------------------------------------------------*/
/* xemacif_getmac():                                                         */
/*                                                                           */
/* Returns a pointer to the ethaddr variable in  the ConfigTable             */
/* (6 bytes in length)                                                       */
/*---------------------------------------------------------------------------*/
u8_t * xemacif_getmac(u32_t index) {
   return &(XEmacIf_ConfigTable[index].ethaddr.addr[0]);
}

/*---------------------------------------------------------------------------*/
/* xemacif_init():                                                           */
/*                                                                           */
/* Should be called at the beginning of the program to set up the            */
/* network interface. It calls the function low_level_init() to do the       */
/* actual setup of the hardware.                                             */
/*---------------------------------------------------------------------------*/
err_t xemacif_init(struct netif *netif_ptr)
{
   XEmacIf_Config *xemacif_ptr;

   xemacif_ptr = (XEmacIf_Config *) netif_ptr->state;

   netif_ptr->mtu = 1500;
   netif_ptr->hwaddr_len = 6;
   netif_ptr->hwaddr[0] = xemacif_ptr->ethaddr.addr[0];
   netif_ptr->hwaddr[1] = xemacif_ptr->ethaddr.addr[1];
   netif_ptr->hwaddr[2] = xemacif_ptr->ethaddr.addr[2];
   netif_ptr->hwaddr[3] = xemacif_ptr->ethaddr.addr[3];
   netif_ptr->hwaddr[4] = xemacif_ptr->ethaddr.addr[4];
   netif_ptr->hwaddr[5] = xemacif_ptr->ethaddr.addr[5];
   netif_ptr->name[0] = IFNAME0;
   netif_ptr->name[1] = IFNAME1;
   netif_ptr->output = xemacif_output;
   netif_ptr->linkoutput = low_level_output;

   low_level_init(netif_ptr);
   etharp_init();

   return ERR_OK;
}


/******************************************************************************
 *
 * FUNCTION:
 *
 * xemacif_send_handler 
 *
 * DESCRIPTION:
 *
 * Callback function (called from driver) to handle confirmation of transmit
 * events when in direct memory-mapped I/O mode.
 *
 * ARGUMENTS:
 *
 * CallBackRef is the callback reference passed from the driver, which in our
 * case is a pointer the netif instance
 *
 * RETURN VALUE:
 *
 * None.
 *
 ******************************************************************************/
static void xemacif_send_handler(void *CallBackRef, XBufDescriptor *BdPtr,
				 Xuint32 NumBds)
{
   struct netif * netif_ptr = (struct netif *) CallBackRef;
   XEmacIf_Config * xemacif_ptr = (XEmacIf_Config *) netif_ptr->state;
   XEmac *EmacPtr = xemacif_ptr->instance_ptr;
   XEmac_Stats Stats;

   XBufDescriptor *curbd;
/*
    * Check stats for transmission errors (overrun or underrun errors are
    * caught by the asynchronous error handler).
    */
   XEmac_GetStats(EmacPtr, &Stats);
   
   if (Stats.XmitLateCollisionErrors || Stats.XmitExcessDeferral ||
       Stats.XmitOverrunErrors || Stats.XmitUnderrunErrors )
     {   
       snd_pkt_dropped++;
     }


   
   while (NumBds != 0) 
     {
       NumBds--;
       
       curbd = BdPtr;
       /*
	* Unlock the descriptor for reuse in the transmit ring
	*/
       BdPtr = (XBufDescriptor *)XBufDescriptor_GetNextPtr(BdPtr);
       XBufDescriptor_Unlock(curbd);
     }

#ifdef LINK_STATS
    lwip_stats.link.xmit++;
#endif /* LINK_STATS */
    

}

/******************************************************************************
*
* FUNCTION:
*
* xemacif_error_handler
*
* DESCRIPTION:
*
* Callback function (called from driver) to handle asynchronous errors. These
* errors are usually bad and require a reset of the device.  Here is an
* example of how to recover (albeit data will be lost during the reset)
*
* ARGUMENTS:
*
* CallBackRef is the callback reference passed from the driver, which in our
* case is a pointer the netif instance.
*
* RETURN VALUE:
*
* None.
*
* NOTES:
*
* None.
*
******************************************************************************/
static void xemacif_error_handler(void *CallBackRef, XStatus Code)
{
   struct netif * netif_ptr = (struct netif *) CallBackRef;
   XEmacIf_Config * xemacif_ptr = (XEmacIf_Config *) netif_ptr->state;

   XEmac *EmacPtr = xemacif_ptr->instance_ptr;
    
    /*
     * Most if not all asynchronous errors returned by the XEmac driver are
     * serious.  The usual remedy is to reset the device.  The user will need
     * to re-configure the driver/device after the reset, so if you don't know
     * how it is configured, be sure to retrieve its options and configuration
     * (e.g., using the XEmac_Get... functions) before the reset.
     */
   if (Code == XST_RESET_ERROR)
     {
       LWIP_DEBUGF(NETIF_DEBUG, ("XEmac Reset Error \r\n"));
      XEmac_Reset(xemacif_ptr->instance_ptr);
      XEmac_SetMacAddress(EmacPtr, (Xuint8*) xemacif_ptr->ethaddr.addr);
      XEmac_SetOptions(EmacPtr, DEFAULT_OPTIONS);
      (void)XEmac_SetPktThreshold(EmacPtr, XEM_RECV, 1);
      XEmac_Start(EmacPtr);
   }
}

static void flush_dcache_range(Xuint8* data_p,Xuint32 len)
{

#ifdef __PPC__
  char *end_ptr = data_p + len;
  char *ptr = (char *)((unsigned long)(data_p) & (unsigned long)~31 );
  while(ptr<end_ptr){
    XCache_FlushDCacheLine((unsigned int)(ptr));  
    ptr += 32;
  }
#elif __MICROBLAZE__
  /*  int x;
      for (x=0; x < len; x = x+16) {
      microblaze_update_dcache((int)(data_p), 0, 0);
      data_p += 16;
      }
  */
  // Using the microblaze_init_dcache function call 
  microblaze_init_dcache_range((int)(data_p), len);  
#endif

}

static void invalidate_dcache_range(Xuint8* data_p,Xuint32 len)
{
  char *end_ptr = data_p + len;
  char *ptr = (char *)((unsigned long)(data_p) & (unsigned long)~31 );
  while(ptr<end_ptr){
    XCache_InvalidateDCacheLine((unsigned int)(ptr));  
    ptr += 32;
  }
}

/******************************************************************************
 *
 * FUNCTION:
 *
 * AddCsumRxPseudoHeader
 *
 * DESCRIPTION:
 *
 * Calculate the Pseudo header checksum of the provided IP packet
 *
 * ARGUMENTS:
 *
 * skb is the buffer containing the received packet. The entire packet is
 * within this skb.
 *
 * Initial Checksum - Checksum to start with, InitCSum
 *
 * Length of the Data, IpPayloadLen
 *
 * ProtoTTL is the data from the IP header containing the Time To Live (TTL)
 *          and the protocol type, 6 = TCP and 16 = UDP
 *
 *
 * RETURN VALUE:
 *
 * Completed checksum or 0 if not an IP/TCP or IP/UDP packet
 *
 ******************************************************************************/
inline static Xuint16 AddCsumRxPseudoHeader(struct pbuf *p, Xuint16 InitCSum,
                                        Xuint16 IpPayloadLen, Xuint16 ProtoTTL)
{
  register Xuint32 Csum;
  int i;

  Csum = InitCSum;

  /*
   * Add in the pseudoheader source address and destination address info
   */

  for (i = RX_PSEUDO_HEADER_DATA_START;
       i <= RX_PSEUDO_HEADER_DATA_END;
       i = i + 2)
  {
    //Csum += (Xuint32)(*(Xuint16*)(p->payload + i));
    Csum += (Xuint32)(((Xuint16)((((Xuint8*)p->payload)[i]) << 8)) | (((Xuint8*)p->payload)[i+1]));
  }

  Csum += (Xuint32)(ProtoTTL & 0x00FF);

  /* Add in the length of the TCP/UDP data payload */
  Csum += (Xuint32)(IpPayloadLen);

  /* Handle the carries */
  Csum += (( Csum & 0xFFFF0000) >> 16);


  return (Csum);

}

/******************************************************************************
 *
 * FUNCTION:
 *
 * AddCsumTxPseudoHeader
 *
 * DESCRIPTION:
 *
 * Calculate the Pseudo header checksum of the provided TX IP packet
 * The offsets are different for the CHECKSUM == HW on the TCP_SENDFILE
 * zerocopy path through the stack, hence the different pseudoheader
 * checksum calculation.
 *
 * ARGUMENTS:
 *
 * skb is the buffer containing the received packet. The entire packet is
 * within this skb.
 *
 * Initial Checksum - Checksum to start with, InitCSum
 *
 * Length of the Data, IpPayloadLen
 *
 * ProtoTTL is the data from the IP header containing the Time To Live (TTL)
 *          and the protocol type, 6 = TCP and 16 = UDP
 *
 * RETURN VALUE:
 *
 * Completed checksum or 0 if not an IP/TCP or IP/UDP packet
 *
 ******************************************************************************/
inline static Xuint16 AddCsumTxPseudoHeader(struct pbuf *p, Xuint16 InitCSum,
                                        Xuint16 IpPayloadLen, Xuint16 ProtoTTL)
{
  register Xuint32 Csum;
  int i;

  Csum = InitCSum;

  /*
   * Add in the pseudoheader source address and destination address info
   */

  for (i = TX_PSEUDO_HEADER_DATA_START;
       i <= TX_PSEUDO_HEADER_DATA_END;
       i = i + 2)
  {
    //Csum += (Xuint32)(*(Xuint16*)(p->payload + i));
    Csum += (Xuint32)(((Xuint16)((((Xuint8*)p->payload)[i]) << 8)) | (((Xuint8*)p->payload)[i+1]));
  }

  Csum += (Xuint32)(ProtoTTL & 0x00FF);

  /* Add in the length of the TCP/UDP data payload */
  Csum += (Xuint32)(IpPayloadLen);

  /* Handle the carries */
  Csum += (( Csum & 0xFFFF0000) >> 16);

  return (Csum);

}

void eth_dma_intr( void )
{
    XEmacIf_Config *xemacif_ptr = netif_default->state;
    //XEmac_IntrHandlerFifo( xemacif_ptr->instance_ptr );
    XEmac_IntrHandlerDma( xemacif_ptr->instance_ptr );
}

void eth_dma_recv( void* data )
{
    xemacif_input( netif_default );
}

void eth_dma_send( void *data )
{
}
