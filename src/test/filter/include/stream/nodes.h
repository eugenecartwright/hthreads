#ifndef _IMAGE_STREAM_NODES_H_
#define _IMAGE_STREAM_NODES_H_

// Declare all of the possible input functions
extern void* nullinput_thread( void *arg );
extern void* sdlinput_thread( void *arg );
extern void* drawinput_thread( void *arg );
extern void* tgainput_thread( void *arg );
extern void* imginput_thread( void *arg );
extern void* vdecinput_thread( void *arg );

// Declare all of the possible output functions
extern void* nulloutput_thread( void *arg );
extern void* sdloutput_thread( void *arg );
extern void* ppmoutput_thread( void *arg );
extern void* tgaoutput_thread( void *arg );
extern void* vgaoutput_thread( void *arg );

// Declare all of the possible filtering functions
extern void* sharpen_thread( void *arg );
extern void* emboss_thread( void *arg );
extern void* sobel_thread( void *arg );
extern void* median_thread( void *arg );
extern void* reduce_thread( void *arg );
extern void* expand_thread( void *arg );
extern void* blur_thread( void *arg );
extern void* histogram_thread( void *arg );
extern void* histogram_eq_thread( void *arg );
extern void* intensity_waveform_thread( void *arg );
extern void* uv_mapping_thread( void *arg );
extern void* hough_thread( void *arg );
extern void* dct_thread( void *arg );
extern void* idct_thread( void *arg );
extern void* invert_thread( void *arg );
extern void* rotate_thread( void *arg );
extern void* laplace3_thread( void *arg );
extern void* laplace5_thread( void *arg );
extern void* gray_thread( void *arg );
extern void* pixelate_thread( void *arg );
extern void* contrast_thread( void *arg );
extern void* thresh_thread( void *arg );

// Declare all of the possible filtering nodes
#define null_node       {NULL, NULL}
#define nullinput_node  {"null input",  nullinput_thread}
#define nulloutput_node {"null output", nulloutput_thread}
#define vdecinput_node  {"video decoder input",  vdecinput_thread}
#define drawinput_node  {"draw input",  drawinput_thread}
#define imginput_node   {"image input", imginput_thread}
#define sdloutput_node  {"SDL output",  sdloutput_thread}
#define ppmoutput_node  {"PPM output",  ppmoutput_thread}
#define tgainput_node   {"TGA input",   tgainput_thread}
#define sdlinput_node   {"SDL input",   sdlinput_thread}
#define tgaoutput_node  {"TGA output",  tgaoutput_thread}
#define vgaoutput_node  {"VGA output",  vgaoutput_thread}
#define sharpen_node    {"sharpen",     sharpen_thread}
#define emboss_node     {"emboss",      emboss_thread}
#define sobel_node      {"sobel",       sobel_thread}
#define reduce_node     {"reduce",      reduce_thread}
#define expand_node     {"expand",      expand_thread}
#define blur_node       {"blur",        blur_thread}
#define histogram_node  {"histogram",   histogram_thread}
#define histogram_eq_node  {"histogram_eq",   histogram_eq_thread}
#define intensity_waveform_node  {"intensity_waveform",   intensity_waveform_thread}
#define uv_mapping_node {"uv mapping",  uv_mapping_thread}
#define hough_node      {"hough",       hough_thread}
#define invert_node     {"invert",      invert_thread}
#define dct_node        {"dct",         dct_thread}
#define idct_node       {"idct",        idct_thread}
#define rotate_node     {"rotate",      rotate_thread}
#define laplace3_node   {"3x3 laplace", laplace3_thread}
#define laplace5_node   {"5x5 laplace", laplace5_thread}
#define median_node     {"median",      median_thread}
#define contrast_node   {"contrast",    contrast_thread}
#define thresh_node     {"threshold",   thresh_thread}
#define gray_node       {"gray",        gray_thread}
#define pixelate_node   {"pixelate",    pixelate_thread}

#endif
