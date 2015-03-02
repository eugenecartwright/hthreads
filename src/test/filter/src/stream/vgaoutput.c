#include <framebuffer.h>
#include <hthread.h>
#include <stream.h>
#include <stdio.h>
#include <arch/htime.h>
#include <vga/vga.h>
#include <config.h>

extern void process_keys();
void vgaoutput_check_buffers( stream_node_t *node )
{
    // Make sure that the input buffer is valid
    if( node->input == NULL )
    {
        fprintf(stderr,"output node must be used with a valid input buffer\n");
        exit(1 );
    }
}

void vgaoutput_capture_time( hthread_time_t *s, hthread_time_t *e, Huint *f )
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
    if( sec > 10 )
    {
        printf( "STATS: (FRAMES=%d) (RATE=%.2f)\n", *f, *f/sec );
        *f = 0;
        hthread_time_get(s);
    }
}

void vgaoutput_cleanup_frame( stream_node_t *node, framebuffer_t *frame )
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

void vgaoutput_init_vga( vga_t *vga )
{
    vga_config_t config;

    printf( "Configuring Video...\n" );
    config.base   = VGA_BASEADDR;
    config.dbuf   = Htrue;
    config.width  = VGA_WIDTH;
    config.height = VGA_HEIGHT;

    printf( "Initializing Video...\n" );
    vga_init( vga, &config );
}

void vgaoutput_show_frame( vga_t *vga, framebuffer_t *frame )
{
    Huint  *vfb;
    Huint  x;
    Huint  y;
    Huint  vx;
    Huint  vy;
    Hubyte r;
    Hubyte g;
    Hubyte b;
    color_t   fcol;
    vga_color col;

    // Get the address of the video frame buffer
    vfb = (Huint*)vga->base;

    // Fill the video frame buffer 
    for( y = 0; y < frame->height; y++ )
    {
        for( x = 0; x < frame->width; x++ )
        {
            fcol = framebuffer_get( frame, x, y );
            //r    = color_red( fcol );
            //g    = color_green( fcol );
            //b    = color_blue( fcol );

            col = vga_make( fcol, fcol, fcol );
            vfb[ y*1024 + (x+40) ] = col.value;

            //vx  = 2*x; vy  = 2*y;
            //col = vga_make(r,g,b);
            //vfb[(vy+0)*1024 + (vx+0)] = col.value;
            //vfb[(vy+0)*1024 + (vx+1)] = col.value;
            //vfb[(vy+1)*1024 + (vx+0)] = col.value;
            //vfb[(vy+1)*1024 + (vx+1)] = col.value;
        }
    }

    /*
    for( y = 0; y < frame->height; y++ )
    {
        for( x = 0; x < frame->width; x++ )
        {
            fcol = framebuffer_get( frame, x, y );
            r    = color_red( fcol );
            g    = color_green( fcol );
            b    = color_blue( fcol );

            vx  = 2*x; vy  = 2*y;
            col = vga_make(r,g,b);
            vfb[(vy+0)*1024 + (vx+0)] = col.value;
            vfb[(vy+0)*1024 + (vx+1)] = col.value;
            vfb[(vy+1)*1024 + (vx+0)] = col.value;
            vfb[(vy+1)*1024 + (vx+1)] = col.value;
        }
    }
    */

    // Show the video frame
    vga_flip( vga );
}

void* vgaoutput_thread( void *arg )
{
    framebuffer_t *frame;
    stream_node_t *node;
    hthread_time_t start;
    hthread_time_t end;
    Huint          frames;
    vga_t          vga;

    // Get the argument to the thread
    node = (stream_node_t*)arg;

    // Check that the node has been setup correctly
    vgaoutput_check_buffers( node );

    // Initialize the video device
    vgaoutput_init_vga( &vga );

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

        // Output the image
        vgaoutput_show_frame( &vga, frame );

        // Show the FPS that we are handling
        vgaoutput_capture_time( &start, &end, &frames );

        // Clean up the processed frame
        vgaoutput_cleanup_frame( node, frame );
    }

    // Destroy the video device
    vga_destroy( &vga );

    // Finish running the thread
    return NULL;
}
