/*** Matrix Multiplication
   * Author: Eugene Cartwright
   * Rewritten from an earlier 
   * application to allow bigger
   * multiplication,support for
   * distributed memory, and
   * support for variable
   * sized matrices.
   * Date: 02/2012
   */
#include <hthread.h>
#include <arch/htime.h>
#include <stdio.h>

//#define DEBUG_DISPATCH
//#define TIME_DMA
//#define VERIFY
#define NUM_TRIALS      (1)
#define NUM_THREADS     (2)
#define LOCAL_TIMER     (0x82000000)

// define size of your matrix
// w.r.t. A*B format
#define A_ROW_SIZE      256
#define A_COL_SIZE      A_ROW_SIZE
#define B_ROW_SIZE      A_ROW_SIZE
#define B_COL_SIZE      A_ROW_SIZE
#define MAX_SIZE        1024

typedef struct {
    int row[MAX_SIZE];
    int col[MAX_SIZE];
    int array_length;
    int dest_row;
    int dest_col;
    int solution;
    hthread_time_t time;
    //unsigned int time;
} data;

#ifndef HETERO_COMPILATION
// Function for printing out a matrix
void show_matrix (int **matrix, int row_size, int col_size) {
  int i, j;
  printf ("\n");
  for (i = 0; i < row_size; i++) {
	for (j = 0; j < col_size; j++) {
	  printf ("%4d ", matrix[i][j]);
	}
	printf ("\n");
  }
}

// Function for creating 2D matrices
int **make_matrix (int rows, int cols) {
  int **ptr;
  ptr = malloc (sizeof (int *) * rows);
  if (ptr == NULL) {
	printf ("ROW MALLOC error!\n");
	while (1);
  }
  int i = 0;
  for (i = 0; i < rows; i++) {
	ptr[i] = malloc (sizeof (int) * cols);
	if (ptr[i] == NULL) {
	  printf ("ROW MALLOC error!\n");
	  while (1);
	}
  }
  return ptr;
}

hthread_attr_t create_attr() {

  hthread_attr_t attr;
  hthread_attr_init (&attr);
  //For portability reasons when changing to pthreads
  hthread_attr_setdetachstate (&attr, HTHREAD_CREATE_JOINABLE);

  return attr;
}
#endif
void * worker_thread (void *arg) {
    data *targ = (data *) arg;
    // Read timer
    hthread_time_t start = hthread_time_get();
    
    // Calculate solution
    int  i = 0, size = targ->array_length, result = 0;
    for (i = 0; i < size; i++) 
        result += (targ->row[i] * targ->col[i]);
    targ->solution = result;
   
    // Read timer
    hthread_time_t stop = hthread_time_get();
    targ->time = stop - start;

    // Return NULL to indicate to firmware
    // not to copy via ptr. back to DDR memory 
    return NULL;
}

#ifndef HETERO_COMPILATION

#include "matrix_multiply_prog.h"

int main () {
    
    int i, j;
    hthread_t threads[NUM_THREADS];
    hthread_attr_t attr[NUM_THREADS];
    for (i = 0; i < NUM_THREADS; i++) {
        attr[i] = create_attr();
    }
    
    // Create timer variables
    hthread_time_t start, stop,running_total,running_calc_total,average_calc_total;
    hthread_time_t thread_create_start, thread_create_end, running_create_total = 0.0;

    //----------- initialize main matrices---------------
    int **matrixA = make_matrix (A_ROW_SIZE, A_COL_SIZE);
    int **matrixB = make_matrix (A_ROW_SIZE, B_COL_SIZE);
    int **matrixC = make_matrix (A_ROW_SIZE, B_COL_SIZE);
    for (i = 0; i < A_ROW_SIZE; i++) {
        for (j = 0; j <A_COL_SIZE; j++) {
            matrixA[i][j] = i + j;
        }
    }    
    for (i = 0; i < B_ROW_SIZE; i++) {
        for (j = 0; j <B_COL_SIZE; j++) {
            matrixB[i][j] = i + j;
        }
    }
    //---------------------- Done----------------------

    // Reserve space for thread package but ONLY
    // NUM_THREADS at a time
    data * package = (data *) malloc(sizeof(data) * NUM_THREADS);
    if (package == NULL) {
        printf("MALLOC ERROR: Unable to malloc thread package\n");
        while(1);
    }
    printf("*******************************************************\n");
    printf("  Multiplying A (%d x %d) x B (%d x %d)\n", A_ROW_SIZE, A_COL_SIZE, B_ROW_SIZE,B_COL_SIZE);
    printf("*******************************************************\n");

    int counter = 0, trials = 0, dest_row = 0, dest_col = 0;
    int running_create_counter, running_calc_counter;
    //for (counter = NUM_THREADS; counter > 0; counter-=2) {
    for (counter = NUM_THREADS; counter > 0; counter/=2) {
	    printf ("Number of threads %d\n", counter);
        for (trials = 0; trials < NUM_TRIALS; trials++) {
            
            // Clear the C matrix
            for (i = 0; i < A_ROW_SIZE; i++) {
                for (j = 0; j <B_COL_SIZE; j++) {
                    matrixC[i][j] = 0;
                }
            }
            // Reset running totals
            running_calc_total = 0.0;
            running_create_total = 0.0;
            running_create_counter = 0;
            running_calc_counter = 0;

            // Begin Timing
            start = hthread_time_get();
            
            // for every element in the result matrix
            int new_counter = counter;
            int A_ROW_SIZE_factor = 0;
            A_ROW_SIZE_factor = ((A_ROW_SIZE % counter != 0) ? 1 : 0);

            // A_ROW_SIZE_factor = (# of Rows / # of threads) + (1 if not a multiple of # of threads, else 0)
            A_ROW_SIZE_factor = ((A_ROW_SIZE / counter)+A_ROW_SIZE_factor);

            // This is the Outer loop for computing entire matrix.
            // dest_row is used as an offset into the matrix as we (try to)
            // create x number of threads through each pass of this for loop
            for (dest_row = 0; dest_row < A_ROW_SIZE_factor; dest_row++) {

                // if # of threads >= # of Rows or last iteration
                // Note: if statement below is simplified
                if (dest_row == (A_ROW_SIZE_factor-1)) {
                    // Then we create x threads, where x = # of Rows (remaining)
                    new_counter = (A_ROW_SIZE - (dest_row*counter));
                    // Now create x thread packages, instructing them what
                    // row they will work on
                    for ( i = 0; i < new_counter; i++) 
                        package[i].dest_row = (dest_row*counter) + i;
                }
                // if # of Rows > # of threads
                else {
                    // Then we create x threads at a time, where x = # of threads
                    new_counter = counter;
                    // Also, create x thread packages giving them row they will work on
                    for ( i = 0; i < new_counter; i++) 
                        package[i].dest_row = (dest_row*counter) + i;
                }
               
                // For each row a thread works on, we need to calculate the # of passes
                // it must make to compute the solution for a single cell. That is, each
                // thread can only hold at most MAX_SIZE'd elements for the row it is given.
                // If the original matrix is 2*MAX_SIZE, then that thread must receive from
                // host 0->MAX_SIZE-1 elements of the row, and then MAX_SIZE->(2*MAX_SIZE)-1 to
                // compute the first cell. To reduce the number of times we transfer these elements,
                // a thread computes each cell using only 0->MAX_SIZE-1 elements, then it would make a
                // second pass using MAX_SIZE->2*MAX_SIZE-1 elements. Default values for passes and 
                // array_size are set in order not to introduce more if statements.
                int passes = 1, array_size = A_COL_SIZE;
                
                // If we can fit all columns (matrix A) or all rows (matrix B) in one MAX_SIZE'd element array or
                // if # of Columns (A) or if # of Rows (B) is > MAX_SIZE
                passes = ((A_COL_SIZE % MAX_SIZE != 0) ? ((A_COL_SIZE / MAX_SIZE) + 1) : (A_COL_SIZE / MAX_SIZE));

                // The do-while loop is in charge of looping over the # of passes needed to be done
                int offset_counter = 0;
                do {
                    // Need to calculate array size for each pass
                    array_size = ( (A_COL_SIZE - (offset_counter*MAX_SIZE)) >= MAX_SIZE) ? 
                        MAX_SIZE : ( A_COL_SIZE - (offset_counter*MAX_SIZE));
                    //printf("Array Size for pass %d = %d\n", offset_counter, array_size);
                    
                    // "For each column of this row"/"for each cell in this row"
                    for (dest_col = 0; dest_col < A_COL_SIZE; dest_col++) {
                        // Copy the contents from original matrices to thread's package 
                        for (i = 0; i < new_counter; i++) {
                            package[i].dest_col = dest_col;
                            package[i].array_length = array_size;
                            //printf("Computing (%d, %d)\n", package[i].dest_row, package[i].dest_col);
                            // Now grab the row and the col from A & B matrix.
                            for( j = 0; j < array_size; j++) {
                                package[i].row[j] = matrixA[package[i].dest_row][(offset_counter*MAX_SIZE) + j];
                                package[i].col[j] = matrixB[j+(offset_counter*MAX_SIZE)][dest_col];
                            }
                        }
                        // -------------------------------THREAD CREATE--------------------------------------//
                        thread_create_start = hthread_time_get();         
                        for (i = 0; i < new_counter; i++) {
                            // if not the first time you are DMAing on this pass, only the column matrix has changed
                            if ( dest_col > 0 ) {
#ifdef  SPLIT_BRAM
                                microblaze_create_DMA( &threads[i], 
                                                        &attr[i], 
                                                        worker_thread_FUNC_ID, 
                                                        (void *) (&package[i].col), // The new column
                                                        array_size*sizeof(int),     // The # of elements
                                                        MAX_SIZE*sizeof(int),       // The offset into the original thread package
                                                        i);                         // the thread #
#else
                                microblaze_create( &threads[i], 
                                                        &attr[i], 
                                                        worker_thread_FUNC_ID, 
                                                        (void *) (&package[i]),     // The new column
                                                        i);                         // the thread #
#endif
                            }
                            // if this is the first time you are DMA'ing the row, or dest_col has passed MAX_SIZE * i, DMA everything    
                            // if this is a new pass, or the first time DMA'ing
                            else {
#ifdef  SPLIT_BRAM
                                microblaze_create_DMA( &threads[i], 
                                                        &attr[i], 
                                                        worker_thread_FUNC_ID,
                                                        (void *) &package[i],       // new column and row
                                                        sizeof(data),               // entire data package
                                                        0,                          // offset = 0 (beginning of free space)
                                                        i);
#else 
                                microblaze_create( &threads[i], 
                                                        &attr[i], 
                                                        worker_thread_FUNC_ID,
                                                        (void *) &package[i],       // new column and row
                                                        i); 
#endif
                            }
                            //microblaze_create(&threads[i], &attr, (void *) worker_thread_FUNC_ID,(void *) &package[i],i);
                            //hthread_create(&threads[i], &attr, (void *) worker_thread,(void *) &package[i]; 
                        }
                        
                        // temporary storage for average calc time
                        hthread_time_t calc_time = 0.0; 

                        // Join on those threads grabbing only the solution
                        for (i = 0; i < new_counter; i++) {
#ifdef  SPLIT_BRAM
                            hthread_join_DMA(threads[i],
                                    NULL,
                                    &package[i].solution,   // Place the 2 integers starting at solution
                                    sizeof(int)*3,          // size = 3 integers
                                    sizeof(data) - 12);      // offset = grab the last 12 bytes (1 int, 1 long long)
#else
                            hthread_join(threads[i], NULL);
#endif
                            // Update solution
                            matrixC[package[i].dest_row][package[i].dest_col] += package[i].solution;

                            // Grab times from all threads - clock cycles
                            calc_time += (hthread_time_t) package[i].time;
                            //printf("package[%d].solution = %d\n", i, package[i].solution);
                        }
                        thread_create_end = hthread_time_get();

                        // Update running total for average calculate time
                        average_calc_total = calc_time / (new_counter * 1.0); 
                        running_calc_total += average_calc_total;

                        // Update running total for thread creation overhead
                        running_create_total += ( ((thread_create_end - thread_create_start) / (new_counter * 1.0)) - average_calc_total);
                        running_create_counter++;
                        // ----------------------------------------------------------------------------------//
                    } // for dest_col
                    offset_counter++;
                }while (offset_counter < passes);
            } // for dest_row
            stop = hthread_time_get(); 
            running_total += stop - start;
        } // trials loop end

#ifdef  VERIFY
        // Verify the solution
        printf("Verifying solution.....");
        for (i = 0; i < A_ROW_SIZE; i++) {
            for (j = 0; j < B_COL_SIZE; j++) {
                int temp = 0;
                for (k = 0; k < A_COL_SIZE; k++) {
                    temp += (matrixA[i][k] * matrixB[k][j] );
                }
                if (matrixC[i][j] != temp) {
                    printf("ERROR: incorrect solution for C[%d][%d]\n", i,j);
                    while(1);
                }
            }
        }
        printf("Passed\n");
#endif
        running_total /= (NUM_TRIALS * 1.0);
        printf("Total Average Time         = %.6f seconds\n", hthread_time_sec(running_total));
        printf("Total Calculation Time     = %.6f msec\t%.6f sec\n", hthread_time_msec(running_calc_total), hthread_time_sec(running_calc_total));
        printf("Average Calculation Time   = %.6f msec\n", hthread_time_msec(running_calc_total/(running_create_counter * 1.0)));
        printf("Average Creation/Join Time = %.6f msec\n", hthread_time_msec(running_create_total/(running_create_counter * 1.0)));
        running_total = 0;
        //if (counter == 2) counter++;
    } // NUM_THREADS loop
    // Print Matrices
    //show_matrix(matrixA, A_ROW_SIZE, A_COL_SIZE);
    //show_matrix(matrixB, B_ROW_SIZE, B_COL_SIZE);
    //show_matrix(matrixC, A_ROW_SIZE, B_COL_SIZE);
    
    free(matrixA);
    free(matrixB);
    free(matrixC);
    printf("END\n");
    return 0;
}
#endif
