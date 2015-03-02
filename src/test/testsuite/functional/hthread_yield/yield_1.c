/*   
  hthread_yield will return SUCCESS
 */

#include <hthread.h>
#include <stdlib.h>
#include <stdio.h>
#include "hthreadtest.h"

#define EXPECTED_RESULT SUCCESS

void * testThread ( void * arg ) {
	int retVal;

	retVal = hthread_yield();
	
	hthread_exit( (void *) retVal );
	return NULL;
}

int main() {
	hthread_t test_thread;
	int arg, retVal;
	
	//Print the name of the test to the screen
	printf( "Starting test yield_1\n" );

	//Set up the arguments for the test
	arg = (int) NULL;
	
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
