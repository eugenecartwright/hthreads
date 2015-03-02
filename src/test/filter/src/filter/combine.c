#include <framebuffer.h>

int32 framebuffer_add( framebuffer_t *dst, framebuffer_t *src1, framebuffer_t *src2 )
{
    int32   x;
    int32   y;
    color_t c[2];

    if( dst->width != src1->width )     return EINVAL;
    if( dst->height != src1->height )   return EINVAL;

    if( src2->width != src1->width )    return EINVAL;
    if( src2->height != src1->height )  return EINVAL;

    for( y = 0; y < dst->height; y++ )
    {
        for( x = 0; x < dst->width; x++ )
        {
            c[0] = framebuffer_get( src1, x, y );
            c[1] = framebuffer_get( src2, x, y );

            framebuffer_set( dst, x, y, color_add(c[0],c[1]) );
        }
    }

    return 0;
}

int32 framebuffer_sub( framebuffer_t *dst, framebuffer_t *src1, framebuffer_t *src2 )
{
    int32   x;
    int32   y;
    color_t c[2];

    if( dst->width != src1->width )     return EINVAL;
    if( dst->height != src1->height )   return EINVAL;

    if( src2->width != src1->width )    return EINVAL;
    if( src2->height != src1->height )  return EINVAL;

    for( y = 0; y < dst->height; y++ )
    {
        for( x = 0; x < dst->width; x++ )
        {
            c[0] = framebuffer_get( src1, x, y );
            c[1] = framebuffer_get( src2, x, y );

            framebuffer_set( dst, x, y, color_sub(c[0],c[1]) );
        }
    }

    return 0;
}

int32 framebuffer_mul( framebuffer_t *dst, framebuffer_t *src1, framebuffer_t *src2 )
{
    int32   x;
    int32   y;
    color_t c[2];

    if( dst->width != src1->width )     return EINVAL;
    if( dst->height != src1->height )   return EINVAL;

    if( src2->width != src1->width )    return EINVAL;
    if( src2->height != src1->height )  return EINVAL;

    for( y = 0; y < dst->height; y++ )
    {
        for( x = 0; x < dst->width; x++ )
        {
            c[0] = framebuffer_get( src1, x, y );
            c[1] = framebuffer_get( src2, x, y );

            framebuffer_set( dst, x, y, color_mul(c[0],c[1]) );
        }
    }

    return 0;
}

int32 framebuffer_div( framebuffer_t *dst, framebuffer_t *src1, framebuffer_t *src2 )
{
    int32   x;
    int32   y;
    color_t c[2];

    if( dst->width != src1->width )     return EINVAL;
    if( dst->height != src1->height )   return EINVAL;

    if( src2->width != src1->width )    return EINVAL;
    if( src2->height != src1->height )  return EINVAL;

    for( y = 0; y < dst->height; y++ )
    {
        for( x = 0; x < dst->width; x++ )
        {
            c[0] = framebuffer_get( src1, x, y );
            c[1] = framebuffer_get( src2, x, y );

            framebuffer_set( dst, x, y, color_div(c[0],c[1]) );
        }
    }

    return 0;
}

int32 framebuffer_blend( framebuffer_t *dst, framebuffer_t *src1, framebuffer_t *src2 )
{
    int32   x;
    int32   y;
    color_t c[2];

    if( dst->width != src1->width )     return EINVAL;
    if( dst->height != src1->height )   return EINVAL;

    if( src2->width != src1->width )    return EINVAL;
    if( src2->height != src1->height )  return EINVAL;

    for( y = 0; y < dst->height; y++ )
    {
        for( x = 0; x < dst->width; x++ )
        {
            c[0] = framebuffer_get( src1, x, y );
            c[1] = framebuffer_get( src2, x, y );

            framebuffer_set( dst, x, y, color_blend(c[0],c[1]) );
        }
    }

    return 0;
}
