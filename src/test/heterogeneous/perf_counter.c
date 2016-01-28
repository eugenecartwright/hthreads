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

/** \file      perf_counter.c 
  * \brief     Integer division micro-benchmark\n
  *            GCC will include '__udivsi3' subroutine\n
  *            if this processor doesn't have integer\n 
  *            division unit to perform unsigned division.
  *
  * \author    Eugene Cartwright <eugene@uark.edu>
  */

#include <hthread.h>
#include <arch/htime.h>

void * perf_counter_thread(void * arg);

#ifndef HETERO_COMPILATION
#include <stdio.h>
#include <stdlib.h>
#include "perf_counter_prog.h"
#endif

//0x4140
#define  MDM_BASEADDR         XPAR_PERIPHERALS_MDM_1_BASEADDR
#define  DBG_STATUS           (MDM_BASEADDR + 0x10)
#define  DBG_CTRL             (MDM_BASEADDR + 0x10)
#define  DBG_DATA             (MDM_BASEADDR + 0x14)
#define  DBG_LOCK             (MDM_BASEADDR + 0x18)


// Performance Counter Thread
void * perf_counter_thread (void * arg) {
   Hint min = (Huint) arg;

   Hint temp =  -2;   
   do {
      min = (Hint) (min / temp);
      temp--;
   } while(min != 0);

   return (void *) temp;
}

/**
 * Function to write specified command to MDM CTRL register.
 */
void mdm_cmd(unsigned int  cmd) {
	volatile unsigned int * status  = (unsigned int *) DBG_STATUS;
	volatile unsigned int * control = (unsigned int *) DBG_CTRL;

	do {
		*control = cmd;
	} while( *status != 0x1);

	return;
}


#ifndef HETERO_COMPILATION
int main() {
  
   printf("--------------------------------\n");
   printf("--- Performance Counter Test ---\n");
   printf("--------------------------------\n");
   volatile Huint * status  = (Huint *) DBG_STATUS;
   volatile Huint * control = (Huint *) DBG_CTRL;
   volatile Huint * data    = (Huint *) DBG_DATA;
   volatile Huint * lock    = (Huint *) DBG_LOCK;
   int i,j, k=0;

   Huint event_num[] = {28, 0};
   Huint event_num_size = sizeof(event_num) / sizeof(Huint);
   //Huint latency_num[] = {62, 63};
   //Huint latency_num_size = sizeof(latency_num) / sizeof(Huint);
   int size = (NUM_AVAILABLE_HETERO_CPUS+1) * event_num_size;

   // Gain access to DBG_CTRL and DBG_DATA 
   // registers in MDM by writing magic num
   *lock = 0xebab;
   
#if 0
   do {
      *control = 0x6181F;
   } while( *status != 0x1);
   printf("MDM configuration = 0x%08x\n", *data);

   // Set all debug registers at once for all ports (excluding
   // the port that host processor is connected to.).
   Huint which_processor = 0;
   for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++)
      which_processor |= (1 << (i+1));
   do {
      *control = 0x61A07;
   } while( *status != 0x1);
   *data = which_processor; 
#endif

   for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS+1; i++) 
   {
      if (i == 0)
         printf("Reading Host Counter configuration\n");
      else
         printf("Reading Slave %d Counter configuration\n", i);
      

      // Specify which Processor (DEBUG Port) you are configuring
      mdm_cmd(0x61A07);
      *data = (1 << (i)); // Processor 0/Port 0 corresponds to Host
      unsigned int temp = 1 << (i+1);
      //printf("Specifying processor with argument = %u\n",temp); // Processor 0/Port 0 corresponds to Host
      
      // Write to Performance Counter Command
      // Register to reset event counter access
      // back to first one.
		mdm_cmd(0x8A404); 
		*data = 0x1;
      
      // Specify Events Counters by writing repeatedly the events numbers
		for( j = 0; j < event_num_size; j++) {
			mdm_cmd(0x8A207);
			*data = event_num[j];
		}
      
      // Write to Performance Counter Command
      // Register to reset event counter access
      // back to first one.
		mdm_cmd(0x8A404); 
		*data = 0x1;

      // Specify initial values for those event counters
		for( j = 0; j < event_num_size; j++) {
			mdm_cmd(0x8AE1F);
			*data = j*5 + 65;
		}

      // Write to Performance Counter Command
      // Register to reset event counter access
      // back to first one.
		mdm_cmd(0x8A404); 
		*data = 0x1;
      
#if 0
      // Clear and start all counters for this processor
		mdm_cmd(0x8A404);
      *data = 0x18;   // Clear and start
      //*data = 0x08;     // Start
#endif
      
      // Sample and stop all counters for this processor
		mdm_cmd(0x8A404);
		*data = 0x2;
		mdm_cmd(0x8A404);
		*data = 0x4;
      
      
#if 0
      // Write to Performance Counter Command
      // Register to reset event counter access
      // back to first one.
		mdm_cmd(0x8A404);
      *data = 0x1;
     
      // Check for Overflow and Full bits
      for( j = 0; j < event_num_size; j++) {
		   mdm_cmd(0x8A601);
         printf("Overflow-Full 0x%02x\n", *data);
      }
#endif
      
      // Write to Performance Counter Command
      // Register to reset event counter access
      // back to first one.
		mdm_cmd(0x8A404); 
		*data = 0x1;
      
      // Read events and latency counters
      for( j = 0; j < event_num_size; j++) {
         printf("Event #%02d = ", event_num[j]);
			mdm_cmd(0x8AC1F);
         printf("%d\n", *data);
      }
		
      mdm_cmd(0x4A404); 
		*data = 0x1;
   }

		*lock = 0;

#if 0
   /* ------------------------------------------------------------------------------------------------ */
   /* 
   load_my_table();

   hthread_t tid[NUM_AVAILABLE_HETERO_CPUS];
   hthread_attr_t attr[NUM_AVAILABLE_HETERO_CPUS];
   void * ret[NUM_AVAILABLE_HETERO_CPUS];

   for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
      hthread_attr_init(&attr[i]);
      thread_create(&tid[i], &attr[i], perf_counter_thread_FUNC_ID, (void *) HUINT_MAX, STATIC_HW0+i, 0);
   }

   for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
      hthread_join(tid[i], &ret[i]);
      hthread_time_t * slave_time = (hthread_time_t *) (attr[i].hardware_addr - HT_CMD_HWTI_COMMAND + HT_CMD_VHWTI_EXEC_TIME);
      printf("Time reported by slave nano kernel #%02d = %f usec\n", i,hthread_time_usec(*slave_time));
   }
   */
   /* ------------------------------------------------------------------------------------------------ */

   for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
      // Specify which Processor (DEBUG Port) you are configuring
      printf("Reading Slave %d Counter configuration\n", i);
      do {
         *control = 0x61A07;
      } while( *status != 0x1);
      *data = 1 << (i+1); // Processor 0/Port 0 corresponds to Host
      
      // Sample for Slave i
      do {
         *control = 0x4A404;
      } while(*status != 0x1);
      *data = 0x2;
      
      // Stop counters for Slave i
      do {
         *control = 0x4A404;
      } while(*status != 0x1);
      *data = 0x4;
      
      // Write to Performance Counter Command
      // Register to reset event counter access
      // back to first one.
      do {
         *control = 0x4A404;
      } while(*status != 0x1);
      *data = 0x1;

      // Check for Overflow and Full bits
      for( j = 0; j < event_num_size; j++) {
         do {
            *control = 0x4A601;
         } while(*status != 0x1);
         printf("Overflow-Full 0x%02x\n", *data);
      }
      
      // Write to Performance Counter Command
      // Register to reset event counter access
      // back to first one.
      do {
         *control = 0x4A404;
      } while(*status != 0x1);
      *data = 0x1;


      // Read events and latency counters
      for( j = 0; j < event_num_size; j++) {
         printf("Event #%02d = ", event_num[j]);
         do {
            *control = 0x4AC1F;
         } while(*status != 0x1);
         printf("%d\n", *data);
      }
     /* 
      for( j = 0; j < latency_num_size; j++) {
         printf("Latency #%d = ", latency_num[j]);
         do {
            *control = 0x4AC1F;
         } while(*status != 0x1);
         printf("%d\n", *data);
      }
      */
   }
#endif
   // Write anything other than the magic num to 
   // lock access to MDM DBG registers.
   //printf("Locking access to MDM\n");
   *lock = 0;


   printf("--- Done ---\n");
      
   return 0;
}
#endif
