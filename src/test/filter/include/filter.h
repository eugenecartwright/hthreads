#ifndef _GRAPHICS_FILTER_H_
#define _GRAPHICS_FILTER_H_

#include <kernel.h>
#include <framebuffer.h>

extern int32 framebuffer_gray(framebuffer_t*);
extern int32 framebuffer_pixelate(framebuffer_t*,int32,int32);

extern int32 framebuffer_laplace3(framebuffer_t*,framebuffer_t*);
extern int32 framebuffer_histogram(framebuffer_t*,framebuffer_t*);
extern int32 framebuffer_histogram_eq(framebuffer_t*,framebuffer_t*);
extern int32 framebuffer_intensity_waveform(framebuffer_t*,framebuffer_t*);
extern int32 framebuffer_uv_mapping(framebuffer_t*,framebuffer_t*);
extern int32 framebuffer_hough(framebuffer_t*,framebuffer_t*,int32);
extern int32 framebuffer_invert(framebuffer_t*,framebuffer_t*);
extern int32 framebuffer_rotate(framebuffer_t*,framebuffer_t*);
extern int32 framebuffer_dct(framebuffer_t*,framebuffer_t*);
extern int32 framebuffer_idct(framebuffer_t*,framebuffer_t*);
extern int32 framebuffer_laplace5(framebuffer_t*,framebuffer_t*);
extern int32 framebuffer_sobel(framebuffer_t*,framebuffer_t*);
extern int32 framebuffer_median(framebuffer_t*,framebuffer_t*,int32);
extern int32 framebuffer_contrast(framebuffer_t*,framebuffer_t*);
extern int32 framebuffer_thresh(framebuffer_t*,framebuffer_t*,int32);

extern int32 framebuffer_blur(framebuffer_t*,framebuffer_t*,int32);
extern int32 framebuffer_kernel(framebuffer_t*,framebuffer_t*,kernel_t*);

extern int32 framebuffer_add( framebuffer_t*, framebuffer_t*, framebuffer_t* );
extern int32 framebuffer_sub( framebuffer_t*, framebuffer_t*, framebuffer_t* );
extern int32 framebuffer_mul( framebuffer_t*, framebuffer_t*, framebuffer_t* );
extern int32 framebuffer_div( framebuffer_t*, framebuffer_t*, framebuffer_t* );
extern int32 framebuffer_blend( framebuffer_t*, framebuffer_t*, framebuffer_t* );

extern int32 framebuffer_linear(framebuffer_t*,framebuffer_t*);
extern int32 framebuffer_bilinear(framebuffer_t*,framebuffer_t*);
extern int32 framebuffer_cubic(framebuffer_t*,framebuffer_t*);

#endif
