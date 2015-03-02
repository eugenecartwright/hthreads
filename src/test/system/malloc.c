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
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define BYTES       (1*1024*1024)
#define THREADS     100

void* malloc_thread( void *arg )
{
    Huint       cnt;
    Hubyte      *buffer;
    hthread_t   self;

    cnt  = 0;
    self = hthread_self();
    while( 1 )
    {
        //if( cnt++ % 500 == 0 )  printf( "%u still running...\n", (Huint)self );
        printf( "%u still running...\n", (Huint)self );
        buffer = malloc( BYTES );
        memset( buffer, 0, BYTES );
        free( buffer );

        //buffer = _malloc_r( _REENT, BYTES );
        //memset( buffer, 0, BYTES );
        //_free_r( _REENT, buffer );

        hthread_yield();
    }

    return NULL;
}

hthread_t create_thread(void)
{
	hthread_t	tid;
    Huint 		status;

    status = hthread_create( &tid, NULL, malloc_thread, NULL );
	if( status != SUCCESS )
	{
		printf( "Create Error: (STA=0x%8.8x) (TID=%u)\n",status,tid );
        while(1);
	}
	
    return tid;
}

int main( int argc, char *argv[] )
{
	Huint		i;
    Huint		status;
	hthread_t	tid[THREADS];

    printf( "Running malloc test...\n" );

    for( i = 0; i < THREADS; i++ )  tid[i] = create_thread();
    for( i = 0; i < THREADS; i++ )  status = hthread_join( tid[i], NULL );
	
	printf( "--DONE--\n" );
	return 1;
}
