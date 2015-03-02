#include <framebuffer.h>
#include <hthread.h>
#include <stream.h>
#include <stdio.h>

extern int gray_run;
void* gray_thread( void *arg )
{
    framebuffer_t *frame;
    stream_node_t *node;

    // Get the argument to the thread
    node = (stream_node_t*)arg;

    // Make sure that the input buffer is valid
    if( node->input == NULL )
    {
        fprintf(stderr,"gray node must be used with a valid input buffer\n");
        exit(1 );
    }

    // Make sure that the output buffer is valid
    if( node->output == NULL )
    {
        fprintf(stderr,"gray node must be used with a valid output buffer\n");
        exit(1 );
    }

    // Run the gray thread
    while( 1 )
    {
        // Get an image from the input buffer
        frame = buffer_remove( node->input );

        // Determine if we should stop processing
        if( frame == NULL ) break;

        // Process the image
        if( gray_run ) framebuffer_gray( frame );

        // Place the image on the output buffer
        buffer_insert( node->output, frame );
    }

    // Finish running the thread
    return NULL;
}

