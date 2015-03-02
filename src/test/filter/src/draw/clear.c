#include <framebuffer.h>

int32 framebuffer_clear( framebuffer_t *img )
{
    int32 x;
    int32 y;

    for( y = 0; y < img->height; y++ )
    {
        for( x = 0; x < img->width; x++ )
        {
            framebuffer_set( img, x, y, color_make(0,0,0,255) );
        }
    }

    return 0;
}
