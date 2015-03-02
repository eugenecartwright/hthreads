/*   
  The function hthread_barrier_wait(hthread_barrier_t *bar_) has a thread wait on a
  barrier object until the number of threads specified in hthread_barrier_init() have
  checked in to the barrier. This barrier type utilizes condition variables and the calls
  hthread_cond_wait and hthread_cond_broadcast to wait on all threads to enter.
  
  Methodology
  1. Set up barrier to wait on number of child threads.
  2. Dispatch children to wait on barrier NUM_LOOPS times
  3. Join on children once they have all completed the waits

  Error Codes: A return value of anything but 1 means the test has failed
  2: An error occured when creating a child thread
  3: An error occured while joining on a child thread

  -Juan
 */

#include <hthread.h>

#define NUM_THREADS 8     //Number of threads denotes number of slaves being used
#define NUM_LOOPS 1      //Number of barrier_waits to perform per iteration

typedef struct hthread_barrier_t {
  hthread_mutex_t mtx;
  hthread_cond_t cv;
  int valid;
  int n_threads_required;
  int n_threads_left;
  int cycle; /* alternate wait cycles (0 or 1) used to hold threads from entering/exiting */
} hthread_barrier_t;

#define HTHREAD_BARRIER_SERIAL_THREAD -1

int hthread_barrier_init (hthread_barrier_t*, unsigned);
int hthread_barrier_destroy (hthread_barrier_t*);
int hthread_barrier_wait (hthread_barrier_t*);

int hthread_barrier_destroy (hthread_barrier_t* bar)
{
  int err, err2;

  if (!bar) return EINVAL;

  err = hthread_mutex_trylock (&bar->mtx);

  if (err) return err;

  if (bar->n_threads_left != bar->n_threads_required) {
    err = EBUSY;
    goto err_done;
  }
  if (!bar->valid) {
    err = EINVAL;
    goto err_done;
  }

  bar->valid = 0; /* It's officially dead. */

  hthread_mutex_unlock (&bar->mtx);

  err = hthread_mutex_destroy (&bar->mtx);
  err2 = hthread_cond_destroy (&bar->cv);
  if (err) return err;
  return err2;

 err_done:
  hthread_mutex_unlock (&bar->mtx);
  return err;
}

int hthread_barrier_init (hthread_barrier_t* bar,
		      unsigned nthr)
{
  int err;

  if (!bar) return EINVAL;

  if (0 == nthr) return EINVAL;

  err = hthread_mutex_init (&bar->mtx, NULL);
  if (err) return err;
  err = hthread_cond_init (&bar->cv, NULL);
  if (err) {
    hthread_mutex_destroy (&bar->mtx);
    return err;
  }
  bar->n_threads_required = nthr;
  bar->n_threads_left = nthr;
  bar->cycle = 0;
  bar->valid = 1;

  return 0;
}

int hthread_barrier_wait (hthread_barrier_t* bar_)
{
  volatile hthread_barrier_t* bar = bar_;
  int tmp;
  int err = 0;
  int cycle;

  if (!bar || !bar->valid) return EINVAL;

  err = hthread_mutex_lock (&bar_->mtx);

  if (err) return err;

  //Store cycle in order to prevent threads that are prematurely awoken from leaving the barrier
  cycle = bar->cycle;

  tmp = --bar->n_threads_left;
  //If all threads have entered...
  if (0 == tmp) {
    //Reset number of threads to enter
    bar->n_threads_left = bar->n_threads_required;
    //change the cycle (allowing awoken threads to leave)
    bar->cycle ^= 0x01;
    //Wake up all other waiting threads

    err = hthread_cond_broadcast (&bar_->cv);

    //if there is no error, mark this thread as the last
    if (!err) err = HTHREAD_BARRIER_SERIAL_THREAD;
  }
  else {
    //While it is still our turn to wait on the barrier
    while (cycle == bar->cycle) {
      err = hthread_cond_wait (&bar_->cv, &bar_->mtx);
    }
  }

  hthread_mutex_unlock (&bar_->mtx);

  return err;
}


void * worker_thread (void * arg)
{
    hthread_barrier_t * bar = (hthread_barrier_t *)arg;
    int c = 0;
    int err = 0;

    for (c = 0; c < NUM_LOOPS; c++)
    {
	hthread_barrier_wait(bar);		//barrier wait
    }

    return (void*)err;
}

#ifdef HETERO_COMPILATION
int main()
{
    return 0;
}
#else
#include "barrier_test_prog.h"

int main()
{
    int i = 0;
    int returns[NUM_THREADS];
    hthread_barrier_t barrier;
    hthread_t tid[NUM_THREADS];
    hthread_attr_t attr[NUM_THREADS];

    //Initialize barrier
    hthread_barrier_init(&barrier, NUM_THREADS);

    //Set up thread attributes
    for(i = 0; i < NUM_THREADS; i++)
	hthread_attr_init(&attr[i]);

    int iter = 0;
    int return_err = SUCCESS;
    int success = 0;

    // Run iterations
    //intf("----Begin test barrier_test\n");
    for (i = 0; i < NUM_THREADS; i++)
    {
        return_err = microblaze_create( &tid[i], &attr[i], worker_thread_FUNC_ID, (void *) &barrier, i);
        if(return_err != SUCCESS)
        	success = 1;
    }
    if(success != SUCCESS)
    {
	printf("2\nEND\n");
	return 1;
    }
	
    success = 0;

    // Wait for all threads to finish
    for (i = 0; i < NUM_THREADS; i++)
    {
        return_err = hthread_join(tid[i], (void*)&returns[i]);
	if(return_err != SUCCESS)
	    success = 1;
	}
    }

    if(success != SUCCESS)
    {
	printf("3\nEND\n");
	return 1;
    }

    hthread_barrier_destroy(&barrier);

    printf("0\nEND\n");



    return 0;

}
#endif
