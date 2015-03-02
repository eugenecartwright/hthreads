#include <eth.h>
#include <string.h>
#include <arch/htime.h>

// The MAC Address to use for the ethernet device
Hubyte ETH_MACADDR[] = {0x00, 0x50, 0x56, 0xC0, 0x00, 0x09};

// The options to use with the ethernet device
const Huint  ETH_OPTIONS   = XEM_INSERT_FCS_OPTION |
                             XEM_INSERT_PAD_OPTION |
                             XEM_UNICAST_OPTION |
                             XEM_BROADCAST_OPTION |
                             XEM_FDUPLEX_OPTION |
                             XEM_FLOW_CONTROL_OPTION |
                             XEM_POLLED_OPTION |
                             XEM_STRIP_PAD_FCS_OPTION;

Hint eth_init( eth_t *eth, eth_config_t *config )
{
    XStatus res;
    Hubyte  mac[6];

    // Don't use DMA processing
    config->IpIfDmaConfig = XEM_CFG_NO_DMA;

    // Initialize the ethernet device
    printf( "Initializing ethernet device..." );
    res = XEmac_Initialize( eth, config->DeviceId );
    if( res != XST_SUCCESS )    { printf( "failed\n" ); return -EINVAL; }
    else                        { printf( "success\n" ); }

    // Stop the ethernet so that we can configure it
    res = XEmac_Stop( eth );

    // Set the MAC address of the ethernet device
    printf( "Setting address of ethernet device..." );
    res = XEmac_SetMacAddress( eth, ETH_MACADDR );
    if( res != XST_SUCCESS )    { printf( "failed\n" ); return -EINVAL; }
    else                        { printf( "success\n" ); }

    // Set the configuration options for the ethernet device
    printf( "Setting options for ethernet device..." );
    res = XEmac_SetOptions( eth, ETH_OPTIONS );
    if( res != XST_SUCCESS )    { printf( "failed\n" ); return -EINVAL; }
    else                        { printf( "success\n" ); }

    // Start the ethernet device
    printf( "Starting ethernet device..." );
    res = XEmac_Start( eth );
    if( res != XST_SUCCESS )    { printf( "failed\n" ); return -EINVAL; }
    else                        { printf( "success\n" ); }

    // Clear all of the statistics
    XEmac_ClearStats( eth );

    // Show the MAC address
    XEmac_GetMacAddress( eth, mac );
    printf( "Ethernet Device Address: " );
    printf( "%.2x:%.2x:%.2x:%.2x:%.2x:%.2x\n", mac[0],mac[1],mac[2],mac[3],mac[4],mac[5]);

    // Return succcessfully
    return 0;
}

Hint eth_destroy( eth_t *eth )
{
    // Stop the ethernet device
    XEmac_Stop( eth );

    // Return successfully
    return 0;
}

Hint eth_recv( eth_t *eth, void *data, Huint *size )
{
    XStatus res;
    const Hubyte ack[] = { 0x00, 0x50, 0x56, 0xC0, 0x00, 0x09,
                           0x00, 0x0d, 0x61, 0x4a, 0xc4, 0xd6,
                           0x00, 0x04, 0xCA, 0xFE, 0xBA, 0xBE };

    // Read data from the ethernet device
    res = XEmac_PollRecv( eth, data, (Xuint32*)size );

    // Determine if an error occurred
    switch( res )
    {
    case XST_SUCCESS:
        res = XEmac_PollSend( eth, (Hubyte*)ack, 18 );
        return 0;

    case XST_NO_DATA:               return 1;
    case XST_BUFFER_TOO_SMALL:      return 2;
    default:                        return -EINVAL;
    }
}

Hint eth_send( eth_t *eth, void *data, Huint size )
{
    XStatus res;

    // Send data using the ethernet device
    res = XEmac_PollSend( eth, data, size );
    switch( res )
    {
    case XST_SUCCESS:               return 0;
    case XST_FIFO_NO_ROOM:          return 1;
    case XST_EMAC_COLLISION_ERROR:  return 1;
    default:                        return -EINVAL;
    }

    // Return successfully
    return 0;
}
