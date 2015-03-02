/*   
  The function hthread_mutex_lock(hthread_mutex_t *mutex) locks the mutex object
  referenced by 'mutex'.  This operation returns with the mutex object
  referenced by 'mutex' in the locked state with the calling thread as its owner.
  
  Hardware may be tested in simulation.
  
  Methodology
  1. Lock a mutex.
  2. Check that the mutex owner is the calling thread.
 */

#include <hthread.h>
#include <stdlib.h>
#include <stdio.h>
#include <mutex/mutex.h>
#include "hthreadtest.h"

#define EXPECTED_RESULT 0

void * testThread ( void * arg ) {
	int retVal;
	hthread_mutex_t * mutex = (hthread_mutex_t *) arg;
	
	//Test that after lock returns, the calling thread owns the mutex
	hthread_mutex_lock( mutex );
	
	if ( _mutex_owner( mutex->num ) == hthread_self() )
		retVal = SUCCESS;
	else 
		retVal = FAILURE;
	
	hthread_mutex_unlock( mutex );
	
	hthread_exit( (void *) retVal );
	return NULL;
}

int main() {
	hthread_t test_thread;
	hthread_attr_t test_attr;
	hthread_mutex_t mutex;
	int arg, retVal;
	
	//Print the name of the test to the screen
	printf( "Starting test mutex_lock_1\n" );

	//Set up the arguments for the test
	hthread_mutex_init( &mutex, NULL );
	
	arg = (int) &mutex;
	
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
