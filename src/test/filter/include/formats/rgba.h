#ifndef _IMAGE_FORMAT_RGBA_H_
#define _IMAGE_FORMAT_RGBA_H_

#include <itypes.h>
#include <colors/rgba.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

typedef struct
{
    int32           width;
    int32           height;
    int32           depth;
    color_rgba_t     *data;
} framebuffer_rgba_t;

static inline int32 rgba_create( framebuffer_rgba_t *img, int32 width, int32 height )
{
    img->data = (color_rgba_t*)malloc( width*height*sizeof(color_rgba_t) );
    if( img->data == NULL ) return ENOMEM;

    img->width  = width;
    img->height = height;
    img->depth  = 32;

    return 0;
}

static inline int32 rgba_destroy( framebuffer_rgba_t *img )
{
    if( img->data != NULL ) free( img->data );
    img->data   = NULL;
    img->width  = 0;
    img->height = 0;
    img->depth  = 0;
    return 0;
}

static inline color_rgba_t rgba_get( framebuffer_rgba_t *img, int32 x, int32 y )
{
    return img->data[y*img->width + x];
}

static inline void rgba_set(framebuffer_rgba_t *img,int32 x,int32 y,color_rgba_t val)
{
    img->data[y*img->width + x] = val;
}


static inline color_rgba_t rgba_pixel( framebuffer_rgba_t *img, int32 loc )
{
    return img->data[loc];
}

static inline void rgba_place( framebuffer_rgba_t *img, int32 loc, color_rgba_t c )
{
    img->data[loc] = c;
}

static inline void rgba_clone( framebuffer_rgba_t *dst, framebuffer_rgba_t *src )
{
    rgba_create( dst, src->width, src->height );
    memcpy( dst->data, src->data, src->width*src->height*sizeof(color_rgba_t) );
}

static inline void rgba_copy( framebuffer_rgba_t *dst, framebuffer_rgba_t *src )
{
    memcpy( dst->data, src->data, src->width*src->height*sizeof(color_rgba_t) );
}

#endif
