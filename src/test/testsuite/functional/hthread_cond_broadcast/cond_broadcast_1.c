/*   
  The function int hthread_cond_broadcast(hthread_cond_t *cond); shall unblock
  all threads, hardware or software, currently blocked on the specified
  condition variable cond.
  
  Hardware must be tested on the board
  
  Methodology
  1. Create a number of threads that will wait on the condvar
  2. Wait until all threads have started
  3. Lock the mutex
  4. Issue a broadcast, all threads should wake up
  5. Check that all threads woke up
 */

#include <hthread.h>
#include <stdlib.h>
#include <stdio.h>
#include "hthreadtest.h"

#define THREAD_NUM  3

#define EXPECTED_RESULT THREAD_NUM

struct testdata {
	hthread_mutex_t * mutex;
	hthread_cond_t  * cond;
	int * start_num;
	int * waken_num;
	void * function;
	hthread_t thread[THREAD_NUM];
};

void * a_thread_function(void * arg) {
	struct testdata * data = (struct testdata *) arg;
	
	printf( "Thread %d Running\n", (int)hthread_self() );
	
	hthread_mutex_lock( data->mutex );
	*(data->start_num) += 1;
	hthread_cond_wait( data->cond, data->mutex );
	*(data->waken_num) += 1;
	hthread_mutex_unlock( data->mutex);
	return NULL;
}

void * testThread ( void * arg ) {
	int retVal, i;
	struct testdata * data = (struct testdata *) arg;

	for( i=0; i<THREAD_NUM; i++ )	
		hthread_create( &data->thread[i], NULL, data->function, (void *) data );
	while( *(data->start_num) != THREAD_NUM ) hthread_yield();
	hthread_mutex_lock( data->mutex );
	hthread_cond_broadcast( data->cond );
	hthread_mutex_unlock( data->mutex );
	for( i=0; i<THREAD_NUM; i++ )	
		hthread_join( data->thread[i], NULL );
	
	retVal = *(data->waken_num);
	
	hthread_exit( (void *) retVal );
	return NULL;
}

int main() {
	hthread_t test_thread;
	hthread_attr_t test_attr;
	int arg, retVal, start_num, waken_num;
	struct testdata data;
	hthread_mutex_t mutex;
	hthread_cond_t cond;
	
	//Print the name of the test to the screen
	printf( "Starting test cond_broadcast_1\n" );

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
