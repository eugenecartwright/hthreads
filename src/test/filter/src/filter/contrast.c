#include <framebuffer.h>

#define labs(x)     ((x) < 0 ? -(x) : (x))

int32 framebuffer_contrast( framebuffer_t *dst, framebuffer_t *src )
{
    int32   x;
    int32   y;
    uint8   min[3];
    uint8   max[3];
    uint8   rng[3];
    float   rt;
    float   gt;
    float   bt;
    uint8   r;
    uint8   g;
    uint8   b;
    color_t t;

    // Make sure the filter is called with valid images
    if( dst->width != src->width )      return EINVAL;
    if( dst->height != src->height )    return EINVAL;

    // Initialize the minimum and maximum values
    min[0] = min[1] = min[2] = 255;
    max[0] = max[1] = max[2] = 0;

    // Find the minimum and maximum values for each color channel
    for( y = 0; y < src->height; y++ )
    {
        for( x = 0; x < src->width; x++ )
        {
            t = framebuffer_get( src, x, y );

            // Determine the minimum and maximum red value
            min[0] = fbmin( min[0], color_red(t) );
            max[0] = fbmax( max[0], color_red(t) );

            // Determine the minimum and maximum green value
            min[1] = fbmin( min[1], color_green(t) );
            max[1] = fbmax( max[1], color_green(t) );

            // Determine the minimum and maximum blue value
            min[2] = fbmin( min[2], color_blue(t) );
            max[2] = fbmax( max[2], color_blue(t) );
        }
    }

    // Determine the dynamic ranges
    rng[0] = max[0] - min[0];
    rng[1] = max[1] - min[1];
    rng[2] = max[2] - min[2];

    // Determine which dynamic range to use
    if( rng[0] > rng[1] )
    {
        if( rng[0] > rng[2] )   { rng[0] = rng[0]; min[0] = min[0]; }
        else                    { rng[0] = rng[2]; min[0] = min[2]; }
    }
    else
    {
        if( rng[1] > rng[2] )   { rng[0] = rng[1]; min[0] = min[1]; }
        else                    { rng[0] = rng[2]; min[0] = min[2]; }
    }

    // Determine if we should perform the contrast stretching
    if( rng[0] < 10 )   { framebuffer_copy(dst,src); return 0; }

    // Dynamically stretch the contrast
    for( y = 0; y < src->height; y++ )
    {
        for( x = 0; x < src->width; x++ )
        {
            t = framebuffer_get( src, x, y );

            // Calculate the new red color
            rt = ((float)color_red(t) - min[0]) * (255.0f/rng[0]);
            gt = ((float)color_green(t) - min[0]) * (255.0f/rng[0]);
            bt = ((float)color_blue(t) - min[0]) * (255.0f/rng[0]);
            rt = fbrng( rt, 0.0, 255.0 );
            gt = fbrng( gt, 0.0, 255.0 );
            bt = fbrng( bt, 0.0, 255.0 );


            r = (uint8)rt;
            g = (uint8)gt;
            b = (uint8)bt;
            /*
            r -= min[0];
            r *= 255;
            r /= rng[0];
            r = fbrng(r,0,255);

            // Calculate the new green color
            g = color_green(t);
            g -= min[0];
            g *= 255;
            g /= rng[0];
            g = fbrng(g,0,255);

            // Calculate the new blue color
            b = color_blue(t);
            b -= min[0];
            b *= 255;
            b /= rng[0];
            b = fbrng(b,0,255);
            */

            // Place the new color into the output image
            framebuffer_set( dst, x, y, color_make(r,g,b,255) );
        }
    }

    return 0;
}
