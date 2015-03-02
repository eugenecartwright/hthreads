#include <ethlite/netif.h>
#include <stdlib.h>
#include <debug.h>

void* ethlite_netif_malloc( Huint size )
{   
    Huint   alloc;
    Huint   buffer;
    Hubyte  *off;

    // Allocate the buffer, we include extra space in case we need to align the memory
    alloc = (Huint)malloc( size+4 );
    
    // Align the buffer to a 4-byte boundary
    buffer = alloc + 4 - (alloc % 4);

    // Store the offset in the previous byte
    off = (Hubyte*)(buffer-1);
    *off = 4 - alloc % 4;

    return (void*)buffer;
}
    
void ethlite_netif_free( void *mem )
{
    Huint   alloc;
    Huint   buffer;
    Hubyte  *off;

    // Cast the pointer to an integer
    buffer = (Huint)mem;

    // Get the offset that was used during alignment
    off = (Hubyte*)(buffer-1);

    // Retreive the orignally allocated buffer
    alloc = buffer - *off;

    // Free the original buffer
    free( (void*)alloc );
}

err_t ethlite_netif_llinit( struct netif *netif )
{
    Hint i;
    DEBUG_PRINTF( "Ethernet Lite Low Level Network Interface Initialization\n" );

    // This interface can send a maximum of 1500 bytes at a time
    netif->mtu       = 1500;

    // This interface is broadcast capable
    netif->flags     = NETIF_FLAG_BROADCAST;

    // Set the length of the MAC address
    netif->hwaddr_len = 6;

    printf( "Mac Address: " );
    for( i = 0; i < 6; i++ )
    {
        if( i < 5 ) printf( "%2.2X:", netif->hwaddr[i] );
        else        printf( "%2.2X\n", netif->hwaddr[i] );
    }
    
    // Return successfully
    return ERR_OK;
}

struct pbuf* ethlite_netif_llinput( struct netif *netif )
{
    Hint                i;
    int                 buffer;
    ethlite_netif_t     *enetif;
    struct pbuf         *p;
    u16_t               len;
    Hubyte              *rb;
    Hubyte              *pb;

    // Get the ethernet interface
    enetif = (ethlite_netif_t*)netif->state;
    
    // Get a buffer to read from
    buffer = ethlite_rxwait( &enetif->eth );

    // Get the size of the frame in the buffer
    len = ethlite_recvsize( &enetif->eth, buffer );

    // Allow room to ethernet padding if neccessary
    ADD_SIZE(len);

    /* We allocate a pbuf chain of pbufs from the pool. */
    p = pbuf_alloc(PBUF_RAW, len, PBUF_POOL);

    if (p != NULL)
    {
        // Drop the padding word if neccessary
        DROP_SIZE(p);

        /*
        size = 0;
        for(q = p; q != NULL; q = q->next)
        {
            // Read bytes from the interface into the buffer
            ethlite_recvfill( &enetif->eth, buffer, size, q->payload, q->len );

            // Increment the number of bytes read
            size += q->len;
        }
        */

        // Get the frame from the ethernet interface
        ethlite_recvfill( &enetif->eth, buffer, enetif->rxbuffer, len );

        // Get pointers to the data
        pb = (Hubyte*)p->payload;
        rb = (Hubyte*)enetif->rxbuffer;

        // Copy the data in to the pbuf
        for( i = 0; i < len; i++ )  *pb++ = *rb++;

        // Tell the interface that the frame has been read
        ethlite_recvack( &enetif->eth, buffer );

        // Reclaim the padding word if neccesary
        RECLAIM_SIZE(p);

        // Update the receive statistics
        RECV_INC();
    }
    else
    {
        // Drop the packet by ack'ing the interface without reading the data
        ethlite_recvack( &enetif->eth, buffer );

        // Update the memory error statistics
        MEMERR_INC();

        // Update the dropped packets statistics
        DROP_INC();
    }

    // Return the input buffer
    return p;
}

err_t ethlite_netif_lloutput( struct netif *netif, struct pbuf *p )
{
    int             size;
    int             buffer;
    struct pbuf     *q;
    ethlite_netif_t *enetif;
    Hubyte          *fbp;

    // Get the ethernet interface
    enetif = (ethlite_netif_t*)netif->state;

    // Allocate a buffer the size of the maximum frame
    fbp = (Hubyte*)enetif->txbuffer;

    // Get a free buffer to use for the transmission
    buffer = ethlite_txwait( &enetif->eth );

    // Drop the padding word if neccessary
    DROP_SIZE(p);

    size = 0;
    for( q = p; q != NULL; q = q->next )
    {
        // Add the pbuf to the frame buffer
        memcpy( fbp, q->payload, q->len );

        // Move to the next spot in the frame buffer
        fbp += q->len;

        // Increment the number of bytes in the packet
        size += q->len;
    }

    // Send the frame
    ethlite_sendfill( &enetif->eth, buffer, enetif->txbuffer, size );

    // Signal the ethernet interface to send the packet
    ethlite_sendsignal( &enetif->eth, buffer, size );

    // Reclaim the padding word if neccessary
    RECLAIM_SIZE(p);

    // Update the transmission statistics
    SEND_INC();

    // Return successfully
    return ERR_OK;
}

err_t ethlite_netif_init( struct netif *netif )
{
    Hint                i;
    ethlite_netif_t     *enetif;
    ethlite_config_t    *config;

    DEBUG_PRINTF( "Ethernet Lite Network Interface Initialization\n" );

    // Get the configuration to use
    config = (ethlite_config_t*)netif->state;
    
    // Allocate a network interface structure
    DEBUG_PRINTF( "Ethernet Lite Network Interface Memory Allocation\n" );
    enetif = (ethlite_netif_t*)malloc( sizeof(ethlite_netif_t) );
    if( enetif == NULL )
    {
        DEBUG_PRINTF( "Ethernet Lite NetIf: out of memory\n" );
        return ERR_MEM;
    }

    // Allocate an aligned buffer to work with
    enetif->txbuffer = ethlite_netif_malloc( 1500 );
    enetif->rxbuffer = ethlite_netif_malloc( 1500 );

    // Setup the network interface
    DEBUG_PRINTF( "Ethernet Lite Network Interface Creating Driver\n" );
    ethlite_create( &enetif->eth, config );

    // Setup the network interface given to us
    DEBUG_PRINTF( "Ethernet Lite Network Interface Setup\n" );
    netif->state        = enetif;
    netif->name[0]      = ETHLITE_NETIF_NAME0;
    netif->name[1]      = ETHLITE_NETIF_NAME1;
    netif->output       = ethlite_netif_output;
    netif->linkoutput   = ethlite_netif_lloutput;

    // Setup the ethernet mac address for the network interface
    DEBUG_PRINTF( "Ethernet Lite Network Interface Setup MAC Address\n" );
    for( i = 0; i < 6; i++ )    netif->hwaddr[i] =enetif->eth.mac[i];
    //ethlite_setmac( &enetif->eth, netif->hwaddr );

    // Initialize the ethernet lite low level network interface
    ethlite_netif_llinit(netif);

    // Return successfully
    return ERR_OK;
}

void ethlite_netif_input( struct netif *netif )
{
    s16_t             size;
    ethlite_netif_t   *enetif;
    struct eth_hdr    *ethhdr;
    struct pbuf       *p;

    // Get the ethernet lite network interface
    enetif = (ethlite_netif_t*)netif->state;

    // Get an ethernet frame from the low level interface
    p = ethlite_netif_llinput( netif );

    // Abort if no packet could be read
    if( p == NULL ) return;

    // Increment the link statistics
    RECV_INC();

    // The buffer contains a ethernet frame so we are going to examine it
    ethhdr = (struct eth_hdr*)p->payload;

    // Determine what to do with the ethernet packet that we received
    switch( htons(ethhdr->type) )
    {
    case ETHTYPE_IP:
        size = (s16_t)sizeof(struct eth_hdr);
        etharp_ip_input(netif, p);              // Update the arp table
        pbuf_header(p, -size );                 // Remove the ethernet header
        netif->input(p, netif);                 // Pass it to the network
        break;

    case ETHTYPE_ARP:
      etharp_arp_input(netif, (struct eth_addr*)enetif->eth.mac, p); // Update the arp table
      break;
   
    default:
      DEBUG_PRINTF( "Unknown Frame Read: 0x%8.8x\n", ethhdr->type );
      pbuf_free(p);                                 // Free the allocated buffer
      p = NULL;
      break;
    }
}

err_t ethlite_netif_output( struct netif *netif, struct pbuf *p, struct ip_addr *ipaddr )
{
    // Resolve the hardware mac address and then send the packet
    return etharp_output( netif, ipaddr, p );
}
