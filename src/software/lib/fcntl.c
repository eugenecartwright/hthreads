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

/** \file       fcntl.c
  * \brief      Implementation of the fcntl library call.
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  */
#include <errno.h>
#include <fcntl.h>
#include <stdarg.h>
#include <hthread.h>

extern int stdin_flags;
extern int stdout_flags;

int fcntl( int fd, int cmd, ... )
{
    va_list args;
    int     res;

    va_start( args, cmd );
    switch( cmd )
    {
    case F_GETFL:
        if( fd == 0 )       res = stdin_flags;
        else if( fd == 1 )  res =  stdout_flags;
        else                { errno = EINVAL; res = -1; }
        break;

    case F_SETFL:
        if( fd == 0 )       { stdin_flags  = va_arg(args,int); res = 0; }
        else if( fd == 1 )  { stdout_flags = va_arg(args,int); res = 0; }
        else                { errno = EINVAL; res = -1; }
        break;

    default:
        errno = EINVAL;
        res   = -1;
        break;
    }

    va_end( args );
    return res;
}
