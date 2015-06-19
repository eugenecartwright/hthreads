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
  * \file       hardware.h
  * \brief      The interface to the hardware thread manager.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  *
  * This file contains the implementation of the hardware thread manager
  * interface.
  */
#ifndef _HTHREADS_MANAGER_HARDWARE_H_
#define _HTHREADS_MANAGER_HARDWARE_H_

#include <hthread.h>
#include <manager/commands.h>
#include <processor/hardware.h>
#include <hwti/hardware.h>
#include <scheduler/scheduler.h>
#include <sys/internal.h>
#include <stdio.h>
#include <debug.h>

#undef HTHREAD_SHOWTABLE
#ifdef HTHREAD_SHOWTABLE
    #define show_table( s ) _show_table( s )
#else
    #define show_table( s )
#endif

static inline void _start_hardware( void )
{
	Huint reg = encode_reg( HT_CMD_SOFT_START );
//#if PLATFORM_BOARD != ml507
#ifdef OLD_RESET_ARCH
    write_reg( reg, 0xFFFFFFFF );     // V2P based systems will work with this
#else
    write_reg( reg, 0x00000001 );       // V5 based systems have a newer reset architecture
#endif
}

static inline void _stop_hardware( void )
{
	Huint reg = encode_reg( HT_CMD_SOFT_STOP );
	write_reg( reg, 0xFFFFFFFF );
}

static inline void _reset_hardware( void )
{
	Huint reg = encode_reg( HT_CMD_SOFT_RESET );

//#if PLATFORM_BOARD != ml507
#ifdef OLD_RESET_ARCH
    write_reg( reg, 0xFFFFFFFF );     // V2P based systems will work with this
#else
    // Definitions for the new reset core
    volatile Huint *plb_core_resets = (Huint*)(CORE_RESET_BASEADDR);
    volatile Huint *plb_core_reset_responses = (Huint*)(CORE_RESET_BASEADDR+4);

    // Reset TM
    write_reg( reg, 0x00000001 );       // V5 based systems should only use SOFTRESET for the V5

    // Reset all other cores...

    // Send resets to all cores
    *plb_core_resets = 0xF;

    // Wait for all cores to respond
    while(*plb_core_reset_responses != 0xF);

    // De-assert resets to cores
    *plb_core_resets = 0x0;
#endif

	_start_hardware();
}

static inline Huint _read_reset( void )
{
	Huint reg = encode_reg( HT_CMD_SOFT_RESET );
	return read_reg( reg );
}

static inline void _init_thread_manager( void )
{
	_reset_hardware();
    _init_thread_scheduler();
}

static inline Huint _read_thread_status( Huint id )
{
    Huint cmd;
	Huint value;
	
	cmd = encode_cmd( id, HT_CMD_READ_THREAD);
	value = read_reg( cmd );

	return value;
}

static inline void _decode_manager_status( Huint status )
{
    Huint   next;
    Huint   pid;
    Huint   attrs;
    Huint   err;

    err     = ((status >> 0) & 0x0000000F);
    attrs   = ((status >> 4) & 0x0000000F);
    pid     = ((status >> 8) & 0x000000FF);
    next    = ((status >> 16) & 0x000000FF);
    
    DEBUG_PRINTF("\tTMan - " );
    DEBUG_PRINTF("(NXT=%#02x)", next );
    DEBUG_PRINTF("(PID=%#02x)", pid );
    DEBUG_PRINTF("(ATR=%#02x)", attrs );
    DEBUG_PRINTF("(ERR=%#02x)\n", err );
}

static inline void _show_status( const char *header, Huint id )
{
    Huint status1;
    Huint status2;
    
    status1 = _read_thread_status( id );
    status2 = _read_sched_status( id );
  
    DEBUG_PRINTF( "%s: ", header );
    DEBUG_PRINTF( "(TID=%u)", id );
    DEBUG_PRINTF( "(MAN=%#08x)", status1 );
    DEBUG_PRINTF( "(SCH=%#08x)\n", status2 );
    
    _decode_manager_status( status1 );
    _decode_sched_status( status2 );
    
    DEBUG_PRINTF( "\n" );
}

static inline void _show_table( const char *header )
{
    Huint i;
    for( i = 0; i < 5; i++ )
    {
        _show_status( header, i );
    }
    DEBUG_PRINTF("****************************************************\n");
}

static inline Huint _create_detached( void )
{
	Huint res;
    Huint cmd;
    show_table( "Create Detached Status" );
	
	cmd = encode_cmd( 0, HT_CMD_CREATE_THREAD_D);
	res = read_reg( cmd );

    show_table( "Create Detached Status" );
	return res;
}

static inline Huint _create_joinable( void )
{
	Huint res;
	Huint cmd;
    show_table( "Create Joinable Status" );

	cmd = encode_cmd( 0, HT_CMD_CREATE_THREAD_J);
	res = read_reg( cmd );

    show_table( "Create Joinable Status" );
	return res;
}

static inline Huint _get_sched_lines( void )
{
    Huint res;
    Huint cmd;
    show_table( "Get Sched Lines Status" );

    cmd = encode_reg( HT_CMD_GET_SCHED_LINES );
    res = read_reg( cmd );

    show_table( "Get Sched Lines Status" );
    return res;
}

static inline Huint _add_thread( Huint id )
{
	Huint res;
    Huint cmd;
    show_table( "Add Thread Status" );

    cmd = encode_cmd( id, HT_CMD_ADD_THREAD);
	res = read_reg( cmd );

    show_table( "Add Thread Status" );
	return res;
}

static inline Huint _clear_thread( Huint id )
{
	Huint res;
	Huint cmd;
    show_table( "Clear Thread Status" );

	cmd = encode_cmd( id, HT_CMD_CLEAR_THREAD);
	res = read_reg( cmd );

    show_table( "Clear Thread Status" );
	return res;
}

static inline Huint _join_thread( Huint id )
{
	Huint res;
	Huint cmd;
    show_table( "Join Thread Status" );

	cmd = encode_cmd( id, HT_CMD_JOIN_THREAD);
	res = read_reg( cmd );

    show_table( "Join Thread Status" );
	return res;
}

static inline Huint _detach_thread( Huint id )
{
	Huint res;
	Huint cmd;
    show_table( "Detach Thread Status" );

	cmd = encode_cmd( id, HT_CMD_DETACH_THREAD);
	res = read_reg( cmd );

    show_table( "Detach Thread Status" );
	return res;
}

static inline Huint _queue_length( void )
{
	Huint res;
	Huint cmd;
    show_table( "Queue Length Status" );

	cmd = encode_cmd( 0, HT_CMD_QUE_LENGTH);
	res = read_reg( cmd );

    show_table( "Queue Length Status" );
	return res;
}

static inline Huint _exit_thread( Huint id )
{
	Huint res;
	Huint cmd;
    show_table( "Exit Thread Status" );

    /// Exit via TM
    cmd = encode_cmd( id, HT_CMD_EXIT_THREAD);
 	res = read_reg( cmd );

    // Mark as exited/free in VHWTI
    _hwti_set_free(_proc_id());

    show_table( "Exit Thread Status" );
	return res;
}

static inline Huint _is_queued( Huint id )
{
    Huint res;
    Huint cmd;
    show_table( "Is Queued Status" );

    cmd = encode_cmd( id, HT_CMD_IS_QUEUED );
    res = read_reg( cmd );

    show_table( "Is Queued Status" );
    return res;
}

static inline Huint _current_thread( void )
{
    // MicroBlaze-specific V-HWTI code
    // The ID of the thread running on a heterogeneous MB processor
    // can be found in the PVR regsister (w/o having to access the TM)    
    Huint tid;
    tid = _vhwti_tid_field();
    return tid;
}

static inline Huint _next_thread( void )
{
	Huint cmd;
	Huint sta;
    show_table( "Next Thread Status" );
	
	cmd	= encode_cmd( 0, HT_CMD_NEXT_THREAD);
	sta = read_reg( cmd );

	// FIXME: Check for error
    if( has_error(sta) ) DEBUG_PRINTF( "ERROR: (OP=NEXT) (STA=%#08x)\n", sta );
    
    show_table( "Next Thread Status" );
	return extract_id( sta );
}

static inline Huint _yield_thread( void )
{
	Huint cmd;
	Huint sta;

    show_table( "Yield Thread Status" );
	cmd	= encode_cmd( 0, HT_CMD_YIELD_THREAD);
	sta = read_reg( cmd );

	// FIXME: Check for error
    if( has_error(sta) ) DEBUG_PRINTF( "ERROR: (OP=YIELD) (STA=%#08x)\n", sta );
    
    show_table( "Yield Thread Status" );
	return extract_id( sta );
}

static inline Hbool _detached_thread( Huint id )
{
    Huint cmd;
    Huint status;

    cmd = encode_cmd( id, HT_CMD_DETACHED_THREAD );
    status = read_reg(cmd);

    if( status == 0 )   return Hfalse;
    else                return Htrue;
}

static inline Huint _exception_addr( void )
{
	Huint cmd = encode_cmd( 0, HT_CMD_EXCEPTION_ADDR );
	return read_reg( cmd );
}

static inline Huint _exception_reg( void )
{
	Huint cmd = encode_cmd( 0, HT_CMD_EXCEPTION_REG );
	return read_reg( cmd );
}

static inline Huint _get_cpuid( void )
{
    Huint cmd;
    Huint status;
    
    cmd = encode_cmd( 0, HT_CMD_GET_CPUID );
    status = read_reg( cmd );
    
    return extract_cpuid( status );
}

#endif
