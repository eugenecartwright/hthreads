-------------------------------------------------------------------------------
-- plbv46_opb_bridge_0_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library plbv46_opb_bridge_v1_00_a;
use plbv46_opb_bridge_v1_00_a.all;

entity plbv46_opb_bridge_0_wrapper is
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

  attribute x_core_info : STRING;
  attribute x_core_info of plbv46_opb_bridge_0_wrapper : entity is "plbv46_opb_bridge_v1_00_a";

end plbv46_opb_bridge_0_wrapper;

architecture STRUCTURE of plbv46_opb_bridge_0_wrapper is

  component plbv46_opb_bridge is
    generic (
      C_NUM_ADDR_RNG : INTEGER;
      C_RNG0_BASEADDR : std_logic_vector;
      C_RNG0_HIGHADDR : std_logic_vector;
      C_RNG1_BASEADDR : std_logic_vector;
      C_RNG1_HIGHADDR : std_logic_vector;
      C_RNG2_BASEADDR : std_logic_vector;
      C_RNG2_HIGHADDR : std_logic_vector;
      C_RNG3_BASEADDR : std_logic_vector;
      C_RNG3_HIGHADDR : std_logic_vector;
      C_SPLB_P2P : INTEGER;
      C_SPLB_MID_WIDTH : INTEGER;
      C_SPLB_NUM_MASTERS : INTEGER;
      C_SPLB_SMALLEST_MASTER : INTEGER;
      C_SPLB_DWIDTH : INTEGER;
      C_SPLB_AWIDTH : INTEGER;
      C_BUS_CLOCK_PERIOD_RATIO : INTEGER;
      C_FAMILY : STRING
    );
    port (
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
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

begin

  plbv46_opb_bridge_0 : plbv46_opb_bridge
    generic map (
      C_NUM_ADDR_RNG => 1,
      C_RNG0_BASEADDR => X"10000000",
      C_RNG0_HIGHADDR => X"17FFFFFF",
      C_RNG1_BASEADDR => X"ffffffff",
      C_RNG1_HIGHADDR => X"00000000",
      C_RNG2_BASEADDR => X"ffffffff",
      C_RNG2_HIGHADDR => X"00000000",
      C_RNG3_BASEADDR => X"ffffffff",
      C_RNG3_HIGHADDR => X"00000000",
      C_SPLB_P2P => 0,
      C_SPLB_MID_WIDTH => 1,
      C_SPLB_NUM_MASTERS => 2,
      C_SPLB_SMALLEST_MASTER => 32,
      C_SPLB_DWIDTH => 64,
      C_SPLB_AWIDTH => 32,
      C_BUS_CLOCK_PERIOD_RATIO => 1,
      C_FAMILY => "virtex5"
    )
    port map (
      SPLB_Clk => SPLB_Clk,
      SPLB_Rst => SPLB_Rst,
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
      OPB_Clk => OPB_Clk,
      OPB_Rst => OPB_Rst,
      Mn_request => Mn_request,
      Mn_busLock => Mn_busLock,
      Mn_select => Mn_select,
      Mn_RNW => Mn_RNW,
      Mn_BE => Mn_BE,
      Mn_seqAddr => Mn_seqAddr,
      Mn_DBus => Mn_DBus,
      Mn_ABus => Mn_ABus,
      OPB_MGrant => OPB_MGrant,
      OPB_xferAck => OPB_xferAck,
      OPB_errAck => OPB_errAck,
      OPB_retry => OPB_retry,
      OPB_timeout => OPB_timeout,
      OPB_DBus => OPB_DBus
    );

end architecture STRUCTURE;

