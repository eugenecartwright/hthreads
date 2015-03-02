#include <framebuffer.h>

#define labs(x)     ((x) < 0 ? -(x) : (x))
#define MAX_VALUE   256
#define NUM_BINS    256

int32 framebuffer_uv_mapping( framebuffer_t *dst, framebuffer_t *src )

{
    int32   x;
    int32   y;
    int32   r;
    int32   g;
    int32   b;
    int32   y_yuv;
    int32   u_yuv;
    int32   v_yuv;
    int32   image_center_x;
    int32   image_center_y;
    int32   image_scale_x;
    int32   image_scale_y;
    int32   new_x;
    int32   new_y;
    int32   x_colorband;
    color_t c;

    // Define Origin at center
    image_center_x = src->width/2;
    image_center_y = src->height/2;
    
    // Max value for U = +/-112, V = +/-157
    // Calculate scaling
    image_scale_x = src->width/(112.0);
    image_scale_y = src->height/(157.0);
    
    for( y = 0; y < src->height; y++ )
    {
        for( x = 0; x < src->width; x++ )
        {
            c = framebuffer_get( src, x, y );
            r = color_red(c);
            g = color_green(c);
            b = color_blue(c);
            if (y < 5) {
            	// 8 different "pure" RGB colors
            	x_colorband = x % 8;
            	switch (x_colorband) {
            		case 0: r=000; g=000; b=000; break;
            		case 1: r=000; g=000; b=255; break;
            		case 2: r=000; g=255; b=000; break;
            		case 3: r=000; g=255; b=255; break;
            		case 4: r=255; g=000; b=000; break;
            		case 5: r=255; g=000; b=255; break;
            		case 6: r=255; g=255; b=000; break;
            		case 7: r=255; g=255; b=255; break;
            	} //  end switch
            }

            // Convert to YUV
            y_yuv = ( 0.299 * r) + ( 0.587 * g) + ( 0.114 * b);
            u_yuv = (-0.147 * r) + (-0.289 * g) + ( 0.436 * b);
            v_yuv = ( 0.615 * r) + (-0.515 * g) + (-0.100 * b);
                        
            new_x = image_center_x + (u_yuv);//*image_scale_x);
            new_y = image_center_y - (v_yuv);//*image_scale_y);
            

            // Prevent Seg faults
            if (new_x >= src->width)  {new_x = src->width-1;}
            if (new_y >= src->height) {new_y = src->height-1;}
            if (new_x <= 0)  {new_x = 0;}
            if (new_y <= 0) {new_y = 0;}
            
            // Send to screen
			if ((x == image_center_x) || (y == image_center_y)) {
				// Draw axis
            	framebuffer_set( dst, x, y, color_make(100,100,100,255) );
			} else {
				// Draw color
            	//framebuffer_set( dst, new_x, new_y, color_make(r,g,b,255) );
            	framebuffer_set( dst, new_x, new_y, color_make(255,255,255,255) );
            }
        }
    }

    return 0;
}
