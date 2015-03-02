#include <stdio.h>     /* for printf */
#include <stdlib.h>    /* for rand() */
#include <limits.h>    /* for INT_MAX */
#include <hthread.h>   /* for all the hthread functions */

#define SIZE 100
#define TIMER
//#define TEST_MODE

/* We can only pass a single pointer value to a newly-created thread,
 * so we define a structure that includes all the things we want to pass,
 * and pass a pointer to this structure instead.
 */

typedef struct thread_data_s {
  int *A;
  int p;
  int r;
} thread_data_t;

hthread_attr_t attr; /* Attributes for hthreads. Make it global so everyone can use it */

/*
 * Vanilla merge procedure from CLR Algorithms text.
 */

void merge(int *A, int p, int q, int r)
{

  int n1 = q - p + 1;
  int n2 = r - q;
  int *L, *R;
  int i, j, k;

  L = (int *)malloc((n1+1)*sizeof(int));
  R = (int *)malloc((n2+1)*sizeof(int));

  for (i = 0; i < n1; i++) {
    L[i] = A[p+i];
  }
  L[n1] = INT_MAX;

  for (i = 0; i < n2; i++) {
    R[i] = A[q+1+i];
  }
  R[n2] = INT_MAX;

  i = j = 0;

  for (k = p; k <= r; k++) {
    if (L[i] <= R[j]) {
      A[k] = L[i];
      i++;
    } else {
      A[k] = R[j];
      j++;
    }
  }

  free(L);
  free(R);

}

/* mergesort routine that creates new threads to sort each half of the array
 * before merging the two halves together.
 * Gives up and exit's early if the attempt to create a thread fails.
 *
 * Note that mergesort takes a single void * as a parameter this time.
 */

void *mergesort(void *args) {
  int q;
  //hthread_t me = hthread_self();    /* for diagnostics */
  hthread_t t1 = 0, t2 = 0;         /* thread id's of children */
  thread_data_t *t1_data=NULL, *t2_data=NULL; /* arguments to pass to children */
  thread_data_t *my_data = (thread_data_t *)args;
  int failed = 0;

  q = (my_data->p+my_data->r)/2;  /* Split array */

  if (my_data->p < q) {
    t1_data = (thread_data_t *)malloc(sizeof(thread_data_t));
    t1_data->A = my_data->A;
    t1_data->p = my_data->p;
    t1_data->r = q;

    if (hthread_create(&t1, &attr, mergesort, (void *)t1_data) != 0) {
      /* thread create failed. Give up. */
      perror("Unable to create thread for first half of segment");

      free(t1_data);
      hthread_exit((void *)-1);
    }
  }

  if (q+1 < my_data->r) {
    t2_data = (thread_data_t *)malloc(sizeof(thread_data_t));
    t2_data->A = my_data->A;
    t2_data->p = q+1;
    t2_data->r = my_data->r;

    if (hthread_create(&t2, &attr, mergesort, (void *)t2_data) != 0) {
      /* thread create failed. Give up. */
      perror("Unable to create thread for second half of segment");

      /* Clean up: still have to wait for first thread, if it was created */
      if (t1 != 0) {
	hthread_join(t1, NULL);
	free(t1_data);
      }

      free(t2_data);
      hthread_exit((void *)-1);
    }
  }

  /* Now wait for children to finish their halfs and merge them */

  /* Depending on value of q, one or both children may not have been needed.
   * Don't wait for them if they don't exist. (Note the use of C's "short-circuit"
   * logical AND - if the first part is FALSE, the second part is not evaluated
   * and hthread_join is not called).
   */

  if ( (t1 != 0) && hthread_join(t1, NULL) < 0) {
    perror("Join with first child failed");
    failed = 1;
  }

  /* Even if something already went wrong, we should still wait
   * for the second child, if it exists
   */
  if ( (t2 != 0) && hthread_join(t2, NULL) < 0) {
    perror("Join with second child failed");
    failed = 1;
  }

  /* But don't bother merging if we know something went wrong */
  if (!failed) {
    merge(my_data->A, my_data->p, q, my_data->r);
  }

  /* Clean up the memory we allocated */
  if(t1_data != NULL) free(t1_data);
  if(t2_data != NULL) free(t2_data);

  hthread_exit(0);

}

/*
 * Generate an array of "size" integers initialized with random values.
 * Returns a pointer to the newly-initialized array.
 * Note the type of my_array: We want to modify the pointer value itself,
 * so we have to pass the address of the pointer (in other words, a pointer
 * to a pointer).
 */

void create_rand_array(int size, int **my_array)
{
  int i;

  *my_array = (int *)malloc(size*sizeof(int));

  for (i = 0; i < size; i++) {
    (*my_array)[i] = rand();
  }

}


int main(int argc, char **argv) {

  int *the_array;
  int i; 
  thread_data_t *start_data;
  hthread_t firstthread;

#ifdef TEST_MODE
  int j;
  for(j = 1; j <=250; j++){
  my_size = j;
#else
  int my_size;
  my_size = SIZE;
#endif

  /* Initialize the array of numbers to be sorted */

  create_rand_array(my_size, &the_array);

  /* Set up the arguments to pass to the first thread */

  start_data = (thread_data_t *)malloc(sizeof(thread_data_t));
  start_data->A = the_array;
  start_data->p = 0;
  start_data->r = my_size-1;

  /* Initialize attributes for the threads we are going to create.
   * Note that the variable attr is global, and thus shared by all threads.
   */
  hthread_attr_init(&attr);
  hthread_attr_setstacksize(&attr, 1024);

  /* Time the sort itself */
#ifdef TIMER
    unsigned int start = 0;
    unsigned int stop  = 0;
    
    volatile int *timer_control = (int*)0x73000000;
    volatile int *timer_value   = (int*)0x73000008;

    // Start timer
    *timer_control = 0x00000510; // Enable timer, clear interrupt

    // Start timing
    start = *timer_value;
#endif

  if (hthread_create(&firstthread, &attr, mergesort, (void *)start_data) != 0) {
    perror("Could not create first thread. Giving up");
    free(start_data);
    free(the_array);
    exit(-1);
  }

  if (hthread_join(firstthread, NULL) != 0) {
    perror("Could not join with first thread. Giving up");
    free(start_data);
    free(the_array);
    exit(-1);
  }

#ifdef TIMER
    // Stop timing
    stop = *timer_value; // Read stop value
#ifdef TEST_MODE
    printf("Iteration Number %d - Exec. Time = %d\n",j,(stop-start));
#else
    printf("Start Time = %u\n",start);
    printf("Stop Time  = %u\n",stop);
	printf("Exec. Time = %d\n", (stop-start));
#endif
#endif

  /* Check if the sort succeeded. */

  for (i = 0; i < my_size-1; i++) {
    if (the_array[i] > the_array[i+1]) {
      printf("Sort failed, A[%d] = %d, A[%d] = %d\n",i,the_array[i],i+1,the_array[i+1]);
      break;
    }
  }

  /* Release malloc'd memory */
  free(start_data);
  free(the_array);

#ifdef TEST_MODE
}
#endif

  return 0;
}
