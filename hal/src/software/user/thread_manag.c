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

/** \file       thread_manag.c
  * \brief      The implementations of the thread management function for the
  *             Hybrid Threads API.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  *
  * This file contains implementation of the thread management functions
  * for the Hybrid Threads API. Hybrid Threads is a threading library for
  * embedded systems which is similar in functionality to PThreads. However,
  * the management of most functionality in Hybrid Threads is done in hardware
  * on an FPGA. This frees the processor so that it only performs meaningful
  * computations. The overhead from the use of threading is reduced
  * to a simple context switch.
  */
#include <hthread.h>
#include <sys/syscall.h>

/** \internal
  * \brief	The default attributes for a thread; used when null is given.
  */
const hthread_attr_t	_hthread_default_attrs = {
    Hfalse,                 /* Detached */
    Hfalse,                 /* Hardware */
    0x00000000,             /* Hardware Address */
    HT_STACK_SIZE,          /* Stack Size */
    NULL,                   /* Stack Address */
    HT_DEFAULT_PRI          /* Scheduling Parameter */
};

/** \brief	Create a new thread of control which will execute concurrenly
  *			with the currently running thread.
  *
  * \author	Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function creates a new thread of control which will execute
  * concurrently with the currently running thread. The new thread
  * begins its execution in the function start which is passed arg
  * as its first and only argument.
  *
  * The thread is created with attributes taken from the attr argument.
  * If this argument is null then the thread is created with the default
  * attributes of joinable (not detached).
  *
  * \param	th		If the thread was created successfully then the new
  *					thread will be stored in the location pointed to
  *					by this argument.
  * \param	attr	The attributes to apply to the newly created thread.
  *					See the documentation for ::hthread_attr_t for more on
  *					the allowable attributes.
  * \param	start	A function pointer which is used as the beginning of
  *					the new threads execution. If this function ever returns
  *					then the new thread will be terminated.
  * \param	arg		An arbitrary pointer which is used as the first and
  *					only argument to the start routine.
  * \return			The return value is one of the following:
  *					- HTHREAD_SUCCESS
  *					- HTHREAD_FAILURE
  */
Hint hthread_create( hthread_t *th, const hthread_attr_t *attr, 
					 hthread_start_t start, void *arg )
{
    // If the thread attributes are NULL then use the default attributes.
	if( attr == NULL )  attr = &(_hthread_default_attrs);

    // The user must supply a valid pointer to store the thread id in.
    if( th == NULL )                                return EINVAL;

    // If the thread is a hardware thread then the starting function
    // can be a NULL value otherwise the starting function must be valid.
	if( start == NULL && attr->hardware != Htrue )  return EINVAL;
	
	return (Hint)do_syscall(    HTHREAD_SYSCALL_CREATE,
                                (void*)th,
                                (void*)attr,
                                (void*)start,
                                (void*)arg,
                                NULL );
}

/** \brief	Halt the execution of the currently running thread until
  *			the given thread terminates.
  *
  * \author	Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function halts the execution of the currently running thread
  * until the execution of the thread th is terminated. For this function
  * to be successful the thread th must be in the joinable state and
  * must not have another thread waiting for its termination.
  *
  * If more than one thread attempts to join the same thread then this
  * function will return successfully for the first thread but will
  * return a failure for all other joins.
  *
  * If a thread terminates while in the joinable state then the
  * deallocation of its resources is delayed until it has been joined
  * by another thread. Because of this, every joinable thread must be
  * joined by another thread or resource leaks will occur.
  *
  * \param	th		The thread which the currently running thread will
  *					join with. This thread must be a valid thread which
  *					is in the joinable state and must not have another
  *					thread waiting for its termination.
  * \param	retval	If this value is not NULL then the return value from
  *					the thread th will be stored into the location pointed
  *					to by retval.
  * \return			The return value is one of the following:
  *					- HTHREAD_SUCCESS
  *					- HTHREAD_FAILURE
  */
Hint hthread_join( hthread_t th, void **retval )
{
	return (Hint)do_syscall(    HTHREAD_SYSCALL_JOIN,
                                (void*)th,
                                retval,
                                NULL,
                                NULL,
                                NULL );
}

/** \brief	Voluntarily release the processor so that another thread
  *			can be scheduled to run.
  *
  * \author	Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function causes the currently running thread to be placed back
  * onto the scheduling queue which allows another thread to be scheduled
  * to run.
  *
  * There is no guarantee that this function will actually schedule
  * another thread to run. If no other threads are able to run then
  * the currently running thread will continue to execute.
  *
  * \return			The return value is one of the following:
  *					- HTHREAD_SUCCESS
  *					- HTHREAD_FAILURE
  */
Hint hthread_yield( void )
{
	return (Hint)do_syscall(    HTHREAD_SYSCALL_YIELD,
                                NULL,
                                NULL,
                                NULL,
                                NULL,
                                NULL );
}

/** \brief	Terminate the execution of the currenly running thread.
  *
  * \author	Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function terminates the execution of the currently running
  * thread. If the currently running thread is in the joinable state
  * then the deallocation of its resources will be delayed until another
  * thread performs a join with it, see ::hthread_join for more details.
  *
  * If the currently running thread is in the detached state then the
  * resources used by the thread will be deallocated immediately and the
  * return value will be discarded, otherwise the return value will
  * be passed back to the thread which joins the currenly running thread.
  *
  * Note that when a thread returns from its start routine it works as
  * if the thread had called hthread_exit with the value returned from
  * the start routine.
  *
  * \param	retval	The return value of the thread. If the currently
  *					running thread is in the joinable state then this
  *					value is returned to the thread which joins with
  *					the currently running thread, otherwise this
  *					value is discarded.
  * \return			This function never returns to the calling thread.
  */
void hthread_exit( void *retval )
{
    // Cause the thread to exit
	do_syscall( HTHREAD_SYSCALL_EXIT,
                retval,
                NULL,
                NULL,
                NULL,
                NULL );

    // The code should never reach this point
    while(1)
    {
        DEBUG_PRINTF( "Exited thread is continuing to run\n" );
    }
}

/** \brief	Test if two thread's are actually the same thread.
  * 
  * \author	Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function determines whether two thread types represent the same
  * thread. This function will return a non-zero value if the two threads
  * are equal and zero if the two threads are not equal.
  *
  * \param th1	The first thread to be compared.
  * \param th2	The second thread to be compared.
  * \return		The return value is one of the following:
  *				- Non-Zero\n
  *					The two threads are equal.
  *				- Zero\n
  *					The two threads are not equal.
  */
Hint hthread_equal( hthread_t th1, hthread_t th2 )
{
	return (th1 == th2);
}

/** \brief	Get the thread id for the currently running thread.
  *
  * \author	Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function returns the thread id of the currently running thread
  * to the caller.
  *
  * \return	The thread ID of the caller.
  */
hthread_t hthread_self( void )
{
    return (hthread_t)do_syscall(   HTHREAD_SYSCALL_CURRENTID,
                                    NULL,
                                    NULL,
                                    NULL,
                                    NULL,
                                    NULL );

}

/** \brief	Run the scheduler.
  *
  * \author	Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function runs the Hthreads scheduler. This function is not
  * usually needed for the normal operation of threads, however, the
  * idle thread makes use of this function.
  *
  * \return	The status of the scheduler invocation.
  */
Hint hthread_sched( void )
{
	return (Hint)do_syscall(   HTHREAD_SYSCALL_SCHED,
                               NULL,
                               NULL,
                               NULL,
                               NULL,
                               NULL );
}
