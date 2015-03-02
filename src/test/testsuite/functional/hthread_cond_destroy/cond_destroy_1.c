/* 
  Test that a condition variable destroyed by hthread_cond_destroy()
  can be reinitialized. 

  Hardware may be tested in simulation
  
  Methodology
  1. Initialize a condvar
  2. Destroy a condvar
  3. Reinitialize the same condvar, check return status
 */

#include <hthread.h>
#include <stdlib.h>
#include <stdio.h>
#include "hthreadtest.h"

#define EXPECTED_RESULT SUCCESS

void * testThread ( void * arg ) {
	int retVal;
	hthread_cond_t * cond = (hthread_cond_t *) arg;
	
	hthread_cond_init( cond, NULL );
	hthread_cond_destroy( cond );
	retVal = hthread_cond_init( cond, NULL );
	
	hthread_exit( (void *) retVal );
	return NULL;
}

int main() {
	hthread_t test_thread;
	hthread_attr_t test_attr;
	hthread_cond_t cond;
	int arg, retVal;
	
	//Print the name of the test to the screen
	printf( "Starting test cond_destroy_1\n" );

	//Set up the arguments for the test
	arg = (int) &cond;
	
	//Run the tests
	hthread_attr_init( &test_attr );
	if ( HARDWARE ) hthread_attr_sethardware( &test_attr, HWTI_ONE_BASEADDR );
	hthread_create( &test_thread, &test_attr, testThread, (void *) arg );
	hthread_join( test_thread, (void *) &retVal );

	//Evaluate the results
	if ( retVal == EXPECTED_RESULT ) {
		printf("Test PASSED\n");
		return PTS_PASS;
	} else {
		printf("Test FAILED [expecting %d, received %d]\n", EXPECTED_RESULT, retVal );
		return PTS_FAIL;
	}
}
