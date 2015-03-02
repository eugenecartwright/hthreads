
#include <stdio.h>

// *******************************************************
// Hard-coded Address Definitions
// *******************************************************
#define MANAGER_BASEADDR        (0x11000000)
#define SCHEDULER_BASEADDR        (0x12000000)
#define SRAM_BASE                   (0x10000000)
volatile int * reset_reg = (int*)(0x84800000);
volatile int * resp_reg = (int*)(0x84800004);
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

    xil_printf( "\tSched - (QUE=0x%2.2x) (NXT=0x%2.2x) (PRI=0x%2.2x)\n",
            queued, next, prior );
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

int main(){
	//microblaze_disable_dcache();
    //while(1)  // Uncomment to run in an infinite loop
	{
		// Reset all cores
	    _reset_hardware();
	
	    unsigned int tid, sta, pr,dbg;
	
	    int count = 0;
        volatile unsigned int * addr = 0;
	    for (count = 0; count < 5; count++)
	    {    
            xil_printf("***********************\r\n");

            // Setup address/priority
            //addr = (unsigned int *)SRAM_BASE + count*4;     // HW thread
            //addr = (unsigned int *)(0xB0001000);                     // SW thread
				addr = (unsigned int *)(0xB0001000) +count*4;
            
            // Initialize value at address
            *addr = 0xCAFEBABE;

            // Create thread and extract TID
            tid = extract_id(_create_joinable());

            // Adjust scheduling parameter (priority)
            sta = _set_schedparam(tid,(unsigned int)addr);
            xil_printf("\tSET PR status = 0x%08x\r\n",sta);

            // Read back scheduling parameter
            pr = _get_schedparam(tid);

            // Add thread to R2RQ
            sta = _add_thread(tid);

            // Read scheduler debug register
            dbg = _get_highest_priority();

            // Display results
            xil_printf("DEBUG = 0x%08x\r\n",dbg);
            xil_printf("Create - TID = 0x%08x, PR = 0x%08x (STA = 0x%08x)\r\n",tid,pr,sta);
            xil_printf("\t *ADDR = 0x%08x\r\n",*addr);
	        sta = _read_sched_status(tid);
	        _decode_sched_status(sta);
	    }
    }
	return 0;
}
