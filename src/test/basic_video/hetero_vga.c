/*

   Image Processing App

   Requires VGA driver configuration


   */
#include <stdio.h>
#include <xio.h>
#include "xbasic_types.h"
#include "xstatus.h"
#include "xparameters.h"
#include <xparameters.h>
#include "image_lib.h"
#include <hthread.h>
#include "hetero_lib.h"
#include <xcache_l.h>
#include <vga/vga.h>
#include <config.h>

// Useful definitions
#define DDR_BASEADDR    XPAR_DDR2_SDRAM_MPMC_BASEADDR
#define DISPLAY_COLUMNS  640
#define DISPLAY_ROWS     480

#define USE_MB_PROCESS_THREAD
//#define USE_MB_OUTPUT_THREAD

typedef unsigned char       uint8;
struct __color_rgb_t
{
    uint8   r;
    uint8   g;
    uint8   b;
} __attribute__((__packed__));;

typedef struct __color_rgb_t  pixel_t;

typedef struct
{
    int width;
    int height;
    pixel_t * im_ptr;
} framebuffer_t;

typedef struct
{
    hthread_mutex_t * output_mutex;
    framebuffer_t * src_image;
    framebuffer_t * dst_image;
    vga_t   * vga;
}targ_t;


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

void draw_picture(unsigned char * apic_ptr)
{
    int i, j, pixel;
    unsigned int * framebuf_ptr;
		framebuf_ptr = (unsigned int*)DDR_BASEADDR;
	        for( i = 0; i < 512; i++)
	        {
	            for (j = 0; j < 1024; j++)
	            {
	                pixel = (apic_ptr[0] << 16) | (apic_ptr[1] << 8) | (apic_ptr[2] << 0);
	
	                if ((j >= DISPLAY_COLUMNS) || (i >= DISPLAY_ROWS))
	                {
	                    pixel = 0;
	                }
	                else
	                {
	                    apic_ptr = apic_ptr + 3;
	                }
	
	                *framebuf_ptr++ = pixel;
	            }
	        }
}

void usleep(int delay)
{
    int x = delay;
    int y = 0;
    for (y = 0; y < delay; y++)
    {
        x = y + delay * x / (x + 3);
    }
}

#define labs(x)     ((x) < 0 ? -(x) : (x))

pixel_t framebuffer_get( framebuffer_t * im, int xc, int yc)
{
    int coord;
    coord = xc +(im->width*yc);
    return im->im_ptr[coord];   
}

void framebuffer_set( framebuffer_t * im, int xc, int yc, pixel_t p)
{
    int coord;
    coord = xc + (im->width*yc);
    im->im_ptr[coord] = p;
//    printf("addr = 0x%08x\n",&im->im_ptr[coord]);
}

int color_red(pixel_t p)
{
    return p.r;
}

int color_green(pixel_t p)
{
    return p.g;
}

int color_blue(pixel_t p)
{
    return p.b;
}

/*
#define color_make(_r,_g,_b,_a)  ({  \
         pixel_t c;                  \
         c.r = _r;                   \
         c.g = _g;                   \
         c.b = _b;                   \
         c;                          \
})
*/
#define color_make(_r,_g,_b,_a)  ({ pixel_t c; c.r = _r; c.g = _g; c.b = _b; c; })

#define int32 int

int laplace3( framebuffer_t *dst, framebuffer_t *src )
{
    int32   x;
    int32   y;
    int32   i;
    int32   j;
    int32   xn;
    int32   yn;
    int32   r;
    int32   g;
    int32   b;
    int32   m;
    pixel_t t;

    if(( dst->width != src->width ) || ( dst->height != src->height )) {
        printf("Error, dimensions don't match!\n");
    }
    int count = 0;
    for( y = 0; y < src->height; y++ )
    {
        for( x = 0; x < src->width; x++ )
        {
            r = 0;  g = 0;  b = 0;
            for( j = -1; j <= 1; j++ )
            {
                for( i = -1; i <= 1; i++ )
                {
                    xn = x + i;
                    yn = y + j;

                    if( xn < 0 )                  xn = 0;
                    else if( xn >= src->width )   xn = src->width-1;

                    if( yn < 0 )                  yn = 0;
                    else if( yn >= src->height )  yn = src->height-1;

                    if( i == 0 && j == 0 )     m = 8;
                    else                       m = -1;

                    t = framebuffer_get( src, xn, yn );
                    r += m*color_red(t);
                    g += m*color_green(t);
                    b += m*color_blue(t);
                }
            }

            if( r < 0 )         r = 0;
            else if( r > 255 )  r = 255;

            if( g < 0 )         g = 0;
            else if( g > 255 )  g = 255;

            if( b < 0 )         b = 0;
            else if( b > 255 )  b = 255;

            framebuffer_set( dst, x, y, color_make(r,g,b,255) );
            count++;
/*            if (count < 10)
            {
                printf("Orig = ( %d, %d, %d)\n",color_red(t), color_green(t), color_blue(t));
                printf("New  = ( %d, %d, %d)\n",r,g,b);
            }
            */
        }
    }

    return 0;
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
    pixel_t   fcol;
    vga_color col;

    // Get the address of the video frame buffer
    vfb = (Huint*)vga->base;

    for( y = 0; y < frame->height; y++ )
    {
        for( x = 0; x < frame->width; x++ )
        {	                
            fcol = framebuffer_get( frame, x, y );
            r    = color_red( fcol );
            g    = color_green( fcol );
            b    = color_blue( fcol );

            col = vga_make(r,g,b);
            vx = x;
            vy = y;
            vfb[(vy+0)*1024 + (vx+0)] = col.value;
/*
            vx  = 2*x; vy  = 2*y;
            vfb[(vy+0)*1024 + (vx+0)] = col.value;
            vfb[(vy+0)*1024 + (vx+1)] = col.value;
            vfb[(vy+1)*1024 + (vx+0)] = col.value;
            vfb[(vy+1)*1024 + (vx+1)] = col.value;
            */
        }
    }

    // Show the video frame
    vga_flip( vga );
}

#define labs(x)     ((x) < 0 ? -(x) : (x))
#define MAX_VALUE   256
#define NUM_BINS    256

int32 framebuffer_invert( framebuffer_t *dst, framebuffer_t *src )
{
    int32   x;
    int32   y;
    int32   r_inv;
    int32   g_inv;
    int32   b_inv;
    pixel_t t;

    if( dst->width != src->width )      return EINVAL;
    if( dst->height != src->height )    return EINVAL;

    // Invert image pixel by pixel
    for( y = 0; y < src->height; y++ )
    {
        for( x = 0; x < src->width; x++ )
        {            
            // Grab a pixel and invert it
            t = framebuffer_get( src, x, y);
            r_inv = MAX_VALUE - color_red(t);
            g_inv = MAX_VALUE - color_green(t);
            b_inv = MAX_VALUE - color_blue(t);

            if( r_inv < 0 )         r_inv = 0;
            else if( r_inv > 255 )  r_inv = 255;

            if( g_inv < 0 )         g_inv = 0;
            else if( g_inv > 255 )  g_inv = 255;

            if( b_inv < 0 )         b_inv = 0;
            else if( b_inv > 255 )  b_inv = 255;


            // Write out inverted pixel
            framebuffer_set (dst, x, y, color_make(r_inv,g_inv,b_inv,255));
        }
    }

    return 0;
}

int32 framebuffer_histogram( framebuffer_t *dst, framebuffer_t *src )
{
    static int32   max = 1;
    int32   hist[NUM_BINS];
    int32   lum;
    int32   bin;
    int32   x;
    int32   y;
    int32   i;
    int32   j;
    int32   r;
    int32   g;
    int32   b;
    int32   h;
    pixel_t t;

    if( dst->width != src->width )      return EINVAL;
    if( dst->height != src->height )    return EINVAL;

    // Initialize histogram
    for (i = 0; i < NUM_BINS; i++ )
    {
        hist[i] = 0;
    }

    // Build histogram
    for( y = 0; y < src->height; y++ )
    {
        for( x = 0; x < src->width; x++ )
        {
            
            // Grab a pixel
            t = framebuffer_get( src, x, y);
            r = color_red(t);
            g = color_green(t);
            b = color_blue(t);

            // Calculate luminance (Y-value)
            //  * Since all values are gray-scale, just use the r-value
            lum = r;

            // Calculate proper histogram bin to put value in
            bin = lum / (MAX_VALUE/NUM_BINS);

            // Increment histogram bin
            hist[bin] = hist[bin] + 1;
            if( hist[bin] > max ) max = hist[bin];

            // Zero out pixel in destination
            //  * Comment out if you would like to superimpose the 
            //    histogram on the original image
            //framebuffer_set (dst, x, y, color_make(0,0,0,255));

            // Re-insert original pixel
            framebuffer_set (dst, x, y, t);
        }
    }

    // Build image from histogram
    for (i = 0; i < NUM_BINS; i++ )
    {
        // Set x-axis value of the histogram entry
        x = i;

        // Set max y-value of histogram entry
        h = (240*hist[i])/(10000);
        if( h > src->height ) h = src->height;

        // Draw a vertical line with height of hist[i]
        for (j = src->height - h; j < (src->height); j++){
            y = j;
            framebuffer_set (dst, x, y, color_make(255,255,255,255));
        }
    }

    //printf("Done!!\n");

    return 0;
}

void * input_thread (void * arg)
{
    targ_t * targ = (targ_t *)arg;
    int count = 0;
    while(1)
    {
        hthread_mutex_lock(targ->output_mutex);

        // Do nothing
        printf("INPUT THREAD, frame %d\n",count++);

/*        int i = 0;
        for (i = 0 ; i < 10; i++)
        {
            printf(".");
            usleep(100);
        }
        printf("\n");
        */

        hthread_mutex_unlock(targ->output_mutex);
        hthread_yield();
        usleep(100);
    }

    return NULL;
}


void * output_thread (void * arg)
{
    targ_t * targ = (targ_t *)arg;
    int count = 0;

    while(1)
    {
        hthread_mutex_lock(targ->output_mutex);
        printf("OUTPUT THREAD\n");
        vgaoutput_show_frame( targ->vga, targ->src_image );
        vgaoutput_show_frame( targ->vga, targ->dst_image );
/*        if (count%2 == 0)
        {
            vgaoutput_show_frame( targ->vga, targ->dst_image );
        }
        else
        {
            vgaoutput_show_frame( targ->vga, targ->src_image );
        }
        */
        hthread_mutex_unlock(targ->output_mutex);
        count++;
        hthread_yield();
    }

    return NULL;
}

#define DIV 3
void * process_thread (void * arg)
{
    targ_t * targ = (targ_t *)arg;
    int count = 0;
    while(1)
    {
        hthread_mutex_lock(targ->output_mutex);

        printf("PROCESS THREAD\n");
        
        if (count % DIV == 0)
        {
            laplace3(targ->dst_image,targ->src_image);
        }
        else if (count % DIV == 1)
        {
            framebuffer_histogram(targ->dst_image,targ->src_image);
        }
        else
        {
            framebuffer_invert(targ->dst_image,targ->src_image);
        }

        count++;

        hthread_mutex_unlock(targ->output_mutex);
        hthread_yield();
    }

    return NULL;
}

/**************************** Type Definitions ******************************/

/***************** Macros (Inline Functions) Definitions ********************/

/************************** Function Prototypes *****************************/

int TftExample(u32 TftDeviceId);

/************************** Variable Definitions ****************************/


/************************** Function Definitions ****************************/
/*****************************************************************************/
/**
*
* Main function that invokes the Tft example.
*
* @param	None.
*
* @return
*		- XST_SUCCESS if successful.
*		- XST_FAILURE if unsuccessful.
*
* @note		None.
*
******************************************************************************/

#define TFT_DEVICE_ID  XPAR_XPS_TFT_0_DEVICE_ID
int main()
{
    // Setup Cache
    XCache_DisableDCache();
    XCache_EnableICache(0xc0000801);

    int Status;

	Status = TftExample(TFT_DEVICE_ID);
	if ( Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	return XST_SUCCESS;
}

/*****************************************************************************/
/**
*
* This is the example function which performs the following operations on
* the TFT device -
* - Write numeric characters (0-9) one after another
* - Writes a Color Bar Pattern
* - fills the framebuffer with three colors
*
* @param	TftDeviceId is the unique Id of the device.
*
* @return
*		- XST_SUCCESS if successful.
*		- XST_FAILURE if unsuccessful.
*
* @note		None.
*
******************************************************************************/
int TftExample(u32 TftDeviceId)
{
    hthread_t tid0, tid1, tid2;
    targ_t targ;
    hthread_mutex_t mutex;
    vga_t          vga;

    // Initialize the video device
    printf("Setting up TFT...\r\n");
    vgaoutput_init_vga( &vga );

    // Initialize mutex
    printf("Setting up synchronization...\r\n");
    hthread_mutex_init(&mutex, NULL);
    
    // Allocating framebuffers
    printf("Allocating framebuffers...\n");
    targ.src_image = malloc(sizeof(framebuffer_t));
    targ.dst_image = malloc(sizeof(framebuffer_t));

    // Setup thread arguments
    printf("Setting up thread arguments...\r\n");
    targ.output_mutex = &mutex;
    targ.src_image->width = DISPLAY_COLUMNS;
    targ.src_image->height = DISPLAY_ROWS;
    targ.dst_image->width = DISPLAY_COLUMNS;
    targ.dst_image->height = DISPLAY_ROWS;
    targ.src_image->im_ptr = (pixel_t *)&image_array_rgb[0];
    targ.dst_image->im_ptr = (pixel_t *)&temp_array_rgb[0];
    targ.vga = &vga;


    extern unsigned char intermediate[];

    extern unsigned int output_handle_offset;
    unsigned int output_handle = (output_handle_offset) + (unsigned int)(&intermediate);

    extern unsigned int input_handle_offset;
    unsigned int input_handle = (input_handle_offset) + (unsigned int)(&intermediate);

    extern unsigned int process_handle_offset;
    unsigned int process_handle = (process_handle_offset) + (unsigned int)(&intermediate);

    hthread_attr_t attr[3];
    int i;
    printf("Setting up thread attributes...\n");
    for (i = 0; i < 3; i++)
    {
        hthread_attr_init( &attr[i] );
        hthread_attr_sethardware( &attr[i], (void*)base_array[i] );
    }

    // Pre-lock mutex
    hthread_mutex_lock(&mutex);

    // Create threads
    printf("Creating threads...\r\n");
    hthread_create(&tid0, NULL, input_thread, (void*)&targ);

    // Allow input thread to pre-lock mutex
    hthread_yield();

#ifdef USE_MB_PROCESS_THREAD
    hthread_create(&tid1, &attr[1], (void *)process_handle, (void*)&targ);
#else
    hthread_create(&tid1, NULL, (void *)process_thread, (void*)&targ);
#endif

#ifdef USE_MB_OUTPUT_THREAD
    hthread_create(&tid2, &attr[2], (void *)output_handle, (void*)&targ);
#else
    hthread_create(&tid2, NULL, output_thread, (void*)&targ);
#endif

    // Release mutex, allowing all threads to process data
    hthread_mutex_unlock(&mutex);

/*
    while(1)
    {
        hthread_yield();
        usleep(10000);
    }
*/

    // Wait for threads to complete
    printf("Waiting for threads to complete...\r\n");
    printf("Joining thread %d\n",tid0);
    hthread_join(tid0, NULL);
    printf("Joining thread %d\n",tid1);
    hthread_join(tid1, NULL);
    printf("Joining thread %d\n",tid2);
    hthread_join(tid2, NULL);

	return XST_SUCCESS;
    
}
