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
  *	\file       buffer.h
  * \brief      This file contains the macros which are used to buffer
  *             data values during the profiling process.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  */
#ifndef _HYBRID_THREADS_PROFILE_BUFFER_H_
#define _HYBRID_THREADS_PROFILE_BUFFER_H_

#include <math.h>

#define hprofile_interp_buff_struct(type)                           \
    typedef struct                                                  \
    {                                                               \
        Huint   loc;                                                \
        Huint   size;                                               \
        H##type *buffer;                                            \
        Huint   *tags;                                              \
    } hprofile_##type##_buff;

#define hprofile_interp_buffer_create(type,val,num) ({              \
    val.loc  = 0;                                                   \
    val.size = num;                                                 \
    val.buffer = (H##type*)malloc(val.size*sizeof(H##type));        \
    val.tags   = (Huint*)malloc(val.size*sizeof(Huint));            \
    if( val.buffer == NULL || val.tags == NULL ) {                  \
        if( val.buffer == NULL )    free(val.buffer);               \
        if( val.tags == NULL )    free(val.tags);                   \
    }                                                               \
                                                                    \
    val.buffer == NULL || val.tags == NULL;                         \
})

#define hprofile_interp_buffer_close(type,val) ({                   \
    if(val.buffer != NULL) free(val.buffer);                        \
    if(val.tags != NULL) free(val.tags);                            \
})

#define hprofile_interp_buffer(type,buff,tag,sample)  ({            \
    Hint ret;                                                       \
                                                                    \
    ret = ENOMEM;                                                   \
    if( buff.loc < buff.size ) {                                    \
        buff.buffer[buff.loc] = sample;                             \
        buff.tags[buff.loc++] = tag;                                \
        ret = SUCCESS;                                              \
    }                                                               \
                                                                    \
    ret;                                                            \
})

#define hprofile_interp_bufferout(type,buff,out)  ({                \
    Hulong  i;                                                      \
                                                                    \
    hprofile_output_label( out, "Tag" );                            \
    hprofile_output_column(out);                                    \
    hprofile_output_label( out, "Data" );                           \
    hprofile_output_row(out);                                       \
    for( i = 0; i < buff.loc; i++ ) {                               \
        hprofile_output_uint(out, buff.tags[i] );                   \
        hprofile_output_column(out);                                \
        hprofile_output_##type(out, buff.buffer[i] );               \
        hprofile_output_row(out);                                   \
    }                                                               \
    buff.loc = 0;                                                   \
})

#endif
