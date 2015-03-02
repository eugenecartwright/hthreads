#ifndef _GRAPHICS_KERNEL_H_
#define _GRAPHICS_KERNEL_H_

#include <math.h>

typedef struct
{
    int32   size;
    int32   div;
    int32   *data;
} kernel_t;

static inline int32 kernel_create( kernel_t *kernel, int32 div, int32 size )
{
    kernel->data = (int32*)malloc( size*size*sizeof(int32) );
    if( kernel->data == NULL )  return EINVAL;

    kernel->size = size;
    kernel->div  = div;

    return 0;
}

static inline int32 kernel_destroy( kernel_t *kernel )
{
    if( kernel->data != NULL )  free( kernel->data );
    kernel->data = NULL;
    kernel->size = 0;
    kernel->div  = 0;

    return 0;
}

static inline int32 kernel_get( kernel_t *kernel, int32 x, int32 y )
{
    return kernel->data[y*kernel->size + x];
}

static inline void kernel_set( kernel_t *kernel, int32 x, int32 y, int32 v )
{
    kernel->data[y*kernel->size + x] = v;
}

static inline void kernel_sharpen( kernel_t *k, int s )
{
    kernel_create( k, s, 3 );

    kernel_set(k,0,0,-0); kernel_set(k,0,1,-1);  kernel_set(k,0,2,-0);
    kernel_set(k,1,0,-1); kernel_set(k,1,1,s+4); kernel_set(k,1,2,-1);
    kernel_set(k,2,0,-0); kernel_set(k,2,1,-1);  kernel_set(k,2,2,-0);
}

static inline void kernel_emboss( kernel_t *k )
{
    kernel_create( k, 1, 3 );

    kernel_set(k,0,0,-2); kernel_set(k,0,1,-1); kernel_set(k,0,2, 0);
    kernel_set(k,1,0,-1); kernel_set(k,1,1, 1); kernel_set(k,1,2, 1);
    kernel_set(k,2,0, 0); kernel_set(k,2,1, 1); kernel_set(k,2,2, 2);
}

#endif
