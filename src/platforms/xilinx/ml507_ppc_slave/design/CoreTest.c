/* Test Bench for Hthreads Bootup 
   Modified from original file
   CoreTest.c  */
#include <stdio.h>
#include "xparameters.h"

#define NUM_TRIALS          1
// *******************************************************
// Hard-coded Address Definitions
// *******************************************************
#define MANAGER_BASEADDR        XPAR_THREAD_MANAGER_BASEADDR
#define SCHEDULER_BASEADDR      XPAR_SCHEDULER_BASEADDR
#define OKAY_VALUE              (0xDEADBEEF)
#define NUM_OF_SLAVES           (6)
#define CPUS_PER_BUS            (1)
#define EXTRA_BRAM              (0xE0000000)

volatile int * reset_reg = (int*)(XPAR_PLB_HTHREAD_RESET_CORE_0_BASEADDR);
volatile int * resp_reg = (int*)(XPAR_PLB_HTHREAD_RESET_CORE_0_BASEADDR + 0x04);
volatile int * tm_base = (int*)(MANAGER_BASEADDR);
volatile int * sched_base = (int*)(SCHEDULER_BASEADDR);
// *******************************************************

// *******************************************************
// HybridThread Definitions
// *******************************************************
#define SUCCESS				    (0)
#define FAILURE				    (-1)

#define read_reg(cmd)           (*(volatile unsigned int*)(cmd))
#define write_reg(reg,val)      ((*(volatile unsigned int*)(reg)) = val)

#define HT_CMD_CLEAR_THREAD         0x00
#define HT_CMD_JOIN_THREAD          0x01
#define HT_CMD_DETACH_THREAD        0x02
#define HT_CMD_READ_THREAD          0x03
#define HT_CMD_ADD_THREAD           0x04
#define HT_CMD_CREATE_THREAD_J      0x05
#define HT_CMD_CREATE_THREAD_D      0x06
#define HT_CMD_EXIT_THREAD          0x07
#define HT_CMD_NEXT_THREAD          0x08
#define HT_CMD_YIELD_THREAD         0x09
#define HT_CMD_DETACHED_THREAD      0x18
#define HT_CMD_CURRENT_THREAD       0x10
#define HT_CMD_QUE_LENGTH           0x12
#define HT_CMD_EXCEPTION_ADDR       0x13
#define HT_CMD_EXCEPTION_REG        0x14
#define HT_CMD_SOFT_START           0x15
#define HT_CMD_SOFT_STOP            0x16
#define HT_CMD_SOFT_RESET           0x17

#define HT_CMD_IS_QUEUED            0x19
#define HT_CMD_GET_SCHED_LINES      0x1A
#define HT_CMD_GET_CPUID            0x1F

#define ERR_SHIFT                   1
#define ERR_MASK                    0x00000007
#define ERR_BIT                     0x00000001

#define STATUS_SHIFT                1
#define STATUS_MASK                 0x00000007

#define THREAD_TID_SHIFT            2
#define THREAD_TID_MASK             0x000000FF

#define THREAD_CMD_SHIFT            10  
#define THREAD_CMD_MASK             0x0000001F

#define THREAD_SHIFT                1
#define THREAD_MASK                 0x000000FF

#define PRIOR_SHIFT                 4
#define PRIOR_MASK                  0x0000007F

#define PROCID_SHIFT                16
#define PROCID_MASK                 0x00000003

#define CPUID_SHIFT                 0
#define CPUID_MASK                  0x00000003

#define has_error(status)       ((status)&ERR_BIT)
#define extract_error(status)   (((status)>>ERR_SHIFT)&ERR_MASK)
#define encode_error(status)    (((status)<<ERR_SHIFT)|ERR_MASK)

#define encode_reg(reg)         encode_cmd( 0, reg )

#define encode_cmd(th,cd)       (MANAGER_BASEADDR                            |\
                                (((0x0)&PROCID_MASK)<<PROCID_SHIFT)|\
                                (((th)&THREAD_TID_MASK)<<THREAD_TID_SHIFT)   |\
                                (((cd)&THREAD_CMD_MASK)<<THREAD_CMD_SHIFT))

#define extract_id(status)      (((status) >> THREAD_SHIFT) & THREAD_MASK)
#define extract_pri(status)     (((status) >> PRIOR_SHIFT) & PRIOR_MASK)
#define extract_cpuid(status)   (((status) >> CPUID_SHIFT) & CPUID_MASK)

#define HT_ALREADY_EXITED               0x01
#define HT_DEFAULT_PRI                  0x40
#define HT_LOWEST_PRI                   0x7F
#define HT_CMD_SCHED_GETSCHEDPARAM      0x64
#define HT_CMD_SCHED_SETSCHEDPARAM      0x5C
#define HT_CMD_SCHED_CHECKSCHEDPARAM    0x68
#define HT_CMD_SCHED_HIGHPRI            0x58
#define HT_CMD_SCHED_ENTRY              0x60
#define HT_CMD_SCHED_PREEMPT            0x48
#define HT_CMD_SCHED_DEFPRI             0x4C
#define HT_CMD_SCHED_GET_IDLE_THREAD    0x50
#define HT_CMD_SCHED_SET_IDLE_THREAD    0x54
#define HT_CMD_SCHED_SYSCALL_LOCK       0x3C
#define HT_CMD_SCHED_CS_LOCK            0x40
#define HT_CMD_SCHED_MALLOC_LOCK        0x44

#define SCHED_PRI_SHIFT                 16
#define SCHED_PRI_MASK                  0x0000007F

#define SCHED_TID_SHIFT                 8
#define SCHED_TID_MASK                  0x000000FF

#define SCHED_CMD_SHIFT                 0
#define SCHED_CMD_MASK                  0x000000FF

#define sched_cmd(pr,th,cd) (SCHEDULER_BASEADDR |                          \
                            (((0x0)&PROCID_MASK)<<PROCID_SHIFT)| \
                            (((th)&SCHED_TID_MASK) << SCHED_TID_SHIFT)   | \
                            (((cd)&SCHED_CMD_MASK) << SCHED_CMD_SHIFT))
                            

static inline unsigned int _set_idle_thread( unsigned int id, unsigned int cpuid )
{
    unsigned int cmd;

    if (cpuid == 0 )
    {
        cmd = sched_cmd( 0, id, HT_CMD_SCHED_SET_IDLE_THREAD );
    }
    else
    {
        cmd = sched_cmd( 0, id, HT_CMD_SCHED_SET_IDLE_THREAD );
        cmd |= 0x00010000;
    }
    return read_reg( cmd );
}

static inline unsigned int _join_thread ( unsigned int id )
{
    unsigned int cmd;
    unsigned int res;

    cmd = encode_cmd( id,  HT_CMD_JOIN_THREAD );
    res = read_reg( cmd );

    return res;
}

static inline unsigned int _exit_thread ( unsigned int id )
{
    unsigned int cmd;
    unsigned int res;

    cmd = encode_cmd( id, HT_CMD_EXIT_THREAD );
    res = read_reg( cmd );

    return res;
}

static inline unsigned int _current_thread ( void )
{
    unsigned int cmd;
    unsigned int sta;

    cmd = encode_reg( HT_CMD_CURRENT_THREAD );
    sta = read_reg( cmd );

    if( has_error(sta) )
    {
        xil_printf("_next_thread operation ERROR: 0x%08x\r\n", sta);
    }
    
    return extract_id( sta );
}

static inline unsigned int _next_thread ( void )
{
    unsigned int cmd;
    unsigned int sta;

    cmd = encode_reg( HT_CMD_NEXT_THREAD );
    sta = read_reg( cmd );

    if( has_error(sta) )
    {
        xil_printf("_next_thread operation ERROR: 0x%08x\r\n", sta);
    }

    return extract_id( sta );
}

static inline void _run_sched( void )
{

    xil_printf("\tRun Sched......\r\n");
    unsigned int curr = _current_thread();
    unsigned int next = _next_thread();
    unsigned int new_curr = _current_thread();
    xil_printf("\tcurr tid ----->0x%08x\r\n", curr);
    xil_printf("\tnext tid ----->0x%08x\r\n", next);
    xil_printf("\tnew_curr tid ->0x%08x\r\n", new_curr);

    if (new_curr != next)
    {
        xil_printf("NEXT THREAD ERROR/BUS ERROR!\r\n");
    }

    // if next thread to run is same thread, return
    if( curr == next ) 
    {
        xil_printf("Curr == Next\r\n");
        return;
    }
    // otherwise, _switch_context
    else
    {
        return;
    }

}

static inline unsigned int _read_sched_status( unsigned int id )
{
	unsigned int cmd = sched_cmd( 0, id, HT_CMD_SCHED_ENTRY );
	return read_reg( cmd );
}

static inline void _decode_sched_status( unsigned int status )
{
    unsigned int   queued;
    unsigned int   next;
    unsigned int   prior;

    queued  = ((status >> 31) & 0x00000001);
    next    = ((status >> 23) & 0x000000FF);
    prior   = ((status >> 16) & 0x0000007F);

    xil_printf( "\tSched - (QUE=0x%2.2x) (NXT=0x%2.2x) (PRI=0x%2.2x)\r\n", queued, next, prior );
}

static inline void _start_hardware( void )
{
	unsigned int reg = encode_reg( HT_CMD_SOFT_START );
    write_reg( reg, 0x00000001 );       // V5 based systems have a newer reset architecture
}

static inline void _reset_hardware( void )
{
	unsigned int reg = encode_reg( HT_CMD_SOFT_RESET );
	
    // Reset TM
    write_reg( reg, 0x00000001 );       // V5 based systems should only use SOFTRESET for the V5

    // Reset all other cores...

    // Send resets to all cores
    *reset_reg = 0xF;

    // Wait for all cores to respond
    while(*resp_reg != 0xF);
	 xil_printf("**** Reset complete!\r\n");

    // De-assert resets to cores
    *reset_reg = 0x0;

	_start_hardware();
}

static inline unsigned int _add_thread( unsigned int id )
{
	unsigned int res;
    unsigned int cmd;

    cmd = encode_cmd( id, HT_CMD_ADD_THREAD);
	res = read_reg( cmd );

	return res;
}

static inline unsigned int _create_detached( void )
{
	unsigned int res;
	unsigned int cmd;

	cmd = encode_cmd( 0, HT_CMD_CREATE_THREAD_D);
	res = read_reg( cmd );

	return res;
}

static inline unsigned int _create_joinable( void )
{
	unsigned int res;
	unsigned int cmd;

	cmd = encode_cmd( 0, HT_CMD_CREATE_THREAD_J);
	res = read_reg( cmd );

	return res;
}


static inline unsigned int _get_schedparam( unsigned int id )
{
	unsigned int   cmd;
    
    cmd = sched_cmd( 0, id, HT_CMD_SCHED_GETSCHEDPARAM );
    return read_reg( cmd );
}

static inline unsigned int _check_schedparam( unsigned int id )
{
	unsigned int   cmd;
	unsigned int   res;
    
    cmd = sched_cmd( 0, id, HT_CMD_SCHED_CHECKSCHEDPARAM );
    res = read_reg( cmd );

	if ( has_error( res ) ) return FAILURE;
    else                    return SUCCESS;
}

static inline int _set_schedparam( unsigned int id, unsigned int pr )
{
    unsigned int   cmd;
    int    res;
        
    cmd = sched_cmd( 0, id, HT_CMD_SCHED_SETSCHEDPARAM );
    write_reg( cmd, pr );

    // After setting the sched_param, now check to see if it is valid
    res = _check_schedparam( id );
    if ( has_error( res ) )     return FAILURE;
    else                        return SUCCESS;
}

static inline unsigned int _get_highest_priority( void )
{
    unsigned int val;
    unsigned int cmd;
    
    cmd = sched_cmd( 0x00, 0x00, HT_CMD_SCHED_HIGHPRI );
    val = read_reg( cmd );

    return val;
}

static inline unsigned int _clear_thread( unsigned int id )
{
    unsigned int res;
    unsigned int cmd;

    cmd = encode_cmd( id, HT_CMD_CLEAR_THREAD );
    res = read_reg( cmd );

    return res;
}

int main(){
    xil_printf("SMP CoreTest.c\r\n");
    xil_printf("Simulating Hthreads Boot\r\n");
	microblaze_invalidate_icache();
	microblaze_disable_icache();
	microblaze_invalidate_dcache();
	microblaze_disable_dcache();
    int j;
    {
		// Reset all cores
	    _reset_hardware();
	
        volatile unsigned int * child_addr = 0;

#if 1        
        /*********Create Main Thread*********/
        xil_printf("Creating Main Thread\r\n");
	    unsigned int main_tid, main_sta, main_pr,main_dbg;
        
        // Create thread and extract TID
        //main_tid = extract_id(_create_joinable());
        main_tid = extract_id(_create_detached());
        xil_printf("\tMain TID: 0x%08x\r\n", main_tid);
        
        // Adjust scheduling parameter - Middle of the road priority
        main_sta = _set_schedparam(main_tid,HT_DEFAULT_PRI);
        xil_printf("\tSetting Sched Parameters....\r\n");
        xil_printf("\tMain TID STATUS: 0x%08x\r\n", main_sta);
            
        // Read back scheduling parameter
        main_pr = _get_schedparam(main_tid);
        xil_printf("\tMain TID SCHED PARAM: 0x%08x\r\n", main_pr);
        
        // Add thread to R2RQ
        main_sta = _add_thread(main_tid);
        xil_printf("\tAdding TID %d to R2RQ....\r\n",main_tid);
        xil_printf("\tMain TID STATUS: 0x%08x\r\n", main_sta);
        if ( has_error(main_sta) )
        {
	        main_sta = _read_sched_status(main_tid);
	        _decode_sched_status(main_sta);
        }

        // Move the main thread from the next threa reg. to the current reg.
        _next_thread();

        // Read scheduler debug register
        main_dbg = _get_highest_priority();
        xil_printf("\tScheduler Debug Register: 0x%0x8\r\n", main_dbg);
#endif        
#if 1        
        /*********Create Idle Thread*********/
        xil_printf("Creating Idle Thread\r\n");
	    unsigned int idle_tid, idle_sta, idle_pr,idle_dbg;
        
        // Create thread and extract TID
        idle_tid = extract_id(_create_detached());
        xil_printf("\tIdle TID: 0x%08x\r\n", idle_tid);
        
        // Adjust scheduling parameter - Middle of the road priority
        idle_sta = _set_schedparam(idle_tid,HT_LOWEST_PRI);
        xil_printf("\tSetting Sched Parameters....\r\n");
        xil_printf("\tIdle TID STATUS: 0x%08x\r\n", idle_sta);
            
        // Read back scheduling parameter
        idle_pr = _get_schedparam(idle_tid);
        xil_printf("\tIdle TID SCHED PARAM: 0x%08x\r\n", idle_pr);
        
        // Tell the hardware what the idle thread is
        _set_idle_thread(idle_tid, 0);
#endif

        for (j = 0; j < NUM_TRIALS; j++) 
        {
            /*********Create Child Thread*********/
            xil_printf("Creating Child Thread\r\n");
            unsigned int child_tid, child_sta, child_pr,child_dbg;
            // Setup address/priority
            child_addr = (unsigned int *)(0xB0001000) + 4;
            
            // Initialize value at address
            *child_addr = 0xCAFEBABE;
            
            // Create thread and extract TID
            child_tid = extract_id(_create_joinable());
            xil_printf("\tChild TID: 0x%08x\r\n", child_tid);
            
            // Adjust scheduling parameter - Hardware thread
            child_sta = _set_schedparam(child_tid,(unsigned int) child_addr);
            xil_printf("\tSetting Sched Parameters....\r\n");
            xil_printf("\tChild TID STATUS: 0x%08x\r\n", child_sta);
                
            // Read back scheduling parameter
            child_pr = _get_schedparam(child_tid);
            xil_printf("\tChild TID SCHED PARAM: 0x%08x\r\n", child_pr);
            
            // Add thread to R2RQ
            child_sta = _add_thread(child_tid);
            xil_printf("\tAdding TID %d to R2RQ....\r\n",child_tid);
            xil_printf("\tChild TID STATUS: 0x%08x\r\n", child_sta);
            if ( has_error(child_sta) )
            {
                child_sta = _read_sched_status(child_tid);
                _decode_sched_status(child_sta);
            }

            // Read scheduler debug register
            child_dbg = _get_highest_priority();
            xil_printf("\tScheduler Debug Register: 0x%0x8\r\n", child_dbg);
            
            /********** JOIN **********/
            xil_printf("\r\nNow Joining\r\n");
            unsigned int exited;
            main_sta = _join_thread( child_tid );
            exited = extract_error( main_sta );
            xil_printf("_join_thread( child_tid ) = 0x%08x\r\n", main_sta);
            
            if ( exited != HT_ALREADY_EXITED )
            {
                xil_printf("Initial _run_sched() (before switch to idle)\r\n");
               _run_sched();
            }

            // Call _run_sched to simulate a delay within child
            int i = 0;
            xil_printf("Calling _run_sched several more times\r\n");
            for (i=0; i< 5; i++)
            {
                _run_sched();
            }

            // Now exit from child
            xil_printf("Now exiting child....");
            _exit_thread( child_tid );
            xil_printf("Done\r\n");

            // Now call _run_sched to place main_tid back on Queue
            xil_printf("Final call to_run_sched();\r\n");
            _run_sched();
            xil_printf("Done\r\n");

            // Recycle child's tid
            xil_printf("Deallocate child_tid.....");
            _clear_thread( child_tid );
            xil_printf("Done\r\n");
        }

        xil_printf("FINISHED\r\n");
        xil_printf("*********************************************\r\n\r\n");

        // ******************************************
        // Now check slave processors "extra_bram"
        // ******************************************
        xil_printf("Now checking %d slave processor(s)\r\n", NUM_OF_SLAVES);
        int i = 0; volatile unsigned int * check = (unsigned int *) EXTRA_BRAM;
        for (i = 0; i < NUM_OF_SLAVES; i++) 
        {
            if(*check == OKAY_VALUE)  xil_printf("#%2d:ONLINE\r\n", i);
            else                      xil_printf("#%2d:OFFLINE\r\n", i);
            check = (unsigned int *) ((unsigned int) check + 0x100);
        }
        xil_printf("FINISHED\r\n");
    }
	return 0;
}
