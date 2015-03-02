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
#include <stdio.h>
#include <hthread.h>

#define MAXCNT						2
#define CONCUR					    250
#define LOOP_CNT					1
#define PRINT
#define PRIORITIES

void set_priority( hthread_t th, Hint pri )
{
    Hint status;
    struct sched_param pr;

    pr.sched_priority = pri;
    status = hthread_setschedparam( th, SCHED_OTHER, &pr );
    if( status < 0 )
    {
        printf( "Set Priority Error: 0x%8.8x\n", status );
    }
}

void* simpleThread( void *arg )
{
    Huint 	i;
	Huint	cnt;
	Huint	tid;
    Huint   pri;
#ifdef PRIORITIES
    Hint    pol;
    struct sched_param pr;
#endif

	cnt = (Huint)arg;
	tid = hthread_self();

#ifdef PRIORITIES
    hthread_getschedparam( tid, &pol, &pr );
    pri = pr.sched_priority;
#else
    pri = 0;
#endif
    
#ifdef PRINT
	printf( "Starting Thread:   (TID=%u) (CNT=%u) (PRI=%d)\n", tid, cnt, pri );
#endif
	
	for( i = 0; i < LOOP_CNT; i++ )
	{
#ifdef PRINT
		printf("Running Thread:    (TID=%u) (CNT=%u) (PRI=%d)\n",tid,cnt,pri);
#endif

		hthread_yield();
	}
	
#ifdef PRINT
	printf( "Exiting Thread:    (TID=%u) (CNT=%u) (PRI=%d)\n", tid, cnt, pri );
#endif

	return NULL;
}

hthread_t create_new_thread( int ctr )
{
	hthread_t	tid;
    Huint 		status;

    printf("Before create...\r\n");
    status = hthread_create( &tid, NULL, simpleThread, (void*)ctr );
    printf("After create...\r\n");
	if( status != SUCCESS )
	{
		printf( "Create Error: (STA=0x%8.8x) (TID=%u) (CNT=%u)\n",status,tid, ctr );
        while(1);
	}
	
    return tid;
}

int main( int argc, char *argv[] )
{
	hthread_t	tid[ CONCUR ];
	Huint		tcn[ CONCUR ];
    Huint		status;
	Huint		cnt;
    Huint       pri;
	Huint		i;
	Huint		j;

    printf( "Running create2 test...\n" );

	cnt = 0;
    pri = 100;
    for( i = 0; i < MAXCNT; i++ )
	{
        printf( "Create Iteration: %u\n", i );
		for( j = 0; j < CONCUR; j++ )
		{
            //printf( "Concur Iteration: %u\n", j );
        	tid[j] = create_new_thread( cnt );
			tcn[j] = cnt;

#ifdef PRIORITIES
            pri = ((pri + 1) % 128);
            set_priority( tid[j], pri );
#endif

#ifdef PRINT
			printf( "Created Thread: (TID=%u) (CNT=%u) (PRI=%u)\n", tid[j], cnt, pri);
#endif

			cnt++;
		}
		
        printf( "Join Iteration: %u\n", i );
		for( j = 0; j < CONCUR; j++ )
		{
			printf( "Joining Thread:     (TID=%u)\n", tid[j] );
        	status = hthread_join( tid[j], NULL );
#ifdef PRINT
			printf( "Joined Thread:     (TID=%u) (CNT=%u) (STA=0x%08x)\n", tid[j],tcn[j],status);
#endif
		}
    }
	
	printf( "--DONE--\n" );
	return 1;
}
