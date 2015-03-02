/*   
 * This file is a stress test for the pthread_cond_wait function.

 * The steps are:
 * -> Create some threads
 * -> each thread loops on broadcasting or signaling a condavar, and then waits
 * -> the whole process stop when all waits are complete
 */

#include <hthread.h>
#include <stdlib.h>
#include <stdio.h>

#define NUMBER_OF_TESTS 25000
#define NUMBER_OF_THREADS 50

struct test_data {
	int * numberOfTestsToComplete;
	int * numberOfTestsCompleted;
	hthread_mutex_t * mutex;
	hthread_cond_t * condvar;
};

void * testThread ( void * arg ) {
	struct test_data * data = (struct test_data *) arg;
	
	hthread_mutex_lock( data->mutex );
	
	//Repeat until we've completed the number of tests
	while( *(data->numberOfTestsCompleted) < *(data->numberOfTestsToComplete) ) {
		
		//Signal the condvar
		hthread_cond_signal( data->condvar );
		
		//Now wait for another thread to signal us
		hthread_cond_wait( data->condvar, data->mutex );
		
		//Increment the counter, protected by data->mutex
		*(data->numberOfTestsCompleted) += 1;

		hthread_yield();
	}	
	
	//Signal again to make sure no one is waiting
	hthread_cond_broadcast( data->condvar );
	
	hthread_mutex_unlock( data->mutex );
	
	//Exit
	hthread_exit( NULL );
	return NULL;
}

int main() {
	hthread_t test_thread[NUMBER_OF_THREADS];
	hthread_mutex_t mutex;
	hthread_cond_t condvar;
	int arg, retVal, toBeCompleted, completed, i;
	struct test_data data;
	
	//Print the name of the test to the screen
	printf( "Starting test cond_wait_stress_1\n" );

	//Set up the arguments for the test
	hthread_mutex_init( &mutex, NULL );
	hthread_cond_init( &condvar, NULL );
	toBeCompleted = NUMBER_OF_TESTS;
	completed = 0;
	
	data.numberOfTestsToComplete = & toBeCompleted;
	data.numberOfTestsCompleted = & completed;
	data.mutex = & mutex;
	data.condvar = & condvar;
	
	arg = (int) &data;
	
	//Run the tests
	for ( i=0; i<NUMBER_OF_THREADS; i++ )
		hthread_create( &test_thread[i], NULL, testThread, (void *) arg );
	for ( i=0; i<NUMBER_OF_THREADS; i++ )
		hthread_join( test_thread[i], (void *) &retVal );

	//If all threads joined, then test was successful
	printf( "Completed Tests: %d\n", completed );
	printf( "Number of Threads: %d\n", NUMBER_OF_THREADS );
	printf( "Test PASSED\n" );

	return 1;
}
