#include <hthread.h>
#include <config.h>
#include <stdio.h>

extern pthread_mutex_t  *mutexes;
pthread_cond_t  conds[ COND_MAX ];
int             iconds[ COND_MAX ];

void _hpthread_cond_startup(void) __attribute__ ((constructor));
void _hpthread_cond_startup( void )
{
    fprintf( stderr, "Hthreads pthreads emulation startup...\n" );
    memset( iconds, 0, COND_MAX*sizeof(int) );
}

int hpthread_cond_init( hpthread_cond_t *c, const hpthread_condattr_t *a )
{
    if( a != NULL )
    {
        *c = a->num;
        if( iconds[*c] )    pthread_cond_destroy( &conds[*c] );

        iconds[*c] = 1;
        return pthread_cond_init( &conds[*c], &a->attr );
    }
    else
    {
        *c = 0;
        if( iconds[*c] )    pthread_cond_destroy( &conds[*c] );

        iconds[*c] = 1;
        return pthread_cond_init( &conds[*c], NULL );
    }
}

int hpthread_cond_destroy( hpthread_cond_t *c )
{
    iconds[*c] = 0;
    return pthread_cond_destroy( &conds[*c] );
}

int hpthread_cond_signal( hpthread_cond_t *c )
{
    return pthread_cond_signal( &conds[*c] );
}

int hpthread_cond_broadcast( hpthread_cond_t *c )
{
    return pthread_cond_broadcast( &conds[*c] );
}

int hpthread_cond_wait( hpthread_cond_t *c, hpthread_mutex_t *m )
{
    return pthread_cond_wait( &conds[*c], &mutexes[*m] );
}

int hpthread_cond_getnum( hpthread_cond_t *c )
{
    return *c;
}

int hpthread_condattr_init( hpthread_condattr_t *a )
{
    a->num = 0;
    return pthread_condattr_init(&a->attr);
}

int hpthread_condattr_destroy( hpthread_condattr_t *a )
{
    return pthread_condattr_destroy(&a->attr);
}

int hpthread_condattr_setnum( hpthread_condattr_t *a, int num )
{
    if( num >= COND_MAX )   return EINVAL;

    a->num = num;
    return 0;
}

int hpthread_condattr_getnum( hpthread_condattr_t *a, int *num )
{
    *num = a->num;
    return 0;
}

int hpthread_condattr_getpshared( hpthread_condattr_t *a, int *pshared )
{
    return ENOTSUP;
}

int hphthread_condattr_setpshared( hpthread_condattr_t *a, int pshared )
{
    return ENOTSUP;
}

