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
  *	\file       histogram.h
  * \brief      This file contains the macros which are used to histogram
  *             data values during the profiling process.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  */
#ifndef _HYBRID_THREADS_PROFILE_HISTOGRAM_H_
#define _HYBRID_THREADS_PROFILE_HISTOGRAM_H_

#include <math.h>

#define hprofile_interp_hist_struct(type)                           \
    typedef struct                                                  \
    {                                                               \
        Hint    bins;                                               \
        Hulong  samples;                                            \
        H##type min;                                                \
        H##type max;                                                \
        H##type smin;                                               \
        H##type smax;                                               \
        Hulong  *data;                                              \
    } hprofile_##type##_hist;

#define hprofile_interp_hist_create(type,val,m,x,b,sm,sx) ({        \
    Hint i;                                                         \
                                                                    \
    H##type##_assign(val.min,m);                                    \
    H##type##_assign(val.max,x);                                    \
    H##type##_assign(val.smin,sm);                                  \
    H##type##_assign(val.smax,sx);                                  \
    val.samples = 0;                                                \
    val.bins = b;                                                   \
                                                                    \
    val.data = (Hulong*)malloc( (b+2)*sizeof(Hulong) );             \
    if(val.data != NULL)  for(i=0;i<b+2;i++) val.data[i] = 0;       \
                                                                    \
    val.data == NULL;                                               \
})

#define hprofile_interp_hist_close(type,val) ({                     \
    if(val.data != NULL ) free(val.data);                           \
    SUCCESS;                                                        \
})

#define hprofile_interp_hist(type,hist,sample)  ({                  \
    Hint    bin;                                                    \
    Hdouble wid;                                                    \
    Hdouble tmp;                                                    \
    H##type width;                                                  \
    H##type temp;                                                   \
                                                                    \
    if(H##type##_less(sample,hist.smin))      hist.smin = sample;   \
    if(H##type##_greater(sample,hist.smax))   hist.smax = sample;   \
                                                                    \
    H##type##_sub(width, hist.max, hist.min );                      \
    wid = H##type##_double(width);                                  \
    wid /= hist.bins;                                               \
                                                                    \
    H##type##_sub(temp, sample, hist.min );                         \
    tmp = H##type##_double(temp);                                   \
                                                                    \
    bin = (Hint)floor( tmp / wid ) + 1;                             \
    if( bin < 0 )       bin = 0;                                    \
    if( bin > hist.bins+1)   bin = hist.bins+1;                     \
    hist.data[bin]++;                                               \
    hist.samples++;                                                 \
})

#define hprofile_interp_histout(type,hist,out)  ({                  \
    Hint    i;                                                      \
    H##type tmp;                                                    \
    Hdouble del;                                                    \
    Hdouble cur;                                                    \
                                                                    \
    hprofile_output_label( out, "Low" );                            \
    hprofile_output_column(out);                                    \
    hprofile_output_label( out, "High" );                           \
    hprofile_output_column(out);                                    \
    hprofile_output_label( out, "Value" );                          \
    hprofile_output_row(out);                                       \
                                                                    \
    hprofile_output_column(out);                                    \
    hprofile_output_double( out, H##type##_double(hist.min) );      \
    hprofile_output_column(out);                                    \
    hprofile_output_ulong( out, hist.data[0] );                     \
    hprofile_output_row(out);                                       \
                                                                    \
    cur = H##type##_double(hist.min);                               \
    H##type##_sub(tmp, hist.max, hist.min );                        \
    del = H##type##_double( tmp );                                  \
    del /= hist.bins;                                               \
    for( i = 1; i < hist.bins+1; i++ ) {                            \
        hprofile_output_double( out, cur );                         \
        hprofile_output_column(out);                                \
        hprofile_output_double( out, cur+del );                     \
        hprofile_output_column(out);                                \
        hprofile_output_ulong( out, hist.data[i] );                 \
        hprofile_output_row(out);                                   \
        cur += del;                                                 \
        hist.data[i] = 0;                                           \
    }                                                               \
                                                                    \
    hprofile_output_double(out,H##type##_double(hist.max) );        \
    hprofile_output_column(out);                                    \
    hprofile_output_column(out);                                    \
    hprofile_output_ulong( out, hist.data[hist.bins+1] );           \
    hprofile_output_row(out);                                       \
    hist.samples = 0;                                               \
})

#endif
