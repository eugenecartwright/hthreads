/************************************************************************************
* Copyright (c) 2015, University of Arkansas - Hybridthreads Group
* All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
* 
*     * Redistributions of source code must retain the above copyright notice,
*       this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright notice,
*       this list of conditions and the following disclaimer in the documentation
*       and/or other materials provided with the distribution.
*     * Neither the name of the University of Arkansas nor the name of the
*       Hybridthreads Group nor the names of its contributors may be used to
*       endorse or promote products derived from this software without specific
*       prior written permission.
* 
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
* ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
************************************************************************************/

#include <hthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <util/rops.h>
#include <arch/cache.h>
#include <arch/memory.h>
#include <xcache_l.h>
#include "time_lib.h"

#define NUM_THREADS     (6)
#define NUM_INTERVALS (1000)
#define USE_MB_THREAD

// The base addresses of the hardware thread we are creating
#define HWTI_BASEADDR0               (0xB0000000)
#define HWTI_BASEADDR1               (0xB0000100)
#define HWTI_BASEADDR2               (0xB0000200)
#define HWTI_BASEADDR3               (0xB0000300)
#define HWTI_BASEADDR4               (0xB0000400)
#define HWTI_BASEADDR5               (0xB0000500)
#define HWTI_BASEADDR6               (0xB0000600)
#define HWTI_BASEADDR7               (0xB0000700)
#define HWTI_BASEADDR8               (0xB0000800)
#define HWTI_BASEADDR9               (0xB0000900)

#define NUM_CPUS        (10)
unsigned int base_array[NUM_CPUS] = {HWTI_BASEADDR0, HWTI_BASEADDR1, HWTI_BASEADDR2, HWTI_BASEADDR3, HWTI_BASEADDR4, HWTI_BASEADDR5, HWTI_BASEADDR6, HWTI_BASEADDR7, HWTI_BASEADDR8, HWTI_BASEADDR9};

typedef struct
{
    int num_threads;
    int num_intervals;
    int data;
    double * pi;    
    hthread_mutex_t * pi_mutex;
} targ_t;


void * pi_thread(void * arg)
{
    targ_t * targ = (targ_t *)(arg);
    int id;
    int threads;
    int intervals;

    // Get TID
    id = hthread_self();

    // Extract arguments
    threads = targ->num_threads;
    intervals = targ->num_intervals;

    // Approximate Pi
    register double width, localsum;
    register int i;
    register int iproc = (int)targ->data;

    // set width
    width = 1.0 / intervals;


    /* do the local computations */
    localsum = 0;
    for (i = iproc; i < intervals; i += threads)
    {
        register double x = (i + 0.5) * width;
        localsum += 4.0 / (1.0 + x * x);
    }
    localsum *= width;

    /* get permission, update pi, and unlock */
    hthread_mutex_lock(targ->pi_mutex);
    *(targ->pi) += localsum;
    hthread_mutex_unlock(targ->pi_mutex);

    return (void*)id;
}


int run_tests()
{
    // Timer variables
    xps_timer_t timer;
    int time_create, time_start, time_unlock, time_stop;

    // Mutex
    hthread_mutex_t * mutex          = (hthread_mutex_t*)malloc( sizeof(hthread_mutex_t) );
    hthread_mutex_init( mutex, NULL );

    double pi;

    // Thread attribute structures
    Huint           sta[NUM_THREADS];
    void*           retval[NUM_THREADS];
    hthread_t       tid[NUM_THREADS];
    hthread_attr_t  attr[NUM_THREADS];
    targ_t thread_arg[NUM_THREADS];

    // Setup Cache
    XCache_DisableDCache();
    XCache_EnableICache(0xc0000801);

    // Create timer
    xps_timer_create(&timer, (int*)0x20400000);

    // Start timer
    xps_timer_start(&timer);

// *************************************************************************************    
    extern unsigned char intermediate[];

    extern unsigned int pi_handle_offset;
    unsigned int pi_handle = (pi_handle_offset) + (unsigned int)(&intermediate);


// *************************************************************************************    

    printf("Code start address = 0x%08x\n", (unsigned int)&intermediate);

    int i = 0;
    for (i = 0; i < NUM_THREADS; i++)
    {
        // Initialize the attributes for the hardware threads
        hthread_attr_init( &attr[i] );
        hthread_attr_sethardware( &attr[i], (void*)base_array[i] );

        // Initialize thread arguments
        thread_arg[i].num_threads = NUM_THREADS;
        thread_arg[i].num_intervals = NUM_INTERVALS;
        thread_arg[i].data = i;
        thread_arg[i].pi_mutex = mutex;
        thread_arg[i].pi  = &pi;
    }

    int num_ops = 0;
    for( num_ops = 0; num_ops < 2; num_ops = num_ops + 1)
    { 

        printf("******* Round %d ********\n",num_ops);
#ifdef USE_MB_THREAD
    printf("**** MB-based Threads ****\n");
#else
    printf("**** PPC-based Threads ****\n");
#endif
        pi = 0;

        // Lock mutex before hand so that timing will not include thread creation time
        hthread_mutex_lock(mutex);

        // Start timing thread create
        time_create = xps_timer_read_counter(&timer);

        for (i = 0; i < NUM_THREADS; i++)
        {
            // Create the worker threads
#ifdef USE_MB_THREAD

            // Create MB Thread
            sta[i] = hthread_create( &tid[i], &attr[i], (void*)(pi_handle), (void*)(&thread_arg[i]) );
#else
            // Create SW Thread
            sta[i] = hthread_create( &tid[i], NULL, pi_thread, (void*)(&thread_arg[i]) );
#endif
        }

        // Allow created threads to begin running and start timer
        time_start = xps_timer_read_counter(&timer);
        hthread_mutex_unlock(mutex);
        time_unlock = xps_timer_read_counter(&timer);

        // Wait for the threads to exit
		//printf( "Waiting for thread(s) to complete... \n" );
        for (i = 0; i < NUM_THREADS; i++)
        {
    	    hthread_join( tid[i], &retval[i] );
        }

        time_stop = xps_timer_read_counter(&timer);

        // Display results
        printf("Pi = %f\n",pi);
        for (i = 0; i < NUM_THREADS; i++)
        {
            printf("TID = 0x%08x, status = 0x%08x, retval = 0x%08x\n",tid[i],sta[i],(Huint)retval[i]);
        }
        printf("*********************************\n");
        printf("Create time  = %u\n",time_create);
        printf("Start time   = %u\n",time_start);
        printf("Unlock time  = %u\n",time_unlock);
        printf("Stop time    = %u\n",time_stop);
        printf("*********************************\n");
        printf("Creation time (|Start - Create|) = %u\n",time_start - time_create);
        printf("Unlock time (|Unlock - Start|)   = %u\n",time_unlock - time_start);
        printf("Elapsed time  (|Stop - Start|)   = %u\n",time_stop - time_start);

    }

    hthread_mutex_destroy( mutex );
    free( mutex );

    // Clean up the attribute structures
    for (i = 0; i < NUM_THREADS; i++)
    {
        hthread_attr_destroy( &attr[i] );
    }
    printf ("-- Complete --\n");

    // Return from main
    return 0;
}

int main()
{
    int x;
    for (x = 0; x < 2; x++)
    {
        run_tests();
    }
    return 0;
}
