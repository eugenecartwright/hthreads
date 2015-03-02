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

/** \file       boots.h
  * \brief      The header file for the FAT16 file system MBR implementation.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  * This file is the main header file for the FAT16 file system implementation.
  */
#ifndef _HYBRID_THREAD_FS_FAT16_BOOT_SECTOR_H_
#define _HYBRID_THREAD_FS_FAT16_BOOT_SECTOR_H_

#include <httype.h>
#include <block/block.h>

typedef struct
{
    Hubyte  jmp[3];                 // A jump instruction
    Hubyte  name[8];                // The OEM name
    Hushort bytes_per_sector;       // Number of bytes per sector
    Hubyte  sectors_per_cluster;    // Number of sectors per cluster
    Hushort reserved_sectors;       // Number of Reserved Sectors
    Hubyte  fats;                   // Number of File Allocation Tables
    Hushort max_root;               // Maximum number of root directory entries
    Hushort ssectors;               // Total number of sectors (if < 65535)
    Hubyte  media;                  // The type of media
    Hushort sectors_per_fat;        // Number of sectors per File Allocation Table
    Hushort sectors_per_track;      // Number of sectors per track
    Hushort heads;                  // Number of heads
    Huint   hidden;                 // Number of hidden sectors
    Huint   sectors;                // Total number of sectors (if > 65535)
    Hubyte  drive;                  // Physical drive number
    Hubyte  reserved;               // Reserved
    Hubyte  signature;              // Signature
    Huint   serial;                 // Serial Number
    Hubyte  label[11];              // Volume label
    Hubyte  type[8];                // File system type
    Hubyte  code[448];              // OS boot code
    Hushort marker;                 // End of sector marker
}  __attribute__((__packed__)) fat16_bts_t;

extern Hint fat16_boots_read( block_t*, fat16_bts_t*, Huint );
extern Hint fat16_boots_readconvert( fat16_bts_t* );

#endif
