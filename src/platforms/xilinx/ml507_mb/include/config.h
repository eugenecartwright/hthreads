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
  *             Ed Komp <komp@ittc.ku.edu>
  *
  * This file contains the configuration parameters used by the system.
  * Currently this includes the symbols used to reference the hardware.
  */

#ifndef _HYBRID_THREADS_CONFIG_H_
#define _HYBRID_THREADS_CONFIG_H_

#include <xparameters.h>

// Definitions for the number of bits used to represent tids and mids
#define THREAD_BITS             8
#define MUTEX_BITS              6

// CPU Definitions - VP7
#define CPU_CLOCK_HZ            XPAR_CPU_CORE_CLOCK_FREQ_HZ

// Reset Core Definitions
#define CORE_RESET_BASEADDR     XPAR_PLB_HTHREAD_RESET_CORE_0_BASEADDR

// Definitions used for communication between SMP cores
// during system initialization
#define READY_REG               (CORE_RESET_BASEADDR + 0x8)
#define CPU_0_READY             0xDEAD0000
#define CPU_1_READY             0xCAFE0000

// Scheduler Definitions
#define MANAGER_BASEADDR        XPAR_THREAD_MANAGER_BASEADDR
#define TIMER_BASEADDR          #error( "No Timer Defined" )
#define SCHEDULER_BASEADDR      XPAR_SCHEDULER_BASEADDR
#define SYNCH_BASEADDR          XPAR_SYNCH_MANAGER_BASEADDR
#define CONDVAR_BASEADDR	    XPAR_COND_VARS_BASEADDR


// UART Definitions
#define UART1_BASEADDR          XPAR_RS232_UART_1_BASEADDR
#define UART2_BASEADDR          #error( "No Second UART Defined" )

// Interrupt Controller Definitions
#define PIC_BASEADDR            XPAR_XPS_INTC_0_BASEADDR

// Interrupt Mask Definitions
#define DECISION_INTR_MASK      #error( "No Decision Interrrupt Defined" )
#define TIMER1_INTR_MASK        #error( "No Timer1 Interrupt Defined" )
#define TIMER2_INTR_MASK        #error( "No Timer2 Interrupt Defined" )
#define ACCESS_INTR_MASK        XPAR_THREAD_MANAGER_ACCESS_INTR_MASK

#define PREEMPT_INTR_MASK       XPAR_SCHEDULER_PREEMPTION_INTERRUPT_MASK

// Peripheral support definitions
#define ETHLITE_BASEADDR        #error( "No Ethernet Lite Defined" )
#define SYSACE_BASEADDR         #error( "No SystemACE Defined" )
#define GPIOLED_BASEADDR        XPAR_LEDS_BASEADDR
#define GPIODIP_BASEADDR        XPAR_DIPSWS_BASEADDR
#define GPIOBTN_BASEADDR        XPAR_PUSHS_BASEADDR
#define PS2_BASEADDR            #error( "No PS2 Defined" )
#define AC97_BASEADDR           #error( "No AC97 Defined" )
#define GPIOLCD_BASEADDR        
#define VGA_BASEADDR            #error( "No VGA Defined" )

// VGA Support Definitions
#define VGA_WIDTH               0
#define VGA_HEIGHT              0
/******************************************************************/

#define XPAR_THREAD_MANAGER_ACCESS_INTR_MASK 0X000001
#define XPAR_OPB_INTC_0_THREAD_MANAGER_ACCESS_INTR_INTR 0
#define XPAR_OPB_INTC_0_SCHEDULER_PREEMPTION_INTERRUPT_INTR 1
#define XPAR_PUSHS_IP2INTC_IRPT_MASK 0X000004
#define XPAR_OPB_INTC_0_PUSHS_IP2INTC_IRPT_INTR 2
#define XPAR_DIPSWS_IP2INTC_IRPT_MASK 0X000008
#define XPAR_OPB_INTC_0_DIPSWS_IP2INTC_IRPT_INTR 3
#define XPAR_LEDS_IP2INTC_IRPT_MASK 0X000010
#define XPAR_OPB_INTC_0_LEDS_IP2INTC_IRPT_INTR 4

/******************************************************************/

#define XPAR_THREAD_MANAGER_ACCESS_INTR_MASK 0X000001
#define XPAR_OPB_INTC_1_THREAD_MANAGER_ACCESS_INTR_INTR 0
#define XPAR_OPB_INTC_1_SCHEDULER_PREEMPTION_INTERRUPT_INTR 1
#define XPAR_PUSHS_IP2INTC_IRPT_MASK 0X000004
#define XPAR_OPB_INTC_1_PUSHS_IP2INTC_IRPT_INTR 2
#define XPAR_DIPSWS_IP2INTC_IRPT_MASK 0X000008
#define XPAR_OPB_INTC_1_DIPSWS_IP2INTC_IRPT_INTR 3
#define XPAR_LEDS_IP2INTC_IRPT_MASK 0X000010
#define XPAR_OPB_INTC_1_LEDS_IP2INTC_IRPT_INTR 4


#endif

