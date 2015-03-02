#include <hthread.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <util/rops.h>

#define HWTI_ZERO_BASEADDR (void*)(0x63000000)
#define HWTI_ONE_BASEADDR (void*)(0x63010000)

typedef struct {
	int opcode;
	int result;
	int args[ 5 ];
} rpc_t;

struct argument {
	hthread_attr_t * attribute;
	void * function;
	void * argument;
};

rpc_t           rpc;
hthread_mutex_t rpc_mutex;
hthread_mutex_t rpc_signal_mutex;
hthread_cond_t  rpc_signal;

void readHWTStatus( void* baseAddr) {
    printf( "  HWT Thread ID %x \n", read_reg(baseAddr) );
    printf( "  HWT Status  %x \n", read_reg(baseAddr + 0x00000008) );
    printf( "  HWT Command %x \n", read_reg(baseAddr + 0x0000000C) );
    printf( "  HWT Argument %x \n", read_reg(baseAddr + 0x00000010) );
    printf( "  HWT Result %x \n", read_reg(baseAddr + 0x00000014) );
    printf( "  HWT Timer %d \n", read_reg(baseAddr + 0x00000004) );
    printf( "  HWT Debug User %x \n", read_reg(baseAddr + 0x0000001C) );
    printf( "  HWT Reg Master Read %x \n", read_reg(baseAddr + 0x00000020) );
    printf( "  HWT Reg Master Write %x \n", read_reg(baseAddr + 0x00000024) );
    printf( "  HWT Stack Pointer %x \n", read_reg(baseAddr + 0x00000028) );
    printf( "  HWT Frame Pointer %x \n", read_reg(baseAddr + 0x0000002C) );
    printf( "  HWT Heap Pointer %x \n", read_reg(baseAddr + 0x00000030) );
    printf( "  HWT RPC Numbers %x \n", read_reg(baseAddr + 0x00000048) );
    printf( "  HWT RPC Struct %x \n", read_reg(baseAddr + 0x0000004C) );
}

void * foo( void* arg ) {
	printf( "Thread %x Created!\n", (int)hthread_self() );
    //printf( "  HWT Debug User %x \n", read_reg(HWTI_ZERO_BASEADDR + 0x0000001C) );
	readHWTStatus( HWTI_ZERO_BASEADDR );

	hthread_exit(NULL);
	return NULL;
}

void * rpc_hardware( int opcode, int args[5] ) {
	int i, result;

	hthread_mutex_lock( &rpc_mutex );

	hthread_mutex_lock( &rpc_signal_mutex );

	rpc.opcode = opcode;
	for( i=0; i<5; i++ ) rpc.args[i] = args[i];

	hthread_cond_signal( &rpc_signal );

	hthread_cond_wait( &rpc_signal, &rpc_signal_mutex );

	result = rpc.result;

	hthread_mutex_unlock( &rpc_signal_mutex );
	hthread_mutex_unlock( &rpc_mutex );

	return (void *) result;
}


void * hardware( void* arg ) {
	int result;
	int args[5];
	hthread_t thread;

	printf( "Calling rpc create\n" );
	args[0] = (int) &thread;
	args[1] = (int) NULL;
	args[2] = (int) foo;
	args[3] = (int) 31;
	args[4] = (int) NULL;
	result = (int) rpc_hardware( 0x8010, args );

	printf( "Calling rpc join\n" );
	args[0] = (int) thread;
	args[1] = (int) NULL;
	args[2] = (int) NULL;
	args[3] = (int) NULL;
	args[4] = (int) NULL;
	result = (int) rpc_hardware( 0x8011, args );

	printf( "Exing hardware thread\n" );
	return (void *) result;
}

void * rpc_software( void* arg ) {
	printf( "Locking rpc_signal_mutex\n" );
	hthread_mutex_lock( &rpc_signal_mutex );

	while( 1 ) {

		printf( "Waiting on rpc_signal\n" );
		hthread_cond_wait( &rpc_signal, &rpc_signal_mutex );

		printf( "RPC opcode = %x \n", rpc.opcode );
		printf( " result = %x \n", rpc.result );
		printf( " args[0] = %x \n", rpc.args[0] );
		printf( " args[1] = %x \n", rpc.args[1] );
		printf( " args[2] = %x \n", rpc.args[2] );
		printf( " args[3] = %x \n", rpc.args[3] );

		switch( rpc.opcode ) {
			case 0x8010:
				printf( "Performing hthread_create\n" );
				rpc.result = hthread_create( (hthread_t *) rpc.args[0],
					(hthread_attr_t *) rpc.args[1],
					(void *) rpc.args[2],
					(void *) rpc.args[3] );
				break;

			case 0x8011:
				printf( "Performing hthread_join\n" );
				rpc.result = hthread_join( (hthread_t) rpc.args[0],
					(void **) rpc.args[1] );
				break;
		}

	    readHWTStatus( HWTI_ZERO_BASEADDR );
		printf( "Signalling rpc_signal, rpc is complete\n" );
		hthread_cond_signal( &rpc_signal );
	}

	//Never get here, but for completness sake ...
	hthread_mutex_unlock( &rpc_signal_mutex );
    return NULL;
}

int main(int argc, char *argv[]) {
	hthread_attr_t      hwAttr, swAttr, rpcAttr;
    hthread_t           hwThread[5], rpcThread;
	hthread_mutexattr_t mutexAttr;
	hthread_condattr_t  condAttr;
	struct argument 	arg;

	printf( "\n\n\n" );

	//Initialize and start RPC
	hthread_mutexattr_init( &mutexAttr );
	hthread_mutexattr_setnum( &mutexAttr, 7 );
	hthread_mutex_init( &rpc_mutex, &mutexAttr );

	hthread_mutexattr_setnum( &mutexAttr, 8 );
	hthread_mutex_init( &rpc_signal_mutex, &mutexAttr );

	hthread_condattr_init( &condAttr );
	hthread_condattr_setnum( &condAttr, 9 );
	hthread_cond_init( &rpc_signal, &condAttr );

	hthread_attr_init( &rpcAttr );
    hthread_attr_setdetachstate( &rpcAttr, HTHREAD_CREATE_DETACHED );
	hthread_create( &rpcThread, &rpcAttr, rpc_software, NULL );
	hthread_yield();

    write_reg(HWTI_ZERO_BASEADDR + 0x00000048, 0x00070809 );
    write_reg(HWTI_ZERO_BASEADDR + 0x0000004C, (int) &rpc );

    //Thread operations
	printf( "Starting thread operations\n" );
	hthread_attr_init( &hwAttr );
	hthread_attr_init( &swAttr );
	hthread_attr_sethardware( &hwAttr, HWTI_ZERO_BASEADDR );

	arg.attribute = &swAttr;
	arg.function = foo;
	arg.argument = NULL;

	//printf( "Creating hardware thread\n" );
    hthread_create( &hwThread[0], &hwAttr, NULL, &arg );
    //hthread_create( &hwThread[0], NULL, hardware, &arg );
    //hthread_create( &hwThread[1], NULL, hardware, &arg );
    //hthread_create( &hwThread[2], NULL, hardware, &arg );
    //hthread_create( &hwThread[3], NULL, hardware, &arg );
    //hthread_create( &hwThread[4], NULL, hardware, &arg );

	//readHWTStatus( HWTI_ZERO_BASEADDR );

	hthread_join( hwThread[0], NULL );
	//hthread_join( hwThread[1], NULL );
	//hthread_join( hwThread[2], NULL );
	//hthread_join( hwThread[3], NULL );
	//hthread_join( hwThread[4], NULL );

	//readHWTStatus( HWTI_ZERO_BASEADDR );

    printf( " -- End of Program --\n" );

	return 0;
}
