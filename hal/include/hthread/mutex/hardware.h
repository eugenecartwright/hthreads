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

/** \file       hardware.h
  */
#ifndef _HYBRID_THREADS_MUTEX_HARDWARE_H_
#define _HYBRID_THREADS_MUTEX_HARDWARE_H_

#include <debug.h>
#include <util/rops.h>
#include <mutex/commands.h>
#include <htconst.h>

#define HT_SEM_RESERVE  5
#define HT_SEM_MAXNUM   (((1 << MUTEX_BITS) - 1) - HT_SEM_RESERVE)

static inline Hint _mutex_acquire( Huint tid, Huint mid )
{
    Huint cmd;
    Huint sta;

    cmd = mutex_cmd( HT_MUTEX_LOCK, tid, mid );
    sta = read_reg( cmd );

    TRACE_PRINTF(TRACE_FINE,TRACE_MUTEX,"LOCK: (CMD=0x%8.8x) (TID=%u) (MID=%u) (STA=0x%8.8x)\n",cmd,tid,mid,sta);
    return sta;
}

static inline Hint _mutex_tryacquire( Huint tid, Huint mid )
{
    Huint cmd;
    Huint sta;

    cmd = mutex_cmd( HT_MUTEX_TRY, tid, mid );
    sta = read_reg( cmd );

    TRACE_PRINTF(TRACE_FINE,TRACE_MUTEX,"TRYLOCK: (CMD=0x%8.8x) (TID=%u) (MID=%u) (STA=0x%8.8x)\n",cmd,tid,mid,sta);
    if( mutex_error(sta) )  return FAILURE;
    else                    return SUCCESS;
}

static inline void _mutex_release( Huint tid, Huint mid )
{
    Huint cmd;
    Huint sta;

    cmd = mutex_cmd( HT_MUTEX_UNLOCK, tid, mid );
    sta = read_reg( cmd );

    TRACE_PRINTF(TRACE_FINE,TRACE_MUTEX,"UNLOCK: (CMD=0x%8.8x) (TID=%u) (MID=%u) (STA=0x%8.8x)\n",cmd,tid,mid,sta);
}

static inline Huint _mutex_owner( Huint mid )
{
    Huint cmd;
    Huint sta;

    cmd = mutex_cmd( HT_MUTEX_OWNER, 0, mid );
    sta = read_reg( cmd );

    TRACE_PRINTF(TRACE_FINE,TRACE_MUTEX,"OWNER: (CMD=0x%8.8x) (MID=%u) (STA=0x%8.8x)\n",cmd,mid,sta);
    return mutex_owner(sta);
}

static inline Huint _mutex_count( Huint mid )
{
    Huint cmd;
    Huint sta;

    cmd = mutex_cmd( HT_MUTEX_COUNT, 0, mid );
    sta = read_reg( cmd );

    TRACE_PRINTF(TRACE_FINE,TRACE_MUTEX,"COUNT: (CMD=0x%8.8x) (MID=%u) (STA=0x%8.8x)\n",cmd,mid,sta);
    return mutex_count(sta);
}

static inline Huint _mutex_kind( Huint mid )
{
    Huint cmd;
    Huint sta;

    cmd = mutex_cmd( HT_MUTEX_KIND, 0, mid );
    sta = read_reg( cmd );

    TRACE_PRINTF(TRACE_FINE,TRACE_MUTEX,"KIND: (CMD=0x%8.8x) (MID=%u) (STA=0x%8.8x)\n",cmd,mid,sta);
    return mutex_kind(sta);
}

static inline void _mutex_setkind( Huint mid, Huint kind )
{
    Huint cmd;

    cmd = mutex_cmd( HT_MUTEX_KIND, 0, mid );
    write_reg( cmd, kind );

    TRACE_PRINTF(TRACE_FINE,TRACE_MUTEX,"SETKIND: (CMD=0x%8.8x) (MID=%u)\n",cmd,mid);
}

#endif

