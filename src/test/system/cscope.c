#include <hthread.h>
#include <stdio.h>
#include <arch/arch.h>

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

void * dumb_child (void * arg)
{
    set_priority(hthread_self(),(Hint)arg);
    while(1);
    return (void*)20;
}

int main()
{
    int x;
    hthread_t tid0, tid1;
    printf("Running main thread on CPU%d, press enter to continue...\n",_get_procid());

    scanf("%d\n",&x);

    hthread_create(&tid0, NULL, dumb_child, (void*)0x33);

    hthread_create(&tid1, NULL, dumb_child, (void*)0x30);

    set_priority(hthread_self(),0x33);
    set_priority(tid0,0x25);
    set_priority(tid1,0x25);
    

    while(1)
    {
        printf("Running main thread on CPU%d, press enter to continue...\n",_get_procid());
    }
    return 0;
}
