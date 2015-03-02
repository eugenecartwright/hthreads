#include <hthread.h>
#include <config.h>
#include <ps2/keyboard.h>
#include <stdio.h>
#include <unistd.h>

void keyboard_test( keyboard_t *keyb )
{
    Hubyte data;
    Hubyte send;
    Hint   num;

    num  = 0;
    send = 0;
    while( 1 )
    {
        data = keyboard_getascii( keyb );
        write( 1, &data, 1 );
        num++;
        
        if( num == 256 )
        {
            printf( "Increasing Speed...\n" );
            keyboard_setrate( keyb, KEYBOARD_RATE_30_0 );
            keyboard_setdelay( keyb, KEYBOARD_DELAY_0_25 );
        }

        //printf( "Char: '%c'\n", data );
        //printf( "Key Code: 0x%8.8x\n", data );
        //ps2_sendbyte( keyb->ps2, send++ );
    }
}

int main( int argc, const char *argv[] )
{
    ps2_config_t    config;
    ps2_t           ps2;
    keyboard_t      keyb;

    printf( "Running PS2 Test...\n" );

    config.base = PS2_BASEADDR;
    ps2_create( &ps2, &config );
    keyboard_create( &keyb, &ps2 );

    keyboard_test( &keyb );

    keyboard_destroy( &keyb );
    ps2_destroy( &ps2 );

    return 0;
}
