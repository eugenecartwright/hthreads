#include <framebuffer.h>
#include <hthread.h>
#include <stream.h>
#include <stdio.h>

void nullinput_check_buffers( stream_node_t *node )
{
    // Make sure that the input buffer is valid
    if( node->input != NULL )
    {
        fprintf(stderr,"input node must be used with no input buffer\n");
        exit(1 );
    }

    // Make sure that the output buffer is valid
    if( node->output == NULL )
    {
        fprintf(stderr,"input node must be used with a valid output buffer\n");
        exit(1 );
    }
}

framebuffer_t* nullinput_next_frame( stream_node_t *node )
{
    framebuffer_t *frame;

    if( node->input == NULL )
    {
        frame = (framebuffer_t*)malloc( sizeof(framebuffer_t) );
        if( frame != NULL )
        {
            framebuffer_create( frame, INPUT_WIDTH, INPUT_HEIGHT );
        }
    }
    else
    {
        frame = buffer_remove( node->input );
    }

    return frame;
}

void* nullinput_thread( void *arg )
{
    stream_node_t *node;
    framebuffer_t *frame;

    // Get the argument to the thread
    node = (stream_node_t*)arg;

    // Check that the node was setup correctly
    nullinput_check_buffers( node );

    // Run the input thread
    while( 1 )
    {
        // Get the next video frame
        frame = nullinput_next_frame( node );

        // Determine if we should halt the processing
        if( frame == NULL ) break;

        // Insert the image to the output buffer
        buffer_insert( node->output, frame );
    }

    // Finish running the thread
    return NULL;
}
