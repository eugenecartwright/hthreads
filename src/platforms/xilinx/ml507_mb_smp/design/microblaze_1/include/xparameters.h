
/*******************************************************************
*
* CAUTION: This file is automatically generated by libgen.
* Version: Xilinx EDK 10.1.03 EDK_K_SP3.6
* DO NOT EDIT.
*
* Copyright (c) 2005 Xilinx, Inc.  All rights reserved. 
* 
* Description: Driver parameters
*
*******************************************************************/

#define STDIN_BASEADDRESS 0x84000000
#define STDOUT_BASEADDRESS 0x84000000

/******************************************************************/


/* Definitions for peripheral DLMB_CNTLR1 */
#define XPAR_DLMB_CNTLR1_BASEADDR 0x00000000
#define XPAR_DLMB_CNTLR1_HIGHADDR 0x0000FFFF


/* Definitions for peripheral ILMB_CNTLR1 */
#define XPAR_ILMB_CNTLR1_BASEADDR 0x00000000
#define XPAR_ILMB_CNTLR1_HIGHADDR 0x0000FFFF


/******************************************************************/

#define XPAR_INTC_MAX_NUM_INTR_INPUTS 4
#define XPAR_XINTC_HAS_IPR 1
#define XPAR_XINTC_USE_DCR 0
/* Definitions for driver INTC */
#define XPAR_XINTC_NUM_INSTANCES 2

/* Definitions for peripheral XPS_INTC_0 */
#define XPAR_XPS_INTC_0_DEVICE_ID 0
#define XPAR_XPS_INTC_0_BASEADDR 0x81800000
#define XPAR_XPS_INTC_0_HIGHADDR 0x8180FFFF
#define XPAR_XPS_INTC_0_KIND_OF_INTR 0x00000007


/* Definitions for peripheral XPS_INTC_1 */
#define XPAR_XPS_INTC_1_DEVICE_ID 1
#define XPAR_XPS_INTC_1_BASEADDR 0x81900000
#define XPAR_XPS_INTC_1_HIGHADDR 0x8190FFFF
#define XPAR_XPS_INTC_1_KIND_OF_INTR 0x00000007


/******************************************************************/

#define XPAR_THREAD_MANAGER_ACCESS_INTR_MASK 0X000001
#define XPAR_XPS_INTC_0_THREAD_MANAGER_ACCESS_INTR_INTR 0
#define XPAR_UTIL_INTR_SPLIT_0_OUT1_MASK 0X000002
#define XPAR_XPS_INTC_0_UTIL_INTR_SPLIT_0_OUT1_INTR 1
#define XPAR_UTIL_INTR_SPLIT_0_OUT2_MASK 0X000004
#define XPAR_XPS_INTC_0_UTIL_INTR_SPLIT_0_OUT2_INTR 2
#define XPAR_XPS_TIMER_1_INTERRUPT_MASK 0X000008
#define XPAR_XPS_INTC_0_XPS_TIMER_1_INTERRUPT_INTR 3

/******************************************************************/

#define XPAR_THREAD_MANAGER_ACCESS_INTR_MASK 0X000001
#define XPAR_XPS_INTC_1_THREAD_MANAGER_ACCESS_INTR_INTR 0
#define XPAR_UTIL_INTR_SPLIT_0_OUT1_MASK 0X000002
#define XPAR_XPS_INTC_1_UTIL_INTR_SPLIT_0_OUT1_INTR 1
#define XPAR_UTIL_INTR_SPLIT_0_OUT2_MASK 0X000004
#define XPAR_XPS_INTC_1_UTIL_INTR_SPLIT_0_OUT2_INTR 2
#define XPAR_XPS_TIMER_1_INTERRUPT_MASK 0X000008
#define XPAR_XPS_INTC_1_XPS_TIMER_1_INTERRUPT_INTR 3

/******************************************************************/


/* Canonical definitions for peripheral XPS_INTC_0 */
#define XPAR_INTC_0_DEVICE_ID XPAR_XPS_INTC_0_DEVICE_ID
#define XPAR_INTC_0_BASEADDR 0x81800000
#define XPAR_INTC_0_HIGHADDR 0x8180FFFF
#define XPAR_INTC_0_KIND_OF_INTR 0x00000007


/* Canonical definitions for peripheral XPS_INTC_1 */
#define XPAR_INTC_1_DEVICE_ID XPAR_XPS_INTC_1_DEVICE_ID
#define XPAR_INTC_1_BASEADDR 0x81900000
#define XPAR_INTC_1_HIGHADDR 0x8190FFFF
#define XPAR_INTC_1_KIND_OF_INTR 0x00000007

#define XPAR_INTC_0_TMRCTR_0_VEC_ID XPAR_XPS_INTC_0_XPS_TIMER_1_INTERRUPT_INTR
#define XPAR_INTC_1_TMRCTR_0_INTERRUPT_VEC_ID XPAR_XPS_INTC_1_XPS_TIMER_1_INTERRUPT_INTR

/******************************************************************/

/* Definitions for driver UARTLITE */
#define XPAR_XUARTLITE_NUM_INSTANCES 2

/* Definitions for peripheral RS232_UART_1 */
#define XPAR_RS232_UART_1_BASEADDR 0x84000000
#define XPAR_RS232_UART_1_HIGHADDR 0x8400FFFF
#define XPAR_RS232_UART_1_DEVICE_ID 0
#define XPAR_RS232_UART_1_BAUDRATE 9600
#define XPAR_RS232_UART_1_USE_PARITY 0
#define XPAR_RS232_UART_1_ODD_PARITY 0
#define XPAR_RS232_UART_1_DATA_BITS 8


/* Definitions for peripheral DEBUG_MODULE */
#define XPAR_DEBUG_MODULE_BASEADDR 0x84400000
#define XPAR_DEBUG_MODULE_HIGHADDR 0x8440FFFF
#define XPAR_DEBUG_MODULE_DEVICE_ID 1
#define XPAR_DEBUG_MODULE_BAUDRATE 0
#define XPAR_DEBUG_MODULE_USE_PARITY 0
#define XPAR_DEBUG_MODULE_ODD_PARITY 0
#define XPAR_DEBUG_MODULE_DATA_BITS 0


/******************************************************************/


/* Canonical definitions for peripheral RS232_UART_1 */
#define XPAR_UARTLITE_0_DEVICE_ID XPAR_RS232_UART_1_DEVICE_ID
#define XPAR_UARTLITE_0_BASEADDR 0x84000000
#define XPAR_UARTLITE_0_HIGHADDR 0x8400FFFF
#define XPAR_UARTLITE_0_BAUDRATE 9600
#define XPAR_UARTLITE_0_USE_PARITY 0
#define XPAR_UARTLITE_0_ODD_PARITY 0
#define XPAR_UARTLITE_0_DATA_BITS 8
#define XPAR_UARTLITE_0_SIO_CHAN 0


/* Canonical definitions for peripheral DEBUG_MODULE */
#define XPAR_UARTLITE_1_DEVICE_ID XPAR_DEBUG_MODULE_DEVICE_ID
#define XPAR_UARTLITE_1_BASEADDR 0x84400000
#define XPAR_UARTLITE_1_HIGHADDR 0x8440FFFF
#define XPAR_UARTLITE_1_BAUDRATE 0
#define XPAR_UARTLITE_1_USE_PARITY 0
#define XPAR_UARTLITE_1_ODD_PARITY 0
#define XPAR_UARTLITE_1_DATA_BITS 0
#define XPAR_UARTLITE_1_SIO_CHAN -1


/******************************************************************/

/* Definitions for driver GPIO */
#define XPAR_XGPIO_NUM_INSTANCES 1

/* Definitions for peripheral LEDS_8BIT */
#define XPAR_LEDS_8BIT_BASEADDR 0x81400000
#define XPAR_LEDS_8BIT_HIGHADDR 0x8140FFFF
#define XPAR_LEDS_8BIT_DEVICE_ID 0
#define XPAR_LEDS_8BIT_INTERRUPT_PRESENT 0
#define XPAR_LEDS_8BIT_IS_DUAL 0


/******************************************************************/


/* Definitions for peripheral SRAM */
#define XPAR_SRAM_NUM_BANKS_MEM 1


/******************************************************************/

/* Definitions for peripheral SRAM */
#define XPAR_SRAM_MEM0_BASEADDR 0x8A300000
#define XPAR_SRAM_MEM0_HIGHADDR 0x8A3FFFFF

/******************************************************************/

/* Definitions for driver MPMC */
#define XPAR_XMPMC_NUM_INSTANCES 1

/* Definitions for peripheral DDR2_SDRAM */
#define XPAR_DDR2_SDRAM_DEVICE_ID 0
#define XPAR_DDR2_SDRAM_MPMC_BASEADDR 0x90000000
#define XPAR_DDR2_SDRAM_MPMC_CTRL_BASEADDR 0xFFFFFFFF
#define XPAR_DDR2_SDRAM_INCLUDE_ECC_SUPPORT 0
#define XPAR_DDR2_SDRAM_USE_STATIC_PHY 0
#define XPAR_DDR2_SDRAM_PM_ENABLE 0
#define XPAR_DDR2_SDRAM_NUM_PORTS 5


/******************************************************************/


/* Definitions for peripheral DDR2_SDRAM */
#define XPAR_DDR2_SDRAM_MPMC_BASEADDR 0x90000000
#define XPAR_DDR2_SDRAM_MPMC_HIGHADDR 0x9FFFFFFF


/******************************************************************/


/* Canonical definitions for peripheral DDR2_SDRAM */
#define XPAR_MPMC_0_DEVICE_ID XPAR_DDR2_SDRAM_DEVICE_ID
#define XPAR_MPMC_0_MPMC_BASEADDR 0x90000000
#define XPAR_MPMC_0_MPMC_CTRL_BASEADDR 0xFFFFFFFF
#define XPAR_MPMC_0_INCLUDE_ECC_SUPPORT 0
#define XPAR_MPMC_0_USE_STATIC_PHY 0
#define XPAR_MPMC_0_PM_ENABLE 0
#define XPAR_MPMC_0_NUM_PORTS 5


/******************************************************************/

/* Definitions for driver TMRCTR */
#define XPAR_XTMRCTR_NUM_INSTANCES 1

/* Definitions for peripheral XPS_TIMER_1 */
#define XPAR_XPS_TIMER_1_DEVICE_ID 0
#define XPAR_XPS_TIMER_1_BASEADDR 0x83C00000
#define XPAR_XPS_TIMER_1_HIGHADDR 0x83C0FFFF


/******************************************************************/


/* Canonical definitions for peripheral XPS_TIMER_1 */
#define XPAR_TMRCTR_0_DEVICE_ID XPAR_XPS_TIMER_1_DEVICE_ID
#define XPAR_TMRCTR_0_BASEADDR 0x83C00000
#define XPAR_TMRCTR_0_HIGHADDR 0x83C0FFFF


/******************************************************************/


/* Definitions for peripheral SCHEDULER */
#define XPAR_SCHEDULER_BASEADDR 0x12000000
#define XPAR_SCHEDULER_HIGHADDR 0x12FFFFFF


/* Definitions for peripheral THREAD_MANAGER */
#define XPAR_THREAD_MANAGER_BASEADDR 0x11000000
#define XPAR_THREAD_MANAGER_HIGHADDR 0x1103FFFF


/* Definitions for peripheral SYNCH_MANAGER */
#define XPAR_SYNCH_MANAGER_BASEADDR 0x13000000
#define XPAR_SYNCH_MANAGER_HIGHADDR 0x13FFFFFF


/* Definitions for peripheral COND_VARS */
#define XPAR_COND_VARS_BASEADDR 0x11100000
#define XPAR_COND_VARS_HIGHADDR 0x1117FFFF


/* Definitions for peripheral PLB_HTHREAD_RESET_CORE_0 */
#define XPAR_PLB_HTHREAD_RESET_CORE_0_BASEADDR 0x81200000
#define XPAR_PLB_HTHREAD_RESET_CORE_0_HIGHADDR 0x812001FF


/* Definitions for peripheral PLB_HTHREADS_TIMER_0 */
#define XPAR_PLB_HTHREADS_TIMER_0_BASEADDR 0x82000000
#define XPAR_PLB_HTHREADS_TIMER_0_HIGHADDR 0x820001FF


/******************************************************************/

#define XPAR_CPU_CORE_CLOCK_FREQ_HZ 125000000

/******************************************************************/


/* Definitions for peripheral MICROBLAZE_1 */
#define XPAR_MICROBLAZE_1_SCO 0
#define XPAR_MICROBLAZE_1_DATA_SIZE 32
#define XPAR_MICROBLAZE_1_DYNAMIC_BUS_SIZING 1
#define XPAR_MICROBLAZE_1_AREA_OPTIMIZED 0
#define XPAR_MICROBLAZE_1_INTERCONNECT 1
#define XPAR_MICROBLAZE_1_DPLB_DWIDTH 64
#define XPAR_MICROBLAZE_1_DPLB_NATIVE_DWIDTH 32
#define XPAR_MICROBLAZE_1_DPLB_BURST_EN 0
#define XPAR_MICROBLAZE_1_DPLB_P2P 0
#define XPAR_MICROBLAZE_1_IPLB_DWIDTH 64
#define XPAR_MICROBLAZE_1_IPLB_NATIVE_DWIDTH 32
#define XPAR_MICROBLAZE_1_IPLB_BURST_EN 0
#define XPAR_MICROBLAZE_1_IPLB_P2P 0
#define XPAR_MICROBLAZE_1_D_PLB 1
#define XPAR_MICROBLAZE_1_D_OPB 0
#define XPAR_MICROBLAZE_1_D_LMB 1
#define XPAR_MICROBLAZE_1_I_PLB 1
#define XPAR_MICROBLAZE_1_I_OPB 0
#define XPAR_MICROBLAZE_1_I_LMB 1
#define XPAR_MICROBLAZE_1_USE_MSR_INSTR 1
#define XPAR_MICROBLAZE_1_USE_PCMP_INSTR 1
#define XPAR_MICROBLAZE_1_USE_BARREL 0
#define XPAR_MICROBLAZE_1_USE_DIV 1
#define XPAR_MICROBLAZE_1_USE_HW_MUL 1
#define XPAR_MICROBLAZE_1_USE_FPU 1
#define XPAR_MICROBLAZE_1_UNALIGNED_EXCEPTIONS 0
#define XPAR_MICROBLAZE_1_ILL_OPCODE_EXCEPTION 0
#define XPAR_MICROBLAZE_1_IOPB_BUS_EXCEPTION 0
#define XPAR_MICROBLAZE_1_DOPB_BUS_EXCEPTION 0
#define XPAR_MICROBLAZE_1_IPLB_BUS_EXCEPTION 0
#define XPAR_MICROBLAZE_1_DPLB_BUS_EXCEPTION 0
#define XPAR_MICROBLAZE_1_DIV_ZERO_EXCEPTION 0
#define XPAR_MICROBLAZE_1_FPU_EXCEPTION 0
#define XPAR_MICROBLAZE_1_FSL_EXCEPTION 0
#define XPAR_MICROBLAZE_1_PVR 2
#define XPAR_MICROBLAZE_1_PVR_USER1 0x00
#define XPAR_MICROBLAZE_1_PVR_USER2 0x00000001
#define XPAR_MICROBLAZE_1_DEBUG_ENABLED 1
#define XPAR_MICROBLAZE_1_NUMBER_OF_PC_BRK 1
#define XPAR_MICROBLAZE_1_NUMBER_OF_RD_ADDR_BRK 0
#define XPAR_MICROBLAZE_1_NUMBER_OF_WR_ADDR_BRK 0
#define XPAR_MICROBLAZE_1_INTERRUPT_IS_EDGE 0
#define XPAR_MICROBLAZE_1_EDGE_IS_POSITIVE 1
#define XPAR_MICROBLAZE_1_RESET_MSR 0x00000000
#define XPAR_MICROBLAZE_1_OPCODE_0X0_ILLEGAL 0
#define XPAR_MICROBLAZE_1_FSL_LINKS 0
#define XPAR_MICROBLAZE_1_FSL_DATA_SIZE 32
#define XPAR_MICROBLAZE_1_USE_EXTENDED_FSL_INSTR 0
#define XPAR_MICROBLAZE_1_ICACHE_BASEADDR 0x90000000
#define XPAR_MICROBLAZE_1_ICACHE_HIGHADDR 0x9FFFFFFF
#define XPAR_MICROBLAZE_1_USE_ICACHE 1
#define XPAR_MICROBLAZE_1_ALLOW_ICACHE_WR 1
#define XPAR_MICROBLAZE_1_ADDR_TAG_BITS 17
#define XPAR_MICROBLAZE_1_CACHE_BYTE_SIZE 2048
#define XPAR_MICROBLAZE_1_ICACHE_USE_FSL 1
#define XPAR_MICROBLAZE_1_ICACHE_LINE_LEN 4
#define XPAR_MICROBLAZE_1_ICACHE_ALWAYS_USED 0
#define XPAR_MICROBLAZE_1_DCACHE_BASEADDR 0x90000000
#define XPAR_MICROBLAZE_1_DCACHE_HIGHADDR 0x9FFFFFFF
#define XPAR_MICROBLAZE_1_USE_DCACHE 1
#define XPAR_MICROBLAZE_1_ALLOW_DCACHE_WR 1
#define XPAR_MICROBLAZE_1_DCACHE_ADDR_TAG 16
#define XPAR_MICROBLAZE_1_DCACHE_BYTE_SIZE 4096
#define XPAR_MICROBLAZE_1_DCACHE_USE_FSL 1
#define XPAR_MICROBLAZE_1_DCACHE_LINE_LEN 4
#define XPAR_MICROBLAZE_1_DCACHE_ALWAYS_USED 0
#define XPAR_MICROBLAZE_1_USE_MMU 0
#define XPAR_MICROBLAZE_1_MMU_DTLB_SIZE 4
#define XPAR_MICROBLAZE_1_MMU_ITLB_SIZE 2
#define XPAR_MICROBLAZE_1_MMU_TLB_ACCESS 3
#define XPAR_MICROBLAZE_1_MMU_ZONES 16
#define XPAR_MICROBLAZE_1_USE_INTERRUPT 1
#define XPAR_MICROBLAZE_1_USE_EXT_BRK 1
#define XPAR_MICROBLAZE_1_USE_EXT_NM_BRK 1

/******************************************************************/

#define XPAR_CPU_ID 0
#define XPAR_MICROBLAZE_ID 0
#define XPAR_MICROBLAZE_CORE_CLOCK_FREQ_HZ 100000000
#define XPAR_MICROBLAZE_SCO 0
#define XPAR_MICROBLAZE_DATA_SIZE 32
#define XPAR_MICROBLAZE_DYNAMIC_BUS_SIZING 1
#define XPAR_MICROBLAZE_AREA_OPTIMIZED 0
#define XPAR_MICROBLAZE_INTERCONNECT 1
#define XPAR_MICROBLAZE_DPLB_DWIDTH 64
#define XPAR_MICROBLAZE_DPLB_NATIVE_DWIDTH 32
#define XPAR_MICROBLAZE_DPLB_BURST_EN 0
#define XPAR_MICROBLAZE_DPLB_P2P 0
#define XPAR_MICROBLAZE_IPLB_DWIDTH 64
#define XPAR_MICROBLAZE_IPLB_NATIVE_DWIDTH 32
#define XPAR_MICROBLAZE_IPLB_BURST_EN 0
#define XPAR_MICROBLAZE_IPLB_P2P 0
#define XPAR_MICROBLAZE_D_PLB 1
#define XPAR_MICROBLAZE_D_OPB 0
#define XPAR_MICROBLAZE_D_LMB 1
#define XPAR_MICROBLAZE_I_PLB 1
#define XPAR_MICROBLAZE_I_OPB 0
#define XPAR_MICROBLAZE_I_LMB 1
#define XPAR_MICROBLAZE_USE_MSR_INSTR 1
#define XPAR_MICROBLAZE_USE_PCMP_INSTR 1
#define XPAR_MICROBLAZE_USE_BARREL 0
#define XPAR_MICROBLAZE_USE_DIV 1
#define XPAR_MICROBLAZE_USE_HW_MUL 1
#define XPAR_MICROBLAZE_USE_FPU 1
#define XPAR_MICROBLAZE_UNALIGNED_EXCEPTIONS 0
#define XPAR_MICROBLAZE_ILL_OPCODE_EXCEPTION 0
#define XPAR_MICROBLAZE_IOPB_BUS_EXCEPTION 0
#define XPAR_MICROBLAZE_DOPB_BUS_EXCEPTION 0
#define XPAR_MICROBLAZE_IPLB_BUS_EXCEPTION 0
#define XPAR_MICROBLAZE_DPLB_BUS_EXCEPTION 0
#define XPAR_MICROBLAZE_DIV_ZERO_EXCEPTION 0
#define XPAR_MICROBLAZE_FPU_EXCEPTION 0
#define XPAR_MICROBLAZE_FSL_EXCEPTION 0
#define XPAR_MICROBLAZE_PVR 2
#define XPAR_MICROBLAZE_PVR_USER1 0x00
#define XPAR_MICROBLAZE_PVR_USER2 0x00000001
#define XPAR_MICROBLAZE_DEBUG_ENABLED 1
#define XPAR_MICROBLAZE_NUMBER_OF_PC_BRK 1
#define XPAR_MICROBLAZE_NUMBER_OF_RD_ADDR_BRK 0
#define XPAR_MICROBLAZE_NUMBER_OF_WR_ADDR_BRK 0
#define XPAR_MICROBLAZE_INTERRUPT_IS_EDGE 0
#define XPAR_MICROBLAZE_EDGE_IS_POSITIVE 1
#define XPAR_MICROBLAZE_RESET_MSR 0x00000000
#define XPAR_MICROBLAZE_OPCODE_0X0_ILLEGAL 0
#define XPAR_MICROBLAZE_FSL_LINKS 0
#define XPAR_MICROBLAZE_FSL_DATA_SIZE 32
#define XPAR_MICROBLAZE_USE_EXTENDED_FSL_INSTR 0
#define XPAR_MICROBLAZE_ICACHE_BASEADDR 0x90000000
#define XPAR_MICROBLAZE_ICACHE_HIGHADDR 0x9FFFFFFF
#define XPAR_MICROBLAZE_USE_ICACHE 1
#define XPAR_MICROBLAZE_ALLOW_ICACHE_WR 1
#define XPAR_MICROBLAZE_ADDR_TAG_BITS 17
#define XPAR_MICROBLAZE_CACHE_BYTE_SIZE 2048
#define XPAR_MICROBLAZE_ICACHE_USE_FSL 1
#define XPAR_MICROBLAZE_ICACHE_LINE_LEN 4
#define XPAR_MICROBLAZE_ICACHE_ALWAYS_USED 0
#define XPAR_MICROBLAZE_DCACHE_BASEADDR 0x90000000
#define XPAR_MICROBLAZE_DCACHE_HIGHADDR 0x9FFFFFFF
#define XPAR_MICROBLAZE_USE_DCACHE 1
#define XPAR_MICROBLAZE_ALLOW_DCACHE_WR 1
#define XPAR_MICROBLAZE_DCACHE_ADDR_TAG 16
#define XPAR_MICROBLAZE_DCACHE_BYTE_SIZE 4096
#define XPAR_MICROBLAZE_DCACHE_USE_FSL 1
#define XPAR_MICROBLAZE_DCACHE_LINE_LEN 4
#define XPAR_MICROBLAZE_DCACHE_ALWAYS_USED 0
#define XPAR_MICROBLAZE_USE_MMU 0
#define XPAR_MICROBLAZE_MMU_DTLB_SIZE 4
#define XPAR_MICROBLAZE_MMU_ITLB_SIZE 2
#define XPAR_MICROBLAZE_MMU_TLB_ACCESS 3
#define XPAR_MICROBLAZE_MMU_ZONES 16
#define XPAR_MICROBLAZE_USE_INTERRUPT 1
#define XPAR_MICROBLAZE_USE_EXT_BRK 1
#define XPAR_MICROBLAZE_USE_EXT_NM_BRK 1
#define XPAR_MICROBLAZE_HW_VER "7.10.d"

/******************************************************************/

