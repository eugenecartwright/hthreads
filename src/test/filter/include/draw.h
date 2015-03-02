#ifndef _GRAPHICS_DRAW_H_
#define _GRAPHICS_DRAW_H_

#include <rect.h>
#include <framebuffer.h>

extern int32 framebuffer_rect(framebuffer_t*,rect_t*,color_t);
extern int32 framebuffer_fill(framebuffer_t*,color_t);
extern int32 framebuffer_clear(framebuffer_t*);

#endif
