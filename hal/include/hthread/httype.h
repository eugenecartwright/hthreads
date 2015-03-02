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

/** \file       httype.h
  * \brief      The declaration of the Hybrid Threads API Types.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  */

#ifndef _HYBRID_THREAD_TYPES_H_
#define _HYBRID_THREAD_TYPES_H_

/** \brief  The definition of the NULL value */
#ifndef NULL
	#define NULL	0
#endif

// Minimum and maximum for all Hthreads data types
#define HBYTE_MIN       (-128)
#define HSHORT_MIN      (-32767-1)
#define HINT_MIN        (-2147483647-1)
#define HLONG_MIN       (-(9223372036854775807LL)-1)
#define HBYTE_MAX       (127)
#define HSHORT_MAX      (32767)
#define HINT_MAX        (2147483647)
#define HLONG_MAX       (9223372036854775807LL)
#define HUBYTE_MAX      (255)
#define HUSHORT_MAX     (65535)
#define HUINT_MAX       (4294967295U)
#define HULONG_MAX      (18446744073709551615ULL)
#define HFLOAT_MIN      (1.17549435e-38F)
#define HFLOAT_MAX      (3.40282347e+38F)
#define HDOUBLE_MIN     (2.2250738585072014e-308)
#define HDOUBLE_MAX     (1.7976931348623157e+308)

/** \brief	A signed 8-bit integer value.  */
typedef char		    	Hbyte;

/** \brief	A signed 16-bit integer value.  */
typedef short		    	Hshort;

/** \brief	A signed 32-bit integer value.  */
typedef	int				    Hint;

/** \brief	A signed 64-bit integer value.  */
typedef long long			Hlong;

/** \brief	A signed 32-bit floating point value.  */
typedef float			    Hfloat;

/** \brief	A signed 64-bit floating point value.  */
typedef double			    Hdouble;

/** \brief	An unsigned 8-bit integer value.  */
typedef unsigned char	    Hubyte;

/** \brief	An unsigned 16-bit integer value.  */
typedef unsigned short	    Hushort;

/** \brief	An unsigned 32-bit integer value.  */
typedef unsigned int	    Huint;

/** \brief	An unsigned 64-bit integer value.  */
typedef unsigned long long	Hulong;

/** \brief	A boolean type with representations for true and false.
  *
  * This typedef declares the boolean type used within the hthreads API.
  * The Hfalse value must be defined such that it evaluates to false and
  * the Htrue value must be defined such that it evaluates to true.
  */
typedef enum
{
	/** \brief	The boolean value false used within the hthreads API. */
	Hfalse	= 0,
	
	/** \brief	The boolean value true used within the hthreads API. */
	Htrue	= 1
} Hbool;

#endif

