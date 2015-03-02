#include <framebuffer.h>

int32 framebuffer_thresh( framebuffer_t *dst, framebuffer_t *src, int32 val )
{
    int32   x;
    int32   y;
    uint8   r;
    uint8   g;
    uint8   b;
    color_t t;

    // Make sure the filter is called with valid images
    if( dst->width != src->width )      return EINVAL;
    if( dst->height != src->height )    return EINVAL;

    for( y = 0; y < src->height; y++ )
    {
        for( x = 0; x < src->width; x++ )
        {
            t = framebuffer_get( src, x, y );
            r = color_red(t);
            g = color_green(t);
            b = color_blue(t);

            if( r < val )   r = 0;
            else            r = 255;

            if( g < val )   g = 0;
            else            g = 255;

            if( b < val )   b = 0;
            else            b = 255;

            framebuffer_set( dst, x, y, color_make(r,g,b,255) );
        }
    }

    return 0;
}
