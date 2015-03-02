-------------------------------------------------------------------------------
-- sram_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library xps_mch_emc_v2_00_a;
use xps_mch_emc_v2_00_a.all;

entity sram_wrapper is
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

  attribute x_core_info : STRING;
  attribute x_core_info of sram_wrapper : entity is "xps_mch_emc_v2_00_a";

end sram_wrapper;

architecture STRUCTURE of sram_wrapper is

  component xps_mch_emc is
    generic (
      C_FAMILY : STRING;
      C_NUM_BANKS_MEM : INTEGER;
      C_NUM_CHANNELS : INTEGER;
      C_PRIORITY_MODE : INTEGER;
      C_INCLUDE_PLB_IPIF : INTEGER;
      C_INCLUDE_WRBUF : INTEGER;
      C_SPLB_MID_WIDTH : INTEGER;
      C_SPLB_NUM_MASTERS : INTEGER;
      C_SPLB_P2P : INTEGER;
      C_SPLB_DWIDTH : INTEGER;
      C_MCH_SPLB_AWIDTH : INTEGER;
      C_SPLB_SMALLEST_MASTER : INTEGER;
      C_MCH_NATIVE_DWIDTH : INTEGER;
      C_MCH_PLB_CLK_PERIOD_PS : INTEGER;
      C_MEM0_BASEADDR : std_logic_vector;
      C_MEM0_HIGHADDR : std_logic_vector;
      C_MEM1_BASEADDR : std_logic_vector;
      C_MEM1_HIGHADDR : std_logic_vector;
      C_MEM2_BASEADDR : std_logic_vector;
      C_MEM2_HIGHADDR : std_logic_vector;
      C_MEM3_BASEADDR : std_logic_vector;
      C_MEM3_HIGHADDR : std_logic_vector;
      C_INCLUDE_NEGEDGE_IOREGS : INTEGER;
      C_MEM0_WIDTH : INTEGER;
      C_MEM1_WIDTH : INTEGER;
      C_MEM2_WIDTH : INTEGER;
      C_MEM3_WIDTH : INTEGER;
      C_MAX_MEM_WIDTH : INTEGER;
      C_INCLUDE_DATAWIDTH_MATCHING_0 : INTEGER;
      C_INCLUDE_DATAWIDTH_MATCHING_1 : INTEGER;
      C_INCLUDE_DATAWIDTH_MATCHING_2 : INTEGER;
      C_INCLUDE_DATAWIDTH_MATCHING_3 : INTEGER;
      C_SYNCH_MEM_0 : INTEGER;
      C_SYNCH_PIPEDELAY_0 : INTEGER;
      C_TCEDV_PS_MEM_0 : INTEGER;
      C_TAVDV_PS_MEM_0 : INTEGER;
      C_THZCE_PS_MEM_0 : INTEGER;
      C_THZOE_PS_MEM_0 : INTEGER;
      C_TWC_PS_MEM_0 : INTEGER;
      C_TWP_PS_MEM_0 : INTEGER;
      C_TLZWE_PS_MEM_0 : INTEGER;
      C_SYNCH_MEM_1 : INTEGER;
      C_SYNCH_PIPEDELAY_1 : INTEGER;
      C_TCEDV_PS_MEM_1 : INTEGER;
      C_TAVDV_PS_MEM_1 : INTEGER;
      C_THZCE_PS_MEM_1 : INTEGER;
      C_THZOE_PS_MEM_1 : INTEGER;
      C_TWC_PS_MEM_1 : INTEGER;
      C_TWP_PS_MEM_1 : INTEGER;
      C_TLZWE_PS_MEM_1 : INTEGER;
      C_SYNCH_MEM_2 : INTEGER;
      C_SYNCH_PIPEDELAY_2 : INTEGER;
      C_TCEDV_PS_MEM_2 : INTEGER;
      C_TAVDV_PS_MEM_2 : INTEGER;
      C_THZCE_PS_MEM_2 : INTEGER;
      C_THZOE_PS_MEM_2 : INTEGER;
      C_TWC_PS_MEM_2 : INTEGER;
      C_TWP_PS_MEM_2 : INTEGER;
      C_TLZWE_PS_MEM_2 : INTEGER;
      C_SYNCH_MEM_3 : INTEGER;
      C_SYNCH_PIPEDELAY_3 : INTEGER;
      C_TCEDV_PS_MEM_3 : INTEGER;
      C_TAVDV_PS_MEM_3 : INTEGER;
      C_THZCE_PS_MEM_3 : INTEGER;
      C_THZOE_PS_MEM_3 : INTEGER;
      C_TWC_PS_MEM_3 : INTEGER;
      C_TWP_PS_MEM_3 : INTEGER;
      C_TLZWE_PS_MEM_3 : INTEGER;
      C_MCH0_PROTOCOL : INTEGER;
      C_MCH0_ACCESSBUF_DEPTH : INTEGER;
      C_MCH0_RDDATABUF_DEPTH : INTEGER;
      C_MCH1_PROTOCOL : INTEGER;
      C_MCH1_ACCESSBUF_DEPTH : INTEGER;
      C_MCH1_RDDATABUF_DEPTH : INTEGER;
      C_MCH2_PROTOCOL : INTEGER;
      C_MCH2_ACCESSBUF_DEPTH : INTEGER;
      C_MCH2_RDDATABUF_DEPTH : INTEGER;
      C_MCH3_PROTOCOL : INTEGER;
      C_MCH3_ACCESSBUF_DEPTH : INTEGER;
      C_MCH3_RDDATABUF_DEPTH : INTEGER;
      C_XCL0_LINESIZE : INTEGER;
      C_XCL0_WRITEXFER : INTEGER;
      C_XCL1_LINESIZE : INTEGER;
      C_XCL1_WRITEXFER : INTEGER;
      C_XCL2_LINESIZE : INTEGER;
      C_XCL2_WRITEXFER : INTEGER;
      C_XCL3_LINESIZE : INTEGER;
      C_XCL3_WRITEXFER : INTEGER
    );
    port (
      MCH_PLB_Clk : in std_logic;
      RdClk : in std_logic;
      MCH_PLB_Rst : in std_logic;
      MCH0_Access_Control : in std_logic;
      MCH0_Access_Data : in std_logic_vector(0 to (C_MCH_NATIVE_DWIDTH-1));
      MCH0_Access_Write : in std_logic;
      MCH0_Access_Full : out std_logic;
      MCH0_ReadData_Control : out std_logic;
      MCH0_ReadData_Data : out std_logic_vector(0 to (C_MCH_NATIVE_DWIDTH-1));
      MCH0_ReadData_Read : in std_logic;
      MCH0_ReadData_Exists : out std_logic;
      MCH1_Access_Control : in std_logic;
      MCH1_Access_Data : in std_logic_vector(0 to (C_MCH_NATIVE_DWIDTH-1));
      MCH1_Access_Write : in std_logic;
      MCH1_Access_Full : out std_logic;
      MCH1_ReadData_Control : out std_logic;
      MCH1_ReadData_Data : out std_logic_vector(0 to (C_MCH_NATIVE_DWIDTH-1));
      MCH1_ReadData_Read : in std_logic;
      MCH1_ReadData_Exists : out std_logic;
      MCH2_Access_Control : in std_logic;
      MCH2_Access_Data : in std_logic_vector(0 to (C_MCH_NATIVE_DWIDTH-1));
      MCH2_Access_Write : in std_logic;
      MCH2_Access_Full : out std_logic;
      MCH2_ReadData_Control : out std_logic;
      MCH2_ReadData_Data : out std_logic_vector(0 to (C_MCH_NATIVE_DWIDTH-1));
      MCH2_ReadData_Read : in std_logic;
      MCH2_ReadData_Exists : out std_logic;
      MCH3_Access_Control : in std_logic;
      MCH3_Access_Data : in std_logic_vector(0 to (C_MCH_NATIVE_DWIDTH-1));
      MCH3_Access_Write : in std_logic;
      MCH3_Access_Full : out std_logic;
      MCH3_ReadData_Control : out std_logic;
      MCH3_ReadData_Data : out std_logic_vector(0 to (C_MCH_NATIVE_DWIDTH-1));
      MCH3_ReadData_Read : in std_logic;
      MCH3_ReadData_Exists : out std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_masterID : in std_logic_vector(0 to (C_SPLB_MID_WIDTH-1));
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to ((C_SPLB_DWIDTH/8)-1));
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_lockErr : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to (C_SPLB_DWIDTH-1));
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
      Sl_rdDBus : out std_logic_vector(0 to (C_SPLB_DWIDTH-1));
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_rdBTerm : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to (C_SPLB_NUM_MASTERS-1));
      Sl_MWrErr : out std_logic_vector(0 to (C_SPLB_NUM_MASTERS-1));
      Sl_MRdErr : out std_logic_vector(0 to (C_SPLB_NUM_MASTERS-1));
      Sl_MIRQ : out std_logic_vector(0 to (C_SPLB_NUM_MASTERS-1));
      Mem_DQ_I : in std_logic_vector(0 to (C_MAX_MEM_WIDTH-1));
      Mem_DQ_O : out std_logic_vector(0 to (C_MAX_MEM_WIDTH-1));
      Mem_DQ_T : out std_logic_vector(0 to (C_MAX_MEM_WIDTH-1));
      Mem_A : out std_logic_vector(0 to (C_MCH_SPLB_AWIDTH-1));
      Mem_RPN : out std_logic;
      Mem_CEN : out std_logic_vector(0 to (C_NUM_BANKS_MEM-1));
      Mem_OEN : out std_logic_vector(0 to (C_NUM_BANKS_MEM-1));
      Mem_WEN : out std_logic;
      Mem_QWEN : out std_logic_vector(0 to ((C_MAX_MEM_WIDTH/8)-1));
      Mem_BEN : out std_logic_vector(0 to ((C_MAX_MEM_WIDTH/8)-1));
      Mem_CE : out std_logic_vector(0 to (C_NUM_BANKS_MEM-1));
      Mem_ADV_LDN : out std_logic;
      Mem_LBON : out std_logic;
      Mem_CKEN : out std_logic;
      Mem_RNW : out std_logic
    );
  end component;

begin

  SRAM : xps_mch_emc
    generic map (
      C_FAMILY => "virtex5",
      C_NUM_BANKS_MEM => 1,
      C_NUM_CHANNELS => 0,
      C_PRIORITY_MODE => 0,
      C_INCLUDE_PLB_IPIF => 1,
      C_INCLUDE_WRBUF => 1,
      C_SPLB_MID_WIDTH => 1,
      C_SPLB_NUM_MASTERS => 2,
      C_SPLB_P2P => 0,
      C_SPLB_DWIDTH => 64,
      C_MCH_SPLB_AWIDTH => 32,
      C_SPLB_SMALLEST_MASTER => 32,
      C_MCH_NATIVE_DWIDTH => 32,
      C_MCH_PLB_CLK_PERIOD_PS => 8000,
      C_MEM0_BASEADDR => X"8a300000",
      C_MEM0_HIGHADDR => X"8a3fffff",
      C_MEM1_BASEADDR => X"ffffffff",
      C_MEM1_HIGHADDR => X"00000000",
      C_MEM2_BASEADDR => X"ffffffff",
      C_MEM2_HIGHADDR => X"00000000",
      C_MEM3_BASEADDR => X"ffffffff",
      C_MEM3_HIGHADDR => X"00000000",
      C_INCLUDE_NEGEDGE_IOREGS => 0,
      C_MEM0_WIDTH => 32,
      C_MEM1_WIDTH => 32,
      C_MEM2_WIDTH => 32,
      C_MEM3_WIDTH => 32,
      C_MAX_MEM_WIDTH => 32,
      C_INCLUDE_DATAWIDTH_MATCHING_0 => 0,
      C_INCLUDE_DATAWIDTH_MATCHING_1 => 0,
      C_INCLUDE_DATAWIDTH_MATCHING_2 => 0,
      C_INCLUDE_DATAWIDTH_MATCHING_3 => 0,
      C_SYNCH_MEM_0 => 1,
      C_SYNCH_PIPEDELAY_0 => 2,
      C_TCEDV_PS_MEM_0 => 0,
      C_TAVDV_PS_MEM_0 => 0,
      C_THZCE_PS_MEM_0 => 0,
      C_THZOE_PS_MEM_0 => 0,
      C_TWC_PS_MEM_0 => 0,
      C_TWP_PS_MEM_0 => 0,
      C_TLZWE_PS_MEM_0 => 0,
      C_SYNCH_MEM_1 => 0,
      C_SYNCH_PIPEDELAY_1 => 2,
      C_TCEDV_PS_MEM_1 => 15000,
      C_TAVDV_PS_MEM_1 => 15000,
      C_THZCE_PS_MEM_1 => 7000,
      C_THZOE_PS_MEM_1 => 7000,
      C_TWC_PS_MEM_1 => 15000,
      C_TWP_PS_MEM_1 => 12000,
      C_TLZWE_PS_MEM_1 => 0,
      C_SYNCH_MEM_2 => 0,
      C_SYNCH_PIPEDELAY_2 => 2,
      C_TCEDV_PS_MEM_2 => 15000,
      C_TAVDV_PS_MEM_2 => 15000,
      C_THZCE_PS_MEM_2 => 7000,
      C_THZOE_PS_MEM_2 => 7000,
      C_TWC_PS_MEM_2 => 15000,
      C_TWP_PS_MEM_2 => 12000,
      C_TLZWE_PS_MEM_2 => 0,
      C_SYNCH_MEM_3 => 0,
      C_SYNCH_PIPEDELAY_3 => 2,
      C_TCEDV_PS_MEM_3 => 15000,
      C_TAVDV_PS_MEM_3 => 15000,
      C_THZCE_PS_MEM_3 => 7000,
      C_THZOE_PS_MEM_3 => 7000,
      C_TWC_PS_MEM_3 => 15000,
      C_TWP_PS_MEM_3 => 12000,
      C_TLZWE_PS_MEM_3 => 0,
      C_MCH0_PROTOCOL => 0,
      C_MCH0_ACCESSBUF_DEPTH => 16,
      C_MCH0_RDDATABUF_DEPTH => 16,
      C_MCH1_PROTOCOL => 0,
      C_MCH1_ACCESSBUF_DEPTH => 16,
      C_MCH1_RDDATABUF_DEPTH => 16,
      C_MCH2_PROTOCOL => 0,
      C_MCH2_ACCESSBUF_DEPTH => 16,
      C_MCH2_RDDATABUF_DEPTH => 16,
      C_MCH3_PROTOCOL => 0,
      C_MCH3_ACCESSBUF_DEPTH => 16,
      C_MCH3_RDDATABUF_DEPTH => 16,
      C_XCL0_LINESIZE => 4,
      C_XCL0_WRITEXFER => 1,
      C_XCL1_LINESIZE => 4,
      C_XCL1_WRITEXFER => 1,
      C_XCL2_LINESIZE => 4,
      C_XCL2_WRITEXFER => 1,
      C_XCL3_LINESIZE => 4,
      C_XCL3_WRITEXFER => 1
    )
    port map (
      MCH_PLB_Clk => MCH_PLB_Clk,
      RdClk => RdClk,
      MCH_PLB_Rst => MCH_PLB_Rst,
      MCH0_Access_Control => MCH0_Access_Control,
      MCH0_Access_Data => MCH0_Access_Data,
      MCH0_Access_Write => MCH0_Access_Write,
      MCH0_Access_Full => MCH0_Access_Full,
      MCH0_ReadData_Control => MCH0_ReadData_Control,
      MCH0_ReadData_Data => MCH0_ReadData_Data,
      MCH0_ReadData_Read => MCH0_ReadData_Read,
      MCH0_ReadData_Exists => MCH0_ReadData_Exists,
      MCH1_Access_Control => MCH1_Access_Control,
      MCH1_Access_Data => MCH1_Access_Data,
      MCH1_Access_Write => MCH1_Access_Write,
      MCH1_Access_Full => MCH1_Access_Full,
      MCH1_ReadData_Control => MCH1_ReadData_Control,
      MCH1_ReadData_Data => MCH1_ReadData_Data,
      MCH1_ReadData_Read => MCH1_ReadData_Read,
      MCH1_ReadData_Exists => MCH1_ReadData_Exists,
      MCH2_Access_Control => MCH2_Access_Control,
      MCH2_Access_Data => MCH2_Access_Data,
      MCH2_Access_Write => MCH2_Access_Write,
      MCH2_Access_Full => MCH2_Access_Full,
      MCH2_ReadData_Control => MCH2_ReadData_Control,
      MCH2_ReadData_Data => MCH2_ReadData_Data,
      MCH2_ReadData_Read => MCH2_ReadData_Read,
      MCH2_ReadData_Exists => MCH2_ReadData_Exists,
      MCH3_Access_Control => MCH3_Access_Control,
      MCH3_Access_Data => MCH3_Access_Data,
      MCH3_Access_Write => MCH3_Access_Write,
      MCH3_Access_Full => MCH3_Access_Full,
      MCH3_ReadData_Control => MCH3_ReadData_Control,
      MCH3_ReadData_Data => MCH3_ReadData_Data,
      MCH3_ReadData_Read => MCH3_ReadData_Read,
      MCH3_ReadData_Exists => MCH3_ReadData_Exists,
      PLB_ABus => PLB_ABus,
      PLB_UABus => PLB_UABus,
      PLB_PAValid => PLB_PAValid,
      PLB_SAValid => PLB_SAValid,
      PLB_rdPrim => PLB_rdPrim,
      PLB_wrPrim => PLB_wrPrim,
      PLB_masterID => PLB_masterID,
      PLB_abort => PLB_abort,
      PLB_busLock => PLB_busLock,
      PLB_RNW => PLB_RNW,
      PLB_BE => PLB_BE,
      PLB_MSize => PLB_MSize,
      PLB_size => PLB_size,
      PLB_type => PLB_type,
      PLB_lockErr => PLB_lockErr,
      PLB_wrDBus => PLB_wrDBus,
      PLB_wrBurst => PLB_wrBurst,
      PLB_rdBurst => PLB_rdBurst,
      PLB_wrPendReq => PLB_wrPendReq,
      PLB_rdPendReq => PLB_rdPendReq,
      PLB_wrPendPri => PLB_wrPendPri,
      PLB_rdPendPri => PLB_rdPendPri,
      PLB_reqPri => PLB_reqPri,
      PLB_TAttribute => PLB_TAttribute,
      Sl_addrAck => Sl_addrAck,
      Sl_SSize => Sl_SSize,
      Sl_wait => Sl_wait,
      Sl_rearbitrate => Sl_rearbitrate,
      Sl_wrDAck => Sl_wrDAck,
      Sl_wrComp => Sl_wrComp,
      Sl_wrBTerm => Sl_wrBTerm,
      Sl_rdDBus => Sl_rdDBus,
      Sl_rdWdAddr => Sl_rdWdAddr,
      Sl_rdDAck => Sl_rdDAck,
      Sl_rdComp => Sl_rdComp,
      Sl_rdBTerm => Sl_rdBTerm,
      Sl_MBusy => Sl_MBusy,
      Sl_MWrErr => Sl_MWrErr,
      Sl_MRdErr => Sl_MRdErr,
      Sl_MIRQ => Sl_MIRQ,
      Mem_DQ_I => Mem_DQ_I,
      Mem_DQ_O => Mem_DQ_O,
      Mem_DQ_T => Mem_DQ_T,
      Mem_A => Mem_A,
      Mem_RPN => Mem_RPN,
      Mem_CEN => Mem_CEN,
      Mem_OEN => Mem_OEN,
      Mem_WEN => Mem_WEN,
      Mem_QWEN => Mem_QWEN,
      Mem_BEN => Mem_BEN,
      Mem_CE => Mem_CE,
      Mem_ADV_LDN => Mem_ADV_LDN,
      Mem_LBON => Mem_LBON,
      Mem_CKEN => Mem_CKEN,
      Mem_RNW => Mem_RNW
    );

end architecture STRUCTURE;

