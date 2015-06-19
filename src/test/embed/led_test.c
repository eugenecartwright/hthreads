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

// The base addresses of the hardware thread we are creating
#define HWTI_BASEADDR0               (0xB0000000)
#define HWTI_BASEADDR1               (0xB0000100)


#define NUM_THREADS     (2)
#define USE_MB_THREAD
#define MY_DEBUG

unsigned int base_array[NUM_THREADS] = {HWTI_BASEADDR0, HWTI_BASEADDR1};

// Function pointer Definition
typedef void * (*FuncPointer)(void);


// Thread argument definition
typedef struct
{
    int arg;
    hthread_mutex_t * mutex;
} targ_t;

void * blink_thread (void * arg)
{
    return (void*)99;
}

int main( int argc, char *argv[] )
{
    if (NUM_THREADS > 2){
        printf("CANNOT USE MORE THAN (2) HETEROGENEOUS THREADS!!!!\r\n");
        return (-1);
    }
    // Timer variables
    xps_timer_t timer;
    int time_create, time_start, time_stop;

    // Mutex
    hthread_mutex_t * mutex          = (hthread_mutex_t*)malloc( sizeof(hthread_mutex_t) );
    hthread_mutex_init( mutex, NULL );

    // Thread attribute structures
    Huint           sta[NUM_THREADS];
    void*           retval[NUM_THREADS];
    hthread_t       tid[NUM_THREADS];
    hthread_attr_t  attr[NUM_THREADS];
    targ_t thread_arg[NUM_THREADS];

    // Setup Cache
    XCache_EnableICache(0xc0000801);

    // Create timer
    xps_timer_create(&timer, (int*)0x20400000);

    // Start timer
    xps_timer_start(&timer);

// *************************************************************************************    
    extern unsigned char intermediate[];

    extern unsigned int blink_handle_offset;
    unsigned int blink_handle = (blink_handle_offset) + (unsigned int)(&intermediate);

// *************************************************************************************    

    int j = 0;
    printf("Code start address = 0x%08x\n", (unsigned int)&intermediate);

    for (j = 0; j < NUM_THREADS; j++)
    {
        // Initialize the attributes for the threads
        hthread_attr_init( &attr[j] );
        hthread_attr_sethardware( &attr[j], (void*)base_array[j] );
    }

    int num_ops = 0;
    for( num_ops = 0; num_ops < 1; num_ops = num_ops + 1)
    { 

        printf("******* Round %d ********\n",num_ops);
#ifdef USE_MB_THREAD
        printf("**** MB-based Threads ****\n");
#else
        printf("**** PPC-based Threads ****\n");
#endif

        // Initialize thread arguments
        for ( j= 0; j < NUM_THREADS; j++)
        {
            thread_arg[j].arg = 1 << ((j + 1));
            thread_arg[j].mutex = mutex;
        }

        time_create = xps_timer_read_counter(&timer);
        // Create threads
        for (j = 0; j < NUM_THREADS; j++)
        {
            // Create the blink thread
#ifdef USE_MB_THREAD
            // Create MB Thread
            sta[j] = hthread_create( &tid[j], &attr[j], (void*)blink_handle, (void*)(&thread_arg[j]) );
            //printf( "Started MB Thread (TID = %d) \n", tid[j]);
#else
            // Create SW Thread
            sta[j] = hthread_create( &tid[j], NULL, blink_thread, (void*)(&thread_arg[j]) );
            //printf( "Started SW Thread (TID = %d) \n", tid[j]);
#endif
        }


        // Allow created threads to begin running and start timer
        time_start = xps_timer_read_counter(&timer);
        printf("Waiting for threads...\n");
        // Join on all threads
        for (j = 0; j < NUM_THREADS; j++)
        {
            hthread_join( tid[j], &retval[j] );
        }

        // Grab stop time
        time_stop = xps_timer_read_counter(&timer);

        // Print out status
        for (j = 0; j < NUM_THREADS; j++)
        {
            printf("TID[%d] = 0x%08x, status = 0x%08x, retval = 0x%08x\n",j,tid[j],sta[j],(unsigned int)retval[j]);
        }

        printf("*********************************\n");
        printf("Create time  = %u\n",time_create);
        printf("Start time   = %u\n",time_start);
        printf("Stop time    = %u\n",time_stop);
        printf("*********************************\n");
        printf("Creation time (|Start - Create|) = %u\n",time_start - time_create);
        printf("Elapsed time  (|Stop - Start|)   = %u\n",time_stop - time_start);


    }


    hthread_mutex_destroy( mutex );
    free( mutex );

    // Clean up the attribute structures
    for (j = 0; j < NUM_THREADS; j++)
    {
        hthread_attr_destroy( &attr[j] );
    }

    printf ("-- Complete --\n");

    // Return from main
    return 0;
}
