/*   
   If the attributes specified by 'attr' are modified later after the thread 
   is create, the thread's attributes should not be affected.
   
   Hardware must be tested on the board.
   
   Methodology
   1. Create a child thread with default hthread_attr_t attr.
   2. Update attr, after the child is created, to be detached.
   3. Try to join on the child thread.  Should be able to join, since the attr were modified to be detached after the child thread was created.
 */

#include <hthread.h>
#include <stdlib.h>
#include <stdio.h>
#include "hthreadtest.h"

#define EXPECTED_RESULT SUCCESS

struct testdata {
	void * function;
	hthread_attr_t * attr;
	hthread_t thread;
};

void * a_thread_function(void * arg) {
	return NULL;
}

void * testThread ( void * arg ) {
	int retVal;
	struct testdata * data = (struct testdata *) arg;
	
	hthread_create( &data->thread, data->attr, data->function, NULL );
    hthread_attr_setdetachstate( data->attr, HTHREAD_CREATE_DETACHED );
	retVal = hthread_join( data->thread, NULL );
	
	hthread_exit( (void *) retVal );
	return NULL;
}

int main() {
	hthread_t test_thread;
	hthread_attr_t test_attr;
	hthread_attr_t attr;
	int arg, retVal;
	struct testdata data;
	
	//Print the name of the test to the screen
	printf( "Starting test create_3\n" );

	//Set up the arguments for the test
	hthread_attr_init( &attr );
	
	data.function = a_thread_function;
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
