/************************************************************************************
* Copyright (c) 2006, University of Kansas - Hybridthreads Group
* All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
* 
*     * Redistributions of source code must retain the above copyright notice,
*       this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright notice,
*       this list of conditions and the following disclaimer in the documentation
*       and/or other materials provided with the distribution.
*     * Neither the name of the University of Kansas nor the name of the
*       Hybridthreads Group nor the names of its contributors may be used to
*       endorse or promote products derived from this software without specific
*       prior written permission.
* 
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
* ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
************************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <hthread.h>
#include <util/rops.h>

#define FIBMAX 7
#define HWTI_BASEADDR (void*)(0x63000000)

//#define LOG_SERIAL 1
//#include <log/log.h>

hthread_mutex_t hwtiMutex;
hthread_mutex_t mutex2;
hthread_mutex_t mutex3;
hthread_mutex_t mutex4;

struct fibonacci {
	volatile Huint fibVal;
	volatile Huint fibNum;
};

void* findFibHWTI(void * arg) {
	struct fibonacci * fib;
	fib = (struct fibonacci *) arg;
	fib->fibVal = 1;

	return NULL;
}

void readHWTStatus() {
printf( "  HWT Thread ID %x \n", read_reg(HWTI_BASEADDR) );
printf( "  HWT Verify %x \n", read_reg(HWTI_BASEADDR + 0x00000400) );
printf( "  HWT Status  %x \n", read_reg(HWTI_BASEADDR + 0x00000800) );
printf( "  HWT Command %x \n", read_reg(HWTI_BASEADDR + 0x00000C00) );
printf( "  HWT Argument %x \n", read_reg(HWTI_BASEADDR + 0x00001000) );
printf( "  HWT Result %x \n", read_reg(HWTI_BASEADDR + 0x00001400) );
printf( "  HWT Reg Master Write %x \n", read_reg(HWTI_BASEADDR + 0x00002400) );
printf( "  HWT DEBUG SYSTEM %x \n", read_reg(HWTI_BASEADDR + 0x00002800) );
printf( "  HWT DEBUG USER %x \n", read_reg(HWTI_BASEADDR + 0x00002C00) );
printf( "  HWT DEBUG CONTROL %x \n", read_reg(HWTI_BASEADDR + 0x00003000) );
}

void resetHWT() {
	write_reg(HWTI_BASEADDR + 0x00000C00, 2);
}

void* findFibonacci(void * arg) {
	hthread_attr_t attrBase;
	hthread_t threadBase;
	hthread_t threadOne;
	hthread_t threadTwo;
	struct fibonacci * fib;
	struct fibonacci fibOne;
	struct fibonacci fibTwo;
    
	fib = (struct fibonacci *) arg;
    
	if (fib->fibNum == 0 || fib->fibNum == 1) {
		//Set up the attr for a HW thread
		hthread_attr_init( &attrBase );
		hthread_attr_sethardware( &attrBase, HWTI_BASEADDR );

		//since there is only one HWTI, perform a mutex lock on it.
		//then create the HW thread
		hthread_mutex_lock( &hwtiMutex );
		//hthread_create(&threadBase, NULL, findFibHWTI, (void*)fib);
		//readHWTStatus();
		//resetHWT();
		//printf( "fibVal is %d\n", fib->fibVal );
		printf( "fib address is %x, %x, %x\n", (Huint)fib, (Huint)(&fib->fibNum), (Huint)(&fib->fibVal) );
		hthread_create(&threadBase, &attrBase, NULL, arg);

		//Clean up the attr
		hthread_attr_destroy( &attrBase );

		//Wait for HW thread to finish ... and unlock mutex
		hthread_join(threadBase, NULL);
		//readHWTStatus();
		printf( "fibVal is %d\n", fib->fibVal );
		hthread_mutex_unlock( &hwtiMutex );
	} else {
		fibOne.fibNum = fib->fibNum - 1;
		fibTwo.fibNum = fib->fibNum - 2;

		hthread_create(&threadOne, NULL, findFibonacci, (void*)&fibOne);
		hthread_create(&threadTwo, NULL, findFibonacci, (void*)&fibTwo);

		hthread_join(threadOne, NULL);
		hthread_join(threadTwo, NULL);

		fib->fibVal = fibOne.fibVal + fibTwo.fibVal;
	}
   
	return NULL;
}

int main (int argc, char *argv[]) {
	hthread_t thread; //I came up with this name myself
	struct fibonacci fib;
//	log_t log;
    Huint fibArray[FIBMAX];
//	Huint *fibArray;
	Huint i;

	hthread_mutex_init( &hwtiMutex, NULL );
	hthread_mutex_init( &mutex2, NULL );
	hthread_mutex_init( &mutex3, NULL );
	hthread_mutex_init( &mutex4, NULL );
	printf( "Mutex number is %d\n", hwtiMutex.num );
	printf( "Mutex number is %d\n", mutex2.num );
	printf( "Mutex number is %d\n", mutex3.num );
	printf( "Mutex number is %d\n", mutex4.num );

//	log_create( &log, 1024 );
//	log_time( &log );

//	fibArray = malloc( FIBMAX * sizeof ( Huint ) );

	for( i=0; i<FIBMAX; i++ ) {
		fib.fibNum = i;
    
		printf( "Creating Thread for Fibonacci %d\n", i );
		hthread_create(&thread, NULL, findFibonacci, (void*)&fib);
		hthread_join(thread, NULL);
		fibArray[i] = fib.fibVal;
	}

//	log_time( &log );
	for( i=0; i<FIBMAX; i++ ) {
		printf( "Fibonacci %d is %d\n", i, fibArray[i] );
	}
//	log_close_ascii( &log );
//	printf( "\nReview the log file to determine the total time\n" );
	printf( " - done -\n\n" );
	return 1 ;
}
