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
    iface->uti_reg      = (int*)(baseAddr + 1);
    iface->sta_reg      = (int*)(baseAddr + 2);
    iface->cmd_reg      = (int*)(baseAddr + 3);
    iface->arg_reg      = (int*)(baseAddr + 4);
    iface->res_reg      = (int*)(baseAddr + 5);
    iface->fcn_reg      = (int*)(baseAddr + 6);

    // Note, entry 7 is currently unused

    // Extra hetero pointers
    iface->stack_ptr    = (int*)(baseAddr + 8);
    iface->gctx_ptr     = (int*)(baseAddr + 9);
    iface->arch_ctx_ptr = (int*)(baseAddr + 10);
    iface->bstrap_ptr   = (int*)(baseAddr + 11);

    // 64-bit field
    iface->execution_time   = (hthread_time_t *)(baseAddr + 12);

    iface->first_used_accelerator   = (int*)(baseAddr + 14);
    iface->first_used_ptr           = (int*)(baseAddr + 15);
    iface->last_used_accelerator    = (int*)(baseAddr + 16);
    iface->last_used_ptr            = (int*)(baseAddr + 17);
    iface->tuning_table_ptr         = (int*)(baseAddr + 18);
    iface->has_PR                   = (int*)(baseAddr + 19);
    iface->acc_hw_counter           = (int*)(baseAddr + 20);
    iface->acc_sw_counter           = (int*)(baseAddr + 21);
    iface->acc_pr_counter           = (int*)(baseAddr + 22);

    return;
}

void delay()
{
    int x = 0;
    int y = 10 + x;
	 int z = 0;
	 
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
    // Wait for go Command - Polling the V-HWTI
    while(*(iface->cmd_reg) != GO_COMMAND);
    
    // Clear out first used accelerator in case
    // this thread function I am about to run doesn't
    // use an accelerator.
    *(iface->first_used_accelerator) = NO_ACC;    

    // Get timestamp to for beginning of execution
    *(iface->execution_time) = (hthread_time_t) 0;
    *(iface->execution_time) =  hthread_time_get();

    // Reset command register
    *(iface->cmd_reg) = 0;

    return;
}

// ***********************************************************
// System Calls
// ***********************************************************

int proc_hw_thread_exit( proc_interface_t * iface, void * ret)
{
    volatile int * cmd;
    int status;  

    // Store execution time - 
    hthread_time_t stop = hthread_time_get();
    hthread_time_t start = *(iface->execution_time);
    *(iface->execution_time) = stop-start;

    // Return a value (if any) first
    if(ret != NULL) 
    {
        // Setup return value in V-HWTI
        *(iface->res_reg) = (int)ret;
        
        // Place return value in global TCB array for safe-keeping 
        // (V-HWTI return reg is too volatile when using dynamic APIs)
        // IMPORTANT - as V-HWTI may be re-used by a smart function, then move return value
        //to global data struct "threads" retval location
        volatile hthread_thread_t * tcb_array = (hthread_thread_t*) *(iface->gctx_ptr);
        Huint tid = *(iface->tid_reg);
        tcb_array[tid].retval = ret;
    }

    // If there was an accelerator used, we need to update the
    // first use accelerator for this particular function it ran.
    // The host processor is responsible for writing the proper address.
    if (*(iface->first_used_accelerator) != NO_ACC) {
        volatile unsigned int * first_used_acc = (unsigned int *) *(iface->first_used_ptr);
        if (first_used_acc != NULL)
            *first_used_acc = *(iface->first_used_accelerator);
    }

    // We should also update the last used accelerator, checking to see
    // if the previous last used accelerator is equal to the currently
    // loader accelerator.
    if (*(iface->last_used_accelerator) != prev_last_used_accelerator) {

        // Update the last used accelerator
        volatile unsigned int * last_used_acc = (unsigned int *) *(iface->last_used_ptr);
        if (last_used_acc != NULL) {
            *last_used_acc = *(iface->last_used_accelerator);
        }

        // Update the previous_last_used_accelerator to current
        prev_last_used_accelerator = *(iface->last_used_accelerator);
    }

    // Perform hthread_exit() second
    cmd = (int*)(encode_cmd(*(iface->tid_reg),HT_CMD_EXIT_THREAD));
    status = *cmd;

    // Mark in the V-HWTI that this slave is free
    *(iface->uti_reg) = 0;

	 //xil_printf("Thread ID %d exit status = 0x%08x\r\n",*(iface->tid_reg), status);	
	 return status;
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
	 int status;

    // Invoke  the start function and grab the return value
    ret = func( arg );

    // Exit the thread using the return value
    status = proc_hw_thread_exit(iface, ret );

    // This statement should never be reached
    return (void *) status;
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
