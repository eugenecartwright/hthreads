/** \internal
  * \file       init.c
  * \brief      The implementation of the Hybrid Threads initialization
  *             functionality.
  *
  * \author     Seth Warn <swarn@uark.edu>\n
  *             based on work by Wesley Peck and Ed Komp
  *
  * This file contains the implementations for the Hybrid Thread initialization
  * functionality.
  */
#include <hthread.h>
#include <sys/core.h>
#include <manager/manager.h>
#include <arch/arch.h>
#include <stdlib.h>
#include <sys/exception.h>


#ifdef HTHREADS_SMP
#define SMP Htrue
#else
#define SMP Hfalse
#endif


void _init_stack_ptrs(void);
hthread_t _create_main_thread(void);
hthread_t _create_idle_thread(void);
void _init_thread_register(hthread_t thread_id);
hthread_t _allocate_thread(void);

void _cpu0_is_ready(void);
void _check_cpu0_is_ready(void);
void _cpu1_is_ready(void);
void _wait_for_cpu1(void);


/** \internal
  * \brief  The Hybrid Threads initialization function.
  *
  * This function is the Hybrid Threads initialization function. This function
  * must be called before any other HThread's functionality is used.
  */
void hthread_init(void)
{

    const int cpu_id = _get_procid();
    hthread_t main_tid = 0;

    TRACE_PRINTF(TRACE_INFO, TRACE_INIT,
                 "CPU %d Initializing HThreads...\n", cpu_id);

    // Initialize the thread_counter to zero.
    // Ultimately, the TM should keep track of 
    // this in a register.
    thread_counter = 0;

    if(cpu_id == 0)
    {
        _init_stack_ptrs();

        /* Initialize the Thread Manager */
        TRACE_PRINTF( TRACE_INFO, TRACE_INIT, "Initializing Thread Manager...\n" );
        _init_thread_manager();

        main_tid = _create_main_thread();
        _cpu0_is_ready();
    }
    else
    {
        _check_cpu0_is_ready();
    }

    hthread_t idle_thread = _create_idle_thread();

    // Initialize the Architecture Specific Code
    TRACE_PRINTF( TRACE_INFO, TRACE_INIT, "Initializing Architecture...\n" );
    _init_arch_specific();

    // Enable interrupts if the Xilinx Interrupt Cntlr is present
#ifdef INTC_PRESENT
    _arch_enable_intr(); 
#endif
    // Enter into user mode
    _arch_enter_user();

    if(cpu_id == 0 && SMP)
        _wait_for_cpu1();

    if(cpu_id != 0 && SMP)
    {
        // Get the syscall lock.  When executing for the first time, the
        // idle thread calls a bootstrap_thread function that unlocks
        // the syscall lock.
        while(!_get_syscall_lock());
        _cpu1_is_ready();
        _restore_context(0, idle_thread);
    }

    if(cpu_id == 0 && SMP)
    {
        // Though we already set the main thread priority when it was
        // created, it seems necessary to set it again here to make
        // the scheduler fully aware of the main thread's priority.
        _set_schedparam(main_tid, HT_DEFAULT_PRI);
        _enable_preemption();
    }
}


// Initialize all of the thread stacks to NULL.
void _init_stack_ptrs(void)
{
    int i;
    for(i = 0; i < MAX_THREADS; i++)
        threads[i].stack = NULL;
}


hthread_t _create_main_thread(void)
{
    // Setup the attributes for the main thread.
    hthread_t main_thread;
    hthread_attr_t attrs;
    attrs.detached	= Htrue;                // Main thread is detached
    attrs.stack_size = HT_MAIN_STACK_SIZE;  // Stack size for main thread
    attrs.hardware = Hfalse;                // Main thread is not hardware
    attrs.stack_addr = (void*)0xFFFFFFFF;   // Main thread has a stack
    attrs.sched_param = HT_DEFAULT_PRI;     // Middle of the road priority

    // Allocate a thread id for the main thread.
    main_thread = _allocate_thread();

    // Set the scheduling parameter for the thread.
    _set_schedparam(main_thread, attrs.sched_param);

    // Prevent the system from attempting to deallocate the main stack.
    threads[ main_thread ].stack = NULL;

    // Populate the thread manager registers for CPU0.
    _init_thread_register(main_thread);

    // Initialize the software structures used to keep track of the thread.
    _setup_thread(main_thread, &attrs, NULL, NULL);
    
    // The main thread is not a new thread.
    threads[ main_thread ].newthread = Hfalse;

    TRACE_PRINTF( TRACE_INFO, TRACE_INIT, "HThread Init: (MAIN ID=%u)\n", main_thread );

    return main_thread;
}


hthread_t _create_idle_thread(void)
{
    // Setup the attributes for the idle thread
    hthread_t idle_thread;
    hthread_attr_t attrs;
    attrs.detached	= Htrue;
    attrs.stack_addr = (void*)NULL;
    attrs.stack_size = HT_IDLE_STACK_SIZE;
    attrs.hardware = Hfalse;
    attrs.sched_param = 0x0000007F;         // Lowest priority

    idle_thread = _allocate_thread();

    // Set the scheduling parameter for the thread.
    _set_schedparam(idle_thread, attrs.sched_param);

    // If this isn't the master CPU, then the current thread register
    // hasn't been initialized yet -- the master CPU does it when it creates
    // the main thread.
    if(_get_procid() != 0)
        _init_thread_register(idle_thread);

    // Initialize the software structures used to keep track of the thread.
    _setup_thread(idle_thread, &attrs, _idle_thread, NULL);

    // Tell the hardware what the idle thread is
    _set_idle_thread(idle_thread, _get_procid());

    TRACE_PRINTF( TRACE_INFO, TRACE_INIT, "HThread Init: (IDLE ID=%u)\n", idle_thread );

    return idle_thread;
}


// The thread manager maintains two registers for each processor.  There
// is a "current" register and a "next" register, holding the thread id
// of the currently executing thread, and the thread that the scheduler
// has determined should run next, respectively.
//
// Some basic functionality of the hthreads require the current thread
// register to be populated.  This include mutex operations, which are
// used in turn by malloc, which is used by _setup_thread.
void _init_thread_register(hthread_t thread_id)
{
    // Add the thread to the queue; it will be in the next thread reg.
    _add_thread(thread_id);

    // Move the thread from the next thread reg. to the current reg.
    _next_thread();
}


hthread_t _allocate_thread(void)
{
    Huint thread_status = _create_detached();

    if(has_error(thread_status))
    {
        TRACE_PRINTF(TRACE_FATAL, TRACE_INIT, "Failed to allocate thread.\n" );
        while(1);
    }

    return extract_id(thread_status);
}


void _cpu0_is_ready(void)
{
    volatile Huint *flag_reg = (Huint*)(READY_REG);
    *flag_reg = CPU_0_READY;
}


void _check_cpu0_is_ready(void)
{
    volatile Huint *flag_reg = (Huint*)(READY_REG);
    if(*flag_reg != CPU_0_READY)
    {
        TRACE_PRINTF(TRACE_FATAL, TRACE_INIT, "CPU0 is not ready!\n");
        while(1);
    }
}


void _wait_for_cpu1(void)
{
    int i;

    volatile Huint *flag_reg = (Huint*)(READY_REG);
    TRACE_PRINTF(TRACE_INFO, TRACE_INIT, "CPU0 waiting for CPU1...\n");
    while(*flag_reg != CPU_1_READY)
        for(i = 0; i < 10000; i++);
    TRACE_PRINTF(TRACE_INFO, TRACE_INIT, "CPU0 received ready from CPU1.\n");
}


void _cpu1_is_ready(void)
{
    volatile Huint *flag_reg = (Huint*)(READY_REG);
    *flag_reg = CPU_1_READY;
}


void reset_hardware(void)
{
    _reset_hardware();
}
