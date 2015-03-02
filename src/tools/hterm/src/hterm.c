#include <hterm.h>
#include <stdio.h>
#include <signal.h>
#include <getopt.h>

static struct option longopts[] = {
    {     "tty", 1, 0, 't'},
    {     "log", 1, 0, 'l'},
    {    "baud", 1, 0, 'b'},
    {    "data", 1, 0, 'd'},
    {    "port", 1, 0, 'p'},
    {    "help", 0, 0, 'h'},
    { "version", 0, 0, 'v'},
    {0,0,0,0} };

static hterm_t *gterm = NULL;

void hterm_changesize( int sig )
{
    if( gterm != NULL ) resize_key( KEY_RESIZE, gterm );
}

void hterm_quit( int sig )
{
    if( gterm == NULL ) return;
    gterm->exit = 1;
}

void hterm_alarm( int sig )
{
    gterm->refresh  = 1;
    /*
    static struct timeval start;
    static struct timeval finish;
    static struct timeval diff;
    double  time;

    gettimeofday( &finish, NULL );
    diff   = finish - start;
    fprintf( stderr, "Clocks: (SRT=%lld) (FIN=%lld) (DIF=%lld)\n", start, finish, diff );

    time = (double)diff / (double)CLOCKS_PER_SEC;
    if( time < 0.01 )   time = 0.01;

    start           = finish;
    gterm->refresh  = 1;
    gterm->brate    = (double)gterm->bytes / time;
    gterm->bytes    = 0;
    */
}

void hterm_showstats( hterm_t *term )
{
    static char buffer[512];
    static struct timeval start;
    static struct timeval finish;
    static double time;
    double size;
    char   *units;

    gettimeofday( &finish, NULL );
    time = finish.tv_sec - start.tv_sec;
    if( start.tv_usec > finish.tv_usec )
    {
        time = (time-1) + (1000000.0-start.tv_usec+finish.tv_usec)/1000000.0;
    }
    else
    {
        time += (finish.tv_usec-start.tv_usec)/1000000.0;
    }
    
    start = finish;
    term->brate   = (double)term->bytes / time;
    term->bytes   = 0;
    term->refresh = 0;

    units = "B/SEC";
    size  = term->brate;
    if( size >= 1024*1024*1024 )    { size  /= (1024*1024*1024); units  = "GB/SEC"; }
    else if( size >= 1024*1024 )    { size  /= (1024*1024); units  = "MB/SEC"; }
    else if( size >= 1024 )         { size  /= 1024; units  = "KB/SEC"; }
    snprintf( buffer, 512, "%2.2f %s", size, units );

    hwin_clear( &term->rate );
    hwin_msgstr( &term->rate, buffer, LEFT );

    units = "B";
    size = (double)term->received;
    if( size >= 1024*1024*1024 )    { size  /= (1024*1024*1024); units  = "GB"; }
    else if( size >= 1024*1024 )    { size  /= (1024*1024); units  = "MB"; }
    else if( size >= 1024 )         { size  /= 1024; units  = "KB"; }
    snprintf( buffer, 512, "%2.2f %s", size, units );

    hwin_clear( &term->total );
    hwin_msgstr( &term->total, buffer, RIGHT );

    hwin_refresh( &term->rate );
    hwin_refresh( &term->total );
}

void hterm_resize( hterm_t *term, int w, int h, int resize )
{
    int x1;
    int x2;
    
    if( resize )
    {
        hwin_resize(   &term->scr,     0,   3,     w, h-6 );
        hwin_resize(   &term->cmd,     0, h-3,     w,   3 );
        
        x1 = w/4; x2 = w - x1 - x1;;
        hwin_resize(  &term->rate,     0,   0,    x1,   3 );
        hwin_resize( &term->title,    x1,   0,    x2,   3 );
        hwin_resize( &term->total, x1+x2,   0,    x1,   3 );
    }
    else
    {
        hwin_create(   &term->scr,     0,   3,     w, h-6 );
        hwin_create(   &term->cmd,     0, h-3,     w,   3 );

        hwin_create(  &term->rate,     0,   0,   w/4,   3 );
        hwin_create( &term->total, 3*w/4,   0,   w/4,   3 );
        hwin_create( &term->title, 1*w/4,   0, w-w/2,   3 );
    }

    hwin_touch( &term->scr );
    hwin_touch( &term->cmd );
    hwin_touch( &term->rate );
    hwin_touch( &term->total );
    hwin_touch( &term->title );

    hwin_refresh( &term->scr );
    hwin_refresh( &term->cmd );
    hwin_refresh( &term->rate );
    hwin_refresh( &term->total );
    hwin_refresh( &term->title );
}

void hterm_commands( hterm_t *term )
{
    hcommand_t *c;
    c = &term->commands;

    // Initialize the commands
    hcommand_init( c );

    // Add the commands
    hcommand_add(c,"serial","serial","receive data on a serial port", serial_command, term );
    hcommand_add(c,"listen","listen","receive data on a TCP/IP port", listen_command, term );
    hcommand_add(c,"clear","clear","clear the output window", clear_command, term );
    hcommand_add(c, "rst",  "rst","reset the application", reset_command, term );
    hcommand_add(c, "quit", "quit","quit the application",     quit_command, term );
    hcommand_add(c, "exit", "exit","quit the application",     quit_command, term );
    hcommand_add(c, "help", "help","show this help",           help_command, term );
}

void hterm_keys( hterm_t *term )
{
    hkey_t *k;
    k = &term->keys;

    // Initialize the keys
    hkey_init( k );

    // Add the keys
    hkey_add(k,    "Resize",   KEY_RESIZE,  "resize the window",resize_key,term);
    hkey_add(k,     "Enter",    KEY_ENTER,  "execute a command",enter_key,term);
    hkey_add(k,     "Enter",         '\n',  "execute a command",enter_key,term);
    hkey_add(k, "Backspace",KEY_BACKSPACE,    "delete a letter",backspace_key,term);
    hkey_add(k,  "Up Arrow",       KEY_UP,  "scroll histroy up",up_key,term);
    hkey_add(k,"Down Arrow",     KEY_DOWN,"scroll history down",down_key,term);
}

void hterm_init( hterm_t *term )
{
    // Initialize the ncurses window system
    hwin_init();
    hterm_resize( term, COLS, LINES, 0 );

    // Setup handler for window resizing
    gterm = term;
    signal( SIGWINCH, hterm_changesize );

    // Catch the quit signals
    signal( SIGTERM, hterm_quit );
    signal( SIGINT,  hterm_quit );

    // Ignore the SIGPIPE signal
    signal( SIGPIPE, SIG_IGN );
    
    // Show defaults in the statistics windows
    hwin_msgstr(&term->title, "HThreads Terminal", CENTER); hwin_refresh( &term->title );
    hwin_msgstr(&term->rate, "0.00 B/SEC", LEFT);           hwin_refresh( &term->rate );
    hwin_msgstr(&term->total, "0 B", RIGHT);                hwin_refresh( &term->total );

    // Initialize the available commands and keys
    hterm_commands( term );
    hterm_keys( term );
    
    // Setup the timer
    term->timer.it_value.tv_sec     = 1;
    term->timer.it_value.tv_usec    = 0;
    term->timer.it_interval.tv_sec  = 1;
    term->timer.it_interval.tv_usec = 0;
    
    // Setup the timer signal handler
    signal( SIGALRM, hterm_alarm );
    setitimer( ITIMER_REAL, &term->timer, &term->oldtimer );

    // Setup the timing data
    term->refresh   = 0;
    term->received  = 0;
    term->bytes     = 0;
    term->start     = clock();
}

void hterm_destroy( hterm_t *term )
{
    // Destroy the input system
    hinput_destroy( &term->input );
    
    // Destroy the log file
    hlog_close( &term->log );
    hlog_close( &term->data );

    // Destroy the keyboard map
    hkey_destroy( &term->keys );

    // Destroy the command map
    hcommand_destroy( &term->commands );

    // Destroy the ncurses system
    hwin_destroy( &term->scr );
    hwin_destroy( &term->cmd );
    hwin_destroy( &term->rate );
    hwin_destroy( &term->title );
    hwin_destroy( &term->total );
    hwin_finish();
}

void hterm_run( hterm_t *term )
{
    term->exit = 0;
    while( !term->exit )
    {
        if( term->refresh ) hterm_showstats( term );
        hinput_select( &term->input, NULL );

        hwin_setcur( &term->cmd );
        hwin_update();
    }
}

void hterm_options( hterm_t *term, int argc, char *argv[] )
{
    int c;
    int opt;
    int baud;
    int port;

    baud = 0;
    term->log.file  = NULL;
    term->data.file = NULL;
    while( (opt=getopt_long(argc,argv,"t:l:b:d:p:vh?",longopts,&c)) >= 0 )
    {
        switch( opt )
        {
        // Listen to a serial port for input
        case 't':
            if(baud<=0)
            {
                printf(" You must set the baud rate\n" );
                hterm_help( term );
            }
            hinput_serial( &term->input, optarg, baud, recv_serial, term );
            break;

        // Set the baud rate to use when opening the serial port
        case 'b':
            baud = atoi(optarg);
            if( baud <= 0 )
            {
                printf( "Invalid Baud Rate: %s\n", optarg );
                hterm_help( term );
            }
            break;

        // Set the text output log file
        case 'l':
            hlog_open( &term->log, &term->input, optarg, 1 );
            break;

        // Set the data output log file
        case 'd':
            hlog_open( &term->data, &term->input, optarg, 0 );
            break;

        // Listen to a port for data
        case 'p':
            port = atoi( optarg );
            hinput_listener( &term->input, port, recv_listen, term );
            break;

        // Show the version number and exit
        case 'v':
            printf( "hterm %s\n", HTERM_VERSION );
            exit(0);
            break;
            
        // Show the help and exit
        case '?':
        case 'h':
        default:
            hterm_help( term );
            break;
        }
    }
}

void hterm_help( hterm_t *term )
{
    endwin();

    printf("Usage: hterm [option...]\n");
    printf("   where option is\n");
    printf("   -t, --tty DEVICE : Receive input on a serial port\n");
    printf("   -b, --baud BAUD  : Set the baud rate for the serial port\n");
    printf("   -l, --log FILE   : Name of the log file to use\n");
    printf("   -d, --data FILE  : Name of the data log to use\n");
    printf("   -p, --port PORT  : Receive input from an IP port\n");
    printf("   -h, --help       : Show this help\n");
    printf("   -v, --version    : Show the version of the program\n");

    hterm_destroy( term );
    exit(0);
}

int main( int argc, char *argv[] )
{
    hterm_t     term;

    // Initialize the input system
    hinput_create( &term.input );
    hinput_read( &term.input, STDIN, recv_stdin, &term );

    // Parse the program options
    hterm_options( &term, argc, argv );

    // Initialize the system
    hterm_init( &term );

    // Run the system
    hterm_run( &term );

    // Destroy the system
    hterm_destroy( &term );
    
    return 0;
}
