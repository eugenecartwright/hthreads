/************************************************************************************
* Copyright (c) 2015, University of Arkansas - Hybridthreads Group
* All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
* 
*     * Redistributions of source code must retain the above copyright notice,
*       this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright notice,
*       this list of conditions and the following disclaimer in the documentation
*       and/or other materials provided with the distribution.
*     * Neither the name of the University of Arkansas nor the name of the
*       Hybridthreads Group nor the names of its contributors may be used to
*       endorse or promote products derived from this software without specific
*       prior written permission.
* 
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
* ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
************************************************************************************/

/** \file      dct.c 
  * \brief     DCT application
  *
  * \author    Unknown
  */

#include <stdio.h>
#include <hthread.h>
#include <arch/htime.h>

void * idct_thread (void * arg);
void * dct_thread (void * arg);

#ifndef HETERO_COMPILATION
#include "dct_prog.h"
#endif

// Use PPC/MB thread
#define USE_MB_THREAD

// DCT/DCT Block Size
#define BLOCK_SIZE  8

#define NUM_THREADS (NUM_AVAILABLE_HETERO_CPUS)

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
#ifndef HETERO_COMPILATION
void print_matrix( int mat[][BLOCK_SIZE])
{
    int r, c;

    // Display results
    for (r = 0; r < BLOCK_SIZE; r++)
    {
        for (c = 0; c < BLOCK_SIZE; c++)
        {
            printf("%3d  ",mat[r][c]);
        }
        printf("\n");
    }
}
#endif

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

#ifndef HETERO_COMPILATION
int main()
{
    hthread_time_t time_create, time_start, time_stop, diff;

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


    int i,j;
    for (j = 0; j < NUM_THREADS; j++)
    {
        // Initialize the attributes for the threads
        hthread_attr_init( &attr[j] );
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
    time_create = hthread_time_get();

    // Peform DCT
    sta[0] =  thread_create(&tid[0], &attr[0], dct_thread_FUNC_ID, (void *) &targ[0], STATIC_HW0, 0);

    // Peform IDCT
    sta[1] =  thread_create(&tid[1], &attr[1], idct_thread_FUNC_ID, (void *) &targ[1], STATIC_HW1, 0);
    
    // Allow created threads to begin running and start timer
    time_start = hthread_time_get();

    // Wait for threads to complete
    hthread_join(tid[0],&retval[0]);
    hthread_join(tid[1],&retval[1]);

    // Stop timer
    time_stop = hthread_time_get();

    printf("\r\nDCT (retval = 0x%08x):\r\n",(unsigned int)retval[0]);
    print_matrix(my_output);

    printf("\r\nIDCT (retval = 0x%08x):\r\n",(unsigned int)retval[1]);
    print_matrix(my_idct_output);

    printf("*********************************\n");
    printf("Create time  = %llu\n",time_create);
    printf("Start time   = %llu\n",time_start);
    printf("Stop time    = %llu\n",time_stop);
    printf("*********************************\n");
    hthread_time_diff(diff,time_start, time_create);
    printf("Creation time (|Start - Create|) usec = %f\n",hthread_time_usec(diff));
    hthread_time_diff(diff,time_stop, time_start);
    printf("Elapsed time  (|Stop  - Start|)  usec = %f\n",hthread_time_usec(diff));
    hthread_time_diff(diff,time_stop, time_create);
    printf("Total time    (|Create - Stop|)  usec = %f\n",hthread_time_usec(diff));
   
    hthread_time_t * slave_time = (hthread_time_t *) (attr[0].hardware_addr - HT_CMD_HWTI_COMMAND + HT_CMD_VHWTI_EXEC_TIME);
    printf("Time reported by slave nano kernel #0 = %f usec\n", hthread_time_usec(*slave_time));
    slave_time = (hthread_time_t *) (attr[1].hardware_addr - HT_CMD_HWTI_COMMAND + HT_CMD_VHWTI_EXEC_TIME);
    printf("Time reported by slave nano kernel #1 = %f usec\n", hthread_time_usec(*slave_time));
    return 0;
}
#endif
