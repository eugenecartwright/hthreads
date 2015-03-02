#include <hthread.h>
#include <debug.h>
#include <stdlib.h>
#include <stdio.h>

#define LOOPS                       200
#define THREADS                     250

Hint thread_setpriority( hthread_t th, Hint pri )
{
    Hint status;
    struct sched_param pr;

    pr.sched_priority = pri;
    status = hthread_setschedparam( th, SCHED_OTHER, &pr );

    if( status < 0 )    DEBUG_PRINTF("SET PRIORITY ERROR: 0x%8.8x\n", status);
    return status;
}

Hint thread_create(hthread_t *t, hthread_attr_t *a, hthread_start_t s, void *g)
{
    Hint status;

    status = hthread_create( t, a, s, g );

	if( status != SUCCESS ) DEBUG_PRINTF( "CREATE ERROR: 0x%8.8x\n", status );
    return status;
}

Hint thread_join( hthread_t tid, void **ret )
{
    Hint status;

    status = hthread_join( tid, ret );

    if( status != SUCCESS ) DEBUG_PRINTF( "JOIN ERROR: 0x%8.8x\n", status );
    return status;
}

void* thread( void *arg )
{
    Hint i;
    for( i = 0; i < LOOPS; i++ )    hthread_yield();
    return NULL;
}

int main( int argc, char *argv[] )
{
    Hint i;
    hthread_t th[ THREADS ];

    for( i = 0; i < THREADS; i++ )  thread_create(&th[i], NULL, thread, NULL);
    for( i = 0; i < THREADS; i++ )  thread_join( th[i], NULL );

    return 0;
}
