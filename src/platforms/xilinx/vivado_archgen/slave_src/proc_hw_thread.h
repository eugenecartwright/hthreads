/*

   Processor-Based HW Thread Library

   */

#ifndef PROC_HW_THREAD_H
#define PROC_HW_THREAD_H

#include <xparameters.h>

#define HTHREADS_TIMER_BASE         XPAR_TMRCTR_0_BASEADDR
#define TIMER_COUNTER_OFFSET        (0x8)
#define TIMER1_OFFSET               (0x10)

#define HTHREADS_TIMER0             (HTHREADS_TIMER_BASE)
#define HTHREADS_TIMER1             (HTHREADS_TIMER_BASE + TIMER1_OFFSET)
#define HTHREADS_TIMER_DATA_HI      (HTHREADS_TIMER1 + TIMER_COUNTER_OFFSET)
#define HTHREADS_TIMER_DATA_LO      (HTHREADS_TIMER0 + TIMER_COUNTER_OFFSET)

#define NO_ACC             (-1)

typedef long long arch_clock_t;
typedef arch_clock_t hthread_time_t;

/**
 * This struct allows us to treat the 64-bit timer value as an array of
 * 32-bit values, for ease of use.
 */
typedef union {
   arch_clock_t    time;
   unsigned int help[2];
} arch_clock_helper;

/**
   * Get the high 32 bits from the timer.
    */
static inline unsigned int timer_get_hi()
{
       return *(volatile unsigned int*)(HTHREADS_TIMER_DATA_HI);
}

/**
 * Get the low 32 bits from the timer.
 */
static inline unsigned int timer_get_lo()
{
       return *(volatile unsigned int*)(HTHREADS_TIMER_DATA_LO);
}

/**
 * Get a 64-bit value that counts the number of clock ticks since startup.
 */
static inline arch_clock_t _arch_get_time(void)
{
   arch_clock_helper d;

   // Because we can't get the low and high bits as a single operation,
   // the low value may have rolled over since we got the high value.
   // Check the high value to make sure it hasn't changed, and try
   // again if it has.
   // Watch out for endianness! -Eugene
   do
   {
      d.help[1] = timer_get_hi();
      d.help[0] = timer_get_lo();
   } while( d.help[1] != timer_get_hi() );

   return d.time;
}

#define hthread_time_get()          _arch_get_time()

// Used to keep track of last used accelerator
unsigned int prev_last_used_accelerator;

//-----------------//
//      PR Flag    //
//-----------------//
#define PR_FLAG             (0x1)

// *******************************************
// Thread Manager Functions
// *******************************************
#define MANAGER_BASEADDR   XPAR_HTHREAD_CORE_AXI_THREAD_MANAGER_0_BASEADDR
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
#define SYNCH_BASEADDR   XPAR_HTHREAD_CORE_AXI_SYNC_MANAGER_0_BASEADDR

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

// Mutex type attributes
#define HTHREAD_MUTEX_FAST_NP                   0
#define HTHREAD_MUTEX_RECURSIVE_NP              1
#define HTHREAD_MUTEX_ERRORCHECK_NP             2
#define HTHREAD_MUTEX_DEFAULT                   HTHREAD_MUTEX_FAST_NP

// Mutex initializer
#define HTHREAD_MUTEX_INITIALIZER               {}
#define HTHREAD_RECURSIE_MUTEX_INITIALIZER_NP   {}
#define HTHREAD_ERRORCHECK_MUTEX_INITIALIZER_NP {}

/** \internal
  * \brief  An identifier which marks the highest mutex type value.
  *
  * This definition provides an upper bound for the mutex type. When
  * the function ::hthread_mutexattr_settype is call it will check that the
  * mutex type is an integer between 0 and the value defined here.
  */
#define HTHREAD_MUTEX_MAX_NP    2

/** \brief The mutex object structure.
  *
  * This structure represents a mutex object which can be used in the
  * hthread_mutex_lock and hthread_mutex_unlock functions. However,
  * the mutex must be initialized with a call to the function
  * hthread_mutex_init before either locking or unlocking the mutex.
  *
  * Typically, to create and use a mutex the following process will be taken:
  *     - A mutex attribute object is created and setup
  *         -# A new ::hthread_mutexattr_t structure is allocated.
  *         -# The mutex attribute object is initialized with a call to the
  *             function ::hthread_mutexattr_init.
  *         -# The mutex type is set by calling the function
  *             ::hthread_mutexattr_settype with the desired mutex kind.
  *         -# The mutex number is set by calling the function
  *             ::hthread_mutexattr_setnum with the desired mutex number.
  *     - A mutex object is created and setup
  *         -# A new ::hthread_mutex_t structure is allocated.
  *         -# The mutex object is initialized with a call to the function
  *             ::hthread_mutex_init using the mutex attribute object
  *             allocated and setup previously.
  *         -# The mutex object is used in calls to ::hthread_mutex_lock and
  *             ::hthread_mutex_unlock.
  *     - The mutex attribute object and mutex object are cleaned up
  *         -# The mutex attribute object is destroyed with a call to the
  *             function ::hthread_mutexattr_destroy. This step can be done
  *             any time so long as the mutex attribute object
  *             will not be used in any other calls to hthread_mutex_init.
  *         -# The mutex object is destroyed with a call to the function
  *             ::hthread_mutex_destroy.
  */
typedef struct
{
    /** \internal
      * \brief  The mutex number which is used during the locking and
      *         unlocking process.
      *
      * This structure member keeps track of the mutex number which is used
      * during the locking and unlocking process. The default value for the
      * mutex number is 0 (meaning mutex 0 is locked and unlocked by default)
      * but can be set by the user program using the function
      * ::hthread_mutexattr_setnum.
      */
    unsigned int   num;

    /** \internal
      * \brief  The mutex type which is used during the locking and
      *         unlocking process.
      *
      * This structure member identifies which mutex type is used during the
      * locking and unlocking process. The default type is
      * HTHREAD_MUTEX_BLOCK_NP which means the blocking mutexes are used
      * be default. The type can be set using the function
      * ::hthread_mutexattr_settype.
      */
    unsigned int   type;
} hthread_mutex_t;

/** \brief The mutex attribute object structure.
  *
  * This structure represents a mutex attribute object which is used when
  * calling the function hthread_mutex_init. A call to the function
  * hthread_mutexattr_init must be done before the mutex attribute object
  * is used in any other function.
  *
  * Typically, to create and use a mutex the following process will be taken:
  *     - A mutex attribute object is created and setup
  *         -# A new ::hthread_mutexattr_t structure is allocated.
  *         -# The mutex attribute object is initialized with a call to the
  *             function ::hthread_mutexattr_init.
  *         -# The mutex type is set by calling the function
  *             ::hthread_mutexattr_settype with the desired mutex kind.
  *         -# The mutex number is set by calling the function
  *             ::hthread_mutexattr_setnum with the desired mutex number.
  *     - A mutex object is created and setup
  *         -# A new ::hthread_mutex_t structure is allocated.
  *         -# The mutex object is initialized with a call to the function
  *             ::hthread_mutex_init using the mutex attribute object
  *             allocated and setup previously.
  *         -# The mutex object is used in calls to ::hthread_mutex_lock and
  *             ::hthread_mutex_unlock.
  *     - The mutex attribute object and mutex object are cleaned up
  *         -# The mutex attribute object is destroyed with a call to the
  *             function ::hthread_mutexattr_destroy. This step can be done
  *             any time so long as the mutex attribute object
  *             will not be used in any other calls to hthread_mutex_init.
  *         -# The mutex object is destroyed with a call to the function
  *             ::hthread_mutex_destroy.
  */
typedef struct
{
    /** \internal
      * \brief  The mutex number which is used during the locking and
      *         unlocking process.
      *
      * This structure member keeps track of the mutex number which is used
      * during the locking and unlocking process. The default value for the
      * mutex number is 0 (meaning mutex 0 is locked and unlocked by default)
      * but can be set by the user program using the function
      * ::hthread_mutexattr_setnum.
      */
    unsigned int   num;

    /** \internal
      * \brief  The mutex type which is used during the locking and
      *         unlocking process.
      *
      * This structure member identifies which mutex type is used during the
      * locking and unlocking process. The default type is
      * HTHREAD_MUTEX_BLOCK_NP which means the blocking mutexes are used
      * be default. The type can be set using the function
      * ::hthread_mutexattr_settype.
      */
    unsigned int   type;
} hthread_mutexattr_t;
/*
int hthread_mutexattr_init( hthread_mutexattr_t* );
int hthread_mutexattr_destroy( hthread_mutexattr_t* );
int hthread_mutexattr_setnum( hthread_mutexattr_t*, unsigned int );
int hthread_mutexattr_getnum( hthread_mutexattr_t*, unsigned int* );
int hthread_mutexattr_settype( hthread_mutexattr_t*, unsigned int );
int hthread_mutexattr_gettype( hthread_mutexattr_t*, int* );

int hthread_mutex_init( hthread_mutex_t*, const hthread_mutexattr_t* );
int hthread_mutex_lock( hthread_mutex_t* );
int hthread_mutex_trylock( hthread_mutex_t* );
int hthread_mutex_unlock( hthread_mutex_t* );
int hthread_mutex_destroy( hthread_mutex_t*);
int hthread_mutex_getnum( hthread_mutex_t* );
*/

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
    
    // Pointer to "virtual" utilized register
    volatile int * uti_reg ;

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

    // Pointer to "virtual" stack base register
    volatile int * stack_ptr ;

    // Pointer to "virtual" global context base register
    volatile int * gctx_ptr ;

    // Pointer to "virtual" arch-specific context table register
    volatile int * arch_ctx_ptr ;

    // Pointer to "virtual" bootstrap function ptr
    volatile int * bstrap_ptr ;
    
    // Pointer to "virtual" execution time field
    volatile hthread_time_t * execution_time ;
    
    // Pointer to "virtual" first_used_accelerator field
    volatile int * first_used_accelerator;

    // Pointer to "virtual" first_used_ptr field
    volatile int * first_used_ptr;
    
    // Pointer to "virtual" last_used_accelerator field
    volatile int * last_used_accelerator;
    
    // Pointer to "virtual" last_used_ptr field
    volatile int * last_used_ptr;
    
    // Pointer to "virtual" tuning table field
    volatile int * tuning_table_ptr;

    // Pointer to "virtual" accelerator flags field
    volatile int * has_PR;
    
    // Pointer to "virtual" accelerator hardware counter field
    volatile int * acc_hw_counter;
    
    // Pointer to "virtual" accelerator software counter field
    volatile int * acc_sw_counter;
    
    // Pointer to "virtual" Accelerator PR counter field
    volatile int * acc_pr_counter;

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
int proc_hw_thread_exit( proc_interface_t * iface, void * ret);
void proc_hw_mutex_lock( proc_interface_t * iface, int lock_number);
void proc_hw_mutex_unlock( proc_interface_t * iface, int lock_number);
void hthread_mutex_lock( int lock_number);
void hthread_mutex_unlock( int lock_number);

// *****************************************************************************
// Bootstrap definitions
// *****************************************************************************
typedef void * (*thread_start_t)(void*);


void * _bootstrap_thread(
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

    /** \brief  Execution results of a thread. */
    hthread_time_t      execution_time;
} hthread_thread_t;


#endif /* PROC_HW_THREAD_H */
