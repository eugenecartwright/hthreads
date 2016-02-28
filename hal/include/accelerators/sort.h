#ifndef _SORT_H_
#define _SORT_H_

#include <accelerator.h>
#include "fsl.h"
#include "pvr.h"
#include <hwti/hwti.h>
#include <arch/htime.h>
#include <httype.h>

Hint poly_bubblesort (void * list_ptr, Huint size);
Hint sw_bubblesort(void * list_ptr, Huint size ); 
void sw_quicksort(Hint * startPtr, Hint * endPtr);

#endif
