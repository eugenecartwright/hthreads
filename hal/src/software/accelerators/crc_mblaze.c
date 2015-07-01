/* ***************************************************************
 * Filename: crc.c
 * Description: Code provided for interaction with the crc core.
 * Also, a software version of crc is provided to do some 
 * comparisons, if desired.
 * ***************************************************************/
 
#include <crc.h>
#include "fsl.h"
#include <dma/dma.h>
#include "pvr.h"
#include <accelerator.h>
#include <hwti/hwti.h>
#include <icap.h>

Hint crc (void * list_ptr, Huint size, Huint * done) {

    // done variable not used for slave accelerator calls
    
    Hint result = SUCCESS;
    
    // Get VHWTI
    Huint vhwti_base = 0;
    
    // Get VHWTI from PVRs 
    getpvr(1,vhwti_base);

    // Use Accelerator?
    Hbool use_accelerator = useHW(CRC,size);

    if (use_accelerator) {
        // Increment HW counter 
        Huint hw_counter = _hwti_get_accelerator_hw_counter( vhwti_base );
        _hwti_set_accelerator_hw_counter( vhwti_base, ++hw_counter);
    } else {
        // Increment SW counter 
        Huint sw_counter = _hwti_get_accelerator_sw_counter( vhwti_base );
        _hwti_set_accelerator_sw_counter( vhwti_base, ++sw_counter);
    }


    // Local variables
    tuning_table_t * tuning_table = (tuning_table_t *) _hwti_get_tuning_table_ptr(vhwti_base);
    
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

        // If I was instructed to use an accelerator
        if (use_accelerator) {

            // Get index for the given size
            Huint index = get_index(size);
            
            // Look up the the correct chunk number in table
            Huint chunks = tuning_table[CRC*NUM_OF_SIZES + index].chunks;

            // Call Pipeline crc with chunk number
            pipeline_crc( chunks, (int *) new_list_ptr, new_size);
        } else {
            // Run crc in software
            result =  (sw_crc((void *) new_list_ptr, new_size));
        }

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

//X => how many chunks , n=> size of data
void pipeline_crc(int x, int * start , int n){
	
    int chunk_size = n/x;
	int reminder = n %x ;
	dma_config_t    dma_config;
	dma_t           dma;              
	dma_config.base=ACCELERATOR_DMA_BASEADDR;
	dma_create(&dma,&dma_config);
	
	transfer_dma(&dma, start, (void *)(ACC_BRAM_A),chunk_size * 4);

	int volatile i,j;
	for( i=0; i< x ; i++)
	{
		putfslx(( ((i+1) *chunk_size)    <<15)|(i *chunk_size), 0,FSL_DEFAULT);
 
		if (i >0 )
			transfer_dma(&dma,(int*) (ACC_BRAM_A)+ (i-1)*chunk_size, (int *) (start+ (i-1)*chunk_size )   , chunk_size * 4);
		if ( i <(x-1))
			transfer_dma(&dma,(int *) (start+ (i+1)*chunk_size ) , (int*) (ACC_BRAM_A)+ (i+1)*chunk_size, chunk_size * 4);

		getfslx(j,0, FSL_DEFAULT);
	}

	   transfer_dma(&dma,(int*) (ACC_BRAM_A)+ (i-1)*chunk_size, (int *) (start+ (i-1)*chunk_size )   , chunk_size * 4);


	if (reminder != 0)
	{
		transfer_dma(&dma,(int *) (start +n-reminder ) , (int*) (ACC_BRAM_A)+n -reminder, reminder * 4);
		putfslx( (n  <<15)|(n-reminder), 0,FSL_DEFAULT);
		getfslx(j,0, FSL_DEFAULT);
		transfer_dma(&dma, (int*) (ACC_BRAM_A)+  n- reminder, (int *) (start+ n-reminder)   , reminder * 4);

	}
}
