#include <hinput.h>
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
#include <fcntl.h>
#include <fcntl.h>
#include <termios.h>
#include <errno.h>

int hinput_find( hinput_call_t *callbacks, int num )
{
    int i;
    for( i = 0; i < num; i++ )
    {
        if( callbacks[i].fd < 0 )   return i;
    }

    return -1;
}

void hinput_findhigh( hinput_t *input )
{
    int i;

    input->nfds = 0;
    for( i = 0; i < input->readsize; i++ )
    {
        if( input->readcall[i].fd > input->nfds )   input->nfds = input->readcall[i].fd;
    }

    for( i = 0; i < input->writesize; i++ )
    {
        if( input->writecall[i].fd > input->nfds )  input->nfds = input->writecall[i].fd;
    }

    for( i = 0; i < input->exceptsize; i++ )
    {
        if( input->exceptcall[i].fd > input->nfds ) input->nfds = input->exceptcall[i].fd;
    }

    if( input->nfds > 0 )   input->nfds++;
}

int hinput_resize( hinput_call_t **callbacks, int *num )
{
    int i;
    int old;

    if( *num <= 0 )
    {
        *num = 10;
        *callbacks = (hinput_call_t*)malloc( (*num)*sizeof(hinput_call_t) );

        for( i = 0; i < *num; i++ ) (*callbacks)[i].fd = -1;
    }
    else
    {
        old  = *num;
        *num = *num + 10;
        *callbacks = (hinput_call_t*)realloc( *callbacks, (*num)*sizeof(hinput_call_t) );

        for( i = old; i < *num; i++ ) (*callbacks)[i].fd = -1;
    }

    return 0;
}

int hinput_nonblocking( int fd )
{
    int                 res;
    int                 opts;

    // Make the connection non-blocking
    opts = fcntl( fd, F_GETFL );
    if( opts < 0 )  { fprintf( stderr, "Get Fcntl Error\n" ); return  opts; }
    
    opts = (opts | O_NONBLOCK);
    res  = fcntl( fd, F_SETFL, opts );
    if( res < 0 )   { fprintf( stderr, "Fcntl Error\n" ); return res; }

    return 0;
}

void hinput_create( hinput_t *input )
{
    input->nfds = 0;
    FD_ZERO( &input->readfds );
    FD_ZERO( &input->writefds );
    FD_ZERO( &input->exceptfds );

    input->readcall     = NULL;
    input->writecall    = NULL;
    input->exceptcall   = NULL;

    input->readsize     = 0;
    input->writesize    = 0;
    input->exceptsize   = 0;
}

void hinput_destroy( hinput_t *input )
{
    input->nfds = 0;
    FD_ZERO( &input->readfds );
    FD_ZERO( &input->writefds );
    FD_ZERO( &input->exceptfds );

    if( input->readcall != NULL )   free( input->readcall );
    if( input->writecall != NULL )   free( input->writecall );
    if( input->exceptcall != NULL )   free( input->exceptcall );
}

int hinput_read( hinput_t *input, int fd, callback call, void *data )
{
    int free;

    // Add the file descriptor to the fd set
    FD_SET( fd, &input->readfds );
    if( fd >= input->nfds ) input->nfds = fd+1;

    // Set the file descriptor to be non-blocking
    //hinput_nonblocking( fd );

    // Attempt to find a free location
    free = hinput_find( input->readcall, input->readsize );

    // Resize and try again if neccessary
    if( free < 0 )
    {
        hinput_resize( &input->readcall, &input->readsize );
        free = hinput_find( input->readcall, input->readsize );
        if( free < 0 ) return -1;
    }

    // Insert the callback into the array
    input->readcall[free].fd    = fd;
    input->readcall[free].del   = 0;
    input->readcall[free].data  = data;
    input->readcall[free].call  = call;

    // Return successfully
    return 0;
}

int hinput_write( hinput_t *input, int fd, callback call, void *data )
{
    int free;

    FD_SET( fd, &input->writefds );
    if( fd >= input->nfds ) input->nfds = fd+1;

    // Set the file descriptor to be non-blocking
    hinput_nonblocking( fd );

    // Attempt to find a free location
    free = hinput_find( input->writecall, input->writesize );

    // Resize and try again if neccessary
    if( free < 0 )
    {
        hinput_resize( &input->writecall, &input->writesize );
        free = hinput_find( input->writecall, input->writesize );
        if( free < 0 ) return -1;
    }

    // Insert the callback into the array
    input->writecall[free].fd      = fd;
    input->writecall[free].del     = 0;
    input->writecall[free].data    = data;
    input->writecall[free].call    = call;

    // Return successfully
    return 0;
}

int hinput_except( hinput_t *input, int fd, callback call, void *data )
{
    int free;

    FD_SET( fd, &input->exceptfds );
    if( fd >= input->nfds ) input->nfds = fd+1;

    // Set the file descriptor to be non-blocking
    //hinput_nonblocking( fd );

    // Attempt to find a free location
    free = hinput_find( input->exceptcall, input->exceptsize );

    // Resize and try again if neccessary
    if( free < 0 )
    {
        hinput_resize( &input->exceptcall, &input->exceptsize );
        free = hinput_find( input->exceptcall, input->exceptsize );
        if( free < 0 ) return -1;
    }

    // Insert the callback into the array
    input->exceptcall[free].fd      = fd;
    input->exceptcall[free].del     = 0;
    input->exceptcall[free].data    = data;
    input->exceptcall[free].call    = call;

    // Return successfully
    return 0;
}

void hinput_delread( hinput_t *input, int fd )
{
    int i;
    
    FD_CLR( fd, &input->readfds );
    for( i = 0; i < input->readsize; i++ )
    {
        if( input->readcall[i].fd == fd ) input->readcall[i].fd = -1;
    }

    hinput_findhigh( input );
}

void hinput_delwrite( hinput_t *input, int fd )
{
    int i;
    
    FD_CLR( fd, &input->writefds );
    for( i = 0; i < input->writesize; i++ )
    {
        if( input->writecall[i].fd == fd ) input->writecall[i].fd = -1;
    }

    hinput_findhigh( input );
}

void hinput_delexcept( hinput_t *input, int fd )
{
    int i;
    
    FD_CLR( fd, &input->exceptfds );
    for( i = 0; i < input->exceptsize; i++ )
    {
        if( input->exceptcall[i].fd == fd ) input->exceptcall[i].fd = -1;
    }

    hinput_findhigh( input );
}

int hinput_select( hinput_t *input, struct timeval *timeout )
{
    int i;
    int j;
    int res;
    int num;
    
    FD_ZERO( &input->rfds );
    FD_ZERO( &input->wfds );
    FD_ZERO( &input->efds );
    FD_COPY( &input->readfds, &input->rfds );
    FD_COPY( &input->writefds, &input->wfds );
    FD_COPY( &input->exceptfds, &input->efds );
    
    num = select( input->nfds, &input->rfds, &input->wfds, &input->efds, timeout );
    for( i = 0; i < input->nfds; i++ )
    {
        if( FD_ISSET(i, &input->rfds ) )
        {
            for( j = 0; j < input->readsize; j++ )
            {
                if( input->readcall[j].fd == i )
                {
                    res = input->readcall[j].call(i, input->readcall[j].data );
                    input->readcall[j].del = res;
                }               
            }
        }

        if( FD_ISSET(i, &input->wfds) )
        {
            for( j = 0; j < input->writesize; j++ )
            {
                if( input->writecall[j].fd == i )
                {
                    res = input->writecall[j].call(i, input->writecall[j].data );
                    input->writecall[j].del = res;
                }
            }
        }

        if( FD_ISSET(i, &input->efds) )
        {
            for( j = 0; j < input->exceptsize; j++ )
            {
                if( input->exceptcall[j].fd == i )
                {
                    res = input->exceptcall[j].call(i, input->exceptcall[j].data );
                    input->exceptcall[j].del = res;
                }
            }
        }
    }

    for( i = 0; i < input->readsize; i++ )
    {
        if( input->readcall[i].fd >= 0 && input->readcall[i].del )
        {
            FD_CLR( input->readcall[i].fd, &input->readfds );
            input->readcall[i].fd = -1;
            hinput_findhigh( input );
        }
    }

    for( i = 0; i < input->writesize; i++ )
    {
        if( input->writecall[i].fd >= 0 && input->writecall[i].del )
        {
            FD_CLR( input->writecall[i].fd, &input->writefds );
            input->writecall[i].fd = -1;
            hinput_findhigh( input );
        }
    }

    for( i = 0; i < input->exceptsize; i++ )
    {
        if( input->exceptcall[i].fd >= 0 && input->exceptcall[i].del )
        {
            FD_CLR( input->exceptcall[i].fd, &input->exceptfds );
            input->exceptcall[i].fd = -1;
            hinput_findhigh( input );
        }
    }
        
    return num;
}

int hinput_readset( hinput_t *input, int fd )
{
    return FD_ISSET( fd, &input->rfds );
}

int hinput_writeset( hinput_t *input, int fd )
{
    return FD_ISSET( fd, &input->wfds );
}

int hinput_exceptset( hinput_t *input, int fd )
{
    return FD_ISSET( fd, &input->efds );
}

int hinput_serial( hinput_t *input, const char *d, int b, callback c, void *t )
{
    int             fd;
    int             opt;
    int             baud;
    struct termios  tio;

    // Check the baud rate
    switch( b )
    {
    case 1200:      baud = B1200;       break;
    case 2400:      baud = B2400;       break;
    case 4800:      baud = B4800;       break;
    case 9600:      baud = B9600;       break;
    case 19200:     baud = B19200;      break;
    case 38400:     baud = B38400;      break;
    case 115200:    baud = B115200;     break;
    case 230400:    baud = B230400;     break;
    default:        errno = EINVAL;     return -1;
    }

    // Attempt to open up the serial port
    fd = open( d, O_RDWR | O_NOCTTY );
    if( fd < 0 )    return fd;

    // Setup the port
    memset( &tio, 0, sizeof(struct termios) );
    tio.c_cflag        = baud | CS8 | CLOCAL | CREAD;
    tio.c_iflag        = IGNPAR | IGNBRK | IGNCR;
    tio.c_oflag        = 0;
    tio.c_lflag        = 0;
    tio.c_cc[VTIME]    = 0;
    tio.c_cc[VMIN]     = 0;

    tcflush( fd, TCIFLUSH );
    tcsetattr( fd, TCSANOW, &tio );

    // Make the file descriptor non-blocking
    hinput_nonblocking( fd );

    // Add the file to the list of inputs
    hinput_read( input, fd, c, t );

    // Return the opened device
    return fd;
}

int hinput_listener( hinput_t *input, int port, callback call, void *data )
{
    int                 fd;
    int                 res;
    int                 yes;
    struct sockaddr_in  inaddr;

    // Create a new socket file descriptor
    fd = socket( PF_INET, SOCK_STREAM, 0 );
    if( fd < 0 )    { fprintf( stderr, "Socket Error\n" ); return fd; }

    // Attempt to make the socket reuseable
    yes = 1;
    setsockopt( fd, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(int) );

    // Attempt to make the socket non-blocking
    hinput_nonblocking( fd );

    // Setup the address for the file descriptor
    inaddr.sin_family         = AF_INET;
    inaddr.sin_port           = htons(port);
    inaddr.sin_addr.s_addr    = INADDR_ANY;
    memset( &inaddr.sin_zero, 0, 8 );
    
    // Bind the file descriptor to the address that we have created
    res = bind( fd, (struct sockaddr*)&inaddr, sizeof(struct sockaddr) );
    if( res < 0 )   { fprintf(stderr,"Bind Error\n"); return res; }

    // Setup the file descriptor to listen for incoming requests
    res = listen( fd, 10 );
    if( res < 0 )   { fprintf(stderr,"Listen Error\n"); return res; }

    // Add the file descriptor to the list of read listeners
    hinput_read( input, fd, call, data );

    // Return the file descriptor back to the caller
    return fd;
}
