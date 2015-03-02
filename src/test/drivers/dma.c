#include <hthread.h>
#include <dma/dma.h>
#include <stdio.h>

#define SIZE    (10)

void show_buf( Hint *buf )
{
    Hint i;

    printf( "\n" );
    for( i = 0; i < SIZE; i++ )
    {
        printf( "%d ", buf[i] );
    }
    printf( "\n" );
}

void dma_test( dma_t *dma )
{
    Hint i;
    Hint *buf1;
    Hint *buf2;
    Hint *buf3;
    Hint *buf4;

    printf( "Running DMA Test...\n" );

    buf1 = (Hint*)dma_malloc( sizeof(Hint)*SIZE );
    buf2 = (Hint*)dma_malloc( sizeof(Hint)*SIZE );
    buf3 = (Hint*)dma_malloc( sizeof(Hint)*SIZE );
    buf4 = (Hint*)dma_malloc( sizeof(Hint)*SIZE );

    for( i = 0; i < SIZE; i++ )
    {
        buf1[i] = i;
        buf2[i] = SIZE-i-1;
        buf3[i] = 0;
        buf4[i] = 0;
    }

    show_buf( buf1 );
    show_buf( buf2 );
    show_buf( buf3 );
    show_buf( buf4 );

    dma_transfer( dma, buf1, buf3, sizeof(Hint)*SIZE, DMA_SIZE_WORD, Htrue, Htrue );
    dma_transfer( dma, buf2, buf4, sizeof(Hint)*SIZE, DMA_SIZE_WORD, Htrue, Htrue );
    while( dma_getbusy(dma) );

    show_buf( buf1 );
    show_buf( buf2 );
    show_buf( buf3 );
    show_buf( buf4 );

    dma_free( buf1 );
    dma_free( buf2 );
    dma_free( buf3 );
    dma_free( buf4 );
}

int main( int argc, const char *argv[] )
{
    dma_config_t   config;
    dma_t          dma;

    config.base = 0x50000000;
    dma_create( &dma, &config );

    dma_test( &dma );
    dma_destroy( &dma );

    return 0;
}
