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

/** \file       dirs.h
  * \brief      The header file for the FAT16 file system implementation.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  * This file is the main header file for the FAT16 file system implementation.
  */
#ifndef _HYBRID_THREAD_FS_FAT16_DIRS_H_
#define _HYBRID_THREAD_FS_FAT16_DIRS_H_

#include <fs/fat16/fat16.h>
#include <fs/fat16/direntry.h>
#include <fs/fat16/longname.h>

typedef struct
{
    Huint   block;
    Huint   size;
} fat16_dir_t;

typedef struct
{
    fat16_dir_t     *parent;
    char            name[ FAT16_NAME_MAX + 1 ];
    int             entryno;
    Huint           attrs;
    Huint           size;
    Huint           cluster;
} fat16_dir_entry_t;

// Get the root directory of the file system
extern Hint fat16_dir_root( fat16_t*, fat16_dir_t* );

// Directory listing operations
extern Hint fat16_dir_first( fat16_t*, fat16_dir_t*, fat16_dir_entry_t* );
extern Hint fat16_dir_next( fat16_t*, fat16_dir_entry_t*, fat16_dir_entry_t* );

#endif
