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

/** \file       init.c
  * \brief      Implementation of the the libc initialization routine.
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  */
#include <errno.h>
#include <hthread.h>
#include <manager/manager.h>
#undef errno

void __malloc_lock( struct _reent *reent )
{
    Huint curr = _current_thread();

    //write( 0, "LOCKING MALLOC\n", 15 );

    while(!_get_malloc_lock(curr));
}

void __malloc_unlock( struct _reent *reent )
{
    Huint curr = _current_thread();

    //write( 0, "UNLOCKING MALLOC\n", 17 );

    _release_malloc_lock(curr);
}

void __my_malloc_lock( struct _reent *reent )
{
    Huint curr = 0;

    //write( 0, "LOCKING MALLOC\n", 15 );

    while(!_get_malloc_lock(curr));
}

void __my_malloc_unlock( struct _reent *reent )
{
    Huint curr = 0;

    //write( 0, "UNLOCKING MALLOC\n", 17 );

    _release_malloc_lock(curr);
}

void _libc_init()
{
    volatile void *keep;

    // The hthreads OS hardware must be reset so that libc can lock and unlock
    // the malloc lock.
    _reset_hardware();

    // Get the lock first to make sure you have the right to unlock it, then
    // unlock it, guaranteeing that the malloc lock is unlocked at the end of
    // libc initialization.
    keep = __my_malloc_lock;
    keep = __my_malloc_unlock;
}
