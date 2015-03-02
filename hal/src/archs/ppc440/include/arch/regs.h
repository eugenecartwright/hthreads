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

/**	\internal
  *	\file	    regs.h
  * \brief      Declaration of PPC405 registers.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  */
#ifndef _HYBRID_THREADS_PPC405_REGS_
#define _HYBRID_THREADS_PPC405_REGS_

// Instruction Address Compare Registers
#define PPC405_IAC1         0
#define PPC405_IAC2         0
#define PPC405_IAC3         0
#define PPC405_IAC4         0

// Instruction Cache Registers
#define PPC405_ICCR         0
#define PPC405_ICDBDR       0

// Link Register
#define PPC405_LR           1

// Process ID Register
#define PPC405_PID          0

// Programmable Interval Timer Register
#define PPC405_PIT          0

// Processor Version Register
#define PPC405_PVR          0

// Storage Guarded Register
#define PPC405_SGR          0

// Storage Little Endian Register
#define PPC405_SLER         0

// Special General Purpose Registers
#define PPC405_SGPR0        0
#define PPC405_SGPR1        (PPC405_SGPR0 + 1)
#define PPC405_SGPR2        (PPC405_SGPR0 + 2)
#define PPC405_SGPR3        (PPC405_SGPR0 + 3)
#define PPC405_SGPR4        (PPC405_SGPR0 + 4)
#define PPC405_SGPR5        (PPC405_SGPR0 + 5)
#define PPC405_SGPR6        (PPC405_SGPR0 + 6)
#define PPC405_SGPR7        (PPC405_SGPR0 + 7)

// Save Restore Registers
#define PPC405_SRR0         0
#define PPC405_SRR1         (PPC405_SRR0 + 1)
#define PPC405_SRR2         (PPC405_SRR0 + 2)
#define PPC405_SRR3         (PPC405_SRR0 + 3)

// Storage User Defined
#define PPC405_SU0R         0

// Time Base Registers
#define PPC405_TBL          0
#define PPC405_TBU          (PPC405_TBLR + 1)

// Timer Control Register
#define PPC405_TCR          0

// Timer Status Register
#define PPC405_TSR          0
 
// User Special General Purpose Register
#define PPC405_USPRG0       0

// Fixed Point Exception Register
#define PPC405_XER          3

// Zone Protection Register
#define PPC405_ZPR          0

// Condition Register
#define PPC405_CR           4

// Machine State Register
#define PPC405_MSR          0

// Core Configuration Register
#define PPC405_CCR          0

// Count Register
#define PPC405_CTR          2

// Date Address Compare Registers
#define PPC405_DAC1         0
#define PPC405_DAC2         (PPC405_DAC1 + 1)

// Debug Control Registers
#define PPC405_DBCR0        0
#define PPC405_DBCR1        (PPC405_DBCR0 + 1)

// Debug Status Register
#define PPC405_DBSR         0

// Data Cache Cachability Register
#define PPC405_DCCR         0

// Data Cache Write Through Register
#define PPC405_DCWR         0

// Date Error Address Register
#define PPC405_DEAR         0

// Data Value Compare Registers
#define PPC405_DVC1         0
#define PPC405_DVC2         (PPC405_DVC2 + 1)

// Exception Syndrom Register
#define PPC405_ESR          0

// Exception Vector Prefix Register
#define PPC405_EVPR         0

// General Purpose Registers
#define PPC405_GPR0         5
#define PPC405_GPR1         (PPC405_GPR0 + 1)
#define PPC405_GPR2         (PPC405_GPR0 + 2)
#define PPC405_GPR3         (PPC405_GPR0 + 3)
#define PPC405_GPR4         (PPC405_GPR0 + 4)
#define PPC405_GPR5         (PPC405_GPR0 + 5)
#define PPC405_GPR6         (PPC405_GPR0 + 6)
#define PPC405_GPR7         (PPC405_GPR0 + 7)
#define PPC405_GPR8         (PPC405_GPR0 + 8)
#define PPC405_GPR9         (PPC405_GPR0 + 9)
#define PPC405_GPR10        (PPC405_GPR0 + 10)
#define PPC405_GPR11        (PPC405_GPR0 + 11)
#define PPC405_GPR12        (PPC405_GPR0 + 12)
#define PPC405_GPR13        (PPC405_GPR0 + 13)
#define PPC405_GPR14        (PPC405_GPR0 + 14)
#define PPC405_GPR15        (PPC405_GPR0 + 15)
#define PPC405_GPR16        (PPC405_GPR0 + 16)
#define PPC405_GPR17        (PPC405_GPR0 + 17)
#define PPC405_GPR18        (PPC405_GPR0 + 18)
#define PPC405_GPR19        (PPC405_GPR0 + 19)
#define PPC405_GPR20        (PPC405_GPR0 + 20)
#define PPC405_GPR21        (PPC405_GPR0 + 21)
#define PPC405_GPR22        (PPC405_GPR0 + 22)
#define PPC405_GPR23        (PPC405_GPR0 + 23)
#define PPC405_GPR24        (PPC405_GPR0 + 24)
#define PPC405_GPR25        (PPC405_GPR0 + 25)
#define PPC405_GPR26        (PPC405_GPR0 + 26)
#define PPC405_GPR27        (PPC405_GPR0 + 27)
#define PPC405_GPR28        (PPC405_GPR0 + 28)
#define PPC405_GPR29        (PPC405_GPR0 + 29)
#define PPC405_GPR30        (PPC405_GPR0 + 30)
#define PPC405_GPR31        (PPC405_GPR0 + 31)

#endif
