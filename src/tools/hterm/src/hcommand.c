#include <hcommand.h>
#include <stdlib.h>
#include <string.h>

void hcommand_init( hcommand_t *list )
{
    list->size = 0;
    list->cmds = NULL;
}

void hcommand_destroy( hcommand_t *list )
{
    if( list->cmds != NULL )    free( list->cmds );

    list->size = 0;
    list->cmds = NULL;
}

void hcommand_resize( hcommand_t *list, int s )
{
    int i;

    if(list->cmds==NULL)  list->cmds = (hcmd_t*)malloc( s*sizeof(hcmd_t) );
    else                  list->cmds = (hcmd_t*)realloc(list->cmds,s*sizeof(hcmd_t) );

    for( i = list->size; i < s; i++ )   list->cmds[i].name = NULL;
    list->size = s;
}

int hcommand_free( hcommand_t *list )
{
    int i;

    for( i = 0; i < list->size; i++ )   if( list->cmds[i].name == NULL) return i;
    return -1;
}

int hcommand_find( hcommand_t *list, char *name )
{
    int i;

    if( name == NULL ) return -1;
    for( i = 0; i < list->size; i++ )   if(list->cmds[i].name != NULL && strcmp(list->cmds[i].name,name)==0) return i;
    return -1;
}

int hcommand_add( hcommand_t *list, char *n, char *d, char *h, command c, void *v )
{
    int free;

    // Find a free location, allocating more room if neccessary
    free = hcommand_free( list );
    if( free < 0 )  { hcommand_resize(list, list->size+10); free = hcommand_free(list); }

    // If there is still no room then fail
    if( free < 0 )  return -1;

    // Store the new command
    list->cmds[free].cmd        = d;
    list->cmds[free].name       = n;
    list->cmds[free].help       = h;
    list->cmds[free].data       = v;
    list->cmds[free].command    = c;

    // Return successfully
    return 0;
}

void hcommand_remove( hcommand_t *list, char *name )
{
    int find;

    find = hcommand_find( list, name );
    while( find > 0 )
    {
        list->cmds[find].name = NULL;
        find = hcommand_find( list, name );
    }
}

void hcommand_run( hcommand_t *list, char *cmd )
{
    int i;
    char *spc;
    if( cmd == NULL ) return;
    
    spc = strchr( cmd, ' ' );
    if( spc != NULL ) *spc = '\0';

    for( i = 0; i < list->size; i++ )
    {
        if( list->cmds[i].name != NULL && strcmp(list->cmds[i].cmd, cmd) == 0 )
        {
            if( spc != NULL ) { *spc = ' '; spc++; }
            list->cmds[i].command( list->cmds[i].data, spc );
        }
    }
}

void hcommand_help( hcommand_t *list, showhelp help, void *data )
{
    int i;

    for( i = 0; i < list->size; i++ )
    {
        if( list->cmds[i].name != NULL )
        {
            help( data, "\t%s\t: %s\n", list->cmds[i].cmd, list->cmds[i].help );
        }
    }
}

void hcommand_parse( char *args, char ***opts, int *num )
{
    int  i;
    int  m;
    char *tokn;
    char *save;
    char **opt;

    i = 0;
    m = 5;
    opt = (char**)malloc( m*sizeof(char*) );

    tokn = strtok_r( args, " \t\n\r", &save );
    while( tokn != NULL )
    { 
        if( i >= m )    { m += 5; opt = (char**)realloc(opt,m*sizeof(char*) ); }
        opt[i++] = tokn;

        tokn = strtok_r(NULL," \t\n\r",&save);
    }

    *num  = i;
    *opts = opt;
}
