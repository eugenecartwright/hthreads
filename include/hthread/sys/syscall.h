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
  *	\file       syscall.h
  * \brief      Declaration of system calls used by hybrid threads.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  *
  * This file contains the declaration of all of the system call information
  * used by hybrid threads. This includes definitions of all of the system
  * call numbers and the definition of the system call data structure.
  */

#ifndef _HYBRID_THREADS_SYSCALL_H_
#define _HYBRID_THREADS_SYSCALL_H_

#include <mutex/mutex.h>
#include <profile/profile.h>

// Set the default value for syscall tracing if it is not set yet
#ifndef TRACE_SYSCALL
#define TRACE_SYSCALL 0
#endif

// Set the default value for syscall profiling if it is not set yet
#ifndef PROFILE_SYSCALL
#define PROFILE_SYSCALL 0
#endif

// Define parameters for syscall profiling
#define SCTYPE  int
#define SCMIN   HTHREAD_SYSCALL_MINIMUM
#define SCMAX   HTHREAD_SYSCALL_MAXIMUM
#define SCBINS  (SCMAX - SCMIN)
#define SCOUT   default
#define SCNAME  "syscalls"

// Define the Hthreads syscall numbers
#define HTHREAD_SYSCALL_CREATE		    1
#define HTHREAD_SYSCALL_JOIN		    2
#define HTHREAD_SYSCALL_DETACH		    3
#define HTHREAD_SYSCALL_YIELD		    4
#define HTHREAD_SYSCALL_EXIT		    5
#define HTHREAD_SYSCALL_CURRENTID	    6
#define HTHREAD_SYSCALL_SETPRI  	    7
#define HTHREAD_SYSCALL_GETPRI  	    8
#define HTHREAD_SYSCALL_INTRASSOC  	    9

#define HTHREAD_SYSCALL_MUTEX_LOCK      10
#define HTHREAD_SYSCALL_MUTEX_UNLOCK    11
#define HTHREAD_SYSCALL_MUTEX_TRYLOCK   12

#define HTHREAD_SYSCALL_COND_WAIT       13
#define HTHREAD_SYSCALL_COND_SIGNAL     14
#define HTHREAD_SYSCALL_COND_BROADCAST  15

#define HTHREAD_SYSCALL_SCHED           16

#define HTHREAD_SYSCALL_MINIMUM         1
#define HTHREAD_SYSCALL_MAXIMUM         16

/** \internal
  * \brief	This is the handler for the system call exception; it takes
  *			care of performing all system call requests.
  */
//extern void _system_call_handler( void * );
extern void* _system_call_handler( Huint, void*, void*, void*, void*, void* );

/** \internal
  * \brief	This function performs a system call with the given system call
  *         number and the given parameters.
  */
extern void* do_syscall(int,void*,void*,void*,void*,void*);

/** \internal
  * \brief  The system call which implements the hthread_create functionality.
  */ 
extern Hint _syscall_create( hthread_t *th, hthread_attr_t *attr,
		                     hthread_start_t start, void *arg );

/** \internal
  * \brief  The system call that implements the hthread_join functionality.
  */
extern Hint _syscall_join( hthread_t th, void **retval );
	
/** \internal
  * \brief  The system call that implements the hthread_detach functionality.
  */
extern Hint _syscall_detach( hthread_t th );
	
/** \internal
  * \brief  Voluntarily release the processor so that another thread
  */
extern Hint _syscall_yield( void );
	
/** \internal
  * \brief  A system call that implements the htread_exit functionality.
  */
extern void _syscall_exit( void *retval );

/** \internal
  * \brief  Determine the thread id of the current thread.
  */
extern hthread_t _syscall_current_id( void );

/** \internal
  * \brief  Lock a mutex.
  */
extern Hint _syscall_mutex_lock(hthread_mutex_t*);

/** \internal
  * \brief  Unlock a mutex.
  */
extern Hint _syscall_mutex_unlock(hthread_mutex_t*);

/** \internal
  * \brief  Try to lock a mutex.
  */
extern Hint _syscall_mutex_trylock(hthread_mutex_t*);

/** \internal
  * \brief  Wait on a condition variable.
  */
extern Hint _syscall_cond_wait(hthread_cond_t*,hthread_mutex_t*);

/** \internal
  * \brief  Signal a condition variable.
  */
extern Hint _syscall_cond_signal(hthread_cond_t*);

/** \internal
  * \brief  Broadcast to a condition variable.
  */
extern Hint _syscall_cond_broadcast(hthread_cond_t*);

/** \internal
  * \brief  Set the scheduling parameter for the current thread.
  */
extern Hint _syscall_set_schedparam( hthread_t, Huint );

/** \internal
  * \brief  Get the scheduling parameter for the current thread.
  */
extern Hint _syscall_get_schedparam( hthread_t, Hint* );

/** \internal
  * \brief  Run the hthreads scheduler.
  */
extern Hint _syscall_sched( void );

/** \internal
  * \brief  Determine the thread id of the current thread.
  */
extern Hint _syscall_intr_assoc( Huint iid );

#endif

