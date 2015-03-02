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
  * \file       core.c
  * \brief      The implementation of the system call handler.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  *
  * FIXME: Add description
  */
#include <hthread.h>
#include <sys/core.h>
#include <arch/context.h>
#include <arch/regs.h>
#include <arch/arch.h>
#include <arch/asm.h>

ppc405_context_t    __global_context;
ppc405_context_t    ppc405_context_table[ MAX_THREADS ];

Huint _arch_setup_thread( Huint th, hthread_thread_t *thread, hthread_start_t start, void *arg )
{
    void                *stack;
    ppc405_context_t    *context;

    // Create a new context for the thread (return an error if we couldn't)
    //context = (ppc405_context_t*)malloc( sizeof(ppc405_context_t) );
    //if( context == NULL )   return ENOMEM;
    context = &ppc405_context_table[ (Huint)th ];
    
    // Store the pointer to the context into the thread's context pointer
    thread->context = context;

    // On the PPC405 the stack works from the bottom up. Thus, here we move the
    // stack pointer to the end of the stack. When doing this it is important for
    // us to reserve a frame on the stack for the compiler to use.
    stack = thread->stack;
    stack += thread->stacksize;
    stack -= HTHREAD_STACK_RESERVE;

    // The first four bytes of the context point to the memory that stores the
    // contents of the registers during a context switch (required by context switcher)
	context->address = (Huint)(&context->regs);

    // At the end of a context switch a branch to link register is performed.
    // In order to start the correct function we must place the function's address
    // in the link register so that the context switcher will branch to it.
    // 
    // The hthread's system requires that all threads be bootstrapped by a function
    // called "_bootstrap_thread". Thus, this code places the address of the
    // bootstrap function into the link register.
	context->regs[PPC405_LR] = (Huint)_bootstrap_thread;

    // By default, when a thread is started, interrupts are enabled. This is done by
    // setting the enable interrupts bit in the machine state register on the PPC405
	context->regs[PPC405_MSR] = MSR_CE | MSR_EE | MSR_ME ; // | MSR_PR;
   
    // Setup MSR bits to forward all data TLB entries to TS = 1
    // Setup MSR bits to forward all instruction TLB entries to TS = 0
    context->regs[PPC405_MSR] = context->regs[PPC405_MSR] | MSR_DR ;

    // If the thread has a stack then store it into the PPC's stack pointer register
    // If the thread we are setting up has a stack then we need to store the pointer
    // to the stack in the PPC405's GPR1 register.
	if( thread->stacksize > 0 ) context->regs[PPC405_GPR1] = (Huint)stack;

    // The function which bootstraps threads requires two arguments. The first argument
    // if the address of the function to bootstrap. The second argument is the
    // argument that is given to the function being bootstrapped. In order to pass 
    // these two arguments to the bootstrap function we must storethen into
    // GPR3 and GPR4.
	context->regs[PPC405_GPR3] = (Huint)start;
	context->regs[PPC405_GPR4] = (Huint)arg;

    // At this point the function was completed successfully.
	return SUCCESS;
}

Huint _arch_destroy_thread( Huint th, hthread_thread_t *thread, Huint id )
{
    // Return successfully
	return SUCCESS;
}
