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

#ifndef _ETHERNET_H_
#define _ETHERNET_H_

#define ETH_MAC_SIZE           6
#define ETH_HDR_SIZE          14
//#define ETH_HDR_SIZE          16    // (6 bytes for SRC addr) + (6 bytes for DST addr) + (4 bytes for LLC) = 16
#define ETH_MTU_WORD         375
#define ETH_MTU_SIZE        1500
#define ETH_FRM_SIZE        1518
#define ETH_FRM_WORD         380

typedef unsigned char   Hubyte;
typedef unsigned short  Hushort;
typedef unsigned int    Huint;
typedef unsigned long   Hulong;

void eth_init( Hubyte *src );
void eth_destroy( void );
void eth_send( Hubyte *target, Hubyte *data, Huint size );
void eth_send_ackless( Hubyte *target, Hubyte *data, Huint size );
void eth_recv( Hubyte *data, Huint size );
void eth_recv_ackless( Hubyte *data, Huint size );

#endif

