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

/** \file       debug.h
  * \brief      The declaration of debug macros for the Hybrid Threads system.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  *
  * This file contains several macros used to support debug and trace
  * information in the Hybrid Threads system.
  */
#ifndef _HYBRID_THREAD_DEBUG_H_
#define _HYBRID_THREAD_DEBUG_H_

#include <stdio.h>

// Define the trace levels which can be used
#define TRACE_NONE      0
#define TRACE_FATAL     1
#define TRACE_ERR       2
#define TRACE_WARN      3
#define TRACE_INFO      4
#define TRACE_DBG       5
#define TRACE_FINE      6

// Define a macro to alway output a trace statement
#define TRACE_ALWAYS(str,...)  fprintf(stderr,str,##__VA_ARGS__)

/* Trace Level 1: Used to print out trace information for errors */
#if TRACE_LEVEL >= 1
#define TRACE1_PRINTF(str,...)  fprintf(stderr,str,##__VA_ARGS__)
#else
#define TRACE1_PRINTF(str,...)
#endif

/* Trace Level 2: Used to print out trace information for warnings */
#if TRACE_LEVEL >= 2
#define TRACE2_PRINTF(str,...)  fprintf(stderr,str,##__VA_ARGS__)
#else
#define TRACE2_PRINTF(str,...)
#endif

/* Trace Level 3: Used to print out trace information for helpful info */
#if TRACE_LEVEL >= 3
#define TRACE3_PRINTF(str,...)  fprintf(stderr,str,##__VA_ARGS__)
#else
#define TRACE3_PRINTF(str,...)
#endif

/* Trace Level 4: Used to print out trace information for function calls */
#if TRACE_LEVEL >= 4
#define TRACE4_PRINTF(str,...)  fprintf(stderr,str,##__VA_ARGS__)
#else
#define TRACE4_PRINTF(str,...)
#endif

/* Trace Level 5: Used to print out trace information for statements */
#if TRACE_LEVEL >= 5
#define TRACE5_PRINTF(str,...)  fprintf(stderr,str,##__VA_ARGS__)
#else
#define TRACE5_PRINTF(str,...)
#endif

/* Trace: Used to print out trace information unconditionally */
#if TRACE_LEVEL > 0
#define TRACE_PRINTF(vrb,mod,str,...)                       \
({                                                          \
    if( (mod) && vrb <= TRACE_LEVEL )                       \
    {                                                       \
        fprintf(stderr, "%d %s: ",__LINE__,__FUNCTION__);   \
        fprintf(stderr, str,##__VA_ARGS__);                 \
        while( vrb == TRACE_FATAL );                        \
    }                                                       \
})
#else
#define TRACE_PRINTF(vbr,mod,str,...)
#endif

/* Trace: Used to print out debug information */
#ifdef DEBUG
#define DEBUG_PRINTF(str,...)   fprintf(stderr,str,##__VA_ARGS__)
#else
#define DEBUG_PRINTF(str,...)
#endif

#endif
