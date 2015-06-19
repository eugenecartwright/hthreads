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

/** \file       stdio.c
  * \brief      Implementation of the required stdio routines.
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  */
#include <errno.h>
#include <fcntl.h>
#include <hthread.h>
#include <uartlite/uartlite.h>
#include <config.h>
#include <stdio.h>

int stdin_flags;
int stdout_flags;

#ifdef SMP_DUAL_UART 
#include <arch/arch.h>
uartlite_t _io_uart1;
uartlite_t _io_uart2;

void stdio_init( void )
{
    uartlite_config_t   config1;
    uartlite_config_t   config2;

    if( _get_procid() == 0 )
    {
        // Setup the base address of the UART
        config1.base = UART1_BASEADDR;
    
        // Create the UART Lite device
        uartlite_create( &(_io_uart1), &config1 );

        // Initialize the stdin and stdout flags
        stdin_flags = 0;
        stdout_flags = 0;
    }
    else
    {
        // Setup the base address of the UART
        config2.base = UART2_BASEADDR;
    
        // Create the UART Lite device
        uartlite_create( &(_io_uart2), &config2 );

        // Initialize the stdin and stdout flags
        stdin_flags = 0;
        stdout_flags = 0;
    }
}  

void stdio_destroy( void )
{
}
#else
uartlite_t _io_uart;

void stdio_init( void )
{
    uartlite_config_t   config;

    // Setup the base address of the UART
    config.base = UART1_BASEADDR;
    
    // Create the UART Lite device
    uartlite_create( &(_io_uart), &config );

    // Initialize the stdin and stdout flags
    stdin_flags = 0;
    stdout_flags = 0;
}  

void stdio_destroy( void )
{
}
#endif
