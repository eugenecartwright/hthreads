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

/** \file       const.h
  * \brief      Declaration of constant values used by hthreads.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  */

#ifndef _HYBRID_THREADS_THREAD_CONSTS_H_
#define _HYBRID_THREADS_THREAD_CONSTS_H_

/** FIXME: Move this to the configuration file
  * \brief The maximum number of threads which can be running concurrently.
  *
  * This definition identifies the maximum number of threads which can
  * be running concurrently. This value represents the amount of storage
  * which is available in hardware to track the threads.
  *
  * Note that the number of threads that can be created is unlimited so long
  * as the number of concurrently running threads is below this value. This
  * is possible because thread storage is becomes reusable after a thread
  * has terminated.
  */
#define MAX_THREADS             256

// Stack sizes for threads in the HybridThreads System
#define HT_STACK_SIZE			(16 * 1024)
#define HT_IDLE_STACK_SIZE		( 1 * 1024)
#define HT_MAIN_STACK_SIZE		( 0 * 1024)
#define HT_DEFAULT_STACK_SIZE	(16 * 1024)

// The default priority for new threads
#define HT_DEFAULT_PRI          64

// Constants for Joinable vs. Detached Threads
#define HTHREAD_CREATE_JOINABLE     1
#define HTHREAD_CREATE_DETACHED     2

// NOTE: Only HTHREAD_EXPLICIT_SCHED is supported by the HybridThreads API
#define HTHREAD_INHERIT_SCHED       1
#define HTHREAD_EXPLICIT_SCHED      2

// NOTE: Cancellation is not supported by the HybridThreads API
#define HTHREAD_CANCEL_ENABLE       1
#define HTHREAD_CANCEL_DISABLE      2
#define HTHREAD_CANCEL_DEFERRED     3
#define HTHREAD_CANCEL_ASYNCHRONOUS 4

// NOTE: Only system scope is supported by the HybridThreads API
#define HTHREAD_SCOPE_SYSTEM        1
#define HTHREAD_SCOPE_PROCESS       2

// NOTE: Only private is supported by the HybridThreads API
#define HTHREAD_PROCESS_SHARED      1
#define HTHREAD_PROCESS_PRIVATE     2

// Mutex protocol attributes
#define HTHREAD_PRIO_NONE           1
#define HTHREAD_PRIO_INHERIT        2
#define HTHREAD_PRIO_PROTECT        3

#endif

