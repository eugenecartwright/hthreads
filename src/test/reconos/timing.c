///
/// \file timing.c
/// Implementation of timing functions.
///
/// \author     Enno Luebbers   <luebbers@reconos.de>
/// \date       28.09.2007
//
// This file is part of the ReconOS project <http://www.reconos.de>.
// University of Paderborn, Computer Engineering Group.
//
// (C) Copyright University of Paderborn 2007.
//

#include <time.h>
#include <limits.h>
#include "timing.h"

#ifdef USE_ECOS
#include <xparameters.h>
#endif


#ifdef USE_ECOS
volatile unsigned int *const twcsr0 =
    ( unsigned int * ) XPAR_OPB_TIMEBASE_WDT_0_BASEADDR;
volatile unsigned int *const twcsr1 =
    ( unsigned int * ) XPAR_OPB_TIMEBASE_WDT_0_BASEADDR + 1;
volatile unsigned int *const tbr =
    ( unsigned int * ) XPAR_OPB_TIMEBASE_WDT_0_BASEADDR + 2;
#endif

// get system timer value
hthread_time_t gettime(  )
{
    hthread_time_t time;
    hthread_time_get(&time);
    return time;
}


// calculate difference between start and stop time
// and convert to milliseconds
hthread_time_t calc_timediff_ms( hthread_time_t start, hthread_time_t stop )
{
    hthread_time_t diff;
    hthread_time_diff( diff, stop, start );
    return (hthread_time_t)hthread_time_msec( diff );
}

// calculate difference between start and stop time
// and convert to microseconds
hthread_time_t calc_timediff_us( hthread_time_t start, hthread_time_t stop )
{
    hthread_time_t diff;
    hthread_time_diff( diff, stop, start );
    return (hthread_time_t)hthread_time_usec( diff );
}

// calculate difference between start and stop time (no conversion)
hthread_time_t calc_timediff( hthread_time_t start, hthread_time_t stop )
{
    hthread_time_t diff;
    hthread_time_diff( diff, stop, start );
    return diff;
}
