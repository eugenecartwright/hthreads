#include <framebuffer.h>
#include <hthread.h>
#include <stream.h>
#include <stdio.h>

void drawinput_check_buffers( stream_node_t *node )
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

framebuffer_t* drawinput_next_frame( stream_node_t *node )
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

void drawinput_draw_square( framebuffer_t *frame )
{
    int x;
    int y;

    /*
    memset( frame->data, 0, frame->width*frame->height*(frame->depth/8) );
    for( y = 10; y < 20; y++ )
    {
        for( x = 10; x < 20; x++ )
        {
            framebuffer_set( frame, x, y, color_make(255,255,255,255) );
        }
    }
    */
    for( y = 0; y < frame->height; y++ )
    {
        for( x = 0; x < frame->width; x++ )
        {
            framebuffer_set( frame, x, y, color_make(x%256,y%256,255,255) );
        }
    }
}

void* drawinput_thread( void *arg )
{
    stream_node_t *node;
    framebuffer_t *frame;

    // Get the argument to the thread
    node = (stream_node_t*)arg;

    // Check that the node was setup correctly
    drawinput_check_buffers( node );

    // Run the input thread
    while( 1 )
    {
        // Get the next video frame
        frame = drawinput_next_frame( node );

        // Draw a square on the frame
        drawinput_draw_square( frame );

        // Determine if we should halt the processing
        if( frame == NULL ) break;

        // Insert the image to the output buffer
        buffer_insert( node->output, frame );
    }

    // Finish running the thread
    return NULL;
}
