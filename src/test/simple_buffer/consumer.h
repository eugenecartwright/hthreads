#ifndef _CONSUMER_H_
#define _CONSUMER_H_

typedef struct
{
    int         num;
    buffer_t    *buffer;
} consumer_t;

extern void* consumer( void* );

#endif
