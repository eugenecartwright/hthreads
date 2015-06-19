/************************************************************************************
* Copyright (c) 2015, University of Arkansas - Hybridthreads Group
* All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
* 
*     * Redistributions of source code must retain the above copyright notice,
*       this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright notice,
*       this list of conditions and the following disclaimer in the documentation
*       and/or other materials provided with the distribution.
*     * Neither the name of the University of Arkansas nor the name of the
*       Hybridthreads Group nor the names of its contributors may be used to
*       endorse or promote products derived from this software without specific
*       prior written permission.
* 
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
* ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
************************************************************************************/

#include <stdlib.h>
#include <buffer.h>

Hint buffer_init( buffer_t *buffer, Huint size, Huint max )
{
    // Values to store the next mutex id and condition variable id
    static int mid = 0;
    static int cid = 0;
    static int bid = 0;
    
    // Attribute objects for the mutexes and the condition variables
    hthread_mutexattr_t attrs;
    hthread_condattr_t  cattrs;

    // Attempt to allocate storage for the buffer
    buffer->data = (Hint*)malloc( sizeof(Hint) * size );

    // Check that the allocation was successful
    if( buffer->data == NULL )  DEBUG_PRINTF( "ERROR: (OP=MALLOC) (STA=FAILED)\n" );

    // Set the defaults for the rest of the structure
    buffer->num  = 0;
    buffer->head = 0;
    buffer->tail = 0;
    buffer->size = size;
    buffer->gets = 0;
    buffer->puts = 0;
    buffer->bid  = bid++;
    buffer->max  = max;

    // Initialize the mutex
    hthread_mutexattr_init( &attrs );
    hthread_mutexattr_setnum( &attrs, mid++ );
    hthread_mutex_init( &buffer->mutex, &attrs );

    // Initialize the notfull mutex
    hthread_condattr_init( &cattrs );
    hthread_condattr_setnum( &cattrs, cid++ );
    hthread_cond_init( &buffer->notfull, &cattrs );

    // Initialize the notempty condition variable
    hthread_condattr_init( &cattrs );
    hthread_condattr_setnum( &cattrs, cid++ );
    hthread_cond_init( &buffer->notempty, &cattrs );

    // Return successfully
    return SUCCESS;
}

Hint buffer_destroy( buffer_t *buf )
{
    // Free the buffer memory
    free( buf->data );

    // Destroy the mutexes
    hthread_mutex_destroy( &buf->mutex );

    // Destroy the condition variable
    hthread_cond_destroy( &buf->notfull );
    hthread_cond_destroy( &buf->notempty );

    // Return successfully
    return SUCCESS;
}

Hint buffer_get( buffer_t *buf, Hint *val )
{
    Hint num;

    // Lock the mutex
    hthread_mutex_lock( &buf->mutex );

    // Loop while the buffer is empty
    while( buf->num <= 0 && (buf->max < 0 || buf->gets < buf->max) )
    {
        hthread_cond_wait( &buf->notempty, &buf->mutex );
    }

    // If the total number of values produced is exceeded then exit
    if( buf->max > 0 && buf->gets >= buf->max )
    {
        hthread_cond_signal( &buf->notfull );
        hthread_cond_signal( &buf->notempty );
        hthread_mutex_unlock( &buf->mutex );
        return -1;
    }

    // Get the next value out of the buffer
    *val = buf->data[ buf->tail ];

    // Print out that we are getting a value our of the buffer
    TRACE5_PRINTF( "BUFFER: (OP=GET) (VAL=%d)\n", *val );

    // Move the tail pointer
    buf->tail = (buf->tail + 1) & buf->size;

    // Decrememnt the size of the buffer
    buf->num -= 1;

    // Increment the number of get operations performed
    buf->gets += 1;
    
    // Store the value to return
    num = buf->gets;

    // The buffer is not longer full
    hthread_cond_signal( &buf->notfull );

    // Unlock the mutex
    hthread_mutex_unlock( &buf->mutex );

    // Return successfully
    return num;
}
    
Hint buffer_put( buffer_t *buf, Hint val )
{
    Hint num;

    // Lock the mutex
    hthread_mutex_lock( &buf->mutex );

    // Loop while the buffer is full
    while( buf->num >= buf->size && (buf->max < 0 || buf->puts < buf->max) )
    {
        hthread_cond_wait( &buf->notfull, &buf->mutex );
    }

    // If the total number of values produced is exceeded then exit
    if( buf->max > 0 && buf->puts >= buf->max )
    {
        hthread_cond_signal( &buf->notfull );
        hthread_cond_signal( &buf->notempty );
        hthread_mutex_unlock( &buf->mutex );
        return -1;
    }

    if( buf->puts % (buf->max / 100) == 0 )
    {
        TRACE1_PRINTF( "BUFFER: (OP=PUT) (ID=%d) (VAL=%d)\n", buf->bid,
                       (int)ceil((100.0f*buf->puts)/buf->max) );
    }

    // Put the next value into the buffer
    buf->data[ buf->head ] = val;

    // Print out that we are putting a value into the buffer
    TRACE5_PRINTF( "BUFFER: (OP=PUT) (VAL=%d)\n", val );

    // Move the head pointer
    buf->head = (buf->head + 1) & buf->size;

    // Incrememnt the size of the buffer
    buf->num += 1;

    // Increment the number of put operations performed
    buf->puts += 1;
    
    // Store the value to return
    num = buf->puts;

    // The buffer is no longer empty
    hthread_cond_signal( &buf->notempty );

    // Unlock the mutex
    hthread_mutex_unlock( &buf->mutex );

    // Return successfully
    return num;
}

Hint buffer_size( buffer_t *buf, Huint *size )
{
    // Lock the mutex
    hthread_mutex_lock( &buf->mutex );

    // Grab the size of the mutexes
    *size = buf->num;

    // Unlock the mutex
    hthread_mutex_unlock( &buf->mutex );

    // Return successfully
    return SUCCESS;
}
