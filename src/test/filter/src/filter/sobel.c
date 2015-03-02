#include <framebuffer.h>

#define lower(x,y)      (((x)<(y)) ? (y) : (x))
#define higher(x,y)     (((x)>(y)) ? ((y)-1) : (x))
    
#define MAX (2*255*255)
int sqrtdone = 0;
int sqrttable[MAX];

void lookupinit()
{
    int i;
    for( i = 0; i < MAX; i++ ) sqrttable[i] = (int)sqrt(i);
    sqrtdone = 1;
}

int sqrtlookup( int val )
{
    return sqrttable[val];
}

int32 framebuffer_sobel( framebuffer_t *dst, framebuffer_t *src )
{
    int32   x;
    int32   y;
    int32   r_index;
    int32   g_index;
    int32   b_index;
    int32   rh;
    int32   gh;
    int32   bh;
    int32   rv;
    int32   gv;
    int32   bv;
    color_t ch;
    color_t cv;

    if( !sqrtdone ) lookupinit();
    if( dst->width != src->width )      return EINVAL;
    if( dst->height != src->height )    return EINVAL;

    for( y = 0; y < src->height; y++ )
    {
        for( x = 0; x < src->width; x++ )
        {
            rh = gh = bh = 0;
            rv = gv = bv = 0;

            // Perform horizontal line detection
            ch = framebuffer_get( src, lower(x-1,0), lower(y-1,0) );
            rh -= color_red(ch);
            gh -= color_green(ch);
            bh -= color_blue(ch);

            ch = framebuffer_get( src, x, lower(y-1,0) );
            rh -= 2*color_red(ch);
            gh -= 2*color_green(ch);
            bh -= 2*color_blue(ch);

            ch = framebuffer_get( src, higher(x+1,dst->width), lower(y-1,0) );
            rh -= color_red(ch);
            gh -= color_green(ch);
            bh -= color_blue(ch);

            ch = framebuffer_get( src, lower(x-1,0), higher(y+1,dst->height) );
            rh += color_red(ch);
            gh += color_green(ch);
            bh += color_blue(ch);

            ch = framebuffer_get( src, x, higher(y+1,dst->height) );
            rh += 2*color_red(ch);
            gh += 2*color_green(ch);
            bh += 2*color_blue(ch);

            ch = framebuffer_get(src,higher(x+1,dst->width),higher(y+1,dst->height));
            rh += color_red(ch);
            gh += color_green(ch);
            bh += color_blue(ch);

            // Perform vertical line detection
            cv = framebuffer_get( src, lower(x-1,0), lower(y-1,0) );
            rv -= color_red(cv);
            gv -= color_green(cv);
            bv -= color_blue(cv);

            cv = framebuffer_get( src, lower(x-1,0), y );
            rv -= 2*color_red(cv);
            gv -= 2*color_green(cv);
            bv -= 2*color_blue(cv);

            cv = framebuffer_get( src, lower(x-1,0), higher(y+1,dst->height) );
            rv -= color_red(cv);
            gv -= color_green(cv);
            bv -= color_blue(cv);

            cv = framebuffer_get( src, higher(x+1,dst->width), lower(y-1,0) );
            rv += color_red(cv);
            gv += color_green(cv);
            bv += color_blue(cv);

            cv = framebuffer_get( src, higher(x+1,dst->width), y );
            rv += 2*color_red(cv);
            gv += 2*color_green(cv);
            bv += 2*color_blue(cv);

            cv = framebuffer_get(src,higher(x+1,dst->width),higher(y+1,dst->height));
            rv += color_red(cv);
            gv += color_green(cv);
            bv += color_blue(cv);

            // Calculate square root arguments
            r_index = rh*rh + rv*rv;
            g_index = gh*gh + gv*gv;
            b_index = bh*bh + bv*bv;

            if( r_index < 0 )         r_index = 0;
            else if( r_index > MAX )  r_index = MAX;

            if( g_index < 0 )         g_index = 0;
            else if( g_index > MAX )  g_index = MAX;

            if( b_index < 0 )         b_index = 0;
            else if( b_index > MAX )  b_index = MAX;

            // Combine the horizontal and vertical line detections
            //rh = sqrt( rh*rh + rv*rv );
            //gh = sqrt( gh*gh + gv*gv );
            //bh = sqrt( bh*bh + bv*bv );
            rh = sqrtlookup( r_index );
            gh = sqrtlookup( g_index );
            bh = sqrtlookup( b_index );

            // Bound the resulting values
            if( rh < 0 )         rh = 0;
            else if( rh > 255 )  rh = 255;

            if( gh < 0 )         gh = 0;
            else if( gh > 255 )  gh = 255;

            if( bh < 0 )         bh = 0;
            else if( bh > 255 )  bh = 255;

            // Set the new image color
            framebuffer_set( dst, x, y, color_make(rh,gh,bh,255) );
        }
    }

    return 0;
}
