#include <accelerator.h>
#include <dma/dma.h>

// -------------------------------------------------------------- //
//                     DMA Transfer Wrapper                       //
// -------------------------------------------------------------- //
Hint transfer_dma(void * src, void * des, Hint size) {
   XAxiCdma dma;
   Hint status = dma_create(&dma,GLOBAL_DMA_DEVICE_ID);
   if (status != SUCCESS)
      return FAILURE;

   // Reset DMA   
   dma_reset(&dma);    
   
   status = dma_transfer(&dma, (Huint) src, (Huint) des, size);
   if (status != SUCCESS)
      return FAILURE;

   // Wait until done
   while(dma_getbusy(&dma));

   // Check for any errors
   return (dma_geterror(&dma));
}
