#ifndef _SORT_H_
#define _SORT_H_

#include <httype.h>

extern Hint poly_bubblesort (void * list_ptr, Huint size, Huint * done);

extern Hint sw_sort(void * list_ptr, Huint size);
extern void sw_quicksort(Huint * startPtr, Huint * endPtr );
extern void sw_bubblesort(Huint * startPtr, Hint n ); 

#endif
