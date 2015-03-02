/*   
  The function hthread_cond_wait(); shall block on a condition variable. It
  shall be called with mutex locked by the calling thread or undefined behavior
  results.
 
  Hardware must be tested on the board
  
  Methodology
  1. Create a thread that waits on a condition variable
  2. Check that the child thread is waiting after the cooresponding mutex is unlocked
  3. If successful, the child thread should not have been able to increment waken_num
 */

#include <hthread.h>
#include <stdlib.h>
#include <stdio.h>
#include "hthreadtest.h"

#define EXPECTED_RESULT 0

struct test_data {
	hthread_mutex_t * mutex;
	hthread_cond_t  * cond;
	int * start_num;
	int * waken_num;
	void * function;
	hthread_t thread;
};

void * a_thread_function(void * arg) {
	struct test_data * data = (struct test_data *) arg;
	
	hthread_mutex_lock( data->mutex );
	*(data->start_num) += 1;
	hthread_cond_wait( data->cond, data->mutex );
	*(data->waken_num) += 1;
	hthread_mutex_unlock( data->mutex);
	return NULL;
}

void * testThread ( void * arg ) {
	int retVal;
	struct test_data * data = (struct test_data *) arg;

	hthread_create( &data->thread, NULL, data->function, (void *) data );
	while( *(data->start_num) != 1 ) hthread_yield();
	hthread_mutex_lock( data->mutex );
	retVal = *(data->waken_num);
	hthread_cond_signal( data->cond );
	hthread_mutex_unlock( data->mutex );
	hthread_join( data->thread, NULL );
	
	hthread_exit( (void *) retVal );
	return NULL;
}

int main() {
	hthread_t test_thread;
	hthread_attr_t test_attr;
	int arg, retVal, start_num, waken_num;
	struct test_data data;
	hthread_mutex_t mutex;
	hthread_cond_t cond;
	
	//Print the name of the test to the screen
	printf( "Starting test cond_wait_1\n" );

	//Set up the arguments for the test
	hthread_cond_init( &cond, NULL );
	hthread_mutex_init( &mutex, NULL );
	start_num = 0;
	waken_num = 0;
	
	data.mutex = &mutex;
	data.cond = &cond;
	data.start_num = &start_num;
	data.waken_num = &waken_num;
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
