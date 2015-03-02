/** \internal
  * \file       interrupt.c
  * \brief      hthreads interrupt handler
  *
  * For the MicroBlaze, "interrupt" refers specifically to external
  * interrupts received via the "Interrupt" input port.  In a
  * standard hthreads system, there are only two types of interrupts:
  *
  * - A preemption from the scheduler, indicating there should be a
  *   context switch.
  * - Hthread hardware cores, on error, may interrupt the CPU with
  *   an "access interrupt."
  */

#include <debug.h>
#include <hthread.h>
#include <manager/manager.h>
#include <sys/exception.h>
#include <sys/core.h>
#include <scheduler/hardware.h>

/* As described in the Xilinx "Embedded System Tools Reference Manual,"
 * the interrupt_handler attribute makes the function save volatile
 * registers in addition to those normally saved, and return with a 
 * rtid, which re-enables interrupts and restores the previous user mode */
void __interrupt_handler() __attribute__ ((interrupt_handler));
static inline void get_lock(void);
static inline void release_lock(void);


void __interrupt_handler()
{
    Huint status, current_thread, next_thread, preempt_mask, pic_base_addr;

#ifndef HTHREADS_SMP
    preempt_mask = PREEMPT_INTR_MASK;
    pic_base_addr = PIC_BASEADDR;
#else
    if(_get_procid() == 0)
    {
        preempt_mask = PREEMPT_0_INTR_MASK;
        pic_base_addr = PIC_BASEADDR_0;
    }
    else
    {
        preempt_mask = PREEMPT_1_INTR_MASK;
        pic_base_addr = PIC_BASEADDR_1;
    }
#endif

    /* Get the pending interrupts */
    status = intr_pending(pic_base_addr);

    if(status & preempt_mask);
    {
        current_thread = _current_thread();
        next_thread = _yield_thread();

        intr_ack(pic_base_addr, preempt_mask);

        if(current_thread != next_thread)
        {
            get_lock();
            _switch_context(current_thread, next_thread);
            release_lock();
        }

        return;
    }

    if(status & ACCESS_INTR_MASK)
        TRACE_ALWAYS("Access Interrupt\n");
    else
        TRACE_ALWAYS("Unknown Interrupt = %d\n", status);

    TRACE_ALWAYS("--FAILURE--\n");
    while(1);
}


static void get_lock(void)
{
#ifdef HTHREADS_SMP
    while(!_get_syscall_lock());
#endif
}


static void release_lock(void)
{
#ifdef HTHREADS_SMP
    while(!_release_syscall_lock());
#endif
}
