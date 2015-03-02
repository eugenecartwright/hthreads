/**	\internal
  *	\file	    context.h
  * \brief      Declaration of context switching macros.
  *
  * \author     Seth Warn
  *
  *	This file declares the struct used to store microblaze context and
  *	the routines to save and restore contexts.
  */
#ifndef _HYBRID_THREADS_MB_CONTEXT_
#define _HYBRID_THREADS_MB_CONTEXT_

#define STACK_ALIGN 4

/** \internal
  * \brief  The structure used during context saving or context restoring.
  *
  * Note that the context switching routines in context.S assume that the
  * registers are the first element of the struct.
  */
typedef struct
{
    unsigned int regs[33];
} mb_context_t;

// register usage conventions for the MicroBlaze
#define MB_LR 15
#define MB_MSR 32 
#define MB_SP 1
#define MB_ARG0 5
#define MB_ARG1 6


#endif
