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

#define LOG_SERIAL 1
#include <log/log.h>

// The base address of the hardware thread we are creating
#define HWTI_BASEADDR_ZERO          (void*)(0x63000000)
#define HWTI_BASEADDR_ONE           (void*)(0x63010000)
#define LENGTH 2500

struct Array {
	Huint length;
	Huint data[LENGTH];
};


void readHWTStatus(void * HWTI_BASEADDR) {
    printf( "  HWT Thread ID %x \n", read_reg(HWTI_BASEADDR) );
    printf( "  HWT Verify %x \n", read_reg(HWTI_BASEADDR + 0x00000400) );
    printf( "  HWT Status  %x \n", read_reg(HWTI_BASEADDR + 0x00000800) );
    printf( "  HWT Command %x \n", read_reg(HWTI_BASEADDR + 0x00000C00) );
    printf( "  HWT Argument %x \n", read_reg(HWTI_BASEADDR + 0x00001000) );
    printf( "  HWT Result %x \n", read_reg(HWTI_BASEADDR + 0x00001400) );
    printf( "  HWT Reg Master Write %x \n", read_reg(HWTI_BASEADDR + 0x00002400) );
    printf( "  HWT Timer %x \n", read_reg(HWTI_BASEADDR + 0x00003400) );
}

void * dwtHaar( void * arg ) {
	struct Array * arrayPtr;
	arrayPtr = (struct Array *) arg;

	Huint * sig = arrayPtr->data;
	Huint len = arrayPtr->length;

	int i = 0;
	Huint * tmp = calloc(len,sizeof(int));

	while ( i < (len >> 1) ) {
		tmp[(i<<1)+1] = (sig[(i<<1)] + sig[(i<<1)+1]) >> 1;
		tmp[(i<<1)] = sig[(i<<1)] - tmp[(i<<1)+1];

		i++;
	}

	i = 0;
	while ( i < (len>>1) ) {
		sig[i] = tmp[(i<<1)+1];
		sig[(len>>1)+i] = tmp[(i<<1)];
		i++;
	}

	free(tmp);
	return NULL;
}

int main( int argc, char *argv[] ) {
    hthread_t        hw2;
    hthread_attr_t  attr1, attr2, attr3, attr4;
	struct Array    arg1, arg2, arg3, arg4;
    Huint           i, retval;
	log_t log;

    // Initialize the attributes for the hardware thread
    hthread_attr_init( &attr1 );
    hthread_attr_init( &attr2 );
    hthread_attr_init( &attr3 );
    hthread_attr_init( &attr4 );

    // Setup the attributes for the hardware thread
    hthread_attr_sethardware( &attr1, HWTI_BASEADDR_ZERO );
    hthread_attr_sethardware( &attr2, HWTI_BASEADDR_ONE );
   
    // Set the thread's argument data to some value
	arg1.length = LENGTH;
	arg2.length = LENGTH;
	arg3.length = LENGTH;
	arg4.length = LENGTH;
	for( i = 0; i<LENGTH; i++ ) {
		arg1.data[i] = (100 + i*4) % LENGTH;
		arg2.data[i] = (101 + i*3) % LENGTH;
		arg3.data[i] = (102 + i*2) % LENGTH;
		arg4.data[i] = (103 + i*1) % LENGTH;
	}

	for( i = 0; i < LENGTH; i++ ) {
		//printf( "%i = %i\n", i, arg3.data[i] );
	}
    
	log_create( &log, 1024 );
	log_time( &log );
    //hthread_create( &sw1, &attr3, dwtHaar, &arg3 );
    //hthread_create( &sw2, &attr4, dwtHaar, &arg4 );
    //hthread_create( &hw1, &attr1, NULL, &arg1 );
    hthread_create( &hw2, &attr2, NULL, &arg2 );

    // Wait for the hardware thread to exit
    //hthread_join( hw1, (void*)(&retval) );
	hthread_join( hw2, (void*)(&retval) );
	//hthread_join( sw1, (void*)(&retval) );
	//hthread_join( sw2, (void*)(&retval) );
	log_time( &log );

    // Clean up the attribute structure
    hthread_attr_destroy( &attr1 );
    hthread_attr_destroy( &attr2 );
    hthread_attr_destroy( &attr3 );
    hthread_attr_destroy( &attr4 );

    readHWTStatus(HWTI_BASEADDR_ZERO);
    readHWTStatus(HWTI_BASEADDR_ONE);

	log_close_ascii( &log );
	for( i = 0; i < LENGTH; i++ ) {
		//printf( "%i = %i\n", i, arg3.data[i] );
	}
    printf( "-- QED --\n" );

    // Return from main
    return 1;
}
