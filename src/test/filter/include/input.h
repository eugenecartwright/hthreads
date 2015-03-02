#ifndef _IMAGE_INPUT_H_
#define _IMAGE_INPUT_H_

#include <framebuffer.h>

extern int32 framebuffer_rawin(framebuffer_t*,const char*);
extern int32 framebuffer_ppmin(framebuffer_t*,const char*);
extern int32 framebuffer_tgain(framebuffer_t*,const char*);

extern int32 framebuffer_rawread(framebuffer_t*,framebuffer_file_t,int32,int32,int32);
extern int32 framebuffer_tgaread(framebuffer_t*,framebuffer_file_t);

#endif
