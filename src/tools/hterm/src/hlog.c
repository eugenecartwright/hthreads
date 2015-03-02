#include <hlog.h>
#include <hinput.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

int hlog_open( hlog_t *log, hinput_t *input, const char *path, int head )
{
    char        buffer[256];
    time_t      t;
    struct tm   *tm;

    log->head  = NULL;
    log->tail  = NULL;
    log->input = input;
    log->file  = fopen( path, "a" );
    if( log->file == NULL )     return -1;

    hinput_nonblocking( fileno(log->file) );
    if( head )
    {
        t  = time(NULL);
        tm = localtime( &t );
        if( tm == NULL )    return -1;
        
        strftime( buffer, 256, "\n\n%r - %A, %B %d, %Y\n", tm );
        hlog_write( log, buffer, strlen(buffer) );

        snprintf(buffer,256,"--------------------------------------------------\n");
        hlog_write( log, buffer, strlen(buffer) );
    }

    return 0;
}

int hlog_close( hlog_t *log )
{
    if( log->file != NULL )     fclose( log->file );
    log->file = NULL;

    return 0;
}

int hlog_write( hlog_t *log, const char *data, size_t size )
{
    if( log->input == NULL || log->file == NULL )   return -2;

    hlog_data_t *dat;
    dat = (hlog_data_t*)malloc( sizeof(hlog_data_t) );

    dat->size      = size;
    dat->off       = 0;
    dat->next      = NULL;

    dat->data      = (char*)malloc( size );
    if( dat->data == NULL )    return -1;

    memcpy( dat->data, data, size );
    if( log->head == NULL ) { log->head = dat; log->tail = dat; }
    else                    { log->tail->next = dat; log->tail = dat; }

    hinput_write( log->input, fileno(log->file), hlog_perform, log );
    return 0;
}

int hlog_perform( int fd, void *data )
{
    size_t      wrt;
    hlog_t      *log;
    hlog_data_t *dat;

    log = (hlog_t*)data;
    dat = log->head;
    if( dat == NULL ) return 1;

    wrt = fwrite( &dat->data[dat->off], 1, dat->size-dat->off, log->file );
    dat->off += wrt;

    if( dat->off >= dat->size )
    {
        log->head = dat->next;
        free( dat->data );
        free( dat );
    }

    if( log->head == NULL ) return 1;
    else                    return 0;

    return 0;
}
