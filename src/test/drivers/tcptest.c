#include <hthread.h>
#include <config.h>
#include <ethlite/netif.h>
#include <netif/etharp.h>
#include <stdio.h>

int main( int argc, const char *argv[] )
{
    Huint size;

    size = sizeof(struct eth_hdr);
    printf( "Size: %d\n", size );

    return 0;
}
