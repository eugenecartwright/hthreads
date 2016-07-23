/* File: regression_accelerator_test.c
 * Author: Eugene Cartwright 
 * Description: This program simply runs through
 * variable data sizes for each accelerator function:
 * Creates NUM_AVAILABLE_HETERO_CPUS threads either
 * dynamically or statically, and checks the result
 * for each thread against a host calculated result. */

#include <hthread.h>
#include <stdio.h>
#include <accelerator.h>
#include <arch/htime.h>
#include <math.h>
#include "tuning_table.h"

void * queue_thread(void * arg);
//#define NUM_THREADS  NUM_AVAILABLE_HETERO_CPUS
#define  PI_NUM_THREADS          5
#define  MANDEL_NUM_THREADS      3
#define  HISTOGRAM_NUM_THREADS   5
#define  DISTANCE_NUM_THREADS    3
#define  MATRIX_NUM_THREADS      4
#define  FINDMAX_NUM_THREADS     5

#define NUM_THREADS  (PI_NUM_THREADS + MANDEL_NUM_THREADS + HISTOGRAM_NUM_THREADS + DISTANCE_NUM_THREADS + MATRIX_NUM_THREADS + FINDMAX_NUM_THREADS + 32)

//#define DEBUG_DISPATCH
#define OPCODE_FLAGGING
#define CHECK_FIRST_POLYMORPHIC
//#define FORCE_POLYMORPHIC_HW
//#define FORCE_POLYMORPHIC_SW

//#define BASE_CASE


//void * worker_crc1_thread( void * arg);
//void * worker_sort1_thread( void * arg);
//void * worker_vector1_thread( void * arg);

// Primitives
void * worker_crc_thread( void * arg);
void * worker_sort_thread( void * arg);
void * worker_vectoradd_thread( void * arg);
void * worker_vectorsub_thread( void * arg);
void * worker_vectormul_thread( void * arg);

void * worker_sort_crc_thread( void * arg);
void * worker_sort_vectoradd_thread( void * arg);
void * worker_sort_vectorsub_thread( void * arg);
void * worker_sort_vectormul_thread( void * arg);
void * worker_crc_sort_thread( void * arg);
void * worker_crc_vectoradd_thread( void * arg);
void * worker_crc_vectorsub_thread( void * arg);
void * worker_crc_vectormul_thread( void * arg);
void * worker_vectoradd_sort_thread( void * arg);
void * worker_vectorsub_sort_thread( void * arg);
void * worker_vectormul_sort_thread( void * arg);
void * worker_vectoradd_crc_thread( void * arg);
void * worker_vectorsub_crc_thread( void * arg);
void * worker_vectormul_crc_thread( void * arg);
void * worker_vectoradd_crc_sort_thread( void * arg);
void * worker_vectorsub_crc_sort_thread( void * arg);
void * worker_vectormul_crc_sort_thread( void * arg);
void * worker_vectoradd_sort_crc_thread( void * arg);
void * worker_vectorsub_sort_crc_thread( void * arg);
void * worker_vectormul_sort_crc_thread( void * arg);
void * worker_crc_vectoradd_sort_thread( void * arg);
void * worker_crc_vectorsub_sort_thread( void * arg);
void * worker_crc_vectormul_sort_thread( void * arg);
void * worker_crc_sort_vectoradd_thread( void * arg);
void * worker_crc_sort_vectorsub_thread( void * arg);
void * worker_crc_sort_vectormul_thread( void * arg);
void * worker_sort_crc_vectoradd_thread( void * arg);
void * worker_sort_crc_vectorsub_thread( void * arg);
void * worker_sort_crc_vectormul_thread( void * arg);
void * worker_sort_vectoradd_crc_thread( void * arg);
void * worker_sort_vectorsub_crc_thread( void * arg);
void * worker_sort_vectormul_crc_thread( void * arg);

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
#include "fpl2013_prog.h"
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
#include <arch/htime.h>
#endif

#include "fpl2013.h"

/*******************************
 * Top Level accelerator calls
 * *****************************/



#ifndef HETERO_COMPILATION
hthread_time_t start PRIVATE_MEMORY;
hthread_time_t stop PRIVATE_MEMORY;
hthread_time_t exec_time[NUM_THREADS] PRIVATE_MEMORY;
hthread_t tid[NUM_THREADS] PRIVATE_MEMORY;
hthread_attr_t attr[NUM_THREADS] PRIVATE_MEMORY;
void * ret[NUM_THREADS] PRIVATE_MEMORY;
int main(){

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
   printf("*********************************************************\n");
   printf("*               Accelerator Regression Test             *\n");
   printf("*                                                       *\n");
   printf("*                Author: Eugene Cartwright              *\n");
   printf("*********************************************************\n");
   printf("Number of Slave processors: %d\n", NUM_AVAILABLE_HETERO_CPUS);
   #ifdef OPCODE_FLAGGING
   printf("Opcode flagging enabled\n");
   #else
   printf("Opcode flagging disabled\n");
   #endif
   #ifdef CHECK_FIRST_POLYMORPHIC
   printf("CHECK FIRST POLYMORPHIC FUNCTION enabled\n");
   #else
   printf("CHECK FIRST POLYMORPHIC FUNCTION disabled\n");
   #endif
   #ifdef FORCE_POLYMORPHIC_HW
   printf("Forcing slaves to choose HARDWARE for polymorphic functions\n");
   #elif defined FORCE_POLYMORPHIC_SW
   printf("Forcing slaves to choose SOFTWARE for polymorphic functions\n");
   #else
   printf("Slaves will decide between HW or SW for polymorphic functions\n");
   #endif

   unsigned int b = 0;
   // Customize Accelerators here according to your platform setup
   assert(perform_PR(0,CRC) == SUCCESS);
   assert(perform_PR(1,VECTORDIV) == SUCCESS);
   assert(perform_PR(2,MATRIXMUL) == SUCCESS);
   assert(perform_PR(3,VECTORADD) == SUCCESS);
   assert(perform_PR(4,VECTORSUB) == SUCCESS);
   assert(perform_PR(5,BUBBLESORT) == SUCCESS);
   assert(perform_PR(6,VECTORDIV) == SUCCESS);
   assert(perform_PR(7,MATRIXMUL) == SUCCESS);
   assert(perform_PR(8,VECTORADD) == SUCCESS);
   assert(perform_PR(9,VECTORDIV) == SUCCESS);
   assert(perform_PR(10,MATRIXMUL) == SUCCESS);
   assert(perform_PR(11,VECTORADD) == SUCCESS);
   assert(perform_PR(12,CRC) == SUCCESS);
   assert(perform_PR(13,VECTORSUB) == SUCCESS);
   // Update table of last known accelerators
   slave_table[0].acc = CRC;
   slave_table[1].acc = VECTORDIV;
   slave_table[2].acc = MATRIXMUL;
   slave_table[3].acc = VECTORADD;
   slave_table[4].acc = VECTORSUB;
   slave_table[5].acc = BUBBLESORT;
   slave_table[6].acc = VECTORDIV;
   slave_table[7].acc = MATRIXMUL;
   slave_table[8].acc = VECTORADD;
   slave_table[9].acc = VECTORDIV;
   slave_table[10].acc = MATRIXMUL;
   slave_table[11].acc = VECTORADD;
   slave_table[12].acc = CRC;
   slave_table[13].acc = VECTORSUB;
 
   // Specify PR  
   _hwti_set_PR_flag((Huint) hwti_array[0], PR_FLAG);
   _hwti_set_PR_flag((Huint) hwti_array[1], PR_FLAG);
   _hwti_set_PR_flag((Huint) hwti_array[2], 0);
   _hwti_set_PR_flag((Huint) hwti_array[3], PR_FLAG);
   _hwti_set_PR_flag((Huint) hwti_array[4], PR_FLAG);
   _hwti_set_PR_flag((Huint) hwti_array[5], 0);
   _hwti_set_PR_flag((Huint) hwti_array[6], 0);
   _hwti_set_PR_flag((Huint) hwti_array[7], 0);
   _hwti_set_PR_flag((Huint) hwti_array[8], PR_FLAG);
   _hwti_set_PR_flag((Huint) hwti_array[9], PR_FLAG);
   _hwti_set_PR_flag((Huint) hwti_array[10], 0);
   _hwti_set_PR_flag((Huint) hwti_array[11], PR_FLAG);
   _hwti_set_PR_flag((Huint) hwti_array[12], 0);
   _hwti_set_PR_flag((Huint) hwti_array[13], 0);
   slave_table[0].pr = PR_FLAG;
   slave_table[1].pr = PR_FLAG;
   slave_table[2].pr = 0;
   slave_table[3].pr = PR_FLAG;
   slave_table[4].pr = PR_FLAG;
   slave_table[5].pr = 0;
   slave_table[6].pr = 0;
   slave_table[7].pr = 0;
   slave_table[8].pr = PR_FLAG;
   slave_table[9].pr = PR_FLAG;
   slave_table[10].pr = 0;
   slave_table[11].pr = PR_FLAG;
   slave_table[12].pr = 0;
   slave_table[13].pr = 0;
   //_hwti_set_last_accelerator((Huint) hwti_array[0], NO_ACC);
   //_hwti_set_last_accelerator((Huint) hwti_array[2], NO_ACC);


   for (b = 0; b < NUM_AVAILABLE_HETERO_CPUS; b++) {
      #ifdef BASE_CASE
      // No accelerators, no PR
      _hwti_set_PR_flag( (Huint) hwti_array[b], 0);
      _hwti_set_last_accelerator((Huint) hwti_array[b], NO_ACC);
      #endif
   }
   
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


	// Instantiate threads and thread attribute structures
	unsigned int ee = 0;
	for(ee = 0; ee < NUM_THREADS; ee++) {
		hthread_attr_init(&attr[ee]);
		hthread_attr_setdetachstate(&attr[ee], HTHREAD_CREATE_DETACHED);
	}

	volatile Data package[32];
	/*************** Package 0 **********/
	// Initalize the size for this package
	package[0].sort_size = 4095;
	package[0].crc_size = 1024;
	package[0].vectoradd_size = 3500;
	package[0].vectorsub_size = 3500;
	package[0].vectormul_size = 3500;
	
	/*************** Package 1 **********/
	// Initalize the size for this package
	package[1].sort_size = 2048;
	package[1].crc_size = 3500;
	package[1].vectoradd_size = 1024;
	package[1].vectorsub_size = 1024;
	package[1].vectormul_size = 1024;
	
	/*************** Package 2 **********/
	// Initalize the size for this package
	package[2].sort_size = 2048;
	package[2].crc_size = 4095;
	package[2].vectoradd_size = 1024;
	package[2].vectorsub_size = 1024;
	package[2].vectormul_size = 1024;
	
	/*************** Package 3 **********/
	// Initalize the size for this package
	package[3].sort_size = 2048;
	package[3].crc_size = 64;
	package[3].vectoradd_size = 3500;
	package[3].vectorsub_size = 3500;
	package[3].vectormul_size = 3500;
	
	/*************** Package 4 **********/
	// Initalize the size for this package
	package[4].sort_size = 512;
	package[4].crc_size = 3500;
	package[4].vectoradd_size = 64;
	package[4].vectorsub_size = 64;
	package[4].vectormul_size = 64;
	
	/*************** Package 5 **********/
	// Initalize the size for this package
	package[5].sort_size = 2048;
	package[5].crc_size = 1024;
	package[5].vectoradd_size = 4095;
	package[5].vectorsub_size = 4095;
	package[5].vectormul_size = 4095;
	
	/*************** Package 6 **********/
	// Initalize the size for this package
	package[6].sort_size = 3500;
	package[6].crc_size = 2048;
	package[6].vectoradd_size = 2048;
	package[6].vectorsub_size = 2048;
	package[6].vectormul_size = 2048;
	
	/*************** Package 7 **********/
	// Initalize the size for this package
	package[7].sort_size = 2048;
	package[7].crc_size = 4095;
	package[7].vectoradd_size = 1024;
	package[7].vectorsub_size = 1024;
	package[7].vectormul_size = 1024;
	
	/*************** Package 8 **********/
	// Initalize the size for this package
	package[8].sort_size = 3500;
	package[8].crc_size = 64;
	package[8].vectoradd_size = 4095;
	package[8].vectorsub_size = 4095;
	package[8].vectormul_size = 4095;
	
	/*************** Package 9 **********/
	// Initalize the size for this package
	package[9].sort_size = 2048;
	package[9].crc_size = 64;
	package[9].vectoradd_size = 2048;
	package[9].vectorsub_size = 2048;
	package[9].vectormul_size = 2048;
	
	/*************** Package 10 **********/
	// Initalize the size for this package
	package[10].sort_size = 1024;
	package[10].crc_size = 2048;
	package[10].vectoradd_size = 3500;
	package[10].vectorsub_size = 3500;
	package[10].vectormul_size = 3500;
	
	/*************** Package 11 **********/
	// Initalize the size for this package
	package[11].sort_size = 1024;
	package[11].crc_size = 1024;
	package[11].vectoradd_size = 512;
	package[11].vectorsub_size = 512;
	package[11].vectormul_size = 512;
	
	/*************** Package 12 **********/
	// Initalize the size for this package
	package[12].sort_size = 512;
	package[12].crc_size = 2048;
	package[12].vectoradd_size = 3500;
	package[12].vectorsub_size = 3500;
	package[12].vectormul_size = 3500;
	
	/*************** Package 13 **********/
	// Initalize the size for this package
	package[13].sort_size = 1024;
	package[13].crc_size = 512;
	package[13].vectoradd_size = 2048;
	package[13].vectorsub_size = 2048;
	package[13].vectormul_size = 2048;
	
	/*************** Package 14 **********/
	// Initalize the size for this package
	package[14].sort_size = 64;
	package[14].crc_size = 512;
	package[14].vectoradd_size = 64;
	package[14].vectorsub_size = 64;
	package[14].vectormul_size = 64;
	
	/*************** Package 15 **********/
	// Initalize the size for this package
	package[15].sort_size = 4095;
	package[15].crc_size = 3500;
	package[15].vectoradd_size = 2048;
	package[15].vectorsub_size = 2048;
	package[15].vectormul_size = 2048;
	
	/*************** Package 16 **********/
	// Initalize the size for this package
	package[16].sort_size = 64;
	package[16].crc_size = 4095;
	package[16].vectoradd_size = 3500;
	package[16].vectorsub_size = 3500;
	package[16].vectormul_size = 3500;
	
	/*************** Package 17 **********/
	// Initalize the size for this package
	package[17].sort_size = 64;
	package[17].crc_size = 1024;
	package[17].vectoradd_size = 1024;
	package[17].vectorsub_size = 1024;
	package[17].vectormul_size = 1024;
	
	/*************** Package 18 **********/
	// Initalize the size for this package
	package[18].sort_size = 512;
	package[18].crc_size = 3500;
	package[18].vectoradd_size = 2048;
	package[18].vectorsub_size = 2048;
	package[18].vectormul_size = 2048;
	
	/*************** Package 19 **********/
	// Initalize the size for this package
	package[19].sort_size = 2048;
	package[19].crc_size = 2048;
	package[19].vectoradd_size = 4095;
	package[19].vectorsub_size = 4095;
	package[19].vectormul_size = 4095;
	
	/*************** Package 20 **********/
	// Initalize the size for this package
	package[20].sort_size = 2048;
	package[20].crc_size = 512;
	package[20].vectoradd_size = 4095;
	package[20].vectorsub_size = 4095;
	package[20].vectormul_size = 4095;
	
	/*************** Package 21 **********/
	// Initalize the size for this package
	package[21].sort_size = 64;
	package[21].crc_size = 512;
	package[21].vectoradd_size = 1024;
	package[21].vectorsub_size = 1024;
	package[21].vectormul_size = 1024;
	
	/*************** Package 22 **********/
	// Initalize the size for this package
	package[22].sort_size = 1024;
	package[22].crc_size = 512;
	package[22].vectoradd_size = 4095;
	package[22].vectorsub_size = 4095;
	package[22].vectormul_size = 4095;
	
	/*************** Package 23 **********/
	// Initalize the size for this package
	package[23].sort_size = 3500;
	package[23].crc_size = 64;
	package[23].vectoradd_size = 64;
	package[23].vectorsub_size = 64;
	package[23].vectormul_size = 64;
	
	/*************** Package 24 **********/
	// Initalize the size for this package
	package[24].sort_size = 4095;
	package[24].crc_size = 4095;
	package[24].vectoradd_size = 64;
	package[24].vectorsub_size = 64;
	package[24].vectormul_size = 64;
	
	/*************** Package 25 **********/
	// Initalize the size for this package
	package[25].sort_size = 4095;
	package[25].crc_size = 512;
	package[25].vectoradd_size = 4095;
	package[25].vectorsub_size = 4095;
	package[25].vectormul_size = 4095;
	
	/*************** Package 26 **********/
	// Initalize the size for this package
	package[26].sort_size = 2048;
	package[26].crc_size = 512;
	package[26].vectoradd_size = 2048;
	package[26].vectorsub_size = 2048;
	package[26].vectormul_size = 2048;
	
	/*************** Package 27 **********/
	// Initalize the size for this package
	package[27].sort_size = 4095;
	package[27].crc_size = 4095;
	package[27].vectoradd_size = 3500;
	package[27].vectorsub_size = 3500;
	package[27].vectormul_size = 3500;
	
	/*************** Package 28 **********/
	// Initalize the size for this package
	package[28].sort_size = 4095;
	package[28].crc_size = 1024;
	package[28].vectoradd_size = 1024;
	package[28].vectorsub_size = 1024;
	package[28].vectormul_size = 1024;
	
	/*************** Package 29 **********/
	// Initalize the size for this package
	package[29].sort_size = 1024;
	package[29].crc_size = 4095;
	package[29].vectoradd_size = 512;
	package[29].vectorsub_size = 512;
	package[29].vectormul_size = 512;
	
	/*************** Package 30 **********/
	// Initalize the size for this package
	package[30].sort_size = 1024;
	package[30].crc_size = 3500;
	package[30].vectoradd_size = 512;
	package[30].vectorsub_size = 512;
	package[30].vectormul_size = 512;
	
	/*************** Package 31 **********/
	// Initalize the size for this package
	package[31].sort_size = 64;
	package[31].crc_size = 2048;
	package[31].vectoradd_size = 4095;
	package[31].vectorsub_size = 4095;
	package[31].vectormul_size = 4095;
	
	// Allocate memory
	unsigned int e = 0, k = 0;
	for ( k = 0; k < 32; k++) {
	    package[k].sort_data = (void *) malloc(sizeof(int) * package[k].sort_size);
	    package[k].crc_data = (void *) malloc(sizeof(int) * package[k].crc_size);
	    package[k].crc_data_check = (void *) malloc(sizeof(int) * package[k].crc_size);
	    package[k].dataA = (void *) malloc(sizeof(int) * package[k].vectoradd_size);
	    package[k].dataB = (void *) malloc(sizeof(int) * package[k].vectoradd_size);
	    package[k].dataC = (void *) malloc(sizeof(int) * package[k].vectoradd_size);
	    package[k].sort_valid = (Huint *) malloc(sizeof(Huint));
	    package[k].crc_valid = (Huint *) malloc(sizeof(Huint));
	    package[k].vectoradd_valid = (Huint *) malloc(sizeof(Huint));
	    package[k].vectorsub_valid = (Huint *) malloc(sizeof(Huint));
	    package[k].vectormul_valid = (Huint *) malloc(sizeof(Huint));
	
	    // Check to see if we were able to allocate said memory
	    assert(package[k].sort_valid != NULL);
	    assert(package[k].crc_valid != NULL);
	    assert(package[k].vectoradd_valid != NULL);
	    assert(package[k].vectorsub_valid != NULL);
	    assert(package[k].vectormul_valid != NULL);
	
	    assert(package[k].sort_data != NULL);
	    assert(package[k].crc_data != NULL);
	    assert(package[k].dataA != NULL);
	    assert(package[k].dataB != NULL);
	    assert(package[k].dataC != NULL);
	
	    // Initialize all the valid signals to zero
	    *(package[k].sort_valid) = 0;
	    *(package[k].crc_valid) = 0;
	    *(package[k].vectoradd_valid) = 0;
	    *(package[k].vectorsub_valid) = 0;
	    *(package[k].vectormul_valid) = 0;
	
	    // Initialize the CRC data here
	    for (e = 0; e < package[k].crc_size; e++) { 
	        Hint * data = (Hint *) package[k].crc_data;
	        Hint * data_check = (Hint *) package[k].crc_data_check;
	        data[e] = data_check[e] = (rand() % 1000) * 8;
	    }
	    
	    // Initialize Vector Data 
	    for (e = 0; e < package[k].vectoradd_size; e++) {
	        Hint * dataA = package[k].dataA;
	        Hint * dataB = package[k].dataB;
	        Hint * dataC = package[k].dataC;
	        dataA[e] = rand() % 1000;
	        dataB[e] = rand() % 1000;
	        dataC[e] = 0;
	    }
	
	    // Initialize Sort Data 
	    for (e = 0; e < package[k].sort_size; e++) {
	        Hint * sort_data = (Hint *) package[k].sort_data;
	        sort_data[e] = package[k].sort_size - e;
	    }
	}
	

	start = hthread_time_get();

   thread_create(&tid[0],  &attr[0], matrix_mult_thread_FUNC_ID, (void *) &matrix_arg[1], DYNAMIC_HW, 0);
	thread_create(&tid[1],  &attr[1], worker_vectoradd_thread_FUNC_ID, (void *) &package[19], DYNAMIC_HW, 0);
   thread_create(&tid[2],  &attr[2], worker_vectorsub_thread_FUNC_ID, (void *) &package[23], DYNAMIC_HW, 0);
   thread_create(&tid[3],  &attr[3], find_max_thread_FUNC_ID, (void *) &findmax_arg[3], DYNAMIC_HW, 0);
	thread_create(&tid[4],  &attr[4], worker_crc_thread_FUNC_ID, (void *) &package[11], DYNAMIC_HW, 0);
	thread_create(&tid[5],  &attr[5], worker_sort_thread_FUNC_ID, (void *) &package[18], DYNAMIC_HW, 0);
   thread_create(&tid[6],  &attr[6], histogram_thread_FUNC_ID, (void*)(&thread_arg[1]),DYNAMIC_HW,0 );
	thread_create(&tid[7],  &attr[7], worker_crc_vectormul_thread_FUNC_ID, (void *) &package[21], DYNAMIC_HW, 0);
   thread_create(&tid[8],  &attr[8], mandel_thread_FUNC_ID, (void *) MANDEL_MAX_ITERATIONS, DYNAMIC_HW, 0);
	thread_create(&tid[9],  &attr[9], worker_vectorsub_thread_FUNC_ID, (void *) &package[26], DYNAMIC_HW, 0);
	thread_create(&tid[10], &attr[10], worker_vectorsub_sort_crc_thread_FUNC_ID, (void *) &package[7], DYNAMIC_HW, 0);
	thread_create(&tid[11], &attr[11], worker_vectorsub_sort_thread_FUNC_ID, (void *) &package[12], DYNAMIC_HW, 0);
	thread_create(&tid[12], &attr[12], worker_vectoradd_thread_FUNC_ID, (void *) &package[25], DYNAMIC_HW, 0);
   thread_create(&tid[13], &attr[13], histogram_thread_FUNC_ID, (void*)(&thread_arg[0]),DYNAMIC_HW,0 );
   thread_create(&tid[14], &attr[14], find_max_thread_FUNC_ID, (void *) &findmax_arg[2], DYNAMIC_HW, 0);
	thread_create(&tid[15], &attr[15], worker_vectormul_thread_FUNC_ID, (void *) &package[17], DYNAMIC_HW, 0);
   thread_create(&tid[16], &attr[16], histogram_thread_FUNC_ID, (void*)(&thread_arg[2]),DYNAMIC_HW,0 );
	thread_create(&tid[17], &attr[17], worker_crc_thread_FUNC_ID, (void *) &package[10], DYNAMIC_HW, 0);
   thread_create(&tid[18], &attr[18], matrix_mult_thread_FUNC_ID, (void *) &matrix_arg[2], DYNAMIC_HW, 0);
	thread_create(&tid[19], &attr[19], worker_vectormul_thread_FUNC_ID, (void *) &package[6], DYNAMIC_HW, 0);
	thread_create(&tid[20], &attr[20], worker_vectormul_thread_FUNC_ID, (void *) &package[27], DYNAMIC_HW, 0);
	thread_create(&tid[21], &attr[21], worker_vectorsub_thread_FUNC_ID, (void *) &package[3], DYNAMIC_HW, 0);
	thread_create(&tid[22], &attr[22], worker_vectormul_thread_FUNC_ID, (void *) &package[24], DYNAMIC_HW, 0);
	thread_create(&tid[23], &attr[23], worker_vectoradd_thread_FUNC_ID, (void *) &package[22], DYNAMIC_HW, 0);
   thread_create(&tid[24], &attr[24], distance_thread_FUNC_ID, (void *) &distance_arg[2], DYNAMIC_HW, 0);
   thread_create(&tid[25], &attr[25], pi_thread_FUNC_ID, (void *) &thread_data[0], DYNAMIC_HW, 0);
   thread_create(&tid[26], &attr[26], pi_thread_FUNC_ID, (void *) &thread_data[4], DYNAMIC_HW, 0);
	thread_create(&tid[27], &attr[27], worker_vectorsub_thread_FUNC_ID, (void *) &package[5], DYNAMIC_HW, 0);
	thread_create(&tid[28], &attr[28], worker_crc_vectormul_thread_FUNC_ID, (void *) &package[30], DYNAMIC_HW, 0);
	thread_create(&tid[29], &attr[29], worker_vectorsub_sort_thread_FUNC_ID, (void *) &package[2], DYNAMIC_HW, 0);
   thread_create(&tid[30], &attr[30], distance_thread_FUNC_ID, (void *) &distance_arg[0], DYNAMIC_HW, 0);
   thread_create(&tid[31], &attr[31], find_max_thread_FUNC_ID, (void *) &findmax_arg[1], DYNAMIC_HW, 0);
   thread_create(&tid[32], &attr[32], mandel_thread_FUNC_ID, (void *) MANDEL_MAX_ITERATIONS, DYNAMIC_HW, 0);
	thread_create(&tid[33], &attr[33], worker_vectoradd_thread_FUNC_ID, (void *) &package[9], DYNAMIC_HW, 0);
	thread_create(&tid[34], &attr[34], worker_sort_vectorsub_thread_FUNC_ID, (void *) &package[28], DYNAMIC_HW, 0);
   thread_create(&tid[35], &attr[35], mandel_thread_FUNC_ID, (void *) MANDEL_MAX_ITERATIONS, DYNAMIC_HW, 0);
	thread_create(&tid[36], &attr[36], worker_vectorsub_sort_thread_FUNC_ID, (void *) &package[8], DYNAMIC_HW, 0);
	thread_create(&tid[37], &attr[37], worker_vectoradd_thread_FUNC_ID, (void *) &package[29], DYNAMIC_HW, 0);
   thread_create(&tid[38], &attr[38], pi_thread_FUNC_ID, (void *) &thread_data[3], DYNAMIC_HW, 0);
	thread_create(&tid[39], &attr[39], worker_vectormul_thread_FUNC_ID, (void *) &package[20], DYNAMIC_HW, 0);
	thread_create(&tid[40], &attr[40], worker_vectorsub_sort_crc_thread_FUNC_ID, (void *) &package[31], DYNAMIC_HW, 0);
	thread_create(&tid[41], &attr[41], worker_sort_crc_vectoradd_thread_FUNC_ID, (void *) &package[16], DYNAMIC_HW, 0);
	thread_create(&tid[42], &attr[42], worker_sort_vectormul_crc_thread_FUNC_ID, (void *) &package[1], DYNAMIC_HW, 0);
	thread_create(&tid[43], &attr[43], worker_sort_crc_vectoradd_thread_FUNC_ID, (void *) &package[0], DYNAMIC_HW, 0);
   thread_create(&tid[44], &attr[44], pi_thread_FUNC_ID, (void *) &thread_data[2], DYNAMIC_HW, 0);
	thread_create(&tid[45], &attr[45], worker_sort_thread_FUNC_ID, (void *) &package[13], DYNAMIC_HW, 0);
   thread_create(&tid[46], &attr[46], histogram_thread_FUNC_ID, (void*)(&thread_arg[4]),DYNAMIC_HW,0 );
	thread_create(&tid[47], &attr[47], worker_crc_thread_FUNC_ID, (void *) &package[15], DYNAMIC_HW, 0);
	thread_create(&tid[48], &attr[48], worker_vectorsub_sort_thread_FUNC_ID, (void *) &package[14], DYNAMIC_HW, 0);
   thread_create(&tid[49], &attr[49], matrix_mult_thread_FUNC_ID, (void *) &matrix_arg[3], DYNAMIC_HW, 0);
   thread_create(&tid[50], &attr[50], matrix_mult_thread_FUNC_ID, (void *) &matrix_arg[0], DYNAMIC_HW, 0);
   thread_create(&tid[51], &attr[51], histogram_thread_FUNC_ID, (void*)(&thread_arg[1]),DYNAMIC_HW,0 );
   thread_create(&tid[52], &attr[52], distance_thread_FUNC_ID, (void *) &distance_arg[1], DYNAMIC_HW, 0);
   thread_create(&tid[53], &attr[53], find_max_thread_FUNC_ID, (void *) &findmax_arg[4], DYNAMIC_HW, 0);
   thread_create(&tid[54], &attr[54], pi_thread_FUNC_ID, (void *) &thread_data[1], DYNAMIC_HW, 0);
	thread_create(&tid[55], &attr[55], worker_crc_vectorsub_sort_thread_FUNC_ID, (void *) &package[4], DYNAMIC_HW, 0);
   thread_create(&tid[56], &attr[56], find_max_thread_FUNC_ID, (void *) &findmax_arg[0], DYNAMIC_HW, 0);

   // Wait until all threads are finished 
	while(get_num_free_slaves() < NUM_AVAILABLE_HETERO_CPUS || thread_entries != 0) {
      if (thread_entries != 0)
         hthread_yield();
   }

	stop = hthread_time_get();

	#if 0
	   for (e = 0; e < 32; e++) {
	      // Determine which slave ran this thread based on address
	      Huint base = attr[e].hardware_addr - HT_HWTI_COMMAND_OFFSET;
	      Huint slave_num = (base & 0x00FF0000) >> 16;
	      printf("Thread %03d -> Slave : %02d\n", e, slave_num);
	   }
	#endif
	
	int number_of_errors = 0;
	for (e = 0; e < 32; e++) {
	    // Check SORT for this package
	    if (*(package[e].sort_valid)) {
	        unsigned int b = 0;
	        Hint * sorted_list = package[e].sort_data;
	        for (b = 0; b < package[e].sort_size-1; b++) {
	            if (sorted_list[b] > sorted_list[b+1]) {
	                number_of_errors++;
	                printf("\tSORT: Package %u failed\n", e);
	                break;
	            }
	        }
	    }
	    
	    // Check CRC for this package
	    if (*(package[e].crc_valid)) {
	        unsigned int b = 0;
	        Hint * crc = (Hint *) package[e].crc_data;
	        Hint * crc_check = (Hint *) package[e].crc_data_check;
	
	        poly_crc((void *) crc_check, package[e].crc_size);
	
	        for (b = 0; b < package[e].crc_size; b++) {
	            if (crc[b] != crc_check[b]) {
	                printf("\tCRC: Package %u failed\n", e);
	                number_of_errors++;
	                break;
	            }
	        }
	    }
	
	    // Check VectorAdd for this package
	    if (*(package[e].vectoradd_valid)) {
	        unsigned int b = 0;
	        Hint * A = (Hint *) package[e].dataA;
	        Hint * B = (Hint *) package[e].dataB;
	        Hint * C = (Hint *) package[e].dataC;
	        for (b = 0; b < package[e].vectoradd_size; b++) {
	            if (C[b] != A[b] +B[b]) { 
	                printf("\tVectorAdd: Package %u failed\n", e);
	                number_of_errors++;
	                break;
	            }
	        }
	    }
	    
	    // Check VectorSub for this package
	    if (*(package[e].vectorsub_valid)) {
	        unsigned int b = 0;
	        Hint * A = (Hint *) package[e].dataA;
	        Hint * B = (Hint *) package[e].dataB;
	        Hint * C = (Hint *) package[e].dataC;
	        for (b = 0; b < package[e].vectorsub_size; b++) {
	            if (C[b] != A[b] -B[b]) { 
	                printf("\tVectorSub: Package %u failed\n", e);
	                number_of_errors++;
	                break;
	            }
	        }
	    }
	
	    // Check VectorMul for this package
	    if (*(package[e].vectormul_valid)) {
	        unsigned int b = 0;
	        Hint * A = (Hint *) package[e].dataA;
	        Hint * B = (Hint *) package[e].dataB;
	        Hint * C = (Hint *) package[e].dataC;
	        for (b = 0; b < package[e].vectormul_size; b++) {
	            if (C[b] != A[b] *B[b]) { 
	                printf("\tVectorMul: Package %u failed\n", e);
	                number_of_errors++;
	                break;
	            }
	        }
	    }
	}
	
	printf("---------------------------\n");
	printf("\nNumber of Errors = %d\n\n", number_of_errors);
	hthread_time_t diff;
	hthread_time_diff(diff, stop, start);
	printf("Total Execution Time: %.2f ms\n", hthread_time_msec(diff));
	printf("Total Execution Time: %.2f us\n", hthread_time_usec(diff));
    

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

    for (e = 0; e < NUM_AVAILABLE_HETERO_CPUS; e++) {
        hw_counter[e] = _hwti_get_accelerator_hw_counter(hwti_array[e]);
        sw_counter[e] = _hwti_get_accelerator_sw_counter(hwti_array[e]);
        pr_counter[e] = _hwti_get_accelerator_pr_counter(hwti_array[e]);

        total_hw_count += hw_counter[e];
        total_sw_count += sw_counter[e];
        total_pr_count += pr_counter[e];

        // Manually Reset
        _hwti_set_accelerator_hw_counter(hwti_array[e], 0);
        _hwti_set_accelerator_sw_counter(hwti_array[e], 0);
        _hwti_set_accelerator_pr_counter(hwti_array[e], 0);
    }

    printf("Total HW Counter: %d\n", total_hw_count);
    printf("Total SW Counter: %d\n", total_sw_count);
    printf("Total PR Counter: %d\n", total_pr_count);
    printf("-----------------------\n");
    if (total_hw_count)     // if total_hw_count != 0
        printf("Total PR Counter / HW Counter = %f\n", total_pr_count / (1.0 *total_hw_count));
    printf("Total PR Counter / HW+SW Counter = %f\n", total_pr_count / (1.0 *(total_hw_count+total_sw_count)));
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

