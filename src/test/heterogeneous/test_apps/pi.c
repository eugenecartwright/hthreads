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
// Modified by Eugene to use floating point instructions and local timer reads

#include <hthread.h>
#include <arch/htime.h>

#define MAX_THREAD      (32)
#define NUM_THREADS     (NUM_AVAILABLE_HETERO_CPUS)
#define NUM_INTERVALS   (1000)
#define NUM_TRIALS      (1)
#define USE_FPU

void * pi_thread_fpu (void * arg);
void * pi_thread_no_fpu (void * arg);

#ifndef HETERO_COMPILATION
#include <stdio.h>
#include <stdlib.h>
#include <util/rops.h>
#include "pi_prog.h"
#endif

typedef struct
{
    float num_threads;
    float num_intervals;
    float data;
    float * pi;    
    hthread_mutex_t * pi_mutex;
    hthread_time_t start;
    hthread_time_t stop;
} targ_t;

// Make use of 32-bit FPU
void * pi_thread_fpu (void * arg)
{
    targ_t * targ = (targ_t *)(arg);
    targ->start = hthread_time_get();
    float threads;
    float intervals;

    // Get TID
    //int id;
    //id = hthread_self();

    // Extract arguments
    threads = targ->num_threads;
    intervals = targ->num_intervals;

    // Approximate Pi
    register float width, localsum;
    register float i;
    register float iproc = (float)targ->data;

    // set width
    width = 1.0f / intervals;


    /* do the local computations */
    localsum = 0.0f;
    for (i = iproc; i < intervals; i += threads)
    {
        register float x = (i + 0.5f) * width;
        localsum += 4.0f / (1.0f + x * x);
    }
    localsum *= width;

    /* get permission, update pi, and unlock */
    hthread_mutex_lock(targ->pi_mutex);
    *(targ->pi) += localsum;
    hthread_mutex_unlock(targ->pi_mutex);

    targ->stop = hthread_time_get();
    return NULL;
    //return (void*)id;
}

// Generate Software emulated FPU instructions
// C defaults to double-precision floating point,
// yet sizeof(float) reveals 4 bytes.
void * pi_thread_no_fpu (void * arg)
{
    targ_t * targ = (targ_t *)(arg);
    targ->start = hthread_time_get();
    float threads;
    float intervals;

    // Get TID
    //int id;
    //id = hthread_self();

    // Extract arguments
    threads = targ->num_threads;
    intervals = targ->num_intervals;

    // Approximate Pi
    register float width, localsum;
    register float i;
    register float iproc = (float)targ->data;

    // set width
    width = 1.0 / intervals;


    /* do the local computations */
    localsum = 0.0;
    for (i = iproc; i < intervals; i += threads)
    {
        register float x = (i + 0.5) * width;
        localsum += 4.0 / (1.0 + x * x);
    }
    localsum *= width;

    /* get permission, update pi, and unlock */
    hthread_mutex_lock(targ->pi_mutex);
    *(targ->pi) += localsum;
    hthread_mutex_unlock(targ->pi_mutex);

    targ->stop = hthread_time_get();
    return NULL;
    //return (void*)id;
}

#ifndef HETERO_COMPILATION

int run_tests()
{
    // Timer variables
    hthread_time_t time_create, time_stop, temp_os_overhead,time_middle;
    hthread_time_t total_diff_total, diff_total, diff_thread_calc, diff_os_overhead, temp_diff_thread_calc,total_diff_os_overhead, total_diff_thread_calc;
    // Mutex
    hthread_mutex_t * mutex          = (hthread_mutex_t*)malloc( sizeof(hthread_mutex_t) );
    hthread_mutex_init( mutex, NULL );

    float pi;

    // Thread attribute structures
    Huint           sta[MAX_THREAD];
    void*           retval[MAX_THREAD];
    hthread_t       tid[MAX_THREAD];
    hthread_attr_t  attr[MAX_THREAD];
    targ_t thread_arg[MAX_THREAD];

    int n = 0; 
    //for (n = NUM_THREADS - (NUM_THREADS-1); n < NUM_THREADS; n++)
    for (n = NUM_THREADS; n > 0; n--)
    //for (n =NUM_THREADS; n < MAX_THREAD+1; n*=2) 
    {
        printf("Number of threads = %d\n", n );
        int m = 0;
        total_diff_os_overhead = 0.0; 
        total_diff_thread_calc = 0.0;  
        total_diff_total = 0.0;  
        for (m=0; m < NUM_TRIALS; m++ )
        {
            int i = 0;
            pi = 0.0f;
            for (i = 0; i < n; i++)
            {
                // Initialize the attributes for the hardware threads
                hthread_attr_init( &attr[i] );

                // Initialize thread arguments
                thread_arg[i].num_threads = (float) n;
                thread_arg[i].num_intervals = (float) NUM_INTERVALS;
                thread_arg[i].data = (float) i;
                thread_arg[i].pi_mutex = mutex;
                thread_arg[i].pi  = &pi;
            }


            // Start timing thread create
            time_create = hthread_time_get();

            for (i = 0; i < n; i++)
            {
            

                // Create the worker threads

#ifndef USE_FPU
                sta[i] = microblaze_create( &tid[i], &attr[i], (void *) (pi_thread_no_fpu_FUNC_ID), (void*)&thread_arg[i],i );
#else
                sta[i] = microblaze_create( &tid[i], &attr[i], (void *) (pi_thread_fpu_FUNC_ID), (void*)&thread_arg[i],i );
#endif

            }

            // Get time stamp before joining
            time_stop = hthread_time_get();

            // Wait for the threads to exit
            //printf( "Waiting for thread(s) to complete... \n" );
            for (i = 0; i < n; i++)
            {
                hthread_join( tid[i], &retval[i] );
            }

            time_stop = hthread_time_get();

            // Display results
            //printf("Pi = %f\n",pi);
           /* 
            for (i = 0; i < n; i++)
            {
                printf("TID = 0x%08x, status = 0x%08x, retval = 0x%08x\n",tid[i],sta[i],(Huint)retval[i]);
            }
           */
           
            // Total
            hthread_time_diff(diff_total, time_stop, time_create);


            // (Average) Calculation overhead
            temp_diff_thread_calc = 0.0;
            for ( i = 0; i < n; i++) 
            {
                hthread_time_diff(diff_thread_calc, thread_arg[i].stop, thread_arg[i].start);
                temp_diff_thread_calc += diff_thread_calc;
            }
            temp_diff_thread_calc /= (n * 1.0f);
            
            // OS create threads overhead = time_stamp of last thread's start time stamp - time_create
            //hthread_time_t os_create_overhead, diff_os_create_overhead;
            //hthread_time_diff(diff_os_create_overhead,thread_arg[n-1].start,time_create);
            //os_create_overhead = diff_os_create_overhead;

            // Os join threads_overhead = 

            // OS overhead relative to average calculation time
            hthread_time_diff(diff_os_overhead, time_stop, time_create);
            temp_os_overhead = diff_os_overhead - temp_diff_thread_calc;
            
            //Running totals
            total_diff_os_overhead += temp_os_overhead;
            total_diff_thread_calc += temp_diff_thread_calc;
            total_diff_total += diff_total;
        } // NUM_TRIALS LOOP
       
        total_diff_os_overhead  /=  (NUM_TRIALS * 1.0f); 
        total_diff_thread_calc  /=  (NUM_TRIALS * 1.0f); 
        total_diff_total        /=  (NUM_TRIALS * 1.0f); 
        
        printf("*******************************************\n");
        //printf("Average OS Overhead time    = %.3f us\n", hthread_time_usec(total_diff_os_overhead));
        //printf("Average Calculation time    = %.3f us\n",hthread_time_usec(total_diff_thread_calc));
        //printf("Total Time                  = %.3f us\n\n",hthread_time_usec(total_diff_total));
        //printf("Average OS Overhead time    = %.3f ms\n", hthread_time_msec(total_diff_os_overhead));
        printf("Average Calculation time    = %.3f us\n",hthread_time_usec(total_diff_thread_calc));
        printf("Average Calculation time    = %.3f ms\n",hthread_time_msec(total_diff_thread_calc));
        //printf("Total Time                  = %.3f ms\n\n",hthread_time_msec(total_diff_total));
        
    }// BIG LOOP
            
    hthread_mutex_destroy( mutex );
    free( mutex );
    int i;
    // Clean up the attribute structures
    for (i = 0; i < MAX_THREAD; i++)
    {
        hthread_attr_destroy( &attr[i] );
    }
    printf ("-- Complete --\n");

    // Return from main
    return 0;
}

int main()
{
    run_tests();

    return 0;
}
#endif
