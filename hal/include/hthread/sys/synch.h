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

/** \internal
  *	\file       synch.h
  * \brief      Declaration of structures and functions used by the system
  *				level synchronization API.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  * This file contains the definitions of the system level synchronization
  * functions used by the Hybridthreads system.
  */

#ifndef _HYBRID_THREADS_SYNCH_H_
#define _HYBRID_THREADS_SYNCH_H_

#include <mutex/mutex.h>
#include <manager/manager.h>

// Systems level spin locks are just special normal mutexes
typedef hthread_mutex_t         hthread_spin_t;

// Definitions of the systems level spin locks
extern hthread_spin_t   _sysc_lock;
extern hthread_spin_t   _libc_lock;

// Special systems level functions are used to access the spin locks
extern Hint hthread_spin_init( void );
extern Hint hthread_spin_destory( void );
extern Hint hthread_spin_lock( hthread_spin_t* );
extern Hint hthread_spin_unlock( hthread_spin_t* );

#endif

