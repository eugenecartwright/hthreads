#include <framebuffer.h>
#include <hthread.h>
#include <stream.h>
#include <stdio.h>
#include <arch/htime.h>

void tgainput_check_buffers( stream_node_t *node )
{
    // Make sure that the output buffer is valid
    if( node->output == NULL )
    {
        fprintf(stderr,"input node must be used with a valid output buffer\n");
        exit(1 );
    }
}

framebuffer_t* tgainput_next_frame( stream_node_t *node, framebuffer_t *copy )
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

void* tgainput_thread( void *arg )
{
    Hint res;
    stream_node_t *node;
    framebuffer_t image;
    framebuffer_t *frame;

    // Get the argument to the thread
    node = (stream_node_t*)arg;

    // Check that the node was setup correctly
    tgainput_check_buffers( node );

    // Read the image in
    res = framebuffer_tgain( &image, "image.tga" );
    if( res != 0 )
    {
        perror( "cannot read input image" );
        exit(1);
    }

    // Run the input thread
    while( 1 )
    {
        // Get the next video frame
        frame = tgainput_next_frame( node, &image );

        // Determine if we should halt the processing
        if( frame == NULL ) break;

        // Copy the video into the output frame
        framebuffer_copy( frame, &image );

        // Insert the image to the output buffer
        buffer_insert( node->output, frame );
    }

    // Finish running the thread
    return NULL;
}
