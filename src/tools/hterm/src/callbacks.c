#include <hterm.h>
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

int recv_stdin( int fd, void *data )
{
    chtype  ch;
    hterm_t *term;

    term = (hterm_t*)data;
    ch = hwin_getch( &term->cmd );

    hkey_run( &term->keys, ch, default_key, term );
    return 0;
}


int send_ack( int fd, void *data )
{
    int     res;
    hterm_t *term;
    term = (hterm_t*)data;

    res = send( fd, "\n", 1, 0 );
    if( res == 0 )
    {
        close(fd);
        return 1;
    }
    else if( res >= 0 )
    {
        hinput_read( &term->input, fd, recv_port, term );
        return 1;
    }
}

int recv_serial( int fd, void *data )
{
    ssize_t res;
    char    buffer[1024];
    hterm_t *term;

    term = (hterm_t*)data;
    res  = read( fd, buffer, 1023 );

    if( res < 0 )
    {
        close(fd);
        return 1;
    }
    else if( res >= 0 )
    {
        // Increment the statistics
        term->bytes     += res;
        term->received  += res;
        
        // Show the data on the screen
        buffer[res] = 0;
        hwin_addstr( &term->scr, buffer );
        hwin_refresh( &term->scr );

        // Write the received data to the output log
        hlog_write( &term->log, buffer, res );

        // Return successfully
        return 0;
    }
}

int recv_listen( int fd, void *data )
{
    int                 nfd;
    socklen_t           size;
    hterm_t             *term;
    struct sockaddr_in  client;

    term = (hterm_t*)data;
    size = sizeof(struct sockaddr_in);
    nfd  = accept( fd, (struct sockaddr*)&client, &size );
    if( nfd >= 0 )
    {
        hinput_nonblocking( nfd );
        hinput_read( &term->input, nfd, recv_port, term );
    }

    return 0;
}

int recv_port( int fd, void *data )
{
    int     res;
    char    buffer[1500];
    hterm_t *term;

    term = (hterm_t*)data;
    res  = recv( fd, buffer, 1500, 0 );

    if( res < 0 && errno != EAGAIN )
    {
        hwin_addstr( &term->scr, "Closing connection\n" );
        close(fd);
        return 1;
    }
    else if( res >= 0 )
    {
        // Increment the statistics
        term->bytes     += res;
        term->received  += res;
        
        // Write the received data to the output log
        hlog_write( &term->data, buffer, res );

        // Setup the ack write for the socket
        //hinput_write( &term->input, fd, send_ack, term );

        // Return successfully
        return 0;
    }
}

int send_message( int fd, void *data )
{
    ssize_t res;
    
    res = send( fd, "This is a test message\n", 23, 0 );
    if( res < 0 )   { close(fd); return 1; }
    else            { return 0; }
}
