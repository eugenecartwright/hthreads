/** \internal
  * \file       crt0.S
  *
  * \author     Seth Warn <swarn@uark.edu>
  *
  * Startup code.  Partially based on the crt0.s and crtinit.S provided
  * by Xilinx.
  */

#include <config.h>

/****************************************************************************
 * First, populate vectors according to the MicroBlaze reference guide
 * (ug081).
 ***************************************************************************/
        .globl _start
        .section .vectors.reset, "ax"
        .align 2
_start:
        brai    _start1

        .section .vectors.sw_exception, "ax"
        .align 2
_vector_sw_exception:
        brai    _system_call_handler

        .section .vectors.interrupt, "ax"
        .align 2
_vector_interrupt:
        brai    _interrupt_handler

        .section .vectors.hw_exception, "ax"
        .align 2
_vector_hw_exception:
        brai    _hw_exception_handler


// **************************************************************************
// As set above, _start1 is the symbol jumped to after a hard or soft reset.
// **************************************************************************
        .section .text
        .globl _start1
        .align 2
_start1:
        // All CPUs must set the Small Data Anchors
        la  r13, r0, _SDA_BASE_
        la  r2, r0, _SDA2_BASE_

        // Determine which CPU we are running on by reading PVR1.  These
        // values must be manually set by the system designer.
        mfs r3, rpvr1

        // CPU 0 will be the master and is responsible for various one-time-
        // only initialization routines.  Other CPUs only need to run per-CPU
        // routines.
        bnei r3, _setup_slave_cpu

_setup_master_cpu:

        // Set the stack pointer to the stack allocated for CPU 0
        la r1, r0, __stack0-16

        // ******************************************************************
        // Clear the SBSS and BSS segments.  These memory segements contain
        // static variables that are expected to be initialized to zero.
        // ******************************************************************
        addi	r6, r0, __sbss_start          	/* clear SBSS */
        addi	r7, r0, __sbss_end	
        rsub	r18, r6, r7		
        blei	r18, .Lendsbss
.Lloopsbss:
        swi	r0, r6, 0
        addi	r6, r6, 4
        rsub	r18, r6, r7
        bgti	r18, .Lloopsbss
.Lendsbss:
        addi	r6, r0, __bss_start             /* clear BSS */
        addi	r7, r0, __bss_end		
        rsub	r18, r6, r7		
        blei	r18, .Lendbss
.Lloopbss:
        swi r0, r6, 0
        addi r6, r6, 4
        rsub r18, r6, r7
        bgti r18, .Lloopbss
.Lendbss:

        // ******************************************************************
        // Call various initialization routines
        // ******************************************************************

        // Perform a soft reset on the hthreads hardware OS cores
        brlid r15, reset_hardware
        nop

        // Some Xilinx applications may put code (e.g. instrumentation
        // initialization) in _program_init.  Typically, _program_init
        // is simply a nop.  It is defined in the libxil.a library.
        brlid r15, _program_init
        nop

        // stdio_init is defined in the hthreads code to initialize
        // one or more UART devices.
        brlid r15, stdio_init
        nop

        // hthread_init continues the initialization process.
        brlid r15, hthread_init
        nop

        // CPU0 will return from hthread_init and call the main function.
        // CPU1 will perform a context switch to the idle directly from
        // hthread_init, and not execute this code.
        addi r5, r0, 0                  /* Initialize argc = 0 */
        addi r6, r0, 0                  /*     and argv = NULL */
        addi r7, r0, 0                  /*     and envp = NULL */
        brlid r15, main                 /* Execute the program */
        nop

        // _program_clean is the epilogue code corresponding to
        // _program_init, called above
        brlid r15, _program_clean
        nop
        
        bri done

_setup_slave_cpu:

        // Set the stack pointer to the stack allocated for CPU 1
        la r1, r0, __stack1-16
        
        // Poll a memory-mapped register in the system for a word written by
        // the master CPU (in the hthreads_init function) that indicates
        // system initialization is complete
        .ent waiting
waiting:
        lwi r3, r0, READY_REG
        xori r3, r3, CPU_0_READY
        beqi r3, waiting_over
        addi r3, r0, 1000
wait_loop:
        addi r3, r3, -1
        bnei r3, wait_loop
        bri waiting
waiting_over:
        .end waiting

        brlid r15, hthread_init
        nop

        .globl done
        .section .text
        .align 2
        .ent done
done:
        bri done
        .end done

