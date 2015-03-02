#ifndef _GRAPHICS_OUTPUT_H_
#define _GRAPHICS_OUTPUT_H_

#include <framebuffer.h>

#define TGA_RAW     0
#define TGA_RLE     1

extern int32 framebuffer_rawout(framebuffer_t*,const char*);
extern int32 framebuffer_ppmout(framebuffer_t*,const char*);
extern int32 framebuffer_tgaout(framebuffer_t*,const char*,uint32);

#endif
