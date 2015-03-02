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

/** \file       mutex_attr.c
  * \brief      The implementations of mutex attributes for the Hybrid Threads
  *             API. Currently blocking mutexes, spinning mutexes, and
  *             counting mutexes are supported.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Razali Jidin <rjidin@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  */
#include <hthread.h>
#include <mutex/mutex.h>

/** \brief  Initialize the attributes for a mutex attribute object.
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function initializes the mutex attribute object attr and fills it
  * with the default values of blocking operation on mutex number 0. This 
  * function must be called on every mutex attribute object before it is
  * used.
  *
  * \param attr     This parameter is the mutex attribute object which 
  *                 is going to be initialized. This parameter should be
  *                 a pointer to a valid memory location.
  * \return         The return value is one of the following:
  *                 - HTHREAD_SUCCESS\n
  *                     The mutex attribute object was successfully initalizes
  *                     and has been filled with the default values.
  *                 - HTHREAD_FAILURE\n
  *                     The mutex attribute object was not initialized properly
  *                     and should not be used in any other mutex operations.
  */
Hint hthread_mutexattr_init( hthread_mutexattr_t *attr )
{
    attr->num   = 0;
    attr->type  = HTHREAD_MUTEX_DEFAULT;

    return SUCCESS;
}

/** \brief  Destroy a mutex attribute object.
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function destroys a mutex attribute object. This object cannot be
  * reused again until it has been reinitialized. In the current implementation
  * this function does nothing.
  *
  * \param attr     This parameter is the mutex attribute object which is
  *                 going to be destroyed. This parameter should be a
  *                 pointer to a valid memory location.
  * \return         The return value is one of the following:
  *                 - HTHREAD_SUCCESS\n
  *                     The mutex attribute object was destroyed successfull.
  *                 - HTHREAD_FAILURE\n
  *                     A failure was encountered during the destruction of
  *                     the mutex attribute object.
  */
Hint hthread_mutexattr_destroy( hthread_mutexattr_t *attr )
{
    return SUCCESS;
}

/** \brief  Set the mutex number for the mutex attribute object.
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function sets the mutex number for the mutex attribute object. The
  * mutex number identifies a specific mutex to use during the locking and
  * unlocking operations.
  *
  * The mutex number is an Huint in the range 0 to 511. Two or more threads
  * can synchronize on the same mutex by using the same mutex number. This
  * is especially useful when interacting with hardware threads.
  *
  * \param attr     This parameter is the mutex attribute object which is
  *                 having it's mutex number set. This parameter should be a
  *                 pointer to a valid memory location.
  * \param num      This parameter identifies the mutex number of assigned
  *                 to the given mutex attribute object. This number should
  *                 be in the range 0 to 511.
  * \return         The return value is one of the following:
  *                 - HTHREAD_SUCCESS\n
  *                     The mutex number for the mutex attribute object was
  *                     successfully set.
  *                 - HTHREAD_FAILURE\n
  *                     The nutex number of the mutex attribute object was not
  *                     set because the number was not in the range 0 to 511.
  */
Hint hthread_mutexattr_setnum( hthread_mutexattr_t *attr, Huint num )
{
    if( num > HT_SEM_MAXNUM ) return EINVAL;
    
    attr->num = num;
    return SUCCESS;
}

/** \brief  Retrieve the mutex number for the given mutex attribute object.
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function returns the mutex number for the given mutex attribute
  * object. The return value is in the range 0 to 511.
  *
  * \param attr     This parameter is the mutex attribute object from which
  *                 the mutex number is be requested. This parameter should be
  *                 a pointer to a valid memory location.
  * \return         The return value is an integer in the range 0 to 511 and
  *                 identifies the mutex number used by the given mutex
  *                 attribute object.
  */
Hint hthread_mutexattr_getnum( hthread_mutexattr_t *attr, Huint *num )
{
    *num = attr->num;
    return SUCCESS;
}

/** \brief  Set the type of mutex that the mutex attribute object identifies.
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function sets the mutex type for the given mutex attribute object.
  * Currently two mutex types are supported:
  *     - HTHREAD_MUTEX_BLOCK_NP: Blocking Mutexes\n
  *         When ::hthread_mutex_lock is called the mutex will attempt to 
  *         acquire a lock on the mutex. If the lock is granted then
  *         ::hthread_mutex_lock will return immediately. If the lock is owned
  *         by another thread then the thread requesting the lock will put
  *         to sleep.
  *         When the owner of the mutex releases the mutex a single thread
  *         will wake up and be granted the mutex lock. The lock is granted in
  *         FIFO order. Once a sleeping thread has been granted the
  *         lock it will return from the ::hthread_mutex_lock call.
  *     - HTHREAD_MUTEX_SPIN_NP: Busy Wait Mutexes\n
  *         When ::hthread_mutex_lock is called the mutex will attempt to 
  *         acquire a lock on the mutex. If the lock is granted then
  *         ::hthread_mutex_lock will return immediately. If the lock is owned
  *         by another thread it will continue to attempt locking the mutex.
  *         When the thread has successfully locked the mutex the
  *         ::hthread_mutex_lock function will return.
  *         When the owner of the mutex releases the mutex all threads
  *         which are attempting to lock the mutex will compete for the
  *         lock. The "fastest" thread to the mutex will be granted the lock.
  *
  * \param attr     This parameter is the mutex attribute object which is
  *                 having it's type set. This parameter should be a
  *                 pointer to a valid memory location.
  * \param type     This parameter indicates the type which is being assigned
  *                 to the given mutex attribute object. This should be either
  *                 HTHREAD_MUTEX_BLOCK_NP or HTHREAD_MUTEX_SPIN_NP.
  * \return         The return value is one of the following:
  *                 - HTHREAD_SUCCESS\n
  *                     The type of the mutex was successfully set.
  *                 - HTHREAD_FAILURE\n
  *                     The type of the mutex was not set because the
  *                     mutex kind was not valid.
  */
Hint hthread_mutexattr_settype( hthread_mutexattr_t *attr, Huint type )
{
    switch( type )
    {
    case HTHREAD_MUTEX_FAST_NP:
    case HTHREAD_MUTEX_RECURSIVE_NP:
    case HTHREAD_MUTEX_ERRORCHECK_NP:
        attr->type = type;
        return SUCCESS;

    default:
        return EINVAL;
    }
}

/** \brief Retrieve the mutex type.
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function returns the type. See the documentation for the function
  * ::hthread_mutexattr_settype for more information on the supported mutex
  * tyeps.
  *
  * \param attr     This parameter is the mutex attribute object from which
  *                 the type is being retrieved. This parameter should be a
  *                 pointer to a valid memory location.
  * \return         An integer value indicating the type of the mutex.
  */
Hint hthread_mutexattr_gettype( hthread_mutexattr_t *attr, Hint *kind )
{
    *kind = attr->type;
    return SUCCESS;
}

/** \brief  
  */
Hint hthread_mutexattr_setpshared( hthread_mutexattr_t *attr, Hint pshared )
{
    return ENOTSUP;
}

/** \brief  
  */
Hint hthread_mutexattr_getpshared( hthread_mutexattr_t *attr, Hint *pshared )
{
    return ENOTSUP;
}

/** \brief  
  */
Hint hthread_mutexattr_setprotocol( hthread_mutexattr_t *attr, Hint protocol )
{
    return ENOTSUP;
}

/** \brief  
  */
Hint hthread_mutexattr_getprotocol( hthread_mutexattr_t *attr, Hint *protocol )
{
    return ENOTSUP;
}

/** \brief  
  */
Hint hthread_mutexattr_setprioceiling( hthread_mutexattr_t *attr, Hint ceil )
{
    return ENOTSUP;
}

/** \brief  
  */
Hint hthread_mutexattr_getprioceiling( hthread_mutexattr_t *attr, Hint *ceil )
{
    return ENOTSUP;
}

