/*
   Mutexes MicroBenchmark

   */
#include <stdio.h>
//#include <math.h>
#include <stdlib.h>
//#include <time.h>
//#include <arch/cache.h>
//#include <xcache_l.h>
#include <hthread.h>
#include "xil_timing.h"

#define TESTS   10
#define RUNS    20

typedef unsigned int mytime_t;

//#define DBG

#ifdef DBG
#define dbg_printf(x,...) printf(x,##__VA_ARGS__)
#else
#define dbg_printf(x,...)
#endif

typedef struct threadArg {
	hthread_mutex_t data_mutex;	    // Mutex used to protect the counter
	int counter;					// Common counter
	int num_load_threads;		    // Number of load threads in test
	hthread_mutex_t block_mutex;	// Mutex used to block thread
    mytime_t unlock_start;
    mytime_t unlock_stop;
    mytime_t unlock_check;
    mytime_t lock_start;
    mytime_t lock_stop;
    mytime_t lock_check;
    mytime_t measure_lock_start;
    mytime_t measure_lock_stop;
    mytime_t measure_lock_check;
} thread_arg_t;

void * testThread (void * arg)
{
    thread_arg_t * my_arg;
    my_arg = (thread_arg_t *)arg;
    Huint tid;

    tid = hthread_self();

    // Atomically increment counter (protected by data_mutex)
    dbg_printf("LOAD TID %d, incrementing counter (%d -> %d) \n",tid,my_arg->counter,my_arg->counter+1);
    hthread_mutex_lock(&my_arg->data_mutex);
    my_arg->counter = my_arg->counter + 1;
    hthread_mutex_unlock(&my_arg->data_mutex);

    // Grab and release block mutex (protected by block_mutex) - should be pre-locked by main thread
    dbg_printf("LOAD TID %d, locking block mutex\n",tid);
    hthread_mutex_lock(&my_arg->block_mutex);
    dbg_printf("LOAD TID %d, unlocking block mutex\n",tid);
    hthread_mutex_unlock(&my_arg->block_mutex);

    //hthread_exit( NULL );
	return NULL;
}

void * testThreadWithMeasurement (void * arg)
{
    thread_arg_t * my_arg;
    my_arg = (thread_arg_t *)arg;
    Huint tid;

    tid = hthread_self();

    // Atomically increment counter (protected by data_mutex)
    dbg_printf("LOAD w/ measure TID %d, incrementing counter (%d -> %d) \n",tid,my_arg->counter,my_arg->counter+1);
    hthread_mutex_lock(&my_arg->data_mutex);
    my_arg->counter = my_arg->counter + 1;
    hthread_mutex_unlock(&my_arg->data_mutex);

    // Grab and release block mutex (protected by block_mutex) - should be pre-locked by main thread
    dbg_printf("LOAD w/ measure TID %d, locking block mutex\n",tid);
    my_arg->measure_lock_start = readTimer(  );
    hthread_mutex_lock(&my_arg->block_mutex);
    my_arg->measure_lock_stop = readTimer(  );
    dbg_printf("LOAD w/ measure TID %d, unlocking block mutex\n",tid);
    hthread_mutex_unlock(&my_arg->block_mutex);

    //hthread_exit( NULL );
	return NULL;
}


void * measureThread (void * arg)
{
    thread_arg_t * my_arg;
    my_arg = (thread_arg_t *)arg;
    Huint tid;
    volatile Hint * counter = &my_arg->counter;

    tid = hthread_self();

    // Pre-lock blocking mutex
    dbg_printf("MEASURE THREAD : Timing lock of block mutex\n");
    my_arg->lock_start = readTimer(  );
    hthread_mutex_lock(&my_arg->block_mutex);
    my_arg->lock_stop = readTimer(  );

    // Wait for all threads to block (i.e. wait for counter to reach limit)
    dbg_printf("### Waiting for counter value to be reached ###\n");
    while (*counter < my_arg->num_load_threads)
    {
        dbg_printf("Measurement thread yielding...(counter = %d)\n",my_arg->counter);
        //hthread_yield();
    }
    dbg_printf("### Counter value reached ###\n");

    // (**B**) Unlock blocking mutex
    dbg_printf("MEASURE THREAD : Timing unlock of block mutex\n");
    my_arg->unlock_start = readTimer(  );
    hthread_mutex_unlock(&my_arg->block_mutex);
    my_arg->unlock_stop = readTimer(  );

    //hthread_exit( NULL );
	return NULL;
}

int main()
{
    return 0;
}
