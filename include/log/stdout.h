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
  *	\file       stdout.h
  * \brief      This file contains the logging functionality built into the
  *             hthreads system.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  *
  */

#ifndef _HYBRID_THREADS_LOG_STDOUT_H_
#define _HYBRID_THREADS_LOG_STDOUT_H_

#include <stdlib.h>
#include <log/log.h>

// Declaration of write function
extern int write( int, const void *, int );

static inline Hint log_init( log_t *log ) {
    // Nothing to initialize for output to standard out
    return 0;
}

static inline Hint log_flush( log_t *log ) {
    Huint   size;
    Hubyte  *buffer;

    // Get the size of the log in bytes
    size    = log->pos * sizeof(Huint);

    // Get a pointer to the log data
    buffer  = (Hubyte*)(log->buffer);
    
    // Write the data to stdout
    write( 1, buffer, size );

    // Reset the position counter in the log
    log->pos = 0;

    // Return successfully
    return 0;
}

static inline Hint log_flush_ascii( log_t *log ) {
    Huint i = 0;

    // Loop over all values in the log and print them out in ascii
    while( i < log->pos )	printf( "%u\n", log->buffer[i++] );

    // Reset the position counter in the log
    log->pos = 0;

    // Return successfully
    return 0;
}
#endif

