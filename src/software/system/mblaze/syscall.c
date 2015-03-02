/************************************************************************************
* Copyright (c) 2006, University of Kansas - Hybridthreads Group
* All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
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
  * \file       syscall.c
  * \brief      The implementation of the system call handler.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  *
  * This file contains the implementation of the system call exception
  * handler. The handler is the gateway between a user process and the
  * kernel. Any function performed by the kernel on behalf of a user process
  * must go through the system call interface.
  */
#include <hthread.h>
#include <debug.h>
#include <sys/syscall.h>
#include <manager/manager.h>
#include <condvar/condvar.h>
#include <mutex/mutex.h>
#include <pic/pic.h>
#include <sys/core.h>
#include <hwti/hwti.h>
#include <arch/arch.h>

// Declare the global variable used profile system calls
hprofile_hist_declare( SYSCALL, SCTYPE );

#if PROFILE_SYSCALL
static void __attribute((constructor)) profile_start( void )
{
    hprofile_hist_create( SYSCALL, SCTYPE, SCMIN, SCMAX, SCBINS );
}

static void __attribute((destructor)) profile_finish( void )
{
    hprofile_hist_flush( SYSCALL, SCTYPE, SCOUT, SCNAME );
    hprofile_hist_close( SYSCALL, SCTYPE );
}
#endif

/**	\internal
  * \brief	The exception handler for the system call exception.
  *
  * This function is registered at initialization time to be the system
  * call exception handler. It calls one of several functions based on the
  * system call number and returns the results of the system call back
  * to the caller by way of the param1 variable in the system call
  * data structure.
  */
void* _system_call_handler(Huint c,void *p2,void *p3,void *p4,void *p5,void *p6)
{
    void *ret;

    if (c > 16)
    {

/* Pseudo assembler instructions */

#define stringify(s)    tostring(s)
#define tostring(s)     #s
#define mfgpr(rn)       ({  unsigned int _rval;         \
                            __asm__ __volatile__ (      \
                                "or\t%0,r0," stringify(rn) "\n" : "=d"(_rval) \
                            );                          \
                            _rval;                      \
                        })

        unsigned int temp_reg;
        temp_reg = mfgpr(r15);
        printf("[TID = %u] Illegal Syscall ID 0x%08x, r15 = 0x%08x\n",_current_thread(),c,temp_reg);
        while(1);
    } 

#ifdef HTHREADS_SMP
    while( !_get_syscall_lock() );
#endif     
   
    hprofile_hist_capture( SYSCALL, SCTYPE, c );
	switch( c )
	{
	case HTHREAD_SYSCALL_CREATE:
		ret = (void*)_syscall_create( (hthread_t*)p2,
                                       (hthread_attr_t*)p3,
                                       (hthread_start_t)p4,
                                       p5 );
        break;

	case HTHREAD_SYSCALL_JOIN:
		ret = (void*)_syscall_join( (hthread_t)p2, (void**)p3 );
        break;

	case HTHREAD_SYSCALL_DETACH:
		ret = (void*)_syscall_detach( (hthread_t)p2 );
        break;

	case HTHREAD_SYSCALL_YIELD:
		ret = (void*)_syscall_yield();
        break;

	case HTHREAD_SYSCALL_EXIT:
		_syscall_exit( p2 );
        ret = NULL;
        break;

	case HTHREAD_SYSCALL_CURRENTID:
		ret = (void*)_syscall_current_id();
        break;

    case HTHREAD_SYSCALL_SETPRI:
        ret = (void*)_syscall_set_schedparam(  (hthread_t)p2, (Huint)p3 );
        break;

    case HTHREAD_SYSCALL_GETPRI:
        ret = (void*)_syscall_get_schedparam(  (hthread_t)p2, (Hint*)p3 );
        break;

	case HTHREAD_SYSCALL_MUTEX_LOCK:
		ret = (void*)_syscall_mutex_lock((hthread_mutex_t*)p2);
        break;

	case HTHREAD_SYSCALL_MUTEX_UNLOCK:
		ret = (void*)_syscall_mutex_unlock((hthread_mutex_t*)p2);
        break;

	case HTHREAD_SYSCALL_MUTEX_TRYLOCK:
		ret = (void*)_syscall_mutex_trylock((hthread_mutex_t*)p2);
        break;

	case HTHREAD_SYSCALL_COND_WAIT:
        ret = (void*)_syscall_cond_wait((hthread_cond_t*)p2,
                                         (hthread_mutex_t*)p3);
        break;

	case HTHREAD_SYSCALL_COND_SIGNAL:
        ret = (void*)_syscall_cond_signal((hthread_cond_t*)p2);
        break;

	case HTHREAD_SYSCALL_COND_BROADCAST:
        ret = (void*)_syscall_cond_broadcast((hthread_cond_t*)p2);
        break;

	case HTHREAD_SYSCALL_INTRASSOC:
		ret = (void*)_syscall_intr_assoc( (Huint)p2 );
        break;

    case HTHREAD_SYSCALL_SCHED:
        ret = (void*)_syscall_sched();
        break;

    default:
        printf("***** Bad Syscall ID (0x%08x) ******\n",c);
        ret = (void*)EINVAL;
        break;
	}

#ifdef HTHREADS_SMP
    while( !_release_syscall_lock() );
#endif

    return ret;
}

/** \internal
  * \brief  The system call which implements the hthread_create functionality.
  *
  * \author     Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function is the system call routine which implements the 
  * hthread_create functionality for hthreads. The user space function
  * hthread_create invokes this function to create a new thread.
  *
  * \param  th      If the thread was created successfully then the new
  *                 thread will be stored in the location pointed to
  *                 by this argument.
  * \param  attr    The attributes to apply to the newly created thread.
  *                 See the documentation for hthread_attr_t for more on
  *                 the allowable attributes.
  * \param  start   A function pointer which is used as the beginning of
  *                 the new threads execution. If this function ever returns
  *                 then the new thread will be terminated.
  * \param  arg     An arbitrary pointer which is used as the first and
  *                 only argument to the start routine.
  * \return         The return value is one of the following:
  *                 - EAGAIN  : There was an error when attempting to create
  *                             the new thread. Trying the attempt again might
  *                             have a different result.
  *                 - ENOMEM  : Not enough memory is available to satisfy the
  *                             request. Attempting again after more memory
  *                             is free might have different results.
  *                 - EINVAL  : One of the parameters used when calling this
  *                             function is invalid.
  *                 - FAILURE : A generic failure occurred in the hardware
  *                             when attempting to setup the thread.
  *                 - SUCCESS : The thread was created successfully
  */
Hint _syscall_create(	hthread_t *th, hthread_attr_t *attr,
						hthread_start_t start, void *arg )
{
	Huint threadStatus;
	Huint threadID;
	Huint addStatus;
    Huint setupStatus;
    Huint schedStatus;
    
    // Print out a trace message about this system call
    TRACE_PRINTF( TRACE_FINE, TRACE_SYSCALL,
                  "SYSCALL: (OP=CREATE) (THR=0x%8.8x) (ATTR=0x%8.8x) (STRT=0x%8.8x) (ARG=0x%8.8x)\n",
                  (Huint)th, (Huint)attr, (Huint)start, (Huint)arg );

    // Ask the thread manager to create a new thread for us. If it
    // is successful then the thread id will be encoded into the return
    // value.
    if( attr->detached )    threadStatus = _create_detached();
	else                    threadStatus = _create_joinable();

    TRACE_PRINTF( TRACE_FINE, TRACE_SYSCALL, "SYSCALL: (OP=CREATE) (DET = 0x%8.8x)\n",(Huint)attr->detached );

    // Check if there was an error while creating the new thread. If
	// there was then it means that all of the available threads are
	// being used, so we return an error.
	if( has_error(threadStatus) )
    {
        TRACE_PRINTF( TRACE_DBG, TRACE_SYSCALL, "SYSCALL: (OP=CREATE) (STA=0x%8.8x) (ERR=CREATE)\n", threadStatus );
        return EAGAIN;
    }

	// If there was no error then we need to get the new thread's id
	// out of the return status.
	threadID = extract_id( threadStatus );
    TRACE_PRINTF( TRACE_DBG, TRACE_SYSCALL, "SYSCALL: (OP=CREATE) (TID=0x%8.8x)\n", threadID );
    
	// Initialize the software structures used to keep track of the thread.
	setupStatus = _setup_thread( threadID, attr, start, arg );
    if( setupStatus != SUCCESS )
    {
        TRACE_PRINTF( TRACE_DBG, TRACE_SYSCALL, "SYSCALL: (OP=CREATE) (STA=0x%8.8x) (ERR=SETUP)\n", setupStatus );
        return setupStatus;
    }

    // Set the scheduling parameter for the thread.
    if( attr->hardware != Htrue )
    {
        TRACE_PRINTF( TRACE_DBG, TRACE_SYSCALL, "SYSCALL: (OP=CREATE) (Software Thread Sched. Param = 0x%8.8x)\n",attr->sched_param);
        schedStatus = _set_schedparam( threadID, attr->sched_param );
    }
    else
    {
        TRACE_PRINTF( TRACE_DBG, TRACE_SYSCALL, "SYSCALL: (OP=CREATE) (Hardware Thread Sched. Param = 0x%8.8x)\n",attr->hardware_addr);
        schedStatus = _set_schedparam( threadID, attr->hardware_addr );
    }

    if( schedStatus != SUCCESS )
    {
        TRACE_PRINTF( TRACE_DBG, TRACE_SYSCALL, "SYSCALL: (OP=CREATE) (STA=0x%8.8x) (ERR=SCHED)\n", schedStatus );
        return schedStatus;
    }

    // Now that we have the new thread setup so that it can run we
    // can add the thread in the ready-to-run queue.
    addStatus = _add_thread( threadID );

	// Check if there was an error when adding the thread into the
	// ready-to-run queue. If there was then we need to clean up the
	// new thread and return an error condition.
	if( has_error(addStatus) )
	{
        TRACE_PRINTF( TRACE_DBG, TRACE_SYSCALL, "SYSCALL: (OP=CREATE) (STA=0x%8.8x) (ERR=ADD)\n", addStatus );

        addStatus = _read_sched_status(threadID);
        _decode_sched_status(addStatus);

		// Clean up the software structures used by the thread.
		_destroy_thread( threadID );

		// Remove the thread.
		_clear_thread( threadID );

		// Return an error condition.
		return EAGAIN;
	}

	// Return the thread ID to the caller. At this point the thread has
	// been successfully created and added to the queue so that we know
	// a valid thread ID will be returned to the user.
	*th = threadID;

    // Print out a trace message about this system call
    TRACE_PRINTF( TRACE_FINE, TRACE_SYSCALL, "SYSCALL DONE: (OP=CREATE) (THR=0x%8.8x) (ATTR=0x%8.8x) (STRT=0x%8.8x) (ARG=0x%8.8x)\n", (Huint)th, (Huint)attr, (Huint)start, (Huint)arg );

	// The thread was created and added to the ready-to-run queue
	// successfully. Return the success code.
	return SUCCESS;
}

/** \internal
  * \brief  The system call that implements the hthread_join functionality.
  *
  * \author     Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function is the system call routine which implements the 
  * hthread_join functionality for hthreads. The user space function
  * hthread_join invokes this function to join to a thread.
  *
  * \param  th      The thread which the currently running thread will
  *                 join with. This thread must be a valid thread which
  *                 is in the joinable state and must not have another
  *                 thread waiting for its termination.
  * \param  retval  If this value is not NULL then the return value from
  *                 the thread th will be stored into the location pointed
  *                 to by retval.
  * \return         The return value is one of the following:
  *                 - EINVAL  : One of the parameters used to call this
  *                             function is invalid
  *                 - SUCCESS : The thread was joined successfully and is
  *                             now exited
  */
Hint _syscall_join( hthread_t th, void **retval )
{
	Huint exited;
	Huint status;
	
    // Print out a trace message about this system call
    TRACE_PRINTF( TRACE_FINE, TRACE_SYSCALL, "SYSCALL: (OP=JOIN) (THR=0x%8.8x) (RET=0x%8.8x)\n", (Huint)th, (Huint)retval );

	// Join the current thread with the given thread.
	status = _join_thread( th );

	// If there was an error trying to join the thread then we
	// will return that error to the caller.
	if( has_error(status) )
	{
		// If the thread that is being joined has already exited then we do
		// not need to wait on it so this statement will not be executed. If
		// the thread has not yet exited then we will release the proccessor
		// without adding ourself back onto the ready-to-run queue. The thread
		// we are joining will add us back to the queue once it has exited.
        exited = extract_error( status );
		if( exited != HT_ALREADY_EXITED )
        {
            DEBUG_PRINTF( "JOIN ERROR=0x%8.8x\n", exited );
            return EINVAL;
        }
	}		

    // If the thread has not already exited then block the currently
    // running thread until that thread has exited.
    exited = extract_error( status );
    if( exited != HT_ALREADY_EXITED )
    {
        _run_sched( Htrue );
    }
    
	// At this point the thread we are joining is guaranteed to have exited.
	// We should store the return value of the thread into the retval
	// variable. We then destroy and clear the thread so that some other
	// process can make used of the thread ID.
    if( retval != NULL )
    {
        // Commented out, as fast V-HWTI re-usage via smart dispatch will re-use a V-HWTI as soon as a thread is exited,
        // thus causing the return value to be overwritten.  The new HAL bootloop copies the return value to the threads.retval location
        // just as SW threads do, so hardware thread's return values can be retrieved from the same place (as they are now preserved)
        //if( threads[ th ].hardware != 0 )   *retval = (void**)_hwti_results( threads[th].hardware - HT_HWTI_COMMAND_OFFSET );

        if( threads[ th ].hardware != 0 )   *retval = threads[th].retval;
        else                                *retval = threads[th].retval;
    }

	// Deallocate the software side structures used to keep track of the
	// thread that was just joined.
    if( !_detached_thread( th ) )
    {
        _destroy_thread( th );
    }
    
    // Print out a trace message about this system call
    TRACE_PRINTF( TRACE_FINE, TRACE_SYSCALL, "SYSCALL DONE: (OP=JOIN) (THR=0x%8.8x) (RET=0x%8.8x)\n", (Huint)th, (Huint)retval );

	// Return successfully.
	return SUCCESS;
}

/** \internal
  * \brief  The system call that implements the hthread_detach functionality.
  *
  * \author     Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function is the system call routine which implements the 
  * hthread_detach functionality for hthreads. The user space function
  * hthread_detach invokes this function to detach a thread.
  *
  * \return         The return value is one of the following:
  *                 - EINVAL  : One of the parameters used to call this
  *                             function is invalid
  *                 - SUCCESS : The thread was detached successfully
  */ 
Hint _syscall_detach( hthread_t th )
{
    Hbool sta;

    // Print out a trace message about this system call
    TRACE_PRINTF( TRACE_FINE, TRACE_SYSCALL, "SYSCALL: (OP=DETACH) (THR=0x%8.8x)\n", (Huint)th );

    sta = _detach_thread( th );
    
    // Print out a trace message about this system call
    TRACE_PRINTF( TRACE_FINE, TRACE_SYSCALL, "SYSCALL DONE: (OP=DETACH) (THR=0x%8.8x)\n", (Huint)th );

    if( sta )   return SUCCESS;
    else        return EINVAL;
}

/** \internal
  * \brief  Voluntarily release the processor so that another thread
  *         can be scheduled to run.
  *
  * \author     Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function is the system call routine which implements the 
  * hthread_yield functionality for hthreads. The user space function
  * hthread_yield invokes this function to yield the processor.
  *
  * \return         The return value is one of the following:
  *                 - SUCCESS : Currently there is no way for this function
  *                             to fail
  */ 
Hint _syscall_yield( void )
{
    Huint curr;
	Huint next;
	
    // Print out a trace message about this system call
    TRACE_PRINTF( TRACE_FINE, TRACE_SYSCALL, "SYSCALL: (OP=YIELD)\n" );

    // Get the currently running thread
    curr = _current_thread();    

    // Get the next thread to run
    next = _yield_thread();
    
    // Print out a trace message about this system call
    TRACE_PRINTF( TRACE_FINE, TRACE_SYSCALL, "SYSCALL DONE: (OP=YIELD)\n" );

    // If they are not the same thread then switch to the new thread
    if( curr != next )  _switch_context( curr, next );

    return SUCCESS;
}

/** \internal
  * \brief  The system call that implements the htread_exit functionality.
  *
  * \author     Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function is the system call routine which implements the 
  * hthread_exit functionality for hthreads. The user space function
  * hthread_exit invokes this function to terminate a thread.
  *
  * \param  retval  The return value of the thread. If the currently
  *                 running thread is in the joinable state then this
  *                 value is returned to the thread which joins with
  *                 the currently running thread, otherwise this
  *                 value is discarded.
  * \return         This function never returns to the calling thread.
  */ 
void _syscall_exit( void *retval )
{
	Huint status;
	Huint current;
    Hbool destroy_flag = Hfalse;

    // Print out a trace message about this system call
    TRACE_PRINTF( TRACE_FINE, TRACE_SYSCALL, "SYSCALL: (OP=EXIT) (RET=0x%8.8x)\n", (Huint)retval );

    // Grab the current thread
	current = _current_thread();
    
    // Print out a trace message about this system call
    TRACE_PRINTF( TRACE_FINE, TRACE_SYSCALL, "SYSCALL: (OP=EXIT) (TID=0x%8.8x) (RET=0x%8.8x)\n", (Huint)current, (Huint)retval );
     
    if( _detached_thread(current) ) destroy_flag = Htrue;

	// The return value needs to be saved before we
	// try to exit the thread (to avoid race conditions when a parent joins
	// a thread and trys to get the return value). Note that we don't
	// need to save the return value for a detached thread.
    threads[current].retval = retval;
    
	// FIXME: We should check the error condition during the while loop
	// to ensure that the error was because the ready-to-run queue is
	// full. Any other error is fatal and since this function never returns
	// to the caller we must handle this error.
	status = _exit_thread( current );

	while( has_error(status) )
	{
        DEBUG_PRINTF( "Exit returned an error: (STA=0x%8.8x)\n", status );

		// Yield the processor to another thread.
		_syscall_yield();

		// Try to exit again after some other thread has run.
		status = _exit_thread( current );
	}
 
    // If the thread is a detached thread then it can be destroyed right
    // away. Joinable threads cannot be destroyed until they have been joined
    // by some other thread (see _syscall_join).
    if( destroy_flag ) 
    {
        _destroy_thread( current );

        TRACE_PRINTF( TRACE_FINE, TRACE_SYSCALL, "** DETACHED = 0x%8.8x **\n",destroy_flag);
    }

    // Print out a trace message about this system call
    TRACE_PRINTF( TRACE_FINE, TRACE_SYSCALL, "SYSCALL DONE: (OP=EXIT) (RET=0x%8.8x)\n", (Huint)retval );

	// We have now exited. Run the scheduler and never come back.
	_run_sched( Hfalse );
}

/** \internal
  * \brief  Thread the thread id for the currently running thread.
  *
  * \author Wesley Peck <peckw@eecs.ku.edu>
  *
  * This function returns the thread id of the currently running thread
  * to the caller.
  *
  * \return The thread ID of the caller.
  */ 
hthread_t _syscall_current_id( void )
{
    // Print out a trace message about this system call
    TRACE_PRINTF( TRACE_FINE, TRACE_SYSCALL, "SYSCALL: (OP=CURID)\n" );

    // Return the currently running thread
	return (hthread_t)_current_thread();
}

/** \internal
  * \brief  Set the given threads priority.
  *
  * \author Wesley Peck <peckw@ittc.ku.edu>
  *
  * This function sets the given threads priority value and returns
  * it to the caller. The priority of a thread ranges from 0 to 127 with
  * smaller values indicating higher priorities.
  *
  * Setting a threads priority can only be done by the thread itself or
  * the parent of the thread. If a thread other than these two attempts
  * to change another thread's priority then an error value will be returned.
  *
  * \param  th  The thread id of the thread to set the priority for.
  * \param  pr  The priority value to give to the thread. This value should
  *             be in the range 0 to 127 with lower values indicating higher
  *             priority.
  * \return     This function returns one of the following:\n
  *             - FAILURE : The thread's priority was not updated because the
  *                         set priority operation failed
  *             - SUCCESS : The thread's priority was updated to the new value
  */
Hint _syscall_set_schedparam( hthread_t th, Huint pr )
{
    // Print out a trace message about this system call
    TRACE_PRINTF( TRACE_FINE, TRACE_SYSCALL, "SYSCALL: (OP=SETPRI) (THR=0x%8.8x) (PRI=0x%8.8x)\n", (Huint)th, (Huint)pr );

    // Set the priority of the currently running thread
    return _set_schedparam( th, pr );
}

/** \internal
  * \brief  Retreive the given threads priority.
  *
  * \author Wesley Peck <peckw@ittc.ku.edu>
  *
  * This function retrieves the given threads priority value and returns
  * it to the caller. The priority of a thread ranges from 0 to 127 with
  * smaller values indicating higher priorities.
  *
  * \param  th  The thread id to retrieve the priority of.
  *         pr  The priority of the requested thread
  * \return     This function always returns successfully
  */
Hint _syscall_get_schedparam( hthread_t th, Hint *pr )
{
    // Print out a trace message about this system call
    TRACE_PRINTF( TRACE_FINE, TRACE_SYSCALL, "SYSCALL: (OP=GETPRI) (THR=0x%8.8x)\n", (Huint)th );

    *pr = _get_schedparam( th );
    return SUCCESS;
}

/** \internal
  * \brief  Associate a thread id with and interrupt id - Old Special PIC.
  */
Hint _syscall_intr_assoc_OLD_OPB_PIC( Huint iid )
{
    Huint res;

    // Print out a trace message about this system call
    TRACE_PRINTF( TRACE_FINE, TRACE_SYSCALL, "SYSCALL: (OP=INTR) (IID=0x%8.8x)\n", (Huint)iid );

#ifdef SPIC_BASEADDR
    Huint cur;
    
    // FIXME: Should this be a while loop?
    cur = _current_thread();
    do
    {
        printf( "INTR: Assoc Intr\n" );
        res = spic_assoc(cur,iid);
        if( spic_success(res) ) { printf( "INTR: Run Sched\n" ); _run_sched( Htrue ); }
    } while( spic_error(res) );
#else
    res = 0;
#endif

    // Print out a trace message about this system call
    TRACE_PRINTF( TRACE_FINE, TRACE_SYSCALL, "SYSCALL DONE: (OP=INTR) (IID=0x%8.8x)\n", (Huint)iid );

    return res;
}

/** \internal
  * \brief  Associate a thread id with and interrupt id - FSMLang Special PIC.
  */
Hint _syscall_intr_assoc( Huint iid )
{
    Huint res;
    volatile Huint *cmd;

    // Print out a trace message about this system call
    TRACE_PRINTF( TRACE_FINE, TRACE_SYSCALL, "SYSCALL: (OP=INTR) (IID=0x%8.8x)\n", (Huint)iid );

    // Get currently running thread ID
    Huint cur;    
    cur = _current_thread();

    // Associate thread with interrupt
    // 1) Form command address
    cmd = (Huint *)cbis_encode_cmd(CBIS_WRITE, cur, iid);

    // 2) Invoke command (read from address) and grab result
    res = *cmd;

    //printf("PIC CMD = 0x%08x --> 0x%08x\n",(unsigned int)cmd, res);

    // 3) Check for success, if successful put to sleep, else return with error
    if (res == 0)
    {
        _run_sched( Htrue );
    }

    // Print out a trace message about this system call
    TRACE_PRINTF( TRACE_FINE, TRACE_SYSCALL, "SYSCALL DONE: (OP=INTR) (IID=0x%8.8x)\n", (Huint)iid );

    return res;
}

/** \internal
 *  \brief  Acquire a mutex lock.
 *
 *  \author Wesley Peck <peckw@ittc.ku.edu>
 *
 *  This function is used to acquire a lock for the given mutex.
 *
 *  \param  mutex   The mutex to acquire the lock for.
 */
Hint _syscall_mutex_lock( hthread_mutex_t *mutex )
{
    Huint cur;
    Hint sta;

    // Print out a trace message about this system call
    TRACE_PRINTF( TRACE_FINE, TRACE_SYSCALL, "SYSCALL: (OP=LOCK) (MTX=%d)\n", (Huint)mutex->num );

    cur = _current_thread();
    sta = _mutex_acquire( cur, mutex->num );

    // Print out a trace message about this system call
    TRACE_PRINTF( TRACE_FINE, TRACE_SYSCALL, "SYSCALL DONE: (OP=LOCK) (MTX=%d) (CUR=%u) (STA=%8.8X)\n", (Huint)mutex->num, cur, sta );

    if( sta == HT_MUTEX_BLOCK )
    {
        _run_sched( Htrue );
        return SUCCESS;
    }

    if( sta == SUCCESS ) return SUCCESS;
    else                 return FAILURE;
}

/** \internal
 *  \brief  Release a mutex lock.
 *
 *  \author Wesley Peck <peckw@ittc.ku.edu>
 *
 *  This function is used to release a lock for the given mutex.
 *
 *  \param  mutex   The mutex to release the lock for.
 */
Hint _syscall_mutex_unlock( hthread_mutex_t *mutex )
{
    Huint cur;

    // Print out a trace message about this system call
    TRACE_PRINTF( TRACE_FINE, TRACE_SYSCALL, "SYSCALL: (OP=UNLOCK) (MTX=%d)\n", (Huint)mutex->num );

    cur = _current_thread();
    _mutex_release( cur, mutex->num );

    // Print out a trace message about this system call
    TRACE_PRINTF( TRACE_FINE, TRACE_SYSCALL, "SYSCALL DONE: (OP=UNLOCK) (MTX=%d)\n", (Huint)mutex->num );

    return SUCCESS;
}

/** \internal
 *  \brief  Try to acquire a mutex lock.
 *
 *  \author Wesley Peck <peckw@ittc.ku.edu>
 *
 *  This function is used to try to acquire a lock for the given mutex.
 *
 *  \param  mutex   The mutex to try to acquire the lock for.
 */
Hint _syscall_mutex_trylock( hthread_mutex_t *mutex )
{
    Huint cur;
    Hint sta;

    // Print out a trace message about this system call
    TRACE_PRINTF( TRACE_FINE, TRACE_SYSCALL, "SYSCALL: (OP=TRYLOCK) (MTX=%d)\n", (Huint)mutex->num );

    cur = _current_thread();
    sta = _mutex_tryacquire( cur, mutex->num );

    // Print out a trace message about this system call
    TRACE_PRINTF( TRACE_FINE, TRACE_SYSCALL, "SYSCALL DONE: (OP=TRYLOCK) (MTX=%d)\n", (Huint)mutex->num );

    if( sta != SUCCESS )    return EBUSY;
    else                    return SUCCESS;
}

/** \internal
 *  \brief  Wait on a condition variable.
 *
 *  \author Wesley Peck <peckw@ittc.ku.edu>
 *
 *  This function is used to try to acquire a lock for the given mutex.
 *
 *  \param  cond    The condition variable to try to wait on.
 *  \param  mutex   The mutex to try to used for the wait operation.
 */
Hint _syscall_cond_wait( hthread_cond_t *cond, hthread_mutex_t *mutex )
{
    Hint    sta;
    Huint   tid;

    // Print out a trace message about this system call
    TRACE_PRINTF( TRACE_FINE, TRACE_SYSCALL, "SYSCALL: (OP=WAIT) (CND=0x%8.8x) (MTX=0x%8.8x)\n", (Huint)cond, (Huint)mutex );

    tid = _current_thread();
    _condvar_wait( tid, cond->num );

    sta = _syscall_mutex_unlock( mutex );
    if( sta != SUCCESS )  return sta;

    _run_sched( Htrue );

    sta = _syscall_mutex_lock( mutex );
   if( sta != SUCCESS )  return sta;

    // Print out a trace message about this system call
    TRACE_PRINTF( TRACE_FINE, TRACE_SYSCALL, "SYSCALL DONE: (OP=WAIT) (CND=0x%8.8x) (MTX=0x%8.8x)\n", (Huint)cond, (Huint)mutex );

    return SUCCESS;
}

/** \internal
 *  \brief  Wait on a condition variable.
 *
 *  \author Wesley Peck <peckw@ittc.ku.edu>
 *
 *  This function is used to try to acquire a lock for the given mutex.
 *
 *  \param  cond    The condition variable to try to wait on.
 *  \param  mutex   The mutex to try to used for the wait operation.
 */
Hint _syscall_cond_signal( hthread_cond_t *cond )
{
    // Print out a trace message about this system call
    TRACE_PRINTF( TRACE_FINE, TRACE_SYSCALL, "SYSCALL: (OP=SIGNAL) (CND=0x%8.8x)\n", (Huint)cond );

    return _condvar_signal( cond->num );
}

/** \internal
 *  \brief  Wait on a condition variable.
 *
 *  \author Wesley Peck <peckw@ittc.ku.edu>
 *
 *  This function is used to try to acquire a lock for the given mutex.
 *
 *  \param  cond    The condition variable to try to wait on.
 *  \param  mutex   The mutex to try to used for the wait operation.
 */
Hint _syscall_cond_broadcast( hthread_cond_t *cond )
{
    // Print out a trace message about this system call
    TRACE_PRINTF( TRACE_FINE, TRACE_SYSCALL, "SYSCALL: (OP=BROADCAST) (CND=0x%8.8x)\n", (Huint)cond );

    return _condvar_broadcast( cond->num );
}

/** \internal
 *  \brief  Run the scheduler.
 *
 *  \author Wesley Peck <peckw@ittc.ku.edu>
 *
 *  This function is used to invoke the scheduler. Normally this function
 *  is not used directly, however, it is used by the idle thread.
 */
Hint _syscall_sched( void )
{
    _run_sched( Htrue );
    return SUCCESS;
}
