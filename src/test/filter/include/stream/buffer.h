#ifndef _IMAGE_STREAM_BUFFER_H_
#define _IMAGE_STREAM_BUFFER_H_

#include <hthread.h>

// Declare the buffer type
typedef struct
{
    int             size;
    int             num;
    int             head;
    int             tail;
    hthread_mutex_t mutex;
    hthread_cond_t  notfull;
    hthread_cond_t  notempty;
    framebuffer_t   **frames;
} buffer_t;

// Declare the buffer functions
extern int buffer_init( buffer_t*, int );
extern int buffer_destroy( buffer_t* );
extern void buffer_insert( buffer_t*, framebuffer_t*);
extern framebuffer_t* buffer_remove( buffer_t*);

#endif
