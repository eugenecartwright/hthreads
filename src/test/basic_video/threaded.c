
#include <stdio.h>
#include <xio.h>
#include "xbasic_types.h"
#include "xstatus.h"
#include "xparameters.h"
#include "xtft.h"
#include <xparameters.h>
#include "image_lib.h"
#include <hthread.h>

// Useful definitions
#define DDR_BASEADDR    XPAR_DDR2_SDRAM_MPMC_BASEADDR
#define DISPLAY_COLUMNS  640
#define DISPLAY_ROWS     480

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
    pixel_t * src_image;
    pixel_t * dst_image;
}targ_t;

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

#define labs(x)     ((x) < 0 ? -(x) : (x))
#define MAX_VALUE   256
#define NUM_BINS    256

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

    while(1)
    {
        hthread_mutex_lock(targ->output_mutex);

        // Do nothing
        printf("INPUT THREAD\n");

        hthread_mutex_unlock(targ->output_mutex);

        hthread_yield();
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
        if (count%2 == 0)
        {
            draw_picture((unsigned char *)targ->dst_image);
        }
        else
        {
            draw_picture((unsigned char *)targ->src_image);
        }
        hthread_mutex_unlock(targ->output_mutex);
        count++;
        hthread_yield();
    }

    return NULL;
}

void * process_thread (void * arg)
{
    targ_t * targ = (targ_t *)arg;

    framebuffer_t src;
    framebuffer_t dst;

    while(1)
    {
        hthread_mutex_lock(targ->output_mutex);

        printf("PROCESS THREAD\n");
        src.width = DISPLAY_COLUMNS;
        src.height = DISPLAY_ROWS;
        src.im_ptr = (pixel_t *)targ->src_image;
        
        dst.width = DISPLAY_COLUMNS;
        dst.height = DISPLAY_ROWS;
        dst.im_ptr = (pixel_t *)targ->dst_image;

        //laplace3(&dst,&src);
        framebuffer_histogram(&dst,&src);

        hthread_mutex_unlock(targ->output_mutex);
        hthread_yield();
    }

    return NULL;
}

/**************************** Type Definitions ******************************/

/***************** Macros (Inline Functions) Definitions ********************/

/************************** Function Prototypes *****************************/

static int XTft_DrawSolidBox(XTft *Tft, u32 Left, u32 Top, u32 Right, 
			u32 Bottom, u32 PixelVal);
int TftExample(u32 TftDeviceId);

/************************** Variable Definitions ****************************/

static XTft TftInstance;

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
	int Status;
	XTft_Config *TftConfigPtr;
    hthread_t tid0, tid1, tid2;
    targ_t targ;
    hthread_mutex_t mutex;

    // Get address of the XTft_Config structure for the given device id.	
    printf("Setting up TFT...\r\n");
	TftConfigPtr = XTft_LookupConfig(TftDeviceId);
	if (TftConfigPtr == (XTft_Config *)NULL) {
		return XST_FAILURE;
	}
	
	// Initialize all the TftInstance members and fills the screen with
	// default background color.
	Status = XTft_CfgInitialize(&TftInstance, TftConfigPtr,
				 	TftConfigPtr->BaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	
	

    // Initialize mutex
    printf("Setting up synchronization...\r\n");
    hthread_mutex_init(&mutex, NULL);

    // Setup thread arguments
    printf("Setting up thread arguments...\r\n");
    targ.output_mutex = &mutex;
    targ.src_image = (pixel_t *)&image_array_rgb[0];
    targ.dst_image = (pixel_t *)&temp_array_rgb[0];

    // Create threads
    printf("Creating threads...\r\n");
    hthread_create(&tid0, NULL, input_thread, (void*)&targ);
    hthread_create(&tid1, NULL, process_thread, (void*)&targ);
    hthread_create(&tid2, NULL, output_thread, (void*)&targ);

    // Wait for threads to complete
    printf("Waiting for threads to complete...\r\n");
    hthread_join(tid0, NULL);
    hthread_join(tid1, NULL);
    hthread_join(tid2, NULL);

	return XST_SUCCESS;
    
}

/*****************************************************************************/
/**
* Draws a solid box with the specified color between two points.
*
* @param	InstancePtr is a pointer to the XTft instance.
* @param	Left, Top, Right, Bottom are the edges of the box
* @param	PixelVal is the Color Value to be put at pixel.
*
* @return
*		- XST_SUCCESS if successful.
*		- XST_FAILURE if unsuccessful.
*
* @note		None.
*
******************************************************************************/
static int XTft_DrawSolidBox(XTft *InstancePtr, u32 Left, u32 Top, u32 Right, 
			u32 Bottom, u32 PixelVal)
{
   u32 xmin,xmax,ymin,ymax,i,j;

   if (Left >= 0 &&
		Left <= DISPLAY_COLUMNS-1 &&
		Right >= 0 &&
		Right <= DISPLAY_COLUMNS-1 &&
		Top >= 0 &&
		Top <= DISPLAY_ROWS-1 &&
		Bottom >= 0 &&
		Bottom <= DISPLAY_ROWS-1) {
		if (Right < Left) {
			xmin = Right;
			xmax = Left;
		}
		else {
			xmin = Left;
			xmax = Right;
		}
		if (Bottom < Top) {
			ymin = Bottom;
			ymax = Top;
		}
		else {
			ymin = Top;
			ymax = Bottom;
		}

		for (i=xmin; i<=xmax; i++) {
			for (j=ymin; j<=ymax; j++) {
				XTft_SetPixel(InstancePtr, i, j, PixelVal);
			}
		}
		return XST_SUCCESS;
	}
	return XST_FAILURE;
}
