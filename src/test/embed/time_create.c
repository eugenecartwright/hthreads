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
#define NUM_ITERATIONS  (100)
#define NUM_THREADS     (3)
#define USE_MB_THREAD
//#define MY_DEBUG

#define NUM_CPUS        (10)
unsigned int base_array[NUM_CPUS] = {HWTI_BASEADDR0, HWTI_BASEADDR1, HWTI_BASEADDR2, HWTI_BASEADDR3, HWTI_BASEADDR4, HWTI_BASEADDR5, HWTI_BASEADDR6, HWTI_BASEADDR7, HWTI_BASEADDR8, HWTI_BASEADDR9};

// Function pointer Definition
typedef void * (*FuncPointer)(void);

// Data logs
int log_create[NUM_ITERATIONS*NUM_THREADS];
int log_lock[NUM_ITERATIONS*NUM_THREADS];
int log_unlock[NUM_ITERATIONS*NUM_THREADS];
int log_join[NUM_ITERATIONS*NUM_THREADS];

// Thread argument definition
typedef struct
{
    xps_timer_t * timer;
    hthread_mutex_t * shared_mutex;
    int create_time;
    int intra_time;
    int lock_time;
    int unlock_time;
    int join_time;
} targ_t;

void * timer_thread(void * arg)
{
    int t_start, t_stop;
    targ_t * targ = (targ_t *)arg;

    // Grab timestamp to measure end of creation time
    targ->intra_time = xps_timer_read_counter(targ->timer); // Only works if timer is accessible to the thread

    // Measure mutex lock time
    t_start = xps_timer_read_counter(targ->timer);
    hthread_mutex_lock(targ->shared_mutex);
    t_stop = xps_timer_read_counter(targ->timer);
    targ->lock_time = t_stop - t_start;

    // Measure mutex unlock time
    t_start = xps_timer_read_counter(targ->timer);
    hthread_mutex_unlock(targ->shared_mutex);
    t_stop = xps_timer_read_counter(targ->timer);
    targ->unlock_time = t_stop - t_start;

    return (void*)999;
}

int main( int argc, char *argv[] )
{
    if (NUM_THREADS > NUM_CPUS){
        printf("CANNOT USE MORE THAN (%d) HETEROGENEOUS THREADS!!!!\r\n", NUM_CPUS);
        return (-1);
    }
  
    // Timer variables
    xps_timer_t timer;
    int time_create, time_start, time_stop;

    // Mutex
    //hthread_mutex_t * mutex          = (hthread_mutex_t*)malloc( sizeof(hthread_mutex_t) );
    //hthread_mutex_init( mutex, NULL );

    // Thread attribute structures
    Huint           sta[NUM_THREADS];
    void*           retval[NUM_THREADS];
    hthread_t       tid[NUM_THREADS];
    hthread_attr_t  attr[NUM_THREADS];
    targ_t thread_arg[NUM_THREADS];
    hthread_mutex_t * mutex[NUM_THREADS];
    hthread_mutexattr_t mattr[NUM_THREADS];

    // Setup Cache
    XCache_DisableDCache();
    XCache_EnableICache(0xc0000801);

    // Create timer
    xps_timer_create(&timer, (int*)0x20400000);

    // Start timer
    xps_timer_start(&timer);

// *************************************************************************************    
    extern unsigned char intermediate[];

    extern unsigned int thread_handle_offset;
    unsigned int thread_handle = (thread_handle_offset) + (unsigned int)(&intermediate);

// *************************************************************************************    

    int j = 0;
    printf("Code start address = 0x%08x\n", (unsigned int)&intermediate);
    int mutexnum = 0;
    for (j = 0; j < NUM_THREADS; j++)
    {
        // Initialize the attributes for the threads
        hthread_attr_init( &attr[j] );
        hthread_attr_sethardware( &attr[j], (void*)base_array[j] );

        mutex[j] = (hthread_mutex_t*)malloc( sizeof(hthread_mutex_t) );
        hthread_mutexattr_init( &mattr[j] );
        hthread_mutexattr_setnum( &mattr[j], mutexnum++ );
        hthread_mutexattr_settype( &mattr[j], HTHREAD_MUTEX_RECURSIVE_NP );
        hthread_mutex_init( mutex[j], &mattr[j]);
    }
    printf("%d Iterations\n",NUM_ITERATIONS);
#ifdef USE_MB_THREAD
        printf("**** MB-based Threads (%d) ****\n",NUM_THREADS);
#else
        printf("**** PPC-based Threads (%d) ****\n",NUM_THREADS);
#endif

    int accum_create = 0;
    int accum_lock = 0;
    int accum_unlock = 0;
    int accum_join = 0;
    int num_ops = 0;
    int log_num = 0;
    for( num_ops = 0; num_ops < NUM_ITERATIONS; num_ops = num_ops + 1)
    { 

        // Initialize thread arguments
        for ( j= 0; j < NUM_THREADS; j++)
        {
            thread_arg[j].timer = &timer;
            thread_arg[j].shared_mutex = mutex[j];
        }

        time_create = xps_timer_read_counter(&timer);
        // Create threads
        for (j = 0; j < NUM_THREADS; j++)
        {
            thread_arg[j].create_time = xps_timer_read_counter(&timer);
            // Create the sort thread
#ifdef USE_MB_THREAD
            // Create MB Thread
            sta[j] = hthread_create( &tid[j], &attr[j], (void*)thread_handle, (void*)(&thread_arg[j]) );
            //printf( "Started MB Thread (TID = %d) \n", tid[j]);
#else
            // Create SW Thread
            sta[j] = hthread_create( &tid[j], NULL, timer_thread, (void*)(&thread_arg[j]) );
            //printf( "Started SW Thread (TID = %d) \n", tid[j]);
#endif
        }


        // Allow created threads to begin running and start timer
        time_start = xps_timer_read_counter(&timer);
        int join_start;
        // Join on all threads
        for (j = 0; j < NUM_THREADS; j++)
        {
            join_start = xps_timer_read_counter(&timer);
            hthread_join( tid[j], &retval[j] );
            thread_arg[j].join_time = xps_timer_read_counter(&timer) - join_start;

#ifdef MY_DEBUG
            printf("Create Time = %u\n",thread_arg[j].create_time);
            printf("Intra Time  = %u\n",thread_arg[j].intra_time);
            printf("Diff Time   = %u\n",thread_arg[j].intra_time - thread_arg[j].create_time);
#endif

            // Log data
            log_create[log_num] = thread_arg[j].intra_time - thread_arg[j].create_time;
            log_lock[log_num]   = thread_arg[j].lock_time;
            log_unlock[log_num]   = thread_arg[j].unlock_time;
            log_join[log_num] = thread_arg[j].join_time;
            log_num++;

            // Accumulate data
            accum_create = accum_create + (thread_arg[j].intra_time - thread_arg[j].create_time);
            accum_lock = accum_lock + (thread_arg[j].lock_time);
            accum_unlock = accum_unlock + (thread_arg[j].unlock_time);
            accum_join = accum_join + (thread_arg[j].join_time);
        }

        // Grab stop time
        time_stop = xps_timer_read_counter(&timer);
/*
        // Print out status
        for (j = 0; j < NUM_THREADS; j++)
        {
            printf("TID[%d] = 0x%08x, status = 0x%08x, retval = 0x%08x\n",j,tid[j],sta[j],(unsigned int)retval[j]);
        }
*/
    }

    float avg_create, avg_lock, avg_unlock, avg_join;
    float std_create, std_lock, std_unlock, std_join;

    // Calculate averages
    avg_create = (float)((float)accum_create/NUM_ITERATIONS);
    avg_lock   = (float)((float)accum_lock/NUM_ITERATIONS);
    avg_unlock = (float)((float)accum_unlock/NUM_ITERATIONS);
    avg_join = (float)((float)accum_join/NUM_ITERATIONS);

    // Calculate standard deviations
    std_create = 0;
    std_lock = 0;
    std_unlock = 0;
    std_join = 0;
    float t;
    for (j = 0; j < NUM_ITERATIONS*NUM_THREADS; j++)
    {
       t = (avg_create - log_create[j]);
       t = t*t;
       std_create = std_create + t;

       t = (avg_lock - log_lock[j]);
       t = t*t;
       std_lock = std_lock + t;

       t = (avg_unlock - log_unlock[j]);
       t = t*t;
       std_unlock = std_unlock + t;

       t = (avg_join - log_join[j]);
       t = t*t;
       std_join = std_join + t;
    }

    std_create = sqrt(std_create / (NUM_ITERATIONS*NUM_THREADS));
    std_lock   = sqrt(std_lock / (NUM_ITERATIONS*NUM_THREADS));
    std_unlock   = sqrt(std_unlock / (NUM_ITERATIONS*NUM_THREADS));
    std_join   = sqrt(std_join / (NUM_ITERATIONS*NUM_THREADS));

    printf("*********************************\n");
    printf("Average Create = %d / %d = %f, STD_DEV = %f\n",accum_create,NUM_ITERATIONS,avg_create,std_create);
    printf("Average Lock   = %d / %d = %f, STD_DEV = %f\n",accum_lock,NUM_ITERATIONS,avg_lock,std_lock);
    printf("Average Unlock = %d / %d = %f, STD_DEV = %f\n",accum_unlock,NUM_ITERATIONS,avg_unlock,std_unlock);
    printf("Average Join   = %d / %d = %f, STD_DEV = %f\n",accum_join,NUM_ITERATIONS,avg_join,std_join);


    // Clean up the attribute structures
    for (j = 0; j < NUM_THREADS; j++)
    {
        hthread_attr_destroy( &attr[j] );
    }

    printf ("-- Complete --\n");

    // Return from main
    return 0;
}
