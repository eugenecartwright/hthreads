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

/** \file       longname.h
  * \brief      The header file for the FAT16 file system entry implementation.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  * This file is the main header file for the FAT16 file system implementation.
  */
#ifndef _HYBRID_THREAD_FS_FAT16_LONGNAME_H_
#define _HYBRID_THREAD_FS_FAT16_LONGNAME_H_

#include <block/block.h>

// Entry attributes
#define FAT16_DIRENTRY_READONLY     0x01
#define FAT16_DIRENTRY_HIDDEN       0x02
#define FAT16_DIRENTRY_SYSTEM       0x04
#define FAT16_DIRENTRY_VOLUMEID     0x08
#define FAT16_DIRENTRY_DIRECTORY    0x10
#define FAT16_DIRENTRY_ARCHIVE      0x20
#define FAT16_DIRENTRY_LONGNAME     0x0F

typedef struct
{
    Hubyte  order;
    Hushort name1[5];
    Hubyte  attr;
    Hubyte  type;
    Hubyte  chksum;
    Hushort name2[6];
    Hushort reserved;
    Hushort name3[2];
}  __attribute__((__packed__)) fat16_longname_t;

// Utility functions for entries
extern Hint fat16_longname_read( fat16_t*, char*, Huint );

#endif
