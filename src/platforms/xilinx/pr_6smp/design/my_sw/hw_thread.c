/*
   Main nano-kernel application
   Originally written by Jason Agron
   Modified by Eugene Cartwright
   */

#include "proc_hw_thread.h"
#include "pvr.h"
#include "mb_interface.h"
#include "xparameters.h"

// Defines the amount of slave processors
// per bus. 
#define CPUS_PER_BUS    1

#define OKAY_VALUE      (0xDEADBEEF)
//#define LOCAL_TIMER     (0x82000000) --> defined elsewhere
#define EXTRA_BRAM      (0xE0000000)

#define CMD_RESET       (0xA)
#define RESET_REG       (0x100)

// Macro to load GPRs for the MB
#define mtgpr(rn, v)    ({  __asm__ __volatile__ (      \
                             "or\t" stringify(rn) ",r0,%0\n" :: "d" (v)    \
                            );                          \
                         })


int main() {
    proc_interface_t hwti;
	 
    // Get HWTI base address from user PVR register
    int hwti_base;
    unsigned char cpu_id; // only 8bits
    getpvr(1,hwti_base);
    
    // Disable instruction and data cache
    microblaze_invalidate_icache();
    microblaze_enable_icache();
    microblaze_invalidate_dcache();
	microblaze_disable_dcache();

    //Determine if uB is first on bus
    getpvr(0, cpu_id);

    // Timer pointers
    volatile unsigned long long * timer = (unsigned long long *) LOCAL_TIMER;
    volatile unsigned int * timer_reset = (unsigned int *) (LOCAL_TIMER + RESET_REG);

    // Reset timer
    *timer_reset = CMD_RESET;
    
    // Indicate to CoreTest.c running on host that this processor is running
    volatile unsigned int * check = (unsigned int *) EXTRA_BRAM;
    
    // assign cpus_per_bus offset
    check = (unsigned int *)
        ((unsigned int) check + ( ((unsigned int) cpu_id) *  0x100));
    
    // write OKAY_VALUE to common memory (extra_bram)
    *check = OKAY_VALUE;
	
    // Set initial value for last accelerator used    
    initialize_interface(&hwti,(int*)(hwti_base));

    // Set this local variable to keep track of "previous"
    // last used accelerator
    prev_last_used_accelerator = MAGIC_NUMBER;
    
    // Reset last used accelerator
    *(hwti.last_used_accelerator) = MAGIC_NUMBER;
    
    // Clear out accelerator Flags
    *(hwti.accelerator_flags) = (0x00000000);
    
    // Clear out the first and last used accelerator pointers.
    *(hwti.first_used_ptr) = 0;
    *(hwti.last_used_ptr) = 0;

    // Clear out all counters
    *(hwti.acc_hw_counter) = 0;
    *(hwti.acc_sw_counter) = 0;
    *(hwti.acc_pr_counter) = 0;

    // Nano-kernel loop...
    while(1) {
        // Setup interface
		// * Perform this upon each iteration, just in case the memory
		//   map for the MB-HWTI is corrupted.
	    initialize_interface(&hwti,(int*)(hwti_base));

	    // Wait to be "started"
	    wait_for_go_command(&hwti);

        // Setup r20 for thread, this can be used to enforce -fPIC (Position-independent code) for the MB
        // (r20 is used as part of the GOT, to make things PC-relative)
        mtgpr(r20, *(hwti.fcn_reg));

        // Boostrap thread (wraps up thread execution with a thread exit)
        //  * Pull out thread argument, and thread start function
        _bootstrap_thread(&hwti, *(hwti.fcn_reg), *(hwti.arg_reg));
		 
    }
    return 0;
}
