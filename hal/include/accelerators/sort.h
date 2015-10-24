#ifndef _SORT_H_
#define _SORT_H_

#include <httype.h>

extern Hint poly_bubblesort (void * list_ptr, Huint size);

extern void sw_quicksort(Hint * startPtr, Hint * endPtr);
extern void sw_bubblesort(void * list_ptr, Huint size ); 

#endif
