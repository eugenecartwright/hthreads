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
  *	\file       double.h
  * \brief      This file contains the declaration of the functionality used
  *             to interpret double data values inside of the Hthreads
  *             profiling framework.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  */

#ifndef _HYBRID_THREADS_PROFILE_INTERP_DOUBLE_H_
#define _HYBRID_THREADS_PROFILE_INTERP_DOUBLE_H_

#include <profile/storage/storage.h>

// Declare the structures used
hprofile_interp_avg_struct(double);
hprofile_interp_hist_struct(double);
hprofile_interp_buff_struct(double);
hprofile_interp_sum_struct(double);

// Provide definitions for all of the required operations
#define Hdouble_double(x)       (x)
#define Hdouble_assign(x,y)     (x = y)
#define Hdouble_less(x,y)       (x < y)
#define Hdouble_greater(x,y)    (x > y)
#define Hdouble_sub(d,l,r)      (d = l - r)
#define Hdouble_add(d,l,r)      (d = l + r)

// Declare the functions used for averaging
#define hprofile_interp_double_avg_create(val)                            \
    hprofile_interp_avg_create(double,val)

#define hprofile_interp_double_avg_average(info,data)                     \
    hprofile_interp_average(double,info,data)

#define hprofile_interp_double_avg_output(info,out)                       \
    hprofile_interp_averageout(double,info,out)

#define hprofile_interp_double_avg_close(info)                            \
    hprofile_interp_avg_close(double,info)

// Declare the functions used for histogramming
#define hprofile_interp_double_hist_create(val,m,x,b)                     \
    hprofile_interp_hist_create(double,val,m,x,b,HDOUBLE_MAX,HDOUBLE_MIN)

#define hprofile_interp_double_hist_histogram(info,data)                  \
    hprofile_interp_hist(double,info,data)

#define hprofile_interp_double_hist_output(info,out)                      \
    hprofile_interp_histout(double,info,out)

#define hprofile_interp_double_hist_close(info)                           \
    hprofile_interp_hist_close(double,info)

// Declare the functions used for buffering
#define hprofile_interp_double_buff_create(info,num)                      \
    hprofile_interp_buffer_create(double,info,num)

#define hprofile_interp_double_buff_buffer(info,tag,sample)               \
    hprofile_interp_buffer(double,info,tag,sample)

#define hprofile_interp_double_buff_output(info,out)                      \
    hprofile_interp_bufferout(double,info,out)

#define hprofile_interp_double_buff_close(info)                           \
    hprofile_interp_buffer_close(double,info)

// Declare the functions used for summing
#define hprofile_interp_double_sum_create(info,num)                       \
    hprofile_interp_sum_create(double,info,num)

#define hprofile_interp_double_sum_sum(info,sample)                       \
    hprofile_interp_sum(double,info,sample)

#define hprofile_interp_double_sum_output(info,out)                       \
    hprofile_interp_sumout(double,info,out)

#define hprofile_interp_double_sum_close(info)                            \
    hprofile_interp_sum_close(double,info)


#endif

