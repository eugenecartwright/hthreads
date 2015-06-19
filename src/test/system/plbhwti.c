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
#include <stdio.h>
#include <stdlib.h>
#include <util/rops.h>

// The base address of the hardware thread we are creating
#define HWTI_BASEADDR               (void*)(0x10000000)
//#define HWTI_BASEADDR               (void*)(0xfff80000)
#define HWTI_ARG                    (void*)(0xCAFEBABE)


int main( int argc, char *argv[] )
{
    Huint           sta;
    void*           retval;
    hthread_t       tid;
    hthread_attr_t  attr;
    int num_ops = 0;
	printf( "\n****Main Thread****... \n" );
   
    for( num_ops = 0; num_ops < 5; num_ops++)
    { 
	    // Initialize the attributes for the hardware thread
	    hthread_attr_init( &attr );
	    hthread_attr_sethardware( &attr, HWTI_BASEADDR );
	
	    // Create the hardware thread
		printf( "Starting Hardware Thread... \r" );
	    sta = hthread_create( &tid, &attr, NULL, (void*)(num_ops) );
		printf( "Started Hardware Thread (TID = %d) (ARG = %d)... 0x%8.8x\n", tid, num_ops, sta );
	
	    // Clean up the attribute structure
	    hthread_attr_destroy( &attr );
	
	    // Wait for the hardware thread to exit
		printf( "Waiting for Hardware Thread... \r" );
	    hthread_join( tid, &retval );
		printf( "Joined on  Hardware Thread... 0x%8.8x\n", (Huint)retval );
    }
    // Return from main
    return 0;
}
