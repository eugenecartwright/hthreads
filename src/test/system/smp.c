// smp.c -- A test to demonstrate the SMP hthreads system.
//
// by Seth Warn, 2009

#include <stdio.h>
#include <stdarg.h>

#include <hthread.h>
#include <arch/arch.h>
#include <arch/htime.h>
#include <arch/arch.h>


// Various test runs
void create_test(void);
void preempt_test(void);
void problem_test(void);
void preempt_main(void);

// Utility functions
void aprintf(char* fmt, ...);
void wait(int seconds);
void wait_on_lock(hthread_mutex_t * lock);
void set_priority(hthread_t, Hint);
Huint get_priority(void);

// Helper functions
void* simple_thread(void*);
hthread_t create_simple_thread(int duration, Huint priority);


// Mutex used to prevent interleaved printf output
hthread_mutex_t print_mutex;


int main()
{
    hthread_mutex_init(&print_mutex, NULL);

    create_test();
    preempt_test();
    problem_test();
    preempt_main();

    aprintf("Main thread is exiting.\n");
    return 0;
}


void* simple_thread(void* arg)
{
    aprintf("Thread %d started running on CPU %d with priority %d.\n",
            hthread_self(), _get_procid(), get_priority());

    int i;
    for(i = 0; i < (int)arg; i++)
    {
        wait(1);
        aprintf("Thread %d is running on CPU %d...\n",
                hthread_self(), _get_procid());
    }

    aprintf("Thread %d is exiting.\n", hthread_self());
    return NULL;
}


hthread_t create_simple_thread(int duration, Huint priority)
{
    aprintf("Thread %d on CPU %d is creating a simple thread...\n",
            hthread_self(), _get_procid());

    hthread_t thread_id;
    hthread_attr_t attr;
    hthread_attr_init(&attr);
    attr.detached = Htrue;
    attr.sched_param = priority;

    Huint status = hthread_create(&thread_id, &attr, simple_thread, (void*)duration);

    if(status == SUCCESS)
        aprintf("Thread %d created thread %d\n", hthread_self(), thread_id);
    else
        aprintf("Thread %d failed to create a thread with status 0x%8.8x\n",
                hthread_self(), status);

    return thread_id;
}


// The first CPU improves its priority, to prevent preemption of the main
// thread.  It creates a number of simple threads, which should run
// sequentially on the second processor.
void create_test(void)
{
    Huint old_priority = get_priority();
    set_priority(hthread_self(), 10);

    aprintf("******** create_test ********\n");
    aprintf("Main thread (%d) is running on CPU %d with priority %d.\n",
            hthread_self(), _get_procid(), get_priority());

    int i;
    for(i = 0; i < 4; i++)
    {
        create_simple_thread(3, 64);
        wait(1);
    }

    wait(15);
    set_priority(hthread_self(), old_priority);

    aprintf("******** create_test complete ********\n\n");
}


// The first CPU improves its priority, to prevent preemption of the main
// thread.  It creates a thread which should immediately start on the
// second CPU (preempting the idle thread).  Main creates another thread
// with lower priority, which should not run immediately.  Finally, main
// creates a third thread with better priority, which should preempt the
// first created thread.  It should run to completion, then the first
// created thread, then the second.
void preempt_test(void)
{
    Huint old_priority = get_priority();
    set_priority(hthread_self(), 10);

    aprintf("******** preempt_test ********\n");
    aprintf("Main thread (%d) is running on CPU %d with priority %d.\n",
            hthread_self(), _get_procid(), get_priority());

    create_simple_thread(6, 64);
    wait(3);
    create_simple_thread(2, 80);
    wait(3);
    create_simple_thread(2, 50);
    wait(12);
    
    set_priority(hthread_self(), old_priority);
    aprintf("******** preempt_test complete ********\n\n");
}


// Main simply creates two threads of equal priority.  The first should run
// to completion, then the second.
void problem_test(void)
{
    Huint old_priority = get_priority();
    set_priority(hthread_self(), 10);

    aprintf("******** problem_test ********\n");
    aprintf("Main thread (%d) is running on CPU %d with priority %d.\n",
            hthread_self(), _get_procid(), get_priority());

    create_simple_thread(5, 64);
    wait(4);
    create_simple_thread(2, 64);
    wait(8);
    
    set_priority(hthread_self(), old_priority);
    aprintf("******** problem_test complete ********\n\n");
}


// Main creates a thread with good priority, which should immediately start
// running on the second processor.  Main creates a second thread with even
// better priority.  This second thread has better priority than the main
// thread and the first thread; it should preempt main, since main has the
// worst priority of the running threads.
void preempt_main(void)
{
    aprintf("******** preempt_main ********\n");
    aprintf("Main thread (%d) is running on CPU %d with priority %d.\n",
            hthread_self(), _get_procid(), get_priority());

    create_simple_thread(5, 40);
    wait(4);
    create_simple_thread(2, 30);
    wait(3);

    aprintf("******** preempt_main complete********\n\n");
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
