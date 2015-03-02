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

#ifndef _HYBRID_THREAD_CONDVAR_USER_H_
#define _HYBRID_THREAD_CONDVAR_USER_H_

#include <httype.h>

/** \brief The condition variable object structure.
  *
  * This structure represents a condition variable object which can be used
  * in the ::hthread_cond_wait, ::hthread_cond_signal, and
  * ::hthread_cond_broadcast functions. However, the condition variable must
  * be initialized with a call to the function ::hthread_cond_init before
  * any other condition variable operation is used.
  *
  * Typically, to create and use a condition variable the following process
  * will be taken:
  *     - A condition variable attribute object is created and setup
  *         -# A new ::hthread_condattr_t structure is allocated.
  *         -# The condition variable attribute object is initialized with
  *            a call to the function ::hthread_mutexattr_init.
  *         -# The condition variable number is set by calling the function
  *             ::hthread_condattr_setnum with the desired number.
  *     - A condition variable object is created and setup
  *         -# A new ::hthread_cond_t structure is allocated.
  *         -# The condition variable  object is initialized with a call to
  *            the function ::hthread_cond_init using the condition variable
  *            attribute object allocated and setup previously.
  *         -# The mutex object is used in calls to ::hthread_cond_wait,
  *             ::hthread_cond_signal, and ::hthread_cond_broadcast.
  *     - The condition variable attribute object and condition variable
  *       object are cleaned up
  *         -# The condition variable  attribute object is destroyed with a
  *            call to the function ::hthread_condattr_destroy. This step
  *            can be done any time so long as the condition variable
  *            attribute object will not be used in any other calls to
  *            ::hthread_cond_init.
  *         -# The condition variable  object is destroyed with a call to
  *            the function ::hthread_cond_destroy.
  */
typedef struct
{
    /** \internal
      * \brief  The condition variable number which is used to determine
      *         which condition variable to communicate with during
      *         signal, broadcast, and wait operations.
      *
      * This structure member keeps tract of the condition variable number
      * which is used during the signalling, broadcasting, and waiting
      * operations. The default value for the condition variable number is
      * 0 but can be set by the user program by using the function
      * ::hthread_condattr_setnum.
      */
    Huint   num;
} hthread_cond_t;

/** \brief The condition variable attribute object structure.
  *
  * This structure represents a condition variable attribute object which
  * is used when calling the function ::hthread_cond_init. A call to the
  * function ::hthread_condattr_init must be done before the condition
  * variable attribute object is used in any other function.
  *
  * Typically, to create and use a condition variable the following process
  * will be taken:
  *     - A condition variable attribute object is created and setup
  *         -# A new ::hthread_condattr_t structure is allocated.
  *         -# The condition variable attribute object is initialized with
  *            a call to the function ::hthread_mutexattr_init.
  *         -# The condition variable number is set by calling the function
  *             ::hthread_condattr_setnum with the desired number.
  *     - A condition variable object is created and setup
  *         -# A new ::hthread_cond_t structure is allocated.
  *         -# The condition variable  object is initialized with a call to
  *            the function ::hthread_cond_init using the condition variable
  *            attribute object allocated and setup previously.
  *         -# The mutex object is used in calls to ::hthread_cond_wait,
  *             ::hthread_cond_signal, and ::hthread_cond_broadcast.
  *     - The condition variable attribute object and condition variable
  *       object are cleaned up
  *         -# The condition variable  attribute object is destroyed with a
  *            call to the function ::hthread_condattr_destroy. This step
  *            can be done any time so long as the condition variable
  *            attribute object will not be used in any other calls to
  *            ::hthread_cond_init.
  *         -# The condition variable  object is destroyed with a call to
  *            the function ::hthread_cond_destroy.
  */
typedef struct
{
    /** \internal
      * \brief  The condition variable number which is used to determine
      *         which condition variable to communicate with during
      *         signal, broadcast, and wait operations.
      *
      * This structure member keeps tract of the condition variable number
      * which is used during the signalling, broadcasting, and waiting
      * operations. The default value for the condition variable number is
      * 0 but can be set by the user program by using the function
      * ::hthread_condattr_setnum.
      */
    Huint   num;
} hthread_condattr_t;

extern Hint hthread_cond_init( hthread_cond_t*, hthread_condattr_t*);
extern Hint hthread_cond_destroy( hthread_cond_t*);
extern Hint hthread_cond_signal( hthread_cond_t*);
extern Hint hthread_cond_broadcast( hthread_cond_t*);
extern Hint hthread_cond_wait( hthread_cond_t*, hthread_mutex_t*);
extern Hint hthread_cond_getnum( hthread_cond_t* );

extern Hint hthread_condattr_init( hthread_condattr_t*);
extern Hint hthread_condattr_destroy( hthread_condattr_t*);
extern Hint hthread_condattr_setnum( hthread_condattr_t*, Huint );
extern Hint hthread_condattr_getnum( hthread_condattr_t*, Huint* );

#endif

