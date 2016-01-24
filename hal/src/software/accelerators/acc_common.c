#include <accelerator.h>
#include "xaxicdma.h"

#include <hwti/hwti.h>
#include <dma/dma.h>
#include "fsl.h"
#include "pvr.h"
#ifdef PR
#include <pr.h> 
#endif

// -------------------------------------------------------------- //
//                     DMA Transfer Wrapper                       //
// -------------------------------------------------------------- //

Hint transfer_dma(void * src, void * des, Hint size) {
   XAxiCdma dma;
   Hint status = dma_create(&dma,SLAVE_LOCAL_DMA_DEVICE_ID);
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

// -------------------------------------------------------------- //
//     Initialization routine for all polymorphic functions       //
// -------------------------------------------------------------- //
Hbool poly_init(Hint acc, Huint size) {
   
   // Get VHWTI
   Huint vhwti_base = 0;
   
   // Get VHWTI from PVRs 
   getpvr(1,vhwti_base);

   // Use Accelerator?
   Hbool use_accelerator = useHW(acc,size);

   if (use_accelerator) {
       // Increment HW counter 
       Huint hw_counter = _hwti_get_accelerator_hw_counter( vhwti_base );
       _hwti_set_accelerator_hw_counter( vhwti_base, ++hw_counter);
   } else {
       // Increment SW counter 
       Huint sw_counter = _hwti_get_accelerator_sw_counter( vhwti_base );
       _hwti_set_accelerator_sw_counter( vhwti_base, ++sw_counter);
   }

   return use_accelerator;
}

// -------------------------------------------------------------- //
//             Get's index size for given data size               //
// -------------------------------------------------------------- //
Huint get_index(Huint size) 
{
    
    if (size > ((BRAM_SIZE + (BRAM_SIZE/2)) / 2)) {
        return NUM_OF_SIZES-1;
    } 
    if (size > ((BRAM_SIZE/2 + (BRAM_SIZE/4)) / 2)) {
        return NUM_OF_SIZES-2;
    } 
    if (size > ((BRAM_SIZE/4 + (BRAM_SIZE/8)) / 2)) {
        return NUM_OF_SIZES-3;
    } 
    if (size > ((BRAM_SIZE/8 + (BRAM_SIZE/16)) / 2)) {
        return NUM_OF_SIZES-4;
    } 
    if (size > ((BRAM_SIZE/16 + (BRAM_SIZE/32)) / 2)) {
        return NUM_OF_SIZES-5;
    } 
    if (size > ((BRAM_SIZE/32 + (BRAM_SIZE/64)) / 2)) {
        return NUM_OF_SIZES-6;
    } 
    return NUM_OF_SIZES-7;
}

// -------------------------------------------------------------- //
//             Determine if we use HW, PR if necessary            //
// -------------------------------------------------------------- //
Hbool useHW(Huint accelerator_type, Huint size) {

   // Grab the VHWTI base
   Huint vhwti_base = 0;
   getpvr(1,vhwti_base);

   // Get currently loaded accelerator
   Huint current_accelerator = _hwti_get_last_accelerator(vhwti_base);

   // Determine whether this slave has PR
   Hbool has_PR = (Huint) _hwti_get_PR_flag(vhwti_base);

   // Immediately return 0 if slave has no PR, and has no
   // access to the specified "accelerator_type"
   if (has_PR != PR_FLAG) {
      if (current_accelerator == NO_ACC)
         return 0;
      else if(current_accelerator != accelerator_type)
         return 0;
   }

   // Update the first used accelerator (slaves init this to NO_ACC)
   if (_hwti_get_first_accelerator(vhwti_base) == NO_ACC)
      _hwti_set_first_accelerator(vhwti_base, accelerator_type);
    
   // if the loaded accelerator matches the specified accelerator, return 1
   // FIXME: Is hardware faster always?
   if (current_accelerator == accelerator_type) {
     return 1;
   }

#ifdef PR
   // Does this processor have PR capabilities?
   if (has_PR) {
      // Get tuning table pointer.
      tuning_table_t * tuning_table = (tuning_table_t *) _hwti_get_tuning_table_ptr(vhwti_base);

        // Calculate if PR is worth it by indexing appropriately 
        // into the table and evaluating the software and hardware
        // execution times, taking into account PR overhead.
        Huint index = get_index(size);
        if ((tuning_table[accelerator_type*NUM_OF_SIZES + index].hw_time + PR_OVERHEAD) < tuning_table[accelerator_type*NUM_OF_SIZES +index].sw_time) {
            // TODO: Yes, PR is worth it ...but by how much?
 
            // ----Begin loading the accelerator----//
            // If performing PR failed, fallback to software
            // execution. So return false.
            unsigned char id;
            getpvr(0, id);
            // Perform PR (which updates last used accelerator)
            if (perform_PR(id, accelerator_type) != SUCCESS)  
               return 0;
           
            // Increment PR counter 
            Huint pr_counter = _hwti_get_accelerator_pr_counter( vhwti_base );
            _hwti_set_accelerator_pr_counter( vhwti_base, ++pr_counter);

            // Return immediately indicating to use HW/accelerator
            return 1;
        }
    }
#endif

    // As a default, always return 0 
    // indicating to run in software.
    return 0;
}

