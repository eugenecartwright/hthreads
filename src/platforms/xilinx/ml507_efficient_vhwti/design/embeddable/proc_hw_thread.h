/*

   Processor-Based HW Thread Library

   */

#ifndef PROC_HW_THREAD_H
#define PROC_HW_THREAD_H
 
// *******************************************
// Thread Manager Functions
// *******************************************
#define MANAGER_BASEADDR (0x11000000)
#define HT_CMD_EXIT_THREAD          0x07

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
                                (((th)&THREAD_TID_MASK)<<THREAD_TID_SHIFT)   |\
                                (((cd)&THREAD_CMD_MASK)<<THREAD_CMD_SHIFT))

#define extract_id(status)      (((status) >> THREAD_SHIFT) & THREAD_MASK)
#define extract_pri(status)     (((status) >> PRIOR_SHIFT) & PRIOR_MASK)
#define extract_cpuid(status)   (((status) >> CPUID_SHIFT) & CPUID_MASK)

// *******************************************
// Synch Manager Functions
// *******************************************
#define SYNCH_BASEADDR (0x13000000)
#define KIND_BITS           2
#define COUNT_BITS          8
#define COMMAND_BITS        3
#define THREAD_BITS             8
#define MUTEX_BITS              6

#define HT_MUTEX_LOCK       0
#define HT_MUTEX_UNLOCK     1
#define HT_MUTEX_TRY        2
#define HT_MUTEX_OWNER      3
#define HT_MUTEX_KIND       4
#define HT_MUTEX_COUNT      5

#define HT_MUTEX_MID_SHIFT  2
#define HT_MUTEX_MID_MASK   ((1 << MUTEX_BITS) - 1)
#define HT_MUTEX_TID_SHIFT  (MUTEX_BITS + HT_MUTEX_MID_SHIFT)
#define HT_MUTEX_TID_MASK   ((1 << THREAD_BITS) - 1)
#define HT_MUTEX_CMD_SHIFT  (THREAD_BITS + HT_MUTEX_TID_SHIFT)
#define HT_MUTEX_CMD_MASK   ((1 << COMMAND_BITS) - 1)

#define MT_MUTEX_SUCCESS    0x00000000
#define HT_MUTEX_ERROR      0x80000000
#define HT_MUTEX_BLOCK      0x40000000

//#define HT_MUTEX_CNT_SHIFT  (32 - COUNT_BITS)
//#define HT_MUTEX_CNT_MASK   ((1 << COUNT_BITS) - 1)
//#define HT_MUTEX_KND_SHIFT  (32 - KIND_BITS)
//#define HT_MUTEX_KND_MASK   ((1 << KIND_BITS) - 1)
//#define HT_MUTEX_OWN_SHIFT  (32 - THREAD_BITS)
//#define HT_MUTEX_OWN_MASK   ((1 << THREAD_BITS) - 1)
#define HT_MUTEX_CNT_SHIFT  0
#define HT_MUTEX_CNT_MASK   0x000000FF
#define HT_MUTEX_KND_SHIFT  0
#define HT_MUTEX_KND_MASK   0x00000003
#define HT_MUTEX_OWN_SHIFT  0
#define HT_MUTEX_OWN_MASK   0x000000FF


#define mutex_cmd(c,t,m)    ((SYNCH_BASEADDR)                             |\
                             ((c&HT_MUTEX_CMD_MASK)<<HT_MUTEX_CMD_SHIFT)  |\
                             ((t&HT_MUTEX_TID_MASK)<<HT_MUTEX_TID_SHIFT)  |\
                             ((m&HT_MUTEX_MID_MASK)<<HT_MUTEX_MID_SHIFT))

#define mutex_kind(sta)     (((sta)>>HT_MUTEX_KND_SHIFT)&HT_MUTEX_KND_MASK)
#define mutex_count(sta)    (((sta)>>HT_MUTEX_CNT_SHIFT)&HT_MUTEX_CNT_MASK)
#define mutex_owner(sta)    (((sta)>>HT_MUTEX_OWN_SHIFT)&HT_MUTEX_OWN_MASK)
#define mutex_error(sta)    ((sta) != 0)


// *****************************************************************************
// Thread Interface Definitions
// *****************************************************************************
#define GO_COMMAND (0x1)
#define RESET_COMMAND (0x2)

typedef struct{
    // Pointer to "virtual" base address
    volatile int * base_reg ;

    // Pointer to "virtual" thread ID register
    volatile int * tid_reg ;

    // Pointer to "virtual" thread STATUS register
    volatile int * sta_reg ;

    // Pointer to "virtual" COMMAND register
    volatile int * cmd_reg ;

    // Pointer to "virtual" thread ARG register
    volatile int * arg_reg ;

    // Pointer to "virtual" thread RESULT register
    volatile int * res_reg ;

    // Pointer to "virtual" thread FUNCTION register
    volatile int * fcn_reg ;
} proc_interface_t;


// *****************************************************************************
// Utility Calls
// *****************************************************************************
void initialize_interface( proc_interface_t * iface, int * baseAddr);
void wait_for_go_command( proc_interface_t * iface);
void wait_for_reset_command( proc_interface_t * iface);

// *****************************************************************************
// System Calls
// *****************************************************************************
void proc_hw_thread_exit( proc_interface_t * iface, void * ret);
void proc_hw_mutex_lock( proc_interface_t * iface, int lock_number);
void proc_hw_mutex_unlock( proc_interface_t * iface, int lock_number);
void hthread_mutex_lock( int lock_number);
void hthread_mutex_unlock( int lock_number);

// *****************************************************************************
// Bootstrap definitions
// *****************************************************************************
typedef void * (*thread_start_t)(void*);


void * bootstrap_thread(
        proc_interface_t * iface,
        thread_start_t func,
        void * arg );

#endif /* PROC_HW_THREAD_H */
