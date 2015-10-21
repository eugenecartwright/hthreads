#include <accelerator.h>
#include "xaxicdma.h"

#include <hwti/hwti.h>
#include "fsl.h"
#include "pvr.h"
#include "icap.h"

// -------------------------------------------------------------- //
//                     DMA Transfer Wrapper                       //
// -------------------------------------------------------------- //
static Hbool initialized = 0;

Hint transfer_dma(void * src, void * des, int size) {
   XAxiCdma *dma;
   if (!initiliazed) {
      Hint status = dma_create(dma,SLAVE_LOCAL_DMA_DEVICE_ID);
      if (!status)
         return FAILURE;
      else
         initialized = 1;
   }

   dma_reset(dma);        
   dma_transfer(dma, src, des, size);

   // Wait until done
   while(!dma_getdone(dma));

   // Check for any errors
   if (dma_geterror(dma))
      return FAILURE;
   else
      return SUCCESS;

}

// -------------------------------------------------------------- //
//     Initialization routine for all polymorphic functions       //
// -------------------------------------------------------------- //
Hbool poly_init(Hint acc) {
   
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

    // Grab accelerator flags
    Huint accelerator_flags = (Huint) _hwti_get_accelerator_flags(vhwti_base); 

    // Do we use the accelerator? 
    if (!(accelerator_flags & ACCELERATOR_FLAG))
        return 0;
    
    // if this is the first accelerator used for this function
    // (if the first_accelerator_used field in VHWTI is MAGIC_NUMBER), 
    // update this field.
    // TODO: Should this be NO_ACC or MAGIC_NUMBER?
    if (_hwti_get_first_accelerator(vhwti_base) == MAGIC_NUMBER)
        _hwti_set_first_accelerator(vhwti_base, accelerator_type);

    // What is the current accelerator loaded?
    Huint current_accelerator = _hwti_get_last_accelerator(vhwti_base);
    
    // if the accelerator I want is already loaded 
    if (current_accelerator == accelerator_type) {
        // Return immediately indicating to use HW/accelerator
        return 1;
    }

#ifdef PR
    // get accelerator profile associated for this Slave
    // Accelerator profile is simply a list of pointers to each
    // of the accelerator bit files specific for this PR region.
    // For example, the accelerator profile is a structure that
    // looks as follows:
    //
    //      ...
    //      char * crc_bit_file_ptr;
    //      char * sort_bit_file_ptr;
    //      char * vector_bit_file_ptr;
    //      ...

    // Does this processor have PR capabilities?
    if (accelerator_flags & PR_FLAG) {
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
            if (perform_PR(id, accelerator_type))  
               return 0;
           
            // Increment PR counter 
            Huint pr_counter = _hwti_get_accelerator_pr_counter( vhwti_base );
            _hwti_set_accelerator_pr_counter( vhwti_base, ++pr_counter);

            // always update last_accelerator field
            _hwti_set_last_accelerator(vhwti_base, accelerator_type);
            
            // Return immediately indicating to use HW/accelerator
            return 1;
        }
    }
#endif

    // As a default, always return 0 
    // indicating to run in software.
    return 0;
}

