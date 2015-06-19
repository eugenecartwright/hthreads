/************************************************************************************
* Copyright (c) 2015, University of Arkansas - Hybridthreads Group
* All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
* 
*     * Redistributions of source code must retain the above copyright notice,
*       this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright notice,
*       this list of conditions and the following disclaimer in the documentation
*       and/or other materials provided with the distribution.
*     * Neither the name of the University of Arkansas nor the name of the
*       Hybridthreads Group nor the names of its contributors may be used to
*       endorse or promote products derived from this software without specific
*       prior written permission.
* 
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
* ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
************************************************************************************/

/** \internal
  * \file       htime.h
  * \brief      The definition of Hthreads time grabbing routines.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  * This file defines the architecture dependent implementation of timers.
  */
#ifndef _HYBRID_THREADS_PPC405_TIME_H_
#define _HYBRID_THREADS_PPC405_TIME_H_

#include <hthread.h>
#include <config.h>
#include <arch/asm.h>

#ifndef CLOCKS_PER_SEC
#define CLOCKS_PER_SEC  CPU_CLOCK_HZ
#endif

typedef long long arch_clock_t;
typedef arch_clock_t hthread_time_t;
#define _arch_clock_sec(c)          (CPU_CLOCK_HZ)

typedef union
{
    arch_clock_t    time;
    Huint           help[2];
} arch_clock_helper;

static inline arch_clock_t _arch_get_time( void )
{
    arch_clock_helper d;

    // Read a consistent time value from the processor
    do
    {
        d.help[0] = mftbu();
        d.help[1] = mftbl();
    } while( d.help[0] != mftbu() );

    return d.time;
}

static inline Hint _arch_set_time( arch_clock_t *clock )
{
    Huint l;
    Huint h;

    // Get the low and high values
    h = (Huint)(*clock >> 32);
    l = (Huint)(*clock & 0x00000000FFFFFFFF);

    // Clear out the lower time value to make sure a roll over doesn't occur
    mttbl( 0 );

    // Set the time value on the cpu
    mttbu( h );
    mttbl( l );

    // Return successfully
    return SUCCESS;
}

#define hthread_time_min()          0
#define hthread_time_max()          HULONG_MAX
#define hthread_time_zero(t)        (t = 0)

#define hthread_time_get(time)      _arch_get_time(time)
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
