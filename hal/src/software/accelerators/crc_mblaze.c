/* ***************************************************************
 * Filename: crc.c
 * Description: Code provided for interaction with the crc core.
 * Also, a software version of crc is provided to do some 
 * comparisons, if desired.
 * FIXME: Use powers of 2 for size of data, except 4096. Also, 
 * input data numbers should be divisible by 8.
 * ***************************************************************/
 
#include <crc.h>

Hint poly_crc (void * list_ptr, Huint size) 
{
   Hint result = SUCCESS;
   
   // Use Accelerator?
   Hbool use_accelerator = poly_init(CRC, size);

   // Start transferring data to BRAM
   if(transfer_dma( (void *) list_ptr, (void *) ACC_BRAMC, size *4))
      return FAILURE;

   if (use_accelerator) {
     int e = 0;
     putfslx( size, 0, FSL_DEFAULT);//send end address
     putfslx( 0, 0, FSL_DEFAULT); //send start address
     getfslx(e, 0, FSL_DEFAULT);
     if (e != 1) return FAILURE;
   } else {
      Huint vhwti_base = 0;
   
      // Get VHWTI from PVRs 
      getpvr(1,vhwti_base);
      hthread_time_t start = hthread_time_get();
      // Run crc in software
      result =  (sw_crc((void *) ACC_BRAMC, size));
      hthread_time_t stop = hthread_time_get();
      hthread_time_t diff;
      hthread_time_diff(diff, stop,start);
      volatile hthread_time_t * ptr = (hthread_time_t *) (vhwti_base + 0x100);
      *ptr += diff;

   }

   // Start transferring data from BRAM
   if(transfer_dma( (void *) ACC_BRAMC, (void *) list_ptr, size *4))
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
    
    Hint *array;

    for (array = (Hint *) list_ptr; array < (Hint *) list_ptr + size; array++) {
        *array = gen_crc(*array);
    }

    return SUCCESS;
}

