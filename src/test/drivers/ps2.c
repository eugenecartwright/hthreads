#include <hthread.h>
#include <config.h>
#include <ps2/ps2.h>

void ps2_test( ps2_t *ps2 )
{
    Hubyte data;

    while( 1 )
    {
        data = ps2_recvbyte( ps2 );
        printf( "Received: 0x%8.8x\n", data );
    }
}

int main( int argc, const char *argv[] )
{
    ps2_config_t    config;
    ps2_t           ps2;

    printf( "Running PS2 Test...\n" );

    config.base = PS2_BASEADDR;
    ps2_create( &ps2, &config );

    ps2_test( &ps2 );
    ps2_destroy( &ps2 );

    return 0;
}
