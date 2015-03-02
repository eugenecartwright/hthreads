/*****************************************************************************
 * Array Data Structure
 *****************************************************************************/
#ifndef _ALGORITHM_UTIL_CARRAY_H_
#define _ALGORITHM_UTIL_CARRAY_H_

#include <string/types.h>

// Definition of the array structure
typedef struct
{
    uint32  size;
    boolean owner;

    uint8  *data;
} carray_t;

// Definition of array functions
int32 carray_create( carray_t*, uint32 );
int32 carray_destroy( carray_t* );

int32 carray_fromstr( carray_t*, const char* );
int32 carray_concatstr( carray_t*, const char* );

int32 carray_mirror( carray_t*, carray_t* );
int32 carray_submirror( carray_t*, carray_t*, uint32, uint32 );

int32 carray_clone( carray_t*, carray_t* );
int32 carray_subclone( carray_t*, carray_t*, uint32, uint32 );

int32 carray_copy( carray_t*, carray_t* );
int32 carray_subcopy( carray_t*, carray_t*, uint32 off, uint32, uint32 );

int32 carray_fill( carray_t*, uint8 );
int32 carray_subfill( carray_t*, uint32, uint32, uint8 );

int32 carray_clear( carray_t* );
int32 carray_subclear( carray_t*, uint32, uint32 );

boolean carray_equal( carray_t*, carray_t* );
boolean carray_subequal( carray_t*, carray_t*, uint32, uint32, uint32 );

void carray_random( carray_t*, uint8, uint8 );
void carray_print( carray_t* );
boolean carray_sorted( carray_t* );

int32 carray_resize( carray_t*, uint32 );

#endif
