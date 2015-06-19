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

/** \file       hardware.h
  */
#ifndef _HYBRID_THREADS_CONDVAR_HARDWARE_H_
#define _HYBRID_THREADS_CONDVAR_HARDWARE_H_

#include <util/rops.h>
#include <condvar/commands.h>

static inline Hint _condvar_signal( Huint mid )
{
    Huint cmd;
    Huint sta;

    // Form the address used to issue the command to the condition variables
    cmd = cvr_sema_cmd( HT_CMD_SIGNAL, 0, mid );

    // Continue to loop while the condition variable core says that its busy
    do
    {
        sta = read_reg( cmd );
    } while( sta == HT_CONDVAR_FAILED );

    // Return a success code
    return SUCCESS;
}

static inline Hint _condvar_broadcast( Huint mid )
{
    Huint cmd;
    Huint sta;

    // Form the address used to issue the command to the condition variables
    cmd = cvr_sema_cmd( HT_CMD_BROADCAST, 0, mid );

    // Continue to loop while the condition variable core says that its busy
    do
    {
        sta = read_reg( cmd );
    } while( sta == HT_CONDVAR_FAILED );

    // Return a success code
    return SUCCESS;
}

static inline Hint _condvar_wait( Huint tid, Huint mid )
{
    Huint cmd;
    Huint sta;

    // Form the address used to issue the command to the condition variables
    cmd = cvr_sema_cmd( HT_CMD_WAIT, tid, mid );

    // Continue to loop while the condition variable core says that its busy
    do
    {
        sta = read_reg( cmd );
    } while( sta == HT_CONDVAR_FAILED );

    // Return a success code
    return SUCCESS;
}

#endif

