#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <hthread.h>

#define LOG_SERIAL 1
#include <log/log.h>

#define HWTI_ZERO_BASEADDR (void*)(0x63000000)
#define HWTI_ONE_BASEADDR (void*)(0x63010000)

void readHWTStatus( void* baseAddr) {
    printf( "  HWT Thread ID %x \n", read_reg(baseAddr) );
    printf( "  HWT Status  %x \n", read_reg(baseAddr + 0x00000008) );
    printf( "  HWT Command %x \n", read_reg(baseAddr + 0x0000000C) );
    printf( "  HWT Argument %x \n", read_reg(baseAddr + 0x00000010) );
    printf( "  HWT Result %x \n", read_reg(baseAddr + 0x00000014) );
    printf( "  HWT Timer %d \n", read_reg(baseAddr + 0x00000004) );
}

void * foo( void* arg ) {
	hthread_exit(NULL);
	return NULL;
}

int main(int argc, char *argv[]) {
    hthread_mutexattr_t mutexAttr;
    hthread_mutex_t     mutex;
	hthread_attr_t      threadAttr;
    hthread_t           thread;
	Huint               arg;
	log_t               log;

    //Initialize Log
	log_create( &log, 1024 );

	//Mutex operations
	printf( "Starting mutex operations\n" );
	hthread_mutexattr_init( &mutexAttr );
	hthread_mutexattr_setnum( &mutexAttr, 0 );
	hthread_mutexattr_getnum( &mutexAttr, &arg );
	hthread_mutexattr_destroy( &mutexAttr );

    hthread_mutex_init(&mutex, NULL);
	hthread_mutex_lock( &mutex );
	hthread_mutex_unlock( &mutex );

	hthread_mutex_trylock( &mutex );
	hthread_mutex_unlock( &mutex );
	hthread_mutex_destroy( &mutex );

    //Condition Variable operations
	/*
	printf( "Starting condition variable operations\n" );
	hthread_condattr_init( &condvarAttr );
	hthread_condattr_setnum( &condvarAttr, 0 );
	hthread_condattr_getnum( &condvarAttr, &arg );
	hthread_condattr_destroy( &condvarAttr );

	hthread_cond_init( &condvar, NULL );
	hthread_mutex_lock( &mutex );
	hthread_cond_wait( &condvar, &mutex );
	hthread_mutex_unlock( &mutex );
	hthread_cond_signal( &condvar );
	hthread_cond_broadcast( &condvar );
	hthread_cond_destroy( &condvar );
	*/

    //Thread operations
	printf( "Starting thread operations\n" );
	hthread_attr_init( &threadAttr );
    hthread_create( &thread, &threadAttr, foo, &log );
	hthread_attr_destroy( &threadAttr );

	hthread_join( thread, NULL );

    printf( " -- End of Program --\n" );
	log_close_ascii( &log );

	return 0;
}
