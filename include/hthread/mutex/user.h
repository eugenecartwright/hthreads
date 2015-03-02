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
  */

#ifndef _HYBRID_THREAD_MUTEX_USER_H_
#define _HYBRID_THREAD_MUTEX_USER_H_

#include <httype.h>

/** \brief The mutex object structure.
  *
  * This structure represents a mutex object which can be used in the
  * hthread_mutex_lock and hthread_mutex_unlock functions. However,
  * the mutex must be initialized with a call to the function
  * hthread_mutex_init before either locking or unlocking the mutex.
  *
  * Typically, to create and use a mutex the following process will be taken:
  *     - A mutex attribute object is created and setup
  *         -# A new ::hthread_mutexattr_t structure is allocated.
  *         -# The mutex attribute object is initialized with a call to the
  *             function ::hthread_mutexattr_init.
  *         -# The mutex type is set by calling the function
  *             ::hthread_mutexattr_settype with the desired mutex kind.
  *         -# The mutex number is set by calling the function
  *             ::hthread_mutexattr_setnum with the desired mutex number.
  *     - A mutex object is created and setup
  *         -# A new ::hthread_mutex_t structure is allocated.
  *         -# The mutex object is initialized with a call to the function
  *             ::hthread_mutex_init using the mutex attribute object
  *             allocated and setup previously.
  *         -# The mutex object is used in calls to ::hthread_mutex_lock and
  *             ::hthread_mutex_unlock.
  *     - The mutex attribute object and mutex object are cleaned up
  *         -# The mutex attribute object is destroyed with a call to the
  *             function ::hthread_mutexattr_destroy. This step can be done
  *             any time so long as the mutex attribute object
  *             will not be used in any other calls to hthread_mutex_init.
  *         -# The mutex object is destroyed with a call to the function
  *             ::hthread_mutex_destroy.
  */
typedef struct
{
    /** \internal
      * \brief  The mutex number which is used during the locking and
      *         unlocking process.
      *
      * This structure member keeps track of the mutex number which is used
      * during the locking and unlocking process. The default value for the
      * mutex number is 0 (meaning mutex 0 is locked and unlocked by default)
      * but can be set by the user program using the function
      * ::hthread_mutexattr_setnum.
      */
    Huint   num;

    /** \internal
      * \brief  The mutex type which is used during the locking and
      *         unlocking process.
      *
      * This structure member identifies which mutex type is used during the
      * locking and unlocking process. The default type is
      * HTHREAD_MUTEX_BLOCK_NP which means the blocking mutexes are used
      * be default. The type can be set using the function
      * ::hthread_mutexattr_settype.
      */
    Huint   type;
} hthread_mutex_t;

/** \brief The mutex attribute object structure.
  *
  * This structure represents a mutex attribute object which is used when
  * calling the function hthread_mutex_init. A call to the function
  * hthread_mutexattr_init must be done before the mutex attribute object
  * is used in any other function.
  *
  * Typically, to create and use a mutex the following process will be taken:
  *     - A mutex attribute object is created and setup
  *         -# A new ::hthread_mutexattr_t structure is allocated.
  *         -# The mutex attribute object is initialized with a call to the
  *             function ::hthread_mutexattr_init.
  *         -# The mutex type is set by calling the function
  *             ::hthread_mutexattr_settype with the desired mutex kind.
  *         -# The mutex number is set by calling the function
  *             ::hthread_mutexattr_setnum with the desired mutex number.
  *     - A mutex object is created and setup
  *         -# A new ::hthread_mutex_t structure is allocated.
  *         -# The mutex object is initialized with a call to the function
  *             ::hthread_mutex_init using the mutex attribute object
  *             allocated and setup previously.
  *         -# The mutex object is used in calls to ::hthread_mutex_lock and
  *             ::hthread_mutex_unlock.
  *     - The mutex attribute object and mutex object are cleaned up
  *         -# The mutex attribute object is destroyed with a call to the
  *             function ::hthread_mutexattr_destroy. This step can be done
  *             any time so long as the mutex attribute object
  *             will not be used in any other calls to hthread_mutex_init.
  *         -# The mutex object is destroyed with a call to the function
  *             ::hthread_mutex_destroy.
  */
typedef struct
{
    /** \internal
      * \brief  The mutex number which is used during the locking and
      *         unlocking process.
      *
      * This structure member keeps track of the mutex number which is used
      * during the locking and unlocking process. The default value for the
      * mutex number is 0 (meaning mutex 0 is locked and unlocked by default)
      * but can be set by the user program using the function
      * ::hthread_mutexattr_setnum.
      */
    Huint   num;

    /** \internal
      * \brief  The mutex type which is used during the locking and
      *         unlocking process.
      *
      * This structure member identifies which mutex type is used during the
      * locking and unlocking process. The default type is
      * HTHREAD_MUTEX_BLOCK_NP which means the blocking mutexes are used
      * be default. The type can be set using the function
      * ::hthread_mutexattr_settype.
      */
    Huint   type;
} hthread_mutexattr_t;

extern Hint hthread_mutexattr_init( hthread_mutexattr_t* );
extern Hint hthread_mutexattr_destroy( hthread_mutexattr_t* );
extern Hint hthread_mutexattr_setnum( hthread_mutexattr_t*, Huint );
extern Hint hthread_mutexattr_getnum( hthread_mutexattr_t*, Huint* );
extern Hint hthread_mutexattr_settype( hthread_mutexattr_t*, Huint );
extern Hint hthread_mutexattr_gettype( hthread_mutexattr_t*, Hint* );

extern Hint hthread_mutex_init( hthread_mutex_t*, const hthread_mutexattr_t* );
extern Hint hthread_mutex_lock( hthread_mutex_t* );
extern Hint hthread_mutex_trylock( hthread_mutex_t* );
extern Hint hthread_mutex_unlock( hthread_mutex_t* );
extern Hint hthread_mutex_destroy( hthread_mutex_t*);
extern Hint hthread_mutex_getnum( hthread_mutex_t* );

#endif

