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
#define USE_MB_THREAD
//#define MY_DEBUG

#define NUM_CPUS        (10)
unsigned int base_array[NUM_CPUS] = {HWTI_BASEADDR0, HWTI_BASEADDR1, HWTI_BASEADDR2, HWTI_BASEADDR3, HWTI_BASEADDR4, HWTI_BASEADDR5, HWTI_BASEADDR6, HWTI_BASEADDR7, HWTI_BASEADDR8, HWTI_BASEADDR9};

// Function pointer Definition
typedef void * (*FuncPointer)(void);


// Thread argument definition
typedef struct
{
    int * data;
    unsigned int length;
} targ_t;

void bubblesort(int *array, unsigned int len )
{

    int swapped = 1;
    unsigned int i, n, n_new, temp;
    n = len - 1;
    n_new = n;

    while ( swapped ) {
        swapped = 0;
        for ( i = 0; i < n; i++ ) {
            if ( array[i] > array[i + 1] ) {
                temp = array[i];
                array[i] = array[i + 1];
                array[i + 1] = temp;
                n_new = i;
                swapped = 1;
            }
        }
        n = n_new;
    }
}

void insertionsort(int * a, int length)
{
  int i;
  for (i=0; i < length; i++)
  {
      // Insert a[i] into the sorted sublist
      int j, v = a[i];

      for (j = i - 1; j >= 0; j--)
      {
          if (a[j] <= v) break;
          a[j + 1] = a[j];
      }
      a[j + 1] = v;

  }
}

void show_array( int * array, unsigned int length)
{
    int counter = 0;
    for (counter = 0; counter < 10; counter++)
    {
        printf("Array[%d] = %d\n",counter,array[counter]);
    }
}

void check_array( int * array, unsigned int length)
{
    int counter = 0;
    int error = 0;
    for (counter = 0; counter < length-1; counter++)
    {
        if (array[counter] > array[counter+1])
        {
            error++;
        }
    }
    printf("%d errors!\r\n",error);
}


void * bubblesort_thread (void * arg)
{
    targ_t * targ = (targ_t*)arg;

    // Sort the data
    bubblesort(targ->data, targ->length);

    return (void*)(999);
}

void * insertionsort_thread (void * arg)
{
    targ_t * targ = (targ_t*)arg;

    // Sort the data
    insertionsort(targ->data, targ->length);

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

    extern unsigned int sort_handle_offset;
    unsigned int sort_handle = (sort_handle_offset) + (unsigned int)(&intermediate);

// *************************************************************************************    
    int local_data[ARR_LENGTH];

    int j = 0;
    printf("Code start address = 0x%08x\n", (unsigned int)&intermediate);

    for (j = 0; j < NUM_THREADS; j++)
    {
        // Initialize the attributes for the threads
        hthread_attr_init( &attr[j] );
        hthread_attr_sethardware( &attr[j], (void*)base_array[j] );
    }

    for (j = 0; j < ARR_LENGTH; j++)
    {
        local_data[j] = ARR_LENGTH - j;
    }


#ifdef MY_DEBUG
    show_array(&local_data[0], ARR_LENGTH);
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
            local_data[j]  = ARR_LENGTH - j;
        }


        // Initialize thread arguments
        for ( j= 0; j < NUM_THREADS; j++)
        {
            thread_arg[j].data = &local_data[j*(ARR_LENGTH/NUM_THREADS)];
            thread_arg[j].length = ARR_LENGTH/NUM_THREADS;
        }

        time_create = xps_timer_read_counter(&timer);
        // Create threads
        for (j = 0; j < NUM_THREADS; j++)
        {
            // Create the sort thread
#ifdef USE_MB_THREAD
            // Create MB Thread
            sta[j] = hthread_create( &tid[j], &attr[j], (void*)sort_handle, (void*)(&thread_arg[j]) );
            //printf( "Started MB Thread (TID = %d) \n", tid[j]);
#else
            // Create SW Thread
            sta[j] = hthread_create( &tid[j], NULL, bubblesort_thread, (void*)(&thread_arg[j]) );
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
    show_array(&local_data[0], ARR_LENGTH);
    check_array(&local_data[0], ARR_LENGTH);
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
    for (x = 0; x < 2; x++)
    {
        run_tests();
    }
    return 0;
}
