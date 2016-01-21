/** \internal
  * \file       htime.h
  * \brief      The definition of Hthreads time grabbing routines.
  *
  * \author     Eugene Cartwright <eugene@uark.edu>
  *
  * Based on earlier work by Wesley Peck and Seth Warn
  *
  * This file defines the architecture-specific interface to a 64-bit
  * cycle counter.  Because the MicroBlaze has no such counter, this is
  * a separate component in MB-based hthreads systems.
  */

#ifndef _HYBRID_THREADS_MBLAZE_TIME_H_
#define _HYBRID_THREADS_MBLAZE_TIME_H_

#include <hthread.h>
#include <config.h>

#ifndef CLOCKS_PER_SEC
#define CLOCKS_PER_SEC  CPU_CLOCK_HZ
#endif

// Base address of hthreads timer core
#define HTHREADS_TIMER_BASE XPAR_TMRCTR_0_BASEADDR

// Register offsets (in bytes) for timer core
#define  CONTROL_REGISTER_OFFSET    (0x0)
#define  TIMER_LOAD_OFFSET          (0x4)
#define  TIMER_COUNTER_OFFSET       (0x8)
#define  TIMER1_OFFSET              (0x10)


// Register definitions for timer core
#define HTHREADS_TIMER0             (HTHREADS_TIMER_BASE)
#define HTHREADS_TIMER1             (HTHREADS_TIMER_BASE + TIMER1_OFFSET)
#define HTHREADS_TIMER0_CONTROL     (HTHREADS_TIMER0 + CONTROL_REGISTER_OFFSET)
#define HTHREADS_TIMER1_CONTROL     (HTHREADS_TIMER1 + CONTROL_REGISTER_OFFSET)
#define HTHREADS_TIMER0_LOAD        (HTHREADS_TIMER0 + TIMER_LOAD_OFFSET)
#define HTHREADS_TIMER1_LOAD        (HTHREADS_TIMER1 + TIMER_LOAD_OFFSET)

#define HTHREADS_TIMER_DATA_HI       (HTHREADS_TIMER1 + TIMER_COUNTER_OFFSET)
#define HTHREADS_TIMER_DATA_LO       (HTHREADS_TIMER0 + TIMER_COUNTER_OFFSET)

typedef struct {
   Huint MDT:1;   // Timer Mode
   Huint UDT:1;   // Up/Down Count
   Huint GENT:1;  // Enable External Generate Signal
   Huint CAPT:1;  // Enable External Capture Trigger
   Huint ARHT:1;  // Auto Reload/Hold
   Huint LOAD:1;  // Load Timer
   Huint ENIT:1;  // Enable Interrupt 
   Huint ENT:1;   // Enable Timer
   Huint T0INT:1; // Timer Interrupt
   Huint PWMA:1;  // Enable Pulse Width Modulation
   Huint ENALL:1; // Enable all Timers 
   Huint CASC:1;  // Enable Cascade Mode of timers
   Huint reserved:20;
} volatile CTRL_STATUS_REG;

typedef long long arch_clock_t;
typedef arch_clock_t hthread_time_t;

/**
 * This struct allows us to treat the 64-bit timer value as an array of
 * 32-bit values, for ease of use.
 */
typedef union
{
    arch_clock_t    time;
    unsigned int help[2];
} arch_clock_helper;

#define _arch_clock_sec(c)          (CPU_CLOCK_HZ)

/**
 * Initializes the AXI Timer in 64-bit Generate Mode
 */
static inline void _init_timer()
{
   volatile CTRL_STATUS_REG * timer0_reg = (CTRL_STATUS_REG *) (HTHREADS_TIMER0 + CONTROL_REGISTER_OFFSET);

   // Clear all bits (effectively clearing the enable fields)
   *(volatile Huint *)(HTHREADS_TIMER0_CONTROL) = 0x0;
   *(volatile Huint *)(HTHREADS_TIMER1_CONTROL) = 0x0;

   // Load both timers with initial values
   *(volatile Huint *)(HTHREADS_TIMER0_LOAD) = 0x0;
   *(volatile Huint *)(HTHREADS_TIMER1_LOAD) = 0x0;
   
   timer0_reg->LOAD = 1;

   // Set Cascade option, auto-reload, up/down, and generate mode options in timer0 control reg only
   timer0_reg->CASC = 1;
   timer0_reg->ARHT = 1;
   timer0_reg->UDT = 0;
   timer0_reg->MDT = 0;
   timer0_reg->LOAD = 0;
   
   // Enable the timer0 only
   timer0_reg->ENT = 1;

}

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


#define hthread_time_min()          0
#define hthread_time_max()          HULONG_MAX
#define hthread_time_zero(t)        (t = 0)

#define hthread_time_get()          _arch_get_time()
#define hthread_time_sub(d,l,r)     ((d) = (l) - (r))
#define hthread_time_add(d,l,r)     ((d) = (l) + (r))
#define hthread_time_div(d,l,r)     ((d) = (l) / (r))
#define hthread_time_diff(d,l,r)    hthread_time_sub(d,l,r)

#define hthread_time_assign(l,r)    (l = r)
#define hthread_time_less(l,r)      (l < r)
#define hthread_time_greater(l,r)   (l > r)

#define hthread_time_sec(time)      (time*(double)(1.0f/CPU_CLOCK_HZ))
#define hthread_time_msec(time)     (time*(double)(1000.0f/CPU_CLOCK_HZ))
#define hthread_time_usec(time)     (time*(double)(1000000.0f/CPU_CLOCK_HZ))
#define hthread_time_nsec(time)     (time*(double)(1000000000.0f/CPU_CLOCK_HZ))

#define hthread_time_fromsec(time)  (time*(double)(CPU_CLOCK_HZ/1.0f))
#define hthread_time_frommsec(time) (time*(double)(CPU_CLOCK_HZ/1000.0f))
#define hthread_time_fromusec(time) (time*(double)(CPU_CLOCK_HZ/1000000.0f))
#define hthread_time_fromnsec(time) (time*(double)(CPU_CLOCK_HZ/1000000000.0f))

#endif
