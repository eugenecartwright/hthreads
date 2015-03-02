#ifndef _HCOMMAND_H_
#define _HCOMMAND_H_

#include <hwin.h>
#include <hinput.h>

#define STDIN   0
#define STDOUT  1
#define STDERR  2

typedef void (*command)( void*, char* );
typedef void (*showhelp)( void*, const char*, ... );

typedef struct
{
    char        *name;
    char        *cmd;
    char        *help;
    void        *data;
    command     command;
} hcmd_t;

typedef struct
{
    int         size;
    hcmd_t      *cmds;
} hcommand_t;

extern void hcommand_init( hcommand_t* );
extern void hcommand_destroy( hcommand_t* );
extern int  hcommand_add( hcommand_t*, char*, char*, char*, command, void* );
extern void hcommand_rem( hcommand_t*, char*, char* );
extern void hcommand_run( hcommand_t*, char* );
extern void hcommand_help( hcommand_t*, showhelp, void* );
extern void hcommand_parse( char*, char ***, int* );

#endif
