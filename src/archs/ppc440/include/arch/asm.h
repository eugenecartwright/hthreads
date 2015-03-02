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
  *	\file	    asm.h
  * \brief      Declaration of PPC405 assembly macros
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  */
#ifndef _HYBRID_THREADS_PPC405_ASM_
#define _HYBRID_THREADS_PPC405_ASM_

#include <httype.h>

// Definition of cache information
#define DCACHE_SIZE     (16 * 1024)
#define ICACHE_SIZE     (16 * 1024)
#define DCACHE_CLASSES  256

// Definition of Machine State Register Bits
#define MSR_AP          0x04000000
#define MSR_APE         0x00080000
#define MSR_WE          0x00040000
#define MSR_CE          0x00020000
#define MSR_EE          0x00008000
#define MSR_PR          0x00004000
#define MSR_FP          0x00002000
#define MSR_ME          0x00001000
#define MSR_FE0         0x00000800
#define MSR_DWE         0x00000400
#define MSR_DE          0x00000200
#define MSR_FE1         0x00000100
#define MSR_IR          0x00000020
#define MSR_DR          0x00000010

// Definition of Core-Configuration Register Bits
#define CCR0_LWL        0x02000000
#define CCR0_LWOA       0x01000000
#define CCR0_SWOA       0x00800000
#define CCR0_DPP1       0x00400000
#define CCR0_IPP0       0x00200000
#define CCR0_IPP1       0x00100000
#define CCR0_U0XE       0x00020000
#define CCR0_LDBE       0x00010000
#define CCR0_PFC        0x00000800
#define CCR0_PFNC       0x00000400
#define CCR0_NCRS       0x00000200
#define CCR0_FWOA       0x00000100
#define CCR0_CIS        0x00000010
#define CCR0_CWS        0x00000001

// Definition of Debug Control Register Bits
#define DBCR0_EDM       0x80000000
#define DBCR0_IDM       0x40000000
#define DBCR0_RST0      0x20000000
#define DBCR0_RST1      0x10000000
#define DBCR0_IC        0x08000000
#define DBCR0_BT        0x04000000
#define DBCR0_EDE       0x02000000
#define DBCR0_TDE       0x01000000
#define DBCR0_IA1       0x00800000
#define DBCR0_IA2       0x00400000
#define DBCR0_IA12      0x00200000
#define DBCR0_IA12X     0x00100000
#define DBCR0_IA3       0x00080000
#define DBCR0_IA4       0x00040000
#define DBCR0_IA34      0x00020000
#define DBCR0_IA34X     0x00010000
#define DBCR0_IA12T     0x00008000
#define DBCR0_IA34T     0x00004000
#define DBCR0_FT        0x00000001
#define DBCR1_D1R       0x80000000
#define DBCR1_D2R       0x40000000
#define DBCR1_D1W       0x20000000
#define DBCR1_D2W       0x10000000
#define DBCR1_D1S0      0x08000000
#define DBCR1_D1S1      0x04000000
#define DBCR1_D2S0      0x02000000
#define DBCR1_D2S1      0x01000000
#define DBCR1_DA12      0x00800000
#define DBCR1_DA12X     0x00400000
#define DBCR1_DV1M0     0x00080000
#define DBCR1_DV1M1     0x00040000
#define DBCR1_DV2M0     0x00020000
#define DBCR1_DV2M1     0x00010000
#define DBCR1_DV1BE0    0x00008000
#define DBCR1_DV1BE1    0x00004000
#define DBCR1_DV1BE2    0x00002000
#define DBCR1_DV1BE3    0x00001000
#define DBCR1_DV2BE0    0x00000800
#define DBCR1_DV2BE1    0x00000400
#define DBCR1_DV2BE2    0x00000200
#define DBCR1_DV2BE3    0x00000100

// Definition of Debug Status Register Bits
#define DBSR_IC         0x80000000
#define DBSR_BT         0x40000000
#define DBSR_EDE        0x20000000
#define DBSR_TDE        0x10000000
#define DBSR_UDE        0x08000000
#define DBSR_IA1        0x04000000
#define DBSR_IA2        0x02000000
#define DBSR_DR1        0x01000000
#define DBSR_DW1        0x00800000
#define DBSR_DR2        0x00400000
#define DBSR_DW2        0x00200000
#define DBSR_IDE        0x00100000
#define DBSR_IA3        0x00080000
#define DBSR_IA4        0x00040000
#define DBSR_MRR0       0x00000200
#define DBSR_MRR1       0x00000100

// Definition of Exception Syndrom Register Bits
#define ESR_MCI         0x80000000
#define ESR_PIL         0x08000000
#define ESR_PPR         0x04000000
#define ESR_PTR         0x02000000
#define ESR_PEU         0x01000000
#define ESR_DST         0x00800000
#define ESR_DIZ         0x00400000
#define ESR_PFP         0x00080000
#define ESR_PAP         0x00040000
#define ESR_U0F         0x00008000

// Definition of Instruction Cache Register Bits
#define ICREAD_INFO     0xFFFFFC00
#define ICREAD_VALID    0x00000080
#define ICREAD_LRU      0x00000008

// Definition of Timer Control Register Bits
#define TCR_WP0         0x80000000
#define TCR_WP1         0x40000000
#define TCR_WCR0        0x20000000
#define TCR_WCR1        0x10000000
#define TCR_WIE         0x08000000
#define TCR_PIE         0x04000000
#define TCR_FP0         0x02000000
#define TCR_FP1         0x01000000
#define TCR_FIE         0x00800000
#define TCR_ARE         0x00400000

// Definition of Timer Status Register Bits
#define TSR_ENW         0x80000000
#define TSR_WIS         0x40000000
#define TSR_WRS0        0x20000000
#define TSR_WRS1        0x10000000
#define TSR_PIS         0x08000000
#define TSR_FIS         0x04000000

// Definition of Fixed-Point Exception Register Bits
#define XER_SO          0x80000000
#define XER_OV          0x40000000
#define XER_CA          0x20000000
#define XER_TBC         0x0000007F

// Access to the General Purpose Registers
#define mtgpr(r,v)   ({ asm volatile("addi "#r", %0, 0\n\t" : : "r"(v) ); })
#define mfgpr(r)     ({ Huint _v; asm volatile("addi %0, "#r", 0\n\t" : "=r"(_v) ); _v; })

// Access to the Condition Register
#define mtcr(v)    ({ asm volatile("mtcr %0\n\t" : : "r"(v) ); })
#define mfcr()     ({ Huint _v; asm volatile("mfcr %0\n\t" : "=r"(_v) ); _v; })

// Access to the Storage Guarded Register
#define mtsgr(v)    ({ asm volatile("mtsgr %0\n\t" : : "r"(v) ); })
#define mfsgr()     ({ Huint _v; asm volatile("mfsgr %0\n\t" : "=r"(_v) ); _v; })

// Access to the Data Cache Cachability Register
#define mtdccr(v)   ({ asm volatile("mtdccr %0\n\t" : : "r"(v) ); })
#define mfdccr()    ({ Huint _v; asm volatile("mfdccr %0\n\t" : "=r"(_v) ); _v; })

// Access to the Data Cache Write Through Register
#define mtdcwr(v)   ({ asm volatile("mtdcwr %0\n\t" : : "r"(v) ); })
#define mfdcwr()    ({ Huint _v; asm volatile("mfdcwr %0\n\t" : "=r"(_v) ); _v; })

// Access to the Machine State Register
#define mtmsr(v)    ({ asm volatile("mtmsr %0\n\t" : : "r"(v) ); })
#define mfmsr()     ({ Huint _v; asm volatile("mfmsr %0\n\t" : "=r"(_v) ); _v; })
#define ormsr(m)    ({ Huint _v; _v = mfmsr() | (m); mtmsr(_v); })
#define andmsr(m)   ({ Huint _v; _v = mfmsr() & (m); mtmsr(_v); })

// Access to the Instruction Cache Cachability Register
#define mticcr(v)   ({ asm volatile("mticcr %0\n\t" : : "r"(v) ); })
#define mficcr()    ({ Huint _v; asm volatile("mficcr %0\n\t" : "=r"(_v) ); _v; })

// Access to the Instruction Cache Debug Data Register
#define mticdbdr(v)   ({ asm volatile("mticdbdr %0\n\t" : : "r"(v) ); })
#define mficdbdr()    ({ Huint _v; asm volatile("mficdbdr %0\n\t" : "=r"(_v) ); _v; })

// Access to the Core Configuration Register
#define mtccr0(v)   ({ asm volatile("mtccr0 %0\n\t" : : "r"(v) ); })
#define mfccr0()    ({ Huint _v; asm volatile("mfccr0 %0\n\t" : "=r"(_v) ); _v; })
#define orccr0(m)   ({ Huint _v; _v = mfccr0() | (m); mtccr0(_v); })
#define andccr0(m)  ({ Huint _v; _v = mfccr0() & (m); mtccr0(_v); })

// Access to the Data Access Compare Registers
#define mtdac1(v)   ({ asm volatile("mtdac1 %0\n\t" : : "r"(v) ); })
#define mfdac1()    ({ Huint _v; asm volatile("mfdac1 %0\n\t" : "=r"(_v) ); _v; })
#define mtdac2(v)   ({ asm volatile("mtdac2 %0\n\t" : : "r"(v) ); })
#define mfdac2()    ({ Huint _v; asm volatile("mfdac2 %0\n\t" : "=r"(_v) ); _v; })

// Access to the Data Value Compare Registers
#define mtdvc1(v)   ({ asm volatile("mtdvc1 %0\n\t" : : "r"(v) ); })
#define mfdvc1()    ({ Huint _v; asm volatile("mfdvc1 %0\n\t" : "=r"(_v) ); _v; })
#define mtdvc2(v)   ({ asm volatile("mtdvc2 %0\n\t" : : "r"(v) ); })
#define mfdvc2()    ({ Huint _v; asm volatile("mfdvc2 %0\n\t" : "=r"(_v) ); _v; })

// Access to the Debug Status Register
#define mtdbsr(v)   ({ asm volatile("mtdbsr %0\n\t" : : "r"(v) ); })
#define mfdbsr()    ({ Huint _v; asm volatile("mfdbsr %0\n\t" : "=r"(_v) ); _v; })
#define ordbsr(m)   ({ Huint _v; _v = mfdbsr() | (m); mtdbsr(_v); })
#define anddbsr(m)  ({ Huint _v; _v = mfdbsr() & (m); mtdbsr(_v); })

// Access to the Debug Control Registers
#define mtdbcr0(v)  ({ asm volatile("mtdbcr0 %0\n\t" : : "r"(v) ); })
#define mfdbcr0()   ({ Huint _v; asm volatile("mfdbcr0 %0\n\t" : "=r"(_v) ); _v; })
#define ordbcr0(m)  ({ Huint _v; _v = mfdbcr0() | (m); mtdbcr0(_v); })
#define anddbcr0(m) ({ Huint _v; _v = mfdbcr0() & (m); mtdbcr0(_v); })
#define mtdbcr1(v)  ({ asm volatile("mtdbcr1 %0\n\t" : : "r"(v) ); })
#define mfdbcr1()   ({ Huint _v; asm volatile("mfdbcr1 %0\n\t" : "=r"(_v) ); _v; })
#define ordbcr1(m)  ({ Huint _v; _v = mfdbcr1() | (m); mtdbcr1(_v); })
#define anddbcr1(m) ({ Huint _v; _v = mfdbcr1() & (m); mtdbcr1(_v); })

// Access to the Data Exception Address Register
#define mtdear(v)   ({ asm volatile("mtdear %0\n\t" : : "r"(v) ); })
#define mfdear()    ({ Huint _v; asm volatile("mfdear %0\n\t" : "=r"(_v) ); _v; })

// Access to the Exception Syndrom Register
#define mtesr(v)    ({ asm volatile("mtesr %0\n\t" : : "r"(v) ); })
#define mfesr()     ({ Huint _v; asm volatile("mfesr %0\n\t" : "=r"(_v) ); _v; })
#define oresr(m)    ({ Huint _v; _v = mfesr() | (m); mtesr(_v); })
#define andesr(m)   ({ Huint _v; _v = mfesr() & (m); mtesr(_v); })

// Access to the Exception Vector Prefix Register
#define mtevpr(v)   ({ asm volatile("mtevpr %0\n\t" : : "r"(v) ); })
#define mfevpr()    ({ Huint _v; asm volatile("mfevpr %0\n\t" : "=r"(_v) ); _v; })

// Access to the Interrupt Vector Prefix Register
#define mtivpr(v)   ({ asm volatile("mtivpr %0\n\t" : : "r"(v) ); })
#define mfivpr()    ({ Huint _v; asm volatile("mfivpr %0\n\t" : "=r"(_v) ); _v; })

// Access to the Interrupt Vector Offset Registers
#define mtivor0(v)   ({ asm volatile("mtivor0 %0\n\t" : : "r"(v) ); })
#define mfivor0()    ({ Huint _v; asm volatile("mfivor0 %0\n\t" : "=r"(_v) ); _v; })
#define mtivor1(v)   ({ asm volatile("mtivor1 %0\n\t" : : "r"(v) ); })
#define mfivor1()    ({ Huint _v; asm volatile("mfivor1 %0\n\t" : "=r"(_v) ); _v; })
#define mtivor2(v)   ({ asm volatile("mtivor2 %0\n\t" : : "r"(v) ); })
#define mfivor2()    ({ Huint _v; asm volatile("mfivor2 %0\n\t" : "=r"(_v) ); _v; })
#define mtivor3(v)   ({ asm volatile("mtivor3 %0\n\t" : : "r"(v) ); })
#define mfivor3()    ({ Huint _v; asm volatile("mfivor3 %0\n\t" : "=r"(_v) ); _v; })
#define mtivor4(v)   ({ asm volatile("mtivor4 %0\n\t" : : "r"(v) ); })
#define mfivor4()    ({ Huint _v; asm volatile("mfivor4 %0\n\t" : "=r"(_v) ); _v; })
#define mtivor5(v)   ({ asm volatile("mtivor5 %0\n\t" : : "r"(v) ); })
#define mfivor5()    ({ Huint _v; asm volatile("mfivor5 %0\n\t" : "=r"(_v) ); _v; })
#define mtivor6(v)   ({ asm volatile("mtivor6 %0\n\t" : : "r"(v) ); })
#define mfivor6()    ({ Huint _v; asm volatile("mfivor6 %0\n\t" : "=r"(_v) ); _v; })
#define mtivor7(v)   ({ asm volatile("mtivor7 %0\n\t" : : "r"(v) ); })
#define mfivor7()    ({ Huint _v; asm volatile("mfivor7 %0\n\t" : "=r"(_v) ); _v; })
#define mtivor8(v)   ({ asm volatile("mtivor8 %0\n\t" : : "r"(v) ); })
#define mfivor8()    ({ Huint _v; asm volatile("mfivor8 %0\n\t" : "=r"(_v) ); _v; })
#define mtivor9(v)   ({ asm volatile("mtivor9 %0\n\t" : : "r"(v) ); })
#define mfivor9()    ({ Huint _v; asm volatile("mfivor9 %0\n\t" : "=r"(_v) ); _v; })
#define mtivor10(v)   ({ asm volatile("mtivor10 %0\n\t" : : "r"(v) ); })
#define mfivor10()    ({ Huint _v; asm volatile("mfivor10 %0\n\t" : "=r"(_v) ); _v; })
#define mtivor11(v)   ({ asm volatile("mtivor11 %0\n\t" : : "r"(v) ); })
#define mfivor11()    ({ Huint _v; asm volatile("mfivor11 %0\n\t" : "=r"(_v) ); _v; })
#define mtivor12(v)   ({ asm volatile("mtivor12 %0\n\t" : : "r"(v) ); })
#define mfivor12()    ({ Huint _v; asm volatile("mfivor12 %0\n\t" : "=r"(_v) ); _v; })
#define mtivor13(v)   ({ asm volatile("mtivor13 %0\n\t" : : "r"(v) ); })
#define mfivor13()    ({ Huint _v; asm volatile("mfivor13 %0\n\t" : "=r"(_v) ); _v; })
#define mtivor14(v)   ({ asm volatile("mtivor14 %0\n\t" : : "r"(v) ); })
#define mfivor14()    ({ Huint _v; asm volatile("mfivor14 %0\n\t" : "=r"(_v) ); _v; })
#define mtivor15(v)   ({ asm volatile("mtivor15 %0\n\t" : : "r"(v) ); })
#define mfivor15()    ({ Huint _v; asm volatile("mfivor15 %0\n\t" : "=r"(_v) ); _v; })

// Access to the Instruction Address Compare Registers
#define mtiac1(v)   ({ asm volatile("mtiac1 %0\n\t" : : "r"(v) ); })
#define mfiac1()    ({ Huint _v; asm volatile("mfiac1 %0\n\t" : "=r"(_v) ); _v; })
#define mtiac2(v)   ({ asm volatile("mtiac2 %0\n\t" : : "r"(v) ); })
#define mfiac2()    ({ Huint _v; asm volatile("mfiac2 %0\n\t" : "=r"(_v) ); _v; })
#define mtiac3(v)   ({ asm volatile("mtiac3 %0\n\t" : : "r"(v) ); })
#define mfiac3()    ({ Huint _v; asm volatile("mfiac3 %0\n\t" : "=r"(_v) ); _v; })
#define mtiac4(v)   ({ asm volatile("mtiac4 %0\n\t" : : "r"(v) ); })
#define mfiac4()    ({ Huint _v; asm volatile("mfiac4 %0\n\t" : "=r"(_v) ); _v; })

// Access to the Process Identifier Register
#define mtpid(v)    ({ asm volatile("mtpid %0\n\t" : : "r"(v) ); })
#define mfpid()     ({ Huint _v; asm volatile("mfpid %0\n\t" : "=r"(_v) ); _v; })

// Access to the Process Identifier Register
#define mtpit(v)    ({ asm volatile("mtpit %0\n\t" : : "r"(v) ); })
#define mfpit()     ({ Huint _v; asm volatile("mfpit %0\n\t" : "=r"(_v) ); _v; })

// Access to the Process Identifier Register
#define mfpvr()     ({ Huint _v; asm volatile("mfpvr %0\n\t" : "=r"(_v) ); _v; })

// Access to the Storage Little Endian Register
#define mtsler(v)   ({ asm volatile("mtsler %0\n\t" : : "r"(v) ); })
#define mfsler()    ({ Huint _v; asm volatile("mfsler %0\n\t" : "=r"(_v) ); _v; })

// Access to the SPR General Purpose Registers
#define mtsprg0(v)  ({ asm volatile("mtsprg0 %0\n\t" : : "r"(v) ); })
#define mfsprg0()   ({ Huint _v; asm volatile("mfsprg0 %0\n\t" : "=r"(_v) ); _v; })
#define mtsprg1(v)  ({ asm volatile("mtsprg1 %0\n\t" : : "r"(v) ); })
#define mfsprg1()   ({ Huint _v; asm volatile("mfsprg1 %0\n\t" : "=r"(_v) ); _v; })
#define mtsprg2(v)  ({ asm volatile("mtsprg2 %0\n\t" : : "r"(v) ); })
#define mfsprg2()   ({ Huint _v; asm volatile("mfsprg2 %0\n\t" : "=r"(_v) ); _v; })
#define mtsprg3(v)  ({ asm volatile("mtsprg3 %0\n\t" : : "r"(v) ); })
#define mfsprg3()   ({ Huint _v; asm volatile("mfsprg3 %0\n\t" : "=r"(_v) ); _v; })
#define mtsprg4(v)  ({ asm volatile("mtsprg4 %0\n\t" : : "r"(v) ); })
#define mfsprg4()   ({ Huint _v; asm volatile("mfsprg4 %0\n\t" : "=r"(_v) ); _v; })
#define mtsprg5(v)  ({ asm volatile("mtsprg5 %0\n\t" : : "r"(v) ); })
#define mfsprg5()   ({ Huint _v; asm volatile("mfsprg5 %0\n\t" : "=r"(_v) ); _v; })
#define mtsprg6(v)  ({ asm volatile("mtsprg6 %0\n\t" : : "r"(v) ); })
#define mfsprg6()   ({ Huint _v; asm volatile("mfsprg6 %0\n\t" : "=r"(_v) ); _v; })
#define mtsprg7(v)  ({ asm volatile("mtsprg7 %0\n\t" : : "r"(v) ); })
#define mfsprg7()   ({ Huint _v; asm volatile("mfsprg7 %0\n\t" : "=r"(_v) ); _v; })

// Access to the Save/Restore Registers
#define mtsrr0(v)   ({ asm volatile("mtsrr0 %0\n\t" : : "r"(v) ); })
#define mfsrr0()    ({ Huint _v; asm volatile("mfsrr0 %0\n\t" : "=r"(_v) ); _v; })
#define mtsrr1(v)   ({ asm volatile("mtsrr1 %0\n\t" : : "r"(v) ); })
#define mfsrr1()    ({ Huint _v; asm volatile("mfsrr1 %0\n\t" : "=r"(_v) ); _v; })
#define mtsrr2(v)   ({ asm volatile("mtsrr2 %0\n\t" : : "r"(v) ); })
#define mfsrr2()    ({ Huint _v; asm volatile("mfsrr2 %0\n\t" : "=r"(_v) ); _v; })
#define mtsrr3(v)   ({ asm volatile("mtsrr3 %0\n\t" : : "r"(v) ); })
#define mfsrr3()    ({ Huint _v; asm volatile("mfsrr3 %0\n\t" : "=r"(_v) ); _v; })

// Access to the Storage User-Defined 0 Register
#define mtsu0r(v)   ({ asm volatile("mtsu0r %0\n\t" : : "r"(v) ); })
#define mfsu0r()    ({ Huint _v; asm volatile("mfsu0r %0\n\t" : "=r"(_v) ); _v; })

// Access to the User SPR General Purpose Register
#define mtusprg0(v) ({ asm volatile("mtusprg0 %0\n\t" : : "r"(v) ); })
#define mfusprg0()  ({ Huint _v; asm volatile("mfusprg0 %0\n\t" : "=r"(_v) ); _v; })

// Access to the Time Base Register
#define mttbl(v)    ({ asm volatile("mttbl %0\n\t" : : "r"(v) ); })
#define mftbl()     ({ Huint _v; asm volatile("mftbl %0\n\t" : "=r"(_v) ); _v; })
#define mttbu(v)    ({ asm volatile("mttbu %0\n\t" : : "r"(v) ); })
#define mftbu()     ({ Huint _v; asm volatile("mftbu %0\n\t" : "=r"(_v) ); _v; })

// Access to the Timer Control Register
#define mttcr(v)    ({ asm volatile("mttcr %0\n\t" : : "r"(v) ); })
#define mftcr()     ({ Huint _v; asm volatile("mftcr %0\n\t" : "=r"(_v) ); _v; })
#define ortcr(m)    ({ Huint _v; _v = mftcr() | (m); mttcr(_v); })
#define andtcr(m)   ({ Huint _v; _v = mftcr() & (m); mttcr(_v); })

// Access to the Timer Status Register
#define mttsr(v)    ({ asm volatile("mttsr %0\n\t" : : "r"(v) ); })
#define mftsr()     ({ Huint _v; asm volatile("mftsr %0\n\t" : "=r"(_v) ); _v; })
#define ortsr(m)    ({ Huint _v; _v = mftsr() | (m); mttsr(_v); })
#define andtsr(m)   ({ Huint _v; _v = mftsr() & (m); mttsr(_v); })

// Access to the Fixed-Point Exception Register
#define mtxer(v)    ({ asm volatile("mtxer %0\n\t" : : "r"(v) ); })
#define mfxer()     ({ Huint _v; asm volatile("mfxer %0\n\t" : "=r"(_v) ); _v; })
#define orxer(m)    ({ Huint _v; _v = mfxer() | (m); mtxer(_v); })
#define andxer(m)   ({ Huint _v; _v = mfxer() & (m); mtxer(_v); })

// Access to the Zone Protection Register
#define mtzpr(v)    ({ asm volatile("mtzpr %0\n\t" : : "r"(v) ); })
#define mfzpr()     ({ Huint _v; asm volatile("mfzpr %0\n\t" : "=r"(_v) ); _v; })

// Access to the Link Register
#define mtlr(v)     ({ asm volatile("mtlr %0\n\t" : : "r"(v) ); })
#define mflr()      ({ Huint _v; asm volatile("mflr %0\n\t" : "=r"(_v) ); _v; })

// Access to the Count Register
#define mtctr(v)    ({ asm volatile("mtctr %0\n\t" : : "r"(v) ); })
#define mfctr()     ({ Huint _v; asm volatile("mfctr %0\n\t" : "=r"(_v) ); _v; })

// Access to the Device Control Register
#define mtdcr(d,v)  ({ asm volatile("mtdcr "#d" , %1\n\t" : : "r"(d),"r"(v) ); })
#define mfdcr(d)    ({ Huint _v; asm volatile("mfdcr %0, "#d"\n\t" : "=r"(_v) ); _v; })

// Access to data/instruction synchronising instructions
#define sync()      ({ asm volatile("sync\n\t" ); })
#define isync()     ({ asm volatile("isync\n\t" ); })

// Access to system linkage instructions
#define sc()        ({ asm volatile("sc\n\t" ); })
#define rfi()       ({ asm volatile("rfi\n\t" ); })
#define rfci()      ({ asm volatile("rfci\n\t" ); })

// Access to memory management instructions
// These definitions work around known issues with the PowerPC 405 on
// Xilinx Processors.
#define dcbi(a,b)   ({ asm volatile("dcbi %0, %1\n\t" : : "r"(a),"r"(b) ); })
#define dcba(a,b)   ({ asm volatile("dcba %0, %1\n\t" : : "r"(a),"r"(b) ); })
#define dcbf(a,b)   ({ asm volatile("dcbf %0, %1\n\t" : : "r"(a),"r"(b) ); })
#define dcbst(a,b)  ({ asm volatile("dcbst %0, %1\n\t" : : "r"(a),"r"(b) ); })
#define dcbt(a,b)   ({ asm volatile("dcbt %0, %1\n\t" : : "r"(a),"r"(b) ); })
#define dcbtst(a,b) ({ asm volatile("dcbtst %0, %1\n\t" : : "r"(a),"r"(b) ); })
#define dcbz(a,b)   ({ asm volatile("dcbz %0, %1\n\t" : : "r"(a),"r"(b) ); })
#define dccci(a,b)  ({ asm volatile("dccci %0, %1\n\t" : : "r"(a),"r"(b) ); })
#define dcread(a,b) ({ Huint _v; asm volatile("dcread %0, %1, %2\n\t" : "=r"(_v) : "r"(a),"r"(b) ); _v; })
#define icbi(a,b)   ({ asm volatile("icbi %0, %1\n\t" : : "r"(a),"r"(b) ); })
#define icbt(a,b)   ({ Huint msr = mfmsr(); andmsr(MSR_DR); asm volatile("icbt %0, %1\n\t" : : "r"(a),"r"(b) ); mtmsr(msr); })
#define iccci()     ({ Huint msr = mfmsr(); andmsr(MSR_DR); asm volatile("iccci 0, 0\n\t" ); mtmsr(msr); })
#define icread(a,b) ({ Huint _v; asm volatile("icread %0, %1, %2\n\t" : "=r"(_v) : "r"(a),"r"(b) ); _v; })

// Access to virtual memory management instructions
#define tlbia()         ({ asm volatile("tlbia\n\t" ); })
#define tlbre(d,a,w)    ({ asm volatile("tlbre %0, %1,"#w"\n\t" : "=r"(d) : "r"(a) ); })
#define tlbsx(d,a,b)    ({ asm volatile("tlbsx %0, %1, %2\n\t" : "=r"(d) : "r"(a),"r"(b) ); })
#define tlbsync()       ({ asm volatile("tlbsync\n\t" ); })
#define tlbwe(s,a,w)    ({ asm volatile("tlbwe %0, %1,"#w"\n\t" : : "r"(s),"r"(a) ); })

// Access to the nop instruction
#define nop()       ({ asm volatile("nop\n\t" ); })

// Access to the move register instruction
#define mr(a,b)     ({ asm volatile("mr %0, "#b"\n\t" : "=r"(a) ); })

#endif
