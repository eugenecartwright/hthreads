#include "hthread.h"

#define BLOCK_SIZE  8

typedef struct targ
{
  int a_matrix[BLOCK_SIZE][BLOCK_SIZE];
  int b_matrix[BLOCK_SIZE][BLOCK_SIZE];
  int c_matrix[BLOCK_SIZE][BLOCK_SIZE];
}threadarg_t;


void matrix_mult(int a_matrix[][BLOCK_SIZE], int b_matrix[][BLOCK_SIZE], int output_matrix[][BLOCK_SIZE])
{ 
    int row, col, k;
    int accum;

    // Traverse each row and column of the matrix
    for (row = 0; row < BLOCK_SIZE; row++)
    {
        for (col = 0; col < BLOCK_SIZE; col++)
        {
            // Reset accumulator 
            accum = 0;

            for (k = 0; k < BLOCK_SIZE; k++)
            {
                // Multiply accumulate
                accum = accum + (int)(a_matrix[row][k]*b_matrix[k][col]);
            }

            // Fill in output matrix
            output_matrix[row][col] = accum;
        }
    }    
}

void * junkThread (void * arg)
{

  threadarg_t * targ = (threadarg_t *)arg;

  
  matrix_mult(targ->a_matrix, targ->b_matrix, targ->c_matrix);

  return 0;
}
