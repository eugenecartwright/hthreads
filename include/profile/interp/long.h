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
  *	\file       long.h
  * \brief      This file contains the declaration of the functionality used
  *             to interpret long data values inside of the Hthreads
  *             profiling framework.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  */

#ifndef _HYBRID_THREADS_PROFILE_INTERP_LONG_H_
#define _HYBRID_THREADS_PROFILE_INTERP_LONG_H_

#include <profile/storage/storage.h>

// Declare the structures used
hprofile_interp_avg_struct(long);
hprofile_interp_hist_struct(long);
hprofile_interp_buff_struct(long);
hprofile_interp_sum_struct(long);

// Provide definitions for all of the required operations
#define Hlong_double(x)       (x)
#define Hlong_assign(x,y)     (x = y)
#define Hlong_less(x,y)       (x < y)
#define Hlong_greater(x,y)    (x > y)
#define Hlong_sub(d,l,r)      (d = l - r)
#define Hlong_add(d,l,r)      (d = l + r)

// Declare the functions used for averaging
#define hprofile_interp_long_avg_create(val)                            \
    hprofile_interp_avg_create(long,val)

#define hprofile_interp_long_avg_average(info,data)                     \
    hprofile_interp_average(long,info,data)

#define hprofile_interp_long_avg_output(info,out)                       \
    hprofile_interp_averageout(long,info,out)

#define hprofile_interp_long_avg_close(info)                            \
    hprofile_interp_avg_close(long,info)

// Declare the functions used for histogramming
#define hprofile_interp_long_hist_create(val,m,x,b)                     \
    hprofile_interp_hist_create(long,val,m,x,b,HLONG_MAX,HLONG_MIN)

#define hprofile_interp_long_hist_histogram(info,data)                  \
    hprofile_interp_hist(long,info,data)

#define hprofile_interp_long_hist_output(info,out)                      \
    hprofile_interp_histout(long,info,out)

#define hprofile_interp_long_hist_close(info)                           \
    hprofile_interp_hist_close(long,info)

// Declare the functions used for buffering
#define hprofile_interp_long_buff_create(info,num)                      \
    hprofile_interp_buffer_create(long,info,num)

#define hprofile_interp_long_buff_buffer(info,tag,sample)               \
    hprofile_interp_buffer(long,info,tag,sample)

#define hprofile_interp_long_buff_output(info,out)                      \
    hprofile_interp_bufferout(long,info,out)

#define hprofile_interp_long_buff_close(info)                           \
    hprofile_interp_buffer_close(long,info)

// Declare the functions used for summing
#define hprofile_interp_long_sum_create(info,num)                       \
    hprofile_interp_sum_create(long,info,num)

#define hprofile_interp_long_sum_sum(info,sample)                       \
    hprofile_interp_sum(long,info,sample)

#define hprofile_interp_long_sum_output(info,out)                       \
    hprofile_interp_sumout(long,info,out)

#define hprofile_interp_long_sum_close(info)                            \
    hprofile_interp_sum_close(long,info)


#endif

