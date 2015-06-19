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

#ifndef _HTHREAD_PTHREAD_MUTEX_H_
#define _HTHREAD_PTHREAD_MUTEX_H_

#define __USE_UNIX98
#include <errno.h>
#include <pthread.h>
#include <hthread/httype.h>

// Definitions of the hthreads mutex and mutexattr objects
#define hthread_mutex_t                     pthread_mutex_t
#define hthread_mutexattr_t                 pthread_mutexattr_t

// Redefinition of hthreads constants
#define HTHREAD_MUTEX_NORMAL                PTHREAD_MUTEX_NORMAL
#define HTHREAD_MUTEX_RECURSIVE             PTHREAD_MUTEX_RECURSIVE
#define HTHREAD_MUTEX_ERRORCHECK            PTHREAD_MUTEX_ERRORCHECK
#define HTHREAD_MUTEX_DEFAULT               PTHREAD_MUTEX_DEFAULT
#define HTHREAD_MUTEX_FAST_NP               PTHREAD_MUTEX_NORMAL
#define HTHREAD_MUTEX_RECURSIVE_NP          PTHREAD_MUTEX_RECURSIVE
#define HTHREAD_MUTEX_ERRORCHECK_NP         PTHREAD_MUTEX_ERRORCHECK

// Redefinition of the hthreads functions
#define hthread_mutex_init                  pthread_mutex_init
#define hthread_mutex_destroy               pthread_mutex_destroy
#define hthread_mutex_lock                  pthread_mutex_lock 
#define hthread_mutex_unlock                pthread_mutex_unlock   
#define hthread_mutex_trylock               pthread_mutex_trylock
#define hthread_mutex_getnum                pthread_mutex_getnum
#define hthread_mutex_setprioceiling        pthread_mutex_setprioceiling
#define hthread_mutex_getprioceiling        pthread_mutex_getprioceiling

#define hthread_mutexattr_init              pthread_mutexattr_init
#define hthread_mutexattr_destroy           pthread_mutexattr_destroy
#define hthread_mutexattr_getpshared        pthread_mutexattr_getpshared
#define hthread_mutexattr_setpshared        pthread_mutexattr_setpshared
#define hthread_mutexattr_gettype           pthread_mutexattr_gettype
#define hthread_mutexattr_settype           pthread_mutexattr_settype
#define hthread_mutexattr_getprotocol       pthread_mutexattr_getprotocol
#define hthread_mutexattr_setprotocol       pthread_mutexattr_setprotocol
#define hthread_mutexattr_setprioceiling    pthread_mutexattr_setprioceiling
#define hthread_mutexattr_getprioceiling    pthread_mutexattr_getprioceiling
#define hthread_mutexattr_setnum(m,n)
#define hthread_mutexattr_getnum(m)         0

#endif
