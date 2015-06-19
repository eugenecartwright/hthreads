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
  * \file       hardware.h
  * \brief      The interface to the processor ID (processor-specific).
  *
  */
#ifndef _HTHREADS_PROCESSOR_HARDWARE_H_
#define _HTHREADS_PROCESSOR_HARDWARE_H_

#include <hthread.h>
#include <pvr.h>
#include "config.h"

static inline Huint _proc_id( void )
{

#ifdef mblaze
    // MicroBlaze-specific V-HWTI code
    // The ID of the thread running on a heterogeneous MB processor
    // can be found in the PVR regsister (w/o having to access the TM)
    // Extract V-HWTI address
    int vhwti_base;
    getpvr(1,vhwti_base);

    return vhwti_base;
#elif ppc440

    /* PPC-specific V-HWTI code
     * ************************
     * For heterogeneous (slave) processors, we typically use a 
     * processor ID register to hold the base of the V-HWTI. 
     * Since the PPC (except Virtex4 Pro) has no notion of a PVR,
     * the base of the VHWTI is macro'ed in the platform's config.h.
     */
    return PPC_VHWTI_BASE;
#else
#error "Unsupported!"
#endif
}

static inline Huint _vhwti_field(int word_offset)
{
    volatile Huint * field_ptr;
    Huint field;

    // Dereference the V-HWTI field of interest
    field_ptr = (Huint *) (((Huint *)_proc_id()) + word_offset);
    field = *field_ptr;

    return field;
}

static inline volatile Huint * _vhwti_field_ptr(int word_offset)
{
    volatile Huint * field_ptr;

    // Calculate the V-HWTI pointer of interest
    field_ptr = (Huint *) (((Huint *)_proc_id()) + word_offset);

    return field_ptr;
}


// Macro to access the V-HWTI command pointer
#define _vhwti_command_pointer() _vhwti_field_ptr(3)

// Macro to access the value of the V-HWTI TID field
#define _vhwti_tid_field() _vhwti_field(0)

// Macro to access the value of the V-HWTI stack pointer field
#define _vhwti_stack_ptr_field() _vhwti_field(8)

// Macro to access the value of the V-HWTI stack pointer field
#define _vhwti_context_ptr_field() _vhwti_field(9)

// Macro to access the value of the V-HWTI stack pointer field
#define _vhwti_context_table_ptr_field() _vhwti_field(10)

// Macro to access the value of the V-HWTI stack pointer field
#define _vhwti_bootstrap_field() _vhwti_field(11)

// Macro to access the value of the V-HWTI utilized field pointer
#define _vhwti_utilized_pointer() _vhwti_field_ptr(1)

#endif
