#include <framebuffer.h>

int32 framebuffer_blur( framebuffer_t *dst, framebuffer_t *src, int32 a )
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
    color_t t;

    if( dst->width != src->width )      return EINVAL;
    if( dst->height != src->height )    return EINVAL;

    for( y = 0; y < src->height; y++ )
    {
        for( x = 0; x < src->width; x++ )
        {
            r = 0;  g = 0;  b = 0;
            for( j = -a; j <= a; j++ )
            {
                for( i = -a; i <= a; i++ )
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
                    r += color_red(t);
                    g += color_green(t);
                    b += color_blue(t);
                }
            }

            r /= (2*a+1)*(2*a+1);
            g /= (2*a+1)*(2*a+1);
            b /= (2*a+1)*(2*a+1);

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
