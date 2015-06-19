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
#define ARRAY_LENGTH (100)
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
    int num_items;
    float * data_ptr;
    float * min;
    hthread_mutex_t * min_mutex;
} targ_t;


void * min_thread(void * arg)
{
    targ_t * targ = (targ_t *)(arg);
    // Calculate local minimum
    int i,end;
    float local_min = 10000000;
    float val;
    end = targ->num_items;
    for (i = 0; i < end; i++)
    {
        val = targ->data_ptr[i];
        if (val < local_min)
            local_min = val;
        
    }
    /* get permission, update min, and unlock */
    hthread_mutex_lock(targ->min_mutex);
    if ( local_min < *(targ->min))
    {
        *(targ->min) = local_min;
    }
    hthread_mutex_unlock(targ->min_mutex);

    return (void*)(10);
}


int run_tests()
{
    // Timer variables
    xps_timer_t timer;
    int time_create, time_start, time_unlock, time_stop;

    // Mutex
    hthread_mutex_t * mutex          = (hthread_mutex_t*)malloc( sizeof(hthread_mutex_t) );
    hthread_mutex_init( mutex, NULL );

    float min;

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

    extern unsigned int min_handle_offset;
    unsigned int min_handle = (min_handle_offset) + (unsigned int)(&intermediate);


// *************************************************************************************    
    printf("Code start address = 0x%08x\n", (unsigned int)&intermediate);

    int i = 0;
    float main_array[ARRAY_LENGTH];
    printf("Addr of array = 0x%08x\n",(unsigned int)&main_array[0]);
    for (i = 0; i < ARRAY_LENGTH; i++)
    {
        main_array[i] = (i+2)*3.14f;
    }


    int num_items = ARRAY_LENGTH/NUM_THREADS;
    int extra_items = ARRAY_LENGTH - (num_items*NUM_THREADS);
    float * start_addr = &main_array[0];
    for (i = 0; i < NUM_THREADS; i++)
    {
        // Initialize the attributes for the hardware threads
        hthread_attr_init( &attr[i] );
        hthread_attr_sethardware( &attr[i], (void*)base_array[i] );

        // Initialize thread arguments
        thread_arg[i].num_items = num_items;
        thread_arg[i].data_ptr = start_addr;
        thread_arg[i].min_mutex = mutex;
        thread_arg[i].min  = &min;
        start_addr+=num_items;
    }
    // Add in extra items for the last thread if needed
    thread_arg[i-1].num_items += extra_items;

    int num_ops = 0;
    for( num_ops = 0; num_ops < 2; num_ops = num_ops + 1)
    { 

        printf("******* Round %d ********\n",num_ops);
#ifdef USE_MB_THREAD
    printf("**** MB-based Threads ****\n");
#else
    printf("**** PPC-based Threads ****\n");
#endif
        min = 9999999;

        // Lock mutex before hand so that timing will not include thread creation time
        hthread_mutex_lock(mutex);

        // Start timing thread create
        time_create = xps_timer_read_counter(&timer);

        for (i = 0; i < NUM_THREADS; i++)
        {
            // Create the worker threads
#ifdef USE_MB_THREAD

            // Create MB Thread
            sta[i] = hthread_create( &tid[i], &attr[i], (void*)(min_handle), (void*)(&thread_arg[i]) );
#else
            // Create SW Thread
            sta[i] = hthread_create( &tid[i], NULL, min_thread, (void*)(&thread_arg[i]) );
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
        printf("Min = %f\n",min);
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
    for (x = 0; x < 1; x++)
    {
        run_tests();
    }
    return 0;
}
