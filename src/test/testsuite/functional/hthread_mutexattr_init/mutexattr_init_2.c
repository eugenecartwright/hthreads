/*   
  After a mutex attributes object has been used to initialize one or more
  mutexes, any function affecting the attributes object (including destruction)
  shall not affect any previously initialized mutexes.
 */

#include <hthread.h>
#include <stdlib.h>
#include <stdio.h>
#include "hthreadtest.h"

#define EXPECTED_RESULT 0

struct test_data {
	hthread_mutex_t * mutex;
	hthread_mutexattr_t * attr;
};

void * testThread ( void * arg ) {
	int retVal;
	struct test_data * data = (struct test_data *) arg;
	
	//Initialize a mutexattr, then a mutex with the attr
	hthread_mutexattr_init( data->attr );
	hthread_mutex_init( data->mutex, data->attr );
	
	//Change the attr 
	data->attr->num = 1;
	
	//Get the num of the mutex, it should not have changed
	retVal = hthread_mutex_getnum( data->mutex );
	
	hthread_exit( (void *) retVal );
	return NULL;
}

int main() {
	hthread_t test_thread;
	hthread_mutexattr_t attr;
	hthread_mutex_t mutex;
	struct test_data data;
	int arg, retVal;
	
	//Print the name of the test to the screen
	printf( "Starting test mutexattr_init_1\n" );

	//Set up the arguments for the test
	data.attr = &attr;
	data.mutex = &mutex;
	arg = (int) &data;
	
	//Run the tests
	hthread_create( &test_thread, NULL, testThread, (void *) arg );
	hthread_join( test_thread, (void *) &retVal );

	//Evaluate the results
	if ( retVal == EXPECTED_RESULT ) {
		printf("Test PASSED\n");
		return PTS_PASS;
	} else {
		printf("Test FAILED [expecting %d, received%d]\n", EXPECTED_RESULT, retVal );
		return PTS_FAIL;
	}	
}
