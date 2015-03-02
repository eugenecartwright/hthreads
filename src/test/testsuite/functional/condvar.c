#include <hthread.h>
#include <util/rops.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#define HWTI_ZERO_BASEADDR (void*)(0x63000000)
#define HWTI_ONE_BASEADDR (void*)(0x63010000)

struct argument {
	hthread_mutex_t * mutex;
	hthread_cond_t * condvar;
};

void readHWTStatus( void* baseAddr) {
    printf( "  HWT Thread ID %x \n", read_reg(baseAddr) );
    printf( "  HWT Status  %x \n", read_reg(baseAddr + 0x00000008) );
    printf( "  HWT Command %x \n", read_reg(baseAddr + 0x0000000C) );
    printf( "  HWT Argument %x \n", read_reg(baseAddr + 0x00000010) );
    printf( "  HWT Result %x \n", read_reg(baseAddr + 0x00000014) );
    printf( "  HWT Timer %d \n", read_reg(baseAddr + 0x00000004) );
    printf( "  HWT Reg Master Read %x \n", read_reg(baseAddr + 0x00000020) );
    printf( "  HWT Reg Master Write %x \n", read_reg(baseAddr + 0x00000024) );
    printf( "  HWT Stack Pointer %x \n", read_reg(baseAddr + 0x00000028) );
    printf( "  HWT Frame Pointer %x \n", read_reg(baseAddr + 0x0000002C) );
    printf( "  HWT Heap Pointer %x \n", read_reg(baseAddr + 0x00000030) );
}

void * foo( void* arg ) {
	hthread_cond_t * condvar = (hthread_cond_t *) arg;
	hthread_mutex_t mutex;

	hthread_mutex_init( &mutex, NULL );
	hthread_mutex_lock( &mutex );
	printf( "Waiting on condvar\n" );
	hthread_cond_wait( condvar, &mutex );
	printf( "received signal from condvar\n" );
	hthread_mutex_unlock( &mutex );

	hthread_exit(NULL);
	return NULL;
}

int main(int argc, char *argv[]) {
    hthread_cond_t      condvar;
    hthread_mutex_t     mutex;
	hthread_attr_t      threadAttr;
    hthread_t           thread;
	struct argument 	arg;

	hthread_cond_init( &condvar, NULL );
	hthread_mutex_init( &mutex, NULL );

	arg.condvar = &condvar;
	arg.mutex = &mutex;

    //Thread operations
	printf( "Starting thread operations\n" );
	hthread_attr_init( &threadAttr );
	hthread_attr_sethardware( &threadAttr, HWTI_ZERO_BASEADDR );

	printf( "Creating hardware thread\n" );
    hthread_create( &thread, &threadAttr, NULL, &arg );
	readHWTStatus( HWTI_ZERO_BASEADDR );

	printf( "Issuing signal\n" );
	hthread_cond_signal( &condvar );
	readHWTStatus( HWTI_ZERO_BASEADDR );


	hthread_join( thread, NULL );

    printf( " -- End of Program --\n" );

	return 0;
}
