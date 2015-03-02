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
  *	\file	    context.h
  * \brief      Declaration of context switching macros.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  *
  *	This file contains the context switching macros used when compiling for
  * the PowerPC 405 processor.
  */
#ifndef _HYBRID_THREADS_PPC405_CONTEXT_
#define _HYBRID_THREADS_PPC405_CONTEXT_

/** \internal
  * \brief  The structure used during context saving or context restoring.
  *
  * This structure is the structure used during context saving and context
  * restoring operations. The structure allocates enough space to store all
  * of the general purpose registers and some other special purpose registers.
  * For more information see the documentation for PPC405_SAVE_CONTEXT and
  * PPC405_RESTORE_CONTEXT.
  */
typedef struct
{
    /** \brief  Used to store the registered which are preserved during
      *         a context switching operation.
      */
    Huint   address;

    /** \brief  An array to hold all of the registers in the PowerPC 405.
      */
    Huint   regs[48];
} ppc405_context_t;

#define PPC405_SAVE_CONTEXT( context )		        \
	({												\
	 asm volatile(	"lwz	2, 0(%0)"				\
		 			:								\
					: "b" (context)                 \
                    : "2"                           \
                    );	                			\
	 asm volatile(	"mtspr   0x100, 2\n\t"			\
					"mfmsr   0\n\t"					\
					"stw     0, 0(2)\n\t"			\
					"mflr    0\n\t"					\
					"stw     0, 4(2)\n\t"			\
					"mfctr   0\n\t"					\
					"stw     0, 8(2)\n\t"			\
					"mfxer   0\n\t"					\
					"stw     0, 12(2)\n\t"			\
					"mfcr    0\n\t"					\
					"stw     0, 16(2)\n\t"			\
					"stw     1, 24(2)\n\t"          \
					"stmw    3, 32(2)\n\t"          \
                    );		                        \
	})

#define PPC405_RESTORE_CONTEXT( context )			    \
	({												    \
	 asm volatile(	"lwz	2, 0(%0)"				    \
		 			:								    \
					: "b" (context)                     \
                    : "2"                               \
                    );				                    \
	 asm volatile(	"mtusprg0   2	        \n\t"		\
                    "lwz        0, 4(2)	    \n\t"		\
					"mtlr       0			\n\t"		\
					"lwz        0, 8(2)	    \n\t"		\
					"mtctr      0			\n\t"		\
					"lwz        0, 12(2)	\n\t"		\
					"mtxer      0			\n\t"		\
					"lwz        0, 16(2)	\n\t"		\
					"mtcr       0			\n\t"		\
					"lwz        0, 0(2)	    \n\t"		\
					"mtsrr1     0			\n\t"		\
					"lwz        1, 24(2)	\n\t"		\
				    "lmw        3, 32(2)	\n\t"       \
                    );                                  \
	})

#define PPC405_RESTORE_NEW_CONTEXT( context )           \
	({												    \
	 asm volatile(	"lwz	2, 0(%0)"				    \
		 			:								    \
					: "b" (context)                     \
                    : "2"                               \
                    );				                    \
	 asm volatile(  "mtusprg0   2	        \n\t"		\
                    "lwz        0, 4(2)	    \n\t"		\
					"mtsrr0     0   	    \n\t"		\
					"lwz        0, 8(2)	    \n\t"		\
					"mtctr      0			\n\t"		\
					"lwz        0, 12(2)	\n\t"		\
					"mtxer      0			\n\t"		\
					"lwz        0, 16(2)	\n\t"		\
					"mtcr       0			\n\t"		\
					"lwz        0, 0(2)	    \n\t"		\
					"mtsrr1     0			\n\t"		\
					"lwz        1, 24(2)	\n\t"		\
				    "lmw        3, 32(2)	\n\t"		\
				    "rfi"                               \
                    );		                            \
	})

#define SAVE_CONTEXT(context)           PPC405_SAVE_CONTEXT(context)
#define RESTORE_CONTEXT(context)        PPC405_RESTORE_CONTEXT(context)
#define RESTORE_NEW_CONTEXT(context)    PPC405_RESTORE_NEW_CONTEXT(context)

#endif
