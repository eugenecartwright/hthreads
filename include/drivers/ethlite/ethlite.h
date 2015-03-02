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

/** \file       ethlite.h
  * \brief      Header file for the ethlite driver.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  * This file is the header file for the Hthreads ethlite driver. This driver
  * is capable of communicating with any Xilinx Lite Ethernet based device.
  */
#ifndef _HYBRID_THREADS_DRIVER_ETHLITE_H_
#define _HYBRID_THREADS_DRIVER_ETHLITE_H_

#include <httype.h>
#include <htconst.h>

#define ETHLITE_GIE             0x07F8

#define ETHLITE_TXPING_BUFFER   0x0000
#define ETHLITE_TXPING_LENGTH   0x07F4
#define ETHLITE_TXPING_CONTROL  0x07FC

#define ETHLITE_TXPONG_BUFFER   0x0800
#define ETHLITE_TXPONG_LENGTH   0x0FF4
#define ETHLITE_TXPONG_CONTROL  0x0FFC

#define ETHLITE_RXPING_BUFFER   0x1000
#define ETHLITE_RXPING_LENGTH   0x100C
#define ETHLITE_RXPING_CONTROL  0x17FC

#define ETHLITE_RXPONG_BUFFER   0x1800
#define ETHLITE_RXPONG_LENGTH   0x180C
#define ETHLITE_RXPONG_CONTROL  0x1FFC

#define ETHLITE_CONTROL_STATUS  0x000000001
#define ETHLITE_CONTROL_PROGRAM 0x000000002
#define ETHLITE_CONTROL_INTR    0x000000008
#define ETHLITE_CONTROL_GIE     0x800000000

typedef struct
{
    Hubyte  dst[6];
    Hubyte  src[6];
    Hushort length;
    Hubyte  data[1500];
} ethlite_frame_t;

typedef struct
{
    Huint   base;
    Hbool   recv_toggle;
    Hbool   send_toggle;
} ethlite_config_t;

typedef struct
{
    Hubyte  mac[8];
    Huint   txintr;
    Huint   rxintr;
    Huint   *txbuffer[2];
    Huint   *rxbuffer[2];
    Huint   *txcontrol[2];
    Huint   *rxcontrol[2];
    Huint   *txlength[2];
    Huint   *rxlength[2];
} ethlite_t;

extern Hint ethlite_create( ethlite_t*, ethlite_config_t* );
extern Hint ethlite_destroy( ethlite_t* );

extern void ethlite_setmac( ethlite_t*, Hubyte* );
extern void ethlite_getmac( ethlite_t*, Hubyte* );

extern Huint ethlite_cansend( ethlite_t* );
extern Huint ethlite_canrecv( ethlite_t* );
extern Huint ethlite_txwait( ethlite_t* );
extern Huint ethlite_rxwait( ethlite_t* );

extern void ethlite_send( ethlite_t*, ethlite_frame_t*, Hushort );
extern void ethlite_recv( ethlite_t*, ethlite_frame_t* );

extern void ethlite_enablesend( ethlite_t* );
extern void ethlite_disablesend( ethlite_t* );
extern void ethlite_enablerecv( ethlite_t* );
extern void ethlite_disablerecv( ethlite_t* );

extern void ethlite_sendfill( ethlite_t*, Huint, Huint*, Huint );
extern void ethlite_sendsignal( ethlite_t*, Huint, Hushort );
extern void ethlite_recvfill( ethlite_t*, Huint, Huint*, Huint );
extern void ethlite_recvack( ethlite_t*, Huint );
extern Hushort ethlite_recvsize( ethlite_t*, Huint );
extern void ethlite_sendflush( ethlite_t* );
extern void ethlite_recvflush( ethlite_t* );

extern void ethlite_alignedwrite( void*, void*, Huint );
extern void ethlite_bytealignedwrite( Huint*, Hubyte*, Huint );
extern void ethlite_hwordalignedwrite( Huint*, Hushort*, Huint );
extern void ethlite_wordalignedwrite( Huint*, Huint*, Huint );
#endif
