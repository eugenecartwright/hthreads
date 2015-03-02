/************************************************************************************
* Copyright (c) 2006, University of Kansas - Hybridthreads Group
* All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
* 
*     * Redistributions of source code must retain the above copyright notice,
*       this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright notice,
*       this list of conditions and the following disclaimer in the documentation
*       and/or other materials provided with the distribution.
*     * Neither the name of the University of Kansas nor the name of the
*       Hybridthreads Group nor the names of its contributors may be used to
*       endorse or promote products derived from this software without specific
*       prior written permission.
* 
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
* ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
************************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <string.h>
#include "ethernet.h"

#define DATA    (256*1024)
#define LOOPS   10

static void run( void )
{
    Huint    i;
    Huint    j;
    Hubyte   target[6];
    Huint    send[ DATA ];
    Huint    recv[ DATA ];
    clock_t  start;
    clock_t  end;
    double   ela;
    double   bytes;
    double   bandw;

    target[0] = 0x00;
    target[1] = 0x00;
    target[2] = 0x5e;
    target[3] = 0x00;
    target[4] = 0xfa;
    target[5] = 0xce;

    memset( send, 0, sizeof(Huint)*DATA );
    memset( recv, 0, sizeof(Huint)*DATA );
    for( i = 0; i < DATA; i++ )  send[i] = htonl(i);
    
    start = clock();
    for( j = 0; j < LOOPS; j++ )
    {
        printf("Sending a packet...\n");
        eth_send( target, (Hubyte*)send, sizeof(Huint)*DATA );
        printf("Waiting for ACK...\n");
        eth_recv( (Hubyte*)recv, sizeof(Huint)*DATA );
        printf("ACK received...\n");

        for( i = 0; i < DATA; i++ )
        {
            if( send[i] != recv[i] )
            {
                printf( "Transaction Error At Byte: %u\n", i*4 );
                exit( 1 );
            }
        }
        
        printf( "Transaction %u done\n", j );
    }
    end = clock();
    
    ela = (double)(end - start);
    ela /= 2405516000.0;

    bytes = LOOPS * DATA * 8.0;
    bandw = bytes / ela;
    
    printf( "Processed %.2f bytes of data in %.2f seconds\n", bytes, ela );
    printf( "Bandwidth: %.2f bytes/sec\n", bandw );
}

int main( int argc, char *argv[] )
{
    Hubyte   src[6];

    src[0] = 0x00;
    src[1] = 0x16;
    src[2] = 0xcb;
    src[3] = 0xcf;
    src[4] = 0xe6;
    src[5] = 0x07;
    
    eth_init( src );
    run();
    
    eth_destroy();
    return 0;
}

