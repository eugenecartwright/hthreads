/*   
 * This file is a stress test for the hthread_create function.

 * The steps are:
 * -> Create threads until it returns error
 */

#include <hthread.h>
#include <stdlib.h>
#include <stdio.h>

#define NUMBER_OF_THREADS 500
#define NUMBER_OF_TESTS NUMBER_OF_THREADS

struct test_data {
	int * numberOfTestsToComplete;
	int * numberOfTestsCompleted;
	void * function;
	hthread_t threads[NUMBER_OF_THREADS];
};

void * a_thread_function (void * arg) {
	hthread_exit( NULL );
	return NULL;
}

void * testThread ( void * arg ) {
	struct test_data * data = (struct test_data *) arg;
	int i, createReturn;
	
	createReturn = SUCCESS;
	i = 0;
	
	//Check to see if everything is still OK, and we have not reached the max yet
	while( createReturn == SUCCESS
		&& *(data->numberOfTestsCompleted) < *(data->numberOfTestsToComplete) ) {
		
		//Create the threads
		createReturn = hthread_create( &(data->threads[i]), NULL, data->function, NULL );
	    printf("Creating thread - %u\n",i);	
		if ( createReturn == SUCCESS ) {
			*(data->numberOfTestsCompleted) += 1;
			i++;
		}
	}
	
	//Join on the threads we created
	for( i=0; i<*(data->numberOfTestsCompleted); i++ ) {
	    printf("Joining thread - %u\n",i);	
		hthread_join( data->threads[i], NULL );
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
	printf( "Starting test create_stress_1\n" );

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
