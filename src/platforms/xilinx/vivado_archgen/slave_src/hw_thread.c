/*
   Main nano-kernel application
   Originally written by Jason Agron
   Modified by Eugene Cartwright
   */

#include "proc_hw_thread.h"
#include "pvr.h"
#include "mb_interface.h"
#include "xparameters.h"


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
   
   // Disable data cache and enable instruction cache
   microblaze_invalidate_icache();
   microblaze_enable_icache();
   microblaze_invalidate_dcache();
   microblaze_disable_dcache();

   // Grab CPU ID
   getpvr(0, cpu_id);

   // Set initial value for last accelerator used    
   initialize_interface(&hwti,(int*)(hwti_base));

   // Set this local variable to keep track of "previous"
   // last used accelerator
   prev_last_used_accelerator = NO_ACC;
   
   // Reset last used accelerator
   *(hwti.last_used_accelerator) = NO_ACC;
   
   // Clear out the first and last used accelerator pointers.
   *(hwti.first_used_ptr) = 0;
   *(hwti.last_used_ptr) = 0;


   while(1) {
      // Clear out all counters
      *(hwti.acc_hw_counter) = 0;
      *(hwti.acc_sw_counter) = 0;
      *(hwti.acc_pr_counter) = 0;
   
      // Reset first used accelerator
      *(hwti.first_used_accelerator) = NO_ACC;

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
