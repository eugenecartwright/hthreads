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

#define LIBNET_LIL_ENDIAN 1
#include <stdlib.h>
#include <stdio.h>
#include <libnet.h>

#define ETH_MTU         375
#define ETH_BYTE        1500
#define ETH_SIZE        1518

typedef unsigned char uchar;

static libnet_t* init( void )
{
    char err[ LIBNET_ERRBUF_SIZE ];
    libnet_t *net;
    
    
    net = libnet_init( LIBNET_LINK_ADV, "eth1", err );
    if( net == NULL )
    {
        printf( "Could not Initialize: %s\n", err );
        exit( 1 );
    }

    return net;
}

static void destroy( libnet_t *net )
{
    libnet_destroy( net );
}

static void setup_frame( u_int8_t   *frm,
                         u_int8_t   *dst,
                         u_int8_t   *src,
                         u_int16_t  len,
                         u_int8_t   *dat )
{
    u_int32_t i;

    // Add the destination MAC Address
    for( i = 0; i < 6; i++ )   frm[i] = dst[i];

    // Add the source MAC Address
    for( i = 0; i < 6; i++ )   frm[i+6] = src[i];

    // Add the type
    frm[12]   = (u_int8_t)(len >> 8);
    frm[13]   = (u_int8_t)(len >> 0);

    // Copy the data into the frame
    for( i = 0; i < len; i++ )  frm[i+14] = dat[i];
}

static int build_frame(  u_int8_t   *dst,
                         u_int8_t   *src,
                         u_int16_t  len,
                         u_int8_t   *dat,
                         u_int32_t  size,
                         libnet_t   *net )
{
    libnet_ptag_t   type;
    char            *err;
    
    type = libnet_build_802_3( dst, src, len, dat, size, net, 0 );
    if( type < 0 )
    {
        err = libnet_geterror( net );
        printf( "Could not Build Frame: %s\n", err );
        
        return -1;
    }

    printf( "Successfully Built (LEN=%u) (SIZ=%u)\n", len, size );
    return 0;
}

static int write_frame( libnet_t *net )
{
    int res;
    char *err;

    res = libnet_write( net );
//    if( res < 0 )
//    {
//        err = libnet_geterror( net );
//        printf( "Could not Write Frame: %s\n", err );
//        
//        return -1;
//    }

//    printf( "Successfully Wrote\n" );
    return 0;
}

static void run( libnet_t *net )
{
    int         res;
    int         temp;

    u_int32_t   i;
    u_int16_t   len;
    u_int8_t    buffer[ETH_BYTE];
    u_int8_t    frame[ETH_SIZE];
    u_int32_t    *data;
    u_int8_t    *dst;
    u_int8_t    *src;

    data = (u_int32_t*)(buffer);

    dst = libnet_hex_aton( (int8_t*)"00:E0:18:E4:B2:75", &temp );
    src = libnet_hex_aton( (int8_t*)"00:E0:18:E4:B2:74", &temp );
    
//    dst[0]  = 0x00; src[0]  = 0x00;
//    dst[1]  = 0xE0; src[1]  = 0xE0;
//    dst[2]  = 0x18; src[2]  = 0x18;
//    dst[3]  = 0xE4; src[3]  = 0xE4;
//    dst[4]  = 0xB2; src[4]  = 0xB2;
//    dst[5]  = 0x75; src[5]  = 0x74;

    i = 0;
    while( 1 )
    {
        len = ETH_BYTE;
        for( i = 0; i < ETH_MTU; i++ )  data[i] = htonl(i);
  
        setup_frame( frame, dst, src, len, buffer );
        libnet_adv_write_link( net, frame, len + 14 );
//        res = build_frame( dst, src, len, buffer, len, net );
//        if( res < 0 )   break;
        
//        res = write_frame( net );
//        if( res < 0 )   break;
    }

    free( src );
    free( dst );
}

int main( int argc, char *argv[] )
{
    libnet_t *net;
    
    net = init();
    run( net );
    
    destroy( net );
    return 0;
}

