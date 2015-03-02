#ifndef _HLOG_H_
#define _HLOGH_

#include <stdio.h>
#include <hinput.h>

typedef struct _log_data
{
    size_t              size;
    size_t              off;
    char                *data;
    struct _log_data    *next;
} hlog_data_t;

typedef struct
{
    FILE        *file;
    hinput_t    *input;
    hlog_data_t *head;
    hlog_data_t *tail;
} hlog_t;

extern int hlog_open( hlog_t*, hinput_t*, const char*, int );
extern int hlog_close( hlog_t* );
extern int hlog_write( hlog_t*, const char*, size_t );

extern int hlog_perform( int fd, void* );
#endif
