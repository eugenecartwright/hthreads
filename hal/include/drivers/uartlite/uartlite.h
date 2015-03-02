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

/** \file       uartlite.h
  * \brief      Header file for the uartlite driver.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  * This file is the header file for the Hthreads UART Lite driver. This driver
  * is capable of communicating with any UART Lite device.
  */
#ifndef _HYBRID_THREADS_DRIVER_UARTLITE_H_
#define _HYBRID_THREADS_DRIVER_UARTLITE_H_

#include <httype.h>
#include <htconst.h>

// Definition of UART Lite Register Offsets
#define UARTLITE_RECV           0x00000000
#define UARTLITE_SEND           0x00000004
#define UARTLITE_STATUS         0x00000008
#define UARTLITE_CONTROL        0x0000000C

// Definition of UART Lite Status Bits
#define UARTLITE_STATUS_PERROR  0x00000080
#define UARTLITE_STATUS_FERROR  0x00000040
#define UARTLITE_STATUS_OERROR  0x00000020
#define UARTLITE_STATUS_INTR    0x00000010
#define UARTLITE_STATUS_TXFULL  0x00000008
#define UARTLITE_STATUS_TXEMPTY 0x00000004
#define UARTLITE_STATUS_RXFULL  0x00000002
#define UARTLITE_STATUS_RXVALID 0x00000001

// Defintion of UART Lite Control Bits
#define UARTLITE_CONTROL_INTR   0x00000010
#define UARTLITE_CONTROL_RXRST  0x00000002
#define UARTLITE_CONTROL_TXRST  0x00000001

typedef struct
{
    Huint   base;
} uartlite_config_t;

typedef struct
{
    volatile Huint *status;
    volatile Huint *control;
    volatile Huint *send;
    volatile Huint *recv;
} uartlite_t;

// Create or destroy the uart lite device
extern Hint uartlite_create( uartlite_t*, uartlite_config_t* );
extern Hint uartlite_destroy( uartlite_t* );

// Enable or disable interrupts
extern Hint uartlite_enable( uartlite_t* );
extern Hint uartlite_disable( uartlite_t* );

// Determine if a trasmit or receive can occur
extern Hint uartlite_cansend( uartlite_t* );
extern Hint uartlite_canrecv( uartlite_t* );

// Transmite or receive a single byte
extern Hint uartlite_recv( uartlite_t*, Hubyte* );
extern Hint uartlite_send( uartlite_t*, Hubyte );

// Send or receive data
extern Huint uartlite_read( uartlite_t*, Hubyte*, Huint );
extern Huint uartlite_write( uartlite_t*, Hubyte*, Huint );

#endif
