/* ***************************************************************
 * Filename: sort.c
 * Description: Code provided for interaction with the sort core.
 * Also, a software version of sort is provided to do some 
 * comparisons, if desired.
 * ***************************************************************/

#include <accelerator.h>
#include <sort.h>
#include "fsl.h"
#include "pvr.h"
#include <hwti/hwti.h>

Hint poly_bubblesort (void * list_ptr, Huint size) 
{
    
   Hint result = SUCCESS;
    
   // Use Accelerator?
   Hbool use_accelerator = poly_init(BUBBLESORT, size);

   // Start transferring data to BRAM
   if(!transfer_dma( (void *) list_ptr, (void *) ACC_BRAMC, size *4))
      return FAILURE;

   if (use_accelerator) {
      int e;
      int start = 0;
		int end = size-1;
		putfslx( end, 0, FSL_DEFAULT);
		putfslx( start, 0, FSL_DEFAULT);
		getfslx(e, 0, FSL_DEFAULT);
   } else {
      // Run sort in software
      sw_bubblesort((void *) ACC_BRAMC, size) ;
   }
   
   // Start transferring data from BRAM
   if(!transfer_dma( (void *) ACC_BRAMC, (void *) list_ptr, size *4))
      return FAILURE;

   return result;
}




/* ---------------------------------------------- *
 * Software routine for performing sort. Function *
 * simply performs quick-sort.                    *
 * ---------------------------------------------- */
void sw_quicksort(Hint * startPtr, Hint * endPtr ) {
    
   Hint pivot;
	Hint * leftPtr, * rightPtr;
	Hint temp, * tempPtr;

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

void sw_bubblesort(void * list_ptr, Huint size) 
{
   Hint * startPtr = (Hint *) list_ptr;
   Huint c, d;
   Hint swap;
   for (c = 0 ; c < ( size - 1 ); c++)
   {
      for (d = 0 ; d < size - c - 1; d++)
      { 
         /* For decreasing order use < */
         if (startPtr[d] > startPtr[d+1])
         {
            swap       = startPtr[d];
            startPtr[d]   = startPtr[d+1];
            startPtr[d+1] = swap;
         }
      }
   }
}  

