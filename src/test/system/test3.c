#include <stdio.h>
#include <hthread.h>

typedef struct
{
    hthread_mutex_t * mutex;
} targ_t;

void* thread( void *arg )
{
    targ_t * targ = (targ_t *)arg;

    while(1)
    {
        hthread_mutex_lock(targ->mutex);

        printf("Child thread (%d)!\n",hthread_self());

        hthread_mutex_unlock(targ->mutex);

    }

    return (void*)99;
}

int main( int argc, char *argv[] )
{
    hthread_t   tid;
    hthread_mutex_t mutex;
    targ_t targ;


    hthread_mutex_init(&mutex,NULL);
    targ.mutex = &mutex;

    hthread_create( &tid, NULL, thread, (void*)&targ );
    printf( "Created TID #%d\n",tid);

    while(1)
    {
        hthread_mutex_lock(&mutex);

        printf("Main thread!\n");

        hthread_mutex_unlock(&mutex);

    }

    

    return 0;
}
