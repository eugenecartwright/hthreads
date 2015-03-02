/*
   Processor-Based Hardware Thread

   */

#include "proc_hw_thread.h"


typedef void (*FuncPointer)(void);

int main()
{
    proc_interface_t hwti;

    while(1)
    {
	    // Setup interface
	    initialize_interface(&hwti,(int*)(0x10001000));

       // Wait to be "reset"
	    wait_for_reset_command(&hwti);

	    // Wait to be "started"
	    wait_for_go_command(&hwti);
		 
		 //xil_printf("Thread started (fcn @ 0x%08x), arg = 0x%08x!!!\r\n",*(hwti.fcn_reg), *(hwti.arg_reg));

       // Boostrap thread
       _bootstrap_thread(&hwti, *(hwti.fcn_reg), *(hwti.arg_reg));
    }
    return 0;
}
