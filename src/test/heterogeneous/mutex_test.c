/*   
  The function hthread_mutex_lock(hthread_mutex_t *mutex) locks the mutex object
  referenced by 'mutex'.  This operation returns with the mutex object
  referenced by 'mutex' in the locked state with the calling thread as its owner.
  
  The original test files are mutex_lock_2.c, mutex_trylock1.c, mutex_trylock2.c
    under the test directory /testsuite/functional/
  
  Methodology
  1. Lock a mutex.
  2. Check that the mutex owner is the calling thread.
  3. Create a child threads that locks the same mutex and tries to update value.
  4. Wait until the child thread has called lock.
  5. Check that the value has not been updated yet.
  6. Unlock the mutex and exit.

  7. Create a thread that will attempt to lock an already-locked mutex
      by calling trylock().
  8. Confirm that the child thread does not own the mutex.
  9. Create a thread that will attempt to lock a mutex
      by calling trylock().
  10. Confirm that the child thread does own the mutex.

  Error Codes: A return value of anything but 0 means the test has failed
  2: Error not returned when setting the number of the mutex to be over the supported number
  3: Error not returned when setting the type of the mutex to be an invalid integer
  4: The thread testThread that locked the mutex does not own the mutex
  5: Child thread mutex_attempt has run past the mutex owned by testThread
  6: testLocked thread owns the mutex locked by the main thread
  7: testUnlocked thread does not own the mutex after a trylock()
  8: An error was recieved when trying to create a thread
  9: An error was recieved upon joining a thread

  -Juan
 */

#include <hthread.h>
#include <stdlib.h>
#include <stdio.h>
#include <mutex/mutex.h>
#include <mutex/hardware.h>

#define NUM_THREADS 100

struct test_data {
	void * function;
	hthread_mutex_t * mutex;
	hthread_t owner;
	hthread_t thread;
	int retVal[2];
	int incrementVal;
};

//A thread to test that after using trylock on an owned mutex
//	this thread does not own it
void * testLocked ( void * arg ) {
	int retVal;
	hthread_mutex_t * mutex = (hthread_mutex_t *) arg;
	
	//Try to lock a locked mutex
	hthread_mutex_trylock( mutex );

	//Test that another thread owns the mutex	
	if ( _mutex_owner( mutex->num ) != hthread_self() )
		retVal = SUCCESS;
	else 
		retVal = FAILURE;
	
	hthread_exit( (void *) retVal );
	return NULL;
}

//A thread to test that after using trylock on an unowned mutex
//	this thread now owns it
void * testUnlocked ( void * arg ) {
	int retVal;
	hthread_mutex_t * mutex = (hthread_mutex_t *) arg;
	
	//Test that after trylock returns, on an unlocked mutex, the calling thread owns the mutex
	hthread_mutex_trylock( mutex );
	
	if ( _mutex_owner( mutex->num ) == hthread_self() )
		retVal = SUCCESS;
	else 
		retVal = FAILURE;
	
	hthread_mutex_unlock( mutex );
	
	hthread_exit( (void *) retVal );
	return NULL;
}


//A detached thread that tries to lock a mutex
void * mutex_attempt (void * arg) {
	struct test_data * data = (struct test_data *) arg;
	
	//Try to lock the mutex
	hthread_mutex_lock( data->mutex );
	data->incrementVal += 1;
	hthread_mutex_unlock( data->mutex );
	
	hthread_exit( NULL );
	return NULL;
}

void * testThread ( void * arg ) {
	int i;
	struct test_data * data = (struct test_data *) arg;
	hthread_mutex_t * mutex = data->mutex;
	
	//Test that after lock returns, the calling thread owns the mutex
	hthread_mutex_lock( mutex );
	
	if ( _mutex_owner( mutex->num ) == hthread_self() )
		data->retVal[0] = SUCCESS;
	else 
		data->retVal[0] = FAILURE;
	
	//Create a child thread that will try to lock the mutex
	hthread_create( &data->thread, NULL, data->function, arg );
	
	//Give the child thread lots of oppertunity to run
	for( i=0; i<1000; i++ ) hthread_yield();

	//Ensure child has not updated the value
	data->retVal[1] = data->incrementVal;

	hthread_mutex_unlock( mutex );
	
	return 0;
}

#ifndef HETERO_COMPILATION
#include "mutex_test_prog.h"
#include <hthread.h>
#endif


#ifdef HETERO_COMPILATION
int main()
{
    return 0;
}
#else

int main() {
	hthread_t test_thread[NUM_THREADS];
	hthread_attr_t test_attr;
	hthread_mutexattr_t test_mtx_attr;
	hthread_mutex_t try_mutex;
	hthread_mutex_t mutex[NUM_THREADS];

	int i;
	int success_num = 0;
	struct test_data data[NUM_THREADS];
	int retLocked[NUM_THREADS], retUnlocked[NUM_THREADS];
	Hint mutex_return;

	hthread_attr_init(&test_attr);

	//Try to set number over maximum available mutexes
	for(i = HT_SEM_MAXNUM+1; i < HT_SEM_MAXNUM + 10; i++)
	{
		hthread_mutexattr_init(&test_mtx_attr);
		mutex_return = hthread_mutexattr_setnum(&test_mtx_attr, i);
		if(mutex_return != EINVAL)
		{
			/****************************************************
			* Here the test fails when setting number of mutexes
			****************************************************/
			printf("2\nEND\n");
			return 1;
		}
	}

	//Try to set an invalid type
	mutex_return = hthread_mutexattr_settype(&test_mtx_attr, 60);
	if(mutex_return != EINVAL)
	{
		/****************************************************
		* Here the test fails when setting mutex type
		****************************************************/
		printf("3\nEND\n");
		return 1;
	}


	//Set up the arguments for the tests
	hthread_mutex_init(&try_mutex, NULL);

	for(i = 0; i < NUM_THREADS; i++)
	{
		hthread_mutex_init( &mutex[i], NULL );
		data[i].mutex = &mutex[i];
		data[i].function = mutex_attempt;
		data[i].incrementVal = 0;
	}

	int return_err;
	//Run the tests
	hthread_attr_init( &test_attr );

	for(i = 0; i < NUM_THREADS; i++)
	{
		return_err = hthread_create( &test_thread[i], &test_attr, testThread, (void *) &data[i] );
		if(return_err)
		{
			printf("8\nEND\n");
			return 1;
		}
	}

	for(i = 0; i < NUM_THREADS; i++)
	{
  		return_err = hthread_join( test_thread[i], NULL );
		if(return_err)
		{
			printf("9\nEND\n");
			return 1;
		}
	}

	//Evaluate the results
	for(i = 0; i < NUM_THREADS; i++)
	{
		//Expected thread to own mutex and none of its children to have incremented the value
		if ( data[i].retVal[0] != SUCCESS ) {
			/****************************************************
			* Here the test fails when the parent thread did not own the mutex
			****************************************************/
			printf("4\nEND\n");
			return 0;
		}
		if( data[i].retVal[1] != 0 ) {
			/****************************************************
			* Here the test fails because a child got past the locked mutex
			****************************************************/
			printf("5\nEND\n");
			return 0;
		}
	}

	//Run tests on locked mutex
	hthread_mutex_lock(&try_mutex);

	for(i = 0; i < NUM_THREADS; i++)
	{
	    return_err = hthread_create( &test_thread[i], &test_attr, testLocked, (void *) &try_mutex );
		if(return_err)
		{
			printf("8\nEND\n");
			hthread_mutex_unlock( &mutex );
			return 1;
		}
	}
	for(i = 0; i < NUM_THREADS; i++)
	{
	    return_err = hthread_join( test_thread[i], (void *) &retLocked[i] );
		if(return_err)
		{
			printf("9\nEND\n");
			hthread_mutex_unlock( &mutex );
			return 1;
		}
	}
	hthread_mutex_unlock( &try_mutex );
	
	//Run tests on unlocked mutex
	for(i = 0; i < NUM_THREADS; i++)
	{
	    hthread_create( &test_thread[i], &test_attr, testUnlocked, (void *) &try_mutex );
		if(return_err)
		{
			printf("8\nEND\n");
			return 1;
		}
	}
	for(i = 0; i < NUM_THREADS; i++)
	{
	    hthread_join( test_thread[i], (void *) &retUnlocked[i] );
		if(return_err)
		{
			printf("9\nEND\n");
			return 1;
		}
	}

	//Evaluate the results
	for(i = 0; i < NUM_THREADS; i++)
	{
		if ( retLocked[i] != SUCCESS ) {
			/****************************************************
			* Here the test fails because the child thread got the mutex
			****************************************************/
			printf("6\nEND\n");
			return 1;
		}
		if ( retUnlocked[i] != SUCCESS ) {
			/****************************************************
			* Here the test fails because the child thread did not own the mutex
			****************************************************/
			printf("7\nEND\n");
			return 1;
		}
	}

	printf("0\nEND\n");
	return 0;

}

#endif
