/* ***************************************************************
 * Filename: crc.c
 * Description: Code provided for interaction with the crc core.
 * Also, a software version of crc is provided to do some 
 * comparisons, if desired.
 * ***************************************************************/
 
#include <accelerator.h>
#include "fsl.h"
#include "pvr.h"
#include <hwti/hwti.h>
#include <icap.h>

Hint poly_crc (void * list_ptr, Huint size, Huint * done) 
{
   // TODO: done variable not used for slave accelerator calls
   // Fix with macro definition later
   
   Hint result = SUCCESS;
   
   // Use Accelerator?
   Hbool use_accelerator = poly_init(CRC, size);

   // Start transferring data to BRAM
   if(!transfer_dma( (void *) list_ptr, (void *) ACC_BRAMC, size *4))
      return FAILURE;
   
   if (use_accelerator) {
     int e;
     putfslx( size, 0, FSL_DEFAULT);//send end address
     putfslx( 0, 0, FSL_DEFAULT); //send start address
     getfslx(e, 0, FSL_DEFAULT);
   } else {
      // Run crc in software
      result =  (sw_crc((void *) BRAMC, size));
   }

   // Start transferring data from BRAM
   if(!transfer_dma( (void *) ACC_BRAMC, (void *) list_ptr, size *4))
      return FAILURE;

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
    
    // Transfer List A to local BRAM A using local dma
    if(transfer_dma((void *) list_ptr, (void *) ACC_BRAM_A, size*4))
        return FAILURE;
    
    Hint *array = (Hint *) ACC_BRAM_A;

    for (array = (Hint *) ACC_BRAM_A; array < (Hint *) ACC_BRAM_A + size; array++) {
        *array = gen_crc(*array);
    }

    // Transfer results back
    if(transfer_dma((void *) ACC_BRAM_A, (void *) list_ptr, size*4))
        return FAILURE;
    else
        return SUCCESS;
}

