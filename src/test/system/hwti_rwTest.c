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
#define HWT_ZERO_BASEADDR              (void*)(0x63000000)
#define HWT_ONE_BASEADDR               (void*)(0x63010000)

#define LOG_SERIAL 1
#include <log/log.h>

void readHWTStatus( void * HWTI_BASEADDR ) {
    printf( "  HWT Thread ID %x \n", read_reg(HWTI_BASEADDR) );
    printf( "  HWT Verify %x \n", read_reg(HWTI_BASEADDR + 0x00000004) );
    printf( "  HWT Status  %x \n", read_reg(HWTI_BASEADDR + 0x00000008) );
    printf( "  HWT Command %x \n", read_reg(HWTI_BASEADDR + 0x0000000C) );
    printf( "  HWT Argument %x \n", read_reg(HWTI_BASEADDR + 0x00000010) );
    printf( "  HWT Result %x \n", read_reg(HWTI_BASEADDR + 0x00000014) );
    printf( "  HWT Reg Master Write %x \n", read_reg(HWTI_BASEADDR + 0x00000024) );
    printf( "  HWT DEBUG SYSTEM %x \n", read_reg(HWTI_BASEADDR + 0x00000028) );
    printf( "  HWT DEBUG USER %x \n", read_reg(HWTI_BASEADDR + 0x0000002C) );
    printf( "  HWT DEBUG CONTROL %x \n", read_reg(HWTI_BASEADDR + 0x00000030) );
    printf( "  HWT Timer %x \n", read_reg(HWTI_BASEADDR + 0x00000034) );
}

struct command{
	int * ptrData;
	int count;
	int value;
	int operation;
};

int main( int argc, char *argv[] ) {
    hthread_t       tid1;
    hthread_attr_t  attr1;
    struct command 	commands;
	Huint           i;
	log_t           log;

    // Create the log file for timing reports
	log_create( &log, 1024 );

    // Initialize the attributes for the threads
    hthread_attr_init( &attr1 );

    // Setup the attributes for the hardware threads
    hthread_attr_sethardware( &attr1, HWT_ZERO_BASEADDR );

	// Initialize matrixData
	commands.count = 060;
	commands.value = 1012;
	commands.operation = 6;
	//commands.ptrData = (int *) malloc( sizeof( int ) * commands.count );
	commands.ptrData = (int *) 0x63000050;

    // Create the hardware thread
	log_time( &log );
	hthread_create( &tid1, &attr1, NULL, (void*)(&commands) );

    // Wait for the threads to exit
    hthread_join( tid1, NULL );
	log_time( &log );

    readHWTStatus( HWT_ZERO_BASEADDR );

	for( i = 0; i < commands.count; i+=16 ) {
		printf( "%i=%i\n", i, commands.ptrData[i] );
	}

    // Clean up the attribute structure
    hthread_attr_destroy( &attr1 );

	printf( "log dump\n" );
	log_close_ascii( &log );
    printf( "-- QED --\n" );

    // Return from main
    return 1;
}
