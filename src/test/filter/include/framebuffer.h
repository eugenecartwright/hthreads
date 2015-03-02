#ifndef _GRAPHICS_FRAMEBUFFER_H_
#define _GRAPHICS_FRAMEBUFFER_H_

#include <itypes.h>
#include <stdio.h>

#define fbmax(x,y)      ((x) > (y) ? (x) : (y))
#define fbmin(x,y)      ((x) < (y) ? (x) : (y))
#define fbrng(v,m,x)    ((v) < (m) ? (m) : (v) > (x) ? (x) : (v))

#ifdef COLOR_RGB
#   include <colors/rgb.h>
#   include <formats/rgb.h>
#   define framebuffer_t                framebuffer_rgb_t
#   define color_t                      color_rgb_t

#   define framebuffer_create(i,w,h)    rgb_create(i,w,h)
#   define framebuffer_clone(d,s)       rgb_clone(d,s)
#   define framebuffer_copy(d,s)        rgb_copy(d,s)
#   define framebuffer_destroy(i)       rgb_destroy(i);
#   define framebuffer_get(i,x,y)       rgb_get(i,x,y)
#   define framebuffer_set(i,x,y,v)     rgb_set(i,x,y,v)
#   define framebuffer_pixel(i,x)       rgb_pixel(i,x)
#   define framebuffer_place(i,x,c)     rgb_place(i,x,c)

#   define color_red(c)                 rgb_red(c)
#   define color_green(c)               rgb_green(c)
#   define color_blue(c)                rgb_blue(c)
#   define color_alpha(c)               rgb_alpha(c)
#   define color_make(r,g,b,a)          rgb_make(r,g,b,a)
#   define color_equal(c1,c2)           rgb_equal(c1,c2)

#   define color_add(c1,c2)             rgb_add(c1,c2)
#   define color_sub(c1,c2)             rgb_sub(c1,c2)
#   define color_mul(c1,c2)             rgb_mul(c1,c2)
#   define color_div(c1,c2)             rgb_div(c1,c2)
#   define color_blend(c1,c2)           rgb_blend(c1,c2)
#   define color_cmp(c1,c2)             rgb_cmp(c1,c2)
#elif COLOR_RGBA
#   include <colors/rgba.h>
#   include <formats/rgba.h>
#   define framebuffer_t                framebuffer_rgba_t
#   define color_t                      color_rgba_t

#   define framebuffer_create(i,w,h)    rgba_create(i,w,h)
#   define framebuffer_clone(d,s)       rgba_clone(d,s)
#   define framebuffer_copy(d,s)        rgba_copy(d,s)
#   define framebuffer_destroy(i)       rgba_destroy(i);
#   define framebuffer_get(i,x,y)       rgba_get(i,x,y)
#   define framebuffer_set(i,x,y,v)     rgba_set(i,x,y,v)
#   define framebuffer_pixel(i,x)       rgba_pixel(i,x)
#   define framebuffer_place(i,x,c)     rgba_place(i,x,c)

#   define color_red(c)                 rgba_red(c)
#   define color_green(c)               rgba_green(c)
#   define color_blue(c)                rgba_blue(c)
#   define color_alpha(c)               rgba_alpha(c)
#   define color_make(r,g,b,a)          rgba_make(r,g,b,a)
#   define color_equal(c1,c2)           rgba_equal(c1,c2)

#   define color_add(c1,c2)             rgba_add(c1,c2)
#   define color_sub(c1,c2)             rgba_sub(c1,c2)
#   define color_mul(c1,c2)             rgba_mul(c1,c2)
#   define color_div(c1,c2)             rgba_div(c1,c2)
#   define color_blend(c1,c2)           rgba_blend(c1,c2)
#   define color_cmp(c1,c2)             rgba_cmp(c1,c2)
#else
#   include <colors/gray.h>
#   include <formats/gray.h>
#   define framebuffer_t                framebuffer_gray_t
#   define color_t                      color_gray_t

#   define framebuffer_create(i,w,h)    gray_create(i,w,h)
#   define framebuffer_clone(d,s)       gray_clone(d,s)
#   define framebuffer_copy(d,s)        gray_copy(d,s)
#   define framebuffer_destroy(i)       gray_destroy(i);
#   define framebuffer_get(i,x,y)       gray_get(i,x,y)
#   define framebuffer_set(i,x,y,v)     gray_set(i,x,y,v)
#   define framebuffer_pixel(i,x)       gray_pixel(i,x)
#   define framebuffer_place(i,x,c)     gray_place(i,x,c)

#   define color_red(c)                 gray_red(c)
#   define color_green(c)               gray_green(c)
#   define color_blue(c)                gray_blue(c)
#   define color_alpha(c)               gray_alpha(c)
#   define color_make(r,g,b,a)          gray_make(r,g,b,a)
#   define color_equal(c1,c2)           gray_equal(c1,c2)

#   define color_add(c1,c2)             gray_add(c1,c2)
#   define color_sub(c1,c2)             gray_sub(c1,c2)
#   define color_mul(c1,c2)             gray_mul(c1,c2)
#   define color_div(c1,c2)             gray_div(c1,c2)
#   define color_blend(c1,c2)           gray_blend(c1,c2)
#   define color_cmp(c1,c2)             gray_cmp(c1,c2)
#endif

#define framebuffer_file_t              FILE*
#define framebuffer_fopen(f,m)          fopen(f,m)
#define framebuffer_fclose(f)           fclose(f)
#define framebuffer_fputc(c,f)          fputc(c,f)
#define framebuffer_fwrite(b,s,n,f)     fwrite(b,s,n,f)
#define framebuffer_fread(b,s,n,f)      fread(b,s,n,f)
#define framebuffer_fprintf(f,s,...)    fprintf(f,s,##__VA_ARGS__)
#define framebuffer_fscanf(f,s,...)     fscanf(f,s,##__VA_ARGS__)
#define framebuffer_fseek(f,o,w)        fseek(f,o,w)

#include <input.h>
#include <output.h>
#include <draw.h>
#include <filter.h>

#endif
