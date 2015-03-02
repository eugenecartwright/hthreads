#include <framebuffer.h>

int32 framebuffer_rect( framebuffer_t *image, rect_t *rect, color_t col )
{
    int32 x;
    int32 y;
    int32 xs;
    int32 ys;
    int32 xe;
    int32 ye;

    xs = rect->x;
    ys = rect->y;
    xe = xs + rect->w;
    ye = ys + rect->h;

    if( xs < 0 )                    xs = 0;
    else if( xs > image->width )    return 0;

    if( ys < 0 )                    ys = 0;
    else if( ys > image->height )   return 0;

    if( xe < 0 )                    return 0;
    else if( xe > image->width )    xe = image->width;

    if( ye < 0 )                    return 0;
    else if( ye > image->height )   ye = image->height;

    for( y = ys; y < ye ; y++ )
    {
        for( x = xs; x < xe; x++ )
        {
            framebuffer_set(image,x,y,col);
        }
    }

    // Return successfully
    return 0;
}
