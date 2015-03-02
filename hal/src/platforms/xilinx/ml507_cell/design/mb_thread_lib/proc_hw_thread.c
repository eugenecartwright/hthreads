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

void delay()
{
    int x;
    int y = 10 + x;
	 int z;
	 
	 getpvr(1,z);
	 
    //for (x = 0; x< (1000000); x++)
    for (x = 0; x < z; x++)
    {
        y+=x+z;
    }
}

void wait_for_reset_command( proc_interface_t * iface)
{
    while(*(iface->cmd_reg) != RESET_COMMAND)
	 {
		delay();
	 }
    return;
}

void wait_for_go_command( proc_interface_t * iface)
{
    while(*(iface->cmd_reg) != GO_COMMAND)
	 {
		//delay();
	 }

    // Reset command register
    *(iface->cmd_reg) = 0;
    return;
}

// ***********************************************************
// System Calls
// ***********************************************************

int hthread_self()
{
    int tid;

    // Retrieve HWTI pointer
    proc_interface_t iface;
    int hwti_base;

    // Form proc_interface_t from PVR register
    getpvr(1,hwti_base);
    initialize_interface(&iface, (int*)hwti_base);

    // Extract and return TID
    return *(iface.tid_reg);
}

void proc_hw_thread_exit( proc_interface_t * iface, void * ret)
{
    volatile int * cmd;
    int status;   

    // Setup return value
    *(iface->res_reg) = (int)ret;

    cmd = (int*)(encode_cmd(*(iface->tid_reg),HT_CMD_EXIT_THREAD));
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
