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

//#define DEBUG_DISPATCH

// Runtime tuning?
//#define TUNING

//#define USE_PR
#define USE_ACC
//#define BASE_CASE

#define MAIN_PR_FLAG     (0xC0000000)
#define MAIN_ACC_FLAG    (0x80000000)

Hint sort_sw_thread(void * arg);
Hint crc_sw_thread(void * arg);
Hint vector_add_sw_thread(void * arg);

void * worker_crc1_thread( void * arg);
void * worker_sort1_thread( void * arg);
void * worker_vector1_thread( void * arg);

// Primitives
void * worker_crc_thread( void * arg);
void * worker_sort_thread( void * arg);
void * worker_vector_add_thread( void * arg);

void * worker_sort_crc_thread( void * arg);
void * worker_sort_vector_thread( void * arg);
void * worker_crc_sort_thread( void * arg);
void * worker_crc_vector_thread( void * arg);
void * worker_vector_sort_thread( void * arg);
void * worker_vector_crc_thread( void * arg);
void * worker_vector_crc_sort_thread( void * arg);
void * worker_vector_sort_crc_thread( void * arg);
void * worker_crc_vector_sort_thread( void * arg);
void * worker_crc_sort_vector_thread( void * arg);
void * worker_sort_crc_vector_thread( void * arg);
void * worker_sort_vector_crc_thread( void * arg);

#ifndef HETERO_COMPILATION
#include "fpl2013_prog.h"
#include <arch/htime.h>
#endif

#include "fpl2013.h"

/*******************************
 * Top Level accelerator calls
 * *****************************/



#ifdef HETERO_COMPILATION
int main() { return 0; }
#else
int main(){

    printf("*********************************************************\n");
    printf("*               Accelerator Regression Test             *\n");
    printf("*                                                       *\n");
    printf("*                Author: Eugene Cartwright              *\n");
    printf("*********************************************************\n");

    unsigned int b = 0;
    // Initialize accelerator entries in slave table
    // and last_used_acc field in VHWTIs
    _hwti_set_last_accelerator(base_array[0],CRC); 
    _hwti_set_last_accelerator(base_array[1],CRC); 

    _hwti_set_last_accelerator(base_array[2],SORT); 
    _hwti_set_last_accelerator(base_array[3],SORT); 

    _hwti_set_last_accelerator(base_array[4],VECTOR); 
    _hwti_set_last_accelerator(base_array[5],VECTOR); 
    
    for (b = 0; b < NUM_AVAILABLE_HETERO_CPUS; b++) {
#ifdef BASE_CASE
        _hwti_set_accelerator_flags(base_array[b], 0);
#endif
#ifndef BASE_CASE
    #ifdef USE_ACC
        _hwti_set_accelerator_flags(base_array[b], MAIN_ACC_FLAG);
    #endif
    #ifdef USE_PR
        _hwti_set_accelerator_flags(base_array[b], 0xC0000000);
    #endif
#endif
    }

    //defining masks for timer control
	#define TimerInitMask 0x00000062   //initilizing the timer and loading the pre load reg. but not starting.
	#define TimerStartMask  0x000000D2
	#define timePeriod      200 //in microseconds

	#define base_timer0  XPAR_XPS_TIMER_0_BASEADDR
	volatile int *TCSR0 = (int*) (base_timer0+0x0);
	volatile int *TLR0 = (int*) (base_timer0+0x4);

	*TLR0=timePeriod*100;	 
	*TCSR0=TimerInitMask ; //starting the timer;
	*TCSR0=TimerStartMask;

    0xDEADBEEF

    // Grab the total number of calls statistic.
    Huint total_num_of_calls = best_slaves_num + no_free_slaves_num + possible_slaves_num; 

    printf("Total number of thread_create (DYNAMIC) calls: %d\n", total_num_of_calls);
    printf("---------------------------------------------------\n");
    printf("Best Ratio:     %03d / %03d = %0.2f\n", best_slaves_num, total_num_of_calls, best_slaves_num / (1.0 * total_num_of_calls));
    printf("No Free Ratio:  %03d / %03d = %0.2f\n", no_free_slaves_num, total_num_of_calls, no_free_slaves_num / (1.0 * total_num_of_calls));
    printf("Possible Ratio: %03d / %03d = %0.2f\n", possible_slaves_num, total_num_of_calls, possible_slaves_num / (1.0 * total_num_of_calls));

    Huint hw_counter[NUM_AVAILABLE_HETERO_CPUS];
    Huint sw_counter[NUM_AVAILABLE_HETERO_CPUS];
    Huint pr_counter[NUM_AVAILABLE_HETERO_CPUS];
    Huint total_hw_count = 0;
    Huint total_sw_count = 0;
    Huint total_pr_count = 0;

    for (e = 0; e < NUM_AVAILABLE_HETERO_CPUS; e++) {
        hw_counter[e] = _hwti_get_accelerator_hw_counter(base_array[e]);
        sw_counter[e] = _hwti_get_accelerator_sw_counter(base_array[e]);
        pr_counter[e] = _hwti_get_accelerator_pr_counter(base_array[e]);

        total_hw_count += hw_counter[e];
        total_sw_count += sw_counter[e];
        total_pr_count += pr_counter[e];
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

