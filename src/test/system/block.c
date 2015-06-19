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
#include <mutex/hardware.h>

#define DISPATCHERS             5
#define WORKERS					5

typedef struct
{
    hthread_cond_t  *cond_notfull;
    hthread_cond_t  *cond_notempty;
    
    hthread_mutex_t *mutex;

    int             jobs;
} argument;

void* thread_worker( void *a )
{
    volatile int i,j,z;
    Hint      sta;
	Huint	  tid;
    argument  *arg;

	tid = hthread_self();
	arg = (argument*)a;

    while( 1 )
	{
        printf( "Attempting Lock: WORKER (TID=%u) (OWN=%u)\n", tid, _mutex_owner(arg->mutex->num) );
        sta = hthread_mutex_lock( arg->mutex );
	    printf( "Running Thread:  WORKER (TID=%u) (OWN=%u) (STA=%8.8X)\n", tid, _mutex_owner(arg->mutex->num), sta );
        for( i = 0; i < 1000; i++ ) for( j = 0; j < 100000; j++ ) z=i*j;
	    printf( "Yield Thread:    WORKER (TID=%u) (OWN=%u) (STA=%8.8X)\n", tid, _mutex_owner(arg->mutex->num), sta );
        hthread_yield(); 
        sta = hthread_mutex_unlock( arg->mutex );
	    printf( "Unlocked Mutex:  WORKER (TID=%u) (OWN=%u) (STA=%8.8X)\n", tid, _mutex_owner(arg->mutex->num), sta );
	}
	
	return NULL;
}

void* thread_dispatcher( void *a )
{
    volatile int i,j,z;
    Hint      sta;
	Huint	  tid;
    argument  *arg;

	tid = hthread_self();
	arg = (argument*)a;

	while( 1 )
    {
        printf( "Attempting Lock: DISPCH (TID=%u) (OWN=%u)\n", tid, _mutex_owner(arg->mutex->num) );
        sta = hthread_mutex_lock( arg->mutex );
	    printf( "Running Thread:  DISPCH (TID=%u) (OWN=%u) (STA=%8.8X)\n", tid, _mutex_owner(arg->mutex->num), sta );
        for( i = 0; i < 1000; i++ ) for( j = 0; j < 100000; j++ ) z=i*j;
	    printf( "Yield Thread:    DISPCH (TID=%u) (OWN=%u) (STA=%8.8X)\n", tid, _mutex_owner(arg->mutex->num), sta );
        hthread_yield();
        sta = hthread_mutex_unlock( arg->mutex );
	    printf( "Unlocked Mutex:  DISPCH (TID=%u) (OWN=%u) (STA=%8.8X)\n", tid, _mutex_owner(arg->mutex->num), sta );
    }
    
	return NULL;
}

hthread_t create_dispatcher( argument *arg )
{
	hthread_t	tid;
    Huint 		status;

    status = hthread_create( &tid, NULL, thread_dispatcher, (void*)arg );
	if( status != 0 )
	{
		printf( "Create Error: (STA=%u) (TID=%u)\n",status,tid );
        while(1);
	}
	
    return tid;
}

hthread_t create_worker( argument *arg )
{
	hthread_t	tid;
    Huint 		status;

    status = hthread_create( &tid, NULL, thread_worker, (void*)arg );
	if( status != 0 )
	{
		printf( "Create Error: (STA=%u) (TID=%u)\n",status,tid );
        while(1);
	}
	
    return tid;
}

argument* create_args(void)
{
    argument *arg;
    
    arg                 = (argument*)malloc( sizeof(argument) );
    arg->cond_notempty  = (hthread_cond_t*)malloc( sizeof(hthread_cond_t) );
    arg->cond_notfull   = (hthread_cond_t*)malloc( sizeof(hthread_cond_t) );
    arg->mutex          = (hthread_mutex_t*)malloc( sizeof(hthread_mutex_t) );

    hthread_cond_init( arg->cond_notempty, NULL );
    hthread_cond_init( arg->cond_notfull, NULL );
    hthread_mutex_init( arg->mutex, NULL );
    
    arg->jobs = 0;
    return arg;
}

void destroy_args( argument *arg )
{
    hthread_cond_destroy( arg->cond_notempty );
    hthread_cond_destroy( arg->cond_notfull );
    hthread_mutex_destroy( arg->mutex );

    free( arg->cond_notempty );
    free( arg->cond_notfull );
    free( arg->mutex );
    free( arg );
}

int main( int argc, char *argv[] )
{
	Huint	  i;
    argument  *arg;
    hthread_t tid[WORKERS + DISPATCHERS];

    arg = create_args();

    for(i = 0;i<WORKERS;i++)      tid[i] = create_worker( arg );
    for(i = 0;i<DISPATCHERS;i++)  tid[i+WORKERS] = create_dispatcher( arg );
    
    for(i = 0;i<WORKERS;i++)      hthread_join(tid[i], NULL);
    for(i = 0;i<DISPATCHERS;i++)  hthread_join(tid[i+WORKERS], NULL);
    destroy_args( arg );
    
	printf( "--QED--\n" );
	return 1;
}
