#include <stdio.h>
#include <errno.h>
#include <hthread.h>
#include <stdarg.h>
#include <arch/arch.h>
#include <arch/htime.h>



#define NUM_THREADS (2)

typedef struct hthread_barrier_t {
  hthread_mutex_t mtx;
  hthread_cond_t cv;
  int valid;
  int n_threads_required;
  int n_threads_left;
  int cycle; /* alternate wait cycles (0 or 1) */
} hthread_barrier_t;

typedef struct hthread_barrierattr_t {
  /* Not implemented. */
  /* First, AIX doesn't have barriers.  Then xlc requires
     a member.  augh. */
  char c;
} hthread_barrierattr_t;

#define HTHREAD_BARRIER_SERIAL_THREAD -1

// Barrier Prototypes
int hthread_barrier_init (hthread_barrier_t*, const hthread_barrierattr_t*, unsigned);
int hthread_barrier_destroy (hthread_barrier_t*);
int hthread_barrier_wait (hthread_barrier_t*);
int hthread_barrierattr_init (hthread_barrierattr_t*);
int hthread_barrierattr_destroy (hthread_barrierattr_t*);

// Utility Prototypes
void aprintf(char* fmt, ...);
void wait(int seconds);
void wait_on_lock(hthread_mutex_t * lock);
void set_priority(hthread_t, Hint);
Huint get_priority(void);

// Global Mutex used to prevent interleaved printf output
hthread_mutex_t print_mutex;

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
		      const hthread_barrierattr_t* attr,
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

  cycle = bar->cycle;

  tmp = --bar->n_threads_left;
  if (0 == tmp) {
    bar->n_threads_left = bar->n_threads_required;
    bar->cycle ^= 0x01;
    err = hthread_cond_broadcast (&bar_->cv);
    if (!err) err = HTHREAD_BARRIER_SERIAL_THREAD;
  }
  else {
    while (cycle == bar->cycle) {
      err = hthread_cond_wait (&bar_->cv, &bar_->mtx);
    }
  }

  hthread_mutex_unlock (&bar_->mtx);

  return err;
}

int hthread_barrierattr_destroy (hthread_barrierattr_t* attr /*NOTUSED*/)
{
  if (!attr) return EINVAL;
  return 0;
}


int hthread_barrierattr_init (hthread_barrierattr_t* attr)
{
  if (!attr) return EINVAL;
  return 1;
}

void * worker_thread (void * arg)
{
    hthread_barrier_t * bar = (hthread_barrier_t *)arg;
    hthread_t tid = hthread_self();

    int c = 0;
    for (c = 0; c < 10; c++)
    {
        aprintf("(CPU%d) Thread %d waiting (%d)...\n",_get_procid(),tid,c);
        hthread_barrier_wait(bar);
    }

    return (void*)tid;
}

int main()
{
    int i;
    hthread_barrier_t barrier;
    hthread_t tid[NUM_THREADS];

    //printf("Press enter to continue...\n");
    //int x;
    //scanf("%d\n",&x);

    // Init. global print mutex
    hthread_mutex_init(&print_mutex, NULL);

    aprintf("Setting up barrier...\n");
    hthread_barrier_init(&barrier, NULL, NUM_THREADS);

    aprintf("Creating a total of %d threads...\n", NUM_THREADS);

    for (i = 0; i < NUM_THREADS; i++)
    {
        hthread_create(&tid[i], NULL, (void*)worker_thread, (void*)&barrier);
        //set_priority(tid[i],20-i);
        aprintf("Created TID #%d\n",tid[i]);
    }

    aprintf("Joining threads...\n");
    for (i = 0; i < NUM_THREADS; i++)
    {
        hthread_join(tid[i], NULL);
    }

    aprintf("Done!\n");
    hthread_barrier_destroy(&barrier);

    return 0;

}

// Non-blocking busy-wait for a mutex.  Unlike the usual mutex_lock, this
// doesn't force a scheduling decision, and thus won't lead to a context
// switch.
void wait_on_lock(hthread_mutex_t * lock)
{
    while(hthread_mutex_trylock(lock) != SUCCESS)
    {
        wait(1);
    }
}


// An "atomic" printf function.  Any process calling this function spins
// on the global print_mutex; this prevents the output from printfs by
// physically concurrent threads from being interleaved.
void aprintf(char* fmt, ...)
{
    va_list args;
    va_start(args, fmt);
    wait_on_lock(&print_mutex);
    vprintf(fmt, args);
    hthread_mutex_unlock(&print_mutex);
    va_end(args);
}


// Non-blocking wait.
void wait(int seconds)
{
    arch_clock_t done = _arch_get_time() + CLOCKS_PER_SEC * seconds;
    while(_arch_get_time() < done)
    {
        int i;
        int a = 0;
        for(i = 0; i < 10000; i++)
            a = a + 1;
    }
}


// Set the priority of the given thread.
void set_priority( hthread_t th, Hint pri )
{
    Hint status;
    struct sched_param pr;

    pr.sched_priority = pri;
    status = hthread_setschedparam( th, SCHED_OTHER, &pr );
    if( status < 0 )
    {
        printf( "Set Priority Error: 0x%8.8x\n", status );
    }
}


// Return the priority of the currently-running thread.
Huint get_priority(void)
{
    struct sched_param pr;
    Hint pol;
    hthread_getschedparam(hthread_self(), &pol, &pr);
    Huint priority = pr.sched_priority;
    return priority;
}
