/*   
   hthread_mutex_init, when called with non-NULL attributes, initializes the 
   mutex with values specified in the attributes.
   
   Hardware may be tested in simulation.
   
   Methodology
   1. Initialize a mutex, with mutex_attr_t.
   2. Check that the initialized mutex number, is that of the value set in the attr.
 */

#include <hthread.h>
#include <stdlib.h>
#include <stdio.h>
#include "hthreadtest.h"

#define MUTEX_NUM 5

#define EXPECTED_RESULT MUTEX_NUM

struct testdata {
	hthread_mutex_t * mutex;
	hthread_mutexattr_t * attr;
};

void * testThread ( void * arg ) {
	int retVal;
	struct testdata * data = (struct testdata *) arg;
	
	hthread_mutex_init( data->mutex, data->attr );
	retVal = hthread_mutex_getnum( data->mutex );
	
	hthread_exit( (void *) retVal );
	return NULL;
}

int main() {
	hthread_t test_thread;
	hthread_attr_t test_attr;
	hthread_mutex_t mutex;
	hthread_mutexattr_t attr;
	struct testdata data;
	int arg, retVal;
	
	//Print the name of the test to the screen
	printf( "Starting test mutex_init_2\n" );

	//Set up the arguments for the test
	hthread_mutexattr_init( &attr );
	hthread_mutexattr_setnum( &attr, MUTEX_NUM );
	data.mutex = &mutex;
	data.attr = &attr;
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
