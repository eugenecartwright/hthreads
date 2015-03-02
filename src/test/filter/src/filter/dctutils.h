/*

   Useful things for DCT


   */

// DCT/DCT Block Size
#define BLOCK_SIZE  8

// Initialization flag
static int dct_initialized = 0;

// Cosine Matrix - DCT Coefficient Matrix (8x8)
static int dct_matrix[BLOCK_SIZE][BLOCK_SIZE] = {
        {23170,    23170,    23170,    23170,    23170,    23170,    23170,  23170  }, 
        {32138,    27246,    18205,     6393,    -6393,   -18205,   -27246,  -32138 },
        {30274,    12540,   -12540,   -30274,   -30274,   -12540,    12540,  30274  },
        {27246,    -6393,   -32138,   -18205,    18205,    32138,     6393,  -27246 },
        {23170,   -23170,   -23170,    23170,    23170,   -23170,   -23170,  23170  },
        {18205,   -32138,     6393,    27246,   -27246,   -6393,     32138,  -18205 },
        {12540,   -30274,    30274,   -12540,   -12540,    30274,   -30274,  12540  },
        {6393 ,   -18205,    27246,   -32138,    32138,   -27246,    18205,  -6393  }
     };

static int dct_matrix_trans[BLOCK_SIZE][BLOCK_SIZE] = {
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0}
     };

// Function used to perform matrix multiplication of blocks
// output_matrix = a*b
static void dct_matrix_mult(int a_matrix[][BLOCK_SIZE], int b_matrix[][BLOCK_SIZE], int output_matrix[][BLOCK_SIZE])
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

// Function used to scale down the values in a matrix
static void dct_matrix_scale(int a_matrix[][BLOCK_SIZE], int scale_factor, int output_matrix[][BLOCK_SIZE])
{ 
    int row, col;

    // Traverse each row and column of the matrix
    for (row = 0; row < BLOCK_SIZE; row++)
    {
        for (col = 0; col < BLOCK_SIZE; col++)
        {
            // Fill in output matrix
            output_matrix[row][col] = a_matrix[row][col] >> scale_factor;
        }
    }    
}

// Initialization function used to initialize the transposed cosine matrix
static void initialize_dct_matrix()
{
    int i, j;

    // Transpose matrix
    for (i = 0; i < BLOCK_SIZE; i++)
    {
        for (j = 0; j < BLOCK_SIZE; j++)
        {
            dct_matrix_trans[i][j] = dct_matrix[j][i];
        }
    }

    // Set flag
    dct_initialized = 1;
}

void dct_print_matrix( int mat[][BLOCK_SIZE])
{
    int r, c;

    // Display results
    for (r = 0; r < BLOCK_SIZE; r++)
    {
        for (c = 0; c < BLOCK_SIZE; c++)
        {
            printf("%d  ",mat[r][c]);
        }
        printf("\n");
    }

}

