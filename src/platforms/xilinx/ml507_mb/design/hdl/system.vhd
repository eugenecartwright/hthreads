-------------------------------------------------------------------------------
-- system.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity system is
  port (
    fpga_0_RS232_Uart_1_RX_pin : in std_logic;
    fpga_0_RS232_Uart_1_TX_pin : out std_logic;
    fpga_0_LEDs_8Bit_GPIO_IO_pin : inout std_logic_vector(0 to 7);
    fpga_0_SRAM_Mem_A_pin : out std_logic_vector(7 to 30);
    fpga_0_SRAM_Mem_DQ_pin : inout std_logic_vector(0 to 31);
    fpga_0_SRAM_Mem_BEN_pin : out std_logic_vector(0 to 3);
    fpga_0_SRAM_Mem_OEN_pin : out std_logic;
    fpga_0_SRAM_Mem_CEN_pin : out std_logic;
    fpga_0_SRAM_Mem_ADV_LDN_pin : out std_logic;
    fpga_0_SRAM_Mem_WEN_pin : out std_logic;
    fpga_0_DDR2_SDRAM_DDR2_ODT_pin : out std_logic_vector(1 downto 0);
    fpga_0_DDR2_SDRAM_DDR2_Addr_pin : out std_logic_vector(12 downto 0);
    fpga_0_DDR2_SDRAM_DDR2_BankAddr_pin : out std_logic_vector(1 downto 0);
    fpga_0_DDR2_SDRAM_DDR2_CAS_n_pin : out std_logic;
    fpga_0_DDR2_SDRAM_DDR2_CE_pin : out std_logic_vector(0 to 0);
    fpga_0_DDR2_SDRAM_DDR2_CS_n_pin : out std_logic_vector(0 to 0);
    fpga_0_DDR2_SDRAM_DDR2_RAS_n_pin : out std_logic;
    fpga_0_DDR2_SDRAM_DDR2_WE_n_pin : out std_logic;
    fpga_0_DDR2_SDRAM_DDR2_Clk_pin : out std_logic_vector(1 downto 0);
    fpga_0_DDR2_SDRAM_DDR2_Clk_n_pin : out std_logic_vector(1 downto 0);
    fpga_0_DDR2_SDRAM_DDR2_DM_pin : out std_logic_vector(7 downto 0);
    fpga_0_DDR2_SDRAM_DDR2_DQS : inout std_logic_vector(7 downto 0);
    fpga_0_DDR2_SDRAM_DDR2_DQS_n : inout std_logic_vector(7 downto 0);
    fpga_0_DDR2_SDRAM_DDR2_DQ : inout std_logic_vector(63 downto 0);
    fpga_0_SRAM_CLK : out std_logic;
    fpga_0_SRAM_CLK_FB : in std_logic;
    sys_clk_pin : in std_logic;
    sys_rst_pin : in std_logic
  );
end system;

architecture STRUCTURE of system is

  component microblaze_0_wrapper is
    port (
      CLK : in std_logic;
      RESET : in std_logic;
      MB_RESET : in std_logic;
      INTERRUPT : in std_logic;
      EXT_BRK : in std_logic;
      EXT_NM_BRK : in std_logic;
      DBG_STOP : in std_logic;
      MB_Halted : out std_logic;
      INSTR : in std_logic_vector(0 to 31);
      I_ADDRTAG : out std_logic_vector(0 to 3);
      IREADY : in std_logic;
      IWAIT : in std_logic;
      INSTR_ADDR : out std_logic_vector(0 to 31);
      IFETCH : out std_logic;
      I_AS : out std_logic;
      IPLB_M_ABort : out std_logic;
      IPLB_M_ABus : out std_logic_vector(0 to 31);
      IPLB_M_UABus : out std_logic_vector(0 to 31);
      IPLB_M_BE : out std_logic_vector(0 to 7);
      IPLB_M_busLock : out std_logic;
      IPLB_M_lockErr : out std_logic;
      IPLB_M_MSize : out std_logic_vector(0 to 1);
      IPLB_M_priority : out std_logic_vector(0 to 1);
      IPLB_M_rdBurst : out std_logic;
      IPLB_M_request : out std_logic;
      IPLB_M_RNW : out std_logic;
      IPLB_M_size : out std_logic_vector(0 to 3);
      IPLB_M_TAttribute : out std_logic_vector(0 to 15);
      IPLB_M_type : out std_logic_vector(0 to 2);
      IPLB_M_wrBurst : out std_logic;
      IPLB_M_wrDBus : out std_logic_vector(0 to 63);
      IPLB_MBusy : in std_logic;
      IPLB_MRdErr : in std_logic;
      IPLB_MWrErr : in std_logic;
      IPLB_MIRQ : in std_logic;
      IPLB_MWrBTerm : in std_logic;
      IPLB_MWrDAck : in std_logic;
      IPLB_MAddrAck : in std_logic;
      IPLB_MRdBTerm : in std_logic;
      IPLB_MRdDAck : in std_logic;
      IPLB_MRdDBus : in std_logic_vector(0 to 63);
      IPLB_MRdWdAddr : in std_logic_vector(0 to 3);
      IPLB_MRearbitrate : in std_logic;
      IPLB_MSSize : in std_logic_vector(0 to 1);
      IPLB_MTimeout : in std_logic;
      DATA_READ : in std_logic_vector(0 to 31);
      DREADY : in std_logic;
      DWAIT : in std_logic;
      DATA_WRITE : out std_logic_vector(0 to 31);
      DATA_ADDR : out std_logic_vector(0 to 31);
      D_ADDRTAG : out std_logic_vector(0 to 3);
      D_AS : out std_logic;
      READ_STROBE : out std_logic;
      WRITE_STROBE : out std_logic;
      BYTE_ENABLE : out std_logic_vector(0 to 3);
      DM_ABUS : out std_logic_vector(0 to 31);
      DM_BE : out std_logic_vector(0 to 3);
      DM_BUSLOCK : out std_logic;
      DM_DBUS : out std_logic_vector(0 to 31);
      DM_REQUEST : out std_logic;
      DM_RNW : out std_logic;
      DM_SELECT : out std_logic;
      DM_SEQADDR : out std_logic;
      DOPB_DBUS : in std_logic_vector(0 to 31);
      DOPB_ERRACK : in std_logic;
      DOPB_MGRANT : in std_logic;
      DOPB_RETRY : in std_logic;
      DOPB_TIMEOUT : in std_logic;
      DOPB_XFERACK : in std_logic;
      DPLB_M_ABort : out std_logic;
      DPLB_M_ABus : out std_logic_vector(0 to 31);
      DPLB_M_UABus : out std_logic_vector(0 to 31);
      DPLB_M_BE : out std_logic_vector(0 to 7);
      DPLB_M_busLock : out std_logic;
      DPLB_M_lockErr : out std_logic;
      DPLB_M_MSize : out std_logic_vector(0 to 1);
      DPLB_M_priority : out std_logic_vector(0 to 1);
      DPLB_M_rdBurst : out std_logic;
      DPLB_M_request : out std_logic;
      DPLB_M_RNW : out std_logic;
      DPLB_M_size : out std_logic_vector(0 to 3);
      DPLB_M_TAttribute : out std_logic_vector(0 to 15);
      DPLB_M_type : out std_logic_vector(0 to 2);
      DPLB_M_wrBurst : out std_logic;
      DPLB_M_wrDBus : out std_logic_vector(0 to 63);
      DPLB_MBusy : in std_logic;
      DPLB_MRdErr : in std_logic;
      DPLB_MWrErr : in std_logic;
      DPLB_MIRQ : in std_logic;
      DPLB_MWrBTerm : in std_logic;
      DPLB_MWrDAck : in std_logic;
      DPLB_MAddrAck : in std_logic;
      DPLB_MRdBTerm : in std_logic;
      DPLB_MRdDAck : in std_logic;
      DPLB_MRdDBus : in std_logic_vector(0 to 63);
      DPLB_MRdWdAddr : in std_logic_vector(0 to 3);
      DPLB_MRearbitrate : in std_logic;
      DPLB_MSSize : in std_logic_vector(0 to 1);
      DPLB_MTimeout : in std_logic;
      IM_ABUS : out std_logic_vector(0 to 31);
      IM_BE : out std_logic_vector(0 to 3);
      IM_BUSLOCK : out std_logic;
      IM_DBUS : out std_logic_vector(0 to 31);
      IM_REQUEST : out std_logic;
      IM_RNW : out std_logic;
      IM_SELECT : out std_logic;
      IM_SEQADDR : out std_logic;
      IOPB_DBUS : in std_logic_vector(0 to 31);
      IOPB_ERRACK : in std_logic;
      IOPB_MGRANT : in std_logic;
      IOPB_RETRY : in std_logic;
      IOPB_TIMEOUT : in std_logic;
      IOPB_XFERACK : in std_logic;
      DBG_CLK : in std_logic;
      DBG_TDI : in std_logic;
      DBG_TDO : out std_logic;
      DBG_REG_EN : in std_logic_vector(0 to 4);
      DBG_SHIFT : in std_logic;
      DBG_CAPTURE : in std_logic;
      DBG_UPDATE : in std_logic;
      DEBUG_RST : in std_logic;
      Trace_Instruction : out std_logic_vector(0 to 31);
      Trace_Valid_Instr : out std_logic;
      Trace_PC : out std_logic_vector(0 to 31);
      Trace_Reg_Write : out std_logic;
      Trace_Reg_Addr : out std_logic_vector(0 to 4);
      Trace_MSR_Reg : out std_logic_vector(0 to 14);
      Trace_PID_Reg : out std_logic_vector(0 to 7);
      Trace_New_Reg_Value : out std_logic_vector(0 to 31);
      Trace_Exception_Taken : out std_logic;
      Trace_Exception_Kind : out std_logic_vector(0 to 4);
      Trace_Jump_Taken : out std_logic;
      Trace_Delay_Slot : out std_logic;
      Trace_Data_Address : out std_logic_vector(0 to 31);
      Trace_Data_Access : out std_logic;
      Trace_Data_Read : out std_logic;
      Trace_Data_Write : out std_logic;
      Trace_Data_Write_Value : out std_logic_vector(0 to 31);
      Trace_Data_Byte_Enable : out std_logic_vector(0 to 3);
      Trace_DCache_Req : out std_logic;
      Trace_DCache_Hit : out std_logic;
      Trace_ICache_Req : out std_logic;
      Trace_ICache_Hit : out std_logic;
      Trace_OF_PipeRun : out std_logic;
      Trace_EX_PipeRun : out std_logic;
      Trace_MEM_PipeRun : out std_logic;
      Trace_MB_Halted : out std_logic;
      FSL0_S_CLK : out std_logic;
      FSL0_S_READ : out std_logic;
      FSL0_S_DATA : in std_logic_vector(0 to 31);
      FSL0_S_CONTROL : in std_logic;
      FSL0_S_EXISTS : in std_logic;
      FSL0_M_CLK : out std_logic;
      FSL0_M_WRITE : out std_logic;
      FSL0_M_DATA : out std_logic_vector(0 to 31);
      FSL0_M_CONTROL : out std_logic;
      FSL0_M_FULL : in std_logic;
      FSL1_S_CLK : out std_logic;
      FSL1_S_READ : out std_logic;
      FSL1_S_DATA : in std_logic_vector(0 to 31);
      FSL1_S_CONTROL : in std_logic;
      FSL1_S_EXISTS : in std_logic;
      FSL1_M_CLK : out std_logic;
      FSL1_M_WRITE : out std_logic;
      FSL1_M_DATA : out std_logic_vector(0 to 31);
      FSL1_M_CONTROL : out std_logic;
      FSL1_M_FULL : in std_logic;
      FSL2_S_CLK : out std_logic;
      FSL2_S_READ : out std_logic;
      FSL2_S_DATA : in std_logic_vector(0 to 31);
      FSL2_S_CONTROL : in std_logic;
      FSL2_S_EXISTS : in std_logic;
      FSL2_M_CLK : out std_logic;
      FSL2_M_WRITE : out std_logic;
      FSL2_M_DATA : out std_logic_vector(0 to 31);
      FSL2_M_CONTROL : out std_logic;
      FSL2_M_FULL : in std_logic;
      FSL3_S_CLK : out std_logic;
      FSL3_S_READ : out std_logic;
      FSL3_S_DATA : in std_logic_vector(0 to 31);
      FSL3_S_CONTROL : in std_logic;
      FSL3_S_EXISTS : in std_logic;
      FSL3_M_CLK : out std_logic;
      FSL3_M_WRITE : out std_logic;
      FSL3_M_DATA : out std_logic_vector(0 to 31);
      FSL3_M_CONTROL : out std_logic;
      FSL3_M_FULL : in std_logic;
      FSL4_S_CLK : out std_logic;
      FSL4_S_READ : out std_logic;
      FSL4_S_DATA : in std_logic_vector(0 to 31);
      FSL4_S_CONTROL : in std_logic;
      FSL4_S_EXISTS : in std_logic;
      FSL4_M_CLK : out std_logic;
      FSL4_M_WRITE : out std_logic;
      FSL4_M_DATA : out std_logic_vector(0 to 31);
      FSL4_M_CONTROL : out std_logic;
      FSL4_M_FULL : in std_logic;
      FSL5_S_CLK : out std_logic;
      FSL5_S_READ : out std_logic;
      FSL5_S_DATA : in std_logic_vector(0 to 31);
      FSL5_S_CONTROL : in std_logic;
      FSL5_S_EXISTS : in std_logic;
      FSL5_M_CLK : out std_logic;
      FSL5_M_WRITE : out std_logic;
      FSL5_M_DATA : out std_logic_vector(0 to 31);
      FSL5_M_CONTROL : out std_logic;
      FSL5_M_FULL : in std_logic;
      FSL6_S_CLK : out std_logic;
      FSL6_S_READ : out std_logic;
      FSL6_S_DATA : in std_logic_vector(0 to 31);
      FSL6_S_CONTROL : in std_logic;
      FSL6_S_EXISTS : in std_logic;
      FSL6_M_CLK : out std_logic;
      FSL6_M_WRITE : out std_logic;
      FSL6_M_DATA : out std_logic_vector(0 to 31);
      FSL6_M_CONTROL : out std_logic;
      FSL6_M_FULL : in std_logic;
      FSL7_S_CLK : out std_logic;
      FSL7_S_READ : out std_logic;
      FSL7_S_DATA : in std_logic_vector(0 to 31);
      FSL7_S_CONTROL : in std_logic;
      FSL7_S_EXISTS : in std_logic;
      FSL7_M_CLK : out std_logic;
      FSL7_M_WRITE : out std_logic;
      FSL7_M_DATA : out std_logic_vector(0 to 31);
      FSL7_M_CONTROL : out std_logic;
      FSL7_M_FULL : in std_logic;
      FSL8_S_CLK : out std_logic;
      FSL8_S_READ : out std_logic;
      FSL8_S_DATA : in std_logic_vector(0 to 31);
      FSL8_S_CONTROL : in std_logic;
      FSL8_S_EXISTS : in std_logic;
      FSL8_M_CLK : out std_logic;
      FSL8_M_WRITE : out std_logic;
      FSL8_M_DATA : out std_logic_vector(0 to 31);
      FSL8_M_CONTROL : out std_logic;
      FSL8_M_FULL : in std_logic;
      FSL9_S_CLK : out std_logic;
      FSL9_S_READ : out std_logic;
      FSL9_S_DATA : in std_logic_vector(0 to 31);
      FSL9_S_CONTROL : in std_logic;
      FSL9_S_EXISTS : in std_logic;
      FSL9_M_CLK : out std_logic;
      FSL9_M_WRITE : out std_logic;
      FSL9_M_DATA : out std_logic_vector(0 to 31);
      FSL9_M_CONTROL : out std_logic;
      FSL9_M_FULL : in std_logic;
      FSL10_S_CLK : out std_logic;
      FSL10_S_READ : out std_logic;
      FSL10_S_DATA : in std_logic_vector(0 to 31);
      FSL10_S_CONTROL : in std_logic;
      FSL10_S_EXISTS : in std_logic;
      FSL10_M_CLK : out std_logic;
      FSL10_M_WRITE : out std_logic;
      FSL10_M_DATA : out std_logic_vector(0 to 31);
      FSL10_M_CONTROL : out std_logic;
      FSL10_M_FULL : in std_logic;
      FSL11_S_CLK : out std_logic;
      FSL11_S_READ : out std_logic;
      FSL11_S_DATA : in std_logic_vector(0 to 31);
      FSL11_S_CONTROL : in std_logic;
      FSL11_S_EXISTS : in std_logic;
      FSL11_M_CLK : out std_logic;
      FSL11_M_WRITE : out std_logic;
      FSL11_M_DATA : out std_logic_vector(0 to 31);
      FSL11_M_CONTROL : out std_logic;
      FSL11_M_FULL : in std_logic;
      FSL12_S_CLK : out std_logic;
      FSL12_S_READ : out std_logic;
      FSL12_S_DATA : in std_logic_vector(0 to 31);
      FSL12_S_CONTROL : in std_logic;
      FSL12_S_EXISTS : in std_logic;
      FSL12_M_CLK : out std_logic;
      FSL12_M_WRITE : out std_logic;
      FSL12_M_DATA : out std_logic_vector(0 to 31);
      FSL12_M_CONTROL : out std_logic;
      FSL12_M_FULL : in std_logic;
      FSL13_S_CLK : out std_logic;
      FSL13_S_READ : out std_logic;
      FSL13_S_DATA : in std_logic_vector(0 to 31);
      FSL13_S_CONTROL : in std_logic;
      FSL13_S_EXISTS : in std_logic;
      FSL13_M_CLK : out std_logic;
      FSL13_M_WRITE : out std_logic;
      FSL13_M_DATA : out std_logic_vector(0 to 31);
      FSL13_M_CONTROL : out std_logic;
      FSL13_M_FULL : in std_logic;
      FSL14_S_CLK : out std_logic;
      FSL14_S_READ : out std_logic;
      FSL14_S_DATA : in std_logic_vector(0 to 31);
      FSL14_S_CONTROL : in std_logic;
      FSL14_S_EXISTS : in std_logic;
      FSL14_M_CLK : out std_logic;
      FSL14_M_WRITE : out std_logic;
      FSL14_M_DATA : out std_logic_vector(0 to 31);
      FSL14_M_CONTROL : out std_logic;
      FSL14_M_FULL : in std_logic;
      FSL15_S_CLK : out std_logic;
      FSL15_S_READ : out std_logic;
      FSL15_S_DATA : in std_logic_vector(0 to 31);
      FSL15_S_CONTROL : in std_logic;
      FSL15_S_EXISTS : in std_logic;
      FSL15_M_CLK : out std_logic;
      FSL15_M_WRITE : out std_logic;
      FSL15_M_DATA : out std_logic_vector(0 to 31);
      FSL15_M_CONTROL : out std_logic;
      FSL15_M_FULL : in std_logic;
      ICACHE_FSL_IN_CLK : out std_logic;
      ICACHE_FSL_IN_READ : out std_logic;
      ICACHE_FSL_IN_DATA : in std_logic_vector(0 to 31);
      ICACHE_FSL_IN_CONTROL : in std_logic;
      ICACHE_FSL_IN_EXISTS : in std_logic;
      ICACHE_FSL_OUT_CLK : out std_logic;
      ICACHE_FSL_OUT_WRITE : out std_logic;
      ICACHE_FSL_OUT_DATA : out std_logic_vector(0 to 31);
      ICACHE_FSL_OUT_CONTROL : out std_logic;
      ICACHE_FSL_OUT_FULL : in std_logic;
      DCACHE_FSL_IN_CLK : out std_logic;
      DCACHE_FSL_IN_READ : out std_logic;
      DCACHE_FSL_IN_DATA : in std_logic_vector(0 to 31);
      DCACHE_FSL_IN_CONTROL : in std_logic;
      DCACHE_FSL_IN_EXISTS : in std_logic;
      DCACHE_FSL_OUT_CLK : out std_logic;
      DCACHE_FSL_OUT_WRITE : out std_logic;
      DCACHE_FSL_OUT_DATA : out std_logic_vector(0 to 31);
      DCACHE_FSL_OUT_CONTROL : out std_logic;
      DCACHE_FSL_OUT_FULL : in std_logic
    );
  end component;

  component mb_plb_wrapper is
    port (
      PLB_Clk : in std_logic;
      SYS_Rst : in std_logic;
      PLB_Rst : out std_logic;
      SPLB_Rst : out std_logic_vector(0 to 10);
      MPLB_Rst : out std_logic_vector(0 to 1);
      PLB_dcrAck : out std_logic;
      PLB_dcrDBus : out std_logic_vector(0 to 31);
      DCR_ABus : in std_logic_vector(0 to 9);
      DCR_DBus : in std_logic_vector(0 to 31);
      DCR_Read : in std_logic;
      DCR_Write : in std_logic;
      M_ABus : in std_logic_vector(0 to 63);
      M_UABus : in std_logic_vector(0 to 63);
      M_BE : in std_logic_vector(0 to 15);
      M_RNW : in std_logic_vector(0 to 1);
      M_abort : in std_logic_vector(0 to 1);
      M_busLock : in std_logic_vector(0 to 1);
      M_TAttribute : in std_logic_vector(0 to 31);
      M_lockErr : in std_logic_vector(0 to 1);
      M_MSize : in std_logic_vector(0 to 3);
      M_priority : in std_logic_vector(0 to 3);
      M_rdBurst : in std_logic_vector(0 to 1);
      M_request : in std_logic_vector(0 to 1);
      M_size : in std_logic_vector(0 to 7);
      M_type : in std_logic_vector(0 to 5);
      M_wrBurst : in std_logic_vector(0 to 1);
      M_wrDBus : in std_logic_vector(0 to 127);
      Sl_addrAck : in std_logic_vector(0 to 10);
      Sl_MRdErr : in std_logic_vector(0 to 21);
      Sl_MWrErr : in std_logic_vector(0 to 21);
      Sl_MBusy : in std_logic_vector(0 to 21);
      Sl_rdBTerm : in std_logic_vector(0 to 10);
      Sl_rdComp : in std_logic_vector(0 to 10);
      Sl_rdDAck : in std_logic_vector(0 to 10);
      Sl_rdDBus : in std_logic_vector(0 to 703);
      Sl_rdWdAddr : in std_logic_vector(0 to 43);
      Sl_rearbitrate : in std_logic_vector(0 to 10);
      Sl_SSize : in std_logic_vector(0 to 21);
      Sl_wait : in std_logic_vector(0 to 10);
      Sl_wrBTerm : in std_logic_vector(0 to 10);
      Sl_wrComp : in std_logic_vector(0 to 10);
      Sl_wrDAck : in std_logic_vector(0 to 10);
      Sl_MIRQ : in std_logic_vector(0 to 21);
      PLB_MIRQ : out std_logic_vector(0 to 1);
      PLB_ABus : out std_logic_vector(0 to 31);
      PLB_UABus : out std_logic_vector(0 to 31);
      PLB_BE : out std_logic_vector(0 to 7);
      PLB_MAddrAck : out std_logic_vector(0 to 1);
      PLB_MTimeout : out std_logic_vector(0 to 1);
      PLB_MBusy : out std_logic_vector(0 to 1);
      PLB_MRdErr : out std_logic_vector(0 to 1);
      PLB_MWrErr : out std_logic_vector(0 to 1);
      PLB_MRdBTerm : out std_logic_vector(0 to 1);
      PLB_MRdDAck : out std_logic_vector(0 to 1);
      PLB_MRdDBus : out std_logic_vector(0 to 127);
      PLB_MRdWdAddr : out std_logic_vector(0 to 7);
      PLB_MRearbitrate : out std_logic_vector(0 to 1);
      PLB_MWrBTerm : out std_logic_vector(0 to 1);
      PLB_MWrDAck : out std_logic_vector(0 to 1);
      PLB_MSSize : out std_logic_vector(0 to 3);
      PLB_PAValid : out std_logic;
      PLB_RNW : out std_logic;
      PLB_SAValid : out std_logic;
      PLB_abort : out std_logic;
      PLB_busLock : out std_logic;
      PLB_TAttribute : out std_logic_vector(0 to 15);
      PLB_lockErr : out std_logic;
      PLB_masterID : out std_logic_vector(0 to 0);
      PLB_MSize : out std_logic_vector(0 to 1);
      PLB_rdPendPri : out std_logic_vector(0 to 1);
      PLB_wrPendPri : out std_logic_vector(0 to 1);
      PLB_rdPendReq : out std_logic;
      PLB_wrPendReq : out std_logic;
      PLB_rdBurst : out std_logic;
      PLB_rdPrim : out std_logic_vector(0 to 10);
      PLB_reqPri : out std_logic_vector(0 to 1);
      PLB_size : out std_logic_vector(0 to 3);
      PLB_type : out std_logic_vector(0 to 2);
      PLB_wrBurst : out std_logic;
      PLB_wrDBus : out std_logic_vector(0 to 63);
      PLB_wrPrim : out std_logic_vector(0 to 10);
      PLB_SaddrAck : out std_logic;
      PLB_SMRdErr : out std_logic_vector(0 to 1);
      PLB_SMWrErr : out std_logic_vector(0 to 1);
      PLB_SMBusy : out std_logic_vector(0 to 1);
      PLB_SrdBTerm : out std_logic;
      PLB_SrdComp : out std_logic;
      PLB_SrdDAck : out std_logic;
      PLB_SrdDBus : out std_logic_vector(0 to 63);
      PLB_SrdWdAddr : out std_logic_vector(0 to 3);
      PLB_Srearbitrate : out std_logic;
      PLB_Sssize : out std_logic_vector(0 to 1);
      PLB_Swait : out std_logic;
      PLB_SwrBTerm : out std_logic;
      PLB_SwrComp : out std_logic;
      PLB_SwrDAck : out std_logic;
      Bus_Error_Det : out std_logic
    );
  end component;

  component ilmb_wrapper is
    port (
      LMB_Clk : in std_logic;
      SYS_Rst : in std_logic;
      LMB_Rst : out std_logic;
      M_ABus : in std_logic_vector(0 to 31);
      M_ReadStrobe : in std_logic;
      M_WriteStrobe : in std_logic;
      M_AddrStrobe : in std_logic;
      M_DBus : in std_logic_vector(0 to 31);
      M_BE : in std_logic_vector(0 to 3);
      Sl_DBus : in std_logic_vector(0 to 31);
      Sl_Ready : in std_logic_vector(0 to 0);
      LMB_ABus : out std_logic_vector(0 to 31);
      LMB_ReadStrobe : out std_logic;
      LMB_WriteStrobe : out std_logic;
      LMB_AddrStrobe : out std_logic;
      LMB_ReadDBus : out std_logic_vector(0 to 31);
      LMB_WriteDBus : out std_logic_vector(0 to 31);
      LMB_Ready : out std_logic;
      LMB_BE : out std_logic_vector(0 to 3)
    );
  end component;

  component dlmb_wrapper is
    port (
      LMB_Clk : in std_logic;
      SYS_Rst : in std_logic;
      LMB_Rst : out std_logic;
      M_ABus : in std_logic_vector(0 to 31);
      M_ReadStrobe : in std_logic;
      M_WriteStrobe : in std_logic;
      M_AddrStrobe : in std_logic;
      M_DBus : in std_logic_vector(0 to 31);
      M_BE : in std_logic_vector(0 to 3);
      Sl_DBus : in std_logic_vector(0 to 31);
      Sl_Ready : in std_logic_vector(0 to 0);
      LMB_ABus : out std_logic_vector(0 to 31);
      LMB_ReadStrobe : out std_logic;
      LMB_WriteStrobe : out std_logic;
      LMB_AddrStrobe : out std_logic;
      LMB_ReadDBus : out std_logic_vector(0 to 31);
      LMB_WriteDBus : out std_logic_vector(0 to 31);
      LMB_Ready : out std_logic;
      LMB_BE : out std_logic_vector(0 to 3)
    );
  end component;

  component dlmb_cntlr_wrapper is
    port (
      LMB_Clk : in std_logic;
      LMB_Rst : in std_logic;
      LMB_ABus : in std_logic_vector(0 to 31);
      LMB_WriteDBus : in std_logic_vector(0 to 31);
      LMB_AddrStrobe : in std_logic;
      LMB_ReadStrobe : in std_logic;
      LMB_WriteStrobe : in std_logic;
      LMB_BE : in std_logic_vector(0 to 3);
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_Ready : out std_logic;
      BRAM_Rst_A : out std_logic;
      BRAM_Clk_A : out std_logic;
      BRAM_EN_A : out std_logic;
      BRAM_WEN_A : out std_logic_vector(0 to 3);
      BRAM_Addr_A : out std_logic_vector(0 to 31);
      BRAM_Din_A : in std_logic_vector(0 to 31);
      BRAM_Dout_A : out std_logic_vector(0 to 31)
    );
  end component;

  component ilmb_cntlr_wrapper is
    port (
      LMB_Clk : in std_logic;
      LMB_Rst : in std_logic;
      LMB_ABus : in std_logic_vector(0 to 31);
      LMB_WriteDBus : in std_logic_vector(0 to 31);
      LMB_AddrStrobe : in std_logic;
      LMB_ReadStrobe : in std_logic;
      LMB_WriteStrobe : in std_logic;
      LMB_BE : in std_logic_vector(0 to 3);
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_Ready : out std_logic;
      BRAM_Rst_A : out std_logic;
      BRAM_Clk_A : out std_logic;
      BRAM_EN_A : out std_logic;
      BRAM_WEN_A : out std_logic_vector(0 to 3);
      BRAM_Addr_A : out std_logic_vector(0 to 31);
      BRAM_Din_A : in std_logic_vector(0 to 31);
      BRAM_Dout_A : out std_logic_vector(0 to 31)
    );
  end component;

  component lmb_bram_wrapper is
    port (
      BRAM_Rst_A : in std_logic;
      BRAM_Clk_A : in std_logic;
      BRAM_EN_A : in std_logic;
      BRAM_WEN_A : in std_logic_vector(0 to 3);
      BRAM_Addr_A : in std_logic_vector(0 to 31);
      BRAM_Din_A : out std_logic_vector(0 to 31);
      BRAM_Dout_A : in std_logic_vector(0 to 31);
      BRAM_Rst_B : in std_logic;
      BRAM_Clk_B : in std_logic;
      BRAM_EN_B : in std_logic;
      BRAM_WEN_B : in std_logic_vector(0 to 3);
      BRAM_Addr_B : in std_logic_vector(0 to 31);
      BRAM_Din_B : out std_logic_vector(0 to 31);
      BRAM_Dout_B : in std_logic_vector(0 to 31)
    );
  end component;

  component rs232_uart_1_wrapper is
    port (
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 0);
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to 7);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_wrDBus : in std_logic_vector(0 to 63);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_lockErr : in std_logic;
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 63);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 1);
      Sl_MWrErr : out std_logic_vector(0 to 1);
      Sl_MRdErr : out std_logic_vector(0 to 1);
      Sl_wrBTerm : out std_logic;
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdBTerm : out std_logic;
      Sl_MIRQ : out std_logic_vector(0 to 1);
      RX : in std_logic;
      TX : out std_logic;
      Interrupt : out std_logic
    );
  end component;

  component leds_8bit_wrapper is
    port (
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 0);
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to 7);
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_lockErr : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to 63);
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_wrBTerm : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 63);
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_rdBTerm : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 1);
      Sl_MWrErr : out std_logic_vector(0 to 1);
      Sl_MRdErr : out std_logic_vector(0 to 1);
      Sl_MIRQ : out std_logic_vector(0 to 1);
      IP2INTC_Irpt : out std_logic;
      GPIO_IO_I : in std_logic_vector(0 to 7);
      GPIO_IO_O : out std_logic_vector(0 to 7);
      GPIO_IO_T : out std_logic_vector(0 to 7);
      GPIO_in : in std_logic_vector(0 to 7);
      GPIO_d_out : out std_logic_vector(0 to 7);
      GPIO_t_out : out std_logic_vector(0 to 7);
      GPIO2_IO_I : in std_logic_vector(0 to 7);
      GPIO2_IO_O : out std_logic_vector(0 to 7);
      GPIO2_IO_T : out std_logic_vector(0 to 7);
      GPIO2_in : in std_logic_vector(0 to 7);
      GPIO2_d_out : out std_logic_vector(0 to 7);
      GPIO2_t_out : out std_logic_vector(0 to 7)
    );
  end component;

  component sram_wrapper is
    port (
      MCH_PLB_Clk : in std_logic;
      RdClk : in std_logic;
      MCH_PLB_Rst : in std_logic;
      MCH0_Access_Control : in std_logic;
      MCH0_Access_Data : in std_logic_vector(0 to 31);
      MCH0_Access_Write : in std_logic;
      MCH0_Access_Full : out std_logic;
      MCH0_ReadData_Control : out std_logic;
      MCH0_ReadData_Data : out std_logic_vector(0 to 31);
      MCH0_ReadData_Read : in std_logic;
      MCH0_ReadData_Exists : out std_logic;
      MCH1_Access_Control : in std_logic;
      MCH1_Access_Data : in std_logic_vector(0 to 31);
      MCH1_Access_Write : in std_logic;
      MCH1_Access_Full : out std_logic;
      MCH1_ReadData_Control : out std_logic;
      MCH1_ReadData_Data : out std_logic_vector(0 to 31);
      MCH1_ReadData_Read : in std_logic;
      MCH1_ReadData_Exists : out std_logic;
      MCH2_Access_Control : in std_logic;
      MCH2_Access_Data : in std_logic_vector(0 to 31);
      MCH2_Access_Write : in std_logic;
      MCH2_Access_Full : out std_logic;
      MCH2_ReadData_Control : out std_logic;
      MCH2_ReadData_Data : out std_logic_vector(0 to 31);
      MCH2_ReadData_Read : in std_logic;
      MCH2_ReadData_Exists : out std_logic;
      MCH3_Access_Control : in std_logic;
      MCH3_Access_Data : in std_logic_vector(0 to 31);
      MCH3_Access_Write : in std_logic;
      MCH3_Access_Full : out std_logic;
      MCH3_ReadData_Control : out std_logic;
      MCH3_ReadData_Data : out std_logic_vector(0 to 31);
      MCH3_ReadData_Read : in std_logic;
      MCH3_ReadData_Exists : out std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 0);
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to 7);
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_lockErr : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to 63);
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_wrBTerm : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 63);
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_rdBTerm : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 1);
      Sl_MWrErr : out std_logic_vector(0 to 1);
      Sl_MRdErr : out std_logic_vector(0 to 1);
      Sl_MIRQ : out std_logic_vector(0 to 1);
      Mem_DQ_I : in std_logic_vector(0 to 31);
      Mem_DQ_O : out std_logic_vector(0 to 31);
      Mem_DQ_T : out std_logic_vector(0 to 31);
      Mem_A : out std_logic_vector(0 to 31);
      Mem_RPN : out std_logic;
      Mem_CEN : out std_logic_vector(0 to 0);
      Mem_OEN : out std_logic_vector(0 to 0);
      Mem_WEN : out std_logic;
      Mem_QWEN : out std_logic_vector(0 to 3);
      Mem_BEN : out std_logic_vector(0 to 3);
      Mem_CE : out std_logic_vector(0 to 0);
      Mem_ADV_LDN : out std_logic;
      Mem_LBON : out std_logic;
      Mem_CKEN : out std_logic;
      Mem_RNW : out std_logic
    );
  end component;

  component ddr2_sdram_wrapper is
    port (
      FSL0_M_Clk : in std_logic;
      FSL0_M_Write : in std_logic;
      FSL0_M_Data : in std_logic_vector(0 to 31);
      FSL0_M_Control : in std_logic;
      FSL0_M_Full : out std_logic;
      FSL0_S_Clk : in std_logic;
      FSL0_S_Read : in std_logic;
      FSL0_S_Data : out std_logic_vector(0 to 31);
      FSL0_S_Control : out std_logic;
      FSL0_S_Exists : out std_logic;
      SPLB0_Clk : in std_logic;
      SPLB0_Rst : in std_logic;
      SPLB0_PLB_ABus : in std_logic_vector(0 to 31);
      SPLB0_PLB_PAValid : in std_logic;
      SPLB0_PLB_SAValid : in std_logic;
      SPLB0_PLB_masterID : in std_logic_vector(0 to 0);
      SPLB0_PLB_RNW : in std_logic;
      SPLB0_PLB_BE : in std_logic_vector(0 to 7);
      SPLB0_PLB_UABus : in std_logic_vector(0 to 31);
      SPLB0_PLB_rdPrim : in std_logic;
      SPLB0_PLB_wrPrim : in std_logic;
      SPLB0_PLB_abort : in std_logic;
      SPLB0_PLB_busLock : in std_logic;
      SPLB0_PLB_MSize : in std_logic_vector(0 to 1);
      SPLB0_PLB_size : in std_logic_vector(0 to 3);
      SPLB0_PLB_type : in std_logic_vector(0 to 2);
      SPLB0_PLB_lockErr : in std_logic;
      SPLB0_PLB_wrPendReq : in std_logic;
      SPLB0_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SPLB0_PLB_rdPendReq : in std_logic;
      SPLB0_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SPLB0_PLB_reqPri : in std_logic_vector(0 to 1);
      SPLB0_PLB_TAttribute : in std_logic_vector(0 to 15);
      SPLB0_PLB_rdBurst : in std_logic;
      SPLB0_PLB_wrBurst : in std_logic;
      SPLB0_PLB_wrDBus : in std_logic_vector(0 to 63);
      SPLB0_Sl_addrAck : out std_logic;
      SPLB0_Sl_SSize : out std_logic_vector(0 to 1);
      SPLB0_Sl_wait : out std_logic;
      SPLB0_Sl_rearbitrate : out std_logic;
      SPLB0_Sl_wrDAck : out std_logic;
      SPLB0_Sl_wrComp : out std_logic;
      SPLB0_Sl_wrBTerm : out std_logic;
      SPLB0_Sl_rdDBus : out std_logic_vector(0 to 63);
      SPLB0_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SPLB0_Sl_rdDAck : out std_logic;
      SPLB0_Sl_rdComp : out std_logic;
      SPLB0_Sl_rdBTerm : out std_logic;
      SPLB0_Sl_MBusy : out std_logic_vector(0 to 0);
      SPLB0_Sl_MRdErr : out std_logic_vector(0 to 0);
      SPLB0_Sl_MWrErr : out std_logic_vector(0 to 0);
      SPLB0_Sl_MIRQ : out std_logic_vector(0 to 0);
      SDMA0_Clk : in std_logic;
      SDMA0_Rx_IntOut : out std_logic;
      SDMA0_Tx_IntOut : out std_logic;
      SDMA0_RstOut : out std_logic;
      SDMA0_TX_D : out std_logic_vector(0 to 31);
      SDMA0_TX_Rem : out std_logic_vector(0 to 3);
      SDMA0_TX_SOF : out std_logic;
      SDMA0_TX_EOF : out std_logic;
      SDMA0_TX_SOP : out std_logic;
      SDMA0_TX_EOP : out std_logic;
      SDMA0_TX_Src_Rdy : out std_logic;
      SDMA0_TX_Dst_Rdy : in std_logic;
      SDMA0_RX_D : in std_logic_vector(0 to 31);
      SDMA0_RX_Rem : in std_logic_vector(0 to 3);
      SDMA0_RX_SOF : in std_logic;
      SDMA0_RX_EOF : in std_logic;
      SDMA0_RX_SOP : in std_logic;
      SDMA0_RX_EOP : in std_logic;
      SDMA0_RX_Src_Rdy : in std_logic;
      SDMA0_RX_Dst_Rdy : out std_logic;
      SDMA_CTRL0_Clk : in std_logic;
      SDMA_CTRL0_Rst : in std_logic;
      SDMA_CTRL0_PLB_ABus : in std_logic_vector(0 to 31);
      SDMA_CTRL0_PLB_PAValid : in std_logic;
      SDMA_CTRL0_PLB_SAValid : in std_logic;
      SDMA_CTRL0_PLB_masterID : in std_logic_vector(0 to 0);
      SDMA_CTRL0_PLB_RNW : in std_logic;
      SDMA_CTRL0_PLB_BE : in std_logic_vector(0 to 7);
      SDMA_CTRL0_PLB_UABus : in std_logic_vector(0 to 31);
      SDMA_CTRL0_PLB_rdPrim : in std_logic;
      SDMA_CTRL0_PLB_wrPrim : in std_logic;
      SDMA_CTRL0_PLB_abort : in std_logic;
      SDMA_CTRL0_PLB_busLock : in std_logic;
      SDMA_CTRL0_PLB_MSize : in std_logic_vector(0 to 1);
      SDMA_CTRL0_PLB_size : in std_logic_vector(0 to 3);
      SDMA_CTRL0_PLB_type : in std_logic_vector(0 to 2);
      SDMA_CTRL0_PLB_lockErr : in std_logic;
      SDMA_CTRL0_PLB_wrPendReq : in std_logic;
      SDMA_CTRL0_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL0_PLB_rdPendReq : in std_logic;
      SDMA_CTRL0_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL0_PLB_reqPri : in std_logic_vector(0 to 1);
      SDMA_CTRL0_PLB_TAttribute : in std_logic_vector(0 to 15);
      SDMA_CTRL0_PLB_rdBurst : in std_logic;
      SDMA_CTRL0_PLB_wrBurst : in std_logic;
      SDMA_CTRL0_PLB_wrDBus : in std_logic_vector(0 to 63);
      SDMA_CTRL0_Sl_addrAck : out std_logic;
      SDMA_CTRL0_Sl_SSize : out std_logic_vector(0 to 1);
      SDMA_CTRL0_Sl_wait : out std_logic;
      SDMA_CTRL0_Sl_rearbitrate : out std_logic;
      SDMA_CTRL0_Sl_wrDAck : out std_logic;
      SDMA_CTRL0_Sl_wrComp : out std_logic;
      SDMA_CTRL0_Sl_wrBTerm : out std_logic;
      SDMA_CTRL0_Sl_rdDBus : out std_logic_vector(0 to 63);
      SDMA_CTRL0_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SDMA_CTRL0_Sl_rdDAck : out std_logic;
      SDMA_CTRL0_Sl_rdComp : out std_logic;
      SDMA_CTRL0_Sl_rdBTerm : out std_logic;
      SDMA_CTRL0_Sl_MBusy : out std_logic_vector(0 to 0);
      SDMA_CTRL0_Sl_MRdErr : out std_logic_vector(0 to 0);
      SDMA_CTRL0_Sl_MWrErr : out std_logic_vector(0 to 0);
      SDMA_CTRL0_Sl_MIRQ : out std_logic_vector(0 to 0);
      PIM0_Addr : in std_logic_vector(31 downto 0);
      PIM0_AddrReq : in std_logic;
      PIM0_AddrAck : out std_logic;
      PIM0_RNW : in std_logic;
      PIM0_Size : in std_logic_vector(3 downto 0);
      PIM0_RdModWr : in std_logic;
      PIM0_WrFIFO_Data : in std_logic_vector(63 downto 0);
      PIM0_WrFIFO_BE : in std_logic_vector(7 downto 0);
      PIM0_WrFIFO_Push : in std_logic;
      PIM0_RdFIFO_Data : out std_logic_vector(63 downto 0);
      PIM0_RdFIFO_Pop : in std_logic;
      PIM0_RdFIFO_RdWdAddr : out std_logic_vector(3 downto 0);
      PIM0_WrFIFO_Empty : out std_logic;
      PIM0_WrFIFO_AlmostFull : out std_logic;
      PIM0_WrFIFO_Flush : in std_logic;
      PIM0_RdFIFO_Empty : out std_logic;
      PIM0_RdFIFO_Flush : in std_logic;
      PIM0_RdFIFO_Latency : out std_logic_vector(1 downto 0);
      PIM0_InitDone : out std_logic;
      PPC440MC0_MIMCReadNotWrite : in std_logic;
      PPC440MC0_MIMCAddress : in std_logic_vector(0 to 35);
      PPC440MC0_MIMCAddressValid : in std_logic;
      PPC440MC0_MIMCWriteData : in std_logic_vector(0 to 127);
      PPC440MC0_MIMCWriteDataValid : in std_logic;
      PPC440MC0_MIMCByteEnable : in std_logic_vector(0 to 15);
      PPC440MC0_MIMCBankConflict : in std_logic;
      PPC440MC0_MIMCRowConflict : in std_logic;
      PPC440MC0_MCMIReadData : out std_logic_vector(0 to 127);
      PPC440MC0_MCMIReadDataValid : out std_logic;
      PPC440MC0_MCMIReadDataErr : out std_logic;
      PPC440MC0_MCMIAddrReadyToAccept : out std_logic;
      VFBC0_Cmd_Clk : in std_logic;
      VFBC0_Cmd_Reset : in std_logic;
      VFBC0_Cmd_Data : in std_logic_vector(31 downto 0);
      VFBC0_Cmd_Write : in std_logic;
      VFBC0_Cmd_End : in std_logic;
      VFBC0_Cmd_Full : out std_logic;
      VFBC0_Cmd_Almost_Full : out std_logic;
      VFBC0_Cmd_Idle : out std_logic;
      VFBC0_Wd_Clk : in std_logic;
      VFBC0_Wd_Reset : in std_logic;
      VFBC0_Wd_Write : in std_logic;
      VFBC0_Wd_End_Burst : in std_logic;
      VFBC0_Wd_Flush : in std_logic;
      VFBC0_Wd_Data : in std_logic_vector(31 downto 0);
      VFBC0_Wd_Data_BE : in std_logic_vector(3 downto 0);
      VFBC0_Wd_Full : out std_logic;
      VFBC0_Wd_Almost_Full : out std_logic;
      VFBC0_Rd_Clk : in std_logic;
      VFBC0_Rd_Reset : in std_logic;
      VFBC0_Rd_Read : in std_logic;
      VFBC0_Rd_End_Burst : in std_logic;
      VFBC0_Rd_Flush : in std_logic;
      VFBC0_Rd_Data : out std_logic_vector(31 downto 0);
      VFBC0_Rd_Empty : out std_logic;
      VFBC0_Rd_Almost_Empty : out std_logic;
      FSL1_M_Clk : in std_logic;
      FSL1_M_Write : in std_logic;
      FSL1_M_Data : in std_logic_vector(0 to 31);
      FSL1_M_Control : in std_logic;
      FSL1_M_Full : out std_logic;
      FSL1_S_Clk : in std_logic;
      FSL1_S_Read : in std_logic;
      FSL1_S_Data : out std_logic_vector(0 to 31);
      FSL1_S_Control : out std_logic;
      FSL1_S_Exists : out std_logic;
      SPLB1_Clk : in std_logic;
      SPLB1_Rst : in std_logic;
      SPLB1_PLB_ABus : in std_logic_vector(0 to 31);
      SPLB1_PLB_PAValid : in std_logic;
      SPLB1_PLB_SAValid : in std_logic;
      SPLB1_PLB_masterID : in std_logic_vector(0 to 0);
      SPLB1_PLB_RNW : in std_logic;
      SPLB1_PLB_BE : in std_logic_vector(0 to 7);
      SPLB1_PLB_UABus : in std_logic_vector(0 to 31);
      SPLB1_PLB_rdPrim : in std_logic;
      SPLB1_PLB_wrPrim : in std_logic;
      SPLB1_PLB_abort : in std_logic;
      SPLB1_PLB_busLock : in std_logic;
      SPLB1_PLB_MSize : in std_logic_vector(0 to 1);
      SPLB1_PLB_size : in std_logic_vector(0 to 3);
      SPLB1_PLB_type : in std_logic_vector(0 to 2);
      SPLB1_PLB_lockErr : in std_logic;
      SPLB1_PLB_wrPendReq : in std_logic;
      SPLB1_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SPLB1_PLB_rdPendReq : in std_logic;
      SPLB1_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SPLB1_PLB_reqPri : in std_logic_vector(0 to 1);
      SPLB1_PLB_TAttribute : in std_logic_vector(0 to 15);
      SPLB1_PLB_rdBurst : in std_logic;
      SPLB1_PLB_wrBurst : in std_logic;
      SPLB1_PLB_wrDBus : in std_logic_vector(0 to 63);
      SPLB1_Sl_addrAck : out std_logic;
      SPLB1_Sl_SSize : out std_logic_vector(0 to 1);
      SPLB1_Sl_wait : out std_logic;
      SPLB1_Sl_rearbitrate : out std_logic;
      SPLB1_Sl_wrDAck : out std_logic;
      SPLB1_Sl_wrComp : out std_logic;
      SPLB1_Sl_wrBTerm : out std_logic;
      SPLB1_Sl_rdDBus : out std_logic_vector(0 to 63);
      SPLB1_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SPLB1_Sl_rdDAck : out std_logic;
      SPLB1_Sl_rdComp : out std_logic;
      SPLB1_Sl_rdBTerm : out std_logic;
      SPLB1_Sl_MBusy : out std_logic_vector(0 to 0);
      SPLB1_Sl_MRdErr : out std_logic_vector(0 to 0);
      SPLB1_Sl_MWrErr : out std_logic_vector(0 to 0);
      SPLB1_Sl_MIRQ : out std_logic_vector(0 to 0);
      SDMA1_Clk : in std_logic;
      SDMA1_Rx_IntOut : out std_logic;
      SDMA1_Tx_IntOut : out std_logic;
      SDMA1_RstOut : out std_logic;
      SDMA1_TX_D : out std_logic_vector(0 to 31);
      SDMA1_TX_Rem : out std_logic_vector(0 to 3);
      SDMA1_TX_SOF : out std_logic;
      SDMA1_TX_EOF : out std_logic;
      SDMA1_TX_SOP : out std_logic;
      SDMA1_TX_EOP : out std_logic;
      SDMA1_TX_Src_Rdy : out std_logic;
      SDMA1_TX_Dst_Rdy : in std_logic;
      SDMA1_RX_D : in std_logic_vector(0 to 31);
      SDMA1_RX_Rem : in std_logic_vector(0 to 3);
      SDMA1_RX_SOF : in std_logic;
      SDMA1_RX_EOF : in std_logic;
      SDMA1_RX_SOP : in std_logic;
      SDMA1_RX_EOP : in std_logic;
      SDMA1_RX_Src_Rdy : in std_logic;
      SDMA1_RX_Dst_Rdy : out std_logic;
      SDMA_CTRL1_Clk : in std_logic;
      SDMA_CTRL1_Rst : in std_logic;
      SDMA_CTRL1_PLB_ABus : in std_logic_vector(0 to 31);
      SDMA_CTRL1_PLB_PAValid : in std_logic;
      SDMA_CTRL1_PLB_SAValid : in std_logic;
      SDMA_CTRL1_PLB_masterID : in std_logic_vector(0 to 0);
      SDMA_CTRL1_PLB_RNW : in std_logic;
      SDMA_CTRL1_PLB_BE : in std_logic_vector(0 to 7);
      SDMA_CTRL1_PLB_UABus : in std_logic_vector(0 to 31);
      SDMA_CTRL1_PLB_rdPrim : in std_logic;
      SDMA_CTRL1_PLB_wrPrim : in std_logic;
      SDMA_CTRL1_PLB_abort : in std_logic;
      SDMA_CTRL1_PLB_busLock : in std_logic;
      SDMA_CTRL1_PLB_MSize : in std_logic_vector(0 to 1);
      SDMA_CTRL1_PLB_size : in std_logic_vector(0 to 3);
      SDMA_CTRL1_PLB_type : in std_logic_vector(0 to 2);
      SDMA_CTRL1_PLB_lockErr : in std_logic;
      SDMA_CTRL1_PLB_wrPendReq : in std_logic;
      SDMA_CTRL1_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL1_PLB_rdPendReq : in std_logic;
      SDMA_CTRL1_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL1_PLB_reqPri : in std_logic_vector(0 to 1);
      SDMA_CTRL1_PLB_TAttribute : in std_logic_vector(0 to 15);
      SDMA_CTRL1_PLB_rdBurst : in std_logic;
      SDMA_CTRL1_PLB_wrBurst : in std_logic;
      SDMA_CTRL1_PLB_wrDBus : in std_logic_vector(0 to 63);
      SDMA_CTRL1_Sl_addrAck : out std_logic;
      SDMA_CTRL1_Sl_SSize : out std_logic_vector(0 to 1);
      SDMA_CTRL1_Sl_wait : out std_logic;
      SDMA_CTRL1_Sl_rearbitrate : out std_logic;
      SDMA_CTRL1_Sl_wrDAck : out std_logic;
      SDMA_CTRL1_Sl_wrComp : out std_logic;
      SDMA_CTRL1_Sl_wrBTerm : out std_logic;
      SDMA_CTRL1_Sl_rdDBus : out std_logic_vector(0 to 63);
      SDMA_CTRL1_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SDMA_CTRL1_Sl_rdDAck : out std_logic;
      SDMA_CTRL1_Sl_rdComp : out std_logic;
      SDMA_CTRL1_Sl_rdBTerm : out std_logic;
      SDMA_CTRL1_Sl_MBusy : out std_logic_vector(0 to 0);
      SDMA_CTRL1_Sl_MRdErr : out std_logic_vector(0 to 0);
      SDMA_CTRL1_Sl_MWrErr : out std_logic_vector(0 to 0);
      SDMA_CTRL1_Sl_MIRQ : out std_logic_vector(0 to 0);
      PIM1_Addr : in std_logic_vector(31 downto 0);
      PIM1_AddrReq : in std_logic;
      PIM1_AddrAck : out std_logic;
      PIM1_RNW : in std_logic;
      PIM1_Size : in std_logic_vector(3 downto 0);
      PIM1_RdModWr : in std_logic;
      PIM1_WrFIFO_Data : in std_logic_vector(63 downto 0);
      PIM1_WrFIFO_BE : in std_logic_vector(7 downto 0);
      PIM1_WrFIFO_Push : in std_logic;
      PIM1_RdFIFO_Data : out std_logic_vector(63 downto 0);
      PIM1_RdFIFO_Pop : in std_logic;
      PIM1_RdFIFO_RdWdAddr : out std_logic_vector(3 downto 0);
      PIM1_WrFIFO_Empty : out std_logic;
      PIM1_WrFIFO_AlmostFull : out std_logic;
      PIM1_WrFIFO_Flush : in std_logic;
      PIM1_RdFIFO_Empty : out std_logic;
      PIM1_RdFIFO_Flush : in std_logic;
      PIM1_RdFIFO_Latency : out std_logic_vector(1 downto 0);
      PIM1_InitDone : out std_logic;
      PPC440MC1_MIMCReadNotWrite : in std_logic;
      PPC440MC1_MIMCAddress : in std_logic_vector(0 to 35);
      PPC440MC1_MIMCAddressValid : in std_logic;
      PPC440MC1_MIMCWriteData : in std_logic_vector(0 to 127);
      PPC440MC1_MIMCWriteDataValid : in std_logic;
      PPC440MC1_MIMCByteEnable : in std_logic_vector(0 to 15);
      PPC440MC1_MIMCBankConflict : in std_logic;
      PPC440MC1_MIMCRowConflict : in std_logic;
      PPC440MC1_MCMIReadData : out std_logic_vector(0 to 127);
      PPC440MC1_MCMIReadDataValid : out std_logic;
      PPC440MC1_MCMIReadDataErr : out std_logic;
      PPC440MC1_MCMIAddrReadyToAccept : out std_logic;
      VFBC1_Cmd_Clk : in std_logic;
      VFBC1_Cmd_Reset : in std_logic;
      VFBC1_Cmd_Data : in std_logic_vector(31 downto 0);
      VFBC1_Cmd_Write : in std_logic;
      VFBC1_Cmd_End : in std_logic;
      VFBC1_Cmd_Full : out std_logic;
      VFBC1_Cmd_Almost_Full : out std_logic;
      VFBC1_Cmd_Idle : out std_logic;
      VFBC1_Wd_Clk : in std_logic;
      VFBC1_Wd_Reset : in std_logic;
      VFBC1_Wd_Write : in std_logic;
      VFBC1_Wd_End_Burst : in std_logic;
      VFBC1_Wd_Flush : in std_logic;
      VFBC1_Wd_Data : in std_logic_vector(31 downto 0);
      VFBC1_Wd_Data_BE : in std_logic_vector(3 downto 0);
      VFBC1_Wd_Full : out std_logic;
      VFBC1_Wd_Almost_Full : out std_logic;
      VFBC1_Rd_Clk : in std_logic;
      VFBC1_Rd_Reset : in std_logic;
      VFBC1_Rd_Read : in std_logic;
      VFBC1_Rd_End_Burst : in std_logic;
      VFBC1_Rd_Flush : in std_logic;
      VFBC1_Rd_Data : out std_logic_vector(31 downto 0);
      VFBC1_Rd_Empty : out std_logic;
      VFBC1_Rd_Almost_Empty : out std_logic;
      FSL2_M_Clk : in std_logic;
      FSL2_M_Write : in std_logic;
      FSL2_M_Data : in std_logic_vector(0 to 31);
      FSL2_M_Control : in std_logic;
      FSL2_M_Full : out std_logic;
      FSL2_S_Clk : in std_logic;
      FSL2_S_Read : in std_logic;
      FSL2_S_Data : out std_logic_vector(0 to 31);
      FSL2_S_Control : out std_logic;
      FSL2_S_Exists : out std_logic;
      SPLB2_Clk : in std_logic;
      SPLB2_Rst : in std_logic;
      SPLB2_PLB_ABus : in std_logic_vector(0 to 31);
      SPLB2_PLB_PAValid : in std_logic;
      SPLB2_PLB_SAValid : in std_logic;
      SPLB2_PLB_masterID : in std_logic_vector(0 to 0);
      SPLB2_PLB_RNW : in std_logic;
      SPLB2_PLB_BE : in std_logic_vector(0 to 7);
      SPLB2_PLB_UABus : in std_logic_vector(0 to 31);
      SPLB2_PLB_rdPrim : in std_logic;
      SPLB2_PLB_wrPrim : in std_logic;
      SPLB2_PLB_abort : in std_logic;
      SPLB2_PLB_busLock : in std_logic;
      SPLB2_PLB_MSize : in std_logic_vector(0 to 1);
      SPLB2_PLB_size : in std_logic_vector(0 to 3);
      SPLB2_PLB_type : in std_logic_vector(0 to 2);
      SPLB2_PLB_lockErr : in std_logic;
      SPLB2_PLB_wrPendReq : in std_logic;
      SPLB2_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SPLB2_PLB_rdPendReq : in std_logic;
      SPLB2_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SPLB2_PLB_reqPri : in std_logic_vector(0 to 1);
      SPLB2_PLB_TAttribute : in std_logic_vector(0 to 15);
      SPLB2_PLB_rdBurst : in std_logic;
      SPLB2_PLB_wrBurst : in std_logic;
      SPLB2_PLB_wrDBus : in std_logic_vector(0 to 63);
      SPLB2_Sl_addrAck : out std_logic;
      SPLB2_Sl_SSize : out std_logic_vector(0 to 1);
      SPLB2_Sl_wait : out std_logic;
      SPLB2_Sl_rearbitrate : out std_logic;
      SPLB2_Sl_wrDAck : out std_logic;
      SPLB2_Sl_wrComp : out std_logic;
      SPLB2_Sl_wrBTerm : out std_logic;
      SPLB2_Sl_rdDBus : out std_logic_vector(0 to 63);
      SPLB2_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SPLB2_Sl_rdDAck : out std_logic;
      SPLB2_Sl_rdComp : out std_logic;
      SPLB2_Sl_rdBTerm : out std_logic;
      SPLB2_Sl_MBusy : out std_logic_vector(0 to 1);
      SPLB2_Sl_MRdErr : out std_logic_vector(0 to 1);
      SPLB2_Sl_MWrErr : out std_logic_vector(0 to 1);
      SPLB2_Sl_MIRQ : out std_logic_vector(0 to 1);
      SDMA2_Clk : in std_logic;
      SDMA2_Rx_IntOut : out std_logic;
      SDMA2_Tx_IntOut : out std_logic;
      SDMA2_RstOut : out std_logic;
      SDMA2_TX_D : out std_logic_vector(0 to 31);
      SDMA2_TX_Rem : out std_logic_vector(0 to 3);
      SDMA2_TX_SOF : out std_logic;
      SDMA2_TX_EOF : out std_logic;
      SDMA2_TX_SOP : out std_logic;
      SDMA2_TX_EOP : out std_logic;
      SDMA2_TX_Src_Rdy : out std_logic;
      SDMA2_TX_Dst_Rdy : in std_logic;
      SDMA2_RX_D : in std_logic_vector(0 to 31);
      SDMA2_RX_Rem : in std_logic_vector(0 to 3);
      SDMA2_RX_SOF : in std_logic;
      SDMA2_RX_EOF : in std_logic;
      SDMA2_RX_SOP : in std_logic;
      SDMA2_RX_EOP : in std_logic;
      SDMA2_RX_Src_Rdy : in std_logic;
      SDMA2_RX_Dst_Rdy : out std_logic;
      SDMA_CTRL2_Clk : in std_logic;
      SDMA_CTRL2_Rst : in std_logic;
      SDMA_CTRL2_PLB_ABus : in std_logic_vector(0 to 31);
      SDMA_CTRL2_PLB_PAValid : in std_logic;
      SDMA_CTRL2_PLB_SAValid : in std_logic;
      SDMA_CTRL2_PLB_masterID : in std_logic_vector(0 to 0);
      SDMA_CTRL2_PLB_RNW : in std_logic;
      SDMA_CTRL2_PLB_BE : in std_logic_vector(0 to 7);
      SDMA_CTRL2_PLB_UABus : in std_logic_vector(0 to 31);
      SDMA_CTRL2_PLB_rdPrim : in std_logic;
      SDMA_CTRL2_PLB_wrPrim : in std_logic;
      SDMA_CTRL2_PLB_abort : in std_logic;
      SDMA_CTRL2_PLB_busLock : in std_logic;
      SDMA_CTRL2_PLB_MSize : in std_logic_vector(0 to 1);
      SDMA_CTRL2_PLB_size : in std_logic_vector(0 to 3);
      SDMA_CTRL2_PLB_type : in std_logic_vector(0 to 2);
      SDMA_CTRL2_PLB_lockErr : in std_logic;
      SDMA_CTRL2_PLB_wrPendReq : in std_logic;
      SDMA_CTRL2_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL2_PLB_rdPendReq : in std_logic;
      SDMA_CTRL2_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL2_PLB_reqPri : in std_logic_vector(0 to 1);
      SDMA_CTRL2_PLB_TAttribute : in std_logic_vector(0 to 15);
      SDMA_CTRL2_PLB_rdBurst : in std_logic;
      SDMA_CTRL2_PLB_wrBurst : in std_logic;
      SDMA_CTRL2_PLB_wrDBus : in std_logic_vector(0 to 63);
      SDMA_CTRL2_Sl_addrAck : out std_logic;
      SDMA_CTRL2_Sl_SSize : out std_logic_vector(0 to 1);
      SDMA_CTRL2_Sl_wait : out std_logic;
      SDMA_CTRL2_Sl_rearbitrate : out std_logic;
      SDMA_CTRL2_Sl_wrDAck : out std_logic;
      SDMA_CTRL2_Sl_wrComp : out std_logic;
      SDMA_CTRL2_Sl_wrBTerm : out std_logic;
      SDMA_CTRL2_Sl_rdDBus : out std_logic_vector(0 to 63);
      SDMA_CTRL2_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SDMA_CTRL2_Sl_rdDAck : out std_logic;
      SDMA_CTRL2_Sl_rdComp : out std_logic;
      SDMA_CTRL2_Sl_rdBTerm : out std_logic;
      SDMA_CTRL2_Sl_MBusy : out std_logic_vector(0 to 0);
      SDMA_CTRL2_Sl_MRdErr : out std_logic_vector(0 to 0);
      SDMA_CTRL2_Sl_MWrErr : out std_logic_vector(0 to 0);
      SDMA_CTRL2_Sl_MIRQ : out std_logic_vector(0 to 0);
      PIM2_Addr : in std_logic_vector(31 downto 0);
      PIM2_AddrReq : in std_logic;
      PIM2_AddrAck : out std_logic;
      PIM2_RNW : in std_logic;
      PIM2_Size : in std_logic_vector(3 downto 0);
      PIM2_RdModWr : in std_logic;
      PIM2_WrFIFO_Data : in std_logic_vector(63 downto 0);
      PIM2_WrFIFO_BE : in std_logic_vector(7 downto 0);
      PIM2_WrFIFO_Push : in std_logic;
      PIM2_RdFIFO_Data : out std_logic_vector(63 downto 0);
      PIM2_RdFIFO_Pop : in std_logic;
      PIM2_RdFIFO_RdWdAddr : out std_logic_vector(3 downto 0);
      PIM2_WrFIFO_Empty : out std_logic;
      PIM2_WrFIFO_AlmostFull : out std_logic;
      PIM2_WrFIFO_Flush : in std_logic;
      PIM2_RdFIFO_Empty : out std_logic;
      PIM2_RdFIFO_Flush : in std_logic;
      PIM2_RdFIFO_Latency : out std_logic_vector(1 downto 0);
      PIM2_InitDone : out std_logic;
      PPC440MC2_MIMCReadNotWrite : in std_logic;
      PPC440MC2_MIMCAddress : in std_logic_vector(0 to 35);
      PPC440MC2_MIMCAddressValid : in std_logic;
      PPC440MC2_MIMCWriteData : in std_logic_vector(0 to 127);
      PPC440MC2_MIMCWriteDataValid : in std_logic;
      PPC440MC2_MIMCByteEnable : in std_logic_vector(0 to 15);
      PPC440MC2_MIMCBankConflict : in std_logic;
      PPC440MC2_MIMCRowConflict : in std_logic;
      PPC440MC2_MCMIReadData : out std_logic_vector(0 to 127);
      PPC440MC2_MCMIReadDataValid : out std_logic;
      PPC440MC2_MCMIReadDataErr : out std_logic;
      PPC440MC2_MCMIAddrReadyToAccept : out std_logic;
      VFBC2_Cmd_Clk : in std_logic;
      VFBC2_Cmd_Reset : in std_logic;
      VFBC2_Cmd_Data : in std_logic_vector(31 downto 0);
      VFBC2_Cmd_Write : in std_logic;
      VFBC2_Cmd_End : in std_logic;
      VFBC2_Cmd_Full : out std_logic;
      VFBC2_Cmd_Almost_Full : out std_logic;
      VFBC2_Cmd_Idle : out std_logic;
      VFBC2_Wd_Clk : in std_logic;
      VFBC2_Wd_Reset : in std_logic;
      VFBC2_Wd_Write : in std_logic;
      VFBC2_Wd_End_Burst : in std_logic;
      VFBC2_Wd_Flush : in std_logic;
      VFBC2_Wd_Data : in std_logic_vector(31 downto 0);
      VFBC2_Wd_Data_BE : in std_logic_vector(3 downto 0);
      VFBC2_Wd_Full : out std_logic;
      VFBC2_Wd_Almost_Full : out std_logic;
      VFBC2_Rd_Clk : in std_logic;
      VFBC2_Rd_Reset : in std_logic;
      VFBC2_Rd_Read : in std_logic;
      VFBC2_Rd_End_Burst : in std_logic;
      VFBC2_Rd_Flush : in std_logic;
      VFBC2_Rd_Data : out std_logic_vector(31 downto 0);
      VFBC2_Rd_Empty : out std_logic;
      VFBC2_Rd_Almost_Empty : out std_logic;
      FSL3_M_Clk : in std_logic;
      FSL3_M_Write : in std_logic;
      FSL3_M_Data : in std_logic_vector(0 to 31);
      FSL3_M_Control : in std_logic;
      FSL3_M_Full : out std_logic;
      FSL3_S_Clk : in std_logic;
      FSL3_S_Read : in std_logic;
      FSL3_S_Data : out std_logic_vector(0 to 31);
      FSL3_S_Control : out std_logic;
      FSL3_S_Exists : out std_logic;
      SPLB3_Clk : in std_logic;
      SPLB3_Rst : in std_logic;
      SPLB3_PLB_ABus : in std_logic_vector(0 to 31);
      SPLB3_PLB_PAValid : in std_logic;
      SPLB3_PLB_SAValid : in std_logic;
      SPLB3_PLB_masterID : in std_logic_vector(0 to 0);
      SPLB3_PLB_RNW : in std_logic;
      SPLB3_PLB_BE : in std_logic_vector(0 to 7);
      SPLB3_PLB_UABus : in std_logic_vector(0 to 31);
      SPLB3_PLB_rdPrim : in std_logic;
      SPLB3_PLB_wrPrim : in std_logic;
      SPLB3_PLB_abort : in std_logic;
      SPLB3_PLB_busLock : in std_logic;
      SPLB3_PLB_MSize : in std_logic_vector(0 to 1);
      SPLB3_PLB_size : in std_logic_vector(0 to 3);
      SPLB3_PLB_type : in std_logic_vector(0 to 2);
      SPLB3_PLB_lockErr : in std_logic;
      SPLB3_PLB_wrPendReq : in std_logic;
      SPLB3_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SPLB3_PLB_rdPendReq : in std_logic;
      SPLB3_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SPLB3_PLB_reqPri : in std_logic_vector(0 to 1);
      SPLB3_PLB_TAttribute : in std_logic_vector(0 to 15);
      SPLB3_PLB_rdBurst : in std_logic;
      SPLB3_PLB_wrBurst : in std_logic;
      SPLB3_PLB_wrDBus : in std_logic_vector(0 to 63);
      SPLB3_Sl_addrAck : out std_logic;
      SPLB3_Sl_SSize : out std_logic_vector(0 to 1);
      SPLB3_Sl_wait : out std_logic;
      SPLB3_Sl_rearbitrate : out std_logic;
      SPLB3_Sl_wrDAck : out std_logic;
      SPLB3_Sl_wrComp : out std_logic;
      SPLB3_Sl_wrBTerm : out std_logic;
      SPLB3_Sl_rdDBus : out std_logic_vector(0 to 63);
      SPLB3_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SPLB3_Sl_rdDAck : out std_logic;
      SPLB3_Sl_rdComp : out std_logic;
      SPLB3_Sl_rdBTerm : out std_logic;
      SPLB3_Sl_MBusy : out std_logic_vector(0 to 0);
      SPLB3_Sl_MRdErr : out std_logic_vector(0 to 0);
      SPLB3_Sl_MWrErr : out std_logic_vector(0 to 0);
      SPLB3_Sl_MIRQ : out std_logic_vector(0 to 0);
      SDMA3_Clk : in std_logic;
      SDMA3_Rx_IntOut : out std_logic;
      SDMA3_Tx_IntOut : out std_logic;
      SDMA3_RstOut : out std_logic;
      SDMA3_TX_D : out std_logic_vector(0 to 31);
      SDMA3_TX_Rem : out std_logic_vector(0 to 3);
      SDMA3_TX_SOF : out std_logic;
      SDMA3_TX_EOF : out std_logic;
      SDMA3_TX_SOP : out std_logic;
      SDMA3_TX_EOP : out std_logic;
      SDMA3_TX_Src_Rdy : out std_logic;
      SDMA3_TX_Dst_Rdy : in std_logic;
      SDMA3_RX_D : in std_logic_vector(0 to 31);
      SDMA3_RX_Rem : in std_logic_vector(0 to 3);
      SDMA3_RX_SOF : in std_logic;
      SDMA3_RX_EOF : in std_logic;
      SDMA3_RX_SOP : in std_logic;
      SDMA3_RX_EOP : in std_logic;
      SDMA3_RX_Src_Rdy : in std_logic;
      SDMA3_RX_Dst_Rdy : out std_logic;
      SDMA_CTRL3_Clk : in std_logic;
      SDMA_CTRL3_Rst : in std_logic;
      SDMA_CTRL3_PLB_ABus : in std_logic_vector(0 to 31);
      SDMA_CTRL3_PLB_PAValid : in std_logic;
      SDMA_CTRL3_PLB_SAValid : in std_logic;
      SDMA_CTRL3_PLB_masterID : in std_logic_vector(0 to 0);
      SDMA_CTRL3_PLB_RNW : in std_logic;
      SDMA_CTRL3_PLB_BE : in std_logic_vector(0 to 7);
      SDMA_CTRL3_PLB_UABus : in std_logic_vector(0 to 31);
      SDMA_CTRL3_PLB_rdPrim : in std_logic;
      SDMA_CTRL3_PLB_wrPrim : in std_logic;
      SDMA_CTRL3_PLB_abort : in std_logic;
      SDMA_CTRL3_PLB_busLock : in std_logic;
      SDMA_CTRL3_PLB_MSize : in std_logic_vector(0 to 1);
      SDMA_CTRL3_PLB_size : in std_logic_vector(0 to 3);
      SDMA_CTRL3_PLB_type : in std_logic_vector(0 to 2);
      SDMA_CTRL3_PLB_lockErr : in std_logic;
      SDMA_CTRL3_PLB_wrPendReq : in std_logic;
      SDMA_CTRL3_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL3_PLB_rdPendReq : in std_logic;
      SDMA_CTRL3_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL3_PLB_reqPri : in std_logic_vector(0 to 1);
      SDMA_CTRL3_PLB_TAttribute : in std_logic_vector(0 to 15);
      SDMA_CTRL3_PLB_rdBurst : in std_logic;
      SDMA_CTRL3_PLB_wrBurst : in std_logic;
      SDMA_CTRL3_PLB_wrDBus : in std_logic_vector(0 to 63);
      SDMA_CTRL3_Sl_addrAck : out std_logic;
      SDMA_CTRL3_Sl_SSize : out std_logic_vector(0 to 1);
      SDMA_CTRL3_Sl_wait : out std_logic;
      SDMA_CTRL3_Sl_rearbitrate : out std_logic;
      SDMA_CTRL3_Sl_wrDAck : out std_logic;
      SDMA_CTRL3_Sl_wrComp : out std_logic;
      SDMA_CTRL3_Sl_wrBTerm : out std_logic;
      SDMA_CTRL3_Sl_rdDBus : out std_logic_vector(0 to 63);
      SDMA_CTRL3_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SDMA_CTRL3_Sl_rdDAck : out std_logic;
      SDMA_CTRL3_Sl_rdComp : out std_logic;
      SDMA_CTRL3_Sl_rdBTerm : out std_logic;
      SDMA_CTRL3_Sl_MBusy : out std_logic_vector(0 to 0);
      SDMA_CTRL3_Sl_MRdErr : out std_logic_vector(0 to 0);
      SDMA_CTRL3_Sl_MWrErr : out std_logic_vector(0 to 0);
      SDMA_CTRL3_Sl_MIRQ : out std_logic_vector(0 to 0);
      PIM3_Addr : in std_logic_vector(31 downto 0);
      PIM3_AddrReq : in std_logic;
      PIM3_AddrAck : out std_logic;
      PIM3_RNW : in std_logic;
      PIM3_Size : in std_logic_vector(3 downto 0);
      PIM3_RdModWr : in std_logic;
      PIM3_WrFIFO_Data : in std_logic_vector(63 downto 0);
      PIM3_WrFIFO_BE : in std_logic_vector(7 downto 0);
      PIM3_WrFIFO_Push : in std_logic;
      PIM3_RdFIFO_Data : out std_logic_vector(63 downto 0);
      PIM3_RdFIFO_Pop : in std_logic;
      PIM3_RdFIFO_RdWdAddr : out std_logic_vector(3 downto 0);
      PIM3_WrFIFO_Empty : out std_logic;
      PIM3_WrFIFO_AlmostFull : out std_logic;
      PIM3_WrFIFO_Flush : in std_logic;
      PIM3_RdFIFO_Empty : out std_logic;
      PIM3_RdFIFO_Flush : in std_logic;
      PIM3_RdFIFO_Latency : out std_logic_vector(1 downto 0);
      PIM3_InitDone : out std_logic;
      PPC440MC3_MIMCReadNotWrite : in std_logic;
      PPC440MC3_MIMCAddress : in std_logic_vector(0 to 35);
      PPC440MC3_MIMCAddressValid : in std_logic;
      PPC440MC3_MIMCWriteData : in std_logic_vector(0 to 127);
      PPC440MC3_MIMCWriteDataValid : in std_logic;
      PPC440MC3_MIMCByteEnable : in std_logic_vector(0 to 15);
      PPC440MC3_MIMCBankConflict : in std_logic;
      PPC440MC3_MIMCRowConflict : in std_logic;
      PPC440MC3_MCMIReadData : out std_logic_vector(0 to 127);
      PPC440MC3_MCMIReadDataValid : out std_logic;
      PPC440MC3_MCMIReadDataErr : out std_logic;
      PPC440MC3_MCMIAddrReadyToAccept : out std_logic;
      VFBC3_Cmd_Clk : in std_logic;
      VFBC3_Cmd_Reset : in std_logic;
      VFBC3_Cmd_Data : in std_logic_vector(31 downto 0);
      VFBC3_Cmd_Write : in std_logic;
      VFBC3_Cmd_End : in std_logic;
      VFBC3_Cmd_Full : out std_logic;
      VFBC3_Cmd_Almost_Full : out std_logic;
      VFBC3_Cmd_Idle : out std_logic;
      VFBC3_Wd_Clk : in std_logic;
      VFBC3_Wd_Reset : in std_logic;
      VFBC3_Wd_Write : in std_logic;
      VFBC3_Wd_End_Burst : in std_logic;
      VFBC3_Wd_Flush : in std_logic;
      VFBC3_Wd_Data : in std_logic_vector(31 downto 0);
      VFBC3_Wd_Data_BE : in std_logic_vector(3 downto 0);
      VFBC3_Wd_Full : out std_logic;
      VFBC3_Wd_Almost_Full : out std_logic;
      VFBC3_Rd_Clk : in std_logic;
      VFBC3_Rd_Reset : in std_logic;
      VFBC3_Rd_Read : in std_logic;
      VFBC3_Rd_End_Burst : in std_logic;
      VFBC3_Rd_Flush : in std_logic;
      VFBC3_Rd_Data : out std_logic_vector(31 downto 0);
      VFBC3_Rd_Empty : out std_logic;
      VFBC3_Rd_Almost_Empty : out std_logic;
      FSL4_M_Clk : in std_logic;
      FSL4_M_Write : in std_logic;
      FSL4_M_Data : in std_logic_vector(0 to 31);
      FSL4_M_Control : in std_logic;
      FSL4_M_Full : out std_logic;
      FSL4_S_Clk : in std_logic;
      FSL4_S_Read : in std_logic;
      FSL4_S_Data : out std_logic_vector(0 to 31);
      FSL4_S_Control : out std_logic;
      FSL4_S_Exists : out std_logic;
      SPLB4_Clk : in std_logic;
      SPLB4_Rst : in std_logic;
      SPLB4_PLB_ABus : in std_logic_vector(0 to 31);
      SPLB4_PLB_PAValid : in std_logic;
      SPLB4_PLB_SAValid : in std_logic;
      SPLB4_PLB_masterID : in std_logic_vector(0 to 0);
      SPLB4_PLB_RNW : in std_logic;
      SPLB4_PLB_BE : in std_logic_vector(0 to 7);
      SPLB4_PLB_UABus : in std_logic_vector(0 to 31);
      SPLB4_PLB_rdPrim : in std_logic;
      SPLB4_PLB_wrPrim : in std_logic;
      SPLB4_PLB_abort : in std_logic;
      SPLB4_PLB_busLock : in std_logic;
      SPLB4_PLB_MSize : in std_logic_vector(0 to 1);
      SPLB4_PLB_size : in std_logic_vector(0 to 3);
      SPLB4_PLB_type : in std_logic_vector(0 to 2);
      SPLB4_PLB_lockErr : in std_logic;
      SPLB4_PLB_wrPendReq : in std_logic;
      SPLB4_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SPLB4_PLB_rdPendReq : in std_logic;
      SPLB4_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SPLB4_PLB_reqPri : in std_logic_vector(0 to 1);
      SPLB4_PLB_TAttribute : in std_logic_vector(0 to 15);
      SPLB4_PLB_rdBurst : in std_logic;
      SPLB4_PLB_wrBurst : in std_logic;
      SPLB4_PLB_wrDBus : in std_logic_vector(0 to 63);
      SPLB4_Sl_addrAck : out std_logic;
      SPLB4_Sl_SSize : out std_logic_vector(0 to 1);
      SPLB4_Sl_wait : out std_logic;
      SPLB4_Sl_rearbitrate : out std_logic;
      SPLB4_Sl_wrDAck : out std_logic;
      SPLB4_Sl_wrComp : out std_logic;
      SPLB4_Sl_wrBTerm : out std_logic;
      SPLB4_Sl_rdDBus : out std_logic_vector(0 to 63);
      SPLB4_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SPLB4_Sl_rdDAck : out std_logic;
      SPLB4_Sl_rdComp : out std_logic;
      SPLB4_Sl_rdBTerm : out std_logic;
      SPLB4_Sl_MBusy : out std_logic_vector(0 to 0);
      SPLB4_Sl_MRdErr : out std_logic_vector(0 to 0);
      SPLB4_Sl_MWrErr : out std_logic_vector(0 to 0);
      SPLB4_Sl_MIRQ : out std_logic_vector(0 to 0);
      SDMA4_Clk : in std_logic;
      SDMA4_Rx_IntOut : out std_logic;
      SDMA4_Tx_IntOut : out std_logic;
      SDMA4_RstOut : out std_logic;
      SDMA4_TX_D : out std_logic_vector(0 to 31);
      SDMA4_TX_Rem : out std_logic_vector(0 to 3);
      SDMA4_TX_SOF : out std_logic;
      SDMA4_TX_EOF : out std_logic;
      SDMA4_TX_SOP : out std_logic;
      SDMA4_TX_EOP : out std_logic;
      SDMA4_TX_Src_Rdy : out std_logic;
      SDMA4_TX_Dst_Rdy : in std_logic;
      SDMA4_RX_D : in std_logic_vector(0 to 31);
      SDMA4_RX_Rem : in std_logic_vector(0 to 3);
      SDMA4_RX_SOF : in std_logic;
      SDMA4_RX_EOF : in std_logic;
      SDMA4_RX_SOP : in std_logic;
      SDMA4_RX_EOP : in std_logic;
      SDMA4_RX_Src_Rdy : in std_logic;
      SDMA4_RX_Dst_Rdy : out std_logic;
      SDMA_CTRL4_Clk : in std_logic;
      SDMA_CTRL4_Rst : in std_logic;
      SDMA_CTRL4_PLB_ABus : in std_logic_vector(0 to 31);
      SDMA_CTRL4_PLB_PAValid : in std_logic;
      SDMA_CTRL4_PLB_SAValid : in std_logic;
      SDMA_CTRL4_PLB_masterID : in std_logic_vector(0 to 0);
      SDMA_CTRL4_PLB_RNW : in std_logic;
      SDMA_CTRL4_PLB_BE : in std_logic_vector(0 to 7);
      SDMA_CTRL4_PLB_UABus : in std_logic_vector(0 to 31);
      SDMA_CTRL4_PLB_rdPrim : in std_logic;
      SDMA_CTRL4_PLB_wrPrim : in std_logic;
      SDMA_CTRL4_PLB_abort : in std_logic;
      SDMA_CTRL4_PLB_busLock : in std_logic;
      SDMA_CTRL4_PLB_MSize : in std_logic_vector(0 to 1);
      SDMA_CTRL4_PLB_size : in std_logic_vector(0 to 3);
      SDMA_CTRL4_PLB_type : in std_logic_vector(0 to 2);
      SDMA_CTRL4_PLB_lockErr : in std_logic;
      SDMA_CTRL4_PLB_wrPendReq : in std_logic;
      SDMA_CTRL4_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL4_PLB_rdPendReq : in std_logic;
      SDMA_CTRL4_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL4_PLB_reqPri : in std_logic_vector(0 to 1);
      SDMA_CTRL4_PLB_TAttribute : in std_logic_vector(0 to 15);
      SDMA_CTRL4_PLB_rdBurst : in std_logic;
      SDMA_CTRL4_PLB_wrBurst : in std_logic;
      SDMA_CTRL4_PLB_wrDBus : in std_logic_vector(0 to 63);
      SDMA_CTRL4_Sl_addrAck : out std_logic;
      SDMA_CTRL4_Sl_SSize : out std_logic_vector(0 to 1);
      SDMA_CTRL4_Sl_wait : out std_logic;
      SDMA_CTRL4_Sl_rearbitrate : out std_logic;
      SDMA_CTRL4_Sl_wrDAck : out std_logic;
      SDMA_CTRL4_Sl_wrComp : out std_logic;
      SDMA_CTRL4_Sl_wrBTerm : out std_logic;
      SDMA_CTRL4_Sl_rdDBus : out std_logic_vector(0 to 63);
      SDMA_CTRL4_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SDMA_CTRL4_Sl_rdDAck : out std_logic;
      SDMA_CTRL4_Sl_rdComp : out std_logic;
      SDMA_CTRL4_Sl_rdBTerm : out std_logic;
      SDMA_CTRL4_Sl_MBusy : out std_logic_vector(0 to 0);
      SDMA_CTRL4_Sl_MRdErr : out std_logic_vector(0 to 0);
      SDMA_CTRL4_Sl_MWrErr : out std_logic_vector(0 to 0);
      SDMA_CTRL4_Sl_MIRQ : out std_logic_vector(0 to 0);
      PIM4_Addr : in std_logic_vector(31 downto 0);
      PIM4_AddrReq : in std_logic;
      PIM4_AddrAck : out std_logic;
      PIM4_RNW : in std_logic;
      PIM4_Size : in std_logic_vector(3 downto 0);
      PIM4_RdModWr : in std_logic;
      PIM4_WrFIFO_Data : in std_logic_vector(63 downto 0);
      PIM4_WrFIFO_BE : in std_logic_vector(7 downto 0);
      PIM4_WrFIFO_Push : in std_logic;
      PIM4_RdFIFO_Data : out std_logic_vector(63 downto 0);
      PIM4_RdFIFO_Pop : in std_logic;
      PIM4_RdFIFO_RdWdAddr : out std_logic_vector(3 downto 0);
      PIM4_WrFIFO_Empty : out std_logic;
      PIM4_WrFIFO_AlmostFull : out std_logic;
      PIM4_WrFIFO_Flush : in std_logic;
      PIM4_RdFIFO_Empty : out std_logic;
      PIM4_RdFIFO_Flush : in std_logic;
      PIM4_RdFIFO_Latency : out std_logic_vector(1 downto 0);
      PIM4_InitDone : out std_logic;
      PPC440MC4_MIMCReadNotWrite : in std_logic;
      PPC440MC4_MIMCAddress : in std_logic_vector(0 to 35);
      PPC440MC4_MIMCAddressValid : in std_logic;
      PPC440MC4_MIMCWriteData : in std_logic_vector(0 to 127);
      PPC440MC4_MIMCWriteDataValid : in std_logic;
      PPC440MC4_MIMCByteEnable : in std_logic_vector(0 to 15);
      PPC440MC4_MIMCBankConflict : in std_logic;
      PPC440MC4_MIMCRowConflict : in std_logic;
      PPC440MC4_MCMIReadData : out std_logic_vector(0 to 127);
      PPC440MC4_MCMIReadDataValid : out std_logic;
      PPC440MC4_MCMIReadDataErr : out std_logic;
      PPC440MC4_MCMIAddrReadyToAccept : out std_logic;
      VFBC4_Cmd_Clk : in std_logic;
      VFBC4_Cmd_Reset : in std_logic;
      VFBC4_Cmd_Data : in std_logic_vector(31 downto 0);
      VFBC4_Cmd_Write : in std_logic;
      VFBC4_Cmd_End : in std_logic;
      VFBC4_Cmd_Full : out std_logic;
      VFBC4_Cmd_Almost_Full : out std_logic;
      VFBC4_Cmd_Idle : out std_logic;
      VFBC4_Wd_Clk : in std_logic;
      VFBC4_Wd_Reset : in std_logic;
      VFBC4_Wd_Write : in std_logic;
      VFBC4_Wd_End_Burst : in std_logic;
      VFBC4_Wd_Flush : in std_logic;
      VFBC4_Wd_Data : in std_logic_vector(31 downto 0);
      VFBC4_Wd_Data_BE : in std_logic_vector(3 downto 0);
      VFBC4_Wd_Full : out std_logic;
      VFBC4_Wd_Almost_Full : out std_logic;
      VFBC4_Rd_Clk : in std_logic;
      VFBC4_Rd_Reset : in std_logic;
      VFBC4_Rd_Read : in std_logic;
      VFBC4_Rd_End_Burst : in std_logic;
      VFBC4_Rd_Flush : in std_logic;
      VFBC4_Rd_Data : out std_logic_vector(31 downto 0);
      VFBC4_Rd_Empty : out std_logic;
      VFBC4_Rd_Almost_Empty : out std_logic;
      FSL5_M_Clk : in std_logic;
      FSL5_M_Write : in std_logic;
      FSL5_M_Data : in std_logic_vector(0 to 31);
      FSL5_M_Control : in std_logic;
      FSL5_M_Full : out std_logic;
      FSL5_S_Clk : in std_logic;
      FSL5_S_Read : in std_logic;
      FSL5_S_Data : out std_logic_vector(0 to 31);
      FSL5_S_Control : out std_logic;
      FSL5_S_Exists : out std_logic;
      SPLB5_Clk : in std_logic;
      SPLB5_Rst : in std_logic;
      SPLB5_PLB_ABus : in std_logic_vector(0 to 31);
      SPLB5_PLB_PAValid : in std_logic;
      SPLB5_PLB_SAValid : in std_logic;
      SPLB5_PLB_masterID : in std_logic_vector(0 to 0);
      SPLB5_PLB_RNW : in std_logic;
      SPLB5_PLB_BE : in std_logic_vector(0 to 7);
      SPLB5_PLB_UABus : in std_logic_vector(0 to 31);
      SPLB5_PLB_rdPrim : in std_logic;
      SPLB5_PLB_wrPrim : in std_logic;
      SPLB5_PLB_abort : in std_logic;
      SPLB5_PLB_busLock : in std_logic;
      SPLB5_PLB_MSize : in std_logic_vector(0 to 1);
      SPLB5_PLB_size : in std_logic_vector(0 to 3);
      SPLB5_PLB_type : in std_logic_vector(0 to 2);
      SPLB5_PLB_lockErr : in std_logic;
      SPLB5_PLB_wrPendReq : in std_logic;
      SPLB5_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SPLB5_PLB_rdPendReq : in std_logic;
      SPLB5_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SPLB5_PLB_reqPri : in std_logic_vector(0 to 1);
      SPLB5_PLB_TAttribute : in std_logic_vector(0 to 15);
      SPLB5_PLB_rdBurst : in std_logic;
      SPLB5_PLB_wrBurst : in std_logic;
      SPLB5_PLB_wrDBus : in std_logic_vector(0 to 63);
      SPLB5_Sl_addrAck : out std_logic;
      SPLB5_Sl_SSize : out std_logic_vector(0 to 1);
      SPLB5_Sl_wait : out std_logic;
      SPLB5_Sl_rearbitrate : out std_logic;
      SPLB5_Sl_wrDAck : out std_logic;
      SPLB5_Sl_wrComp : out std_logic;
      SPLB5_Sl_wrBTerm : out std_logic;
      SPLB5_Sl_rdDBus : out std_logic_vector(0 to 63);
      SPLB5_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SPLB5_Sl_rdDAck : out std_logic;
      SPLB5_Sl_rdComp : out std_logic;
      SPLB5_Sl_rdBTerm : out std_logic;
      SPLB5_Sl_MBusy : out std_logic_vector(0 to 0);
      SPLB5_Sl_MRdErr : out std_logic_vector(0 to 0);
      SPLB5_Sl_MWrErr : out std_logic_vector(0 to 0);
      SPLB5_Sl_MIRQ : out std_logic_vector(0 to 0);
      SDMA5_Clk : in std_logic;
      SDMA5_Rx_IntOut : out std_logic;
      SDMA5_Tx_IntOut : out std_logic;
      SDMA5_RstOut : out std_logic;
      SDMA5_TX_D : out std_logic_vector(0 to 31);
      SDMA5_TX_Rem : out std_logic_vector(0 to 3);
      SDMA5_TX_SOF : out std_logic;
      SDMA5_TX_EOF : out std_logic;
      SDMA5_TX_SOP : out std_logic;
      SDMA5_TX_EOP : out std_logic;
      SDMA5_TX_Src_Rdy : out std_logic;
      SDMA5_TX_Dst_Rdy : in std_logic;
      SDMA5_RX_D : in std_logic_vector(0 to 31);
      SDMA5_RX_Rem : in std_logic_vector(0 to 3);
      SDMA5_RX_SOF : in std_logic;
      SDMA5_RX_EOF : in std_logic;
      SDMA5_RX_SOP : in std_logic;
      SDMA5_RX_EOP : in std_logic;
      SDMA5_RX_Src_Rdy : in std_logic;
      SDMA5_RX_Dst_Rdy : out std_logic;
      SDMA_CTRL5_Clk : in std_logic;
      SDMA_CTRL5_Rst : in std_logic;
      SDMA_CTRL5_PLB_ABus : in std_logic_vector(0 to 31);
      SDMA_CTRL5_PLB_PAValid : in std_logic;
      SDMA_CTRL5_PLB_SAValid : in std_logic;
      SDMA_CTRL5_PLB_masterID : in std_logic_vector(0 to 0);
      SDMA_CTRL5_PLB_RNW : in std_logic;
      SDMA_CTRL5_PLB_BE : in std_logic_vector(0 to 7);
      SDMA_CTRL5_PLB_UABus : in std_logic_vector(0 to 31);
      SDMA_CTRL5_PLB_rdPrim : in std_logic;
      SDMA_CTRL5_PLB_wrPrim : in std_logic;
      SDMA_CTRL5_PLB_abort : in std_logic;
      SDMA_CTRL5_PLB_busLock : in std_logic;
      SDMA_CTRL5_PLB_MSize : in std_logic_vector(0 to 1);
      SDMA_CTRL5_PLB_size : in std_logic_vector(0 to 3);
      SDMA_CTRL5_PLB_type : in std_logic_vector(0 to 2);
      SDMA_CTRL5_PLB_lockErr : in std_logic;
      SDMA_CTRL5_PLB_wrPendReq : in std_logic;
      SDMA_CTRL5_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL5_PLB_rdPendReq : in std_logic;
      SDMA_CTRL5_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL5_PLB_reqPri : in std_logic_vector(0 to 1);
      SDMA_CTRL5_PLB_TAttribute : in std_logic_vector(0 to 15);
      SDMA_CTRL5_PLB_rdBurst : in std_logic;
      SDMA_CTRL5_PLB_wrBurst : in std_logic;
      SDMA_CTRL5_PLB_wrDBus : in std_logic_vector(0 to 63);
      SDMA_CTRL5_Sl_addrAck : out std_logic;
      SDMA_CTRL5_Sl_SSize : out std_logic_vector(0 to 1);
      SDMA_CTRL5_Sl_wait : out std_logic;
      SDMA_CTRL5_Sl_rearbitrate : out std_logic;
      SDMA_CTRL5_Sl_wrDAck : out std_logic;
      SDMA_CTRL5_Sl_wrComp : out std_logic;
      SDMA_CTRL5_Sl_wrBTerm : out std_logic;
      SDMA_CTRL5_Sl_rdDBus : out std_logic_vector(0 to 63);
      SDMA_CTRL5_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SDMA_CTRL5_Sl_rdDAck : out std_logic;
      SDMA_CTRL5_Sl_rdComp : out std_logic;
      SDMA_CTRL5_Sl_rdBTerm : out std_logic;
      SDMA_CTRL5_Sl_MBusy : out std_logic_vector(0 to 0);
      SDMA_CTRL5_Sl_MRdErr : out std_logic_vector(0 to 0);
      SDMA_CTRL5_Sl_MWrErr : out std_logic_vector(0 to 0);
      SDMA_CTRL5_Sl_MIRQ : out std_logic_vector(0 to 0);
      PIM5_Addr : in std_logic_vector(31 downto 0);
      PIM5_AddrReq : in std_logic;
      PIM5_AddrAck : out std_logic;
      PIM5_RNW : in std_logic;
      PIM5_Size : in std_logic_vector(3 downto 0);
      PIM5_RdModWr : in std_logic;
      PIM5_WrFIFO_Data : in std_logic_vector(63 downto 0);
      PIM5_WrFIFO_BE : in std_logic_vector(7 downto 0);
      PIM5_WrFIFO_Push : in std_logic;
      PIM5_RdFIFO_Data : out std_logic_vector(63 downto 0);
      PIM5_RdFIFO_Pop : in std_logic;
      PIM5_RdFIFO_RdWdAddr : out std_logic_vector(3 downto 0);
      PIM5_WrFIFO_Empty : out std_logic;
      PIM5_WrFIFO_AlmostFull : out std_logic;
      PIM5_WrFIFO_Flush : in std_logic;
      PIM5_RdFIFO_Empty : out std_logic;
      PIM5_RdFIFO_Flush : in std_logic;
      PIM5_RdFIFO_Latency : out std_logic_vector(1 downto 0);
      PIM5_InitDone : out std_logic;
      PPC440MC5_MIMCReadNotWrite : in std_logic;
      PPC440MC5_MIMCAddress : in std_logic_vector(0 to 35);
      PPC440MC5_MIMCAddressValid : in std_logic;
      PPC440MC5_MIMCWriteData : in std_logic_vector(0 to 127);
      PPC440MC5_MIMCWriteDataValid : in std_logic;
      PPC440MC5_MIMCByteEnable : in std_logic_vector(0 to 15);
      PPC440MC5_MIMCBankConflict : in std_logic;
      PPC440MC5_MIMCRowConflict : in std_logic;
      PPC440MC5_MCMIReadData : out std_logic_vector(0 to 127);
      PPC440MC5_MCMIReadDataValid : out std_logic;
      PPC440MC5_MCMIReadDataErr : out std_logic;
      PPC440MC5_MCMIAddrReadyToAccept : out std_logic;
      VFBC5_Cmd_Clk : in std_logic;
      VFBC5_Cmd_Reset : in std_logic;
      VFBC5_Cmd_Data : in std_logic_vector(31 downto 0);
      VFBC5_Cmd_Write : in std_logic;
      VFBC5_Cmd_End : in std_logic;
      VFBC5_Cmd_Full : out std_logic;
      VFBC5_Cmd_Almost_Full : out std_logic;
      VFBC5_Cmd_Idle : out std_logic;
      VFBC5_Wd_Clk : in std_logic;
      VFBC5_Wd_Reset : in std_logic;
      VFBC5_Wd_Write : in std_logic;
      VFBC5_Wd_End_Burst : in std_logic;
      VFBC5_Wd_Flush : in std_logic;
      VFBC5_Wd_Data : in std_logic_vector(31 downto 0);
      VFBC5_Wd_Data_BE : in std_logic_vector(3 downto 0);
      VFBC5_Wd_Full : out std_logic;
      VFBC5_Wd_Almost_Full : out std_logic;
      VFBC5_Rd_Clk : in std_logic;
      VFBC5_Rd_Reset : in std_logic;
      VFBC5_Rd_Read : in std_logic;
      VFBC5_Rd_End_Burst : in std_logic;
      VFBC5_Rd_Flush : in std_logic;
      VFBC5_Rd_Data : out std_logic_vector(31 downto 0);
      VFBC5_Rd_Empty : out std_logic;
      VFBC5_Rd_Almost_Empty : out std_logic;
      FSL6_M_Clk : in std_logic;
      FSL6_M_Write : in std_logic;
      FSL6_M_Data : in std_logic_vector(0 to 31);
      FSL6_M_Control : in std_logic;
      FSL6_M_Full : out std_logic;
      FSL6_S_Clk : in std_logic;
      FSL6_S_Read : in std_logic;
      FSL6_S_Data : out std_logic_vector(0 to 31);
      FSL6_S_Control : out std_logic;
      FSL6_S_Exists : out std_logic;
      SPLB6_Clk : in std_logic;
      SPLB6_Rst : in std_logic;
      SPLB6_PLB_ABus : in std_logic_vector(0 to 31);
      SPLB6_PLB_PAValid : in std_logic;
      SPLB6_PLB_SAValid : in std_logic;
      SPLB6_PLB_masterID : in std_logic_vector(0 to 0);
      SPLB6_PLB_RNW : in std_logic;
      SPLB6_PLB_BE : in std_logic_vector(0 to 7);
      SPLB6_PLB_UABus : in std_logic_vector(0 to 31);
      SPLB6_PLB_rdPrim : in std_logic;
      SPLB6_PLB_wrPrim : in std_logic;
      SPLB6_PLB_abort : in std_logic;
      SPLB6_PLB_busLock : in std_logic;
      SPLB6_PLB_MSize : in std_logic_vector(0 to 1);
      SPLB6_PLB_size : in std_logic_vector(0 to 3);
      SPLB6_PLB_type : in std_logic_vector(0 to 2);
      SPLB6_PLB_lockErr : in std_logic;
      SPLB6_PLB_wrPendReq : in std_logic;
      SPLB6_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SPLB6_PLB_rdPendReq : in std_logic;
      SPLB6_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SPLB6_PLB_reqPri : in std_logic_vector(0 to 1);
      SPLB6_PLB_TAttribute : in std_logic_vector(0 to 15);
      SPLB6_PLB_rdBurst : in std_logic;
      SPLB6_PLB_wrBurst : in std_logic;
      SPLB6_PLB_wrDBus : in std_logic_vector(0 to 63);
      SPLB6_Sl_addrAck : out std_logic;
      SPLB6_Sl_SSize : out std_logic_vector(0 to 1);
      SPLB6_Sl_wait : out std_logic;
      SPLB6_Sl_rearbitrate : out std_logic;
      SPLB6_Sl_wrDAck : out std_logic;
      SPLB6_Sl_wrComp : out std_logic;
      SPLB6_Sl_wrBTerm : out std_logic;
      SPLB6_Sl_rdDBus : out std_logic_vector(0 to 63);
      SPLB6_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SPLB6_Sl_rdDAck : out std_logic;
      SPLB6_Sl_rdComp : out std_logic;
      SPLB6_Sl_rdBTerm : out std_logic;
      SPLB6_Sl_MBusy : out std_logic_vector(0 to 0);
      SPLB6_Sl_MRdErr : out std_logic_vector(0 to 0);
      SPLB6_Sl_MWrErr : out std_logic_vector(0 to 0);
      SPLB6_Sl_MIRQ : out std_logic_vector(0 to 0);
      SDMA6_Clk : in std_logic;
      SDMA6_Rx_IntOut : out std_logic;
      SDMA6_Tx_IntOut : out std_logic;
      SDMA6_RstOut : out std_logic;
      SDMA6_TX_D : out std_logic_vector(0 to 31);
      SDMA6_TX_Rem : out std_logic_vector(0 to 3);
      SDMA6_TX_SOF : out std_logic;
      SDMA6_TX_EOF : out std_logic;
      SDMA6_TX_SOP : out std_logic;
      SDMA6_TX_EOP : out std_logic;
      SDMA6_TX_Src_Rdy : out std_logic;
      SDMA6_TX_Dst_Rdy : in std_logic;
      SDMA6_RX_D : in std_logic_vector(0 to 31);
      SDMA6_RX_Rem : in std_logic_vector(0 to 3);
      SDMA6_RX_SOF : in std_logic;
      SDMA6_RX_EOF : in std_logic;
      SDMA6_RX_SOP : in std_logic;
      SDMA6_RX_EOP : in std_logic;
      SDMA6_RX_Src_Rdy : in std_logic;
      SDMA6_RX_Dst_Rdy : out std_logic;
      SDMA_CTRL6_Clk : in std_logic;
      SDMA_CTRL6_Rst : in std_logic;
      SDMA_CTRL6_PLB_ABus : in std_logic_vector(0 to 31);
      SDMA_CTRL6_PLB_PAValid : in std_logic;
      SDMA_CTRL6_PLB_SAValid : in std_logic;
      SDMA_CTRL6_PLB_masterID : in std_logic_vector(0 to 0);
      SDMA_CTRL6_PLB_RNW : in std_logic;
      SDMA_CTRL6_PLB_BE : in std_logic_vector(0 to 7);
      SDMA_CTRL6_PLB_UABus : in std_logic_vector(0 to 31);
      SDMA_CTRL6_PLB_rdPrim : in std_logic;
      SDMA_CTRL6_PLB_wrPrim : in std_logic;
      SDMA_CTRL6_PLB_abort : in std_logic;
      SDMA_CTRL6_PLB_busLock : in std_logic;
      SDMA_CTRL6_PLB_MSize : in std_logic_vector(0 to 1);
      SDMA_CTRL6_PLB_size : in std_logic_vector(0 to 3);
      SDMA_CTRL6_PLB_type : in std_logic_vector(0 to 2);
      SDMA_CTRL6_PLB_lockErr : in std_logic;
      SDMA_CTRL6_PLB_wrPendReq : in std_logic;
      SDMA_CTRL6_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL6_PLB_rdPendReq : in std_logic;
      SDMA_CTRL6_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL6_PLB_reqPri : in std_logic_vector(0 to 1);
      SDMA_CTRL6_PLB_TAttribute : in std_logic_vector(0 to 15);
      SDMA_CTRL6_PLB_rdBurst : in std_logic;
      SDMA_CTRL6_PLB_wrBurst : in std_logic;
      SDMA_CTRL6_PLB_wrDBus : in std_logic_vector(0 to 63);
      SDMA_CTRL6_Sl_addrAck : out std_logic;
      SDMA_CTRL6_Sl_SSize : out std_logic_vector(0 to 1);
      SDMA_CTRL6_Sl_wait : out std_logic;
      SDMA_CTRL6_Sl_rearbitrate : out std_logic;
      SDMA_CTRL6_Sl_wrDAck : out std_logic;
      SDMA_CTRL6_Sl_wrComp : out std_logic;
      SDMA_CTRL6_Sl_wrBTerm : out std_logic;
      SDMA_CTRL6_Sl_rdDBus : out std_logic_vector(0 to 63);
      SDMA_CTRL6_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SDMA_CTRL6_Sl_rdDAck : out std_logic;
      SDMA_CTRL6_Sl_rdComp : out std_logic;
      SDMA_CTRL6_Sl_rdBTerm : out std_logic;
      SDMA_CTRL6_Sl_MBusy : out std_logic_vector(0 to 0);
      SDMA_CTRL6_Sl_MRdErr : out std_logic_vector(0 to 0);
      SDMA_CTRL6_Sl_MWrErr : out std_logic_vector(0 to 0);
      SDMA_CTRL6_Sl_MIRQ : out std_logic_vector(0 to 0);
      PIM6_Addr : in std_logic_vector(31 downto 0);
      PIM6_AddrReq : in std_logic;
      PIM6_AddrAck : out std_logic;
      PIM6_RNW : in std_logic;
      PIM6_Size : in std_logic_vector(3 downto 0);
      PIM6_RdModWr : in std_logic;
      PIM6_WrFIFO_Data : in std_logic_vector(63 downto 0);
      PIM6_WrFIFO_BE : in std_logic_vector(7 downto 0);
      PIM6_WrFIFO_Push : in std_logic;
      PIM6_RdFIFO_Data : out std_logic_vector(63 downto 0);
      PIM6_RdFIFO_Pop : in std_logic;
      PIM6_RdFIFO_RdWdAddr : out std_logic_vector(3 downto 0);
      PIM6_WrFIFO_Empty : out std_logic;
      PIM6_WrFIFO_AlmostFull : out std_logic;
      PIM6_WrFIFO_Flush : in std_logic;
      PIM6_RdFIFO_Empty : out std_logic;
      PIM6_RdFIFO_Flush : in std_logic;
      PIM6_RdFIFO_Latency : out std_logic_vector(1 downto 0);
      PIM6_InitDone : out std_logic;
      PPC440MC6_MIMCReadNotWrite : in std_logic;
      PPC440MC6_MIMCAddress : in std_logic_vector(0 to 35);
      PPC440MC6_MIMCAddressValid : in std_logic;
      PPC440MC6_MIMCWriteData : in std_logic_vector(0 to 127);
      PPC440MC6_MIMCWriteDataValid : in std_logic;
      PPC440MC6_MIMCByteEnable : in std_logic_vector(0 to 15);
      PPC440MC6_MIMCBankConflict : in std_logic;
      PPC440MC6_MIMCRowConflict : in std_logic;
      PPC440MC6_MCMIReadData : out std_logic_vector(0 to 127);
      PPC440MC6_MCMIReadDataValid : out std_logic;
      PPC440MC6_MCMIReadDataErr : out std_logic;
      PPC440MC6_MCMIAddrReadyToAccept : out std_logic;
      VFBC6_Cmd_Clk : in std_logic;
      VFBC6_Cmd_Reset : in std_logic;
      VFBC6_Cmd_Data : in std_logic_vector(31 downto 0);
      VFBC6_Cmd_Write : in std_logic;
      VFBC6_Cmd_End : in std_logic;
      VFBC6_Cmd_Full : out std_logic;
      VFBC6_Cmd_Almost_Full : out std_logic;
      VFBC6_Cmd_Idle : out std_logic;
      VFBC6_Wd_Clk : in std_logic;
      VFBC6_Wd_Reset : in std_logic;
      VFBC6_Wd_Write : in std_logic;
      VFBC6_Wd_End_Burst : in std_logic;
      VFBC6_Wd_Flush : in std_logic;
      VFBC6_Wd_Data : in std_logic_vector(31 downto 0);
      VFBC6_Wd_Data_BE : in std_logic_vector(3 downto 0);
      VFBC6_Wd_Full : out std_logic;
      VFBC6_Wd_Almost_Full : out std_logic;
      VFBC6_Rd_Clk : in std_logic;
      VFBC6_Rd_Reset : in std_logic;
      VFBC6_Rd_Read : in std_logic;
      VFBC6_Rd_End_Burst : in std_logic;
      VFBC6_Rd_Flush : in std_logic;
      VFBC6_Rd_Data : out std_logic_vector(31 downto 0);
      VFBC6_Rd_Empty : out std_logic;
      VFBC6_Rd_Almost_Empty : out std_logic;
      FSL7_M_Clk : in std_logic;
      FSL7_M_Write : in std_logic;
      FSL7_M_Data : in std_logic_vector(0 to 31);
      FSL7_M_Control : in std_logic;
      FSL7_M_Full : out std_logic;
      FSL7_S_Clk : in std_logic;
      FSL7_S_Read : in std_logic;
      FSL7_S_Data : out std_logic_vector(0 to 31);
      FSL7_S_Control : out std_logic;
      FSL7_S_Exists : out std_logic;
      SPLB7_Clk : in std_logic;
      SPLB7_Rst : in std_logic;
      SPLB7_PLB_ABus : in std_logic_vector(0 to 31);
      SPLB7_PLB_PAValid : in std_logic;
      SPLB7_PLB_SAValid : in std_logic;
      SPLB7_PLB_masterID : in std_logic_vector(0 to 0);
      SPLB7_PLB_RNW : in std_logic;
      SPLB7_PLB_BE : in std_logic_vector(0 to 7);
      SPLB7_PLB_UABus : in std_logic_vector(0 to 31);
      SPLB7_PLB_rdPrim : in std_logic;
      SPLB7_PLB_wrPrim : in std_logic;
      SPLB7_PLB_abort : in std_logic;
      SPLB7_PLB_busLock : in std_logic;
      SPLB7_PLB_MSize : in std_logic_vector(0 to 1);
      SPLB7_PLB_size : in std_logic_vector(0 to 3);
      SPLB7_PLB_type : in std_logic_vector(0 to 2);
      SPLB7_PLB_lockErr : in std_logic;
      SPLB7_PLB_wrPendReq : in std_logic;
      SPLB7_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SPLB7_PLB_rdPendReq : in std_logic;
      SPLB7_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SPLB7_PLB_reqPri : in std_logic_vector(0 to 1);
      SPLB7_PLB_TAttribute : in std_logic_vector(0 to 15);
      SPLB7_PLB_rdBurst : in std_logic;
      SPLB7_PLB_wrBurst : in std_logic;
      SPLB7_PLB_wrDBus : in std_logic_vector(0 to 63);
      SPLB7_Sl_addrAck : out std_logic;
      SPLB7_Sl_SSize : out std_logic_vector(0 to 1);
      SPLB7_Sl_wait : out std_logic;
      SPLB7_Sl_rearbitrate : out std_logic;
      SPLB7_Sl_wrDAck : out std_logic;
      SPLB7_Sl_wrComp : out std_logic;
      SPLB7_Sl_wrBTerm : out std_logic;
      SPLB7_Sl_rdDBus : out std_logic_vector(0 to 63);
      SPLB7_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SPLB7_Sl_rdDAck : out std_logic;
      SPLB7_Sl_rdComp : out std_logic;
      SPLB7_Sl_rdBTerm : out std_logic;
      SPLB7_Sl_MBusy : out std_logic_vector(0 to 0);
      SPLB7_Sl_MRdErr : out std_logic_vector(0 to 0);
      SPLB7_Sl_MWrErr : out std_logic_vector(0 to 0);
      SPLB7_Sl_MIRQ : out std_logic_vector(0 to 0);
      SDMA7_Clk : in std_logic;
      SDMA7_Rx_IntOut : out std_logic;
      SDMA7_Tx_IntOut : out std_logic;
      SDMA7_RstOut : out std_logic;
      SDMA7_TX_D : out std_logic_vector(0 to 31);
      SDMA7_TX_Rem : out std_logic_vector(0 to 3);
      SDMA7_TX_SOF : out std_logic;
      SDMA7_TX_EOF : out std_logic;
      SDMA7_TX_SOP : out std_logic;
      SDMA7_TX_EOP : out std_logic;
      SDMA7_TX_Src_Rdy : out std_logic;
      SDMA7_TX_Dst_Rdy : in std_logic;
      SDMA7_RX_D : in std_logic_vector(0 to 31);
      SDMA7_RX_Rem : in std_logic_vector(0 to 3);
      SDMA7_RX_SOF : in std_logic;
      SDMA7_RX_EOF : in std_logic;
      SDMA7_RX_SOP : in std_logic;
      SDMA7_RX_EOP : in std_logic;
      SDMA7_RX_Src_Rdy : in std_logic;
      SDMA7_RX_Dst_Rdy : out std_logic;
      SDMA_CTRL7_Clk : in std_logic;
      SDMA_CTRL7_Rst : in std_logic;
      SDMA_CTRL7_PLB_ABus : in std_logic_vector(0 to 31);
      SDMA_CTRL7_PLB_PAValid : in std_logic;
      SDMA_CTRL7_PLB_SAValid : in std_logic;
      SDMA_CTRL7_PLB_masterID : in std_logic_vector(0 to 0);
      SDMA_CTRL7_PLB_RNW : in std_logic;
      SDMA_CTRL7_PLB_BE : in std_logic_vector(0 to 7);
      SDMA_CTRL7_PLB_UABus : in std_logic_vector(0 to 31);
      SDMA_CTRL7_PLB_rdPrim : in std_logic;
      SDMA_CTRL7_PLB_wrPrim : in std_logic;
      SDMA_CTRL7_PLB_abort : in std_logic;
      SDMA_CTRL7_PLB_busLock : in std_logic;
      SDMA_CTRL7_PLB_MSize : in std_logic_vector(0 to 1);
      SDMA_CTRL7_PLB_size : in std_logic_vector(0 to 3);
      SDMA_CTRL7_PLB_type : in std_logic_vector(0 to 2);
      SDMA_CTRL7_PLB_lockErr : in std_logic;
      SDMA_CTRL7_PLB_wrPendReq : in std_logic;
      SDMA_CTRL7_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL7_PLB_rdPendReq : in std_logic;
      SDMA_CTRL7_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL7_PLB_reqPri : in std_logic_vector(0 to 1);
      SDMA_CTRL7_PLB_TAttribute : in std_logic_vector(0 to 15);
      SDMA_CTRL7_PLB_rdBurst : in std_logic;
      SDMA_CTRL7_PLB_wrBurst : in std_logic;
      SDMA_CTRL7_PLB_wrDBus : in std_logic_vector(0 to 63);
      SDMA_CTRL7_Sl_addrAck : out std_logic;
      SDMA_CTRL7_Sl_SSize : out std_logic_vector(0 to 1);
      SDMA_CTRL7_Sl_wait : out std_logic;
      SDMA_CTRL7_Sl_rearbitrate : out std_logic;
      SDMA_CTRL7_Sl_wrDAck : out std_logic;
      SDMA_CTRL7_Sl_wrComp : out std_logic;
      SDMA_CTRL7_Sl_wrBTerm : out std_logic;
      SDMA_CTRL7_Sl_rdDBus : out std_logic_vector(0 to 63);
      SDMA_CTRL7_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SDMA_CTRL7_Sl_rdDAck : out std_logic;
      SDMA_CTRL7_Sl_rdComp : out std_logic;
      SDMA_CTRL7_Sl_rdBTerm : out std_logic;
      SDMA_CTRL7_Sl_MBusy : out std_logic_vector(0 to 0);
      SDMA_CTRL7_Sl_MRdErr : out std_logic_vector(0 to 0);
      SDMA_CTRL7_Sl_MWrErr : out std_logic_vector(0 to 0);
      SDMA_CTRL7_Sl_MIRQ : out std_logic_vector(0 to 0);
      PIM7_Addr : in std_logic_vector(31 downto 0);
      PIM7_AddrReq : in std_logic;
      PIM7_AddrAck : out std_logic;
      PIM7_RNW : in std_logic;
      PIM7_Size : in std_logic_vector(3 downto 0);
      PIM7_RdModWr : in std_logic;
      PIM7_WrFIFO_Data : in std_logic_vector(63 downto 0);
      PIM7_WrFIFO_BE : in std_logic_vector(7 downto 0);
      PIM7_WrFIFO_Push : in std_logic;
      PIM7_RdFIFO_Data : out std_logic_vector(63 downto 0);
      PIM7_RdFIFO_Pop : in std_logic;
      PIM7_RdFIFO_RdWdAddr : out std_logic_vector(3 downto 0);
      PIM7_WrFIFO_Empty : out std_logic;
      PIM7_WrFIFO_AlmostFull : out std_logic;
      PIM7_WrFIFO_Flush : in std_logic;
      PIM7_RdFIFO_Empty : out std_logic;
      PIM7_RdFIFO_Flush : in std_logic;
      PIM7_RdFIFO_Latency : out std_logic_vector(1 downto 0);
      PIM7_InitDone : out std_logic;
      PPC440MC7_MIMCReadNotWrite : in std_logic;
      PPC440MC7_MIMCAddress : in std_logic_vector(0 to 35);
      PPC440MC7_MIMCAddressValid : in std_logic;
      PPC440MC7_MIMCWriteData : in std_logic_vector(0 to 127);
      PPC440MC7_MIMCWriteDataValid : in std_logic;
      PPC440MC7_MIMCByteEnable : in std_logic_vector(0 to 15);
      PPC440MC7_MIMCBankConflict : in std_logic;
      PPC440MC7_MIMCRowConflict : in std_logic;
      PPC440MC7_MCMIReadData : out std_logic_vector(0 to 127);
      PPC440MC7_MCMIReadDataValid : out std_logic;
      PPC440MC7_MCMIReadDataErr : out std_logic;
      PPC440MC7_MCMIAddrReadyToAccept : out std_logic;
      VFBC7_Cmd_Clk : in std_logic;
      VFBC7_Cmd_Reset : in std_logic;
      VFBC7_Cmd_Data : in std_logic_vector(31 downto 0);
      VFBC7_Cmd_Write : in std_logic;
      VFBC7_Cmd_End : in std_logic;
      VFBC7_Cmd_Full : out std_logic;
      VFBC7_Cmd_Almost_Full : out std_logic;
      VFBC7_Cmd_Idle : out std_logic;
      VFBC7_Wd_Clk : in std_logic;
      VFBC7_Wd_Reset : in std_logic;
      VFBC7_Wd_Write : in std_logic;
      VFBC7_Wd_End_Burst : in std_logic;
      VFBC7_Wd_Flush : in std_logic;
      VFBC7_Wd_Data : in std_logic_vector(31 downto 0);
      VFBC7_Wd_Data_BE : in std_logic_vector(3 downto 0);
      VFBC7_Wd_Full : out std_logic;
      VFBC7_Wd_Almost_Full : out std_logic;
      VFBC7_Rd_Clk : in std_logic;
      VFBC7_Rd_Reset : in std_logic;
      VFBC7_Rd_Read : in std_logic;
      VFBC7_Rd_End_Burst : in std_logic;
      VFBC7_Rd_Flush : in std_logic;
      VFBC7_Rd_Data : out std_logic_vector(31 downto 0);
      VFBC7_Rd_Empty : out std_logic;
      VFBC7_Rd_Almost_Empty : out std_logic;
      MPMC_CTRL_Clk : in std_logic;
      MPMC_CTRL_Rst : in std_logic;
      MPMC_CTRL_PLB_ABus : in std_logic_vector(0 to 31);
      MPMC_CTRL_PLB_PAValid : in std_logic;
      MPMC_CTRL_PLB_SAValid : in std_logic;
      MPMC_CTRL_PLB_masterID : in std_logic_vector(0 to 0);
      MPMC_CTRL_PLB_RNW : in std_logic;
      MPMC_CTRL_PLB_BE : in std_logic_vector(0 to 7);
      MPMC_CTRL_PLB_UABus : in std_logic_vector(0 to 31);
      MPMC_CTRL_PLB_rdPrim : in std_logic;
      MPMC_CTRL_PLB_wrPrim : in std_logic;
      MPMC_CTRL_PLB_abort : in std_logic;
      MPMC_CTRL_PLB_busLock : in std_logic;
      MPMC_CTRL_PLB_MSize : in std_logic_vector(0 to 1);
      MPMC_CTRL_PLB_size : in std_logic_vector(0 to 3);
      MPMC_CTRL_PLB_type : in std_logic_vector(0 to 2);
      MPMC_CTRL_PLB_lockErr : in std_logic;
      MPMC_CTRL_PLB_wrPendReq : in std_logic;
      MPMC_CTRL_PLB_wrPendPri : in std_logic_vector(0 to 1);
      MPMC_CTRL_PLB_rdPendReq : in std_logic;
      MPMC_CTRL_PLB_rdPendPri : in std_logic_vector(0 to 1);
      MPMC_CTRL_PLB_reqPri : in std_logic_vector(0 to 1);
      MPMC_CTRL_PLB_TAttribute : in std_logic_vector(0 to 15);
      MPMC_CTRL_PLB_rdBurst : in std_logic;
      MPMC_CTRL_PLB_wrBurst : in std_logic;
      MPMC_CTRL_PLB_wrDBus : in std_logic_vector(0 to 63);
      MPMC_CTRL_Sl_addrAck : out std_logic;
      MPMC_CTRL_Sl_SSize : out std_logic_vector(0 to 1);
      MPMC_CTRL_Sl_wait : out std_logic;
      MPMC_CTRL_Sl_rearbitrate : out std_logic;
      MPMC_CTRL_Sl_wrDAck : out std_logic;
      MPMC_CTRL_Sl_wrComp : out std_logic;
      MPMC_CTRL_Sl_wrBTerm : out std_logic;
      MPMC_CTRL_Sl_rdDBus : out std_logic_vector(0 to 63);
      MPMC_CTRL_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      MPMC_CTRL_Sl_rdDAck : out std_logic;
      MPMC_CTRL_Sl_rdComp : out std_logic;
      MPMC_CTRL_Sl_rdBTerm : out std_logic;
      MPMC_CTRL_Sl_MBusy : out std_logic_vector(0 to 0);
      MPMC_CTRL_Sl_MRdErr : out std_logic_vector(0 to 0);
      MPMC_CTRL_Sl_MWrErr : out std_logic_vector(0 to 0);
      MPMC_CTRL_Sl_MIRQ : out std_logic_vector(0 to 0);
      MPMC_Clk0 : in std_logic;
      MPMC_Clk0_DIV2 : in std_logic;
      MPMC_Clk90 : in std_logic;
      MPMC_Clk_200MHz : in std_logic;
      MPMC_Rst : in std_logic;
      MPMC_Clk_Mem : in std_logic;
      MPMC_Idelayctrl_Rdy_I : in std_logic;
      MPMC_Idelayctrl_Rdy_O : out std_logic;
      MPMC_InitDone : out std_logic;
      MPMC_ECC_Intr : out std_logic;
      MPMC_DCM_PSEN : out std_logic;
      MPMC_DCM_PSINCDEC : out std_logic;
      MPMC_DCM_PSDONE : in std_logic;
      SDRAM_Clk : out std_logic_vector(1 downto 0);
      SDRAM_CE : out std_logic_vector(1 downto 0);
      SDRAM_CS_n : out std_logic_vector(1 downto 0);
      SDRAM_RAS_n : out std_logic;
      SDRAM_CAS_n : out std_logic;
      SDRAM_WE_n : out std_logic;
      SDRAM_BankAddr : out std_logic_vector(1 downto 0);
      SDRAM_Addr : out std_logic_vector(12 downto 0);
      SDRAM_DQ : inout std_logic_vector(63 downto 0);
      SDRAM_DM : out std_logic_vector(7 downto 0);
      DDR_Clk : out std_logic_vector(1 downto 0);
      DDR_Clk_n : out std_logic_vector(1 downto 0);
      DDR_CE : out std_logic_vector(1 downto 0);
      DDR_CS_n : out std_logic_vector(1 downto 0);
      DDR_RAS_n : out std_logic;
      DDR_CAS_n : out std_logic;
      DDR_WE_n : out std_logic;
      DDR_BankAddr : out std_logic_vector(1 downto 0);
      DDR_Addr : out std_logic_vector(12 downto 0);
      DDR_DQ : inout std_logic_vector(63 downto 0);
      DDR_DM : out std_logic_vector(7 downto 0);
      DDR_DQS : inout std_logic_vector(7 downto 0);
      DDR_DQS_Div_O : out std_logic;
      DDR_DQS_Div_I : in std_logic;
      DDR2_Clk : out std_logic_vector(1 downto 0);
      DDR2_Clk_n : out std_logic_vector(1 downto 0);
      DDR2_CE : out std_logic_vector(1 downto 0);
      DDR2_CS_n : out std_logic_vector(1 downto 0);
      DDR2_ODT : out std_logic_vector(1 downto 0);
      DDR2_RAS_n : out std_logic;
      DDR2_CAS_n : out std_logic;
      DDR2_WE_n : out std_logic;
      DDR2_BankAddr : out std_logic_vector(1 downto 0);
      DDR2_Addr : out std_logic_vector(12 downto 0);
      DDR2_DQ : inout std_logic_vector(63 downto 0);
      DDR2_DM : out std_logic_vector(7 downto 0);
      DDR2_DQS : inout std_logic_vector(7 downto 0);
      DDR2_DQS_n : inout std_logic_vector(7 downto 0);
      DDR2_DQS_Div_O : out std_logic;
      DDR2_DQS_Div_I : in std_logic
    );
  end component;

  component xps_timer_1_wrapper is
    port (
      CaptureTrig0 : in std_logic;
      CaptureTrig1 : in std_logic;
      GenerateOut0 : out std_logic;
      GenerateOut1 : out std_logic;
      PWM0 : out std_logic;
      Interrupt : out std_logic;
      Freeze : in std_logic;
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 0);
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to 7);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_wrDBus : in std_logic_vector(0 to 63);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 63);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 1);
      Sl_MWrErr : out std_logic_vector(0 to 1);
      Sl_MRdErr : out std_logic_vector(0 to 1);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_lockErr : in std_logic;
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_wrBTerm : out std_logic;
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdBTerm : out std_logic;
      Sl_MIRQ : out std_logic_vector(0 to 1)
    );
  end component;

  component sram_util_bus_split_0_wrapper is
    port (
      Sig : in std_logic_vector(0 to 31);
      Out1 : out std_logic_vector(7 to 30);
      Out2 : out std_logic_vector(31 to 31)
    );
  end component;

  component ddr2_sdram_util_bus_split_1_wrapper is
    port (
      Sig : in std_logic_vector(0 to 1);
      Out1 : out std_logic_vector(0 to 0);
      Out2 : out std_logic_vector(1 to 1)
    );
  end component;

  component ddr2_sdram_util_bus_split_2_wrapper is
    port (
      Sig : in std_logic_vector(0 to 1);
      Out1 : out std_logic_vector(0 to 0);
      Out2 : out std_logic_vector(1 to 1)
    );
  end component;

  component clock_generator_0_wrapper is
    port (
      CLKIN : in std_logic;
      CLKFBIN : in std_logic;
      CLKOUT0 : out std_logic;
      CLKOUT1 : out std_logic;
      CLKOUT2 : out std_logic;
      CLKOUT3 : out std_logic;
      CLKOUT4 : out std_logic;
      CLKOUT5 : out std_logic;
      CLKOUT6 : out std_logic;
      CLKOUT7 : out std_logic;
      CLKOUT8 : out std_logic;
      CLKOUT9 : out std_logic;
      CLKOUT10 : out std_logic;
      CLKOUT11 : out std_logic;
      CLKOUT12 : out std_logic;
      CLKOUT13 : out std_logic;
      CLKOUT14 : out std_logic;
      CLKOUT15 : out std_logic;
      CLKFBOUT : out std_logic;
      RST : in std_logic;
      LOCKED : out std_logic
    );
  end component;

  component debug_module_wrapper is
    port (
      Interrupt : out std_logic;
      Debug_SYS_Rst : out std_logic;
      Ext_BRK : out std_logic;
      Ext_NM_BRK : out std_logic;
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 0);
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to 7);
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_lockErr : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to 63);
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_wrBTerm : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 63);
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_rdBTerm : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 1);
      Sl_MWrErr : out std_logic_vector(0 to 1);
      Sl_MRdErr : out std_logic_vector(0 to 1);
      Sl_MIRQ : out std_logic_vector(0 to 1);
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      OPB_DBus : in std_logic_vector(0 to 31);
      MDM_DBus : out std_logic_vector(0 to 31);
      MDM_errAck : out std_logic;
      MDM_retry : out std_logic;
      MDM_toutSup : out std_logic;
      MDM_xferAck : out std_logic;
      Dbg_Clk_0 : out std_logic;
      Dbg_TDI_0 : out std_logic;
      Dbg_TDO_0 : in std_logic;
      Dbg_Reg_En_0 : out std_logic_vector(0 to 4);
      Dbg_Capture_0 : out std_logic;
      Dbg_Shift_0 : out std_logic;
      Dbg_Update_0 : out std_logic;
      Dbg_Rst_0 : out std_logic;
      Dbg_Clk_1 : out std_logic;
      Dbg_TDI_1 : out std_logic;
      Dbg_TDO_1 : in std_logic;
      Dbg_Reg_En_1 : out std_logic_vector(0 to 4);
      Dbg_Capture_1 : out std_logic;
      Dbg_Shift_1 : out std_logic;
      Dbg_Update_1 : out std_logic;
      Dbg_Rst_1 : out std_logic;
      Dbg_Clk_2 : out std_logic;
      Dbg_TDI_2 : out std_logic;
      Dbg_TDO_2 : in std_logic;
      Dbg_Reg_En_2 : out std_logic_vector(0 to 4);
      Dbg_Capture_2 : out std_logic;
      Dbg_Shift_2 : out std_logic;
      Dbg_Update_2 : out std_logic;
      Dbg_Rst_2 : out std_logic;
      Dbg_Clk_3 : out std_logic;
      Dbg_TDI_3 : out std_logic;
      Dbg_TDO_3 : in std_logic;
      Dbg_Reg_En_3 : out std_logic_vector(0 to 4);
      Dbg_Capture_3 : out std_logic;
      Dbg_Shift_3 : out std_logic;
      Dbg_Update_3 : out std_logic;
      Dbg_Rst_3 : out std_logic;
      Dbg_Clk_4 : out std_logic;
      Dbg_TDI_4 : out std_logic;
      Dbg_TDO_4 : in std_logic;
      Dbg_Reg_En_4 : out std_logic_vector(0 to 4);
      Dbg_Capture_4 : out std_logic;
      Dbg_Shift_4 : out std_logic;
      Dbg_Update_4 : out std_logic;
      Dbg_Rst_4 : out std_logic;
      Dbg_Clk_5 : out std_logic;
      Dbg_TDI_5 : out std_logic;
      Dbg_TDO_5 : in std_logic;
      Dbg_Reg_En_5 : out std_logic_vector(0 to 4);
      Dbg_Capture_5 : out std_logic;
      Dbg_Shift_5 : out std_logic;
      Dbg_Update_5 : out std_logic;
      Dbg_Rst_5 : out std_logic;
      Dbg_Clk_6 : out std_logic;
      Dbg_TDI_6 : out std_logic;
      Dbg_TDO_6 : in std_logic;
      Dbg_Reg_En_6 : out std_logic_vector(0 to 4);
      Dbg_Capture_6 : out std_logic;
      Dbg_Shift_6 : out std_logic;
      Dbg_Update_6 : out std_logic;
      Dbg_Rst_6 : out std_logic;
      Dbg_Clk_7 : out std_logic;
      Dbg_TDI_7 : out std_logic;
      Dbg_TDO_7 : in std_logic;
      Dbg_Reg_En_7 : out std_logic_vector(0 to 4);
      Dbg_Capture_7 : out std_logic;
      Dbg_Shift_7 : out std_logic;
      Dbg_Update_7 : out std_logic;
      Dbg_Rst_7 : out std_logic;
      bscan_tdi : out std_logic;
      bscan_reset : out std_logic;
      bscan_shift : out std_logic;
      bscan_update : out std_logic;
      bscan_capture : out std_logic;
      bscan_sel1 : out std_logic;
      bscan_drck1 : out std_logic;
      bscan_tdo1 : in std_logic;
      FSL0_S_CLK : out std_logic;
      FSL0_S_READ : out std_logic;
      FSL0_S_DATA : in std_logic_vector(0 to 31);
      FSL0_S_CONTROL : in std_logic;
      FSL0_S_EXISTS : in std_logic;
      FSL0_M_CLK : out std_logic;
      FSL0_M_WRITE : out std_logic;
      FSL0_M_DATA : out std_logic_vector(0 to 31);
      FSL0_M_CONTROL : out std_logic;
      FSL0_M_FULL : in std_logic;
      Ext_JTAG_DRCK : out std_logic;
      Ext_JTAG_RESET : out std_logic;
      Ext_JTAG_SEL : out std_logic;
      Ext_JTAG_CAPTURE : out std_logic;
      Ext_JTAG_SHIFT : out std_logic;
      Ext_JTAG_UPDATE : out std_logic;
      Ext_JTAG_TDI : out std_logic;
      Ext_JTAG_TDO : in std_logic
    );
  end component;

  component proc_sys_reset_0_wrapper is
    port (
      Slowest_sync_clk : in std_logic;
      Ext_Reset_In : in std_logic;
      Aux_Reset_In : in std_logic;
      MB_Debug_Sys_Rst : in std_logic;
      Core_Reset_Req_0 : in std_logic;
      Chip_Reset_Req_0 : in std_logic;
      System_Reset_Req_0 : in std_logic;
      Core_Reset_Req_1 : in std_logic;
      Chip_Reset_Req_1 : in std_logic;
      System_Reset_Req_1 : in std_logic;
      Dcm_locked : in std_logic;
      RstcPPCresetcore_0 : out std_logic;
      RstcPPCresetchip_0 : out std_logic;
      RstcPPCresetsys_0 : out std_logic;
      RstcPPCresetcore_1 : out std_logic;
      RstcPPCresetchip_1 : out std_logic;
      RstcPPCresetsys_1 : out std_logic;
      MB_Reset : out std_logic;
      Bus_Struct_Reset : out std_logic_vector(0 to 0);
      Peripheral_Reset : out std_logic_vector(0 to 0)
    );
  end component;

  component xps_intc_0_wrapper is
    port (
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 0);
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to 7);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_wrDBus : in std_logic_vector(0 to 63);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_lockErr : in std_logic;
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 63);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 1);
      Sl_MWrErr : out std_logic_vector(0 to 1);
      Sl_MRdErr : out std_logic_vector(0 to 1);
      Sl_wrBTerm : out std_logic;
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdBTerm : out std_logic;
      Sl_MIRQ : out std_logic_vector(0 to 1);
      Intr : in std_logic_vector(2 downto 0);
      Irq : out std_logic
    );
  end component;

  component plbv46_opb_bridge_0_wrapper is
    port (
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 0);
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to 7);
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_lockErr : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to 63);
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_wrBTerm : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 63);
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_rdBTerm : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 1);
      Sl_MWrErr : out std_logic_vector(0 to 1);
      Sl_MRdErr : out std_logic_vector(0 to 1);
      Sl_MIRQ : out std_logic_vector(0 to 1);
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Mn_request : out std_logic;
      Mn_busLock : out std_logic;
      Mn_select : out std_logic;
      Mn_RNW : out std_logic;
      Mn_BE : out std_logic_vector(0 to 3);
      Mn_seqAddr : out std_logic;
      Mn_DBus : out std_logic_vector(0 to 31);
      Mn_ABus : out std_logic_vector(0 to 31);
      OPB_MGrant : in std_logic;
      OPB_xferAck : in std_logic;
      OPB_errAck : in std_logic;
      OPB_retry : in std_logic;
      OPB_timeout : in std_logic;
      OPB_DBus : in std_logic_vector(0 to 31)
    );
  end component;

  component opb_v20_0_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : out std_logic;
      SYS_Rst : in std_logic;
      Debug_SYS_Rst : in std_logic;
      WDT_Rst : in std_logic;
      M_ABus : in std_logic_vector(0 to 127);
      M_BE : in std_logic_vector(0 to 15);
      M_beXfer : in std_logic_vector(0 to 3);
      M_busLock : in std_logic_vector(0 to 3);
      M_DBus : in std_logic_vector(0 to 127);
      M_DBusEn : in std_logic_vector(0 to 3);
      M_DBusEn32_63 : in std_logic_vector(0 to 3);
      M_dwXfer : in std_logic_vector(0 to 3);
      M_fwXfer : in std_logic_vector(0 to 3);
      M_hwXfer : in std_logic_vector(0 to 3);
      M_request : in std_logic_vector(0 to 3);
      M_RNW : in std_logic_vector(0 to 3);
      M_select : in std_logic_vector(0 to 3);
      M_seqAddr : in std_logic_vector(0 to 3);
      Sl_beAck : in std_logic_vector(0 to 4);
      Sl_DBus : in std_logic_vector(0 to 159);
      Sl_DBusEn : in std_logic_vector(0 to 4);
      Sl_DBusEn32_63 : in std_logic_vector(0 to 4);
      Sl_errAck : in std_logic_vector(0 to 4);
      Sl_dwAck : in std_logic_vector(0 to 4);
      Sl_fwAck : in std_logic_vector(0 to 4);
      Sl_hwAck : in std_logic_vector(0 to 4);
      Sl_retry : in std_logic_vector(0 to 4);
      Sl_toutSup : in std_logic_vector(0 to 4);
      Sl_xferAck : in std_logic_vector(0 to 4);
      OPB_MRequest : out std_logic_vector(0 to 3);
      OPB_ABus : out std_logic_vector(0 to 31);
      OPB_BE : out std_logic_vector(0 to 3);
      OPB_beXfer : out std_logic;
      OPB_beAck : out std_logic;
      OPB_busLock : out std_logic;
      OPB_rdDBus : out std_logic_vector(0 to 31);
      OPB_wrDBus : out std_logic_vector(0 to 31);
      OPB_DBus : out std_logic_vector(0 to 31);
      OPB_errAck : out std_logic;
      OPB_dwAck : out std_logic;
      OPB_dwXfer : out std_logic;
      OPB_fwAck : out std_logic;
      OPB_fwXfer : out std_logic;
      OPB_hwAck : out std_logic;
      OPB_hwXfer : out std_logic;
      OPB_MGrant : out std_logic_vector(0 to 3);
      OPB_pendReq : out std_logic_vector(0 to 3);
      OPB_retry : out std_logic;
      OPB_RNW : out std_logic;
      OPB_select : out std_logic;
      OPB_seqAddr : out std_logic;
      OPB_timeout : out std_logic;
      OPB_toutSup : out std_logic;
      OPB_xferAck : out std_logic
    );
  end component;

  component opb_bram_if_cntlr_1_wrapper is
    port (
      opb_clk : in std_logic;
      opb_rst : in std_logic;
      opb_abus : in std_logic_vector(0 to 31);
      opb_dbus : in std_logic_vector(0 to 31);
      sln_dbus : out std_logic_vector(0 to 31);
      opb_select : in std_logic;
      opb_rnw : in std_logic;
      opb_seqaddr : in std_logic;
      opb_be : in std_logic_vector(0 to 3);
      sln_xferack : out std_logic;
      sln_errack : out std_logic;
      sln_toutsup : out std_logic;
      sln_retry : out std_logic;
      bram_rst : out std_logic;
      bram_clk : out std_logic;
      bram_en : out std_logic;
      bram_wen : out std_logic_vector(0 to 3);
      bram_addr : out std_logic_vector(0 to 31);
      bram_din : in std_logic_vector(0 to 31);
      bram_dout : out std_logic_vector(0 to 31)
    );
  end component;

  component bram_block_0_wrapper is
    port (
      BRAM_Rst_A : in std_logic;
      BRAM_Clk_A : in std_logic;
      BRAM_EN_A : in std_logic;
      BRAM_WEN_A : in std_logic_vector(0 to 3);
      BRAM_Addr_A : in std_logic_vector(0 to 31);
      BRAM_Din_A : out std_logic_vector(0 to 31);
      BRAM_Dout_A : in std_logic_vector(0 to 31);
      BRAM_Rst_B : in std_logic;
      BRAM_Clk_B : in std_logic;
      BRAM_EN_B : in std_logic;
      BRAM_WEN_B : in std_logic_vector(0 to 3);
      BRAM_Addr_B : in std_logic_vector(0 to 31);
      BRAM_Din_B : out std_logic_vector(0 to 31);
      BRAM_Dout_B : in std_logic_vector(0 to 31)
    );
  end component;

  component xps_bram_if_cntlr_0_wrapper is
    port (
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 0);
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to 7);
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_lockErr : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to 63);
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_wrBTerm : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 63);
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_rdBTerm : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 1);
      Sl_MWrErr : out std_logic_vector(0 to 1);
      Sl_MRdErr : out std_logic_vector(0 to 1);
      Sl_MIRQ : out std_logic_vector(0 to 1);
      BRAM_Rst : out std_logic;
      BRAM_Clk : out std_logic;
      BRAM_EN : out std_logic;
      BRAM_WEN : out std_logic_vector(0 to 3);
      BRAM_Addr : out std_logic_vector(0 to 31);
      BRAM_Din : in std_logic_vector(0 to 31);
      BRAM_Dout : out std_logic_vector(0 to 31)
    );
  end component;

  component thread_manager_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      Sln_DBus : out std_logic_vector(0 to 31);
      Sln_errAck : out std_logic;
      Sln_retry : out std_logic;
      Sln_toutSup : out std_logic;
      Sln_xferAck : out std_logic;
      Access_Intr : out std_logic;
      Scheduler_Reset : out std_logic;
      Scheduler_Reset_Done : in std_logic;
      Semaphore_Reset : out std_logic;
      Semaphore_Reset_Done : in std_logic;
      SpinLock_Reset : out std_logic;
      SpinLock_Reset_Done : in std_logic;
      User_IP_Reset : out std_logic;
      User_IP_Reset_Done : in std_logic;
      Soft_Stop : out std_logic;
      tm2sch_cpu_thread_id : out std_logic_vector(0 to 7);
      tm2sch_opcode : out std_logic_vector(0 to 5);
      tm2sch_data : out std_logic_vector(0 to 7);
      tm2sch_request : out std_logic;
      sch2tm_busy : in std_logic;
      sch2tm_data : in std_logic_vector(0 to 7);
      sch2tm_next_id : in std_logic_vector(0 to 7);
      sch2tm_next_id_valid : in std_logic;
      tm2sch_DOB : out std_logic_vector(0 to 31);
      sch2tm_ADDRB : in std_logic_vector(0 to 8);
      sch2tm_DIB : in std_logic_vector(0 to 31);
      sch2tm_ENB : in std_logic;
      sch2tm_WEB : in std_logic
    );
  end component;

  component scheduler_wrapper is
    port (
      Soft_Reset : in std_logic;
      Reset_Done : out std_logic;
      Soft_Stop : in std_logic;
      SWTM_DOB : in std_logic_vector(0 to 31);
      SWTM_ADDRB : out std_logic_vector(0 to 8);
      SWTM_DIB : out std_logic_vector(0 to 31);
      SWTM_ENB : out std_logic;
      SWTM_WEB : out std_logic;
      TM2SCH_current_cpu_tid : in std_logic_vector(0 to 7);
      TM2SCH_opcode : in std_logic_vector(0 to 5);
      TM2SCH_data : in std_logic_vector(0 to 7);
      TM2SCH_request : in std_logic;
      SCH2TM_busy : out std_logic;
      SCH2TM_data : out std_logic_vector(0 to 7);
      SCH2TM_next_cpu_tid : out std_logic_vector(0 to 7);
      SCH2TM_next_tid_valid : out std_logic;
      Preemption_Interrupt : out std_logic;
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      M_ABus : out std_logic_vector(0 to 31);
      M_BE : out std_logic_vector(0 to 3);
      M_busLock : out std_logic;
      M_request : out std_logic;
      M_RNW : out std_logic;
      M_select : out std_logic;
      M_seqAddr : out std_logic;
      OPB_errAck : in std_logic;
      OPB_MGrant : in std_logic;
      OPB_retry : in std_logic;
      OPB_timeout : in std_logic;
      OPB_xferAck : in std_logic
    );
  end component;

  component synch_manager_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      M_ABus : out std_logic_vector(0 to 31);
      M_BE : out std_logic_vector(0 to 3);
      M_busLock : out std_logic;
      M_request : out std_logic;
      M_RNW : out std_logic;
      M_select : out std_logic;
      M_seqAddr : out std_logic;
      OPB_errAck : in std_logic;
      OPB_MGrant : in std_logic;
      OPB_retry : in std_logic;
      OPB_timeout : in std_logic;
      OPB_xferAck : in std_logic;
      system_reset : in std_logic;
      system_resetdone : out std_logic
    );
  end component;

  component cond_vars_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Interrupt : out std_logic;
      IP2Bus_IntrEvent : in std_logic_vector(0 to 0);
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      OPB_errAck : in std_logic;
      OPB_MnGrant : in std_logic;
      OPB_retry : in std_logic;
      OPB_timeout : in std_logic;
      OPB_xferAck : in std_logic;
      Mn_request : out std_logic;
      Mn_busLock : out std_logic;
      Mn_select : out std_logic;
      Mn_RNW : out std_logic;
      Mn_BE : out std_logic_vector(0 to 3);
      Mn_seqAddr : out std_logic;
      Mn_ABus : out std_logic_vector(0 to 31);
      Sln_xferAck : out std_logic;
      Sln_errAck : out std_logic;
      Sln_retry : out std_logic;
      Sln_toutSup : out std_logic;
      Sln_DBus : out std_logic_vector(0 to 31);
      Sema_Reset : in std_logic;
      Sema_Rst_Ack : out std_logic
    );
  end component;

  component plb_hthread_reset_core_0_wrapper is
    port (
      reset_port0 : out std_logic;
      reset_response_port0 : in std_logic;
      reset_port1 : out std_logic;
      reset_response_port1 : in std_logic;
      reset_port2 : out std_logic;
      reset_response_port2 : in std_logic;
      reset_port3 : out std_logic;
      reset_response_port3 : in std_logic;
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 0);
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to 7);
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_lockErr : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to 63);
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_wrBTerm : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 63);
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_rdBTerm : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 1);
      Sl_MWrErr : out std_logic_vector(0 to 1);
      Sl_MRdErr : out std_logic_vector(0 to 1);
      Sl_MIRQ : out std_logic_vector(0 to 1)
    );
  end component;

  component plb_hthreads_timer_0_wrapper is
    port (
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 0);
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to 7);
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_lockErr : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to 63);
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_wrBTerm : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 63);
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_rdBTerm : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 1);
      Sl_MWrErr : out std_logic_vector(0 to 1);
      Sl_MRdErr : out std_logic_vector(0 to 1);
      Sl_MIRQ : out std_logic_vector(0 to 1)
    );
  end component;

  component IOBUF is
    port (
      I : in std_logic;
      IO : inout std_logic;
      O : out std_logic;
      T : in std_logic
    );
  end component;

  -- Internal signals

  signal DDR2_SDRAM_MPMC_Clk_Div2 : std_logic;
  signal DDR2_SDRAM_mpmc_clk_90_s : std_logic;
  signal Dcm_all_locked : std_logic;
  signal Debug_SYS_Rst : std_logic;
  signal Ext_BRK : std_logic;
  signal Ext_NM_BRK : std_logic;
  signal Interrupt : std_logic;
  signal ZBT_CLK_FB_s : std_logic;
  signal ZBT_CLK_OUT_s : std_logic;
  signal access_intr : std_logic;
  signal clk_200mhz_s : std_logic;
  signal core_sch2tm_addrb : std_logic_vector(0 to 8);
  signal core_sch2tm_busy : std_logic;
  signal core_sch2tm_data : std_logic_vector(0 to 7);
  signal core_sch2tm_dib : std_logic_vector(0 to 31);
  signal core_sch2tm_enb : std_logic;
  signal core_sch2tm_next_id : std_logic_vector(0 to 7);
  signal core_sch2tm_next_id_valid : std_logic;
  signal core_sch2tm_web : std_logic;
  signal core_tm2sch_cpu_thread_id : std_logic_vector(0 to 7);
  signal core_tm2sch_data : std_logic_vector(0 to 7);
  signal core_tm2sch_dob : std_logic_vector(0 to 31);
  signal core_tm2sch_opcode : std_logic_vector(0 to 5);
  signal core_tm2sch_request : std_logic;
  signal dcm_clk_s : std_logic;
  signal dlmb_LMB_ABus : std_logic_vector(0 to 31);
  signal dlmb_LMB_AddrStrobe : std_logic;
  signal dlmb_LMB_BE : std_logic_vector(0 to 3);
  signal dlmb_LMB_ReadDBus : std_logic_vector(0 to 31);
  signal dlmb_LMB_ReadStrobe : std_logic;
  signal dlmb_LMB_Ready : std_logic;
  signal dlmb_LMB_WriteDBus : std_logic_vector(0 to 31);
  signal dlmb_LMB_WriteStrobe : std_logic;
  signal dlmb_M_ABus : std_logic_vector(0 to 31);
  signal dlmb_M_AddrStrobe : std_logic;
  signal dlmb_M_BE : std_logic_vector(0 to 3);
  signal dlmb_M_DBus : std_logic_vector(0 to 31);
  signal dlmb_M_ReadStrobe : std_logic;
  signal dlmb_M_WriteStrobe : std_logic;
  signal dlmb_OPB_Rst : std_logic;
  signal dlmb_Sl_DBus : std_logic_vector(0 to 31);
  signal dlmb_Sl_Ready : std_logic_vector(0 to 0);
  signal dlmb_port_BRAM_Addr : std_logic_vector(0 to 31);
  signal dlmb_port_BRAM_Clk : std_logic;
  signal dlmb_port_BRAM_Din : std_logic_vector(0 to 31);
  signal dlmb_port_BRAM_Dout : std_logic_vector(0 to 31);
  signal dlmb_port_BRAM_EN : std_logic;
  signal dlmb_port_BRAM_Rst : std_logic;
  signal dlmb_port_BRAM_WEN : std_logic_vector(0 to 3);
  signal dxcl_FSL_M_Clk : std_logic;
  signal dxcl_FSL_M_Control : std_logic;
  signal dxcl_FSL_M_Data : std_logic_vector(0 to 31);
  signal dxcl_FSL_M_Full : std_logic;
  signal dxcl_FSL_M_Write : std_logic;
  signal dxcl_FSL_S_Clk : std_logic;
  signal dxcl_FSL_S_Control : std_logic;
  signal dxcl_FSL_S_Data : std_logic_vector(0 to 31);
  signal dxcl_FSL_S_Exists : std_logic;
  signal dxcl_FSL_S_Read : std_logic;
  signal fpga_0_DDR2_SDRAM_DDR2_Addr : std_logic_vector(12 downto 0);
  signal fpga_0_DDR2_SDRAM_DDR2_BankAddr : std_logic_vector(1 downto 0);
  signal fpga_0_DDR2_SDRAM_DDR2_CAS_n : std_logic;
  signal fpga_0_DDR2_SDRAM_DDR2_CE : std_logic_vector(0 to 0);
  signal fpga_0_DDR2_SDRAM_DDR2_CE_split : std_logic_vector(0 to 1);
  signal fpga_0_DDR2_SDRAM_DDR2_CS_n : std_logic_vector(0 to 0);
  signal fpga_0_DDR2_SDRAM_DDR2_CS_n_split : std_logic_vector(0 to 1);
  signal fpga_0_DDR2_SDRAM_DDR2_Clk : std_logic_vector(1 downto 0);
  signal fpga_0_DDR2_SDRAM_DDR2_Clk_n : std_logic_vector(1 downto 0);
  signal fpga_0_DDR2_SDRAM_DDR2_DM : std_logic_vector(7 downto 0);
  signal fpga_0_DDR2_SDRAM_DDR2_ODT : std_logic_vector(1 downto 0);
  signal fpga_0_DDR2_SDRAM_DDR2_RAS_n : std_logic;
  signal fpga_0_DDR2_SDRAM_DDR2_WE_n : std_logic;
  signal fpga_0_LEDs_8Bit_GPIO_IO_I : std_logic_vector(0 to 7);
  signal fpga_0_LEDs_8Bit_GPIO_IO_O : std_logic_vector(0 to 7);
  signal fpga_0_LEDs_8Bit_GPIO_IO_T : std_logic_vector(0 to 7);
  signal fpga_0_RS232_Uart_1_RX : std_logic;
  signal fpga_0_RS232_Uart_1_TX : std_logic;
  signal fpga_0_SRAM_Mem_A : std_logic_vector(7 to 30);
  signal fpga_0_SRAM_Mem_ADV_LDN : std_logic;
  signal fpga_0_SRAM_Mem_A_split : std_logic_vector(0 to 31);
  signal fpga_0_SRAM_Mem_BEN : std_logic_vector(0 to 3);
  signal fpga_0_SRAM_Mem_CEN : std_logic_vector(0 to 0);
  signal fpga_0_SRAM_Mem_DQ_I : std_logic_vector(0 to 31);
  signal fpga_0_SRAM_Mem_DQ_O : std_logic_vector(0 to 31);
  signal fpga_0_SRAM_Mem_DQ_T : std_logic_vector(0 to 31);
  signal fpga_0_SRAM_Mem_OEN : std_logic_vector(0 to 0);
  signal fpga_0_SRAM_Mem_WEN : std_logic;
  signal hthread_resp_condvar : std_logic;
  signal hthread_resp_sched : std_logic;
  signal hthread_resp_synch : std_logic;
  signal hthread_rst_condvar : std_logic;
  signal hthread_rst_sched : std_logic;
  signal hthread_rst_synch : std_logic;
  signal ilmb_LMB_ABus : std_logic_vector(0 to 31);
  signal ilmb_LMB_AddrStrobe : std_logic;
  signal ilmb_LMB_BE : std_logic_vector(0 to 3);
  signal ilmb_LMB_ReadDBus : std_logic_vector(0 to 31);
  signal ilmb_LMB_ReadStrobe : std_logic;
  signal ilmb_LMB_Ready : std_logic;
  signal ilmb_LMB_WriteDBus : std_logic_vector(0 to 31);
  signal ilmb_LMB_WriteStrobe : std_logic;
  signal ilmb_M_ABus : std_logic_vector(0 to 31);
  signal ilmb_M_AddrStrobe : std_logic;
  signal ilmb_M_ReadStrobe : std_logic;
  signal ilmb_OPB_Rst : std_logic;
  signal ilmb_Sl_DBus : std_logic_vector(0 to 31);
  signal ilmb_Sl_Ready : std_logic_vector(0 to 0);
  signal ilmb_port_BRAM_Addr : std_logic_vector(0 to 31);
  signal ilmb_port_BRAM_Clk : std_logic;
  signal ilmb_port_BRAM_Din : std_logic_vector(0 to 31);
  signal ilmb_port_BRAM_Dout : std_logic_vector(0 to 31);
  signal ilmb_port_BRAM_EN : std_logic;
  signal ilmb_port_BRAM_Rst : std_logic;
  signal ilmb_port_BRAM_WEN : std_logic_vector(0 to 3);
  signal ixcl_FSL_M_Clk : std_logic;
  signal ixcl_FSL_M_Control : std_logic;
  signal ixcl_FSL_M_Data : std_logic_vector(0 to 31);
  signal ixcl_FSL_M_Full : std_logic;
  signal ixcl_FSL_M_Write : std_logic;
  signal ixcl_FSL_S_Clk : std_logic;
  signal ixcl_FSL_S_Control : std_logic;
  signal ixcl_FSL_S_Data : std_logic_vector(0 to 31);
  signal ixcl_FSL_S_Exists : std_logic;
  signal ixcl_FSL_S_Read : std_logic;
  signal mb_plb_M_ABort : std_logic_vector(0 to 1);
  signal mb_plb_M_ABus : std_logic_vector(0 to 63);
  signal mb_plb_M_BE : std_logic_vector(0 to 15);
  signal mb_plb_M_MSize : std_logic_vector(0 to 3);
  signal mb_plb_M_RNW : std_logic_vector(0 to 1);
  signal mb_plb_M_TAttribute : std_logic_vector(0 to 31);
  signal mb_plb_M_UABus : std_logic_vector(0 to 63);
  signal mb_plb_M_busLock : std_logic_vector(0 to 1);
  signal mb_plb_M_lockErr : std_logic_vector(0 to 1);
  signal mb_plb_M_priority : std_logic_vector(0 to 3);
  signal mb_plb_M_rdBurst : std_logic_vector(0 to 1);
  signal mb_plb_M_request : std_logic_vector(0 to 1);
  signal mb_plb_M_size : std_logic_vector(0 to 7);
  signal mb_plb_M_type : std_logic_vector(0 to 5);
  signal mb_plb_M_wrBurst : std_logic_vector(0 to 1);
  signal mb_plb_M_wrDBus : std_logic_vector(0 to 127);
  signal mb_plb_PLB_ABus : std_logic_vector(0 to 31);
  signal mb_plb_PLB_BE : std_logic_vector(0 to 7);
  signal mb_plb_PLB_MAddrAck : std_logic_vector(0 to 1);
  signal mb_plb_PLB_MBusy : std_logic_vector(0 to 1);
  signal mb_plb_PLB_MIRQ : std_logic_vector(0 to 1);
  signal mb_plb_PLB_MRdBTerm : std_logic_vector(0 to 1);
  signal mb_plb_PLB_MRdDAck : std_logic_vector(0 to 1);
  signal mb_plb_PLB_MRdDBus : std_logic_vector(0 to 127);
  signal mb_plb_PLB_MRdErr : std_logic_vector(0 to 1);
  signal mb_plb_PLB_MRdWdAddr : std_logic_vector(0 to 7);
  signal mb_plb_PLB_MRearbitrate : std_logic_vector(0 to 1);
  signal mb_plb_PLB_MSSize : std_logic_vector(0 to 3);
  signal mb_plb_PLB_MSize : std_logic_vector(0 to 1);
  signal mb_plb_PLB_MTimeout : std_logic_vector(0 to 1);
  signal mb_plb_PLB_MWrBTerm : std_logic_vector(0 to 1);
  signal mb_plb_PLB_MWrDAck : std_logic_vector(0 to 1);
  signal mb_plb_PLB_MWrErr : std_logic_vector(0 to 1);
  signal mb_plb_PLB_PAValid : std_logic;
  signal mb_plb_PLB_RNW : std_logic;
  signal mb_plb_PLB_SAValid : std_logic;
  signal mb_plb_PLB_TAttribute : std_logic_vector(0 to 15);
  signal mb_plb_PLB_UABus : std_logic_vector(0 to 31);
  signal mb_plb_PLB_abort : std_logic;
  signal mb_plb_PLB_busLock : std_logic;
  signal mb_plb_PLB_lockErr : std_logic;
  signal mb_plb_PLB_masterID : std_logic_vector(0 to 0);
  signal mb_plb_PLB_rdBurst : std_logic;
  signal mb_plb_PLB_rdPendPri : std_logic_vector(0 to 1);
  signal mb_plb_PLB_rdPendReq : std_logic;
  signal mb_plb_PLB_rdPrim : std_logic_vector(0 to 10);
  signal mb_plb_PLB_reqPri : std_logic_vector(0 to 1);
  signal mb_plb_PLB_size : std_logic_vector(0 to 3);
  signal mb_plb_PLB_type : std_logic_vector(0 to 2);
  signal mb_plb_PLB_wrBurst : std_logic;
  signal mb_plb_PLB_wrDBus : std_logic_vector(0 to 63);
  signal mb_plb_PLB_wrPendPri : std_logic_vector(0 to 1);
  signal mb_plb_PLB_wrPendReq : std_logic;
  signal mb_plb_PLB_wrPrim : std_logic_vector(0 to 10);
  signal mb_plb_SPLB_Rst : std_logic_vector(0 to 10);
  signal mb_plb_Sl_MBusy : std_logic_vector(0 to 21);
  signal mb_plb_Sl_MIRQ : std_logic_vector(0 to 21);
  signal mb_plb_Sl_MRdErr : std_logic_vector(0 to 21);
  signal mb_plb_Sl_MWrErr : std_logic_vector(0 to 21);
  signal mb_plb_Sl_SSize : std_logic_vector(0 to 21);
  signal mb_plb_Sl_addrAck : std_logic_vector(0 to 10);
  signal mb_plb_Sl_rdBTerm : std_logic_vector(0 to 10);
  signal mb_plb_Sl_rdComp : std_logic_vector(0 to 10);
  signal mb_plb_Sl_rdDAck : std_logic_vector(0 to 10);
  signal mb_plb_Sl_rdDBus : std_logic_vector(0 to 703);
  signal mb_plb_Sl_rdWdAddr : std_logic_vector(0 to 43);
  signal mb_plb_Sl_rearbitrate : std_logic_vector(0 to 10);
  signal mb_plb_Sl_wait : std_logic_vector(0 to 10);
  signal mb_plb_Sl_wrBTerm : std_logic_vector(0 to 10);
  signal mb_plb_Sl_wrComp : std_logic_vector(0 to 10);
  signal mb_plb_Sl_wrDAck : std_logic_vector(0 to 10);
  signal mb_reset : std_logic;
  signal microblaze_0_dbg_Dbg_Capture : std_logic;
  signal microblaze_0_dbg_Dbg_Clk : std_logic;
  signal microblaze_0_dbg_Dbg_Reg_En : std_logic_vector(0 to 4);
  signal microblaze_0_dbg_Dbg_Shift : std_logic;
  signal microblaze_0_dbg_Dbg_TDI : std_logic;
  signal microblaze_0_dbg_Dbg_TDO : std_logic;
  signal microblaze_0_dbg_Dbg_Update : std_logic;
  signal microblaze_0_dbg_Debug_Rst : std_logic;
  signal net_gnd0 : std_logic;
  signal net_gnd1 : std_logic_vector(0 to 0);
  signal net_gnd2 : std_logic_vector(0 to 1);
  signal net_gnd3 : std_logic_vector(0 to 2);
  signal net_gnd4 : std_logic_vector(0 to 3);
  signal net_gnd5 : std_logic_vector(0 to 4);
  signal net_gnd8 : std_logic_vector(0 to 7);
  signal net_gnd10 : std_logic_vector(0 to 9);
  signal net_gnd16 : std_logic_vector(0 to 15);
  signal net_gnd32 : std_logic_vector(0 to 31);
  signal net_gnd36 : std_logic_vector(0 to 35);
  signal net_gnd64 : std_logic_vector(0 to 63);
  signal net_gnd128 : std_logic_vector(0 to 127);
  signal net_vcc0 : std_logic;
  signal net_vcc4 : std_logic_vector(0 to 3);
  signal net_vcc5 : std_logic_vector(0 to 4);
  signal opb_bram_if_cntlr_1_PORTA_BRAM_Addr : std_logic_vector(0 to 31);
  signal opb_bram_if_cntlr_1_PORTA_BRAM_Clk : std_logic;
  signal opb_bram_if_cntlr_1_PORTA_BRAM_Din : std_logic_vector(0 to 31);
  signal opb_bram_if_cntlr_1_PORTA_BRAM_Dout : std_logic_vector(0 to 31);
  signal opb_bram_if_cntlr_1_PORTA_BRAM_EN : std_logic;
  signal opb_bram_if_cntlr_1_PORTA_BRAM_Rst : std_logic;
  signal opb_bram_if_cntlr_1_PORTA_BRAM_WEN : std_logic_vector(0 to 3);
  signal opb_v20_0_M_ABus : std_logic_vector(0 to 127);
  signal opb_v20_0_M_BE : std_logic_vector(0 to 15);
  signal opb_v20_0_M_DBus : std_logic_vector(0 to 127);
  signal opb_v20_0_M_RNW : std_logic_vector(0 to 3);
  signal opb_v20_0_M_busLock : std_logic_vector(0 to 3);
  signal opb_v20_0_M_request : std_logic_vector(0 to 3);
  signal opb_v20_0_M_select : std_logic_vector(0 to 3);
  signal opb_v20_0_M_seqAddr : std_logic_vector(0 to 3);
  signal opb_v20_0_OPB_ABus : std_logic_vector(0 to 31);
  signal opb_v20_0_OPB_BE : std_logic_vector(0 to 3);
  signal opb_v20_0_OPB_DBus : std_logic_vector(0 to 31);
  signal opb_v20_0_OPB_MGrant : std_logic_vector(0 to 3);
  signal opb_v20_0_OPB_RNW : std_logic;
  signal opb_v20_0_OPB_Rst : std_logic;
  signal opb_v20_0_OPB_errAck : std_logic;
  signal opb_v20_0_OPB_retry : std_logic;
  signal opb_v20_0_OPB_select : std_logic;
  signal opb_v20_0_OPB_seqAddr : std_logic;
  signal opb_v20_0_OPB_timeout : std_logic;
  signal opb_v20_0_OPB_xferAck : std_logic;
  signal opb_v20_0_Sl_DBus : std_logic_vector(0 to 159);
  signal opb_v20_0_Sl_errAck : std_logic_vector(0 to 4);
  signal opb_v20_0_Sl_retry : std_logic_vector(0 to 4);
  signal opb_v20_0_Sl_toutSup : std_logic_vector(0 to 4);
  signal opb_v20_0_Sl_xferAck : std_logic_vector(0 to 4);
  signal pgassign1 : std_logic_vector(2 downto 0);
  signal sched_intr : std_logic;
  signal soft_stop : std_logic;
  signal sys_bus_reset : std_logic_vector(0 to 0);
  signal sys_clk_s : std_logic;
  signal sys_periph_reset : std_logic_vector(0 to 0);
  signal sys_rst_s : std_logic;
  signal xps_bram_if_cntlr_0_PORTA_BRAM_Addr : std_logic_vector(0 to 31);
  signal xps_bram_if_cntlr_0_PORTA_BRAM_Clk : std_logic;
  signal xps_bram_if_cntlr_0_PORTA_BRAM_Din : std_logic_vector(0 to 31);
  signal xps_bram_if_cntlr_0_PORTA_BRAM_Dout : std_logic_vector(0 to 31);
  signal xps_bram_if_cntlr_0_PORTA_BRAM_EN : std_logic;
  signal xps_bram_if_cntlr_0_PORTA_BRAM_Rst : std_logic;
  signal xps_bram_if_cntlr_0_PORTA_BRAM_WEN : std_logic_vector(0 to 3);
  signal xps_timer_1_Interrupt : std_logic;

  attribute BOX_TYPE : STRING;
  attribute BOX_TYPE of microblaze_0_wrapper : component is "black_box";
  attribute BOX_TYPE of mb_plb_wrapper : component is "black_box";
  attribute BOX_TYPE of ilmb_wrapper : component is "black_box";
  attribute BOX_TYPE of dlmb_wrapper : component is "black_box";
  attribute BOX_TYPE of dlmb_cntlr_wrapper : component is "black_box";
  attribute BOX_TYPE of ilmb_cntlr_wrapper : component is "black_box";
  attribute BOX_TYPE of lmb_bram_wrapper : component is "black_box";
  attribute BOX_TYPE of rs232_uart_1_wrapper : component is "black_box";
  attribute BOX_TYPE of leds_8bit_wrapper : component is "black_box";
  attribute BOX_TYPE of sram_wrapper : component is "black_box";
  attribute BOX_TYPE of ddr2_sdram_wrapper : component is "black_box";
  attribute BOX_TYPE of xps_timer_1_wrapper : component is "black_box";
  attribute BOX_TYPE of sram_util_bus_split_0_wrapper : component is "black_box";
  attribute BOX_TYPE of ddr2_sdram_util_bus_split_1_wrapper : component is "black_box";
  attribute BOX_TYPE of ddr2_sdram_util_bus_split_2_wrapper : component is "black_box";
  attribute BOX_TYPE of clock_generator_0_wrapper : component is "black_box";
  attribute BOX_TYPE of debug_module_wrapper : component is "black_box";
  attribute BOX_TYPE of proc_sys_reset_0_wrapper : component is "black_box";
  attribute BOX_TYPE of xps_intc_0_wrapper : component is "black_box";
  attribute BOX_TYPE of plbv46_opb_bridge_0_wrapper : component is "black_box";
  attribute BOX_TYPE of opb_v20_0_wrapper : component is "black_box";
  attribute BOX_TYPE of opb_bram_if_cntlr_1_wrapper : component is "black_box";
  attribute BOX_TYPE of bram_block_0_wrapper : component is "black_box";
  attribute BOX_TYPE of xps_bram_if_cntlr_0_wrapper : component is "black_box";
  attribute BOX_TYPE of thread_manager_wrapper : component is "black_box";
  attribute BOX_TYPE of scheduler_wrapper : component is "black_box";
  attribute BOX_TYPE of synch_manager_wrapper : component is "black_box";
  attribute BOX_TYPE of cond_vars_wrapper : component is "black_box";
  attribute BOX_TYPE of plb_hthread_reset_core_0_wrapper : component is "black_box";
  attribute BOX_TYPE of plb_hthreads_timer_0_wrapper : component is "black_box";

begin

  -- Internal assignments

  fpga_0_RS232_Uart_1_RX <= fpga_0_RS232_Uart_1_RX_pin;
  fpga_0_RS232_Uart_1_TX_pin <= fpga_0_RS232_Uart_1_TX;
  fpga_0_SRAM_Mem_A_pin <= fpga_0_SRAM_Mem_A;
  fpga_0_SRAM_Mem_BEN_pin <= fpga_0_SRAM_Mem_BEN;
  fpga_0_SRAM_Mem_OEN_pin <= fpga_0_SRAM_Mem_OEN(0);
  fpga_0_SRAM_Mem_CEN_pin <= fpga_0_SRAM_Mem_CEN(0);
  fpga_0_SRAM_Mem_ADV_LDN_pin <= fpga_0_SRAM_Mem_ADV_LDN;
  fpga_0_SRAM_Mem_WEN_pin <= fpga_0_SRAM_Mem_WEN;
  fpga_0_DDR2_SDRAM_DDR2_ODT_pin <= fpga_0_DDR2_SDRAM_DDR2_ODT;
  fpga_0_DDR2_SDRAM_DDR2_Addr_pin <= fpga_0_DDR2_SDRAM_DDR2_Addr;
  fpga_0_DDR2_SDRAM_DDR2_BankAddr_pin <= fpga_0_DDR2_SDRAM_DDR2_BankAddr;
  fpga_0_DDR2_SDRAM_DDR2_CAS_n_pin <= fpga_0_DDR2_SDRAM_DDR2_CAS_n;
  fpga_0_DDR2_SDRAM_DDR2_CE_pin(0 to 0) <= fpga_0_DDR2_SDRAM_DDR2_CE(0 to 0);
  fpga_0_DDR2_SDRAM_DDR2_CS_n_pin(0 to 0) <= fpga_0_DDR2_SDRAM_DDR2_CS_n(0 to 0);
  fpga_0_DDR2_SDRAM_DDR2_RAS_n_pin <= fpga_0_DDR2_SDRAM_DDR2_RAS_n;
  fpga_0_DDR2_SDRAM_DDR2_WE_n_pin <= fpga_0_DDR2_SDRAM_DDR2_WE_n;
  fpga_0_DDR2_SDRAM_DDR2_Clk_pin <= fpga_0_DDR2_SDRAM_DDR2_Clk;
  fpga_0_DDR2_SDRAM_DDR2_Clk_n_pin <= fpga_0_DDR2_SDRAM_DDR2_Clk_n;
  fpga_0_DDR2_SDRAM_DDR2_DM_pin <= fpga_0_DDR2_SDRAM_DDR2_DM;
  fpga_0_SRAM_CLK <= ZBT_CLK_OUT_s;
  ZBT_CLK_FB_s <= fpga_0_SRAM_CLK_FB;
  dcm_clk_s <= sys_clk_pin;
  sys_rst_s <= sys_rst_pin;
  opb_v20_0_M_DBus(32 to 63) <= B"00000000000000000000000000000000";
  opb_v20_0_M_DBus(64 to 95) <= B"00000000000000000000000000000000";
  opb_v20_0_M_DBus(96 to 127) <= B"00000000000000000000000000000000";
  pgassign1(2) <= xps_timer_1_Interrupt;
  pgassign1(1) <= sched_intr;
  pgassign1(0) <= access_intr;
  net_gnd0 <= '0';
  net_gnd1(0 to 0) <= B"0";
  net_gnd10(0 to 9) <= B"0000000000";
  net_gnd128(0 to 127) <= B"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
  net_gnd16(0 to 15) <= B"0000000000000000";
  net_gnd2(0 to 1) <= B"00";
  net_gnd3(0 to 2) <= B"000";
  net_gnd32(0 to 31) <= B"00000000000000000000000000000000";
  net_gnd36(0 to 35) <= B"000000000000000000000000000000000000";
  net_gnd4(0 to 3) <= B"0000";
  net_gnd5(0 to 4) <= B"00000";
  net_gnd64(0 to 63) <= B"0000000000000000000000000000000000000000000000000000000000000000";
  net_gnd8(0 to 7) <= B"00000000";
  net_vcc0 <= '1';
  net_vcc4(0 to 3) <= B"1111";
  net_vcc5(0 to 4) <= B"11111";

  microblaze_0 : microblaze_0_wrapper
    port map (
      CLK => sys_clk_s,
      RESET => dlmb_OPB_Rst,
      MB_RESET => mb_reset,
      INTERRUPT => Interrupt,
      EXT_BRK => Ext_BRK,
      EXT_NM_BRK => Ext_NM_BRK,
      DBG_STOP => net_gnd0,
      MB_Halted => open,
      INSTR => ilmb_LMB_ReadDBus,
      I_ADDRTAG => open,
      IREADY => ilmb_LMB_Ready,
      IWAIT => net_gnd0,
      INSTR_ADDR => ilmb_M_ABus,
      IFETCH => ilmb_M_ReadStrobe,
      I_AS => ilmb_M_AddrStrobe,
      IPLB_M_ABort => mb_plb_M_ABort(1),
      IPLB_M_ABus => mb_plb_M_ABus(32 to 63),
      IPLB_M_UABus => mb_plb_M_UABus(32 to 63),
      IPLB_M_BE => mb_plb_M_BE(8 to 15),
      IPLB_M_busLock => mb_plb_M_busLock(1),
      IPLB_M_lockErr => mb_plb_M_lockErr(1),
      IPLB_M_MSize => mb_plb_M_MSize(2 to 3),
      IPLB_M_priority => mb_plb_M_priority(2 to 3),
      IPLB_M_rdBurst => mb_plb_M_rdBurst(1),
      IPLB_M_request => mb_plb_M_request(1),
      IPLB_M_RNW => mb_plb_M_RNW(1),
      IPLB_M_size => mb_plb_M_size(4 to 7),
      IPLB_M_TAttribute => mb_plb_M_TAttribute(16 to 31),
      IPLB_M_type => mb_plb_M_type(3 to 5),
      IPLB_M_wrBurst => mb_plb_M_wrBurst(1),
      IPLB_M_wrDBus => mb_plb_M_wrDBus(64 to 127),
      IPLB_MBusy => mb_plb_PLB_MBusy(1),
      IPLB_MRdErr => mb_plb_PLB_MRdErr(1),
      IPLB_MWrErr => mb_plb_PLB_MWrErr(1),
      IPLB_MIRQ => mb_plb_PLB_MIRQ(1),
      IPLB_MWrBTerm => mb_plb_PLB_MWrBTerm(1),
      IPLB_MWrDAck => mb_plb_PLB_MWrDAck(1),
      IPLB_MAddrAck => mb_plb_PLB_MAddrAck(1),
      IPLB_MRdBTerm => mb_plb_PLB_MRdBTerm(1),
      IPLB_MRdDAck => mb_plb_PLB_MRdDAck(1),
      IPLB_MRdDBus => mb_plb_PLB_MRdDBus(64 to 127),
      IPLB_MRdWdAddr => mb_plb_PLB_MRdWdAddr(4 to 7),
      IPLB_MRearbitrate => mb_plb_PLB_MRearbitrate(1),
      IPLB_MSSize => mb_plb_PLB_MSSize(2 to 3),
      IPLB_MTimeout => mb_plb_PLB_MTimeout(1),
      DATA_READ => dlmb_LMB_ReadDBus,
      DREADY => dlmb_LMB_Ready,
      DWAIT => net_gnd0,
      DATA_WRITE => dlmb_M_DBus,
      DATA_ADDR => dlmb_M_ABus,
      D_ADDRTAG => open,
      D_AS => dlmb_M_AddrStrobe,
      READ_STROBE => dlmb_M_ReadStrobe,
      WRITE_STROBE => dlmb_M_WriteStrobe,
      BYTE_ENABLE => dlmb_M_BE,
      DM_ABUS => open,
      DM_BE => open,
      DM_BUSLOCK => open,
      DM_DBUS => open,
      DM_REQUEST => open,
      DM_RNW => open,
      DM_SELECT => open,
      DM_SEQADDR => open,
      DOPB_DBUS => net_gnd32,
      DOPB_ERRACK => net_gnd0,
      DOPB_MGRANT => net_gnd0,
      DOPB_RETRY => net_gnd0,
      DOPB_TIMEOUT => net_gnd0,
      DOPB_XFERACK => net_gnd0,
      DPLB_M_ABort => mb_plb_M_ABort(0),
      DPLB_M_ABus => mb_plb_M_ABus(0 to 31),
      DPLB_M_UABus => mb_plb_M_UABus(0 to 31),
      DPLB_M_BE => mb_plb_M_BE(0 to 7),
      DPLB_M_busLock => mb_plb_M_busLock(0),
      DPLB_M_lockErr => mb_plb_M_lockErr(0),
      DPLB_M_MSize => mb_plb_M_MSize(0 to 1),
      DPLB_M_priority => mb_plb_M_priority(0 to 1),
      DPLB_M_rdBurst => mb_plb_M_rdBurst(0),
      DPLB_M_request => mb_plb_M_request(0),
      DPLB_M_RNW => mb_plb_M_RNW(0),
      DPLB_M_size => mb_plb_M_size(0 to 3),
      DPLB_M_TAttribute => mb_plb_M_TAttribute(0 to 15),
      DPLB_M_type => mb_plb_M_type(0 to 2),
      DPLB_M_wrBurst => mb_plb_M_wrBurst(0),
      DPLB_M_wrDBus => mb_plb_M_wrDBus(0 to 63),
      DPLB_MBusy => mb_plb_PLB_MBusy(0),
      DPLB_MRdErr => mb_plb_PLB_MRdErr(0),
      DPLB_MWrErr => mb_plb_PLB_MWrErr(0),
      DPLB_MIRQ => mb_plb_PLB_MIRQ(0),
      DPLB_MWrBTerm => mb_plb_PLB_MWrBTerm(0),
      DPLB_MWrDAck => mb_plb_PLB_MWrDAck(0),
      DPLB_MAddrAck => mb_plb_PLB_MAddrAck(0),
      DPLB_MRdBTerm => mb_plb_PLB_MRdBTerm(0),
      DPLB_MRdDAck => mb_plb_PLB_MRdDAck(0),
      DPLB_MRdDBus => mb_plb_PLB_MRdDBus(0 to 63),
      DPLB_MRdWdAddr => mb_plb_PLB_MRdWdAddr(0 to 3),
      DPLB_MRearbitrate => mb_plb_PLB_MRearbitrate(0),
      DPLB_MSSize => mb_plb_PLB_MSSize(0 to 1),
      DPLB_MTimeout => mb_plb_PLB_MTimeout(0),
      IM_ABUS => open,
      IM_BE => open,
      IM_BUSLOCK => open,
      IM_DBUS => open,
      IM_REQUEST => open,
      IM_RNW => open,
      IM_SELECT => open,
      IM_SEQADDR => open,
      IOPB_DBUS => net_gnd32,
      IOPB_ERRACK => net_gnd0,
      IOPB_MGRANT => net_gnd0,
      IOPB_RETRY => net_gnd0,
      IOPB_TIMEOUT => net_gnd0,
      IOPB_XFERACK => net_gnd0,
      DBG_CLK => microblaze_0_dbg_Dbg_Clk,
      DBG_TDI => microblaze_0_dbg_Dbg_TDI,
      DBG_TDO => microblaze_0_dbg_Dbg_TDO,
      DBG_REG_EN => microblaze_0_dbg_Dbg_Reg_En,
      DBG_SHIFT => microblaze_0_dbg_Dbg_Shift,
      DBG_CAPTURE => microblaze_0_dbg_Dbg_Capture,
      DBG_UPDATE => microblaze_0_dbg_Dbg_Update,
      DEBUG_RST => microblaze_0_dbg_Debug_Rst,
      Trace_Instruction => open,
      Trace_Valid_Instr => open,
      Trace_PC => open,
      Trace_Reg_Write => open,
      Trace_Reg_Addr => open,
      Trace_MSR_Reg => open,
      Trace_PID_Reg => open,
      Trace_New_Reg_Value => open,
      Trace_Exception_Taken => open,
      Trace_Exception_Kind => open,
      Trace_Jump_Taken => open,
      Trace_Delay_Slot => open,
      Trace_Data_Address => open,
      Trace_Data_Access => open,
      Trace_Data_Read => open,
      Trace_Data_Write => open,
      Trace_Data_Write_Value => open,
      Trace_Data_Byte_Enable => open,
      Trace_DCache_Req => open,
      Trace_DCache_Hit => open,
      Trace_ICache_Req => open,
      Trace_ICache_Hit => open,
      Trace_OF_PipeRun => open,
      Trace_EX_PipeRun => open,
      Trace_MEM_PipeRun => open,
      Trace_MB_Halted => open,
      FSL0_S_CLK => open,
      FSL0_S_READ => open,
      FSL0_S_DATA => net_gnd32,
      FSL0_S_CONTROL => net_gnd0,
      FSL0_S_EXISTS => net_gnd0,
      FSL0_M_CLK => open,
      FSL0_M_WRITE => open,
      FSL0_M_DATA => open,
      FSL0_M_CONTROL => open,
      FSL0_M_FULL => net_gnd0,
      FSL1_S_CLK => open,
      FSL1_S_READ => open,
      FSL1_S_DATA => net_gnd32,
      FSL1_S_CONTROL => net_gnd0,
      FSL1_S_EXISTS => net_gnd0,
      FSL1_M_CLK => open,
      FSL1_M_WRITE => open,
      FSL1_M_DATA => open,
      FSL1_M_CONTROL => open,
      FSL1_M_FULL => net_gnd0,
      FSL2_S_CLK => open,
      FSL2_S_READ => open,
      FSL2_S_DATA => net_gnd32,
      FSL2_S_CONTROL => net_gnd0,
      FSL2_S_EXISTS => net_gnd0,
      FSL2_M_CLK => open,
      FSL2_M_WRITE => open,
      FSL2_M_DATA => open,
      FSL2_M_CONTROL => open,
      FSL2_M_FULL => net_gnd0,
      FSL3_S_CLK => open,
      FSL3_S_READ => open,
      FSL3_S_DATA => net_gnd32,
      FSL3_S_CONTROL => net_gnd0,
      FSL3_S_EXISTS => net_gnd0,
      FSL3_M_CLK => open,
      FSL3_M_WRITE => open,
      FSL3_M_DATA => open,
      FSL3_M_CONTROL => open,
      FSL3_M_FULL => net_gnd0,
      FSL4_S_CLK => open,
      FSL4_S_READ => open,
      FSL4_S_DATA => net_gnd32,
      FSL4_S_CONTROL => net_gnd0,
      FSL4_S_EXISTS => net_gnd0,
      FSL4_M_CLK => open,
      FSL4_M_WRITE => open,
      FSL4_M_DATA => open,
      FSL4_M_CONTROL => open,
      FSL4_M_FULL => net_gnd0,
      FSL5_S_CLK => open,
      FSL5_S_READ => open,
      FSL5_S_DATA => net_gnd32,
      FSL5_S_CONTROL => net_gnd0,
      FSL5_S_EXISTS => net_gnd0,
      FSL5_M_CLK => open,
      FSL5_M_WRITE => open,
      FSL5_M_DATA => open,
      FSL5_M_CONTROL => open,
      FSL5_M_FULL => net_gnd0,
      FSL6_S_CLK => open,
      FSL6_S_READ => open,
      FSL6_S_DATA => net_gnd32,
      FSL6_S_CONTROL => net_gnd0,
      FSL6_S_EXISTS => net_gnd0,
      FSL6_M_CLK => open,
      FSL6_M_WRITE => open,
      FSL6_M_DATA => open,
      FSL6_M_CONTROL => open,
      FSL6_M_FULL => net_gnd0,
      FSL7_S_CLK => open,
      FSL7_S_READ => open,
      FSL7_S_DATA => net_gnd32,
      FSL7_S_CONTROL => net_gnd0,
      FSL7_S_EXISTS => net_gnd0,
      FSL7_M_CLK => open,
      FSL7_M_WRITE => open,
      FSL7_M_DATA => open,
      FSL7_M_CONTROL => open,
      FSL7_M_FULL => net_gnd0,
      FSL8_S_CLK => open,
      FSL8_S_READ => open,
      FSL8_S_DATA => net_gnd32,
      FSL8_S_CONTROL => net_gnd0,
      FSL8_S_EXISTS => net_gnd0,
      FSL8_M_CLK => open,
      FSL8_M_WRITE => open,
      FSL8_M_DATA => open,
      FSL8_M_CONTROL => open,
      FSL8_M_FULL => net_gnd0,
      FSL9_S_CLK => open,
      FSL9_S_READ => open,
      FSL9_S_DATA => net_gnd32,
      FSL9_S_CONTROL => net_gnd0,
      FSL9_S_EXISTS => net_gnd0,
      FSL9_M_CLK => open,
      FSL9_M_WRITE => open,
      FSL9_M_DATA => open,
      FSL9_M_CONTROL => open,
      FSL9_M_FULL => net_gnd0,
      FSL10_S_CLK => open,
      FSL10_S_READ => open,
      FSL10_S_DATA => net_gnd32,
      FSL10_S_CONTROL => net_gnd0,
      FSL10_S_EXISTS => net_gnd0,
      FSL10_M_CLK => open,
      FSL10_M_WRITE => open,
      FSL10_M_DATA => open,
      FSL10_M_CONTROL => open,
      FSL10_M_FULL => net_gnd0,
      FSL11_S_CLK => open,
      FSL11_S_READ => open,
      FSL11_S_DATA => net_gnd32,
      FSL11_S_CONTROL => net_gnd0,
      FSL11_S_EXISTS => net_gnd0,
      FSL11_M_CLK => open,
      FSL11_M_WRITE => open,
      FSL11_M_DATA => open,
      FSL11_M_CONTROL => open,
      FSL11_M_FULL => net_gnd0,
      FSL12_S_CLK => open,
      FSL12_S_READ => open,
      FSL12_S_DATA => net_gnd32,
      FSL12_S_CONTROL => net_gnd0,
      FSL12_S_EXISTS => net_gnd0,
      FSL12_M_CLK => open,
      FSL12_M_WRITE => open,
      FSL12_M_DATA => open,
      FSL12_M_CONTROL => open,
      FSL12_M_FULL => net_gnd0,
      FSL13_S_CLK => open,
      FSL13_S_READ => open,
      FSL13_S_DATA => net_gnd32,
      FSL13_S_CONTROL => net_gnd0,
      FSL13_S_EXISTS => net_gnd0,
      FSL13_M_CLK => open,
      FSL13_M_WRITE => open,
      FSL13_M_DATA => open,
      FSL13_M_CONTROL => open,
      FSL13_M_FULL => net_gnd0,
      FSL14_S_CLK => open,
      FSL14_S_READ => open,
      FSL14_S_DATA => net_gnd32,
      FSL14_S_CONTROL => net_gnd0,
      FSL14_S_EXISTS => net_gnd0,
      FSL14_M_CLK => open,
      FSL14_M_WRITE => open,
      FSL14_M_DATA => open,
      FSL14_M_CONTROL => open,
      FSL14_M_FULL => net_gnd0,
      FSL15_S_CLK => open,
      FSL15_S_READ => open,
      FSL15_S_DATA => net_gnd32,
      FSL15_S_CONTROL => net_gnd0,
      FSL15_S_EXISTS => net_gnd0,
      FSL15_M_CLK => open,
      FSL15_M_WRITE => open,
      FSL15_M_DATA => open,
      FSL15_M_CONTROL => open,
      FSL15_M_FULL => net_gnd0,
      ICACHE_FSL_IN_CLK => ixcl_FSL_S_Clk,
      ICACHE_FSL_IN_READ => ixcl_FSL_S_Read,
      ICACHE_FSL_IN_DATA => ixcl_FSL_S_Data,
      ICACHE_FSL_IN_CONTROL => ixcl_FSL_S_Control,
      ICACHE_FSL_IN_EXISTS => ixcl_FSL_S_Exists,
      ICACHE_FSL_OUT_CLK => ixcl_FSL_M_Clk,
      ICACHE_FSL_OUT_WRITE => ixcl_FSL_M_Write,
      ICACHE_FSL_OUT_DATA => ixcl_FSL_M_Data,
      ICACHE_FSL_OUT_CONTROL => ixcl_FSL_M_Control,
      ICACHE_FSL_OUT_FULL => ixcl_FSL_M_Full,
      DCACHE_FSL_IN_CLK => dxcl_FSL_S_Clk,
      DCACHE_FSL_IN_READ => dxcl_FSL_S_Read,
      DCACHE_FSL_IN_DATA => dxcl_FSL_S_Data,
      DCACHE_FSL_IN_CONTROL => dxcl_FSL_S_Control,
      DCACHE_FSL_IN_EXISTS => dxcl_FSL_S_Exists,
      DCACHE_FSL_OUT_CLK => dxcl_FSL_M_Clk,
      DCACHE_FSL_OUT_WRITE => dxcl_FSL_M_Write,
      DCACHE_FSL_OUT_DATA => dxcl_FSL_M_Data,
      DCACHE_FSL_OUT_CONTROL => dxcl_FSL_M_Control,
      DCACHE_FSL_OUT_FULL => dxcl_FSL_M_Full
    );

  mb_plb : mb_plb_wrapper
    port map (
      PLB_Clk => sys_clk_s,
      SYS_Rst => sys_bus_reset(0),
      PLB_Rst => open,
      SPLB_Rst => mb_plb_SPLB_Rst,
      MPLB_Rst => open,
      PLB_dcrAck => open,
      PLB_dcrDBus => open,
      DCR_ABus => net_gnd10,
      DCR_DBus => net_gnd32,
      DCR_Read => net_gnd0,
      DCR_Write => net_gnd0,
      M_ABus => mb_plb_M_ABus,
      M_UABus => mb_plb_M_UABus,
      M_BE => mb_plb_M_BE,
      M_RNW => mb_plb_M_RNW,
      M_abort => mb_plb_M_ABort,
      M_busLock => mb_plb_M_busLock,
      M_TAttribute => mb_plb_M_TAttribute,
      M_lockErr => mb_plb_M_lockErr,
      M_MSize => mb_plb_M_MSize,
      M_priority => mb_plb_M_priority,
      M_rdBurst => mb_plb_M_rdBurst,
      M_request => mb_plb_M_request,
      M_size => mb_plb_M_size,
      M_type => mb_plb_M_type,
      M_wrBurst => mb_plb_M_wrBurst,
      M_wrDBus => mb_plb_M_wrDBus,
      Sl_addrAck => mb_plb_Sl_addrAck,
      Sl_MRdErr => mb_plb_Sl_MRdErr,
      Sl_MWrErr => mb_plb_Sl_MWrErr,
      Sl_MBusy => mb_plb_Sl_MBusy,
      Sl_rdBTerm => mb_plb_Sl_rdBTerm,
      Sl_rdComp => mb_plb_Sl_rdComp,
      Sl_rdDAck => mb_plb_Sl_rdDAck,
      Sl_rdDBus => mb_plb_Sl_rdDBus,
      Sl_rdWdAddr => mb_plb_Sl_rdWdAddr,
      Sl_rearbitrate => mb_plb_Sl_rearbitrate,
      Sl_SSize => mb_plb_Sl_SSize,
      Sl_wait => mb_plb_Sl_wait,
      Sl_wrBTerm => mb_plb_Sl_wrBTerm,
      Sl_wrComp => mb_plb_Sl_wrComp,
      Sl_wrDAck => mb_plb_Sl_wrDAck,
      Sl_MIRQ => mb_plb_Sl_MIRQ,
      PLB_MIRQ => mb_plb_PLB_MIRQ,
      PLB_ABus => mb_plb_PLB_ABus,
      PLB_UABus => mb_plb_PLB_UABus,
      PLB_BE => mb_plb_PLB_BE,
      PLB_MAddrAck => mb_plb_PLB_MAddrAck,
      PLB_MTimeout => mb_plb_PLB_MTimeout,
      PLB_MBusy => mb_plb_PLB_MBusy,
      PLB_MRdErr => mb_plb_PLB_MRdErr,
      PLB_MWrErr => mb_plb_PLB_MWrErr,
      PLB_MRdBTerm => mb_plb_PLB_MRdBTerm,
      PLB_MRdDAck => mb_plb_PLB_MRdDAck,
      PLB_MRdDBus => mb_plb_PLB_MRdDBus,
      PLB_MRdWdAddr => mb_plb_PLB_MRdWdAddr,
      PLB_MRearbitrate => mb_plb_PLB_MRearbitrate,
      PLB_MWrBTerm => mb_plb_PLB_MWrBTerm,
      PLB_MWrDAck => mb_plb_PLB_MWrDAck,
      PLB_MSSize => mb_plb_PLB_MSSize,
      PLB_PAValid => mb_plb_PLB_PAValid,
      PLB_RNW => mb_plb_PLB_RNW,
      PLB_SAValid => mb_plb_PLB_SAValid,
      PLB_abort => mb_plb_PLB_abort,
      PLB_busLock => mb_plb_PLB_busLock,
      PLB_TAttribute => mb_plb_PLB_TAttribute,
      PLB_lockErr => mb_plb_PLB_lockErr,
      PLB_masterID => mb_plb_PLB_masterID(0 to 0),
      PLB_MSize => mb_plb_PLB_MSize,
      PLB_rdPendPri => mb_plb_PLB_rdPendPri,
      PLB_wrPendPri => mb_plb_PLB_wrPendPri,
      PLB_rdPendReq => mb_plb_PLB_rdPendReq,
      PLB_wrPendReq => mb_plb_PLB_wrPendReq,
      PLB_rdBurst => mb_plb_PLB_rdBurst,
      PLB_rdPrim => mb_plb_PLB_rdPrim,
      PLB_reqPri => mb_plb_PLB_reqPri,
      PLB_size => mb_plb_PLB_size,
      PLB_type => mb_plb_PLB_type,
      PLB_wrBurst => mb_plb_PLB_wrBurst,
      PLB_wrDBus => mb_plb_PLB_wrDBus,
      PLB_wrPrim => mb_plb_PLB_wrPrim,
      PLB_SaddrAck => open,
      PLB_SMRdErr => open,
      PLB_SMWrErr => open,
      PLB_SMBusy => open,
      PLB_SrdBTerm => open,
      PLB_SrdComp => open,
      PLB_SrdDAck => open,
      PLB_SrdDBus => open,
      PLB_SrdWdAddr => open,
      PLB_Srearbitrate => open,
      PLB_Sssize => open,
      PLB_Swait => open,
      PLB_SwrBTerm => open,
      PLB_SwrComp => open,
      PLB_SwrDAck => open,
      Bus_Error_Det => open
    );

  ilmb : ilmb_wrapper
    port map (
      LMB_Clk => sys_clk_s,
      SYS_Rst => sys_bus_reset(0),
      LMB_Rst => ilmb_OPB_Rst,
      M_ABus => ilmb_M_ABus,
      M_ReadStrobe => ilmb_M_ReadStrobe,
      M_WriteStrobe => net_gnd0,
      M_AddrStrobe => ilmb_M_AddrStrobe,
      M_DBus => net_gnd32,
      M_BE => net_gnd4,
      Sl_DBus => ilmb_Sl_DBus,
      Sl_Ready => ilmb_Sl_Ready(0 to 0),
      LMB_ABus => ilmb_LMB_ABus,
      LMB_ReadStrobe => ilmb_LMB_ReadStrobe,
      LMB_WriteStrobe => ilmb_LMB_WriteStrobe,
      LMB_AddrStrobe => ilmb_LMB_AddrStrobe,
      LMB_ReadDBus => ilmb_LMB_ReadDBus,
      LMB_WriteDBus => ilmb_LMB_WriteDBus,
      LMB_Ready => ilmb_LMB_Ready,
      LMB_BE => ilmb_LMB_BE
    );

  dlmb : dlmb_wrapper
    port map (
      LMB_Clk => sys_clk_s,
      SYS_Rst => sys_bus_reset(0),
      LMB_Rst => dlmb_OPB_Rst,
      M_ABus => dlmb_M_ABus,
      M_ReadStrobe => dlmb_M_ReadStrobe,
      M_WriteStrobe => dlmb_M_WriteStrobe,
      M_AddrStrobe => dlmb_M_AddrStrobe,
      M_DBus => dlmb_M_DBus,
      M_BE => dlmb_M_BE,
      Sl_DBus => dlmb_Sl_DBus,
      Sl_Ready => dlmb_Sl_Ready(0 to 0),
      LMB_ABus => dlmb_LMB_ABus,
      LMB_ReadStrobe => dlmb_LMB_ReadStrobe,
      LMB_WriteStrobe => dlmb_LMB_WriteStrobe,
      LMB_AddrStrobe => dlmb_LMB_AddrStrobe,
      LMB_ReadDBus => dlmb_LMB_ReadDBus,
      LMB_WriteDBus => dlmb_LMB_WriteDBus,
      LMB_Ready => dlmb_LMB_Ready,
      LMB_BE => dlmb_LMB_BE
    );

  dlmb_cntlr : dlmb_cntlr_wrapper
    port map (
      LMB_Clk => sys_clk_s,
      LMB_Rst => dlmb_OPB_Rst,
      LMB_ABus => dlmb_LMB_ABus,
      LMB_WriteDBus => dlmb_LMB_WriteDBus,
      LMB_AddrStrobe => dlmb_LMB_AddrStrobe,
      LMB_ReadStrobe => dlmb_LMB_ReadStrobe,
      LMB_WriteStrobe => dlmb_LMB_WriteStrobe,
      LMB_BE => dlmb_LMB_BE,
      Sl_DBus => dlmb_Sl_DBus,
      Sl_Ready => dlmb_Sl_Ready(0),
      BRAM_Rst_A => dlmb_port_BRAM_Rst,
      BRAM_Clk_A => dlmb_port_BRAM_Clk,
      BRAM_EN_A => dlmb_port_BRAM_EN,
      BRAM_WEN_A => dlmb_port_BRAM_WEN,
      BRAM_Addr_A => dlmb_port_BRAM_Addr,
      BRAM_Din_A => dlmb_port_BRAM_Din,
      BRAM_Dout_A => dlmb_port_BRAM_Dout
    );

  ilmb_cntlr : ilmb_cntlr_wrapper
    port map (
      LMB_Clk => sys_clk_s,
      LMB_Rst => ilmb_OPB_Rst,
      LMB_ABus => ilmb_LMB_ABus,
      LMB_WriteDBus => ilmb_LMB_WriteDBus,
      LMB_AddrStrobe => ilmb_LMB_AddrStrobe,
      LMB_ReadStrobe => ilmb_LMB_ReadStrobe,
      LMB_WriteStrobe => ilmb_LMB_WriteStrobe,
      LMB_BE => ilmb_LMB_BE,
      Sl_DBus => ilmb_Sl_DBus,
      Sl_Ready => ilmb_Sl_Ready(0),
      BRAM_Rst_A => ilmb_port_BRAM_Rst,
      BRAM_Clk_A => ilmb_port_BRAM_Clk,
      BRAM_EN_A => ilmb_port_BRAM_EN,
      BRAM_WEN_A => ilmb_port_BRAM_WEN,
      BRAM_Addr_A => ilmb_port_BRAM_Addr,
      BRAM_Din_A => ilmb_port_BRAM_Din,
      BRAM_Dout_A => ilmb_port_BRAM_Dout
    );

  lmb_bram : lmb_bram_wrapper
    port map (
      BRAM_Rst_A => ilmb_port_BRAM_Rst,
      BRAM_Clk_A => ilmb_port_BRAM_Clk,
      BRAM_EN_A => ilmb_port_BRAM_EN,
      BRAM_WEN_A => ilmb_port_BRAM_WEN,
      BRAM_Addr_A => ilmb_port_BRAM_Addr,
      BRAM_Din_A => ilmb_port_BRAM_Din,
      BRAM_Dout_A => ilmb_port_BRAM_Dout,
      BRAM_Rst_B => dlmb_port_BRAM_Rst,
      BRAM_Clk_B => dlmb_port_BRAM_Clk,
      BRAM_EN_B => dlmb_port_BRAM_EN,
      BRAM_WEN_B => dlmb_port_BRAM_WEN,
      BRAM_Addr_B => dlmb_port_BRAM_Addr,
      BRAM_Din_B => dlmb_port_BRAM_Din,
      BRAM_Dout_B => dlmb_port_BRAM_Dout
    );

  RS232_Uart_1 : rs232_uart_1_wrapper
    port map (
      SPLB_Clk => sys_clk_s,
      SPLB_Rst => mb_plb_SPLB_Rst(0),
      PLB_ABus => mb_plb_PLB_ABus,
      PLB_PAValid => mb_plb_PLB_PAValid,
      PLB_masterID => mb_plb_PLB_masterID(0 to 0),
      PLB_RNW => mb_plb_PLB_RNW,
      PLB_BE => mb_plb_PLB_BE,
      PLB_size => mb_plb_PLB_size,
      PLB_type => mb_plb_PLB_type,
      PLB_wrDBus => mb_plb_PLB_wrDBus,
      PLB_UABus => mb_plb_PLB_UABus,
      PLB_SAValid => mb_plb_PLB_SAValid,
      PLB_rdPrim => mb_plb_PLB_rdPrim(0),
      PLB_wrPrim => mb_plb_PLB_wrPrim(0),
      PLB_abort => mb_plb_PLB_abort,
      PLB_busLock => mb_plb_PLB_busLock,
      PLB_MSize => mb_plb_PLB_MSize,
      PLB_lockErr => mb_plb_PLB_lockErr,
      PLB_wrBurst => mb_plb_PLB_wrBurst,
      PLB_rdBurst => mb_plb_PLB_rdBurst,
      PLB_wrPendReq => mb_plb_PLB_wrPendReq,
      PLB_rdPendReq => mb_plb_PLB_rdPendReq,
      PLB_wrPendPri => mb_plb_PLB_wrPendPri,
      PLB_rdPendPri => mb_plb_PLB_rdPendPri,
      PLB_reqPri => mb_plb_PLB_reqPri,
      PLB_TAttribute => mb_plb_PLB_TAttribute,
      Sl_addrAck => mb_plb_Sl_addrAck(0),
      Sl_SSize => mb_plb_Sl_SSize(0 to 1),
      Sl_wait => mb_plb_Sl_wait(0),
      Sl_rearbitrate => mb_plb_Sl_rearbitrate(0),
      Sl_wrDAck => mb_plb_Sl_wrDAck(0),
      Sl_wrComp => mb_plb_Sl_wrComp(0),
      Sl_rdDBus => mb_plb_Sl_rdDBus(0 to 63),
      Sl_rdDAck => mb_plb_Sl_rdDAck(0),
      Sl_rdComp => mb_plb_Sl_rdComp(0),
      Sl_MBusy => mb_plb_Sl_MBusy(0 to 1),
      Sl_MWrErr => mb_plb_Sl_MWrErr(0 to 1),
      Sl_MRdErr => mb_plb_Sl_MRdErr(0 to 1),
      Sl_wrBTerm => mb_plb_Sl_wrBTerm(0),
      Sl_rdWdAddr => mb_plb_Sl_rdWdAddr(0 to 3),
      Sl_rdBTerm => mb_plb_Sl_rdBTerm(0),
      Sl_MIRQ => mb_plb_Sl_MIRQ(0 to 1),
      RX => fpga_0_RS232_Uart_1_RX,
      TX => fpga_0_RS232_Uart_1_TX,
      Interrupt => open
    );

  LEDs_8Bit : leds_8bit_wrapper
    port map (
      SPLB_Clk => sys_clk_s,
      SPLB_Rst => mb_plb_SPLB_Rst(1),
      PLB_ABus => mb_plb_PLB_ABus,
      PLB_UABus => mb_plb_PLB_UABus,
      PLB_PAValid => mb_plb_PLB_PAValid,
      PLB_SAValid => mb_plb_PLB_SAValid,
      PLB_rdPrim => mb_plb_PLB_rdPrim(1),
      PLB_wrPrim => mb_plb_PLB_wrPrim(1),
      PLB_masterID => mb_plb_PLB_masterID(0 to 0),
      PLB_abort => mb_plb_PLB_abort,
      PLB_busLock => mb_plb_PLB_busLock,
      PLB_RNW => mb_plb_PLB_RNW,
      PLB_BE => mb_plb_PLB_BE,
      PLB_MSize => mb_plb_PLB_MSize,
      PLB_size => mb_plb_PLB_size,
      PLB_type => mb_plb_PLB_type,
      PLB_lockErr => mb_plb_PLB_lockErr,
      PLB_wrDBus => mb_plb_PLB_wrDBus,
      PLB_wrBurst => mb_plb_PLB_wrBurst,
      PLB_rdBurst => mb_plb_PLB_rdBurst,
      PLB_wrPendReq => mb_plb_PLB_wrPendReq,
      PLB_rdPendReq => mb_plb_PLB_rdPendReq,
      PLB_wrPendPri => mb_plb_PLB_wrPendPri,
      PLB_rdPendPri => mb_plb_PLB_rdPendPri,
      PLB_reqPri => mb_plb_PLB_reqPri,
      PLB_TAttribute => mb_plb_PLB_TAttribute,
      Sl_addrAck => mb_plb_Sl_addrAck(1),
      Sl_SSize => mb_plb_Sl_SSize(2 to 3),
      Sl_wait => mb_plb_Sl_wait(1),
      Sl_rearbitrate => mb_plb_Sl_rearbitrate(1),
      Sl_wrDAck => mb_plb_Sl_wrDAck(1),
      Sl_wrComp => mb_plb_Sl_wrComp(1),
      Sl_wrBTerm => mb_plb_Sl_wrBTerm(1),
      Sl_rdDBus => mb_plb_Sl_rdDBus(64 to 127),
      Sl_rdWdAddr => mb_plb_Sl_rdWdAddr(4 to 7),
      Sl_rdDAck => mb_plb_Sl_rdDAck(1),
      Sl_rdComp => mb_plb_Sl_rdComp(1),
      Sl_rdBTerm => mb_plb_Sl_rdBTerm(1),
      Sl_MBusy => mb_plb_Sl_MBusy(2 to 3),
      Sl_MWrErr => mb_plb_Sl_MWrErr(2 to 3),
      Sl_MRdErr => mb_plb_Sl_MRdErr(2 to 3),
      Sl_MIRQ => mb_plb_Sl_MIRQ(2 to 3),
      IP2INTC_Irpt => open,
      GPIO_IO_I => fpga_0_LEDs_8Bit_GPIO_IO_I,
      GPIO_IO_O => fpga_0_LEDs_8Bit_GPIO_IO_O,
      GPIO_IO_T => fpga_0_LEDs_8Bit_GPIO_IO_T,
      GPIO_in => net_gnd8,
      GPIO_d_out => open,
      GPIO_t_out => open,
      GPIO2_IO_I => net_gnd8,
      GPIO2_IO_O => open,
      GPIO2_IO_T => open,
      GPIO2_in => net_gnd8,
      GPIO2_d_out => open,
      GPIO2_t_out => open
    );

  SRAM : sram_wrapper
    port map (
      MCH_PLB_Clk => sys_clk_s,
      RdClk => sys_clk_s,
      MCH_PLB_Rst => mb_plb_SPLB_Rst(2),
      MCH0_Access_Control => net_gnd0,
      MCH0_Access_Data => net_gnd32,
      MCH0_Access_Write => net_gnd0,
      MCH0_Access_Full => open,
      MCH0_ReadData_Control => open,
      MCH0_ReadData_Data => open,
      MCH0_ReadData_Read => net_gnd0,
      MCH0_ReadData_Exists => open,
      MCH1_Access_Control => net_gnd0,
      MCH1_Access_Data => net_gnd32,
      MCH1_Access_Write => net_gnd0,
      MCH1_Access_Full => open,
      MCH1_ReadData_Control => open,
      MCH1_ReadData_Data => open,
      MCH1_ReadData_Read => net_gnd0,
      MCH1_ReadData_Exists => open,
      MCH2_Access_Control => net_gnd0,
      MCH2_Access_Data => net_gnd32,
      MCH2_Access_Write => net_gnd0,
      MCH2_Access_Full => open,
      MCH2_ReadData_Control => open,
      MCH2_ReadData_Data => open,
      MCH2_ReadData_Read => net_gnd0,
      MCH2_ReadData_Exists => open,
      MCH3_Access_Control => net_gnd0,
      MCH3_Access_Data => net_gnd32,
      MCH3_Access_Write => net_gnd0,
      MCH3_Access_Full => open,
      MCH3_ReadData_Control => open,
      MCH3_ReadData_Data => open,
      MCH3_ReadData_Read => net_gnd0,
      MCH3_ReadData_Exists => open,
      PLB_ABus => mb_plb_PLB_ABus,
      PLB_UABus => mb_plb_PLB_UABus,
      PLB_PAValid => mb_plb_PLB_PAValid,
      PLB_SAValid => mb_plb_PLB_SAValid,
      PLB_rdPrim => mb_plb_PLB_rdPrim(2),
      PLB_wrPrim => mb_plb_PLB_wrPrim(2),
      PLB_masterID => mb_plb_PLB_masterID(0 to 0),
      PLB_abort => mb_plb_PLB_abort,
      PLB_busLock => mb_plb_PLB_busLock,
      PLB_RNW => mb_plb_PLB_RNW,
      PLB_BE => mb_plb_PLB_BE,
      PLB_MSize => mb_plb_PLB_MSize,
      PLB_size => mb_plb_PLB_size,
      PLB_type => mb_plb_PLB_type,
      PLB_lockErr => mb_plb_PLB_lockErr,
      PLB_wrDBus => mb_plb_PLB_wrDBus,
      PLB_wrBurst => mb_plb_PLB_wrBurst,
      PLB_rdBurst => mb_plb_PLB_rdBurst,
      PLB_wrPendReq => mb_plb_PLB_wrPendReq,
      PLB_rdPendReq => mb_plb_PLB_rdPendReq,
      PLB_wrPendPri => mb_plb_PLB_wrPendPri,
      PLB_rdPendPri => mb_plb_PLB_rdPendPri,
      PLB_reqPri => mb_plb_PLB_reqPri,
      PLB_TAttribute => mb_plb_PLB_TAttribute,
      Sl_addrAck => mb_plb_Sl_addrAck(2),
      Sl_SSize => mb_plb_Sl_SSize(4 to 5),
      Sl_wait => mb_plb_Sl_wait(2),
      Sl_rearbitrate => mb_plb_Sl_rearbitrate(2),
      Sl_wrDAck => mb_plb_Sl_wrDAck(2),
      Sl_wrComp => mb_plb_Sl_wrComp(2),
      Sl_wrBTerm => mb_plb_Sl_wrBTerm(2),
      Sl_rdDBus => mb_plb_Sl_rdDBus(128 to 191),
      Sl_rdWdAddr => mb_plb_Sl_rdWdAddr(8 to 11),
      Sl_rdDAck => mb_plb_Sl_rdDAck(2),
      Sl_rdComp => mb_plb_Sl_rdComp(2),
      Sl_rdBTerm => mb_plb_Sl_rdBTerm(2),
      Sl_MBusy => mb_plb_Sl_MBusy(4 to 5),
      Sl_MWrErr => mb_plb_Sl_MWrErr(4 to 5),
      Sl_MRdErr => mb_plb_Sl_MRdErr(4 to 5),
      Sl_MIRQ => mb_plb_Sl_MIRQ(4 to 5),
      Mem_DQ_I => fpga_0_SRAM_Mem_DQ_I,
      Mem_DQ_O => fpga_0_SRAM_Mem_DQ_O,
      Mem_DQ_T => fpga_0_SRAM_Mem_DQ_T,
      Mem_A => fpga_0_SRAM_Mem_A_split,
      Mem_RPN => open,
      Mem_CEN => fpga_0_SRAM_Mem_CEN(0 to 0),
      Mem_OEN => fpga_0_SRAM_Mem_OEN(0 to 0),
      Mem_WEN => fpga_0_SRAM_Mem_WEN,
      Mem_QWEN => open,
      Mem_BEN => fpga_0_SRAM_Mem_BEN,
      Mem_CE => open,
      Mem_ADV_LDN => fpga_0_SRAM_Mem_ADV_LDN,
      Mem_LBON => open,
      Mem_CKEN => open,
      Mem_RNW => open
    );

  DDR2_SDRAM : ddr2_sdram_wrapper
    port map (
      FSL0_M_Clk => ixcl_FSL_M_Clk,
      FSL0_M_Write => ixcl_FSL_M_Write,
      FSL0_M_Data => ixcl_FSL_M_Data,
      FSL0_M_Control => ixcl_FSL_M_Control,
      FSL0_M_Full => ixcl_FSL_M_Full,
      FSL0_S_Clk => ixcl_FSL_S_Clk,
      FSL0_S_Read => ixcl_FSL_S_Read,
      FSL0_S_Data => ixcl_FSL_S_Data,
      FSL0_S_Control => ixcl_FSL_S_Control,
      FSL0_S_Exists => ixcl_FSL_S_Exists,
      SPLB0_Clk => net_vcc0,
      SPLB0_Rst => net_gnd0,
      SPLB0_PLB_ABus => net_gnd32,
      SPLB0_PLB_PAValid => net_gnd0,
      SPLB0_PLB_SAValid => net_gnd0,
      SPLB0_PLB_masterID => net_gnd1(0 to 0),
      SPLB0_PLB_RNW => net_gnd0,
      SPLB0_PLB_BE => net_gnd8,
      SPLB0_PLB_UABus => net_gnd32,
      SPLB0_PLB_rdPrim => net_gnd0,
      SPLB0_PLB_wrPrim => net_gnd0,
      SPLB0_PLB_abort => net_gnd0,
      SPLB0_PLB_busLock => net_gnd0,
      SPLB0_PLB_MSize => net_gnd2,
      SPLB0_PLB_size => net_gnd4,
      SPLB0_PLB_type => net_gnd3,
      SPLB0_PLB_lockErr => net_gnd0,
      SPLB0_PLB_wrPendReq => net_gnd0,
      SPLB0_PLB_wrPendPri => net_gnd2,
      SPLB0_PLB_rdPendReq => net_gnd0,
      SPLB0_PLB_rdPendPri => net_gnd2,
      SPLB0_PLB_reqPri => net_gnd2,
      SPLB0_PLB_TAttribute => net_gnd16,
      SPLB0_PLB_rdBurst => net_gnd0,
      SPLB0_PLB_wrBurst => net_gnd0,
      SPLB0_PLB_wrDBus => net_gnd64,
      SPLB0_Sl_addrAck => open,
      SPLB0_Sl_SSize => open,
      SPLB0_Sl_wait => open,
      SPLB0_Sl_rearbitrate => open,
      SPLB0_Sl_wrDAck => open,
      SPLB0_Sl_wrComp => open,
      SPLB0_Sl_wrBTerm => open,
      SPLB0_Sl_rdDBus => open,
      SPLB0_Sl_rdWdAddr => open,
      SPLB0_Sl_rdDAck => open,
      SPLB0_Sl_rdComp => open,
      SPLB0_Sl_rdBTerm => open,
      SPLB0_Sl_MBusy => open,
      SPLB0_Sl_MRdErr => open,
      SPLB0_Sl_MWrErr => open,
      SPLB0_Sl_MIRQ => open,
      SDMA0_Clk => net_gnd0,
      SDMA0_Rx_IntOut => open,
      SDMA0_Tx_IntOut => open,
      SDMA0_RstOut => open,
      SDMA0_TX_D => open,
      SDMA0_TX_Rem => open,
      SDMA0_TX_SOF => open,
      SDMA0_TX_EOF => open,
      SDMA0_TX_SOP => open,
      SDMA0_TX_EOP => open,
      SDMA0_TX_Src_Rdy => open,
      SDMA0_TX_Dst_Rdy => net_vcc0,
      SDMA0_RX_D => net_gnd32,
      SDMA0_RX_Rem => net_vcc4,
      SDMA0_RX_SOF => net_vcc0,
      SDMA0_RX_EOF => net_vcc0,
      SDMA0_RX_SOP => net_vcc0,
      SDMA0_RX_EOP => net_vcc0,
      SDMA0_RX_Src_Rdy => net_vcc0,
      SDMA0_RX_Dst_Rdy => open,
      SDMA_CTRL0_Clk => net_vcc0,
      SDMA_CTRL0_Rst => net_gnd0,
      SDMA_CTRL0_PLB_ABus => net_gnd32,
      SDMA_CTRL0_PLB_PAValid => net_gnd0,
      SDMA_CTRL0_PLB_SAValid => net_gnd0,
      SDMA_CTRL0_PLB_masterID => net_gnd1(0 to 0),
      SDMA_CTRL0_PLB_RNW => net_gnd0,
      SDMA_CTRL0_PLB_BE => net_gnd8,
      SDMA_CTRL0_PLB_UABus => net_gnd32,
      SDMA_CTRL0_PLB_rdPrim => net_gnd0,
      SDMA_CTRL0_PLB_wrPrim => net_gnd0,
      SDMA_CTRL0_PLB_abort => net_gnd0,
      SDMA_CTRL0_PLB_busLock => net_gnd0,
      SDMA_CTRL0_PLB_MSize => net_gnd2,
      SDMA_CTRL0_PLB_size => net_gnd4,
      SDMA_CTRL0_PLB_type => net_gnd3,
      SDMA_CTRL0_PLB_lockErr => net_gnd0,
      SDMA_CTRL0_PLB_wrPendReq => net_gnd0,
      SDMA_CTRL0_PLB_wrPendPri => net_gnd2,
      SDMA_CTRL0_PLB_rdPendReq => net_gnd0,
      SDMA_CTRL0_PLB_rdPendPri => net_gnd2,
      SDMA_CTRL0_PLB_reqPri => net_gnd2,
      SDMA_CTRL0_PLB_TAttribute => net_gnd16,
      SDMA_CTRL0_PLB_rdBurst => net_gnd0,
      SDMA_CTRL0_PLB_wrBurst => net_gnd0,
      SDMA_CTRL0_PLB_wrDBus => net_gnd64,
      SDMA_CTRL0_Sl_addrAck => open,
      SDMA_CTRL0_Sl_SSize => open,
      SDMA_CTRL0_Sl_wait => open,
      SDMA_CTRL0_Sl_rearbitrate => open,
      SDMA_CTRL0_Sl_wrDAck => open,
      SDMA_CTRL0_Sl_wrComp => open,
      SDMA_CTRL0_Sl_wrBTerm => open,
      SDMA_CTRL0_Sl_rdDBus => open,
      SDMA_CTRL0_Sl_rdWdAddr => open,
      SDMA_CTRL0_Sl_rdDAck => open,
      SDMA_CTRL0_Sl_rdComp => open,
      SDMA_CTRL0_Sl_rdBTerm => open,
      SDMA_CTRL0_Sl_MBusy => open,
      SDMA_CTRL0_Sl_MRdErr => open,
      SDMA_CTRL0_Sl_MWrErr => open,
      SDMA_CTRL0_Sl_MIRQ => open,
      PIM0_Addr => net_gnd32(0 to 31),
      PIM0_AddrReq => net_gnd0,
      PIM0_AddrAck => open,
      PIM0_RNW => net_gnd0,
      PIM0_Size => net_gnd4(0 to 3),
      PIM0_RdModWr => net_gnd0,
      PIM0_WrFIFO_Data => net_gnd64(0 to 63),
      PIM0_WrFIFO_BE => net_gnd8(0 to 7),
      PIM0_WrFIFO_Push => net_gnd0,
      PIM0_RdFIFO_Data => open,
      PIM0_RdFIFO_Pop => net_gnd0,
      PIM0_RdFIFO_RdWdAddr => open,
      PIM0_WrFIFO_Empty => open,
      PIM0_WrFIFO_AlmostFull => open,
      PIM0_WrFIFO_Flush => net_gnd0,
      PIM0_RdFIFO_Empty => open,
      PIM0_RdFIFO_Flush => net_gnd0,
      PIM0_RdFIFO_Latency => open,
      PIM0_InitDone => open,
      PPC440MC0_MIMCReadNotWrite => net_gnd0,
      PPC440MC0_MIMCAddress => net_gnd36,
      PPC440MC0_MIMCAddressValid => net_gnd0,
      PPC440MC0_MIMCWriteData => net_gnd128,
      PPC440MC0_MIMCWriteDataValid => net_gnd0,
      PPC440MC0_MIMCByteEnable => net_gnd16,
      PPC440MC0_MIMCBankConflict => net_gnd0,
      PPC440MC0_MIMCRowConflict => net_gnd0,
      PPC440MC0_MCMIReadData => open,
      PPC440MC0_MCMIReadDataValid => open,
      PPC440MC0_MCMIReadDataErr => open,
      PPC440MC0_MCMIAddrReadyToAccept => open,
      VFBC0_Cmd_Clk => net_gnd0,
      VFBC0_Cmd_Reset => net_gnd0,
      VFBC0_Cmd_Data => net_gnd32(0 to 31),
      VFBC0_Cmd_Write => net_gnd0,
      VFBC0_Cmd_End => net_gnd0,
      VFBC0_Cmd_Full => open,
      VFBC0_Cmd_Almost_Full => open,
      VFBC0_Cmd_Idle => open,
      VFBC0_Wd_Clk => net_gnd0,
      VFBC0_Wd_Reset => net_gnd0,
      VFBC0_Wd_Write => net_gnd0,
      VFBC0_Wd_End_Burst => net_gnd0,
      VFBC0_Wd_Flush => net_gnd0,
      VFBC0_Wd_Data => net_gnd32(0 to 31),
      VFBC0_Wd_Data_BE => net_gnd4(0 to 3),
      VFBC0_Wd_Full => open,
      VFBC0_Wd_Almost_Full => open,
      VFBC0_Rd_Clk => net_gnd0,
      VFBC0_Rd_Reset => net_gnd0,
      VFBC0_Rd_Read => net_gnd0,
      VFBC0_Rd_End_Burst => net_gnd0,
      VFBC0_Rd_Flush => net_gnd0,
      VFBC0_Rd_Data => open,
      VFBC0_Rd_Empty => open,
      VFBC0_Rd_Almost_Empty => open,
      FSL1_M_Clk => dxcl_FSL_M_Clk,
      FSL1_M_Write => dxcl_FSL_M_Write,
      FSL1_M_Data => dxcl_FSL_M_Data,
      FSL1_M_Control => dxcl_FSL_M_Control,
      FSL1_M_Full => dxcl_FSL_M_Full,
      FSL1_S_Clk => dxcl_FSL_S_Clk,
      FSL1_S_Read => dxcl_FSL_S_Read,
      FSL1_S_Data => dxcl_FSL_S_Data,
      FSL1_S_Control => dxcl_FSL_S_Control,
      FSL1_S_Exists => dxcl_FSL_S_Exists,
      SPLB1_Clk => net_vcc0,
      SPLB1_Rst => net_gnd0,
      SPLB1_PLB_ABus => net_gnd32,
      SPLB1_PLB_PAValid => net_gnd0,
      SPLB1_PLB_SAValid => net_gnd0,
      SPLB1_PLB_masterID => net_gnd1(0 to 0),
      SPLB1_PLB_RNW => net_gnd0,
      SPLB1_PLB_BE => net_gnd8,
      SPLB1_PLB_UABus => net_gnd32,
      SPLB1_PLB_rdPrim => net_gnd0,
      SPLB1_PLB_wrPrim => net_gnd0,
      SPLB1_PLB_abort => net_gnd0,
      SPLB1_PLB_busLock => net_gnd0,
      SPLB1_PLB_MSize => net_gnd2,
      SPLB1_PLB_size => net_gnd4,
      SPLB1_PLB_type => net_gnd3,
      SPLB1_PLB_lockErr => net_gnd0,
      SPLB1_PLB_wrPendReq => net_gnd0,
      SPLB1_PLB_wrPendPri => net_gnd2,
      SPLB1_PLB_rdPendReq => net_gnd0,
      SPLB1_PLB_rdPendPri => net_gnd2,
      SPLB1_PLB_reqPri => net_gnd2,
      SPLB1_PLB_TAttribute => net_gnd16,
      SPLB1_PLB_rdBurst => net_gnd0,
      SPLB1_PLB_wrBurst => net_gnd0,
      SPLB1_PLB_wrDBus => net_gnd64,
      SPLB1_Sl_addrAck => open,
      SPLB1_Sl_SSize => open,
      SPLB1_Sl_wait => open,
      SPLB1_Sl_rearbitrate => open,
      SPLB1_Sl_wrDAck => open,
      SPLB1_Sl_wrComp => open,
      SPLB1_Sl_wrBTerm => open,
      SPLB1_Sl_rdDBus => open,
      SPLB1_Sl_rdWdAddr => open,
      SPLB1_Sl_rdDAck => open,
      SPLB1_Sl_rdComp => open,
      SPLB1_Sl_rdBTerm => open,
      SPLB1_Sl_MBusy => open,
      SPLB1_Sl_MRdErr => open,
      SPLB1_Sl_MWrErr => open,
      SPLB1_Sl_MIRQ => open,
      SDMA1_Clk => net_gnd0,
      SDMA1_Rx_IntOut => open,
      SDMA1_Tx_IntOut => open,
      SDMA1_RstOut => open,
      SDMA1_TX_D => open,
      SDMA1_TX_Rem => open,
      SDMA1_TX_SOF => open,
      SDMA1_TX_EOF => open,
      SDMA1_TX_SOP => open,
      SDMA1_TX_EOP => open,
      SDMA1_TX_Src_Rdy => open,
      SDMA1_TX_Dst_Rdy => net_vcc0,
      SDMA1_RX_D => net_gnd32,
      SDMA1_RX_Rem => net_vcc4,
      SDMA1_RX_SOF => net_vcc0,
      SDMA1_RX_EOF => net_vcc0,
      SDMA1_RX_SOP => net_vcc0,
      SDMA1_RX_EOP => net_vcc0,
      SDMA1_RX_Src_Rdy => net_vcc0,
      SDMA1_RX_Dst_Rdy => open,
      SDMA_CTRL1_Clk => net_vcc0,
      SDMA_CTRL1_Rst => net_gnd0,
      SDMA_CTRL1_PLB_ABus => net_gnd32,
      SDMA_CTRL1_PLB_PAValid => net_gnd0,
      SDMA_CTRL1_PLB_SAValid => net_gnd0,
      SDMA_CTRL1_PLB_masterID => net_gnd1(0 to 0),
      SDMA_CTRL1_PLB_RNW => net_gnd0,
      SDMA_CTRL1_PLB_BE => net_gnd8,
      SDMA_CTRL1_PLB_UABus => net_gnd32,
      SDMA_CTRL1_PLB_rdPrim => net_gnd0,
      SDMA_CTRL1_PLB_wrPrim => net_gnd0,
      SDMA_CTRL1_PLB_abort => net_gnd0,
      SDMA_CTRL1_PLB_busLock => net_gnd0,
      SDMA_CTRL1_PLB_MSize => net_gnd2,
      SDMA_CTRL1_PLB_size => net_gnd4,
      SDMA_CTRL1_PLB_type => net_gnd3,
      SDMA_CTRL1_PLB_lockErr => net_gnd0,
      SDMA_CTRL1_PLB_wrPendReq => net_gnd0,
      SDMA_CTRL1_PLB_wrPendPri => net_gnd2,
      SDMA_CTRL1_PLB_rdPendReq => net_gnd0,
      SDMA_CTRL1_PLB_rdPendPri => net_gnd2,
      SDMA_CTRL1_PLB_reqPri => net_gnd2,
      SDMA_CTRL1_PLB_TAttribute => net_gnd16,
      SDMA_CTRL1_PLB_rdBurst => net_gnd0,
      SDMA_CTRL1_PLB_wrBurst => net_gnd0,
      SDMA_CTRL1_PLB_wrDBus => net_gnd64,
      SDMA_CTRL1_Sl_addrAck => open,
      SDMA_CTRL1_Sl_SSize => open,
      SDMA_CTRL1_Sl_wait => open,
      SDMA_CTRL1_Sl_rearbitrate => open,
      SDMA_CTRL1_Sl_wrDAck => open,
      SDMA_CTRL1_Sl_wrComp => open,
      SDMA_CTRL1_Sl_wrBTerm => open,
      SDMA_CTRL1_Sl_rdDBus => open,
      SDMA_CTRL1_Sl_rdWdAddr => open,
      SDMA_CTRL1_Sl_rdDAck => open,
      SDMA_CTRL1_Sl_rdComp => open,
      SDMA_CTRL1_Sl_rdBTerm => open,
      SDMA_CTRL1_Sl_MBusy => open,
      SDMA_CTRL1_Sl_MRdErr => open,
      SDMA_CTRL1_Sl_MWrErr => open,
      SDMA_CTRL1_Sl_MIRQ => open,
      PIM1_Addr => net_gnd32(0 to 31),
      PIM1_AddrReq => net_gnd0,
      PIM1_AddrAck => open,
      PIM1_RNW => net_gnd0,
      PIM1_Size => net_gnd4(0 to 3),
      PIM1_RdModWr => net_gnd0,
      PIM1_WrFIFO_Data => net_gnd64(0 to 63),
      PIM1_WrFIFO_BE => net_gnd8(0 to 7),
      PIM1_WrFIFO_Push => net_gnd0,
      PIM1_RdFIFO_Data => open,
      PIM1_RdFIFO_Pop => net_gnd0,
      PIM1_RdFIFO_RdWdAddr => open,
      PIM1_WrFIFO_Empty => open,
      PIM1_WrFIFO_AlmostFull => open,
      PIM1_WrFIFO_Flush => net_gnd0,
      PIM1_RdFIFO_Empty => open,
      PIM1_RdFIFO_Flush => net_gnd0,
      PIM1_RdFIFO_Latency => open,
      PIM1_InitDone => open,
      PPC440MC1_MIMCReadNotWrite => net_gnd0,
      PPC440MC1_MIMCAddress => net_gnd36,
      PPC440MC1_MIMCAddressValid => net_gnd0,
      PPC440MC1_MIMCWriteData => net_gnd128,
      PPC440MC1_MIMCWriteDataValid => net_gnd0,
      PPC440MC1_MIMCByteEnable => net_gnd16,
      PPC440MC1_MIMCBankConflict => net_gnd0,
      PPC440MC1_MIMCRowConflict => net_gnd0,
      PPC440MC1_MCMIReadData => open,
      PPC440MC1_MCMIReadDataValid => open,
      PPC440MC1_MCMIReadDataErr => open,
      PPC440MC1_MCMIAddrReadyToAccept => open,
      VFBC1_Cmd_Clk => net_gnd0,
      VFBC1_Cmd_Reset => net_gnd0,
      VFBC1_Cmd_Data => net_gnd32(0 to 31),
      VFBC1_Cmd_Write => net_gnd0,
      VFBC1_Cmd_End => net_gnd0,
      VFBC1_Cmd_Full => open,
      VFBC1_Cmd_Almost_Full => open,
      VFBC1_Cmd_Idle => open,
      VFBC1_Wd_Clk => net_gnd0,
      VFBC1_Wd_Reset => net_gnd0,
      VFBC1_Wd_Write => net_gnd0,
      VFBC1_Wd_End_Burst => net_gnd0,
      VFBC1_Wd_Flush => net_gnd0,
      VFBC1_Wd_Data => net_gnd32(0 to 31),
      VFBC1_Wd_Data_BE => net_gnd4(0 to 3),
      VFBC1_Wd_Full => open,
      VFBC1_Wd_Almost_Full => open,
      VFBC1_Rd_Clk => net_gnd0,
      VFBC1_Rd_Reset => net_gnd0,
      VFBC1_Rd_Read => net_gnd0,
      VFBC1_Rd_End_Burst => net_gnd0,
      VFBC1_Rd_Flush => net_gnd0,
      VFBC1_Rd_Data => open,
      VFBC1_Rd_Empty => open,
      VFBC1_Rd_Almost_Empty => open,
      FSL2_M_Clk => net_vcc0,
      FSL2_M_Write => net_gnd0,
      FSL2_M_Data => net_gnd32,
      FSL2_M_Control => net_gnd0,
      FSL2_M_Full => open,
      FSL2_S_Clk => net_gnd0,
      FSL2_S_Read => net_gnd0,
      FSL2_S_Data => open,
      FSL2_S_Control => open,
      FSL2_S_Exists => open,
      SPLB2_Clk => sys_clk_s,
      SPLB2_Rst => mb_plb_SPLB_Rst(3),
      SPLB2_PLB_ABus => mb_plb_PLB_ABus,
      SPLB2_PLB_PAValid => mb_plb_PLB_PAValid,
      SPLB2_PLB_SAValid => mb_plb_PLB_SAValid,
      SPLB2_PLB_masterID => mb_plb_PLB_masterID(0 to 0),
      SPLB2_PLB_RNW => mb_plb_PLB_RNW,
      SPLB2_PLB_BE => mb_plb_PLB_BE,
      SPLB2_PLB_UABus => mb_plb_PLB_UABus,
      SPLB2_PLB_rdPrim => mb_plb_PLB_rdPrim(3),
      SPLB2_PLB_wrPrim => mb_plb_PLB_wrPrim(3),
      SPLB2_PLB_abort => mb_plb_PLB_abort,
      SPLB2_PLB_busLock => mb_plb_PLB_busLock,
      SPLB2_PLB_MSize => mb_plb_PLB_MSize,
      SPLB2_PLB_size => mb_plb_PLB_size,
      SPLB2_PLB_type => mb_plb_PLB_type,
      SPLB2_PLB_lockErr => mb_plb_PLB_lockErr,
      SPLB2_PLB_wrPendReq => mb_plb_PLB_wrPendReq,
      SPLB2_PLB_wrPendPri => mb_plb_PLB_wrPendPri,
      SPLB2_PLB_rdPendReq => mb_plb_PLB_rdPendReq,
      SPLB2_PLB_rdPendPri => mb_plb_PLB_rdPendPri,
      SPLB2_PLB_reqPri => mb_plb_PLB_reqPri,
      SPLB2_PLB_TAttribute => mb_plb_PLB_TAttribute,
      SPLB2_PLB_rdBurst => mb_plb_PLB_rdBurst,
      SPLB2_PLB_wrBurst => mb_plb_PLB_wrBurst,
      SPLB2_PLB_wrDBus => mb_plb_PLB_wrDBus,
      SPLB2_Sl_addrAck => mb_plb_Sl_addrAck(3),
      SPLB2_Sl_SSize => mb_plb_Sl_SSize(6 to 7),
      SPLB2_Sl_wait => mb_plb_Sl_wait(3),
      SPLB2_Sl_rearbitrate => mb_plb_Sl_rearbitrate(3),
      SPLB2_Sl_wrDAck => mb_plb_Sl_wrDAck(3),
      SPLB2_Sl_wrComp => mb_plb_Sl_wrComp(3),
      SPLB2_Sl_wrBTerm => mb_plb_Sl_wrBTerm(3),
      SPLB2_Sl_rdDBus => mb_plb_Sl_rdDBus(192 to 255),
      SPLB2_Sl_rdWdAddr => mb_plb_Sl_rdWdAddr(12 to 15),
      SPLB2_Sl_rdDAck => mb_plb_Sl_rdDAck(3),
      SPLB2_Sl_rdComp => mb_plb_Sl_rdComp(3),
      SPLB2_Sl_rdBTerm => mb_plb_Sl_rdBTerm(3),
      SPLB2_Sl_MBusy => mb_plb_Sl_MBusy(6 to 7),
      SPLB2_Sl_MRdErr => mb_plb_Sl_MRdErr(6 to 7),
      SPLB2_Sl_MWrErr => mb_plb_Sl_MWrErr(6 to 7),
      SPLB2_Sl_MIRQ => mb_plb_Sl_MIRQ(6 to 7),
      SDMA2_Clk => net_gnd0,
      SDMA2_Rx_IntOut => open,
      SDMA2_Tx_IntOut => open,
      SDMA2_RstOut => open,
      SDMA2_TX_D => open,
      SDMA2_TX_Rem => open,
      SDMA2_TX_SOF => open,
      SDMA2_TX_EOF => open,
      SDMA2_TX_SOP => open,
      SDMA2_TX_EOP => open,
      SDMA2_TX_Src_Rdy => open,
      SDMA2_TX_Dst_Rdy => net_vcc0,
      SDMA2_RX_D => net_gnd32,
      SDMA2_RX_Rem => net_vcc4,
      SDMA2_RX_SOF => net_vcc0,
      SDMA2_RX_EOF => net_vcc0,
      SDMA2_RX_SOP => net_vcc0,
      SDMA2_RX_EOP => net_vcc0,
      SDMA2_RX_Src_Rdy => net_vcc0,
      SDMA2_RX_Dst_Rdy => open,
      SDMA_CTRL2_Clk => net_vcc0,
      SDMA_CTRL2_Rst => net_gnd0,
      SDMA_CTRL2_PLB_ABus => net_gnd32,
      SDMA_CTRL2_PLB_PAValid => net_gnd0,
      SDMA_CTRL2_PLB_SAValid => net_gnd0,
      SDMA_CTRL2_PLB_masterID => net_gnd1(0 to 0),
      SDMA_CTRL2_PLB_RNW => net_gnd0,
      SDMA_CTRL2_PLB_BE => net_gnd8,
      SDMA_CTRL2_PLB_UABus => net_gnd32,
      SDMA_CTRL2_PLB_rdPrim => net_gnd0,
      SDMA_CTRL2_PLB_wrPrim => net_gnd0,
      SDMA_CTRL2_PLB_abort => net_gnd0,
      SDMA_CTRL2_PLB_busLock => net_gnd0,
      SDMA_CTRL2_PLB_MSize => net_gnd2,
      SDMA_CTRL2_PLB_size => net_gnd4,
      SDMA_CTRL2_PLB_type => net_gnd3,
      SDMA_CTRL2_PLB_lockErr => net_gnd0,
      SDMA_CTRL2_PLB_wrPendReq => net_gnd0,
      SDMA_CTRL2_PLB_wrPendPri => net_gnd2,
      SDMA_CTRL2_PLB_rdPendReq => net_gnd0,
      SDMA_CTRL2_PLB_rdPendPri => net_gnd2,
      SDMA_CTRL2_PLB_reqPri => net_gnd2,
      SDMA_CTRL2_PLB_TAttribute => net_gnd16,
      SDMA_CTRL2_PLB_rdBurst => net_gnd0,
      SDMA_CTRL2_PLB_wrBurst => net_gnd0,
      SDMA_CTRL2_PLB_wrDBus => net_gnd64,
      SDMA_CTRL2_Sl_addrAck => open,
      SDMA_CTRL2_Sl_SSize => open,
      SDMA_CTRL2_Sl_wait => open,
      SDMA_CTRL2_Sl_rearbitrate => open,
      SDMA_CTRL2_Sl_wrDAck => open,
      SDMA_CTRL2_Sl_wrComp => open,
      SDMA_CTRL2_Sl_wrBTerm => open,
      SDMA_CTRL2_Sl_rdDBus => open,
      SDMA_CTRL2_Sl_rdWdAddr => open,
      SDMA_CTRL2_Sl_rdDAck => open,
      SDMA_CTRL2_Sl_rdComp => open,
      SDMA_CTRL2_Sl_rdBTerm => open,
      SDMA_CTRL2_Sl_MBusy => open,
      SDMA_CTRL2_Sl_MRdErr => open,
      SDMA_CTRL2_Sl_MWrErr => open,
      SDMA_CTRL2_Sl_MIRQ => open,
      PIM2_Addr => net_gnd32(0 to 31),
      PIM2_AddrReq => net_gnd0,
      PIM2_AddrAck => open,
      PIM2_RNW => net_gnd0,
      PIM2_Size => net_gnd4(0 to 3),
      PIM2_RdModWr => net_gnd0,
      PIM2_WrFIFO_Data => net_gnd64(0 to 63),
      PIM2_WrFIFO_BE => net_gnd8(0 to 7),
      PIM2_WrFIFO_Push => net_gnd0,
      PIM2_RdFIFO_Data => open,
      PIM2_RdFIFO_Pop => net_gnd0,
      PIM2_RdFIFO_RdWdAddr => open,
      PIM2_WrFIFO_Empty => open,
      PIM2_WrFIFO_AlmostFull => open,
      PIM2_WrFIFO_Flush => net_gnd0,
      PIM2_RdFIFO_Empty => open,
      PIM2_RdFIFO_Flush => net_gnd0,
      PIM2_RdFIFO_Latency => open,
      PIM2_InitDone => open,
      PPC440MC2_MIMCReadNotWrite => net_gnd0,
      PPC440MC2_MIMCAddress => net_gnd36,
      PPC440MC2_MIMCAddressValid => net_gnd0,
      PPC440MC2_MIMCWriteData => net_gnd128,
      PPC440MC2_MIMCWriteDataValid => net_gnd0,
      PPC440MC2_MIMCByteEnable => net_gnd16,
      PPC440MC2_MIMCBankConflict => net_gnd0,
      PPC440MC2_MIMCRowConflict => net_gnd0,
      PPC440MC2_MCMIReadData => open,
      PPC440MC2_MCMIReadDataValid => open,
      PPC440MC2_MCMIReadDataErr => open,
      PPC440MC2_MCMIAddrReadyToAccept => open,
      VFBC2_Cmd_Clk => net_gnd0,
      VFBC2_Cmd_Reset => net_gnd0,
      VFBC2_Cmd_Data => net_gnd32(0 to 31),
      VFBC2_Cmd_Write => net_gnd0,
      VFBC2_Cmd_End => net_gnd0,
      VFBC2_Cmd_Full => open,
      VFBC2_Cmd_Almost_Full => open,
      VFBC2_Cmd_Idle => open,
      VFBC2_Wd_Clk => net_gnd0,
      VFBC2_Wd_Reset => net_gnd0,
      VFBC2_Wd_Write => net_gnd0,
      VFBC2_Wd_End_Burst => net_gnd0,
      VFBC2_Wd_Flush => net_gnd0,
      VFBC2_Wd_Data => net_gnd32(0 to 31),
      VFBC2_Wd_Data_BE => net_gnd4(0 to 3),
      VFBC2_Wd_Full => open,
      VFBC2_Wd_Almost_Full => open,
      VFBC2_Rd_Clk => net_gnd0,
      VFBC2_Rd_Reset => net_gnd0,
      VFBC2_Rd_Read => net_gnd0,
      VFBC2_Rd_End_Burst => net_gnd0,
      VFBC2_Rd_Flush => net_gnd0,
      VFBC2_Rd_Data => open,
      VFBC2_Rd_Empty => open,
      VFBC2_Rd_Almost_Empty => open,
      FSL3_M_Clk => net_vcc0,
      FSL3_M_Write => net_gnd0,
      FSL3_M_Data => net_gnd32,
      FSL3_M_Control => net_gnd0,
      FSL3_M_Full => open,
      FSL3_S_Clk => net_gnd0,
      FSL3_S_Read => net_gnd0,
      FSL3_S_Data => open,
      FSL3_S_Control => open,
      FSL3_S_Exists => open,
      SPLB3_Clk => net_vcc0,
      SPLB3_Rst => net_gnd0,
      SPLB3_PLB_ABus => net_gnd32,
      SPLB3_PLB_PAValid => net_gnd0,
      SPLB3_PLB_SAValid => net_gnd0,
      SPLB3_PLB_masterID => net_gnd1(0 to 0),
      SPLB3_PLB_RNW => net_gnd0,
      SPLB3_PLB_BE => net_gnd8,
      SPLB3_PLB_UABus => net_gnd32,
      SPLB3_PLB_rdPrim => net_gnd0,
      SPLB3_PLB_wrPrim => net_gnd0,
      SPLB3_PLB_abort => net_gnd0,
      SPLB3_PLB_busLock => net_gnd0,
      SPLB3_PLB_MSize => net_gnd2,
      SPLB3_PLB_size => net_gnd4,
      SPLB3_PLB_type => net_gnd3,
      SPLB3_PLB_lockErr => net_gnd0,
      SPLB3_PLB_wrPendReq => net_gnd0,
      SPLB3_PLB_wrPendPri => net_gnd2,
      SPLB3_PLB_rdPendReq => net_gnd0,
      SPLB3_PLB_rdPendPri => net_gnd2,
      SPLB3_PLB_reqPri => net_gnd2,
      SPLB3_PLB_TAttribute => net_gnd16,
      SPLB3_PLB_rdBurst => net_gnd0,
      SPLB3_PLB_wrBurst => net_gnd0,
      SPLB3_PLB_wrDBus => net_gnd64,
      SPLB3_Sl_addrAck => open,
      SPLB3_Sl_SSize => open,
      SPLB3_Sl_wait => open,
      SPLB3_Sl_rearbitrate => open,
      SPLB3_Sl_wrDAck => open,
      SPLB3_Sl_wrComp => open,
      SPLB3_Sl_wrBTerm => open,
      SPLB3_Sl_rdDBus => open,
      SPLB3_Sl_rdWdAddr => open,
      SPLB3_Sl_rdDAck => open,
      SPLB3_Sl_rdComp => open,
      SPLB3_Sl_rdBTerm => open,
      SPLB3_Sl_MBusy => open,
      SPLB3_Sl_MRdErr => open,
      SPLB3_Sl_MWrErr => open,
      SPLB3_Sl_MIRQ => open,
      SDMA3_Clk => net_gnd0,
      SDMA3_Rx_IntOut => open,
      SDMA3_Tx_IntOut => open,
      SDMA3_RstOut => open,
      SDMA3_TX_D => open,
      SDMA3_TX_Rem => open,
      SDMA3_TX_SOF => open,
      SDMA3_TX_EOF => open,
      SDMA3_TX_SOP => open,
      SDMA3_TX_EOP => open,
      SDMA3_TX_Src_Rdy => open,
      SDMA3_TX_Dst_Rdy => net_vcc0,
      SDMA3_RX_D => net_gnd32,
      SDMA3_RX_Rem => net_vcc4,
      SDMA3_RX_SOF => net_vcc0,
      SDMA3_RX_EOF => net_vcc0,
      SDMA3_RX_SOP => net_vcc0,
      SDMA3_RX_EOP => net_vcc0,
      SDMA3_RX_Src_Rdy => net_vcc0,
      SDMA3_RX_Dst_Rdy => open,
      SDMA_CTRL3_Clk => net_vcc0,
      SDMA_CTRL3_Rst => net_gnd0,
      SDMA_CTRL3_PLB_ABus => net_gnd32,
      SDMA_CTRL3_PLB_PAValid => net_gnd0,
      SDMA_CTRL3_PLB_SAValid => net_gnd0,
      SDMA_CTRL3_PLB_masterID => net_gnd1(0 to 0),
      SDMA_CTRL3_PLB_RNW => net_gnd0,
      SDMA_CTRL3_PLB_BE => net_gnd8,
      SDMA_CTRL3_PLB_UABus => net_gnd32,
      SDMA_CTRL3_PLB_rdPrim => net_gnd0,
      SDMA_CTRL3_PLB_wrPrim => net_gnd0,
      SDMA_CTRL3_PLB_abort => net_gnd0,
      SDMA_CTRL3_PLB_busLock => net_gnd0,
      SDMA_CTRL3_PLB_MSize => net_gnd2,
      SDMA_CTRL3_PLB_size => net_gnd4,
      SDMA_CTRL3_PLB_type => net_gnd3,
      SDMA_CTRL3_PLB_lockErr => net_gnd0,
      SDMA_CTRL3_PLB_wrPendReq => net_gnd0,
      SDMA_CTRL3_PLB_wrPendPri => net_gnd2,
      SDMA_CTRL3_PLB_rdPendReq => net_gnd0,
      SDMA_CTRL3_PLB_rdPendPri => net_gnd2,
      SDMA_CTRL3_PLB_reqPri => net_gnd2,
      SDMA_CTRL3_PLB_TAttribute => net_gnd16,
      SDMA_CTRL3_PLB_rdBurst => net_gnd0,
      SDMA_CTRL3_PLB_wrBurst => net_gnd0,
      SDMA_CTRL3_PLB_wrDBus => net_gnd64,
      SDMA_CTRL3_Sl_addrAck => open,
      SDMA_CTRL3_Sl_SSize => open,
      SDMA_CTRL3_Sl_wait => open,
      SDMA_CTRL3_Sl_rearbitrate => open,
      SDMA_CTRL3_Sl_wrDAck => open,
      SDMA_CTRL3_Sl_wrComp => open,
      SDMA_CTRL3_Sl_wrBTerm => open,
      SDMA_CTRL3_Sl_rdDBus => open,
      SDMA_CTRL3_Sl_rdWdAddr => open,
      SDMA_CTRL3_Sl_rdDAck => open,
      SDMA_CTRL3_Sl_rdComp => open,
      SDMA_CTRL3_Sl_rdBTerm => open,
      SDMA_CTRL3_Sl_MBusy => open,
      SDMA_CTRL3_Sl_MRdErr => open,
      SDMA_CTRL3_Sl_MWrErr => open,
      SDMA_CTRL3_Sl_MIRQ => open,
      PIM3_Addr => net_gnd32(0 to 31),
      PIM3_AddrReq => net_gnd0,
      PIM3_AddrAck => open,
      PIM3_RNW => net_gnd0,
      PIM3_Size => net_gnd4(0 to 3),
      PIM3_RdModWr => net_gnd0,
      PIM3_WrFIFO_Data => net_gnd64(0 to 63),
      PIM3_WrFIFO_BE => net_gnd8(0 to 7),
      PIM3_WrFIFO_Push => net_gnd0,
      PIM3_RdFIFO_Data => open,
      PIM3_RdFIFO_Pop => net_gnd0,
      PIM3_RdFIFO_RdWdAddr => open,
      PIM3_WrFIFO_Empty => open,
      PIM3_WrFIFO_AlmostFull => open,
      PIM3_WrFIFO_Flush => net_gnd0,
      PIM3_RdFIFO_Empty => open,
      PIM3_RdFIFO_Flush => net_gnd0,
      PIM3_RdFIFO_Latency => open,
      PIM3_InitDone => open,
      PPC440MC3_MIMCReadNotWrite => net_gnd0,
      PPC440MC3_MIMCAddress => net_gnd36,
      PPC440MC3_MIMCAddressValid => net_gnd0,
      PPC440MC3_MIMCWriteData => net_gnd128,
      PPC440MC3_MIMCWriteDataValid => net_gnd0,
      PPC440MC3_MIMCByteEnable => net_gnd16,
      PPC440MC3_MIMCBankConflict => net_gnd0,
      PPC440MC3_MIMCRowConflict => net_gnd0,
      PPC440MC3_MCMIReadData => open,
      PPC440MC3_MCMIReadDataValid => open,
      PPC440MC3_MCMIReadDataErr => open,
      PPC440MC3_MCMIAddrReadyToAccept => open,
      VFBC3_Cmd_Clk => net_gnd0,
      VFBC3_Cmd_Reset => net_gnd0,
      VFBC3_Cmd_Data => net_gnd32(0 to 31),
      VFBC3_Cmd_Write => net_gnd0,
      VFBC3_Cmd_End => net_gnd0,
      VFBC3_Cmd_Full => open,
      VFBC3_Cmd_Almost_Full => open,
      VFBC3_Cmd_Idle => open,
      VFBC3_Wd_Clk => net_gnd0,
      VFBC3_Wd_Reset => net_gnd0,
      VFBC3_Wd_Write => net_gnd0,
      VFBC3_Wd_End_Burst => net_gnd0,
      VFBC3_Wd_Flush => net_gnd0,
      VFBC3_Wd_Data => net_gnd32(0 to 31),
      VFBC3_Wd_Data_BE => net_gnd4(0 to 3),
      VFBC3_Wd_Full => open,
      VFBC3_Wd_Almost_Full => open,
      VFBC3_Rd_Clk => net_gnd0,
      VFBC3_Rd_Reset => net_gnd0,
      VFBC3_Rd_Read => net_gnd0,
      VFBC3_Rd_End_Burst => net_gnd0,
      VFBC3_Rd_Flush => net_gnd0,
      VFBC3_Rd_Data => open,
      VFBC3_Rd_Empty => open,
      VFBC3_Rd_Almost_Empty => open,
      FSL4_M_Clk => net_vcc0,
      FSL4_M_Write => net_gnd0,
      FSL4_M_Data => net_gnd32,
      FSL4_M_Control => net_gnd0,
      FSL4_M_Full => open,
      FSL4_S_Clk => net_gnd0,
      FSL4_S_Read => net_gnd0,
      FSL4_S_Data => open,
      FSL4_S_Control => open,
      FSL4_S_Exists => open,
      SPLB4_Clk => net_vcc0,
      SPLB4_Rst => net_gnd0,
      SPLB4_PLB_ABus => net_gnd32,
      SPLB4_PLB_PAValid => net_gnd0,
      SPLB4_PLB_SAValid => net_gnd0,
      SPLB4_PLB_masterID => net_gnd1(0 to 0),
      SPLB4_PLB_RNW => net_gnd0,
      SPLB4_PLB_BE => net_gnd8,
      SPLB4_PLB_UABus => net_gnd32,
      SPLB4_PLB_rdPrim => net_gnd0,
      SPLB4_PLB_wrPrim => net_gnd0,
      SPLB4_PLB_abort => net_gnd0,
      SPLB4_PLB_busLock => net_gnd0,
      SPLB4_PLB_MSize => net_gnd2,
      SPLB4_PLB_size => net_gnd4,
      SPLB4_PLB_type => net_gnd3,
      SPLB4_PLB_lockErr => net_gnd0,
      SPLB4_PLB_wrPendReq => net_gnd0,
      SPLB4_PLB_wrPendPri => net_gnd2,
      SPLB4_PLB_rdPendReq => net_gnd0,
      SPLB4_PLB_rdPendPri => net_gnd2,
      SPLB4_PLB_reqPri => net_gnd2,
      SPLB4_PLB_TAttribute => net_gnd16,
      SPLB4_PLB_rdBurst => net_gnd0,
      SPLB4_PLB_wrBurst => net_gnd0,
      SPLB4_PLB_wrDBus => net_gnd64,
      SPLB4_Sl_addrAck => open,
      SPLB4_Sl_SSize => open,
      SPLB4_Sl_wait => open,
      SPLB4_Sl_rearbitrate => open,
      SPLB4_Sl_wrDAck => open,
      SPLB4_Sl_wrComp => open,
      SPLB4_Sl_wrBTerm => open,
      SPLB4_Sl_rdDBus => open,
      SPLB4_Sl_rdWdAddr => open,
      SPLB4_Sl_rdDAck => open,
      SPLB4_Sl_rdComp => open,
      SPLB4_Sl_rdBTerm => open,
      SPLB4_Sl_MBusy => open,
      SPLB4_Sl_MRdErr => open,
      SPLB4_Sl_MWrErr => open,
      SPLB4_Sl_MIRQ => open,
      SDMA4_Clk => net_gnd0,
      SDMA4_Rx_IntOut => open,
      SDMA4_Tx_IntOut => open,
      SDMA4_RstOut => open,
      SDMA4_TX_D => open,
      SDMA4_TX_Rem => open,
      SDMA4_TX_SOF => open,
      SDMA4_TX_EOF => open,
      SDMA4_TX_SOP => open,
      SDMA4_TX_EOP => open,
      SDMA4_TX_Src_Rdy => open,
      SDMA4_TX_Dst_Rdy => net_vcc0,
      SDMA4_RX_D => net_gnd32,
      SDMA4_RX_Rem => net_vcc4,
      SDMA4_RX_SOF => net_vcc0,
      SDMA4_RX_EOF => net_vcc0,
      SDMA4_RX_SOP => net_vcc0,
      SDMA4_RX_EOP => net_vcc0,
      SDMA4_RX_Src_Rdy => net_vcc0,
      SDMA4_RX_Dst_Rdy => open,
      SDMA_CTRL4_Clk => net_vcc0,
      SDMA_CTRL4_Rst => net_gnd0,
      SDMA_CTRL4_PLB_ABus => net_gnd32,
      SDMA_CTRL4_PLB_PAValid => net_gnd0,
      SDMA_CTRL4_PLB_SAValid => net_gnd0,
      SDMA_CTRL4_PLB_masterID => net_gnd1(0 to 0),
      SDMA_CTRL4_PLB_RNW => net_gnd0,
      SDMA_CTRL4_PLB_BE => net_gnd8,
      SDMA_CTRL4_PLB_UABus => net_gnd32,
      SDMA_CTRL4_PLB_rdPrim => net_gnd0,
      SDMA_CTRL4_PLB_wrPrim => net_gnd0,
      SDMA_CTRL4_PLB_abort => net_gnd0,
      SDMA_CTRL4_PLB_busLock => net_gnd0,
      SDMA_CTRL4_PLB_MSize => net_gnd2,
      SDMA_CTRL4_PLB_size => net_gnd4,
      SDMA_CTRL4_PLB_type => net_gnd3,
      SDMA_CTRL4_PLB_lockErr => net_gnd0,
      SDMA_CTRL4_PLB_wrPendReq => net_gnd0,
      SDMA_CTRL4_PLB_wrPendPri => net_gnd2,
      SDMA_CTRL4_PLB_rdPendReq => net_gnd0,
      SDMA_CTRL4_PLB_rdPendPri => net_gnd2,
      SDMA_CTRL4_PLB_reqPri => net_gnd2,
      SDMA_CTRL4_PLB_TAttribute => net_gnd16,
      SDMA_CTRL4_PLB_rdBurst => net_gnd0,
      SDMA_CTRL4_PLB_wrBurst => net_gnd0,
      SDMA_CTRL4_PLB_wrDBus => net_gnd64,
      SDMA_CTRL4_Sl_addrAck => open,
      SDMA_CTRL4_Sl_SSize => open,
      SDMA_CTRL4_Sl_wait => open,
      SDMA_CTRL4_Sl_rearbitrate => open,
      SDMA_CTRL4_Sl_wrDAck => open,
      SDMA_CTRL4_Sl_wrComp => open,
      SDMA_CTRL4_Sl_wrBTerm => open,
      SDMA_CTRL4_Sl_rdDBus => open,
      SDMA_CTRL4_Sl_rdWdAddr => open,
      SDMA_CTRL4_Sl_rdDAck => open,
      SDMA_CTRL4_Sl_rdComp => open,
      SDMA_CTRL4_Sl_rdBTerm => open,
      SDMA_CTRL4_Sl_MBusy => open,
      SDMA_CTRL4_Sl_MRdErr => open,
      SDMA_CTRL4_Sl_MWrErr => open,
      SDMA_CTRL4_Sl_MIRQ => open,
      PIM4_Addr => net_gnd32(0 to 31),
      PIM4_AddrReq => net_gnd0,
      PIM4_AddrAck => open,
      PIM4_RNW => net_gnd0,
      PIM4_Size => net_gnd4(0 to 3),
      PIM4_RdModWr => net_gnd0,
      PIM4_WrFIFO_Data => net_gnd64(0 to 63),
      PIM4_WrFIFO_BE => net_gnd8(0 to 7),
      PIM4_WrFIFO_Push => net_gnd0,
      PIM4_RdFIFO_Data => open,
      PIM4_RdFIFO_Pop => net_gnd0,
      PIM4_RdFIFO_RdWdAddr => open,
      PIM4_WrFIFO_Empty => open,
      PIM4_WrFIFO_AlmostFull => open,
      PIM4_WrFIFO_Flush => net_gnd0,
      PIM4_RdFIFO_Empty => open,
      PIM4_RdFIFO_Flush => net_gnd0,
      PIM4_RdFIFO_Latency => open,
      PIM4_InitDone => open,
      PPC440MC4_MIMCReadNotWrite => net_gnd0,
      PPC440MC4_MIMCAddress => net_gnd36,
      PPC440MC4_MIMCAddressValid => net_gnd0,
      PPC440MC4_MIMCWriteData => net_gnd128,
      PPC440MC4_MIMCWriteDataValid => net_gnd0,
      PPC440MC4_MIMCByteEnable => net_gnd16,
      PPC440MC4_MIMCBankConflict => net_gnd0,
      PPC440MC4_MIMCRowConflict => net_gnd0,
      PPC440MC4_MCMIReadData => open,
      PPC440MC4_MCMIReadDataValid => open,
      PPC440MC4_MCMIReadDataErr => open,
      PPC440MC4_MCMIAddrReadyToAccept => open,
      VFBC4_Cmd_Clk => net_gnd0,
      VFBC4_Cmd_Reset => net_gnd0,
      VFBC4_Cmd_Data => net_gnd32(0 to 31),
      VFBC4_Cmd_Write => net_gnd0,
      VFBC4_Cmd_End => net_gnd0,
      VFBC4_Cmd_Full => open,
      VFBC4_Cmd_Almost_Full => open,
      VFBC4_Cmd_Idle => open,
      VFBC4_Wd_Clk => net_gnd0,
      VFBC4_Wd_Reset => net_gnd0,
      VFBC4_Wd_Write => net_gnd0,
      VFBC4_Wd_End_Burst => net_gnd0,
      VFBC4_Wd_Flush => net_gnd0,
      VFBC4_Wd_Data => net_gnd32(0 to 31),
      VFBC4_Wd_Data_BE => net_gnd4(0 to 3),
      VFBC4_Wd_Full => open,
      VFBC4_Wd_Almost_Full => open,
      VFBC4_Rd_Clk => net_gnd0,
      VFBC4_Rd_Reset => net_gnd0,
      VFBC4_Rd_Read => net_gnd0,
      VFBC4_Rd_End_Burst => net_gnd0,
      VFBC4_Rd_Flush => net_gnd0,
      VFBC4_Rd_Data => open,
      VFBC4_Rd_Empty => open,
      VFBC4_Rd_Almost_Empty => open,
      FSL5_M_Clk => net_vcc0,
      FSL5_M_Write => net_gnd0,
      FSL5_M_Data => net_gnd32,
      FSL5_M_Control => net_gnd0,
      FSL5_M_Full => open,
      FSL5_S_Clk => net_gnd0,
      FSL5_S_Read => net_gnd0,
      FSL5_S_Data => open,
      FSL5_S_Control => open,
      FSL5_S_Exists => open,
      SPLB5_Clk => net_vcc0,
      SPLB5_Rst => net_gnd0,
      SPLB5_PLB_ABus => net_gnd32,
      SPLB5_PLB_PAValid => net_gnd0,
      SPLB5_PLB_SAValid => net_gnd0,
      SPLB5_PLB_masterID => net_gnd1(0 to 0),
      SPLB5_PLB_RNW => net_gnd0,
      SPLB5_PLB_BE => net_gnd8,
      SPLB5_PLB_UABus => net_gnd32,
      SPLB5_PLB_rdPrim => net_gnd0,
      SPLB5_PLB_wrPrim => net_gnd0,
      SPLB5_PLB_abort => net_gnd0,
      SPLB5_PLB_busLock => net_gnd0,
      SPLB5_PLB_MSize => net_gnd2,
      SPLB5_PLB_size => net_gnd4,
      SPLB5_PLB_type => net_gnd3,
      SPLB5_PLB_lockErr => net_gnd0,
      SPLB5_PLB_wrPendReq => net_gnd0,
      SPLB5_PLB_wrPendPri => net_gnd2,
      SPLB5_PLB_rdPendReq => net_gnd0,
      SPLB5_PLB_rdPendPri => net_gnd2,
      SPLB5_PLB_reqPri => net_gnd2,
      SPLB5_PLB_TAttribute => net_gnd16,
      SPLB5_PLB_rdBurst => net_gnd0,
      SPLB5_PLB_wrBurst => net_gnd0,
      SPLB5_PLB_wrDBus => net_gnd64,
      SPLB5_Sl_addrAck => open,
      SPLB5_Sl_SSize => open,
      SPLB5_Sl_wait => open,
      SPLB5_Sl_rearbitrate => open,
      SPLB5_Sl_wrDAck => open,
      SPLB5_Sl_wrComp => open,
      SPLB5_Sl_wrBTerm => open,
      SPLB5_Sl_rdDBus => open,
      SPLB5_Sl_rdWdAddr => open,
      SPLB5_Sl_rdDAck => open,
      SPLB5_Sl_rdComp => open,
      SPLB5_Sl_rdBTerm => open,
      SPLB5_Sl_MBusy => open,
      SPLB5_Sl_MRdErr => open,
      SPLB5_Sl_MWrErr => open,
      SPLB5_Sl_MIRQ => open,
      SDMA5_Clk => net_gnd0,
      SDMA5_Rx_IntOut => open,
      SDMA5_Tx_IntOut => open,
      SDMA5_RstOut => open,
      SDMA5_TX_D => open,
      SDMA5_TX_Rem => open,
      SDMA5_TX_SOF => open,
      SDMA5_TX_EOF => open,
      SDMA5_TX_SOP => open,
      SDMA5_TX_EOP => open,
      SDMA5_TX_Src_Rdy => open,
      SDMA5_TX_Dst_Rdy => net_vcc0,
      SDMA5_RX_D => net_gnd32,
      SDMA5_RX_Rem => net_vcc4,
      SDMA5_RX_SOF => net_vcc0,
      SDMA5_RX_EOF => net_vcc0,
      SDMA5_RX_SOP => net_vcc0,
      SDMA5_RX_EOP => net_vcc0,
      SDMA5_RX_Src_Rdy => net_vcc0,
      SDMA5_RX_Dst_Rdy => open,
      SDMA_CTRL5_Clk => net_vcc0,
      SDMA_CTRL5_Rst => net_gnd0,
      SDMA_CTRL5_PLB_ABus => net_gnd32,
      SDMA_CTRL5_PLB_PAValid => net_gnd0,
      SDMA_CTRL5_PLB_SAValid => net_gnd0,
      SDMA_CTRL5_PLB_masterID => net_gnd1(0 to 0),
      SDMA_CTRL5_PLB_RNW => net_gnd0,
      SDMA_CTRL5_PLB_BE => net_gnd8,
      SDMA_CTRL5_PLB_UABus => net_gnd32,
      SDMA_CTRL5_PLB_rdPrim => net_gnd0,
      SDMA_CTRL5_PLB_wrPrim => net_gnd0,
      SDMA_CTRL5_PLB_abort => net_gnd0,
      SDMA_CTRL5_PLB_busLock => net_gnd0,
      SDMA_CTRL5_PLB_MSize => net_gnd2,
      SDMA_CTRL5_PLB_size => net_gnd4,
      SDMA_CTRL5_PLB_type => net_gnd3,
      SDMA_CTRL5_PLB_lockErr => net_gnd0,
      SDMA_CTRL5_PLB_wrPendReq => net_gnd0,
      SDMA_CTRL5_PLB_wrPendPri => net_gnd2,
      SDMA_CTRL5_PLB_rdPendReq => net_gnd0,
      SDMA_CTRL5_PLB_rdPendPri => net_gnd2,
      SDMA_CTRL5_PLB_reqPri => net_gnd2,
      SDMA_CTRL5_PLB_TAttribute => net_gnd16,
      SDMA_CTRL5_PLB_rdBurst => net_gnd0,
      SDMA_CTRL5_PLB_wrBurst => net_gnd0,
      SDMA_CTRL5_PLB_wrDBus => net_gnd64,
      SDMA_CTRL5_Sl_addrAck => open,
      SDMA_CTRL5_Sl_SSize => open,
      SDMA_CTRL5_Sl_wait => open,
      SDMA_CTRL5_Sl_rearbitrate => open,
      SDMA_CTRL5_Sl_wrDAck => open,
      SDMA_CTRL5_Sl_wrComp => open,
      SDMA_CTRL5_Sl_wrBTerm => open,
      SDMA_CTRL5_Sl_rdDBus => open,
      SDMA_CTRL5_Sl_rdWdAddr => open,
      SDMA_CTRL5_Sl_rdDAck => open,
      SDMA_CTRL5_Sl_rdComp => open,
      SDMA_CTRL5_Sl_rdBTerm => open,
      SDMA_CTRL5_Sl_MBusy => open,
      SDMA_CTRL5_Sl_MRdErr => open,
      SDMA_CTRL5_Sl_MWrErr => open,
      SDMA_CTRL5_Sl_MIRQ => open,
      PIM5_Addr => net_gnd32(0 to 31),
      PIM5_AddrReq => net_gnd0,
      PIM5_AddrAck => open,
      PIM5_RNW => net_gnd0,
      PIM5_Size => net_gnd4(0 to 3),
      PIM5_RdModWr => net_gnd0,
      PIM5_WrFIFO_Data => net_gnd64(0 to 63),
      PIM5_WrFIFO_BE => net_gnd8(0 to 7),
      PIM5_WrFIFO_Push => net_gnd0,
      PIM5_RdFIFO_Data => open,
      PIM5_RdFIFO_Pop => net_gnd0,
      PIM5_RdFIFO_RdWdAddr => open,
      PIM5_WrFIFO_Empty => open,
      PIM5_WrFIFO_AlmostFull => open,
      PIM5_WrFIFO_Flush => net_gnd0,
      PIM5_RdFIFO_Empty => open,
      PIM5_RdFIFO_Flush => net_gnd0,
      PIM5_RdFIFO_Latency => open,
      PIM5_InitDone => open,
      PPC440MC5_MIMCReadNotWrite => net_gnd0,
      PPC440MC5_MIMCAddress => net_gnd36,
      PPC440MC5_MIMCAddressValid => net_gnd0,
      PPC440MC5_MIMCWriteData => net_gnd128,
      PPC440MC5_MIMCWriteDataValid => net_gnd0,
      PPC440MC5_MIMCByteEnable => net_gnd16,
      PPC440MC5_MIMCBankConflict => net_gnd0,
      PPC440MC5_MIMCRowConflict => net_gnd0,
      PPC440MC5_MCMIReadData => open,
      PPC440MC5_MCMIReadDataValid => open,
      PPC440MC5_MCMIReadDataErr => open,
      PPC440MC5_MCMIAddrReadyToAccept => open,
      VFBC5_Cmd_Clk => net_gnd0,
      VFBC5_Cmd_Reset => net_gnd0,
      VFBC5_Cmd_Data => net_gnd32(0 to 31),
      VFBC5_Cmd_Write => net_gnd0,
      VFBC5_Cmd_End => net_gnd0,
      VFBC5_Cmd_Full => open,
      VFBC5_Cmd_Almost_Full => open,
      VFBC5_Cmd_Idle => open,
      VFBC5_Wd_Clk => net_gnd0,
      VFBC5_Wd_Reset => net_gnd0,
      VFBC5_Wd_Write => net_gnd0,
      VFBC5_Wd_End_Burst => net_gnd0,
      VFBC5_Wd_Flush => net_gnd0,
      VFBC5_Wd_Data => net_gnd32(0 to 31),
      VFBC5_Wd_Data_BE => net_gnd4(0 to 3),
      VFBC5_Wd_Full => open,
      VFBC5_Wd_Almost_Full => open,
      VFBC5_Rd_Clk => net_gnd0,
      VFBC5_Rd_Reset => net_gnd0,
      VFBC5_Rd_Read => net_gnd0,
      VFBC5_Rd_End_Burst => net_gnd0,
      VFBC5_Rd_Flush => net_gnd0,
      VFBC5_Rd_Data => open,
      VFBC5_Rd_Empty => open,
      VFBC5_Rd_Almost_Empty => open,
      FSL6_M_Clk => net_vcc0,
      FSL6_M_Write => net_gnd0,
      FSL6_M_Data => net_gnd32,
      FSL6_M_Control => net_gnd0,
      FSL6_M_Full => open,
      FSL6_S_Clk => net_gnd0,
      FSL6_S_Read => net_gnd0,
      FSL6_S_Data => open,
      FSL6_S_Control => open,
      FSL6_S_Exists => open,
      SPLB6_Clk => net_vcc0,
      SPLB6_Rst => net_gnd0,
      SPLB6_PLB_ABus => net_gnd32,
      SPLB6_PLB_PAValid => net_gnd0,
      SPLB6_PLB_SAValid => net_gnd0,
      SPLB6_PLB_masterID => net_gnd1(0 to 0),
      SPLB6_PLB_RNW => net_gnd0,
      SPLB6_PLB_BE => net_gnd8,
      SPLB6_PLB_UABus => net_gnd32,
      SPLB6_PLB_rdPrim => net_gnd0,
      SPLB6_PLB_wrPrim => net_gnd0,
      SPLB6_PLB_abort => net_gnd0,
      SPLB6_PLB_busLock => net_gnd0,
      SPLB6_PLB_MSize => net_gnd2,
      SPLB6_PLB_size => net_gnd4,
      SPLB6_PLB_type => net_gnd3,
      SPLB6_PLB_lockErr => net_gnd0,
      SPLB6_PLB_wrPendReq => net_gnd0,
      SPLB6_PLB_wrPendPri => net_gnd2,
      SPLB6_PLB_rdPendReq => net_gnd0,
      SPLB6_PLB_rdPendPri => net_gnd2,
      SPLB6_PLB_reqPri => net_gnd2,
      SPLB6_PLB_TAttribute => net_gnd16,
      SPLB6_PLB_rdBurst => net_gnd0,
      SPLB6_PLB_wrBurst => net_gnd0,
      SPLB6_PLB_wrDBus => net_gnd64,
      SPLB6_Sl_addrAck => open,
      SPLB6_Sl_SSize => open,
      SPLB6_Sl_wait => open,
      SPLB6_Sl_rearbitrate => open,
      SPLB6_Sl_wrDAck => open,
      SPLB6_Sl_wrComp => open,
      SPLB6_Sl_wrBTerm => open,
      SPLB6_Sl_rdDBus => open,
      SPLB6_Sl_rdWdAddr => open,
      SPLB6_Sl_rdDAck => open,
      SPLB6_Sl_rdComp => open,
      SPLB6_Sl_rdBTerm => open,
      SPLB6_Sl_MBusy => open,
      SPLB6_Sl_MRdErr => open,
      SPLB6_Sl_MWrErr => open,
      SPLB6_Sl_MIRQ => open,
      SDMA6_Clk => net_gnd0,
      SDMA6_Rx_IntOut => open,
      SDMA6_Tx_IntOut => open,
      SDMA6_RstOut => open,
      SDMA6_TX_D => open,
      SDMA6_TX_Rem => open,
      SDMA6_TX_SOF => open,
      SDMA6_TX_EOF => open,
      SDMA6_TX_SOP => open,
      SDMA6_TX_EOP => open,
      SDMA6_TX_Src_Rdy => open,
      SDMA6_TX_Dst_Rdy => net_vcc0,
      SDMA6_RX_D => net_gnd32,
      SDMA6_RX_Rem => net_vcc4,
      SDMA6_RX_SOF => net_vcc0,
      SDMA6_RX_EOF => net_vcc0,
      SDMA6_RX_SOP => net_vcc0,
      SDMA6_RX_EOP => net_vcc0,
      SDMA6_RX_Src_Rdy => net_vcc0,
      SDMA6_RX_Dst_Rdy => open,
      SDMA_CTRL6_Clk => net_vcc0,
      SDMA_CTRL6_Rst => net_gnd0,
      SDMA_CTRL6_PLB_ABus => net_gnd32,
      SDMA_CTRL6_PLB_PAValid => net_gnd0,
      SDMA_CTRL6_PLB_SAValid => net_gnd0,
      SDMA_CTRL6_PLB_masterID => net_gnd1(0 to 0),
      SDMA_CTRL6_PLB_RNW => net_gnd0,
      SDMA_CTRL6_PLB_BE => net_gnd8,
      SDMA_CTRL6_PLB_UABus => net_gnd32,
      SDMA_CTRL6_PLB_rdPrim => net_gnd0,
      SDMA_CTRL6_PLB_wrPrim => net_gnd0,
      SDMA_CTRL6_PLB_abort => net_gnd0,
      SDMA_CTRL6_PLB_busLock => net_gnd0,
      SDMA_CTRL6_PLB_MSize => net_gnd2,
      SDMA_CTRL6_PLB_size => net_gnd4,
      SDMA_CTRL6_PLB_type => net_gnd3,
      SDMA_CTRL6_PLB_lockErr => net_gnd0,
      SDMA_CTRL6_PLB_wrPendReq => net_gnd0,
      SDMA_CTRL6_PLB_wrPendPri => net_gnd2,
      SDMA_CTRL6_PLB_rdPendReq => net_gnd0,
      SDMA_CTRL6_PLB_rdPendPri => net_gnd2,
      SDMA_CTRL6_PLB_reqPri => net_gnd2,
      SDMA_CTRL6_PLB_TAttribute => net_gnd16,
      SDMA_CTRL6_PLB_rdBurst => net_gnd0,
      SDMA_CTRL6_PLB_wrBurst => net_gnd0,
      SDMA_CTRL6_PLB_wrDBus => net_gnd64,
      SDMA_CTRL6_Sl_addrAck => open,
      SDMA_CTRL6_Sl_SSize => open,
      SDMA_CTRL6_Sl_wait => open,
      SDMA_CTRL6_Sl_rearbitrate => open,
      SDMA_CTRL6_Sl_wrDAck => open,
      SDMA_CTRL6_Sl_wrComp => open,
      SDMA_CTRL6_Sl_wrBTerm => open,
      SDMA_CTRL6_Sl_rdDBus => open,
      SDMA_CTRL6_Sl_rdWdAddr => open,
      SDMA_CTRL6_Sl_rdDAck => open,
      SDMA_CTRL6_Sl_rdComp => open,
      SDMA_CTRL6_Sl_rdBTerm => open,
      SDMA_CTRL6_Sl_MBusy => open,
      SDMA_CTRL6_Sl_MRdErr => open,
      SDMA_CTRL6_Sl_MWrErr => open,
      SDMA_CTRL6_Sl_MIRQ => open,
      PIM6_Addr => net_gnd32(0 to 31),
      PIM6_AddrReq => net_gnd0,
      PIM6_AddrAck => open,
      PIM6_RNW => net_gnd0,
      PIM6_Size => net_gnd4(0 to 3),
      PIM6_RdModWr => net_gnd0,
      PIM6_WrFIFO_Data => net_gnd64(0 to 63),
      PIM6_WrFIFO_BE => net_gnd8(0 to 7),
      PIM6_WrFIFO_Push => net_gnd0,
      PIM6_RdFIFO_Data => open,
      PIM6_RdFIFO_Pop => net_gnd0,
      PIM6_RdFIFO_RdWdAddr => open,
      PIM6_WrFIFO_Empty => open,
      PIM6_WrFIFO_AlmostFull => open,
      PIM6_WrFIFO_Flush => net_gnd0,
      PIM6_RdFIFO_Empty => open,
      PIM6_RdFIFO_Flush => net_gnd0,
      PIM6_RdFIFO_Latency => open,
      PIM6_InitDone => open,
      PPC440MC6_MIMCReadNotWrite => net_gnd0,
      PPC440MC6_MIMCAddress => net_gnd36,
      PPC440MC6_MIMCAddressValid => net_gnd0,
      PPC440MC6_MIMCWriteData => net_gnd128,
      PPC440MC6_MIMCWriteDataValid => net_gnd0,
      PPC440MC6_MIMCByteEnable => net_gnd16,
      PPC440MC6_MIMCBankConflict => net_gnd0,
      PPC440MC6_MIMCRowConflict => net_gnd0,
      PPC440MC6_MCMIReadData => open,
      PPC440MC6_MCMIReadDataValid => open,
      PPC440MC6_MCMIReadDataErr => open,
      PPC440MC6_MCMIAddrReadyToAccept => open,
      VFBC6_Cmd_Clk => net_gnd0,
      VFBC6_Cmd_Reset => net_gnd0,
      VFBC6_Cmd_Data => net_gnd32(0 to 31),
      VFBC6_Cmd_Write => net_gnd0,
      VFBC6_Cmd_End => net_gnd0,
      VFBC6_Cmd_Full => open,
      VFBC6_Cmd_Almost_Full => open,
      VFBC6_Cmd_Idle => open,
      VFBC6_Wd_Clk => net_gnd0,
      VFBC6_Wd_Reset => net_gnd0,
      VFBC6_Wd_Write => net_gnd0,
      VFBC6_Wd_End_Burst => net_gnd0,
      VFBC6_Wd_Flush => net_gnd0,
      VFBC6_Wd_Data => net_gnd32(0 to 31),
      VFBC6_Wd_Data_BE => net_gnd4(0 to 3),
      VFBC6_Wd_Full => open,
      VFBC6_Wd_Almost_Full => open,
      VFBC6_Rd_Clk => net_gnd0,
      VFBC6_Rd_Reset => net_gnd0,
      VFBC6_Rd_Read => net_gnd0,
      VFBC6_Rd_End_Burst => net_gnd0,
      VFBC6_Rd_Flush => net_gnd0,
      VFBC6_Rd_Data => open,
      VFBC6_Rd_Empty => open,
      VFBC6_Rd_Almost_Empty => open,
      FSL7_M_Clk => net_vcc0,
      FSL7_M_Write => net_gnd0,
      FSL7_M_Data => net_gnd32,
      FSL7_M_Control => net_gnd0,
      FSL7_M_Full => open,
      FSL7_S_Clk => net_gnd0,
      FSL7_S_Read => net_gnd0,
      FSL7_S_Data => open,
      FSL7_S_Control => open,
      FSL7_S_Exists => open,
      SPLB7_Clk => net_vcc0,
      SPLB7_Rst => net_gnd0,
      SPLB7_PLB_ABus => net_gnd32,
      SPLB7_PLB_PAValid => net_gnd0,
      SPLB7_PLB_SAValid => net_gnd0,
      SPLB7_PLB_masterID => net_gnd1(0 to 0),
      SPLB7_PLB_RNW => net_gnd0,
      SPLB7_PLB_BE => net_gnd8,
      SPLB7_PLB_UABus => net_gnd32,
      SPLB7_PLB_rdPrim => net_gnd0,
      SPLB7_PLB_wrPrim => net_gnd0,
      SPLB7_PLB_abort => net_gnd0,
      SPLB7_PLB_busLock => net_gnd0,
      SPLB7_PLB_MSize => net_gnd2,
      SPLB7_PLB_size => net_gnd4,
      SPLB7_PLB_type => net_gnd3,
      SPLB7_PLB_lockErr => net_gnd0,
      SPLB7_PLB_wrPendReq => net_gnd0,
      SPLB7_PLB_wrPendPri => net_gnd2,
      SPLB7_PLB_rdPendReq => net_gnd0,
      SPLB7_PLB_rdPendPri => net_gnd2,
      SPLB7_PLB_reqPri => net_gnd2,
      SPLB7_PLB_TAttribute => net_gnd16,
      SPLB7_PLB_rdBurst => net_gnd0,
      SPLB7_PLB_wrBurst => net_gnd0,
      SPLB7_PLB_wrDBus => net_gnd64,
      SPLB7_Sl_addrAck => open,
      SPLB7_Sl_SSize => open,
      SPLB7_Sl_wait => open,
      SPLB7_Sl_rearbitrate => open,
      SPLB7_Sl_wrDAck => open,
      SPLB7_Sl_wrComp => open,
      SPLB7_Sl_wrBTerm => open,
      SPLB7_Sl_rdDBus => open,
      SPLB7_Sl_rdWdAddr => open,
      SPLB7_Sl_rdDAck => open,
      SPLB7_Sl_rdComp => open,
      SPLB7_Sl_rdBTerm => open,
      SPLB7_Sl_MBusy => open,
      SPLB7_Sl_MRdErr => open,
      SPLB7_Sl_MWrErr => open,
      SPLB7_Sl_MIRQ => open,
      SDMA7_Clk => net_gnd0,
      SDMA7_Rx_IntOut => open,
      SDMA7_Tx_IntOut => open,
      SDMA7_RstOut => open,
      SDMA7_TX_D => open,
      SDMA7_TX_Rem => open,
      SDMA7_TX_SOF => open,
      SDMA7_TX_EOF => open,
      SDMA7_TX_SOP => open,
      SDMA7_TX_EOP => open,
      SDMA7_TX_Src_Rdy => open,
      SDMA7_TX_Dst_Rdy => net_vcc0,
      SDMA7_RX_D => net_gnd32,
      SDMA7_RX_Rem => net_vcc4,
      SDMA7_RX_SOF => net_vcc0,
      SDMA7_RX_EOF => net_vcc0,
      SDMA7_RX_SOP => net_vcc0,
      SDMA7_RX_EOP => net_vcc0,
      SDMA7_RX_Src_Rdy => net_vcc0,
      SDMA7_RX_Dst_Rdy => open,
      SDMA_CTRL7_Clk => net_vcc0,
      SDMA_CTRL7_Rst => net_gnd0,
      SDMA_CTRL7_PLB_ABus => net_gnd32,
      SDMA_CTRL7_PLB_PAValid => net_gnd0,
      SDMA_CTRL7_PLB_SAValid => net_gnd0,
      SDMA_CTRL7_PLB_masterID => net_gnd1(0 to 0),
      SDMA_CTRL7_PLB_RNW => net_gnd0,
      SDMA_CTRL7_PLB_BE => net_gnd8,
      SDMA_CTRL7_PLB_UABus => net_gnd32,
      SDMA_CTRL7_PLB_rdPrim => net_gnd0,
      SDMA_CTRL7_PLB_wrPrim => net_gnd0,
      SDMA_CTRL7_PLB_abort => net_gnd0,
      SDMA_CTRL7_PLB_busLock => net_gnd0,
      SDMA_CTRL7_PLB_MSize => net_gnd2,
      SDMA_CTRL7_PLB_size => net_gnd4,
      SDMA_CTRL7_PLB_type => net_gnd3,
      SDMA_CTRL7_PLB_lockErr => net_gnd0,
      SDMA_CTRL7_PLB_wrPendReq => net_gnd0,
      SDMA_CTRL7_PLB_wrPendPri => net_gnd2,
      SDMA_CTRL7_PLB_rdPendReq => net_gnd0,
      SDMA_CTRL7_PLB_rdPendPri => net_gnd2,
      SDMA_CTRL7_PLB_reqPri => net_gnd2,
      SDMA_CTRL7_PLB_TAttribute => net_gnd16,
      SDMA_CTRL7_PLB_rdBurst => net_gnd0,
      SDMA_CTRL7_PLB_wrBurst => net_gnd0,
      SDMA_CTRL7_PLB_wrDBus => net_gnd64,
      SDMA_CTRL7_Sl_addrAck => open,
      SDMA_CTRL7_Sl_SSize => open,
      SDMA_CTRL7_Sl_wait => open,
      SDMA_CTRL7_Sl_rearbitrate => open,
      SDMA_CTRL7_Sl_wrDAck => open,
      SDMA_CTRL7_Sl_wrComp => open,
      SDMA_CTRL7_Sl_wrBTerm => open,
      SDMA_CTRL7_Sl_rdDBus => open,
      SDMA_CTRL7_Sl_rdWdAddr => open,
      SDMA_CTRL7_Sl_rdDAck => open,
      SDMA_CTRL7_Sl_rdComp => open,
      SDMA_CTRL7_Sl_rdBTerm => open,
      SDMA_CTRL7_Sl_MBusy => open,
      SDMA_CTRL7_Sl_MRdErr => open,
      SDMA_CTRL7_Sl_MWrErr => open,
      SDMA_CTRL7_Sl_MIRQ => open,
      PIM7_Addr => net_gnd32(0 to 31),
      PIM7_AddrReq => net_gnd0,
      PIM7_AddrAck => open,
      PIM7_RNW => net_gnd0,
      PIM7_Size => net_gnd4(0 to 3),
      PIM7_RdModWr => net_gnd0,
      PIM7_WrFIFO_Data => net_gnd64(0 to 63),
      PIM7_WrFIFO_BE => net_gnd8(0 to 7),
      PIM7_WrFIFO_Push => net_gnd0,
      PIM7_RdFIFO_Data => open,
      PIM7_RdFIFO_Pop => net_gnd0,
      PIM7_RdFIFO_RdWdAddr => open,
      PIM7_WrFIFO_Empty => open,
      PIM7_WrFIFO_AlmostFull => open,
      PIM7_WrFIFO_Flush => net_gnd0,
      PIM7_RdFIFO_Empty => open,
      PIM7_RdFIFO_Flush => net_gnd0,
      PIM7_RdFIFO_Latency => open,
      PIM7_InitDone => open,
      PPC440MC7_MIMCReadNotWrite => net_gnd0,
      PPC440MC7_MIMCAddress => net_gnd36,
      PPC440MC7_MIMCAddressValid => net_gnd0,
      PPC440MC7_MIMCWriteData => net_gnd128,
      PPC440MC7_MIMCWriteDataValid => net_gnd0,
      PPC440MC7_MIMCByteEnable => net_gnd16,
      PPC440MC7_MIMCBankConflict => net_gnd0,
      PPC440MC7_MIMCRowConflict => net_gnd0,
      PPC440MC7_MCMIReadData => open,
      PPC440MC7_MCMIReadDataValid => open,
      PPC440MC7_MCMIReadDataErr => open,
      PPC440MC7_MCMIAddrReadyToAccept => open,
      VFBC7_Cmd_Clk => net_gnd0,
      VFBC7_Cmd_Reset => net_gnd0,
      VFBC7_Cmd_Data => net_gnd32(0 to 31),
      VFBC7_Cmd_Write => net_gnd0,
      VFBC7_Cmd_End => net_gnd0,
      VFBC7_Cmd_Full => open,
      VFBC7_Cmd_Almost_Full => open,
      VFBC7_Cmd_Idle => open,
      VFBC7_Wd_Clk => net_gnd0,
      VFBC7_Wd_Reset => net_gnd0,
      VFBC7_Wd_Write => net_gnd0,
      VFBC7_Wd_End_Burst => net_gnd0,
      VFBC7_Wd_Flush => net_gnd0,
      VFBC7_Wd_Data => net_gnd32(0 to 31),
      VFBC7_Wd_Data_BE => net_gnd4(0 to 3),
      VFBC7_Wd_Full => open,
      VFBC7_Wd_Almost_Full => open,
      VFBC7_Rd_Clk => net_gnd0,
      VFBC7_Rd_Reset => net_gnd0,
      VFBC7_Rd_Read => net_gnd0,
      VFBC7_Rd_End_Burst => net_gnd0,
      VFBC7_Rd_Flush => net_gnd0,
      VFBC7_Rd_Data => open,
      VFBC7_Rd_Empty => open,
      VFBC7_Rd_Almost_Empty => open,
      MPMC_CTRL_Clk => net_vcc0,
      MPMC_CTRL_Rst => net_gnd0,
      MPMC_CTRL_PLB_ABus => net_gnd32,
      MPMC_CTRL_PLB_PAValid => net_gnd0,
      MPMC_CTRL_PLB_SAValid => net_gnd0,
      MPMC_CTRL_PLB_masterID => net_gnd1(0 to 0),
      MPMC_CTRL_PLB_RNW => net_gnd0,
      MPMC_CTRL_PLB_BE => net_gnd8,
      MPMC_CTRL_PLB_UABus => net_gnd32,
      MPMC_CTRL_PLB_rdPrim => net_gnd0,
      MPMC_CTRL_PLB_wrPrim => net_gnd0,
      MPMC_CTRL_PLB_abort => net_gnd0,
      MPMC_CTRL_PLB_busLock => net_gnd0,
      MPMC_CTRL_PLB_MSize => net_gnd2,
      MPMC_CTRL_PLB_size => net_gnd4,
      MPMC_CTRL_PLB_type => net_gnd3,
      MPMC_CTRL_PLB_lockErr => net_gnd0,
      MPMC_CTRL_PLB_wrPendReq => net_gnd0,
      MPMC_CTRL_PLB_wrPendPri => net_gnd2,
      MPMC_CTRL_PLB_rdPendReq => net_gnd0,
      MPMC_CTRL_PLB_rdPendPri => net_gnd2,
      MPMC_CTRL_PLB_reqPri => net_gnd2,
      MPMC_CTRL_PLB_TAttribute => net_gnd16,
      MPMC_CTRL_PLB_rdBurst => net_gnd0,
      MPMC_CTRL_PLB_wrBurst => net_gnd0,
      MPMC_CTRL_PLB_wrDBus => net_gnd64,
      MPMC_CTRL_Sl_addrAck => open,
      MPMC_CTRL_Sl_SSize => open,
      MPMC_CTRL_Sl_wait => open,
      MPMC_CTRL_Sl_rearbitrate => open,
      MPMC_CTRL_Sl_wrDAck => open,
      MPMC_CTRL_Sl_wrComp => open,
      MPMC_CTRL_Sl_wrBTerm => open,
      MPMC_CTRL_Sl_rdDBus => open,
      MPMC_CTRL_Sl_rdWdAddr => open,
      MPMC_CTRL_Sl_rdDAck => open,
      MPMC_CTRL_Sl_rdComp => open,
      MPMC_CTRL_Sl_rdBTerm => open,
      MPMC_CTRL_Sl_MBusy => open,
      MPMC_CTRL_Sl_MRdErr => open,
      MPMC_CTRL_Sl_MWrErr => open,
      MPMC_CTRL_Sl_MIRQ => open,
      MPMC_Clk0 => sys_clk_s,
      MPMC_Clk0_DIV2 => DDR2_SDRAM_MPMC_Clk_Div2,
      MPMC_Clk90 => DDR2_SDRAM_mpmc_clk_90_s,
      MPMC_Clk_200MHz => clk_200mhz_s,
      MPMC_Rst => sys_periph_reset(0),
      MPMC_Clk_Mem => net_vcc0,
      MPMC_Idelayctrl_Rdy_I => net_vcc0,
      MPMC_Idelayctrl_Rdy_O => open,
      MPMC_InitDone => open,
      MPMC_ECC_Intr => open,
      MPMC_DCM_PSEN => open,
      MPMC_DCM_PSINCDEC => open,
      MPMC_DCM_PSDONE => net_gnd0,
      SDRAM_Clk => open,
      SDRAM_CE => open,
      SDRAM_CS_n => open,
      SDRAM_RAS_n => open,
      SDRAM_CAS_n => open,
      SDRAM_WE_n => open,
      SDRAM_BankAddr => open,
      SDRAM_Addr => open,
      SDRAM_DQ => open,
      SDRAM_DM => open,
      DDR_Clk => open,
      DDR_Clk_n => open,
      DDR_CE => open,
      DDR_CS_n => open,
      DDR_RAS_n => open,
      DDR_CAS_n => open,
      DDR_WE_n => open,
      DDR_BankAddr => open,
      DDR_Addr => open,
      DDR_DQ => open,
      DDR_DM => open,
      DDR_DQS => open,
      DDR_DQS_Div_O => open,
      DDR_DQS_Div_I => net_gnd0,
      DDR2_Clk => fpga_0_DDR2_SDRAM_DDR2_Clk,
      DDR2_Clk_n => fpga_0_DDR2_SDRAM_DDR2_Clk_n,
      DDR2_CE => fpga_0_DDR2_SDRAM_DDR2_CE_split(0 to 1),
      DDR2_CS_n => fpga_0_DDR2_SDRAM_DDR2_CS_n_split(0 to 1),
      DDR2_ODT => fpga_0_DDR2_SDRAM_DDR2_ODT,
      DDR2_RAS_n => fpga_0_DDR2_SDRAM_DDR2_RAS_n,
      DDR2_CAS_n => fpga_0_DDR2_SDRAM_DDR2_CAS_n,
      DDR2_WE_n => fpga_0_DDR2_SDRAM_DDR2_WE_n,
      DDR2_BankAddr => fpga_0_DDR2_SDRAM_DDR2_BankAddr,
      DDR2_Addr => fpga_0_DDR2_SDRAM_DDR2_Addr,
      DDR2_DQ => fpga_0_DDR2_SDRAM_DDR2_DQ,
      DDR2_DM => fpga_0_DDR2_SDRAM_DDR2_DM,
      DDR2_DQS => fpga_0_DDR2_SDRAM_DDR2_DQS,
      DDR2_DQS_n => fpga_0_DDR2_SDRAM_DDR2_DQS_n,
      DDR2_DQS_Div_O => open,
      DDR2_DQS_Div_I => net_gnd0
    );

  xps_timer_1 : xps_timer_1_wrapper
    port map (
      CaptureTrig0 => net_gnd0,
      CaptureTrig1 => net_gnd0,
      GenerateOut0 => open,
      GenerateOut1 => open,
      PWM0 => open,
      Interrupt => xps_timer_1_Interrupt,
      Freeze => net_gnd0,
      SPLB_Clk => sys_clk_s,
      SPLB_Rst => mb_plb_SPLB_Rst(4),
      PLB_ABus => mb_plb_PLB_ABus,
      PLB_PAValid => mb_plb_PLB_PAValid,
      PLB_masterID => mb_plb_PLB_masterID(0 to 0),
      PLB_RNW => mb_plb_PLB_RNW,
      PLB_BE => mb_plb_PLB_BE,
      PLB_size => mb_plb_PLB_size,
      PLB_type => mb_plb_PLB_type,
      PLB_wrDBus => mb_plb_PLB_wrDBus,
      Sl_addrAck => mb_plb_Sl_addrAck(4),
      Sl_SSize => mb_plb_Sl_SSize(8 to 9),
      Sl_wait => mb_plb_Sl_wait(4),
      Sl_rearbitrate => mb_plb_Sl_rearbitrate(4),
      Sl_wrDAck => mb_plb_Sl_wrDAck(4),
      Sl_wrComp => mb_plb_Sl_wrComp(4),
      Sl_rdDBus => mb_plb_Sl_rdDBus(256 to 319),
      Sl_rdDAck => mb_plb_Sl_rdDAck(4),
      Sl_rdComp => mb_plb_Sl_rdComp(4),
      Sl_MBusy => mb_plb_Sl_MBusy(8 to 9),
      Sl_MWrErr => mb_plb_Sl_MWrErr(8 to 9),
      Sl_MRdErr => mb_plb_Sl_MRdErr(8 to 9),
      PLB_UABus => mb_plb_PLB_UABus,
      PLB_SAValid => mb_plb_PLB_SAValid,
      PLB_rdPrim => mb_plb_PLB_rdPrim(4),
      PLB_wrPrim => mb_plb_PLB_wrPrim(4),
      PLB_abort => mb_plb_PLB_abort,
      PLB_busLock => mb_plb_PLB_busLock,
      PLB_MSize => mb_plb_PLB_MSize,
      PLB_lockErr => mb_plb_PLB_lockErr,
      PLB_wrBurst => mb_plb_PLB_wrBurst,
      PLB_rdBurst => mb_plb_PLB_rdBurst,
      PLB_wrPendReq => mb_plb_PLB_wrPendReq,
      PLB_rdPendReq => mb_plb_PLB_rdPendReq,
      PLB_wrPendPri => mb_plb_PLB_wrPendPri,
      PLB_rdPendPri => mb_plb_PLB_rdPendPri,
      PLB_reqPri => mb_plb_PLB_reqPri,
      PLB_TAttribute => mb_plb_PLB_TAttribute,
      Sl_wrBTerm => mb_plb_Sl_wrBTerm(4),
      Sl_rdWdAddr => mb_plb_Sl_rdWdAddr(16 to 19),
      Sl_rdBTerm => mb_plb_Sl_rdBTerm(4),
      Sl_MIRQ => mb_plb_Sl_MIRQ(8 to 9)
    );

  SRAM_util_bus_split_0 : sram_util_bus_split_0_wrapper
    port map (
      Sig => fpga_0_SRAM_Mem_A_split,
      Out1 => fpga_0_SRAM_Mem_A,
      Out2 => open
    );

  DDR2_SDRAM_util_bus_split_1 : ddr2_sdram_util_bus_split_1_wrapper
    port map (
      Sig => fpga_0_DDR2_SDRAM_DDR2_CE_split,
      Out1 => open,
      Out2 => fpga_0_DDR2_SDRAM_DDR2_CE(0 to 0)
    );

  DDR2_SDRAM_util_bus_split_2 : ddr2_sdram_util_bus_split_2_wrapper
    port map (
      Sig => fpga_0_DDR2_SDRAM_DDR2_CS_n_split,
      Out1 => open,
      Out2 => fpga_0_DDR2_SDRAM_DDR2_CS_n(0 to 0)
    );

  clock_generator_0 : clock_generator_0_wrapper
    port map (
      CLKIN => dcm_clk_s,
      CLKFBIN => ZBT_CLK_FB_s,
      CLKOUT0 => sys_clk_s,
      CLKOUT1 => DDR2_SDRAM_mpmc_clk_90_s,
      CLKOUT2 => clk_200mhz_s,
      CLKOUT3 => DDR2_SDRAM_MPMC_Clk_Div2,
      CLKOUT4 => open,
      CLKOUT5 => open,
      CLKOUT6 => open,
      CLKOUT7 => open,
      CLKOUT8 => open,
      CLKOUT9 => open,
      CLKOUT10 => open,
      CLKOUT11 => open,
      CLKOUT12 => open,
      CLKOUT13 => open,
      CLKOUT14 => open,
      CLKOUT15 => open,
      CLKFBOUT => ZBT_CLK_OUT_s,
      RST => net_gnd0,
      LOCKED => Dcm_all_locked
    );

  debug_module : debug_module_wrapper
    port map (
      Interrupt => open,
      Debug_SYS_Rst => Debug_SYS_Rst,
      Ext_BRK => Ext_BRK,
      Ext_NM_BRK => Ext_NM_BRK,
      SPLB_Clk => sys_clk_s,
      SPLB_Rst => mb_plb_SPLB_Rst(5),
      PLB_ABus => mb_plb_PLB_ABus,
      PLB_UABus => mb_plb_PLB_UABus,
      PLB_PAValid => mb_plb_PLB_PAValid,
      PLB_SAValid => mb_plb_PLB_SAValid,
      PLB_rdPrim => mb_plb_PLB_rdPrim(5),
      PLB_wrPrim => mb_plb_PLB_wrPrim(5),
      PLB_masterID => mb_plb_PLB_masterID(0 to 0),
      PLB_abort => mb_plb_PLB_abort,
      PLB_busLock => mb_plb_PLB_busLock,
      PLB_RNW => mb_plb_PLB_RNW,
      PLB_BE => mb_plb_PLB_BE,
      PLB_MSize => mb_plb_PLB_MSize,
      PLB_size => mb_plb_PLB_size,
      PLB_type => mb_plb_PLB_type,
      PLB_lockErr => mb_plb_PLB_lockErr,
      PLB_wrDBus => mb_plb_PLB_wrDBus,
      PLB_wrBurst => mb_plb_PLB_wrBurst,
      PLB_rdBurst => mb_plb_PLB_rdBurst,
      PLB_wrPendReq => mb_plb_PLB_wrPendReq,
      PLB_rdPendReq => mb_plb_PLB_rdPendReq,
      PLB_wrPendPri => mb_plb_PLB_wrPendPri,
      PLB_rdPendPri => mb_plb_PLB_rdPendPri,
      PLB_reqPri => mb_plb_PLB_reqPri,
      PLB_TAttribute => mb_plb_PLB_TAttribute,
      Sl_addrAck => mb_plb_Sl_addrAck(5),
      Sl_SSize => mb_plb_Sl_SSize(10 to 11),
      Sl_wait => mb_plb_Sl_wait(5),
      Sl_rearbitrate => mb_plb_Sl_rearbitrate(5),
      Sl_wrDAck => mb_plb_Sl_wrDAck(5),
      Sl_wrComp => mb_plb_Sl_wrComp(5),
      Sl_wrBTerm => mb_plb_Sl_wrBTerm(5),
      Sl_rdDBus => mb_plb_Sl_rdDBus(320 to 383),
      Sl_rdWdAddr => mb_plb_Sl_rdWdAddr(20 to 23),
      Sl_rdDAck => mb_plb_Sl_rdDAck(5),
      Sl_rdComp => mb_plb_Sl_rdComp(5),
      Sl_rdBTerm => mb_plb_Sl_rdBTerm(5),
      Sl_MBusy => mb_plb_Sl_MBusy(10 to 11),
      Sl_MWrErr => mb_plb_Sl_MWrErr(10 to 11),
      Sl_MRdErr => mb_plb_Sl_MRdErr(10 to 11),
      Sl_MIRQ => mb_plb_Sl_MIRQ(10 to 11),
      OPB_Clk => net_gnd0,
      OPB_Rst => net_gnd0,
      OPB_ABus => net_gnd32,
      OPB_BE => net_gnd4,
      OPB_RNW => net_gnd0,
      OPB_select => net_gnd0,
      OPB_seqAddr => net_gnd0,
      OPB_DBus => net_gnd32,
      MDM_DBus => open,
      MDM_errAck => open,
      MDM_retry => open,
      MDM_toutSup => open,
      MDM_xferAck => open,
      Dbg_Clk_0 => microblaze_0_dbg_Dbg_Clk,
      Dbg_TDI_0 => microblaze_0_dbg_Dbg_TDI,
      Dbg_TDO_0 => microblaze_0_dbg_Dbg_TDO,
      Dbg_Reg_En_0 => microblaze_0_dbg_Dbg_Reg_En,
      Dbg_Capture_0 => microblaze_0_dbg_Dbg_Capture,
      Dbg_Shift_0 => microblaze_0_dbg_Dbg_Shift,
      Dbg_Update_0 => microblaze_0_dbg_Dbg_Update,
      Dbg_Rst_0 => microblaze_0_dbg_Debug_Rst,
      Dbg_Clk_1 => open,
      Dbg_TDI_1 => open,
      Dbg_TDO_1 => net_gnd0,
      Dbg_Reg_En_1 => open,
      Dbg_Capture_1 => open,
      Dbg_Shift_1 => open,
      Dbg_Update_1 => open,
      Dbg_Rst_1 => open,
      Dbg_Clk_2 => open,
      Dbg_TDI_2 => open,
      Dbg_TDO_2 => net_gnd0,
      Dbg_Reg_En_2 => open,
      Dbg_Capture_2 => open,
      Dbg_Shift_2 => open,
      Dbg_Update_2 => open,
      Dbg_Rst_2 => open,
      Dbg_Clk_3 => open,
      Dbg_TDI_3 => open,
      Dbg_TDO_3 => net_gnd0,
      Dbg_Reg_En_3 => open,
      Dbg_Capture_3 => open,
      Dbg_Shift_3 => open,
      Dbg_Update_3 => open,
      Dbg_Rst_3 => open,
      Dbg_Clk_4 => open,
      Dbg_TDI_4 => open,
      Dbg_TDO_4 => net_gnd0,
      Dbg_Reg_En_4 => open,
      Dbg_Capture_4 => open,
      Dbg_Shift_4 => open,
      Dbg_Update_4 => open,
      Dbg_Rst_4 => open,
      Dbg_Clk_5 => open,
      Dbg_TDI_5 => open,
      Dbg_TDO_5 => net_gnd0,
      Dbg_Reg_En_5 => open,
      Dbg_Capture_5 => open,
      Dbg_Shift_5 => open,
      Dbg_Update_5 => open,
      Dbg_Rst_5 => open,
      Dbg_Clk_6 => open,
      Dbg_TDI_6 => open,
      Dbg_TDO_6 => net_gnd0,
      Dbg_Reg_En_6 => open,
      Dbg_Capture_6 => open,
      Dbg_Shift_6 => open,
      Dbg_Update_6 => open,
      Dbg_Rst_6 => open,
      Dbg_Clk_7 => open,
      Dbg_TDI_7 => open,
      Dbg_TDO_7 => net_gnd0,
      Dbg_Reg_En_7 => open,
      Dbg_Capture_7 => open,
      Dbg_Shift_7 => open,
      Dbg_Update_7 => open,
      Dbg_Rst_7 => open,
      bscan_tdi => open,
      bscan_reset => open,
      bscan_shift => open,
      bscan_update => open,
      bscan_capture => open,
      bscan_sel1 => open,
      bscan_drck1 => open,
      bscan_tdo1 => net_gnd0,
      FSL0_S_CLK => open,
      FSL0_S_READ => open,
      FSL0_S_DATA => net_gnd32,
      FSL0_S_CONTROL => net_gnd0,
      FSL0_S_EXISTS => net_gnd0,
      FSL0_M_CLK => open,
      FSL0_M_WRITE => open,
      FSL0_M_DATA => open,
      FSL0_M_CONTROL => open,
      FSL0_M_FULL => net_gnd0,
      Ext_JTAG_DRCK => open,
      Ext_JTAG_RESET => open,
      Ext_JTAG_SEL => open,
      Ext_JTAG_CAPTURE => open,
      Ext_JTAG_SHIFT => open,
      Ext_JTAG_UPDATE => open,
      Ext_JTAG_TDI => open,
      Ext_JTAG_TDO => net_gnd0
    );

  proc_sys_reset_0 : proc_sys_reset_0_wrapper
    port map (
      Slowest_sync_clk => sys_clk_s,
      Ext_Reset_In => sys_rst_s,
      Aux_Reset_In => net_gnd0,
      MB_Debug_Sys_Rst => Debug_SYS_Rst,
      Core_Reset_Req_0 => net_gnd0,
      Chip_Reset_Req_0 => net_gnd0,
      System_Reset_Req_0 => net_gnd0,
      Core_Reset_Req_1 => net_gnd0,
      Chip_Reset_Req_1 => net_gnd0,
      System_Reset_Req_1 => net_gnd0,
      Dcm_locked => Dcm_all_locked,
      RstcPPCresetcore_0 => open,
      RstcPPCresetchip_0 => open,
      RstcPPCresetsys_0 => open,
      RstcPPCresetcore_1 => open,
      RstcPPCresetchip_1 => open,
      RstcPPCresetsys_1 => open,
      MB_Reset => mb_reset,
      Bus_Struct_Reset => sys_bus_reset(0 to 0),
      Peripheral_Reset => sys_periph_reset(0 to 0)
    );

  xps_intc_0 : xps_intc_0_wrapper
    port map (
      SPLB_Clk => sys_clk_s,
      SPLB_Rst => mb_plb_SPLB_Rst(6),
      PLB_ABus => mb_plb_PLB_ABus,
      PLB_PAValid => mb_plb_PLB_PAValid,
      PLB_masterID => mb_plb_PLB_masterID(0 to 0),
      PLB_RNW => mb_plb_PLB_RNW,
      PLB_BE => mb_plb_PLB_BE,
      PLB_size => mb_plb_PLB_size,
      PLB_type => mb_plb_PLB_type,
      PLB_wrDBus => mb_plb_PLB_wrDBus,
      PLB_UABus => mb_plb_PLB_UABus,
      PLB_SAValid => mb_plb_PLB_SAValid,
      PLB_rdPrim => mb_plb_PLB_rdPrim(6),
      PLB_wrPrim => mb_plb_PLB_wrPrim(6),
      PLB_abort => mb_plb_PLB_abort,
      PLB_busLock => mb_plb_PLB_busLock,
      PLB_MSize => mb_plb_PLB_MSize,
      PLB_lockErr => mb_plb_PLB_lockErr,
      PLB_wrBurst => mb_plb_PLB_wrBurst,
      PLB_rdBurst => mb_plb_PLB_rdBurst,
      PLB_wrPendReq => mb_plb_PLB_wrPendReq,
      PLB_rdPendReq => mb_plb_PLB_rdPendReq,
      PLB_wrPendPri => mb_plb_PLB_wrPendPri,
      PLB_rdPendPri => mb_plb_PLB_rdPendPri,
      PLB_reqPri => mb_plb_PLB_reqPri,
      PLB_TAttribute => mb_plb_PLB_TAttribute,
      Sl_addrAck => mb_plb_Sl_addrAck(6),
      Sl_SSize => mb_plb_Sl_SSize(12 to 13),
      Sl_wait => mb_plb_Sl_wait(6),
      Sl_rearbitrate => mb_plb_Sl_rearbitrate(6),
      Sl_wrDAck => mb_plb_Sl_wrDAck(6),
      Sl_wrComp => mb_plb_Sl_wrComp(6),
      Sl_rdDBus => mb_plb_Sl_rdDBus(384 to 447),
      Sl_rdDAck => mb_plb_Sl_rdDAck(6),
      Sl_rdComp => mb_plb_Sl_rdComp(6),
      Sl_MBusy => mb_plb_Sl_MBusy(12 to 13),
      Sl_MWrErr => mb_plb_Sl_MWrErr(12 to 13),
      Sl_MRdErr => mb_plb_Sl_MRdErr(12 to 13),
      Sl_wrBTerm => mb_plb_Sl_wrBTerm(6),
      Sl_rdWdAddr => mb_plb_Sl_rdWdAddr(24 to 27),
      Sl_rdBTerm => mb_plb_Sl_rdBTerm(6),
      Sl_MIRQ => mb_plb_Sl_MIRQ(12 to 13),
      Intr => pgassign1,
      Irq => Interrupt
    );

  plbv46_opb_bridge_0 : plbv46_opb_bridge_0_wrapper
    port map (
      SPLB_Clk => sys_clk_s,
      SPLB_Rst => mb_plb_SPLB_Rst(7),
      PLB_ABus => mb_plb_PLB_ABus,
      PLB_UABus => mb_plb_PLB_UABus,
      PLB_PAValid => mb_plb_PLB_PAValid,
      PLB_SAValid => mb_plb_PLB_SAValid,
      PLB_rdPrim => mb_plb_PLB_rdPrim(7),
      PLB_wrPrim => mb_plb_PLB_wrPrim(7),
      PLB_masterID => mb_plb_PLB_masterID(0 to 0),
      PLB_abort => mb_plb_PLB_abort,
      PLB_busLock => mb_plb_PLB_busLock,
      PLB_RNW => mb_plb_PLB_RNW,
      PLB_BE => mb_plb_PLB_BE,
      PLB_MSize => mb_plb_PLB_MSize,
      PLB_size => mb_plb_PLB_size,
      PLB_type => mb_plb_PLB_type,
      PLB_lockErr => mb_plb_PLB_lockErr,
      PLB_wrDBus => mb_plb_PLB_wrDBus,
      PLB_wrBurst => mb_plb_PLB_wrBurst,
      PLB_rdBurst => mb_plb_PLB_rdBurst,
      PLB_wrPendReq => mb_plb_PLB_wrPendReq,
      PLB_rdPendReq => mb_plb_PLB_rdPendReq,
      PLB_wrPendPri => mb_plb_PLB_wrPendPri,
      PLB_rdPendPri => mb_plb_PLB_rdPendPri,
      PLB_reqPri => mb_plb_PLB_reqPri,
      PLB_TAttribute => mb_plb_PLB_TAttribute,
      Sl_addrAck => mb_plb_Sl_addrAck(7),
      Sl_SSize => mb_plb_Sl_SSize(14 to 15),
      Sl_wait => mb_plb_Sl_wait(7),
      Sl_rearbitrate => mb_plb_Sl_rearbitrate(7),
      Sl_wrDAck => mb_plb_Sl_wrDAck(7),
      Sl_wrComp => mb_plb_Sl_wrComp(7),
      Sl_wrBTerm => mb_plb_Sl_wrBTerm(7),
      Sl_rdDBus => mb_plb_Sl_rdDBus(448 to 511),
      Sl_rdWdAddr => mb_plb_Sl_rdWdAddr(28 to 31),
      Sl_rdDAck => mb_plb_Sl_rdDAck(7),
      Sl_rdComp => mb_plb_Sl_rdComp(7),
      Sl_rdBTerm => mb_plb_Sl_rdBTerm(7),
      Sl_MBusy => mb_plb_Sl_MBusy(14 to 15),
      Sl_MWrErr => mb_plb_Sl_MWrErr(14 to 15),
      Sl_MRdErr => mb_plb_Sl_MRdErr(14 to 15),
      Sl_MIRQ => mb_plb_Sl_MIRQ(14 to 15),
      OPB_Clk => sys_clk_s,
      OPB_Rst => opb_v20_0_OPB_Rst,
      Mn_request => opb_v20_0_M_request(0),
      Mn_busLock => opb_v20_0_M_busLock(0),
      Mn_select => opb_v20_0_M_select(0),
      Mn_RNW => opb_v20_0_M_RNW(0),
      Mn_BE => opb_v20_0_M_BE(0 to 3),
      Mn_seqAddr => opb_v20_0_M_seqAddr(0),
      Mn_DBus => opb_v20_0_M_DBus(0 to 31),
      Mn_ABus => opb_v20_0_M_ABus(0 to 31),
      OPB_MGrant => opb_v20_0_OPB_MGrant(0),
      OPB_xferAck => opb_v20_0_OPB_xferAck,
      OPB_errAck => opb_v20_0_OPB_errAck,
      OPB_retry => opb_v20_0_OPB_retry,
      OPB_timeout => opb_v20_0_OPB_timeout,
      OPB_DBus => opb_v20_0_OPB_DBus
    );

  opb_v20_0 : opb_v20_0_wrapper
    port map (
      OPB_Clk => sys_clk_s,
      OPB_Rst => opb_v20_0_OPB_Rst,
      SYS_Rst => sys_rst_s,
      Debug_SYS_Rst => net_gnd0,
      WDT_Rst => net_gnd0,
      M_ABus => opb_v20_0_M_ABus,
      M_BE => opb_v20_0_M_BE,
      M_beXfer => net_gnd4,
      M_busLock => opb_v20_0_M_busLock,
      M_DBus => opb_v20_0_M_DBus,
      M_DBusEn => net_gnd4,
      M_DBusEn32_63 => net_vcc4,
      M_dwXfer => net_gnd4,
      M_fwXfer => net_gnd4,
      M_hwXfer => net_gnd4,
      M_request => opb_v20_0_M_request,
      M_RNW => opb_v20_0_M_RNW,
      M_select => opb_v20_0_M_select,
      M_seqAddr => opb_v20_0_M_seqAddr,
      Sl_beAck => net_gnd5,
      Sl_DBus => opb_v20_0_Sl_DBus,
      Sl_DBusEn => net_vcc5,
      Sl_DBusEn32_63 => net_vcc5,
      Sl_errAck => opb_v20_0_Sl_errAck,
      Sl_dwAck => net_gnd5,
      Sl_fwAck => net_gnd5,
      Sl_hwAck => net_gnd5,
      Sl_retry => opb_v20_0_Sl_retry,
      Sl_toutSup => opb_v20_0_Sl_toutSup,
      Sl_xferAck => opb_v20_0_Sl_xferAck,
      OPB_MRequest => open,
      OPB_ABus => opb_v20_0_OPB_ABus,
      OPB_BE => opb_v20_0_OPB_BE,
      OPB_beXfer => open,
      OPB_beAck => open,
      OPB_busLock => open,
      OPB_rdDBus => open,
      OPB_wrDBus => open,
      OPB_DBus => opb_v20_0_OPB_DBus,
      OPB_errAck => opb_v20_0_OPB_errAck,
      OPB_dwAck => open,
      OPB_dwXfer => open,
      OPB_fwAck => open,
      OPB_fwXfer => open,
      OPB_hwAck => open,
      OPB_hwXfer => open,
      OPB_MGrant => opb_v20_0_OPB_MGrant,
      OPB_pendReq => open,
      OPB_retry => opb_v20_0_OPB_retry,
      OPB_RNW => opb_v20_0_OPB_RNW,
      OPB_select => opb_v20_0_OPB_select,
      OPB_seqAddr => opb_v20_0_OPB_seqAddr,
      OPB_timeout => opb_v20_0_OPB_timeout,
      OPB_toutSup => open,
      OPB_xferAck => opb_v20_0_OPB_xferAck
    );

  opb_bram_if_cntlr_1 : opb_bram_if_cntlr_1_wrapper
    port map (
      opb_clk => sys_clk_s,
      opb_rst => opb_v20_0_OPB_Rst,
      opb_abus => opb_v20_0_OPB_ABus,
      opb_dbus => opb_v20_0_OPB_DBus,
      sln_dbus => opb_v20_0_Sl_DBus(0 to 31),
      opb_select => opb_v20_0_OPB_select,
      opb_rnw => opb_v20_0_OPB_RNW,
      opb_seqaddr => opb_v20_0_OPB_seqAddr,
      opb_be => opb_v20_0_OPB_BE,
      sln_xferack => opb_v20_0_Sl_xferAck(0),
      sln_errack => opb_v20_0_Sl_errAck(0),
      sln_toutsup => opb_v20_0_Sl_toutSup(0),
      sln_retry => opb_v20_0_Sl_retry(0),
      bram_rst => opb_bram_if_cntlr_1_PORTA_BRAM_Rst,
      bram_clk => opb_bram_if_cntlr_1_PORTA_BRAM_Clk,
      bram_en => opb_bram_if_cntlr_1_PORTA_BRAM_EN,
      bram_wen => opb_bram_if_cntlr_1_PORTA_BRAM_WEN,
      bram_addr => opb_bram_if_cntlr_1_PORTA_BRAM_Addr,
      bram_din => opb_bram_if_cntlr_1_PORTA_BRAM_Din,
      bram_dout => opb_bram_if_cntlr_1_PORTA_BRAM_Dout
    );

  bram_block_0 : bram_block_0_wrapper
    port map (
      BRAM_Rst_A => xps_bram_if_cntlr_0_PORTA_BRAM_Rst,
      BRAM_Clk_A => xps_bram_if_cntlr_0_PORTA_BRAM_Clk,
      BRAM_EN_A => xps_bram_if_cntlr_0_PORTA_BRAM_EN,
      BRAM_WEN_A => xps_bram_if_cntlr_0_PORTA_BRAM_WEN,
      BRAM_Addr_A => xps_bram_if_cntlr_0_PORTA_BRAM_Addr,
      BRAM_Din_A => xps_bram_if_cntlr_0_PORTA_BRAM_Din,
      BRAM_Dout_A => xps_bram_if_cntlr_0_PORTA_BRAM_Dout,
      BRAM_Rst_B => opb_bram_if_cntlr_1_PORTA_BRAM_Rst,
      BRAM_Clk_B => opb_bram_if_cntlr_1_PORTA_BRAM_Clk,
      BRAM_EN_B => opb_bram_if_cntlr_1_PORTA_BRAM_EN,
      BRAM_WEN_B => opb_bram_if_cntlr_1_PORTA_BRAM_WEN,
      BRAM_Addr_B => opb_bram_if_cntlr_1_PORTA_BRAM_Addr,
      BRAM_Din_B => opb_bram_if_cntlr_1_PORTA_BRAM_Din,
      BRAM_Dout_B => opb_bram_if_cntlr_1_PORTA_BRAM_Dout
    );

  xps_bram_if_cntlr_0 : xps_bram_if_cntlr_0_wrapper
    port map (
      SPLB_Clk => sys_clk_s,
      SPLB_Rst => mb_plb_SPLB_Rst(8),
      PLB_ABus => mb_plb_PLB_ABus,
      PLB_UABus => mb_plb_PLB_UABus,
      PLB_PAValid => mb_plb_PLB_PAValid,
      PLB_SAValid => mb_plb_PLB_SAValid,
      PLB_rdPrim => mb_plb_PLB_rdPrim(8),
      PLB_wrPrim => mb_plb_PLB_wrPrim(8),
      PLB_masterID => mb_plb_PLB_masterID(0 to 0),
      PLB_abort => mb_plb_PLB_abort,
      PLB_busLock => mb_plb_PLB_busLock,
      PLB_RNW => mb_plb_PLB_RNW,
      PLB_BE => mb_plb_PLB_BE,
      PLB_MSize => mb_plb_PLB_MSize,
      PLB_size => mb_plb_PLB_size,
      PLB_type => mb_plb_PLB_type,
      PLB_lockErr => mb_plb_PLB_lockErr,
      PLB_wrDBus => mb_plb_PLB_wrDBus,
      PLB_wrBurst => mb_plb_PLB_wrBurst,
      PLB_rdBurst => mb_plb_PLB_rdBurst,
      PLB_wrPendReq => mb_plb_PLB_wrPendReq,
      PLB_rdPendReq => mb_plb_PLB_rdPendReq,
      PLB_wrPendPri => mb_plb_PLB_wrPendPri,
      PLB_rdPendPri => mb_plb_PLB_rdPendPri,
      PLB_reqPri => mb_plb_PLB_reqPri,
      PLB_TAttribute => mb_plb_PLB_TAttribute,
      Sl_addrAck => mb_plb_Sl_addrAck(8),
      Sl_SSize => mb_plb_Sl_SSize(16 to 17),
      Sl_wait => mb_plb_Sl_wait(8),
      Sl_rearbitrate => mb_plb_Sl_rearbitrate(8),
      Sl_wrDAck => mb_plb_Sl_wrDAck(8),
      Sl_wrComp => mb_plb_Sl_wrComp(8),
      Sl_wrBTerm => mb_plb_Sl_wrBTerm(8),
      Sl_rdDBus => mb_plb_Sl_rdDBus(512 to 575),
      Sl_rdWdAddr => mb_plb_Sl_rdWdAddr(32 to 35),
      Sl_rdDAck => mb_plb_Sl_rdDAck(8),
      Sl_rdComp => mb_plb_Sl_rdComp(8),
      Sl_rdBTerm => mb_plb_Sl_rdBTerm(8),
      Sl_MBusy => mb_plb_Sl_MBusy(16 to 17),
      Sl_MWrErr => mb_plb_Sl_MWrErr(16 to 17),
      Sl_MRdErr => mb_plb_Sl_MRdErr(16 to 17),
      Sl_MIRQ => mb_plb_Sl_MIRQ(16 to 17),
      BRAM_Rst => xps_bram_if_cntlr_0_PORTA_BRAM_Rst,
      BRAM_Clk => xps_bram_if_cntlr_0_PORTA_BRAM_Clk,
      BRAM_EN => xps_bram_if_cntlr_0_PORTA_BRAM_EN,
      BRAM_WEN => xps_bram_if_cntlr_0_PORTA_BRAM_WEN,
      BRAM_Addr => xps_bram_if_cntlr_0_PORTA_BRAM_Addr,
      BRAM_Din => xps_bram_if_cntlr_0_PORTA_BRAM_Din,
      BRAM_Dout => xps_bram_if_cntlr_0_PORTA_BRAM_Dout
    );

  thread_manager : thread_manager_wrapper
    port map (
      OPB_Clk => sys_clk_s,
      OPB_Rst => opb_v20_0_OPB_Rst,
      OPB_ABus => opb_v20_0_OPB_ABus,
      OPB_BE => opb_v20_0_OPB_BE,
      OPB_DBus => opb_v20_0_OPB_DBus,
      OPB_RNW => opb_v20_0_OPB_RNW,
      OPB_select => opb_v20_0_OPB_select,
      OPB_seqAddr => opb_v20_0_OPB_seqAddr,
      Sln_DBus => opb_v20_0_Sl_DBus(128 to 159),
      Sln_errAck => opb_v20_0_Sl_errAck(4),
      Sln_retry => opb_v20_0_Sl_retry(4),
      Sln_toutSup => opb_v20_0_Sl_toutSup(4),
      Sln_xferAck => opb_v20_0_Sl_xferAck(4),
      Access_Intr => access_intr,
      Scheduler_Reset => open,
      Scheduler_Reset_Done => net_gnd0,
      Semaphore_Reset => open,
      Semaphore_Reset_Done => net_gnd0,
      SpinLock_Reset => open,
      SpinLock_Reset_Done => net_gnd0,
      User_IP_Reset => open,
      User_IP_Reset_Done => net_gnd0,
      Soft_Stop => soft_stop,
      tm2sch_cpu_thread_id => core_tm2sch_cpu_thread_id,
      tm2sch_opcode => core_tm2sch_opcode,
      tm2sch_data => core_tm2sch_data,
      tm2sch_request => core_tm2sch_request,
      sch2tm_busy => core_sch2tm_busy,
      sch2tm_data => core_sch2tm_data,
      sch2tm_next_id => core_sch2tm_next_id,
      sch2tm_next_id_valid => core_sch2tm_next_id_valid,
      tm2sch_DOB => core_tm2sch_dob,
      sch2tm_ADDRB => core_sch2tm_addrb,
      sch2tm_DIB => core_sch2tm_dib,
      sch2tm_ENB => core_sch2tm_enb,
      sch2tm_WEB => core_sch2tm_web
    );

  scheduler : scheduler_wrapper
    port map (
      Soft_Reset => hthread_rst_sched,
      Reset_Done => hthread_resp_sched,
      Soft_Stop => soft_stop,
      SWTM_DOB => core_tm2sch_dob,
      SWTM_ADDRB => core_sch2tm_addrb,
      SWTM_DIB => core_sch2tm_dib,
      SWTM_ENB => core_sch2tm_enb,
      SWTM_WEB => core_sch2tm_web,
      TM2SCH_current_cpu_tid => core_tm2sch_cpu_thread_id,
      TM2SCH_opcode => core_tm2sch_opcode,
      TM2SCH_data => core_tm2sch_data,
      TM2SCH_request => core_tm2sch_request,
      SCH2TM_busy => core_sch2tm_busy,
      SCH2TM_data => core_sch2tm_data,
      SCH2TM_next_cpu_tid => core_sch2tm_next_id,
      SCH2TM_next_tid_valid => core_sch2tm_next_id_valid,
      Preemption_Interrupt => sched_intr,
      OPB_Clk => sys_clk_s,
      OPB_Rst => opb_v20_0_OPB_Rst,
      Sl_DBus => opb_v20_0_Sl_DBus(32 to 63),
      Sl_errAck => opb_v20_0_Sl_errAck(1),
      Sl_retry => opb_v20_0_Sl_retry(1),
      Sl_toutSup => opb_v20_0_Sl_toutSup(1),
      Sl_xferAck => opb_v20_0_Sl_xferAck(1),
      OPB_ABus => opb_v20_0_OPB_ABus,
      OPB_BE => opb_v20_0_OPB_BE,
      OPB_DBus => opb_v20_0_OPB_DBus,
      OPB_RNW => opb_v20_0_OPB_RNW,
      OPB_select => opb_v20_0_OPB_select,
      OPB_seqAddr => opb_v20_0_OPB_seqAddr,
      M_ABus => opb_v20_0_M_ABus(32 to 63),
      M_BE => opb_v20_0_M_BE(4 to 7),
      M_busLock => opb_v20_0_M_busLock(1),
      M_request => opb_v20_0_M_request(1),
      M_RNW => opb_v20_0_M_RNW(1),
      M_select => opb_v20_0_M_select(1),
      M_seqAddr => opb_v20_0_M_seqAddr(1),
      OPB_errAck => opb_v20_0_OPB_errAck,
      OPB_MGrant => opb_v20_0_OPB_MGrant(1),
      OPB_retry => opb_v20_0_OPB_retry,
      OPB_timeout => opb_v20_0_OPB_timeout,
      OPB_xferAck => opb_v20_0_OPB_xferAck
    );

  synch_manager : synch_manager_wrapper
    port map (
      OPB_Clk => sys_clk_s,
      OPB_Rst => opb_v20_0_OPB_Rst,
      Sl_DBus => opb_v20_0_Sl_DBus(64 to 95),
      Sl_errAck => opb_v20_0_Sl_errAck(2),
      Sl_retry => opb_v20_0_Sl_retry(2),
      Sl_toutSup => opb_v20_0_Sl_toutSup(2),
      Sl_xferAck => opb_v20_0_Sl_xferAck(2),
      OPB_ABus => opb_v20_0_OPB_ABus,
      OPB_BE => opb_v20_0_OPB_BE,
      OPB_DBus => opb_v20_0_OPB_DBus,
      OPB_RNW => opb_v20_0_OPB_RNW,
      OPB_select => opb_v20_0_OPB_select,
      OPB_seqAddr => opb_v20_0_OPB_seqAddr,
      M_ABus => opb_v20_0_M_ABus(64 to 95),
      M_BE => opb_v20_0_M_BE(8 to 11),
      M_busLock => opb_v20_0_M_busLock(2),
      M_request => opb_v20_0_M_request(2),
      M_RNW => opb_v20_0_M_RNW(2),
      M_select => opb_v20_0_M_select(2),
      M_seqAddr => opb_v20_0_M_seqAddr(2),
      OPB_errAck => opb_v20_0_OPB_errAck,
      OPB_MGrant => opb_v20_0_OPB_MGrant(2),
      OPB_retry => opb_v20_0_OPB_retry,
      OPB_timeout => opb_v20_0_OPB_timeout,
      OPB_xferAck => opb_v20_0_OPB_xferAck,
      system_reset => hthread_rst_synch,
      system_resetdone => hthread_resp_synch
    );

  cond_vars : cond_vars_wrapper
    port map (
      OPB_Clk => sys_clk_s,
      OPB_Rst => opb_v20_0_OPB_Rst,
      Interrupt => open,
      IP2Bus_IntrEvent => net_gnd1(0 to 0),
      OPB_ABus => opb_v20_0_OPB_ABus,
      OPB_DBus => opb_v20_0_OPB_DBus,
      OPB_BE => opb_v20_0_OPB_BE,
      OPB_RNW => opb_v20_0_OPB_RNW,
      OPB_select => opb_v20_0_OPB_select,
      OPB_seqAddr => opb_v20_0_OPB_seqAddr,
      OPB_errAck => opb_v20_0_OPB_errAck,
      OPB_MnGrant => opb_v20_0_OPB_MGrant(3),
      OPB_retry => opb_v20_0_OPB_retry,
      OPB_timeout => opb_v20_0_OPB_timeout,
      OPB_xferAck => opb_v20_0_OPB_xferAck,
      Mn_request => opb_v20_0_M_request(3),
      Mn_busLock => opb_v20_0_M_busLock(3),
      Mn_select => opb_v20_0_M_select(3),
      Mn_RNW => opb_v20_0_M_RNW(3),
      Mn_BE => opb_v20_0_M_BE(12 to 15),
      Mn_seqAddr => opb_v20_0_M_seqAddr(3),
      Mn_ABus => opb_v20_0_M_ABus(96 to 127),
      Sln_xferAck => opb_v20_0_Sl_xferAck(3),
      Sln_errAck => opb_v20_0_Sl_errAck(3),
      Sln_retry => opb_v20_0_Sl_retry(3),
      Sln_toutSup => opb_v20_0_Sl_toutSup(3),
      Sln_DBus => opb_v20_0_Sl_DBus(96 to 127),
      Sema_Reset => hthread_rst_condvar,
      Sema_Rst_Ack => hthread_resp_condvar
    );

  plb_hthread_reset_core_0 : plb_hthread_reset_core_0_wrapper
    port map (
      reset_port0 => open,
      reset_response_port0 => hthread_resp_sched,
      reset_port1 => hthread_rst_sched,
      reset_response_port1 => hthread_resp_sched,
      reset_port2 => hthread_rst_synch,
      reset_response_port2 => hthread_resp_synch,
      reset_port3 => hthread_rst_condvar,
      reset_response_port3 => hthread_resp_condvar,
      SPLB_Clk => sys_clk_s,
      SPLB_Rst => mb_plb_SPLB_Rst(9),
      PLB_ABus => mb_plb_PLB_ABus,
      PLB_UABus => mb_plb_PLB_UABus,
      PLB_PAValid => mb_plb_PLB_PAValid,
      PLB_SAValid => mb_plb_PLB_SAValid,
      PLB_rdPrim => mb_plb_PLB_rdPrim(9),
      PLB_wrPrim => mb_plb_PLB_wrPrim(9),
      PLB_masterID => mb_plb_PLB_masterID(0 to 0),
      PLB_abort => mb_plb_PLB_abort,
      PLB_busLock => mb_plb_PLB_busLock,
      PLB_RNW => mb_plb_PLB_RNW,
      PLB_BE => mb_plb_PLB_BE,
      PLB_MSize => mb_plb_PLB_MSize,
      PLB_size => mb_plb_PLB_size,
      PLB_type => mb_plb_PLB_type,
      PLB_lockErr => mb_plb_PLB_lockErr,
      PLB_wrDBus => mb_plb_PLB_wrDBus,
      PLB_wrBurst => mb_plb_PLB_wrBurst,
      PLB_rdBurst => mb_plb_PLB_rdBurst,
      PLB_wrPendReq => mb_plb_PLB_wrPendReq,
      PLB_rdPendReq => mb_plb_PLB_rdPendReq,
      PLB_wrPendPri => mb_plb_PLB_wrPendPri,
      PLB_rdPendPri => mb_plb_PLB_rdPendPri,
      PLB_reqPri => mb_plb_PLB_reqPri,
      PLB_TAttribute => mb_plb_PLB_TAttribute,
      Sl_addrAck => mb_plb_Sl_addrAck(9),
      Sl_SSize => mb_plb_Sl_SSize(18 to 19),
      Sl_wait => mb_plb_Sl_wait(9),
      Sl_rearbitrate => mb_plb_Sl_rearbitrate(9),
      Sl_wrDAck => mb_plb_Sl_wrDAck(9),
      Sl_wrComp => mb_plb_Sl_wrComp(9),
      Sl_wrBTerm => mb_plb_Sl_wrBTerm(9),
      Sl_rdDBus => mb_plb_Sl_rdDBus(576 to 639),
      Sl_rdWdAddr => mb_plb_Sl_rdWdAddr(36 to 39),
      Sl_rdDAck => mb_plb_Sl_rdDAck(9),
      Sl_rdComp => mb_plb_Sl_rdComp(9),
      Sl_rdBTerm => mb_plb_Sl_rdBTerm(9),
      Sl_MBusy => mb_plb_Sl_MBusy(18 to 19),
      Sl_MWrErr => mb_plb_Sl_MWrErr(18 to 19),
      Sl_MRdErr => mb_plb_Sl_MRdErr(18 to 19),
      Sl_MIRQ => mb_plb_Sl_MIRQ(18 to 19)
    );

  plb_hthreads_timer_0 : plb_hthreads_timer_0_wrapper
    port map (
      SPLB_Clk => sys_clk_s,
      SPLB_Rst => mb_plb_SPLB_Rst(10),
      PLB_ABus => mb_plb_PLB_ABus,
      PLB_UABus => mb_plb_PLB_UABus,
      PLB_PAValid => mb_plb_PLB_PAValid,
      PLB_SAValid => mb_plb_PLB_SAValid,
      PLB_rdPrim => mb_plb_PLB_rdPrim(10),
      PLB_wrPrim => mb_plb_PLB_wrPrim(10),
      PLB_masterID => mb_plb_PLB_masterID(0 to 0),
      PLB_abort => mb_plb_PLB_abort,
      PLB_busLock => mb_plb_PLB_busLock,
      PLB_RNW => mb_plb_PLB_RNW,
      PLB_BE => mb_plb_PLB_BE,
      PLB_MSize => mb_plb_PLB_MSize,
      PLB_size => mb_plb_PLB_size,
      PLB_type => mb_plb_PLB_type,
      PLB_lockErr => mb_plb_PLB_lockErr,
      PLB_wrDBus => mb_plb_PLB_wrDBus,
      PLB_wrBurst => mb_plb_PLB_wrBurst,
      PLB_rdBurst => mb_plb_PLB_rdBurst,
      PLB_wrPendReq => mb_plb_PLB_wrPendReq,
      PLB_rdPendReq => mb_plb_PLB_rdPendReq,
      PLB_wrPendPri => mb_plb_PLB_wrPendPri,
      PLB_rdPendPri => mb_plb_PLB_rdPendPri,
      PLB_reqPri => mb_plb_PLB_reqPri,
      PLB_TAttribute => mb_plb_PLB_TAttribute,
      Sl_addrAck => mb_plb_Sl_addrAck(10),
      Sl_SSize => mb_plb_Sl_SSize(20 to 21),
      Sl_wait => mb_plb_Sl_wait(10),
      Sl_rearbitrate => mb_plb_Sl_rearbitrate(10),
      Sl_wrDAck => mb_plb_Sl_wrDAck(10),
      Sl_wrComp => mb_plb_Sl_wrComp(10),
      Sl_wrBTerm => mb_plb_Sl_wrBTerm(10),
      Sl_rdDBus => mb_plb_Sl_rdDBus(640 to 703),
      Sl_rdWdAddr => mb_plb_Sl_rdWdAddr(40 to 43),
      Sl_rdDAck => mb_plb_Sl_rdDAck(10),
      Sl_rdComp => mb_plb_Sl_rdComp(10),
      Sl_rdBTerm => mb_plb_Sl_rdBTerm(10),
      Sl_MBusy => mb_plb_Sl_MBusy(20 to 21),
      Sl_MWrErr => mb_plb_Sl_MWrErr(20 to 21),
      Sl_MRdErr => mb_plb_Sl_MRdErr(20 to 21),
      Sl_MIRQ => mb_plb_Sl_MIRQ(20 to 21)
    );

  iobuf_0 : IOBUF
    port map (
      I => fpga_0_LEDs_8Bit_GPIO_IO_O(0),
      IO => fpga_0_LEDs_8Bit_GPIO_IO_pin(0),
      O => fpga_0_LEDs_8Bit_GPIO_IO_I(0),
      T => fpga_0_LEDs_8Bit_GPIO_IO_T(0)
    );

  iobuf_1 : IOBUF
    port map (
      I => fpga_0_LEDs_8Bit_GPIO_IO_O(1),
      IO => fpga_0_LEDs_8Bit_GPIO_IO_pin(1),
      O => fpga_0_LEDs_8Bit_GPIO_IO_I(1),
      T => fpga_0_LEDs_8Bit_GPIO_IO_T(1)
    );

  iobuf_2 : IOBUF
    port map (
      I => fpga_0_LEDs_8Bit_GPIO_IO_O(2),
      IO => fpga_0_LEDs_8Bit_GPIO_IO_pin(2),
      O => fpga_0_LEDs_8Bit_GPIO_IO_I(2),
      T => fpga_0_LEDs_8Bit_GPIO_IO_T(2)
    );

  iobuf_3 : IOBUF
    port map (
      I => fpga_0_LEDs_8Bit_GPIO_IO_O(3),
      IO => fpga_0_LEDs_8Bit_GPIO_IO_pin(3),
      O => fpga_0_LEDs_8Bit_GPIO_IO_I(3),
      T => fpga_0_LEDs_8Bit_GPIO_IO_T(3)
    );

  iobuf_4 : IOBUF
    port map (
      I => fpga_0_LEDs_8Bit_GPIO_IO_O(4),
      IO => fpga_0_LEDs_8Bit_GPIO_IO_pin(4),
      O => fpga_0_LEDs_8Bit_GPIO_IO_I(4),
      T => fpga_0_LEDs_8Bit_GPIO_IO_T(4)
    );

  iobuf_5 : IOBUF
    port map (
      I => fpga_0_LEDs_8Bit_GPIO_IO_O(5),
      IO => fpga_0_LEDs_8Bit_GPIO_IO_pin(5),
      O => fpga_0_LEDs_8Bit_GPIO_IO_I(5),
      T => fpga_0_LEDs_8Bit_GPIO_IO_T(5)
    );

  iobuf_6 : IOBUF
    port map (
      I => fpga_0_LEDs_8Bit_GPIO_IO_O(6),
      IO => fpga_0_LEDs_8Bit_GPIO_IO_pin(6),
      O => fpga_0_LEDs_8Bit_GPIO_IO_I(6),
      T => fpga_0_LEDs_8Bit_GPIO_IO_T(6)
    );

  iobuf_7 : IOBUF
    port map (
      I => fpga_0_LEDs_8Bit_GPIO_IO_O(7),
      IO => fpga_0_LEDs_8Bit_GPIO_IO_pin(7),
      O => fpga_0_LEDs_8Bit_GPIO_IO_I(7),
      T => fpga_0_LEDs_8Bit_GPIO_IO_T(7)
    );

  iobuf_8 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(0),
      IO => fpga_0_SRAM_Mem_DQ_pin(0),
      O => fpga_0_SRAM_Mem_DQ_I(0),
      T => fpga_0_SRAM_Mem_DQ_T(0)
    );

  iobuf_9 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(1),
      IO => fpga_0_SRAM_Mem_DQ_pin(1),
      O => fpga_0_SRAM_Mem_DQ_I(1),
      T => fpga_0_SRAM_Mem_DQ_T(1)
    );

  iobuf_10 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(2),
      IO => fpga_0_SRAM_Mem_DQ_pin(2),
      O => fpga_0_SRAM_Mem_DQ_I(2),
      T => fpga_0_SRAM_Mem_DQ_T(2)
    );

  iobuf_11 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(3),
      IO => fpga_0_SRAM_Mem_DQ_pin(3),
      O => fpga_0_SRAM_Mem_DQ_I(3),
      T => fpga_0_SRAM_Mem_DQ_T(3)
    );

  iobuf_12 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(4),
      IO => fpga_0_SRAM_Mem_DQ_pin(4),
      O => fpga_0_SRAM_Mem_DQ_I(4),
      T => fpga_0_SRAM_Mem_DQ_T(4)
    );

  iobuf_13 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(5),
      IO => fpga_0_SRAM_Mem_DQ_pin(5),
      O => fpga_0_SRAM_Mem_DQ_I(5),
      T => fpga_0_SRAM_Mem_DQ_T(5)
    );

  iobuf_14 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(6),
      IO => fpga_0_SRAM_Mem_DQ_pin(6),
      O => fpga_0_SRAM_Mem_DQ_I(6),
      T => fpga_0_SRAM_Mem_DQ_T(6)
    );

  iobuf_15 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(7),
      IO => fpga_0_SRAM_Mem_DQ_pin(7),
      O => fpga_0_SRAM_Mem_DQ_I(7),
      T => fpga_0_SRAM_Mem_DQ_T(7)
    );

  iobuf_16 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(8),
      IO => fpga_0_SRAM_Mem_DQ_pin(8),
      O => fpga_0_SRAM_Mem_DQ_I(8),
      T => fpga_0_SRAM_Mem_DQ_T(8)
    );

  iobuf_17 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(9),
      IO => fpga_0_SRAM_Mem_DQ_pin(9),
      O => fpga_0_SRAM_Mem_DQ_I(9),
      T => fpga_0_SRAM_Mem_DQ_T(9)
    );

  iobuf_18 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(10),
      IO => fpga_0_SRAM_Mem_DQ_pin(10),
      O => fpga_0_SRAM_Mem_DQ_I(10),
      T => fpga_0_SRAM_Mem_DQ_T(10)
    );

  iobuf_19 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(11),
      IO => fpga_0_SRAM_Mem_DQ_pin(11),
      O => fpga_0_SRAM_Mem_DQ_I(11),
      T => fpga_0_SRAM_Mem_DQ_T(11)
    );

  iobuf_20 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(12),
      IO => fpga_0_SRAM_Mem_DQ_pin(12),
      O => fpga_0_SRAM_Mem_DQ_I(12),
      T => fpga_0_SRAM_Mem_DQ_T(12)
    );

  iobuf_21 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(13),
      IO => fpga_0_SRAM_Mem_DQ_pin(13),
      O => fpga_0_SRAM_Mem_DQ_I(13),
      T => fpga_0_SRAM_Mem_DQ_T(13)
    );

  iobuf_22 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(14),
      IO => fpga_0_SRAM_Mem_DQ_pin(14),
      O => fpga_0_SRAM_Mem_DQ_I(14),
      T => fpga_0_SRAM_Mem_DQ_T(14)
    );

  iobuf_23 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(15),
      IO => fpga_0_SRAM_Mem_DQ_pin(15),
      O => fpga_0_SRAM_Mem_DQ_I(15),
      T => fpga_0_SRAM_Mem_DQ_T(15)
    );

  iobuf_24 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(16),
      IO => fpga_0_SRAM_Mem_DQ_pin(16),
      O => fpga_0_SRAM_Mem_DQ_I(16),
      T => fpga_0_SRAM_Mem_DQ_T(16)
    );

  iobuf_25 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(17),
      IO => fpga_0_SRAM_Mem_DQ_pin(17),
      O => fpga_0_SRAM_Mem_DQ_I(17),
      T => fpga_0_SRAM_Mem_DQ_T(17)
    );

  iobuf_26 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(18),
      IO => fpga_0_SRAM_Mem_DQ_pin(18),
      O => fpga_0_SRAM_Mem_DQ_I(18),
      T => fpga_0_SRAM_Mem_DQ_T(18)
    );

  iobuf_27 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(19),
      IO => fpga_0_SRAM_Mem_DQ_pin(19),
      O => fpga_0_SRAM_Mem_DQ_I(19),
      T => fpga_0_SRAM_Mem_DQ_T(19)
    );

  iobuf_28 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(20),
      IO => fpga_0_SRAM_Mem_DQ_pin(20),
      O => fpga_0_SRAM_Mem_DQ_I(20),
      T => fpga_0_SRAM_Mem_DQ_T(20)
    );

  iobuf_29 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(21),
      IO => fpga_0_SRAM_Mem_DQ_pin(21),
      O => fpga_0_SRAM_Mem_DQ_I(21),
      T => fpga_0_SRAM_Mem_DQ_T(21)
    );

  iobuf_30 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(22),
      IO => fpga_0_SRAM_Mem_DQ_pin(22),
      O => fpga_0_SRAM_Mem_DQ_I(22),
      T => fpga_0_SRAM_Mem_DQ_T(22)
    );

  iobuf_31 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(23),
      IO => fpga_0_SRAM_Mem_DQ_pin(23),
      O => fpga_0_SRAM_Mem_DQ_I(23),
      T => fpga_0_SRAM_Mem_DQ_T(23)
    );

  iobuf_32 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(24),
      IO => fpga_0_SRAM_Mem_DQ_pin(24),
      O => fpga_0_SRAM_Mem_DQ_I(24),
      T => fpga_0_SRAM_Mem_DQ_T(24)
    );

  iobuf_33 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(25),
      IO => fpga_0_SRAM_Mem_DQ_pin(25),
      O => fpga_0_SRAM_Mem_DQ_I(25),
      T => fpga_0_SRAM_Mem_DQ_T(25)
    );

  iobuf_34 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(26),
      IO => fpga_0_SRAM_Mem_DQ_pin(26),
      O => fpga_0_SRAM_Mem_DQ_I(26),
      T => fpga_0_SRAM_Mem_DQ_T(26)
    );

  iobuf_35 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(27),
      IO => fpga_0_SRAM_Mem_DQ_pin(27),
      O => fpga_0_SRAM_Mem_DQ_I(27),
      T => fpga_0_SRAM_Mem_DQ_T(27)
    );

  iobuf_36 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(28),
      IO => fpga_0_SRAM_Mem_DQ_pin(28),
      O => fpga_0_SRAM_Mem_DQ_I(28),
      T => fpga_0_SRAM_Mem_DQ_T(28)
    );

  iobuf_37 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(29),
      IO => fpga_0_SRAM_Mem_DQ_pin(29),
      O => fpga_0_SRAM_Mem_DQ_I(29),
      T => fpga_0_SRAM_Mem_DQ_T(29)
    );

  iobuf_38 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(30),
      IO => fpga_0_SRAM_Mem_DQ_pin(30),
      O => fpga_0_SRAM_Mem_DQ_I(30),
      T => fpga_0_SRAM_Mem_DQ_T(30)
    );

  iobuf_39 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(31),
      IO => fpga_0_SRAM_Mem_DQ_pin(31),
      O => fpga_0_SRAM_Mem_DQ_I(31),
      T => fpga_0_SRAM_Mem_DQ_T(31)
    );

end architecture STRUCTURE;

