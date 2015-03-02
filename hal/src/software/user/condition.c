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

/** \file       condition.c
  * \brief      The implementation of condition variables for the Hybrid
  *             Threads API.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Razali Jidin <rjidin@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  */
#include <hthread.h>
#include <sys/syscall.h>

/** \brief  Initialize a condition variable object given a condition variable
  *          attribute object.
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function will initialize a condition variable object given a condition
  * variable attribute object. If the condition variable attribute object is
  * NULL then the default values for the condition variable will be used.
  *
  * This function must be called before any other condition variable functions
  * may be used on the condition variable object.
  *
  * \param cond     This parameter is the condition variable object which is
  *                 going to be initialized. This parameter should be a
  *                 pointer to a valid memory location.
  * \param attr     This parameter is the condition variable attribute object
  *                 which contains the attributes to use with the given
  *                 condition variable object.
  * \return         The return value is one of the following:
  *                 - HTHREAD_SUCCESS\n
  *                     The condtition variable object was successfully
  *                     initialized.
  *                 - HTHREAD_FAILURE\n
  *                     The condition variable object was not initialized and
  *                     should not be used in any other mutex operations.
  */
Hint hthread_cond_init( hthread_cond_t *cond, hthread_condattr_t *attr )
{
    if( attr == NULL )  cond->num  = 0;
    else                cond->num  = attr->num;

    return SUCCESS;
}

/** \brief  Destroy a condition variable object and release any resources
  *         that are being used.
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function will destroy a condition variable object and release the
  * resources that are being used by it. After this function is called the
  * condition variable object must not be used.
  *
  * \param cond     This parameter is the condition variable object which is
  *                 going to be destroyed. This parameter should be a
  *                 pointer to a valid memory location.
  * \return         The return value is one of the following:
  *                 - HTHREAD_SUCCESS\n
  *                     The condtition variable object was successfully
  *                     destroyed.
  *                 - HTHREAD_FAILURE\n
  *                     The condition variable object was not destroyed and
  *                     the resources that it used were not released.
  */
Hint hthread_cond_destroy( hthread_cond_t *cond )
{
    return SUCCESS;
}

/** \brief  Signal a condition variable object to wake up one thread which
  *         is waiting for the condition to occur.
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function will wake up a single thread which is waiting on the
  * condition variable. If the condition variable has no waiting threads
  * then nothing will occur.
  *
  * This function will wake up exactly one thread, however, the exact thread
  * which is woken up is undefined.
  *
  * \param cond     This parameter is the condition variable object which will
  *                 be used. This parameter should be a pointer to a valid
  *                 memory location.
  * \return         The return value is one of the following:
  *                 - HTHREAD_SUCCESS\n
  *                     The function successfully processed the request.
  *                 - HTHREAD_FAILURE\n
  *                     The function failed to process the request.
  */
Hint hthread_cond_signal( hthread_cond_t *cond )
{
    return (Hint)do_syscall( HTHREAD_SYSCALL_COND_SIGNAL,
                             (void*)cond,
                             NULL,
                             NULL,
                             NULL,
                             NULL );
}

/** \brief  Signal a condition variable object to wake up all threads which
  *         is waiting for the condition to occur.
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function will wake up all of the threads which are waiting on the
  * condition variable. If the condition variable has no waiting threads
  * then nothing will occur.
  *
  * \param cond     This parameter is the condition variable object which will
  *                 be used. This parameter should be a pointer to a valid
  *                 memory location.
  * \return         The return value is one of the following:
  *                 - HTHREAD_SUCCESS\n
  *                     The function successfully processed the request.
  *                 - HTHREAD_FAILURE\n
  *                     The function failed to process the request.
  */
Hint hthread_cond_broadcast( hthread_cond_t *cond )
{
    return (Hint)do_syscall( HTHREAD_SYSCALL_COND_BROADCAST,
                             (void*)cond,
                             NULL,
                             NULL,
                             NULL,
                             NULL );
}

/** \brief  Wait on a condition variable until another thread either signals
  *         or broadcasts.
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function will cause the callling thread to wait on the condition
  * variable. The thread can be woken up by either signalling or broadcasting
  * to the condition variable. The mutex object parameter is unlocked if the 
  * thread will be blocked because of this function and will be relocked
  * before the function returns to the caller.
  *
  * \param cond     This parameter is the condition variable object which will
  *                 be used. This parameter should be a pointer to a valid
  *                 memory location.
  * \param mutex    This parameter is the mutex object which will be used. The
  *                 parameter should be a pointer to a valid memory location.
  * \return         The return value is one of the following:
  *                 - HTHREAD_SUCCESS\n
  *                     The function successfully processed the request.
  *                 - HTHREAD_FAILURE\n
  *                     The function failed to process the request.
  */
Hint hthread_cond_wait( hthread_cond_t *cond, hthread_mutex_t *mutex )
{
    return (Hint)do_syscall( HTHREAD_SYSCALL_COND_WAIT,
                             (void*)cond,
                             (void*)mutex,
                             NULL,
                             NULL,
                             NULL );
}

/** \brief  Get the condition variable number of a condition variable.
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function will return the condition variable number of the given
  * condition variable to the user.
  * 
  * \param cond     This parameter is the condition variable object which will
  *                 be used. This parameter should be a pointer to a valid
  *                 memory location.
  * \return         The return value will be the condition variable number.
  */
Hint hthread_cond_getnum( hthread_cond_t *cond )
{
    return cond->num;
}
