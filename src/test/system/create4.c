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

#define LOOPS   2
#define NUM     32

void* simple_thread( void *arg )
{
    return NULL;
}

hthread_t create_new_thread( void )
{
	hthread_t	    tid;
    Huint 		    status;
    hthread_attr_t  attrs;

    attrs.detached     = Htrue;
    attrs.stack_size   = HT_STACK_SIZE;
    
    status = hthread_create( &tid, &attrs, simple_thread, NULL );
	if( status != 0 )
	{
		printf( "Create Error: (STATUS = %u) (TID = %u)\n", status, tid );
        while(1);
	}
	
    return tid;
}

void run( Huint num )
{
    Huint       i;
    hthread_t   tid;
    
    for( i = 0; i < num; i++ )
    {
        tid = create_new_thread();
        printf( "Created Thread: %u\n", tid );
    }
}

int main( int argc, char *argv[] )
{
    Huint i;

    for( i = 0; i < LOOPS; i++ )
    {
        printf( "\n\nRunning Tests...\n" );
        printf( "----------------------------------------------\n" );
        run( NUM );
        printf( "----------------------------------------------\n" );
    }
    
	printf( "--DONE--\n" );
	return 1;
}
