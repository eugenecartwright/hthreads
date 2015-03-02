/*   
  The function hthread_cond_init() shall initialize the condition variable
  referenced by cond with attributeds referenced by attr.  If attr is NULL, then
  default attributes will be assigned.

  Hardware may be tested in simulation
  
  Methodology:
  1.  Initialize a hthread_cond_t object using preinitialized condattr
  2.  Test that the cond number is the default 
 */

#include <hthread.h>
#include <stdlib.h>
#include <stdio.h>
#include "hthreadtest.h"

#define EXPECTED_RESULT 0

void * testThread ( void * arg ) {
	int retVal;
	hthread_cond_t * cond = (hthread_cond_t *) arg;
	
	hthread_cond_init( cond, NULL );
    retVal = hthread_cond_getnum( cond );
	
	hthread_exit( (void *) retVal );
	return NULL;
}

int main() {
	hthread_t test_thread;
	hthread_attr_t test_attr;
	hthread_cond_t cond;
	int arg, retVal;
	
	//Print the name of the test to the screen
	printf( "Starting test cond_init_2\n" );

	//Set up the arguments for the test
	arg = (int) &cond;
	
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

