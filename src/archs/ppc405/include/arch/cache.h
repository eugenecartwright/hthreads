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

/** \internal
  * \file       cache.h
  * \brief      The implementation of PowerPC cache functionality.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  */
#ifndef _HYBRID_THREADS_PPC405_CACHE_
#define _HYBRID_THREADS_PPC405_CACHE_

#include <httype.h>

void ppc405_dcache_enable( Hint regions );
void ppc405_dcache_disable( void );
void ppc405_dcache_inv( void );
void ppc405_dcache_flush( void );
void ppc405_dcache_store( void );
void ppc405_dcache_invaddr( void *addr );
void ppc405_dcache_flushaddr( void *addr );
void ppc405_dcache_storeaddr( void *addr );
void ppc405_icache_enable( Hint regions );
void ppc405_icache_disable( void );
void ppc405_icache_inv( void );
void ppc405_icache_invaddr( void *addr );
void ppc405_icache_touchaddr( void *addr );

#define dcache_flush()          ppc405_dcache_flush();
#define dcache_flushaddr(addr)  ppc405_dcache_flushaddr(addr)
#define icache_flush()          ppc405_icache_flush();


#endif
