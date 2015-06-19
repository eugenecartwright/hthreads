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
  *	\file       float.h
  * \brief      This file contains the declaration of the functionality used
  *             to interpret float data values inside of the Hthreads
  *             profiling framework.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  */

#ifndef _HYBRID_THREADS_PROFILE_INTERP_FLOAT_H_
#define _HYBRID_THREADS_PROFILE_INTERP_FLOAT_H_

#include <profile/storage/storage.h>

// Declare the structures used
hprofile_interp_avg_struct(float);
hprofile_interp_hist_struct(float);
hprofile_interp_buff_struct(float);
hprofile_interp_sum_struct(float);

// Provide definitions for all of the required operations
#define Hfloat_double(x)       (x)
#define Hfloat_assign(x,y)     (x = y)
#define Hfloat_less(x,y)       (x < y)
#define Hfloat_greater(x,y)    (x > y)
#define Hfloat_sub(d,l,r)      (d = l - r)
#define Hfloat_add(d,l,r)      (d = l + r)

// Declare the functions used for averaging
#define hprofile_interp_float_avg_create(val)                            \
    hprofile_interp_avg_create(float,val)

#define hprofile_interp_float_avg_average(info,data)                     \
    hprofile_interp_average(float,info,data)

#define hprofile_interp_float_avg_output(info,out)                       \
    hprofile_interp_averageout(float,info,out)

#define hprofile_interp_float_avg_close(info)                            \
    hprofile_interp_avg_close(float,info)

// Declare the functions used for histogramming
#define hprofile_interp_float_hist_create(val,m,x,b)                     \
    hprofile_interp_hist_create(float,val,m,x,b,HFLOAT_MAX,HFLOAT_MIN)

#define hprofile_interp_float_hist_histogram(info,data)                  \
    hprofile_interp_hist(float,info,data)

#define hprofile_interp_float_hist_output(info,out)                      \
    hprofile_interp_histout(float,info,out)

#define hprofile_interp_float_hist_close(info)                           \
    hprofile_interp_hist_close(float,info)

// Declare the functions used for buffering
#define hprofile_interp_float_buff_create(info,num)                      \
    hprofile_interp_buffer_create(float,info,num)

#define hprofile_interp_float_buff_buffer(info,tag,sample)               \
    hprofile_interp_buffer(float,info,tag,sample)

#define hprofile_interp_float_buff_output(info,out)                      \
    hprofile_interp_bufferout(float,info,out)

#define hprofile_interp_float_buff_close(info)                           \
    hprofile_interp_buffer_close(float,info)

// Declare the functions used for summing
#define hprofile_interp_float_sum_create(info,num)                       \
    hprofile_interp_sum_create(float,info,num)

#define hprofile_interp_float_sum_sum(info,sample)                       \
    hprofile_interp_sum(float,info,sample)

#define hprofile_interp_float_sum_output(info,out)                       \
    hprofile_interp_sumout(float,info,out)

#define hprofile_interp_float_sum_close(info)                            \
    hprofile_interp_sum_close(float,info)


#endif

