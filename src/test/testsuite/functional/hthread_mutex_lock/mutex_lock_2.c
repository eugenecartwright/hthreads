/*   
  If the mutex referenced by hthread_mutex_lock is already locked, the calling
  thread will block until the mutex becomes available.  Once returned, the
  calling thread is the owner of the mutex.
  
  Hardware may be tested in simulation.
  
  Methodology
  1. Lock a mutex that protects value.
  2. Create a child threads that locks the same mutex and tries to update value.
  3. Wait until the child thread has called lock.
  4. Check that the value has not been updated yet.
  5. Unlock the mutex and exit.
 */

#include <hthread.h>
#include <stdlib.h>
#include <stdio.h>
#include <mutex/mutex.h>
#include "hthreadtest.h"

#define EXPECTED_RESULT SUCCESS

struct test_data {
	void * function;
	hthread_mutex_t * mutex;
	hthread_t owner;
	hthread_t thread;
};

//A detached thread that tries to lock a mutex
void * a_thread_function (void * arg) {
	struct test_data * data = (struct test_data *) arg;
	
	//Tri to lock the mutex
	hthread_mutex_lock( data->mutex );
	data->owner = _mutex_owner( data->mutex->num );
	hthread_mutex_unlock( data->mutex );
	
	hthread_exit( NULL );
	return NULL;
}

void * testThread ( void * arg ) {
	int retVal, i;
	struct test_data * data = (struct test_data *) arg;
	
	//Lock the mutex
	hthread_mutex_lock( data->mutex );
	
	//Create a detached thread that will try to lock the mutex
	hthread_create( &data->thread, NULL, data->function, arg );

	//Give the child threads lots of oppertunity to run
	for( i=0; i<1000; i++ ) hthread_yield();
	
	//Unlock the mutex
	hthread_mutex_unlock( data->mutex );
	
	//Join on child thread
	hthread_join( data->thread, NULL );
	
	if ( data->owner == data->thread ) retVal = SUCCESS;
	else retVal = FAILURE;
	
	hthread_exit( (void *) retVal );
	return NULL;
}

int main() {
	hthread_t test_thread;
	hthread_attr_t test_attr;
	hthread_mutex_t mutex;
	struct test_data data;
	int arg, retVal;
	
	//Print the name of the test to the screen
	printf( "Starting test mutex_lock_2\n" );

	//Set up the arguments for the test
	data.mutex = &mutex;
	data.function = a_thread_function;
	
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
