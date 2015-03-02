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

int hthread_self();

// *****************************************************************************
// Bootstrap definitions
// *****************************************************************************
typedef void * (*thread_start_t)(void*);

void * bootstrap_thread(
        proc_interface_t * iface,
        thread_start_t func,
        void * arg );

#endif /* PROC_HW_THREAD_H */
