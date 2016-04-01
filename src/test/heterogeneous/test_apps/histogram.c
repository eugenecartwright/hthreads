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
#include <arch/htime.h>
#include <stdio.h>
#include <stdlib.h>
#include <util/rops.h>
#include <accelerator.h>

// Number of threads
#define NUM_THREADS  (NUM_AVAILABLE_HETERO_CPUS)
#define NUM_BINS     (8)

#define OPCODE_FLAGGING
#define CHECK_FIRST_POLYMORPHIC
// Array size
#define ARR_SIZE    1024

// Used to initialize array
// with elements 0 - (MOD_VAL-1)
#define MOD_VAL    4

// Thread argument definition
typedef struct
{
   int * array;
   int max_value;
   int min_value;
   int * hist;
} targ_t;

#ifndef HETERO_COMPILATION
void show_data (targ_t * x)
{
    int i = 0;

    printf("Data:\n");
    for (i = 0; i < ARR_SIZE; i++)
    {
        printf("\tArray %d = %d\n",i , x->array[i]);
    } 
}

void show_histogram (targ_t * x)
{
    int i = 0;

    printf("Histogram:\n");
    for (i = 0; i < NUM_BINS; i++)
    {
        printf("\tBin %d = %d\n",i , x->hist[i]);
    } 
}
#endif

void * histogram_thread (void * arg) {

   // Create a pointer to thread argument
   volatile targ_t * targ = (targ_t *) arg;
   volatile int i = 0;
   volatile int bin = 0;
   volatile int val = 0;
   volatile int * data;
   volatile int * hist = targ->hist;
   for (i = 0; i < NUM_BINS; i++)
      hist[i] = 0;

   data = targ->array;

   // Calculate histogram
   int diff = (targ->max_value - targ->min_value);
   int bin_width = diff / NUM_BINS;
   int divider = bin_width + (NUM_BINS - (diff % NUM_BINS));
    
   for (i = 0; i < ARR_SIZE; i++) {
      // Extract array value
      val = data[i]; // Load

      // Calculate bin number
      bin = val / divider;

      // Update histogram
      hist[bin]++; // Load and store
    }
  
   return (void*)(SUCCESS);
}


#ifndef HETERO_COMPILATION
#include "histogram_prog.h"

// TODO: Need to transfer data locally as
// what governs execution time looks more like
// memory I/O
hthread_t        tid[NUM_THREADS] PRIVATE_MEMORY;
hthread_attr_t   attr[NUM_THREADS] PRIVATE_MEMORY;
hthread_time_t start PRIVATE_MEMORY, stop PRIVATE_MEMORY, diff;
hthread_time_t exec_time[NUM_THREADS] PRIVATE_MEMORY;
void * ret[NUM_THREADS] PRIVATE_MEMORY;
Huint            sta[NUM_THREADS] PRIVATE_MEMORY;

int main( int argc, char *argv[] ) 
{
   printf("--- Histogram ---\n"); 
   printf("Array Size: %d\n", ARR_SIZE);
   printf("Number of Bins: %d\n", NUM_BINS);
#ifdef OPCODE_FLAGGING
   printf("-->Opcode flagging ENABLED\n");
#else
   printf("-->Opcode flagging DISABLED\n");
#endif
   // Initialize various host tables once.
   init_host_tables();

   // Thread attribute structures
   targ_t * thread_arg = (targ_t *) malloc(sizeof(targ_t) * NUM_THREADS);
   assert (thread_arg != NULL);

   // Array Structures
   int my_array[ARR_SIZE];
   int my_hist[NUM_THREADS][NUM_BINS];

   int num_ops = 0, j = 0;;
   // Initialize the attributes for the hardware threads
   for (j = 0; j < NUM_THREADS; j++) 
      hthread_attr_init( &attr[j]);

   // Initialize array
   for (j = 0; j < ARR_SIZE; j++) {
      my_array[j] = j+num_ops % MOD_VAL;
   }
   // Initialize histograms
   for (j = 0; j < NUM_THREADS; j++) {
      int i;
      for (i = 0; i < NUM_BINS; i++)
         my_hist[j][i] = 0;
   }


   // Initialize thread argument
   for (j = 0; j < NUM_THREADS; j++) 
   {
      thread_arg[j].array = (int *)&my_array;
      thread_arg[j].hist = (int *)&my_hist[j][0];
      thread_arg[j].max_value = MOD_VAL - 1;
      thread_arg[j].min_value = 0;
   }

   start = hthread_time_get();

   // Create the histogram thread
   for (j = 0; j < NUM_THREADS; j++) 
      //sta[j] = thread_create( &tid[j], &attr[j], histogram_thread_FUNC_ID, (void*)(&thread_arg[j]),DYNAMIC_HW,0 );
      sta[j] = thread_create( &tid[j], &attr[j], histogram_thread_FUNC_ID, (void*)(&thread_arg[j]),STATIC_HW0+j,0 );

   // Wait for the thread to exit
   for (j = 0; j < NUM_THREADS; j++) {
      if (thread_join( tid[j], ret[j], &exec_time[j] ))
         printf("Failed to join on thread %d\n", tid[j]);
   }

   stop = hthread_time_get();

   // Display thread times
   for (j = 0; j < NUM_THREADS; j++) { 
      // Determine which slave ran this thread based on address
      Huint base = attr[j].hardware_addr - HT_HWTI_COMMAND_OFFSET;
      Huint slave_num = (base & 0x00FF0000) >> 16;
      printf("Execution time (TID : %d, Slave : %d)  = %f msec\n", tid[j], slave_num, hthread_time_msec(exec_time[j]));
   }

   // Display OS overhead
   printf("Total OS overhead (thread_create) = %f usec\n", hthread_time_usec(create_overhead));
   printf("Total OS overhead (thread_join) = %f usec\n", hthread_time_usec(join_overhead));
   create_overhead=0;
   join_overhead=0;

   // Display overall time
   hthread_time_t diff; hthread_time_diff(diff, stop, start);
   printf("Total time = %f usec\n", hthread_time_usec(diff));
    

    // Clean up the attribute structures
    for (j = 0; j < NUM_THREADS; j++) 
      hthread_attr_destroy( &attr[j] );

    printf ("-- Complete --\n");

    // Return from main
    return 0;
}
#endif
