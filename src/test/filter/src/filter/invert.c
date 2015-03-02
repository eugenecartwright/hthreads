#include <framebuffer.h>

#define labs(x)     ((x) < 0 ? -(x) : (x))
#define MAX_VALUE   255

int32 framebuffer_invert( framebuffer_t *dst, framebuffer_t *src )
{
    int32   x;
    int32   y;
    int32   r_inv;
    int32   g_inv;
    int32   b_inv;
    color_t t;

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

            // Write out inverted pixel
            framebuffer_set (dst, x, y, color_make(r_inv,g_inv,b_inv,255));
        }
    }

    return 0;
}
