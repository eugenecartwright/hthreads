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
  * \file       cache.c
  * \brief      The implementation of PowerPC cache functionality.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  */
#include <hthread.h>
#include <arch/cache.h>
#include <arch/asm.h>

void ppc405_dcache_enable( Hint regions )
{
    ppc405_dcache_disable();

    mtsgr( 0 );
    mtdcwr( 0 );
    mtdccr( regions );
    isync();
}

void ppc405_dcache_disable( void )
{
    Huint dccr;

    dccr = mfdccr();
    if( dccr != 0 )     ppc405_dcache_flush();
    else                ppc405_dcache_inv();

    mtdcwr(0);
    mtdccr(0);
    isync();
}

void ppc405_dcache_inv( void )
{
    Huint i;
    Huint addr;

    for(i = 0, addr = 0; i < DCACHE_CLASSES; i++, addr += 32)   dccci(0, addr);

    sync();
    isync();
}

void ppc405_dcache_flush( void )
{
    Huint i;
    Huint addr;
    Huint tag;

    // Get Tag Information using dcread
    orccr0( CCR0_CIS );
    
    // Select Cache Set A
    andccr0( ~CCR0_CWS );

    // Flush Cache Set A
    for( i = 0, addr = 0; i < DCACHE_CLASSES; i++, addr += 32 )
    {
        // Get the cache tag for the current address
        tag = dcread( 0, addr );

        // Flush the cache line if it is dirty and valid
        if( (tag & 0x30) == 0x30 )  dcbf( 0, (tag & 0xFFFFF000) | addr );
    }

    // Select Cache Set B
    orccr0( CCR0_CWS );

    // Flush Cache Set B
    for( i = 0, addr = 0; i < DCACHE_CLASSES; i++, addr += 32 )
    {
        // Get the cache tag for the current address
        tag = dcread( 0, addr );

        // Flush the cache line if it is dirty and valid
        if( (tag & 0x30) == 0x30 )  dcbf( 0, (tag & 0xFFFFF000) | addr );
    }

    sync();
    isync();
}

void ppc405_dcache_store( void )
{
    Huint i;
    Huint addr;

    for( i = 0, addr = 0; i < DCACHE_CLASSES; i++ )
    {
        // Flush one way of the cache set
        dcbst( 0, addr );

        // Flush the other way of the cache set
        dcbst( 8192, addr );

        // Move to the next cache line
        addr += 32;
    }

    sync();
    isync();
}

void ppc405_dcache_invaddr( void *addr )
{
    dcbi( 0, addr );
    sync();
    isync();
}

void ppc405_dcache_invaddrs( void *addr, Huint len )
{
    Huint *adr  = (Huint*)addr;
    Huint *adre = (Huint*)(addr + len);
    while( adr < adre )  dcbi( 0, adr++ );
    sync();
    isync();
}

void ppc405_dcache_flushaddr( void *addr )
{
    dcbf( 0, addr );
    sync();
    isync();
}

void ppc405_dcache_storeaddr( void *addr )
{
    dcbst( 0, addr );
    sync();
    isync();
}

void ppc405_icache_enable( Hint regions )
{
    ppc405_icache_disable();

    mtsgr( 0 );
    iccci();
    mticcr( regions );
    isync();
}

void ppc405_icache_disable( void )
{
    iccci();
    mticcr( 0 );
    isync();
}

void ppc405_icache_inv( void )
{
    iccci();
    isync();
}

void ppc405_icache_invaddr( void *addr )
{
    icbi( 0, addr );
    isync();
}

void ppc405_icache_touchaddr( void *addr )
{
    icbt( 0, addr );
    isync();
}
