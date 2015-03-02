/*

   Processor-Based HW Thread Library

   */

#include "proc_hw_thread.h"
#include "pvr.h"

// ***********************************************************
// Utility Calls
// ***********************************************************
void wait_for_go_command( proc_interface_t * iface)
{
    while((iface->cmd_reg) != GO_COMMAND);
	
    // Reset command register
    (iface->cmd_reg) = 0;
    return;
}

// ***********************************************************
// System Calls
// ***********************************************************

int proc_hw_thread_exit( proc_interface_t * iface, void * ret)
{
    volatile int * cmd;
    int status;   

    // Check if thread returns NULL value so we 
    // don't waste time copying a return value
    // we don't need
    if (ret != NULL)
    {

        // Setup return value in V-HWTI
        (iface->res_reg) = (int)ret;

        // Place return value in global TCB array for safe-keeping (V-HWTI return reg is too volatile when using dynamic APIs)
        // IMPORTANT - as V-HWTI may be re-used by a smart function, then move return value
        //to global data struct "threads" retval location
        volatile hthread_thread_t * tcb_array = (hthread_thread_t*) (iface->gctx_ptr);
        Huint tid = (iface->tid_reg);
        tcb_array[tid].retval = ret;
    }
    
    // IMPORTANT - set V-HWTI utilized field back to free!!!!!
    (iface->uti_reg) = 0;
    
    // Perform hthread_exit()
    cmd = (int*)(encode_cmd((iface->tid_reg),HT_CMD_EXIT_THREAD));
    status = *cmd;
    
    //xil_printf("Thread ID %d exit status = 0x%08x\r\n",*(iface->tid_reg), status);	
    return status;
}

void* _bootstrap_thread( proc_interface_t * iface, thread_start_t func, void * arg )
{
    void *ret;
	 int status;

     // Invoke  the start function and grab the return value
    ret = func( arg );

    // Exit the thread using the return value
    status = proc_hw_thread_exit(iface, ret );

    // This statement should never be reached
    return 0;
}
