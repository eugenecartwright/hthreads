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

#ifndef _HTHREADS_PERFORMANCE_PROFILE_H_
#define _HTHREADS_PERFORMANCE_PROFILE_H_

// Make sure that profiling is turned on for these tests
#define PROFILING 1
#ifndef PROFILE_OUTPUT
#define PROFILE_OUTPUT serial
#endif

#include <hthread.h>
#include <debug.h>
#include <profile/profile.h>
#include <stdlib.h>
#include <stdio.h>

#define CREATE_TYPE                 time
#define CREATE_MIN                  5000
#define CREATE_MAX                  20000
#define CREATE_BINS                 200
#define CREATE_NAME                 "create"

#define SCHEDPARAM_TYPE             time
#define SCHEDPARAM_MIN              5000
#define SCHEDPARAM_MAX              20000
#define SCHEDPARAM_BINS             200
#define SCHEDPARAM_NAME             "schedparam"

#define JOIN_TYPE                   time
#define JOIN_MIN                    5000
#define JOIN_MAX                    20000
#define JOIN_BINS                   200
#define JOIN_NAME                   "join"

#define SELF_TYPE                   time
#define SELF_MIN                    18000
#define SELF_MAX                    20000
#define SELF_BINS                   200
#define SELF_NAME                   "self"

#ifdef PROFILE_CREATE
#undef PROFILE_CREATE
#endif

#ifdef PROFILE_SCHEDPARAM
#undef PROFILE_SCHEDPARAM
#endif

#ifdef PROFILE_JOIN
#undef PROFILE_JOIN
#endif

#ifdef PROFILE_SELF
#undef PROFILE_SELF
#endif

#define PROFILE_CREATE 0
#define PROFILE_SCHEDPARAM 0
#define PROFILE_JOIN 0
#define PROFILE_SELF 0

#endif
