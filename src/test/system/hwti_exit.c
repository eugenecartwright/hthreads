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

#include <hthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <util/rops.h>

// The base address of the hardware thread we are creating
#define HWTI_BASEADDR               (void*)(0x63000000)

void readHWTStatus() {
    printf( "  HWT Thread ID %x \n", read_reg(HWTI_BASEADDR) );
    printf( "  HWT Status  %x \n", read_reg(HWTI_BASEADDR + 0x00000008) );
    printf( "  HWT Command %x \n", read_reg(HWTI_BASEADDR + 0x0000000C) );
    printf( "  HWT Argument %x \n", read_reg(HWTI_BASEADDR + 0x00000010) );
    printf( "  HWT Result %x \n", read_reg(HWTI_BASEADDR + 0x00000014) );
    printf( "  HWT Reg Master Write %x \n", read_reg(HWTI_BASEADDR + 0x00000024) );
    printf( "  HWT DEBUG SYSTEM %x \n", read_reg(HWTI_BASEADDR + 0x00000028) );
    printf( "  HWT DEBUG USER %x \n", read_reg(HWTI_BASEADDR + 0x0000002C) );
    printf( "  HWT Timer %d \n", read_reg(HWTI_BASEADDR + 0x00000034) );
    printf( "  HWT Stack Pointer %x \n", read_reg(HWTI_BASEADDR + 0x00000038) );
    printf( "  HWT Frame Pointer %x \n", read_reg(HWTI_BASEADDR + 0x0000003C) );
    printf( "  HWT Heap Pointer %x \n", read_reg(HWTI_BASEADDR + 0x00000040) );
}

int main( int argc, char *argv[] ) {
    hthread_t       tid;
    hthread_attr_t  attr;

    // Initialize the attributes for the hardware thread
    hthread_attr_init( &attr );
    hthread_attr_sethardware( &attr, HWTI_BASEADDR );

    // Create the hardware thread
	printf( "Starting\n" );
    hthread_create( &tid, &attr, NULL, (void*)(0) );

    // Clean up the attribute structure
    hthread_attr_destroy( &attr );

    // Wait for the hardware thread to exit
    hthread_join( tid, NULL );
   
    readHWTStatus();
	printf ( "Done\n" );

    // Return from main
    return 1;
}
