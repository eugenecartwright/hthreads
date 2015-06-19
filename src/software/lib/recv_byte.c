/************************************************************************************
* Copyright (c) 2015, University of Arkansas - Hybridthreads Group
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
*     * Neither the name of the University of Arkansas nor the name of the
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

/** \file       recv_byte.c
  * \brief      Implementation of the recv_byte library call.
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  */
#include <errno.h>
#include <fcntl.h>
#include <hthread.h>
#include <uartlite/uartlite.h>
#include <config.h>
#include <stdio.h>

#ifdef SMP_DUAL_UART 
#include <arch/arch.h>
extern int stdin_flags;
extern uartlite_t _io_uart1;
extern uartlite_t _io_uart2;

int can_recv()
{
    if( _get_procid() == 0 )    return uartlite_canrecv(&(_io_uart1));
    else                        return uartlite_canrecv(&(_io_uart2));
}

int recv_byte( Hbyte *d )
{
    if( (stdin_flags & O_NONBLOCK) == O_NONBLOCK )
    {
        if( _get_procid() == 0 )
        {
            if( uartlite_canrecv(&(_io_uart1)) ) uartlite_recv(&(_io_uart1),(Hubyte*)d);
            else                                errno = EAGAIN;
        }
        else
        {
            if( uartlite_canrecv(&(_io_uart2)) ) uartlite_recv(&(_io_uart2),(Hubyte*)d);
            else                                errno = EAGAIN;
        }
    }
    else
    {
        if( _get_procid() == 0 )    uartlite_recv( &(_io_uart1), d );
        else                        uartlite_recv( &(_io_uart2), d );
    }

    return 0;
}
#else
extern int stdin_flags;
extern uartlite_t _io_uart;

int can_recv()
{
    return uartlite_canrecv(&(_io_uart));
}

int recv_byte( Hbyte *d )
{
    if( (stdin_flags & O_NONBLOCK) == O_NONBLOCK )
    {
        if( uartlite_canrecv(&(_io_uart)) ) uartlite_recv(&(_io_uart), (Hubyte*)d );
        else                                errno = EAGAIN;
    }
    else
    {
       uartlite_recv( &(_io_uart), (Hubyte*)d );
    }

    return 0;
}
#endif
