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

/** \file       direntry.h
  * \brief      The header file for the FAT16 file system entry implementation.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  * This file is the main header file for the FAT16 file system implementation.
  */
#ifndef _HYBRID_THREAD_FS_FAT16_DIRENTRY_H_
#define _HYBRID_THREAD_FS_FAT16_DIRENTRY_H_

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
    Hubyte  name[11];
    Hubyte  attrs;
    Hubyte  reserved;
    Hubyte  create_mtime;
    Hushort create_time;
    Hushort create_date;
    Hushort access_date;
    Hushort cluster_hi;
    Hushort write_time;
    Hushort write_date;
    Hushort cluster_lo;
    Huint   size;
}  __attribute__((__packed__)) fat16_direntry_t;

// Utility functions for entries
extern Hint fat16_direntry_free( fat16_direntry_t* );

// Utility functions for entry name
extern char* fat16_direntry_name( fat16_direntry_t*, char*, Huint );

// Utility function for entry size
extern Huint fat16_direntry_size( fat16_direntry_t* );

// Utility functions for entry attributes
extern Hint fat16_direntry_readonly( fat16_direntry_t* );
extern Hint fat16_direntry_hidden( fat16_direntry_t* );
extern Hint fat16_direntry_system( fat16_direntry_t* );
extern Hint fat16_direntry_volumeid( fat16_direntry_t* );
extern Hint fat16_direntry_directory( fat16_direntry_t* );
extern Hint fat16_direntry_archive( fat16_direntry_t* );
extern Hint fat16_direntry_longname( fat16_direntry_t* );

// Utility functions for date/time information
extern Huint fat16_direntry_createmtime( fat16_direntry_t* );
extern Huint fat16_direntry_createtime( fat16_direntry_t* );
extern Huint fat16_direntry_createdate( fat16_direntry_t* );
extern Huint fat16_direntry_writetime( fat16_direntry_t* );
extern Huint fat16_direntry_writedate( fat16_direntry_t* );
extern Huint fat16_direntry_accessdate( fat16_direntry_t* );

// Utility functions for cluster access
extern Huint fat16_direntry_cluster( fat16_direntry_t* );

#endif
