#include <hthread.h>
#include <profile/storage/buffer.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>

Hint hprofile_buffer_create( hprofile_buffer_t *buf, hprofile_buffer_info_t *i )
{
    // Allocate space to hold the data
    buf->data = (Hubyte*)malloc( i->bytes );
    if( buf->data == NULL ) return ENOMEM;

    // Allocate space to hold the information
    buf->info = malloc( i->size );
    if( buf->info == NULL ) { free(buf->data); return ENOMEM; }

    // Copy the initialization data into the information
    memcpy( buf->info, i->init, i->size );

    // Initialize the data structure
    buf->loc      = 0;
    buf->size     = i->bytes;
    buf->samples  = 0;
    buf->buffer   = i->buffer;
    buf->output   = i->output;

    // Return successfully
    return SUCCESS;
}

Hint hprofile_buffer_capture( hprofile_buffer_t *buf, void* sample )
{
    Hint   used;
    Hulong bytes;
    Hubyte *buffer;

    // Fail if the buffer is full
    if( buf->loc >= buf->size ) return ENOMEM;

    // Calculate the next address in memory to use
    buffer = &buf->data[ buf->loc ];

    // Calculate the number of bytes left in the storage
    bytes = buf->size - buf->loc;

    // Delegate to the data interpreter's capture method
    used = buf->buffer( buf->info, buffer, bytes, sample, buf->samples );

    // Increment by the number of bytes to used or return an error
    if( used >= 0 ) buf->loc += used;
    else            return used;

    // Increment the number of samples taken
    buf->samples++;

    // Return successfully
    return SUCCESS;
}

Hint hprofile_buffer_flush( hprofile_buffer_t *buf, hprofile_output_t *out )
{
    // Delegate to the data interpreter's output function
    buf->output( buf->info, buf->data, buf->samples, out );

    // Return successfully
    return SUCCESS;
}

Hint hprofile_buffer_close( hprofile_buffer_t *buf )
{
    // Free the allocated data
    free( buf->data );
    free( buf->info );

    // Return successfully
    return SUCCESS;
}
