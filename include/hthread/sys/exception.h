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
  * \file       exception.h
  * \brief      Declaration of the exception handler functions.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  *
  * This file contains the declarations of the exception handler functions
  * used by the hybridthreads API implementation. All exceptions except for
  * the system call exception are defined here.
  */
#ifndef _HYBRID_THREADS_EXCEPTION_H_
#define _HYBRID_THREADS_EXCEPTION_H_

#include <xintc_l.h>
#include <util/rops.h>

#define intr_menable(base)      write_reg( (base) + XIN_MER_OFFSET,        \
                                           XIN_INT_MASTER_ENABLE_MASK  |   \
                                           XIN_INT_HARDWARE_ENABLE_MASK )
#define intr_mdisable(base)     write_reg( (base) + XIN_MER_OFFSET, 0 )
#define intr_enable(base,intr)  write_reg( (base) + XIN_IER_OFFSET, (intr) )
#define intr_disable(base,intr) write_reg( (base) + XIN_CIE_OFFSET, (intr) )
#define intr_ack(base,intr)     write_reg( (base) + XIN_IAR_OFFSET, (intr) )
#define intr_pending(base)       read_reg( (base) + XIN_IPR_OFFSET )
#define intr_status(base)        read_reg( (base) + XIN_ISR_OFFSET )

extern void _exception_jump_zero( void *data );
extern void _exception_machine_check( void *data );
extern void _exception_data_storage( void *data );
extern void _exception_instr_storage( void *data );
extern void _exception_alignment( void *data );
extern void _exception_program( void *data );
extern void _exception_fpu( void *data );
extern void _exception_apu( void *data );
extern void _exception_pit( void *data );
extern void _exception_fit( void *data );
extern void _exception_watchdog( void *data );
extern void _exception_data_tlb_miss( void *data );
extern void _exception_instr_tlb_miss( void *data );
extern void _exception_debug( void *data );
extern void _exception_critical( void *data );
extern void _exception_noncritical( void *data );

#endif

