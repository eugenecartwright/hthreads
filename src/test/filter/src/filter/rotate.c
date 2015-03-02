#include <framebuffer.h>
#include <math.h>

/*
// Sine and cosine of angle of rotation
extern float sang;
extern float cang;
*/

extern int angle;

int32 framebuffer_rotate( framebuffer_t *dst, framebuffer_t *src )
{
    int32   x;
    int32   y;
    int32   src_x, dst_x, center_x;
    int32   src_y, dst_y, center_y;
    color_t t;
    float sang;
    float cang;

    // Check the images
    if( dst->width != src->width )      return EINVAL;
    if( dst->height != src->height )    return EINVAL;

    // Calculate center of the image (width and height divided by 2)
    center_x = (dst->width)  >> 1; 
    center_y = (dst->height) >> 1; 

    // Calculate sine and cosine of the angle of rotation
    sang = sin( M_PI/180.0 * angle );
    cang = cos( M_PI/180.0 * angle );

    // Go over each pixel of the image
    for( y = 0; y < dst->height; y++ )
    {
        for( x = 0; x < dst->width; x++ )
        {            
            // Calculate current pixel coordinates based off of the center of image
            dst_x = x - center_x; 
            dst_y = y - center_y;

            // Calculate source pixel coordinates associated with the current destination
            src_x = round(((float)dst_x*cang) - ((float)dst_y*sang)); 
            src_y = round(((float)dst_x*sang) + ((float)dst_y*cang));

            // Shift source coordinates back from center
            src_x = src_x + center_x;
            src_y = src_y + center_y;

            if( src_x >= 0 && src_x < src->width && src_y >= 0 && src_y < src->height )
            {
                // Get pixel from original image if in range
                t = framebuffer_get(src,src_x,src_y);
                framebuffer_set( dst, x, y, t );
            }
            else
            {
                // Set pixel to zero if out of range of original image
                framebuffer_set( dst, x, y, color_make(0,0,0,255) );
            }

        }
    }

    return 0;
}
