/*   
   The function hthread_join(hthread_t thread, void **value_ptr); shall suspend
   the execution of the calling thread until the target 'thread' terminates,
   unless 'thread' has already terminated.  

   Hardware must be tested on the board.
   
   Methodology
   1. Create a thread that returns the value of a parameter it was passed.
   2. The address of the parameter is incremented after join.
   3. If the parent threads does not resume until after the join, the two values should be unequal.
 */

#include <hthread.h>
#include <stdlib.h>
#include <stdio.h>
#include "hthreadtest.h"

#define EXPECTED_RESULT SUCCESS

struct test_data {
	void * function;
	int value;
	int returnValue;
	hthread_t thread;
};

void * a_thread_function(void * arg) {
	int value;
	
	//Give plenty of oppertunity to context switch
	hthread_yield();
	hthread_yield();
	hthread_yield();
	
	value = *((int *) arg);
	
	hthread_exit((void *) value);
	return NULL;
}

void * testThread ( void * arg ) {
	int retVal;
	struct test_data * data = (struct test_data *) arg;
	
	data->value = 1;
	
	hthread_create( &data->thread, NULL, data->function, (void *) &data->value );
	hthread_join( data->thread, (void *) &data->returnValue );
	
	data->value++;
	
	if ( data->value != data->returnValue ) retVal = SUCCESS;
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
	printf( "Starting test join_1\n" );

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
