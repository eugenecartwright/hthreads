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
  *	\file       commands.h
  * \brief      This file contains the declaration of the commands that
  *				can be issued to the thread manager.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  *
  * This file contains the declaration of the commands that can be issued to
  * the thread manager. It also includes several macros to encode these
  * commands into the format understood by the thread manager and macros
  * to extract the information out of the return values from the thread
  * manager.
  */

#ifndef _HYBRID_THREADS_MANAGER_COMMANDS_H_
#define _HYBRID_THREADS_MANAGER_COMMANDS_H_

#include <config.h>
//#include <arch/arch.h>

#define HT_CMD_CLEAR_THREAD         0x00
#define HT_CMD_JOIN_THREAD          0x01
#define HT_CMD_DETACH_THREAD        0x02
#define HT_CMD_READ_THREAD          0x03
#define HT_CMD_ADD_THREAD           0x04
#define HT_CMD_CREATE_THREAD_J      0x05
#define HT_CMD_CREATE_THREAD_D      0x06
#define HT_CMD_EXIT_THREAD          0x07
#define HT_CMD_NEXT_THREAD          0x08
#define HT_CMD_YIELD_THREAD         0x09
#define HT_CMD_DETACHED_THREAD      0x18

#define HT_CMD_CURRENT_THREAD       0x10
#define HT_CMD_QUE_LENGTH           0x12
#define HT_CMD_EXCEPTION_ADDR       0x13
#define HT_CMD_EXCEPTION_REG        0x14

#define HT_CMD_SOFT_START           0x15
#define HT_CMD_SOFT_STOP            0x16
#define HT_CMD_SOFT_RESET           0x17

#define HT_CMD_IS_QUEUED            0x19
#define HT_CMD_GET_SCHED_LINES      0x1A

#define HT_CMD_GET_CPUID            0x1F

#define ERR_SHIFT                   1
#define ERR_MASK                    0x00000007
#define ERR_BIT                     0x00000001

#define STATUS_SHIFT                1
#define STATUS_MASK                 0x00000007

#define THREAD_TID_SHIFT            2
#define THREAD_TID_MASK             0x000000FF

#define THREAD_CMD_SHIFT            10  
#define THREAD_CMD_MASK             0x0000001F

#define THREAD_SHIFT                1
//#define THREAD_SHIFT                0
#define THREAD_MASK                 0x000000FF

#define PRIOR_SHIFT                 4
#define PRIOR_MASK                  0x0000007F

#define PROCID_SHIFT                16
#define PROCID_MASK                 0x00000003

#define CPUID_SHIFT                 0
#define CPUID_MASK                  0x00000003

#define has_error(status)       ((status)&ERR_BIT)
#define extract_error(status)   (((status)>>ERR_SHIFT)&ERR_MASK)
#define encode_error(status)    (((status)<<ERR_SHIFT)|ERR_MASK)

#define encode_reg(reg)         encode_cmd( 0, reg )

#define encode_cmd(th,cd)       (MANAGER_BASEADDR                            |\
                                (((th)&THREAD_TID_MASK)<<THREAD_TID_SHIFT)   |\
                                (((cd)&THREAD_CMD_MASK)<<THREAD_CMD_SHIFT))

#define extract_id(status)      (((status) >> THREAD_SHIFT) & THREAD_MASK)
#define extract_pri(status)     (((status) >> PRIOR_SHIFT) & PRIOR_MASK)
#define extract_cpuid(status)   (((status) >> CPUID_SHIFT) & CPUID_MASK)

#endif

