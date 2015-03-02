#ifndef _BUFFER_H_
#define _BUFFER_H_

#include <hthread.h>

typedef struct
{
    int     size;
    int     head;
    int     tail;
    int     num;
    int     *buffer;

    hthread_mutex_t mutex;
    hthread_cond_t  notempty;
    hthread_cond_t  notfull;
} buffer_t;

extern int buffer_init( buffer_t*, int );
extern int buffer_destory( buffer_t* );
extern int buffer_write( buffer_t*, int );
extern int buffer_read( buffer_t* );
extern int buffer_size( buffer_t* );

#endif
