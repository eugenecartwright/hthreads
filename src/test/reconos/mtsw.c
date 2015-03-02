///
/// \file sort_ecos_mt_sw.c
/// Sorting application. eCos-based, multi-threaded version.
///
/// \author     Enno Luebbers   <luebbers@reconos.de>
/// \date       28.09.2007
//
// This file is part of the ReconOS project <http://www.reconos.de>.
// University of Paderborn, Computer Engineering Group.
//
// (C) Copyright University of Paderborn 2007.
//

//#include <cyg/infra/diag.h>
//#include <cyg/infra/cyg_type.h>
//#include <cyg/kernel/kapi.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <arch/cache.h>
#include <xcache_l.h>
#include <hthread.h>
#include "setup.h"
#include "sort8k.h"
#include "merge.h"
#include "data.h"
#include "timing.h"
#include "mailbox.h"


unsigned int buf_a[SIZE] __attribute__ ( ( aligned( 32 ) ) );   // align sort buffers to cache lines
unsigned int buf_b[SIZE];       // buffer for merging
unsigned int *data;

mailbox_t mb_start, mb_done;
//cyg_mbox mb_start, mb_done;
//cyg_handle_t mb_start_handle, mb_done_handle;

hthread_t thread_sorter[MT_SW_NUM_THREADS];
//cyg_thread thread_sorter[MT_SW_NUM_THREADS];
//cyg_handle_t thread_sorter_handle[MT_SW_NUM_THREADS];
//char thread_sorter_stack[MT_SW_NUM_THREADS][STACK_SIZE];

void enable_cache()
{
    printf( "enabling data cache for external ram\n" );
    //ppc405_dcache_enable( 0xC0000000 );
    //ppc405_dcache_enable( 0xC0003FFF ); // What should the regions be to cache the burst RAM
    //ppc405_icache_enable( 0xFFFFFFFF );
    XCache_EnableICache(0xFFFFFFFF);
    XCache_EnableDCache(0x40000001);
}

void disable_cache()
{
    printf( "data cache disabled\n" );
    //ppc405_dcache_disable();
    //ppc405_icache_enable( 0xFFFFFFFF );
    XCache_EnableICache(0xFFFFFFFF);
    XCache_DisableDCache();
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

    unsigned int i, start_count = 0, done_count = 0;
    hthread_time_t t_start = 0, t_stop = 0, t_gen = 0, t_sort = 0, t_merge =
        0, t_check = 0, t_tmp;

    printf( "-------------------------------------------------------\n"
            "ReconOS hardware multithreading case study (sort)\n"
            "(c) Computer Engineering Group, University of Paderborn\n\n"
            "eCos, multi-threaded software version (" __FILE__ ")\n"
            "Compiled on " __DATE__ ", " __TIME__ ".\n"
            "-------------------------------------------------------\n\n" );

    setup_cache();
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
    // create mail boxes for 'start' and 'complete' messages
    mailbox_init( &mb_start, SIZE/N );
    mailbox_init( &mb_done, SIZE/N );
    //cyg_mbox_create( &mb_start_handle, &mb_start );
    //cyg_mbox_create( &mb_done_handle, &mb_done );
    // create sorting threads
    for ( i = 0; i < MT_SW_NUM_THREADS; i++ ) {
        hthread_create( &thread_sorter[i], NULL, sort8k_entry, NULL );
        /*
        cyg_thread_create( 16,                        // priority
                           sort8k_entry,              // entry point
                           ( cyg_addrword_t ) i,      // entry data
                           "MT_SW_SORT",              // thread name
                           thread_sorter_stack[i],    // stack
                           STACK_SIZE,                // stack size
                           &thread_sorter_handle[i],  // thread handle
                           &thread_sorter[i]          // thread object
             );
        cyg_thread_resume( thread_sorter_handle[i] );
        */
    }
//    printf( "Sorting data..." );
    i = 0;
    while ( done_count < SIZE / N ) {
        t_start = gettime(  );
        // if we have something to distribute,
        // put as many as possile into the start mailbox
        while ( start_count < SIZE / N ) {
  //          printf( "Writing data...\n" );
            if( mailbox_trywrite( &mb_start, &data[i] ) == 0 ) {
            //    printf( "success\n" );
                start_count++;
                i += N;
            } else {                                                           // mailbox full
    //            printf( "full\n" );
                break;
            }
        }
        t_stop = gettime(  );
        t_sort += calc_timediff_ms( t_start, t_stop );
        // see whether anybody's done
        t_start = gettime(  );
      //  printf( "Waiting for read...\n" );
        if( (t_tmp = (unsigned int)mailbox_read( &mb_done ) != 0 ) ) {
        //    printf( "recieved\n" );
            done_count++;
        } else {
          //  printf( "cyg_mbox_get returned NULL!\n" );
        }
        t_stop = gettime(  );
        t_sort += calc_timediff_ms( t_start, t_stop );
    }
//    printf( "done\n" );

    //----------------------------------
    //-- MERGE DATA
    //----------------------------------
  //  printf( "Merging data..." );
    t_start = gettime(  );
    data = recursive_merge( data, buf_b, SIZE, N, simple_merge );
    t_stop = gettime(  );
    t_merge = calc_timediff_ms( t_start, t_stop );
  //  printf( "done\n" );

    //----------------------------------
    //-- CHECK DATA
    //----------------------------------
    //printf( "Checking sorted data..." );
    t_start = gettime(  );
    if ( check_data( data, SIZE ) != 0 )
        printf( "CHECK FAILED!\n" );
    //else
      //  printf( "check successful.\n" );
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
