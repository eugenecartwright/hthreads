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

/** \file       part.h
  * \brief      The header file for the FAT16 file system partition implementation.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  * This file is the main header file for the FAT16 file system implementation.
  */
#ifndef _HYBRID_THREAD_FS_FAT16_PART_H_
#define _HYBRID_THREAD_FS_FAT16_PART_H_

#include <httype.h>

// Partition states
#define FAT16_PART_STATE_INACTIVE       0x00
#define FAT16_PART_STATE_ACTIVE         0x80

// Partition types
#define FAT16_PART_TYPE_UNKNOWN         0x00
#define FAT16_PART_TYPE_FAT12           0x01
#define FAT16_PART_TYPE_FAT16_SMALL     0x04
#define FAT16_PART_TYPE_EXTENDED        0x05
#define FAT16_PART_TYPE_FAT16           0x06
#define FAT16_PART_TYPE_FAT32           0x0B
#define FAT16_PART_TYPE_FAT32_LBA       0x0C
#define FAT16_PART_TYPE_FAT16_LBA       0x0E
#define FAT16_PART_TYPE_EXTENDED_LBA    0x0F

typedef struct
{
    Hubyte  state;
    Hubyte  start_head;
    Hushort start_sector;
    Hubyte  type;
    Hubyte  end_head;
    Hushort end_sector;
    Huint   offset;
    Huint   size;
}  __attribute__((__packed__)) fat16_prt_t;

extern Hint fat16_part_readconvert( fat16_prt_t* );
extern const char* fat16_part_typestr( Hubyte );

#endif
