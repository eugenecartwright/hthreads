#ifndef _HTERM_H_
#define _HTERM_H_

#include <hwin.h>
#include <hinput.h>
#include <hcommand.h>
#include <hkey.h>
#include <hlog.h>
#include <sys/time.h>
#include <time.h>
#include <stdlib.h>

#define STDIN   0
#define STDOUT  1
#define STDERR  2

#define HTERM_VERSION   "v1.0.0"

typedef struct
{
    hwin_t      scr;
    hwin_t      cmd;
    hwin_t      rate;
    hwin_t      total;
    hwin_t      title;

    hkey_t      keys;
    hlog_t      log;
    hlog_t      data;
    hinput_t    input;
    hcommand_t  commands;

    int         exit;
    int         refresh;


    struct itimerval timer;
    struct itimerval oldtimer;

    double      brate;
    clock_t     start;
    clock_t     finish;

    unsigned long long  bytes;
    unsigned long long  received;
} hterm_t;

// A list of the command functions
extern void reset_command( void*, char* );
extern void listen_command( void*, char* );
extern void serial_command( void*, char* );
extern void clear_command( void*, char* );
extern void quit_command( void*, char* );
extern void help_command( void*, char* );

// A list of callback functions
extern int recv_stdin( int, void* );
extern int recv_port( int, void* );
extern int recv_listen( int, void* );
extern int recv_serial( int, void* );
extern int send_message( int, void* );

// A list of key functions
extern void resize_key( const chtype, void* );
extern void backspace_key( const chtype, void* );
extern void enter_key( const chtype, void* );
extern void up_key( const chtype, void* );
extern void down_key( const chtype, void* );
extern void default_key( const chtype, void* );

// A list of the core functions
extern void hterm_init( hterm_t* );
extern void hterm_destroy( hterm_t* );
extern void hterm_run( hterm_t* );
extern void hterm_resize( hterm_t*, int, int, int );
extern void hterm_showhelp( void*, const char*, ... );
extern void hterm_help( hterm_t* );
extern void hterm_options( hterm_t*, int, char** );

#endif
