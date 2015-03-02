#include <ethlite/ethlite.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

Hint ethlite_create( ethlite_t *eth, ethlite_config_t *config )
{
    // Setup the transmit buffer
    eth->txbuffer[0]  = (Huint*)(config->base + ETHLITE_TXPING_BUFFER);
    eth->txcontrol[0] = (Huint*)(config->base + ETHLITE_TXPING_CONTROL);
    eth->txlength[0]  = (Huint*)(config->base + ETHLITE_TXPING_LENGTH);
    
    // Setup the recieve buffer
    eth->rxbuffer[0]  = (Huint*)(config->base + ETHLITE_RXPING_BUFFER);
    eth->rxcontrol[0] = (Huint*)(config->base + ETHLITE_RXPING_CONTROL);
    eth->rxlength[0]  = (Huint*)(config->base + ETHLITE_RXPING_LENGTH);
    
    // Setup the transmit pong buffer if the device is configured for it
    if( config->send_toggle)
    {
        eth->txbuffer[1]  = (Huint*)(config->base + ETHLITE_TXPONG_BUFFER);
        eth->txcontrol[1] = (Huint*)(config->base + ETHLITE_TXPONG_CONTROL);
        eth->txlength[1]  = (Huint*)(config->base + ETHLITE_TXPONG_LENGTH);
    }
    else
    {
        eth->txbuffer[1]  = NULL;
        eth->txcontrol[1] = NULL;
        eth->txlength[1]  = NULL;
    }

    // Setup the receive pong buffer if the device is configured for it
    if( config->recv_toggle)
    {
        eth->rxbuffer[1]  = (Huint*)(config->base + ETHLITE_RXPONG_BUFFER);
        eth->rxcontrol[1] = (Huint*)(config->base + ETHLITE_RXPONG_CONTROL);
        eth->rxlength[1]  = (Huint*)(config->base + ETHLITE_RXPONG_LENGTH);
    }
    else
    {
        eth->rxbuffer[1]  = NULL;
        eth->rxcontrol[1] = NULL;
        eth->rxlength[1] = NULL;
    }

    // Set the default mac address
    eth->mac[0] = 0x00;
    eth->mac[1] = 0x00;
    eth->mac[2] = 0x5E;
    eth->mac[3] = 0x00;
    eth->mac[4] = 0xFA;
    eth->mac[5] = 0xCE;
    eth->mac[6] = 0x00;
    eth->mac[7] = 0x00;

    // Interrupts are off by default
    eth->txintr = 0;
    eth->rxintr = 0;

    // Flush the send and receive buffers
    ethlite_recvflush( eth );
    ethlite_sendflush( eth );

    // Setup the mac address
    ethlite_setmac( eth, eth->mac );

    return SUCCESS;
}

Hint ethlite_destroy( ethlite_t *eth )
{
    eth->txbuffer[0]  = NULL;
    eth->txcontrol[0] = NULL;
    eth->txlength[0]  = NULL;

    eth->txbuffer[1]  = NULL;
    eth->txcontrol[1] = NULL;
    eth->txlength[1]  = NULL;

    eth->rxbuffer[0]  = NULL;
    eth->rxcontrol[0] = NULL;
    eth->rxlength[0]  = NULL;

    eth->rxbuffer[1]  = NULL;
    eth->rxcontrol[1] = NULL;
    eth->rxlength[1]  = NULL;
    return SUCCESS;
}

Huint ethlite_txwait( ethlite_t *eth )
{
    if( eth->txcontrol[1] == NULL )
    {
        while( (*eth->txcontrol[0]&ETHLITE_CONTROL_STATUS) );
        return 0;
    }
    else
    {
        while( (*eth->txcontrol[0]&ETHLITE_CONTROL_STATUS) &&
               (*eth->txcontrol[1]&ETHLITE_CONTROL_STATUS) );

        if( (*eth->txcontrol[0]&ETHLITE_CONTROL_STATUS) )   return 1;
        else                                                return 0;
    }
}

Huint ethlite_rxwait( ethlite_t *eth )
{
    if( eth->rxcontrol[1] == NULL )
    {
        while( !(*eth->rxcontrol[0]&ETHLITE_CONTROL_STATUS) );
        return 0;
    }
    else
    {
        while( !(*eth->rxcontrol[0]&ETHLITE_CONTROL_STATUS) &&
               !(*eth->rxcontrol[1]&ETHLITE_CONTROL_STATUS) );

        if( !(*eth->rxcontrol[0]&ETHLITE_CONTROL_STATUS) )  return 1;
        else                                                return 0;
    }
}

Hbool ethlite_cansend( ethlite_t *eth )
{
    if( eth->txcontrol[1] == NULL )
    {
        return !(*eth->txcontrol[0]&ETHLITE_CONTROL_STATUS);
    }
    else
    {
        return  !(*eth->txcontrol[0]&ETHLITE_CONTROL_STATUS) ||
                !(*eth->txcontrol[1]&ETHLITE_CONTROL_STATUS);
    }
}

Hbool ethlite_canrecv( ethlite_t *eth )
{
    if( eth->rxcontrol[1] == NULL )
    {
        return (*eth->rxcontrol[0]&ETHLITE_CONTROL_STATUS);
    }
    else
    {
        return  (*eth->rxcontrol[0]&ETHLITE_CONTROL_STATUS) ||
                (*eth->rxcontrol[1]&ETHLITE_CONTROL_STATUS);

    }
}

void ethlite_setmac( ethlite_t *eth, Hubyte *mac )
{
    Huint b;

    // Copy the mac address
    memcpy( &eth->mac, mac, 6 );

    // Get a free transmit buffer to use
    b = ethlite_txwait( eth );

    // Send the mac address to the ping buffer
    eth->txbuffer[b][0] = ((Huint*)&eth->mac)[0];
    eth->txbuffer[b][1] = ((Huint*)&eth->mac)[1];
    *eth->txcontrol[b]  = ETHLITE_CONTROL_STATUS | ETHLITE_CONTROL_PROGRAM;
}

void ethlite_getmac( ethlite_t *eth, Hubyte *mac )
{
    memcpy( mac, &eth->mac, 6 );
}

void ethlite_send( ethlite_t *eth, ethlite_frame_t *frame, Hushort len )
{
    Hint  b;

    // Get a free transmit buffer to use
    b = ethlite_txwait( eth );

    // Copy the source into the frame
    memcpy( frame->src, eth->mac, 6 );
    
    // Copy the data to the ethernet controller
    ethlite_alignedwrite( eth->txbuffer[b], frame, len );

    // Set the length of the packet to be transmitted
    *eth->txlength[b] = (Huint)(len & 0x0000FFFF);

    // Toggle the status bit to send the frame
    *eth->txcontrol[b] = eth->txintr | ETHLITE_CONTROL_STATUS;
}

void ethlite_recv( ethlite_t *eth, ethlite_frame_t *frame )
{
    Huint b;

    // Get a free receive buffer to use
    b = ethlite_rxwait( eth );

    // Get the destination and source addresses along with the frame length
    memcpy( frame, eth->rxbuffer[b], 14 );

    // Read the remaining bytes in the frame
    memcpy( frame->data, eth->rxbuffer+14, frame->length );

    // Clear the status bit to allow more read operations
    *eth->rxcontrol[b] = eth->rxintr;
}

void ethlite_enablesend( ethlite_t *eth )
{
    eth->txintr = ETHLITE_CONTROL_INTR;
    *eth->txcontrol[0] = *eth->txcontrol[0] | ETHLITE_CONTROL_INTR;
}

void ethlite_disablesend( ethlite_t *eth )
{
    eth->txintr = 0;
    *eth->txcontrol[0] = *eth->txcontrol[0] & ~ETHLITE_CONTROL_INTR;
}

void ethlite_enablerecv( ethlite_t *eth )
{
    eth->rxintr = ETHLITE_CONTROL_INTR;
    *eth->rxcontrol[0] = *eth->rxcontrol[0] | ETHLITE_CONTROL_INTR;
}

void ethlite_disablerecv( ethlite_t *eth )
{
    eth->rxintr = 0;
    *eth->rxcontrol[0] = *eth->rxcontrol[0] & ~ETHLITE_CONTROL_INTR;
}

void ethlite_sendfill( ethlite_t *eth, Huint b, Huint *data, Huint len )
{
    Hint i;
    Hint l;

    if( len % 4 == 0 )  l = len / 4;
    else                l = len / 4 + 1;

    for( i = 0; i < l; i++ )    eth->txbuffer[b][i] = data[i];
}

void ethlite_sendsignal( ethlite_t *eth, Huint b, Hushort length )
{
    *eth->txlength[b]  = length;
    *eth->txcontrol[b] = eth->txintr | ETHLITE_CONTROL_STATUS;
}

void ethlite_recvfill( ethlite_t *eth, Huint b, Huint *data, Huint len )
{
    Huint i;
    Huint l;

    // Calculate the word length of the buffer
    if( len % 4 == 0 )  l = len / 4;
    else                l = len / 4 + 1;

    // Fill the buffer with data
    for( i = 0; i < l; i++ )    data[i] = eth->rxbuffer[b][i];
}

void ethlite_recvack( ethlite_t *eth, Huint b )
{
    *eth->rxcontrol[b] = eth->rxintr;
}

Hushort ethlite_recvsize( ethlite_t *eth, Huint b )
{
    Huint len;

    len = *eth->rxlength[b];
    len = (len >> 16);

    if( len > 1500 )   return 1500;
    else               return len;   
}

void ethlite_sendflush( ethlite_t *eth )
{
    if( eth->txcontrol[0] != NULL ) *eth->txcontrol[0] = eth->txintr;
    if( eth->txcontrol[1] != NULL ) *eth->txcontrol[1] = eth->txintr;
}

void ethlite_recvflush( ethlite_t *eth )
{
    Hint    con;
    Huint   rcs;

    con = 1;
    while( con )
    {
        con = ethlite_canrecv( eth );
        if( eth->rxcontrol[0] != NULL )
        {
            rcs = *eth->rxcontrol[0];
            rcs &= ETHLITE_CONTROL_INTR;
            *eth->rxcontrol[0] = rcs;
        }

        if( eth->rxcontrol[1] != NULL )
        {
            rcs = *eth->rxcontrol[1];
            rcs &= ETHLITE_CONTROL_INTR;
            *eth->rxcontrol[1] = rcs;
        }
    }
}

void ethlite_alignedwrite( void *dst, void *src, Huint len )
{
    if( (Huint)src & 0x1 )          ethlite_bytealignedwrite( dst, src, len );
    else if( (Huint)src & 0x2 )     ethlite_hwordalignedwrite( dst, src, len );
    else                            ethlite_wordalignedwrite( dst, src, len );
}

void ethlite_bytealignedwrite( Huint *dst, Hubyte *src, Huint len )
{
    Huint   flen;
    Huint   data;

    // Calculare the number of full words to copy
    flen = len  / 4;

    // Calculate the number of left over words to copy
    len -= flen * 2;

    // Perform the full word copy
    while( flen-- > 0 )
    {
        data = (*src++);
        data = (data << 8) | (*src++);
        data = (data << 8) | (*src++);
        data = (data << 8) | (*src++);

        *dst++  = data;
    }   

    // Copy over the remaining bytes
    if( len > 0 )
    {
        data = 0;
        while( len-- > 0 )  data = (data << 8) | (Huint)(*src++);
        *dst++  = data;
    }
}

void ethlite_hwordalignedwrite( Huint *dst, Hushort *src, Huint len )
{
    Huint   flen;
    Huint   data;

    // Calculare the number of full words to copy
    flen = len  / 4;

    // Calculate the number of left over words to copy
    len -= flen * 2;

    // Perform the full word copy
    while( flen-- > 0 )
    {
        data = (*src++);
        data = (data << 16) | (*src++);

        *dst++  = data;
    }   

    // Copy over the remaining bytes
    if( len > 0 )   ethlite_bytealignedwrite( dst, (Hubyte*)src, len );
}

void ethlite_wordalignedwrite( Huint *dst, Huint *src, Huint len )
{
    Huint   flen;

    // Calculate the number of full words to copy
    flen = len / 4;

    // Calculate the number of left over words to copy
    len -= flen * 4;
    
    // Perform the full word copy
    while( flen-- > 0 )    *dst++ = *src++;

    // Copy over the remaining bytes
    if( len > 0 )   ethlite_bytealignedwrite( dst, (Hubyte*)src, len );
}
