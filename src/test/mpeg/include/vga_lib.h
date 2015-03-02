//
// VGA library for hthreads
// Author: Andres Baez
// Date: Fall 2010
//

#ifndef _VGA_LIB_H_
#define _VGA_LIB_H_

#include <stdio.h>
#include <hthread.h>
#include <vga/vga.h>
#include <config.h>

#define DISPLAY_COLUMNS  640
#define DISPLAY_ROWS     480

#define color_make(_r,_g,_b,_a) ({pixel_t c; c.r = _r; c.g = _g; c.b = _b; c;})

typedef unsigned char uint8;

// Define a pixel
struct __color_rgb_t {
    uint8   r;
    uint8   g;
    uint8   b;
} __attribute__((__packed__));;

// Define a pixel type
typedef struct __color_rgb_t  pixel_t;

// Structure that defines the framebuffer
typedef struct {
    int width;
    int height;
    pixel_t *im_ptr;
} framebuffer_t;

 ////////////////////////
// FUNCTION DEFINITIONS //
 ////////////////////////

void vgaoutput_init(vga_t *vga);
pixel_t framebuffer_get(framebuffer_t * im, int xc, int yc);
void framebuffer_set(framebuffer_t * im, int xc, int yc, pixel_t p);
int color_red(pixel_t p);
int color_green(pixel_t p);
int color_blue(pixel_t p);
void vgaoutput_show_frame(vga_t *vga, framebuffer_t *frame);

 ///////////////////
// FUNCTION BODIES //
 ///////////////////

#endif

