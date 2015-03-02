#include <uartlite/uartlite.h>
#include <stdlib.h>

Hint uartlite_create( uartlite_t *uart, uartlite_config_t *config )
{
    // Setup register pointers
    uart->status  = (Huint*)(config->base + UARTLITE_STATUS);
    uart->control = (Huint*)(config->base + UARTLITE_CONTROL);
    uart->send    = (Huint*)(config->base + UARTLITE_SEND);
    uart->recv    = (Huint*)(config->base + UARTLITE_RECV);

    // Return successfully
    return SUCCESS;
}

Hint uartlite_destroy( uartlite_t *uart )
{
    // Clear out the register pointers
    uart->status  = (Huint*)NULL;
    uart->control = (Huint*)NULL;
    uart->recv    = (Huint*)NULL;
    uart->send    = (Huint*)NULL;

    // Return successfully
    return SUCCESS;
}

Hint uartlite_enable( uartlite_t *uart )
{
    // Enable the interrupt bit in the control register
    *uart->control |= UARTLITE_CONTROL_INTR;
    
    // Return successfully
    return SUCCESS;
}

Hint uartlite_disable( uartlite_t *uart )
{
    // Disable the interrupt bit in the control register
    *uart->control &= ~UARTLITE_CONTROL_INTR;
    
    // Return successfully
    return SUCCESS;
}

Hint uartlite_cansend( uartlite_t *uart )
{
    return !((*uart->status & UARTLITE_STATUS_TXFULL) == UARTLITE_STATUS_TXFULL);
}

Hint uartlite_canrecv( uartlite_t *uart )
{
    return ((*uart->status & UARTLITE_STATUS_RXVALID) == UARTLITE_STATUS_RXVALID);
}

Hint uartlite_recv( uartlite_t *uart, Hubyte *data )
{
    // Wait for the recv buffer to be ready
    while( !((*uart->status & UARTLITE_STATUS_RXVALID) == UARTLITE_STATUS_RXVALID) );

    // Read an item from the receive buffer
    *data = (Hbyte)(*uart->recv);

    // Return successfully
    return SUCCESS;
}

Hint uartlite_send( uartlite_t *uart, Hubyte data )
{
    // Wait for the transmit buffer to be ready
    while( ((*uart->status & UARTLITE_STATUS_TXFULL) == UARTLITE_STATUS_TXFULL) );

    // Write an item to the transmit buffer
    *uart->send = data;

    // Return successfully
    return SUCCESS;
}

Huint uartlite_read( uartlite_t *uart, Hubyte *data, Huint num )
{
    Huint i;

    for( i = 0; i < num; i++ )
    {
        // Wait for the recv buffer to be ready
        while( !((*uart->status & UARTLITE_STATUS_RXVALID) == UARTLITE_STATUS_RXVALID) );

        // Read an item from the receive buffer
        *data++ = (Hubyte)(*uart->recv);
    }

    // Return successfully
    return i;
}

Huint uartlite_write( uartlite_t *uart, Hubyte *data, Huint num )
{
    Huint i;

    for( i = 0; i < num; i++ )
    {
        // Wait for the transmit buffer to be ready
        while( ((*uart->status & UARTLITE_STATUS_TXFULL) == UARTLITE_STATUS_TXFULL) );

        // Write an item to the transmit buffer
        *uart->send = *data++;
    }

    // Return successfully
    return i;
}

