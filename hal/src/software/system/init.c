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
  * \file       init.c
  * \brief      The implementation of the Hybrid Threads initialization
  *             functionality.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  *
  * This file contains the implementations for the Hybrid Thread initialization
  * functionality.
  */
#include <hthread.h>
#include <sys/core.h>
#include <manager/manager.h>
//#include <arch/arch.h>
//#include <arch/smp.h>
//#include <sleep.h>
#include <stdlib.h>
#include <sys/exception.h>
//#include <sys/synch.h>

Huint _create_system_thread( hthread_t *th, hthread_attr_t *attr, hthread_start_t start, void *arg )
{
    Huint threadStatus;
    Huint threadID;

    // Create the thread id for the new thread
    if( attr->detached )    threadStatus = _create_detached();
    else                    threadStatus = _create_joinable();

    // Check if there was an error while creating the new thread. If
    // there was then it means that all of the available threads are
    // being used, so we return an error.
    if( has_error(threadStatus) )   return EAGAIN;

    // If there was no error then we need to get the new thread's id
    // out of the return status.
    threadID = extract_id( threadStatus );

    // Initialize the software structures used to keep track of the thread.
    _setup_thread( threadID, attr, start, arg );

    // Set the scheduling parameter for the thread.
    _set_schedparam( threadID, attr->sched_param );

    // Return the thread ID to the caller. At this point the thread has
    // been successfully created and added to the queue so that we know
    // a valid thread ID will be returned to the user.
    *th = threadID;

    // The thread was created and added to the ready-to-run queue
    // successfully. Return the success code.
    return SUCCESS;
}

/** \internal
  * \brief  The Hybrid Threads initialization function.
  *
  * This function is the Hybrid Threads initialization function. This function
  * must be called before any other HThread's functionality is used.
  */
void hthread_init( void )
{
    int ret, i;
    hthread_t main_thread;
    hthread_t idle_thread;
    hthread_attr_t attrs;
    Huint status;

#ifdef HTHREADS_SMP
    int cpuid;
    if(_get_procid() == 0)
    {
        /* Default all stack values to NULL */
        for( i = 0; i < MAX_THREADS; i++ )  threads[ i ].stack	= NULL;

        /* Initialize the thread manager */ 
        _init_thread_manager();

        // Have to acknowledge the access interrupt generated because
        // spinlock and semaphore cores cause a failure
        // Hardcoded...FIXME
        intr_ack( 0x41200000, ACCESS_INTR_MASK );
        intr_ack( 0x41210000, ACCESS_INTR_MASK );

        // Must call this function again because we just reset the TM after
        // already reading CPUID = 0, therefore the next call to _init_cpuid()
        // will also return zero, giving two cpu's the id of zero
        _init_cpuid();

        // Setup the attributes for the idle thread
        attrs.detached	  = Htrue;
        attrs.stack_size  = HT_IDLE_STACK_SIZE;
        attrs.hardware    = Hfalse;
        attrs.stack_addr  = (void*)NULL;
        attrs.sched_param = 0x0000007F;           // Worst possible priority

        // Create the idle thread
        _create_system_thread( &idle_thread, &attrs, _idle_thread, NULL );
        TRACE_PRINTF( TRACE_INFO, TRACE_INIT, "HThread Init: (IDLE ID(PPC_%d)=%u)\n", _get_procid(), idle_thread );

        // Tell the hardware what the idle thread is
        _set_idle_thread( idle_thread, _get_procid() );

        //hthread_spin_lock(&(_sysc_lock));

        // Enable PPC specific interrupts
        //_arch_enable_intr();

        // Initialize the Architecture Specific Code
        TRACE_PRINTF( TRACE_INFO, TRACE_INIT, "Initializing Architecture...\n" );
        //_init_arch_specific( idle_thread );
        //_init_arch_specific();

        // Need to acquire lock here because bootstrap releases lock
        while(!_get_syscall_lock());

        _restore_context( 0 , idle_thread );
    }
    else
    {
        // Setup the attributes for the main thread
        attrs.detached	    = Htrue;                // The Main Thread is Detached
        attrs.stack_size    = HT_MAIN_STACK_SIZE;   // Stack Size for Main Thread
        attrs.hardware      = Hfalse;               // The Main Thread is not Hardware
        attrs.stack_addr    = (void*)0xFFFFFFFF;    // The Main Thread Already Has a Stack
        attrs.sched_param   = HT_DEFAULT_PRI;           // Middle of the Road Priority

        // Create the main thread
        _create_system_thread( &main_thread, &attrs, NULL, NULL );
        TRACE_PRINTF( TRACE_INFO, TRACE_INIT, "HThread Init: (MAIN ID(PPC_%d)=%u)\n", _get_procid(), main_thread );

        // Prevent the system from attempting to deallocate the main stack
        threads[ main_thread ].stack = NULL;

        // Add the main thread onto the ready-to-run queue
        status = _add_thread( main_thread );

        // Set the next thread to be the current thread. This should place
        // the main thread into the current thread register.
        status = _next_thread();

        // The main thread is not a new thread	
        threads[ main_thread ].newthread = Hfalse;

        // Setup the attributes for the idle thread
        attrs.detached	    = Htrue;
        attrs.stack_size    = HT_IDLE_STACK_SIZE;
        attrs.hardware      = Hfalse;
        attrs.stack_addr    = (void*)NULL;
        attrs.sched_param   = 0x0000007F;           // Worst possible priority

        // Create the idle thread
        _create_system_thread( &idle_thread, &attrs, _idle_thread, NULL );
        TRACE_PRINTF( TRACE_INFO, TRACE_INIT, "HThread Init: (IDLE ID(PPC_%d)=%u)\n", _get_procid(), idle_thread );

        // Tell the hardware what the idle thread is
        _set_idle_thread( idle_thread, _get_procid() );

        // Enable PPC specific interrupts
        //_arch_enable_intr();

        // Initialize the Architecture Specific Code
        TRACE_PRINTF( TRACE_INFO, TRACE_INIT, "Initializing Architecture...\n" );
        //_init_arch_specific( main_thread );
        //_init_arch_specific();

        // Enter into user mode
        //_arch_enter_user();

        _enable_preemption();
    }
#else
    // Initialize all of the thread stacks to NULL
    TRACE_PRINTF( TRACE_INFO, TRACE_INIT, "Initializing HThreads System...\n" );
    for( i = 0; i < MAX_THREADS; i++ )  threads[ i ].stack	= NULL;

    // Initialize the Thread Manager
    TRACE_PRINTF( TRACE_INFO, TRACE_INIT, "Initializing Thread Manager...\n" );
    _init_thread_manager();

    // Setup the attributes for the main thread
    attrs.detached	= Htrue;                // Main thread is detached
    attrs.stack_size	= HT_MAIN_STACK_SIZE;   // Stack size for main thread
    attrs.hardware      = Hfalse;               // Main thread is not hardware
    attrs.stack_addr    = (void*)0xFFFFFFFF;    // Main thread has a stack
    attrs.sched_param   = HT_DEFAULT_PRI;      // Middle of the road priority

    // Create the main thread
    ret = _create_system_thread( &main_thread, &attrs, NULL, NULL );
    TRACE_PRINTF( TRACE_INFO, TRACE_INIT, "HThread Init: (MAIN ID=%u)\n", main_thread );
    if( ret != SUCCESS )
    {
        TRACE_PRINTF(TRACE_FATAL, TRACE_INIT, "HThread Init: create main thread failed\n" );
        while(1);
    }

    // Initialize the Architecture Specific Code
    TRACE_PRINTF( TRACE_INFO, TRACE_INIT, "Initializing Architecture...\n" );
    
    //_init_arch_specific();

    // Prevent the system from attempting to deallocate the main stack
    threads[ main_thread ].stack = NULL;

    // Add the main thread onto the ready-to-run queue
    status = _add_thread( main_thread );

    // Set the next thread to be the current thread. This should place
    // the main thread into the current thread register.
    status = _next_thread();

    // Setup the attributes for the idle thread
    attrs.detached	= Htrue;
    attrs.stack_addr    = (void*)NULL;
    attrs.stack_size	= HT_IDLE_STACK_SIZE;

    // Create the idle thread
    ret = _create_system_thread( &idle_thread, &attrs, _idle_thread, NULL );
    TRACE_PRINTF( TRACE_INFO, TRACE_INIT, "HThread Init: (IDLE ID=%u)\n", idle_thread );
    if( ret != SUCCESS )
    {
        TRACE_PRINTF(TRACE_FATAL, TRACE_INIT, "HThread Init: create idle thread failed\n" );
        while(1);
    }

    // Tell the hardware what the idle thread is
    // FIXME - The CPUID is hardcoded, fix the manager/hardware.h file!
    _set_idle_thread( idle_thread , 0);

    // The main thread is not a new thread	
    threads[ main_thread ].newthread = Hfalse;

    // Enter into user mode
    //_arch_enable_intr();
    //_arch_enter_user();
#endif
}

