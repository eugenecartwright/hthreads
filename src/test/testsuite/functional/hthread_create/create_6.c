/*   
   If the 'start_routine' returns, the effect shall be as if there was an
  implicit call to hthread_exit() using the return value of 'start_routine'
  as the exit status.

   Hardware must be tested on the board
 */

#include <hthread.h>
#include <stdlib.h>
#include <stdio.h>
#include "hthreadtest.h"

#define EXPECTED_RESULT SUCCESS

#define ARGUMENT_VALUE 31

struct test_data {
	void * function1;
	void * function2;
	hthread_t thread1;
	hthread_t thread2;
	int childVal1;
	int childVal2;
};

void * a_thread_function(void * arg) {
	hthread_exit( arg );
	return NULL;
}

void * b_thread_function(void * arg) {	
	return arg;
}

void * testThread ( void * arg ) {
	int retVal;
	struct test_data * data = (struct test_data *) arg;
	
	hthread_create( &data->thread1, NULL, data->function1, (void *) ARGUMENT_VALUE );
	hthread_create( &data->thread2, NULL, data->function2, (void *) ARGUMENT_VALUE );
	hthread_join( data->thread1, (void *) &data->childVal1 );
	hthread_join( data->thread2, (void *) &data->childVal2 );
	
	if ( data->childVal1 == data->childVal2 )  retVal = SUCCESS;
	else retVal = FAILURE;
	
	hthread_exit( (void *) retVal );
	return NULL;
}

int main() {
	hthread_t test_thread;
	hthread_attr_t test_attr;
	int arg, retVal;
	struct test_data data;
	
	//Print the name of the test to the screen
	printf( "Starting test create_6\n" );

	//Set up the arguments for the test
	data.function1 = a_thread_function;
	data.function2 = b_thread_function;
	
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
