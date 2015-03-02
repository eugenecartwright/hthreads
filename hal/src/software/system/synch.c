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

/** \internal
  * \file       synch.c
  * \brief      The implementation of the Hybrid Threads system level
  *             synchronization code.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  * This file contains the implementations for the Hybrid Thread system level
  * synchronization code.
  */
#include <hthread.h>
#include <sys/synch.h>

// Declare the system locks
hthread_spin_t  _sysc_lock;
hthread_spin_t  _libc_lock;

Hint hthread_spin_init( void )
{
    // Setup the system call spin lock
    _sysc_lock.num  = HT_SEM_MAXNUM;
    _sysc_lock.type = HTHREAD_MUTEX_RECURSIVE_NP;

    // Setup the libc spin lock
    _libc_lock.num  = HT_SEM_MAXNUM + 1;
    _libc_lock.type = HTHREAD_MUTEX_RECURSIVE_NP;

    // Setup the mutex types for all of the system mutexes
    _mutex_setkind( _sysc_lock.num, _sysc_lock.type );
    _mutex_setkind( _libc_lock.num, _libc_lock.type );

    // Return successfully
    return SUCCESS;
}

Hint hthread_spin_destroy( void )
{
    // Return successfully
    return SUCCESS;
}

Hint hthread_spin_lock( hthread_spin_t *spin )
{
    Huint cur;

    // Get the current thread id
    cur = _current_thread();

    // Attempt to acquire the lock using a spin lock
    while( _mutex_tryacquire( cur, spin->num ) != SUCCESS );

    // Return successfully
    return SUCCESS;
}

Hint hthread_spin_unlock( hthread_spin_t *spin )
{
    Huint cur;

    // Get the current thread id
    cur = _current_thread();

    // Unlock the spin lock
    _mutex_release( cur, spin->num );

    // Return successfully
    return SUCCESS;
}

