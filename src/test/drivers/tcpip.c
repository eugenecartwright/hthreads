#include <hthread.h>
#include <config.h>
#include <ethlite/netif.h>
#include <stdio.h>
#include <string.h>
#include <sleep.h>
#include <time.h>
#include <xparameters.h>

#define MILLISECOND     (CLOCKS_PER_SEC / 1000)

err_t tcpip_connected( void *arg, struct tcp_pcb *pcb, err_t err )
{
    printf( "Connected to system\n" );
    return ERR_OK;
}

err_t tcpip_accept( void *arg, struct tcp_pcb *newpcb, err_t err )
{
    printf( "New connection accepted\n" );
    return ERR_OK;
}

err_t tcpip_sent( void *arg, struct tcp_pcb *tpcb, u16_t len )
{
    printf( "Send Data\n" );
    return ERR_OK;
}

err_t tcpip_recv( void *arg, struct tcp_pcb *tpcb, struct pbuf *p, err_t err )
{
    printf( "Received Data\n" );
    return ERR_OK;
}

err_t tcpip_poll( void *arg, struct tcp_pcb *tpcb )
{
    printf( "Application Polled\n" );
    return ERR_OK;
}

void tcpip_err( void *arg, err_t err )
{
    printf( "Error: %d\n", err );
}

struct tcp_pcb* tcpip_init( void )
{
    struct tcp_pcb      *pcb;
    ethlite_config_t    *config;
    struct netif        *netif;
    struct ip_addr      ipaddr;
    struct ip_addr      netmask;
    struct ip_addr      gw;

    // Initialize the system
    printf( "Initializing LWIP Systems...\n" );
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

    // Setup the configuration
    printf( "Setting up Ethernet Lite Configuration...\n" );
    config = (ethlite_config_t*)malloc( sizeof(ethlite_config_t) );
    config->base        = ETHLITE_BASEADDR;
    config->send_toggle = Htrue;
    config->recv_toggle = Htrue;

    // Setup the IP of this machine
    printf( "Setting up IP address of board...\n" );
    //ipaddr.addr     = 0xA9FE9122;       // 169.254.145.34
    //netmask.addr    = 0xFFFFFF00;       // 255.255.255.0
    //gw.addr         = 0xA9FE9122;       // 169.254.145.34
    ipaddr.addr     = 0x0A000001;       // 10.0.0.2
    netmask.addr    = 0xFFFFFF00;       // 255.255.255.0
    gw.addr         = 0x0A000001;       // 10.0.0.1
    //ipaddr.addr     = 0xC0A801C8;       // 192.168.1.200
    //netmask.addr    = 0xFFFFFF00;       // 255.255.255.0
    //gw.addr         = 0xC0A80103;       // 192.168.1.3

    // Initialize the network interface
    printf( "Adding Ethernet Lite Network Interface...\n" );
    netif = (struct netif*)malloc( sizeof(struct netif) );
    netif_add( netif, &ipaddr, &netmask, &gw, config, ethlite_netif_init, ip_input );
    netif_set_default( netif );
    netif_set_up( netif );

    // Create a new tcp control block
    printf( "Creating new TCP control block...\n" );
    pcb = tcp_new();
    if( pcb == NULL )   { printf( "Could not create tcp control block\n" ); return NULL; }

    // Set the argument to provide to each callback
    tcp_arg( pcb, netif );
    tcp_accept( pcb, tcpip_accept );
    tcp_sent( pcb, tcpip_sent );
    tcp_recv( pcb, tcpip_recv );
    tcp_poll( pcb, tcpip_poll, 10 );
    tcp_err( pcb, tcpip_err );

    // Return the allocated control block
    return pcb;
}

void tcpip_loop()
{        
    Huint   tcp_fast_ms;
    Huint   tcp_slow_ms;
    Huint   dhcp_fine_ms;
    Huint   dhcp_coarse_ms;
    Huint   etharp_ms;
    clock_t start;
    clock_t end;

    printf( "Running TCP/IP Loop...\n" );
    tcp_fast_ms = 0;
    tcp_slow_ms = 0;
    dhcp_fine_ms = 0;
    dhcp_coarse_ms = 0;
    etharp_ms = 0;

    start = clock();
    while( 1 )
    {
        if( ethlite_canrecv((ethlite_t*)netif_default->state) )
        {
            ethlite_netif_input( netif_default );
        }

        end = clock();
        if( (end - start) >= MILLISECOND )
        {
            tcp_fast_ms++;
            tcp_slow_ms++;
            dhcp_fine_ms++;
            dhcp_coarse_ms++;
            etharp_ms++;
            start = clock();
        }

        if( tcp_fast_ms >= TCP_FAST_INTERVAL )
        {
            //printf( "TCP/IP Fast Timer\n" );
            tcp_fasttmr();
            tcp_fast_ms=0;
        }
        
        if( tcp_slow_ms >= TCP_SLOW_INTERVAL )
        {
            //printf( "TCP/IP Slow Timer\n" );
            tcp_slowtmr();
            tcp_slow_ms=0;
        }
        
        if( dhcp_fine_ms >= DHCP_FINE_TIMER_MSECS )
        {
            //printf( "DHCP Fine Timer\n" );
            dhcp_fine_tmr();
            dhcp_fine_ms=0;
        }
        
        if( dhcp_coarse_ms >= 1000*DHCP_COARSE_TIMER_SECS )
        {
            //printf( "DHCP Coarse Timer\n" );
            dhcp_coarse_tmr();
            dhcp_coarse_ms=0;
        }
        
        if( etharp_ms >= ARP_TMR_INTERVAL )
        {
            //printf( "ARP Timer\n" );
            etharp_tmr();
            etharp_ms=0; 
        }
    }
}

void tcpip_test( void )
{
    err_t           err;
    struct tcp_pcb  *pcb;
    struct ip_addr  server;
    
    // Start the test
    printf( "Running TCP/IP Test...\n" );

    // Initialize the TCP/IP system
    pcb = tcpip_init();
    if( pcb ==  NULL )  return;
    
    // Form the server's TCP/IP address
    server.addr = 0xC0A80103;

    // Attempt to connect to the server 
    printf( "Attempting to connect to server...\n" );
    err = tcp_connect( pcb, &server, 8764, tcpip_connected );
    if( err == ERR_MEM ) { printf( "Could not connect to server\n" ); return; }

    // Get an IP address using DHCP
    dhcp_start( netif_default );

    // Run the system loop
    tcpip_loop();
}

int main( int argc, const char *argv[] )
{
    tcpip_test();
    return 0;
}
