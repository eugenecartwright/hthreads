#ifndef _IMAGE_STREAM_TYPES_H_
#define _IMAGE_STREAM_TYPES_H_

#include <hthread.h>
#include <stream/buffer.h>

// Declare the stream node type
typedef struct
{
    const char      *name;
    hthread_start_t func;
    hthread_t       tid;
    buffer_t        *input;
    buffer_t        *output;
} stream_node_t;

// Declare the stream type
typedef struct
{
    int             input;
    int             output;
    int             input_size;
    int             output_size;
    int             start;
    int             create;
    stream_node_t   node;
} stream_t;

#endif
