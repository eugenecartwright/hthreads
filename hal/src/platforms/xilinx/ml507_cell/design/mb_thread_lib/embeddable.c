#include "proc_hthread.h"

typedef struct
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

int main()
{
	int x = 5;
	test_thread((void*)x);
	return 0;
}
