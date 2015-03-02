/*   
 * This file is a stress test for the hthread_create function.

 * The original of this file was create_stress_1.c
 * This file 1) creates and joins on all available hardware threads,
 * 2) Creates and then joins on all possible software threads, 
 * 3) Creates hardware threads, and then makes the rest software 
 * threads, and then tries to create more software threads which it
 * expects to error out.
 * - Eugene
 */

#include <hthread.h>
#include <stdlib.h>
#include <stdio.h>

#define NUM_THREADS                         254 
#define TEST_PASSED                         0
#define THREAD_SOFTWARE_CREATE_FAILED       2
#define THREAD_SOFTWARE_JOIN_FAILED         3
#define THREAD_HARDWARE_CREATE_FAILED       4
#define THREAD_HARDWARE_JOIN_FAILED         5 
#define THREAD_HARDWARE_INCORRECT_RETURN    6
#define THREAD_SOFTWARE_ERROR_FAILED        7
#define FINAL_JOIN_ERROR                    8
#define TEST_FAILED                         9
#define MALLOC_ERROR                        10

#ifndef HETERO_COMPILATION
#define PRINT_ERROR(x)                      printf("%d\n",x); \
                                            printf("END\n"); \
                                            return x;
#endif


void * foo_thread (void * arg) {
    // Extract TID
	unsigned int tid = hthread_self();

    // Use it to get sceduling priority
    unsigned int priority = 0;
    hthread_getschedparam( (hthread_t) tid, NULL, (struct sched_param *) &priority);

    // Return scheduling priority (used only for verifying hardware threads)
	return (void *) priority;
}

// Dummy function to avoid hardware threads from exiting
// prematurely.
void * foo2_thread( void * arg) {
    volatile unsigned int a = 0, b=0, c=456;;
    c = c*(++b) + (++a);
    
    return NULL;
}

void * foo3_thread( void * arg) {
    volatile unsigned int tid = 0, a = 0; 
    unsigned int max = 10000;
    do {
        tid = a + hthread_self();
        a++;
    } while(a < max);

    return (void *) hthread_self();
}


#ifdef HETERO_COMPILATION
int main(){ return 0;}

#else
#include "create_stress_1_prog.h"
int main() {
    unsigned int i = 0;
	int retVal;
    
    // Allocate NUM_THREADS threads
    hthread_t * tid = NULL; tid = (hthread_t *) malloc(sizeof(hthread_t) * NUM_THREADS);
    hthread_attr_t * attr = NULL; attr = (hthread_attr_t *) malloc(sizeof(hthread_attr_t) * NUM_AVAILABLE_HETERO_CPUS);
    
    if (tid == NULL) { PRINT_ERROR(MALLOC_ERROR); }
    if (attr == NULL) { PRINT_ERROR(MALLOC_ERROR); }
    
    // Set up attributes for a hardware thread
    for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++)
    { 
        hthread_attr_init(&attr[i]);
        hthread_attr_setdetachstate( &attr[i], HTHREAD_CREATE_JOINABLE);
    }
	
    unsigned int failed = 0;
    
    // Create hardware threads first
    for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
        // Create thread -- Assuming that thread manager will give us
        // a TID = 2 every time since we are creating & joining 1 thread 
        // at a time.
        if (microblaze_create( &tid[i], &attr[i], foo_thread_FUNC_ID, (void *) 2, i) ) {
            failed = 1;
            PRINT_ERROR(THREAD_HARDWARE_CREATE_FAILED);
        }
        if (hthread_join( tid[i], (void *) &retVal ) ) {
            failed = 1;
            PRINT_ERROR(THREAD_HARDWARE_JOIN_FAILED);
        }
        // Make sure the return value is equal to base_array[i]
        if (base_array[i] != ((unsigned int) retVal - HT_CMD_HWTI_COMMAND)) {
            failed = 1;
            PRINT_ERROR(THREAD_HARDWARE_INCORRECT_RETURN);
        }

    }
    
    // Create all threads as software threads
    for (i = 0; i < NUM_THREADS; i++) {
        // Create threads
	    if (hthread_create( &tid[i], NULL, foo_thread, (void *) 2 )) {
            failed = 1;
            PRINT_ERROR(THREAD_SOFTWARE_CREATE_FAILED);
        }
    }
    // Now join on all software threads we just created
    for (i = 0; i < NUM_THREADS; i++) {
        // Join on thread
	    if (hthread_join(tid[i], (void *) &retVal )) {
            failed = 1;
            PRINT_ERROR(THREAD_SOFTWARE_JOIN_FAILED);
        }
    }
    // Create NUM_THREADS threads
	// ----> Create hardware threads first
    for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
        // Create threads
        if (microblaze_create( &tid[i], &attr[i], foo2_thread_FUNC_ID, (void *) i, i) ) {
            failed = 1;
            PRINT_ERROR(THREAD_HARDWARE_CREATE_FAILED);
        }
    }

    // ----> The remaining are software threads
    for (i = NUM_AVAILABLE_HETERO_CPUS; i < NUM_THREADS; i++) {
        // Create threads
	    if (hthread_create( &tid[i], NULL, foo2_thread, (void *) i )) {
            failed = 1;
            PRINT_ERROR(THREAD_SOFTWARE_CREATE_FAILED);
        }
    }

    // Try to create more here --SHOULD FAIL!!!
    for (i = 0; i < NUM_THREADS; i++) {
        // If it does not fail
	    if (hthread_create( &tid[i], NULL, foo2_thread, (void *) i ) == SUCCESS ) {
            failed = 1;
            PRINT_ERROR(THREAD_SOFTWARE_ERROR_FAILED);
        }
    }

    // Clean up- Join on the threads.
    for (i = 0; i < NUM_THREADS; i++) {
        // If it fails
	    if (hthread_join(tid[i], (void *) &retVal )) {
            failed = 1;
            PRINT_ERROR(FINAL_JOIN_ERROR);
        }
    }

    // Test dynamic_create_smart
    for (i =0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
        // Create threads
        if (dynamic_create_smart( &tid[i], &attr[i], foo3_thread_FUNC_ID, (void *) i) ) {
            failed = 1;
            PRINT_ERROR(THREAD_HARDWARE_CREATE_FAILED);
        }
    }
    
    // Clean up- Join on the threads.
    for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
        // If it fails
	    if (hthread_join(tid[i], (void *) &retVal )) {
            failed = 1;
            PRINT_ERROR(FINAL_JOIN_ERROR);
        }
    }

#ifdef SPLIT_BRAM
    // Test microblaze_create_DMA, Transfer instructions only
    for (i =0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
        // Create threads
        if (microblaze_create_DMA( &tid[i], &attr[i], foo3_thread_FUNC_ID, (void *) i, 0,0, i) ) {
            failed = 1;
            PRINT_ERROR(THREAD_HARDWARE_CREATE_FAILED);
        }
    }
    // Clean up- Join on the threads.
    for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
        // If it fails
	    if (hthread_join(tid[i], (void *) &retVal )) {
            failed = 1;
            PRINT_ERROR(FINAL_JOIN_ERROR);
        }
        if (retVal != tid[i]) {
            failed = 1;
            PRINT_ERROR(THREAD_HARDWARE_INCORRECT_RETURN);
        }
    }
    
    // Test dynamic_create_smart_DMA, Transfer instructions only
    for (i =0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
        // Create threads
        if (dynamic_create_smart_DMA( &tid[i], &attr[i], foo3_thread_FUNC_ID, (void *) i, 0,0) ) {
            failed = 1;
            PRINT_ERROR(THREAD_HARDWARE_CREATE_FAILED);
        }
    }
    // Clean up- Join on the threads.
    for (i = 0; i < NUM_AVAILABLE_HETERO_CPUS; i++) {
        // If it fails
	    if (hthread_join(tid[i], (void *) &retVal )) {
            failed = 1;
            PRINT_ERROR(FINAL_JOIN_ERROR);
        }
        if (retVal != tid[i]) {
            failed = 1;
            PRINT_ERROR(THREAD_HARDWARE_INCORRECT_RETURN);
        }
    }
        
#endif
    
    if (failed) {
        PRINT_ERROR(TEST_FAILED);
    }
    else
        PRINT_ERROR(TEST_PASSED);

    free(tid);
    free(attr);

	return TEST_PASSED;
}
#endif
