/*****************************************************************************
 * Timing Utility Functions
 *****************************************************************************/
#ifndef _ALGORITHM_UTIL_TIME_H_
#define _ALGORITHM_UTIL_TIME_H_

#include <sys/time.h>

typedef struct timeval arch_clock_t;
typedef arch_clock_t timing_t;

#define _arch_get_time(t)   gettimeofday(t, NULL )
#define _arch_set_time(t)   settimeofday(t, NULL )
#define _arch_clock_sec(c)  1000000

#define timing_min() ({                             \
        timing_t time;                              \
        time.tv_sec = 0;                            \
        time.tv_usec = 0;                           \
        time;                                       \
})

#define timing_max() ({                             \
        timing_t time;                              \
        time.tv_sec = HUINT_MAX;                    \
        time.tv_usec = HUINT_MAX;                   \
        time;                                       \
})

#define timing_get(time)                            \
        _arch_get_time(time)

#define timing_less(l,r)                            \
        (l.tv_sec < r.tv_sec ||                     \
        (l.tv_sec == r.tv_sec &&                    \
         l.tv_usec < r.tv_usec))

#define timing_greater(l,r)                         \
        (l.tv_sec > r.tv_sec ||                     \
        (l.tv_sec == r.tv_sec &&                    \
         l.tv_usec > r.tv_usec))


#define timing_assign(l,r)    ({                    \
        l.tv_sec = r.tv_sec;                        \
        l.tv_usec = r.tv_usec;                      \
})

#define timing_sub(d,l,r)     ({                    \
        (d).tv_sec = (l).tv_sec;                    \
        (d).tv_usec = (l).tv_usec;                  \
        if( (r).tv_usec > (d).tv_usec ) {           \
            (d).tv_sec--;                           \
            (d).tv_usec += 1000000;                 \
        }                                           \
                                                    \
        (d).tv_sec -= (r).tv_sec;                   \
        (d).tv_usec -= (r).tv_usec;                 \
})

#define timing_add(d,l,r) ({                        \
        d.tv_sec = l.tv_sec + r.tv_sec;             \
        d.tv_usec = l.tv_usec + r.tv_usec;          \
        d.tv_sec += (d.tv_usec / 1000000);          \
        d.tv_usec = (d.tv_usec % 1000000);          \
})

/*
#define timing_div(d,l,r) ({                        \
        d.tv_usec  = l.tv_usec / r.tv_usec;         \
        d.tv_sec   = l.tv_sec / r.tv_usec;          \
})

#define timing_sdiv(d,l,r) ({                       \
        d.tv_usec  = l.tv_usec / r;                 \
        d.tv_usec += l.tv_sec*1000000.0f/r;         \
        d.tv_sec   = l.tv_sec / r;                  \
})
#define timing_floor(d)       (d.tv_sec*1000000+d.tv_usec)
*/

#define timing_diff(d,l,r)    timing_sub(d,l,r)

#define timing_sec(time)      ((time).tv_sec + ((time).tv_usec/1000000.0f))
#define timing_msec(time)     (((time).tv_sec*1000.0f)+(time).tv_usec/1000.0f)
#define timing_usec(time)     (((time).tv_sec*1000000.0f)+(time).tv_usec)
#define timing_nsec(time)     (((time).tv_sec*1000000000.0f)+(time).tv_usec*1000.0f)

#define timing_fromsec(x)    ({               \
        timing_t t;                                 \
        t.tv_sec   = x;                             \
        t.tv_usec  = 0;                             \
        t;                                          \
})
#define timing_frommsec(x)    ({              \
        timing_t t;                                 \
        t.tv_sec   = x / 1000;                      \
        t.tv_usec  = (x%1000)*1000;                 \
        t;                                          \
})
#define timing_fromusec(x)    ({              \
        timing_t t;                                 \
        t.tv_sec   = x / 1000000;                   \
        t.tv_usec  = x % 1000000;                   \
        t;                                          \
})
#define timing_fromnsec(x)    ({              \
        timing_t t;                                 \
        t.tv_sec   = x / 1000000000;                \
        t.tv_usec  = x / 1000;                      \
        t.tv_usec %= 1000000;                       \
        t;                                          \
})

#endif
