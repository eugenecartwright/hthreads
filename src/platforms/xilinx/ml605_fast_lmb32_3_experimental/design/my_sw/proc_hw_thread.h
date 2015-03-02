/*

   Processor-Based HW Thread Library

   */

#ifndef PROC_HW_THREAD_H
#define PROC_HW_THREAD_H
 
#include "xparameters.h"

// *******************************************
// Thread Manager Functions
// *******************************************
#define MANAGER_BASEADDR            XPAR_THREAD_MANAGER_BASEADDR
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
    //volatile int * base_reg ;

    // Pointer to "virtual" thread ID register
    volatile int tid_reg ;
    
    // Pointer to "virtual" utilized register
    volatile int uti_reg ;

    // Pointer to "virtual" thread STATUS register
    volatile int sta_reg ;

    // Pointer to "virtual" COMMAND register
    volatile int cmd_reg ;

    // Pointer to "virtual" thread ARG register
    volatile int arg_reg ;

    // Pointer to "virtual" thread RESULT register
    volatile int res_reg ;

    // Pointer to "virtual" thread FUNCTION register
    volatile int fcn_reg ;

    volatile int unused;

    // Pointer to "virtual" stack base register
    volatile int stack_ptr ;

    // Pointer to "virtual" global context base register
    volatile int gctx_ptr ;

    // Pointer to "virtual" arch-specific context table register
    volatile int arch_ctx_ptr ;

    // Pointer to "virtual" bootstrap function ptr
    volatile int bstrap_ptr ;

} proc_interface_t;


// *****************************************************************************
// Utility Calls
// *****************************************************************************
void wait_for_go_command( proc_interface_t * iface);

// *****************************************************************************
// System Calls
// *****************************************************************************
int proc_hw_thread_exit( proc_interface_t * iface, void * ret);

// *****************************************************************************
// Bootstrap definitions
// *****************************************************************************
typedef void * (*thread_start_t)(void*);


void * bootstrap_thread(
        proc_interface_t * iface,
        thread_start_t func,
        void * arg );

/** \brief  An unsigned 32-bit integer value.  */
typedef unsigned int        Huint;

typedef enum
{
     /** \brief  The boolean value false used within the hthreads API. */
     Hfalse  = 0,
         
     /** \brief  The boolean value true used within the hthreads API. */     
     Htrue   = 1    
} Hbool;

/** \internal
  * \brief	The internal structure used to keep track of all threads.
  *
  * This structure is the structure used internally to keep track of
  * all of the threads in the system. The "threads" which are used by
  * user applications are really just indicies into an array of
  * hthread_thread_t structures.
  */
typedef struct
{
	/** \brief	If this value is true then the thread has been created but
	  *			has never been run.
	  */
	Hbool				newthread;

    /** \brief  The return value of a thread.
      */
    void*               retval;

    /** \brief  The architecture dependent context structure */
	void*	            context;

	/** \brief	A pointer to the stack used by this tread. */
    void                *stack;

    /** \brief  The size of the stack that this thread contains */
    Huint               stacksize;

    /** \brief  A value indicating if the threads is a hardware thread */
    Huint               hardware;
} hthread_thread_t;

#endif /* PROC_HW_THREAD_H */
