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

/** \file      combined_test2.c 
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
#include "tuning_table.h"
   
void * fpu_thread(void * arg);
void * shift_thread(void * arg);
void * mul32_thread(void * arg);
void * mul64_thread(void * arg);
void * idiv_thread(void * arg);
void * idivu_thread(void * arg);

#define OPCODE_FLAGGING
#define CHECK_FIRST_POLYMORPHIC
//#define FORCE_POLYMORPHIC_HW
//#define FORCE_POLYMORPHIC_SW


//#define DEBUG_DISPATCH
//#define VERIFY

#ifndef HETERO_COMPILATION
#include <stdio.h>
#include <stdlib.h>
#include "combined_test2_prog.h"
#endif

#define NUM_THREADS  NUM_AVAILABLE_HETERO_CPUS

#if NUM_AVAILABLE_HETERO_CPUS != 5
#error "This program only supports 5 threads to be created."
#endif

typedef struct {
   Hint * dataA;
   Hint * dataB; 
   Hint * dataC;  
   Huint size;  //The size of vector for crc,sort, vectoradd and vectormul. For Matrix Multiply, it's the size of the dimension of the squre matrix.
   Huint value;
} volatile data;

// single precision floating point micro-benchmark
void * fpu_thread (void * arg) {
   data *package = (data*) arg;
   Huint max = package->value;
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

   // Perform polymorphic function
   return (void *) (poly_bubblesort(package->dataA, (Huint) package->size));
}

void * shift_thread (void * arg) {
   data *package = (data*) arg;
   Huint shift_num = (Huint) package->value;
   volatile Hlong i = 0xCAFEBABE,j = 0xCAFEBABE,k = 0xCAFEBABE,l = 0xCAFEBABE; 
  
   for ( ; shift_num > 0; shift_num--) { 
      i = i >> shift_num;
      j = j >> shift_num;
      k = k << shift_num;
      l = l << shift_num;
   }
   
   return (void *) (poly_crc(package->dataA, (Huint) package->size));
}

// 32-bit integer multiplication
void * mul32_thread (void * arg) {
   data *package = (data*) arg;
   Hint multiplier = (Hint) package->value;
   Hint i = (Hint) arg; 
   Hint temp;
   do {
      temp = i * multiplier;
      i++;
      multiplier--;
   } while (temp > 0);

   package->value = multiplier;

   return (void *) (poly_vectorsub((void *) package->dataA,(void *) package->dataB, (void *) package->dataC, (Huint) package->size));
}

// 64-bit integer multiplication
void * mul64_thread (void * arg) {
   data *package = (data*) arg;
   Hint argument = (Hint) package->value;
   Hlong multiplier = (Hlong) argument;
   Hlong i = (Hlong) argument; 
   Hlong temp;
   
   do {
      temp = i * multiplier;
      i++;
      multiplier--;
   } while (temp > 0);

   package->value = multiplier;

   return (void *) (poly_vectormul((void *) package->dataA,(void *) package->dataB, (void *) package->dataC, (Huint) package->size));
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
  
   // Initialize various host tables once.
   init_host_tables();

   printf("--- Combined micro-benchmark ---\n"); 
#ifdef OPCODE_FLAGGING
   printf("Opcode flagging enabled\n");
#else
   printf("Opcode flagging disabled\n");
#endif
#ifdef CHECK_FIRST_POLYMORPHIC
   printf("CHECK FIRST POLYMORPHIC FUNCTION enabled\n");
#else
   printf("CHECK FIRST POLYMORPHIC FUNCTION disabled\n");
#endif
#ifdef FORCE_POLYMORPHIC_HW
   printf("Forcing slaves to choose HARDWARE for polymorphic functions\n");
#elif defined FORCE_POLYMORPHIC_SW
   printf("Forcing slaves to choose SOFTWARE for polymorphic functions\n");
#else
   printf("Slaves will decided between HW or SW for polymorphic functions\n");
#endif

   /*-------------------------------------------------------*/
   /*                    BUBBLESORT                         */
   /*-------------------------------------------------------*/
   int *list = (int *) malloc(_LIST_LENGTH * sizeof(int));
   assert(list != NULL);
   // initialized the list 
   Huint i;
   for (i = 0; i < _LIST_LENGTH; i++) {
      list[i] = _LIST_LENGTH-i;
   }

   // fpu_thread will have bubblesort call
   data bubblesort;
   bubblesort.size = _LIST_LENGTH;
   bubblesort.dataA = &list[0];
   bubblesort.value = 240; 

   /*-------------------------------------------------------*/
   /*                        CRC                            */
   /*-------------------------------------------------------*/
   Hint * input;
   Hint * check, index = 0;
   input = (Hint*) malloc(_ARRAY_SIZE * sizeof(Hint));
   check = (Hint *) malloc(_ARRAY_SIZE * sizeof(Hint)); 
   assert(input != NULL);
   assert(check != NULL);

   // Initializing the data
   Hint *ptr = input;
   for(index = 0; index < _ARRAY_SIZE; index++) {
      *ptr = (rand() % 1000)*8;	
      *(check+index) = *ptr;
      ptr++;
   }

   // shift_thread will have crc call
   data crc;
   crc.size = _ARRAY_SIZE;
   crc.dataA = input;
   crc.value = 1200;

   /*-------------------------------------------------------*/
   /*                     VectorSubtraction                 */
   /*-------------------------------------------------------*/
   data vectorsub;
   vectorsub.size = _ARRAY_SIZE;
   // mul32_thread will have vectorsubtraction call
   vectorsub.value = 7200;
   vectorsub.dataA = (Hint*) malloc(_ARRAY_SIZE * sizeof(Hint)); 	
   vectorsub.dataB = (Hint*) malloc(_ARRAY_SIZE * sizeof(Hint)); 	
   vectorsub.dataC = (Hint*) malloc(_ARRAY_SIZE * sizeof(Hint)); 	
   assert(vectorsub.dataA != NULL);
   assert(vectorsub.dataB != NULL);
   assert(vectorsub.dataC != NULL);
   
   for( i = 0; i < _ARRAY_SIZE; i++) {
      vectorsub.dataA[i] = (Hint) rand() % 1000; 
      vectorsub.dataB[i] = (Hint) rand() % 1000; 
      vectorsub.dataC[i] = 0; 
   }

   /*-------------------------------------------------------*/
   /*                     VectorMultiplication              */
   /*-------------------------------------------------------*/
   data vectormul;
   vectormul.size = _ARRAY_SIZE;
   // mul64_thread will have vectormultiplication call
   vectormul.value = 3200;
   vectormul.dataA = (Hint*) malloc(_ARRAY_SIZE * sizeof(Hint)); 	
   vectormul.dataB = (Hint*) malloc(_ARRAY_SIZE * sizeof(Hint)); 	
   vectormul.dataC = (Hint*) malloc(_ARRAY_SIZE * sizeof(Hint)); 	
   assert(vectormul.dataA != NULL);
   assert(vectormul.dataB != NULL);
   assert(vectormul.dataC != NULL);
   
   for( i = 0; i < _ARRAY_SIZE; i++) {
      vectormul.dataA[i] = (Hint) rand() % 1000; 
      vectormul.dataB[i] = (Hint) rand() % 1000; 
      vectormul.dataC[i] = 0; 
   }

     
   for (i = 0; i < NUM_THREADS; i++) 
      hthread_attr_init(&attr[i]);

   hthread_time_t start = hthread_time_get();

   // Shift
   thread_create(&tid[0], &attr[0], shift_thread_FUNC_ID, (void *) &crc, DYNAMIC_HW, 0);
   
   // Floating point
   thread_create(&tid[1], &attr[1], fpu_thread_FUNC_ID, (void *) &bubblesort, DYNAMIC_HW, 0);

   // Unsigned integer divide
   thread_create(&tid[2], &attr[2], idivu_thread_FUNC_ID, (void *) HUINT_MAX, DYNAMIC_HW, 0);
   
   // Mul64
   thread_create(&tid[3], &attr[3], mul64_thread_FUNC_ID, (void *) &vectormul, DYNAMIC_HW, 0);
   
   // Mul32
   thread_create(&tid[4], &attr[4], mul32_thread_FUNC_ID, (void *) &vectorsub, DYNAMIC_HW, 0);

   
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
  
#ifdef VERIFY 
   // Check Bubblesort results
   for (i = 0; i < _LIST_LENGTH-1; i++) {
      if (list[i] > list[i+1]) {
         printf("Bubblesort FAILED\n");
         i = _LIST_LENGTH;
      }
   }
   free(list);

   // Check CRC results
   if (poly_crc(check, _ARRAY_SIZE)) {
      printf("Host failed to generate CRC check of data\n");
      while(1);
   }
   // For CRC Results
   for ( i = 0; i < _ARRAY_SIZE; i++) {
      if (*(input+i) != *(check+i) )  {
         printf("CRC FAILED\n");
         i = _ARRAY_SIZE;
      }
   } 
   free(check);
   free(input);

   // Check VectorSub results
   for (i=0 ; i < _ARRAY_SIZE; i++) {
      if ( vectorsub.dataC[i] != (vectorsub.dataA[i] - vectorsub.dataB[i]))  {
         printf("Vectorsubtraction FAILED\n");
         i = _ARRAY_SIZE;
      }
   } 
   // Release memory
   free(vectorsub.dataA);
   free(vectorsub.dataB);
   free(vectorsub.dataC);
   
   // Check VectorMul results
   for (i=0 ; i < _ARRAY_SIZE; i++) {
      if ( vectormul.dataC[i] != (vectormul.dataA[i] * vectormul.dataB[i]))  {
         printf("VectorMultiplication FAILED\n");
         i = _ARRAY_SIZE;
      }
   }
   // Release memory
   free(vectormul.dataA);
   free(vectormul.dataB);
   free(vectormul.dataC);
#endif

   printf("--- Done ---\n");
      
   return 0;
}
#endif
