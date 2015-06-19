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

/** \file       cf.h
  * \brief      Header file for the sysace driver.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  * This file is the header file for the Hthreads sysace compact flash driver. This
  * driver is capable of communicating with any SysAce based compact flash device.
  */
#ifndef _HYBRID_THREADS_DRIVER_SYSACE_CF_H_
#define _HYBRID_THREADS_DRIVER_SYSACE_CF_H_

#include <sysace/sysace.h>

#define swapbytes(b,n)                  \
({                                      \
    Hint   _i;                          \
    Hubyte _b;                          \
                                        \
    for( _i = 0; _i < n; _i += 2 )      \
    {                                   \
        _b      = b[_i];                \
        b[_i]   = b[_i+1];              \
        b[_i+1] = _b;                   \
    }                                   \
})

typedef struct
{
    Hushort sig;
    Hushort default_cylinders;
    Hushort reserved1;
    Hushort default_heads;
    Hushort bytes_per_track;
    Hushort bytes_per_sector;
    Hushort default_sectors_per_track;
    Huint   default_sectors_per_card;
    Hushort vendor;
    Hubyte  serial[20];
    Hushort buffer_type;
    //Hushort buffer_size;
    Hushort ecc_bytes;
    Hubyte  version[8];
    Hubyte  model[40];
    Hushort max_sectors;
    Hushort dword;
    Hushort capabilities;
    Hushort reserved2;
    Hushort pio_mode;
    Hushort dma_mode;
    Hushort translation;
    Hushort cylinders;
    Hushort heads;
    Hushort sectors_per_track;
    Huint   sectors_per_card;
    Hushort multiple_sectors;
    Huint   lba_sectors;
    Hubyte  reserved3[132];
    Hushort security;
    Hubyte  vendor_bytes[62];
    Hushort power;
    Hubyte  reserved4[190];
} sysace_cfinfo_t;

extern Hint sysace_cf_reset( sysace_t* );
extern Hint sysace_cf_abort( sysace_t* );
extern Hint sysace_cf_identify( sysace_t*, sysace_cfinfo_t* );
extern Hint sysace_cf_ready( sysace_t* );
extern Hint sysace_cf_isready( sysace_t* );
extern Hint sysace_cf_readsector( sysace_t*, Huint, Huint, Hubyte* );
extern Hint sysace_cf_writesector( sysace_t*, Huint, Huint, Hubyte* );
extern Huint sysace_cf_fatstatus( sysace_t* );

#endif
