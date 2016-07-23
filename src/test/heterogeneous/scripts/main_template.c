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
#include "tuning_table.h"

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

#ifndef HETERO_COMPILATION
#include "fpl2013_prog.h"
#include <arch/htime.h>
#endif

#include "fpl2013.h"

/*******************************
 * Top Level accelerator calls
 * *****************************/



#ifndef HETERO_COMPILATION
hthread_time_t start PRIVATE_MEMORY;
hthread_time_t stop PRIVATE_MEMORY;
int main(){

   init_host_tables();
   printf("*********************************************************\n");
   printf("*               Accelerator Regression Test             *\n");
   printf("*                                                       *\n");
   printf("*                Author: Eugene Cartwright              *\n");
   printf("*********************************************************\n");
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
   _hwti_set_PR_flag((Huint) hwti_array[2], PR_FLAG);
   _hwti_set_PR_flag((Huint) hwti_array[3], PR_FLAG);
   _hwti_set_PR_flag((Huint) hwti_array[4], PR_FLAG);
   _hwti_set_PR_flag((Huint) hwti_array[5], PR_FLAG);
   _hwti_set_PR_flag((Huint) hwti_array[6], PR_FLAG);
   _hwti_set_PR_flag((Huint) hwti_array[7], PR_FLAG);
   _hwti_set_PR_flag((Huint) hwti_array[8], PR_FLAG);
   _hwti_set_PR_flag((Huint) hwti_array[9], PR_FLAG);
   _hwti_set_PR_flag((Huint) hwti_array[10], PR_FLAG);
   _hwti_set_PR_flag((Huint) hwti_array[11], PR_FLAG);
   _hwti_set_PR_flag((Huint) hwti_array[12], PR_FLAG);
   _hwti_set_PR_flag((Huint) hwti_array[13], PR_FLAG);
   slave_table[0].pr = PR_FLAG;
   slave_table[1].pr = PR_FLAG;
   slave_table[2].pr = PR_FLAG;
   slave_table[3].pr = PR_FLAG;
   slave_table[4].pr = PR_FLAG;
   slave_table[5].pr = PR_FLAG;
   slave_table[6].pr = PR_FLAG;
   slave_table[7].pr = PR_FLAG;
   slave_table[8].pr = PR_FLAG;
   slave_table[9].pr = PR_FLAG;
   slave_table[10].pr = PR_FLAG;
   slave_table[11].pr = PR_FLAG;
   slave_table[12].pr = PR_FLAG;
   slave_table[13].pr = PR_FLAG;
   //_hwti_set_last_accelerator((Huint) hwti_array[0], NO_ACC);
   //_hwti_set_last_accelerator((Huint) hwti_array[2], NO_ACC);


   for (b = 0; b < NUM_AVAILABLE_HETERO_CPUS; b++) {
      #ifdef BASE_CASE
      // No accelerators, no PR
      _hwti_set_PR_flag( (Huint) hwti_array[b], 0);
      _hwti_set_last_accelerator((Huint) hwti_array[b], NO_ACC);
      #endif
   }


    0xDEADBEEF

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

    return 0;
}
#endif

