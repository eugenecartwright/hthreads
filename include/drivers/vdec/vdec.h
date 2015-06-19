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

/** \file       vdec.h
  * \brief      Header file for the VDEC driver.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  * This file is the header file for the Hthreads VDEC driver. This driver
  * is capable of communicating with the Video Decoder addon module for the
  * XUP development platform.
  */
#ifndef _HYBRID_THREADS_DRIVER_VDEC_H_
#define _HYBRID_THREADS_DRIVER_VDEC_H_

#include <httype.h>
#include <htconst.h>

#define IIC_GIE     0x01C
#define IIC_ISR     0x020
#define IIC_IER     0x028
#define IIC_RST     0x040
#define IIC_CR      0x100
#define IIC_SR      0x104
#define IIC_TX      0x108
#define IIC_RX      0x10C
#define IIC_ADDR    0x110
#define IIC_TXS     0x114
#define IIC_RXS     0x118
#define IIC_TEN     0x11C
#define IIC_DEPTH   0x120
#define IIC_GPO     0x124

#define IIC_CR_GCEN     0x40
#define IIC_CR_RSTA     0x20
#define IIC_CR_TXAK     0x10
#define IIC_CR_RX       0x08
#define IIC_CR_MSMS     0x04
#define IIC_CR_TXFIFO   0x02
#define IIC_CR_EN       0x01

#define IIC_SR_TXEMPTY  0x80
#define IIC_SR_RXEMPTY  0x40
#define IIC_SR_RXFULL   0x20
#define IIC_SR_TXFULL   0x10
#define IIC_SR_SRW      0x08
#define IIC_SR_BB       0x04
#define IIC_SR_AAS      0x02
#define IIC_SR_ABGC     0x01

typedef struct
{
    Hubyte  addr;
    Hubyte  val;
} vdec_data_t;

typedef struct
{
    Huint           size;
    vdec_data_t     data[];
} vdec_program_t;

typedef struct
{
    Huint   base;
    Huint   ready;
    Huint   data[2];
} vdec_config_t;

typedef struct
{
    volatile Huint   base;
    volatile Huint   *ready;
    volatile Huint   *control;
    volatile Huint   *data[2];
} vdec_t;

extern Hint vdec_create( vdec_t*, vdec_config_t* );
extern Hint vdec_destroy( vdec_t* );

extern Hint vdec_program( vdec_t*, const vdec_program_t* );
extern Hint vdec_select_composite( vdec_t* );
extern Hint vdec_select_svideo( vdec_t* );
extern Hint vdec_select_component( vdec_t* );

#endif
