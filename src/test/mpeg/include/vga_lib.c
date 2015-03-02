#include "vga_lib.h"
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

