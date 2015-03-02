/*   
 * This file is a stress test for the pthread_cond_init function.

 * The steps are:
 * -> Create some threads
 * -> each thread loops on initializing and destroying a mutex variable
 */

#include <hthread.h>
#include <stdlib.h>
#include <stdio.h>

#define NUMBER_OF_TESTS 10000
#define NUMBER_OF_THREADS 50

struct test_data {
	int * numberOfTestsToComplete;
	int * numberOfTestsCompleted;
	hthread_mutex_t * completedMutex;
};

void * testThread ( void * arg ) {
	struct test_data * data = (struct test_data *) arg;
	hthread_mutex_t * mutex;
	
	//Repeat until we've completed the number of tests
	while( *(data->numberOfTestsCompleted) < *(data->numberOfTestsToComplete) ) {
		//Allocate space for the mutex
		mutex = (hthread_mutex_t *) malloc( sizeof( hthread_mutex_t ) );
		
		if ( mutex == NULL ) {
			printf( "Test FAILED, malloc error\n" );
			hthread_exit( NULL );
		}
		
		//Initialize the condvar
		hthread_mutex_init( mutex, NULL );
		
		//Lock the mutex
		hthread_mutex_lock( mutex );
		
		//Unlock the mutex( 
		hthread_mutex_unlock( mutex );
		
		//Destroy the mutex
		hthread_mutex_destroy( mutex );
		
		//Free up its memory
		free( mutex );
		
		//Increment the counter
		hthread_mutex_lock( data->completedMutex );
		*(data->numberOfTestsCompleted) += 1;
		hthread_mutex_unlock( data->completedMutex );

		hthread_yield();
	}	
	
	//Exit
	hthread_exit( NULL );
	return NULL;
}

int main() {
	hthread_t test_thread[NUMBER_OF_THREADS];
	hthread_mutex_t mutex;
	int arg, retVal, toBeCompleted, completed, i;
	struct test_data data;
	
	//Print the name of the test to the screen
	printf( "Starting test mutex_init_stress_1\n" );

	//Set up the arguments for the test
	hthread_mutex_init( &mutex, NULL );
	toBeCompleted = NUMBER_OF_TESTS;
	completed = 0;
	
	data.numberOfTestsToComplete = & toBeCompleted;
	data.numberOfTestsCompleted = & completed;
	data.completedMutex = & mutex;
	
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
