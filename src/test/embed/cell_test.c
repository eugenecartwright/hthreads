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

// The base addresses of the hardware thread we are creating
#define HWTI_BASEADDR0               (void*)(0xB0000000)
#define HWTI_BASEADDR1               (void*)(0xB0000100)
#define HWTI_BASEADDR2               (void*)(0xB0000200)
#define HWTI_BASEADDR3               (void*)(0xB0000300)

// Function Pointer Definition
typedef void * (*FuncPointer)(void);

int update_mask(int mask)
{
    mask = mask << 1;

    if (mask > 128)
       mask = 1;

    return mask;
}

int main( int argc, char *argv[] )
{
    // Thread attribute structures
    Huint           sta0, sta1,sta2,sta3;
    void*           retval0;
    void*           retval1;
    void*           retval2;
    void*           retval3;
    hthread_t       tid0, tid1, tid2, tid3;
    hthread_attr_t  attr0, attr1, attr2, attr3;

    int num_ops = 0;

    printf( "\n****Main Thread****... \n" );

    XCache_DisableDCache();

    // Mutex (mutex #0) is used by created threads
    hthread_mutex_t * mutex          = (hthread_mutex_t*)malloc( sizeof(hthread_mutex_t) );
    hthread_mutex_init( mutex, NULL );

// *************************************************************************************    
    //
    extern unsigned char intermediate[];

    extern unsigned int blink_handle_offset;
    unsigned int blink_handle = (blink_handle_offset) + (unsigned int)(&intermediate);

	FuncPointer fp0 				= 0;			

    FuncPointer fp1 				= 0;			

    FuncPointer fp2 				= 0;			

    FuncPointer fp3 				= 0;			

// *************************************************************************************    
    int mask_val = 1;

    printf("Code start address = 0x%08x\n", (unsigned int)&intermediate);
	    // Initialize the attributes for the hardware threads
        // ****************************************************
	    hthread_attr_init( &attr0 );
	    hthread_attr_sethardware( &attr0, HWTI_BASEADDR0 );
        hthread_attr_init( &attr1 );
	    hthread_attr_sethardware( &attr1, HWTI_BASEADDR1 );
        hthread_attr_init( &attr2 );
	    hthread_attr_sethardware( &attr2, HWTI_BASEADDR2 );
        hthread_attr_init( &attr3 );
	    hthread_attr_sethardware( &attr3, HWTI_BASEADDR3 );

    for( num_ops = 0; num_ops < 5; num_ops = num_ops + 1)
    { 

        printf("******* Round %d ********\n",num_ops);


        // Launch parallel hardware threads
        // ****************************************
        fp0 = (FuncPointer)(blink_handle);
        sta0 = hthread_create( &tid0, &attr0, (void*)fp0, (void*)(mask_val) );

        mask_val = update_mask(mask_val);

        fp1 = (FuncPointer)(blink_handle);
        sta1 = hthread_create( &tid1, &attr1, (void*)fp1, (void*)(mask_val));

        mask_val = update_mask(mask_val);

        fp2 = (FuncPointer)(blink_handle);
        sta2 = hthread_create( &tid2, &attr2, (void*)fp2, (void*)(mask_val));

        mask_val = update_mask(mask_val);

        fp3 = (FuncPointer)(blink_handle);
        sta3 = hthread_create( &tid3, &attr3, (void*)fp3, (void*)(mask_val));
	
		printf( "Started Hardware Thread 0 (TID = %d) \n", tid0);
		printf( "Started Hardware Thread 1 (TID = %d) \n", tid1);
		printf( "Started Hardware Thread 2 (TID = %d) \n", tid2);
		printf( "Started Hardware Thread 3 (TID = %d) \n", tid3);
		
	    // Wait for the hardware threads to exit
		printf( "Waiting for Hardware Threads to Complete... \r" );
	    hthread_join( tid0, &retval0 );
	    hthread_join( tid1, &retval1 );
	    hthread_join( tid2, &retval2 );
	    hthread_join( tid3, &retval3 );
		printf( "Joined on  Hardware Thread 0 ... 0x%8.8x\n", (Huint)retval0 );
		printf( "Joined on  Hardware Thread 1... 0x%8.8x\n", (Huint)retval1 );
		printf( "Joined on  Hardware Thread 2... 0x%8.8x\n", (Huint)retval2 );
		printf( "Joined on  Hardware Thread 3... 0x%8.8x\n", (Huint)retval3 );
    }

    // Clean up the attribute structures
	    hthread_attr_destroy( &attr0 );
	    hthread_attr_destroy( &attr1 );
	    hthread_attr_destroy( &attr2 );
	    hthread_attr_destroy( &attr3 );

    hthread_mutex_destroy( mutex );
    free( mutex );

    printf ("-- Complete --\n");
    // Return from main
    return 0;
}
