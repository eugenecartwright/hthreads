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

/** \internal
  *	\file       core.h
  * \brief      Declaration of structures and functions used by the core
  *				of the hybridthread's API
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  *
  * FIXME: Add Description
  */

#ifndef _HYBRID_THREADS_CORE_H_
#define _HYBRID_THREADS_CORE_H_

#include <sys/internal.h>
//#include <profile/profile.h>

// Set the default value for context switch tracing if not set
#ifndef TRACE_SCHED
#define TRACE_SCHED 0
#endif

// Set the default value for system initialization tracing if not set
#ifndef TRACE_INIT
#define TRACE_INIT 0
#endif

// Set the default value for context switch profiling if not set
#ifndef PROFILE_CONTEXT
#define PROFILE_CONTEXT   0
#endif

// Define the context switch profiling parameters
#define CONTYPE time
#define CONSIZE (1*1024*1024)
#define CONOUT  default
#define CONNAME "context"

extern hthread_thread_t threads[ MAX_THREADS ];

extern void* _bootstrap_thread(hthread_start_t,void*);
extern void* _idle_thread(void*);

extern void _run_sched(Hbool);

extern Huint _setup_thread(Huint,hthread_attr_t*,hthread_start_t,void*);
extern Huint _destroy_thread(Huint);
extern Huint _create_system_thread( hthread_t*,
                                    hthread_attr_t*,
                                    hthread_start_t,
                                    void*);

// Prototype definitions of the architecture indepenent context switching functions
extern void _switch_context(Huint,Huint);
extern void _restore_context(Huint,Huint);

// Prototype definitions of the architecture dependent context switching function
extern void _context_save_restore(void*,void*);
extern void _context_restore(void*,void*);
extern void _context_save_restore_new(void*,void*);
extern void _context_restore_new(void*,void*);
	
#endif

