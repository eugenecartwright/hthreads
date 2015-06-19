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

/** \file       fat16.h
  * \brief      The header file for the FAT16 file system implementation.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  * This file is the main header file for the FAT16 file system implementation.
  */
#ifndef _HYBRID_THREAD_FS_FAT16_H_
#define _HYBRID_THREAD_FS_FAT16_H_

#include <httype.h>
#include <htconst.h>
#include <fs/fat16/mbr.h>
#include <fs/fat16/part.h>
#include <fs/fat16/boots.h>
#include <block/block.h>

// Debug settings for the fat16 code
#define FAT16_DEBUG     1

// Settings for the fat file system
#define FAT16_NAME_MAX  260

typedef struct
{
    block_t    *block;
    Huint       sectors;
    Huint       first_sector;
    Huint       last_sector;
    Huint       boot_sector;
    Huint       fat_size;
    Huint       fat_sector;
    Huint       root_sector;
    Huint       root_size;
    Huint       data_sector;
    Huint       data_size;
    Huint       cl_sectors;
    Huint       bt_sector;
} fat16_t;

// Start and stop the file system
extern Hint fat16_create( fat16_t*, fat16_prt_t*, block_t* );
extern Hint fat16_destroy( fat16_t* );

// Sector locations for various parts of the file system
extern Huint fat16_bootsector( fat16_t* );
extern Huint fat16_fatsector( fat16_t*, Hint );
extern Huint fat16_rootsector( fat16_t* );

// Entries for various clusters in the file system
extern Huint fat16_sector( fat16_t*, Huint );
extern Huint fat16_entry_sector( fat16_t*, Huint );
extern Huint fat16_entry_offset( fat16_t*, Huint );
extern Hint fat16_getentry( fat16_t*, Huint, Hushort* );
extern Hint fat16_setentry( fat16_t*, Huint, Hushort );

#endif
