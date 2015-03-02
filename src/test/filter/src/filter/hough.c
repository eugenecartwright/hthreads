#include <framebuffer.h>
#include <math.h>

#define labs(x)     ((x) < 0 ? -(x) : (x))
#define Theta_length       180
#define luminance_thresh   32
#define intensity_weighted 0


int32 framebuffer_hough( framebuffer_t *dst, framebuffer_t *src, int32 hough_width)

{
    int32   x;
    int32   y;
    int32   r;
    int32   g;
    int32   b;
    int32   gray;
    int32   xn;
    int32   yn;
    int32   i, j, m; 
    // Temp image
    int32   temp_image1[dst->width][dst->height];
    int32   temp_image2[dst->width][dst->height];
    // Hough transform image
    
    // Create hough array
    int32   hough_array[hough_width][Theta_length];
    int32   p_length;
    int32   p;
    int32   theta_var;
    int32   max_accumulator;
    // Top line method
    int32   Hough_max, Hmax_t, Hmax_p;
    float   gradient_m, offset_b; 
    int32   vertical_line, vertical_offset_d;
    
    // Sin Cosine Lookup table
    float   cos_sin_t[Theta_length][2];
    
    color_t c;

    // Preprocesing
    // 1- Gray scale
    for( y = 0; y < src->height; y++ )
    {
        for( x = 0; x < src->width; x++ )
        {
            
            c = framebuffer_get( src, x, y );
            r = color_red(c);
            g = color_green(c);
            b = color_blue(c);
            gray = (r + g + b) / 3;
            temp_image1[x][y] = gray;
            temp_image2[x][y] = 0;
        }
    }
    // End Gray
    // 2- Laplace Gradient
    
    for( y = 0; y < src->height; y++ )
    {
        for( x = 0; x < src->width; x++ )
        {
            gray = 0;
            for( j = -1; j <= 1; j++ )
            {
                for( i = -1; i <= 1; i++ )
                {
                    xn = x + i;
                    yn = y + j;

                    if( xn < 0 )                  xn = 0;
                    else if( xn >= src->width )   xn = src->width-1;

                    if( yn < 0 )                  yn = 0;
                    else if( yn >= src->height )  yn = src->height-1;

                    if( i == 0 && j == 0 )        m = 8;
                    else                          m = -1;

                    r = temp_image1[xn][yn];
                    gray += m*r;
                }
            }

            if( gray < 0 )         gray = 0;
            else if( gray > 255 )  gray = 255;

            temp_image2[x][y] = gray; 
            // framebuffer_set( dst, x, y, color_make(gray,gray,gray,255) );      
        }
    }   
    // End laplace

    // Resulting Hough Graph is twice as long as hypothenuse, since it can be positive or negative.
    // p_length should then be 2*sqrt(Width**2 + Height**2)
    p_length = hough_width;
    p = 0;
    max_accumulator = src->height * src->width;
   
    // **** This should really be moved out of the filter into an include ***
    // Fill up sine-cosine table
    for (theta_var = 0; theta_var<Theta_length; theta_var++) {
        cos_sin_t[theta_var][0] = cos (2 * M_PI * theta_var / 360.0);
        cos_sin_t[theta_var][1] = sin (2 * M_PI * theta_var / 360.0);
        // Clear Hough array
        for (p = 0; p < p_length; p++) {
            hough_array[p][theta_var] = 0;
        }
    }
    
    

    for( y = 0; y < src->height; y++ )
    {
        for( x = 0; x < src->width; x++ )
        {
            // Get pixel
            //c = framebuffer_get( src, x, y );
            //r = color_red(c);
            //g = color_green(c);
            //b = color_blue(c);
            gray = temp_image2[x][y]; //(r + g + b) / 3;
            // Check for threshold
            if (gray > luminance_thresh) {
                // Fill up the Hough transform
                for(theta_var = 0; theta_var<Theta_length; theta_var++) {
                    // For each t, with a given (x,y), calculate p
                    p = (int)(p_length/2 + (x*cos_sin_t[theta_var][0]) + (y*cos_sin_t[theta_var][1]));
                    // printf("p   %d\n",p);
                    // Write to accumulator
                   
                    //h = framebuffer_get( hough, p, theta_var );
                    //acc_value = color_red(h);
                    //acc_value = acc_value + 1;
                    if (p > p_length) { 
                        p = p_length; 
                    } else if (p < 0) {
                        p = 0;
                    } 
                    hough_array[p][theta_var] = hough_array[p][theta_var] + 1 + (intensity_weighted*gray);
                    //framebuffer_set( hough, p, theta_var, color_make(acc_value,acc_value,acc_value,max_accumulator) );
                } // end for theta
            } // end if past threshold          
        } // end for x
    } // end for y
    
    // Now we find the top line by finding the local maxima of the Hough graph
    Hough_max = 0;
    Hmax_t    = 0;
    Hmax_p    = 0;
    
    for (theta_var = 0; theta_var<Theta_length; theta_var++) {
        for( p = 0; p < hough_width; p++ ) {
            // h = framebuffer_get( hough, p, theta_var );
            if (hough_array[p][theta_var] > Hough_max) {
                Hough_max = hough_array[p][theta_var];
                Hmax_t = theta_var;
                Hmax_p = p;
            } // end hough max
        } // end for p
    } // end for theta
 
    //printf("Hough_max       %d\n",Hough_max);
    //printf("Hmax_t          %d\n",Hmax_t);
    //printf("Hmax_p          %d\n",Hmax_p);
 
    // Plot this line in the image by solving for x and y
    // [Y] = -((cos t)/(sin t))[X] + p/(sin t))
    // [Y] = m[X-d] + b;
    vertical_line = 0;
    // Vertical lines are a problem
    if (cos_sin_t[Hmax_t][1] == 0.0) {
        gradient_m = 3000.0; // Non infinite gradient 
        offset_b   = 0;
        vertical_offset_d = (int)((Hmax_p+(p_length/2))%(dst->width));
        vertical_line = 1;
    } else {
        gradient_m = (-1)*(cos_sin_t[Hmax_t][0])/(cos_sin_t[Hmax_t][1]);
        offset_b   = (Hmax_p - (p_length/2)) / (cos_sin_t[Hmax_t][1]);
        vertical_offset_d = 0;   
        vertical_line = 0;     
    }
    
    //printf("gradient       %f\n",gradient_m);
    //printf("offset         %f\n",offset_b);
    //printf("vertical off   %d\n",vertical_offset_d);
    
    // Graph in picture
    if (vertical_line == 1) {
        for( y = 0; y < dst->height; y++ ) {
            framebuffer_set( dst, vertical_offset_d, y, color_make(255,0,0,255) );
        }
    } else {
        y = 0;
        // Graph for X
        for( x = 0; x < dst->width; x++ ) {
            y = (int)((gradient_m*x)+offset_b);
            if ((y>=0) && (y<(dst->height))) {
                framebuffer_set( dst, x, y, color_make(255,0,0,255) );
            }
            if ((y+1>=0) && (y+1<(dst->height))) {
                framebuffer_set( dst, x, y+1, color_make(255,0,0,255) );
            }
            if ((y-1>=0) && (y-1<(dst->height))) {
                framebuffer_set( dst, x, y-1, color_make(255,0,0,255) );
            }
        }
    }
    
    return 0;
}
