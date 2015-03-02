/* $Id: xio_dcr.c,v 1.1.2.2 2008/04/17 17:47:25 moleres Exp $ */
/******************************************************************************
*
*       XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"
*       AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND
*       SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,
*       OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,
*       APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION
*       THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,
*       AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE
*       FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY
*       WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE
*       IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR
*       REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF
*       INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
*       FOR A PARTICULAR PURPOSE.
*
*       (c) Copyright 2007-2008 Xilinx Inc.
*       All rights reserved.
*
******************************************************************************/
/*****************************************************************************/
/**
*
* @file xio_dcr.c
*
* The implementation of the XDcrIo interface. See xio_dcr.h for more
* information about the component.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- -----------------------------------------------
* 1.00a ecm  10/18/07 initial release
* </pre>
*
* @internal
*
* The C functions which subsequently call into either the assembly code or into
* the provided table of functions are required since the registers assigned to
* the calling and return from functions are strictly defined in the ABI and that
* definition is used in the low-level functions directly. The use of macros is
* not recommended since the temporary registers in the ABI are defined but there
* is no way to force the compiler to use a specific register in a block of code.
*
*****************************************************************************/

/***************************** Include Files ********************************/

#include "xstatus.h"
#include "xbasic_types.h"
#include "xio.h"
#include "xio_dcr.h"

/************************** Constant Definitions ****************************/

/*
 * base address defines for each of the four possible DCR base
 * addresses a processor can have
 */
#define XDCR_0_BASEADDR 0x000
#define XDCR_1_BASEADDR 0x100
#define XDCR_2_BASEADDR 0x200
#define XDCR_3_BASEADDR 0x300


#define MAX_DCR_REGISTERS           4096
#define MAX_DCR_REGISTER            MAX_DCR_REGISTERS - 1
#define MIN_DCR_REGISTER            0

/**************************** Type Definitions ******************************/


/***************** Macros (Inline Functions) Definitions ********************/

/************************** Variable Definitions ****************************/


/************************** Function Prototypes *****************************/

/******************************************************************************/
/**
* Reads the APU UDI register at the specified APU address.
*
*
* @param    DcrBase is the base of the block of DCR registers
* @param    UDInum is the intended source APU register
*
* @return
*
* Contents of the specified APU register.
*
* @note
*
* C-style signature:
*    u32 XIo_DcrReadAPUUDIReg(u32 DcrRegister, u32 UDInum)
*
*   Since reading an APU UDI DCR requires a dummy write to the same DCR,
*   the target UDI number is required. In order to make this operation atomic,
*   interrupts are disabled before and enabled after the DCR accesses.
*   Because an APU UDI access involves two DCR accesses, the DCR bus must be
*   locked to ensure that another master doesn't access the APU UDI register
*   at the same time.
*   Care must be taken to not write a '1' to either timeout bit because
*   it will be cleared.
*   Steps:
*   - save old MSR
*   - disable interrupts by writing mask to MSR
*   - acquire lock; since the PPC440 supports timeout wait, it will wait until
*     it successfully acquires the DCR bus lock
*   - shift and mask the UDI number to its bit position of [22:25]
*   - add the DCR base address to the UDI number and perform the read
*   - release DCR bus lock
*   - restore MSR
*   - return value read
*
*******************************************************************************/
inline u32 XIo_DcrReadAPUUDIReg(u32 DcrBase, u32 UDInum)
{
    u32 rVal;
    u32 oldMSR = mfmsr();
    mtmsr(oldMSR & XDCR_DISABLE_EXCEPTIONS);
    XIo_DcrLock(DcrBase);

    switch (DcrBase) {
    case XDCR_0_BASEADDR:
        mtdcr(XDCR_0_BASEADDR | XDCR_APU_UDI, (((UDInum) << 6) & 0x000003c0) | 0x00000030);
        rVal = mfdcr(XDCR_0_BASEADDR | XDCR_APU_UDI);
        break;
    case XDCR_1_BASEADDR:
        mtdcr(XDCR_1_BASEADDR | XDCR_APU_UDI, (((UDInum) << 6) & 0x000003c0) | 0x00000030);
        rVal = mfdcr(XDCR_1_BASEADDR | XDCR_APU_UDI);
        break;
    case XDCR_2_BASEADDR:
        mtdcr(XDCR_2_BASEADDR | XDCR_APU_UDI, (((UDInum) << 6) & 0x000003c0) | 0x00000030);
        rVal = mfdcr(XDCR_2_BASEADDR | XDCR_APU_UDI);
        break;
    case XDCR_3_BASEADDR:
        mtdcr(XDCR_3_BASEADDR | XDCR_APU_UDI, (((UDInum) << 6) & 0x000003c0) | 0x00000030);
        rVal = mfdcr(XDCR_3_BASEADDR | XDCR_APU_UDI);
        break;
    default:
        mtdcr(XDCR_0_BASEADDR | XDCR_APU_UDI, (((UDInum) << 6) & 0x000003c0) | 0x00000030);
        rVal = mfdcr(XDCR_0_BASEADDR | XDCR_APU_UDI);
        break;
    }

    XIo_DcrUnlock(DcrBase);
    mtmsr(oldMSR);
    return (rVal);
}

/******************************************************************************/
/**
* Writes the data to the APU UDI register at the specified APU address.
*
*
* @param    DcrBase is the base of the block of DCR registers
* @param    UDInum is the intended source APU register
* @param    Data is the value to be placed into the specified APU register
*
* @return
*
* None
*
* @note
*
* C-style signature:
*   void XIo_DcrWriteAPUUDIReg(u32 DcrRegister, u32 UDInum, u32 Data)
*
*   Since writing an APU UDI DCR requires a dummy write to the same DCR,
*   the target UDI number is required. In order to make this operation atomic,
*   interrupts are disabled before and enabled after the DCR accesses.
*   Because an APU UDI access involves two DCR accesses, the DCR bus must be
*   locked to ensure that another master doesn't access the APU UDI register
*   at the same time.
*   Care must be taken to not write a '1' to either timeout bit because
*   it will be cleared.
*   Steps:
*   - save old MSR
*   - disable interrupts by writing mask to MSR
*   - acquire lock, since the PPC440 supports timeout wait, it will wait until
*     it successfully acquires the DCR bus lock
*   - shift and mask the UDI number to its bit position of [22:25]
*   - add DCR base address to UDI number offset and perform the write
*   - release DCR bus lock
*   - restore MSR
*
*******************************************************************************/
inline void XIo_DcrWriteAPUUDIReg(u32 DcrBase, u32 UDInum, u32 Data)
{
    u32 oldMSR = mfmsr();
    mtmsr(oldMSR & XDCR_DISABLE_EXCEPTIONS);
    XIo_DcrLock(DcrBase);

    switch (DcrBase) {
    case XDCR_0_BASEADDR:
        mtdcr(XDCR_0_BASEADDR | XDCR_APU_UDI, (((UDInum) << 6) & 0x000003c0) | 0x00000030);
        mtdcr(XDCR_0_BASEADDR | XDCR_APU_UDI, (Data));
        break;
    case XDCR_1_BASEADDR:
        mtdcr(XDCR_1_BASEADDR | XDCR_APU_UDI, (((UDInum) << 6) & 0x000003c0) | 0x00000030);
        mtdcr(XDCR_1_BASEADDR | XDCR_APU_UDI, (Data));
        break;
    case XDCR_2_BASEADDR:
        mtdcr(XDCR_2_BASEADDR | XDCR_APU_UDI, (((UDInum) << 6) & 0x000003c0) | 0x00000030);
        mtdcr(XDCR_2_BASEADDR | XDCR_APU_UDI, (Data));
        break;
    case XDCR_3_BASEADDR:
        mtdcr(XDCR_3_BASEADDR | XDCR_APU_UDI, (((UDInum) << 6) & 0x000003c0) | 0x00000030);
        mtdcr(XDCR_3_BASEADDR | XDCR_APU_UDI, (Data));
        break;
    default:
        mtdcr(XDCR_0_BASEADDR | XDCR_APU_UDI, (((UDInum) << 6) & 0x000003c0) | 0x00000030);
        mtdcr(XDCR_0_BASEADDR | XDCR_APU_UDI, (Data));
        break;
    }

    XIo_DcrUnlock(DcrBase);
    mtmsr(oldMSR);
}

/*****************************************************************************/
/**
*
* Reads the APU UDI register at the specified DCR address using the indirect
* addressing method.
*
*
* @param    DcrBase is the base of the block of DCR registers
* @param    UDInum is the intended source DCR register
*
* @return
*
* Contents of the specified APU register.
*
* @note
*
* C-style signature:
*   void XIo_DcrReadAPUIDAUDIReg(u32 DcrBase, u32 UDInum)
*
*   An indirect APU UDI read requires three DCR accesses:
*     1) Indirect address reg write
*     2) Indirect access reg write to specify the UDI number
*     3) Indirect access reg read of the actual data
*   Since (2) unlocks the DCR bus, the DCR bus must be explicitly locked
*   instead of relying on the auto-lock feature.
*   In order to make this operation atomic, interrupts are disabled before
*   and enabled after the DCR accesses.
*   Care must be taken to not write a '1' to either timeout bit because
*   it will be cleared.
*
****************************************************************************/
inline u32 XIo_DcrReadAPUIDAUDIReg(u32 DcrBase, u32 UDInum)
{
    u32 rVal;
    u32 oldMSR = mfmsr();
    mtmsr(oldMSR & XDCR_DISABLE_EXCEPTIONS);
    XIo_DcrLock(DcrBase);

    switch(DcrBase) {
    case XDCR_0_BASEADDR:
        XIo_mDcrWriteReg(XDCR_0_BASEADDR | XDCR_IDA_ADDR, XDCR_0_BASEADDR | XDCR_APU_UDI);
        XIo_mDcrWriteReg(XDCR_0_BASEADDR | XDCR_IDA_ACC, ((UDInum << 6) & 0x000003c0) | 0x00000030);
        rVal = XIo_mDcrReadReg(XDCR_0_BASEADDR | XDCR_IDA_ACC);
        break;
    case XDCR_1_BASEADDR:
        XIo_mDcrWriteReg(XDCR_1_BASEADDR | XDCR_IDA_ADDR, XDCR_1_BASEADDR | XDCR_APU_UDI);
        XIo_mDcrWriteReg(XDCR_1_BASEADDR | XDCR_IDA_ACC, ((UDInum << 6) & 0x000003c0) | 0x00000030);
        rVal = XIo_mDcrReadReg(XDCR_1_BASEADDR | XDCR_IDA_ACC);
        break;
    case XDCR_2_BASEADDR:
        XIo_mDcrWriteReg(XDCR_2_BASEADDR | XDCR_IDA_ADDR, XDCR_2_BASEADDR | XDCR_APU_UDI);
        XIo_mDcrWriteReg(XDCR_2_BASEADDR | XDCR_IDA_ACC, ((UDInum << 6) & 0x000003c0) | 0x00000030);
        rVal = XIo_mDcrReadReg(XDCR_2_BASEADDR | XDCR_IDA_ACC);
        break;
    case XDCR_3_BASEADDR:
        XIo_mDcrWriteReg(XDCR_3_BASEADDR | XDCR_IDA_ADDR, XDCR_3_BASEADDR | XDCR_APU_UDI);
        XIo_mDcrWriteReg(XDCR_3_BASEADDR | XDCR_IDA_ACC, ((UDInum << 6) & 0x000003c0) | 0x00000030);
        rVal = XIo_mDcrReadReg(XDCR_3_BASEADDR | XDCR_IDA_ACC);
        break;
    default:
        XIo_mDcrWriteReg(XDCR_0_BASEADDR | XDCR_IDA_ADDR, XDCR_0_BASEADDR | XDCR_APU_UDI);
        XIo_mDcrWriteReg(XDCR_0_BASEADDR | XDCR_IDA_ACC, ((UDInum << 6) & 0x000003c0) | 0x00000030);
        rVal = XIo_mDcrReadReg(XDCR_0_BASEADDR | XDCR_IDA_ACC);
        break;
    }

    XIo_DcrUnlock(DcrBase);
    mtmsr(oldMSR);
    return (rVal);
}

/*****************************************************************************/
/**
*
* Writes the value to the APU UDI DCR using the indirect access method.
*
* @param    DcrBase is the base of the block of DCR registers
* @param    UDInum is the intended destination APU register
* @param    Data is the value to be placed into the specified APU register
*
* @return
*
* None
*
* @note
*
* C-style signature:
*   void XIo_DcrWriteAPUIDAUDIReg(u32 DcrBase, u32 UDInum, u32 Data)
*
*   An indirect APU UDI write requires three DCR accesses:
*     1) Indirect address reg write
*     2) Indirect access reg write to specify the UDI number
*     3) Indirect access reg write of the actual data
*   Since (2) unlocks the DCR bus, the DCR bus must be explicitly locked
*   instead of relying on the auto-lock feature.
*   In order to make this operation atomic, interrupts are disabled before
*   and enabled after the DCR accesses.
*   Care must be taken to not write a '1' to either timeout bit because
*   it will be cleared.
*
****************************************************************************/
inline void XIo_DcrWriteAPUIDAUDIReg(u32 DcrBase, u32 UDInum, u32 Data)
{
    u32 oldMSR = mfmsr();
    mtmsr(oldMSR & XDCR_DISABLE_EXCEPTIONS);
    XIo_DcrLock(DcrBase);

    switch (DcrBase) {
    case XDCR_0_BASEADDR:
        XIo_mDcrWriteReg(XDCR_0_BASEADDR | XDCR_IDA_ADDR, XDCR_0_BASEADDR | XDCR_APU_UDI);
        XIo_mDcrWriteReg(XDCR_0_BASEADDR | XDCR_IDA_ACC, ((UDInum << 6) & 0x000003c0) | 0x00000030);
        XIo_mDcrWriteReg(XDCR_0_BASEADDR | XDCR_IDA_ACC, Data);
        break;
    case XDCR_1_BASEADDR:
        XIo_mDcrWriteReg(XDCR_1_BASEADDR | XDCR_IDA_ADDR, XDCR_1_BASEADDR | XDCR_APU_UDI);
        XIo_mDcrWriteReg(XDCR_1_BASEADDR | XDCR_IDA_ACC, ((UDInum << 6) & 0x000003c0) | 0x00000030);
        XIo_mDcrWriteReg(XDCR_1_BASEADDR | XDCR_IDA_ACC, Data);
        break;
    case XDCR_2_BASEADDR:
        XIo_mDcrWriteReg(XDCR_2_BASEADDR | XDCR_IDA_ADDR, XDCR_2_BASEADDR | XDCR_APU_UDI);
        XIo_mDcrWriteReg(XDCR_2_BASEADDR | XDCR_IDA_ACC, ((UDInum << 6) & 0x000003c0) | 0x00000030);
        XIo_mDcrWriteReg(XDCR_2_BASEADDR | XDCR_IDA_ACC, Data);
        break;
    case XDCR_3_BASEADDR:
        XIo_mDcrWriteReg(XDCR_3_BASEADDR | XDCR_IDA_ADDR, XDCR_3_BASEADDR | XDCR_APU_UDI);
        XIo_mDcrWriteReg(XDCR_3_BASEADDR | XDCR_IDA_ACC, ((UDInum << 6) & 0x000003c0) | 0x00000030);
        XIo_mDcrWriteReg(XDCR_3_BASEADDR | XDCR_IDA_ACC, Data);
        break;
    default:
        XIo_mDcrWriteReg(XDCR_0_BASEADDR | XDCR_IDA_ADDR, XDCR_0_BASEADDR | XDCR_APU_UDI);
        XIo_mDcrWriteReg(XDCR_0_BASEADDR | XDCR_IDA_ACC, ((UDInum << 6) & 0x000003c0) | 0x00000030);
        XIo_mDcrWriteReg(XDCR_0_BASEADDR | XDCR_IDA_ACC, Data);
        break;
    }

    XIo_DcrUnlock(DcrBase);
    mtmsr(oldMSR);
    return;
}

/*****************************************************************************/
/**
* Reads the register at the specified DCR address using the indirect addressing
* method.
*
*
* @param    DcrBase is the base of the block of DCR registers
* @param    DcrRegister is the intended source DCR register
*
* @return
*
* Contents of the specified DCR register.
*
* @note
*
* C-style signature:
*   void XIo_DcrIndirectAddrReadReg(u32 DcrBase, u32 DcrRegister, u32 *rVal)
*
*   Assumes auto-buslocking feature is ON.
*   In order to make this operation atomic, interrupts are disabled before
*   and enabled after the DCR accesses.
*
******************************************************************************/
inline void XIo_DcrIndirectAddrReadReg(u32 DcrBase, u32 DcrRegister, u32 *rVal)
{
    unsigned int oldMSR = mfmsr();
    mtmsr(oldMSR & XDCR_DISABLE_EXCEPTIONS);

    switch (DcrBase) {
    case XDCR_0_BASEADDR:
        XIo_mDcrWriteReg(XDCR_0_BASEADDR | XDCR_IDA_ADDR, XDCR_0_BASEADDR | DcrRegister);
        *rVal = XIo_mDcrReadReg(XDCR_0_BASEADDR | XDCR_IDA_ACC);
        break;
    case XDCR_1_BASEADDR:
        XIo_mDcrWriteReg(XDCR_1_BASEADDR | XDCR_IDA_ADDR, XDCR_1_BASEADDR | DcrRegister);
        *rVal = XIo_mDcrReadReg(XDCR_1_BASEADDR | XDCR_IDA_ACC);
        break;
    case XDCR_2_BASEADDR:
        XIo_mDcrWriteReg(XDCR_2_BASEADDR | XDCR_IDA_ADDR, XDCR_2_BASEADDR | DcrRegister);
        *rVal = XIo_mDcrReadReg(XDCR_2_BASEADDR | XDCR_IDA_ACC);
        break;
    case XDCR_3_BASEADDR:
        XIo_mDcrWriteReg(XDCR_3_BASEADDR | XDCR_IDA_ADDR, XDCR_3_BASEADDR | DcrRegister);
        *rVal = XIo_mDcrReadReg(XDCR_3_BASEADDR | XDCR_IDA_ACC);
        break;
    default:
        XIo_mDcrWriteReg(XDCR_0_BASEADDR | XDCR_IDA_ADDR, XDCR_0_BASEADDR | DcrRegister);
        *rVal = XIo_mDcrReadReg(XDCR_0_BASEADDR | XDCR_IDA_ACC);
        break;
    }

    mtmsr(oldMSR);
    return;
}

/*****************************************************************************/
/**
* Writes the register at specified DCR address using the indirect addressing
* method.
*
*
* @param    DcrBase is the base of the block of DCR registers
* @param    DcrRegister is the intended destination DCR register
* @param    Data is the value to be placed into the specified DRC register
*
* @return
*
* None
*
* @note
*
* C-style signature:
*   void XIo_DcrIndirectAddrWriteReg(u32 DcrBase, u32 DcrRegister,
*                                  u32 Data)
*
*   Assumes auto-buslocking feature is ON.
*   In order to make this operation atomic, interrupts are disabled before
*   and enabled after the DCR accesses.
*
******************************************************************************/
inline void XIo_DcrIndirectAddrWriteReg(u32 DcrBase, u32 DcrRegister, u32 Data)
{
    unsigned int oldMSR = mfmsr();
    mtmsr(oldMSR & XDCR_DISABLE_EXCEPTIONS);

    switch (DcrBase)
    {
    case XDCR_0_BASEADDR:
        XIo_mDcrWriteReg(XDCR_0_BASEADDR | XDCR_IDA_ADDR, XDCR_0_BASEADDR | DcrRegister);
        XIo_mDcrWriteReg(XDCR_0_BASEADDR | XDCR_IDA_ACC, Data);
        break;
    case XDCR_1_BASEADDR:
        XIo_mDcrWriteReg(XDCR_1_BASEADDR | XDCR_IDA_ADDR, XDCR_1_BASEADDR | DcrRegister);
        XIo_mDcrWriteReg(XDCR_1_BASEADDR | XDCR_IDA_ACC, Data);
        break;
    case XDCR_2_BASEADDR:
        XIo_mDcrWriteReg(XDCR_2_BASEADDR | XDCR_IDA_ADDR, XDCR_2_BASEADDR | DcrRegister);
        XIo_mDcrWriteReg(XDCR_2_BASEADDR | XDCR_IDA_ACC, Data);
        break;
    case XDCR_3_BASEADDR:
        XIo_mDcrWriteReg(XDCR_3_BASEADDR | XDCR_IDA_ADDR, XDCR_3_BASEADDR | DcrRegister);
        XIo_mDcrWriteReg(XDCR_3_BASEADDR | XDCR_IDA_ACC, Data);
        break;
    default:
        XIo_mDcrWriteReg(XDCR_0_BASEADDR | XDCR_IDA_ADDR, XDCR_0_BASEADDR | DcrRegister);
        XIo_mDcrWriteReg(XDCR_0_BASEADDR | XDCR_IDA_ACC, Data);
        break;
    }
    mtmsr(oldMSR);
    return;
}

/*****************************************************************************/
/**
*
* Outputs value provided to specified register defined in the header file.
*
* @param    DcrRegister is the intended destination DCR register
* @param    Data is the value to be placed into the specified DCR register
*
* @return
*
* None.
*
* @note
*
* None.
*
****************************************************************************/
void XIo_DcrOut(u32 DcrRegister, u32 Data)
{
    /*
     * Assert validates the register number
     */
    XASSERT_VOID(DcrRegister < MAX_DCR_REGISTERS);

    /*
     * pass the call on to the proper function
     */
    XIo_DcrIndirectAddrWriteReg(XDCR_0_BASEADDR, DcrRegister, Data);
}

/*****************************************************************************/
/**
*
* Reads value from specified register.
*
* @param    DcrRegister is the intended source DCR register
*
* @return
*
* Contents of the specified DCR register.
*
* @note
*
* None.
*
****************************************************************************/
u32 XIo_DcrIn(u32 DcrRegister)
{
    u32 rVal;
    /*
     * Assert validates the register number
     */
    XASSERT_NONVOID(DcrRegister < MAX_DCR_REGISTERS);

    /*
     * pass the call on to the proper function
     */
    XIo_DcrIndirectAddrReadReg(XDCR_0_BASEADDR, DcrRegister, &rVal);

    return (rVal);
}

/*****************************************************************************/
/**
*
* Reads the value of the specified register using the indirect access method.
*
* @param    DcrBase is the base of the block of DCR registers
* @param    DcrRegister is the intended destination DCR register
*
* @return
*
* Contents of the specified DCR register.
*
* @note
*
* Uses the indirect addressing method available in V5 with PPC440.
*
****************************************************************************/
u32 XIo_DcrReadReg(u32 DcrBase, u32 DcrRegister)
{
    u32 rVal;

    XIo_DcrIndirectAddrReadReg(DcrBase, DcrRegister, &rVal);

    return (rVal);
}

/*****************************************************************************/
/**
*
* Explicitly acquires and release DCR lock--Auto-Lock is disabled.
* Reads the value of the specified register using the indirect access method.
* This function is provided because the most common usecase is to enable
* Auto-Lock. Checking for Auto-Lock in every indirect access would defeat the
* purpose of having Auto-Lock.
* Auto-Lock can only be enable/disabled in hardware.
*
* @param    DcrBase is the base of the block of DCR registers
* @param    DcrRegister is the intended destination DCR register
*
* @return
*
* Contents of the specified DCR register.
*
* @note
*
* Uses the indirect addressing method available in V5 with PPC440.
*
****************************************************************************/
u32 XIo_DcrLockAndReadReg(u32 DcrBase, u32 DcrRegister)
{
    u32 rVal;

    XIo_DcrLock(DcrBase);
    XIo_DcrIndirectAddrReadReg(DcrBase, DcrRegister, &rVal);
    XIo_DcrUnlock(DcrBase);

    return (rVal);
}

/*****************************************************************************/
/**
*
* Explicitly acquires and release DCR lock--Auto-Lock is disabled.
* Writes the value to the specified register using the indirect access method.
* This function is provided because the most common usecase is to enable
* Auto-Lock. Checking for Auto-Lock in every indirect access would defeat the
* purpose of having Auto-Lock.
* Auto-Lock can only be enable/disabled in hardware.
*
* @param    DcrBase is the base of the block of DCR registers
* @param    DcrRegister is the intended destination DCR register
* @param    Data is the value to be placed into the specified DCR register
*
* @return
*
* None
*
* @note
*
* Uses the indirect addressing method available in V5 with PPC440.
*
****************************************************************************/
void XIo_DcrLockAndWriteReg(u32 DcrBase, u32 DcrRegister, u32 Data)
{
    XIo_DcrLock(DcrBase);
    XIo_DcrIndirectAddrWriteReg(DcrBase, DcrRegister, Data);
    XIo_DcrUnlock(DcrBase);
    return;
}

/*****************************************************************************/
/**
*
* Locks DCR bus via the Global Status/Control register.
*
* @param    DcrBase is the base of the block of DCR registers
*
* @return
*
* None
*
* @note
*
* Care must be taken to not write a '1' to either timeout bit because
* it will be cleared. The internal PPC440 can clear both timeout bits but an
* external DCR master can only clear the external DCR master's timeout bit.
*
* Only available in V5 with PPC440.
*
****************************************************************************/
void XIo_DcrLock(u32 DcrBase)
{
    switch (DcrBase) {
    case XDCR_0_BASEADDR:
        XIo_mDcrLock(XDCR_0_BASEADDR);
        return;
    case XDCR_1_BASEADDR:
        XIo_mDcrLock(XDCR_1_BASEADDR);
        return;
    case XDCR_2_BASEADDR:
        XIo_mDcrLock(XDCR_2_BASEADDR);
        return;
    case XDCR_3_BASEADDR:
        XIo_mDcrLock(XDCR_3_BASEADDR);
        return;
    default:
        XIo_mDcrLock(XDCR_0_BASEADDR);
        return;
    }
}

/*****************************************************************************/
/**
*
* Unlocks DCR bus via the Global Status/Control register.
*
* @param    DcrBase is the base of the block of DCR registers
*
* @return
*
* None
*
* @note
*
* Care must be taken to not write a '1' to either timeout bit because
* it will be cleared. The internal PPC440 can clear both timeout bits but an
* external DCR master can only clear the external DCR master's timeout bit.
*
* Only available in V5 with PPC440.
*
****************************************************************************/
void XIo_DcrUnlock(u32 DcrBase)
{
    switch (DcrBase) {
    case XDCR_0_BASEADDR:
        XIo_mDcrUnlock(XDCR_0_BASEADDR);
        return;
    case XDCR_1_BASEADDR:
        XIo_mDcrUnlock(XDCR_1_BASEADDR);
        return;
    case XDCR_2_BASEADDR:
        XIo_mDcrUnlock(XDCR_2_BASEADDR);
        return;
    case XDCR_3_BASEADDR:
        XIo_mDcrUnlock(XDCR_3_BASEADDR);
        return;
    default:
        XIo_mDcrUnlock(XDCR_0_BASEADDR);
        return;
    }
}
