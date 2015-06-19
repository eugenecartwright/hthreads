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
#ifndef _HYBRID_THREADS_CONDVAR_CMDS_H_
#define _HYBRID_THREADS_CONDVAR_CMDS_H_

#include <config.h>

#define HT_CVR_MAXNUM       63

#define HT_CMD_OWNER        0x00
#define HT_CMD_REQUEST      0x02
#define HT_CMD_RELEASE      0x01
#define HT_CMD_TRYLOCK      0x03
#define HT_CMD_COUNT        0x00
#define HT_CMD_WAIT         0x02
#define HT_CMD_POST         0x03
#define HT_CMD_SIGNAL       0x01
#define HT_CMD_CWAIT        0x02
#define HT_CMD_BROADCAST    0x03

#define HT_CVR_CMD_SHIFT  17
#define HT_CVR_CMD_MASK   0x00000007
#define HT_CVR_TID_SHIFT  8
#define HT_CVR_TID_MASK   0x000000FF
#define HT_CVR_SEM_SHIFT  2
#define HT_CVR_SEM_MASK   0x0000003F

#define HT_CVAR_STATUS_SHIFT 28
#define HT_CVAR_STATUS_MASK  0x0F
#define HT_CVAR_ERROR_SHIFT  24
#define HT_CVAR_ERROR_MASK   0x0F
#define HT_CVAR_COUNT_SHIFT  16
#define HT_CVAR_COUNT_MASK   0xFF
#define HT_CVAR_TID_SHIFT    0
#define HT_CVAR_TID_MASK     0xFF

#define HT_CONDVAR_FAILED   0x0E
#define HT_CONDVAR_SUCCESS  0x0A

#define cvr_sema_cmd(c,t,s) ((CONDVAR_BASEADDR)                          |\
                             ((c & HT_CVR_CMD_MASK) << HT_CVR_CMD_SHIFT) |\
                             ((t & HT_CVR_TID_MASK) << HT_CVR_TID_SHIFT) |\
                             ((s & HT_CVR_SEM_MASK) << HT_CVR_SEM_SHIFT))

#define cvr_sema_sta(sta)   (((sta)>>HT_CVAR_STATUS_SHIFT)&HT_CVAR_STATUS_MASK)
#define cvr_sema_err(sta)   (((sta)>>HT_CVAR_ERROR_SHIFT)&HT_CVAR_ERROR_MASK)
#define cvr_sema_cnt(sta)   (((sta)>>HT_CVAR_COUNT_SHIFT)&HT_CVAR_COUNT_MASK)
#define cvr_sema_tid(sta)   (((sta)>>HT_CVAR_TID_SHIFT)&HT_CVAR_TID_MASK)
    
#endif

