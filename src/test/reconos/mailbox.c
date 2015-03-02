#include <stdlib.h>
#include "mailbox.h"
#include <errno.h>
#include <stdio.h>

int mutexnum = 0;
int condnum = 0;
int mailbox_init( mailbox_t *mailbox, int size )
{
    hthread_mutexattr_t attr;
    hthread_condattr_t  cattr;

    // Allocate the mailbox memory
    mailbox->mailbox = (void**)malloc( sizeof(int)*size );
    if( mailbox->mailbox == NULL )    return ENOMEM;

    // Setup the mailbox structure
    mailbox->size = size;
    mailbox->head = 0;
    mailbox->tail = 0;
    mailbox->num  = 0;

    // Setup the mailbox mutex attributes
    hthread_mutexattr_init( &attr );
    hthread_mutexattr_setnum( &attr, mutexnum++ );
    hthread_mutexattr_settype( &attr, HTHREAD_MUTEX_RECURSIVE_NP );

    // Setup the mailbox mutex
    hthread_mutex_init( &mailbox->mutex, &attr );
    hthread_mutexattr_destroy( &attr );

    // Setup the mailbox condition variables
    hthread_condattr_init( &cattr );
    hthread_condattr_setnum( &cattr, condnum++ );
    hthread_cond_init( &mailbox->notempty, &cattr );
    hthread_condattr_setnum( &cattr, condnum++ );
    hthread_cond_init( &mailbox->notfull, &cattr );

    // Return successfully
    return 0;
}

int mailbox_destroy( mailbox_t *mailbox )
{
    // Free the mailbox memory if needed
    if( mailbox->mailbox != NULL && mailbox->size > 0 )    free( mailbox->mailbox );

    // Destroy the mailbox
    mailbox->mailbox = NULL;
    mailbox->size   = 0;
    mailbox->head   = 0;
    mailbox->tail   = 0;
    mailbox->num    = 0;

    // Destroy the mutex and condition variables
    hthread_cond_destroy( &mailbox->notempty );
    hthread_cond_destroy( &mailbox->notfull );
    hthread_mutex_destroy( &mailbox->mutex );

    return 0;
}

int mailbox_write( mailbox_t *mailbox, void* value )
{
    // Lock the mailbox mutex
    hthread_mutex_lock( &mailbox->mutex );
    //printf( "Writing (%d) (%d)...\n", mailbox->notfull.num, mailbox->notempty.num );

    // Wait until there is space in the mailbox
    while( mailbox->num >= mailbox->size )
    {
        //printf( "Waiting for non-full\n" );
        hthread_cond_wait( &mailbox->notfull, &mailbox->mutex );
        //printf( "done waiting\n" );
    }

    // Store the value in the mailbox
    //printf( "Storing Value\n" );
    mailbox->mailbox[ mailbox->tail ] = value;
    mailbox->tail = (mailbox->tail + 1) % mailbox->size;
    mailbox->num++;
    //printf( "Write Size: %d\n", mailbox->num );

    // Unlock the mailbox mutex
    //printf( "Unlocking Mutex...\n" );
    hthread_mutex_unlock( &mailbox->mutex );
    //printf( "done\n" );

    // Signal that the mailbox in not empty any longer
    //printf( "Signalling not empty\n" );
    hthread_cond_signal( &mailbox->notempty );
    //printf( "done\n" );

    // Return successfully
    return 0;
}

int mailbox_trywrite( mailbox_t *mailbox, void* value )
{
    // Lock the mailbox mutex
    hthread_mutex_lock( &mailbox->mutex );

    // Return a failure if we don't have space
    while( mailbox->num >= mailbox->size )
    {
        hthread_mutex_unlock( &mailbox->mutex );
        return 1;
    }

    // Store the value in the mailbox
    mailbox->mailbox[ mailbox->tail ] = value;
    mailbox->tail = (mailbox->tail + 1) % mailbox->size;
    mailbox->num++;

    // Unlock the mailbox mutex
    hthread_mutex_unlock( &mailbox->mutex );

    // Signal that the mailbox in not empty any longer
    hthread_cond_signal( &mailbox->notempty );

    // Return successfully
    return 0;
}

void*  mailbox_tryread( mailbox_t *mailbox )
{
    void* value;

    // Lock the mailbox mutex
    hthread_mutex_lock( &mailbox->mutex );

    // Wait until there is space in the mailbox
    while( mailbox->num <= 0 )
    {
        hthread_mutex_unlock( &mailbox->mutex );
        return NULL;
    }

    // Get the value out of the mailbox
    value = mailbox->mailbox[ mailbox->head ];
    mailbox->head = (mailbox->head + 1) % mailbox->size;
    mailbox->num--;

    // Unlock the mailbox mutex
    hthread_mutex_unlock( &mailbox->mutex );

    // Signal that the mailbox is not full any longer
    hthread_cond_signal( &mailbox->notfull );

    // Return the read value
    return value;
}

void*  mailbox_read( mailbox_t *mailbox )
{
    void* value;

    // Lock the mailbox mutex
    hthread_mutex_lock( &mailbox->mutex );

    // Wait until there is space in the mailbox
    while( mailbox->num <= 0 )
    {
        //printf( "Waiting for data (%d)...\n", mailbox->notempty.num );
        hthread_cond_wait( &mailbox->notempty, &mailbox->mutex );
        //printf( "done waiting (%d)\n", mailbox->notempty.num );
    }

    // Get the value out of the mailbox
    value = mailbox->mailbox[ mailbox->head ];
    mailbox->head = (mailbox->head + 1) % mailbox->size;
    mailbox->num--;

    // Unlock the mailbox mutex
    hthread_mutex_unlock( &mailbox->mutex );

    // Signal that the mailbox is not full any longer
    hthread_cond_signal( &mailbox->notfull );

    // Return the read value
    return value;
}

int mailbox_size( mailbox_t *mailbox )
{
    int size;

    // Lock the mailbox mutex
    hthread_mutex_lock( &mailbox->mutex );

    // Get the mailbox size
    size = mailbox->num;

    // Lock the mailbox mutex
    hthread_mutex_unlock( &mailbox->mutex );

    // Return the number of elements in the mailbox
    return size;
}
