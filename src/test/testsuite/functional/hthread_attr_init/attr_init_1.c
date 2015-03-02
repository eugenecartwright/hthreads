/*   
 Test that hthread_attr_init() shall initialize a thread attributes object
 'attr' with the default value for all the individual attributes used by a given
 implementation.

 NOTE: Since most default values are implementation specific, only the attribute
 of the detachstate will be tested since the default value is defined in the
 spec.
 
 Hardware will be tested in simulation
 
 Methodology:
 -> Initialize a hthread_attr_t object using hthread_attr_init()
 -> Using the detached attribute member, test that the default value of the 
    detachstate Hfalse.
 */

#include <hthread.h>
#include <stdlib.h>
#include <stdio.h>
#include "hthreadtest.h"

#define EXPECTED_RESULT Hfalse

void * testThread ( void * arg ) {
	int retVal;
	
	hthread_attr_t * attr = (hthread_attr_t *) arg;
	hthread_attr_init( attr );
    hthread_attr_getdetachstate( attr, &retVal );
	
	hthread_exit( (void *) retVal );
	return NULL;
}

int main() {
	hthread_attr_t test_attr;
	hthread_t test_thread;
	hthread_attr_t attr;
	int arg, retVal;
	
	//Print the name of the test to the screen
	printf( "Starting test attr_init_1\n" );

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

