/* 
  A destroyed attr attributes object can be reinitialized using
  hthread_condattr_init(); the results of otherwise referencing the object after
  it has been destroyed are undefined.
  
  Hardware may be tested in simulation.
  
  Methodology
  1. Initialize a condattr.
  2. Destroy the condattr.
  3. Reinitialize a condattr, check return status.
 */

#include <hthread.h>
#include <stdlib.h>
#include <stdio.h>
#include "hthreadtest.h"

#define EXPECTED_RESULT SUCCESS

void * testThread ( void * arg ) {
	int retVal;
	hthread_condattr_t * condattr = (hthread_condattr_t *) arg;
	
	hthread_condattr_init( condattr );
	hthread_condattr_destroy( condattr );
	retVal = hthread_condattr_init( condattr );
	
	hthread_exit( (void *) retVal );
	return NULL;
}

int main() {
	hthread_t test_thread;
	hthread_attr_t test_attr;
	hthread_condattr_t condattr;
	int arg, retVal;
	
	//Print the name of the test to the screen
	printf( "Starting test condattr_destroy_2\n" );

	//Set up the arguments for the test
	arg = (int) &condattr;
	
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
