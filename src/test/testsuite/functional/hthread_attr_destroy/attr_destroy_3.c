/*   
  Upon successful completion, hthread_attr_destroy() shall return a value of 0.

  Hardware will be tested in simulation
  
  Methodology:
  -> Initialize an attribute
  -> Destroy the attribute, and check the return value
 */

#include <hthread.h>
#include <stdlib.h>
#include <stdio.h>
#include "hthreadtest.h"

#define EXPECTED_RESULT SUCCESS

void * testThread ( void * arg ) {
	int retVal;
	hthread_attr_t * attr = (hthread_attr_t *) arg;
	
	hthread_attr_init( attr );
	retVal = hthread_attr_destroy( attr );
	
	hthread_exit( (void *) retVal );
	return NULL;
}

int main() {
	hthread_attr_t test_attr;
	hthread_t test_thread;
	hthread_attr_t attr;
	int arg, retVal;
	
	//Print the name of the test to the screen
	printf( "Starting test attr_destroy_3\n" );

	//Set up the arguments for the test
	
	arg = (int) &attr;
	//Run the tests
	hthread_attr_init( &test_attr );
	hthread_create( &test_thread, &test_attr, testThread, (void *) arg );
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
