/* PI.c program
 * Author: Eugene
 * Date: 1/14/2016
 *
 * Description: Program calculates pi using the
 * Nilakantha series.
 */

#include <stdio.h>
#include <stdlib.h>
#include <hthread.h>
#include <arch/htime.h>

#define NUM_THREADS  NUM_AVAILABLE_HETERO_CPUS
//#define OPCODE_FLAGGING

#define  MAX_ITERATIONS  1000

typedef struct {
   float pi;
   Huint  MaxIterations;
} targ_t;

// TODO: While 32-bit floats can only hold up to 7 digits
// of accuracy, we can still simulate the work of performing
// more iterations to achieve a greater level of accuracy.
void * pi_thread(void * arg) {

   targ_t * thread_data = (targ_t *) arg;
   volatile Huint MaxIterations = thread_data->MaxIterations;
   volatile Huint n = 0;
   register float pi = 3.0f;
   register float i = 2.0f;
   for (n = 0; n < MaxIterations; n++) {
      if ((n % 2) == 0)
         pi += (4.0f / (i * (i+1.0f) * (i+2.0f)));
      else
         pi -= (4.0f / (i * (i+1.0f) * (i+2.0f)));
      i+=2.0f;
   }

   // Write results back
   thread_data->pi = pi;

   return (void *) SUCCESS;

}


#ifndef HETERO_COMPILATION
#include "pi_prog.h"

hthread_time_t exec_time[NUM_THREADS] PRIVATE_MEMORY;
hthread_t tid[NUM_THREADS] PRIVATE_MEMORY;
hthread_attr_t attr[NUM_THREADS] PRIVATE_MEMORY;
void * ret[NUM_THREADS] PRIVATE_MEMORY;

int main() {
   
   printf("--- Calculating PI benchmark ---\n"); 
   printf("ITERATIONS: %d\n", MAX_ITERATIONS);
#ifdef OPCODE_FLAGGING
   printf("-->Opcode flagging ENABLED\n");
#else
   printf("-->Opcode flagging DISABLED\n");
#endif
   // Initialize various host tables once.
   init_host_tables();

   Huint i = 0;
   targ_t thread_data[NUM_THREADS];
   for (i = 0; i < NUM_THREADS; i++) {
      hthread_attr_init(&attr[i]);
      thread_data[i].pi = 0;
      thread_data[i].MaxIterations = MAX_ITERATIONS;
   }

   hthread_time_t start = hthread_time_get();
   
   for (i = 0; i < NUM_THREADS; i++) 
      thread_create(&tid[i], &attr[i], pi_thread_FUNC_ID, (void *) &thread_data[i], STATIC_HW0+i, 0);
   
   for (i = 0; i < NUM_THREADS; i++) {
      if (thread_join(tid[i], ret[i], &exec_time[i]))
         printf("Join error!\n");
   }
   
   hthread_time_t stop = hthread_time_get();
  
   // Display thread times
   for (i = 0; i < NUM_THREADS; i++) { 
      // Determine which slave ran this thread based on address
      Huint base = attr[i].hardware_addr - HT_HWTI_COMMAND_OFFSET;
      Huint slave_num = (base & 0x00FF0000) >> 16;
      printf("Execution time (TID : %d, Slave : %d, Result = %f)  = %f usec\n", tid[i], slave_num, thread_data[i].pi, hthread_time_usec(exec_time[i]));
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

