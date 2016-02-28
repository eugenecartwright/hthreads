/* ***************************************************************
 * Filename: sort.c
 * Description: Code provided for interaction with the sort core.
 * Also, a software version of sort is provided to do some 
 * comparisons, if desired.
 * FIXME: Use powers of 2 for size of data, except 4096. 
 * ***************************************************************/

#include <sort.h>

Hint poly_bubblesort (void * list_ptr, Huint size) 
{
    
   Hint result = SUCCESS;
   // Use Accelerator?
   Hbool use_accelerator = poly_init(BUBBLESORT, size);

   // Start transferring data to BRAM
   if(transfer_dma( (void *) list_ptr, (void *) ACC_BRAMC, size *4)) 
      return FAILURE;


   if (use_accelerator) {
      int e;
      int start = 0;
		int end = size-1;
		putfslx( end, 0, FSL_DEFAULT);
		putfslx( start, 0, FSL_DEFAULT);
		getfslx(e, 0, FSL_DEFAULT);
   } else {
      Huint vhwti_base = 0;
   
      // Get VHWTI from PVRs 
      getpvr(1,vhwti_base);
      hthread_time_t start = hthread_time_get();
      // Run sort in software
      result = sw_bubblesort((void *) ACC_BRAMC, size) ;
      hthread_time_t stop = hthread_time_get();
      hthread_time_t diff = 0;
      hthread_time_diff(diff, stop,start);
      volatile hthread_time_t * ptr = (hthread_time_t *) (vhwti_base + 0x100);
      *ptr += diff;
   }

   // Start transferring data from BRAM
   if(transfer_dma( (void *) ACC_BRAMC, (void *) list_ptr, size *4))
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

Hint sw_bubblesort(void * list_ptr, Huint size) 
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
   return SUCCESS;
}  

