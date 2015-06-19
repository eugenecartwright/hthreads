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

#include <hthread.h>
#include <util/rops.h>
#include <stdlib.h>
#include <stdio.h>


// The base address of the hardware thread we are creating
#define HWTI_BASEADDR               (void*)(0x63000000)

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

struct foo {
	Huint argOne;
	Huint argTwo;
};

int main( int argc, char *argv[] )
{
    hthread_t       tid;
    hthread_attr_t  attr;
    struct foo 		arg;
    Huint           retval;

    // Initialize the attributes for the hardware thread
    hthread_attr_init( &attr );
    printf( "Created Hardware Thread Attributes\n" );

    // Setup the attributes for the hardware thread
    hthread_attr_sethardware( &attr, HWTI_BASEADDR );
    printf( "Set Hardware Thread Base Addresss\n" );
   
    // Set the thread's argument data to some value
    printf( "argOne = %d at address %p\n", arg.argOne, &arg.argOne);
    printf( "argTwo = %d at address %p\n", arg.argTwo, &arg.argTwo);
    arg.argTwo = 100000;
    printf( "argOne = %d at address %p\n", arg.argOne, &arg.argOne);
    printf( "argTwo = %d at address %p\n", arg.argTwo, &arg.argTwo);
    
    // Create the hardware thread
    readHWTStatus();
    hthread_create( &tid, &attr, NULL, (void*)(&arg) );
    printf( "Created Hardware Thread\n" );

    // Clean up the attribute structure
    hthread_attr_destroy( &attr );
    printf( "Destroyed Hardware Thread Attributes\n" );

    // HWT should add its thread id to arg and exit.
    readHWTStatus();
        
    // Wait for the hardware thread to exit
	printf( "Joining Hardware Thread\n" );
    hthread_join( tid, (void*)(&retval) );
    
    // Print out value of arg, and a successful exit message
    printf( "argOne = %d at address %p\n", arg.argOne, &arg.argOne);
    printf( "argTwo = %d at address %p\n", arg.argTwo, &arg.argTwo);
    printf( "-- QED --\n" );

    // Return from main
    return 1;
}
