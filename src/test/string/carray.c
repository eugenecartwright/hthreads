#include <string/carray.h>
#include <string/debug.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

int32 carray_create( carray_t *array, uint32 size )
{
    // Make sure that some presumptions are correct
    ASSERT( array != NULL, "array is null\n" );

    // Allocate the array memory
    array->data = (uint8*)malloc( size*sizeof(uint8) );
    if( array->data == NULL )   return ENOMEM;

    // Store the array bounds
    array->size  = size;
    array->owner = true;

    // Return successfully
    return 0;
}

int32 carray_destroy( carray_t *array )
{
    // Make sure that some presumptions are correct
    ASSERT( array != NULL, "array is null\n" );

    // Make sure the array is valid
    if( array->data == NULL )   return EINVAL;

    // Free the array data
    if( array->owner == true )  free( array->data );

    // Destroy the array
    array->data  = NULL;
    array->size  = 0;
    array->owner = false;

    // Return successfully
    return 0;
}

int32 carray_fromstr( carray_t *array, const char *str )
{
    int32  res;
    uint32 i;
    uint32 len;

    // Determine the length of the string
    len = strlen(str);

    // Create an array to hold the string
    res = carray_create( array, len );
    if( res != 0 ) return res;

    // Copy the string into the array
    for( i = 0; i < len; i++ ) array->data[i] = str[i];

    // Return successfully
    return 0;
}

int32 carray_concatstr( carray_t *array, const char *str )
{
    int32  i;
    uint32 len;
    uint8  *data;

    // Check that the array is the original owner of the array
    if( !array->owner ) return EINVAL;

    // Determine the length of the string
    len = strlen(str);

    // Attempt to reallocate the array memory to accomodate the string
    data = (uint8*)realloc( array->data, array->size + len );
    if( data == NULL ) return ENOMEM;

    // Add the string to the array data
    for( i = 0; i < len; i++ ) data[i+array->size] = str[i];

    // Adjust the array with the new data
    array->size += len;
    array->data = data;

    // Return successfully
    return 0;
}

int32 carray_clone( carray_t *dst, carray_t *src )
{
    int32 res;

    // Make sure that some presumptions are correct
    ASSERT(src != NULL, "source array is null\n");
    ASSERT(dst != NULL, "destination array is null\n");
    ASSERT(src->data != NULL, "source array has not been allocated\n");

    // Create the destination array
    res = carray_create( dst, src->size );
    if( res != 0 )  return res;

    // Copy the source array over
    return carray_copy( dst, src );
}

int32 carray_subclone( carray_t *dst, carray_t *src, uint32 low, uint32 high )
{
    int32 res;

    // Make sure that some presumptions are correct
    ASSERT(src != NULL, "source array is null\n");
    ASSERT(dst != NULL, "destination array is null\n");
    ASSERT(src->data != NULL, "source array has not been allocated\n");
    ASSERT( low <= high, "low index is larger than high index\n" );

    // Create the destination array
    res = carray_create( dst, (high-low) );
    if( res != 0 )  return res;

    // Copy the source array over
    return carray_subcopy( dst, src, 0, low, high );
}

int32 carray_mirror( carray_t *dst, carray_t *src )
{
    // Make sure that some presumptions are correct
    ASSERT(src != NULL, "source array is null\n");
    ASSERT(dst != NULL, "destination array is null\n");
    ASSERT(src->data != NULL, "source array has not been allocated\n");

    // Mirror the source array
    dst->data  = src->data;
    dst->size  = src->size;
    dst->owner = false;

    // Return successfully
    return 0;
}

int32 carray_submirror( carray_t *dst, carray_t *src, uint32 low, uint32 high )
{
    // Make sure that some presumptions are correct
    ASSERT(src != NULL, "source array is null\n");
    ASSERT(dst != NULL, "destination array is null\n");
    ASSERT(src->data != NULL, "source array has not been allocated\n");
    ASSERT( low <= high, "low index is larger than high index\n" );

    // Cap the high value
    high = min( high, src->size );
    
    // Cap the low value
    low = min( low, high );

    // Mirror part of the source array
    dst->data  = &src->data[low];
    dst->size  = high - low;
    dst->owner = false;

    // Return successfully
    return 0;
}

int32 carray_copy( carray_t *dst, carray_t *src )
{
    // Make sure that some presumptions are correct
    ASSERT( src != NULL, "source array is null\n" );

    // Copy the source array over
    return carray_subcopy( dst, src, 0, 0, src->size );
}

int32 carray_subcopy(carray_t *dst,carray_t *src,uint32 off,uint32 low,uint32 high)
{
    uint32 i;

    // Make sure that some presumptions are correct
    ASSERT( src != NULL, "source array is null\n" );
    ASSERT( dst != NULL, "destination array is null\n" );
    ASSERT( src->data != NULL, "source array has not been allocated\n" );
    ASSERT( dst->data != NULL, "destination array has not been allocated\n" );
    ASSERT( low <= high, "low index is larger than high index\n" );
    ASSERT( off <= dst->size, "array offset larger than array size\n" );

    // Cap the high mark to the size of the arrays
    high = min( src->size, high );
    high = min( dst->size-off, high );

    // Transfer the data
    for( i = 0; i < (high-low); i++ )   dst->data[i+off] = src->data[i+low];

    // Return successfully
    return 0;
}

int32 carray_fill( carray_t *array, uint8 value )
{
    // Make sure that some presumptions are correct
    ASSERT( array != NULL, "array is null\n" );
    return carray_subfill( array, 0, array->size, value );
}

int32 carray_subfill( carray_t *array, uint32 low, uint32 high, uint8 value )
{
    uint32 i;

    // Make sure that some presumptions are correct
    ASSERT( array != NULL, "array is null\n" );
    ASSERT( array->data != NULL, "array has not been allocated\n" );

    // Fill the array
    for( i = low; i < high; i++ )  array->data[i] = value;

    // Return successfully
    return 0;
}

int32 carray_clear( carray_t *array )
{
    // Make sure that some presumptions are correct
    ASSERT( array != NULL, "array is null\n" );
    return carray_subfill( array, 0, array->size, 0 );
}

int32 carray_subclear( carray_t *array, uint32 low, uint32 high )
{
    return carray_subfill( array, low, high, 0 );
}

boolean carray_equal( carray_t *a1, carray_t *a2 )
{
    uint32 i;

    // Make sure that some presumptions are correct
    ASSERT( a1 != NULL, "first array is null\n" );
    ASSERT( a2 != NULL, "second array is null\n" );
    ASSERT( a1->data != NULL, "first array has not been allocated\n" );
    ASSERT( a2->data != NULL, "second array has not been allocated\n" );

    // If the arrays are not the same size then they are not equal
    if( a1->size != a2->size )  return false;

    // Make sure all of the elements are the same
    for( i = 0; i < a1->size; i++ ) if(a1->data[i]!=a2->data[i]) return false;

    // The arrays are equal
    return true;
}

boolean carray_subequal(carray_t *a1,carray_t *a2,uint32 off,uint32 low,uint32 high)
{
    uint32 i;

    // Make sure that some presumptions are correct
    ASSERT( a1 != NULL, "first array is null\n" );
    ASSERT( a2 != NULL, "second array is null\n" );
    ASSERT( a1->data != NULL, "first array has not been allocated\n" );
    ASSERT( a2->data != NULL, "second array has not been allocated\n" );
    ASSERT( low <= high, "low index is larger than high index\n" );

    // The arrays must be the same size to be equal
    if( (a1->size-off) < (high-low) )   return false;
    if( a2->size < high )               return false;

    // Transfer the data
    for(i=0; i<(high-low); i++) if(a1->data[i+off] != a2->data[i+low])  return false;

    // The arrays are equal
    return true;
}

void carray_random( carray_t *a, uint8 min, uint8 max )
{
    uint32 i;
    for( i = 0; i < a->size; i++ )  a->data[i] = (rand()%(max-min))+min;
}   

boolean carray_sorted( carray_t *array )
{
    uint32  i;
    boolean res;

    res = true;
    for( i = 0; i < array->size-1; i++ )
    {
        if( array->data[i] > array->data[i+1] ) {res = false; break;}
    }

    return res;
}

void carray_print( carray_t *array )
{
    uint32 i;

    for( i = 0; i < array->size; i++ )
    {
        if( i < array->size-1)  printf( "%c ", array->data[i] );
        else                    printf( "%c", array->data[i] );
    }
}

int32 carray_resize( carray_t *array, uint32 size )
{
    uint8 *data;

    // Make sure that some presumptions are correct
    ASSERT( array != NULL, "array is null\n" );
    ASSERT( array->data != NULL, "array is not allocated\n" );

    // Reallocate the array memory
    data = realloc( array->data, size );
    if( data == NULL )  return ENOMEM;

    // Setup the new data
    array->data = data;
    array->size = size;

    // Return successfully
    return 0;
}

/*
int32 carray_toiarray( iarray_t *dst, carray_t *src )
{
    // Make sure that some presumptions are correct
    ASSERT( src != NULL, "source array is null\n" );
    ASSERT( dst != NULL, "destination array is null\n" );

    // Convert the source array into the destination array
    dst->data  = (int32*)src->data;
    dst->size  = (sizeof(uint8)*src->size) / sizeof(int32);
    dst->owner = false;

    // Return successfully
    return 0;
}

int32 carray_tobarray( barray_t *dst, carray_t *src )
{
    // Make sure that some presumptions are correct
    ASSERT( src != NULL, "source array is null\n" );
    ASSERT( dst != NULL, "destination array is null\n" );

    // Not implemented yet
    return EFAULT;
}
*/
