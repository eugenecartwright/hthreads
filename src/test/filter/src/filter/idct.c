#include <framebuffer.h>
#include <math.h>
#include "idctutils.h"

#define labs(x)     ((x) < 0 ? -(x) : (x))
#define MAX_VALUE   255

int32 framebuffer_idct( framebuffer_t *dst, framebuffer_t *src )
{
    int32   x;
    int32   y;
    int32   r;
    int32   c;
    int32   pixelValue;
    int32   input_block[BLOCK_SIZE][BLOCK_SIZE];
    int32   intermediate_block[BLOCK_SIZE][BLOCK_SIZE]; 
    int32   output_block[BLOCK_SIZE][BLOCK_SIZE];
    color_t t;
    int32 scale_factor = 16;

    if( dst->width != src->width )      return EINVAL;
    if( dst->height != src->height )    return EINVAL;

    // Make sure that the cosine matrices are initialized
    if (!idct_initialized)
       initialize_idct_matrix();

    // Calculate the DCT of the image in blocks
    for( y = 0; y < src->height; y = y + BLOCK_SIZE )
    {
        for( x = 0; x < src->width; x = x + BLOCK_SIZE )
        {            


            // Form a  block of pixels
            for (r = 0; r < BLOCK_SIZE; r++)
            {
               for (c = 0; c < BLOCK_SIZE; c++)
               {
                    t = framebuffer_get( src, x+c, y+r );
                    pixelValue = color_green(t);
                    input_block[r][c] = pixelValue;
               }
            }

            // Perform IDCT on the block
            // Calculate:
            //  intermediate   = input_block * idct_matrix
            //  ouptut         = idct_matrix_trans * intermediate
            idct_matrix_mult( input_block, idct_matrix, intermediate_block );
            idct_matrix_scale( intermediate_block, scale_factor, input_block);
            idct_matrix_mult( idct_matrix_trans, input_block, output_block );
            idct_matrix_scale( output_block, scale_factor, intermediate_block);

            // Write the transformed block to the destination image
            for (r = 0; r < BLOCK_SIZE; r++)
            {
               for (c = 0; c < BLOCK_SIZE; c++)
               { 
                    pixelValue = intermediate_block[r][c];
                    framebuffer_set (dst, x+c, y+r, color_make(pixelValue,pixelValue,pixelValue,255));
               }
            } 


        }
    }

    return 0;
}
