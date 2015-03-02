/************************************************************************************
* Copyright (c) 2006, University of Kansas - Hybridthreads Group
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
*     * Neither the name of the University of Kansas nor the name of the
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
#include <math.h>

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


#define ARR_LENGTH      (512)
#define NUM_THREADS     (3)
//#define USE_MB_THREAD
//#define MY_DEBUG

#define NUM_CPUS        (10)
unsigned int base_array[NUM_CPUS] = {HWTI_BASEADDR0, HWTI_BASEADDR1, HWTI_BASEADDR2, HWTI_BASEADDR3, HWTI_BASEADDR4, HWTI_BASEADDR5, HWTI_BASEADDR6, HWTI_BASEADDR7, HWTI_BASEADDR8, HWTI_BASEADDR9};

// Function pointer Definition
typedef void * (*FuncPointer)(void);


// Thread argument definition
typedef struct
{
    int * x0s;
    int * y0s;
    int * x1s;
    int * y1s;
    int * distances;
    unsigned int length;
} targ_t;

void distances(int * x0s, int * y0s, int * x1s, int * y1s, int * ds, int length)
{
  int i;
  register int t1, t2;
  for (i=0; i < length; i++)
  {
    t1 = (x0s[i] - x1s[i]);
    t1 = t1*t1;

    t2 = (y0s[i] - y1s[i]);
    t2 = t2*t2;

    ds[i] = sqrt(t1 + t2); 
  }
}

void calc_distances( targ_t * targ)
{
    distances(targ->x0s, targ->y0s, targ->x1s, targ->y1s, targ->distances, targ->length);
}

void * distance_thread (void * arg)
{
    targ_t * targ = (targ_t*)arg;

    // Calculate distances
    calc_distances(targ);

    return (void*)(999);
}

int run_tests()
{
    if (NUM_THREADS > NUM_CPUS){
        printf("CANNOT USE MORE THAN (%d) HETEROGENEOUS THREADS!!!!\r\n", NUM_CPUS);
        return (-1);
    }
  
    // Timer variables
    xps_timer_t timer;
    int time_create, time_start, time_stop;

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

    extern unsigned int distance_handle_offset;
    unsigned int distance_handle = (distance_handle_offset) + (unsigned int)(&intermediate);
    printf("Code start address = 0x%08x\n", (unsigned int)&intermediate);

// *************************************************************************************    
    int vals_x0[ARR_LENGTH];
    int vals_x1[ARR_LENGTH];

    int vals_y0[ARR_LENGTH];
    int vals_y1[ARR_LENGTH];
    int vals_ds[ARR_LENGTH];

    int j = 0;

    for (j = 0; j < NUM_THREADS; j++)
    {
        // Initialize the attributes for the threads
        hthread_attr_init( &attr[j] );
        hthread_attr_sethardware( &attr[j], (void*)base_array[j] );
    }

    for (j = 0; j < ARR_LENGTH; j++)
    {
        vals_x0[j] = ARR_LENGTH - j;
        vals_y0[j] = ARR_LENGTH - j;

        vals_x1[j] = ARR_LENGTH - j + 1;
        vals_y1[j] = ARR_LENGTH - j;
    }


#ifdef MY_DEBUG
#endif

    int num_ops = 0;
    for( num_ops = 0; num_ops < 2; num_ops = num_ops + 1)
    { 

        printf("******* Round %d ********\n",num_ops);
#ifdef USE_MB_THREAD
        printf("**** MB-based Threads ****\n");
#else
        printf("**** PPC-based Threads ****\n");
#endif

        for (j = 0; j < ARR_LENGTH; j++)
        {
            vals_x0[j]  = ARR_LENGTH - j;
        }

        // Initialize thread arguments
        int num_items = ARR_LENGTH/NUM_THREADS;
        int extra_items = ARR_LENGTH - (num_items*NUM_THREADS);
        for ( j= 0; j < NUM_THREADS; j++)
        {
            thread_arg[j].x0s = &vals_x0[j*(num_items)];
            thread_arg[j].y0s = &vals_y0[j*(num_items)];
            thread_arg[j].x1s = &vals_x1[j*(num_items)];
            thread_arg[j].y1s = &vals_y1[j*(num_items)];
            thread_arg[j].distances = &vals_ds[j*(num_items)];
            thread_arg[j].length = num_items;
        }
        // Add in extra items for the last thread if needed
        thread_arg[j-1].length += extra_items;

        time_create = xps_timer_read_counter(&timer);
        // Create threads
        for (j = 0; j < NUM_THREADS; j++)
        {
            // Create the distance thread
#ifdef USE_MB_THREAD
            // Create MB Thread
            sta[j] = hthread_create( &tid[j], &attr[j], (void*)distance_handle, (void*)(&thread_arg[j]) );
            //printf( "Started MB Thread (TID = %d) \n", tid[j]);
#else
            // Create SW Thread
            sta[j] = hthread_create( &tid[j], NULL, distance_thread, (void*)(&thread_arg[j]) );
            //printf( "Started SW Thread (TID = %d) \n", tid[j]);
#endif
        }


        // Allow created threads to begin running and start timer
        time_start = xps_timer_read_counter(&timer);
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
        printf("Total time   (|Create - Stop|)   = %u\n",time_stop - time_create);


    }

#ifdef MY_DEBUG
    for (j = 0; j < ARR_LENGTH; j++)
    {
        printf("D(%d) = %d\n",j,vals_ds[j]);
    }
#endif

    // Clean up the attribute structures
    for (j = 0; j < NUM_THREADS; j++)
    {
        hthread_attr_destroy( &attr[j] );
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
