#include "proc_hthread.h"

/*typedef struct
{
    hthread_mutex_t * mutex;
} targ_t;


void * test_thread(void * arg)
{
    targ_t * targ = (targ_t *)(arg);
    int id;

    // Get TID
    id = hthread_self();

    // Atomic print
    hthread_mutex_lock(targ->mutex);
    print("I am 0x%08x\r\n");
    hthread_mutex_unlock(targ->mutex);
	
    // Return ID
    return (void*)id;
}
*/

typedef struct
{
    int num_threads;
    int num_intervals;
    int data;
    double * pi;    
    hthread_mutex_t * pi_mutex;
} targ_t;

void * pi_thread(void * arg)
{
    targ_t * targ = (targ_t *)(arg);
    int id;
    int threads;
    int intervals;

    // Get TID
    id = hthread_self();

    // Extract arguments
    threads = targ->num_threads;
    intervals = targ->num_intervals;

    // Approximate Pi
    register double width, localsum;
    register int i;
    register int iproc = (int)targ->data;

    // set width
    width = 1.0 / intervals;


    /* do the local computations */
    localsum = 0;
    for (i = iproc; i < intervals; i += threads)
    {
        register double x = (i + 0.5) * width;
        localsum += 4.0 / (1.0 + x * x);
    }
    localsum *= width;

    /* get permission, update pi, and unlock */
    hthread_mutex_lock(targ->pi_mutex);
    *(targ->pi) += localsum;
    hthread_mutex_unlock(targ->pi_mutex);

    return (void*)id;
}


int main()
{
	int x = 5;
	pi_thread((void*)x);
	return 0;
}

