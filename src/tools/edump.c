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

#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/wait.h>
#include <signal.h>

#define PORT        7284
#define LISTEN      10
#define BUFFSIZE    (16*1024)

typedef struct
{
    int sock;
    struct sockaddr_in addr;
} socket_client_t;

int socket_open()
{
    int opt;
    int res;
    int sock;

    sock = socket( AF_INET, SOCK_STREAM, 0 );
    if( sock < 0 )
    {
        perror( "could not create server socket" );
        exit( 1 );
    }

    opt = 1;
    res = setsockopt( sock, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(int) );
    if( res < 0 )
    {
        perror( "could not set server socket options" );
        exit( 1 );
    }

    return sock;
}

void socket_bind( int server, int port )
{
    int res;
    struct sockaddr_in addr;

    memset( &addr, 0, sizeof(struct sockaddr_in) );
    addr.sin_family      = AF_INET;
    addr.sin_port        = htons(port);
    addr.sin_addr.s_addr = INADDR_ANY;

    res = bind( server, (struct sockaddr*)&addr, sizeof(struct sockaddr) );
    if( res < 0 )
    {
        perror( "could not open server port" );
        exit( 1 );
    }
}

void socket_listen( int server, int back )
{
    int res;

    res = listen( server, back );
    if( res < 0 )
    {
        perror( "server could not listen on port" );
        exit( 1 );
    }
}

int socket_accept( int server, struct sockaddr_in *addr )
{
    int client;
    socklen_t ssize;

    ssize  = sizeof(struct sockaddr_in);
    client = accept( server, (struct sockaddr*)addr, &ssize );
    if( client < 0  )   perror( "server could not connect to client" );

    return client;
}

void* socket_client( void *arg )
{
    int res;
    int wres;
    char buffer[BUFFSIZE];
    socket_client_t *client;

    // Get the clients information
    client = (socket_client_t*)arg;

    printf( "Serving client at: %s\n", inet_ntoa(client->addr.sin_addr) );
    while( 1 )
    {
        res = recv( client->sock, buffer, BUFFSIZE, 0 );
        if( res < 0 )   break;

        while( res > 0 )
        {
            wres = fwrite( buffer, 1, res, stdout );
            if( wres == 0 ) break;
            res -= wres;
        }
    }

    // Free the space used for client information
    free( client );

    // Exit this thread
    return NULL;
}

void socket_server( int server )
{
    pthread_t tid;
    pthread_attr_t attr;
    socket_client_t *client;

    // Setup client serving threads to be detached
    pthread_attr_init( &attr );
    pthread_attr_setdetachstate( &attr, PTHREAD_CREATE_DETACHED );

    while( 1 )
    {
        // Allocate new space for the client information
        client = (socket_client_t*)malloc( sizeof(socket_client_t) );
        if( client == NULL )
        {
            perror( "could not allocate space for client" );
            exit( 1 );
        }

        // Get a new client connection
        client->sock = socket_accept( server, &client->addr );

        // Spawn a worker to serve the client
        pthread_create( &tid, &attr, socket_client, (void*)client );
    }
}

int main (int argc, char** argv)
{
    int server;

    server = socket_open();
    socket_bind( server, PORT );
    socket_listen( server, LISTEN );
    socket_server( server );

	return 0;
}
