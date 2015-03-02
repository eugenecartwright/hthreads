#include <framebuffer.h>

int32 framebuffer_pixelate( framebuffer_t *img, int32 xs, int32 ys )
{
    int32   x;
    int32   y;
    int32   xn;
    int32   yn;
    color_t c;

    for( y = 0; y < img->height; y += ys )
    {
        for( x = 0; x < img->width; x += xs )
        {
            c = framebuffer_get( img, x, y );
            for( yn = 0; yn < ys && y+yn < img->height;  yn++ )
            {
                for( xn = 0; xn < xs && x+xn < img->width; xn++ )
                {
                    framebuffer_set( img, x+xn, y+yn, c );
                }
            }
        }
    }

    return 0;
}
