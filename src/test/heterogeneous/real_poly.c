/* combined.c program
 * Author: Eugene
 * Date: 3/20/2016
 *
 * Description: Program that incorporates many diverse kernels.
 */

#include <stdio.h>
#include <stdlib.h>
#include <hthread.h>
#include <arch/htime.h>
#include <math.h>
//#define DEBUG_DISPATCH

void * queue_thread(void * arg);
//#define NUM_THREADS  NUM_AVAILABLE_HETERO_CPUS
#define  PI_NUM_THREADS          5
#define  MANDEL_NUM_THREADS      3
#define  HISTOGRAM_NUM_THREADS   5
#define  DISTANCE_NUM_THREADS    3
#define  MATRIX_NUM_THREADS      4
#define  FINDMAX_NUM_THREADS     5

#define NUM_THREADS  (PI_NUM_THREADS + MANDEL_NUM_THREADS + HISTOGRAM_NUM_THREADS + DISTANCE_NUM_THREADS + MATRIX_NUM_THREADS + FINDMAX_NUM_THREADS)

#define OPCODE_FLAGGING
#define CHECK_FIRST_POLYMORPHIC

// For Pi.c
#define  PI_MAX_ITERATIONS  500
typedef struct {
   float pi;
   Huint  MaxIterations;
} pi_t;

// For mandel.c
#define  MANDEL_MAX_ITERATIONS            100
#define  MANDEL_HORIZONTAL_RESOLUTION     50
#define  MANDEL_VERTICAL_RESOLUTION       50

// -----For histogram----- //
#define NUM_BINS     (8)
// Array size
#define ARR_SIZE    1024
// Used to initialize array
// with elements 0 - (MOD_VAL-1)
#define MOD_VAL    4
// Thread argument definition
typedef struct
{
   int * array;
   int max_value;
   int min_value;
   int * hist;
} histogram_t;

// Distance.c
#define DISTANCE_ARR_LENGTH      (5000)
// Thread argument definition
typedef struct
{
    float * x0s;
    float * y0s;
    float * x1s;
    float * y1s;
    float * distances;
    unsigned int length;
} distance_t;

// For Matrix Multiply
#define MATRIX_A_ROW    (24)
#define MATRIX_A_COL    (24)
#define MATRIX_B_ROW    (24)
#define MATRIX_B_COL    (24)
typedef struct
{
  int matrixA[MATRIX_A_ROW][MATRIX_A_COL];
  int matrixB[MATRIX_B_ROW][MATRIX_B_COL];
  int matrixC[MATRIX_A_ROW][MATRIX_B_COL];
} volatile matrix_t;

// Find Max between 2 numbers
#define FINDMAX_LENGTH  500
typedef struct 
{
   int A[FINDMAX_LENGTH];
   int B[FINDMAX_LENGTH];
   int result[FINDMAX_LENGTH];
   int length;
   unsigned int shift_amount;
} volatile max_t;

// TODO: While 32-bit floats can only hold up to 7 digits
// of accuracy, we can still simulate the work of performing
// more iterations to achieve a greater level of accuracy.
void * pi_thread(void * arg) {

   pi_t * thread_data = (pi_t *) arg;
   volatile Huint MaxIterations = thread_data->MaxIterations;
   volatile Huint n = 0;
   register float pi = 3.0f;
   register float i = 2.0f;
   for (n = 0; n < MaxIterations; n++) {
      if ((n % 2) == 0)
         pi += (4.0f / (i * (i+1.0f) * (i+2.0f)));
      else
         pi -= (4.0f / (i * (i+1.0f) * (i+2.0f)));
      i+=2.0f;
   }

   // Write results back
   thread_data->pi = pi;

   return (void *) SUCCESS;

}

void * mandel_thread(void * arg) {

   // NOTE: Alot of things compiler is optimizing out, just
   // put  volatile on everything.
   volatile Huint MaxIterations = (Huint) arg;
   volatile Huint ImageHeight = MANDEL_VERTICAL_RESOLUTION, ImageWidth = MANDEL_HORIZONTAL_RESOLUTION;
   volatile float MinRe = -2.0f;
   volatile float MaxRe = 1.0f;
   volatile float MinIm = -1.2f;
   volatile float MaxIm = MinIm + (MaxRe-MinRe)*ImageHeight/ImageWidth;
   volatile Huint count = 0;

   volatile float Re_factor = (MaxRe-MinRe)/((float)ImageWidth-1.0f);
   volatile float Im_factor = (MaxIm-MinIm)/((float)ImageHeight-1.0f);
	
   /* header for PPM output */
	//printf("P6\n# CREATOR: Eugene Cartwright\n");
	//printf("%d %d\n255\n",(int) ImageWidth,(int) ImageHeight);

   volatile Huint x, y;
   for (y = 0; y < ImageHeight; y++) {

      // Caculate imaginary part of complex number for this y
      volatile float c_im = MaxIm - y*Im_factor;

      for (x = 0; x < ImageWidth; x++) {

         // Caculate real part of complex number for this x
         volatile float c_re = MinRe + x*Re_factor;

         /* ------------------------------------------------
          * Determine whether complex number, c, belongs
          * to the Mandelbrot set, and colour appropriately.
          * -----------------------------------------------*/

         volatile float Z_re = c_re;
         volatile float Z_im = c_im;
         volatile Huint withinSet = 1; // Is it in the set?
         volatile Huint n = 0;
         for (n = 0; n < MaxIterations; n++) {
            count++;
            volatile float Z_re2 = Z_re*Z_re;
            volatile float Z_im2 = Z_im*Z_im;
            if ((Z_re2 + Z_im2) > 4.0f) {
               withinSet = 0;
               break;
            }
            // Calculate new Z
            // Z = Z^2 + c = (Z_re * Z_im)^2 + c
            Z_im = 2.0f*Z_re*Z_im + c_im;
            Z_re = Z_re2 - Z_im2 + c_re;
         }
         /* 
         if (withinSet)
            color(0,0,0, &px);
         else
            color(255,0,0, &px);
         */
      }
   }
   return (void *) count;
}

void * histogram_thread (void * arg) {

   // Create a pointer to thread argument
   volatile histogram_t * targ = (histogram_t *) arg;
   volatile int i = 0;
   volatile int bin = 0;
   volatile int val = 0;
   volatile int * data;
   volatile int * hist = targ->hist;
   //for (i = 0; i < NUM_BINS; i++)
   //   hist[i] = 0;

   data = targ->array;

   // Calculate histogram
   int diff = (targ->max_value - targ->min_value);
   int bin_width = diff / NUM_BINS;
   int divider = bin_width + (NUM_BINS - (diff % NUM_BINS));

   for (i = 0; i < ARR_SIZE; i++) {
      // Extract array value
      val = data[i]; // Load

      // Calculate bin number
      bin = val / divider;

      // Update histogram
      hist[bin]++; // Load and store
    }

   return (void*)(SUCCESS);
}

void * distance_thread (void * arg)
{

   distance_t * targ = (distance_t*)arg;

   // Calculate distances
   int i;
   float * x0s = targ->x0s;
   float * x1s = targ->x1s;
   float * y0s = targ->y0s;
   float * y1s = targ->y1s;
   float * ds  = targ->distances;
   int length = targ->length;
   register float t1, t2;
   for (i=0; i < length; i++)
   {
     t1 = (x0s[i] - x1s[i]);
     t1 = t1*t1;

     t2 = (y0s[i] - y1s[i]);
     t2 = t2*t2;

     ds[i] = sqrtf(t1 + t2); 
   }

    return (void*)(999);
}

void * matrix_mult_thread (void *arg)
{
  int myRow, colA, colB;

  matrix_t *targ = (matrix_t *) arg;
  for (myRow = 0; myRow < MATRIX_A_ROW; myRow++) {

	int fastRow[MATRIX_A_COL];
	int result;
	for (colA = 0; colA < MATRIX_A_COL; colA++) {
	  fastRow[colA] = targ->matrixA[myRow][colA];
	}

	for (colB = 0; colB < MATRIX_B_COL; colB++) {
	  result = 0;
	  for (colA = 0; colA < MATRIX_A_COL; colA++) {
		result += fastRow[colA] * targ->matrixB[colA][colB];
	  }
	  targ->matrixC[myRow][colB] = result;
	}
  }
  return (void *) 0;
}

void * find_max_thread (void *arg) 
{
   max_t *targ = (max_t *) arg;
   int length = targ->length;
   int i = 0;
   Huint shift_amount = targ->shift_amount;
   for (i = 0; i < length; i++ ){
      int a = targ->A[i];
      int b = targ->B[i];
      int diff = a-b;
      int mask = diff >> shift_amount;
      targ->result[i] = a - (diff & (mask));
   }

   return (void *) 0;
}

#ifndef HETERO_COMPILATION
#include "combined_prog.h"
#endif

void * queue_thread(void * arg) {

#ifndef HETERO_COMPILATION
   while(1) {
      if (thread_entries != 0) {
         // Try to schedule thread at front of queue
         Hint status = thread_create(head->tid, head->attr, head->func_id, head->arg,DYNAMIC_HW,0);
         
         // Still nothing available or you were successful?
         if (status == ENQUEUE_THREAD || status == SUCCESS) {
            thread_entries--;
            // Then you should have just appended that
            // thread to the back, so remove it from front
            thread_head_index = (thread_head_index + 1) % THREAD_QUEUE_MAX;
            head = &ThreadQueue[thread_head_index];
            if (thread_entries == THREAD_QUEUE_MAX) {
               printf("QUEUE IS FULL!!!!\n\n");
               while(1);
            }
         } else {
            // Something else went wrong
            printf("Something else went wrong\n\n");
            while(1);
         }
      }
      hthread_yield();
   }
#endif

   return (void *) 0;
}


#ifndef HETERO_COMPILATION
hthread_time_t exec_time[NUM_THREADS] PRIVATE_MEMORY;
hthread_t tid[NUM_THREADS] PRIVATE_MEMORY;
hthread_attr_t attr[NUM_THREADS] PRIVATE_MEMORY;
void * ret[NUM_THREADS] PRIVATE_MEMORY;

int main() {
   
   printf("--- Combined Kernel benchmark ---\n"); 
   printf("Number of Slave processors: %d\n", NUM_AVAILABLE_HETERO_CPUS);
#ifdef OPCODE_FLAGGING
   printf("-->Opcode flagging ENABLED\n");
#else
   printf("-->Opcode flagging DISABLED\n");
#endif
   // Initialize various host tables once.
   init_host_tables();
   
   // Create Queue software thread
   hthread_t queue_tid;
   hthread_attr_t queue_attr;
   hthread_attr_init(&queue_attr);
   if (thread_create(&queue_tid, &queue_attr,queue_thread_FUNC_ID,(void *) &exec_time[0], SOFTWARE_THREAD,0)){
      printf("Error creating Queue thread\n");
      while(1);
   }
   // Reset
   create_overhead = 0;

   Huint i = 0;
   // PI
   pi_t thread_data[PI_NUM_THREADS];
   for (i = 0; i < PI_NUM_THREADS; i++) {
      thread_data[i].pi = 0;
      thread_data[i].MaxIterations = PI_MAX_ITERATIONS;
   }

   // HISTOGRAM
   // Thread attribute structures
   histogram_t * thread_arg = (histogram_t *) malloc(sizeof(histogram_t) * HISTOGRAM_NUM_THREADS);
   assert (thread_arg != NULL);

   // Array Structures
   int my_array[HISTOGRAM_NUM_THREADS][ARR_SIZE];
   int my_hist[HISTOGRAM_NUM_THREADS][NUM_BINS];

   int num_ops = 0, j = 0;;

   // Initialize histograms
   for (j = 0; j < HISTOGRAM_NUM_THREADS; j++) {
      int i;
      for (i = 0; i < NUM_BINS; i++)
         my_hist[j][i] = 0;
      for (i = 0; i < ARR_SIZE; i++) 
         my_array[j][i] = i+num_ops % MOD_VAL;
   }

   // Initialize thread argument
   for (j = 0; j < HISTOGRAM_NUM_THREADS; j++) 
   {
      thread_arg[j].array = (int *)&my_array[j][0];
      thread_arg[j].hist = (int *)&my_hist[j][0];
      thread_arg[j].max_value = MOD_VAL - 1;
      thread_arg[j].min_value = 0;
   }

   // -------- DISTANCE --------------- //
    // Thread attribute structures
    distance_t distance_arg[DISTANCE_NUM_THREADS];

    float vals_x0[DISTANCE_ARR_LENGTH];
    float vals_x1[DISTANCE_ARR_LENGTH];

    float vals_y0[DISTANCE_ARR_LENGTH];
    float vals_y1[DISTANCE_ARR_LENGTH];

    float vals_ds[DISTANCE_ARR_LENGTH];
    for (j = 0; j < DISTANCE_ARR_LENGTH; j++)
    {
        vals_x0[j] = (float) DISTANCE_ARR_LENGTH - j;
        vals_y0[j] = (float) DISTANCE_ARR_LENGTH - j;

        vals_x1[j] = (float) j + 1;
        vals_y1[j] = (float) DISTANCE_ARR_LENGTH - j + 1;
    }

    // Initialize thread arguments
    int num_items = DISTANCE_ARR_LENGTH/DISTANCE_NUM_THREADS;
    int extra_items = DISTANCE_ARR_LENGTH - (num_items*DISTANCE_NUM_THREADS);
    for ( j= 0; j < DISTANCE_NUM_THREADS; j++)
    {
       distance_arg[j].x0s = &vals_x0[j*(num_items)];
       distance_arg[j].y0s = &vals_y0[j*(num_items)];
       distance_arg[j].x1s = &vals_x1[j*(num_items)];
       distance_arg[j].y1s = &vals_y1[j*(num_items)];
       distance_arg[j].distances = &vals_ds[j*(num_items)];
       distance_arg[j].length = num_items;
    }
    // Add in extra items for the last thread if needed
    distance_arg[j-1].length += extra_items;

    // Matrix Multiply
    matrix_t matrix_arg[MATRIX_NUM_THREADS];
    int n;
    for (n = 0; n < MATRIX_NUM_THREADS; n++) {
      for (i = 0; i < MATRIX_A_ROW; i++) {
	      for (j = 0; j < MATRIX_A_COL; j++) {
	         matrix_arg[n].matrixA[i][j] = i + j;
	         matrix_arg[n].matrixB[i][j] = i + j;
	         matrix_arg[n].matrixC[i][j] = 0;
	      }
      }
    }

    // -------- Find MAx-------------- //
    max_t findmax_arg[FINDMAX_NUM_THREADS];
    for (i = 0; i < FINDMAX_NUM_THREADS; i++) {
       findmax_arg[i].length = FINDMAX_LENGTH;
       findmax_arg[i].shift_amount = sizeof(findmax_arg[i].A[0]);
       for (j = 0; j < FINDMAX_LENGTH; j++) {
          findmax_arg[i].A[j] = (int) (rand() % FINDMAX_LENGTH);
          findmax_arg[i].B[j] = (int) (rand() % FINDMAX_LENGTH);
          findmax_arg[i].result[j] = 0;
       }
    }

   // Set all threads to detached   
   for(i = 0; i < NUM_THREADS; i++) {
		hthread_attr_init(&attr[i]);
		hthread_attr_setdetachstate(&attr[i], HTHREAD_CREATE_DETACHED);
	}

   hthread_time_t start = hthread_time_get();

   thread_create( &tid[0], &attr[0], pi_thread_FUNC_ID, (void *) &thread_data[3], DYNAMIC_HW, 0);
   thread_create( &tid[1], &attr[1], distance_thread_FUNC_ID, (void *) &distance_arg[2], DYNAMIC_HW, 0);
   thread_create( &tid[2], &attr[2], mandel_thread_FUNC_ID, (void *) MANDEL_MAX_ITERATIONS, DYNAMIC_HW, 0);
   thread_create( &tid[3], &attr[3], histogram_thread_FUNC_ID, (void*)(&thread_arg[1]),DYNAMIC_HW,0 );
   thread_create( &tid[4], &attr[4], find_max_thread_FUNC_ID, (void *) &findmax_arg[2], DYNAMIC_HW, 0);
   thread_create( &tid[5], &attr[5], find_max_thread_FUNC_ID, (void *) &findmax_arg[4], DYNAMIC_HW, 0);
   thread_create( &tid[6], &attr[6], mandel_thread_FUNC_ID, (void *) MANDEL_MAX_ITERATIONS, DYNAMIC_HW, 0);
   thread_create( &tid[7], &attr[7], find_max_thread_FUNC_ID, (void *) &findmax_arg[1], DYNAMIC_HW, 0);
   thread_create( &tid[8], &attr[8], histogram_thread_FUNC_ID, (void*)(&thread_arg[4]),DYNAMIC_HW,0 );
   thread_create( &tid[9], &attr[9], matrix_mult_thread_FUNC_ID, (void *) &matrix_arg[3], DYNAMIC_HW, 0);
   thread_create( &tid[10], &attr[10], pi_thread_FUNC_ID, (void *) &thread_data[0], DYNAMIC_HW, 0);
   thread_create( &tid[11], &attr[11], matrix_mult_thread_FUNC_ID, (void *) &matrix_arg[2], DYNAMIC_HW, 0);
   thread_create( &tid[12], &attr[12], matrix_mult_thread_FUNC_ID, (void *) &matrix_arg[0], DYNAMIC_HW, 0);
   thread_create( &tid[13], &attr[13], find_max_thread_FUNC_ID, (void *) &findmax_arg[0], DYNAMIC_HW, 0);
   thread_create( &tid[14], &attr[14], histogram_thread_FUNC_ID, (void*)(&thread_arg[0]),DYNAMIC_HW,0 );
   thread_create( &tid[15], &attr[15], pi_thread_FUNC_ID, (void *) &thread_data[2], DYNAMIC_HW, 0);
   thread_create( &tid[16], &attr[16], histogram_thread_FUNC_ID, (void*)(&thread_arg[2]),DYNAMIC_HW,0 );
   thread_create( &tid[17], &attr[17], distance_thread_FUNC_ID, (void *) &distance_arg[1], DYNAMIC_HW, 0);
   thread_create( &tid[18], &attr[18], matrix_mult_thread_FUNC_ID, (void *) &matrix_arg[1], DYNAMIC_HW, 0);
   thread_create( &tid[19], &attr[19], distance_thread_FUNC_ID, (void *) &distance_arg[0], DYNAMIC_HW, 0);
   thread_create( &tid[20], &attr[20], find_max_thread_FUNC_ID, (void *) &findmax_arg[3], DYNAMIC_HW, 0);
   thread_create( &tid[21], &attr[21], mandel_thread_FUNC_ID, (void *) MANDEL_MAX_ITERATIONS, DYNAMIC_HW, 0);
   thread_create(&tid[22], &attr[22], pi_thread_FUNC_ID, (void *) &thread_data[1], DYNAMIC_HW, 0);
   thread_create(&tid[23], &attr[23], pi_thread_FUNC_ID, (void *) &thread_data[4], DYNAMIC_HW, 0);
   thread_create( &tid[24], &attr[24], histogram_thread_FUNC_ID, (void*)(&thread_arg[1]),DYNAMIC_HW,0 );

#if 0   
   thread_create( &tid[5], &attr[5], histogram_thread_FUNC_ID, (void*)(&thread_arg[0]),DYNAMIC_HW,0 );
   thread_create( &tid[6], &attr[6], histogram_thread_FUNC_ID, (void*)(&thread_arg[1]),DYNAMIC_HW,0 );
   thread_create( &tid[7], &attr[7], histogram_thread_FUNC_ID, (void*)(&thread_arg[2]),DYNAMIC_HW,0 );
   thread_create( &tid[8], &attr[8], histogram_thread_FUNC_ID, (void*)(&thread_arg[3]),DYNAMIC_HW,0 );
   thread_create( &tid[9], &attr[9], histogram_thread_FUNC_ID, (void*)(&thread_arg[4]),DYNAMIC_HW,0 );
   thread_create( &tid[16], &attr[16], matrix_mult_thread_FUNC_ID, (void *) &matrix_arg[3], DYNAMIC_HW, 0);
   thread_create( &tid[13], &attr[13], matrix_mult_thread_FUNC_ID, (void *) &matrix_arg[0], DYNAMIC_HW, 0);
   thread_create(&tid[2], &attr[2], pi_thread_FUNC_ID, (void *) &thread_data[2], DYNAMIC_HW, 0);
   //thread_create(&tid[23], &attr[23], mandel_thread_FUNC_ID, (void *) MANDEL_MAX_ITERATIONS, DYNAMIC_HW, 0);
   thread_create( &tid[18], &attr[18], find_max_thread_FUNC_ID, (void *) &findmax_arg[1], DYNAMIC_HW, 0);
   thread_create( &tid[21], &attr[21], find_max_thread_FUNC_ID, (void *) &findmax_arg[4], DYNAMIC_HW, 0);
   thread_create( &tid[14], &attr[14], matrix_mult_thread_FUNC_ID, (void *) &matrix_arg[1], DYNAMIC_HW, 0);
   thread_create( &tid[11], &attr[12], distance_thread_FUNC_ID, (void *) &distance_arg[1], DYNAMIC_HW, 0);
   //thread_create(&tid[24], &attr[24], mandel_thread_FUNC_ID, (void *) MANDEL_MAX_ITERATIONS, DYNAMIC_HW, 0);
   thread_create(&tid[1], &attr[1], pi_thread_FUNC_ID, (void *) &thread_data[1], DYNAMIC_HW, 0);
   thread_create(&tid[4], &attr[4], pi_thread_FUNC_ID, (void *) &thread_data[4], DYNAMIC_HW, 0);
   thread_create( &tid[12], &attr[11], distance_thread_FUNC_ID, (void *) &distance_arg[2], DYNAMIC_HW, 0);
   thread_create( &tid[15], &attr[15], matrix_mult_thread_FUNC_ID, (void *) &matrix_arg[2], DYNAMIC_HW, 0);
   thread_create( &tid[17], &attr[17], find_max_thread_FUNC_ID, (void *) &findmax_arg[0], DYNAMIC_HW, 0);
   thread_create(&tid[3], &attr[3], pi_thread_FUNC_ID, (void *) &thread_data[3], DYNAMIC_HW, 0);
   thread_create(&tid[0], &attr[0], pi_thread_FUNC_ID, (void *) &thread_data[0], DYNAMIC_HW, 0);
   thread_create( &tid[10], &attr[10], distance_thread_FUNC_ID, (void *) &distance_arg[0], DYNAMIC_HW, 0);
   thread_create( &tid[20], &attr[20], find_max_thread_FUNC_ID, (void *) &findmax_arg[3], DYNAMIC_HW, 0);
   //thread_create(&tid[22], &attr[22], mandel_thread_FUNC_ID, (void *) MANDEL_MAX_ITERATIONS, DYNAMIC_HW, 0);
   thread_create( &tid[19], &attr[19], find_max_thread_FUNC_ID, (void *) &findmax_arg[2], DYNAMIC_HW, 0);
#endif
   // Wait until all threads are finished 
	while(get_num_free_slaves() < NUM_AVAILABLE_HETERO_CPUS || thread_entries != 0) {
      if (thread_entries != 0)
         hthread_yield();
   }
   
   hthread_time_t stop = hthread_time_get();

	printf("---------------------------\n");
	hthread_time_t diff;
	hthread_time_diff(diff, stop, start);
	printf("Total Execution Time: %.2f ms\n", hthread_time_msec(diff));
	printf("Total Execution Time: %.2f us\n", hthread_time_usec(diff));
    
#if 0
    // Grab the total number of calls statistic.
    printf("Total number of thread_create (DYNAMIC) calls: %d\n", total_calls);
    printf("---------------------------------------------------\n");
    printf("Perfect Ratio:  %03d / %03d = %0.2f\n", perfect_match_counter, total_calls, perfect_match_counter / (1.0f * total_calls));
    printf("Best Ratio:     %03d / %03d = %0.2f\n", best_match_counter, total_calls, best_match_counter / (1.0f * total_calls));
    printf("Better Ratio:   %03d / %03d = %0.2f\n", better_match_counter, total_calls, better_match_counter / (1.0f * total_calls));
    printf("Possible Ratio: %03d / %03d = %0.2f\n", possible_match_counter, total_calls, possible_match_counter / (1.0f * total_calls));

    perfect_match_counter = 0;
    best_match_counter = 0;
    better_match_counter = 0;
    possible_match_counter = 0;

    Huint hw_counter[NUM_AVAILABLE_HETERO_CPUS];
    Huint sw_counter[NUM_AVAILABLE_HETERO_CPUS];
    Huint pr_counter[NUM_AVAILABLE_HETERO_CPUS];
    Huint total_hw_count = 0;
    Huint total_sw_count = 0;
    Huint total_pr_count = 0;

    for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
        hw_counter[i] = _hwti_get_accelerator_hw_counter(hwti_array[i]);
        sw_counter[i] = _hwti_get_accelerator_sw_counter(hwti_array[i]);
        pr_counter[i] = _hwti_get_accelerator_pr_counter(hwti_array[i]);

        total_hw_count += hw_counter[i];
        total_sw_count += sw_counter[i];
        total_pr_count += pr_counter[i];

        // Manually Reset
        _hwti_set_accelerator_hw_counter(hwti_array[i], 0);
        _hwti_set_accelerator_sw_counter(hwti_array[i], 0);
        _hwti_set_accelerator_pr_counter(hwti_array[i], 0);
    }

    printf("Total HW Counter: %d\n", total_hw_count);
    printf("Total SW Counter: %d\n", total_sw_count);
    printf("Total PR Counter: %d\n", total_pr_count);
    printf("-----------------------\n");
    if (total_hw_count)     // if total_hw_count != 0
        printf("Total PR Counter / HW Counter = %f\n", total_pr_count / (1.0 *total_hw_count));
    printf("Total PR Counter / HW+SW Counter = %f\n", total_pr_count / (1.0 *(total_hw_count+total_sw_count)));
#endif
    printf("Total OS overhead (thread_create) = %f msec\n", hthread_time_msec(create_overhead));
#if 0
    hthread_time_t software_time = 0;
    for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
       volatile hthread_time_t * temp = (hthread_time_t *) (hwti_array[i] + 0x100);
       printf("%d: Software Execution = %f msec\n",i, hthread_time_msec(*temp));
       software_time += *temp;
    }
    printf("Total Software Execution = %f msec\n", hthread_time_msec(software_time));
#endif
   // Display thread times
   for (i = 0; i < NUM_THREADS; i++) { 
      // Determine which slave ran this thread based on address
      Huint base = attr[i].hardware_addr - HT_HWTI_COMMAND_OFFSET;
      Huint slave_num = (base & 0x00FF0000) >> 16;
      printf("Execution time (TID : %d, Slave : %d, HW ADDRESS = 0x%08x)\n", tid[i], slave_num, attr[i].hardware_addr);
   }
  

   printf("--- Done ---\n");

   return 0;
}
#endif

