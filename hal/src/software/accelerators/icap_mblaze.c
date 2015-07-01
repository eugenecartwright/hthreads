#include <icap.h>
#include <dma/dma.h>
#include <hwti/hwti.h>
#include "pvr.h"

#ifdef ICAP
Hint perform_PR(Huint * bit_file_addr, Hint bit_file_len) {
    
    // Get VHWTI and CPUID
    Huint vhwti_base = 0;
    
    // Get VHWTI and CPU ID from PVRs 
    getpvr(1,vhwti_base);

    // Get lock for icap mutex
    hthread_mutex_t * icap_mutex = 
        (hthread_mutex_t *) _hwti_get_icap_mutex(vhwti_base);
    if (hthread_mutex_lock(icap_mutex)) 
        return FAILURE;

    //putnum(bit_file_addr);

    // Configure icap with accelerator bit file
    XHwIcap * HwIcap = (XHwIcap *) _hwti_get_icap_struct_ptr(vhwti_base);
    if (XHwIcap_DRAM2Icap(HwIcap, bit_file_addr, bit_file_len)) {
        hthread_mutex_unlock(icap_mutex);
        return FAILURE;
    }

    // Release lock
    hthread_mutex_unlock(icap_mutex);

    return SUCCESS;

}

Hint XHwIcap_DRAM2Icap(XHwIcap * HwIcap, Huint * src_bit, Huint size) {

    Huint BitstreamLength;
    u32 *word;
    XStatus Status;

    // Point to beginning of the data (skipping the header)
    word = (u32 *) src_bit + ((ICAP_HEADER_LENGTH +1) / 4);

    // Get size without header
    BitstreamLength = size-ICAP_HEADER_LENGTH;

    Status = XHwIcap_DeviceWriteDMA(HwIcap, word, BitstreamLength/4);
    //Status = XHwIcap_DeviceWrite(HwIcap, word, BitstreamLength/4);

    if (Status != XST_SUCCESS) 
        return XST_FAILURE;
    else
        return XST_SUCCESS;
}

Hint XHwIcap_DeviceWriteDMA(XHwIcap *InstancePtr, u32 *FrameBuffer, u32 NumWords) {

	//u32 WrFifoVacancy;
	//u32 IntrStatus;

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
     * TODO:Possibly remove in the future?
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
                dma_config.base=ICAP_DMA_BASEADDR;                
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

	#define NUM 500 //this numer is critical, may go up to 1000, but not gurantee.
	while (InstancePtr->RemainingWords > 0) {
	//WrFifoVacancy = XHwIcap_GetWrFifoVacancy(InstancePtr);
	//printf( " fifo vacancyis %i .\r\n",WrFifoVacancy); 
	
        if ( InstancePtr->RemainingWords >= NUM	)    {            
        dma_transfer(&dma, (void *) InstancePtr->SendBufferPtr, (void *) (InstancePtr)->HwIcapConfig.BaseAddress+XHI_WF_OFFSET, NUM*4, DMA_SIZE_WORD, Htrue,Hfalse);
	InstancePtr->RemainingWords-=NUM;	InstancePtr->SendBufferPtr+=NUM;	}		
       
    		
	 else {
                dma_transfer(&dma, (void *) InstancePtr->SendBufferPtr, (void *) (InstancePtr)->HwIcapConfig.BaseAddress+XHI_WF_OFFSET, InstancePtr->RemainingWords*4, DMA_SIZE_WORD, Htrue,Hfalse);
		InstancePtr->RemainingWords=0;	InstancePtr->SendBufferPtr+=1;	}	
								
							
				XHwIcap_StartConfig(InstancePtr);
								
	}			
                                  
				while ((XHwIcap_ReadReg(
					InstancePtr->HwIcapConfig.BaseAddress,
					XHI_CR_OFFSET)) & XHI_CR_WRITE_MASK);	
					
					  while(!dma_getdone(&dma));
                                  if (dma_geterror(&dma)) {     printf("DMA ERROR\n");                return 1; }

	

#endif		/*
		 * Clear the flag to indicate the write has been done
		 */
		InstancePtr->IsTransferInProgress = FALSE;
		InstancePtr->RequestedWords = 0x0;

	return XST_SUCCESS;


}
#endif
