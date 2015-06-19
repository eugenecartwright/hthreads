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
#include <arch/cache.h>
#include <arch/memory.h>
#include <xcache_l.h>

// The base address of the hardware thread we are creating
#define HWTI_BASEADDR               (void*)(0xb0000000)
#define HWTI_BASEADDR1               (void*)(0xb0000100)
//#define HWTI_BASEADDR               (void*)(0xfff80000)
#define HWTI_ARG                    (void*)(0xCAFEBABE)

typedef void * (*FuncPointer)(void);

typedef struct{
	int x;
	char a;
	int y;
	char * str1;
	char * str2;
} targ_t;

int main( int argc, char *argv[] )
{
    Huint           sta, sta1;
    void*           retval;
    void*           retval1;
    hthread_t       tid, tid1;
    hthread_attr_t  attr;
    hthread_attr_t  attr1;
    int num_ops = 0;
	printf( "\n****Main Thread****... \n" );

    XCache_DisableDCache();


// *************************************************************************************    
    // Code to copy:
    extern unsigned char intermediate[];

    extern unsigned int crazy_handle_offset;
    unsigned int crazy_handle = (crazy_handle_offset) + (unsigned int)(&intermediate);

    extern unsigned int factorial_handle_offset;
    unsigned int factorial_handle = (factorial_handle_offset) + (unsigned int)(&intermediate);

	FuncPointer fp 				= 0;			

    FuncPointer fp1 				= 0;			

// *************************************************************************************    

    targ_t my_arg;

    my_arg.x = 5;  
    my_arg.y = 6;  
    my_arg.a = 'b';  
    *(my_arg.str1) = 'a';
    *(my_arg.str2) = 'b';

    printf("*******\n");
	printf("x(0x%08x) = %d\n",(unsigned int)&my_arg.x,(unsigned int)my_arg.x);
	printf("y(0x%08x) = %d\n",(unsigned int)&my_arg.y,(unsigned int)my_arg.y);
	printf("a(0x%08x) = %c\n",(unsigned int)&my_arg.a,(unsigned int)my_arg.a);
	printf("str1(0x%08x) = %c\n",(unsigned int)my_arg.str1,*my_arg.str1);
	printf("str2(0x%08x) = %c\n",(unsigned int)my_arg.str2,*my_arg.str2);
	printf("*******\n");

    for( num_ops = 0; num_ops < 5; num_ops++)
    { 
	    // Initialize the attributes for the hardware threads
        // ****************************************
	    hthread_attr_init( &attr );
	    hthread_attr_sethardware( &attr, HWTI_BASEADDR );
        hthread_attr_init( &attr1 );
	    hthread_attr_sethardware( &attr1, HWTI_BASEADDR1 );

        printf("******* Round %d ********\n",num_ops);

        // Launch parallel hardware threads
        // ****************************************
        fp = (FuncPointer)(factorial_handle);
        sta = hthread_create( &tid, &attr, (void*)fp, (void*)(num_ops) );

        fp1 = (FuncPointer)(crazy_handle);
        sta1 = hthread_create( &tid1, &attr1, (void*)fp1, (void*)(&my_arg) );
	

		printf( "Started Hardware Thread 0 (TID = %d) (ARG = 0x%08x)... 0x%8.8x\n", tid, (unsigned int)num_ops, sta );
		printf( "Started Hardware Thread 1 (TID = %d) (ARG = 0x%08x)... 0x%8.8x\n", tid1, (unsigned int)&my_arg, sta1 );
	
	    // Clean up the attribute structures
	    hthread_attr_destroy( &attr );
	    hthread_attr_destroy( &attr1 );
	
	    // Wait for the hardware threads to exit
		printf( "Waiting for Hardware Threads to Complete... \r" );
	    hthread_join( tid, &retval );
	    hthread_join( tid1, &retval1 );
		printf( "Joined on  Hardware Thread 0 ... 0x%8.8x\n", (Huint)retval );
		printf( "Joined on  Hardware Thread 1... 0x%8.8x\n", (Huint)retval1 );

	        printf("*******\n");
	        printf("x = %d\n",my_arg.x);
	        printf("y = %d\n",my_arg.y);
	        printf("a = %c\n",my_arg.a);
	        printf("str1(0x%08x) = %c\n",(unsigned int)my_arg.str1,*my_arg.str1);
	        printf("str2(0x%08x) = %c\n",(unsigned int)my_arg.str2,*my_arg.str2);
	        printf("*******\n");
    }
    // Return from main
    return 0;
}
