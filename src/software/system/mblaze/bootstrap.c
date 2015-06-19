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

/** \internal
  * \file       bootstrap.c
  * \brief      The implementation of the thread bootstrap functions.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  *
  * FIXME: Add description
  */
#include <hthread.h>
#include <manager/manager.h>
#include <sys/core.h>
#include <debug.h>


void* _bootstrap_thread( hthread_start_t func, void *arg )
{
    void *ret;
    
#ifdef HTHREADS_SMP
    while(!_release_syscall_lock());
#endif

    // Invoke  the start function and grab the return value
    ret = func( arg );

    // Decrement the counter. It is safer to do this 
    // after hthread_exit but since we don't return
    // from this call, we will do it here.
    thread_counter--;
    
    // Exit the thread using the return value
    hthread_exit( ret );

    // This statement should never be reached
    return NULL;
}

void* _idle_thread( void *arg )
{
    while( 1 )
    {
        // Print out a trace message about the idle thread
        TRACE5_PRINTF( "IDLE THREAD RUNNING\n" );

        // Invoke the scheduler
        hthread_sched();
    }

    // This statement should never be reached
    return NULL;
}

