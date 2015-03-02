/*   
  If there are threads blocked on the mutex object referenced by 'mutex' when
  hthread_mutex_unlock() is called, resulting in the mutex becoming available,
  the first thread who called lock and had to black, shall receive the mutex.
 */

#include <hthread.h>
#include <stdlib.h>
#include <stdio.h>
#include <mutex/mutex.h>
#include "hthreadtest.h"

#define EXPECTED_RESULT 0

struct test_data {
	void * function;
	hthread_attr_t * attr;
    hthread_cond_t  * cond;
	hthread_mutex_t * mutex;
	hthread_t ownerThread;
	hthread_t firstThread;
	hthread_t secondThread;
	hthread_t thirdThread;
};

void * a_thread_function (void * arg) {
	struct test_data * data = (struct test_data *) arg;
	
	printf( "Thread %d is starting\n", (int)hthread_self() );
	//Try to lock the mutex
	hthread_mutex_lock( data->mutex );
	hthread_cond_signal( data->cond );
	
	printf( "Thread %d has locked the mutex\n", (int)hthread_self() );
	//If we get the lock, mark it in the ownerThread
	data->ownerThread = hthread_self();
	
	//Spin
	while(1) hthread_yield();
	
	hthread_mutex_unlock( data->mutex );
	
	return NULL;
}

void * testThread ( void * arg ) {
	int retVal;
	struct test_data * data = (struct test_data *) arg;
	
	//Lock the mutex
	hthread_mutex_lock( data->mutex );
	
	//Create three threads
	printf( "Creating firstThread\n" );
	hthread_create( &data->firstThread, data->attr, data->function, arg );
	
	printf( "Creating secondThread\n" );	
	hthread_create( &data->secondThread, data->attr, data->function, arg );
	
	printf( "Creating thirdThread\n" );
	hthread_create( &data->thirdThread, data->attr, data->function, arg );
	
	printf( "Unlocking mutex\n" );
	//Unlock the mutex, yield, and check that the owner is firstThread
	hthread_cond_wait( data->cond, data->mutex );
	
	printf( "Checking thread status\n" );
	if ( data->ownerThread == data->firstThread ) retVal = SUCCESS;
	else retVal = FAILURE;
	
	hthread_mutex_unlock( data->mutex );
	
	printf( "Returning\n" );
	hthread_exit( (void *) retVal );
	return NULL;
}

int main() {
	hthread_t test_thread;
	hthread_attr_t test_attr;
	//hthread_t t1, t2, t3, ot;
	hthread_mutex_t mutex;
	hthread_attr_t attr;
	struct test_data data;
	int arg, retVal;
	
	//Print the name of the test to the screen
	printf( "Starting test mutex_unlock_2\n" );

	//Set up the arguments for the test
	hthread_mutex_init( &mutex, NULL );
	hthread_attr_init( &attr );
    hthread_attr_setdetachstate( &attr, HTHREAD_CREATE_DETACHED );
	data.mutex = &mutex;
	//data.firstThread = t1;
	//data.secondThread = t2;
	//data.thirdThread = t3;
	//data.ownerThread = ot;
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
