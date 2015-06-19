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
  *	\file       sum.h
  * \brief      This file contains the macros which are used to calculate
  *             summations of data values during the profiling process.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  */
#ifndef _HYBRID_THREADS_PROFILE_SUM_H_
#define _HYBRID_THREADS_PROFILE_SUM_H_

#include <math.h>

#define hprofile_interp_sum_struct(type)                            \
    typedef struct                                                  \
    {                                                               \
        H##type init;                                               \
        H##type sum;                                                \
        Hulong   samples;                                           \
    } hprofile_##type##_sum;

#define hprofile_interp_sum_create(type,val,n) ({                   \
    val.init    = n;                                                \
    val.sum     = n;                                                \
    val.samples = 0;                                                \
})

#define hprofile_interp_sum_close(type,val) ({                      \
    val.sum = val.init;                                             \
    val.samples = 0;                                                \
    SUCCESS;                                                        \
})

#define hprofile_interp_sum(type,summ,sample) ({                    \
    H##type##_add( summ.sum, summ.sum, sample );                    \
    summ.samples++;                                                 \
})

#define hprofile_interp_sumout(type,summ,out) ({                    \
    hprofile_output_label( out, "Sum" );                            \
    hprofile_output_column(out);                                    \
    hprofile_output_label( out, "Samples" );                        \
    hprofile_output_row(out);                                       \
                                                                    \
    hprofile_output_##type( out, summ.sum );                        \
    hprofile_output_column(out);                                    \
    hprofile_output_ulong( out, summ.samples );                     \
    hprofile_output_row(out);                                       \
                                                                    \
    summ.sum = summ.init;                                           \
    summ.samples = 0;                                               \
})

#endif
