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

/** \file      mul32.c 
  * \brief     32-bit integer multiplication  micro-benchmark
  *
  * \author    Eugene Cartwright <eugene@uark.edu>
  */

#include <hthread.h>
#include <arch/htime.h>

void * mul32_thread(void * arg);

#ifndef HETERO_COMPILATION
#include <stdio.h>
#include <stdlib.h>
#include "mul32_prog.h"
#endif

// 32-bit integer multiplication
void * mul32_thread (void * arg) {
   Hint multiplier = (Hint) arg;
   Hint i = (Hint) arg; 
   Hint temp;
   
   do {
      temp = i * multiplier;
      i++;
      multiplier--;
   } while (temp > 0);

   return (void *) multiplier;
}


#ifndef HETERO_COMPILATION
int main() {
  
   printf("--- mul32 micro-benchmark ---\n"); 
   load_my_table();

   hthread_t tid[NUM_AVAILABLE_HETERO_CPUS];
   hthread_attr_t attr[NUM_AVAILABLE_HETERO_CPUS];
   void * ret[NUM_AVAILABLE_HETERO_CPUS];

   Huint i = 0;
   for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
      hthread_attr_init(&attr[i]);
      thread_create(&tid[i], &attr[i], mul32_thread_FUNC_ID, (void *) 200, STATIC_HW0+i, 0);
   }

   for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
      hthread_join(tid[i], &ret[i]);
      hthread_time_t * slave_time = (hthread_time_t *) (attr[i].hardware_addr - HT_CMD_HWTI_COMMAND + HT_CMD_VHWTI_EXEC_TIME_HI);
      printf("Time reported by slave nano kernel #%02d = %f usec\n", i,hthread_time_usec(*slave_time));
   }

   printf("--- Done ---\n");
      
   return 0;
}
#endif
