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

#ifndef _HTHREAD_PTHREAD_H_
#define _HTHREAD_PTHREAD_H_

#define __USE_UNIX98
#include <errno.h>
#include <pthread.h>
#include <hthread/httype.h>
#include <mutex.h>
#include <cond.h>

#define hthread_t                           pthread_t
#define hthread_attr_t                      pthread_attr_t
typedef void* (*hthread_start_t)(void*);

// Forward declaration of functions
extern int hthread_attr_sethardware( hthread_attr_t*, void* );

// Redefinition of hthreads constants
#define HTHREAD_CREATE_DETACHED             PTHREAD_CREATE_DETACHED
#define HTHREAD_CREATE_JOINABLE             PTHREAD_CREATE_JOINABLE

// Redifinition of hthreads functions
#define hthread_create                      pthread_create
#define hthread_exit                        pthread_exit
#define hthread_join                        pthread_join
//#define hthread_once        
//#define hthread_kill        
#define hthread_self                        pthread_self
#define hthread_equal                       pthread_equal
#define hthread_yield                       sched_yield
#define hthread_detach                      pthread_detach
//#define hthread_atfork      
#define hthread_key_create                  pthread_key_create
#define hthread_key_delete                  pthread_key_delete
#define hthread_getspecific                 pthread_getspecific
#define hthread_setspecific                 pthread_setspecific
//#define hthread_cancel
//#define hthread_cleanup_pop
//#define hthread_cleanup_push
//#define hthread_setcancelstate
//#define hthread_getcancelstate
//#define hthread_setcanceltype
//#define hthread_getcanceltype
//#define hthread_testcancel
#define hthread_getschedparam               pthread_getschedparam
#define hthread_setschedparam               pthread_setschedparam
//#define hthread_sigmask     
#define hthread_attr_init                   pthread_attr_init
#define hthread_attr_destroy                pthread_attr_destroy
#define hthread_attr_setdetachstate         pthread_attr_setdetachstate
#define hthread_attr_getdetachstate         pthread_attr_getdetachstate
#define hthread_attr_getstackaddr           pthread_attr_getstackaddr
#define hthread_attr_getstacksize           pthread_attr_getstacksize
#define hthread_attr_setstackaddr           pthread_attr_setstackaddr
#define hthread_attr_getstacksize           pthread_attr_getstacksize
#define hthread_attr_setstack               pthread_attr_setstack
#define hthread_attr_getstack               pthread_attr_getstack
//#define hthread_attr_setguardsize
//#define hthread_attr_getguardsize
#define hthread_attr_getschedparam          pthread_attr_getschedparam
#define hthread_attr_setschedparam          pthread_attr_setschedparam
#define hthread_attr_getschedpolicy         pthread_attr_getschedpolicy
#define hthread_attr_setschedpolicy         pthread_attr_setschedpolicy
#define hthread_attr_getinheritsched        pthread_attr_getinheritsched
#define hthread_attr_setinheritsched        pthread_attr_setinheritsched
#define hthread_attr_setscope               pthread_attr_setscope
#define hthread_attr_getscope               pthread_attr_getscope
//#define hthread_attr_getconcurrency
//#define hthread_attr_setconcurrency
//#define hthread_rwlock_init
//#define hthread_rwlock_destroy
//#define hthread_rwlock_rdlock
//#define hthread_rwlock_wrlock
//#define hthread_rwlock_unlock
//#define hthread_rwlock_tryrdlock
//#define hthread_rwlock_trywrlock
//#define hthread_rwlockattr_init
//#define hthread_rwlockattr_destroy
//#define hthread_rwlockattr_getpshared
//#define hthread_rwlockattr_setpshared
//#define hthread_is_threaded_np
//#define hthread_is_main_np
//#define hthread_cond_signal_thread_np
//#define hthread_cond_timedwait_relative_np
//#define hthread_create_suspended_np
#define hthread_yield_np                    pthread_yield

#define SUCCESS                             (0)
#define FAILURE                             (-1)

#endif
