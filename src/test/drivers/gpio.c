#include <hthread.h>
#include <config.h>
#include <gpio/gpio.h>
#include <stdio.h>

#define BUTTON_RIGHT    0x01
#define BUTTON_LEFT     0x02
#define BUTTON_DOWN     0x04
#define BUTTON_UP       0x08
#define BUTTON_CENTER   0x10

void gpio_test( gpio_t *leds, gpio_t *btns, gpio_t *dips )
{
    Huint   ind;
    Huint   bdat;
    Huint   ddat;
    Huint   ldat;
    Huint   bdato;
    Huint   ddato;

    gpio_setdirection( leds, GPIO_CHANNEL1, GPIO_ALL_OUTPUT );
    gpio_setdirection( btns, GPIO_CHANNEL1, GPIO_ALL_INPUT );
    gpio_setdirection( dips, GPIO_CHANNEL1, GPIO_ALL_INPUT );

    ind   = 0;
    bdato = 0xF0000000;
    ddato = 0xF0000000;
    while( 1 )
    {
        bdat = gpio_getdata( btns, GPIO_CHANNEL1 );
        ddat = gpio_getdata( dips, GPIO_CHANNEL1 );
        
        if( bdat != bdato || ddat != ddato )
        {
            if( !(bdat&BUTTON_CENTER)&&(bdato&BUTTON_CENTER) ) ind = 0;

            if( !(bdat&BUTTON_UP) && (bdato&BUTTON_UP) )       ind = (ind+1)%leds->bits;
            if( !(bdat&BUTTON_DOWN) && (bdato&BUTTON_DOWN) )   ind = (ind-1)%leds->bits;

            if( !(bdat&BUTTON_RIGHT) && (bdato&BUTTON_RIGHT) ) ind = (ind+1)%leds->bits;
            if( !(bdat&BUTTON_LEFT) && (bdato&BUTTON_LEFT) )   ind = (ind-1)%leds->bits;

            ldat = (ddat | (1 << ind));
            printf( "(BTNS=0x%8.8x) (DIPS=0x%8.8x) (LEDS=0x%8.8x)\n", bdat, ddat, ldat );
            gpio_setdata( leds, GPIO_CHANNEL1, (ddat|(1<<ind)) );

            bdato = bdat;
            ddato = ddat;
        }
    }
}

int main( int argc, const char *argv[] )
{
    gpio_config_t   led_config;
    gpio_config_t   btn_config;
    gpio_config_t   dip_config;
    gpio_t          leds;
    gpio_t          btns;
    gpio_t          dips;

    led_config.base = GPIOLED_BASEADDR;
    led_config.dual = 0;
    led_config.intr = 1;
    led_config.bits = 4;

    btn_config.base = GPIOBTN_BASEADDR;
    btn_config.dual = 0;
    btn_config.intr = 1;
    btn_config.bits = 5;

    dip_config.base = GPIODIP_BASEADDR;
    dip_config.dual = 0;
    dip_config.intr = 1;
    dip_config.bits = 4;

    gpio_create( &leds, &led_config );
    gpio_create( &btns, &btn_config );
    gpio_create( &dips, &dip_config );

    gpio_test( &leds, &btns, &dips );

    gpio_destroy( &leds );
    gpio_destroy( &btns );
    gpio_destroy( &dips );

    return 0;
}
