#include <framebuffer.h>

int32 framebuffer_kernel(framebuffer_t *dst,framebuffer_t *src,kernel_t *kernel)
{
    int32   x;
    int32   y;
    int32   i;
    int32   j;
    int32   s;
    int32   xn;
    int32   yn;
    int32   r;
    int32   g;
    int32   b;
    color_t c;

    if( src->width != dst->width )      return EINVAL;
    if( src->height != dst->height )    return EINVAL;

    s = kernel->size/2;
    for( y = 0; y < src->height; y++ )
    {
        for( x = 0; x < src->width; x++ )
        {
            r = 0; g = 0; b = 0;
            for( j = -s; j <= s; j++ )
            {
                for( i = -s; i <= s; i++ )
                {
                    xn = x + i;
                    yn = y + j;

                    if( xn < 0 )                    xn = 0;
                    else if( xn >= src->width )     xn = src->width - 1;

                    if( yn < 0 )                    yn = 0;
                    else if( yn >= src->height )    yn = src->height - 1;

                    c  = framebuffer_get( src, xn, yn );
                    r += kernel_get(kernel,i+s,j+s) * color_red(c);
                    g += kernel_get(kernel,i+s,j+s) * color_green(c);
                    b += kernel_get(kernel,i+s,j+s) * color_blue(c);
                }
            }
            r /= kernel->div;
            g /= kernel->div;
            b /= kernel->div;

            if( r < 0 )         r = 0;
            else if( r > 255 )  r = 255;
            if( g < 0 )         g = 0;
            else if( g > 255 )  g = 255;
            if( b < 0 )         b = 0;
            else if( b > 255 )  b = 255;

            framebuffer_set( dst, x, y, color_make(r,g,b,255) );
        }
    }

    return 0;
}
