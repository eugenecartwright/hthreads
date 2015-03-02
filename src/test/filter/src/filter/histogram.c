#include <framebuffer.h>

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
    color_t t;

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
