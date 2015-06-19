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
#include <util/rops.h>


// The base address of the hardware thread we are creating
#define HWTI_BASEADDR               (void*)(0x63010000)

void readHWTStatus() {
    printf( "  HWT Thread ID %x \n", read_reg(HWTI_BASEADDR) );
    printf( "  HWT Verify %x \n", read_reg(HWTI_BASEADDR + 0x00000400) );
    printf( "  HWT Status  %x \n", read_reg(HWTI_BASEADDR + 0x00000800) );
    printf( "  HWT Command %x \n", read_reg(HWTI_BASEADDR + 0x00000C00) );
    printf( "  HWT Argument %x \n", read_reg(HWTI_BASEADDR + 0x00001000) );
    printf( "  HWT Result %x \n", read_reg(HWTI_BASEADDR + 0x00001400) );
}

struct arguments {
	Huint value;
	hthread_mutex_t *mutex;
};

void * thread( void * arg ) {
	struct arguments * myArgs = (struct arguments*) arg;
	Hint retval;
	
	retval = hthread_mutex_lock( myArgs->mutex );
	myArgs->value += 10;
	retval = hthread_mutex_unlock( myArgs->mutex );

	return NULL;
}

int main( int argc, char *argv[] ) {
    hthread_t       tid, sw1, sw2;
    hthread_attr_t  hw1Attr, sw1Attr, sw2Attr;
	hthread_mutex_t mutex;
    Huint           retval;
	struct arguments myArgs;

    hthread_attr_init( &hw1Attr );
    hthread_attr_init( &sw1Attr );
    hthread_attr_init( &sw2Attr );
    hthread_attr_sethardware( &hw1Attr, HWTI_BASEADDR );
	hthread_mutex_init( &mutex, NULL );
	myArgs.mutex = &mutex;

	retval = hthread_mutex_lock( myArgs.mutex );
   
    // Set the thread's argument data to some value
    myArgs.value = 1000;
   
   	// Create two software threads
    hthread_create( &tid, &hw1Attr, NULL, (void*)(&myArgs) );
    hthread_create( &sw1, &sw1Attr, thread, (void*)(&myArgs) );
    hthread_create( &sw2, &sw2Attr, thread, (void*)(&myArgs) );
	hthread_yield();

    // HWT should be blocked
    readHWTStatus();
	
	retval = hthread_mutex_unlock( myArgs.mutex );

    hthread_join( tid, (void*)(&retval) );
    hthread_join( sw1, (void*)(&retval) );
    hthread_join( sw2, (void*)(&retval) );
    readHWTStatus();
    
    // Clean up the attribute structure
    hthread_attr_destroy( &hw1Attr );
    hthread_attr_destroy( &sw1Attr );
    hthread_attr_destroy( &sw2Attr );

    // Print out value of arg, and a successful exit message
    printf( "After joins arg = %d\n", myArgs.value);
    printf( "-- QED --\n" );

    // Return from main
    return 1;
}
