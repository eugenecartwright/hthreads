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

#include <arch/asm.h>

void _ppc405_xilinx_errata( void )
{
    //orccr0( 0x50000000 );
}

void _ppc405_clear( void *start, void *end )
{
    Hubyte *bstart;
    Hubyte *bend;
    Huint  *wstart;
    Huint  *wend;
    Hubyte *bcur;
    Huint  *wcur;

    // Get byte boundary start and end locations
    bstart = (Hubyte*)start;
    bend   = (Hubyte*)end;

    // Calculate word boundary start and end locations
    wstart = start + ((4 - ((Huint)start % 4)) % 4);
    wend   = end - ((Huint)end % 4);

    // Fill bytes at the beginning upto the word boundary
    for( bcur = bstart; bcur < (Hubyte*)wstart; bcur++ )    *bcur = 0;

    // Fill words in the middle upto the word boundaries
    for( wcur = wstart; wcur < wend; wcur++ )               *wcur = 0;

    // Fill bytes at the end upto the word boundary
    for( bcur = (Hubyte*)wend; bcur < bend; bcur++ )        *bcur = 0;
}

void _ppc405_setup_timer( void )
{
    mttbl( 0 );
    mttbu( 0 );
}

void _ppc405_setup_fpu( void )
{
    ormsr( MSR_FP | MSR_DE );
}
