#include <hthread.h>
#include <config.h>
#include <ethlite/ethlite.h>
#include <stdio.h>
#include <string.h>
#include <sleep.h>

void ethlite_test( ethlite_t *eth )
{
    Huint s;
    Huint r;
    ethlite_frame_t     recv;
    ethlite_frame_t     frame;
    printf( "Ethernet Lite Test...\n" );

    frame.dst[0] = 0x00;
    frame.dst[1] = 0x0D;
    frame.dst[2] = 0x61;
    frame.dst[3] = 0x4A;
    frame.dst[4] = 0xC4;
    frame.dst[5] = 0xD6;

    s = 0;
    r = 0;
    while( 1 )
    {
        // Receive a frame if possible
        if( ethlite_canrecv(eth) )
        {
            ethlite_recv( eth, &recv );
            r += 1;

            if( r % 10 == 0 )
            {
                printf( "Received Ethernet Frame: (NUM=%d) (LEN=%d)\n", r, recv.length );
            }
        }
        
        if( ethlite_cansend(eth) )
        {
            // Send a frame out
            frame.data[0] = 0x01;
            frame.data[1] = 0x01;
            frame.data[2] = s << 1;
            frame.data[3] = r << 1 | 0x01;

            snprintf( (char*)&frame.data[4], 1496, "Hthreads Frame #%d\n", s );
            frame.length = strlen( (char*)&frame.data[4] )+5;
        
            ethlite_send( eth, &frame, frame.length );
            s += 1;

            if( s % 10 == 0 )
            {
                printf( "Sent Frame: (NUM=%d) (LEN=%d)\n", s, frame.length );
            }
        }

        usleep( 100*1000 );
    }
}

int main( int argc, const char *argv[] )
{
    ethlite_config_t    config;
    ethlite_t           eth;

    config.base         = ETHLITE_BASEADDR;
    config.recv_toggle  = Htrue;
    config.send_toggle  = Htrue;
    ethlite_create( &eth, &config );

    ethlite_test( &eth );
    ethlite_destroy( &eth );

    return 0;
}
