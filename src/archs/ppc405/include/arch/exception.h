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

/**	\internal
  *	\file		exception.h
  * \brief      Declaration of interrupt control macros for CPU.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  *
  * This file contains PPC405 specific macros for interrupt control.
  */
#ifndef _HYBRID_THREADS_PPC405_EXCEPTION_
#define _HYBRID_THREADS_PPC405_EXCEPTION_

#define CRITICAL            0x00020000
#define NONCRITICAL         0x00008000
#define ALL                 (CRITICAL | NONCRITICAL)

#define PPC405_MTMSR(v)                             \
    ({                                              \
       asm volatile( "mtmsr %0\n"                   \
                     : : "r" (v) );                 \
    })

#define PPC405_MFMSR()                              \
    ({ unsigned int rval;                           \
       asm volatile( "mfmsr %0\n"                   \
                     : "=r" (rval) );               \
       rval;                                        \
    })

#define ENABLE_EXCEPTIONS()  (PPC405_MTMSR(PPC405_MFMSR() | NONCRITICAL))
#define DISABLE_EXCEPTIONS() (PPC405_MTMSR(PPC405_MFMSR() & ~(NONCRITICAL)))

#define ENABLE_ALL_EXCEPTIONS()  (PPC405_MTMSR(PPC405_MFMSR() | ALL))
#define DISABLE_ALL_EXCEPTIONS() (PPC405_MTMSR(PPC405_MFMSR() & ~(ALL)))

#endif
