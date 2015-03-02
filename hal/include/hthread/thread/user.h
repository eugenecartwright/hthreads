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

/** \file       user.h
  * \brief      The declaration of the Hybrid Threads API.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  *
  * This file contains the declaration of the Hybrid Threads API.
  * Hybrid Threads is a threading library for embedded systems which
  * is similar in functionality to PThreads. However, the thread
  * management for Hybrid Threads is done in hardware on an FPGA.
  *
  * This frees the processor so that it only performs meaningful
  * computations. The overhead from the use of threading is reduced
  * to a simple context switch.
  */

#ifndef _HYBRID_THREADS_THREAD_USER_H_
#define _HYBRID_THREADS_THREAD_USER_H_

#include <httype.h>
#include <stdlib.h>

/** \brief	A pointer to a function which returns takes an arbitrary
  *			pointer as and argument and returns an arbitrary pointer
  *			as its value.
  *
  * This type defines a function pointer which is used in the
  * hthreads_create API call. This function pointer is used to determine
  * the starting point for the execution of the thread.
  */
typedef void* (*hthread_start_t)(void*);

/** \brief	The type used to represent threads in the HThreads API. 
  *
  * This type defines the representation of threads in the HybridThreads
  * API. Whenever a thread is returned to or used by code outside of the
  * HybridThreads system this type is used to encapsulate the return value.
  *
  * This causes the thread representation to be opaque to code outside of
  * the HybridThreads system. This means that the only way that the thread
  * can be manipulated safely is through the used of the HybridThreads API
  * itself.
  */
typedef Huint hthread_t;

/** \brief  The type used to represent keys in the HThreads API.
  */
typedef Huint hthread_key_t;

/** \brief  The type used to represent key destructors in the HThreads API.
  */
typedef void (*key_destructor)(void *);

/** \brief	This structure holds the attributes to assign to threads
  *			created with hthread_create.
  *
  * This structure holds the attributes which are assigned to newly
  * created threads. A structure of this type is passed to hthread_create
  * so that attributes other than the default can be applied to a thread
  * a creation time.
  */
typedef struct
{
	/** \brief	Determines if a thread is created as detached.
	  *
	  * This member variable is used to set whether a newly created thread
	  * should be made detached. If the thread is created as a detached
	  * thread then the all of the threads resources are deallocated
	  * immediately upon thread termination.
	  *
	  * This parameter and the joinable parameter are mutually exclusive.
	  * If both parameters are set then the thread will be created as
	  * joinable and not detached.
	  */
	Hbool	detached;

    /** \brief  Determine if a thread is a hardware or software thread.
      *
      * This member variable is used to set whether a newly created thread
      * will be a hardware thread or a software thread. If the thread is 
      * a hardware thread then the hardware which implements the thread must
      * already be present as a hardware component in the system. If this is
      * the case then the hardware thread will be "created" by telling the
      * hardware to run.
      */
    Hbool   hardware;

    /** \brief  The address to use when creating a hardware thread.
      * 
      * This member variable is used to determine the address to use when
      * creating a new hardware thread. This member variable is only used
      * if the member variable ::hardware is set to true.
      */
    Huint   hardware_addr;

	/** \brief	The stack size to allocate for the new thread.
      *
      * This member variable is used to determine the stack size of a newly
      * created software thread. A stack of this size will be automatically
      * allocated for the thread unless the ::stack_addr member variable
      * is non-null.
	  */
	Huint	stack_size;

    /** \brief  The stack address which has already been allocated.
      *
      * This member variable is used to give a thread a user assigned stack.
      * If this is non-null then it is considered to be a pointer to stack
      * to use for the thread.
      */
    void*   stack_addr;
	
    /** \brief  The scheduling parameter.
      *
      * This member variable is used to give a thread its initial scheduling
      * parameter. If the thread is a software thread then this value will
      * be from 0 - 128 with lower values indicating higher priority.
      */
    Huint   sched_param;

	/** FIXME: Do we need this
	  * \brief	The thread ID of this thread.
	  *
	  * This member variable is used to hold the thread ID of the
	  * thread represented by this structure.
	  */
	//Huint	id;
} hthread_attr_t;

/** \brief	This structure is used to hold a scheduling parameter for the system.
  *
  * This structure is used to pass scheduling information from the user to the
  * operating system. This is then used to control the scheduling of the thread
  * that the scheduling parameter was given for.
  */
typedef struct sched_param
{
    /* \brief   The priority of the thread
     *
     * This member variable is used to store the priority to give to the thread.
     */
    Hint sched_priority;
} sched_param_t;

//extern static void hthread_init(void) __attribute__((constructor)) __attribute__((used));
extern void hthread_exit(void*) __attribute__ ((noreturn));
extern Hint hthread_create(hthread_t*,const hthread_attr_t*,hthread_start_t,void*);
extern Hint hthread_join(hthread_t,void**);
extern Hint hthread_detach(hthread_t);
extern Hint hthread_yield(void);
extern Hint hthread_equal(hthread_t,hthread_t);
extern Hint hthread_setschedparam(hthread_t,Hint,const struct sched_param*);
extern Hint hthread_getschedparam(hthread_t,Hint*,struct sched_param*);
extern Hint hthread_sched(void);
extern hthread_t hthread_self(void);

extern Hint hthread_attr_init(hthread_attr_t*);
extern Hint hthread_attr_destroy(hthread_attr_t*);
extern Hint hthread_attr_setstacksize(hthread_attr_t*,size_t);
extern Hint hthread_attr_getstacksize(const hthread_attr_t*,size_t*);
extern Hint hthread_attr_setstackaddr(hthread_attr_t*,void* );
extern Hint hthread_attr_getstackaddr(const hthread_attr_t*,void**);
extern Hint hthread_attr_setstack(hthread_attr_t*,void*,size_t);
extern Hint hthread_attr_getstack(const hthread_attr_t*,void**,size_t*);
extern Hint hthread_attr_setdetachstate(hthread_attr_t*,Hint);
extern Hint hthread_attr_getdetachstate(const hthread_attr_t*,Hint*);
extern Hint hthread_attr_setinheritsched(hthread_attr_t*,Hint*);
extern Hint hthread_attr_getinheritsched(const hthread_attr_t*,Hint*);
extern Hint hthread_attr_setschedparam(hthread_attr_t*,const struct sched_param*);
extern Hint hthread_attr_getschedparam(const hthread_attr_t*,struct sched_param*);
extern Hint hthread_attr_setschedpolicy(hthread_attr_t*,Hint);
extern Hint hthread_attr_getschedpolicy(const hthread_attr_t*,Hint*);
extern Hint hthread_attr_setscope(const hthread_attr_t*,Hint);
extern Hint hthread_attr_getscope(const hthread_attr_t*,Hint*);
extern Hint hthread_attr_sethardware(hthread_attr_t*,void*);

#endif

