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

/** \file       ps2.h
  * \brief      Header file for the ps2 driver.
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *
  * This file is the header file for the Hthreads PS2 driver. This driver
  * is capable of communicating with any PS2 based device.
  */
#ifndef _HYBRID_THREADS_DRIVER_PS2_H_
#define _HYBRID_THREADS_DRIVER_PS2_H_

#include <httype.h>
#include <htconst.h>

#define PS2_RESET                   0x00
#define PS2_STATUS                  0x04
#define PS2_RECV                    0x08
#define PS2_SEND                    0x0C
#define PS2_INTERRUPTS              0x10
#define PS2_CLEAR                   0x14
#define PS2_ENABLE                  0x18
#define PS2_DISABLE                 0x1C

#define PS2_RESET_ENABLE            ((Hubyte)0x01)
#define PS2_RESET_DISABLE           ((Hubyte)0x00)

#define PS2_RECV_FULL               0x01
#define PS2_SEND_FULL               0x02

#define PS2_INTERRUPT_WDT           0x01
#define PS2_INTERRUPT_NOACK         0x02
#define PS2_INTERRUPT_ACK           0x04
#define PS2_INTERRUPT_OVF           0x08
#define PS2_INTERRUPT_ERR           0x10
#define PS2_INTERRUPT_FULL          0x20
#define PS2_INTERRUPT_ALL           0x3F

typedef struct
{
    Huint   base;
} ps2_config_t;

typedef struct
{
    volatile Hubyte *reset;
    volatile Hubyte *status;
    volatile Hubyte *recv;
    volatile Hubyte *send;
    volatile Hubyte *intr;
    volatile Hubyte *clear;
    volatile Hubyte *enable;
    volatile Hubyte *disable;
} ps2_t;

extern Hint   ps2_create( ps2_t*, ps2_config_t* );
extern Hint   ps2_destroy( ps2_t* );
extern void   ps2_reset( ps2_t* );
extern Hubyte ps2_status( ps2_t* );
extern Hubyte ps2_interrupts( ps2_t* );
extern void   ps2_clear( ps2_t*, Hubyte );
extern Hubyte ps2_isenabled( ps2_t*, Hubyte );
extern void   ps2_enable( ps2_t*, Hubyte );
extern void   ps2_disable( ps2_t*, Hubyte );
extern Hbool  ps2_sendfull( ps2_t* );
extern Hbool  ps2_recvempty( ps2_t* );
extern void   ps2_sendbyte( ps2_t*, Hubyte );
extern Hubyte ps2_recvbyte( ps2_t* );

#endif
