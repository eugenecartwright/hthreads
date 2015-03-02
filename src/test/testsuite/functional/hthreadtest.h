#include <util/rops.h>
#include <math.h>
#include <string.h>
#include <stdio.h>

//Hardware Thread Interface Addresses
#define HWTI_ZERO_BASEADDR (void*)(0x63000000)
#define HWTI_ONE_BASEADDR (void*)(0x63010000)

//Return codes
#define PTS_PASS 0
#define PTS_FAIL 1

//RPC Setup
typedef struct {
	int opcode;
	int result;
	int args[ 5 ];
} rpc_t;

rpc_t           rpc;
hthread_attr_t  rpc_thread_attr;
hthread_t       rpc_thread;
hthread_mutex_t rpc_mutex;
hthread_mutex_t rpc_signal_mutex;
hthread_cond_t  rpc_signal;

void * rpc_software( void* arg ) {
	//printf( "Locking rpc_signal_mutex\n" );
	hthread_mutex_lock( &rpc_signal_mutex );

	while( 1 ) {

		//printf( "Waiting on rpc_signal, RPC TID is %d\n", hthread_self() );
		hthread_cond_wait( &rpc_signal, &rpc_signal_mutex );
		//printf( "Received rpc_signal\n" );
		//fflush( stdout );

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

			case 0x5001:
				rpc.result = printf( "Performing printf\n" );
				break;

			case 0x5002:
				//printf( "Performing cos\n" );
				rpc.result = cos( 10 );
				break;

			case 0x5003:
				//printf( "Performing strcmp\n" );
				rpc.result = strcmp( "ONE", "TWO" );
				break;

			case 0x5004:
				//printf( "Performing null\n" );
				rpc.result = 0;
				break;
		}

		//printf( "RPC address = %x\n", (int) &rpc );
		//printf( " opcode = %x\n", rpc.opcode );
		//printf( " result = %x \n", rpc.result );
		//printf( " args[0] = %x \n", rpc.args[0] );
		//printf( " args[1] = %x \n", rpc.args[1] );
		//printf( " args[2] = %x \n", rpc.args[2] );
		//printf( " args[3] = %x \n", rpc.args[3] );

		//printf( "Signalling rpc_signal, rpc is complete\n" );
		hthread_cond_signal( &rpc_signal );
	}

	//Never get here, but for completness sake ...
	hthread_mutex_unlock( &rpc_signal_mutex );
    return NULL;
}

void rpc_setup() {
	hthread_mutexattr_t mutexAttr;
	hthread_condattr_t condAttr;
	
	//Set up the RPC mutex and condition variables
	hthread_mutexattr_init( &mutexAttr );
	hthread_mutexattr_setnum( &mutexAttr, 7 );
	hthread_mutex_init( &rpc_mutex, &mutexAttr );

	hthread_mutexattr_setnum( &mutexAttr, 8 );
	hthread_mutex_init( &rpc_signal_mutex, &mutexAttr );

	hthread_condattr_init( &condAttr );
	hthread_condattr_setnum( &condAttr, 9 );
	hthread_cond_init( &rpc_signal, &condAttr );
	
	//Set up the RPC Thread
	hthread_attr_init( &rpc_thread_attr );
    hthread_attr_setdetachstate( &rpc_thread_attr, HTHREAD_CREATE_DETACHED );
	hthread_create( &rpc_thread, &rpc_thread_attr, rpc_software, NULL );
	hthread_yield();

	//Notify the HWTI of the RPC setup
    write_reg(HWTI_ZERO_BASEADDR + 0x00000048, 0x00070809 );
    write_reg(HWTI_ZERO_BASEADDR + 0x0000004C, (int) &rpc );
    
    write_reg(HWTI_ONE_BASEADDR + 0x00000048, 0x00070809 );
    write_reg(HWTI_ONE_BASEADDR + 0x0000004C, (int) &rpc );
}

//Debug Hardware
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
