#include <framebuffer.h>

#define labs(x)     ((x) < 0 ? -(x) : (x))
#define MAX_VALUE   255

//#define low_line    20
//#define high_line   40

extern int high_line;
extern int low_line;

int32 framebuffer_intensity_waveform( framebuffer_t *dst, framebuffer_t *src )
{
    int32   lum;
    int32   off;
    int32   x;
    int32   y;
    int32   xn;
    int32   yn;
    int32   r;
    int32   g;
    int32   b;
    int32   max_y, max_x;
    color_t t;

    if( dst->width != src->width )      return EINVAL;
    if( dst->height != src->height )    return EINVAL;

    // Set max_x and max_y
    max_x = src->width;
    max_y = src->height;

    // Bound low_line and high_line
    if (low_line < 0)               low_line = 0;
    else if (low_line >= src->height)    low_line = src->height - 1;

    if (high_line < 0)              high_line = 0;
    else if (high_line >= src->width)    high_line = src->width - 1;

    // Build intensity waveform
    //for( y = 0; y < src->height; y++ )
    for( y = low_line; y < high_line; y++ )
    {
        for( x = 0; x < src->width; x++ )
        {            
            // Draw boundary lines across the section of interest
            if ((y == low_line) || (y == high_line - 1))
                framebuffer_set (dst, x, y, color_make(255,255,255,255));

            // Grab a pixel
            t = framebuffer_get( src, x, y);
            r = color_red(t);
            g = color_green(t);
            b = color_blue(t);

            // Calculate luminance (Y-value)
            //  * Since all values are gray-scale, just use the r-value
            lum = r;

            // Calculate proper offset value
            off = (max_y * lum)/MAX_VALUE;

            // Calculate new point positions
            xn = x;
            yn = max_y - off - 1;

            if (yn < 0)
               yn = 0;

            // Write out destination pixel
            framebuffer_set (dst, xn, yn, color_make(255,255,255,255));
        }
    }

    return 0;
}
