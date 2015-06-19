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

#ifndef _HTHREAD_PTHREAD_COND_H_
#define _HTHREAD_PTHREAD_COND_H_

// Definitions of the hthreads cond and condattr objects
#define hthread_cond_t                      pthread_cond_t
#define hthread_condattr_t                  pthread_condattr_t

// Redefinition of the hthreads functions
#define hthread_cond_init                   pthread_cond_init
#define hthread_cond_destroy                pthread_cond_destroy
#define hthread_cond_signal                 pthread_cond_signal
#define hthread_cond_broadcast              pthread_cond_broadcast
#define hthread_cond_wait                   pthread_cond_wait
#define hthread_cond_getnum                 pthread_cond_getnum
//#define hthread_cond_timedwait

#define hthread_condattr_init               pthread_condattr_init
#define hthread_condattr_destroy            pthread_condattr_destroy
#define hthread_condattr_getpshared         pthread_condattr_getpshared
#define hthread_condattr_setpshared         phthread_condattr_setpshared
#define hthread_condattr_setnum(c,n)
#define hthread_condattr_getnum             0

#endif
