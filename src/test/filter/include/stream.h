#ifndef _IMAGE_STREAM_H_
#define _IMAGE_STREAM_H_

#include <stream/const.h>
#include <stream/buffer.h>
#include <stream/types.h>
#include <stream/nodes.h>

extern void stream_show( stream_t *stream );
extern void stream_create( stream_t *stream );
extern void stream_destroy( stream_t *stream );

#endif
