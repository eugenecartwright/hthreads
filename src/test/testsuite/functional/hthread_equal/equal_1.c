/*   
   The function hthread_equal(hthread_t t1, hthread_t t2) compares the thread
   ids t1 and t2.  It returns a non-zero value if t1 and t2 are equal.
   
   Hardware may be tested in simulation.
   
   Methodology
   1. Check the return value of hthread_equal, passing in two equal thread_t values.
   2. Note that thread_t is an enumerated int.
 */

#include <hthread.h>
#include <stdlib.h>
#include <stdio.h>
#include "hthreadtest.h"

#define EXPECTED_RESULT SUCCESS

#define FIRST_THREAD 5
#define SECOND_THREAD 5

void * testThread ( void * arg ) {
	int retVal;
	
	if(hthread_equal( hthread_self(), *((hthread_t*)arg))!=0) retVal = SUCCESS;
	else retVal = FAILURE;
	
	hthread_exit( (void *) retVal );
	return NULL;
}

int main() {
	hthread_t test_thread;
	hthread_attr_t test_attr;
	int retVal;
	
	//Print the name of the test to the screen
	printf( "Starting test equal_1\n" );

	//Set up the arguments for the test
	
	//Initialize RPC
	rpc_setup();
	
	//Run the tests
	hthread_attr_init( &test_attr );
	if ( HARDWARE ) hthread_attr_sethardware( &test_attr, HWTI_ONE_BASEADDR );
	hthread_create( &test_thread, &test_attr, testThread, (void *)&test_thread );
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
