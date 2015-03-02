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

/** \file       commands.h
  * \brief      Command implementations for the Special PIC.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  */

#ifndef _HYBRID_THREAD_PIC_COMMANDS_H_
#define _HYBRID_THREAD_PIC_COMMANDS_H_

#include <util/rops.h>
#include <config.h>

#define PIC_SUCCESS     0
#define PIC_RETURN      1
#define PIC_ERROR       2

#define PIC_ASSOC       0x00
#define PIC_ENABLE      0x04
#define PIC_DISABLE     0x08
#define PIC_PENDING     0x0C
#define PIC_ENABLED     0x10
#define PIC_INTRENA     0x14
#define PIC_TID         0x18

#define PIC_CMD_BITS    8
#define PIC_CMD_SHIFT   0

#define PIC_TID_BITS    8
#define PIC_TID_SHIFT   8

#define PIC_IID_BITS    8
#define PIC_IID_SHIFT   16

#define spic_cmd(cmd,tid,iid)   read_reg( SPIC_BASEADDR             |   \
                                          ((cmd) << PIC_CMD_SHIFT)  |   \
                                          ((tid) << PIC_TID_SHIFT)  |   \
                                          ((iid) << PIC_IID_SHIFT) )

#define spic_success(res)       ((res) == PIC_SUCCESS)
#define spic_error(res)         ((res) == PIC_ERROR)
#define spic_return_immediately(res)         ((res) == PIC_RETURN)

#endif
