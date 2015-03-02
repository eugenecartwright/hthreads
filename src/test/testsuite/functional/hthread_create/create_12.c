/*   
   hthread_create, when successful, returns SUCCESS

   Hardware must be tested on the board.
   
   Methodology.
   1. Call create, and check the return value.
 */

#include <hthread.h>
#include <stdlib.h>
#include <stdio.h>
#include "hthreadtest.h"

#define EXPECTED_RESULT SUCCESS

struct test_data {
	void * function;
	hthread_t thread;
};

void * a_thread_function(void * arg) {
	hthread_exit( NULL );
	return NULL;
}

void * testThread ( void * arg ) {
	int retVal;
	struct test_data * data = (struct test_data *) arg;
	
	retVal = hthread_create( &data->thread, NULL, data->function, NULL );
	hthread_join( data->thread, NULL );
	
	hthread_exit( (void *) retVal );
	return NULL;
}

int main() {
	hthread_t test_thread;
	hthread_attr_t test_attr;
	int arg, retVal;
	struct test_data data;
	
	//Print the name of the test to the screen
	printf( "Starting test create_12\n" );

	//Set up the arguments for the test
	data.function = a_thread_function;

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
