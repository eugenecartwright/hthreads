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
#include <arch/htime.h>

#define THREAD_ITERATIONS 3
#define CONCURRENT_THREADS 3
#define MAIN_LOOP_ITERATIONS 5

void* simpleThread( void *arg )
{
    uint thread_ctr;
    uint i;
    Huint thread_id;
    hthread_time_t t;

    thread_ctr = (uint)arg;
	thread_id = hthread_self();

    for (i=0; i<THREAD_ITERATIONS; i++)
    {
        printf("In Thread:  (TID= %u) (CTR= %u)\n", thread_id, thread_ctr);

        // idle for one second
        t = hthread_time_get() + CLOCKS_PER_SEC;
        while(hthread_time_get() < t);

        hthread_yield();
    }

    printf( "Exiting Thread:  (TID= %u) (CTR= %u)\n", thread_id, thread_ctr);
    hthread_exit(NULL);

    printf( "??? CODE AFTER THREAD EXIT, should not get here.\n");
    return NULL;
}

hthread_t create_new_thread(uint ctr, Hbool detached)
{    
    Huint status;
    hthread_t   thread_id;
	hthread_attr_t  attrs;

	// Setup the attributes for the main thread
	attrs.detached		= detached;
	attrs.stack_size	= HT_STACK_SIZE;
    
    status = hthread_create( &thread_id, &attrs, simpleThread, (void*) ctr);
	if( status != 0 )
	{
        // UNrecoverable error.
		printf( "Create Error: %u,  for %s thread (CTR = %u)\n",
                status,
                ((detached == Htrue)? "detached" : "joinable"),
                ctr);
        while(1);
	}
    return thread_id;
}

/*  This program performs a number of illegal operations,
    to verify that the error condition is detected, properly reported
    AND that execution can proceed normally afterwards.
    Error Conditions tested:
    1.  Attempt to join a detached thread.
    2.  Attempt to re-join a joinable thread
        (call join more than once for the same thread).
        NOTE:  This "error" is not always detectable by the hardware.
        It amounts to attempting to join a thread which should already
        have been deallocated (when previously joined).
        It is possible that the id has been re-allocated, and the
        effect is to join some "other" thread.
        Later plans include software detection of this error condition.

   In addition, this program exercises creation, execution and exiting
   for both detached and joinable threads.
   Careful observation of allocated thread_id's will also confirm
   that both join'ed and detached threads are de-allocated after exit'ing.

 */

int main( int argc, char *argv[] )
{
    hthread_t   d_id[ MAIN_LOOP_ITERATIONS ];
    Huint       d_ctr[ MAIN_LOOP_ITERATIONS ];

    hthread_t   j_id[ CONCURRENT_THREADS ];
    Huint       j_ctr[ CONCURRENT_THREADS ];
    Huint       cmd_status;
    uint       i, j, ctr, rejoin_index;

    ctr = 0;

    for( i = 0; i < MAIN_LOOP_ITERATIONS; i++ )
    {
        d_ctr[i] = ctr;
        d_id[i] = create_new_thread(ctr, Htrue);
        printf("Created detached thread: ");
        printf("(TID= %u) (CTR= %u)\n", d_id[i], d_ctr[i]);
        ctr++;

        for( j = 0; j < CONCURRENT_THREADS; j++ )
        {
            j_id[j] = create_new_thread(ctr, Hfalse);
            j_ctr[j] = ctr;
            printf("Created joinable thread: ");
            printf("(TID= %u) (CTR= %u)\n", j_id[j], j_ctr[j]);
            ctr++;
        }

        // Attempt to join, a detached thread.
        // EXPECT an error.
        cmd_status = hthread_join( d_id[j], NULL );
        if (cmd_status == 0) {
            printf("??? Successfully joined DETACHED thread: ");
            printf("(TID= %u) (CTR= %u)\n", d_id[i], d_ctr[i]);
        } else {
            printf("EXPECTED error: %x, when joining DETACHED thread:",
                       cmd_status);
            printf("(TID= %u) (CTR= %u)\n", d_id[i], d_ctr[i]);
        }
        
        for( j = 0; j < CONCURRENT_THREADS; j++ )
        {
            cmd_status = hthread_join( j_id[j], NULL );
            printf("Joined Thread: ");
            printf("(TID= %u) (CTR= %u)\n", j_id[j], j_ctr[j]);
        }

        // Attempt to join a thread a second time.
        // EXPECT an error.
        rejoin_index = 0;
        cmd_status = hthread_join( j_id[rejoin_index], NULL );
        if (cmd_status == 0) {
            printf("??? Successfully joined a SECOND TIME thread: ");
            printf("(TID= %u) (CTR= %u)\n", j_id[rejoin_index], j_ctr[rejoin_index]);
        } else {
            printf("EXPECTED error: %u, when RE-joining thread:",
                       cmd_status);
            printf("(TID= %u) (CTR= %u)\n", j_id[rejoin_index], j_ctr[rejoin_index]);
        }
    }
    return 1;
}
