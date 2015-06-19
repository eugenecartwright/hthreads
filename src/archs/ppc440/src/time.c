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
  * \file       time.c
  * \brief      The implementation of time grabbing routines
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  * This file provides the architecture dependent implementation of timers.
  */
#include <hthread.h>
#include <config.h>
#include <arch/htime.h>
#include <arch/asm.h>

/*
Hint _arch_get_time( arch_clock_t *clock )
{
    Huint *d;

    // Get a pointer to the data
    d = (Huint*)clock;

    // Read a consistent time value from the processor
    do
    {
        d[0] = mftbu();
        d[1] = mftbl();
    } while( d[0] != mftbu() );
    
    // At this point the function was completed successfully.
	return SUCCESS;
}

Hint _arch_set_time( arch_clock_t *clock )
{
    Huint l;
    Huint h;

    // Get the low and high values
    h = (Huint)(*clock >> 32);
    l = (Huint)(*clock & 0x00000000FFFFFFFF);

    // Clear out the lower time value to make sure a roll over doesn't occur
    mttbl( 0 );

    // Set the time value on the cpu
    mttbu( h );
    mttbl( l );

    // Return successfully
	return SUCCESS;
}
*/
