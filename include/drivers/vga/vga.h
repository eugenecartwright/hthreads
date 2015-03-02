/************************************************************************************
* Copyright (c) 2006, University of Kansas - Hybridthreads Group
* All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
* 
*     * Redistributions of source code must retain the above copyright notice,
*       this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright notice,
*       this list of conditions and the following disclaimer in the documentation
*       and/or other materials provided with the distribution.
*     * Neither the name of the University of Kansas nor the name of the
*       Hybridthreads Group nor the names of its contributors may be used to
*       endorse or promote products derived from this software without specific
*       prior written permission.
* 
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
* ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
************************************************************************************/

/** \file       vga.h
  * \brief      Header file for the VGA driver.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  * This file is the header file for the Hthreads VGA driver. This driver
  * is capable of communicating with any Xilinx XUP VGA compatible device.
  */
#ifndef _HYBRID_THREADS_DRIVER_VGA_H_
#define _HYBRID_THREADS_DRIVER_VGA_H_

#include <hthread.h>
#include <xtft_l.h>

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
