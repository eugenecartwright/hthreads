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

/** \internal
  * \file       ethernet.c
  * \brief      The implementation of the ethernet lite driver.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  *
  * FIXME: Add description
  */
#include <hthreads.h>
#include <config.h>
#include <drivers/ethernet/ethernet.h>
#include <xemaclite.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "xstatus.h"
#include "xio.h"
#include "xenv.h"

static Hubyte    eth_mac[6];
static XEmacLite eth_inst;
static Huint     eth_sbuf[ ETH_FRM_WORD ];
static Huint     eth_rbuf[ ETH_FRM_WORD ];

void _setup_frame( Hubyte *frame, Hubyte *target, Hubyte *data, Hushort len )
{
    Huint i;
    
    // Add the destination MAC Address
    for( i = 0; i < ETH_MAC_SIZE; i++ ) frame[i] = target[i];

    // Add the source MAC Address
    for( i = 0; i < ETH_MAC_SIZE; i++ ) frame[i+6] = eth_mac[i];

    // Add the type
    frame[12]   = (Hubyte)(len >> 8);
    frame[13]   = (Hubyte)(len >> 0);

    // Copy the data into the frame
    for( i = 0; i < len; i++ ) frame[i + ETH_HDR_SIZE] = data[i];
    //memcpy( (frame+ETH_HDR_SIZE), data, len );
}

void _send_frame( Hubyte *frame, Hushort len )
{
    XStatus s;

    s = XEmacLite_Send( &eth_inst, frame, len );
    while( s !=XST_SUCCESS )    s = XEmacLite_Send( &eth_inst, frame, len );
}

Hushort _recv_frame( Hubyte *frame )
{
    Hushort len;

    len = XEmacLite_Recv( &eth_inst, frame );
    while( len == 0 )   len = XEmacLite_Recv( &eth_inst, frame );

    return len;
}

void _send_ack( Hubyte *target )
{
    Huint   ack;
    Huint   frame[8];
    
    ack = 0xDEADBEEF;
    _setup_frame( (Hubyte*)frame, target, (Hubyte*)&ack, sizeof(ack) );
    _send_frame( (Hubyte*)frame, ETH_HDR_SIZE + sizeof(ack) );
}

void _recv_ack( void )
{
    Huint buffer[ ETH_FRM_WORD ];
    _recv_frame( (Hubyte*)buffer );
}

void eth_send( Hubyte *target, Hubyte *data, Huint size )
{
    Huint   i;
    Huint   j;
    Hushort len;

    i = 0;
    while( i < size )
    {
        if( size - i > ETH_MTU_SIZE )   len = ETH_MTU_SIZE;
        else                            len = size - i;
        
        _setup_frame( (Hubyte*)eth_sbuf, target, data + i, len );
        _send_frame( (Hubyte*)eth_sbuf, len + ETH_HDR_SIZE );
        _recv_ack();

        i += len;
    }
}

void eth_recv( Hubyte *data, Huint size )
{
    Huint   i;
    Hushort len;
    Hubyte  *buffer;
    
    buffer = (Hubyte*)eth_rbuf;
    
    i = 0;
    while( i < size )
    {
        len = _recv_frame( buffer );
        _send_ack( (buffer + ETH_MAC_SIZE) );

        memcpy( (data+i), (buffer+14), len - 18 );
        i += (len-18);
    }
}

Hint eth_init( Hubyte *mac )
{
    Huint   i;
    XStatus status;

    // Copy the ethernet mac address into our own structure
    for( i = 0; i < ETH_MAC_SIZE; i++ ) eth_mac[i] = mac[i];
    
    // Initialize the ethernet controller
    status = XEmacLite_Initialize( &eth_inst, ETH_DEVICE );
    if( status != XST_SUCCESS ) return -1;

    // Set the mac address of the ethernet controller
    XEmacLite_SetMacAddress( &eth_inst, eth_mac );
    
    // Run a self test to ensure things are in order
    //status = XEmacLite_SelfTest( &eth_inst );
    //if( status != XST_SUCCESS ) return -2;

    // Flush the receive buffer so that no extraneous data appears
    XEmacLite_FlushReceive( &eth_inst );

    return 0;
}

Hint eth_destroy( void )
{
    return 0;
}
