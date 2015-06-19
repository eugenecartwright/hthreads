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
#define HWTI_BASEADDR0               (void*)(0xB0000000)
#define HWTI_BASEADDR1               (void*)(0xB0000100)

// Array size
#define ARR_SIZE    100000

    // Array
    int my_array[ARR_SIZE];
    int my_hist0[ARR_SIZE];
    int my_hist1[ARR_SIZE];
    int my_hist2[ARR_SIZE];

// Array size
#define MOD_VAL    4

// Type of thread flag
#define USE_MB_THREAD

// Function pointer Definition
typedef void * (*FuncPointer)(void);

// Thread argument definition
typedef struct
{
    int * array;
    int length;
    int max_value;
    int min_value;

    int * hist;
    int num_bins;
} targ_t;

void show_data (targ_t * x)
{
    int i = 0;

    printf("Data:\n");
    for (i = 0; i < x->length; i++)
    {
        printf("\tArray %d = %d\n",i , x->array[i]);
    } 
}

void show_histogram (targ_t * x)
{
    int i = 0;

    printf("Histogram:\n");
    for (i = 0; i < x->num_bins; i++)
    {
        printf("\tBin %d = %d\n",i , x->hist[i]);
    } 
}

void * histogram_thread (void * arg)
{
    targ_t * targ;
    int i = 0;
    int bin = 0;
    int val = 0;
    int times = 10;
    int accum = 0;
    int tcount = 0;
    for (tcount = 0; tcount < times; tcount++)
    {    
	    // Create a pointer to thread argument
	    targ = (targ_t *)arg;
	
	    // Calculate histogram
	    int diff = (targ->max_value - targ->min_value);
	
	    //int divider = (targ->max_value - targ->min_value) / targ->num_bins;
	    int divider = (diff / targ->num_bins) + (targ->num_bins - (diff % targ->num_bins));
	    //printf("Divider = %d\n",divider);
	    for (i = 0; i < targ->length; i++)
	    {
	        // Extract array value
	        val = targ->array[i];
	
	        // Calculate bin number
	        bin = val / divider;
	
	        // Update histogram
	        targ->hist[bin] = targ->hist[bin] + 1;
            accum = accum + diff;
	    }
    }
    return (void*)(accum);
}

int main( int argc, char *argv[] )
{
    // Timer variables
    xps_timer_t timer;
    int time_start, time_stop;

    // Thread attribute structures
    Huint           sta0;
    void*           retval0;
    hthread_t       tid0;
    hthread_attr_t  attr0;
    targ_t thread_arg0;

    Huint           sta1;
    void*           retval1;
    hthread_t       tid1;
    hthread_attr_t  attr1;
    targ_t thread_arg1;

    int num_ops = 0;
    printf( "\n****Main Thread****... \n" );

    XCache_DisableDCache();
    XCache_EnableICache(0xc0000801);

    // Create timer
    xps_timer_create(&timer, (int*)0x20400000);

    // Start timer
    xps_timer_start(&timer);

// *************************************************************************************    
    extern unsigned char intermediate[];

    extern unsigned int hist_handle_offset;
    unsigned int hist_handle = (hist_handle_offset) + (unsigned int)(&intermediate);

	FuncPointer fp0 				= 0;			

    FuncPointer fp1 				= 0;			

// *************************************************************************************    

    printf("Code start address = 0x%08x\n", (unsigned int)&intermediate);

    // Initialize the attributes for the hardware threads
    hthread_attr_init( &attr0 );
    hthread_attr_sethardware( &attr0, HWTI_BASEADDR0 );
    hthread_attr_init( &attr1 );
    hthread_attr_sethardware( &attr1, HWTI_BASEADDR1 );

    for( num_ops = 0; num_ops < 10000; num_ops = num_ops + 1)
    { 

        printf("******* Round %d ********\n",num_ops);
        // Initialize array and histogram
        int count = 0;
        for (count = 0; count < ARR_SIZE; count++)
        {
            my_array[count] = count % MOD_VAL;
            my_hist0[count]     = 0;
            my_hist1[count]     = 0;
        }

        // Initialize thread argument
        thread_arg0.array = (int *)&my_array;
        thread_arg0.hist = (int *)&my_hist0;
        thread_arg0.length = ARR_SIZE;
        thread_arg0.max_value = MOD_VAL - 1;
        thread_arg0.min_value = 0;
        thread_arg0.num_bins = ARR_SIZE;

        // Initialize thread argument
        thread_arg1.array = (int *)&my_array;
        thread_arg1.hist = (int *)&my_hist1;
        thread_arg1.length = ARR_SIZE;
        thread_arg1.max_value = MOD_VAL - 1;
        thread_arg1.min_value = 0;
        thread_arg1.num_bins = ARR_SIZE;

        time_start = xps_timer_read_counter(&timer);

        // Create the histogram thread
#ifdef USE_MB_THREAD
        // Copy function pointer to HWTI
        fp0 = (FuncPointer)(hist_handle);

        // Create MB Thread
        sta0 = hthread_create( &tid0, &attr0, (void*)fp0, (void*)(&thread_arg0) );
        //printf( "Started MB Thread (TID = %d) \n", tid0);
#else
        // Create SW Thread
        sta0 = hthread_create( &tid0, NULL, histogram_thread, (void*)(&thread_arg0) );
        //printf( "Started SW Thread (TID = %d) \n", tid0);
#endif

        // Create the histogram thread
#ifdef USE_MB_THREAD
        // Copy function pointer to HWTI
        fp1 = (FuncPointer)(hist_handle);

        // Create MB Thread
        sta1 = hthread_create( &tid1, &attr1, (void*)fp1, (void*)(&thread_arg1) );
        //printf( "Started MB Thread (TID = %d) \n", tid1);
#else
        // Create SW Thread
        sta1 = hthread_create( &tid1, NULL, histogram_thread, (void*)(&thread_arg1) );
        //printf( "Started SW Thread (TID = %d) \n", tid1);
#endif



	    // Wait for the thread to exit
		//printf( "Waiting for thread(s) to complete... \n" );
	    hthread_join( tid0, &retval0 );
	    hthread_join( tid1, &retval1 );

        time_stop = xps_timer_read_counter(&timer);
        printf("Start time =    %u\n",time_start);
        printf("Stop time =    %u\n",time_stop);
        printf("Elapsed time =  %u\n",time_stop - time_start);

        printf( "Joined on thread... 0x%8.8x\n", (Huint)retval0 );
		printf( "Joined on thread... 0x%8.8x\n", (Huint)retval1 );

        // Display the results
        //show_data(&thread_arg0);
        //show_histogram(&thread_arg0);
        //show_histogram(&thread_arg1);
    }

    // Clean up the attribute structures
    hthread_attr_destroy( &attr0 );
    hthread_attr_destroy( &attr1 );

    printf ("-- Complete --\n");

    // Return from main
    return 0;
}
