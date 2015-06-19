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
  * \file       context.c
  * \brief      The implementation of the context switching functions.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  *
  * This file contains the implementation of the context switching functions.
  * These functions can save the CPU context to a hthreads_context_t structure
  * and can restore a CPU context from a hthreads_context_t structure.
  */
#include <hthread.h>
#include <sys/core.h>
#include <arch/context.h>

/** \internal
  * \brief  Save the currently running context and restore the given context. 
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function saves the currently running context into the thread context
  * identified by curr. The thread context identified by next is then restored
  * to the CPU.
  *
  * This function assumes that the thread context identified by next has been
  * run on the CPU before. If this is not the case then the function
  * context_save_restore_new should be used instead.
  */
void _context_save_restore( void *curr, void *next )
{
	// Save the current thread's context
	// Note that the save context routine uses the link register as
	// the location to restore the context back to. Thus, no function
	// calls can occur before the context is saved (because they modify
	// the link register).
    PPC405_SAVE_CONTEXT( curr );

	// Restore the next thread's context
	PPC405_RESTORE_CONTEXT( next );
}

/** \internal
  * \brief  Abandon the currenly running context and restore the given context.
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function abandons the currently running context. The thread context
  * identified by next is restore the the CPU.
  *
  * This function assumes that the thread context identified by next has been
  * run on the CPU before. If this is not the case then the function
  * context_save_restore_new should be used instead.
  */
void _context_restore( void *curr, void *next )
{
	// Restore the next thread's context
	PPC405_RESTORE_CONTEXT( next );
}

/** \internal
  * \brief  Save the currently running context and restore the given context. 
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function saves the currently running context into the thread context
  * identified by curr. The thread context identified by next is then restored
  * to the CPU.
  *
  * This function makes the assumption that the thread context identified by
  * next has never been run before. If the context has been run before then
  * the function context_save_restore should be used instead.
  */
void _context_save_restore_new( void *curr, void *next )
{
	// Save the current thread's context
	// Note that the save context routine uses the link register as
	// the location to restore the context back to. Thus, no function
	// calls can occur before the context is saved (because they modify
	// the link register).
    
        PPC405_SAVE_CONTEXT( curr );

	// Restore the next thread's context
	PPC405_RESTORE_NEW_CONTEXT( next );
}

/** \internal
  * \brief  Abandon the currenly running context and restore the given context.
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function abandons the currently running context. The thread context
  * identified by next is restore the the CPU.
  *
  * This function makes the assumption that the thread context identified by
  * next has never been run before. If the context has been run before then
  * the function context_save_restore should be used instead.
  */
void _context_restore_new( void *curr, void *next )
{
	// Restore the next thread's context
	PPC405_RESTORE_NEW_CONTEXT( next );
}

