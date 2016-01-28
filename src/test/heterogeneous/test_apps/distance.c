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
/** \file       
  * \brief     Calculates distances between two points
  *
  * \author    Unknown
  *            Modified by Eugene Cartwright
  * 
  */

#include <hthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <arch/htime.h>

void * distance_thread(void * arg);

#define OPCODE_FLAGGING

#ifndef HETERO_COMPILATION
#include "distance_prog.h"
#endif

#define ARR_LENGTH      (500)
#define NUM_THREADS     (NUM_AVAILABLE_HETERO_CPUS)


// Thread argument definition
typedef struct
{
    float * x0s;
    float * y0s;
    float * x1s;
    float * y1s;
    float * distances;
    unsigned int length;
} targ_t;

void distances(float * x0s, float * y0s, float * x1s, float * y1s, float * ds, int length)
{
  int i;
  register float t1, t2;
  for (i=0; i < length; i++)
  {
    t1 = (x0s[i] - x1s[i]);
    t1 = t1*t1;

    t2 = (y0s[i] - y1s[i]);
    t2 = t2*t2;

    ds[i] = sqrtf(t1 + t2); 
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

#ifndef HETERO_COMPILATION
hthread_time_t exec_time[NUM_THREADS] PRIVATE_MEMORY;
hthread_t tid[NUM_THREADS] PRIVATE_MEMORY;
hthread_attr_t attr[NUM_THREADS] PRIVATE_MEMORY;
void * ret[NUM_THREADS] PRIVATE_MEMORY;
Huint sta[NUM_THREADS] PRIVATE_MEMORY;

// Timer variables
hthread_time_t start, stop;

int main()
{
  
   printf("--- Distance benchmark ---\n");
   printf("Number of Points: %d\n", ARR_LENGTH);
#ifdef OPCODE_FLAGGING
   printf("-->Opcode flagging ENABLED\n");
#else
   printf("-->Opcode flagging DISABLED\n");
#endif
   // Initialize various host tables once.
   init_host_tables();


    // Thread attribute structures
    targ_t thread_arg[NUM_THREADS];

    float vals_x0[ARR_LENGTH];
    float vals_x1[ARR_LENGTH];

    float vals_y0[ARR_LENGTH];
    float vals_y1[ARR_LENGTH];

    float vals_ds[ARR_LENGTH];

    int j = 0;

    for (j = 0; j < NUM_THREADS; j++)
    {
        // Initialize the attributes for the threads
        hthread_attr_init( &attr[j] );
    }

    for (j = 0; j < ARR_LENGTH; j++)
    {
        vals_x0[j] = (float) ARR_LENGTH - j;
        vals_y0[j] = (float) ARR_LENGTH - j;

        vals_x1[j] = (float) j + 1;
        vals_y1[j] = (float) ARR_LENGTH - j + 1;
    }


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

   start = hthread_time_get();
   // Create threads
   for (j = 0; j < NUM_THREADS; j++)
   {
      // Create the distance thread
      //sta[j] =  thread_create( &tid[j], &attr[j], distance_thread_FUNC_ID, (void *) &thread_arg[j], STATIC_HW0+j, 0);
      sta[j] =  thread_create( &tid[j], &attr[j], distance_thread_FUNC_ID, (void *) &thread_arg[j], DYNAMIC_HW, 0);
   }

   // Join on all threads
   for (j = 0; j < NUM_THREADS; j++) {
      if (thread_join(tid[j], &ret[j], &exec_time[j]))
         printf("Join error!\n");
   }

   // Grab stop time
   stop = hthread_time_get();

   for (j = 0; j < NUM_THREADS; j++) {
   // Determine which slave ran this thread based on address
   Huint base = attr[j].hardware_addr - HT_HWTI_COMMAND_OFFSET;
   Huint slave_num = (base & 0x00FF0000) >> 16;
   printf("Execution time (TID : %d, Slave : %d)  = %f usec\n", tid[j], slave_num, hthread_time_usec(exec_time[j]));
   }

   // Display OS overhead
   printf("Total OS overhead (thread_create) = %f usec\n", hthread_time_usec(create_overhead));
   printf("Total OS overhead (thread_join) = %f usec\n", hthread_time_usec(join_overhead));
   create_overhead=0;
   join_overhead=0;

   // Display overall time
   hthread_time_t diff; hthread_time_diff(diff, stop, start);
   printf("Total time = %f usec\n", hthread_time_usec(diff));

#ifdef DEBUG_DISPATCH
    for (j = 0; j < ARR_LENGTH; j++)
    {
        printf("D(%d) = %f\n",j,vals_ds[j]);
    }
#endif

    // Clean up the attribute structures
    for (j = 0; j < NUM_THREADS; j++)
    {
        hthread_attr_destroy( &attr[j] );
    }

   printf("--- Done ---\n");

    return 0;
}

#endif
