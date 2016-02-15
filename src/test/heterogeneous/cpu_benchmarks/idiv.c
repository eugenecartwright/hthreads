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

/** \file      idiv.c 
  * \brief     Integer division micro-benchmark\n
  *            GCC will include '__udivsi3' subroutine\n
  *            if this processor doesn't have integer\n 
  *            division unit to perform unsigned division.
  *
  * \author    Eugene Cartwright <eugene@uark.edu>
  */

#include <hthread.h>
#include <arch/htime.h>

void * idiv_thread(void * arg);
void * idivu_thread(void * arg);

#ifndef HETERO_COMPILATION
#include <stdio.h>
#include <stdlib.h>
#include "idiv_prog.h"
#endif


// Integer division (unsigned) micro-benchmark
void * idivu_thread (void * arg) {
   Huint max = (Huint) arg;

   Huint temp =  2U;   
   while(max > 0) {
      if (temp != 0)
         max =(Huint) (max / temp);
      temp++;
   }

   return (void *) temp;
}

// Integer division (signed) micro-benchmark
void * idiv_thread (void * arg) {
   Hint min = (Huint) arg;

   Hint temp =  -2;   
   do {
      if (temp != 0)
         min = (Hint) (min / temp);
      temp--;
   } while(min != 0);

   return (void *) temp;
}


#ifndef HETERO_COMPILATION
int main() {
  
   printf("--- Integer Divide micro-benchmark ---\n"); 
   init_host_tables();

   hthread_t tid[NUM_AVAILABLE_HETERO_CPUS];
   hthread_attr_t attr[NUM_AVAILABLE_HETERO_CPUS];
   void * ret[NUM_AVAILABLE_HETERO_CPUS];

   Huint i = 0;
   printf("Unsigned Integer Division:\n"); 
   for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
      hthread_attr_init(&attr[i]);
      thread_create(&tid[i], &attr[i], idivu_thread_FUNC_ID, (void *) HUINT_MAX, STATIC_HW0+i, 0);
   }

   for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
      hthread_join(tid[i], &ret[i]);
      hthread_time_t * slave_time = (hthread_time_t *) (attr[i].hardware_addr - HT_CMD_HWTI_COMMAND + HT_CMD_VHWTI_EXEC_TIME_HI);
      printf("Time reported by slave nano kernel #%02d = %f usec\n", i,hthread_time_usec(*slave_time));
   }
   
   printf("Signed Integer Division:\n"); 
   for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
      hthread_attr_init(&attr[i]);
      thread_create(&tid[i], &attr[i], idiv_thread_FUNC_ID, (void *) HINT_MIN, STATIC_HW0+i, 0);
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
