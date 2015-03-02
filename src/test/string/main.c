/*****************************************************************************
 * Boyer/Moore String Maching Algorithm
 *****************************************************************************/
#include <hthread.h>
#include <string/boyermoore.h>
#include <string/time.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#include "books/beowulf.c"
#include "books/britannica1.c"
#include "books/britannica2.c"
#include "books/britannica3.c"
#include "books/caesar.c"
#include "books/hamlet.c"
#include "books/huckfinn.c"
#include "books/illiad.c"
#include "books/macbeth.c"
#include "books/pride.c"
#include "books/sense.c"
#include "books/tomsawyer.c"
#include "books/twist.c"
#include "books/ulysses.c"
#include "books/venice.c"

const char *tar[]       = { "the",   "and",    "or",    "Caesar", "also",
                            "were",  "all",    "draw",  "late",   "left",
                            "that",  "on",     "how",   "when",   "I",
                            "them",  "but",    "might", "story",  "farm",
                            "never", "see",    "next",  "will",   "such",
                            "are",   "than",   "know",  "my",     "people",
                            "unto",  "be",     "you",   "me",     "not",
                            "of",    "to",     "any",   "find",   "let",
                            "has",   "they",   "hot",   "time",   "these",
                            "again", "last",   "part",  "work",   "school",
                            "most",  "get",    "after", "while",  "eye",
                            "never", "Wesley", "Jason", "Perry",  "Seth",
                            "take",  "little", "show",  "few",    "life",
                            "give",  "Dave" };
const int tarsize       = sizeof(tar) / sizeof(char*);

typedef struct
{
    carray_t *search;
    carray_t target;
    bmoore_t bm;
    int32    found;
    int32    locs[256*1024];
} arg_t;

void calculate_rate( char **suf, real32 *val, real32 secs, uint32 size )
{
    *val = size/secs;
    *suf = "/s";

    if( *val > 1024*1024*1024 ) { *val /= 1024*1024*1024; *suf="G/s"; }
    else if( *val > 1024*1024 ) { *val /= 1024*1024; *suf="M/s"; }
    else if( *val > 1024 )      { *val /= 1024; *suf="K/s"; }
}

void calculate_time( char **suf, real32 *val, real32 secs )
{
    *val = secs;
    *suf = "s";

    if( *val > 60*60*24 )                { *val /= 60*60*24; *suf = "d"; }
    else if( *val > 60*60 )              { *val /= 60*60; *suf = "h"; }
    else if( *val > 60 )                 { *val /= 60; *suf = "m"; }
    else if( *val < 1/(1000*1000) )      { *val *= 1000*1000*1000; *suf="ns"; }
    else if( *val < 1/(1000) )           { *val *= 1000*1000; *suf="us"; }
    else if( *val < 1 )                  { *val *= 1000; *suf="ms"; }
}

void calculate_size( char **suf, real32 *val, uint32 size )
{
    if( size > 1024*1024*1024 ) { *suf = "GB"; *val = size/1024*1024*1024.0; }
    else if( size > 1024*1024 ) { *suf = "MB"; *val = size/1024*1024.0; }
    else if( size > 1024 )      { *suf = "KB"; *val = size/1024.0; }
    else                        { *suf = "B";  *val = size; }
}

void* search( void *arg )
{
    int32    i;
    arg_t    *srch;
    int32 found = 0;

    i    = 0;
    srch = (arg_t*)arg;
    while( 1 )
    {
        srch->locs[i] = boyermoore_search( &srch->bm, srch->search );


        if( srch->locs[i] < 0 ) break;
        i++;
        found++;
    }

    return (void*)found;
}

int main( int argc, char *argv[] )
{
    int32     k;
    char      *tsuf;
    timing_t  start;
    timing_t  end;
    timing_t  diff;
    real32    time;
    real32    secs;
    carray_t  haystack;
    hthread_t *threads;
    arg_t     *args;

    // Allocate the threads structure
    threads = (hthread_t*)malloc( tarsize * sizeof(hthread_t) );

    // Allocate the argument structures
    args    = (arg_t*)malloc( tarsize * sizeof(arg_t) );

    // Create arrays for the search string
    carray_fromstr( &haystack, beowulf );
    carray_concatstr( &haystack, britannica1 );
    carray_concatstr( &haystack, britannica2 );
    carray_concatstr( &haystack, britannica3 );
    carray_concatstr( &haystack, caesar );
    carray_concatstr( &haystack, hamlet );
    carray_concatstr( &haystack, huckfinn );
    carray_concatstr( &haystack, illiad );
    carray_concatstr( &haystack, macbeth );
    carray_concatstr( &haystack, pride );
    carray_concatstr( &haystack, sense );
    carray_concatstr( &haystack, tomsawyer );
    carray_concatstr( &haystack, twist );
    carray_concatstr( &haystack, ulysses );
    carray_concatstr( &haystack, venice );


    // Create all of the thread arguments
    for( k = 0; k < tarsize; k++ )
    {
        args[k].search = &haystack;
        args[k].found  = 0;
        carray_fromstr( &args[k].target, tar[k] );
        boyermoore_init( &args[k].bm, &args[k].target );
    }

    // Create worker threads for all of the search strings
    timing_get( &start );
    for( k = 0; k < tarsize; k++ )
    {
        hthread_create( &threads[k], NULL, search, &args[k] );
    }

    // Wait for all of the worker threads to complete
    for( k = 0; k < tarsize; k++ )
    {
        hthread_join( threads[k], (void*)&args[k].found );
    }
    timing_get( &end );
    timing_diff(diff,end,start);
    secs = timing_sec(diff);
    calculate_time( &tsuf, &time, secs );
    printf( "Test Finished: %.2f %s\n", time, tsuf );

    // Show the results and destroy the thread arguments
    for( k = 0; k < tarsize; k++ )
    {
        printf( "Thread %d found %d matches of the string '%s'\n", k, args[k].found, tar[k] );
        boyermoore_destroy( &args[k].bm );
        carray_destroy( &args[k].target );
    }

    // Exit the program
    return 0;
}
