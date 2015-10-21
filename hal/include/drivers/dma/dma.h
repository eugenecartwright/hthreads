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
  * \author     Eugene Cartwright <eugene@uark.edu>\n
  *
  * This file is the header file for the Hthreads DMA driver. This driver
  * is a wrapper of the XCDMA driver provided by Xilinx. Currently, it assumes
  * simple mode transfers and has no support for the scatter-gather feature.
  */
#ifndef _HYBRID_THREADS_DRIVER_DMA_H_
#define _HYBRID_THREADS_DRIVER_DMA_H_

#include <httype.h>
#include <htconst.h>
#include <config.h>
#include "xaxicdma.h"

extern Hint  dma_create(XAxiCdma * dma, u16 DeviceId);
extern void  dma_reset(XAxiCdma * dma);
extern Hbool dma_getbusy(XAxiCdma *dma);
extern Hint dma_geterror(XAxiCdma *dma);
extern Hbool dma_getdone(XAxiCdma *dma);
extern Hint dma_transfer(XAxiCdma *dma, Huint SrcAddr, Huint DstAddr, Hint byte_Length);

#endif
