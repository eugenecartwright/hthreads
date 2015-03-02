/*

   Processor-Based HW Thread Library

   */

#include "proc_hw_thread.h"
#include "pvr.h"

// ***********************************************************
// Utility Calls
// ***********************************************************

void initialize_interface( proc_interface_t * iface, int * baseAddr)
{
    // Initialize all interface pointers
    iface->base_reg     = (int*)baseAddr;
    iface->tid_reg      = (int*)(baseAddr + 0);
    iface->sta_reg      = (int*)(baseAddr + 2);
    iface->cmd_reg      = (int*)(baseAddr + 3);
    iface->arg_reg      = (int*)(baseAddr + 4);
    iface->res_reg      = (int*)(baseAddr + 5);
    iface->fcn_reg      = (int*)(baseAddr + 6);

    return;
}

void wait_for_reset_command( proc_interface_t * iface)
{
    while(*(iface->cmd_reg) != RESET_COMMAND);
    return;
}

void wait_for_go_command( proc_interface_t * iface)
{
    while(*(iface->cmd_reg) != GO_COMMAND);

    // Reset command register
    *(iface->cmd_reg) = 0;
    return;
}

// ***********************************************************
// System Calls
// ***********************************************************

void proc_hw_thread_exit( proc_interface_t * iface, void * ret)
{
    volatile int * cmd;
    int status;   

    // Setup return value
    *(iface->res_reg) = (int)ret;

    cmd = (int*)(encode_cmd(*(iface->tid_reg),HT_CMD_EXIT_THREAD));
    status = *cmd;
}

void proc_hw_mutex_lock( proc_interface_t * iface, int lock_number)
{
    volatile int * cmd;
    int status;   

    cmd = (int*)mutex_cmd( HT_MUTEX_LOCK, *(iface->tid_reg), lock_number );
    status = *cmd;

    // Check to see if lock was successful
    if( status == HT_MUTEX_BLOCK )
    {
        // Block until go command comes in
        wait_for_go_command(iface);
    }
    // Got the lock!
    return;
}

void proc_hw_mutex_unlock( proc_interface_t * iface, int lock_number)
{
    volatile int * cmd;
    int status;   

    cmd = (int*)mutex_cmd( HT_MUTEX_UNLOCK, *(iface->tid_reg), lock_number );
    status = *cmd;
}

void* _bootstrap_thread( proc_interface_t * iface, thread_start_t func, void * arg )
{
    void *ret;

    // Invoke  the start function and grab the return value
    ret = func( arg );

    // Exit the thread using the return value
    proc_hw_thread_exit(iface, ret );

    // This statement should never be reached
    return 0;
}

void hthread_mutex_lock( int lock_number)
{
    volatile int * cmd;
    int status;
    proc_interface_t iface;
    int hwti_base;

    // Form proc_interface_t from PVR register
    getpvr(1,hwti_base);
    initialize_interface(&iface, (int*)hwti_base);

    cmd = (int*)mutex_cmd( HT_MUTEX_LOCK, *(iface.tid_reg), lock_number );
    status = *cmd;

    // Check to see if lock was successful
    if( status == HT_MUTEX_BLOCK )
    {
        // Block until go command comes in
        wait_for_go_command(&iface);
    }
    // Got the lock!
    return;
}

void hthread_mutex_unlock(int lock_number)
{
    volatile int * cmd;
    int status;   

    // Form proc_interface_t from PVR register
    proc_interface_t iface;
    int hwti_base;
    getpvr(1,hwti_base);
    initialize_interface(&iface, (int*)hwti_base);

    cmd = (int*)mutex_cmd( HT_MUTEX_UNLOCK, *(iface.tid_reg), lock_number );
    status = *cmd;
}
