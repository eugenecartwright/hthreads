/************************************************************************************
* Copyright (c) 2006, University of Kansas - Hybridthreads Group
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
*     * Neither the name of the University of Kansas nor the name of the
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
  * \brief      The interface to the thread scheduler.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  *
  * This file contains the implementation of the thread scheduler interface.
  */
#ifndef _HTHREADS_SCHEDULER_HARDWARE_H_
#define _HTHREADS_SCHEDULER_HARDWARE_H_

#include <hthread.h>
#include <util/rops.h>
#include <scheduler/commands.h>
#include <sys/internal.h>
#include <stdio.h>

static inline Huint _read_sched_status( Huint id )
{
	Huint cmd = sched_cmd( 0, id, HT_CMD_SCHED_ENTRY );
	return read_reg( cmd );
}

static inline void _decode_sched_status( Huint status )
{
    Huint   queued;
    Huint   next;
    Huint   prior;

    queued  = ((status >> 31) & 0x00000001);
    next    = ((status >> 23) & 0x000000FF);
    prior   = ((status >> 16) & 0x0000007F);

    //printf( "\tSched - (QUE=0x%2.2x) (NXT=0x%2.2x) (PRI=0x%2.2x)\n",
    //        queued, next, prior );
}

static inline Huint _get_highest_priority( void )
{
    Huint val;
    Huint cmd;
    
    cmd = sched_cmd( 0x00, 0x00, HT_CMD_SCHED_HIGHPRI );
    val = read_reg( cmd );

    return val;
}

static inline Huint _get_schedparam( Huint id )
{
	Huint   cmd;
    
    cmd = sched_cmd( 0, id, HT_CMD_SCHED_GETSCHEDPARAM );
    return read_reg( cmd );
}

static inline Huint _check_schedparam( Huint id )
{
	Huint   cmd;
	Huint   res;
    
    cmd = sched_cmd( 0, id, HT_CMD_SCHED_CHECKSCHEDPARAM );
    res = read_reg( cmd );

	if ( has_error( res ) ) return FAILURE;
    else                    return SUCCESS;
}

static inline Hint _set_schedparam( Huint id, Huint pr )
{
    Huint   cmd;
    Hint    res;
        
    cmd = sched_cmd( 0, id, HT_CMD_SCHED_SETSCHEDPARAM );
    write_reg( cmd, pr );

    // After setting the sched_param, now check to see if it is valid
    res = _check_schedparam( id );

    if ( has_error( res ) )     return FAILURE;
    else                        return SUCCESS;
}

static inline void _enable_preemption( void )
{
	volatile Huint cmd = sched_cmd( 0x0, 0x0, HT_CMD_SCHED_PREEMPT );
    write_reg( cmd, 0xFFFFFFFF );
    TRACE_PRINTF( TRACE_INFO, TRACE_HSCHED, "Preemption Enabled: 0x%8.8x\n", cmd );
}

static inline void _disable_preemption( void )
{
	Huint cmd = sched_cmd( 0x00, 0x00, HT_CMD_SCHED_PREEMPT );
    write_reg( cmd, 0x00 );
    TRACE_PRINTF( TRACE_INFO, TRACE_HSCHED, "Preemption Disabled: 0x%8.8x\n", cmd );
}

static inline void _init_thread_scheduler( void )
{
    TRACE_PRINTF( TRACE_INFO, TRACE_HSCHED, "Initializing Thread Scheduler...\n" );
    //_enable_preemption();
}

//static inline Huint _set_idle_thread( Huint id )
static inline Huint _set_idle_thread( Huint id, Huint cpuid )
{
    Huint cmd;

    if( cpuid == 0)
    {
        cmd = sched_cmd( 0, id, HT_CMD_SCHED_SET_IDLE_THREAD );
    }
    else
    {
        cmd = sched_cmd( 0, id, HT_CMD_SCHED_SET_IDLE_THREAD );
        cmd |= 0x00010000;
    }     
   return read_reg( cmd );
}

static inline Huint _get_idle_thread( Huint cpuid )
{
    Huint cmd;

    if( cpuid == 0 )
    {
        cmd = sched_cmd( 0, 0, HT_CMD_SCHED_GET_IDLE_THREAD );
    }
    else
    {
        cmd = sched_cmd( 0, 0, HT_CMD_SCHED_GET_IDLE_THREAD );
        cmd |= 0x00010000;    
    }
    return read_reg( cmd );
}

/* Processor specific lock for system calls */    
static inline Huint _get_syscall_lock( void )
{
    Huint cmd;

    /* The idea for the delay here is to allow the other processor
       access to the bus by incrementing k which is stored in the 
       processors cache - Not sure whether this is truly needed */
    //int k;
    //for(k = 0; k < 200; k++);

    cmd = sched_cmd( 0, 0, HT_CMD_SCHED_SYSCALL_LOCK );
    
    /* Requesting a lock operation */
    cmd |= 0x00040000;
    
    return read_reg( cmd );
}
    
/* Processor specific lock for system calls */    
static inline Huint _release_syscall_lock( void )
{
    Huint cmd;
    
    /* The idea for the delay here is to allow the other processor
       access to the bus by incrementing k which is stored in the 
       processors cache - Not sure whether this is truly needed */
    //int k;
    //for(k = 0; k < 200; k++);
    
    cmd = sched_cmd( 0, 0, HT_CMD_SCHED_SYSCALL_LOCK );
   
    //_enable_prempt();
 
    return read_reg( cmd );
}

/* Thread specific lock for malloc */
static inline Huint _get_malloc_lock( Huint th )
{
    Huint cmd;

    cmd = sched_cmd( 0, th, HT_CMD_SCHED_MALLOC_LOCK );

    /* Requesting a lock operation */
    cmd |= 0x00040000;
         
    /* Return the LSB */
    return (read_reg( cmd ) & 0x00000001);
}

/* Thread specific unlock for malloc */
static inline Huint _release_malloc_lock( Huint th )
{
    Huint cmd;

    cmd = sched_cmd( 0, th, HT_CMD_SCHED_MALLOC_LOCK );

    return read_reg( cmd );
}


#endif
