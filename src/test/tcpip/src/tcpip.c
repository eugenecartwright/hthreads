#include <hthread.h>
#include <arch/htime.h>
#include <tcpip.h>
#include <callbacks.h>
#include <stdio.h>
#include <string.h>
#include <sleep.h>

void tcpip_init( void )
{
    ethlite_config_t    *config;
    struct netif        *netif;
    struct ip_addr      ip;
    struct ip_addr      nm;
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
    config->base        = ETH_BASE;
    config->send_toggle = Htrue;
    config->recv_toggle = Htrue;

    // Setup the IP of this machine
    printf( "Setting up IP address of board...\n" );
    ip.addr = 0x0A000001;       // 10.0.0.2
    nm.addr = 0xFFFFFF00;       // 255.255.255.0
    gw.addr = 0x0A000001;       // 10.0.0.1

    // Initialize the network interface
    printf( "Adding Ethernet Lite Network Interface...\n" );
    netif = (struct netif*)malloc( sizeof(struct netif) );
    netif_add( netif, &ip, &nm, &gw, config, ethlite_netif_init, ip_input );
    netif_set_default( netif );
}

void tcpip_loop()
{        
    struct tcp_pcb  *pcb;
    Huint           tcp_fast_ms;
    Huint           tcp_slow_ms;
    Huint           dhcp_fine_ms;
    Huint           dhcp_coarse_ms;
    Huint           etharp_ms;
    hthread_time_t  start;
    hthread_time_t  end;
    int             up;

    printf( "Running TCP/IP Loop...\n" );
    tcp_fast_ms     = 0;
    tcp_slow_ms     = 0;
    dhcp_fine_ms    = 0;
    dhcp_coarse_ms  = 0;
    etharp_ms       = 0;
    up              = 0;
    pcb             = NULL;

    hthread_time_get( &start );
    while( 1 )
    {
        if( !up && netif_is_up( netif_default) )
        {
            up = 1;
            pcb = tcpip_up( NULL, netif_default );
        }

        if( up )    tcpip_running( pcb );

        if( ethlite_canrecv((ethlite_t*)netif_default->state) )
        {
            ethlite_netif_input( netif_default );
        }

        hthread_time_get(&end);
        hthread_time_diff(end, end, start );
        if( hthread_time_msec(end) >= 1.0f )
        {
            tcp_fast_ms++;
            tcp_slow_ms++;
            dhcp_fine_ms++;
            dhcp_coarse_ms++;
            etharp_ms++;
            hthread_time_get(&start);
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
    // Start the test
    printf( "Running TCP/IP Test...\n" );

    // Initialize the TCP/IP system
    tcpip_init();
    
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
