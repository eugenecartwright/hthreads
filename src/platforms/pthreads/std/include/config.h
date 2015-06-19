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

/** \file       config.h
  * \brief      Configuration parameters used for the hybrid threads system.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  * This file contains the configuration parameters used by the system.
  * In this file the parameters are hardcoded because no actual hardware
  * exists. This is done so that some host tools which calculate hardware
  * addresses will still work.
  *
  * In addition, some of the values in this file are used to make PThreads
  * more accurately emulate Hthreads. The value of MUTEX_BITS, for example,
  * is used to determine how many mutexes are allocated by the system.
  */

#ifndef _HYBRID_THREADS_CONFIG_H_
#define _HYBRID_THREADS_CONFIG_H_

// Definitions for the number of bits used to represent tids and mids
#define THREAD_BITS             8
#define MUTEX_BITS              6

// Definitions for the maximum number of tids and mids
#define THREAD_MAX              256
#define MUTEX_MAX               64
#define COND_MAX                64

// Definitions for how fast the processor is running
#define CPU_CLOCK_HZ            100000000

// Definitions for base addresses of hthreads cores
#define MANAGER_BASEADDR        0x60000000
#define TIMER_BASEADDR          0x76000000
#define SCHEDULER_BASEADDR      0x61000000
#define SYNCH_BASEADDR          0x75000000
#define CONDVAR_BASEADDR	    0x61000000
#define SPIC_BASEADDR           0x62000000

// Interrupt Mask Definitions
#define DECISION_INTR_MASK      0x00000001
#define TIMER1_INTR_MASK        0x00000002
#define TIMER2_INTR_MASK        0x00000004
#define ACCESS_INTR_MASK        0x00000008
#define PREEMPT_INTR_MASK       0x00000010

#endif

