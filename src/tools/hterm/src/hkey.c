#include <hkey.h>
#include <stdlib.h>
#include <string.h>

void hkey_init( hkey_t *key )
{
    key->size = 0;
    key->keys = NULL;
}

void hkey_destroy( hkey_t *key )
{
    if( key->keys != NULL )    free( key->keys );

    key->size = 0;
    key->keys = NULL;
}

void hkey_resize( hkey_t *key, int s )
{
    int i;

    if(key->keys==NULL) key->keys = (hk_t*)malloc( s*sizeof(hk_t) );
    else                key->keys = (hk_t*)realloc(key->keys,s*sizeof(hk_t) );

    for( i = key->size; i < s; i++ )   key->keys[i].name = NULL;
    key->size = s;
}

int hkey_free( hkey_t *key )
{
    int i;

    for( i = 0; i < key->size; i++ )   if( key->keys[i].name == NULL) return i;
    return -1;
}

int hkey_find( hkey_t *key, char *name )
{
    int i;

    if( name == NULL ) return -1;
    for( i = 0; i < key->size; i++ )   if(key->keys[i].name != NULL && strcmp(key->keys[i].name,name)==0) return i;
    return -1;
}

int hkey_add( hkey_t *key, char *n, const chtype t, char *h, keypr c, void *v )
{
    int free;

    // Find a free location, allocating more room if neccessary
    free = hkey_free( key );
    if( free < 0 )  { hkey_resize(key, key->size+10); free = hkey_free(key); }

    // If there is still no room then fail
    if( free < 0 )  return -1;

    // Store the new key
    key->keys[free].name    = n;
    key->keys[free].help    = h;
    key->keys[free].data    = v;
    key->keys[free].chkey   = t;
    key->keys[free].key     = c;

    // Return successfully
    return 0;
}

void hkey_remove( hkey_t *key, char *name )
{
    int find;

    find = hkey_find( key, name );
    while( find > 0 )
    {
        key->keys[find].name = NULL;
        find = hkey_find( key, name );
    }
}

void hkey_run( hkey_t *key, const chtype ch, keypr def, void *data )
{
    int i;        
    int found;

    found = 0;
    for( i = 0; i < key->size; i++ )
    {
        if( key->keys[i].name != NULL && key->keys[i].chkey == ch )
        {
            found = 1;
            key->keys[i].key( ch, key->keys[i].data );
        }
    }

    if( !found && def != NULL ) def( ch, data );
}

void hkey_help( hkey_t *key, showkey help, void *data )
{
    int i;

    for( i = 0; i < key->size; i++ )
    {
        if( key->keys[i].name != NULL )
        {
            help( data, "\t%s\t: %s\n", key->keys[i].name, key->keys[i].help );
        }
    }
}
