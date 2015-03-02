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
  * \file       commands.h
  * \brief      This file contains the declaration of the commands that can
  *             be issued to the thread manager.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  *
  * This file contains the declaration of the commands that can be issued to
  * the HWTI. It also includes several macros to encode these commands into the
  * format understood by the HWTI and macros to extract the information out of
  * the return values from the HWTI.
  */

#ifndef _HYBRID_THREADS_HWTI_COMMANDS_H_
#define _HYBRID_THREADS_HWTI_COMMANDS_H_

#include <config.h>

#define HT_CMD_HWTI_SETID                   0x0000
#define HT_CMD_HWTI_TIMER                   0x0004
#define HT_CMD_HWTI_STATUS                  0x0008
#define HT_CMD_HWTI_COMMAND                 0x000C
#define HT_CMD_HWTI_SETARG                  0x0010
#define HT_CMD_HWTI_ARGUMENT                0x0010
#define HT_CMD_HWTI_RESULTS                 0x0014
#define HT_CMD_HWTI_RESULT                  0x0014
#define HT_CMD_HWTI_DEBUG_SYSTEM            0x0018
#define HT_CMD_HWTI_FUNC_PTR                0x0018
#define HT_CMD_HWTI_DEBUG_USER              0x001C
#define HT_CMD_HWTI_MASTER_READ             0x0020
#define HT_CMD_HWTI_MASTER_WRITE            0x0024
#define HT_CMD_HWTI_STACKPTR                0x0028
#define HT_CMD_HWTI_FRAMEPTR                0x002C
#define HT_CMD_HWTI_HEAPPTR                 0x0030
#define HT_CMD_HWTI_8B_DYNAMIC_TABLE        0x0034
#define HT_CMD_HWTI_32B_DYNAMIC_TABLE       0x0038
#define HT_CMD_HWTI_1024B_DYNAMIC_TABLE     0x003C
#define HT_CMD_HWTI_UNLIMITED_DYNAMIC_TABLE 0x0040
#define HT_CMD_HWTI_RPC_MUTEXCONVAR         0x0044
#define HT_CMD_HWTI_RPC_T_ADDRESS           0x0048
#define HT_HWTI_RESET                       0x0002
#define HT_HWTI_GO                          0x0001
#define HT_HWTI_COMMAND_OFFSET              0x000C

#define HT_CMD_HWTI_UTILIZED                0x0004
#define HT_CMD_HWTI_STACK_BASE              0x0020
#define HT_CMD_HWTI_CONTEXT_BASE            0x0024
#define HT_CMD_HWTI_CONTEXT_TABLE_BASE      0x0028
#define HT_CMD_HWTI_BOOTSTRAP               0x002C
                                            
// New commands - Added by Eugene
#define HT_CMD_VHWTI_EXEC_TIME              0x0030
//#define HT_CMD_VHWTI_EXEC2_TIME             0x0034
#define HT_CMD_VHWTI_FIRST_USED             0x0038
#define HT_CMD_VHWTI_FIRST_USED_PTR         0x003C
#define HT_CMD_VHWTI_LAST_USED              0x0040
#define HT_CMD_VHWTI_LAST_USED_PTR          0x0044
#define HT_CMD_VHWTI_ACCELERATORS_PTR       0x0048
#define HT_CMD_VHWTI_ICAP_MUTEX_PTR         0x004C
#define HT_CMD_VHWTI_ICAP_STRUCT_PTR        0x0050
#define HT_CMD_VHWTI_TUNING_TABLE_PTR       0x0054
#define HT_CMD_VHWTI_ACC_FLAGS              0x0058
#define HT_CMD_VHWTI_ACC_HW_COUNTER         0x005C
#define HT_CMD_VHWTI_ACC_SW_COUNTER         0x0060
#define HT_CMD_VHWTI_ACC_PR_COUNTER         0x0064
#define HT_CMD_VHWTI_PROC_TYPE              0x0068

// Utilization Flag(s)
#define FLAG_HWTI_UTILIZED                  0x0001
#define FLAG_HWTI_FREE                      0x0000

#define hwti_cmd(base,cmd)           (base | cmd)
    
#endif

