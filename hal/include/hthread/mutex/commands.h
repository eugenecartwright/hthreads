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
  *	\file       commands.h
  */
#ifndef _HYBRID_THREADS_MUTEX_CMDS_H_
#define _HYBRID_THREADS_MUTEX_CMDS_H_

#include <config.h>

#define KIND_BITS           2
#define COUNT_BITS          8
#define COMMAND_BITS        3

#define HT_MUTEX_LOCK       0
#define HT_MUTEX_UNLOCK     1
#define HT_MUTEX_TRY        2
#define HT_MUTEX_OWNER      3
#define HT_MUTEX_KIND       4
#define HT_MUTEX_COUNT      5

#define HT_MUTEX_MID_SHIFT  2
#define HT_MUTEX_MID_MASK   ((1 << MUTEX_BITS) - 1)
#define HT_MUTEX_TID_SHIFT  (MUTEX_BITS + HT_MUTEX_MID_SHIFT)
#define HT_MUTEX_TID_MASK   ((1 << THREAD_BITS) - 1)
#define HT_MUTEX_CMD_SHIFT  (THREAD_BITS + HT_MUTEX_TID_SHIFT)
#define HT_MUTEX_CMD_MASK   ((1 << COMMAND_BITS) - 1)

#define MT_MUTEX_SUCCESS    0x00000000
#define HT_MUTEX_ERROR      0x80000000
#define HT_MUTEX_BLOCK      0x40000000

//#define HT_MUTEX_CNT_SHIFT  (32 - COUNT_BITS)
//#define HT_MUTEX_CNT_MASK   ((1 << COUNT_BITS) - 1)
//#define HT_MUTEX_KND_SHIFT  (32 - KIND_BITS)
//#define HT_MUTEX_KND_MASK   ((1 << KIND_BITS) - 1)
//#define HT_MUTEX_OWN_SHIFT  (32 - THREAD_BITS)
//#define HT_MUTEX_OWN_MASK   ((1 << THREAD_BITS) - 1)
#define HT_MUTEX_CNT_SHIFT  0
#define HT_MUTEX_CNT_MASK   0x000000FF
#define HT_MUTEX_KND_SHIFT  0
#define HT_MUTEX_KND_MASK   0x00000003
#define HT_MUTEX_OWN_SHIFT  0
#define HT_MUTEX_OWN_MASK   0x000000FF


#define mutex_cmd(c,t,m)    ((SYNCH_BASEADDR)                             |\
                             ((c&HT_MUTEX_CMD_MASK)<<HT_MUTEX_CMD_SHIFT)  |\
                             ((t&HT_MUTEX_TID_MASK)<<HT_MUTEX_TID_SHIFT)  |\
                             ((m&HT_MUTEX_MID_MASK)<<HT_MUTEX_MID_SHIFT))

#define mutex_kind(sta)     (((sta)>>HT_MUTEX_KND_SHIFT)&HT_MUTEX_KND_MASK)
#define mutex_count(sta)    (((sta)>>HT_MUTEX_CNT_SHIFT)&HT_MUTEX_CNT_MASK)
#define mutex_owner(sta)    (((sta)>>HT_MUTEX_OWN_SHIFT)&HT_MUTEX_OWN_MASK)
#define mutex_error(sta)    ((sta) != 0)
    
#endif

