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
  *	\file       serial.h
  * \brief      This file contains definitions of the serial port output
  *             functionality in the profiling system of Hthreads.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  */

#ifndef _HYBRID_THREADS_PROFILE_SERIAL_H_
#define _HYBRID_THREADS_PROFILE_SERIAL_H_

#include <hthread.h>
#include <stdio.h>

Hint hprofile_output_serial_label( const char *label )
{
    printf( "%s", label );

    // Return successfully
    return SUCCESS;
}

Hint hprofile_output_serial_column( void )
{
    printf( "," );

    // Return successfully
    return SUCCESS;
}

Hint hprofile_output_serial_row( void )
{
    printf( "\n" );

    // Return successfully
    return SUCCESS;
}

Hint hprofile_output_serial_byte( Hbyte value )
{
    printf( "%d", value );

    // Return successfully
    return SUCCESS;
}

Hint hprofile_output_serial_short( Hshort value )
{
    printf( "%d", value );

    // Return successfully
    return SUCCESS;
}

Hint hprofile_output_serial_int( Hint value )
{
    printf( "%d", value );

    // Return successfully
    return SUCCESS;
}

Hint hprofile_output_serial_long( Hlong value )
{
    printf( "%lld", value );

    // Return successfully
    return SUCCESS;
}

Hint hprofile_output_serial_float( Hfloat value )
{
    printf( "%f", value );

    // Return successfully
    return SUCCESS;
}

Hint hprofile_output_serial_double( Hdouble value )
{
    printf( "%f", value );

    // Return successfully
    return SUCCESS;
}

Hint hprofile_output_serial_ubyte( Hubyte value )
{
    printf( "%u", value );

    // Return successfully
    return SUCCESS;
}

Hint hprofile_output_serial_ushort( Hushort value )
{
    printf( "%u", value );

    // Return successfully
    return SUCCESS;
}

Hint hprofile_output_serial_uint( Huint value )
{
    printf( "%u", value );

    // Return successfully
    return SUCCESS;
}

Hint hprofile_output_serial_ulong( Hulong value )
{
    printf( "%llu", value );

    // Return successfully
    return SUCCESS;
}

#endif

