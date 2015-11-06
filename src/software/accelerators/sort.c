#include <accelerator.h>
#include <sort.h>
#include <htconst.h>


Hint poly_bubblesort(void *list_ptr, Huint size ) 
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

Hint sw_bubblesort(void *list_ptr, Huint size ) {
  return poly_bubblesort(list_ptr, size);
} 
/* ---------------------------------------------- *
 * Software routine for performing sort. Function *
 * simply performs quick-sort.                    *
 * Author: Abazar                                 *
 * ---------------------------------------------- */
Hint poly_quickSort(Huint * startPtr, Huint * endPtr) {

	Huint pivot;
	Huint * leftPtr, * rightPtr;
	Huint temp, * tempPtr;

	//fflush( stdout );
	if ( startPtr == endPtr ) { return SUCCESS; }

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
	
	poly_quickSort( rightPtr, endPtr );
	poly_quickSort( startPtr, leftPtr );

   return SUCCESS;
}
