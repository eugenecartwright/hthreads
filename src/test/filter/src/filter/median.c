#include <framebuffer.h>

#define labs(x)     ((x) < 0 ? -(x) : (x))

int mediancmp( const void *left, const void *right )
{
    uint8 l = *((uint8*)left);
    uint8 r = *((uint8*)right);
    return (l == r ? 0 : l < r ? -1 : 1);
}

int mediancmp2( const void *left, const void *right )
{
    color_t *l = (color_t*)left;
    color_t *r = (color_t*)right;
    return color_cmp( *l, *r );
}

int32 framebuffer_median( framebuffer_t *dst, framebuffer_t *src, int32 win )
{
    static int32 size   = 0;
    static int32 bounds = 0;
    static uint8 *windowr = NULL;
    static uint8 *windowg = NULL;
    static uint8 *windowb = NULL;

    int32   x;
    int32   y;
    int32   i;
    int32   j;
    int32   xn;
    int32   yn;
    int32   indx;
    color_t t;

    // Make sure the filter is called with valid images
    if( dst->width != src->width )      return EINVAL;
    if( dst->height != src->height )    return EINVAL;

    // Determine if we need to allocate memory for the window
    if( bounds != win/2 )
    {
        bounds = win / 2;
        size   = 2*bounds+1;
        size  *= size;
        if( windowr != NULL ) free( windowr );
        if( windowg != NULL ) free( windowg );
        if( windowb != NULL ) free( windowb );
        windowr = (uint8*)malloc( size*sizeof(uint8) );
        windowg = (uint8*)malloc( size*sizeof(uint8) );
        windowb = (uint8*)malloc( size*sizeof(uint8) );
    }

    for( y = 0; y < src->height; y++ )
    {
        for( x = 0; x < src->width; x++ )
        {
            indx = 0;
            for( j = -bounds; j <= bounds; j++ )
            {
                for( i = -bounds; i <= bounds; i++ )
                {
                    xn = fbrng( x+i, 0, src->width-1 );
                    yn = fbrng( y+j, 0, src->height-1 );

                    t = framebuffer_get( src, xn, yn );
                    windowr[indx] = color_red(t);
                    windowg[indx] = color_green(t);
                    windowb[indx] = color_blue(t);
                    indx++;
                }
            }

            qsort( windowr, size, sizeof(uint8), mediancmp );
            qsort( windowg, size, sizeof(uint8), mediancmp );
            qsort( windowb, size, sizeof(uint8), mediancmp );
            framebuffer_set( dst, x, y, color_make(windowr[size/2],windowg[size/2],windowb[size/2],255));
        }
    }

    return 0;
}

int32 framebuffer_median2( framebuffer_t *dst, framebuffer_t *src, int32 win )
{
    static int32 size   = 0;
    static int32 bounds = 0;
    static color_t *window = NULL;

    int32   x;
    int32   y;
    int32   i;
    int32   j;
    int32   xn;
    int32   yn;
    int32   indx;
    color_t t;

    // Make sure the filter is called with valid images
    if( dst->width != src->width )      return EINVAL;
    if( dst->height != src->height )    return EINVAL;

    // Determine if we need to allocate memory for the window
    if( bounds != win/2 || window == NULL )
    {
        bounds = win / 2;
        size   = 2*bounds+1;
        size  *= size;
        if( window != NULL ) free( window );
        window = (color_t*)malloc( size*sizeof(color_t) );
    }

    for( y = 0; y < src->height; y++ )
    {
        for( x = 0; x < src->width; x++ )
        {
            indx = 0;
            for( j = -bounds; j <= bounds; j++ )
            {
                for( i = -bounds; i <= bounds; i++ )
                {
                    xn = fbrng( x+i, 0, src->width-1 );
                    yn = fbrng( y+j, 0, src->height-1 );

                    t = framebuffer_get( src, xn, yn );
                    window[indx++] = t;
                }
            }

            qsort( window, size, sizeof(color_t), mediancmp );
            framebuffer_set( dst, x, y, window[size/2] );
        }
    }

    return 0;
}
