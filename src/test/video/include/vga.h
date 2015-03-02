#ifndef _VIDEO_VGA_H_
#define _VIDEO_VGA_H_

#include <hthread.h>

typedef struct
{
    Huint base;
    Hbool dbuf;
    Huint width;
    Huint height;
} vga_config_t;

typedef struct
{
    volatile Huint  *addr;
    volatile Huint  *enable;
    Huint           width;
    Huint           height;
    Hubyte          *memory;
    Huint           *base;
    Huint           *dbase;
} vga_t;

typedef union
{
    Huint   value;
    Hubyte  value8[4];
    struct  { Hubyte a, r, g, b; };
} vga_color;

#define vga_make(_r,_g,_b) ({   \
    vga_color col;              \
    col.b = _b;                 \
    col.g = _g;                 \
    col.r = _r;                 \
    col;                        \
})

extern Hint vga_init( vga_t*, vga_config_t* );
extern Hint vga_destroy( vga_t* );

extern void vga_enable( vga_t* );
extern void vga_disable( vga_t* );
extern void vga_flip( vga_t* );

extern void vga_clear( vga_t* );
extern void vga_clearto( vga_t*, vga_color );

extern void vga_copy( vga_t*, void* );
extern void vga_framecopy( vga_t*, void*, Huint, Huint, Huint );
extern void vga_fill( vga_t*, Huint, Huint, Huint, Huint, vga_color );

#endif
