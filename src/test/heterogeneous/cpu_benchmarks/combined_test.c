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

/** \file      combined_test.c 
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
   
void * fpu_thread(void * arg);
void * shift_thread(void * arg);
void * mul32_thread(void * arg);
void * mul64_thread(void * arg);
void * idiv_thread(void * arg);
void * idivu_thread(void * arg);

//#define DEBUG_DISPATCH
#define OPCODE_FLAGGING
#define HOMOGENEOUS_TASK

#ifndef HETERO_COMPILATION
#include <stdio.h>
#include <stdlib.h>
#include "combined_test_prog.h"
#endif

#define NUM_THREADS  NUM_AVAILABLE_HETERO_CPUS

#if NUM_AVAILABLE_HETERO_CPUS != 5
#error "This program only supports 5 threads to be created."
#endif

// single precision floating point micro-benchmark
void * fpu_thread (void * arg) {
   Huint max = (Huint) arg;
   Huint i = 0;
   float sum = 0.0F, temp = 2.0F;
   
   for (i = 0; i < max; i++) {
   //while(temp < HFLOAT_MAX) {
      // Test multiplication
      temp *= temp;
      // Test multiplication and addition
      sum += temp;
      // Test sqrt (C_USE_FPU = 2)
      sum += sqrtf(sum);
      // Test divide
      sum /= temp;
   }

   return (void *) status;
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
#ifdef HOMOGENEOUS_TASK
   printf("Homogeneous Load\n");
#else
   printf("Heterogeneous Load\n");
#endif
   // Initialize various host tables once.
   init_host_tables();

   Huint i = 0;
   for (i = 0; i < NUM_THREADS; i++) 
      hthread_attr_init(&attr[i]);

   hthread_time_t start = hthread_time_get();

#ifdef HOMOGENEOUS_TASK
   // Create a homogeneous load
   for (i = 0; i < NUM_THREADS; i++) {
      // Shift
      //thread_create(&tid[i], &attr[i], shift_thread_FUNC_ID, (void *) 240, DYNAMIC_HW, 0);
      
      // Floating point
      //thread_create(&tid[i], &attr[i], fpu_thread_FUNC_ID, (void *) 48, DYNAMIC_HW, 0);

      // Unsigned integer divide
      thread_create(&tid[i], &attr[i], idivu_thread_FUNC_ID, (void *) (HUINT_MAX/5), DYNAMIC_HW, 0);

      // Mul32
      //thread_create(&tid[i], &attr[i], mul32_thread_FUNC_ID, (void *) 1200, DYNAMIC_HW, 0);

      // Mul64
      //thread_create(&tid[i], &attr[i], mul64_thread_FUNC_ID, (void *) 1440, DYNAMIC_HW, 0);
   }
#else
   // Shift
   thread_create(&tid[0], &attr[0], shift_thread_FUNC_ID, (void *) 1200, DYNAMIC_HW, 0);
   
   // Floating point
   thread_create(&tid[1], &attr[1], fpu_thread_FUNC_ID, (void *) 240, DYNAMIC_HW, 0);

   // Unsigned integer divide
   thread_create(&tid[2], &attr[2], idivu_thread_FUNC_ID, (void *) HUINT_MAX, DYNAMIC_HW, 0);
   
   // Mul64
   thread_create(&tid[3], &attr[3], mul64_thread_FUNC_ID, (void *) 3600, DYNAMIC_HW, 0);
   
   // Mul32
   thread_create(&tid[4], &attr[4], mul32_thread_FUNC_ID, (void *) 7200, DYNAMIC_HW, 0);

#endif
   
   for (i = 0; i < NUM_THREADS; i++) {
      if (thread_join(tid[i], &ret[i], &exec_time[i]))
         printf("Join error!\n");
   }
   
   hthread_time_t stop = hthread_time_get();
  
   // Display thread times
   for (i = 0; i < NUM_THREADS; i++) { 
      // Determine which slave ran this thread based on address
      Huint base = attr[i].hardware_addr - HT_HWTI_COMMAND_OFFSET;
      Huint slave_num = (base & 0x00FF0000) >> 16;
      printf("Execution time (TID : %d, Slave : %d, Result = %d)  = %f usec\n", tid[i], slave_num, (unsigned int) ret[i], hthread_time_usec(exec_time[i]));
   }

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
