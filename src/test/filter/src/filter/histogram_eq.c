#include <framebuffer.h>

#define labs(x)     ((x) < 0 ? -(x) : (x))

#define MAX_VALUE   256
#define NUM_BINS    256

#define START_LINE  0 //(src->height/4)
#define END_LINE    src->height //(3*(src->height/4))   

int32 framebuffer_histogram_eq( framebuffer_t *dst, framebuffer_t *src )
{
    static int32   max = 1;
    int32   hist[NUM_BINS];
    int32   lum;
    int32   bin;
    int32   x;
    int32   y;
    int32   i;
    int32   r;
    int32   g;
    int32   b;
    int32   pixelsUsed;
    color_t t;

    if( dst->width != src->width )      return EINVAL;
    if( dst->height != src->height )    return EINVAL;

    // Initialize histogram
    for (i = 0; i < NUM_BINS; i++ )
    {
        hist[i] = 0;
    }

    pixelsUsed = (src->width)*(END_LINE - START_LINE + 1);

    // Build histogram
    //for( y = 0; y < src->height; y++ )
    for( y = START_LINE; y < END_LINE; y++ )
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

    // Create cumulative histogram
    for (i = 1; i < NUM_BINS; i++)
    {
        hist[i] = hist[i] + hist[i - 1];
    }

    // Create EQ'ed image
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

            // Calculate EQ'ed value
            lum = hist[lum] * (MAX_VALUE - 1)/(pixelsUsed);

            // Write out EQ'ed pixel value
            framebuffer_set (dst, x, y, color_make(lum,lum,lum,255));
        }
    }        

    return 0;
}
