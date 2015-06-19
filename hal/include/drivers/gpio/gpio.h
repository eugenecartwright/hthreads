/************************************************************************************
* Copyright (c) 2015, University of Arkansas - Hybridthreads Group
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
*     * Neither the name of the University of Arkansas nor the name of the
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

/** \file       gpio.h
  * \brief      Header file for the gpio driver.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  * This file is the header file for the Hthreads GPIO driver. This driver
  * is capable of communicating with any GPIO based device such as led lights,
  * push buttons, and dip switches.
  */
#ifndef _HYBRID_THREADS_DRIVER_GPIO_H_
#define _HYBRID_THREADS_DRIVER_GPIO_H_

#include <httype.h>
#include <htconst.h>

#define GPIO_CHANNEL1_DATA      0x00
#define GPIO_CHANNEL1_TRIS      0x04
#define GPIO_CHANNEL2_DATA      0x08
#define GPIO_CHANNEL2_TRIS      0x0C
#define GPIO_INTERRPT_GIER      0x11C
#define GPIO_INTERRPT_IER       0x128
#define GPIO_INTERRPT_ISR       0x120

#define GPIO_ENABLE_GIER        0xFFFFFFFF
#define GPIO_DISABLE_GIER       0x00000000

#define GPIO_CHANNEL1           0
#define GPIO_CHANNEL2           1

#define GPIO_ALL_OUTPUT         0x00000000
#define GPIO_ALL_INPUT          0xFFFFFFFF

#define GPIO_INTERRUPT_CHANNEL1 0x00000001
#define GPIO_INTERRUPT_CHANNEL2 0x00000002
#define GPIO_INTERRUPT_ALL      (GPIO_INTERRUPT_CHANNEL1 | GPIO_INTERRUPT_CHANNEL2)

typedef struct
{
    Huint   base;
    Huint   bits;
    Hbool   dual;
    Hbool   intr;
} gpio_config_t;

typedef struct
{
    Huint          bits;
    volatile Huint *data[2];
    volatile Huint *direction[2];
    volatile Huint *gier;
    volatile Huint *ier;
    volatile Huint *isr;
} gpio_t;

extern Hint  gpio_create( gpio_t*, gpio_config_t* );
extern Hint  gpio_destroy( gpio_t* );
extern void  gpio_setdirection( gpio_t*, Huint, Huint );
extern Huint gpio_getdirection( gpio_t*, Huint );
extern void  gpio_setdata( gpio_t*, Huint, Huint );
extern Huint gpio_getdata( gpio_t*, Huint );
extern void  gpio_globalenable( gpio_t* );
extern void  gpio_globaldisable( gpio_t* );
extern void  gpio_enable( gpio_t*, Huint );
extern void  gpio_disable( gpio_t*, Huint );
extern void  gpio_clear( gpio_t*, Huint );

#endif
