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
  *	\file       log.h
  * \brief      This file contains the logging functionality built into the
  *             hthreads system.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  *
  */

#ifndef _HYBRID_THREADS_LOG_H_
#define _HYBRID_THREADS_LOG_H_

#include <hthread.h>
#include <config.h>
#include <stdlib.h>
#include <stdio.h>
#include <time/commands.h>

typedef struct
{
    Hbool   is_open;
    Huint   pos;
    Huint   size;
    Huint   *buffer;
    void    *device;
} log_t;

#if LOG_SERIAL
    #include <log/stdout.h>
#else
    #include <log/null.h>
#endif

static inline Hint log_create( log_t *log, Huint size )
{
    log->is_open    = Hfalse;
    log->pos        = 0;
    log->size       = 0;

    log->buffer = (Huint*)malloc( size * sizeof(Huint) );
    if( log->buffer == NULL )   return -1;

    log->is_open    = Htrue;
    log->pos        = 0;
    log->size       = size;

    return log_init( log );
}

static inline Hint log_write( log_t *log, Huint *data, Huint size )
{
    Huint i;
    
    if( !log->is_open )                 return -1;
    if( size < 0 )                      return -1;
    if( log->size < log->pos + size )   return -1;

    for( i = 0; i < size; i++ )
    {
        log->buffer[ log->pos + i ] = data[i];
    }

    log->pos += size;
    return 0;
}

static inline Hint log_delay( log_t *log )
{
    if( log->is_open && log->pos < log->size )
    {
        log->buffer[ log->pos++ ] = 0; //timer_get_delay(0);
    }

    return 0;
}                                                               

static inline Hint log_time( log_t *log )
{
    if( log->is_open && log->pos < log->size )
    {
        log->buffer[ log->pos++ ] = 0; //timer_get_globallo();
    }

    return 0;
}                                                               

static inline Hint log_close( log_t *log )
{
    if( log->pos > 0 )  log_flush( log );

    log->is_open    = Hfalse;
    log->pos        = 0;
    log->size       = 0;

    free( log->buffer );
    log->buffer = NULL;

    return 0;
}

static inline Hint log_close_ascii( log_t *log ) {
    if( log->pos > 0 )  log_flush_ascii( log );

	log->is_open    = Hfalse;
	log->pos        = 0;
	log->size       = 0;

	free( log->buffer );
	log->buffer = NULL;

	return 0;
}

#endif

