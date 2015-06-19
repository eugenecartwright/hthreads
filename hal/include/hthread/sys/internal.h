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
  *	\file       internal.h
  * \brief      Declaration of structures used internally by hthreads.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  *
  *	This file contains the declarations of structures and types used
  * internally by the hybrid threads implementation. None of this data
  * is exposed to the user side.
  */

#ifndef _HYBRID_THREADS_INTERNAL_H_
#define _HYBRID_THREADS_INTERNAL_H_

#include <hthread.h>

/** \internal
  * \brief	The internal structure used to keep track of all threads.
  *
  * This structure is the structure used internally to keep track of
  * all of the threads in the system. The "threads" which are used by
  * user applications are really just indicies into an array of
  * hthread_thread_t structures.
  */
typedef struct
{
	/** \brief	If this value is true then the thread has been created but
	  *			has never been run.
	  */
	Hbool				newthread;

    /** \brief  The return value of a thread.
      */
    void*               retval;

    /** \brief  The architecture dependent context structure */
	void*	            context;

	/** \brief	A pointer to the stack used by this tread. */
    void                *stack;

    /** \brief  The size of the stack that this thread contains */
    Huint               stacksize;

    /** \brief  A value indicating if the threads is a hardware thread */
    Huint               hardware;
} hthread_thread_t;

/** \internal
  * \brief	The default attributes given to a thread when null is used.
  */
extern hthread_attr_t _hthread_default_attrs;

#endif

