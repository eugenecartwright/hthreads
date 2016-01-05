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
//#define NUM_THREADS  (NUM_AVAILABLE_HETERO_CPUS)
#define NUM_THREADS  1
#define NUM_TRIALS   (1)
#define NUM_BINS     (8)

#define OPCODE_TAGGING

// Array size
#define ARR_SIZE    2048

// Used to initialize array
// with elements 0 - (MOD_VAL-1)
#define MOD_VAL    4

// Thread argument definition
typedef struct
{
   hthread_time_t diff;
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
   int i = 0;
   int bin = 0;
   int val = 0;
   int * data;
   int * hist = targ->hist;
   for (i = 0; i < NUM_BINS; i++)
      hist[i] = 0;

   data = targ->array;
   hthread_time_t start = hthread_time_get();

   // Calculate histogram
   int diff = (targ->max_value - targ->min_value);
   int bin_width = diff / NUM_BINS;
   int divider = bin_width + (NUM_BINS - (diff % NUM_BINS));
    
   for (i = 0; i < ARR_SIZE; i++) {
      // Extract array value
      val = data[i];

      // Calculate bin number
      bin = val / divider;

      // Update histogram
      //targ->hist[bin] = targ->hist[bin] + 1;
      hist[bin]++;
    }
   hthread_time_t stop = hthread_time_get();
/*
   for (i = 0; i < NUM_BINS; i++) {
      // TODO: something is happening here
      putnum(&targ->hist[i]);
      targ->hist[i] = hist[i];
   }
*/
   hthread_time_t diff1;
   hthread_time_diff(diff1, stop, start);
   targ->diff = diff1;
   putnum(2);
   
   return (void*)(SUCCESS);
}


#ifndef HETERO_COMPILATION
#include "histogram_prog.h"

// TODO: Need to transfer data locally as
// what governs execution time looks more like
// memory I/O
int main( int argc, char *argv[] ) 
{
   // Timer variables
   hthread_time_t time_start, time_stop, diff;

   // Thread attribute structures
   Huint            sta[NUM_THREADS];
   int             retval[NUM_THREADS];
   hthread_t        tid[NUM_THREADS];
   hthread_attr_t   attr[NUM_THREADS];
   targ_t * thread_arg = (targ_t *) malloc(sizeof(targ_t) * NUM_THREADS);
   assert (thread_arg != NULL);

   // Array Structures
   int my_array[ARR_SIZE];
   int my_hist[NUM_THREADS][NUM_BINS];

   int num_ops = 0, j = 0;;
   printf( "\n****Main Thread****... \n" );

   // Initialize the attributes for the hardware threads
   for (j = 0; j < NUM_THREADS; j++) 
      hthread_attr_init( &attr[j]);

   for( num_ops = 0; num_ops < NUM_TRIALS; num_ops++)
   {
      printf("******* Round %5d ********\n",num_ops);
      
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
         thread_arg[j].diff = 1;
      }

      time_start = hthread_time_get();

      // Create the histogram thread
      for (j = 0; j < NUM_THREADS; j++) 
         //sta[j] = thread_create( &tid[j], &attr[j], histogram_thread_FUNC_ID, (void*)(&thread_arg[j]),DYNAMIC_HW,0 );
         sta[j] = thread_create( &tid[j], &attr[j], histogram_thread_FUNC_ID, (void*)(&thread_arg[j]),STATIC_HW0+j,0 );

	   // Wait for the thread to exit
      for (j = 0; j < NUM_THREADS; j++) {
	      if (hthread_join( tid[j], (void *) &retval[j] ))
            printf("Failed to join on thread %d\n", tid[j]);
      }
   
      time_stop = hthread_time_get();
    
     printf("Displaying Results\n"); 
      // Display total time
      hthread_time_diff(diff, time_stop, time_start);
      printf("HOST: Elapsed time     =  %f usec\n",hthread_time_usec(diff));
      
      for (j = 0; j < NUM_THREADS; j++) { 
         hthread_time_t * slave_time = (hthread_time_t *) (attr[j].hardware_addr - HT_CMD_HWTI_COMMAND + HT_CMD_VHWTI_EXEC_TIME_HI);
         printf("Elapsed time by slave nano kernel #%02d = %f usec\n", j,hthread_time_usec(*slave_time));
         printf("SLAVE:Calculation time =  %f usec\n",hthread_time_usec(thread_arg[j].diff));
      }

    }

    // Clean up the attribute structures
    for (j = 0; j < NUM_THREADS; j++) 
      hthread_attr_destroy( &attr[j] );

    printf ("-- Complete --\n");

    // Return from main
    return 0;
}
#endif
