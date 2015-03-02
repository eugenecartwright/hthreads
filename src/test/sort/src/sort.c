#include <hthread.h>
#include <sort.h>
#include <stdlib.h>
#include <stdio.h>

// A global variable to store the cut off value for direct vs. recursive sort.
Huint sort_cutoff;

Hint sort_init( void )
{
    // Set the cut off value to something reasonable
    sort_cutoff = 50;

    // Return successfully
    return 0;
}

Hint sort_finish( void )
{
    // Return successfully
    return 0;
}

extern void sort_setcutoff( Huint cutoff )
{
    // Set the new cutoff value
    sort_cutoff = cutoff;
}

extern Huint sort_getcutoff( void )
{
    // Return the cut off value
    return sort_cutoff;
}

Hint sort_setup( sort_t *sort, Huint size )
{
    // Make sure that the sort structure is valid
    if( sort == NULL )  return -1;

    // Make sure that the requested size is valid
    if( size <= 0 )     return -2;

    // Attempt to allocate memory for the data
    sort->data = (Huint*)malloc( size * sizeof(Huint) );

    // Make sure that the allocated memory is valid
    if( sort->data == NULL )    return -3;

    // Store the default range in the structure
    sort->size  = size;

    // Return successfully
    return 0;
}

Hint sort_destroy( sort_t *sort )
{
    // Make sure that the sort structure is valid
    if( sort == NULL )  return -1;

    // Free the previously allocated memory
    free( sort->data );

    // Return successfully
    return 0;
}

Hint sort_copy( sort_t *src, sort_t *dst, Huint start, Huint size )
{
    Huint i;
    Huint ret;

    // Initialize the destination
    ret = sort_setup( dst, size );
    if( ret < 0 )   return ret;

    // Copy data over from the
    for( i = 0; i < size; i++ ) dst->data[i] = src->data[start + i];

    // Return successfully
    return 0;
}

Hint sort_fill( sort_t *sort, Huint min, Huint max )
{
    Huint i;
    Huint diff;

    // Calculate the difference between min and max
    diff = max - min;

    // Fill in the data
    for( i = 0; i < sort->size; i++ )   sort->data[i] = (rand() % diff) + min;

    // Return successfully
    return 0;
}

Hint sort_show( sort_t *sort )
{
    Huint i;

    // Show the data
    for( i = 0; i < sort->size; i++ )
    {
        if( i % ENDLINE == 0 )  printf( "\n" );
        printf( "%4.4d ", sort->data[i] );
    }
    
    printf( "\n" );

    // Return successfully
    return 0;
}

Hint sort_verify( sort_t *sort )
{
    Huint i;

    for( i = 0; i < sort->size-1; i++ )
    {
        if( sort->data[i] > sort->data[i+1] )   return -1;
    }

    return 0;
}

void sort_merge( sort_t *sort, sort_t *left, sort_t *right )
{
    Huint i;
    Huint l;
    Huint r;

    // Initialize the left and the right
    i = 0;
    l = 0;
    r = 0;

    // Merge the two arrays back together
    for( i = 0; i < sort->size; i++ )
    {
        if( l == left->size )                       sort->data[i] = right->data[r++];
        else if( r == right->size )                 sort->data[i] = left->data[l++];
        else if( left->data[l] < right->data[r] )   sort->data[i] = left->data[l++];
        else                                        sort->data[i] = right->data[r++];
    }
}

void sort_recursive( sort_t *sort )
{
    Huint       lend;
    sort_t      left;
    sort_t      right;
    hthread_t   left_thread;
    hthread_t   right_thread;

    // Break the original array into two copies
    lend = sort->size/2;
    sort_copy( sort, &left, 0, lend );
    sort_copy( sort, &right, lend, sort->size-lend );

    // Create threads to sort the two halves of the array
    hthread_create( &left_thread, NULL, sort_thread, (void*)&left );
    hthread_create( &right_thread, NULL, sort_thread, (void*)&right );

    // Wait for sorting threads to finish
    hthread_join( left_thread, NULL );
    hthread_join( right_thread, NULL );

    // Merge the two array halves back together
    sort_merge( sort, &left, &right );
}

void sort_direct( sort_t *sort )
{
    int     i;
    int     j;
    Huint   min;
    Huint   tmp;

    for( i = 0; i < sort->size; i++ )
    {
        // The first value is the minimum so far
        min = i;

        // Find the minimum value in the rest of the array
        for( j = i+1; j < sort->size; j++ )
        {
            if( sort->data[j] < sort->data[min] )   min = j;
        }

        // Swap the minimum into the current location
        tmp = sort->data[i];
        sort->data[i] = sort->data[min];
        sort->data[min] = tmp;
    }
}

void* sort_thread( void *arg )
{
    sort_t  *sort;

    // Cast the argument to a sort structure
    sort = (sort_t*)arg;

    // Determine if we can sort this directly
    if( sort->size < sort_cutoff )  sort_direct( sort );
    else                            sort_recursive( sort );

    // Return the sort structure
    return sort;
}
