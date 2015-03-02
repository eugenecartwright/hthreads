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

/** \file       thread_sched.c
  * \brief      The implementations of the scheduling functions for the
  *             Hybrid Threads API.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  *
  * This file contains implementation of the scheduling functions for the
  * Hybrid Threads API. Hybrid Threads is a threading library for embedded
  * systems which is similar in functionality to PThreads. However, the
  * management for many parts of the Hybrid Threads system is done in hardware
  * on an FPGA. This frees the processor so that it only performs meaningful
  * computations. The overhead from the use of threading is reduced
  * to a simple context switch.
  */
#include <hthread.h>
#include <sys/syscall.h>

// FIXME: Update to be pthread compatible

/** \internal
  * \brief  Set the given threads scheduling parameter.
  *
  * \author Wesley Peck <peckw@ittc.ku.edu>
  *
  * This function sets the given threads priority value and returns
  * it to the caller. The priority of a thread ranges from 0 to 127 with
  * smaller values indicating higher priorities.
  *
  * Setting a threads priority can only be done by the thread itself or
  * the parent of the thread. If a thread other than these two attempts
  * to change another thread's priority then an error value will be returned.
  *
  * \param  th  The thread id of the thread to set the priority for.
  * \param  pl  The scheduling policy to use. This parameter is unused.
  * \param  pr  The priority value to give to the thread. This value should
  *             be in the range 0 to 127 with lower values indicating higher
  *             priority.
  * \return     This function returns one of the following:\n
  *             - HT_SUCCESS\n
  *                 The thread's priority was updated to the new value.
  *             - HT_FAILURE\n
  *                 The thread's priority was not updated because the
  *                 set priority operation failed.
  */
Hint hthread_setschedparam( hthread_t th, Hint pl, const struct sched_param *pr )
{   
	return (Hint)do_syscall(    HTHREAD_SYSCALL_SETPRI,
                                (void*)th,
                                (void*)(pr->sched_priority),
                                NULL,
                                NULL,
                                NULL );
}

/** \internal
  * \brief  Retreive the given threads priority.
  *
  * \author Wesley Peck <peckw@ittc.ku.edu>
  *
  * This function retrieves the given threads priority value and returns
  * it to the caller. The priority of a thread ranges from 0 to 127 with
  * smaller values indicating higher priorities.
  *
  * \param  th  The thread id to retrieve the priority of.
  * \return     This function returns a positive value in the range 0 to 127
  *             upon success and a negative value to indicate failure.
  */ 
Hint hthread_getschedparam( hthread_t th, Hint *policy, struct sched_param *pr )
{   
    // Make sure policy is not a NULL pointer before
    // dereferencing it. You may accidentally write
    // to the Microblaze's IVT
    if (policy != NULL)
        *policy = SCHED_OTHER;
	return (Hint)do_syscall(    HTHREAD_SYSCALL_GETPRI,
                                (void*)th,
                                (void*)(&pr->sched_priority),
                                NULL,
                                NULL,
                                NULL );
}

