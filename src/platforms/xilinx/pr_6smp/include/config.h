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
// FIXME: Is this necessary. Change bootup code?
#define READY_REG               (CORE_RESET_BASEADDR + 0x8)
#define CPU_0_READY             0xDEAD0000
#define CPU_1_READY             0xCAFE0000
#define NUM_AVAILABLE_HETERO_CPUS   6
// Scheduler Definitions
#define MANAGER_BASEADDR        XPAR_THREAD_MANAGER_BASEADDR
#define TIMER_BASEADDR          #error( "No Timer Defined" )
#define SCHEDULER_BASEADDR      XPAR_SCHEDULER_BASEADDR
#define SYNCH_BASEADDR          XPAR_SYNC_MANAGER_BASEADDR
#define CONDVAR_BASEADDR        XPAR_COND_VARS_BASEADDR
// UART Definitions
#define UART1_BASEADDR          XPAR_RS232_UART_1_BASEADDR
#define UART2_BASEADDR          #error( "No Second UART Defined" )
// Interrupt Controller Definitions
#define PIC_BASEADDR          XPAR_XPS_INTC_0_BASEADDR
//#define PIC_BASEADDR_0          XPAR_XPS_INTC_0_BASEADDR
//#define PIC_BASEADDR_1          XPAR_XPS_INTC_1_BASEADDR
#define INTC_PRESENT
//#define PIC_BASEADDR            0xDEADBEEF
// FSMLang Special PIC (CBIS) Definition
//#define CBIS_BASEADDR    XPAR_PLB_FSMLANG_SPECIAL_PIC_0_BASEADDR
#define CBIS_BASEADDR           0xDEADBEEF
// Interrupt Mask Definitions
#define DECISION_INTR_MASK      #error( "No Decision Interrrupt Defined" )
#define TIMER1_INTR_MASK        XPAR_XPS_TIMER_0_INTERRUPT_MASK
//#define TIMER1_INTR_MASK        #error( "No Timer1 Interrupt Defined" )
#define TIMER2_INTR_MASK        #error( "No Timer2 Interrupt Defined" )
#define ACCESS_INTR_MASK        XPAR_THREAD_MANAGER_ACCESS_INTR_MASK
#ifdef HTHREADS_SMP
#define PREEMPT_0_INTR_MASK     XPAR_UTIL_INTR_SPLIT_0_OUT1_MASK
#define PREEMPT_1_INTR_MASK     XPAR_UTIL_INTR_SPLIT_0_OUT2_MASK
#else
#define PREEMPT_INTR_MASK       XPAR_SCHEDULER_PREEMPTION_INTERRUPT_MASK
#endif
//DMA Base Address
#define DMA_BASEADDR            XPAR_XPS_CENTRAL_DMA_0_BASEADDR
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

// Support for timeslicing
#define TIMESLICING

// Support for ICAP
#define ICAP
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
