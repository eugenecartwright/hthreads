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

#ifndef _HTHREAD_PTHREAD_H_
#define _HTHREAD_PTHREAD_H_

#include <hthread.h>

#define pthread_t                           hthread_t
#define pthread_attr_t                      hthread_attr_t

#define pthread_cond_t                      hthread_cond_t
#define pthread_condattr_t                  hthread_condattr_t

#define pthread_mutex_t                     hthread_mutex_t
#define pthread_mutexattr_t                 hthread_mutexattr_t

#define pthread_create                      hthread_create
#define pthread_exit                        hthread_exit
#define pthread_join                        hthread_join
#define pthread_once        
#define pthread_kill        
#define pthread_self                        hthread_self
#define pthread_equal                       hthread_equal
#define pthread_yield                       hthread_yield
#define pthread_detach                      hthread_detach
#define pthread_atfork      
#define pthread_key_create                  hthread_key_create
#define pthread_key_delete                  hthread_key_delete
#define pthread_getspecific                 hthread_getspecific
#define pthread_setspecific                 hthread_setspecific
#define pthread_cancel
#define pthread_cleanup_pop
#define pthread_cleanup_push
#define pthread_setcancelstate
#define pthread_getcancelstate
#define pthread_setcanceltype
#define pthread_getcanceltype
#define pthread_testcancel
#define pthread_getschedparam               hthread_setschedparam
#define pthread_setschedparam               hthread_getschedparam
#define pthread_sigmask     
#define pthread_attr_init                   hthread_attr_init
#define pthread_attr_destroy                hthread_attr_destroy
#define pthread_attr_setdetachstate         hthread_attr_setdetachstate
#define pthread_attr_getdetachstate         hthread_attr_getdetachstate
#define pthread_attr_getstackaddr           hthread_attr_getstackaddr
#define pthread_attr_getstacksize           hthread_attr_getstacksize
#define pthread_attr_setstackaddr           hthread_attr_setstackaddr
#define pthread_attr_getstacksize           hthread_attr_getstacksize
#define pthread_attr_setstack
#define pthread_attr_getstack
#define pthread_attr_setguardsize
#define pthread_attr_getguardsize
#define pthread_attr_getschedparam          hthread_attr_getschedparam
#define pthread_attr_setschedparam          hthread_attr_setschedparam
#define pthread_attr_getschedpolicy         hthread_attr_getschedpolicy
#define pthread_attr_setschedpolicy         hthread_attr_setschedpolicy
#define pthread_attr_getinheritsched        hthread_attr_getinheritsched
#define pthread_attr_setinheritsched        hthread_attr_setinheritsched
#define pthread_attr_setscope               hthread_attr_setscope
#define pthread_attr_getscope               hthread_attr_getscope
#define pthread_attr_getconcurrency
#define pthread_attr_setconcurrency
#define pthread_rwlock_init
#define pthread_rwlock_destroy
#define pthread_rwlock_rdlock
#define pthread_rwlock_wrlock
#define pthread_rwlock_unlock
#define pthread_rwlock_tryrdlock
#define pthread_rwlock_trywrlock
#define pthread_rwlockattr_init
#define pthread_rwlockattr_destroy
#define pthread_rwlockattr_getpshared
#define pthread_rwlockattr_setpshared
#define pthread_is_threaded_np
#define pthread_is_main_np
#define pthread_cond_signal_thread_np
#define pthread_cond_timedwait_relative_np
#define pthread_create_suspended_np
#define pthread_yield_np                    hthread_yield
#define pthread_mutex_init                  hthread_mutex_init
#define pthread_mutex_destroy               hthread_mutex_destroy
#define pthread_mutex_lock                  hthread_mutex_lock 
#define pthread_mutex_unlock                hthread_mutex_unlock   
#define pthread_mutex_trylock               hthread_mutex_trylock
#define pthread_mutex_setprioceiling        hthread_mutex_setprioceiling
#define pthread_mutex_getprioceiling        hthread_mutex_getprioceiling
#define pthread_mutexattr_init              hthread_mutexattr_init
#define pthread_mutexattr_destroy           hthread_mutexattr_destroy
#define pthread_mutexattr_getpshared        hthread_mutexattr_getpshared
#define pthread_mutexattr_setpshared        hthread_mutexattr_setpshared
#define pthread_mutexattr_gettype           hthread_mutexattr_gettype
#define pthread_mutexattr_settype           hthread_mutexattr_settype
#define pthread_mutexattr_getprotocol       hthread_mutexattr_getprotocol
#define pthread_mutexattr_setprotocol       hthread_mutexattr_setprotocol
#define pthread_mutexattr_setprioceiling    hthread_mutexattr_setprioceiling
#define pthread_mutexattr_getprioceiling    hthread_mutexattr_getprioceiling
#define pthread_cond_init                   hthread_cond_init
#define pthread_cond_destroy                hthread_cond_destroy
#define pthread_cond_signal                 hthread_cond_signal
#define pthread_cond_broadcast              hthread_cond_broadcast
#define pthread_cond_wait                   hthread_cond_wait
#define pthread_cond_timedwait
#define pthread_condattr_init               hthread_condattr_init
#define pthread_condattr_destroy            hthread_condattr_destroy
#define pthread_condattr_getpshared         hthread_condattr_getpshared
#define pthread_condattr_setpshared         hthread_condattr_setpshared

#endif
