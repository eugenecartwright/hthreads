//
// VGA library for hthreads
// Author: Andres Baez
// Date: Fall 2010
//

#ifndef VGA_LIB_H
#define VGA_LIB_H

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

// Initializes vga output
void vgaoutput_init(vga_t *vga) {
    vga_config_t config;

    printf("Configuring Video...\n");
    config.base   = VGA_BASEADDR;
    config.dbuf   = Htrue;
    config.width  = VGA_WIDTH;
    config.height = VGA_HEIGHT;

    printf("Initializing Video...\n");
    vga_init(vga, &config);
}


// Get the value of the framebuffer at a given coordinate
pixel_t framebuffer_get(framebuffer_t * im, int xc, int yc) {
    int coord;

    coord = xc +(im->width*yc);
    return im->im_ptr[coord];
}


// Set the value of the framebuffer at a given coordinate
void framebuffer_set(framebuffer_t * im, int xc, int yc, pixel_t p) {
    int coord;

    coord = xc + (im->width*yc);
    im->im_ptr[coord] = p;
}


// Get the red value from a given pixel
int color_red(pixel_t p) {
    return p.r;
}


// Get the green value from a given pixel
int color_green(pixel_t p) {
    return p.g;
}


// Get the blue value from a given pixel
int color_blue(pixel_t p) {
    return p.b;
}


// Display the framebuffer
void vgaoutput_show_frame(vga_t *vga, framebuffer_t *frame) {
    Huint  *vfb;
    Huint  x;
    Huint  y;
    Huint  vx;
    Huint  vy;
    Hubyte r;
    Hubyte g;
    Hubyte b;
    pixel_t   fcol;
    vga_color col;

    // Get the address of the video frame buffer
    vfb = (Huint*)vga->base;

    // Display all pixels in the image
    for (y=0; y < frame->height; y++) {
        for (x=0; x < frame->width; x++) {
            fcol = framebuffer_get(frame, x, y);
            r = color_red(fcol);
            g = color_green(fcol);
            b = color_blue(fcol);

            col = vga_make(r,g,b);
            vx = x;
            vy = y;
            vfb[(vy+0)*1024 + (vx+0)] = col.value;
        }
    }

    // Show the video frame
    vga_flip(vga);
}

#endif

