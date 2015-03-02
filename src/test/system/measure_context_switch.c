#include <hthread.h>
#include <stdio.h>
#include <arch/htime.h>

#define NUM_THREADS (2)
#define NUM_SAMPLES (200)

// Thread Argument Definition
typedef struct
{
    int max_iters;
    arch_clock_t * data;
} targ_t;

// Worker thread
void * worker_thread (void * arg)
{
    targ_t * targ = (targ_t *)arg;

    // Create a local count, and max count
    int max = targ->max_iters;
    int count = 0;

    // Perform iterations
    for (count = 0; count < max; count++)
    {
        targ->data[count] = _arch_get_time();   // Grab timestamp
        hthread_yield();                        // Yield to next thread
    }

    return NULL;
}

int main()
{

    hthread_t tid[NUM_THREADS];
    targ_t arg[NUM_THREADS];
    int i = 0;
    int j = 0;

    // Setup thread arguments
    printf("Setting up thread arguments.\n");
    for (i = 0; i < NUM_THREADS; i++)
    {
        arg[i].max_iters = NUM_SAMPLES;
        arg[i].data = (arch_clock_t *)malloc(NUM_SAMPLES*sizeof(arch_clock_t));
    }

    // Create threads
    printf("Creating threads.\n");
    for (i = 0; i < NUM_THREADS; i++)
    {
        hthread_create(&tid[i], NULL, worker_thread, (void*)&arg[i]);
    }

    // Wait for threads to complete
    printf("Waiting for threads to complete.\n");
    for (i = 0; i < NUM_THREADS; i++)
    {
        hthread_join(tid[i], NULL);
    }

    // Calculate stats
    printf("Calculating stats.\n");
    arch_clock_t diff, total;

    total = 0;
    for (j = 0; j < NUM_SAMPLES; j++)
    {
        // Difference between 2 thread timestamps
        diff = arg[1].data[j] - arg[0].data[j];

        // Accumulate for average calculation
        total = total + diff;

        // Display intermediate results
        for (i = 0; i < NUM_THREADS; i++)
        {
            printf("%llu, ",arg[i].data[j]);
        }
        printf("--> %llu \n", diff);
    }

    // Display final results
    printf("Average Context Switch Delay = %llu\n",total/NUM_SAMPLES);


    return 0;


}
