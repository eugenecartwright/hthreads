#include <stdlib.h>
#include <buffer.h>
#include <errno.h>
#include <stdio.h>

int buffer_init( buffer_t *buffer, int size )
{
    hthread_mutexattr_t attr;

    // Allocate the buffer memory
    buffer->buffer = (int*)malloc( sizeof(int)*size );
    if( buffer->buffer == NULL )    return ENOMEM;

    // Setup the buffer structure
    buffer->size = size;
    buffer->head = 0;
    buffer->tail = 0;
    buffer->num  = 0;

    // Setup the buffer mutex attributes
    hthread_mutexattr_init( &attr );
    hthread_mutexattr_settype( &attr, HTHREAD_MUTEX_RECURSIVE_NP );

    // Setup the buffer mutex
    hthread_mutex_init( &buffer->mutex, &attr );
    hthread_mutexattr_destroy( &attr );

    // Setup the buffer condition variables
    hthread_cond_init( &buffer->notempty, NULL );
    hthread_cond_init( &buffer->notfull, NULL );

    // Return successfully
    return 0;
}

int buffer_destory( buffer_t *buffer )
{
    // Free the buffer memory if needed
    if( buffer->buffer != NULL && buffer->size > 0 )    free( buffer->buffer );

    // Destroy the buffer
    buffer->buffer = NULL;
    buffer->size   = 0;
    buffer->head   = 0;
    buffer->tail   = 0;
    buffer->num    = 0;

    // Destroy the mutex and condition variables
    hthread_cond_destroy( &buffer->notempty );
    hthread_cond_destroy( &buffer->notfull );
    hthread_mutex_destroy( &buffer->mutex );

    return 0;
}

int buffer_write( buffer_t *buffer, int value )
{
    // Lock the buffer mutex
    hthread_mutex_lock( &buffer->mutex );

    // Wait until there is space in the buffer
    while( buffer->num >= buffer->size )
    {
        hthread_cond_wait( &buffer->notfull, &buffer->mutex );
    }

    // Store the value in the buffer
    buffer->buffer[ buffer->tail ] = value;
    buffer->tail = (buffer->tail + 1) % buffer->size;
    buffer->num++;

    // Unlock the buffer mutex
    hthread_mutex_unlock( &buffer->mutex );

    // Signal that the buffer in not empty any longer
    hthread_cond_signal( &buffer->notempty );

    // Return successfully
    return 0;
}

int  buffer_read( buffer_t *buffer )
{
    int value;

    // Lock the buffer mutex
    hthread_mutex_lock( &buffer->mutex );

    // Wait until there is space in the buffer
    while( buffer->num <= 0 )
    {
        hthread_cond_wait( &buffer->notempty, &buffer->mutex );
    }

    // Get the value out of the buffer
    value = buffer->buffer[ buffer->head ];
    buffer->head = (buffer->head + 1) % buffer->size;
    buffer->num--;

    // Unlock the buffer mutex
    hthread_mutex_unlock( &buffer->mutex );

    // Signal that the buffer is not full any longer
    hthread_cond_signal( &buffer->notfull );

    // Return the read value
    return value;
}

int buffer_size( buffer_t *buffer )
{
    int size;

    // Lock the buffer mutex
    hthread_mutex_lock( &buffer->mutex );

    // Get the buffer size
    size = buffer->num;

    // Lock the buffer mutex
    hthread_mutex_unlock( &buffer->mutex );

    // Return the number of elements in the buffer
    return size;
}
