/************************************************************************************
* Copyright (c) 2015, University of Arkansas - Hybridthreads Group
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
*     * Neither the name of the University of Arkansas nor the name of the
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
  * \file       exception.c
  * \brief      The implementaion of all exception handlers
  *				(except for syscall).
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  *
  * This file contains the implementation of all of the exception handlers
  * with the exception of the system call handler which can be found in the
  * file syscall.c.
  */
#include <debug.h>
#include <hthread.h>
#include <manager/manager.h>
#include <sys/exception.h>
#include <sys/core.h>
#include <scheduler/hardware.h>
#include <arch/memory.h>
//#include <sys/synch.h>

#ifdef HTHREADS_SMP
Huint cpu_to_pic[2] = NONCRIT_PIC_BASEADDRS;
#endif

#ifdef HTHREADS_DEBUG
    #include <arch/context.h>

    #define DEBUG_DUMP()        dumpContext()
    void showException()
    {
        Huint esr;
        esr = mfesr();

        DEBUG_PRINTF( "\nException Syndrome Decoding = 0x%08x\n",esr );
        DEBUG_PRINTF( "--------------------------------------------------\n" );
        if( esr & ESR_MCI ) DEBUG_PRINTF( "Machine Check\n" );
        if( esr & ESR_PIL ) DEBUG_PRINTF( "Illegal Instruction\n" );
        if( esr & ESR_PPR ) DEBUG_PRINTF( "Priviledged Instruction\n" );
        if( esr & ESR_PTR ) DEBUG_PRINTF( "Trap Instruction\n" );
        if( esr & ESR_PEU ) DEBUG_PRINTF( "Unimplemented Instruction\n" );
        if( esr & ESR_DST ) DEBUG_PRINTF( "Store Instruction\n" );
        if( esr & ESR_DIZ ) DEBUG_PRINTF( "Zone Protection Violation\n" );
        if( esr & ESR_PFP ) DEBUG_PRINTF( "Floating Point Instruction\n" );
        if( esr & ESR_PAP ) DEBUG_PRINTF( "Auxiliary Processor Instruction\n" );
        if( esr & ESR_U0F ) DEBUG_PRINTF( "U0 Protection Violation\n" );
        DEBUG_PRINTF( "\n" );
    }

	void dumpContext()
	{
        Huint r[32];

        r[0]=mfgpr(0);   r[1]=mfgpr(1);   r[2]=mfgpr(2);   r[3]=mfgpr(3);
        r[4]=mfgpr(4);   r[5]=mfgpr(5);   r[6]=mfgpr(6);   r[7]=mfgpr(7);
        r[8]=mfgpr(8);   r[9]=mfgpr(9);   r[10]=mfgpr(10); r[11]=mfgpr(11);
        r[12]=mfgpr(12); r[13]=mfgpr(13); r[14]=mfgpr(14); r[15]=mfgpr(15);
        r[16]=mfgpr(16); r[17]=mfgpr(17); r[18]=mfgpr(18); r[19]=mfgpr(19);
        r[20]=mfgpr(20); r[21]=mfgpr(21); r[22]=mfgpr(22); r[23]=mfgpr(23);
        r[24]=mfgpr(24); r[25]=mfgpr(25); r[26]=mfgpr(26); r[27]=mfgpr(27);
        r[28]=mfgpr(28); r[29]=mfgpr(29); r[30]=mfgpr(30); r[31]=mfgpr(31);

        DEBUG_PRINTF( "\nGeneral Purpose Registers\n" );
        DEBUG_PRINTF( "--------------------------------------------------\n" );
        DEBUG_PRINTF( "GP Register 0:          0x%08x\n", r[0] );
        DEBUG_PRINTF( "GP Register 1:          0x%08x\n", r[1] );
        DEBUG_PRINTF( "GP Register 2:          0x%08x\n", r[2] );
        DEBUG_PRINTF( "GP Register 3:          0x%08x\n", r[3] );
        DEBUG_PRINTF( "GP Register 4:          0x%08x\n", r[4] );
        DEBUG_PRINTF( "GP Register 5:          0x%08x\n", r[5] );
        DEBUG_PRINTF( "GP Register 6:          0x%08x\n", r[6] );
        DEBUG_PRINTF( "GP Register 7:          0x%08x\n", r[7] );
        DEBUG_PRINTF( "GP Register 8:          0x%08x\n", r[8] );
        DEBUG_PRINTF( "GP Register 9:          0x%08x\n", r[9] );
        DEBUG_PRINTF( "GP Register 10:         0x%08x\n", r[10] );
        DEBUG_PRINTF( "GP Register 11:         0x%08x\n", r[11] );
        DEBUG_PRINTF( "GP Register 12:         0x%08x\n", r[12] );
        DEBUG_PRINTF( "GP Register 13:         0x%08x\n", r[13] );
        DEBUG_PRINTF( "GP Register 14:         0x%08x\n", r[14] );
        DEBUG_PRINTF( "GP Register 15:         0x%08x\n", r[15] );
        DEBUG_PRINTF( "GP Register 16:         0x%08x\n", r[16] );
        DEBUG_PRINTF( "GP Register 17:         0x%08x\n", r[17] );
        DEBUG_PRINTF( "GP Register 18:         0x%08x\n", r[18] );
        DEBUG_PRINTF( "GP Register 19:         0x%08x\n", r[19] );
        DEBUG_PRINTF( "GP Register 20:         0x%08x\n", r[20] );
        DEBUG_PRINTF( "GP Register 21:         0x%08x\n", r[21] );
        DEBUG_PRINTF( "GP Register 22:         0x%08x\n", r[22] );
        DEBUG_PRINTF( "GP Register 23:         0x%08x\n", r[23] );
        DEBUG_PRINTF( "GP Register 24:         0x%08x\n", r[24] );
        DEBUG_PRINTF( "GP Register 25:         0x%08x\n", r[25] );
        DEBUG_PRINTF( "GP Register 26:         0x%08x\n", r[26] );
        DEBUG_PRINTF( "GP Register 27:         0x%08x\n", r[27] );
        DEBUG_PRINTF( "GP Register 28:         0x%08x\n", r[28] );
        DEBUG_PRINTF( "GP Register 29:         0x%08x\n", r[29] );
        DEBUG_PRINTF( "GP Register 30:         0x%08x\n", r[30] );
        DEBUG_PRINTF( "GP Register 31:         0x%08x\n", r[31] );

        DEBUG_PRINTF( "\nSpecial Purpose Registers\n" );
        DEBUG_PRINTF( "--------------------------------------------------\n" );
        DEBUG_PRINTF( "SP Register 0:          0x%08x\n", mfsprg0() );
        DEBUG_PRINTF( "SP Register 1:          0x%08x\n", mfsprg1() );
        DEBUG_PRINTF( "SP Register 2:          0x%08x\n", mfsprg2() );
        DEBUG_PRINTF( "SP Register 3:          0x%08x\n", mfsprg3() );
        DEBUG_PRINTF( "SP Register 4:          0x%08x\n", mfsprg4() );
        DEBUG_PRINTF( "SP Register 5:          0x%08x\n", mfsprg5() );
        DEBUG_PRINTF( "SP Register 6:          0x%08x\n", mfsprg6() );
        DEBUG_PRINTF( "SP Register 7:          0x%08x\n", mfsprg7() );

        DEBUG_PRINTF( "\nException Registers\n" );
        DEBUG_PRINTF( "--------------------------------------------------\n" );
        DEBUG_PRINTF( "FP Exception:           0x%08x\n", mfxer() );
        DEBUG_PRINTF( "Data Exc Address:       0x%08x\n", mfdear() );
        DEBUG_PRINTF( "Exc Syndrome:           0x%08x\n", mfesr() );
        DEBUG_PRINTF( "Exc Vector Prefix:      0x%08x\n", mfevpr() );

        DEBUG_PRINTF( "\nCache Registers\n" );
        DEBUG_PRINTF( "--------------------------------------------------\n" );
        DEBUG_PRINTF( "Data Cacheability:      0x%08x\n", mfdccr() );
        DEBUG_PRINTF( "Data Write Through:     0x%08x\n", mfdcwr() );
        DEBUG_PRINTF( "Instr Cacheability:     0x%08x\n", mficcr() );
        DEBUG_PRINTF( "Instr Debug Data:       0x%08x\n", mficdbdr() );

        DEBUG_PRINTF( "\nTimer Registers\n" );
        DEBUG_PRINTF( "--------------------------------------------------\n" );
        DEBUG_PRINTF( "Timer Control:          0x%08x\n", mftcr() );
        DEBUG_PRINTF( "Timer Status:           0x%08x\n", mftsr() );
        DEBUG_PRINTF( "Timer Base Lower:       0x%08x\n", mftbl() );
        DEBUG_PRINTF( "Timer Base Upper:       0x%08x\n", mftbu() );
        DEBUG_PRINTF( "Prog Interval:          0x%08x\n", mfpit() );

        DEBUG_PRINTF( "\nDebug Registers\n" );
        DEBUG_PRINTF( "--------------------------------------------------\n" );
        DEBUG_PRINTF( "Data Addr Cmp 0:        0x%08x\n", mfdac1() );
        DEBUG_PRINTF( "Data Addr Cmp 1:        0x%08x\n", mfdac2() );
        DEBUG_PRINTF( "Data Value Cmp 0:       0x%08x\n", mfdvc1() );
        DEBUG_PRINTF( "Data Value Cmp 1:       0x%08x\n", mfdvc2() );
        DEBUG_PRINTF( "Debug Control 0:        0x%08x\n", mfdbcr0() );
        DEBUG_PRINTF( "Debug Control 1:        0x%08x\n", mfdbcr1() );
        DEBUG_PRINTF( "Debug Status:           0x%08x\n", mfdbsr() );
        DEBUG_PRINTF( "Instr Addr Cmp 0:       0x%08x\n", mfiac1() );
        DEBUG_PRINTF( "Instr Addr Cmp 1:       0x%08x\n", mfiac2() );
        DEBUG_PRINTF( "Instr Addr Cmp 3:       0x%08x\n", mfiac3() );
        DEBUG_PRINTF( "Instr Addr Cmp 4:       0x%08x\n", mfiac4() );

        DEBUG_PRINTF( "\nOther Registers\n" );
        DEBUG_PRINTF( "--------------------------------------------------\n" );
        DEBUG_PRINTF( "Count Register:         0x%08x\n", mfctr() );
        DEBUG_PRINTF( "Link Register:          0x%08x\n", mflr() );
        DEBUG_PRINTF( "Process ID:             0x%08x\n", mfpid() );
        DEBUG_PRINTF( "Processor Version:      0x%08x\n", mfpvr() );
        DEBUG_PRINTF( "Condition:              0x%08x\n", mfcr() );
        DEBUG_PRINTF( "Machine State:          0x%08x\n", mfmsr() );
        DEBUG_PRINTF( "Core Configuration:     0x%08x\n", mfccr0() );
        DEBUG_PRINTF( "Storage Guarded:        0x%08x\n", mfsgr() );
        DEBUG_PRINTF( "Storage Endian:         0x%08x\n", mfsler() );
        DEBUG_PRINTF( "Save/Restore 0:         0x%08x\n", mfsrr0() );
        DEBUG_PRINTF( "Save/Restore 1:         0x%08x\n", mfsrr1() );
        DEBUG_PRINTF( "Save/Restore 2:         0x%08x\n", mfsrr2() );
        DEBUG_PRINTF( "Save/Restore 3:         0x%08x\n", mfsrr3() );
        DEBUG_PRINTF( "Strg User Defined:      0x%08x\n", mfsu0r() );
        DEBUG_PRINTF( "User SP Register:       0x%08x\n", mfusprg0() );
        DEBUG_PRINTF( "Zone Protection:        0x%08x\n", mfzpr() );

        showException();
	}
#else
	#define DEBUG_DUMP()
#endif

/**	\internal
  * \brief	The exception handler for the jump to zero exception.
  *
  */
void _exception_jump_zero( void *data )
{
	DEBUG_DUMP();
	
	TRACE_ALWAYS( "Jump To Zero Exception\n" );
	TRACE_ALWAYS( "--FAILURE--\n" );
	while(1);
}

/**	\internal
  * \brief	The exception handler for the machine check exception.
  *
  */
void _exception_machine_check( void *data )
{
	DEBUG_DUMP();
	
	TRACE_ALWAYS( "Machine Check Exception\n" );
	TRACE_ALWAYS( "--FAILURE--\n" );
	while(1);
}

/**	\internal
  * \brief	The exception handler for the data storage exception.
  *
  */
void _exception_data_storage( void *data )
{
	DEBUG_DUMP();
	
	TRACE_ALWAYS( "Data Storage Exception\n" );
	TRACE_ALWAYS( "--FAILURE--\n" );
	while(1);
}

/**	\internal
  * \brief	The exception handler for the instruction storage exception.
  *
  */
void _exception_instr_storage( void *data )
{
	DEBUG_DUMP();
	
	TRACE_ALWAYS( "Instruction Storage Exception\n" );
	TRACE_ALWAYS( "--FAILURE--\n" );
	while(1);
}

/**	\internal
  * \brief	The exception handler for the alignment exception.
  *
  */
void _exception_alignment( void *data )
{
	DEBUG_DUMP();
	
	TRACE_ALWAYS( "Alignment Exception\n" );
	TRACE_ALWAYS( "--FAILURE--\n" );
	while(1);
}

/**	\internal
  * \brief	The exception handler for the program exception.
  *
  */
void _exception_program( void *data )
{
	DEBUG_DUMP();
	
	TRACE_ALWAYS( "Program Exception\n" );
	TRACE_ALWAYS( "--FAILURE--\n" );
	while(1);
}

/**	\internal
  * \brief	The exception handler for the FPU unavailable exception.
  *
  */
void _exception_fpu( void *data )
{
	DEBUG_DUMP();
	
	TRACE_ALWAYS( "FPU Exception\n" );
	TRACE_ALWAYS( "--FAILURE--\n" );
	while(1);
}

/**	\internal
  * \brief	The exception handler for the APU available exception.
  *
  */
void _exception_apu( void *data )
{
	DEBUG_DUMP();
	
	TRACE_ALWAYS( "APU Exception\n" );
	TRACE_ALWAYS( "--FAILURE--\n" );
	while(1);
}

/**	\internal
  * \brief	The exception handler for the programmable interval timer exception.
  *
  */
void _exception_pit( void *data )
{
	DEBUG_DUMP();
	
	TRACE_ALWAYS( "PIT Exception\n" );
	TRACE_ALWAYS( "--FAILURE--\n" );
	while(1);
}

/**	\internal
  * \brief	The exception handler for the fixed interval timer exception.
  *
  */
void _exception_fit( void *data )
{
	DEBUG_DUMP();
	
	TRACE_ALWAYS( "FIT Exception\n" );
	TRACE_ALWAYS( "--FAILURE--\n" );
	while(1);
}

/**	\internal
  * \brief	The exception handler for the watchdog timer exception.
  *
  */
void _exception_watchdog( void *data )
{
	DEBUG_DUMP();
	
	TRACE_ALWAYS( "Watch Dog Timer Exception\n" );
	TRACE_ALWAYS( "--FAILURE--\n" );
	while(1);
}

/**	\internal
  * \brief	The exception handler for the data TLB miss exception.
  *
  */
void _exception_data_tlb_miss( void *data )
{
	DEBUG_DUMP();
	
	TRACE_ALWAYS( "Data TLB Exception\n" );
	TRACE_ALWAYS( "--FAILURE--\n" );
	while(1);
}

/**	\internal
  * \brief	The exception handler for the instruction TLB miss exception.
  *
  */
void _exception_instr_tlb_miss( void *data )
{
	DEBUG_DUMP();
	
	TRACE_ALWAYS( "Instruction TLB Exception\n" );
	TRACE_ALWAYS( "--FAILURE--\n" );
	while(1);
}

/**	\internal
  * \brief	The exception handler for the debug exception.
  *
  */
void _exception_debug( void *data )
{
	DEBUG_DUMP();
	
	TRACE_ALWAYS( "Debug Exception\n" );
	TRACE_ALWAYS( "--FAILURE--\n" );
	while(1);
}

/**	\internal
  * \brief	The exception handler for a critical exception.
  *
  */
void _exception_critical( void *data )
{
	DEBUG_DUMP();
	
	TRACE_ALWAYS( "Critical Exception\n" );
	TRACE_ALWAYS( "--FAILURE--\n" );
	while(1);
}

/**	\internal
  * \brief	The exception handler for a noncritical exception.
  *
  */
void _exception_noncritical( void *data )
{
    Huint status;
    Huint curr;
    Huint next;
    Huint preempt_value;

    // Get the pending interrupts
#ifdef HTHREADS_SMP
    status = intr_pending( cpu_to_pic[_get_procid()] );

    if( _get_procid() == 0 )
        preempt_value = PREEMPT_0_INTR_MASK;
    else
        preempt_value = PREEMPT_1_INTR_MASK;
#else
    status = intr_pending( NONCRIT_PIC_BASEADDR );
    preempt_value = PREEMPT_INTR_MASK;
#endif

    if( status & preempt_value )
    {
#ifdef HTHREADS_SMP
        // Read out the current and next threads
        curr = _current_thread();
        next = _yield_thread();

        // Acknowledge the interrupt
        intr_ack( cpu_to_pic[_get_procid()], PREEMPT_0_INTR_MASK );
        intr_ack( cpu_to_pic[_get_procid()], PREEMPT_1_INTR_MASK );

        // Switch contexts if needed
        if( curr != next )
        {
            while(!_get_syscall_lock());
            _switch_context( curr, next );
            while(!_release_syscall_lock());
        }
#else
        // Read out the current and next threads
        curr = _current_thread();
        next = _yield_thread();

        // Acknowledge the interrupt
        intr_ack( NONCRIT_PIC_BASEADDR, PREEMPT_INTR_MASK);
        if( curr != next ) _switch_context( curr, next );
#endif
        // Return from handling the interrupt
        return;
    }

    if( status & ACCESS_INTR_MASK ) TRACE_ALWAYS( "Access Interrupt\n" );
    else                            TRACE_ALWAYS( "Unknown Interrupt = %d\n",status );

    TRACE_ALWAYS( "--FAILURE--\n" );
    while( 1 );
}

