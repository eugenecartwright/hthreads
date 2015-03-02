#ifndef _GRAPHICS_RECT_H_
#define _GRAPHICS_RECT_H_

#include <framebuffer.h>

typedef struct
{
    int32   x;
    int32   y;
    int32   w;
    int32   h;
} rect_t;

#define rect_make(_x,_y,_w,_h)  ({  \
    rect_t rect;                    \
    rect.x = _x;                    \
    rect.y = _y;                    \
    rect.w = _w;                    \
    rect.h = _h;                    \
    &rect;                          \
})

#endif
