///
/// \file sort_ecos_st_sw.c
/// Sorting application. eCos-based, single-threaded version.
///
/// \author     Enno Luebbers   <luebbers@reconos.de>
/// \date       28.09.2007
//
// This file is part of the ReconOS project <http://www.reconos.de>.
// University of Paderborn, Computer Engineering Group.
//
// (C) Copyright University of Paderborn 2007.
//

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <arch/cache.h>
#include "setup.h"
#include "bubblesort.h"
#include "merge.h"
#include "data.h"
#include "timing.h"


unsigned int buf_a[SIZE] __attribute__ ( ( aligned( 32 ) ) );   // align sort buffers to cache lines
unsigned int buf_b[SIZE];       // buffer for merging
unsigned int *data;

void enable_cache()
{
    printf( "enabling data cache for external ram\n" );
    dcache_enable( 0xC0000000 );
    icache_enable( 0xFFFFFFFF );
}

void disable_cache()
{
    printf( "data cache disabled\n" );
    dcache_disable();
    //ppc405_icache_enable( 0xFFFFFFFF );
}

void setup_cache()
{
#ifdef USE_CACHE
    enable_cache();
#else
    disable_cache();
#endif
}

int main( int argc, char *argv[] )
{

    unsigned int i;
    hthread_time_t t_start = 0, t_stop = 0, t_gen = 0, t_sort = 0, t_merge =
        0, t_check = 0;

    setup_cache();
    printf( "-------------------------------------------------------\n"
            "ReconOS hardware multithreading case study (sort)\n"
            "(c) Computer Engineering Group, University of Paderborn\n\n"
            "eCos, single-threaded software version (" __FILE__ ")\n"
            "Compiled on " __DATE__ ", " __TIME__ ".\n"
            "-------------------------------------------------------\n\n" );

    data = buf_a;

    //----------------------------------
    //-- GENERATE DATA
    //----------------------------------
    printf( "Generating data..." );
    t_start = gettime(  );
    generate_data( data, SIZE );
    t_stop = gettime(  );
    t_gen = calc_timediff_ms( t_start, t_stop );
    printf( "done\n" );

    //----------------------------------
    //-- SORT DATA
    //----------------------------------
    printf( "Sorting data..." );
    for ( i = 0; i < SIZE; i += N ) {
        t_start = gettime(  );
        bubblesort( &data[i], N );
        t_stop = gettime(  );
        t_sort += calc_timediff_ms( t_start, t_stop );
    }
    printf( "done\n" );

    //----------------------------------
    //-- MERGE DATA
    //----------------------------------
    printf( "Merging data..." );
    t_start = gettime(  );
    data = recursive_merge( data, buf_b, SIZE, N, simple_merge );
    t_stop = gettime(  );
    t_merge = calc_timediff_ms( t_start, t_stop );
    printf( "done\n" );

    //----------------------------------
    //-- CHECK DATA
    //----------------------------------
    printf( "Checking sorted data..." );
    t_start = gettime(  );
    if ( check_data( data, SIZE ) != 0 )
        printf( "CHECK FAILED!\n" );
    else
        printf( "check successful.\n" );
    t_stop = gettime(  );
    t_check = calc_timediff_ms( t_start, t_stop );

    printf( "\nRunning times (size: %lu words):\n"
            "\tGenerate data: %llu ms\n"
            "\tSort data    : %llu ms\n"
            "\tMerge data   : %llu ms\n"
            "\tCheck data   : %llu ms\n"
            "\nTotal computation time (sort & merge): %llu ms\n",
            SIZE, t_gen, t_sort, t_merge, t_check, t_sort + t_merge );

    return 0;
}
