/* ***************************************************************
 * Filename: sort.c
 * Description: Code provided for interaction with the sort core.
 * Also, a software version of sort is provided to do some 
 * comparisons, if desired.
 * ***************************************************************/

#include <sort.h>
#include <dma/dma.h>
#include "pvr.h"
#include <accelerator.h>
#include <hwti/hwti.h>

Hint sort (void * list_ptr, Huint size, Huint * done) {
    
    Hint result = SUCCESS;

    // Get VHWTI
    Huint vhwti_base = 0;
    
    // Get VHWTI from PVRs 
    getpvr(1,&vhwti_base);

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

    // Increment SW counter 
    Huint sw_counter = _hwti_get_accelerator_sw_counter( vhwti_base );
    _hwti_set_accelerator_sw_counter( vhwti_base, ++sw_counter);
    
    // Run sort in software
    result = (sw_sort((void *) list_ptr, size));
    
    return result;
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

