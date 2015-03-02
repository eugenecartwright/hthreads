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

/** \file       constants.h
  * \brief      Declaration of constant values used by hthreads.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  *
  *	This file contains the declarations of constant values used by the
  * hthreads implementation. Any constant value used by the implementation
  * should be declared in this file.
  */

#ifndef _HYBRID_THREADS_MUTEX_CONSTS_H_
#define _HYBRID_THREADS_MUTEX_CONSTS_H_

// Mutex type attributes
#define HTHREAD_MUTEX_FAST_NP                   0
#define HTHREAD_MUTEX_RECURSIVE_NP              1
#define HTHREAD_MUTEX_ERRORCHECK_NP             2
#define HTHREAD_MUTEX_DEFAULT                   HTHREAD_MUTEX_FAST_NP

// Mutex initializer
#define HTHREAD_MUTEX_INITIALIZER               {}
#define HTHREAD_RECURSIE_MUTEX_INITIALIZER_NP   {}
#define HTHREAD_ERRORCHECK_MUTEX_INITIALIZER_NP {}

/** \internal
  * \brief  An identifier which marks the highest mutex type value.
  *
  * This definition provides an upper bound for the mutex type. When
  * the function ::hthread_mutexattr_settype is call it will check that the
  * mutex type is an integer between 0 and the value defined here.
  */
#define HTHREAD_MUTEX_MAX_NP    2

#endif

