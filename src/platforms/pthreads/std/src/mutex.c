#include <hthread.h>
#include <pthread.h>
#include <config.h>

// Declare all of the mutexes in the system
pthread_mutex_t mutexes[ MUTEX_MAX ];

int hpthread_mutex_init( hpthread_mutex_t *m, const hpthread_mutexattr_t *a )
{
    // Store the mutex number that is being used
    if( a != NULL )
    { 
        *m = a->num; 
        return pthread_mutex_init( &mutexes[*m], &a->attr );
    }
    else
    {
        *m = 0;
        return pthread_mutex_init( &mutexes[*m], NULL );
    }
}

int hpthread_mutex_destroy( hpthread_mutex_t *m )
{
    return pthread_mutex_destroy( &mutexes[*m] );
}

int hpthread_mutex_lock( hpthread_mutex_t *m ) 
{
    return pthread_mutex_lock( &mutexes[*m] );
}

int hpthread_mutex_unlock( hpthread_mutex_t *m )  
{
    return pthread_mutex_unlock( &mutexes[*m] );
}

int hpthread_mutex_trylock( hpthread_mutex_t *m )
{
    return pthread_mutex_trylock( &mutexes[*m] );
}

int hpthread_mutex_getnum( hpthread_mutex_t *m )
{
    return *m;
}

int hpthread_mutex_setprioceiling( hpthread_mutexattr_t *a )
{
    return ENOTSUP;
}

int hpthread_mutex_getprioceiling( hpthread_mutexattr_t *a )
{
    return ENOTSUP;
}

int hpthread_mutexattr_init( hpthread_mutexattr_t *a )
{
    return pthread_mutexattr_init(&a->attr);
}

int hpthread_mutexattr_destroy( hpthread_mutexattr_t *a )
{
    return pthread_mutexattr_destroy(&a->attr);
}

int hpthread_mutexattr_setnum( hpthread_mutexattr_t *a, unsigned int num )
{
    if( num >= MUTEX_MAX )  return EINVAL;

    a->num = num;
    return 0;
}

int hpthread_mutexattr_getnum( hpthread_mutexattr_t *a, unsigned int *num )
{
    *num = a->num;
    return 0;
}

int hpthread_mutexattr_gettype( hpthread_mutexattr_t *a, int *type )
{
    return pthread_mutexattr_gettype(&a->attr,type);
}

int hpthread_mutexattr_settype( hpthread_mutexattr_t *a, int type )
{
    return pthread_mutexattr_settype(&a->attr,type);
}

int hpthread_mutexattr_getpshared( hpthread_mutexattr_t *a )
{
    return ENOTSUP;
}

int hpthread_mutexattr_setpshared( hpthread_mutexattr_t *a )
{
    return ENOTSUP;
}

int hpthread_mutexattr_getprotocol( hpthread_mutexattr_t *a )
{
    return ENOTSUP;
}

int hpthread_mutexattr_setprotocol( hpthread_mutexattr_t *a )
{
    return ENOTSUP;
}

int hpthread_mutexattr_setprioceiling( hpthread_mutexattr_t *a )
{
    return ENOTSUP;
}

int hpthread_mutexattr_getprioceiling( hpthread_mutexattr_t *a )
{
    return ENOTSUP;
}

