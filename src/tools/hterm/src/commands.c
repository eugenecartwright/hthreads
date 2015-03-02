#include <hterm.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>

void reset_command( void *data, char *args )
{
    hterm_t *term;
    term = (hterm_t*)data;

    term->bytes = 0;
    term->received = 0;

    clearok( curscr, TRUE );
    hwin_clear( &term->scr );
    hwin_refresh( &term->scr );
}

void clear_command( void *data, char *args )
{
    hterm_t *term;
    term = (hterm_t*)data;

    clearok( curscr, TRUE );
    hwin_clear( &term->scr );
    hwin_refresh( &term->scr );
}

void quit_command( void *data, char *args )
{
    hterm_t *term;
    term = (hterm_t*)data;

    term->exit = 1;
}

void listen_command( void *data, char *args )
{
    int num;
    int port;
    char **opts;
    hterm_t *term;
    term = (hterm_t*)data;

    port = 7284;
    if( args != NULL ) port = atoi( args );

    if(port == 0) hwin_addstr(&term->scr,"\nUsage: listen <port>\n");
    if(port < 0)  hwin_addstr(&term->scr,"\nInvalid port: must be 1 - 65535\n");

    if( port > 0 )
    {
        hwin_printw( &term->scr, "\nListening on TCP/IP port %d\n\n", port );
        hinput_listener( &term->input, port, recv_listen, term );
    }

    hwin_refresh( &term->scr );
}

void serial_command( void *data, char *args )
{
    int i;
    int fd;
    int inv;
    int num;
    int baud;
    char dev[4192];
    char *save;
    char *tokn;
    char *next;
    
    hterm_t *term;
    term = (hterm_t*)data;

    inv = 0;
    strncpy( dev, "/dev/ttyS0", 4192 );
    baud = 115200;

    tokn = strtok_r( args, " \t\n\r", &save );
    while( tokn != NULL )
    {
        if(strcmp(tokn, "--baud") == 0 || strcmp(tokn, "-b") == 0)
        {
            next = strtok_r( NULL, " \t\n\r", &save );
            if( next == NULL ) { inv = 1; break; }

            baud = atoi( next );
        }
        else if(strcmp(tokn, "--dev") == 0 || strcmp(tokn, "-d") == 0)
        {
            next = strtok_r( NULL, " \t\n\r", &save );
            if( next == NULL ) { inv = 1; break; }

            strncpy( dev, next, 4192 );
        }
        else
        {
            inv = 1;
            break;
        }


        tokn = strtok_r( NULL, " \t\n\r", &save );
    }

    if( inv )
    {
        hwin_addstr(&term->scr, "\nUsage: serial --baud <baud> --dev <dev>\n");
    }
    else
    {
        hwin_addstr( &term->scr, "\nReceiving data on serial port\n" );
        hwin_printw( &term->scr, "\tBaud:   %d\n", baud );
        hwin_printw( &term->scr, "\tDevice: \"%s\"\n", dev );

        fd = hinput_serial( &term->input, dev, baud, recv_serial, term );
        if( fd < 0 )
        {
            hwin_printw( &term->scr, "\tFailed: %s\n", strerror(errno) );
        }
    }

    hwin_refresh( &term->scr );
}

void help_command_show( void *data, const char *fmt, ... )
{
    hterm_t *term;
    va_list args;

    term = (hterm_t*)data;

    va_start( args, fmt );
    hwin_vprintw( &term->scr, fmt, args );
    va_end( args );
}

void help_command( void *data, char *args)
{
    hterm_t *term;
    term = (hterm_t*)data;

    hwin_clear( &term->scr );
    hwin_printw( &term->scr, "Available Commands:\n" );
    hcommand_help( &term->commands, help_command_show, term );
    hwin_refresh( &term->scr );
}
