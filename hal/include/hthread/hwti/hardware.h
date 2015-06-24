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
  * \brief      The interface to the hardware thread interface.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  *
  * This file contains the implementation of the hardware thread interface.
  */
#ifndef _HTHREADS_HWTI_HARDWARE_H_
#define _HTHREADS_HWTI_HARDWARE_H_

#include <util/rops.h>
#include <hwti/commands.h>

static inline void _hwti_reset( Huint base )
{
    Huint cmd;
    
    cmd = hwti_cmd(base, HT_CMD_HWTI_COMMAND);
    write_reg(cmd, HT_HWTI_RESET);
}

static inline void _hwti_setid( Huint base, Huint id )
{
    Huint cmd;
    
    cmd = hwti_cmd(base, HT_CMD_HWTI_SETID);
    write_reg(cmd, id);
}

static inline void _hwti_setarg( Huint base, Huint arg )
{
    Huint cmd;

    cmd = hwti_cmd(base, HT_CMD_HWTI_SETARG);
    write_reg(cmd, arg);
}

// Added by Jason for MicroBlaze-based HW threads
static inline void _hwti_set_fcn_ptr( Huint base, Huint fcn_ptr )
{
    Huint cmd;

    cmd = hwti_cmd(base, HT_CMD_HWTI_FUNC_PTR);
    write_reg(cmd, fcn_ptr);
}

// Added by Jason for MicroBlaze-based HW threads
static inline void _hwti_set_utilized( Huint base )
{
    Huint cmd;

    cmd = hwti_cmd(base, HT_CMD_HWTI_UTILIZED);
    write_reg(cmd, FLAG_HWTI_UTILIZED);
}

// Added by Jason for MicroBlaze-based HW threads
static inline void _hwti_set_free( Huint base )
{
    Huint cmd;

    cmd = hwti_cmd(base, HT_CMD_HWTI_UTILIZED);
    write_reg(cmd, FLAG_HWTI_FREE);
}

// Added by Jason for MicroBlaze-based HW threads
static inline Huint _hwti_results( Huint base )
{
    Huint cmd;
    
    cmd = hwti_cmd(base, HT_CMD_HWTI_RESULTS);
    return read_reg(cmd);
}

/* Returns the value of the HWTI timer.  This timer starts
 * when a RUN command is issued, and stops when hthread_exit
 * is called. */
static inline Huint _hwti_timer( Huint base )
{
    Huint cmd;
    
    cmd = hwti_cmd(base, HT_CMD_HWTI_TIMER);
    return read_reg(cmd);
}

static inline void _hwti_set_global_stack_ptr( Huint base, Huint stack_base )
{
     Huint cmd;
                
     cmd = hwti_cmd(base, HT_CMD_HWTI_STACK_BASE);                
     write_reg(cmd, stack_base);
}

               
static inline void _hwti_set_global_context_ptr( Huint base, Huint context_base )
{            
    Huint cmd;               
    cmd = hwti_cmd(base, HT_CMD_HWTI_CONTEXT_BASE);               
    write_reg(cmd, context_base);
}

static inline void _hwti_set_global_context_table_ptr( Huint base, Huint context_base )
{            
    Huint cmd;               
    cmd = hwti_cmd(base, HT_CMD_HWTI_CONTEXT_TABLE_BASE);               
    write_reg(cmd, context_base);
}

static inline void _hwti_set_bootstrap_ptr( Huint base, Huint boot_base )
{            
    Huint cmd;               
    cmd = hwti_cmd(base, HT_CMD_HWTI_BOOTSTRAP);               
    write_reg(cmd, boot_base);
}
    
// Gets last used accelerator
static inline Huint _hwti_get_last_accelerator( Huint base )
{
    Huint cmd;

    cmd = hwti_cmd(base, HT_CMD_VHWTI_LAST_USED);
    return read_reg(cmd);
}

static inline void _hwti_set_last_accelerator( Huint base, Huint acc_addr )
{
    Huint cmd;
    
    cmd = hwti_cmd(base, HT_CMD_VHWTI_LAST_USED);
    write_reg(cmd, acc_addr);
}

// Gets last used accelerator ptr
static inline Huint _hwti_get_last_accelerator_ptr( Huint base )
{
    Huint cmd;

    cmd = hwti_cmd(base, HT_CMD_VHWTI_LAST_USED_PTR);
    return read_reg(cmd);
}

static inline void _hwti_set_last_accelerator_ptr( Huint base, Huint acc_addr )
{
    Huint cmd;
    
    cmd = hwti_cmd(base, HT_CMD_VHWTI_LAST_USED_PTR);
    write_reg(cmd, acc_addr);
}

// Gets first used accelerator
static inline Huint _hwti_get_first_accelerator( Huint base )
{
    Huint cmd;

    cmd = hwti_cmd(base, HT_CMD_VHWTI_FIRST_USED);
    return read_reg(cmd);
}

static inline void _hwti_set_first_accelerator( Huint base, Huint acc_addr )
{
    Huint cmd;
    
    cmd = hwti_cmd(base, HT_CMD_VHWTI_FIRST_USED);
    write_reg(cmd, acc_addr);
}

// Gets first used accelerator ptr
static inline Huint _hwti_get_first_accelerator_ptr( Huint base )
{
    Huint cmd;

    cmd = hwti_cmd(base, HT_CMD_VHWTI_FIRST_USED_PTR);
    return read_reg(cmd);
}

static inline void _hwti_set_first_accelerator_ptr( Huint base, Huint acc_addr )
{
    Huint cmd;
    
    cmd = hwti_cmd(base, HT_CMD_VHWTI_FIRST_USED_PTR);
    write_reg(cmd, acc_addr);
}

// Gets execution time. HWTI Timer conflicts with the
// Utilized entry when referencing V-HWTI, and not
// the traditional HWTI. 
static inline Hulong _hwti_get_execution_time( Huint base )
{
    Huint cmd;

    cmd = hwti_cmd(base, HT_CMD_VHWTI_EXEC_TIME);
    return read_reg64(cmd);
}

// Gets last function executed on the corresponding processor
static inline Huint _hwti_get_last_function( Huint base )
{
    Huint cmd;

    cmd = hwti_cmd(base, HT_CMD_HWTI_FUNC_PTR);
    return read_reg(cmd);
}

static inline Huint _hwti_get_icap_mutex( Huint base )
{
    Huint cmd;

    cmd = hwti_cmd(base, HT_CMD_VHWTI_ICAP_MUTEX_PTR);
    return read_reg(cmd);
}

static inline void _hwti_set_icap_mutex( Huint base, Huint icap_mutex_addr )
{
    Huint cmd;
    
    cmd = hwti_cmd(base, HT_CMD_VHWTI_ICAP_MUTEX_PTR);
    write_reg(cmd, icap_mutex_addr);
}

static inline Huint _hwti_get_icap_struct_ptr( Huint base )
{
    Huint cmd;

    cmd = hwti_cmd(base, HT_CMD_VHWTI_ICAP_STRUCT_PTR);
    return read_reg(cmd);
}

static inline void _hwti_set_icap_struct_ptr( Huint base, Huint icap_struct_addr )
{
    Huint cmd;
    
    cmd = hwti_cmd(base, HT_CMD_VHWTI_ICAP_STRUCT_PTR);
    write_reg(cmd, icap_struct_addr);
}

static inline Huint _hwti_get_pr_files_ptr( Huint base )
{
    Huint cmd;

    cmd = hwti_cmd(base, HT_CMD_VHWTI_PR_FILES_PTR);
    return read_reg(cmd);
}

static inline void _hwti_set_pr_files_ptr( Huint base, Huint pr_files_ptr )
{
    Huint cmd;
    
    cmd = hwti_cmd(base, HT_CMD_VHWTI_PR_FILES_PTR);
    write_reg(cmd, pr_files_ptr);
}

static inline Huint _hwti_get_tuning_table_ptr( Huint base )
{
    Huint cmd;

    cmd = hwti_cmd(base, HT_CMD_VHWTI_TUNING_TABLE_PTR);
    return read_reg(cmd);
}

static inline void _hwti_set_tuning_table_ptr( Huint base, Huint tuning_table_ptr )
{
    Huint cmd;
    
    cmd = hwti_cmd(base, HT_CMD_VHWTI_TUNING_TABLE_PTR);
    write_reg(cmd, tuning_table_ptr);
}

static inline Huint _hwti_get_accelerator_flags( Huint base )
{
    Huint cmd;

    cmd = hwti_cmd(base, HT_CMD_VHWTI_ACC_FLAGS);
    return read_reg(cmd);
}

static inline void _hwti_set_accelerator_flags( Huint base, Huint accelerator_flags )
{
    Huint cmd;
    
    cmd = hwti_cmd(base, HT_CMD_VHWTI_ACC_FLAGS);
    write_reg(cmd, accelerator_flags);
}

static inline Huint _hwti_get_accelerator_hw_counter( Huint base )
{
    Huint cmd;

    cmd = hwti_cmd(base, HT_CMD_VHWTI_ACC_HW_COUNTER);
    return read_reg(cmd);
}

static inline void _hwti_set_accelerator_hw_counter( Huint base, Huint counter_value )
{
    Huint cmd;
    
    cmd = hwti_cmd(base, HT_CMD_VHWTI_ACC_HW_COUNTER);
    write_reg(cmd, counter_value);
}

static inline Huint _hwti_get_accelerator_sw_counter( Huint base )
{
    Huint cmd;

    cmd = hwti_cmd(base, HT_CMD_VHWTI_ACC_SW_COUNTER);
    return read_reg(cmd);
}

static inline void _hwti_set_accelerator_sw_counter( Huint base, Huint counter_value )
{
    Huint cmd;
    
    cmd = hwti_cmd(base, HT_CMD_VHWTI_ACC_SW_COUNTER);
    write_reg(cmd, counter_value);
}

static inline Huint _hwti_get_accelerator_pr_counter( Huint base )
{
    Huint cmd;

    cmd = hwti_cmd(base, HT_CMD_VHWTI_ACC_PR_COUNTER);
    return read_reg(cmd);
}

static inline void _hwti_set_accelerator_pr_counter( Huint base, Huint counter_value )
{
    Huint cmd;
    
    cmd = hwti_cmd(base, HT_CMD_VHWTI_ACC_PR_COUNTER);
    write_reg(cmd, counter_value);
}
#endif
