/*************************************************************************************
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

//#define DATA    (256*1024)
#define DATA    (7)
#define LOOPS   (10)

void print_packet(Huint * packet, Huint length)
{
    int i = 0;
    int temp = 0;
    unsigned char * letter;

    // Packet header
    printf("\nPacket header (length = %d):\n",length);

    temp = packet[0];
    letter = (unsigned char*)&packet[0];
    for (i = 0; i < length; i++)
    {
        if (i < 2) {
            printf("%d = \t0x%02x\n",i,temp & 0xFF);
            temp = temp >> 8;
        }
        else if (i == 2)
        {
            printf("Packet Data:\n");
            printf("%d = \t%c -> %02x \n",i, *letter, *letter);
        }
        else
        {
            printf("%d = \t%c -> %02x \n",i, *letter, *letter);
        }
        letter++;
    }
 
}

static void run( void )
{
    Huint    i;
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

    int counter = 0;    

    start = clock();
    //for( j = 0; j < LOOPS; j++ )
    for( counter = 0; counter < LOOPS; counter++ )
    {
        printf("\n*******************\nWaiting for a packet...\n");
        eth_recv_ackless( (Hubyte*)recv, sizeof(Huint)*DATA );
        printf("PACKET RECEIVED...\n");

        printf("PACKET DATA-%s\n,",recv);
        for( i = 0; i < DATA; i++ )
        {
            printf("0x%08x,",recv[i]);
        }
        print_packet(recv, sizeof(Huint)*DATA);
        
        //printf( "\nTransaction %u done\n", j );
        printf( "\nTransaction %u done\n", counter );
    }
    end = clock();
    
    ela = (double)(end - start);
    ela /= 2405516000.0;

    bytes = LOOPS * DATA * 8.0;
    bandw = bytes / ela;
    
    printf( "Processed %.2f bytes of data in %.2f seconds\n", bytes, ela );
    printf( "Bandwidth: %.2f bytes/sec\n", bandw );
}

static void run2( void )
{
    Huint    i;
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

    int counter = 0;    

    start = clock();
    for( counter = 0; counter < LOOPS; counter++ )
    {
        // Wait for an incoming packet
        printf("\n*******************\nWaiting for a packet...\n");
        eth_recv_ackless( (Hubyte*)recv, sizeof(Huint)*DATA );
        printf("PACKET RECEIVED...\n");

        printf("PACKET DATA-%s\n,",recv);
        for( i = 0; i < DATA; i++ )
        {
            printf("0x%08x,",recv[i]);
        }
        print_packet(recv, sizeof(Huint)*DATA);
        
        // Send a packet out
        sleep(1);
        /*for( i = 0; i < DATA; i++ )
        {
            recv[i] = 0x01010101;
        }
        */
        recv[2] = 0x46474849;
        eth_send_ackless( (Hubyte*)target, (Hubyte*)recv, sizeof(Huint)*DATA); 

        printf( "\nTransaction %u done\n", counter );
    }
    end = clock();
    
    ela = (double)(end - start);
    ela /= 2405516000.0;

    bytes = LOOPS * DATA * 8.0;
    bandw = bytes / ela;
    
    printf( "Processed %.2f bytes of data in %.2f seconds\n", bytes, ela );
    printf( "Bandwidth: %.2f bytes/sec\n", bandw );
}

static void run3( void )
{
    Huint    i;
    Hubyte   target[6];
    Huint    send[ DATA ];
    Huint    recv[ DATA ];
    Huint    msg[ 20 ];
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
    memset( msg, 0, sizeof(Huint)*DATA );
    for( i = 0; i < DATA; i++ )
    {
        send[i] = htonl(i);
        recv[i] = htonl(i);
    }

    unsigned char * charPointer;
    charPointer = (unsigned char*)&msg[0];
    unsigned char letter = 'a';
    for (i = 0; i < 4*20; i++)
    {
        charPointer[i] = letter++;
    }
    charPointer[10] = 0;

    int counter = 0;    

    start = clock();
    for( counter = 0; counter < LOOPS; counter++ )
    {
        //eth_send_ackless( (Hubyte*)target, (Hubyte*)recv, sizeof(Huint)*DATA); 
        eth_send_ackless( (Hubyte*)target, (Hubyte*)msg, 20);

        charPointer = (unsigned char*)&msg[0];
        *charPointer = *charPointer + 1;

        //eth_send_ackless( (Hubyte*)target, (Hubyte*)msg, sizeof(Huint)*DATA);
       //msg[0] = msg[0] + 1; 

        // Wait for an incoming packet
        printf("\n*******************\nWaiting for a packet...\n");
        eth_recv_ackless( (Hubyte*)recv, sizeof(Huint)*DATA );
        printf("PACKET RECEIVED...\n");
        print_packet(recv, sizeof(Huint)*DATA);
        

        printf( "\nTransaction %u done\n", counter );
    }
    end = clock();
    
    ela = (double)(end - start);
    ela /= 2405516000.0;

    bytes = LOOPS * DATA * 8.0;
    bandw = bytes / ela;
    
    printf( "Processed %.2f bytes of data in %.2f seconds\n", bytes, ela );
    printf( "Bandwidth: %.2f bytes/sec\n", bandw );
}

static void scenario_gen( void )
{
    Huint    i;
    Hubyte   target[6];
    Huint    send[ DATA ];
    Huint    recv[ DATA ];
    Huint    msg[ 20 ];
    clock_t  start;
    clock_t  end;
    double   ela;
    double   bytes;
    double   bandw;

    // Initialize frame taret and frame data 

    target[0] = 0x00;
    target[1] = 0x00;
    target[2] = 0x5e;
    target[3] = 0x00;
    target[4] = 0xfa;
    target[5] = 0xce;

    memset( send, 0, sizeof(Huint)*DATA );
    memset( recv, 0, sizeof(Huint)*DATA );
    memset( msg, 0, sizeof(Huint)*DATA );
    for( i = 0; i < DATA; i++ )
    {
        send[i] = htonl(i);
        recv[i] = htonl(i);
    }

    // Form a channel request packet
    unsigned char * charPointer;
    int param;
    int counter;

    start = clock();
    while(1)
    {
        
        charPointer = (unsigned char*)&msg[0];

        printf("Enter an opcode: \r\n");
        scanf("%d",&param);

        charPointer[0] = param; // set opcode

        printf("Enter a channel ID: \r\n");
        scanf("%d",&param);

        charPointer[1] = param; // channel ID

        printf("Enter a packet #: \r\n");
        scanf("%d",&param);

        charPointer[2] = param; // packet number

        // Put in some junk data
        charPointer[5] = 5;
        charPointer[6] = 6;
        charPointer[7] = 7;
        charPointer[8] = 8;
        charPointer[9] =9;
        charPointer[10] = 10;
        charPointer[11] = 11;

        //eth_send_ackless( (Hubyte*)target, (Hubyte*)recv, sizeof(Huint)*DATA); 
        eth_send_ackless( (Hubyte*)target, (Hubyte*)msg, 20);

        //charPointer = (unsigned char*)&msg[0];
        //*charPointer = *charPointer + 1;

        //eth_send_ackless( (Hubyte*)target, (Hubyte*)msg, sizeof(Huint)*DATA);
       //msg[0] = msg[0] + 1; 

        /*
        // Wait for an incoming packet
        printf("\n*******************\nWaiting for a packet...\n");
        eth_recv_ackless( (Hubyte*)recv, sizeof(Huint)*DATA );
        printf("PACKET RECEIVED...\n");
        print_packet(recv, sizeof(Huint)*DATA);
       */

        printf( "\nTransaction %u done\n", counter );
        counter++;
        sleep(1);
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
    //run3();
    scenario_gen();
    
    eth_destroy();
    return 0;
}

