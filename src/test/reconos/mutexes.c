/*
   Mutexes MicroBenchmark

   */
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>
#include <arch/cache.h>
#include <xcache_l.h>
#include <hthread.h>
#include "timing.h"
#include "xil_timing.h"

#define TESTS   10
#define RUNS    20

//#define USE_CACHE

//#define DBG

#ifdef DBG
#define dbg_printf(x,...) printf(x,##__VA_ARGS__)
#else
#define dbg_printf(x,...)
#endif

void enable_cache()
{
    dbg_printf( "enabling data cache for external ram\n" );
    ppc405_dcache_enable( 0x80000000 );
    ppc405_icache_enable( 0xFFFFFFFF );
}

void disable_cache()
{
    dbg_printf( "data cache disabled\n" );
    ppc405_dcache_disable();
    ppc405_icache_enable( 0xFFFFFFFF );
}

void setup_cache()
{
#ifdef USE_CACHE
    enable_cache();
#else
    disable_cache();
#endif
}

typedef struct threadArg {
	hthread_mutex_t data_mutex;	    // Mutex used to protect the counter
	int counter;					// Common counter
	int num_load_threads;		    // Number of load threads in test
	hthread_mutex_t block_mutex;	// Mutex used to block thread
    hthread_time_t unlock_start;
    hthread_time_t unlock_stop;
    hthread_time_t unlock_check;
    hthread_time_t lock_start;
    hthread_time_t lock_stop;
    hthread_time_t lock_check;
    hthread_time_t measure_lock_start;
    hthread_time_t measure_lock_stop;
    hthread_time_t measure_lock_check;
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

    hthread_exit( NULL );
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
    my_arg->measure_lock_start = gettime(  );
    hthread_mutex_lock(&my_arg->block_mutex);
    my_arg->measure_lock_stop = gettime(  );
    dbg_printf("LOAD w/ measure TID %d, unlocking block mutex\n",tid);
    hthread_mutex_unlock(&my_arg->block_mutex);

    hthread_exit( NULL );
	return NULL;
}

void show_banner(int num_load_threads)
{
    dbg_printf("***********************\n");
    dbg_printf("Mutex MicroBenchmark\n");
    dbg_printf("***********************\n");
    dbg_printf("# of Load Threads = %d\n",num_load_threads);
    dbg_printf("***********************\n");

    // Setup cache
    setup_cache();

    dbg_printf("***********************\n");
}

void * measureThread (void * arg)
{
    thread_arg_t * my_arg;
    my_arg = (thread_arg_t *)arg;
    Huint tid;

    tid = hthread_self();

    // Pre-lock blocking mutex
    dbg_printf("MEASURE THREAD : Timing lock of block mutex\n");
    my_arg->lock_start = gettime(  );
    hthread_mutex_lock(&my_arg->block_mutex);
    my_arg->lock_stop = gettime(  );

    // Wait for all threads to block (i.e. wait for counter to reach limit)
    dbg_printf("### Waiting for counter value to be reached ###\n");
    while (my_arg->counter < my_arg->num_load_threads)
    {
        dbg_printf("Measurement thread yielding...(counter = %d)\n",my_arg->counter);
        hthread_yield();
    }
    dbg_printf("### Counter value reached ###\n");

    // (**B**) Unlock blocking mutex
    dbg_printf("MEASURE THREAD : Timing unlock of block mutex\n");
    my_arg->unlock_start = gettime(  );
    hthread_mutex_unlock(&my_arg->block_mutex);
    my_arg->unlock_stop = gettime(  );

    hthread_exit( NULL );
	return NULL;
}

void run_A (int use_hw, int num_load_threads, thread_arg_t * arg)
{
    unsigned int i=0;
    hthread_t measure_tid;
    hthread_t tids[num_load_threads];
    hthread_mutexattr_t block_attr;
    hthread_mutexattr_t data_attr;

    // Print banner
    show_banner(num_load_threads);

    // Initialize thread argument fields
    //  * Setup mutexes
    //  * Initialize counter
    block_attr.num = 0;
    block_attr.type = HTHREAD_MUTEX_DEFAULT;
    data_attr.num = 1;
    data_attr.type = HTHREAD_MUTEX_DEFAULT;
    hthread_mutex_init(&arg->block_mutex, &block_attr);
    hthread_mutex_init(&arg->data_mutex, &data_attr);
    arg->counter = 0;

    // Create measurement thread
    hthread_create(&measure_tid, NULL, measureThread, (void*)arg);  
    
    // Create all of the load threads
    dbg_printf("Creating load threads...\n");
    for (i = 0; i < num_load_threads; i++)
    {
        // Create load thread
        hthread_create(&tids[i], NULL, testThread, (void*)arg);  
    }

    // Make sure that measurement thread runs
    hthread_join(measure_tid,NULL);

    // Wait for all load threads to complete
    for (i = 0; i < num_load_threads; i++)
    {
        // Join on load thread
        hthread_join(tids[i],NULL); 
    }

    arg->lock_check = calc_timediff_us(arg->lock_start, arg->lock_stop);
    arg->unlock_check = calc_timediff_us(arg->unlock_start, arg->unlock_stop);

    return;
}

void run_B (int use_hw, int num_load_threads, thread_arg_t * arg)
{
    unsigned int i=0;
    hthread_t measure_tidA, measure_tidB;
    hthread_t tids[num_load_threads];
    hthread_mutexattr_t block_attr;
    hthread_mutexattr_t data_attr;

    // Print banner
    show_banner(num_load_threads);

    // Initialize thread argument fields
    //  * Setup mutexes
    //  * Initialize counter
    block_attr.num = 0;
    block_attr.type = HTHREAD_MUTEX_DEFAULT;
    data_attr.num = 1;
    data_attr.type = HTHREAD_MUTEX_DEFAULT;
    hthread_mutex_init(&arg->block_mutex, &block_attr);
    hthread_mutex_init(&arg->data_mutex, &data_attr);
    arg->counter = 0;

    // Create measurement thread A
    hthread_create(&measure_tidA, NULL, measureThread, (void*)arg);  

    // Create measurement thread B
    hthread_create(&measure_tidB, NULL, testThreadWithMeasurement, (void*)arg);  
    
    // Create all of the load threads
    dbg_printf("Creating load threads...\n");
    for (i = 0; i < num_load_threads; i++)
    {
        // Create load thread
        hthread_create(&tids[i], NULL, testThread, (void*)arg);  
    }

    // Make sure that measurement thread A runs
    hthread_join(measure_tidA,NULL);

    // Make sure that measurement thread B runs
    hthread_join(measure_tidB,NULL);

    // Wait for all load threads to complete
    for (i = 0; i < num_load_threads; i++)
    {
        // Join on load thread
        hthread_join(tids[i],NULL); 
    }

    // Extract turn-around results
    // Turn-around = unlock_start to measure_lock_stop 
    arg->measure_lock_check = calc_timediff_us(arg->unlock_start, arg->measure_lock_stop);

    return;
}

typedef struct benchmark
{
    char * name[20];
    int num_threads_in_test;
    hthread_time_t results1[RUNS];
    hthread_time_t results2[RUNS];
}benchmark_t;

void report_benchmark_results(benchmark_t benchmarks[])
{
    int b, r;
    Hdouble lock_avg, lock_total, lock_ns, lock_delta, lock_var;
    Hdouble unlock_avg, unlock_total, unlock_ns, unlock_delta, unlock_var;

    printf("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$\n");
#ifdef USE_CACHE
    printf(" Benchmark - cache enabled\n"); 
#else
    printf(" Benchmark - cache disabled\n"); 
#endif
    printf("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$\n");

    // Loop through each benchmark
    for (b = 0; b < TESTS; b++)
    {
        // Initialize averages
        lock_total = 0;
        unlock_total = 0;

        // Loop through each result
        for (r = 0; r < RUNS; r++)
        {
            // Get the time in nanoseconds
            lock_ns = hthread_time_nsec(benchmarks[b].results1[r]);
            unlock_ns = hthread_time_nsec(benchmarks[b].results2[r]);

            // Accumulate total for use in averaging
            lock_total = lock_ns + lock_total; 
            unlock_total = unlock_ns + unlock_total; 
        }

        // Calculate average
        lock_avg = lock_total / RUNS;
        unlock_avg = unlock_total / RUNS;

        // Calculate variance
        lock_var = 0;
        unlock_var = 0;
        for (r = 0; r < RUNS; r++)
        {
            // Get the time in nanoseconds and calculate variance
            lock_ns = hthread_time_nsec(benchmarks[b].results1[r]);
            lock_delta = (lock_ns - lock_avg);
            lock_var = lock_var + (lock_delta * lock_delta);

            // Get the time in nanoseconds and calculate variance
            unlock_ns = hthread_time_nsec(benchmarks[b].results2[r]);
            unlock_delta = (unlock_ns - unlock_avg);
            unlock_var = unlock_var + (unlock_delta * unlock_delta);
        }


        printf(
                "*****************************************\n");
#ifdef USE_CACHE
    printf("cache enabled\n"); 
#else
    printf("cache disabled\n"); 
#endif
        printf(
                "Benchmark: %s, (# Threads In Test = %d)\n"
                "*****************************************\n"
                "Results 1:\n"
                "\t Average     = %f ns\n"
                "\t Std. Dev    = %f ns\n"
                "Results 2:\n"
                "\t Average     = %f ns\n"
                "\t Std. Dev    = %f ns\n"
                "*****************************************\n",
                *benchmarks[b].name, benchmarks[b].num_threads_in_test,
                lock_avg, sqrt(lock_var), unlock_avg, sqrt(unlock_var));
    } 
}

int main( int argc, char *argv[] )
{

    unsigned int start, stop;
    int i = 0;
    int test = 0;
    int NUM_LOAD_THREADS = 0;
    thread_arg_t arg;
    hthread_mutexattr_t block_attr;
    hthread_mutexattr_t data_attr;
    benchmark_t my_benchmark[TESTS];

    // Turn on the Xilinx Timer
    enableTimer();

    for (test = 0; test < TESTS; test++)
    {
	    // Set the # of load threads
	    NUM_LOAD_THREADS = test * 10;
	
	    // Init. benchmark structure
	    my_benchmark[test].num_threads_in_test = NUM_LOAD_THREADS;
	    *my_benchmark[test].name = "lock/unlock";
	
	    for (i = 0; i < RUNS; i++)
	    {	
	        // Initialize thread argument fields
		    //  * Setup mutexes
		    //  * Initialize counter
		    block_attr.num = 0;
		    block_attr.type = HTHREAD_MUTEX_DEFAULT;
		    data_attr.num = 1;
		    data_attr.type = HTHREAD_MUTEX_DEFAULT;
		    hthread_mutex_init(&arg.block_mutex, &block_attr);
		    hthread_mutex_init(&arg.data_mutex, &data_attr);
		    arg.counter = 0;
		    arg.num_load_threads = NUM_LOAD_THREADS;
	
	        // Run the test
	        start = readTimer();
	        run_A(0,NUM_LOAD_THREADS,&arg);
	        stop = readTimer();
	
	        // Gather results
	        my_benchmark[test].results1[i] = calc_timediff(arg.lock_start, arg.lock_stop);
	        my_benchmark[test].results2[i] = calc_timediff(arg.unlock_start, arg.unlock_stop);
/*	
	        printf(
	                "*** start      = %u\n"
	                "*** stop       = %u\n"
	                "*** elapsed    = %u\n",
	                start, stop, stop - start
	              );
	
	        // Calculate timing results
	        printf(     "\t*********************************\n"
	                    "\t lock Start Time    = %llu ticks\n"
	                    "\t lock Stop Time     = %llu ticks\n"
	                    "\t diff               = %llu ticks\n"
	                    "\t lock Elapsed Time  = %llu us\n",
	                    arg.lock_start, arg.lock_stop, arg.lock_stop - arg.lock_start, calc_timediff_us(arg.lock_start, arg.lock_stop)
	               );
	        printf(     "\t*********************************\n"
	                    "\t unlock Start Time    = %llu ticks\n"
	                    "\t unlock Stop Time     = %llu ticks\n"
	                    "\t diff                 = %llu ticks\n"
	                    "\t unlock Elapsed Time  = %llu us\n",
	                    arg.unlock_start, arg.unlock_stop, arg.unlock_stop - arg.unlock_start, calc_timediff_us(arg.unlock_start, arg.unlock_stop)
	               ); */
	    }                       
    }
    report_benchmark_results(my_benchmark);

    for (test = 0; test < TESTS; test++)
    {
	    // Set the # of load threads
	    NUM_LOAD_THREADS = test * 10;
	
	    // Init. benchmark structure
	    my_benchmark[test].num_threads_in_test = NUM_LOAD_THREADS;
	    *my_benchmark[test].name = "turn_around";
	
	    for (i = 0; i < RUNS; i++)
	    {	
	        // Initialize thread argument fields
		    //  * Setup mutexes
		    //  * Initialize counter
		    block_attr.num = 0;
		    block_attr.type = HTHREAD_MUTEX_DEFAULT;
		    data_attr.num = 1;
		    data_attr.type = HTHREAD_MUTEX_DEFAULT;
		    hthread_mutex_init(&arg.block_mutex, &block_attr);
		    hthread_mutex_init(&arg.data_mutex, &data_attr);
		    arg.counter = 0;

            // Num loads threads + 1 b/c the 2nd measurement thread is a load thread and needs to increment the counter barrier
            // before the main thread releases the blocking mutex
            arg.num_load_threads = NUM_LOAD_THREADS+1;
	
	        // Run the test
	        start = readTimer();
	        run_B(0,NUM_LOAD_THREADS,&arg);
	        stop = readTimer();
	
	        // Gather results
	        my_benchmark[test].results1[i] = calc_timediff(arg.unlock_start, arg.measure_lock_stop);
	        my_benchmark[test].results2[i] = calc_timediff(arg.unlock_start, arg.measure_lock_stop);
/*	
	        printf(
	                "*** start      = %u\n"
	                "*** stop       = %u\n"
	                "*** elapsed    = %u\n",
	                start, stop, stop - start
	              );	

            // Calculate timing results
	        printf(     "\t*********************************\n"
	                    "\t lock Start Time    = %llu ticks\n"
	                    "\t lock Stop Time     = %llu ticks\n"
	                    "\t diff               = %llu ticks\n"
	                    "\t lock Elapsed Time  = %llu us\n",
	                    arg.lock_start, arg.lock_stop, arg.lock_stop - arg.lock_start, calc_timediff_us(arg.lock_start, arg.lock_stop)
	               );
	        printf(     "\t*********************************\n"
	                    "\t unlock Start Time    = %llu ticks\n"
	                    "\t unlock Stop Time     = %llu ticks\n"
	                    "\t diff                 = %llu ticks\n"
	                    "\t unlock Elapsed Time  = %llu us\n"
	                    "\t m_lock Start Time    = %llu ticks\n"
	                    "\t m_lock Stop Time     = %llu ticks\n"
	                    "\t turn around          = %llu us\n",
	                    arg.unlock_start, arg.unlock_stop, arg.unlock_stop - arg.unlock_start, calc_timediff_us(arg.unlock_start, arg.unlock_stop), arg.measure_lock_start, arg.measure_lock_stop, calc_timediff_us(arg.unlock_start, arg.measure_lock_stop)); */
	    }                       
    }
    report_benchmark_results(my_benchmark);

    return 0;
}

