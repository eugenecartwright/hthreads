#include <hthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <xparameters.h>
#include <xtft_l.h>
#include <vga.h>
#include <eth.h>
#include <arch/htime.h>
#include <sys/exception.h>
#include <config.h>
#include <string.h>

#define ETH_DEVICE_ID   XPAR_ETHERNET_MAC_DEVICE_ID

#define WIDTH       320
#define HEIGHT      240
#define DEPTH       1


void eth_setup( eth_t *eth )
{
    Hint res;
    eth_config_t *config;

    // Lookup the configuration to use
    printf( "Configuring Ethernet...\n" );
    config = XEmac_LookupConfig( ETH_DEVICE_ID );

    // Use only simple DMA
    //config->IpIfDmaConfig = XEM_CFG_SIMPLE_DMA;

    // Turn off DMA usage
    //config->IpIfDmaConfig = XEM_CFG_NO_DMA;

    // Initialize the ethernet device
    printf( "Initializing Ethernet...\n" );
    res = eth_init( eth, config );
    if( res != 0 )
    {
        printf( "Failed to initialize ethernet device\n" );
        while(1);
    }

    // Enable interrupts from the ethernet device
    //printf( "Enabling Ethernet Interrupts...\n" );
    //intr_menable( NONCRIT_PIC_BASEADDR );
    //intr_enable( NONCRIT_PIC_BASEADDR, ETH_MASK );

    /*
    //eth_config_t *config;

    // Lookup the configuration to use
    printf( "Configuring Ethernet...\n" );
    //config = XEmac_LookupConfig( ETH_DEVICE_ID );

    // Turn off DMA usage
    //config->IpIfDmaConfig = XEM_CFG_NO_DMA;

    // Initialize the ethernet device
    if( XEmac_Initialize( &emac, ETH_DEVICE_ID ) != XST_SUCCESS )
    {
        printf( "Failed to initialize ethernet...\n" );
        while( 1 );
    }

    if( XEmac_Stop( &emac ) != XST_SUCCESS )
    {
        printf( "Failed to stop ethernet...\n" );
        //while( 1 );
    }

    Xuint8 macaddr[] = { 0x00, 0x50, 0x56, 0xC0, 0x00, 0x09 };
    if( XEmac_SetMacAddress( &emac, macaddr ) != XST_SUCCESS )
    {
        printf( "Failed to set ethernet mac address...\n" );
        while( 1 );
    }

    Xuint32 options = XEM_INSERT_FCS_OPTION |
                      XEM_INSERT_PAD_OPTION |
                      XEM_UNICAST_OPTION |
                      XEM_BROADCAST_OPTION |
                      XEM_POLLED_OPTION |
                      XEM_STRIP_PAD_FCS_OPTION;
    if( XEmac_SetOptions( &emac, options ) != XST_SUCCESS )
    {
        printf( "Failed to set ethernet options...\n" );
        while( 1 );
    }

    if( XEmac_Start( &emac ) != XST_SUCCESS )
    {
        printf( "Failed to start ethernet...\n" );
        while( 1 );
    }

    XEmac_ClearStats( &emac );
    */
}

void vga_setup( vga_t *vga )
{
    vga_config_t config;

    printf( "Configuring Video...\n" );
    config.base   = XPAR_VGA_FRAMEBUFFER_DCR_BASEADDR;
    config.dbuf   = Htrue;
    config.width  = XTFT_DISPLAY_WIDTH;
    config.height = XTFT_DISPLAY_HEIGHT;

    printf( "Initializing Video...\n" );
    vga_init( vga, &config );
}

void recv_frame( eth_t *eth, void *data, Huint w, Huint h, Huint d )
{
    Hint   res;
    Huint  size;
    Huint  recv;
    Huint  bytes;
    Hubyte *copy;
    Hubyte frame[1518];

    // Type cast the data pointer
    copy = (Hubyte*)data;

    // Initialize the number of bytes received so far
    recv = 0;

    // Calculate the number of bytes in the frame
    size = w * h * d;

    // Read all of the data in
    while( recv < size )
    {
        bytes = 1518;
        res = eth_recv( eth, frame, &bytes );

        if( res == 0 &&
            frame[0]==0x00 && frame[1]==0x50 && frame[2]==0x56 &&
            frame[3]==0xC0 && frame[4]==0x00 && frame[5]==0x09 &&
            frame[6]==0x00 && frame[7]==0x0D && frame[8]==0x61 &&
            frame[9]==0x4A && frame[10]==0xC4 && frame[11]==0xD6 )
        {
            // Subtract off the number of bytes for frame information
            bytes -= 14;
            //printf( "Read %d bytes\n", bytes );

            // Copy the frame to the data
            memcpy( copy+recv, frame+14, bytes );

            // Increment the number of bytes read
            recv += bytes;
        }
    }

    // Show the received frame
    /*
    for( res = 0; res < size; res++ )
    {
        if( res % 20 == 19 )    printf( "\n" );
        printf( "%.2x ", copy[res] );
    }
    printf( "\n" );
    */
}

void show_frame( vga_t *vga, void *data, Huint w, Huint h, Huint d )
{
    static unsigned int frame = 0;
    Huint  *vfb;
    Hubyte *ifb;
    vga_color col;
    Huint x;
    Huint y;
    Huint fx;
    Huint fy;

    // Get the address of the image frame buffer
    ifb = (Hubyte*)data;

    // Get the address of the video frame buffer
    vfb = (Huint*)vga->base;

    // Fill the video frame buffer 
    for( y = 0; y < vga->height; y++ )
    {
        for( x = 0; x < vga->width; x++ )
        {
            fx = x / 2;
            fy = y / 2;

            // Form the next color value
            col = vga_make( ifb[fy*w+fx], ifb[fy*w+fx], ifb[fy*w+fx] );

            // Place the color into the frame buffer
            vfb[y*vga->width + x] = frame % 256;
        }
    }

    frame++;
    // Show the video frame
    vga_flip( vga );
}

void run_recv( eth_t *eth, vga_t *vga )
{
    Huint  frames;
    Hubyte frame[ WIDTH*HEIGHT*DEPTH ];

    frames = 0;
    while( 1 )
    {
        // Receive the next video frame
        recv_frame( eth, frame, WIDTH, HEIGHT, DEPTH );

        // Process the frame
        printf( "Processing Frame: %d (%u)\n", frames++, (Huint)frame[150] );

        // Show the frame using the video device
        vga_framecopy( vga, frame, WIDTH, HEIGHT, DEPTH );
        vga_flip( vga );
    }

    /*
    Huint           res;
    Huint           size;
    Huint           bytes;
    hthread_time_t  start;
    hthread_time_t  end;
    hthread_time_t  diff;
    Hubyte          data[1600];

    while( 1 )
    {
        bytes = 0;
        hthread_time_get(&start);
        while( 1 )
        {
            hthread_time_get(&end);
            hthread_time_diff( diff, end, start );
            if( hthread_time_sec(diff) >= 5.0 )    break;

            size = 1600;
            res = eth_recv( eth, data, &size );
            if( res < 0 )        { printf( "Error during receive\n" ); }
            else if( res == 2 )  { printf( "Buffer is too small\n" ); }

            bytes += size;
        }

        printf( "Bytes Received: %d\n", bytes );
        printf( "Time Elapsed:   %.2f\n", hthread_time_sec(diff) );
    }
    */
}

void run_fill( vga_t *vga )
{
    Huint r;
    Huint g;
    Huint b;
    float s;
    hthread_time_t  start;
    hthread_time_t  diff;
    hthread_time_t  end;

    while( 1 )
    {
        for( r = 0; r < 256; r += 16 )
        {
            hthread_time_get(&start);
            for( g = 0; g < 256; g += 16  )
            {
                for (b = 0; b < 256; b += 16 )
                {
                    vga_clearto( vga, vga_make(r,g,b) );
                    //vga_fill( vga, 0, 0, vga->width, vga->height, vga_make(r,g,b) );
                    vga_flip(vga);
                }
            }
            hthread_time_get(&end);
            hthread_time_diff( diff, end, start );
            s = hthread_time_sec(diff);

            printf( "Frames:  %u\n", 256 );
            printf( "Seconds: %f\n", s );
            printf( "FPS:     %f\n", 256/s );
        }
    }
}

int main( int argc, char *argv[] )
{
    vga_t vga;
    eth_t eth;

    printf( "Video Processing Test Starting...\n" );
    printf( "-----------------------------------" );
    printf( "-----------------------------------\n" );
    vga_setup( &vga );
    eth_setup( &eth );

    printf( "Using Ethernet...\n" );
    run_recv( &eth, &vga );

    printf( "Using Video...\n" );
    run_fill( &vga );

    return 0;
}
