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

#include <stdio.h>
#include <stdlib.h>
#include <hthread.h>

#define LOOP                    5
#define CHILDREN_PER_MUTEX      50
#define MUTEXES                 5
#define CHILDREN                250

#define STIME                   50 * 1000;
#undef PRINT

void* child( void *arg )
{
    hthread_t       self;
	hthread_mutex_t *mutex;
    
    mutex = (hthread_mutex_t*)arg;
    self = hthread_self();
    
    printf( "Starting Child: %u\n", self );
    while( 1 )
    {
        hthread_mutex_lock( mutex );
        
        hthread_yield();
        printf( "Locked Mutex: %u\n", self );
        hthread_yield();
        
        hthread_mutex_unlock( mutex );
        hthread_yield();
    }
	
	return NULL;
}

int main( int argc, char *argv[] )
{
	hthread_t           tid[ CHILDREN ];
    hthread_mutex_t     mutex[ MUTEXES ];
    hthread_mutexattr_t attr;
    Huint               i;
    Huint               j;
    Huint               c;

    hthread_mutexattr_init( &attr );
    hthread_mutexattr_settype( &attr, HTHREAD_MUTEX_FAST_NP );
    
    c = 0;
    for( i = 0; i < MUTEXES; i++ )
    {
        hthread_mutexattr_setnum( &attr, i );
        hthread_mutex_init( &mutex[i], &attr );
        
        for( j = 0; j < CHILDREN_PER_MUTEX; j++ )
        {
            hthread_create( &tid[c], NULL, child, &mutex[i] );
            printf( "Created Child %u\n", tid[c] );

            c++;
        }
    }
    
    for( i = 0; i < CHILDREN; i++ )
    {
        printf( "Join Child %u\n", tid[i] );
   	    hthread_join( tid[i], NULL );
    }
    
	printf( "--DONE--\n" );
	return 1;
}
