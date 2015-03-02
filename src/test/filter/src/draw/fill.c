#include <framebuffer.h>

int32 framebuffer_fill( framebuffer_t *img, color_t col )
{
    int32 x;
    int32 y;

    for( y = 0; y < img->height; y++ )
    {
        for( x = 0; x < img->width; x++ )
        {
            framebuffer_set( img, x, y, col );
        }
    }

    return 0;
}
