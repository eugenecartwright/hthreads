#ifndef _SORT_H_
#define _SORT_H_

#include <httype.h>

extern Hint poly_bubblesort (void * list_ptr, Huint size);
extern Hint sw_bubblesort (void * list_ptr, Huint size);
extern Hint poly_quicksort(Hint * startPtr, Hint * endPtr);

#endif
