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

#ifndef _HTHREADS_PERFORMANCE_H_
#define _HTHREADS_PERFORMANCE_H_

#include <hthread.h>
#include <perf.h>
#include <prof.h>
#include <debug.h>
#include <stdlib.h>
#include <stdio.h>

#define LOOPS                       200
#define THREADS                     250

hprofile_hist_declare( CREATE, CREATE_TYPE );
hprofile_hist_declare( SCHEDPARAM, SCHEDPARAM_TYPE );
hprofile_hist_declare( JOIN, JOIN_TYPE );
hprofile_hist_declare( SELF, SELF_TYPE );

Hint perf_setpriority( hthread_t th, Hint pri )
{
    Hint status;
    struct sched_param pr;

    pr.sched_priority = pri;

    hprofile_hist_start( SCHEDPARAM, SCHEDPARAM_TYPE );
    status = hthread_setschedparam( th, SCHED_OTHER, &pr );
    hprofile_hist_finish( SCHEDPARAM, SCHEDPARAM_TYPE );

    if( status < 0 )    DEBUG_PRINTF("SET PRIORITY ERROR: 0x%8.8x\n", status);
    return status;
}

Hint perf_create( hthread_t *t, hthread_attr_t *a, hthread_start_t s, void *g )
{
    Hint status;

    hprofile_hist_start( CREATE, CREATE_TYPE );
    status = hthread_create( t, a, s, g );
    hprofile_hist_finish( CREATE, CREATE_TYPE );

	if( status != SUCCESS ) DEBUG_PRINTF( "CREATE ERROR: 0x%8.8x\n", status );
    if( status == SUCCESS ) perf_setpriority( *t, 0 );
    return status;
}

Hint perf_join( hthread_t tid, void **ret )
{
    Hint status;

    hprofile_hist_start( JOIN, JOIN_TYPE );
    status = hthread_join( tid, ret );
    hprofile_hist_finish( JOIN, JOIN_TYPE );

    if( status != SUCCESS ) DEBUG_PRINTF( "JOIN ERROR: 0x%8.8x\n", status );

    return status;
}

void* perf( void *arg )
{
   hthread_t tid;

    // Get this thread's id
    hprofile_hist_start( SELF, SELF_TYPE );
    tid = hthread_self();
    hprofile_hist_finish( SELF, SELF_TYPE );

    // Exit the thread
    return NULL;
}

#endif
