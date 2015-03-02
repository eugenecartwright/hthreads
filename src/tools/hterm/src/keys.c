#include <hterm.h>
#include <stdio.h>

void resize_key( const chtype ch, void *data )
{
    int w;
    int h;
    hterm_t *term;
    term = (hterm_t*)data;

    getmaxyx(stdscr, h, w);
    endwin();
    initscr();

    resizeterm( h, w );
    hterm_resize( term, w, h, 1 );
    wrefresh( curscr );
}

void backspace_key( const chtype ch, void *data )
{
    hterm_t *term;
    term = (hterm_t*)data;

    hwin_bdelch( &term->cmd );
}

void enter_key( const chtype ch, void *data )
{
    hterm_t *term;
    term = (hterm_t*)data;

    hwin_clear( &term->cmd );
    hwin_baddch( &term->scr, '\n' );
    hwin_baddline( &term->scr, term->cmd.line );
    hcommand_run( &term->commands, term->cmd.line );
    hwin_bnextline( &term->cmd );
}

void up_key( const chtype ch, void *data )
{
    hterm_t *term;
    term = (hterm_t*)data;
}

void down_key( const chtype ch, void *data )
{
    hterm_t *term;
    term = (hterm_t*)data;
}

void default_key( const chtype ch, void *data )
{
    hterm_t *term;
    term = (hterm_t*)data;

    if( ch != ERR ) hwin_baddch( &term->cmd, ch );
}
