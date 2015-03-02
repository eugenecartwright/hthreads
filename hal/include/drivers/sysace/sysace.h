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

/** \file       sysace.h
  * \brief      Header file for the sysace driver.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  * This file is the header file for the Hthreads sysace driver. This driver
  * is capable of communicating with any SysAce based device.
  */
#ifndef _HYBRID_THREADS_DRIVER_SYSACE_H_
#define _HYBRID_THREADS_DRIVER_SYSACE_H_

#include <httype.h>
#include <htconst.h>
#include <sysace/regs.h>

// SysACE Driver debug information
#define SYSACE_DEBUG            1

// SysAce register offsets
#define SYSACE_BUS_MODE         0x00
#define SYSACE_STATUS           0x04
#define SYSACE_ERROR            0x08
#define SYSACE_CONFIG_LBA       0x0C
#define SYSACE_MPU_LBA          0x10
#define SYSACE_SECTOR           0x14
#define SYSACE_VERSION          0x16
#define SYSACE_CONTROL          0x18
#define SYSACE_FAT_STATUS       0x1C
#define SYSACE_DATA             0x40

// Bus mode register masks
#define SYSACE_BUSMODE_8BIT     0x0000
#define SYSACE_BUSMODE_16BIT    0x0101

// Status register masks
#define SYSACE_STATUS_CLOCK     0x00000001
#define SYSACE_STATUS_MLOCK     0x00000002
#define SYSACE_STATUS_CERROR    0x00000004
#define SYSACE_STATUS_CFERROR   0x00000008
#define SYSACE_STATUS_CFDETECT  0x00000010
#define SYSACE_STATUS_DREADY    0x00000020
#define SYSACE_STATUS_DMODE     0x00000040
#define SYSACE_STATUS_CDONE     0x00000080
#define SYSACE_STATUS_CREADY    0x00000100
#define SYSACE_STATUS_CMODE     0x00000200
#define SYSACE_STATUS_CADDR     0x0000E000
#define SYSACE_STATUS_CFBUSY    0x00020000
#define SYSACE_STATUS_CFREADY   0x00040000
#define SYSACE_STATUS_CFFAULT   0x00080000
#define SYSACE_STATUS_CFDSC     0x00100000
#define SYSACE_STATUS_CFREQUEST 0x00200000
#define SYSACE_STATUS_CFCORR    0x00400000
#define SYSACE_STATUS_CFERR     0x00800000

// Error register masks
#define SYSACE_ERROR_CFRESET    0x00000001
#define SYSACE_ERROR_CFREADY    0x00000002
#define SYSACE_ERROR_CFREAD     0x00000004
#define SYSACE_ERROR_CFWRITE    0x00000008
#define SYSACE_ERROR_CFSECTOR   0x00000010
#define SYSACE_ERROR_CADDR      0x00000020
#define SYSACE_ERROR_CFAIL      0x00000040
#define SYSACE_ERROR_CREAD      0x00000080
#define SYSACE_ERROR_CINSTR     0x00000100
#define SYSACE_ERROR_CINIT      0x00000200
#define SYSACE_ERROR_RESERVED   0x00000400
#define SYSACE_ERROR_BLOCK      0x00000800
#define SYSACE_ERROR_UNCORR     0x00001000
#define SYSACE_ERROR_SECTOR     0x00002000
#define SYSACE_ERROR_ABORT      0x00004000
#define SYSACE_ERROR_GENERAL    0x00008000

// LBA address mask
#define SYSACE_LBA_MASK         0x0FFFFFFF

// Sector count values
#define SYSACE_SECTOR_COUNT     0x00FF
#define SYSACE_SECTOR_RESET     0x0100
#define SYSACE_SECTOR_IDENTIFY  0x0200
#define SYSACE_SECTOR_READ      0x0300
#define SYSACE_SECTOR_WRITE     0x0400
#define SYSACE_SECTOR_ABORT     0x0600
#define SYSACE_SECTOR_CMD       0x0700

// Version register masks
#define SYSACE_VERSION_BUILD    0x00FF
#define SYSACE_VERSION_MINOR    0x0F00
#define SYSACE_VERSION_MAJOR    0xF000

// Control register values
#define SYSACE_CONTROL_FLOCK    0x00000001
#define SYSACE_CONTROL_RLOCK    0x00000002
#define SYSACE_CONTROL_FADDR    0x00000004
#define SYSACE_CONTROL_FMODE    0x00000008
#define SYSACE_CONTROL_MODE     0x00000010
#define SYSACE_CONTROL_START    0x00000020
#define SYSACE_CONTROL_SELECT   0x00000040
#define SYSACE_CONTROL_RESET    0x00000080
#define SYSACE_CONTROL_READYI   0x00000100
#define SYSACE_CONTROL_ERRORI   0x00000200
#define SYSACE_CONTROL_DONEI    0x00000400
#define SYSACE_CONTROL_RESETI   0x00000800
#define SYSACE_CONTROL_IMASK    0x00000700
#define SYSACE_CONTROL_PROG     0x00001000
#define SYSACE_CONTROL_ADDR     0x0000E000
#define SYSACE_CONTROL_ASHIFT   13

// FAT status masks
#define SYSACE_FAT_BOOT         0x0001
#define SYSACE_FAT_PART         0x0002
#define SYSACE_FAT_BOOT12       0x0004
#define SYSACE_FAT_PART12       0x0008
#define SYSACE_FAT_BOOT16       0x0010
#define SYSACE_FAT_PART16       0x0020
#define SYSACE_FAT_CALC12       0x0040
#define SYSACE_FAT_CALC16       0x0080

// Data buffer register values
#define SYSACE_DATA_BUFFER      32
#define SYSACE_DATA_SECTOR      512

typedef struct
{
    Huint   base;
} sysace_config_t;

typedef struct
{
    volatile Hushort *mode[2];
    volatile Hushort *control[2];
    volatile Hushort *error[2];
    volatile Hushort *status[2];
    volatile Hushort *version[1];
    volatile Hushort *count[1];
    volatile Hushort *fat[1];
    volatile Hushort *data[1];
    volatile Hushort *clba[2];
    volatile Hushort *mlba[2];
} sysace_t;

extern Hint sysace_create( sysace_t*, sysace_config_t* );
extern Hint sysace_destroy( sysace_t* );
extern Hushort sysace_version( sysace_t* );
extern Hint sysace_busmode( sysace_t*, Hushort );

extern Hint sysace_lock( sysace_t* );
extern Hint sysace_unlock( sysace_t* );

extern Hint sysace_enable( sysace_t*, Huint );
extern Hint sysace_disable( sysace_t*, Huint );

extern Huint sysace_flushbuffer( sysace_t* );
extern Huint sysace_readbuffer( sysace_t*, Hubyte*, Huint );
extern Huint sysace_writebuffer( sysace_t*, Hubyte*, Huint );

#endif
