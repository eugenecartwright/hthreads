#include <framebuffer.h>
#include <hthread.h>
#include <stream.h>
#include <stdio.h>

int CURMTX_NUM = 0;
int CURCND_NUM = 0;

int buffer_init( buffer_t *buffer, int size )
{
    hthread_mutexattr_t mattr;
    hthread_condattr_t cattr;
    int i;

    // Attempt to allcoate space for the two frame lists
    buffer->frames = (framebuffer_t**)malloc( size*sizeof(framebuffer_t*) );
    if( buffer->frames == NULL )    return ENOMEM;

    // Initialize the frame buffer list
    for( i = 0; i < size; i++ )       buffer->frames[i] = NULL;

    // Setup the mutex used to protect the buffer
    hthread_mutexattr_init( &mattr );
    hthread_mutexattr_settype( &mattr, HTHREAD_MUTEX_RECURSIVE_NP );
    hthread_mutexattr_setnum( &mattr, CURMTX_NUM++ );
    hthread_mutex_init( &buffer->mutex, &mattr );
    hthread_mutexattr_destroy( &mattr );

    // Setup the buffer not full condition variable
    hthread_condattr_init( &cattr );
    hthread_condattr_setnum( &cattr, CURCND_NUM++ );
    hthread_cond_init( &buffer->notfull, &cattr );
    hthread_condattr_destroy( &cattr );

    // Setup the buffer not empty condition variable
    hthread_condattr_init( &cattr );
    hthread_condattr_setnum( &cattr, CURCND_NUM++ );
    hthread_cond_init( &buffer->notempty, &cattr );
    hthread_condattr_destroy( &cattr );

    // Setup the remainder of the buffer
    buffer->num  = 0;
    buffer->size = size;
    buffer->head = 0;
    buffer->tail = 0;
 
    // Return successfully   
    return 0;
}

int buffer_destroy( buffer_t *buffer )
{
    int i;

    // Make sure this buffer has been initialized
    if( buffer->frames == NULL )    return EINVAL;

    // Destroy the mutex and condition variabled used by the buffer
    hthread_mutex_destroy( &buffer->mutex );
    hthread_cond_destroy( &buffer->notfull );
    hthread_cond_destroy( &buffer->notempty );

    // Destroy the frame buffer list
    for(i = 0; i < buffer->size; i++) buffer->frames[i] = NULL;

    // Destroy the frame buffer memory
    free( buffer->frames );
    buffer->frames = NULL;

    // Destroy the rest of the buffer
    buffer->num  = 0;
    buffer->size = 0;
    buffer->head = 0;
    buffer->tail = 0;

    // Return successfully
    return 0;
}

void buffer_insert( buffer_t *buffer, framebuffer_t *frame )
{
    //fprintf( stderr, "Buffer:        0x%8.8x\n", (unsigned int)buffer );
    //fprintf( stderr, "Buffer Head:   %d\n", buffer->head );
    //fprintf( stderr, "Buffer Tail:   %d\n", buffer->tail );
    //fprintf( stderr, "Buffer Num:    %d\n", buffer->num );
    //fprintf( stderr, "Buffer Size:   %d\n", buffer->size );
    //fprintf( stderr, "Buffer Frames: 0x%8.8x\n", (unsigned int)buffer->frames );
    //fprintf( stderr, "Frame:         0x%8.8x\n", (unsigned int)frame );

    // Lock the buffer mutex
    hthread_mutex_lock( &buffer->mutex );

    // Wait until the buffer is not full
    while( buffer->num >= buffer->size )
    {
        hthread_cond_wait( &buffer->notfull, &buffer->mutex );
    }

    // Place the frame into the buffer
    buffer->frames[ buffer->head ] = frame;

    // Move to the next free location
    buffer->head = (buffer->head + 1) % buffer->size;
    buffer->num++;

    // Unlock the buffer mutex
    hthread_mutex_unlock( &buffer->mutex );

    // Signal that the buffer is no longer empty
    hthread_cond_signal( &buffer->notempty );
}

framebuffer_t* buffer_remove( buffer_t *buffer )
{
    framebuffer_t *frame = NULL;

    // Lock the buffer mutex
    hthread_mutex_lock( &buffer->mutex );

    // Wait until the buffer is not empty
    while( buffer->num <= 0 )
    {
        hthread_cond_wait( &buffer->notempty, &buffer->mutex );
    }

    // Get the frame out of the buffer
    frame = buffer->frames[ buffer->tail ];

    // Move to the next frame location
    buffer->tail = (buffer->tail + 1) % buffer->size;
    buffer->num--;

    // Unlock the buffer mutex
    hthread_mutex_unlock( &buffer->mutex );

    // Signal that the buffer is no longer full
    hthread_cond_signal( &buffer->notfull );

    // Return the frame
    return frame;
}

