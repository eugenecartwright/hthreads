#ifndef _IMAGE_FORMAT_RGB_H_
#define _IMAGE_FORMAT_RGB_H_

#include <itypes.h>
#include <colors/rgb.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

typedef struct
{
    int32           width;
    int32           height;
    int32           depth;
    color_rgb_t     *data;
} framebuffer_rgb_t;

static inline int32 rgb_create( framebuffer_rgb_t *img, int32 width, int32 height )
{
    img->data = (color_rgb_t*)malloc( width*height*sizeof(color_rgb_t) );
    if( img->data == NULL ) return ENOMEM;

    img->width  = width;
    img->height = height;
    img->depth  = 24;

    return 0;
}

static inline int32 rgb_destroy( framebuffer_rgb_t *img )
{
    if( img->data != NULL ) free( img->data );
    img->data   = NULL;
    img->width  = 0;
    img->height = 0;
    img->depth  = 0;
    return 0;
}

static inline color_rgb_t rgb_get( framebuffer_rgb_t *img, int32 x, int32 y )
{
    return img->data[y*img->width + x];
}

static inline void rgb_set(framebuffer_rgb_t *img,int32 x,int32 y,color_rgb_t val)
{
    img->data[y*img->width + x] = val;
}

static inline color_rgb_t rgb_pixel( framebuffer_rgb_t *img, int32 loc )
{
    return img->data[loc];
}

static inline void rgb_place( framebuffer_rgb_t *img, int32 loc, color_rgb_t c )
{
    img->data[loc] = c;
}

static inline void rgb_clone( framebuffer_rgb_t *dst, framebuffer_rgb_t *src )
{
    rgb_create( dst, src->width, src->height );
    memcpy( dst->data, src->data, src->width*src->height*sizeof(color_rgb_t) );
}

static inline void rgb_copy( framebuffer_rgb_t *dst, framebuffer_rgb_t *src )
{
    memcpy( dst->data, src->data, src->width*src->height*sizeof(color_rgb_t) );
}

#endif
