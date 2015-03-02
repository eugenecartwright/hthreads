/* ***************************************************************
 * Filename: crc.c
 * Description: Code provided for interaction with the crc core.
 * Also, a software version of crc is provided to do some 
 * comparisons, if desired.
 * ***************************************************************/
 
#include <crc.h>
#include <dma/dma.h>
#include <accelerator.h>
#include <hwti/hwti.h>
#include "pvr.h"

Hint crc (void * list_ptr, Huint size, Huint * done) {

    // done variable not used for slave accelerator calls
    
    Hint result = SUCCESS;
    
    // Get VHWTI
    Huint vhwti_base = 0;
    
    // Get VHWTI from PVRs 
    getpvr(1,&vhwti_base);
    
    // Increment SW counter 
    Huint sw_counter = _hwti_get_accelerator_sw_counter( vhwti_base );
    _hwti_set_accelerator_sw_counter( vhwti_base, ++sw_counter);


    // if the size is more than 4k words,
    // grab the amount of iterations you
    // need to perform.
    Huint iterations = size / BRAM_SIZE;
    
    // If there is a remainder in this 
    // division, round up.
    if ((size % BRAM_SIZE) != 0) {
        iterations++;
    }

    Huint i = 0;
    Huint new_size = 0;
    Huint * new_list_ptr = 0;
    for (i = 0; i < iterations; i++) {

        // Calculate the size for this iteration
        new_size = (size < (BRAM_SIZE*(i+1))) ? size-(BRAM_SIZE*i) : BRAM_SIZE; 

        // Calculate the starting pointer for this iteration. Typcasting
        // may be repetitive here.
        new_list_ptr = (Huint *) ((Huint *)list_ptr + BRAM_SIZE*i);

        // Run crc in software
        result =  (sw_crc((void *) new_list_ptr, new_size));

        if (result != SUCCESS) break;
    } /* end of iterations loop */

    return result;
}


#define G_INPUT_WIDTH 32
#define G_DIVISOR_WIDTH 4
Hint gen_crc( Hint input)
{
  unsigned int result;
  result=input;
  unsigned int i=0;  
  unsigned int divisor = 0xb0000000;     
  unsigned int mask     =0x80000000; 
     
       while(1){   
             
              if ( ( i < G_INPUT_WIDTH - G_DIVISOR_WIDTH + 1 ) && ( (result&mask) == 0 ) ) {
                i++;
                divisor=divisor  /2;
                mask = mask /2;
              }
              else if ( ( i < G_INPUT_WIDTH - G_DIVISOR_WIDTH + 1 ) ) {
               
                i++;
                result = result ^ divisor;
                divisor=divisor  /2;
                mask=mask /2;               
              }
              else {              
               return result;
              }
       }
      return 0;
} 

Hint sw_crc(void * list_ptr, Huint size) {
    
    // Set up DMA structure
    dma_t local_dma;
    dma_config_t local_dma_config;
    local_dma_config.base = ACCELERATOR_DMA_BASEADDR;
    dma_create(&local_dma, &local_dma_config);
    
    // Transfer List A to local BRAM A using local dma
    if(transfer_dma(&local_dma, (void *) list_ptr, (void *) ACC_BRAM_A, size*4))
        return FAILURE;
    
    Hint *array = (Hint *) ACC_BRAM_A;

    for (array = (Hint *) ACC_BRAM_A; array < (Hint *) ACC_BRAM_A + size; array++) {
        *array = gen_crc(*array);
    }

    // Transfer results back
    if(transfer_dma(&local_dma, (void *) ACC_BRAM_A, (void *) list_ptr, size*4))
        return FAILURE;
    else
        return SUCCESS;
}

