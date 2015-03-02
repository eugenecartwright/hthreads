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

/** \file       block.h
  * \brief      Header file for the sysace block device interface.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  * This file is the header file for the Hthreads sysace block device interface.
  */
#ifndef _HYBRID_THREADS_DRIVER_SYSACE_BLOCK_H_
#define _HYBRID_THREADS_DRIVER_SYSACE_BLOCK_H_

#include <sysace/sysace.h>
#include <block/block.h>

typedef struct
{
    Huint   lru;
    Huint   sector;
    Huint   dirty;
    Huint   second;
    Huint   cold;
} sysace_block_cache_t;

typedef struct
{
    sysace_t               ace;
    Huint                  hit;
    Huint                  miss;

    Huint                  lines;
    Huint                  depth;
    sysace_block_cache_t   *info;
    Hubyte                 *cache;
} sysace_block_t;

extern Hint sysace_block_create( block_t*, sysace_config_t*, Huint, Huint );
extern Hint sysace_block_destroy( block_t* );
extern Hint sysace_block_read( block_t*, Huint, Huint, Hubyte* );
extern Hint sysace_block_write( block_t*, Huint, Huint, Hubyte* );

extern Hint sysace_block_cachefind( sysace_block_t*, Huint );
extern Hint sysace_block_cacheread( sysace_block_t*, Huint );
extern Hint sysace_block_cacheload( sysace_block_t*, Huint, Huint );
extern Hint sysace_block_cachestore( sysace_block_t*, Huint );

extern Huint sysace_block_cachetouch( sysace_block_t*, Huint );
extern Hint sysace_block_cachereplace( sysace_block_t* );
extern Hint sysace_block_cacheflush( sysace_block_t* );
extern Hint sysace_block_cachesize( sysace_block_t*, Huint, Huint );

#endif
