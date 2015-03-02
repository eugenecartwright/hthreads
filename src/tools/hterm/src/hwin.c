#include <hwin.h>
#include <stdarg.h>
#include <string.h>
#include <stdlib.h>

static int updatescreens=0;
int hwin_init( void )
{
    initscr();                  // Initialize the ncurses screen
    cbreak();                   // Turn off output buffering
    noecho();                   // Turn off character echo'ing
    nodelay(stdscr, FALSE);     // Turn off 
    nl();                       // Do not do NL -> CR/NL mapping
    keypad(stdscr, TRUE);       // Turn on support for the keypad
    leaveok(stdscr, TRUE);     // Restore the cursor
    curs_set( 0 );              // Make the cursor invisible

    // Use colors if the terminal has them
    if( has_colors() && 0 )
    {
        start_color();

        init_pair(COLOR_BLACK, COLOR_BLACK, COLOR_WHITE);
        init_pair(COLOR_GREEN, COLOR_GREEN, COLOR_WHITE);
        init_pair(COLOR_RED, COLOR_RED, COLOR_WHITE);
        init_pair(COLOR_CYAN, COLOR_CYAN, COLOR_WHITE);
        init_pair(COLOR_WHITE, COLOR_WHITE, COLOR_WHITE);
        init_pair(COLOR_MAGENTA, COLOR_MAGENTA, COLOR_WHITE);
        init_pair(COLOR_BLUE, COLOR_BLUE, COLOR_WHITE);
        init_pair(COLOR_YELLOW, COLOR_YELLOW, COLOR_WHITE);

        attron( COLOR_PAIR(1) );
    }

    return 0;
}

int hwin_finish( void )
{
    endwin();
    return 0;
}

int hwin_create( hwin_t *win, int x, int y, int w, int h )
{
    // Create a new window
    win->win = newwin( h, w, y, x );
    win->sub = subwin( win->win, h-2, w-2, y+1, x+1 );

    // Setup the default box for the window
    box( win->win, 0, 0 );
    wrefresh( win->win );

    // Setup window options
    idlok( win->sub, FALSE );
    wsetscrreg( win->sub, y, h+1 );
    scrollok( win->sub, TRUE );
    nodelay( win->sub, TRUE );
    keypad( win->sub, TRUE);
    leaveok( win->win, TRUE );
    leaveok( win->sub, FALSE );

    // Show the new window
    hwin_refresh( win );

    // There is currently no buffer
    win->buffer = NULL;

    // There is currently no line
    win->line  = NULL;
    win->lsize = 0;

    // Setup the line buffer
    hwin_bset( win, 5000 );

    return 0;
}

int hwin_destroy( hwin_t *win )
{
    // Erase the border of the window
    wborder(win->win,' ',' ',' ',' ',' ',' ',' ',' ');

    // Refresh the window one last time
    wrefresh( win->win );

    // Delete the window
    delwin( win->win );
    delwin( win->sub );

    return 0;
}

void hwin_refresh( hwin_t *win )
{
    // Draw a box around the window
    box( win->win, 0, 0 );

    // Refresh the screen
    touchwin( win->win );
    wnoutrefresh( win->win );

    // Tell the system the screen needs updating
    updatescreens=1;
}

void hwin_update( void )
{
    if( updatescreens )
    {
        doupdate();
        updatescreens=0;
    }
}

void hwin_setcur( hwin_t *win )
{
    int y;
    int x;

    getyx( win->sub, y, x );
    wmove( win->sub, y, x );
    wrefresh( win->sub );
}

void hwin_printw( hwin_t *win, const char *fmt, ... )
{
    va_list args;

    va_start( args, fmt );
    vwprintw( win->sub, fmt, args );
    va_end( args );
}

void hwin_vprintw( hwin_t *win, const char *fmt, va_list args )
{
    vwprintw( win->sub, fmt, args );
}

void hwin_msgstr( hwin_t *win, const char *str, int align )
{
    int x;
    int y;
    int mx;
    int my;
    int len;

    getyx(win->sub,x,y);
    len = strlen( str );
    switch( align )
    {
    case LEFT:
        break;

    case RIGHT:
        getmaxyx( win->sub, my, mx );
        x = mx - len - 1;
        break;

    case CENTER:
        getmaxyx( win->sub, my, mx );
        x = mx/2 - len/2;
        break;
    }

    mvwaddstr( win->sub, y, x, str );
}

void hwin_addstr( hwin_t *win, const char *str )
{
    waddstr( win->sub, str );
}

void hwin_resize( hwin_t *win, int x, int y, int w, int h )
{
    mvwin( win->win, y, x );
    wresize( win->win, h, w );
}

void hwin_touch( hwin_t *win )
{
    touchwin( win->win );
}

int hwin_getch( hwin_t *win )
{
    return wgetch( win->sub );
}

void hwin_addch( hwin_t *win, const chtype ch )
{
    waddch( win->sub, ch );
}

void hwin_echoch( hwin_t *win, const chtype ch )
{
    wechochar( win->sub, ch );
}

void hwin_move( hwin_t *win, int xd, int yd )
{
    int x;
    int y;

    getyx( win->sub, y, x );
    x += xd;
    y += yd;

    wmove( win->sub, y, x );
}

void hwin_clear( hwin_t *win )
{
    werase( win->sub );
}

void hwin_bset( hwin_t *win, int size )
{
    int i;

    hwin_bdel( win );
    win->buffer     = (char**)malloc( size*sizeof(char*) );
    win->bmaxsize   = size;
    win->bsize      = 0;
    win->bnext      = 0;

    for( i = 0; i < win->bmaxsize; i++ )    win->buffer[i] = NULL;
}

void hwin_bdel( hwin_t *win )
{
    int i;

    if( win->buffer == NULL )   return;  
    for( i = 0; i < win->bmaxsize; i++ )
    {
        if( win->buffer[i] != NULL )    { free(win->buffer[i]); win->buffer[i] = NULL; }
    }

    free( win->buffer );
    win->buffer = NULL;
}

void hwin_baddch( hwin_t *win, const char ch )
{
    if( win->line == NULL )
    {
        win->lnext   = 0;
        win->lsize   = 500;
        win->line    = (char*)malloc( win->lsize*sizeof(char) );
    }
    
    if( win->lnext >= win->lsize )
    {
        win->lsize   += 500;
        win->line    = (char*)realloc( win->line, win->lsize*sizeof(char) );
    }

    win->line[ win->lnext ] = ch;
    win->lnext++;
    win->line[ win->lnext ] = '\0';

    hwin_echoch( win, ch );
}

void hwin_bdelch( hwin_t *win )
{
    hwin_move( win, -1, 0 );
    hwin_addch( win, ' ' );
    hwin_move( win, -1, 0 );
    hwin_refresh( win );

    if( win->line != NULL && win->lnext > 0 )
    {
        win->lnext--;
        win->line[ win->lnext ] = '\0';
    }
}

void hwin_bnextline( hwin_t *win )
{
    win->line = NULL;
}

void hwin_baddline( hwin_t *win, char *line )
{
    if( win->buffer[win->bnext] != NULL )     free( win->buffer[ win->bnext ] );

    win->buffer[ win->bnext ] = line;
    win->bnext = (win->bnext + 1) % win->bmaxsize;
    win->bsize++;

    waddstr( win->sub, line );
    hwin_refresh( win );
}

char* hwin_getline( hwin_t *win )
{
    return win->line;
}

char* hwin_gethistory( hwin_t *win, int loc )
{
    loc = 0;
    return win->buffer[ loc ];
}
