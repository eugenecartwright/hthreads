/******************************************************************************
* FILE: arrayloops.c
* DESCRIPTION:
*   Example code demonstrating decomposition of array processing by
*   distributing loop iterations.  A global sum is maintained by a mutex
*   variable.  
* AUTHOR: Blaise Barney
* LAST REVISED: 04/05/05
******************************************************************************/
#include <hthread.h>
#include <stdio.h>
#include <stdlib.h>

#define NTHREADS      4
#define ARRAYSIZE   1000000
#define ITERATIONS   ARRAYSIZE / NTHREADS

typedef struct
{
    Huint           *id;
    Huint           *sum;
    Huint           *array;
    hthread_mutex_t *mutex;
} arg_t;

void *do_work( void *a ) 
{
  arg_t *arg;
  int i, start, *mytid, end;
  int mysum=0;

  /* Initialize my part of the global array and keep local sum */
  arg = (arg_t*)a;
  mytid = (int *)arg->id;
  start = (*mytid * ITERATIONS);
  end = start + ITERATIONS;
  printf ("Thread %d doing iterations %d to %d\n",*mytid,start,end-1); 
  for (i=start; i < end ; i++) {
    arg->array[i] = i;
    mysum = mysum + arg->array[i];
    }

  /* Lock the mutex and update the global sum, then exit */
  hthread_mutex_lock(arg->mutex);
  *arg->sum = *arg->sum + mysum;
  hthread_mutex_unlock (arg->mutex);
  hthread_exit(NULL);
}


int main(int argc, char *argv[])
{
  int i;
  unsigned int *a, sum;
  hthread_t threads[NTHREADS];
  arg_t args[NTHREADS];
  hthread_attr_t attr;
  hthread_mutex_t   sum_mutex;

  a = (unsigned int*)malloc( ARRAYSIZE * sizeof(int) );

  /* Pthreads setup: initialize mutex and explicitly create threads in a
     joinable state (for portability).  Pass each thread its loop offset */
  hthread_mutex_init(&sum_mutex, NULL);
  hthread_attr_init(&attr);
  hthread_attr_setdetachstate(&attr, HTHREAD_CREATE_JOINABLE);
  for (i=0; i<NTHREADS; i++) {
    *args[i].id   = i;
    args[i].array = a;
    args[i].sum   = &sum;
    args[i].mutex = &sum_mutex;
    hthread_create(&threads[i], &attr, do_work, (void *)&args[i]);
    }

  /* Wait for all threads to complete then print global sum */ 
  for (i=0; i<NTHREADS; i++) {
    hthread_join(threads[i], NULL);
  }
  printf ("Done Sum=%d \n", sum);

  sum=0;
  for (i=0;i<ARRAYSIZE;i++){ 
  a[i] = i;
  sum = sum + a[i]; }
  printf("Check Sum= %d\n",sum);

  /* Clean up and exit */
  free( a );
  hthread_attr_destroy(&attr);
  hthread_mutex_destroy(&sum_mutex);
  printf( "--DONE--\n" );
  hthread_exit (NULL);
}

