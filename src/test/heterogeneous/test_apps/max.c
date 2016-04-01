/* max.c program
 * Author: Eugene
 * Date: 1/14/2016
 *
 * Description: Finds the max between two numbers using
 * SHIFTING, bitwise AND, and subtraction. Compiler optimizing
 * shift function out, this is why I pass as an arg for now.
 */

#include <stdio.h>
#include <stdlib.h>
#include <hthread.h>
#include <arch/htime.h>

#define NUM_THREADS  NUM_AVAILABLE_HETERO_CPUS
#define OPCODE_FLAGGING
#define  CHECK_FIRST_POLYMORPHIC


#define FINDMAX_LENGTH  500
typedef struct 
{
   int A[FINDMAX_LENGTH];
   int B[FINDMAX_LENGTH];
   int result[FINDMAX_LENGTH];
   int length;
   unsigned int shift_amount;
} volatile max_t;

void * find_max_thread (void *arg) 
{
   max_t *targ = (max_t *) arg;
   int length = targ->length;
   int i = 0;
   Huint shift_amount = targ->shift_amount;
   for (i = 0; i < length; i++ ){
      int a = targ->A[i];
      int b = targ->B[i];
      int diff = a-b;
      int mask = diff >> shift_amount;
      targ->result[i] = a - (diff & (mask));
   }

   return (void *) 9;
}


#ifndef HETERO_COMPILATION
#include "max_prog.h"

hthread_time_t exec_time[NUM_THREADS] PRIVATE_MEMORY;
hthread_t tid[NUM_THREADS] PRIVATE_MEMORY;
hthread_attr_t attr[NUM_THREADS] PRIVATE_MEMORY;
void * ret[NUM_THREADS] PRIVATE_MEMORY;

int main() {
   
   printf("--- Calculating max benchmark ---\n"); 
   printf("FINDMAX_LENGTH: %d\n", FINDMAX_LENGTH);
#ifdef OPCODE_FLAGGING
   printf("-->Opcode flagging ENABLED\n");
#else
   printf("-->Opcode flagging DISABLED\n");
#endif
   // Initialize various host tables once.
   init_host_tables();

   Huint i = 0,j;
   max_t findmax_arg[NUM_THREADS];
   for (i = 0; i < NUM_THREADS; i++) {
      findmax_arg[i].length = FINDMAX_LENGTH;
      findmax_arg[i].shift_amount = sizeof(findmax_arg[i].A[0]);
      for (j = 0; j < FINDMAX_LENGTH; j++) {
         findmax_arg[i].A[j] = (int) (rand() % FINDMAX_LENGTH);
         findmax_arg[i].B[j] = (int) (rand() % FINDMAX_LENGTH);
         findmax_arg[i].result[j] = 0;
      }
   }

   hthread_time_t start = hthread_time_get();
   
   for (i = 0; i < NUM_THREADS; i++) 
      thread_create(&tid[i], &attr[i], find_max_thread_FUNC_ID, (void *) &findmax_arg[i], STATIC_HW0+i, 0);
   
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
      printf("Execution time (TID : %d, Slave : %d)  = %f msec\n", tid[i], slave_num, hthread_time_msec(exec_time[i]));
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

