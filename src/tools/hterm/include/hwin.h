#ifndef _HWIN_H_
#define _HWIN_H_

#include <ncurses.h>
#include <stdarg.h>

#define LEFT    0
#define RIGHT   1
#define CENTER  2

typedef struct
{
    WINDOW  *win;
    WINDOW  *sub;

    int     bsize;
    int     bnext;
    int     bmaxsize;
    char    **buffer;

    int     lsize;
    int     lnext;
    char    *line;
    
    int x;
    int y;
    int w;
    int h;
} hwin_t;

extern int hwin_init( void );
extern int hwin_finish( void );
extern int hwin_create( hwin_t*, int x, int y, int w, int h );
extern int hwin_destroy( hwin_t* );
extern void hwin_refresh( hwin_t* );
extern void hwin_update( void );

extern int hwin_getch( hwin_t* );
extern void hwin_setcur( hwin_t* );

extern void hwin_addch( hwin_t*, const chtype );
extern void hwin_echoch( hwin_t*, const chtype );
extern void hwin_printw( hwin_t*, const char*, ... );
extern void hwin_vprintw( hwin_t*, const char*, va_list );
extern void hwin_msgstr( hwin_t*, const char*, int );
extern void hwin_addstr( hwin_t*, const char* );
extern void hwin_move( hwin_t*, int xd, int yd );
extern void hwin_erase( hwin_t* );

extern void hwin_bset( hwin_t*, int );
extern void hwin_bdel( hwin_t* );
extern void hwin_baddch( hwin_t*, const char );
extern void hwin_bdelch( hwin_t* );
extern void hwin_baddline( hwin_t*, char* );
extern void hwin_bnextline( hwin_t* );
extern char* hwin_getline( hwin_t* );
extern char* hwin_gethistroy( hwin_t*, int );

extern void hwin_resize( hwin_t*, int, int, int, int );
extern void hwin_touch( hwin_t* );
extern void hwin_clear( hwin_t* );
#endif
