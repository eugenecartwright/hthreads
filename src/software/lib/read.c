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

/** \file       read.c
  * \brief      Implementation of the read library call.
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  */
#include <errno.h>
#include <fcntl.h>
#include <hthread.h>

extern int stdin_flags;
extern unsigned int can_recv( void );
extern unsigned int recv_byte( Hbyte* );

int read_block( int fd, void *buffer, size_t nbytes )
{
    size_t  i;
    char    *buf;
    int     err;

    buf = (char*)buffer;
    for( i = 0; i < nbytes; i++, buf++ )
    {
        // Get the next byte
        err = recv_byte( buf );
        if( err != 0 )  return err;

        // Translate '\r\n' to '\n'
        //if( *buf == '\r' )  *buf = '\n';
        //if( i > 0 && *buf == '\n' && *(buf-1) == '\r' ) *(buf-1) = *buf--;

        // Exit when the line ends
        if( *buf == '\n' || *buf == '\r' || *buf == 0x04 || *buf == 0x1A )
        {
            i += 1;
            *(++buf) = 0;
            break;
        }
    }

    return i;
}

int read_nonblock( int fd, void *buffer, size_t nbytes )
{
    size_t  i;
    char    *buf;
    int     err;

    buf = (char*)buffer;
    for( i = 0; i < nbytes; i++, buf++ )
    {
        // Stop reading if we would block
        if( !can_recv() )   break;
        
        // Get the next byte
        err = recv_byte( buf );
        if( err != 0 )  return err;

        // Exit when the line ends
        if( *buf == '\n' || *buf == '\r' || *buf == 0x04 || *buf == 0x1A )
        {
            i += 1;
            *(++buf) = 0;
            break;
        }
    }

    if( i == 0 )    { errno = EAGAIN; return -1; }
    else            { return i; }
}

int read( int fd, void *buffer, size_t nbytes )
{
    if( (stdin_flags&O_NONBLOCK)==O_NONBLOCK )  return read_nonblock(fd, buffer, nbytes);
    else                                        return read_block(fd, buffer, nbytes );
}
