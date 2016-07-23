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

/** \file      instruction_ratios.c 
  * \brief     Program that combines the floating point (single precision),\n
  *            integer division, multiply, and shift micro-benchmarks\n
  *            Followed the 'Software support'\n
  *            guide in Microblaze Reference Manual
  *
  * \author    Eugene Cartwright <eugene@uark.edu>
  */

#include <hthread.h>
#include <accelerator.h>
#include <arch/htime.h>
#include <math.h>
#include <manager/manager.h>
   
void * fpu_shift_thread(void * arg);
void * shift_thread(void * arg);
void * mul32_thread(void * arg);
void * mul64_thread(void * arg);
void * idiv_thread(void * arg);
void * idivu_thread(void * arg);

//#define DEBUG_DISPATCH
#define OPCODE_FLAGGING

#ifndef HETERO_COMPILATION
#include <stdio.h>
#include <stdlib.h>
#include "instruction_ratios_prog.h"
#endif

#define NUM_THREADS  NUM_AVAILABLE_HETERO_CPUS

#if NUM_AVAILABLE_HETERO_CPUS != 5
#error "This program only supports 5 threads to be created."
#endif

typedef struct {
   Huint max;
   Huint shift_num;
} volatile fpu_shift_t;

// single precision floating point micro-benchmark
void * fpu_shift_thread (void * arg) {
   fpu_shift_t * data = (fpu_shift_t *) arg;
   Huint max = data->max;
   Huint shift_num = data->shift_num;
   Huint i = 0;
   volatile float sum = 0.0F, temp = 2.0F;

   volatile Hlong m = 0x15, j = 0x22, k = 0x3,l = 0x7; 
   m = m >> shift_num;
   j = j >> shift_num;
   k = k << shift_num;
   l = l << shift_num;
      
   for (i = 0; i < max; i++) {
      // Test multiplication
      temp *= temp;
      // Test multiplication and addition
      sum += temp;
   }

   volatile Huint success = poly_vectordiv(NULL, NULL, NULL, 0);
   success = poly_vectoradd(NULL, NULL, NULL, 0);

   return (void *) success;
}

void * shift_thread (void * arg) {
   Huint shift_num = (Huint) arg;
   volatile Hlong i = 0xCAFEBABE,j = 0xCAFEBABE,k = 0xCAFEBABE,l = 0xCAFEBABE; 
  
   for ( ; shift_num > 0; shift_num--) { 
      i = i >> shift_num;
      j = j >> shift_num;
      k = k << shift_num;
      l = l << shift_num;
   }
   
   return (void *) ((Hint) i);
}

// 32-bit integer multiplication
void * mul32_thread (void * arg) {
   Hint multiplier = (Hint) arg;
   Hint i = (Hint) arg; 
   Hint temp;
   Huint count = 0; 
   do {
      temp = i * multiplier;
      i++;
      multiplier--;
      count++;
   } while (temp > 0);

   return (void *) count;
}

// 64-bit integer multiplication
void * mul64_thread (void * arg) {
   Hint argument = (Hint) arg;
   Hlong multiplier = (Hlong) argument;
   Hlong i = (Hlong) argument; 
   Hlong temp;
   Huint count = 0;
   
   do {
      temp = i * multiplier;
      i++;
      multiplier--;
      count++;
   } while (temp > 0);

   return (void *) (count);
}

// Integer division (unsigned) micro-benchmark
void * idivu_thread (void * arg) {
   Huint max = (Huint) arg;
   Huint count = 0;
   volatile Huint temp =  2U;   
   while(max > 0) {
      if (temp != 0)
         max =(Huint) (max / temp);
      count++;
   }

   return (void *) count;
}

// Integer division (signed) micro-benchmark
void * idiv_thread (void * arg) {
   Hint min = (Huint) arg;
   Huint count = 0;
   volatile Hint temp =  -2;   
   do {
      if (temp != 0)
         min = (Hint) (min / temp);
      count++;
   } while(min != 0);

   return (void *) count;
}


#ifndef HETERO_COMPILATION
hthread_time_t exec_time[NUM_THREADS] PRIVATE_MEMORY;
hthread_t tid[NUM_THREADS] PRIVATE_MEMORY;
hthread_attr_t attr[NUM_THREADS] PRIVATE_MEMORY;
void * ret[NUM_THREADS] PRIVATE_MEMORY;

int main() {
  
   printf("--- Combined micro-benchmark ---\n"); 
#ifdef OPCODE_FLAGGING
   printf("Opcode flagging enabled\n");
#else
   printf("Opcode flagging disabled\n");
#endif
   // Initialize various host tables once.
   init_host_tables();

   Huint i = 0;
   for (i = 0; i < NUM_THREADS; i++) 
      hthread_attr_init(&attr[i]);

   fpu_shift_t * temp = (fpu_shift_t *) malloc (sizeof(fpu_shift_t));
   assert (temp != NULL);
   temp->max = 240;
   temp->shift_num = 1200;

   hthread_time_t start = hthread_time_get();
      
   thread_create(&tid[0], &attr[0], fpu_shift_thread_FUNC_ID, (void *) temp, DYNAMIC_HW, 0);
   //thread_create(&tid[0], &attr[0], fpu_shift_thread_FUNC_ID, (void *) temp, STATIC_HW0, 0);
   
   if (thread_join(tid[0], &ret[0], &exec_time[0]))
      printf("Join error!\n");

   
   hthread_time_t stop = hthread_time_get();
 
   free(temp); 
   // Display thread time
   // Determine which slave ran this thread based on address
   Huint base = attr[0].hardware_addr - HT_HWTI_COMMAND_OFFSET;
   Huint slave_num = (base & 0x00FF0000) >> 16;
   printf("Execution time (TID : %d, Slave : %d, Result = %d)  = %f usec\n", tid[0], slave_num, (unsigned int) ret[0], hthread_time_usec(exec_time[0]));

   // Display OS overhead
   printf("Total OS overhead (thread_create) = %f usec\n", hthread_time_usec(create_overhead));
   printf("Total OS overhead (thread_join) = %f usec\n", hthread_time_usec(join_overhead));
   create_overhead=0;
   join_overhead=0;

   // Display overall time
   hthread_time_t diff; hthread_time_diff(diff, stop, start);
   printf("Total time = %f usec\n", hthread_time_usec(diff));

   printf("--- Done ---\n");
      
   return 0;
}
#endif
