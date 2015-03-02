///
/// \file sort_ecos_mt_sw.c
/// Sorting application. hthreads-based, multi-threaded version.
///
/// \author     Enno Luebbers   <luebbers@reconos.de>
/// \date       28.09.2007
//
// This file is part of the FSMLang project <http://www.reconos.de>.
// CSDL-UARK, Computer Engineering Group.
//
// (C) Copyright CSDL-UARK 2007.
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
#include "sort8k_no_globals.h"
#include "merge_no_globals.h"
#include "data.h"
#include "timing.h"
#include "mailbox_no_globals.h"
#include <util/rops.h>

#define HWTI_BASEADDR (void*)(0x63000000)

unsigned int buf_a[SIZE] __attribute__ ( ( aligned( 32 ) ) );   // align sort buffers to cache lines
unsigned int buf_b[SIZE];       // buffer for merging
unsigned int *data;

hthread_t thread_sorter[MT_SW_NUM_THREADS];
//hthread_t thread_sorter[10];    // MAX_VALUE

void enable_cache()
{
    printf( "enabling data cache for external ram\n" );
    //ppc405_dcache_enable( 0xC0003FFF ); // What should the regions be to cache the burst RAM
    //ppc405_icache_enable( 0xFFFFFFFF );
    XCache_EnableICache(0x40000001);
    XCache_EnableDCache(0x40000001);
}

void disable_cache()
{
    printf( "data cache disabled\n" );
    //ppc405_dcache_disable();
    //ppc405_icache_enable( 0xFFFFFFFF );
    XCache_EnableICache(0x40000001);
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

void readHWTStatus() {
    printf( "  HWT Thread ID %x \n", read_reg(HWTI_BASEADDR) );
    printf( "  HWT Timer %d \n", read_reg(HWTI_BASEADDR + 0x00000004) );
    printf( "  HWT Status  %x \n", read_reg(HWTI_BASEADDR + 0x00000008) );
    printf( "  HWT Command %x \n", read_reg(HWTI_BASEADDR + 0x0000000C) );
    printf( "  HWT Argument %x \n", read_reg(HWTI_BASEADDR + 0x00000010) );
    printf( "  HWT Result %x \n", read_reg(HWTI_BASEADDR + 0x00000014) );
    printf( "  HWT DEBUG SYSTEM %x \n", read_reg(HWTI_BASEADDR + 0x00000018) );
    printf( "  HWT DEBUG USER %x \n", read_reg(HWTI_BASEADDR + 0x0000001C) );
    printf( "  HWT Stack Pointer %x \n", read_reg(HWTI_BASEADDR + 0x00000028) );
    printf( "  HWT Frame Pointer %x \n", read_reg(HWTI_BASEADDR + 0x0000002C) );
    printf( "  HWT Heap Pointer %x \n", read_reg(HWTI_BASEADDR + 0x00000030) );
}

int main( int argc, char *argv[] )
//int run_test( int number_of_threads, int use_hw )
{

    sortarg_t arg;
    unsigned int i, start_count = 0, done_count = 0;
    hthread_time_t t_start = 0, t_stop = 0, t_gen = 0, t_sort = 0, t_merge =
        0, t_check = 0, t_tmp;

    int use_hw;
    int number_of_threads = MT_SW_NUM_THREADS;
#ifdef USE_HW_THREAD
    use_hw = 1;
#else
    use_hw = 0;
#endif

    printf( "-------------------------------------------------------\n"
            "FSMLang hardware multithreading case study (sort)\n"
            "(c) Computer Engineering Group, CSDL-UARK\n"
            "hthreads, multi-threaded software version (" __FILE__ ")\n"
            "Compiled on " __DATE__ ", " __TIME__ ".\n"
            "use_hw = %d, number of threads = %d.\n"
            "-------------------------------------------------------\n\n", use_hw, number_of_threads );
            //"-------------------------------------------------------\n\n", USE_HW_THREAD, MT_SW_NUM_THREADS );

    setup_cache();
    data = buf_a;

    printf("Address of array = 0x%08x\n",(unsigned int)buf_a);

	hthread_attr_t attrBase;
	hthread_attr_init( &attrBase );
    printf("Number of thread(s) = %d\n",MT_SW_NUM_THREADS);
    //printf("Number of thread(s) = %d\n",number_of_threads);

#ifdef USE_HW_THREAD
    printf("*** Using HW Thread ****!!!\n");
    hthread_attr_sethardware( &attrBase, HWTI_BASEADDR );
#else
    printf("*** Using SW Thread ****!!!\n");
#endif

/*
    if (use_hw)
    {
        printf("*** Using HW Thread ****!!!\n");
        hthread_attr_sethardware( &attrBase, HWTI_BASEADDR );
    }
    else
    {
        printf("*** Using SW Thread ****!!!\n");
    }
*/
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
    int mutexnum = 0;
    int condnum = 0;
    mailbox_init_no_globals(mutexnum++,condnum++, &arg.mb_start, SIZE/N );
    mailbox_init_no_globals(mutexnum++,condnum++, &arg.mb_done, SIZE/N );

    // create sorting threads
    for ( i = 0; i < MT_SW_NUM_THREADS; i++ ) {
    //for ( i = 0; i < number_of_threads; i++ ) {
/*        if (i == 0)
        {
#ifdef USE_HW_THREAD
            printf("$$$ Creating HW Thread $$$\n");
            hthread_create( &thread_sorter[i], NULL, sort8k_entry2, (void*)&arg );
#else
            printf("$$$ Creating SW Thread $$$\n");
#endif
            //hthread_create( &thread_sorter[i], &attrBase, sort8k_entry, (void*)&arg );
            hthread_create( &thread_sorter[i], NULL, sort8k_entry, (void*)&arg );
        }
        else
        {
            printf("$$$ Creating SW Thread $$$\n");
            hthread_create( &thread_sorter[i], NULL, sort8k_entry, (void*)&arg );
        }
*/
#ifdef USE_HW_THREAD
            hthread_create( &thread_sorter[i], NULL, sort8k_entry2, (void*)&arg );
#else
            hthread_create( &thread_sorter[i], NULL, sort8k_entry, (void*)&arg );
#endif

/*
        if (use_hw) {
            hthread_create( &thread_sorter[i], NULL, sort8k_entry2, (void*)&arg );
        }
        else{
            hthread_create( &thread_sorter[i], NULL, sort8k_entry, (void*)&arg );
        }
*/
    
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
    //printf( "Sorting data..." );
    i = 0;
    while ( done_count < SIZE / N ) {
        t_start = gettime(  );
        // if we have something to distribute,
        // put as many as possile into the start mailbox
        while ( start_count < SIZE / N ) {
            //printf( "Writing data...\n" );
            if( mailbox_trywrite( &arg.mb_start, &data[i] ) == 0 ) {
                //printf( "success\n" );
                start_count++;
                i += N;
            } else {                                                           // mailbox full
                //printf( "full\n" );
                break;
            }
        }
        t_stop = gettime(  );
        t_sort += calc_timediff_ms( t_start, t_stop );
        // see whether anybody's done
        t_start = gettime(  );
        //printf( "Waiting for read...\n" );
        //readHWTStatus();
        if( (t_tmp = (unsigned int)mailbox_read( &arg.mb_done ) != 0 ) ) {
            //printf( "recieved\n" );
            done_count++;
        } else {
            printf( "cyg_mbox_get returned NULL!\n" );
        }
        t_stop = gettime(  );
        t_sort += calc_timediff_ms( t_start, t_stop );
        //printf( "**************\n" );
    }
    //printf( "done\n" );

    //----------------------------------
    //-- MERGE DATA
    //----------------------------------
    //printf( "Merging data..." );
    t_start = gettime(  );
    data = recursive_merge( data, buf_b, SIZE, N, simple_merge );
    t_stop = gettime(  );
    t_merge = calc_timediff_ms( t_start, t_stop );
    //printf( "done\n" );

    //----------------------------------
    //-- CHECK DATA
    //----------------------------------
    //printf( "Checking sorted data..." );
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
/*
int main()
{

    run_test(1,0);
    run_test(2,0);
    run_test(3,0);
    run_test(4,0);
    run_test(1,1);
    run_test(2,1);
    run_test(3,1);
    run_test(4,1);

    return 0;
}
*/
