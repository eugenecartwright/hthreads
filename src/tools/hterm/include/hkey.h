#ifndef _HKEY_H_
#define _HKEY_H_

#include <ncurses.h>

typedef void (*keypr)( const chtype, void* );
typedef void (*showkey)( void*, const char*, ... );

typedef struct
{
    char    *name;
    chtype  chkey;
    char    *help;
    void    *data;
    keypr   key;
} hk_t;

typedef struct
{
    int     size;
    hk_t    *keys;
} hkey_t;

extern void hkey_init( hkey_t* );
extern void hkey_destroy( hkey_t* );
extern int  hkey_add( hkey_t*, char*, const chtype, char*, keypr, void* );
extern void hkey_rem( hkey_t*, char*, char* );
extern void hkey_run( hkey_t*, const chtype, keypr, void *data );
extern void hkey_help( hkey_t*, showkey, void* );

#endif
