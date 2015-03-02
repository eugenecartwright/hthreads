#ifndef _IMAGE_FORMAT_GRAY_H_
#define _IMAGE_FORMAT_GRAY_H_

#include <itypes.h>
#include <colors/gray.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

typedef struct
{
    int32           width;
    int32           height;
    int32           depth;
    color_gray_t    *data;
} framebuffer_gray_t;

static inline int32 gray_create( framebuffer_gray_t *img, int32 width, int32 height )
{
    img->data = (color_gray_t*)malloc( width*height*sizeof(color_gray_t) );
    if( img->data == NULL ) return ENOMEM;

    img->width  = width;
    img->height = height;
    img->depth  = 8;

    return 0;
}

static inline int32 gray_destroy( framebuffer_gray_t *img )
{
    if( img->data != NULL ) free( img->data );
    img->data   = NULL;
    img->width  = 0;
    img->height = 0;
    img->depth  = 0;
    return 0;
}

static inline color_gray_t gray_get( framebuffer_gray_t *img, int32 x, int32 y )
{
    return img->data[y*img->width + x];
}

static inline void gray_set(framebuffer_gray_t *img,int32 x,int32 y,color_gray_t val)
{
    img->data[y*img->width + x] = val;
}

static inline color_gray_t gray_pixel( framebuffer_gray_t *img, int32 loc )
{
    return img->data[loc];
}

static inline void gray_place( framebuffer_gray_t *img, int32 loc, color_gray_t c )
{
    img->data[loc] = c;
}

static inline void gray_clone( framebuffer_gray_t *dst, framebuffer_gray_t *src )
{
    gray_create( dst, src->width, src->height );
    memcpy( dst->data, src->data, src->width*src->height*sizeof(color_gray_t) );
}

static inline void gray_copy( framebuffer_gray_t *dst, framebuffer_gray_t *src )
{
    memcpy( dst->data, src->data, src->width*src->height*sizeof(color_gray_t) );
}

#endif
