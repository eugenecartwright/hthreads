#include <gpio/gpio.h>
#include <stdlib.h>

Hint gpio_create( gpio_t *gpio, gpio_config_t *config )
{
    // Store the number of valid bits for this gpio
    gpio->bits = config->bits;

    // Setup pointers the the channel 1 data and direction registers
    gpio->data[0]      = (Huint*)(config->base + GPIO_CHANNEL1_DATA);
    gpio->direction[0] = (Huint*)(config->base + GPIO_CHANNEL1_TRIS);

    if( config->dual )
    {
        // Setup pointers the the channel 2 data and direction registers
        gpio->data[1]       = (Huint*)(config->base + GPIO_CHANNEL2_DATA);
        gpio->direction[1]  = (Huint*)(config->base + GPIO_CHANNEL2_TRIS);
    }
    else
    {
        // Setup pointers to the channel 2 to be non-existant
        gpio->data[1]       = (Huint*)NULL;
        gpio->direction[1]  = (Huint*)NULL;
    }

    if( config->intr )
    {
        // Setup pointers to the interrupt control registers
        gpio->gier = (Huint*)(config->base + GPIO_INTERRPT_GIER);
        gpio->ier  = (Huint*)(config->base + GPIO_INTERRPT_IER);
        gpio->isr  = (Huint*)(config->base + GPIO_INTERRPT_ISR);
    }
    else
    {
        // Setup pointers to the interrupt control registers to be non-existant
        gpio->gier = (Huint*)NULL;
        gpio->ier  = (Huint*)NULL;
        gpio->isr  = (Huint*)NULL;
    }

    return SUCCESS;
}

Hint gpio_destroy( gpio_t *gpio )
{
    gpio->data[0]      = (Huint*)NULL;
    gpio->direction[0] = (Huint*)NULL;
    gpio->data[1]      = (Huint*)NULL;
    gpio->direction[1] = (Huint*)NULL;
    gpio->gier         = (Huint*)NULL;
    gpio->ier          = (Huint*)NULL;
    gpio->isr          = (Huint*)NULL;

    return SUCCESS;
}

void gpio_setdirection( gpio_t *gpio, Huint channel, Huint  mask )
{
    // Set the I/O direction for a channel if that channel exists
    if( gpio->direction[channel] == NULL )  return;
    *gpio->direction[channel] = mask;
}

Huint gpio_getdirection( gpio_t *gpio, Huint channel )
{
    // Get the I/O direction for a channel if that channel exists
    if( gpio->direction[channel] == NULL )  return 0x00000000;
    return *gpio->direction[channel];
}

void gpio_setdata( gpio_t *gpio, Huint channel, Huint data )
{
    // Write data to the channel register if that channel exists
    if( gpio->data[channel] == NULL )   return;
    *gpio->data[channel] = ~data;
}

Huint gpio_getdata( gpio_t *gpio, Huint channel )
{
    Huint data;
    
    // Read data from the channel register if that channel exists
    if( gpio->data[channel] == NULL )   return 0x00000000;
    
    data = *gpio->data[channel];
    data = ~data & ((1 << gpio->bits)-1);

    return data;
}

void gpio_globalenable( gpio_t *gpio )
{
    if( gpio->gier == NULL )  return;
    
    // Enable the global interrupt enable register
    *gpio->gier = GPIO_ENABLE_GIER;
}

void gpio_globaldisable( gpio_t *gpio )
{
    if( gpio->gier == NULL )  return;
    
    // Disable the global interrupt enable register
    *gpio->gier = GPIO_DISABLE_GIER;
}

void gpio_enable( gpio_t *gpio, Huint mask )
{
    Huint ier;

    if( gpio->ier == NULL )    return;
    
    // Get the existing state of the interrupt enables
    ier = *gpio->ier;

    // Combine with the mask by or'ing them together
    mask |= ier;

    // Set the corrosponding bits in the interrupt enable register
    *gpio->ier = mask;
}

void gpio_disable( gpio_t *gpio, Huint mask )
{
    Huint ier;
    if( gpio->ier == NULL )    return;
  
    // Get the existing state of the interrupt enables
    ier = *gpio->ier;

    // Bitwise invert the mask to have 1's for enable and 0's for disable
    mask = ~mask;

    // Combine the two by and'ing them together
    mask &= ier;

    // Disable to corrosponding bit in the interrupt enable register
    *gpio->ier = mask;
}

void gpio_clear( gpio_t *gpio, Huint mask )
{
    Huint isr;
    if( gpio->isr == NULL )    return;
    
    // Get the exiting state of the interrupt status
    isr = *gpio->isr;

    // Combine with the mask by anding the two together
    mask &= isr;
    
    // Clear out the corrosponding bits in the interrupt status register
    *gpio->isr = mask;
}
