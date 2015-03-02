//
// This is a test app to ensure the vga and platform work correctly.
// It displays different colors on the vga screen
// Author: Andres Baez
// Date: Fall 2010
//

#include <stdio.h>
#include <hthread.h>
#include <vga_lib.h>

#define DISPLAY_COLUMNS  640
#define DISPLAY_ROWS     480

 ////////////////////////
// FUNCTION DEFINITIONS //
 ////////////////////////

void draw_colors(framebuffer_t *dst, framebuffer_t *src, vga_t *vga);

void exit(int n) {
    printf("EXIT! (%d)\n",n);
    while(1);
}

 ////////
// MAIN //
 ////////

int main(void) {
    printf("Testing vga...\n");
    int i=0;

    // Declare vga type
    vga_t vga;
    // Declare pixel type
    pixel_t *image;
    // Declare image framebuffer
    framebuffer_t *dst_image;

    // Initialize the video device
    printf("Setting up TFT...\r\n");
    vgaoutput_init(&vga);

    // Allocate memory for the image to display
    printf("Allocating memory for the image...\n");
    image = (pixel_t *)malloc((DISPLAY_COLUMNS*DISPLAY_ROWS) * sizeof(pixel_t));
    if (image == NULL) {
        printf("ERROR - Unable to allocate memory for the image!\n");
        exit(1);
    }
    printf("    image=0x%08X\n", (unsigned int)image);

    // Allocating framebuffers
    printf("Allocating framebuffers...\n");
    dst_image = malloc(sizeof(framebuffer_t));

    // Initialize framebuffer parameters
    dst_image->width = DISPLAY_COLUMNS;
    dst_image->height = DISPLAY_ROWS;
    dst_image->im_ptr = (pixel_t *)image;

    printf("dst_image->width = %d\n", dst_image->width);
    printf("dst_image->height = %d\n", dst_image->height);
    printf("dst_image->im_ptr= 0x%08X\n", (unsigned int)dst_image->im_ptr);

    // Initialize the background color
    printf("Initializing background color to [20 100 150]...\n");
    for (i=0; i < DISPLAY_COLUMNS*DISPLAY_ROWS; i++) {
        pixel_t pix;

        pix.r = 20; 
        pix.g = 100;
        pix.b = 150;

        image[i] = pix;
    } 

    
    printf("Displaying the colors...\n");
    draw_colors(dst_image, dst_image, &vga);
    printf("-> You should now see a colored screen!\n");

    printf("-- DONE --\n");
    return 0;
}


 ///////////////////
// FUNCTION BODIES //
 ///////////////////


void draw_colors(framebuffer_t *dst, framebuffer_t *src, vga_t *vga) {
    if ((dst->width != src->width) || (dst->height != src->height)) {
        printf("Error, dimensions don't match!\n");
    }

    vgaoutput_show_frame(vga, src);

    return;
}

