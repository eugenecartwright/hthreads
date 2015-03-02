/** \internal
  * \file       htime.h
  * \brief      The definition of Hthreads time grabbing routines.
  *
  * \author     Seth Warn <swarn@uark.edu>
  *
  * Based on earlier work by Wesley Peck
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
#define HTHREADS_TIMER_BASE XPAR_PLB_HTHREADS_TIMER_0_BASEADDR

// Special write data (opcode) for software-controlled reset
#define CMD_RESET (0xA)

// Register offsets (in bytes) for timer core
#define OFFSET_RESET     (0x100)
#define OFFSET_COUNT_HI  (0x0)
#define OFFSET_COUNT_LO  (0x4)

// Register definitions for timer core
#define HTHREADS_TIMER_RESET_REG     (HTHREADS_TIMER_BASE + OFFSET_RESET)
#define HTHREADS_TIMER_DATA_HI       (HTHREADS_TIMER_BASE + OFFSET_COUNT_HI)
#define HTHREADS_TIMER_DATA_LO       (HTHREADS_TIMER_BASE + OFFSET_COUNT_LO)


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
 * Reset the counter to zero by writing the reset command to the counter.
 */
static inline void _init_timer()
{
    *(volatile unsigned int*)(HTHREADS_TIMER_RESET_REG) = CMD_RESET;
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
    do
    {
        d.help[0] = timer_get_hi();
        d.help[1] = timer_get_lo();
    } while( d.help[0] != timer_get_hi() );

    return d.time;
}


#define hthread_time_min()          0
#define hthread_time_max()          HULONG_MAX
#define hthread_time_zero(t)        (t = 0)

//#define hthread_time_get(time)      _arch_get_time(time)
#define hthread_time_get()      _arch_get_time()
#define hthread_time_sub(d,l,r)     ((d) = (l) - (r))
#define hthread_time_add(d,l,r)     ((d) = (l) + (r))
#define hthread_time_div(d,l,r)     ((d) = (l) / (r))
#define hthread_time_diff(d,l,r)    hthread_time_sub(d,l,r)

#define hthread_time_assign(l,r)    (l = r)
#define hthread_time_less(l,r)      (l < r)
#define hthread_time_greater(l,r)   (l > r)

#define hthread_time_sec(time)      (time*(float)(1.0f/CPU_CLOCK_HZ))
#define hthread_time_msec(time)     (time*(float)(1000.0f/CPU_CLOCK_HZ))
#define hthread_time_usec(time)     (time*(float)(1000000.0f/CPU_CLOCK_HZ))
#define hthread_time_nsec(time)     (time*(float)(1000000000.0f/CPU_CLOCK_HZ))

#define hthread_time_fromsec(time)  (time*(float)(CPU_CLOCK_HZ/1.0f))
#define hthread_time_frommsec(time) (time*(float)(CPU_CLOCK_HZ/1000.0f))
#define hthread_time_fromusec(time) (time*(float)(CPU_CLOCK_HZ/1000000.0f))
#define hthread_time_fromnsec(time) (time*(float)(CPU_CLOCK_HZ/1000000000.0f))

#endif
