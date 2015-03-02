#include <framebuffer.h>
#include <hthread.h>
#include <stream.h>
#include <stdio.h>
#include <arch/cache.h>

#define PERFORM_VIA_THREAD

extern int hw_not_sw;
extern int laplace3_run;
struct simple_laplace_arg {
    framebuffer_t *src;
    framebuffer_t *dst;

};

void* simple_laplace_thread (void * arg)
{
    struct simple_laplace_arg *myArg;

    // Extract thread arguments
    myArg = (struct simple_laplace_arg*)arg;

    // Call helper function
    framebuffer_laplace3(myArg->dst, myArg->src);

    // Exit thread
    return NULL;

}

void* laplace3_thread( void *arg )
{
    int res;
    int w,h,d;
    framebuffer_t *dst;
    framebuffer_t *frame;
    stream_node_t *node;
    hthread_t tid;
    struct simple_laplace_arg laplaceArg;
    Huint ret;
    hthread_attr_t hwThreadAttr;

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
        if( dst != NULL && laplace3_run )
        {


#ifndef PERFORM_VIA_THREAD
            // ******* Peform the filter via function call
            // Perform the filter
            framebuffer_laplace3( dst, frame );
#else
            // ******* Peform the filter via thread creation
            // Init. thread attributes
            hthread_attr_init( &hwThreadAttr );

            // Check if thread should be created in HW or SW
            if (hw_not_sw)
                hthread_attr_sethardware( &hwThreadAttr, 0x63000000 );

            // Save params
            w = frame->width;
            h = frame->height;
            d = frame->depth;

            // Init. thread argument
            laplaceArg.dst = dst;
            laplaceArg.src = frame;

            // Flush the cache so that the HWT can "see" the frame data
            //dcache_flush();

            // Perform filter via thread creation
            //printf("Created HWT!!!!!\n");
            hthread_create(&tid, &hwThreadAttr, simple_laplace_thread, (void*)&laplaceArg);     // Create child thread and pass its parameter
            hthread_join(tid, (void*)&ret);                                                     // Join child thread and gather its return value
            //printf("HWT Finished Woohooo!!!!!\n");

            // Restore params
            dst->width = w;
            dst->height = h;
            dst->depth = d;
#endif
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

