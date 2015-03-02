/*   
 * This file is a stress test for the hthread_mutex_lock function.

 * The steps are:
 * -> Create some mutexes, lock them
 * -> Create some threads that try to lock one of the mutexes
 * -> Unlock the mutexes
 * -> Make sure each thread gets the lock and exits
 */

#include <hthread.h>
#include <stdlib.h>
#include <stdio.h>

#define NUMBER_OF_MUTEXES 8
#define NUMBER_OF_THREADS 50

void * testThread ( void * arg ) {
	hthread_mutex_t * mutex = (hthread_mutex_t *) arg;
	
	printf( "Thread %d locking mutex %d\n", (int)hthread_self(), hthread_mutex_getnum(mutex) );
	hthread_mutex_lock( mutex );
	hthread_yield();
	printf( "Thread %d unlocking mutex %d\n", (int)hthread_self(), hthread_mutex_getnum(mutex) );
	hthread_mutex_unlock( mutex );
	
	//Exit
	hthread_exit( NULL );
	return NULL;
}

int main() {
	hthread_t test_thread[NUMBER_OF_THREADS];
	hthread_mutex_t mutex[NUMBER_OF_MUTEXES];
	hthread_mutexattr_t attr;
	int arg, retVal, i;
	
	//Print the name of the test to the screen
	printf( "Starting test mutex_lock_stress_1\n" );

	//Set up the arguments for the test
	for ( i=0; i<NUMBER_OF_MUTEXES; i++ ) {
		hthread_mutexattr_init( &attr );
		hthread_mutexattr_setnum( &attr, i );
		hthread_mutex_init( &mutex[i], &attr );
		hthread_mutex_lock( &mutex[i] );
	}
	
	printf( "Creating all threads\n" );
	//Create the tests
	for ( i=0; i<NUMBER_OF_THREADS; i++ ) {
		arg = (int) &mutex[i % NUMBER_OF_MUTEXES];
		hthread_create( &test_thread[i], NULL, testThread, (void *) arg );
	}
	
	//Unlock the mutexes
	for ( i=0; i<NUMBER_OF_MUTEXES; i++ ) {
		printf( "Thread %d unlocking mutex %d\n", (int)hthread_self(), hthread_mutex_getnum(&mutex[i]) );
		hthread_mutex_unlock( &mutex[i] );
		hthread_yield();
	}
	
	printf( "Joining all threads\n" );
	//Join on the tests
	for ( i=0; i<NUMBER_OF_THREADS; i++ )
		hthread_join( test_thread[i], (void *) &retVal );

	//If all threads joined, then test was successful
	printf( "Number of Mutexes: %d\n", NUMBER_OF_MUTEXES );
	printf( "Number of Threads: %d\n", NUMBER_OF_THREADS );
	printf( "Test PASSED\n" );

	return 1;
}
