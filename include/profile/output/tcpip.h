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
  *	\file       tcpip.h
  * \brief      This file contains definitions of the TCP/IP output
  *             functionality in the profiling system of Hthreads.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  */

#ifndef _HYBRID_THREADS_PROFILE_TCPIP_H_
#define _HYBRID_THREADS_PROFILE_TCPIP_H_

#include <profile/output/output.h>
#include <ethlite/netif.h>
#include <arch/htime.h>
#include <string.h>
#include <config.h>

#define IP_ADDR(a,b,c,d)        ((((a) & 0xFF) << 24) |  \
                                 (((b) & 0xFF) << 16) |  \
                                 (((c) & 0xFF) << 8)  |  \
                                 (((d) & 0xFF) << 0))

#define COPY                    1
#define MILLISECOND             (CLOCKS_PER_SEC/1000)
#define DHCP_SLOW_TIMER_MSECS   1000*DHCP_COARSE_TIMER_SECS
#define MAXSEND                 1436
#define SIZE                    (5*MAXSEND)
#define SERVER                  IP_ADDR(192,168,1,3)

static Huint  length __attribute__((unused)) = 0;
static Hubyte buffer[SIZE+1] __attribute__((unused));
static struct tcp_pcb *pcb = NULL;
static void hprofile_output_tcpip_loop();

static void hprofile_output_tcpip_start( const char *file )
{
    ethlite_config_t    *config;
    struct netif        *netif;
    struct ip_addr      ip;
    struct ip_addr      nm;
    struct ip_addr      gw;

    // Initialize the lwIP system
    printf( "Starting TCP/IP for %s\n", file );
    stats_init();
    sys_init();
    mem_init();
    memp_init();
    pbuf_init();
    etharp_init();
    netif_init();
    ip_init();
    udp_init();
    tcp_init();

    // Initialize the low level configuration
    config = (ethlite_config_t*)malloc( sizeof(ethlite_config_t) );
    config->base        = ETHLITE_BASEADDR;
    config->send_toggle = Htrue;
    config->recv_toggle = Htrue;

    // Setup the default ip address
    ip.addr = 0x0A000001;       // 10.0.0.2
    nm.addr = 0xFFFFFF00;       // 255.255.255.0
    gw.addr = 0x0A000001;       // 10.0.0.1

    // Initialize the network interface
    netif = (struct netif*)malloc( sizeof(struct netif) );
    netif_add( netif, &ip, &nm, &gw, config, ethlite_netif_init, ip_input );
    netif_set_default( netif );

    // Attempt to acquire an ip address using dhcp
    printf( "Using DHCP for IP Address...\n" );
    dhcp_start( netif_default );
}

static void hprofile_output_tcpip_finish( const char *file )
{
    Huint size;
    Huint next;
    Huint len;
    printf( "Finishing up TCP/IP output\n" );

    next = 0;
    while( length > 0 )
    {
        while( tcp_sndbuf(pcb) <= 0 ) hprofile_output_tcpip_loop();

        len = tcp_sndbuf(pcb);
        if( len > length )      size = length;
        else                    size = len;
        if( size > MAXSEND )    size = MAXSEND;

        if( size > 0 )
        {
            tcp_write( pcb, &buffer[next], size, COPY );
            length -= size;
            next   += size;
        }
    }
}

static void hprofile_output_tcpip_err( void *arg, err_t err )
{
    switch( err )
    {
    case ERR_OK:        DEBUG_PRINTF("Error: OK\n" );                   break;
    case ERR_MEM:       DEBUG_PRINTF("Error: Out of Memory\n");         break;
    case ERR_BUF:       DEBUG_PRINTF("Error: Buffer\n");                break;
    case ERR_ABRT:      DEBUG_PRINTF("Error: Connection Aborted\n");    break;
    case ERR_RST:       DEBUG_PRINTF("Error: Connection Reset\n");      break;
    case ERR_CLSD:      DEBUG_PRINTF("Error: Connection Closed\n");     break;
    case ERR_CONN:      DEBUG_PRINTF("Error: Not Connected\n");         break;
    case ERR_VAL:       DEBUG_PRINTF("Error: Illegal Value\n");         break;
    case ERR_ARG:       DEBUG_PRINTF("Error: Illegal Argument\n");      break;
    case ERR_RTE:       DEBUG_PRINTF("Error: Routing Problem\n");       break;
    case ERR_USE:       DEBUG_PRINTF("Error: Address Already Used\n");  break;
    case ERR_IF:        DEBUG_PRINTF("Error: Low Level Network\n");     break;
    case ERR_ISCONN:    DEBUG_PRINTF("Error: Already Connected\n");     break;
    default:            DEBUG_PRINTF("Error: Unknown\n");               break;
    }
}

static err_t hprofile_output_tcpip_running( struct tcp_pcb *pcb )
{
    Huint len = tcp_sndbuf(pcb);
    if( length >= MAXSEND && len >= MAXSEND )
    {
        tcp_write( pcb, buffer, MAXSEND, COPY );
        memmove( buffer, &buffer[MAXSEND], length-MAXSEND );
        length -= MAXSEND;
    }

    return ERR_OK;
}

static err_t hprofile_output_tcpip_connected( void *arg, struct tcp_pcb *pcb, err_t err )
{
    printf( "Connected to server\n" );
    return ERR_OK;
}

static err_t hprofile_output_tcpip_sent(void *arg,struct tcp_pcb *pcb,u16_t l)
{
    /*
    Huint size;

    Huint len = tcp_sndbuf(pcb);
    if( len > 0 && length > 0 )
    {
        if( len < length )  size = len;
        else                size = length;
        
        printf( "Sending %d bytes of data\n", size );
        tcp_write( pcb, buffer, size, COPY );
        memmove( buffer, &buffer[size], length-size );
        length -= size;
    }
    */

    return ERR_OK;
}

static err_t hprofile_output_tcpip_recv(void *arg, struct tcp_pcb *pcb, struct pbuf *p, err_t err)
{
    printf( "Received Data\n" );
    tcp_recved( pcb, p->len );
    return ERR_OK;
}

static struct tcp_pcb* hprofile_output_tcpip_up(void *arg, struct netif *netif)
{
    err_t           err;
    struct ip_addr  server;
    struct tcp_pcb  *pcb;

    printf( "Network Interface is Up\n" );

    pcb = tcp_new();
    if( pcb == NULL )
    {
        printf( "Could not create tcp control block\n" );
        return NULL;
    }

    // Set the argument to provide to each callback
    tcp_arg( pcb, netif_default );

    // Set the callbacks to use
    //tcp_accept( pcb, tcpip_accept );
    //tcp_poll( pcb, tcpip_poll, 10 );
    tcp_sent( pcb, hprofile_output_tcpip_sent );
    tcp_recv( pcb, hprofile_output_tcpip_recv );
    tcp_err( pcb, hprofile_output_tcpip_err );

    // Form the server's TCP/IP address
    server.addr = SERVER;

    // Attempt to connect to the server 
    err = tcp_connect( pcb, &server, htons(7284), hprofile_output_tcpip_connected );
    if( err != ERR_OK ) hprofile_output_tcpip_err( NULL, err );

    return pcb;
}

static void hprofile_output_tcpip_loop()
{
    static Huint tcp_ms[2] = {0,0};
    static Huint dhcp_ms[2] = {0,0};
    static Huint etharp_ms = 0;
    static hthread_time_t start = 0;
    static hthread_time_t end = 0;
    static int up = 0;

    hthread_time_get(&end);
    hthread_time_diff(end, end, start );
    if( hthread_time_msec(end) >= 1.0f )
    {
        tcp_ms[0]++;
        tcp_ms[1]++;
        dhcp_ms[0]++; 
        dhcp_ms[1]++;
        etharp_ms++;
        hthread_time_get(&start);
    }

    if( !up && netif_is_up(netif_default) )
    {
        up = 1;
        pcb = hprofile_output_tcpip_up( NULL, netif_default );
    }

    if( ethlite_canrecv((ethlite_t*)netif_default->state) )
    {
        ethlite_netif_input( netif_default );
    }

    if( up ) {hprofile_output_tcpip_running(pcb);}
    if(tcp_ms[0] >= TCP_FAST_INTERVAL)      {tcp_fasttmr(); tcp_ms[0]=0;}
    if(tcp_ms[1] >= TCP_SLOW_INTERVAL)      {tcp_slowtmr(); tcp_ms[1]=0;}
    if(dhcp_ms[0] >= DHCP_FINE_TIMER_MSECS) {dhcp_fine_tmr(); dhcp_ms[0]=0;}
    if(dhcp_ms[1] >= DHCP_SLOW_TIMER_MSECS) {dhcp_coarse_tmr(); dhcp_ms[1]=0;}
    if(etharp_ms >= ARP_TMR_INTERVAL)       {etharp_tmr(); etharp_ms=0;}
}

static void hprofile_output_tcpip_label( const char *label )
{
    // Make sure that the TCP/IP Loop gets called at least once
    hprofile_output_tcpip_loop();

    // Loop until there is space in the output buffer
    while(length>=SIZE-strlen(label)*sizeof(char)) hprofile_output_tcpip_loop();

    // Place the label into the buffer
    memcpy( &buffer[length], label, strlen(label)*sizeof(char) );
    length += strlen(label);
}

static void hprofile_output_tcpip_column()
{
    // Make sure that the TCP/IP Loop gets called at least once
    hprofile_output_tcpip_loop();

    // Loop until there is space in the output buffer
    while( length >= SIZE - sizeof(char) ) hprofile_output_tcpip_loop();

    // Place the column indicator into the buffer
    buffer[length++] = (Hubyte)',';
}

static void hprofile_output_tcpip_row()
{
    // Make sure that the TCP/IP Loop gets called at least once
    hprofile_output_tcpip_loop();

    // Loop until there is space in the output buffer
    while( length >= SIZE - sizeof(char) ) hprofile_output_tcpip_loop();

    // Place the column indicator into the buffer
    buffer[length++] = (Hubyte)'\n';
}

static void hprofile_output_tcpip_byte( Hbyte data )
{
    // Make sure that the TCP/IP Loop gets called at least once
    hprofile_output_tcpip_loop();

    // Loop until there is space in the output buffer
    while( length >= SIZE - 4*sizeof(char) ) hprofile_output_tcpip_loop();

    // Place the number into the buffer
    length += snprintf( (char*)&buffer[length], SIZE-length, "%d", data );
}

static void hprofile_output_tcpip_short( Hshort data )
{
    // Make sure that the TCP/IP Loop gets called at least once
    hprofile_output_tcpip_loop();

    // Loop until there is space in the output buffer
    while( length >= SIZE - 8*sizeof(char) ) hprofile_output_tcpip_loop();

    // Place the number into the buffer
    length += snprintf( (char*)&buffer[length], SIZE-length, "%d", data );
}

static void hprofile_output_tcpip_int( Hint data )
{
    // Make sure that the TCP/IP Loop gets called at least once
    hprofile_output_tcpip_loop();

    // Loop until there is space in the output buffer
    while( length >= SIZE - 16*sizeof(char) ) hprofile_output_tcpip_loop();

    // Place the number into the buffer
    length += snprintf( (char*)&buffer[length], SIZE-length, "%d", data );
}

static void hprofile_output_tcpip_long( Hlong data )
{
    // Make sure that the TCP/IP Loop gets called at least once
    hprofile_output_tcpip_loop();

    // Loop until there is space in the output buffer
    while( length >= SIZE - 32*sizeof(char) ) hprofile_output_tcpip_loop();

    // Place the number into the buffer
    length += snprintf( (char*)&buffer[length], SIZE-length, "%lld", data );
}

static void hprofile_output_tcpip_float( Hfloat data )
{
    // Make sure that the TCP/IP Loop gets called at least once
    hprofile_output_tcpip_loop();

    // Loop until there is space in the output buffer
    while( length >= SIZE - 512*sizeof(char) ) hprofile_output_tcpip_loop();

    // Place the number into the buffer
    length += snprintf( (char*)&buffer[length], SIZE-length, "%f", data );
}

static void hprofile_output_tcpip_double( Hdouble data )
{
    // Make sure that the TCP/IP Loop gets called at least once
    hprofile_output_tcpip_loop();

    // Loop until there is space in the output buffer
    while( length >= SIZE - 512*sizeof(char) ) hprofile_output_tcpip_loop();

    // Place the number into the buffer
    length += snprintf( (char*)&buffer[length], SIZE-length, "%f", data );
}

static void hprofile_output_tcpip_ubyte( Hubyte data )
{
    // Make sure that the TCP/IP Loop gets called at least once
    hprofile_output_tcpip_loop();

    // Loop until there is space in the output buffer
    while( length >= SIZE - 4*sizeof(char) ) hprofile_output_tcpip_loop();

    // Place the number into the buffer
    length += snprintf( (char*)&buffer[length], SIZE-length, "%u", data );
}

static void hprofile_output_tcpip_ushort( Hushort data )
{
    // Make sure that the TCP/IP Loop gets called at least once
    hprofile_output_tcpip_loop();

    // Loop until there is space in the output buffer
    while( length >= SIZE - 8*sizeof(char) ) hprofile_output_tcpip_loop();

    // Place the number into the buffer
    length += snprintf( (char*)&buffer[length], SIZE-length, "%u", data );
}

static void hprofile_output_tcpip_uint( Huint data )
{
    // Make sure that the TCP/IP Loop gets called at least once
    hprofile_output_tcpip_loop();

    // Loop until there is space in the output buffer
    while( length >= SIZE - 16*sizeof(char) ) hprofile_output_tcpip_loop();

    // Place the number into the buffer
    length += snprintf( (char*)&buffer[length], SIZE-length, "%u", data );
}

static void hprofile_output_tcpip_ulong( Hulong data )
{
    // Make sure that the TCP/IP Loop gets called at least once
    hprofile_output_tcpip_loop();

    // Loop until there is space in the output buffer
    while( length >= SIZE - 32*sizeof(char) ) hprofile_output_tcpip_loop();

    // Place the number into the buffer
    length += snprintf( (char*)&buffer[length], SIZE-length, "%llu", data );
}

/*
#define hprofile_output_tcpip_start(f)     
#define hprofile_output_tcpip_label(l)     
#define hprofile_output_tcpip_column()     
#define hprofile_output_tcpip_row()        

#define hprofile_output_tcpip_byte(d)      
#define hprofile_output_tcpip_short(d)     
#define hprofile_output_tcpip_int(d)       
#define hprofile_output_tcpip_long(d)      
#define hprofile_output_tcpip_float(d)     
#define hprofile_output_tcpip_double(d)    

#define hprofile_output_tcpip_ubyte(d)     
#define hprofile_output_tcpip_ushort(d)    
#define hprofile_output_tcpip_uint(d)      
#define hprofile_output_tcpip_ulong(d)     
*/

#endif

