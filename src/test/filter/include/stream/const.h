#ifndef _IMAGE_STREAM_CONST_H_
#define _IMAGE_STREAM_CONST_H_

//#include <hthread.h>
#include <stream/buffer.h>

// The length of the FIFO buffers between stream nodes
#define FIFO_LENGTH     1

// The width and height of the input image
#define INPUT_WIDTH     320 // 320, 160
#define INPUT_HEIGHT    240 // 240, 120

#ifdef COLOR_GRAY
#define INPUT_DEPTH     8
#endif

#ifdef COLOR_RGB
#define INPUT_DEPTH     24
#endif

#ifdef COLOR_RGBA
#define INPUT_DEPTH     32
#endif

#endif
