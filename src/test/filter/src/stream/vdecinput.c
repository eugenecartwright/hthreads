#include <framebuffer.h>
#include <hthread.h>
#include <stream.h>
#include <stdio.h>
#include <vdec/vdec.h>
#include <config.h>
#include <arch/cache.h>

#define VSYNC_SIG   0x1
#define DATAB_SIG   0x2
#define DATAA_SIG   0x4
#define DATA_SIG    0x6 // (DATAB_SIG | DATAA_SIG)

void vdecinput_check_buffers( stream_node_t *node )
{
    // Make sure that the output buffer is valid
    if( node->output == NULL )
    {
        fprintf(stderr,"input node must be used with a valid output buffer\n");
        exit(1 );
    }
}

framebuffer_t* vdecinput_next_frame( stream_node_t *node )
{
    framebuffer_t *frame;

    if( node->input == NULL )
    {
        printf( "Allocating new frame...\n" );
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

void vdecinput_init( vdec_t *vdec )
{
    Hint res;
    vdec_config_t config;

    // Setup the address of the I2C hardware
    config.base  = XPAR_I2C_BASEADDR;

    // Setup the address of the data ready gpio
    config.ready = XPAR_VIDEO_MEM_READY_GPIO_BASEADDR;

    // Setup the addresses of the video data buffers
    config.data[0] = XPAR_VIDEO_MEM_BRAM_CNTLRA_BASEADDR;
    config.data[1] = XPAR_VIDEO_MEM_BRAM_CNTLRB_BASEADDR;

    // Attempt to initialize the video decoder driver
    res = vdec_create( vdec, &config );
    if( res != SUCCESS )
    {
        printf( "Failed to initialize video decoder\n" );
        exit( 1 );
    }

    // Select the composite video input on the video decoder
    res = vdec_select_composite( vdec );
    if( res != SUCCESS )
    {
        printf( "Failed to select composite video input\n" );
        exit( 1 );
    }
}

void vdecinput_getimage( vdec_t *vdec, framebuffer_t *frame )
{
    Huint x;
    Huint y;
    Huint i;
    Huint j;
    Huint sigs;
    Huint sel;
    Huint readyPattern;
    Huint start;
    Huint end;
    Huint val, old_val;
    Huint wait;
    volatile unsigned long long int *buf;
    unsigned long long int *fbuf;

    // Initialize all of the values
    //x = 0;
    //y = 0;
    //end = 0;
    sigs = 0;

    // Clear our the frame buffer
    //memset( frame->data, 0xFF, frame->width*frame->height*(frame->depth/8) );

    // Wait for a VSYNC signal
    while( !(sigs & VSYNC_SIG) )  { sigs = *vdec->ready; }

    // Determine which buffer the data is in
    sel = (sigs & DATAA_SIG) != 0;
    //if( (sigs & DATAA_SIG) != 0 ) sel = 1;
    //else                          sel = 0;

    for( y = 0; y < INPUT_HEIGHT; y++ )
    {
        // Select buffer to read from
        buf = (unsigned long long int*)(vdec->data[sel]);

        // Determine the start and end of the line
        start = y*frame->width;
        end   = start + INPUT_WIDTH;
        fbuf  = (unsigned long long int*)&frame->data[start];

        // Loop through all pixels in a line
        for( x=start; x<end; x = x+80 ){
            *fbuf++ = *buf++;
            *fbuf++ = *buf++;
            *fbuf++ = *buf++;
            *fbuf++ = *buf++;
            *fbuf++ = *buf++;
            *fbuf++ = *buf++;
            *fbuf++ = *buf++;
            *fbuf++ = *buf++;

            *fbuf++ = *buf++;
            *fbuf++ = *buf++;
        }
        ppc405_dcache_invaddrs( vdec->data[sel], INPUT_WIDTH );

        // Wait for the next line of data to become available
        readyPattern = sigs & DATA_SIG;
        while( (sigs&DATA_SIG) == readyPattern ) { sigs = *vdec->ready; }
        sel = !sel;

        //readyPattern = sigs & DATA_SIG;
        //while( (sigs&DATA_SIG) == readyPattern ) sigs = *vdec->ready;
        //sigs = *vdec->ready;
    }

   
/*    printf( "\n" );
    for( x = 0; x < INPUT_WIDTH; x += 32 )
    {
        for( delay = 0; delay < 32; delay++ )
        {
            if( delay % 4 == 0 && delay != 0 ) printf( " " );
            printf( "%02.2X", frame->data[100*INPUT_HEIGHT + x+delay] );
        }
        printf( "\n" );

    } 
    printf( "\n" );
  */  
    //delay = 0;
    //while( delay < 50000000 ) delay++;
}

void* vdecinput_thread( void *arg )
{
    stream_node_t *node;
    framebuffer_t *frame;
    vdec_t        vdec;

    // Get the argument to the thread
    node = (stream_node_t*)arg;

    // Check that the node was setup correctly
    vdecinput_check_buffers( node );

    // Initialize the video decoder hardware
    vdecinput_init( &vdec );

    // Run the input thread
    while( 1 )
    {
        // Get the next video frame
        frame = vdecinput_next_frame( node );

        // Determine if we should halt the processing
        if( frame == NULL ) break;

        // Get the next image from the VDEC hardware
        vdecinput_getimage( &vdec, frame );

        // Insert the image to the output buffer
        buffer_insert( node->output, frame );
    }

    // Finish running the thread
    return NULL;
}
