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

/** \file      test_dma.c 
  * \brief     DMA test program\n
  *
  * \author    Eugene Cartwright <eugene@uark.edu>
  */

#include <hthread.h>
#include <arch/htime.h>
#include <accelerator.h>
#include <math.h>

void * test_dma_thread(void * arg);
#define SIZE   10

#ifndef HETERO_COMPILATION
#include <stdio.h>
#include <stdlib.h>
#include "test_dma_prog.h"
#endif

typedef struct {
   int * A;
   int * B;
} volatile data_t;

void * test_dma_thread(void * arg) {

   #ifdef HETERO_COMPILATION
   data_t * test = (data_t *) arg;
   // DRAM to DRAM (Host heap to Host heap)
   if(transfer_dma( (void *) test->A, (void *) test->B, SIZE * 4))
      return (void *) FAILURE;
   else 
      return (void *) SUCCESS;
#else
   return (void *) SUCCESS;
#endif
}


#ifndef HETERO_COMPILATION
int main() {
  
   printf("--- DMA test ---\n"); 
   init_host_tables();

   hthread_t tid[NUM_AVAILABLE_HETERO_CPUS];
   hthread_attr_t attr[NUM_AVAILABLE_HETERO_CPUS];
   void * ret[NUM_AVAILABLE_HETERO_CPUS];
   Huint i = 0;
   Huint j;

   data_t test[NUM_AVAILABLE_HETERO_CPUS]; 
   for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
      test[i].A = (int *) malloc(sizeof(int) * SIZE);
      test[i].B = (int *) malloc(sizeof(int) * SIZE);

      assert(test[i].A != NULL);
      assert(test[i].B != NULL);
   }
   for (j = 0; j < NUM_AVAILABLE_HETERO_CPUS; j++) {
      for (i = 0; i < SIZE; i++) {
         test[j].A[i] = i;
         test[j].B[i] = 0;
      }
   }
   
   for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
      hthread_attr_init(&attr[i]);
      thread_create(&tid[i], &attr[i], test_dma_thread_FUNC_ID, (void *) &test[i], STATIC_HW0+i, 0);
   }

   for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
      hthread_join(tid[i], &ret[i]);
      hthread_time_t * slave_time = (hthread_time_t *) (attr[i].hardware_addr - HT_CMD_HWTI_COMMAND + HT_CMD_VHWTI_EXEC_TIME_HI);
      printf("Time reported by slave nano kernel #%02d = %f usec\n", i,hthread_time_usec(*slave_time));
   }

   // Print out results
   for (j = 0; j < NUM_AVAILABLE_HETERO_CPUS; j++) {
      printf("----------------Slave %d-------------------------\n", j);
      for (i = 0; i < SIZE; i++) {
         if (test[j].B[i] != test[j].A[i]) {
            printf("Test FAILED!\n");
            while(1);
         }
         printf("%d\t", test[j].B[i]);
      }
      printf("\n");
   }

   printf("--- Done ---\n");
      
   return 0;
}
#endif
