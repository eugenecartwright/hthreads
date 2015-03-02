#include <callbacks.h>
#include <debug.h>


#define COPY        1
#define LENGTH      (10*1436)

int msg = 0;
int buf = 0;
int len = 0;
char buffer[LENGTH + 100];
int start_send = 0;

void tcpip_running( struct tcp_pcb *pcb )
{
    /*
    if( len = 0 )
    {
        buf++;
        tcp_write( pcb, buffer, 1436, 1 );
    }
    */
}

err_t tcpip_connected( void *arg, struct tcp_pcb *pcb, err_t err )
{
    int i;
    printf( "Connected to server\n" );

    if( buf == 0 )  for( i = 0; i < LENGTH+100; i++ ) buffer[i] = i;

    buf++;
    msg++;
    len = LENGTH;
    tcp_write( pcb, buffer, LENGTH, COPY );
    return ERR_OK;
}

err_t tcpip_accept( void *arg, struct tcp_pcb *newpcb, err_t err )
{
    printf( "New connection accepted\n" );
    return ERR_OK;
}

err_t tcpip_sent( void *arg, struct tcp_pcb *pcb, u16_t l )
{
    //printf( "Sent Data: (ACK=%d)\n", l );

    len = tcp_sndbuf(pcb);
    if( len > 0 )   { tcp_write( pcb, buffer, len, COPY ); }

    return ERR_OK;
}

err_t tcpip_recv( void *arg, struct tcp_pcb *pcb, struct pbuf *p, err_t err )
{
    printf( "Received Data\n" );
    tcp_recved( pcb, p->len );

    return ERR_OK;
}

struct tcp_pcb* tcpip_up( void *arg, struct netif *netif )
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
    tcp_accept( pcb, tcpip_accept );
    tcp_sent( pcb, tcpip_sent );
    tcp_recv( pcb, tcpip_recv );
    tcp_poll( pcb, tcpip_poll, 10 );
    tcp_err( pcb, tcpip_err );

    // Form the server's TCP/IP address
    server.addr = 0xC0A80103;
    //server.addr = 0xC0A80164;
    //server.addr = 0xC0A8010A;
    //server.addr = 0xC0A8010B;

    // Attempt to connect to the server 
    err = tcp_connect( pcb, &server, htons(7284), tcpip_connected );
    if( err != ERR_OK ) tcpip_err( NULL, err );

    return pcb;
}

err_t tcpip_poll( void *arg, struct tcp_pcb *tpcb )
{
    printf( "Application Polled\n" );

    return ERR_OK;
}

void tcpip_err( void *arg, err_t err )
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
