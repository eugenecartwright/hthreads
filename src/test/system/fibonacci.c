/************************************************************************************
* Copyright (c) 2015, University of Arkansas - Hybridthreads Group
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
*     * Neither the name of the University of Arkansas nor the name of the
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

#define FIBMAX 8
//#define LOG_SERIAL 1
//#include <log/log.h>

struct fibonacci {
	Huint fibVal;
	Huint fibNum;
};

void* findFibonacci(void * arg) {
	hthread_t threadOne;
	hthread_t threadTwo;
	struct fibonacci * fib;
	struct fibonacci fibOne;
	struct fibonacci fibTwo;
    
	fib = (struct fibonacci *) arg;
    
	if (fib->fibNum == 0 || fib->fibNum == 1) {
		fib->fibVal = 1;
		printf( "  base ... " );
	} else {
		fibOne.fibNum = fib->fibNum - 1;
		fibTwo.fibNum = fib->fibNum - 2;
       
	   	printf( "  Creating thread for Fibonacci %d\n", fibOne.fibNum );
		hthread_create(&threadOne, NULL, findFibonacci, (void*)&fibOne);
		hthread_yield();

	   	printf( "  Creating thread for Fibonacci %d\n", fibTwo.fibNum );
		hthread_create(&threadTwo, NULL, findFibonacci, (void*)&fibTwo);
		hthread_yield();

	   	printf( "  Joining on thread for Fibonacci %d\n", fibOne.fibNum );
		hthread_join(threadOne, NULL);
	   	printf( "  Joining on thread for Fibonacci %d\n", fibTwo.fibNum );
		hthread_join(threadTwo, NULL);

		fib->fibVal = fibOne.fibVal + fibTwo.fibVal;
	}
   
   	printf( "  Returning ...\n" );
	return NULL;
}

int main (int argc, char *argv[]) {
	hthread_t thread; //I came up with this name myself
	struct fibonacci fib;
//	log_t log;
    Huint fibArray[FIBMAX];
//	Huint *fibArray;
	Huint i;

//	log_create( &log, 1024 );
//	log_time( &log );

//	fibArray = malloc( FIBMAX * sizeof ( Huint ) );

	for( i=0; i<FIBMAX; i++ ) {
		fib.fibNum = i;
		fib.fibVal = 0;
    
		printf( "Creating Thread for Fibonacci %d\n", i );
		hthread_create(&thread, NULL, findFibonacci, (void*)&fib);
		hthread_join(thread, NULL);
		fibArray[i] = fib.fibVal;
	}

//	log_time( &log );
	for( i=0; i<FIBMAX; i++ ) {
		printf( "Fibonacci %d is %d\n", i, fibArray[i] );
	}
//	fflush( stdout );
//	log_close_ascii( &log );
	printf( "\nReview the log file to determine the total time\n" );
	printf( " - done -\n\n" );
	return 1 ;
}
