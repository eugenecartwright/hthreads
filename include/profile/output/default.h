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

/** \internal
  *	\file       default.h
  * \brief      This file contains definitions of the default port output
  *             functionality in the profiling system of Hthreads.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  */

#ifndef _HYBRID_THREADS_PROFILE_DEFAULT_H_
#define _HYBRID_THREADS_PROFILE_DEFAULT_H_

#include <profile/output/output.h>

#define __doid(x,y,z)   x##y##z
#define __docat(x,y,z)  __doid(x,y,z)

#define hprofile_output_default_start(f)    \
    __docat(hprofile_output_,PROFILE_OUTPUT,_start)(f)

#define hprofile_output_default_finish(f)    \
    __docat(hprofile_output_,PROFILE_OUTPUT,_finish)(f)

#define hprofile_output_default_label(l)     \
    __docat(hprofile_output_,PROFILE_OUTPUT,_label)(l)

#define hprofile_output_default_column()     \
    __docat(hprofile_output_,PROFILE_OUTPUT,_column)()

#define hprofile_output_default_row()        \
    __docat(hprofile_output_,PROFILE_OUTPUT,_row)()

#define hprofile_output_default_byte(d)      \
    __docat(hprofile_output_,PROFILE_OUTPUT,_byte)(d)

#define hprofile_output_default_short(d)     \
    __docat(hprofile_output_,PROFILE_OUTPUT,_short)(d)

#define hprofile_output_default_int(d)       \
    __docat(hprofile_output_,PROFILE_OUTPUT,_int)(d)

#define hprofile_output_default_long(d)      \
    __docat(hprofile_output_,PROFILE_OUTPUT,_long)(d)

#define hprofile_output_default_float(d)     \
    __docat(hprofile_output_,PROFILE_OUTPUT,_float)(d)

#define hprofile_output_default_double(d)    \
    __docat(hprofile_output_,PROFILE_OUTPUT,_double)(d)

#define hprofile_output_default_ubyte(d)     \
    __docat(hprofile_output_,PROFILE_OUTPUT,_ubyte)(d)

#define hprofile_output_default_ushort(d)    \
    __docat(hprofile_output_,PROFILE_OUTPUT,_ushort)(d)

#define hprofile_output_default_uint(d)      \
    __docat(hprofile_output_,PROFILE_OUTPUT,_uint)(d)

#define hprofile_output_default_ulong(d)     \
    __docat(hprofile_output_,PROFILE_OUTPUT,_ulong)(d)

#endif

