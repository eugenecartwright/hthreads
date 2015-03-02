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
  *	\file       commands.h
  * \brief      This file contains the declaration of the commands that
  *				can be issued to the timer subsystem
  *
  * \author     Wesley Peck <peckw@ittc.ku.edu>\n
  *             Ed Komp <komp@ittc.ku.edu>
  *
  * This file contains the declaration of the commands which can be issued
  * the the hardware timers. This includes the ability to start timers, stop
  * timers, load delta values and others.
  */

#ifndef _HYBRID_THREADS_TIMER_COMMANDS_H_
#define _HYBRID_THREADS_TIMER_COMMANDS_H_

#include <config.h>
#include <util/rops.h>

#define HT_TIMER_GLB_LO         0x00
#define HT_TIMER_GLB_HI         0x04

#define HT_TIMER0_CMD           0x08
#define HT_TIMER0_CMDSET        0x0C
#define HT_TIMER0_CMDCLR        0x10
#define HT_TIMER0_DELTA         0x14
#define HT_TIMER0_DATA          0x18
#define HT_TIMER0_DELAY         0x1C
#define HT_TIMER0_VALUE         0x20
#define HT_TIMER0_INTR_COUNT    0x48

#define HT_TIMER1_CMD           0x24
#define HT_TIMER1_CMDSET        0x28
#define HT_TIMER1_CMDCLR        0x2C
#define HT_TIMER1_DELTA         0x30
#define HT_TIMER1_DATA          0x34
#define HT_TIMER1_DELAY         0x38
#define HT_TIMER1_VALUE         0x3C
#define HT_TIMER1_INTR_COUNT    0x4C

#define HT_DECISION_REG         0x40
#define HT_DECISION_DELAY       0x44

#define HT_TIMER_CMD_RUN        0x01
#define HT_TIMER_CMD_LOAD       0x02
#define HT_TIMER_CMD_ENABLE     0x04
#define HT_TIMER_CMD_PERIODIC   0x08

#ifdef TIMER_BASEADDR
#define timer_get_command(t)    read_reg(   TIMER_BASEADDR +       \
                                            HT_TIMER##t##_CMD )
#define timer_set_command(t,v)  write_reg(  TIMER_BASEADDR +       \
                                            HT_TIMER##t##_CMDSET,      \
                                            (Huint)(v) )
#define timer_clr_command(t,v)  write_reg(  TIMER_BASEADDR +       \
                                            HT_TIMER##t##_CMDCLR,      \
                                            (Huint)(v) )

#define timer_get_delta(t)      read_reg(   TIMER_BASEADDR +       \
                                            HT_TIMER##t##_DELTA )
#define timer_set_delta(t,v)    write_reg(  TIMER_BASEADDR +       \
                                            HT_TIMER##t##_DELTA,       \
                                            (Huint)(v) )

#define timer_get_data(t)       read_reg(   TIMER_BASEADDR +       \
                                            HT_TIMER##t##_DATA )
#define timer_set_data(t,v)     write_reg(  TIMER_BASEADDR +       \
                                            HT_TIMER##t##_DATA,        \
                                            (Huint)(v) )



#define timer_get_intr_count(t)       read_reg(   TIMER_BASEADDR +       \
                                            HT_TIMER##t##_INTR_COUNT )
#define timer_reset_intr_count(t)     write_reg(  TIMER_BASEADDR +       \
                                            HT_TIMER##t##_INTR_COUNT,        \
                                            0x00000001 )


        
#define timer_get_delay(t)      read_reg(   TIMER_BASEADDR +       \
                                            HT_TIMER##t##_DELAY )
#define timer_get_value(t)      read_reg(   TIMER_BASEADDR +       \
                                            HT_TIMER##t##_VALUE )

#define timer_decision_set(v)   write_reg(  TIMER_BASEADDR +       \
                                            HT_DECISION_REG,           \
                                            v );

#define timer_decision_get()     read_reg(  TIMER_BASEADDR +       \
                                            HT_DECISION_REG );

#define timer_decision_delay()   read_reg(  TIMER_BASEADDR +       \
                                            HT_DECISION_DELAY );
                                            
#define timer_get_globallo()    read_reg(   TIMER_BASEADDR +       \
                                            HT_TIMER_GLB_LO )

#define timer_get_globalhi()    read_reg(   TIMER_BASEADDR +       \
                                            HT_TIMER_GLB_HI )
#else
#define timer_get_command(t)        0
#define timer_set_command(t,v)      
#define timer_clr_command(t,v)      
#define timer_get_delta(t)          0
#define timer_set_delta(t,v)        
#define timer_get_data(t)           0
#define timer_set_data(t,v)         
#define timer_get_intr_count(t)     0
#define timer_reset_intr_count(t)   
#define timer_get_delay(t)          0
#define timer_get_value(t)          0
#define timer_decision_set(v)       
#define timer_decision_get()        0
#define timer_decision_delay()      0
#define timer_get_globallo()        0
#define timer_get_globalhi()        0
#endif

#endif

