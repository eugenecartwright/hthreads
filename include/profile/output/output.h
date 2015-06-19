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
  *	\file       output.h
  * \brief      This file contains definitions of the output
  *             functionality in the profiling system of Hthreads.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  */

#ifndef _HYBRID_THREADS_PROFILE_OUTPUT_H_
#define _HYBRID_THREADS_PROFILE_OUTPUT_H_

#include <hthread.h>
#include <profile/output/default.h>
#include <profile/output/serial.h>
//#include <profile/output/tcpip.h>

#define hprofile_output_start(o,f)      hprofile_output_##o##_start(f)
#define hprofile_output_finish(o,f)     hprofile_output_##o##_finish(f)

#define hprofile_output_label(o,l)      hprofile_output_##o##_label(l)
#define hprofile_output_column(o)       hprofile_output_##o##_column()
#define hprofile_output_row(o)          hprofile_output_##o##_row()

#define hprofile_output_byte(o,d)       hprofile_output_##o##_byte(d)
#define hprofile_output_short(o,d)      hprofile_output_##o##_short(d)
#define hprofile_output_int(o,d)        hprofile_output_##o##_int(d)
#define hprofile_output_long(o,d)       hprofile_output_##o##_long(d)
#define hprofile_output_double(o,d)     hprofile_output_##o##_double(d)
#define hprofile_output_float(o,d)      hprofile_output_##o##_float(d)

#define hprofile_output_ubyte(o,d)      hprofile_output_##o##_ubyte(d)
#define hprofile_output_ushort(o,d)     hprofile_output_##o##_ushort(d)
#define hprofile_output_uint(o,d)       hprofile_output_##o##_uint(d)
#define hprofile_output_ulong(o,d)      hprofile_output_##o##_ulong(d)

#endif

