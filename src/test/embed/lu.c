/*

   LU Decomposition

   */

#include <stdio.h>
#include <hthread.h>
#include "time_lib.h"

// Use PPC/MB thread
#define USE_MB_THREAD

// The base addresses of the hardware thread we are creating
#define HWTI_BASEADDR0               (0xB0000000)
#define HWTI_BASEADDR1               (0xB0000100)
#define NUM_THREADS (2)
unsigned int base_array[NUM_THREADS] = {HWTI_BASEADDR0, HWTI_BASEADDR1};

// Thread argument type
typedef struct
{
    double * matrix;
    int width;
    int res;
} targ_t;

// Global matrix
#define MATRIX_WIDTH (3)
double local_data[MATRIX_WIDTH*MATRIX_WIDTH] = 
{
    10, 2, 0,
    3, 60, -1,
    1, 2, 100,
};

////////////////////////////////////////////////////////////////////////////////
//  int Crout_LU_Decomposition(double *A, int n)                              //
//                                                                            //
//  Description:                                                              //
//     This routine uses Crout's method to decompose the n x n matrix A       //
//     into a lower triangular matrix L and a unit upper triangular matrix U  //
//     such that A = LU.                                                      //
//     The matrices L and U replace the matrix A so that the original matrix  //
//     A is destroyed.                                                        //
//     Note!  In Crout's method the diagonal elements of U are 1 and are      //
//            not stored.                                                     //
//     Note!  The determinant of A is the product of the diagonal elements    //
//            of L.  (det A = det L * det U = det L).                         //
//     This routine is suitable for those classes of matrices which when      //
//     performing Gaussian elimination do not need to undergo partial         //
//     pivoting, e.g. positive definite symmetric matrices, diagonally        //
//     dominant band matrices, etc.                                           //
//     For the more general case in which partial pivoting is needed use      //
//                    Crout_LU_Decomposition_with_Pivoting.                   //
//     The LU decomposition is convenient when one needs to solve the linear  //
//     equation Ax = B for the vector x while the matrix A is fixed and the   //
//     vector B is varied.  The routine for solving the linear system Ax = B  //
//     after performing the LU decomposition for A is Crout_LU_Solve          //
//     (see below).                                                           //
//                                                                            //
//     The Crout method is given by evaluating, in order, the following       //
//     pair of expressions for k = 0, ... , n - 1:                            //
//       L[i][k] = (A[i][k] - (L[i][0]*U[0][k] + . + L[i][k-1]*U[k-1][k]))    //
//                                 for i = k, ... , n-1,                      //
//       U[k][j] = A[k][j] - (L[k][0]*U[0][j] + ... + L[k][k-1]*U[k-1][j])    //
//                                                                  / L[k][k] //
//                                      for j = k+1, ... , n-1.               //
//       The matrix U forms the upper triangular matrix, and the matrix L     //
//       forms the lower triangular matrix.                                   //
//                                                                            //
//  Arguments:                                                                //
//     double *A   Pointer to the first element of the matrix A[n][n].        //
//     int     n   The number of rows or columns of the matrix A.             //
//                                                                            //
//  Return Values:                                                            //
//     0  Success                                                             //
//    -1  Failure - The matrix A is singular.                                 //
//                                                                            //
//  Example:                                                                  //
//     #define N                                                              //
//     double A[N][N];                                                        //
//                                                                            //
//     (your code to intialize the matrix A)                                  //
//                                                                            //
//     err = Crout_LU_Decomposition(&A[0][0], N);                             //
//     if (err < 0) printf(" Matrix A is singular\n");                        //
//     else { printf(" The LU decomposition of A is \n");                     //
//           ...                                                              //
////////////////////////////////////////////////////////////////////////////////
//                                                                            //
int Crout_LU_Decomposition(double *A, int n)
{
   int i, j, k, p;
   double *p_k, *p_row, *p_col;

//         For each row and column, k = 0, ..., n-1,
//            find the lower triangular matrix elements for column k
//            and if the matrix is non-singular (nonzero diagonal element).
//            find the upper triangular matrix elements for row k. 
 
   for (k = 0, p_k = A; k < n; p_k += n, k++) {
      for (i = k, p_row = p_k; i < n; p_row += n, i++) {
         for (p = 0, p_col = A; p < k; p_col += n, p++)
            *(p_row + k) -= *(p_row + p) * *(p_col + k);
      }  
      if ( *(p_k + k) == 0.0 ) return -1;
      for (j = k+1; j < n; j++) {
         for (p = 0, p_col = A; p < k; p_col += n,  p++)
            *(p_k + j) -= *(p_k + p) * *(p_col + j);
         *(p_k + j) /= *(p_k + k);
      }
   }
   return 0;
}

void * LU_thread (void * arg)
{
    targ_t * targ = (targ_t *)arg;

    // Perform LU Decomp.
    int res = Crout_LU_Decomposition(targ->matrix, targ->width);
    targ->res = res;

    return (void*)res;
}

void print_matrix( double *mat, int width)
{
    int r, c;

    // Display results
    for (r = 0; r < width; r++)
    {
        for (c = 0; c < width; c++)
        {
            printf("%f  ",mat[r+c*width]);
        }
        printf("\n");
    }

}



int main()
{
    xps_timer_t timer;
    int time_create, time_start, time_stop;

// *************************************************************************************    
    extern unsigned char intermediate[];

    extern unsigned int lu_handle_offset;
    unsigned int lu_handle = (lu_handle_offset) + (unsigned int)(&intermediate);

// *************************************************************************************    

    // Thread attribute structures
    Huint           sta[NUM_THREADS];
    void*           retval[NUM_THREADS];
    hthread_t       tid[NUM_THREADS];
    hthread_attr_t  attr[NUM_THREADS];
    targ_t          targ[NUM_THREADS];


    // Create timer
    xps_timer_create(&timer, (int*)0x20400000);

    // Start timer
    xps_timer_start(&timer);


    int j = 0;
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

/*
    // Initialize input
    for (i = 0; i < MATRIX_WIDTH; i++)
    {
        for (j = 0; j < MATRIX_WIDTH; j++)
        {
            local_data[i+MATRIX_WIDTH*j] = i+j;
        }
    }
*/
    // Initialize thread arguments
    for (j = 0; j < NUM_THREADS; j++)
    {
        targ[j].matrix = &local_data[0];
        targ[j].width = MATRIX_WIDTH;
        targ[j].res = 0;
    }

    printf("\r\nOriginal Matrix:\r\n");
    print_matrix(local_data,MATRIX_WIDTH);


    printf("**************************************************\r\n");

    // Start timing thread create
    time_create = xps_timer_read_counter(&timer);

    // Peform LU
    //lu_thread(&targ);
    // Use a thread
#ifdef USE_MB_THREAD
    sta[0] = hthread_create( &tid[0], &attr[0], (void*)lu_handle, (void*)&targ[0] );
#else
    sta[0] = hthread_create( &tid[0], NULL, LU_thread, (void*)&targ[0]);
#endif

    // Allow created threads to begin running and start timer
    time_start = xps_timer_read_counter(&timer);

    // Wait for threads to complete
    hthread_join(tid[0],&retval[0]);

    // Stop timer
    time_stop = xps_timer_read_counter(&timer);

    printf("\r\nLU (retval = 0x%08x):\r\n",(unsigned int)retval[0]);

    printf("\r\nLU Decomposition:\r\n");
    print_matrix(local_data,MATRIX_WIDTH);

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

