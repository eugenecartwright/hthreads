/*   
   The hthread_create(hthread_t * thread, hthread_attr_t * attr, void
   *start_routine, void * arg); creates a new thread, with attributes specified
   by 'attr', within a process.

   Hardware must be tested on the board
   
   Methodology
   1. Create a detached thread, as specified by hthread_attr_t.
   2. Try to join on the detached thread, should return a EINVAL error.
 */

#include <hthread.h>
#include <stdlib.h>
#include <stdio.h>
#include "hthreadtest.h"

#define EXPECTED_RESULT EINVAL

struct test_data {
	void * function;
	hthread_attr_t * attr;
	hthread_t thread;
};

void * a_thread_function(void * arg) {
	return NULL;
}

void * testThread ( void * arg ) {
	int retVal;
	struct test_data * data = (struct test_data *) arg;
	
	hthread_create( &data->thread, data->attr, data->function, NULL );
	retVal = hthread_join( data->thread, NULL );
	
	hthread_exit( (void *) retVal );
	return NULL;
}

int main() {
	hthread_t test_thread;
	hthread_attr_t test_attr;
	hthread_attr_t attr;
	int arg, retVal;
	struct test_data data;
	
	//Print the name of the test to the screen
	printf( "Starting test create_1\n" );

	//Set up the arguments for the test
	hthread_attr_init( &attr );
    hthread_attr_setdetachstate( &attr, HTHREAD_CREATE_DETACHED );
	
	data.function = a_thread_function;
	data.attr = &attr;
	
	arg = (int) &data;
	
	//Initialize RPC
	rpc_setup();
	
	//Run the tests
	hthread_attr_init( &test_attr );
	if ( HARDWARE ) hthread_attr_sethardware( &test_attr, HWTI_ONE_BASEADDR );
	hthread_create( &test_thread, &test_attr, testThread, (void *) arg );
	hthread_join( test_thread, (void *) &retVal );

	if ( HARDWARE ) readHWTStatus( HWTI_ONE_BASEADDR );
	
	//Evaluate the results
	if ( retVal == EXPECTED_RESULT ) {
		printf("Test PASSED\n");
		return PTS_PASS;
	} else {
		printf("Test FAILED [expecting %d, received %d]\n", EXPECTED_RESULT, retVal );
		return PTS_FAIL;
	}
}
