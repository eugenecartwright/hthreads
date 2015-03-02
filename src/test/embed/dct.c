/*

   Useful things for DCT


   */

#include <stdio.h>
#include <hthread.h>
#include "time_lib.h"

// Use PPC/MB thread
#define USE_MB_THREAD

// DCT/DCT Block Size
#define BLOCK_SIZE  8

// The base addresses of the hardware thread we are creating
#define HWTI_BASEADDR0               (0xB0000000)
#define HWTI_BASEADDR1               (0xB0000100)
#define NUM_THREADS (2)
unsigned int base_array[NUM_THREADS] = {HWTI_BASEADDR0, HWTI_BASEADDR1};

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
static void initialize_dct_matrix(int dct_matrix[][BLOCK_SIZE], int dct_matrix_trans[][BLOCK_SIZE])
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
}

void print_matrix( int mat[][BLOCK_SIZE])
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


typedef struct
{
    int scale_factor;
    int (* input)[BLOCK_SIZE];
    int (* intermediate)[BLOCK_SIZE];
    int (* output)[BLOCK_SIZE];
    int (* coeff_matrix)[BLOCK_SIZE];
    int (* coeff_matrix_trans)[BLOCK_SIZE];
} targ_t;

void perform_dct(int input_block[][BLOCK_SIZE], int intermediate_block[][BLOCK_SIZE], int output_block[][BLOCK_SIZE], int scale_factor, int dct_matrix[][BLOCK_SIZE], int dct_matrix_trans[][BLOCK_SIZE])
{
            // Perform DCT on the block
            // Calculate:
            //  intermediate   = input_block * dct_matrix_trans
            //  ouptut         = dct_matrix * intermediate
            dct_matrix_mult( input_block, dct_matrix_trans, intermediate_block );
            dct_matrix_scale(intermediate_block, scale_factor, intermediate_block);
            dct_matrix_mult(dct_matrix, intermediate_block, output_block );
            dct_matrix_scale(output_block, scale_factor, output_block);

}
void perform_idct(int input_block[][BLOCK_SIZE], int intermediate_block[][BLOCK_SIZE], int output_block[][BLOCK_SIZE], int scale_factor, int dct_matrix[][BLOCK_SIZE], int dct_matrix_trans[][BLOCK_SIZE])
{
            // Perform IDCT on the block
            // Calculate:
            //  intermediate   = input_block * dct_matrix
            //  ouptut         = dct_matrix_trans * intermediate
            dct_matrix_mult( input_block, dct_matrix, intermediate_block );
            dct_matrix_scale( intermediate_block, scale_factor, intermediate_block);
            dct_matrix_mult( dct_matrix_trans, intermediate_block, output_block );
            dct_matrix_scale( output_block, scale_factor, output_block);
}

void * idct_thread (void * arg)
{
    // Grab and cast argument
    targ_t * targ = (targ_t *)arg;

    perform_idct(targ->input, targ->intermediate, targ->output, targ->scale_factor, targ->coeff_matrix, targ->coeff_matrix_trans);

    return (void *)10;
}


void * dct_thread (void * arg)
{
    // Grab and cast argument
    targ_t * targ = (targ_t *)arg;

    perform_dct(targ->input, targ->intermediate, targ->output, targ->scale_factor, targ->coeff_matrix, targ->coeff_matrix_trans);

    return (void *)20;
}

int main()
{
    xps_timer_t timer;
    int time_create, time_start, time_stop;

// *************************************************************************************    
    extern unsigned char intermediate[];

    extern unsigned int dct_handle_offset;
    unsigned int dct_handle = (dct_handle_offset) + (unsigned int)(&intermediate);

    extern unsigned int idct_handle_offset;
    unsigned int idct_handle = (idct_handle_offset) + (unsigned int)(&intermediate);
// *************************************************************************************    

    // Thread attribute structures
    Huint           sta[NUM_THREADS];
    void*           retval[NUM_THREADS];
    hthread_t       tid[NUM_THREADS];
    hthread_attr_t  attr[NUM_THREADS];
    targ_t          targ[NUM_THREADS];

    int my_dct_matrix[BLOCK_SIZE][BLOCK_SIZE] = {
        {23170,    23170,    23170,    23170,    23170,    23170,    23170,  23170  }, 
        {32138,    27246,    18205,     6393,    -6393,   -18205,   -27246,  -32138 },
        {30274,    12540,   -12540,   -30274,   -30274,   -12540,    12540,  30274  },
        {27246,    -6393,   -32138,   -18205,    18205,    32138,     6393,  -27246 },
        {23170,   -23170,   -23170,    23170,    23170,   -23170,   -23170,  23170  },
        {18205,   -32138,     6393,    27246,   -27246,   -6393,     32138,  -18205 },
        {12540,   -30274,    30274,   -12540,   -12540,    30274,   -30274,  12540  },
        {6393 ,   -18205,    27246,   -32138,    32138,   -27246,    18205,  -6393  }
     };

    int my_dct_matrix_trans[BLOCK_SIZE][BLOCK_SIZE] = {
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0}
     };

    int my_temp[BLOCK_SIZE][BLOCK_SIZE];
    int my_input[BLOCK_SIZE][BLOCK_SIZE];
    int my_intermediate_dct[BLOCK_SIZE][BLOCK_SIZE];
    int my_intermediate_idct[BLOCK_SIZE][BLOCK_SIZE];
    int my_output[BLOCK_SIZE][BLOCK_SIZE];
    int my_idct_output[BLOCK_SIZE][BLOCK_SIZE];
    int my_scale_factor = 16;

    // Create timer
    xps_timer_create(&timer, (int*)0x20400000);

    // Start timer
    xps_timer_start(&timer);


    int i,j;
#ifdef USE_MB_THREAD
    printf("Using heterogeneous MB threads\r\n");
    printf("\tCode start address = 0x%08x\n", (unsigned int)&intermediate);
#else
    printf("Using native PPC threads\r\n");
#endif
    for (j = 0; j < NUM_THREADS; j++)
    {
        // Initialize the attributes for the threads
        hthread_attr_init( &attr[j] );
        hthread_attr_sethardware( &attr[j], (void*)base_array[j] );
    }


    // Calculate transpose of dct_matrix
    initialize_dct_matrix(my_dct_matrix, my_dct_matrix_trans);

    // Initialize input
    for (i = 0; i < BLOCK_SIZE; i++)
    {
        for (j = 0; j < BLOCK_SIZE; j++)
        {
            my_input[i][j] = i+j;
        }
    }
    // Fill in thread arguments for an initial DCT run
    targ[0].scale_factor = my_scale_factor;
    targ[0].input = my_input;
    targ[0].intermediate = my_intermediate_dct;
    targ[0].output = my_temp;
    targ[0].coeff_matrix = my_dct_matrix;
    targ[0].coeff_matrix_trans = my_dct_matrix_trans;
    dct_thread(&targ[0]);

    printf("\r\nOriginal Input:\r\n");
    print_matrix(my_input);

    printf("\r\nOriginal DCT:\r\n");
    print_matrix(my_temp);

    printf("**************************************************\r\n");

    // Fill in thread arguments
    targ[0].scale_factor = my_scale_factor;
    targ[0].input = my_input;
    targ[0].intermediate = my_intermediate_dct;
    targ[0].output = my_output;
    targ[0].coeff_matrix = my_dct_matrix;
    targ[0].coeff_matrix_trans = my_dct_matrix_trans;

    targ[1].scale_factor = my_scale_factor;
    targ[1].input = my_temp;
    targ[1].intermediate = my_intermediate_idct;
    targ[1].output = my_idct_output;
    targ[1].coeff_matrix = my_dct_matrix;
    targ[1].coeff_matrix_trans = my_dct_matrix_trans;

    // Start timing thread create
    time_create = xps_timer_read_counter(&timer);

    // Peform DCT
    //dct_thread(&targ);
    // Use a thread
#ifdef USE_MB_THREAD
    sta[0] = hthread_create( &tid[0], &attr[0], (void*)dct_handle, (void*)&targ[0] );
#else
    sta[0] = hthread_create( &tid[0], NULL, dct_thread, (void*)&targ[0]);
#endif

    // Peform IDCT
    //idct_thread(&targ);
    // Use a thread
#ifdef USE_MB_THREAD
    sta[1] = hthread_create( &tid[1], &attr[1], (void*)idct_handle, (void*)&targ[1] );
#else
    sta[1] = hthread_create( &tid[1], NULL, idct_thread, (void*)&targ[1]);
#endif
    // Allow created threads to begin running and start timer
    time_start = xps_timer_read_counter(&timer);

    // Wait for threads to complete
    hthread_join(tid[0],&retval[0]);
    hthread_join(tid[1],&retval[1]);

    // Stop timer
    time_stop = xps_timer_read_counter(&timer);

    printf("\r\nDCT (retval = 0x%08x):\r\n",(unsigned int)retval[0]);
    print_matrix(my_output);

    printf("\r\nIDCT (retval = 0x%08x):\r\n",(unsigned int)retval[1]);
    print_matrix(my_idct_output);

    printf("*********************************\n");
    printf("Create time  = %u\n",time_create);
    printf("Start time   = %u\n",time_start);
    printf("Stop time    = %u\n",time_stop);
    printf("*********************************\n");
    printf("Creation time (|Start - Create|) = %u\n",time_start - time_create);
    printf("Elapsed time  (|Stop - Start|)   = %u\n",time_stop - time_start);
    printf("Total time    (|Create - Stop|)  = %u\n",time_stop - time_create);

    return 0;
}

