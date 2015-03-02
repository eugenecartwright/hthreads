/*   
  The function hthread_cond_init() shall initialize the condition variable
  referenced by cond with attributes referenced by attr.  Upon successful
  initialization, the state of the condition variable shall become initialized.
  Since there is only one element in a cond variable, only the cond number is
  tested.
  
  Hardware may be tested in simulation
  
  Methodology
  1.  Initialize a hthread_cond_t object using preinitialized condattr
  2.  Check that the cond number is what was set in the condattr 
 */

#include <hthread.h>
#include <stdlib.h>
#include <stdio.h>
#include "hthreadtest.h"

#define CONDNUMBER 4
#define EXPECTED_RESULT CONDNUMBER

struct test_data {
	hthread_cond_t * cond;
	hthread_condattr_t * cond_attr;
};

void * testThread ( void * arg ) {
	int retVal;
	struct test_data * data = (struct test_data *) arg;

	hthread_cond_init( data->cond, data->cond_attr );
    retVal = hthread_cond_getnum( data->cond );
	
	hthread_exit( (void *) retVal );
	return NULL;
}

int main() {
	hthread_t test_thread;
	hthread_attr_t test_attr;
	hthread_cond_t cond;
	hthread_condattr_t cond_attr;
	struct test_data data;
	int arg, retVal;
	
	//Print the name of the test to the screen
	printf( "Starting test cond_init_1\n" );

	//Set up the arguments for the test
	hthread_condattr_init( &cond_attr );
	hthread_condattr_setnum( &cond_attr, CONDNUMBER );
	
	data.cond = & cond;
	data.cond_attr = & cond_attr;
	
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

