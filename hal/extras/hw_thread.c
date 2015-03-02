// ---------------------------
// MicroBlaze "Nano" Kernel
// ---------------------------
// Bootloop and thread loader
// for heterogeneous MPSoCs
// ---------------------------

#include "proc_hw_thread.h"
#include "pvr.h"
#include "mb_interface.h"

// --------------------------------------------------------------
// Example Thread Body Hard-Coded into MicroBlaze
// (Can be called direclty from within thread loader)
// --------------------------------------------------------------
int factorial(int arg)
{
    if ((arg == 0) || (arg == 1)){
        return 1;
    }   
    else
    {
        return arg*factorial(arg-1);
    }
}

void* factorial_thread(void * arg)
{
    int x = (int)arg;

    return (void*)factorial(x);
}


// --------------------------------------------------------------
// Thread Loader Code
// --------------------------------------------------------------

// Type of thread bodies
typedef void (*FuncPointer)(void);

// Assembly macro used for enabling position-independent code on MicroBlaze
// (r20 is used as PIC offset register)
#define mtgpr(rn, v)    ({  __asm__ __volatile__ (      \
                             "or\t" stringify(rn) ",r0,%0\n" :: "d" (v)    \
                            );                          \
                         })


// Main event loop
int main()
{

    proc_interface_t hwti;
	 

    // Get HWTI base address from user PVR register
    int hwti_base;
    getpvr(1,hwti_base);
	 

    // Enable instruction cache (reduce PLB load)
    microblaze_init_icache_range(0, 8192);
    microblaze_enable_icache();

    while(1)
    {
	   
        // Setup interface	
        // * Perform this upon each iteration, just in case the memory
        //   map for the MB-HWTI is corrupted.
        initialize_interface(&hwti,(int*)(hwti_base));

        // Wait to be "reset"
        // -- NOTE: Ignore reset as it has no meaning to the MB-HWTI
        //          and it seems causes a race, as the controlling processor
        //          sends a reset, immediately followed by a "go" command.  Therefore
        //          the "reset" command can be missed.
        //wait_for_reset_command(&hwti);

        // Wait to be "started"
        wait_for_go_command(&hwti);
		//xil_printf("Thread started (fcn @ 0x%08x), arg = 0x%08x!!!\r\n",*(hwti.fcn_reg), *(hwti.arg_reg));

        // Setup r20 for thread (only needed for PIC code, i.e. print-related functions)
        mtgpr(r20, *(hwti.fcn_reg));


        // Boostrap thread
        //  * Pull out thread argument, and thread start function
        _bootstrap_thread(&hwti, *(hwti.fcn_reg), *(hwti.arg_reg));
        //_bootstrap_thread(&hwti, factorial_thread, *(hwti.arg_reg));  // Use this when hard-coding functionality
		
    }

    return 0;
}
