#include <ps2/ps2.h>
#include <stdlib.h>

Hint ps2_create( ps2_t *ps2, ps2_config_t *config )
{
    ps2->reset      = (Hubyte*)(config->base + PS2_RESET);
    ps2->status     = (Hubyte*)(config->base + PS2_STATUS);
    ps2->send       = (Hubyte*)(config->base + PS2_SEND);
    ps2->recv       = (Hubyte*)(config->base + PS2_RECV);
    ps2->intr       = (Hubyte*)(config->base + PS2_INTERRUPTS);
    ps2->clear      = (Hubyte*)(config->base + PS2_CLEAR);
    ps2->enable     = (Hubyte*)(config->base + PS2_ENABLE);
    ps2->disable    = (Hubyte*)(config->base + PS2_DISABLE);

    ps2_reset( ps2 );
    return SUCCESS;
}

Hint ps2_destroy( ps2_t *ps2 )
{
    return SUCCESS;
}

void ps2_reset( ps2_t *ps2 )
{
    *ps2->reset = PS2_RESET_ENABLE;
    *ps2->reset = PS2_RESET_DISABLE;
}

Hubyte ps2_status( ps2_t *ps2 )
{
    return *ps2->status;
}

Hubyte ps2_interrupts( ps2_t *ps2 )
{
    return *ps2->intr;
}

void ps2_clear( ps2_t *ps2, Hubyte mask )
{
    *ps2->clear = mask;
}

Hubyte ps2_isenabled( ps2_t *ps2, Hubyte mask )
{
    return *ps2->enable & mask;
}

void ps2_enable( ps2_t *ps2, Hubyte mask )
{
    *ps2->enable = mask;
}

void ps2_disable( ps2_t *ps2, Hubyte mask )
{
    *ps2->disable = mask;
}

Hbool ps2_sendfull( ps2_t *ps2 )
{
    return *ps2->status & PS2_SEND_FULL;
}

Hbool ps2_recvempty( ps2_t *ps2 )
{
    return !((*ps2->status) & PS2_RECV_FULL);
}

void ps2_sendbyte( ps2_t *ps2, Hubyte data )
{
    // Wait for space in the transmit buffer
    while( ps2_sendfull(ps2) );

    // Send the data
    *ps2->send = data;
}

Hubyte ps2_recvbyte( ps2_t *ps2 )
{
    // Wait for something to appear in the receive buffer
    while( ps2_recvempty(ps2) );

    // Receive the data
    return *ps2->recv;
}
