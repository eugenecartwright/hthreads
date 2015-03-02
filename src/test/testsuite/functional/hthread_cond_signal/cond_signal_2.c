/*   
  When each thread unblocked as a result of a hthread_cond_signal() returns from
  its call to hthread_cond_wait(), the thread shall own the mutex with which it
  called hthread_cond_wait().

  Hardware must be tested on the board
  
  Methodology:
  1. Create a number of detached threads, each waiting on a cond var
  2. Signal the condvar
  3. Exactly one thread should wake up from the signal, test that it owns the mutex.
 */

#include <hthread.h>
#include <stdlib.h>
#include <stdio.h>
#include <mutex/mutex.h>
#include "hthreadtest.h"

#define THREAD_NUM  3

#define EXPECTED_RESULT 1

struct test_data {
	hthread_mutex_t * mutex;
	hthread_cond_t  * cond;
	int * start_num;
	int * havelock_num;
	void * function;
	hthread_attr_t * attr;
	hthread_t thread[THREAD_NUM];
};

void * a_thread_function(void * arg) {
	struct test_data * data = (struct test_data *) arg;
	
	printf( "Thread %d Running\n", (int)hthread_self() );
	
	hthread_mutex_lock( data->mutex );
	*(data->start_num) += 1;
	hthread_cond_wait( data->cond, data->mutex );
	if ( _mutex_owner( data->mutex->num ) == hthread_self() )
		*(data->havelock_num) += 1;
	hthread_mutex_unlock( data->mutex);
	return NULL;
}

void * testThread ( void * arg ) {
	int retVal, i;
	struct test_data * data = (struct test_data *) arg;

	//Create the threads
	for( i=0; i<THREAD_NUM; i++ )	
		hthread_create( &data->thread[i], data->attr, data->function, (void *) data );
	while( *(data->start_num) != THREAD_NUM ) hthread_yield();
	hthread_mutex_lock( data->mutex );
	hthread_cond_signal( data->cond );
	hthread_mutex_unlock( data->mutex );
	while( *(data->havelock_num) == 0 ) hthread_yield();
	
	retVal = *(data->havelock_num);
	
	hthread_exit( (void *) retVal );
	return NULL;
}

int main() {
	hthread_t test_thread;
	hthread_attr_t test_attr;
	int arg, retVal, start_num, havelock_num;
	struct test_data data;
	hthread_mutex_t mutex;
	hthread_cond_t cond;
	hthread_attr_t attr;
	
	//Print the name of the test to the screen
	printf( "Starting test cond_signal_2\n" );

	//Set up the arguments for the test
	hthread_cond_init( &cond, NULL );
	hthread_mutex_init( &mutex, NULL );
	hthread_attr_init( &attr );
    hthread_attr_setdetachstate( &attr, HTHREAD_CREATE_DETACHED );
	start_num = 0;
	havelock_num = 0;
	
	data.mutex = &mutex;
	data.cond = &cond;
	data.start_num = &start_num;
	data.havelock_num = &havelock_num;
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
