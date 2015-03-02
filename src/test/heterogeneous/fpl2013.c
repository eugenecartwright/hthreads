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
//#define USE_ACC
#define BASE_CASE

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

	// Instantiate threads and thread attribute structures
	hthread_t threads[1];
	hthread_attr_t attr[1];
	unsigned int ee = 0;
	for(ee = 0; ee < 1; ee++) {
		hthread_attr_init(&attr[ee]);
		hthread_attr_setdetachstate(&attr[ee], HTHREAD_CREATE_DETACHED);
	}

	volatile Data package[1];
	/*************** Package 0 **********/
	// Initalize the size for this package
	package[0].sort_size = 10000;
	package[0].crc_size = 40;
	package[0].vector_size = 4096;
	
	// Allocate memory
	unsigned int e = 0, k = 0;
	for ( k = 0; k < 1; k++) {
	    package[k].sort_data = (void *) malloc(sizeof(int) * package[k].sort_size);
	    package[k].crc_data = (void *) malloc(sizeof(int) * package[k].crc_size);
	    package[k].crc_data_check = (void *) malloc(sizeof(int) * package[k].crc_size);
	    package[k].dataA = (void *) malloc(sizeof(int) * package[k].vector_size);
	    package[k].dataB = (void *) malloc(sizeof(int) * package[k].vector_size);
	    package[k].dataC = (void *) malloc(sizeof(int) * package[k].vector_size);
	    package[k].sort_valid = (Huint *) malloc(sizeof(Huint));
	    package[k].crc_valid = (Huint *) malloc(sizeof(Huint));
	    package[k].vector_valid = (Huint *) malloc(sizeof(Huint));
	
	    // Check to see if we were able to allocate said memory
	    assert(package[k].sort_valid != NULL);
	    assert(package[k].crc_valid != NULL);
	    assert(package[k].vector_valid != NULL);
	
	    assert(package[k].sort_data != NULL);
	    assert(package[k].crc_data != NULL);
	    assert(package[k].dataA != NULL);
	    assert(package[k].dataB != NULL);
	    assert(package[k].dataC != NULL);
	
	    // Initialize all the valid signals to zero
	    *(package[k].sort_valid) = 0;
	    *(package[k].crc_valid) = 0;
	    *(package[k].vector_valid) = 0;
	
	    // Initialize the CRC data here
	    for (e = 0; e < package[k].crc_size; e++) { 
	        Hint * data = (Hint *) package[k].crc_data;
	        Hint * data_check = (Hint *) package[k].crc_data_check;
	        data[e] = data_check[e] = (rand() % 1000) * 8;
	    }
	    
	    // Initialize Vector Data 
	    for (e = 0; e < package[k].vector_size; e++) {
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
	

	printf("Starting Timer!\n");

	hthread_time_t start = hthread_time_get();

	thread_create(&threads[0], &attr[0], worker_vector1_thread_FUNC_ID, (void *) &package[0],STATIC_HW3, 0);

	while((thread_counter + (NUM_AVAILABLE_HETERO_CPUS - get_num_free_slaves()) ) > 0);

	hthread_time_t stop = hthread_time_get();

	int number_of_errors = 0;
	for (e = 0; e < 1; e++) {
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
	
	        _crc((void *) crc_check, package[e].crc_size);
	
	        for (b = 0; b < package[e].crc_size; b++) {
	            if (crc[b] != crc_check[b]) {
	                printf("\tCRC: Package %u failed\n", e);
	                number_of_errors++;
	                break;
	            }
	        }
	    }
	
	    // Check Vector for this package
	    if (*(package[e].vector_valid)) {
	        unsigned int b = 0;
	        Hint * A = (Hint *) package[e].dataA;
	        Hint * B = (Hint *) package[e].dataB;
	        Hint * C = (Hint *) package[e].dataC;
	        for (b = 0; b < package[e].vector_size; b++) {
	            if (C[b] != A[b] +B[b]) { 
	                printf("\tVector: Package %u failed %d\n", e, b);
	                number_of_errors++;
	                //break;
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

