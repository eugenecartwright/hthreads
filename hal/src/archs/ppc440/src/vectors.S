/** \internal
  * \file       vectors.S
  * \brief      The implementation of the PowerPC exception handlers
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  * This file declares the low level exception handling routines for the PowerPC 405.
  * These functions push a interrupt stack frame which is of the form:
  *
  *    -----------------------
  *    |         r31         |
  *    |          .          |
  *    |          .          |
  *    |          .          |
  *    |         r2          |
  *    -----------------------
  *    |         r0          |
  *    -----------------------
  *    |       USPRG0        |
  *    -----------------------
  *    |         CR          |
  *    -----------------------
  *    |         XER         |
  *    -----------------------
  *    |         CTR         |
  *    -----------------------
  *    |         LR          |
  *    -----------------------
  *    |         PC          |
  *    -----------------------
  *    |         MSR         |
  *    -----------------------
  *    |       Next LR       |
  *    -----------------------
  *    |     Back Chain      |
  *    -----------------------
  */

    .file "vectors.S"
    .section ".hvectors","ax"

.macro PROLOGUE addr,mfpc,mfmsr
.org        _hvectors + \addr
.global     _hvector\addr

_hvector\addr:
    /*
        Added by Jason to to set IS/DS for PPC440:

        Upon an exception (i.e. system call) the MSR register bits for IS and DS are set to 0.
        This causes all data accesses to use the TS=0 TLB entries which can cause data/instructions
        to be incorrectly cached.  To fix this, one must revert the IS and DS bits in the MSR to the
        correct value as soon as an exception vector is reached.

        The process of setting the MSR requires a mfmsr/mtmsr combo which necessarily clobbers a
        user-level register, therefore this register must be temporarily saved in a safe place.
        Currently, Special Purpose General Register 5 is used, as this register is not in use in
        any other place within hthreads. 
    */
    mtsprg5     0           // Save r0 to SPR5

    mfmsr       0 
    ori         0,0,0x10    // Set correct IS/DS bits within MSR
    mtmsr       0

    mfsprg5     0       // Restore r0 from SPR5, and continue with normal processing

    stwu        1, -160(1)
    stw         0, 36(1)
    stmw        2, 40(1)

    mfusprg0    0
    stw         0, 32(1)

    mfcr        0
    stw         0, 28(1)

    mfxer       0
    stw         0, 24(1)

    mfctr       0
    stw         0, 20(1)

    mflr        0
    stw         0, 16(1)

    \mfpc       0
    stw         0, 12(1)

    \mfmsr      0
    stw         0, 8(1)
.endm

.macro  EPILOGUE addr,mtpc,mtmsr
    lwz         0, 8(1)
    \mtmsr      0

    lwz         0, 12(1)
    \mtpc       0

    lwz         0, 16(1)
    mtlr        0

    lwz         0, 20(1)
    mtctr       0

    lwz         0, 24(1)
    mtxer       0

    lwz         0, 28(1)
    mtcr        0

    lwz         0, 32(1)
    mtusprg0    0

    lmw         2, 40(1)
    lwz         0, 36(1)
    addi        1, 1, 160
.endm

.macro  SYSCALL_EPILOGUE addr,mtpc,mtmsr
    lwz         0, 8(1)
    \mtmsr      0

    lwz         0, 12(1)
    \mtpc       0

    lwz         0, 16(1)
    mtlr        0

    lwz         0, 20(1)
    mtctr       0

    lwz         0, 24(1)
    mtxer       0

    lwz         0, 28(1)
    mtcr        0

    lwz         0, 32(1)
    mtusprg0    0

    lwz         2, 40(1)
    lmw         4, 48(1)
    lwz         0, 36(1)
    addi        1, 1, 160
.endm

.macro CRITICAL addr,func
    PROLOGUE \addr, mfsrr2, mfsrr3

    lis         9, \func@ha
    addi        0, 9, \func@l
    mtlr        0
    blrl

    EPILOGUE \addr, mtsrr2, mtsrr3
    rfci
.endm

.macro NONCRITICAL addr,func
    PROLOGUE \addr, mfsrr0, mfsrr1

    lis         9, \func@ha
    addi        0, 9, \func@l
    mtlr        0
    blrl

    EPILOGUE \addr, mtsrr0, mtsrr1
    rfi
.endm

.macro SYSCALL addr,func
    PROLOGUE \addr, mfsrr0, mfsrr1

    lis         9, \func@ha
    addi        0, 9, \func@l
    mtlr        0
    blrl

    SYSCALL_EPILOGUE \addr, mtsrr0, mtsrr1
    rfi
.endm

    .global _hvectors
_hvectors:

// Jump to Zero Exception
CRITICAL 0x0000, _exception_jump_zero

// External Critical Interrupt
CRITICAL 0x0100, _exception_critical

// Machine Check Exception
CRITICAL 0x0200, _exception_machine_check

// Data Storage Exception
NONCRITICAL 0x0300, _exception_data_storage

// Instruction Storage Exception
NONCRITICAL 0x0400, _exception_instr_storage

// External Non-Critical Interrupt
NONCRITICAL 0x0500, _exception_noncritical

// Alignment Exception
NONCRITICAL 0x0600, _exception_alignment

// Program Exception
NONCRITICAL 0x0700, _exception_program

// FPU Unavailable Exception
NONCRITICAL 0x0800, _exception_fpu

// System Call Exception
SYSCALL 0x0C00, _system_call_handler

// APU Unavailable Exception
NONCRITICAL 0x0F20, _exception_apu

// Programmable Interval Timer Exception
.org _hvectors + 0x1000
    b _hvector0x1300

// Reroute Fixed Interval Timer
.org _hvectors + 0x1010
    b _hvector0x1400

// Watch Dog Timer Exception
CRITICAL 0x1020, _exception_watchdog

// Data TLB Miss Exception
NONCRITICAL 0x1100, _exception_data_tlb_miss

// Instruction TLB Exception
NONCRITICAL 0x1200, _exception_instr_tlb_miss

// Programmable Interval Timer Exception
NONCRITICAL 0x1300, _exception_pit

// Fixed Interval Timer Exception
NONCRITICAL 0x1400, _exception_fit

// Debug Exception
CRITICAL 0x2000, _exception_debug
