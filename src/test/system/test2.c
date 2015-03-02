#include <stdio.h>
#include <hthread.h>
#include <arch/arch.h>

void* thread( void *arg )
{
    int val;
    int tmp;

    printf("In new thread (TID# %d) on cpu %d.\n", hthread_self(), _get_procid());

    tmp = 1;
    for( val = (int)arg; val > 0; val-- )   tmp *= val;

    printf("New thread returning...\n");
    return (void*)tmp;
}

int main( int argc, char *argv[] )
{
    hthread_t   tid;
    void*       retval;

    hthread_create( &tid, NULL, thread, (void*)5 );
    printf( "Created TID #%d\n",tid);

    hthread_join( tid, &retval );
    
    printf( "Factorial of 5: %d\n", (int)retval );

    return 0;
}
