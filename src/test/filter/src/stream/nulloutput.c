#include <framebuffer.h>
#include <hthread.h>
#include <stream.h>
#include <stdio.h>
#include <arch/htime.h>

extern void process_keys();
void nulloutput_check_buffers( stream_node_t *node )
{
    // Make sure that the input buffer is valid
    if( node->input == NULL )
    {
        fprintf(stderr,"output node must be used with a valid input buffer\n");
        exit(1 );
    }
}

void nulloutput_capture_time( hthread_time_t *s, hthread_time_t *e, Huint *f )
{
    hthread_time_t diff;
    double sec;

    // Increment the number of frames that have been processed
    (*f)++;

    // Get the current time
    hthread_time_get(e);

    // Get the elapsed time since the last time we printed
    hthread_time_diff( diff, *e, *s );
    sec = hthread_time_sec( diff );

    // Show the FPS that we are handling
    if( sec > 1 )
    {
        printf( "STATS: (FRAMES=%d) (TIME=%.2f) (RATE=%.2f)\n", *f, sec, *f/sec );
        *f = 0;
        hthread_time_get(s);
    }
}

void nulloutput_cleanup_frame( stream_node_t *node, framebuffer_t *frame )
{
    // Either destroy the frame or insert it in the output buffer
    if( node->output == NULL )
    {
        framebuffer_destroy( frame );
        free( frame );
    }
    else
    {
        buffer_insert( node->output, frame );
    }
}

void* nulloutput_thread( void *arg )
{
    framebuffer_t *frame;
    stream_node_t *node;
    hthread_time_t start;
    hthread_time_t end;
    Huint          frames;

    // Get the argument to the thread
    node = (stream_node_t*)arg;

    // Check that the node has been setup correctly
    nulloutput_check_buffers( node );

    // Initialize the FPS counter
    frames = 0;

    // Capture the current time
    hthread_time_get( &start );

    // Run the input thread
    while( 1 )
    {
        process_keys();

        // Get an image to output from the input buffer
        frame = buffer_remove( node->input );

        // Determine if we should stop processing
        if( frame == NULL ) break;

        // Show the FPS that we are handling
        nulloutput_capture_time( &start, &end, &frames );

        // Clean up the processed frame
        nulloutput_cleanup_frame( node, frame );
    }

    // Finish running the thread
    return NULL;
}
