/* llsq.c program
 * "Solving the Linear Least Squares Problem for
 *  for fitting a set of N points to y=a*x+b"
 * Author: Eugene Cartwright
 * Original author: John Burkardt
 * Reference: https://people.sc.fsu.edu/~jburkardt/c_src/llsq/llsq.html
 * Date: 1/25/2016
 *
 * Note: Enable FPU = 2 for correct results
 */

#include <stdio.h>
#include <stdlib.h>
#include <hthread.h>
#include <arch/htime.h>
#include <math.h>

#define NUM_THREADS  NUM_AVAILABLE_HETERO_CPUS
#define N            15
#define OPCODE_FLAGGING
#define CHECK_FIRST_POLYMORPHIC

typedef struct {
   Huint n;
   float * x;
   float * y;
   float * a;
   float * b;
   float error;
} volatile llsq_t;

/*
  Purpose:

    LLSQ solves a linear least squares problem matching a line to data.

  Discussion:

    A formula for a line of the form Y = A * X + B is sought, which
    will minimize the root-mean-square error to N data points ( X[I], Y[I] );
*/
void * llsq_thread ( void * arg ) { // int n, float x[], float y[], float *a, float *b ) {
   llsq_t * data = (llsq_t *) arg;

   // Create pointers on stack vs reading value of
   // of pointer from main memory.
   float * y = data->y;
   float * x = data->x;
   float * a = data->a;
   float * b = data->b;
   Huint n = data->n;

   float bot;
   Huint i;
   float top;
   float xbar;
   float ybar;
   float error = 0.0f;

   /* Special case. */
   if ( n == 1 ) {
      *a = 0.0;
      *b = y[0];
      return (void *) SUCCESS;
   }

   /* Average X and Y. */
   xbar = 0.0f;
   ybar = 0.0f;
   for ( i = 0U; i < n; i++ ) {
      xbar = xbar + x[i];
      ybar = ybar + y[i];
   }
   xbar = xbar / ( float ) n;
   ybar = ybar / ( float ) n;

   /* Compute Beta. */
   top = 0.0f;
   bot = 0.0f;
   for ( i = 0U; i < n; i++ ) {
      top = top + ( x[i] - xbar ) * ( y[i] - ybar );
      bot = bot + ( x[i] - xbar ) * ( x[i] - xbar );
   }
   *a = top / bot;

   *b = ybar - *a * xbar;

   // Computer Root Mean squared error
   float temp;
   for ( i = 0U; i < n; i++ ) {
      temp = ( *b + *a * x[i] - y[i]);
      error = error + (temp * temp);
   }
   error = sqrtf (error / ( float ) n);
   
   data->error = error;

   return (void *) SUCCESS;
}

#ifndef HETERO_COMPILATION
#include "llsq_prog.h"

hthread_time_t exec_time[NUM_THREADS] PRIVATE_MEMORY;
hthread_t tid[NUM_THREADS] PRIVATE_MEMORY;
hthread_attr_t attr[NUM_THREADS] PRIVATE_MEMORY;
void * ret[NUM_THREADS] PRIVATE_MEMORY;

hthread_time_t start PRIVATE_MEMORY, stop PRIVATE_MEMORY;

int main() {

   printf("--- Linear Least Squares benchmark ---\n"); 
   printf("Number of Data points: %d\n", N);
#ifdef OPCODE_FLAGGING
   printf("-->Opcode flagging ENABLED\n");
#else
   printf("-->Opcode flagging DISABLED\n");
#endif
   // Initialize various host tables once.
   init_host_tables();
   
   Huint i = 0;
   llsq_t data[NUM_THREADS];
   float a[NUM_THREADS];
   float b[NUM_THREADS];
   float x[N] = { 
    1.47, 1.50, 1.52, 1.55, 1.57, 1.60, 1.63, 1.65, 1.68, 1.70, 
    1.73, 1.75, 1.78, 1.80, 1.83 };
   float y[N] = {
    52.21, 53.12, 54.48, 55.84, 57.20, 58.57, 59.93, 61.29, 63.11, 64.47,
    66.28, 68.10, 69.92, 72.19, 74.46 };

   for (i = 0; i < NUM_THREADS; i++) {
      hthread_attr_init(&attr[i]);
      data[i].x = x;
      data[i].y = y;
      data[i].a = &a[i];
      data[i].b = &b[i];
      data[i].n = N;
   }

   start = hthread_time_get();
   
   for (i = 0; i < NUM_THREADS; i++) 
      thread_create(&tid[i], &attr[i], llsq_thread_FUNC_ID, (void *) &data[i], STATIC_HW0+i, 0);
   
   for (i = 0; i < NUM_THREADS; i++) {
      if (thread_join(tid[i], &ret[i], &exec_time[i]))
         printf("Join error!\n");
   }
   
   stop = hthread_time_get();

#ifdef VERIFY
   printf ( "\n" );
   for (i = 0; i < NUM_THREADS; i++) {
      printf ( "  Estimated relationship is y = %g * x + %g\n", a[i], b[i] );
      printf ( "  Expected value is         y = 61.272 * x - 39.062\n" );
      printf ( "  RMS error =                      %g\n", data[i].error );
      printf ( "\n" );
   }
#endif

   // Display thread times
   for (i = 0; i < NUM_THREADS; i++) { 
      // Determine which slave ran this thread based on address
      Huint base = attr[i].hardware_addr - HT_HWTI_COMMAND_OFFSET;
      Huint slave_num = (base & 0x00FF0000) >> 16;
      printf("Execution time (TID : %02d, Slave : %02d)  = %f usec\n", tid[i], slave_num, hthread_time_usec(exec_time[i]));
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
