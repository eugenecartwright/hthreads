/************************************************************************************
* Copyright (c) 2015, University of Arkansas - Hybridthreads Group
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
*     * Neither the name of the University of Arkansas nor the name of the
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
#include "ethernet.h"
#include "image.h"

#define DATA    (256*1024)
#define LOOPS   10

static void send_image( image *img )
{
    Huint   s;
    Hubyte  target[6];
    Huint   header[3];

    printf( "Image Width: %u\n", img->width );
    printf( "Image Height: %u\n", img->height );
    printf( "Image Depth: %u\n", img->depth );

    target[0] = 0x00;
    target[1] = 0xE0;
    target[2] = 0x18;
    target[3] = 0xE4;
    target[4] = 0xB2;
    target[5] = 0x75;
    
    header[0] = htonl( img->width );
    header[1] = htonl( img->height );
    header[2] = htonl( img->depth );
    eth_send( target, (Hubyte*)header, sizeof(Huint)*3 );

    s = sizeof(Hubyte)*img->width*img->height*img->depth;
    eth_send( target, img->data, s );
}

static void recv_image( image *img )
{
    Huint   s;
    
    s = sizeof(Hubyte)*img->width*img->height*img->depth;
    eth_recv( img->data, s );
}

static void run( const char *input, const char *output )
{
    Huint   i;
    Huint   j;
    image   *img;
    clock_t start;
    clock_t end;
    double  ela;
    double  bytes;
    double  bandw;

    img = read_png_file( input );
    start = clock();
        send_image( img );
        recv_image( img );
    end = clock();
    write_png_file( output, img );
    
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
    src[1] = 0xE0;
    src[2] = 0x18;
    src[3] = 0xE4;
    src[4] = 0xB2;
    src[5] = 0x74;

    eth_init( src );
    run( argv[1], argv[2] );
    
    eth_destroy();
    return 0;
}

