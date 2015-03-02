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

#ifndef _CONSTANTS_H_
#define _CONSTANTS_H_

#if 1
// The number of bounded buffer streams
#define STREAMS     1

// The size for each stream
const int STREAM_SIZES[]    = { 1*2*1024 };

// The number of consumers for each stream
const int STREAM_CONSM[]    = { 5 };

// The number of producers for each stream
const int STREAM_PRODC[]    = { 5 };

// The number of values to produce for each stream
const int STREAM_ENDS[]     = { 1024*1024*1024 };

#endif

#if 0
// The number of bounded buffer streams
#define STREAMS     10

// The size for each stream
const int STREAM_SIZES[]    = { 5, 5, 5, 5, 5, 5, 5, 5, 5, 5 };

// The number of consumers for each stream
const int STREAM_CONSM[]    = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

// The number of producers for each stream
const int STREAM_PRODC[]    = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

// The number of values to produce for each stream
const int STREAM_ENDS[]     = { 1*128*1024, 
                                1*256*1024,
                                1*512*1024,
                                1*1024*1024,
                                2*1024*1024,
                                4*1024*1024,
                                8*1024*1024,
                                16*1024*1024,
                                32*1024*1024,
                                64*1024*1024 };
#endif

#endif
