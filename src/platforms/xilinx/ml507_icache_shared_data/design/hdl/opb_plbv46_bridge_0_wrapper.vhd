-------------------------------------------------------------------------------
-- opb_plbv46_bridge_0_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library opb_plbv46_bridge_v1_00_a;
use opb_plbv46_bridge_v1_00_a.all;

entity opb_plbv46_bridge_0_wrapper is
  port (
    MPLB_Clk : in std_logic;
    MPLB_Rst : in std_logic;
    MD_Error : out std_logic;
    M_request : out std_logic;
    M_priority : out std_logic_vector(0 to 1);
    M_busLock : out std_logic;
    M_RNW : out std_logic;
    M_BE : out std_logic_vector(0 to 15);
    M_MSize : out std_logic_vector(0 to 1);
    M_size : out std_logic_vector(0 to 3);
    M_type : out std_logic_vector(0 to 2);
    M_ABus : out std_logic_vector(0 to 31);
    M_wrBurst : out std_logic;
    M_rdBurst : out std_logic;
    M_wrDBus : out std_logic_vector(0 to 127);
    PLB_MAddrAck : in std_logic;
    PLB_MSSize : in std_logic_vector(0 to 1);
    PLB_MRearbitrate : in std_logic;
    PLB_MTimeout : in std_logic;
    PLB_MRdErr : in std_logic;
    PLB_MWrErr : in std_logic;
    PLB_MRdDBus : in std_logic_vector(0 to 127);
    PLB_MRdDAck : in std_logic;
    PLB_MRdBTerm : in std_logic;
    PLB_MWrDAck : in std_logic;
    PLB_MWrBTerm : in std_logic;
    M_TAttribute : out std_logic_vector(0 to 15);
    M_lockErr : out std_logic;
    M_abort : out std_logic;
    M_UABus : out std_logic_vector(0 to 31);
    PLB_MBusy : in std_logic;
    PLB_MIRQ : in std_logic;
    PLB_MRdWdAddr : in std_logic_vector(0 to 3);
    SOPB_rst : in std_logic;
    SOPB_clk : in std_logic;
    OPB_Select : in std_logic;
    OPB_RNW : in std_logic;
    OPB_BE : in std_logic_vector(0 to 3);
    OPB_seqAddr : in std_logic;
    OPB_DBus : in std_logic_vector(0 to 31);
    OPB_ABus : in std_logic_vector(0 to 31);
    Sl_xferAck : out std_logic;
    Sl_errAck : out std_logic;
    Sl_retry : out std_logic;
    Sl_ToutSup : out std_logic;
    Sl_DBus : out std_logic_vector(0 to 31)
  );

  attribute x_core_info : STRING;
  attribute x_core_info of opb_plbv46_bridge_0_wrapper : entity is "opb_plbv46_bridge_v1_00_a";

end opb_plbv46_bridge_0_wrapper;

architecture STRUCTURE of opb_plbv46_bridge_0_wrapper is

  component opb_plbv46_bridge is
    generic (
      C_NUM_ADDR_RNG : INTEGER;
      C_RNG0_BASEADDR : std_logic_vector(0 to 31);
      C_RNG0_HIGHADDR : std_logic_vector(0 to 31);
      C_RNG1_BASEADDR : std_logic_vector(0 to 31);
      C_RNG1_HIGHADDR : std_logic_vector(0 to 31);
      C_RNG2_BASEADDR : std_logic_vector(0 to 31);
      C_RNG2_HIGHADDR : std_logic_vector(0 to 31);
      C_RNG3_BASEADDR : std_logic_vector(0 to 31);
      C_RNG3_HIGHADDR : std_logic_vector(0 to 31);
      C_BUS_CLOCK_PERIOD_RATIO : INTEGER;
      C_PREFETCH_TIMEOUT : INTEGER;
      C_MPLB_AWIDTH : INTEGER;
      C_MPLB_DWIDTH : INTEGER;
      C_MPLB_NATIVE_DWIDTH : INTEGER;
      C_FAMILY : STRING
    );
    port (
      MPLB_Clk : in std_logic;
      MPLB_Rst : in std_logic;
      MD_Error : out std_logic;
      M_request : out std_logic;
      M_priority : out std_logic_vector(0 to 1);
      M_busLock : out std_logic;
      M_RNW : out std_logic;
      M_BE : out std_logic_vector(0 to ((C_MPLB_DWIDTH/8)-1));
      M_MSize : out std_logic_vector(0 to 1);
      M_size : out std_logic_vector(0 to 3);
      M_type : out std_logic_vector(0 to 2);
      M_ABus : out std_logic_vector(0 to 31);
      M_wrBurst : out std_logic;
      M_rdBurst : out std_logic;
      M_wrDBus : out std_logic_vector(0 to (C_MPLB_DWIDTH-1));
      PLB_MAddrAck : in std_logic;
      PLB_MSSize : in std_logic_vector(0 to 1);
      PLB_MRearbitrate : in std_logic;
      PLB_MTimeout : in std_logic;
      PLB_MRdErr : in std_logic;
      PLB_MWrErr : in std_logic;
      PLB_MRdDBus : in std_logic_vector(0 to (C_MPLB_DWIDTH-1));
      PLB_MRdDAck : in std_logic;
      PLB_MRdBTerm : in std_logic;
      PLB_MWrDAck : in std_logic;
      PLB_MWrBTerm : in std_logic;
      M_TAttribute : out std_logic_vector(0 to 15);
      M_lockErr : out std_logic;
      M_abort : out std_logic;
      M_UABus : out std_logic_vector(0 to 31);
      PLB_MBusy : in std_logic;
      PLB_MIRQ : in std_logic;
      PLB_MRdWdAddr : in std_logic_vector(0 to 3);
      SOPB_rst : in std_logic;
      SOPB_clk : in std_logic;
      OPB_Select : in std_logic;
      OPB_RNW : in std_logic;
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_seqAddr : in std_logic;
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_ABus : in std_logic_vector(0 to 31);
      Sl_xferAck : out std_logic;
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_ToutSup : out std_logic;
      Sl_DBus : out std_logic_vector(0 to 31)
    );
  end component;

begin

  opb_plbv46_bridge_0 : opb_plbv46_bridge
    generic map (
      C_NUM_ADDR_RNG => 1,
      C_RNG0_BASEADDR => X"A0000000",
      C_RNG0_HIGHADDR => X"BFFFFFFF",
      C_RNG1_BASEADDR => X"ffffffff",
      C_RNG1_HIGHADDR => X"00000000",
      C_RNG2_BASEADDR => X"ffffffff",
      C_RNG2_HIGHADDR => X"00000000",
      C_RNG3_BASEADDR => X"ffffffff",
      C_RNG3_HIGHADDR => X"00000000",
      C_BUS_CLOCK_PERIOD_RATIO => 1,
      C_PREFETCH_TIMEOUT => 10,
      C_MPLB_AWIDTH => 32,
      C_MPLB_DWIDTH => 128,
      C_MPLB_NATIVE_DWIDTH => 32,
      C_FAMILY => "virtex5"
    )
    port map (
      MPLB_Clk => MPLB_Clk,
      MPLB_Rst => MPLB_Rst,
      MD_Error => MD_Error,
      M_request => M_request,
      M_priority => M_priority,
      M_busLock => M_busLock,
      M_RNW => M_RNW,
      M_BE => M_BE,
      M_MSize => M_MSize,
      M_size => M_size,
      M_type => M_type,
      M_ABus => M_ABus,
      M_wrBurst => M_wrBurst,
      M_rdBurst => M_rdBurst,
      M_wrDBus => M_wrDBus,
      PLB_MAddrAck => PLB_MAddrAck,
      PLB_MSSize => PLB_MSSize,
      PLB_MRearbitrate => PLB_MRearbitrate,
      PLB_MTimeout => PLB_MTimeout,
      PLB_MRdErr => PLB_MRdErr,
      PLB_MWrErr => PLB_MWrErr,
      PLB_MRdDBus => PLB_MRdDBus,
      PLB_MRdDAck => PLB_MRdDAck,
      PLB_MRdBTerm => PLB_MRdBTerm,
      PLB_MWrDAck => PLB_MWrDAck,
      PLB_MWrBTerm => PLB_MWrBTerm,
      M_TAttribute => M_TAttribute,
      M_lockErr => M_lockErr,
      M_abort => M_abort,
      M_UABus => M_UABus,
      PLB_MBusy => PLB_MBusy,
      PLB_MIRQ => PLB_MIRQ,
      PLB_MRdWdAddr => PLB_MRdWdAddr,
      SOPB_rst => SOPB_rst,
      SOPB_clk => SOPB_clk,
      OPB_Select => OPB_Select,
      OPB_RNW => OPB_RNW,
      OPB_BE => OPB_BE,
      OPB_seqAddr => OPB_seqAddr,
      OPB_DBus => OPB_DBus,
      OPB_ABus => OPB_ABus,
      Sl_xferAck => Sl_xferAck,
      Sl_errAck => Sl_errAck,
      Sl_retry => Sl_retry,
      Sl_ToutSup => Sl_ToutSup,
      Sl_DBus => Sl_DBus
    );

end architecture STRUCTURE;

