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
  * \file       sched.c
  * \brief      The implementation of the software level thread scheduler.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  *
  * FIXME: Add description
  */
#include <hthread.h>
#include <debug.h>
#include <sys/core.h>
#include <manager/manager.h>
#include <processor/processor.h>
#include <hwti/commands.h>

//#include <arch/smp.h>
//#include <arch/context.h>

// Declare the global variable used to profile context switching
////hprofile_buff_declare( CONTEXT, CONTYPE );

/*#if PROFILE_CONTEXT
static void __attribute((constructor)) profile_start( void )
{
    //hprofile_buff_create( CONTEXT, CONTYPE, CONSIZE );
}

static void __attribute((destructor)) profile_finish( void )
{
    //hprofile_buff_flush( CONTEXT, CONTYPE, CONOUT, CONNAME );
    //hprofile_buff_close( CONTEXT, CONTYPE );
}
#endif
*/

/** \internal
  * \brief  Save the currently running context and restore the given context. 
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function saves the currently running context into the thread context
  * identified by curr. The thread context identified by next is then restored
  * to the CPU.
  */
void _switch_context( Huint curr, Huint next )
{
    TRACE_PRINTF( TRACE_FINE, TRACE_SCHED, "SWITCH: (CUR=%d) (NXT=%d)\n", curr, next );

    if( threads[next].newthread )
    {
        TRACE_PRINTF( TRACE_FINE, TRACE_SCHED, "SWITCH: (OP=NEW) (CUR=%d) (NXT=%d)\n", curr, next );
        threads[next].newthread = Hfalse;
        //hprofile_buff_time( CONTEXT, CONTYPE, curr );
        //_context_save_restore_new(threads[curr].context,threads[next].context);
        //hprofile_buff_time( CONTEXT, CONTYPE, curr );
    }
    else
    {
        TRACE_PRINTF( TRACE_FINE, TRACE_SCHED, "SWITCH: (OP=OLD) (CUR=%d) (NXT=%d)\n", curr, next );
        //hprofile_buff_time( CONTEXT, CONTYPE, curr );
        ///_context_save_restore( threads[curr].context, threads[next].context );
        //hprofile_buff_time( CONTEXT, CONTYPE, curr );
    }
}

/** \internal
  * \brief  Abandon the currenly running context and restore the given context.
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function abandons the currently running context. The thread context
  * identified by next is restored to the CPU.
  */
void _restore_context( Huint curr, Huint next )
{
    if( threads[next].newthread )
    {
        threads[next].newthread = Hfalse;
        //hprofile_buff_time( CONTEXT, CONTYPE, curr );
        //_context_restore_new( threads[curr].context, threads[next].context );
        //hprofile_buff_time( CONTEXT, CONTYPE, curr );
    }
    else
    {
        TRACE_PRINTF( TRACE_FINE, TRACE_SCHED, "SWITCH: (OP=OLD) (CUR=%d) (NXT=%d)\n", curr, next );
        //hprofile_buff_time( CONTEXT, CONTYPE, curr );
        //_context_restore( threads[curr].context, threads[next].context );
        //hprofile_buff_time( CONTEXT, CONTYPE, curr );
    }
}

/** \internal
  * \brief  Run the scheduler.
  *
  * This function runs the scheduler. The function will pick a new thread
  * to run and switch to that thread if it is not the currently running thread.
  *
  * \param save This parameters determines if the currently running context
  *             is saved before the new context is restored. Under normal
  *             circumstances this parameter should be Htrue. However, in the
  *             case of exiting a thread this parameter should be Hfalse.
  */
void _run_sched( Hbool save )
{
    // MicroBlaze-specific V-HWTI code:
    // Context switching is not allowed (a thread runs here until it terminates).
    // Therefore, if save = HTrue, block, and wait until awakened
    //  Otherwise, (if save = HFalse), just return

    // FIXME : Jason, add in MB-specific V-HWTI code to block
    if (save == Htrue)
    {
	    volatile Huint * cmd_ptr = _vhwti_command_pointer(); 
	
	    while(*cmd_ptr != HT_HWTI_GO);
	    *cmd_ptr = 0x00;
    }

    /*    Huint curr;
    Huint next;

    TRACE_PRINTF( TRACE_FINE, TRACE_SCHED, "SCHED: (SAVE=0x%8.8x)\n", save );

    curr = _current_thread();
    next = _next_thread();
    TRACE_PRINTF( TRACE_FINE, TRACE_SCHED, "SCHED: (SAVE=0x%8.8x) (CUR=%d) (NXT=%d)\n", save, curr, next );
    if( curr == next )  return;
    if( save )  _switch_context( curr, next );
    else        _restore_context( curr, next );
*/
}

