#ifndef _SORT_H_
#define _SORT_H_

#include <httype.h>

extern Hint sort(void * list_ptr, Huint size, Huint * done);
extern Hint sw_sort(void * list_ptr, Huint size);
extern void sw_quicksort(Huint * startPtr, Huint * endPtr );
extern void pipeline_sort(int x, int * start , int n);
extern void merge_sort(int x, int n, int * src , int * des);

#endif
