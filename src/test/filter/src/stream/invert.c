#include <framebuffer.h>
#include <hthread.h>
#include <stream.h>
#include <stdio.h>

extern int invert_run;
extern void process_keys();

void* invert_thread( void *arg )
{
    int res;
    framebuffer_t *dst;
    framebuffer_t *frame;
    stream_node_t *node;

    // Get the argument to the thread
    node = (stream_node_t*)arg;

    // Make sure that the input buffer is valid
    if( node->input == NULL )
    {
        fprintf(stderr,"sobel node must be used with a valid input buffer\n");
        exit(1 );
    }

    // Make sure that the output buffer is valid
    if( node->output == NULL )
    {
        fprintf(stderr,"sobel node must be used with a valid output buffer\n");
        exit(1 );
    }

    // By default we have no frame for the destination image
    dst = NULL;

    // Run the sobel thread
    while( 1 )
    {
        process_keys();

        // Get an image from the input buffer
        frame = buffer_remove( node->input );

        // Determine if we should stop processing
        if( frame == NULL ) break;

        // Create a destination image if needed
        if( dst == NULL )
        {
            dst = (framebuffer_t*)malloc( sizeof(framebuffer_t) );

            if( dst != NULL )
            {
                res = framebuffer_create( dst, frame->width, frame->height );
                if( res != 0 )
                {
                    free(dst);
                    dst = NULL;
                }
            }
        }

        // Process the image if we can otherwise pass on the input image
        if( dst != NULL && invert_run )
        {
            // Perform the filter
            framebuffer_invert( dst, frame );

            // Place the image on the output buffer
            buffer_insert( node->output, dst );

            // Store the current frame for use as the destination next time
            dst = frame;
        }
        else
        {
            // Place the image on the output buffer unmodified
            buffer_insert( node->output, frame );
        }

    }

    // Destroy our temporary storage
    free( dst );

    // Finish running the thread
    return NULL;
}

