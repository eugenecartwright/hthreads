/*
   Processor-Based Factorial Thread

   */

#include "proc_hw_thread.h"
#include "pvr.h"
#include "mb_interface.h"

// Thread argument definition
typedef struct
{
    int * array;
    int length;
    int max_value;
    int min_value;

    int * hist;
    int num_bins;
} targ_t;

void * histogram_thread (void * arg)
{
    targ_t * targ;
    int i = 0;
    int bin = 0;
    int val = 0;
    int times = 5;
    int accum = 0;
    int tcount = 0;
    for (tcount = 0; tcount < times; tcount++)
    {    
	    // Create a pointer to thread argument
	    targ = (targ_t *)arg;
	
	    // Calculate histogram
	    int diff = (targ->max_value - targ->min_value);
	
	    //int divider = (targ->max_value - targ->min_value) / targ->num_bins;
	    int divider = (diff / targ->num_bins) + (targ->num_bins - (diff % targ->num_bins));
	    for (i = 0; i < targ->length; i++)
	    {
	        // Extract array value
	        val = targ->array[i];
	
	        // Calculate bin number
	        bin = val / divider;
	
	        // Update histogram
	        targ->hist[bin] = targ->hist[bin] + 1;
            accum = accum + diff;
	    }
    }
    return (void*)(accum);
}


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

typedef struct
{
    int x;
    int a;int b;
    char c;
    int y;
} add_two_t;

void* add_two_thread(void * arg)
{
    add_two_t *targ = (add_two_t*)(arg);
    int res;

    res = targ->x + targ->y;
    xil_printf("arg address = 0x%08x\r\n",arg);
    xil_printf("%d + %d = %d\r\n",targ->x, targ->y, res);
    return (void*)res;
}

typedef void (*FuncPointer)(void);

#define mtgpr(rn, v)    ({  __asm__ __volatile__ (      \
                             "or\t" stringify(rn) ",r0,%0\n" :: "d" (v)    \
                            );                          \
                         })


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

        // Setup r20 for thread
        mtgpr(r20, *(hwti.fcn_reg));

       // Boostrap thread
		 //  * Pull out thread argument, and thread start function
       _bootstrap_thread(&hwti, *(hwti.fcn_reg), *(hwti.arg_reg));
       //_bootstrap_thread(&hwti, histogram_thread, *(hwti.arg_reg));
		 
    }
    return 0;
}
