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
#include <arch/cache.h>
#include <xcache_l.h>

// The base address of the hardware thread we are creating
#define HWTI_BASEADDR               (void*)(0x10000000)
//#define HWTI_BASEADDR               (void*)(0xfff80000)
#define HWTI_ARG                    (void*)(0xCAFEBABE)

typedef void * (*FuncPointer)(void);
extern unsigned char junk_o[];
extern unsigned int junk_o_len;

int main( int argc, char *argv[] )
{
    Huint           sta;
    void*           retval;
    hthread_t       tid;
    hthread_attr_t  attr;
    int num_ops = 0;
	printf( "\n****Main Thread****... \n" );

    XCache_DisableDCache();

// *************************************************************************************    
    unsigned int *fcn_pointer = (unsigned int*)(HWTI_BASEADDR + 6*sizeof(int));

    int code_offset				= 0;
	FuncPointer fp 				= 0;
	unsigned char * prog_ptr	= 0;
	unsigned int * first_instr = 0;

	// Initialize code offset and program pointer
	code_offset = 0x1f0; //0x1d4;//0x1a8;
	prog_ptr = (unsigned char *)&junk_o;
			
	// Initialize function pointer (actual place to jump to)
	fp = (FuncPointer)(prog_ptr + code_offset);

	// Initialize a pointer that allows one to "look" at the 1st instruction
	first_instr = (unsigned int*)(prog_ptr + code_offset);

    *fcn_pointer = (int)fp;
// *************************************************************************************    


    for( num_ops = 0; num_ops < 5; num_ops++)
    { 
	    // Initialize the attributes for the hardware thread
	    hthread_attr_init( &attr );
	    hthread_attr_sethardware( &attr, HWTI_BASEADDR );
	
	    // Create the hardware thread
		printf( "Starting Hardware Thread... \r" );
	    sta = hthread_create( &tid, &attr, (void*)fp, (void*)(num_ops) );
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
