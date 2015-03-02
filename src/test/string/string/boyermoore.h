/*****************************************************************************
 * Boyer/Moore String Maching Algorithm
 *****************************************************************************/
#ifndef _ALGORITHM_STRING_BOYERMOORE_H_
#define _ALGORITHM_STRING_BOYERMOORE_H_

#include <string/types.h>
#include <string/carray.h>

typedef struct
{
    int32    *mem;
    int32    *good;
    int32    *bad;
    int32    loc;
    carray_t *needle;
} bmoore_t;

int32 boyermoore_init( bmoore_t*, carray_t* );
int32 boyermoore_reset( bmoore_t* );
int32 boyermoore_search( bmoore_t*, carray_t* );
int32 boyermoore_destroy( bmoore_t* );

int32 string_boyermoore( carray_t*, carray_t* );

#endif
