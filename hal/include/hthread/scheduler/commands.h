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
  * \brief      This file contains the declaration of the commands that
  *				can be issued to the thread scheduler.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  *
  * This file contains the declaration of the commands that can be issued to
  * the thread scheduler. It also includes several macros to encode these
  * commands into the format understood by the thread scheduler and macros
  * to extract the information out of the return values from the thread
  * scheduler.
  */

#ifndef _HYBRID_THREADS_SCHED_COMMANDS_H_
#define _HYBRID_THREADS_SCHED_COMMANDS_H_

#include <config.h>

#define HT_CMD_SCHED_GETSCHEDPARAM      0x64
#define HT_CMD_SCHED_SETSCHEDPARAM      0x5C
#define HT_CMD_SCHED_CHECKSCHEDPARAM    0x68
#define HT_CMD_SCHED_HIGHPRI            0x58
#define HT_CMD_SCHED_ENTRY              0x60
#define HT_CMD_SCHED_PREEMPT            0x48
#define HT_CMD_SCHED_DEFPRI             0x4C
#define HT_CMD_SCHED_GET_IDLE_THREAD    0x50
#define HT_CMD_SCHED_SET_IDLE_THREAD    0x54
#define HT_CMD_SCHED_SYSCALL_LOCK       0x3C
//#define HT_CMD_SCHED_CS_LOCK            0x44
//#define HT_CMD_SCHED_MALLOC_LOCK        0x40
#define HT_CMD_SCHED_CS_LOCK            0x40
#define HT_CMD_SCHED_MALLOC_LOCK        0x44

#define SCHED_PRI_SHIFT                 16
#define SCHED_PRI_MASK                  0x0000007F

#define SCHED_TID_SHIFT                 8
#define SCHED_TID_MASK                  0x000000FF

#define SCHED_CMD_SHIFT                 0
#define SCHED_CMD_MASK                  0x000000FF

#define PROCID_SHIFT                    16
#define PROCID_MASK                     0x00000003

#define sched_cmd(pr,th,cd) (SCHEDULER_BASEADDR |                          \
                            (((th)&SCHED_TID_MASK) << SCHED_TID_SHIFT)   | \
                            (((cd)&SCHED_CMD_MASK) << SCHED_CMD_SHIFT))
                            
#endif

