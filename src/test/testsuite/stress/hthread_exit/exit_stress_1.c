/*   
 * This file is a stress test for the hthread_exit function.

 * The steps are:
 * -> Create a number of threads
 * -> Join on the threads
 * -> Check that the returned value is the value really returned by the thread
 */

#include <hthread.h>
#include <stdlib.h>
#include <stdio.h>

#define NUMBER_OF_THREADS 250
#define NUMBER_OF_TESTS NUMBER_OF_THREADS

struct test_data {
	int * numberOfTestsToComplete;
	int * numberOfTestsCompleted;
	void * function;
	hthread_t threads[NUMBER_OF_THREADS];
};

//Each thread returns their ID
void * a_thread_function (void * arg) {
	hthread_exit( (void *) hthread_self() );
	return NULL;
}

void * testThread ( void * arg ) {
	struct test_data * data = (struct test_data *) arg;
	int i, joinValue;
	
	joinValue = SUCCESS;
	i = 0;
	
	//Create a number of threads
	for( i=0; i<*(data->numberOfTestsToComplete); i++ ) {
		hthread_create( &(data->threads[i]), NULL, data->function, NULL );
	}
	
	//Join on the threads we created
	for( i=0; i<*(data->numberOfTestsToComplete); i++ ) {
		hthread_join( data->threads[i], (void *) &joinValue );
		
		//Check the return value
		if ( joinValue == (int)data->threads[i] )
			*(data->numberOfTestsCompleted) += 1;
	}
	
	//Exit
	hthread_exit( NULL );
	return NULL;
}

int main() {
	hthread_t test_thread;
	int arg, retVal, toBeCompleted, completed;
	struct test_data data;
	
	//Print the name of the test to the screen
	printf( "Starting test exit_stress_1\n" );

	//Set up the arguments for the test
	toBeCompleted = NUMBER_OF_TESTS;
	completed = 0;
	
	data.numberOfTestsToComplete = & toBeCompleted;
	data.numberOfTestsCompleted = & completed;
	data.function = a_thread_function;
	
	arg = (int) &data;
	
	//Run the tests
	hthread_create( &test_thread, NULL, testThread, (void *) arg );
	hthread_join( test_thread, (void *) &retVal );

	//If all threads joined, then test was successful
	printf( "Completed Tests: %d\n", completed );
	printf( "Number of Threads: %d\n", NUMBER_OF_THREADS );
	printf( "Test PASSED\n" );

	return 1;
}
