/*****************************************************************************
 * Debug Definitions
 *****************************************************************************/
#ifndef _ALGORITHM_UTIL_DEBUG_H_
#define _ALGORITHM_UTIL_DEBUG_H_

#include <stdio.h>
#include <stdlib.h>

// Define the trace levels which can be used
#define NONE    0
#define FATAL   1
#define ERR     2
#define WARN    3
#define INFO    4
#define DBG     5
#define FINE    6

// Trace: Used to print out trace information unconditionally
#if TRACE_LEVEL > NONE
#define TRACE(vrb,mod,str,...)                              \
({                                                          \
    if( (mod) && (vrb) <= TRACE_LEVEL )                     \
    {                                                       \
        fprintf(stderr, "%d %s: ",__LINE__,__FUNCTION__);   \
        fprintf(stderr, str,##__VA_ARGS__);                 \
        while( vrb == TRACE_FATAL );                        \
    }                                                       \
})
#else
#define TRACE(vbr,mod,str,...)
#endif

// Debug: Used to print out debug information
#ifdef USEDEBUG
#define DEBUG(str,...)   fprintf(stderr,str,##__VA_ARGS__)
#else
#define DEBUG(str,...)
#endif

// Assert: Used to provide code assertions
#ifdef USEDEBUG
#define ASSERT(mod,str,...)                                 \
({                                                          \
    if( (mod) == false )                                    \
    {                                                       \
        fprintf(stderr, "%d %s: ",__LINE__,__FUNCTION__);   \
        fprintf(stderr, str, ##__VA_ARGS__);                \
        exit(1);                                            \
    }                                                       \
})
#else
#define ASSERT(mod,str,...)
#endif

#endif
