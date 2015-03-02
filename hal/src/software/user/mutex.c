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

/** \file       mutex.c
  * \brief      The implementations of mutex objects for the Hybrid Threads
  *             API. Currently blocking mutexes, spinning mutexes, and
  *             counting mutexes are supported.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Razali Jidin <rjidin@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  */
#include <hthread.h>
#include <sys/syscall.h>

/** \brief  Initialize a mutex object given a mutex attribute object.
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function will initialize a mutex object given a mutex attribute
  * object. If the mutex attribute object is NULL then the default values
  * for the mutex will be used.
  *
  * This function must be called before any other mutex functions may be
  * used on the mutex object.
  *
  * \param mutex    This parameter is the mutex object which is going to
  *                 be initialized. This parameter should be a pointer to a
  *                 valid memory location.
  * \param attr     This parameter is the mutex attribute object which
  *                 contains the attributes to use with the given mutex
  *                 object.
  * \return         The return value is one of the following:
  *                 - HTHREAD_SUCCESS\n
  *                     The mutex object was successfully initialized.
  *                 - HTHREAD_FAILURE\n
  *                     The mutex object was not initialized and should not
  *                     be used in any other mutex operations.
  */
Hint hthread_mutex_init(hthread_mutex_t *mutex, const hthread_mutexattr_t *attr)
{
    if( attr == NULL )
    {
        mutex->num  = 0;
        mutex->type = HTHREAD_MUTEX_DEFAULT;
    }
    else
    {
        mutex->num  = attr->num;
        mutex->type = attr->type;
    }

    _mutex_setkind( mutex->num, mutex->type );
    return SUCCESS;
}

/** \brief  Destroy a mutex object.
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function will destroy a mutex object. This function must be called
  * once the mutex is no longer in used.
  *
  * NOTE: This function should not be called with a with a mutex object
  * which is locked by the calling thread.
  *
  * \param mutex    This parameter is the mutex object which is going to
  *                 be destroyed. This parameter should be a pointer to a
  *                 valid memory location.
  * \return         The return value is one of the following:
  *                 - HTHREAD_SUCCESS\n
  *                 - HTHREAD_FAILURE\n
  */
Hint hthread_mutex_destroy( hthread_mutex_t *mutex )
{
    return SUCCESS;
}

/** \brief 
  */
Hint hthread_mutex_setprioceiling( hthread_mutex_t *mutex, Hint ceil )
{
    return ENOTSUP;
}

/** \brief  
  */
Hint hthread_mutex_getprioceiling( hthread_mutex_t *mutex, Hint *ceil )
{
    return ENOTSUP;
}


/** \brief  Attempt to lock a mutex.
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function will attempt to lock a mutex. This function will not 
  * return until the calling thread has been granted the lock. See the
  * documentation of ::hthread_mutexattr_settype for more information on
  * how this function works for each of the mutex types.
  *
  * \param mutex    This parameter is the mutex object which is going to
  *                 be locked. This parameter should be a pointer to a
  *                 valid memory location.
  * \return         The return value is one of the following:
  *                 - HTHREAD_SUCCESS\n
  *                     The calling thread has been granted the mutex.
  *                 - HTHREAD_FAILURE\n
  *                     The calling thread has not been granted the mutex
  *                     and some error has occurred. This usually means
  *                     that the mutex object has was given as a parameter
  *                     was not valid.
  */
Hint hthread_mutex_lock( hthread_mutex_t *mutex )
{
    return (Hint)do_syscall( HTHREAD_SYSCALL_MUTEX_LOCK,
                             (void*)mutex,
                             NULL,
                             NULL,
                             NULL,
                             NULL );
}

/** \brief  Release a previously acquired lock.
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function will release a previously locked mutex. This function
  * should only be called by the owner of the lock.
  *
  * \param mutex    This parameter is the mutex object which is going to
  *                 be unlocked. This parameter should be a pointer to a
  *                 valid memory location.
  * \return         The return value is one of the following:
  *                 - HTHREAD_SUCCESS\n
  *                     The lock was successfully released.
  *                 - HTHREAD_FAILURE\n
  *                     The lock was not releases. This indicates that either
  *                     the mutex object is invalid or that this function
  *                     was called by a thread that did not own then mutex. 
  */
Hint hthread_mutex_unlock( hthread_mutex_t *mutex )
{
    return (Hint)do_syscall( HTHREAD_SYSCALL_MUTEX_UNLOCK,
                             (void*)mutex,
                             NULL,
                             NULL,
                             NULL,
                             NULL );
}

/** \brief  Attempt to acquire a mutex but return an error condition if the
  *         mutex could not be acquired.
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function will attempt to acquire a mutex. If the mutex is already
  * held by another thread then the function will return with a failure
  * instead of blocking until the mutex can be acquired.
  *
  * \param mutex    This parameter is the mutex object which is going to
  *                 be acquired. This parameter should be a pointer to a
  *                 valid memory location.
  * \return         The return value is one of the following:
  *                 - HTHREAD_SUCCESS\n
  *                     The mutex was successfully acquired.
  *                 - HTHREAD_BUSY\n
  *                     The mutex has already been locked by another thread. 
  *                 - HTHREAD_FAILURE\n
  *                     The lock was not acquired. This indicates that either
  *                     the mutex object is invalid or that some unknown
  *                     error has occurred.
  */
Hint hthread_mutex_trylock( hthread_mutex_t *mutex )
{
    return (Hint)do_syscall( HTHREAD_SYSCALL_MUTEX_TRYLOCK,
                             (void*)mutex,
                             NULL,
                             NULL,
                             NULL,
                             NULL );
}

/** \brief  Retrieve the number of the mutex being used.
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function will retrieve the number of the mutex given to it.
  *
  * \param mutex    This parameter is the mutex object which is going to
  *                 be examined. This parameter should be a pointer to a
  *                 valid memory location.
  * \return         This function returns the mutex number of the given
  *                 mutex.
  */
Hint hthread_mutex_getnum( hthread_mutex_t *mutex )
{
    return mutex->num;
}
