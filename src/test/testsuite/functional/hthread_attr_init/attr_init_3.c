/*   

  A single attributes object can be used in multiple simultaneous calls to
  hthread_create(). 
  
  Methodology:
  1.  Initialize a hthread_attr_t object using hthread_attr_init()
  2.  Create many threads using the same attribute object.
  
  Hardware must be tested on the board.
 */

#include <hthread.h>
#include <stdlib.h>
#include <stdio.h>
#include "hthreadtest.h"

#define NUM_THREADS	5

#define EXPECTED_RESULT SUCCESS

struct test_data {
	hthread_attr_t * attr;
	void * function;
	hthread_t thread[NUM_THREADS];
};

void * a_thread_function(void *arg) {
	printf( "Thread %d Running!\n", (int)hthread_self() );
	hthread_exit(NULL);
	return NULL;
}

void * testThread ( void * arg ) {
	int retVal, i;
	struct test_data * data = (struct test_data *) arg;
	
	hthread_attr_init( data->attr );
	
	for( i=0; i<NUM_THREADS; i++ )
	    hthread_create( &data->thread[i], data->attr, data->function, NULL );
	for( i=0; i<NUM_THREADS; i++ )
    	retVal = hthread_join( data->thread[i], NULL );
	
	hthread_exit( (void *) retVal );
	return NULL;
}

int main() {
	hthread_attr_t test_attr;
	hthread_t test_thread;
	hthread_attr_t attr;
	struct test_data data;
	int arg, retVal;
	
	//Print the name of the test to the screen
	printf( "Starting test attr_init_3\n" );

	retVal = 1234;
	
	//Set up the arguments for the test
	data.attr = &attr;
	data.function = a_thread_function;

	arg = (int) &data;
	
	//Initialize RPC
	rpc_setup();
	
	//Run the tests
	hthread_attr_init( &test_attr );
	if ( HARDWARE ) hthread_attr_sethardware( &test_attr, HWTI_ONE_BASEADDR );
	hthread_create( &test_thread, &test_attr, testThread, (void *) arg );
	hthread_join( test_thread, (void *) &retVal );

	readHWTStatus( HWTI_ONE_BASEADDR );
	
	//Evaluate the results
	if ( retVal == EXPECTED_RESULT ) {
		printf("Test PASSED\n");
		return PTS_PASS;
	} else {
		printf("Test FAILED [expecting %d, received%d]\n", EXPECTED_RESULT, retVal );
		return PTS_FAIL;
	}
}
