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
  * \file       setup.c
  * \brief      The implementation of low level thread setup and destruction.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  *
  * FIXME: Add description
  */
#include <hthread.h>
#include <debug.h>
#include <hwti/hwti.h>
#include <sys/core.h>
#include <manager/manager.h>
#include <arch/arch.h>
#include <arch/context.h>

#ifdef HTHREADS_SMP
#define THREAD_DATA __attribute__ ((section ("thread")))
hthread_thread_t threads[ MAX_THREADS ] THREAD_DATA;
#else
hthread_thread_t threads[ MAX_THREADS ];
#endif

// Statically allocated array of thread stacks
typedef struct
{
     unsigned char bytes[HT_STACK_SIZE];
} hthread_stack_t;
 
// Don't need as this is pre-allocated by host MB
//hthread_stack_t stacks[MAX_THREADS];

typedef ppc405_context_t context_entry_t;

Huint _setup_thread( Huint tid, hthread_attr_t *attr, hthread_start_t start, void *arg )
{
    Huint               base;
    void                *stack;

    hthread_stack_t * global_stack_ptr = (hthread_stack_t *)_vhwti_stack_ptr_field();
    hthread_thread_t * global_context_ptr =(hthread_thread_t *) _vhwti_context_ptr_field();
    context_entry_t * global_context_table_ptr = (context_entry_t *) _vhwti_context_table_ptr_field();
    hthread_thread_t * threads = (hthread_thread_t *)global_context_ptr;

    // Make sure that the thread id is valid
    if( tid < 0 || tid >= MAX_THREADS)
    {
        DEBUG_PRINTF( "SETUP: (ERR=INVALID TID) (TID=%d)\n", tid );
        return EINVAL;
    }

    // By default use the stack given to us
    stack = attr->stack_addr;

    // If the thread has not allocated its own stack then we need to allocate one
    if( stack == NULL && attr->hardware != Htrue )
    {
        // Make sure that the stack space requested is reasonable
        if( attr->stack_size <= HTHREAD_STACK_MIN )
        {
            DEBUG_PRINTF( "SETUP: (ERR=INVALID STACK SIZE) (SIZE=%d)\n", attr->stack_size );
            return EINVAL;
        }

        // Allocate the stack space for the thread
        //stack = (void*)malloc( attr->stack_size );

        // Allocate in statically allocated region stored in global stack pointer
        stack = (void*)&global_stack_ptr[tid];

#ifdef HTHREADS_SMP
        // If multiple CPU's, might need to attemp malloc more than once
        // because of plb issues?
        while( stack == NULL )
        {
            //stack = (void*)malloc( attr->stack_size );
            // Allocate in statically allocated region stored in global stack pointer
            stack = (void*)&global_stack_ptr[tid];
        }
#endif

        // Check that the stack allocation was successful
        if( stack == NULL )
        {
            DEBUG_PRINTF( "SETUP: (ERR=NO STACK MEMORY)\n" );
            return ENOMEM;
        }
    }

    // Store the allocated stack into the threads stack pointer
    threads[ tid ].stack = stack;

    // Store the size of the allocated stack into the thread's context
    threads[ tid ].stacksize = attr->stack_size;

    // Setup the thread to be a new thread
    threads[ tid ].newthread = Htrue;

    // Determine if the new thread is a hardware thread
    if( attr->hardware != Htrue )
    {
        // The thread is not a hardware thread so store that information
        threads[ tid ].hardware = 0x00000000;

        // Have the architecture perform its setup.
        return _arch_setup_thread(tid, &threads[tid], start, arg);
        //return SUCCESS;
    }
    else
    {
        // Commented out by Jason, as this upsets thread creation times by a large factor
        //DEBUG_PRINTF( "SETUP: (STA=HARDWARE)\n" );
        
        // Subtracting the offset to the command register we can get the base
        // address for all of the thread's other registers.
        base = attr->hardware_addr - HT_HWTI_COMMAND_OFFSET;
        
        // Reset the hardware thread interface to prepare for its use
        _hwti_reset( base );

        // Tell the hardware thread what its thread id is
        _hwti_setid( base, tid );

        // Tell the hardware thread what its thread argument is
        _hwti_setarg( base, (Huint)arg );

        // Tell the hardware thread what its function pointer is (added by Jason for MicroBlaze-based HW threads)
        _hwti_set_fcn_ptr( base, (Huint)start );

        // Tell the hardware thread where the global thread stack array and global thread context array are located (added by Jason for MicroBlaze-base    d HW threads)
        _hwti_set_global_context_ptr( base, (Huint)global_context_ptr );
        _hwti_set_global_stack_ptr( base, (Huint)global_stack_ptr );
        _hwti_set_global_context_table_ptr( base, (Huint)global_context_table_ptr);
        _hwti_set_bootstrap_ptr(base, (Huint)_bootstrap_thread);

        // The thread is a hardware thread so store that information
        threads[ tid ].hardware = attr->hardware_addr;

        // Return a success indication
        return SUCCESS;
    }
}

Huint _destroy_thread( Huint id )
{
    hthread_thread_t * global_context_ptr =(hthread_thread_t *) _vhwti_context_ptr_field();
    hthread_thread_t * threads = (hthread_thread_t *)global_context_ptr;

    // Deallocate the thread ID from the thread manager
	_clear_thread( id );

    // Give the architecture dependent code a change to destroy the thread
    //_arch_destroy_thread( id, &threads[id], id );

    // Deallocate the stack that the thread is using
    if( threads[id].stack != NULL )
    {
        //free( threads[ id ].stack );
        // No need to free statically allocated objects
    }

    // The stack pointer now points at nothing
    threads[ id ].stack = NULL;

    return SUCCESS;
}
