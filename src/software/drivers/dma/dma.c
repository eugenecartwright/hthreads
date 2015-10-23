#include <config.h>
#include <dma/dma.h>
#include <stdlib.h>
#include <debug.h>

Hint  dma_create(XAxiCdma * dma, u16 DeviceId)
{
   XAxiCdma_Config * CdmaCfgPtr;

   CdmaCfgPtr-> DeviceId   =  GLOBAL_DMA_DEVICE_ID;  
   CdmaCfgPtr->BaseAddress =  GLOBAL_DMA_BASEADDR;    
   CdmaCfgPtr->HasDRE      =  GLOBAL_DMA_INCLUDE_DRE;
   CdmaCfgPtr->IsLite      =  GLOBAL_DMA_USE_DATAMOVER_LITE;
   CdmaCfgPtr->DataWidth   =  GLOBAL_DMA_M_AXI_DATA_WIDTH;
   CdmaCfgPtr->BurstLen    =  GLOBAL_DMA_M_AXI_MAX_BURST_LEN;


   // Initialize the DMA driver and reset the dma device (done in Initialize)
   Hint Status = XAxiCdma_CfgInitialize(dmar, CdmaCfgPtr, CdmaCfgPtr->BaseAddress);
   if (Status != XST_SUCCESS)
      return FAILURE;
   
   XAxiCdma_IntrDisable(dma, XAXICDMA_XR_IRQ_ALL_MASK);
      
   return SUCCESS;
}

void  dma_reset(XAxiCdma * dma)
{
   // Perform reset
   XAxiCdma_Reset(dma);

   // Wait for it to complete
   while (!XAxiCdma_ResetIsDone(dma));
}


Hbool dma_getbusy(XAxiCdma *dma)
{
   return (Hbool) (XAxiCdma_IsBusy(dma));
}

/*  0 = no error */
Hint dma_geterror( XAxiCdma *dma )
{
   return (XAxiCdma_GetError(dma));
}

/* Function will spin until dma is done. On error, reset device */
Hbool dma_getdone( XAxiCdma *dma )
{
   return (Hbool) (XAxiCdma_IsBusy(dma));
}


Hint dma_transfer(XAxiCdma *dma, Huint SrcAddr, Huint DstAddr, Hint byte_Length)
{
    
   Hint Status, CDMA_Status;

   // Wait for the dma controller to not be busy
   while(dma_getbusy(dma));

   Status = XAxiCdma_SimpleTransfer(dma, SrcAddr, DstAddr, byte_Length, NULL, NULL);

   if (Status != SUCCESS)
   {
      CDMA_Status = dma_geterror(dma);
      if (CDMA_Status != SUCCESS) 
      {
         TRACE_PRINTF( TRACE_ERR, TRACE_DMA, "DMA ERROR: (CDMA Status=0x%08x)\n", CDMA_Status );
         // Reset the device
         dma_reset(dma);
      }
      else
         TRACE_PRINTF( TRACE_ERR, TRACE_DMA, "DMA ERROR: (Perhaps an existing transfer ongoing?)\n");
      return FAILURE;
   }
   
   return SUCCESS;
}
