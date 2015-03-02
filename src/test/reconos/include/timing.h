///
/// \file timing.h
/// Timing functions.
///
/// \author     Enno Luebbers   <luebbers@reconos.de>
/// \date       28.09.2007
//
// This file is part of the ReconOS project <http://www.reconos.de>.
// University of Paderborn, Computer Engineering Group.
//
// (C) Copyright University of Paderborn 2007.
//

#ifndef __TIMING_H__
#define __TIMING_H__

// NOTE: We can only time up to 42.9 seconds (32 bits @ 100 MHz) on eCos!
#include <arch/htime.h>

hthread_time_t gettime(  );
hthread_time_t calc_timediff_ms( hthread_time_t start, hthread_time_t stop );
hthread_time_t calc_timediff_us( hthread_time_t start, hthread_time_t stop );
hthread_time_t calc_timediff( hthread_time_t start, hthread_time_t stop );

#endif                          // __TIMING_H__
