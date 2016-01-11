/** \internal
  * \file       arch.c
  *
  * \author     Seth Warn <swarn@uark.edu>
  *
  * This file has the implementation of functions declared in arch.h
  * including thread setup and destruction, entering user mode, and
  * getting processor ID.  The architecture-specific initialization
  * code is in init.c.
  *
  * Based on the original PPC version by Wesley Peck and Ed Komp.
  */

#include <hthread.h>
#include <sys/core.h>
#include <arch/context.h>
#include <arch/arch.h>


// enable interrupts bit
#define MSR_IE 0x00000002

// enable hardware exceptions bit
#define MSR_EE 0x00000100

// user mode bit
#define MSR_UM 0x00000800

// enable instruction cache bit set according to compile flags
#ifdef HT_ENABLE_MB_ICACHE
#define MSR_ICE 0x00000020
#else
#define MSR_ICE 0x00000000
#endif

// enable data cache bit set according to compile flags
#ifdef HT_ENABLE_MB_DCACHE
#define MSR_DCE 0x00000080
#else
#define MSR_DCE 0x00000000
#endif

mb_context_t    mb_context_table[ MAX_THREADS ];


/**
 * Initialize a thread context when it is first created.
 *
 * Note: The hthreads system calls this function for the main() thread, but
 * the main thread is _not_ context switched into the first time it runs.
 * Instead, the system jumps directly to the "main" symbol.  Therefore, some
 * work done by this function (e.g., enabling cache) is also done in the
 * architecture specific setup in init.c.
 */
Huint _arch_setup_thread( Huint th, hthread_thread_t *thread,
                          hthread_start_t start, void *arg )
{
    void* stack;
    mb_context_t* context = &mb_context_table[ (Huint)th ];
    
    // Store the pointer to the context into the thread's context pointer
    thread->context = context;

    //************************************************************************
    // Stack Pointer Initialization
    // 
    // The "stack" field of the hthread_thread_t struct points to the
    // beginning of the region malloc'ed for the thread's stack.  The stack
    // grows towards zero, so we need to put the stack pointer at the bottom,
    // while reserving space at the bottom for the compiler to use.
    //
    // If a thread has no allocated stack, its stack pointer is set to 0.
    //************************************************************************
 	if( thread->stacksize > 0 ) 
    {
        stack = thread->stack;
        stack += thread->stacksize;
        stack -= HTHREAD_STACK_RESERVE;
        context->regs[MB_SP] = (Huint)stack;
    }
    else
    {
        context->regs[MB_SP] = 0;
    }

    //************************************************************************
    // Thread Bootstrapping
    //
    // The hthreads code defines a function "_bootstrap_thread" (located in
    // src/software/system/bootstrap.c) that calls the thread entry function
    // and ensures that hthread_exit is called the thread finishes.  Make
    // _boostrap_thread run first by placing it in the link register of the
    // thread context.
    //
    // The _boostrap thread function takes two arguments: the thread entry
    // function, and a pointer to the arguments for the thread entry function.
    // These are placed in the argument registers of the MicroBlaze.
    //************************************************************************
	context->regs[MB_LR] = (Huint)_bootstrap_thread;
	context->regs[MB_ARG0] = (Huint)start;
	context->regs[MB_ARG1] = (Huint)arg;

    //************************************************************************
    // Initial MSR Value
    //
    // At thread start:
    // - Interrupts are enabled.
    // - Exceptions are enabled.
    // - The MicroBlaze is in user mode.
    // - Data Cache Enable and Instruction Cache Enable bits are set according
    //   to the defined compile flags.
    //************************************************************************
	context->regs[MB_MSR] = MSR_IE | MSR_EE | MSR_UM | MSR_DCE | MSR_ICE;
    
	return SUCCESS;
}

/**
 * No action is needed to destroy a thread. TCB was statically declared.
 */
Huint _arch_destroy_thread( Huint th, hthread_thread_t *thread, Huint id )
{
	return SUCCESS;
}

#ifdef HTHREADS_SMP
/**
 * Processor ID is used in SMP systems.  In these systems, each MicroBlaze
 * must have the full PVR option (C_PVR=2), and unique ID numbers should be
 * placed in the PVR1 register of each MicroBlaze.  The ID numbers should
 * start at 0 and go up, i.e. 0, 1, 2...
 */
Huint _get_procid(void)
{
    Huint id;
    asm volatile ("mfs %[id_var],rpvr1" : [id_var] "=d" (id));
    return id;
}
#endif
