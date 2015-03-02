/*   
  Test that hthread_attr_init() shall initialize a thread attributes object
  'attr' with the default value for all the individual attributes used by a
  given implementation.

  NOTE: Since most default values are implementation specific, only the
  detached elemente member will be tested since the default value
  is defined in the spec.
 
  Hardware must be tested on the board
  
  Steps:
  -> Initialize a hthread_attr_t object using hthread_attr_init()
  -> Create a thread using the new attribute
  -> Join on the created thread, if join returns success, then the new thread
     was not detached.
 */

#include <hthread.h>
#include <stdlib.h>
#include <stdio.h>
#include "hthreadtest.h"

#define EXPECTED_RESULT SUCCESS

struct test_data {
	hthread_attr_t * attr;
	void * function;
	hthread_t thread;
};

void * a_thread_function(void *arg) {
	printf( "Thread running! %d\n", (int)hthread_self() );
	hthread_exit(NULL);
	return NULL;
}

void * testThread ( void * arg ) {
	int retVal;
	struct test_data * data = (struct test_data *) arg;
	
	printf( "testThread running\n" );
	hthread_attr_init( data->attr );
	hthread_create( &data->thread, data->attr, data->function, NULL );
	retVal = hthread_join( data->thread, NULL );
	
	hthread_exit( (void *) retVal );
	return NULL;
}

int main() {
	hthread_attr_t test_attr;
	hthread_t test_thread;
	hthread_attr_t attr;
	struct test_data data;
	int arg, retVal;
	
	//Print the name of the test to the screen
	printf( "Starting test attr_init_2\n" );

	//Set up the arguments for the test
	data.attr = &attr;
	data.function = a_thread_function;

	arg = (int) &data;
	
	readHWTStatus( HWTI_ZERO_BASEADDR );
	
	//Initialize RPC
	rpc_setup();
	
	//Run the tests
	hthread_attr_init( &test_attr );
	if ( HARDWARE ) hthread_attr_sethardware( &test_attr, HWTI_ZERO_BASEADDR );
	hthread_create( &test_thread, &test_attr, testThread, (void *) arg );
	hthread_join( test_thread, (void *) &retVal );

	readHWTStatus( HWTI_ZERO_BASEADDR );
	
	//Evaluate the results
	if ( retVal == EXPECTED_RESULT ) {
		printf("Test PASSED\n");
		return PTS_PASS;
	} else {
		printf("Test FAILED [expecting %d, received %x]\n", EXPECTED_RESULT, retVal );
		return PTS_FAIL;
	}
}

