/*****************************************************************************
 * Boyer/Moore String Maching Algorithm
 *****************************************************************************/
#include <string/boyermoore.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>

static void boyermoore_badshift( bmoore_t *bm )
{
    int32 i;

    // Initialize the shift values in the table
    for(i=0; i<256; i++) bm->bad[i] = -1;

    // Calculate the bad match shift based on the needle
    for(i=0; i<bm->needle->size-1; i++) bm->bad[bm->needle->data[i]] = i;
}

static void boyermoore_goodshift( bmoore_t *bm )
{
    int32 i;
    int32 j;
    int32 *f;

    // Allocate space for the temporary array
    f = (int32*)malloc( (bm->needle->size+1)*sizeof(int32) );

    i = bm->needle->size;
    j = i + 1;

    f[i] = j;
    while( i > 0 )
    {
        while( j <= bm->needle->size && bm->needle->data[i-1] != bm->needle->data[j-1] )
        {
            if( bm->good[j] == 0 ) bm->good[j]=j-i;
            j=f[j];
        }

        i--;
        j--;
        f[i] = j;
    }

    j = f[0];
    for( i = 0; i <= bm->needle->size; i++ )
    {
        if( bm->good[i] == 0 ) bm->good[i] = j;
        if( i == j )        j = f[j];
    }

    // Deallocate the temporary array
    free( f );
}

int32 boyermoore_init( bmoore_t *bm, carray_t *needle )
{
    // Attempt to allocate memory for the tables
    bm->mem = (int32*)malloc( (needle->size+256+1)*sizeof(int32) );
    if( bm->mem == NULL ) return ENOMEM;

    // Store the pointers to the good and bad shift tables
    bm->bad  = bm->mem;
    bm->good = bm->mem + 256;

    // Store the pointer to the needle data
    bm->needle = needle;

    // Calculate the good and bad shift tables
    boyermoore_badshift( bm );
    boyermoore_goodshift( bm );

    // Setup the initial search location
    bm->loc = 0;

    // Return successfully
    return 0;
}

int32 boyermoore_reset( bmoore_t *bm )
{
    bm->loc = 0;
    return 0;
}

int32 boyermoore_destroy( bmoore_t *bm )
{
    // Free the memory used by the shift tables;
    if( bm->mem != NULL ) free( bm->mem );

    // Destroy the boore moore structure
    bm->mem    = NULL;
    bm->bad    = NULL;
    bm->good   = NULL;
    bm->needle = NULL;

    // Return successfully
    return 0;
}

int32 boyermoore_search( bmoore_t *bm, carray_t *hay )
{
    int32 j;
    int32 v;

    // Perform the string searching
    while( bm->loc <= hay->size - bm->needle->size )
    {
        // Attempt to match the string from right to left
        for( j=bm->needle->size-1; j>=0 && bm->needle->data[j]==hay->data[bm->loc+j]; --j );

        if( j < 0 )
        {
            // Store the location of the match
            v = bm->loc;

            // Update the next location to search at
            bm->loc += bm->good[0];

            // Return the matched location
            return v;
        }
        else 
        {
            v = hay->data[bm->loc+j];
            bm->loc += max(bm->good[j+1], j-bm->bad[v]);
        }
    }

    // No match was found
    return -1;
}

int32 string_boyermoore( carray_t *needle, carray_t *hay )
{
    return 0;
}

