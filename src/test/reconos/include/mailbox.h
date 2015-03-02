#ifndef _BUFFER_H_
#define _BUFFER_H_

#include <hthread.h>

typedef struct
{
    int     size;
    int     head;
    int     tail;
    int     num;
    void    **mailbox;

    hthread_mutex_t mutex;
    hthread_cond_t  notempty;
    hthread_cond_t  notfull;
} mailbox_t;

extern int mailbox_init( mailbox_t*, int );
extern int mailbox_destroy( mailbox_t* );
extern int mailbox_write( mailbox_t*, void* );
extern void* mailbox_read( mailbox_t* );
extern int mailbox_trywrite( mailbox_t*, void* );
extern void* mailbox_tryread( mailbox_t* );
extern int mailbox_size( mailbox_t* );

#endif
