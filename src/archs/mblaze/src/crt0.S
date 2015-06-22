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

        // Initialize Thread Handle Table as early as possible to avoid
        // incurring this overhead when scheduling the first thread.
        #ifdef HETERO_COMPILATION
        brlid r15, load_my_table
        nop
        #endif

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

        .globl done
        .section .text
        .align 2
        .ent done
done:
        bri done
        .end done

