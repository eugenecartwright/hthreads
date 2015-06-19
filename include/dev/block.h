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

/** \file       block.h
  * \brief      Header file for block devices.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  */
#ifndef _HYBRID_THREADS_BLKDEV_H_
#define _HYBRID_THREADS_BLKDEV_H_

#include <httype.h>
#include <htconst.h>

typedef struct _bdev_info_t
{
    char    *name;
    void    *data;
    Hint    (*destroy)(struct _bdev_info_t*);
    Hint    (*open)(struct _bdev_info_t*, const char*, int, int);
    Hint    (*close)(struct _bdev_info_t* );
    Hint    (*stat)(struct _bdev_info_t* );
    Hint    (*isatty)(struct _bdev_info_t* );
    Hint    (*link)(struct _bdev_info_t* );
    Hint    (*unlink)(struct _bdev_info_t* );
    Hint    (*lseek)(struct _bdev_info_t*, int, int);
    Hint    (*read)(struct _bdev_info_t*, char*, int);
    Hint    (*write)(struct _bdev_info_t*, char*, int);
} bdev_info_t;

typedef struct _bdevnode_t
{
    struct _bdevnode_t  *next;
    struct _bdevnode_t  *prev;
    bdev_info_t         *info;
} bdev_node_t;

typedef struct
{
    bdev_node_t *head;
    bdev_node_t *tail;
    Huint       devices;
} bdev_t;

extern Hint bdev_create( bdev_t* );
extern Hint bdev_destroy( bdev_t* );

extern Hint bdev_insert( bdev_t*, bdev_info_t* );
extern Hint bdev_remove( bdev_t*, bdev_info_t* );

extern bdev_info_t* bdev_find( bdev_t*, const char* );

#endif
