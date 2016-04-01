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
#define OPCODE_FLAGGING
#define CHECK_FIRST_POLYMORPHIC


// For Matrix Multiply
#define MATRIX_A_ROW    (24)
#define MATRIX_A_COL    (24)
#define MATRIX_B_ROW    (24)
#define MATRIX_B_COL    (24)
typedef struct
{
  int matrixA[MATRIX_A_ROW][MATRIX_A_COL];
  int matrixB[MATRIX_B_ROW][MATRIX_B_COL];
  int matrixC[MATRIX_A_ROW][MATRIX_B_COL];
} volatile matrix_t;

void * matrix_mult_thread (void *arg)
{
  int myRow, colA, colB;

  matrix_t *targ = (matrix_t *) arg;
  for (myRow = 0; myRow < MATRIX_A_ROW; myRow++) {

	int fastRow[MATRIX_A_COL];
	int result;
	for (colA = 0; colA < MATRIX_A_COL; colA++) {
	  fastRow[colA] = targ->matrixA[myRow][colA];
	}

	for (colB = 0; colB < MATRIX_B_COL; colB++) {
	  result = 0;
	  for (colA = 0; colA < MATRIX_A_COL; colA++) {
		result += fastRow[colA] * targ->matrixB[colA][colB];
	  }
	  targ->matrixC[myRow][colB] = result;
	}
  }
  return (void *) 0;
}


#ifndef HETERO_COMPILATION
#include "matrixmultiply_prog.h"

hthread_time_t exec_time[NUM_THREADS] PRIVATE_MEMORY;
hthread_t tid[NUM_THREADS] PRIVATE_MEMORY;
hthread_attr_t attr[NUM_THREADS] PRIVATE_MEMORY;
void * ret[NUM_THREADS] PRIVATE_MEMORY;

int main() {
   
   printf("--- Calculating Matrix Multiply benchmark ---\n"); 
   printf("MATRIX ROWS: %d\n", MATRIX_A_ROW);
   printf("MATRIX COLS: %d\n", MATRIX_A_COL);
#ifdef OPCODE_FLAGGING
   printf("-->Opcode flagging ENABLED\n");
#else
   printf("-->Opcode flagging DISABLED\n");
#endif
   // Initialize various host tables once.
   init_host_tables();

   Huint i = 0,j  = 0;
   for (i = 0; i < NUM_THREADS; i++) {
      hthread_attr_init(&attr[i]);
   }
    
   // Matrix Multiply
   matrix_t matrix_arg[NUM_THREADS];
   int n;
   for (n = 0; n < NUM_THREADS; n++) {
      for (i = 0; i < MATRIX_A_ROW; i++) {
	      for (j = 0; j < MATRIX_A_COL; j++) {
	         matrix_arg[n].matrixA[i][j] = i + j;
	         matrix_arg[n].matrixB[i][j] = i + j;
	         matrix_arg[n].matrixC[i][j] = 0;
	      }
      }
   }

   hthread_time_t start = hthread_time_get();
  
   // FIXME: Attention! Don't schedule all at once, or you saturate the bus/memory access 
   for (i = 0; i < NUM_THREADS; i++) { 
      thread_create(&tid[i], &attr[i], matrix_mult_thread_FUNC_ID, (void *) &matrix_arg[i], STATIC_HW0+i, 0);
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

