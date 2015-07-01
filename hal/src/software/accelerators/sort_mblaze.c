/* ***************************************************************
 * Filename: sort.c
 * Description: Code provided for interaction with the sort core.
 * Also, a software version of sort is provided to do some 
 * comparisons, if desired.
 * ***************************************************************/

#include <sort.h>
#include "fsl.h"
#include <dma/dma.h>
#include "pvr.h"
#include <accelerator.h>
#include <hwti/hwti.h>
#include <icap.h>

Hint sort (void * list_ptr, Huint size, Huint * done) {
    
    Hint result = SUCCESS;

    // Get VHWTI
    Huint vhwti_base = 0;
    
    // Get VHWTI from PVRs 
    getpvr(1,vhwti_base);

    // If the size is bigger than what we can
    // fit in the BRAM, run (quick)sort directly
    // from main memory/list_ptr
    if (size > BRAM_SIZE) {
        // Calculate start and end pointers
        Huint * startPtr = (Huint *) list_ptr;
        Huint * endPtr   = (Huint *) (startPtr + size-1);

        // Call quicksort directly
        sw_quicksort(startPtr, endPtr);
        
        // Grab accelerator flags
        Huint accelerator_flags = (Huint) _hwti_get_accelerator_flags(vhwti_base); 

        // Do we use the accelerator? 
        if (accelerator_flags & ACCELERATOR_FLAG) {
            // if this is the first accelerator used for this function
            // (if the first_accelerator_used field in VHWTI is MAGIC_NUMBER), 
            // update this field.
            if (_hwti_get_first_accelerator(vhwti_base) == MAGIC_NUMBER)
                _hwti_set_first_accelerator(vhwti_base, SORT);
        }
        
        // Increment SW counter 
        Huint sw_counter = _hwti_get_accelerator_sw_counter( vhwti_base );
        _hwti_set_accelerator_sw_counter( vhwti_base, ++sw_counter);

        return SUCCESS;
    }

    // Use Accelerator?
    Hbool use_accelerator = useHW(SORT,size);
    
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

    // If I was instructed to use an accelerator
    if (use_accelerator) {

        // Get index for the given size
        Huint index = get_index(size);

        // Look up the the correct chunk number in table
        Huint chunks = tuning_table[SORT*NUM_OF_SIZES + index].chunks;

        // Call Pipeline sort with chunk number
        pipeline_sort( chunks, (int *) list_ptr, size);

    } else {
        // Run sort in software
        result = (sw_sort((void *) list_ptr, size));
    }

    return result;
}

//X => how many chunks , n=> size of data ; n should be divisible by x
void pipeline_sort(int x, int * start , int n){
    
    // Set up DMA structure
    dma_t local_dma;
    dma_config_t local_dma_config;
    local_dma_config.base = ACCELERATOR_DMA_BASEADDR;
    dma_create(&local_dma, &local_dma_config);
	
	
    int chunk_size = n/x;
	int remainder = n %x ;

	
	transfer_dma(&local_dma, start, (void *) (ACC_BRAM_A),chunk_size * 4);

	int volatile i,j;
	for( i=0; i< x ; i++)
	{
		putfslx((   (((i+1) *chunk_size)-1)    <<15)|(i *chunk_size), 0,FSL_DEFAULT);
 		if ( i <(x-1))
			transfer_dma(&local_dma,(int *) (start+ (i+1)*chunk_size ) , (int*) (ACC_BRAM_A)+ (i+1)*chunk_size, chunk_size * 4);

		getfslx(j,0, FSL_DEFAULT);
	}

	if (remainder != 0)
	{
		transfer_dma(&local_dma,(int *) (start +n-remainder ) , (int*) (ACC_BRAM_A)+n -remainder,remainder*  4);
		putfslx( ((n-1)  <<15)|(n-remainder), 0,FSL_DEFAULT);
		getfslx(j,0, FSL_DEFAULT);

	}
    
    if (x != 1)
		merge_sort(x, n, (int *) (ACC_BRAM_A), start);
	else
		//DMA the sorted data back to the dram.
		 transfer_dma(&local_dma, (void *) (ACC_BRAM_A), (void *) start,n*4);
}

//X => how many chunks , n=> size of data ; n should be divisible by x, x should be less than MAX
void merge_sort(int x, int n, int * src , int * des){

    int chunck_size = n/x;
	int remainder = n %x ;
		
	#define MAX 50	
	int ptr[MAX];
	int data[MAX];

	int register  i,j, index = 0,min;

	if (remainder !=0)		x++;

	//INITILIZe the ptrs and data for chunks
	for ( i=0; i < x; i++){
		ptr[i]=0;
		data[i]=*((int *)src + i *chunck_size);
		
	}

	//write final data into bramB one by one
	for ( i=0; i < n; i++){
		min=0x7fffffff;
		for ( j=0; j < x-1; j++)
		{
			if (  ( data[j] < min) &&    (ptr[j]<chunck_size)  )
			{
				min=data[j];
				index=j;
			}
			
		}
		if (  ( data[j] < min)){
			if ((remainder ==0) &&    (ptr[j]<chunck_size)  ) {min=data[j];	index=j;}
			else if ((remainder !=0) &&    (ptr[j]<remainder)  ) {min=data[j];	index=j;}
		}

		* ( (int *)(des)+i) =min;

		ptr[index]= ptr[index]+1;
		data[index]= *( (int *)src+ index * chunck_size +ptr[index]);
				
	}
}


/* ---------------------------------------------- *
 * Software routine for performing sort. Function *
 * simply performs quick-sort.                    *
 * Author: Abazar                                 *
 * ---------------------------------------------- */
void sw_quicksort(Huint * startPtr, Huint * endPtr ) {
    
    Huint pivot;
	Huint * leftPtr, * rightPtr;
	Huint temp, * tempPtr;

	//fflush( stdout );
	if ( startPtr == endPtr ) { return; }

	leftPtr = startPtr;
	rightPtr = endPtr;

	pivot = (*leftPtr + *rightPtr)/2;

	while (leftPtr < rightPtr) {
		while ((leftPtr < rightPtr) && (*leftPtr <= pivot) ) {
			leftPtr++;
		}

		while((leftPtr <= rightPtr) && (*rightPtr > pivot) ) {
			rightPtr--;
		}

		if ( leftPtr < rightPtr ) {
			temp = *leftPtr;
			*leftPtr = *rightPtr;
			*rightPtr = temp;
		}
	}
	
	if ( leftPtr == rightPtr ) {
		if ( *rightPtr >= pivot ) {
			leftPtr = rightPtr - 1;
		} else {
			rightPtr++;
		}
	} else {
		if ( *rightPtr > pivot ) {
			leftPtr = rightPtr - 1;
		} else {
			tempPtr = leftPtr;
			leftPtr = rightPtr;
			rightPtr = tempPtr;
		}
	}
	
    sw_quicksort( rightPtr, endPtr );
	sw_quicksort( startPtr, leftPtr );

    return;
}

Hint sw_sort(void * list_ptr, Huint size ) {
    
    // Set up DMA structure
    dma_t local_dma;
    dma_config_t local_dma_config;
    local_dma_config.base = ACCELERATOR_DMA_BASEADDR;
    dma_create(&local_dma, &local_dma_config);
    
    // Transfer List A to local BRAM A using local dma
    if(transfer_dma(&local_dma, (void *) list_ptr, (void *) ACC_BRAM_A, size*4))
        return FAILURE;

    Huint * startPtr = (Huint *) ACC_BRAM_A;
    Huint * endPtr   = (Huint *) (startPtr + size-1);
    sw_quicksort(startPtr, endPtr);

    // Transfer results back
    if(transfer_dma(&local_dma, (void *) ACC_BRAM_A, (void *) list_ptr, size*4))
        return FAILURE;
    else
        return SUCCESS;
}

