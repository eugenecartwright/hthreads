/** \internal
  * \file       syscall.S
  * 
  * \author     Seth Warn <swarn@uark.edu>\n
  *
  * System calls (e.g., hthread_create) utilize the "user vector" (a.k.a.
  * "software exceptions") mechanism to leave user mode and execute OS code.
  * The code in this file handles user vector execution, as well as a
  * routine to return to user mode.
  */


/**
 * When users invoke systems calls like hthread_create, these are
 * translated (see src/software/system/syscall.c) into calls to do_syscall.
 * These calls have between one and six arguments, which the compiler will
 * place in r5 through r10.  All we need to do is leave those arguments in
 * place and cause a "user exception" by branching to a special memory
 * location (0x8).  This location (see src/archs/mblaze/src/crt0.S) simply
 * branches to the hthreads system call handler.  Any return value (in r3)
 * is also left in place for the caller.
 */
        .section .text
        .global do_syscall
        .align 2
        .ent do_syscall
do_syscall:
        /* save the return address */
        addik r1, r1, -4
        swi r15, r1, 0

        /* disable interrupts */
        bralid r15, microblaze_disable_interrupts
        nop

        /* user vector exception */
        bralid r15, 0x8
        nop

        /* enable interrupts */
        bralid r15, microblaze_enable_interrupts
        nop

        /* enter user mode */
        bralid r15, _mb_enter_user_mode
        nop

        /* restore return address and sp, then return */
        lwi r15, r1, 0
        rtsd r15, 8
        addik r1, r1, 4

        .end do_syscall


/**
 * Enter user mode by setting the UM bit of the MSR
 */
        .section .text
        .global _mb_enter_user_mode
        .align 2
        .ent _mb_enter_user_mode
_mb_enter_user_mode:
        /* save r12 on the stack */
        addik r1, r1, -4
        swi r12, r1, 0

        /* read the msr, set the user mode bit, write the msr */
        mfs r12, rmsr
        ori r12, r12, 0x800
        mts rmsr, r12

        /* restore r12 and return, updating SP in the delay slot */
        lwi r12, r1, 0
        rtsd r15, 8
        addik r1, r1, 4

        .end _mb_enter_user_mode

