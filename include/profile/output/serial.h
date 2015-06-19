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

#include <stdio.h>
#include <profile/output/output.h>

#define hprofile_output_serial_start(f)     printf("\001%s\002",f)
#define hprofile_output_serial_finish(f)    printf("\003")

#define hprofile_output_serial_label(l)     printf(l)
#define hprofile_output_serial_column()     printf(",")
#define hprofile_output_serial_row()        printf("\n")

#define hprofile_output_serial_byte(d)      printf("%d", (Hbyte)d)
#define hprofile_output_serial_short(d)     printf("%d", (Hshort)d)
#define hprofile_output_serial_int(d)       printf("%d", (Hint)d)
#define hprofile_output_serial_long(d)      printf("%lld", (Hlong)d)
#define hprofile_output_serial_float(d)     printf("%f", (Hfloat)d)
#define hprofile_output_serial_double(d)    printf("%f", (Hdouble)d)

#define hprofile_output_serial_ubyte(d)     printf("%u", (Hubyte)d)
#define hprofile_output_serial_ushort(d)    printf("%u", (Hushort)d)
#define hprofile_output_serial_uint(d)      printf("%u", (Huint)d)
#define hprofile_output_serial_ulong(d)     printf("%llu", (Hulong)d)

#endif

