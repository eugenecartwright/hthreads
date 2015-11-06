#include <accelerator.h>
#include <crc.h>
#include <htconst.h>

Hint poly_crc(void * list_ptr, Huint size) {

    Hint *array = (Hint *) list_ptr;

    for (array = list_ptr; array < (Hint *) list_ptr + size; array++) {
        *array = gen_crc(*array);
    }
    
    return SUCCESS;
}

Hint sw_crc(void * list_ptr, Huint size) {
   return (poly_crc(list_ptr, size));
}


//====================================================================================
// Author: Abazar
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
//====================================================================================
