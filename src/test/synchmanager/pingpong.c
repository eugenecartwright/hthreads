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

#define PRODUCERS   1
#define CONSUMERS   1
#define SIZE        16

typedef struct
{
    hthread_mutex_t ping;
    hthread_mutex_t pong;
} arg_t;

void* ping( void *arg )
{
    arg_t *data;
    data = (arg_t*)arg;

    while( 1 )
    {
        // Before we can say ping we must lock the ping mutex
        hthread_mutex_lock( &data->ping );

        // Say ping
        printf( "PING -> " );

        // Now the other threads can say pong
        hthread_mutex_unlock( &data->pong );
    }

    return NULL;
}

void* pong( void *arg )
{
    arg_t *data;
    data = (arg_t*)arg;

    while( 1 )
    {
        // Before we can say pong we must lock the pong mutex
        hthread_mutex_lock( &data->pong );

        // Say ping
        printf( "PONG\n" );

        // Now the other threads can say ping
        hthread_mutex_unlock( &data->ping );
    }

    return NULL;
}

int main( int argc, char *argv[] )
{
    void                *r1;
    void                *r2;
    arg_t               arg;
    hthread_t           t1;
    hthread_t           t2;
    hthread_mutexattr_t attr1;
    hthread_mutexattr_t attr2;

    // Create the attribute structure
    printf( "Initializing Attributes...\n" );
    hthread_mutexattr_init( &attr1 );
    hthread_mutexattr_init( &attr2 );
    hthread_mutexattr_setnum( &attr1, 0 );
    hthread_mutexattr_setnum( &attr2, 1 );
    hthread_mutexattr_settype( &attr1, HTHREAD_MUTEX_FAST_NP );
    hthread_mutexattr_settype( &attr2, HTHREAD_MUTEX_FAST_NP );
    
    // Create the argument structure
    printf( "Initializing Mutexes...\n" );
    hthread_mutex_init( &arg.ping, &attr1 );
    hthread_mutex_init( &arg.pong, &attr2 );

    printf( "Locking Mutexes...\n" );
    hthread_mutex_lock( &arg.pong );
    
    // Create the threads
    printf( "Initializing Threads...\n" );
    hthread_create( &t1, NULL, ping, &arg);
    hthread_create( &t2, NULL, pong, &arg);

    // Join the threads
    hthread_join( t1, &r1 );
    hthread_join( t2, &r2 );

    // Finish the program
	printf( "-- QED --\n" );

	return 0;
}
