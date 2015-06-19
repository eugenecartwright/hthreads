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
  *	\file       profile.h
  * \brief      This file contains definitions of the profiling functionality
  *             built into the Hthreads system.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  */

#ifndef _HYBRID_THREADS_PROFILE_H_
#define _HYBRID_THREADS_PROFILE_H_

#include <arch/htime.h>
#include <profile/interp/interp.h>
#include <profile/output/output.h>
#include <profile/storage/storage.h>

#ifdef PROFILING
    // Concatenate symbols together to form another symbol
    #define __pcat2(x,y)            x##y
    #define __pcat3(x,y,z)          x##y##z
    #define __pname(x)              __pcat2(PROFILE_,x)
    #define __pavg(x)               __pcat2(__avg_,x)
    #define __ptavg(x)              __pcat2(__avg_time_,x)
    #define __phist(x)              __pcat2(__hist_,x)
    #define __pthist(x)             __pcat2(__hist_time_,x)
    #define __pbuff(x)              __pcat2(__buff_,x)
    #define __ptbuff(x)             __pcat2(__buff_time_,x)
    #define __pabuff(x)             __pcat2(__buff_tag_,x)
    #define __psum(x)               __pcat2(__sum_,x)
    #define __ptsum(x)              __pcat2(__sum_time_,x)

    #define hprofile_avg_declare(x,t)           \
        __pcat3(hprofile_,t,_avg) __pavg(x);    \
        hthread_time_t  __ptavg(x) __attribute__((unused))

    #define hprofile_avg_create(x,t)        if(__pname(x)) \
        __pcat3(hprofile_interp_,t,_avg_create)(__pavg(x))

    #define hprofile_avg_capture(x,t,v)     if(__pname(x)) \
        __pcat3(hprofile_interp_,t,_avg_average)(__pavg(x), v)

    #define hprofile_avg_flush(x,t,o,f)       ({  if(__pname(x)) {  \
        hprofile_output_start(o,f);                                 \
        __pcat3(hprofile_interp_,t,_avg_output)(__pavg(x),o);       \
        hprofile_output_finish(o,f); } })

    #define hprofile_avg_close(x,t)         if(__pname(x)) \
        __pcat3(hprofile_interp_,t,_avg_close)(__pavg(x))

    #define hprofile_avg_time(x,t)         ({ if(__pname(x)) {      \
        hthread_time_t time;                                        \
        hthread_time_get( &time );                                  \
        hprofile_avg_capture(x,t,time); } })

    #define hprofile_avg_start(x,t)         if(__pname(x)) \
        hthread_time_get( &(__ptavg(x)) )

    #define hprofile_avg_finish(x,t)        ({ if(__pname(x)) {     \
        hthread_time_t time;                                        \
        hthread_time_get( &time );                                  \
        hthread_time_diff( time, time, __ptavg(x) );                \
        hprofile_avg_capture(x,t,time);} })

    #define hprofile_hist_declare(x,t)          \
        __pcat3(hprofile_,t,_hist) __phist(x);  \
        hthread_time_t __pthist(x) __attribute__((unused))

    #define hprofile_hist_create(x,t,m,a,b) if(__pname(x)) \
        __pcat3(hprofile_interp_,t,_hist_create)(__phist(x), m, a, b)

    #define hprofile_hist_capture(x,t,v)    if(__pname(x)) \
        __pcat3(hprofile_interp_,t,_hist_histogram)(__phist(x), v)

    #define hprofile_hist_flush(x,t,o,f)    ({ if(__pname(x)) {     \
        hprofile_output_start(o,f);                                 \
        __pcat3(hprofile_interp_,t,_hist_output)(__phist(x),o);     \
        hprofile_output_finish(o,f); } })

    #define hprofile_hist_close(x,t)        if(__pname(x)) \
        __pcat3(hprofile_interp_,t,_hist_close)(__phist(x))

    #define hprofile_hist_time(x,t)         ({ if(__pname(x)) {     \
        hthread_time_t time;                                        \
        hthread_time_get( &time );                                  \
        hprofile_hist_capture(x,t,time); } })

    #define hprofile_hist_start(x,t)        if(__pname(x)) \
        hthread_time_get( &(__pthist(x)) )

    #define hprofile_hist_finish(x,t)        ({ if(__pname(x)) {    \
        hthread_time_t time;                                        \
        hthread_time_get( &time );                                  \
        hthread_time_diff( time, time, __pthist(x) );               \
        hprofile_hist_capture(x,t,time);} })


    #define hprofile_buff_declare(x,t)                              \
        __pcat3(hprofile_,t,_buff) __pbuff(x);                      \
        Huint __pabuff(x) __attribute__((unused));                  \
        hthread_time_t __ptbuff(x) __attribute__((unused))

    #define hprofile_buff_create(x,t,n)     if(__pname(x)) \
        __pcat3(hprofile_interp_,t,_buff_create)(__pbuff(x), n)

    #define hprofile_buff_capture(x,t,a,v)  if(__pname(x)) \
        __pcat3(hprofile_interp_,t,_buff_buffer)(__pbuff(x), a, v)

    #define hprofile_buff_flush(x,t,o,f)    ({ if(__pname(x)) {     \
        hprofile_output_start(o,f);                                 \
        __pcat3(hprofile_interp_,t,_buff_output)(__pbuff(x),o);     \
        hprofile_output_finish(o,f); } })

    #define hprofile_buff_close(x,t)        if(__pname(x)) \
        __pcat3(hprofile_interp_,t,_buff_close)(__pbuff(x))

    #define hprofile_buff_time(x,t,a)         ({ if(__pname(x)) {   \
        hthread_time_t time;                                        \
        hthread_time_get( &time );                                  \
        hprofile_buff_capture(x,t,a,time); } })

    #define hprofile_buff_begin(x,t,a)       ({ if(__pname(x)) {    \
        __pabuff(x) = a;                                            \
        hthread_time_get( &(__ptbuff(x)) ); } })

    #define hprofile_buff_end(x,t,a)         ({ if(__pname(x)) {    \
        hthread_time_t time;                                        \
        hthread_time_get( &time );                                  \
        hprofile_buff_capture( x, t, __pabuff(x), __ptbuff(x) );    \
        hprofile_buff_capture( x, t, a, time ); } })

    #define hprofile_buff_start(x,t)         if(__pname(x)) \
        hthread_time_get( &(__ptbuff(x)) )

    #define hprofile_buff_finish(x,t,a)      ({ if(__pname(x)) {    \
        hthread_time_t time;                                        \
        hthread_time_get( &time );                                  \
        hthread_time_diff( time, time, __ptbuff(x) );               \
        hprofile_buff_capture(x,t,a,time);} })


    #define hprofile_sum_declare(x,t)           \
        __pcat3(hprofile_,t,_sum) __psum(x);    \
        hthread_time_t __ptsum(x) __attribute__((unused))

    #define hprofile_sum_create(x,t,n)     if(__pname(x)) \
        __pcat3(hprofile_interp_,t,_sum_create)(__psum(x), n)

    #define hprofile_sum_capture(x,t,v)    if(__pname(x)) \
        __pcat3(hprofile_interp_,t,_sum_sum)(__psum(x), v)

    #define hprofile_sum_flush(x,t,o,f)    ({ if(__pname(x)) {      \
        hprofile_output_start(o,f);                                 \
        __pcat3(hprofile_interp_,t,_sum_output)(__psum(x),o);       \
        hprofile_output_finish(o,f); } })

    #define hprofile_sum_close(x,t)        if(__pname(x)) \
        __pcat3(hprofile_interp_,t,_sum_close)(__psum(x))

    #define hprofile_sum_time(x,t)         ({ if(__pname(x)) {      \
        hthread_time_t time;                                        \
        hthread_time_get( &time );                                  \
        hprofile_sum_capture(x,t,time); } })

    #define hprofile_sum_start(x,t)         if(__pname(x)) \
        hthread_time_get( &(__ptsum(x)) )

    #define hprofile_sum_finish(x,t)        ({ if(__pname(x)) {     \
        hthread_time_t time;                                        \
        hthread_time_get( &time );                                  \
        hthread_time_diff( time, time, __ptsum(x) );                \
        hprofile_sum_capture(x,t,time);} })
#else
    #define hprofile_avg_declare(x,t)         
    #define hprofile_avg_create(x,t,...)    
    #define hprofile_avg_capture(x,t,v)     
    #define hprofile_avg_time(x,t)     
    #define hprofile_avg_start(x,t)     
    #define hprofile_avg_finish(x,t)     
    #define hprofile_avg_flush(x,t,o,f)           
    #define hprofile_avg_close(x,t)           
    #define hprofile_hist_declare(x,t)        
    #define hprofile_hist_create(x,t,...)   
    #define hprofile_hist_capture(x,t,v)    
    #define hprofile_hist_time(x,t)     
    #define hprofile_hist_start(x,t)     
    #define hprofile_hist_finish(x,t)     
    #define hprofile_hist_flush(x,t,o,f)          
    #define hprofile_hist_close(x,t)          
    #define hprofile_buff_declare(x,t)        
    #define hprofile_buff_create(x,t,...)   
    #define hprofile_buff_capture(x,t,a,v)    
    #define hprofile_buff_time(x,t,a)     
    #define hprofile_buff_begin(x,t,a)     
    #define hprofile_buff_end(x,t,a)     
    #define hprofile_buff_start(x,t)     
    #define hprofile_buff_finish(x,t,a)     
    #define hprofile_buff_flush(x,t,o,f)          
    #define hprofile_buff_close(x,t)          
    #define hprofile_sum_declare(x,t)         
    #define hprofile_sum_create(x,t,...)    
    #define hprofile_sum_capture(x,t,v)     
    #define hprofile_sum_time(x,t)     
    #define hprofile_sum_start(x,t)     
    #define hprofile_sum_finish(x,t)     
    #define hprofile_sum_flush(x,t,o,f)           
    #define hprofile_sum_close(x,t)           
#endif

#endif

