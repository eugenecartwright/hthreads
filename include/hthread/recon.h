
#ifndef RECON_H_ /* prevent circular inclusions */
#define RECON_H_ /* by using protection macros */

#include <xparameters.h>  
#include <xil_io.h>
#include <xstatus.h>
#include "xhwicap_i.h"
#include "xhwicap.h"
#include "xhwicap_parse.h"
#include "xsysace_l.h"
#include "xsysace.h"
#include "sysace_stdio.h" 
#include "xuartlite_l.h"
#include "bitstream.h"
#include <dma/dma.h>

#include <stdio.h>
#include <string.h>

#define HEADER_LENGTH 103
//==============================================================================
//ICAP And CF functions
//==============================================================================   


static   XHwIcap  HwIcap;	      /* The instance of the HWICAP device */
 



int XHwIcap_DeviceWriteDMA(XHwIcap *InstancePtr, u32 *FrameBuffer, u32 NumWords)
{

	u32 WrFifoVacancy;
	u32 IntrStatus;

	Xil_AssertNonvoid(InstancePtr != NULL);
	Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);
	Xil_AssertNonvoid(FrameBuffer != NULL);
	Xil_AssertNonvoid(NumWords > 0);

	/*
	 * Make sure that the last Read/Write by the driver is complete.
	 */
	if (XHwIcap_IsTransferDone(InstancePtr) == FALSE) {
		return XST_FAILURE;
	}

	/*
	 * Check if the ICAP device is Busy with the last Read/Write
	 */
	if (XHwIcap_IsDeviceBusy(InstancePtr) == TRUE) {
		return XST_FAILURE;
	}

	/*
	 * Set the flag, which will be cleared when the transfer
	 * is entirely done from the FIFO to the ICAP.
	 */
	InstancePtr->IsTransferInProgress = TRUE;


	/*
	 * Disable the Global Interrupt.
	 */
	XHwIcap_IntrGlobalDisable(InstancePtr);


	/*
	 * Set up the buffer pointer and the words to be transferred.
	 */
	InstancePtr->SendBufferPtr = FrameBuffer;
	InstancePtr->RequestedWords = NumWords;
	InstancePtr->RemainingWords = NumWords;


                 dma_config_t    dma_config;
                 dma_t           dma;           
                dma_config.base=DMA_BASEADDR;                
                dma_create(&dma,&dma_config); 
#if 0

	(InstancePtr->IsPolled = TRUE) ; /* Interrupt Mode */
	
	//enabling  half fifo full intr
	XHwIcap_IntrEnable(InstancePtr, XHI_IPIXR_WRP_MASK) ;
	//Clear the interrupt status of the earlier interrupts
	IntrStatus  = XHwIcap_IntrGetStatus(InstancePtr);	
	XHwIcap_IntrClear(InstancePtr, IntrStatus);	
	
	
	volatile int * icap_half;
	icap_half=0x000001f0;;
	(*icap_half)=0;
	int first=1;
	#define N 996
	while (InstancePtr->RemainingWords > 0)	{

		if ( InstancePtr->RemainingWords >= N	) {            
			dma_transfer(&dma, InstancePtr->SendBufferPtr, (InstancePtr)->HwIcapConfig.BaseAddress+XHI_WF_OFFSET, N*4,
			DMA_SIZE_WORD, Htrue,Hfalse);
			InstancePtr->RemainingWords-=N;	InstancePtr->SendBufferPtr+=N;
		}
		else {
			dma_transfer(&dma, InstancePtr->SendBufferPtr, (InstancePtr)->HwIcapConfig.BaseAddress+XHI_WF_OFFSET, 
			InstancePtr->RemainingWords*4, DMA_SIZE_WORD, Htrue,Hfalse);
			InstancePtr->RemainingWords=0;	InstancePtr->SendBufferPtr+=InstancePtr->RemainingWords;
		}
		//if (first==1) { first=0;
		XHwIcap_StartConfig(InstancePtr);
		//while(!dma_getdone(&dma));  if (dma_geterror(&dma)) {     printf("DMA ERROR\n");                return 1; }
		
		
		XHwIcap_IntrGlobalEnable(InstancePtr);
		
		while((*icap_half)==0);
		(*icap_half)=0;
		IntrStatus  = XHwIcap_IntrGetStatus(InstancePtr);	
		XHwIcap_IntrClear(InstancePtr, IntrStatus);	
	}	
	while ((XHwIcap_ReadReg(
					InstancePtr->HwIcapConfig.BaseAddress,
					XHI_CR_OFFSET)) & XHI_CR_WRITE_MASK);	
		
		


/*
         u32 num;	   
 	while (InstancePtr->RemainingWords > 0) {                
		WrFifoVacancy = XHwIcap_GetWrFifoVacancy(InstancePtr);
		//printf( " fifo vacancyis %i .\r\n",WrFifoVacancy); 
		if ( WrFifoVacancy < InstancePtr->RemainingWords ) num=WrFifoVacancy; else num=InstancePtr->RemainingWords;
                dma_transfer(&dma, InstancePtr->SendBufferPtr, (InstancePtr)->HwIcapConfig.BaseAddress+XHI_WF_OFFSET,num*4, DMA_SIZE_WORD, Htrue,Hfalse);
                XHwIcap_StartConfig(InstancePtr);
		while(!dma_getdone(&dma));
		if (dma_geterror(&dma)) {     printf("DMA ERROR\n");                return 1; }
		InstancePtr->RemainingWords-=num;	InstancePtr->SendBufferPtr+=num;	}				   
		while ((XHwIcap_ReadReg(InstancePtr->HwIcapConfig.BaseAddress,	XHI_CR_OFFSET)) & XHI_CR_WRITE_MASK);
				
*/					
#else					
	int NUM;
	 NUM=  800; //this numer is critical, may go up to 1000, but not gurantee.
	
	while (InstancePtr->RemainingWords > 0) {
		//NUM = XHwIcap_GetWrFifoVacancy(InstancePtr);
		//printf( " fifo vacancyis %i .\r\n",WrFifoVacancy); 
		dma_reset(&dma);
		if ( InstancePtr->RemainingWords >= NUM	)   {            
			dma_transfer(&dma, InstancePtr->SendBufferPtr, (InstancePtr)->HwIcapConfig.BaseAddress+XHI_WF_OFFSET, NUM*4, DMA_SIZE_WORD, Htrue,Hfalse);
			InstancePtr->RemainingWords-=NUM;	InstancePtr->SendBufferPtr+=NUM;	}

		else {
			dma_transfer(&dma, InstancePtr->SendBufferPtr, (InstancePtr)->HwIcapConfig.BaseAddress+XHI_WF_OFFSET,
			InstancePtr->RemainingWords*4, DMA_SIZE_WORD, Htrue,Hfalse);
			InstancePtr->RemainingWords=0;	InstancePtr->SendBufferPtr+=1;	}	


		XHwIcap_StartConfig(InstancePtr);					

		while(!dma_getdone(&dma));
		if (dma_geterror(&dma)) {     printf("DMA ERROR\n");                return 1; }

		while ((XHwIcap_ReadReg(		InstancePtr->HwIcapConfig.BaseAddress,		XHI_CR_OFFSET)) & XHI_CR_WRITE_MASK);	
	}	

	

#endif		/*
		 * Clear the flag to indicate the write has been done
		 */
		InstancePtr->IsTransferInProgress = FALSE;
		InstancePtr->RequestedWords = 0x0;

	return XST_SUCCESS;
}

 //====================================================================================
 /** Loads a partial bitstream from DRAM into ICAP */
int XHwIcap_DRAM2Icap(XHwIcap *hwicap, const char* pr , unsigned int ublaze)
{
    
    uint BitstreamLength;
    Xuint32  *word;
    XStatus Status;
    Xuint32 * systemACE_Buffer;
    
	if (pr=="vector" && ublaze==0 ) {systemACE_Buffer = &vector0_bit;BitstreamLength=vector0_bit_len-HEADER_LENGTH;} 
	else if (pr=="crc" && ublaze==0 ){ systemACE_Buffer = &crc0_bit; BitstreamLength=crc0_bit_len-HEADER_LENGTH;} 
	else if (pr=="sort" && ublaze==0 ){ systemACE_Buffer = &sort0_bit; BitstreamLength=sort0_bit_len-HEADER_LENGTH;} 
	
	
	else if (pr=="vector" && ublaze==1 ){ systemACE_Buffer = &vector1_bit; BitstreamLength=crc0_bit_len-HEADER_LENGTH;} 
	else if (pr=="crc" && ublaze==1 ){ systemACE_Buffer = &crc1_bit; BitstreamLength=crc0_bit_len-HEADER_LENGTH;} 
	else if (pr=="sort" && ublaze==1 ){ systemACE_Buffer = &sort1_bit; BitstreamLength=crc0_bit_len-HEADER_LENGTH;} 
	
	
	else if (pr=="vector" && ublaze==2 ){ systemACE_Buffer = &vector2_bit; BitstreamLength=crc0_bit_len-HEADER_LENGTH;} 
	else if (pr=="crc" && ublaze==2 ){ systemACE_Buffer = &crc2_bit; BitstreamLength=crc0_bit_len-HEADER_LENGTH;} 
	else if (pr=="sort" && ublaze==2 ){ systemACE_Buffer = &sort2_bit; BitstreamLength=crc0_bit_len-HEADER_LENGTH;}
	
	 
	else if (pr=="vector" && ublaze==3 ){ systemACE_Buffer = &vector3_bit; BitstreamLength=crc0_bit_len-HEADER_LENGTH;} 
	else if (pr=="crc" && ublaze==3 ){ systemACE_Buffer = &crc3_bit; BitstreamLength=crc0_bit_len-HEADER_LENGTH;} 
	else if (pr=="sort" && ublaze==3 ){ systemACE_Buffer = &sort3_bit; BitstreamLength=crc0_bit_len-HEADER_LENGTH;}
	
	 
	else if (pr=="vector" && ublaze==4 ){ systemACE_Buffer = &vector4_bit; BitstreamLength=crc0_bit_len-HEADER_LENGTH;} 
	else if (pr=="crc" && ublaze==4 ){ systemACE_Buffer = &crc4_bit; BitstreamLength=crc0_bit_len-HEADER_LENGTH;} 
	else if (pr=="sort" && ublaze==4 ){ systemACE_Buffer = &sort4_bit; BitstreamLength=crc0_bit_len-HEADER_LENGTH;} 
	
	else if (pr=="vector" && ublaze==5 ){ systemACE_Buffer = &vector5_bit; BitstreamLength=crc0_bit_len-HEADER_LENGTH;} 
	else if (pr=="crc" && ublaze==5 ){ systemACE_Buffer = &crc5_bit; BitstreamLength=crc0_bit_len-HEADER_LENGTH;} 
	else if (pr=="sort" && ublaze==5 ){ systemACE_Buffer = &sort5_bit; BitstreamLength=crc0_bit_len-HEADER_LENGTH;} 
	
                            
       
   word=systemACE_Buffer + (HEADER_LENGTH+1)/4;// I manuall put a 0x00 before each bitstream to align the starting address 
    
                    
                    
                    
    
  // Status = XHwIcap_DeviceWrite(&HwIcap, word, BitstreamLength/4);
    Status = XHwIcap_DeviceWriteDMA(&HwIcap, word, BitstreamLength/4);
    
    
        if (Status != XST_SUCCESS) 
        { /* Error writing to ICAP */
	   xil_printf("error writing to ICAP (%d)\r\n", Status);
           return -1;
         }
            
	return 0;

}

//=======================================================================
/** Loads a partial bitstream from CF into ICAP */

/* Parse Bitfile header */
XHwIcap_Bit_Header XHwIcap_ReadHeader(Xuint8 *Data, Xuint32 Size) 
{
    Xuint32 I;   
    Xuint32 Len;  
    Xuint32 Tmp;  
    XHwIcap_Bit_Header Header;
    Xuint32 Index;

    /* Start Index at start of bitstream */
    Index=0;

    /* Initialize HeaderLength.  If header returned early inidicates
     * failure. 
     */
    Header.HeaderLength = XHI_BIT_HEADER_FAILURE;

    /* Get "Magic" length */
    Header.MagicLength = Data[Index++];
    Header.MagicLength = (Header.MagicLength << 8) | Data[Index++];

    /* Read in "magic" */
    for (I=0; I<Header.MagicLength-1; I++) {
        Tmp = Data[Index++];
        if (I%2==0 && Tmp != XHI_EVEN_MAGIC_BYTE) 
        {
          return Header;   /* INVALID_FILE_HEADER_ERROR */
        }
        if (I%2==1 && Tmp != XHI_ODD_MAGIC_BYTE) 
        {
            return Header;   /* INVALID_FILE_HEADER_ERROR */
        }
    }

    /* Read null end of magic data. */
    Tmp = Data[Index++];

    /* Read 0x01 (short) */
    Tmp = Data[Index++];
    Tmp = (Tmp << 8) | Data[Index++];

    /* Check the "0x01" half word */
    if (Tmp != 0x01) 
    {
       return Header;   /* INVALID_FILE_HEADER_ERROR */
    }


    /* Read 'a' */
    Tmp = Data[Index++];
    if (Tmp != 'a') 
    {
        return Header;    /* INVALID_FILE_HEADER_ERROR  */
    }

    /* Get Design Name length */
    Len = Data[Index++];
    Len = (Len << 8) | Data[Index++];

    /* allocate space for design name and final null character. */
    Header.DesignName = (Xuint8 *)malloc(Len);

    /* Read in Design Name */
    for (I=0; I<Len; I++) 
    {
        Header.DesignName[I] = Data[Index++];
    }

    /* Read 'b' */
    Tmp = Data[Index++];
    if (Tmp != 'b') 
    {
        return Header;  /* INVALID_FILE_HEADER_ERROR */
    }

    /* Get Part Name length */
    Len = Data[Index++];
    Len = (Len << 8) | Data[Index++];

    /* allocate space for part name and final null character. */
    Header.PartName = (Xuint8 *)malloc(Len);

    /* Read in part name */
    for (I=0; I<Len; I++) 
    {
        Header.PartName[I] = Data[Index++];
    }

    /* Read 'c' */
    Tmp = Data[Index++];
    if (Tmp != 'c') 
    {
        return Header;  /* INVALID_FILE_HEADER_ERROR */
    }

    /* Get date length */
    Len = Data[Index++];
    Len = (Len << 8) | Data[Index++];

    /* allocate space for date and final null character. */
    Header.Date = (Xuint8 *)malloc(Len);

    /* Read in date name */
    for (I=0; I<Len; I++) 
    {
        Header.Date[I] = Data[Index++];
    }

    /* Read 'd' */
    Tmp = Data[Index++];
    if (Tmp != 'd') 
    {
        return Header;  /* INVALID_FILE_HEADER_ERROR  */
    }

    /* Get time length */
    Len = Data[Index++];
    Len = (Len << 8) | Data[Index++];

    /* allocate space for time and final null character. */
    Header.Time = (Xuint8 *)malloc(Len);

    /* Read in time name */
    for (I=0; I<Len; I++) 
    {
        Header.Time[I] = Data[Index++];
    }

    /* Read 'e' */
    Tmp = Data[Index++];
    if (Tmp != 'e') 
    {
        return Header;  /* INVALID_FILE_HEADER_ERROR */
    }

    /* Get byte length of bitstream */
    Header.BitstreamLength = Data[Index++];
    Header.BitstreamLength = (Header.BitstreamLength << 8) | Data[Index++];
    Header.BitstreamLength = (Header.BitstreamLength << 8) | Data[Index++];
    Header.BitstreamLength = (Header.BitstreamLength << 8) | Data[Index++];

    Header.HeaderLength = Index;

    return Header;

}


int XHwIcap_CF2Icap(XHwIcap *hwicap, char* filename)
{
	 int i, numCharsRead, ace_buf_count, rc, SectorNumber;
	 SYSACE_FILE *stream;
    XHwIcap_Bit_Header bit_header;
    Xuint8 data3,data2,data1,data0;
    Xuint8 systemACE_Buffer[XSA_CF_SECTOR_SIZE];
    Xuint32 word[2];
    XStatus Status;
	 
#ifdef  ICAP_DEBUG
	 print("In CF2ICAP\r\n");
	 xil_printf("filename = %s\r\n",filename);
#endif

    /* Opening file */
    if ((stream = sysace_fopen(filename, "r")) == NULL) {
        xil_printf("Can't open file (%s)\r\n", filename);
        return -1;
    }
	 
#ifdef  ICAP_DEBUG
	 print("In CF2ICAP ..File Opened..\r\n");
#endif

    /* Read from systemAce */
	 numCharsRead = sysace_fread(systemACE_Buffer, 1, XSA_CF_SECTOR_SIZE, 
                                stream);
    if (numCharsRead <= 0) {
        xil_printf("Error reading from system ace (%d)\r\n", numCharsRead);
        return -1;
    }
	 
#ifdef  ICAP_DEBUG
	 print("In CF2ICAP ..Header Sector Read..\r\n");
#endif

    /* Read the bitstream header */
    bit_header = XHwIcap_ReadHeader(systemACE_Buffer,0);

	/* close systemAce file handle */
	rc = sysace_fclose (stream);
	if (rc < 0) {
		/* Can't close */
		xil_printf("can't close file\r\n");
		return -1;
    }
	 
#ifdef  ICAP_DEBUG
	 print("In CF2ICAP ..File Closed..\r\n");
#endif

	/* Now that we have info about the bitstream,
	 * re-open and skip the header.
	 */
	     
    if ((stream = sysace_fopen(filename, "r")) == NULL) {
        /* Can't open file */
        xil_printf("can't open file\r\n");
        return -1;
    }

#ifdef  ICAP_DEBUG
	 print("In CF2ICAP ..File Opened..\r\n");
#endif

	 /* Read the header (effectively skipping it) */
	 numCharsRead = sysace_fread(systemACE_Buffer, 1, bit_header.HeaderLength, 
                                stream);
#ifdef  ICAP_DEBUG
	 xil_printf("Number of chars read = %d, Sector Number = %d\r\n",numCharsRead,SectorNumber);
	 xil_printf(" Header length = %d; bitstream length = %d\r\n", bit_header.HeaderLength,  bit_header.BitstreamLength);
	 print("In CF2ICAP ..Skip Header..\r\n");
#endif

	 numCharsRead = sysace_fread(systemACE_Buffer, 1, XSA_CF_SECTOR_SIZE, 
                                stream);

	 SectorNumber = 1;
	 

                               	
    /* Loop through all bitstream data and write to ICAP */
    ace_buf_count = 0;
    for (i=0; i<bit_header.BitstreamLength; i+=4) 
	 {

		  /* Convert 4 chars into an integer */
        data3 = systemACE_Buffer[ace_buf_count++];
        data2 = systemACE_Buffer[ace_buf_count++];
        data1 = systemACE_Buffer[ace_buf_count++];
        data0 = systemACE_Buffer[ace_buf_count++];
        word[0] = ((data3 << 24) | (data2 << 16) | (data1 << 8) | (data0));
        i+=4;
		if(i<bit_header.BitstreamLength) // store another word if even number of words
		{
			  /* Convert 4 chars into an integer */
	        data3 = systemACE_Buffer[ace_buf_count++];
	        data2 = systemACE_Buffer[ace_buf_count++];
	        data1 = systemACE_Buffer[ace_buf_count++];
	        data0 = systemACE_Buffer[ace_buf_count++];
	        word[1] = ((data3 << 24) | (data2 << 16) | (data1 << 8) | (data0));
		}
		else
		{
			word[1] = 0x0; // store 0- this is work around for hwicap bug in 11.4
		}
	    Status = XHwIcap_DeviceWrite(&HwIcap, word, 2);
        if (Status != XST_SUCCESS) 
        {
				/* Error writing to ICAP */
			  xil_printf("error writing to ICAP (%d)\r\n", Status);
           return -1;
        }
#ifdef  ICAP_DEBUG
		//xil_printf("In CF2ICAP ..Writing Word Number %d from current sector to ICAP..\r\n",ace_buf_count);
#endif
			
		  /* Check to see if we need to read from CF again */
        if (ace_buf_count == XSA_CF_SECTOR_SIZE)
        {
#ifdef  ICAP_DEBUG
				//print("In CF2ICAP ..Reading Next Sector..\r\n");
#endif
            /* read next sector from CF */
            numCharsRead = sysace_fread(systemACE_Buffer, 1, XSA_CF_SECTOR_SIZE,
                                        stream);
            ace_buf_count = 0;
#ifdef  ICAP_DEBUG
				//xil_printf("Number of chars read = %d, sector number = %d\r\n",numCharsRead, SectorNumber);
#endif
				SectorNumber++;
        }
		}

#ifdef  ICAP_DEBUG
	print("In CF2ICAP ..All Words Written to ICAP..\r\n");
#endif
	/* close systemAce file handle */
	rc = sysace_fclose (stream);
	if (rc < 0) {
		/* Can't close */
		xil_printf("can't close file\r\n");
		return -1;
    }
	return 0;
}







#endif


