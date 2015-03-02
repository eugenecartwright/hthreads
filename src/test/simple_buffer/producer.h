#ifndef _PRODUCER_H_
#define _PRODUCER_H_

typedef struct
{
    int         num;
    buffer_t    *buffer;
} producer_t;

extern void* producer( void* );

#endif
