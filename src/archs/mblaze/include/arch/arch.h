/**	\internal
  *	\file	    arch.h
  * \brief      Declaration of architecture dependent functionality.
  *
  * \author     Seth Warn
  * 
  * based on work by Wesley Peck and Ed Komp
  */
#ifndef _HYBRID_THREADS_MB_ARCH_
#define _HYBRID_THREADS_MB_ARCH_

#include <hthread.h>
#include <sys/internal.h>
#include <arch/context.h>

// Disable architecture debugging by default
#ifndef ARCH_DEBUG
#define ARCH_DEBUG  0
#endif

// The architecture-specific interrupt-enabling function is aliased to the
// Xilinx-provided routine to disable interrupts on the MicroBlaze
#define _arch_enable_intr microblaze_enable_interrupts

// These functions are provided in Xilinx libraries.
extern void microblaze_enable_interrupts(void);
extern void microblaze_enable_exceptions(void);
extern void microblaze_init_icache_range();
extern void microblaze_enable_icache();
extern void microblaze_disable_icache();
extern void microblaze_invalidate_icache();
extern void microblaze_init_dcache_range();
extern void microblaze_enable_dcache();
extern void microblaze_disable_dcache();
extern void microblaze_invalidate_dcache();

// These functions are defined in the hthreads MicroBlaze-specific code.
void _mb_enter_user_mode(void);
Huint _arch_setup_thread(Huint, hthread_thread_t*, hthread_start_t, void *);
Huint _arch_destroy_thread(Huint,hthread_thread_t*, Huint);
void  _arch_enter_user(void);
void  _init_arch_specific(void);

extern mb_context_t     mb_context_table[ MAX_THREADS ];

// Some code in the tools directory is compiled for the host (typically x86),
// but includes arch.h and calls _get_procid() for reasons I don't understand.
// The host code can't link against the MicroBlaze _get_procid function, so
// for the host, we use a macro to make that 0.
#if defined(HTHREADS_HOSTTOOLS) || !defined(HTHREADS_SMP) 
#define _get_procid() 0
#else
Huint _get_procid(void);
#endif

#endif

