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

#include <stdlib.h>
#include <hthread.h>
#include <arch/htime.h>
#include <stdio.h>

void* startFunc( void *arg )
{
	int i;
	char val = *(char*)arg;
    hthread_time_t t;

	i = 0;
	while( i < 5 )
	{
		printf( "Start Func: %u\n", val );
	
		i++;
		
        // wait one second
        t = hthread_time_get() + CLOCKS_PER_SEC;
        while(hthread_time_get() < t);

		hthread_yield();
	}

	return arg;
}

void* idleThread( void *arg )
{
    hthread_time_t t;

	while( 1 )
	{
		printf( "Idle Thread\n" );

        // wait one second
        t = hthread_time_get() + CLOCKS_PER_SEC;
        while(hthread_time_get() < t);

		hthread_yield();
	}

    return NULL;
}

int main( int argc, char *argv[] )
{
	hthread_attr_t	attr;
	hthread_t	threadID;
	int thread;
	char arg1;
	char arg2;
	char arg3;

	attr.detached 	= Htrue;
	attr.stack_size	= 4096;

	thread = hthread_create( &threadID, &attr, idleThread, NULL );
		
	arg1 = 'a';
	thread = hthread_create( &threadID, &attr, startFunc, &arg1 );
		
	arg2 = 'b';
	thread = hthread_create( &threadID, &attr, startFunc, &arg2 );

	arg3 = 'c';
	thread = hthread_create( &threadID, &attr, startFunc, &arg3 );


    hthread_yield();
	return 1;
}

