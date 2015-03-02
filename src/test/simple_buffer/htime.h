/************************************************************************************
* Copyright (c) 2006, University of Kansas - Hybridthreads Group
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
*     * Neither the name of the University of Kansas nor the name of the
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
#ifndef _HYBRID_THREADS_PTHREADS_TIME_H_
#define _HYBRID_THREADS_PTHREADS_TIME_H_

#include <sys/time.h>

typedef struct timeval arch_clock_t;
typedef arch_clock_t hthread_time_t;

#define _arch_get_time(t)   gettimeofday(t, NULL )
#define _arch_set_time(t)   settimeofday(t, NULL )
#define _arch_clock_sec(c)  1000000

#define hthread_time_min() ({                       \
        hthread_time_t time;                        \
        time.tv_sec = 0;                            \
        time.tv_usec = 0;                           \
        time;                                       \
})

#define hthread_time_max() ({                       \
        hthread_time_t time;                        \
        time.tv_sec = HUINT_MAX;                    \
        time.tv_usec = HUINT_MAX;                   \
        time;                                       \
})

#define hthread_time_get(time)                      \
        _arch_get_time(time)

#define hthread_time_less(l,r)                      \
        (l.tv_sec < r.tv_sec ||                     \
        (l.tv_sec == r.tv_sec &&                    \
         l.tv_usec < r.tv_usec))

#define hthread_time_greater(l,r)                   \
        (l.tv_sec > r.tv_sec ||                     \
        (l.tv_sec == r.tv_sec &&                    \
         l.tv_usec > r.tv_usec))


#define hthread_time_assign(l,r)    ({              \
        l.tv_sec = r.tv_sec;                        \
        l.tv_usec = r.tv_usec;                      \
})

#define hthread_time_sub(d,l,r)     ({              \
        d.tv_sec = l.tv_sec;                        \
        d.tv_usec = l.tv_usec;                      \
        if( r.tv_usec > d.tv_usec ) {               \
            d.tv_sec--;                             \
            d.tv_usec += 1000000;                   \
        }                                           \
                                                    \
        d.tv_sec -= r.tv_sec;                       \
        d.tv_usec -= r.tv_usec;                     \
})

#define hthread_time_add(d,l,r) ({                  \
        d.tv_sec = l.tv_sec + r.tv_sec;             \
        d.tv_usec = l.tv_usec + r.tv_usec;          \
        d.tv_sec += (d.tv_usec / 1000000);          \
        d.tv_usec = (d.tv_usec % 1000000);          \
})

/*
#define hthread_time_div(d,l,r) ({                  \
        d.tv_usec  = l.tv_usec / r.tv_usec;         \
        d.tv_sec   = l.tv_sec / r.tv_usec;          \
})

#define hthread_time_sdiv(d,l,r) ({                 \
        d.tv_usec  = l.tv_usec / r;                 \
        d.tv_usec += l.tv_sec*1000000.0f/r;         \
        d.tv_sec   = l.tv_sec / r;                  \
})
#define hthread_time_floor(d)       (d.tv_sec*1000000+d.tv_usec)
*/
#define hthread_time_diff(d,l,r)    hthread_time_sub(d,l,r)

#define hthread_time_sec(time)      ((time).tv_sec)
#define hthread_time_msec(time)     (((time).tv_sec*1000.0f)+(time).tv_usec/1000.0f)
#define hthread_time_usec(time)     (((time).tv_sec*1000000.0f)+(time).tv_usec)
#define hthread_time_nsec(time)     (((time).tv_sec*1000000000.0f)+(time).tv_usec*1000.0f)

#define hthread_time_fromsec(x)    ({               \
        hthread_time_t t;                           \
        t.tv_sec   = x;                             \
        t.tv_usec  = 0;                             \
        t;                                          \
})
#define hthread_time_frommsec(x)    ({              \
        hthread_time_t t;                           \
        t.tv_sec   = x / 1000;                      \
        t.tv_usec  = (x%1000)*1000;                 \
        t;                                          \
})
#define hthread_time_fromusec(x)    ({              \
        hthread_time_t t;                           \
        t.tv_sec   = x / 1000000;                   \
        t.tv_usec  = x % 1000000;                   \
        t;                                          \
})
#define hthread_time_fromnsec(x)    ({              \
        hthread_time_t t;                           \
        t.tv_sec   = x / 1000000000;                \
        t.tv_usec  = x / 1000;                      \
        t.tv_usec %= 1000000;                       \
        t;                                          \
})
#endif
