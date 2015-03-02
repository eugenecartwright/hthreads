/** \internal
  * \file       init.c
  *
  * \author     Seth Warn <swarn@uark.edu>
  *
  * based on the PPC version by Wesley Peck and Ed Komp
  *
  * Implementations of the functions ("_init_arch_specific" and 
  * "_arch_enter_user") used during hthread initialization.  See
  * "src/software/system/init.c".
  */

#include <hthread.h>
#include <sys/core.h>
#include <sys/syscall.h>
#include <sys/exception.h>
#include <arch/arch.h>
#include <arch/htime.h>


void _mb_enable_cache(void);
void _mb_enable_intr(void);


void _init_arch_specific(void)
{
    TRACE_PRINTF(TRACE_INFO, TRACE_INIT, "Setting up MicroBlaze...\n");

    TRACE_PRINTF(TRACE_INFO, TRACE_INIT, "Initializing PIC...\n");
    
    // Enable the PIC(s)
    _mb_enable_intr();

    TRACE_PRINTF(TRACE_INFO, TRACE_INIT, "Initializing Time Counter...\n");

    // Reset the cycle counter to zero
    _init_timer();

    // Enable caching (according to compile flags)
    _mb_enable_cache();

    TRACE_PRINTF(TRACE_INFO, TRACE_INIT, "Enabling Hardware Exceptions...\n");

    microblaze_enable_exceptions();
}


void _arch_enter_user( void )
{
    TRACE_PRINTF(TRACE_INFO, TRACE_INIT, "Enabling Microblaze User Mode...\n");

    _mb_enter_user_mode();
}


#ifndef HTHREADS_SMP
// Single-Processor Interrupt Enable
void _mb_enable_intr(void)
{
    // Enable interrupts on the PIC
    intr_enable(PIC_BASEADDR, 0xFFFFFFFF);

    // Clear interrupts from the PIC
    intr_ack(PIC_BASEADDR, 0xFFFFFFFF);

    // Set master enable on the PIC
    intr_menable(PIC_BASEADDR);
}

#else
// Two-Processor Interrupt Enable.
//
// The current system design sends the interrupts from the scheduler
// to the pics attached to both CPUs.  This function acts like the
// single-CPU version above, and additionally ensures that:
//   * Each CPU enables its own PIC
//   * Each CPU masks off interrups destined for the other CPU
void _mb_enable_intr(void)
{
    Huint pic_base_address;
    Huint intr_mask;
    Huint id = _get_procid();

    if(id == 0)
    {
        pic_base_address = PIC_BASEADDR_0;
        intr_mask = ~PREEMPT_1_INTR_MASK;
    }
    else
    {
        pic_base_address = PIC_BASEADDR_1;
        intr_mask = ~PREEMPT_0_INTR_MASK;
    }

    intr_enable(pic_base_address, intr_mask);
    intr_ack(pic_base_address, 0xFFFFFFFF);
    intr_menable(pic_base_address);
}

#endif


void _mb_enable_cache(void)
{
#ifdef HT_ENABLE_MB_ICACHE
    TRACE_PRINTF(TRACE_INFO, TRACE_INIT, "Init. Instruction Cache...\n");

    microblaze_init_icache_range(XPAR_MICROBLAZE_0_ICACHE_BASEADDR,
                                 XPAR_MICROBLAZE_0_CACHE_BYTE_SIZE);
    microblaze_enable_icache();
#endif

#ifdef HT_ENABLE_MB_DCACHE
    TRACE_PRINTF(TRACE_INFO, TRACE_INIT, "Init. Data Cache...\n");

    microblaze_init_dcache_range(XPAR_MICROBLAZE_0_DCACHE_BASEADDR,
                                 XPAR_MICROBLAZE_0_DCACHE_BYTE_SIZE);
    microblaze_enable_dcache();
#endif
}

