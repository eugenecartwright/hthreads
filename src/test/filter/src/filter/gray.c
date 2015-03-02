#include <framebuffer.h>

int32 framebuffer_gray( framebuffer_t *img )
{
    int32   x;
    int32   y;
    int32   r;
    int32   g;
    int32   b;
    color_t c;

    for( y = 0; y < img->height; y++ )
    {
        for( x = 0; x < img->width; x++ )
        {
            c = framebuffer_get( img, x, y );
            r = color_red(c);
            g = color_green(c);
            b = color_blue(c);
            g = (r + g + b) / 3;

            framebuffer_set( img, x, y, color_make(g,g,g,255) );
        }
    }

    return 0;
}
