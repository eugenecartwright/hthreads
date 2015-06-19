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

/** \file       dma.h
  * \brief      Header file for the dma driver.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  * This file is the header file for the Hthreads DMA driver. This driver
  * is capable of communicating with any Central DMA based device.
  */
#ifndef _HYBRID_THREADS_DRIVER_DMA_H_
#define _HYBRID_THREADS_DRIVER_DMA_H_

#include <httype.h>
#include <htconst.h>

#define DMA_RESET               0x00
#define DMA_CONTROL             0x04
#define DMA_SOURCE              0x08
#define DMA_DESTINATION         0x0C
#define DMA_LENGTH              0x10
#define DMA_STATUS              0x14
#define DMA_INTERRUPT_STATUS    0x2C
#define DMA_INTERRUPT_ENABLE    0x30

#define DMA_RESET_DATA          0x0000000A
#define DMA_SIZE_BYTE           0x00000001
#define DMA_SIZE_HALFWORD       0x00000002
#define DMA_SIZE_WORD           0x00000004
#define DMA_SOURCE_INC          0x80000000
#define DMA_DESTINATION_INC     0x40000000

#define DMA_STATUS_BUSY         0x80000000
#define DMA_STATUS_ERROR        0x40000000
#define DMA_STATUS_TIMEOUT      0x20000000
#define DMA_ISR_DONE            0x00000001
#define DMA_ISR_ERROR           0x00000002
#define DMA_IER_DONE            0x00000001
#define DMA_IER_ERROR           0x00000002

typedef struct
{
    Huint   base;
} dma_config_t;

typedef struct
{
    Huint          intr;
    volatile Huint *reset;
    volatile Huint *control;
    volatile Huint *source;
    volatile Huint *destination;
    volatile Huint *length;
    volatile Huint *status;
    volatile Huint *isr;
    volatile Huint *ier;
} dma_t;

extern Hint  dma_create( dma_t*, dma_config_t* );
extern Hint  dma_destroy( dma_t* );
extern void  dma_reset( dma_t* );
extern Huint dma_getid( dma_t* );
extern Hbool dma_getbusy( dma_t* );
extern Hbool dma_geterror( dma_t* );
extern Hbool dma_gettimeout( dma_t* );
extern Hbool dma_getdone( dma_t* );
extern Hbool dma_getfailed( dma_t* );
extern void  dma_enabledone( dma_t* );
extern void  dma_disabledone( dma_t* );
extern void  dma_cleardone( dma_t* );
extern void  dma_enablefailed( dma_t* );
extern void  dma_disablefailed( dma_t* );
extern void  dma_clearfailed( dma_t* );
extern Hint  dma_transfer( dma_t*, void*, void*, Huint, Huint, Hbool, Hbool );
extern void* dma_malloc( Huint );
extern void dma_free( void* );

#endif
