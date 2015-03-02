#include <framebuffer.h>

int32 framebuffer_linear( framebuffer_t *dst, framebuffer_t *src )
{
    int32   x;
    int32   y;
    double  xd;
    double  yd;
    color_t c;

    xd = (double)src->width / (double)dst->width;
    yd = (double)src->height / (double)dst->height;

    for( y = 0; y < dst->height; y++ )
    {
        for( x = 0; x < dst->width; x++ )
        {
            c = framebuffer_get( src, x*xd, y*yd );
            framebuffer_set( dst, x, y, c );
        }
    }

    return 0;
}
