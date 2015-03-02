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
#define LIBNET_LIL_ENDIAN 1

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netinet/if_ether.h>
#include <pcap.h>
#include <libnet.h>
#include "ethernet.h"

static libnet_t        *eth_net;
static pcap_t          *eth_cap;

static Hubyte           eth_mac[6];
static Huint            eth_sbuf[ ETH_FRM_WORD ];
static Huint            eth_rbuf[ ETH_FRM_WORD ];

void _setup_frame( Hubyte *frame, Hubyte *target, Hubyte *data, Hushort len )
{
    Huint i;

    // Add the destination MAC Address
    for( i = 0; i < ETH_MAC_SIZE; i++ )   frame[i] = target[i];

    // Add the source MAC Address
    for( i = 0; i < ETH_MAC_SIZE; i++ )   frame[i+ETH_MAC_SIZE] = eth_mac[i];

    // Add the type
/*    frame[12]   = (Hubyte)(len >> 8);
    frame[13]   = (Hubyte)(len >> 0);
*/
    // Add in LLC frame type
/*    frame[12]   = (Hubyte)(0x1);        
    frame[13]   = (Hubyte)(0x1);
    frame[14]   = (Hubyte)(0x46);   // junk, just a spacer
    frame[15]   = (Hubyte)(0x47);   // junk, just a spacer
*/
    //frame[12]   = (Hubyte)(len >> 8);        
    //frame[13]   = (Hubyte)(len >> 0);
    frame[12]   = (Hubyte)(0xc0);   // CTP
    frame[13]   = (Hubyte)(0x00);   // CTP
    //frame[14]   = (Hubyte)(0x1);   // LLC
    //frame[15]   = (Hubyte)(0x1);   // LLC
    //frame[14]   = (Hubyte)(0xc0);   // CTP
    //frame[15]   = (Hubyte)(0x00);   // CTP
    //frame[16]   = (Hubyte)(0x89);   // LLC
    //frame[17]   = (Hubyte)(0x89);   // LLC

    // Copy the data into the frame
    for( i = 0; i < len; i++ )  frame[i+ETH_HDR_SIZE] = data[i];
}

void _send_frame( Hubyte *frame, Hushort len )
{
    libnet_adv_write_link( eth_net, frame, len );
}

Hushort _recv_frame( Hubyte *frame )
{
    int res;
    const Hubyte *packet;
    struct pcap_pkthdr *hdr;
    struct ether_header *eptr;
    short len;
    
    res = pcap_next_ex( eth_cap, &hdr, &packet );
    while( res != 1 )   res = pcap_next_ex( eth_cap, &hdr, &packet );

    len = hdr->len;
    while( --len >= 0 ) frame[len] = packet[len];
    
    return hdr->len;
}

void _send_ack( Hubyte *target )
{
    Huint   ack;
    Huint   frame[8];

    ack = htonl( 0xDEADBEEF );
    _setup_frame( (Hubyte*)frame, target, (Hubyte*)&ack, sizeof(ack) );
    _send_frame( (Hubyte*)frame, ETH_HDR_SIZE + sizeof(ack) );
}

void _recv_ack( void )
{
    Huint i;
    Huint ack;
    Huint buffer[ ETH_FRM_WORD ];
    Huint len;
    Hubyte *temp;
    
    len = _recv_frame( (Hubyte*)buffer );
    
    temp = (Hubyte*)buffer;
    temp += 14;

    ack = *(Huint*)(temp);
}

void send_init( const char *dev )
{
    char err[ LIBNET_ERRBUF_SIZE ];
    
    eth_net = libnet_init( LIBNET_LINK_ADV, (char*)dev, err );
    if( eth_net == NULL )
    {
        printf( "Could not Initialize Send: %s\n", err );
        exit( 1 );
    }

    printf( "Initialized Send Interface\n" );
}

void recv_init( const char *dev )
{
    char                err[PCAP_ERRBUF_SIZE];
    char                filter[32];
    bpf_u_int32         mask;
    bpf_u_int32         net;
    struct bpf_program  bpf;
    int                 res;
                    
    snprintf( filter, 32, "ether dst %2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x",
       eth_mac[0],eth_mac[1],eth_mac[2],eth_mac[3],eth_mac[4],eth_mac[5]);
    
    printf( "Filter: (%s)\n", filter );
    
    eth_cap = pcap_open_live( dev, BUFSIZ, 1, 10, err );
    if( eth_cap == NULL )
    {
        printf( "Could Not Open Device: %s\n", err );
        exit( 1 );
    }
    
    res = pcap_lookupnet( dev, &net, &mask, err );
    if( res < 0 )
    {
        printf( "Could Not Lookup Network Configuration: %s\n", err );
        exit( 1 ); 
    }
             
    res = pcap_compile( eth_cap, &bpf, filter, 0, net );
    if( res < 0 )
    {
        pcap_perror( eth_cap, "Could Not Compile Filter" );
        exit( 1 );
    }
                        
    res = pcap_setfilter( eth_cap, &bpf );
    if( res < 0 )
    {
        pcap_perror( eth_cap, "Could Not Set Filter" );
        exit( 1 );
    }
                            
    printf( "Initialized Recv Interface\n" );
}

void send_destroy( void )
{
    libnet_destroy( eth_net );
    printf( "Destroyed Send Interface\n" );
}

void recv_destroy( void )
{
    printf( "Destroyed Recv Interface\n" );
}

void eth_init( Hubyte *src )
{
    Huint i;

    // Copy the source mac address
    for( i = 0; i < ETH_MAC_SIZE; i++ )  eth_mac[i] = src[i];
    
    // Initialize the sending functionality
    //send_init( "eth1" );
    send_init( "en0" );

    // Initialize the receiving functionality
    //recv_init( "eth1" );
    recv_init( "en0" );
}

void eth_destroy( void )
{
    send_destroy();
    recv_destroy();
}

void eth_send( Hubyte *target, Hubyte *data, Huint size )
{
    Huint   i;
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
void eth_send_ackless( Hubyte *target, Hubyte *data, Huint size )
{
    Huint   i;
    Hushort len;

    i = 0;
    while( i < size )
    {
        if( size - i > ETH_MTU_SIZE )   len = ETH_MTU_SIZE;
        else                            len = size - i;

        _setup_frame( (Hubyte*)eth_sbuf, target, data + i, len );
        printf("Waiting for send (i = %d), (size = %d) \n",i, size);
        _send_frame( (Hubyte*)eth_sbuf, len + ETH_HDR_SIZE );
        printf("Send  complete\n");
        i += len;
    }
}


void eth_recv( Hubyte *data, Huint size )
{
    Huint    i;
    Huint    j;
    Hushort  len;
    Hubyte   *buffer;

    buffer = (Hubyte*)eth_rbuf;
        
    i = 0;
    while( i < size )
    {
        printf("Waiting for receive (i = %d), (size = %d) \n",i, size);
        len = _recv_frame( buffer );
        printf("Receive complete\n");
        _send_ack( (buffer+ETH_MAC_SIZE) );

        for( j = 0; j < len - 14; j++ ) data[i+j] = buffer[j+14];
        i += (len-14);
    }
}

void eth_recv_ackless( Hubyte *data, Huint size )
{
    Huint    i;
    Huint    j;
    Hushort  len;
    Hubyte   *buffer;

    buffer = (Hubyte*)eth_rbuf;
        
    i = 0;
    while( i < size )
    {
        printf("Waiting for receive (i = %d), (size = %d) \n",i, size);
        len = _recv_frame( buffer );
        printf("Receive complete\n");
        //_send_ack( (buffer+ETH_MAC_SIZE) );

        for( j = 0; j < len - 14; j++ ) data[i+j] = buffer[j+14];
        i += (len-14);
    }
}

