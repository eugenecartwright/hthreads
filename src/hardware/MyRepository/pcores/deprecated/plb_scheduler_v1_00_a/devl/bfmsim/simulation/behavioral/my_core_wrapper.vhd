-------------------------------------------------------------------------------
-- my_core_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library plb_scheduler_tb_v1_00_a;
use plb_scheduler_tb_v1_00_a.all;

entity my_core_wrapper is
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
    PLB_BE : in std_logic_vector(0 to 15);
    PLB_MSize : in std_logic_vector(0 to 1);
    PLB_size : in std_logic_vector(0 to 3);
    PLB_type : in std_logic_vector(0 to 2);
    PLB_lockErr : in std_logic;
    PLB_wrDBus : in std_logic_vector(0 to 127);
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
    Sl_rdDBus : out std_logic_vector(0 to 127);
    Sl_rdWdAddr : out std_logic_vector(0 to 3);
    Sl_rdDAck : out std_logic;
    Sl_rdComp : out std_logic;
    Sl_rdBTerm : out std_logic;
    Sl_MBusy : out std_logic_vector(0 to 1);
    Sl_MWrErr : out std_logic_vector(0 to 1);
    Sl_MRdErr : out std_logic_vector(0 to 1);
    Sl_MIRQ : out std_logic_vector(0 to 1);
    MPLB_Clk : in std_logic;
    MPLB_Rst : in std_logic;
    M_request : out std_logic;
    M_priority : out std_logic_vector(0 to 1);
    M_busLock : out std_logic;
    M_RNW : out std_logic;
    M_BE : out std_logic_vector(0 to 15);
    M_MSize : out std_logic_vector(0 to 1);
    M_size : out std_logic_vector(0 to 3);
    M_type : out std_logic_vector(0 to 2);
    M_TAttribute : out std_logic_vector(0 to 15);
    M_lockErr : out std_logic;
    M_abort : out std_logic;
    M_UABus : out std_logic_vector(0 to 31);
    M_ABus : out std_logic_vector(0 to 31);
    M_wrDBus : out std_logic_vector(0 to 127);
    M_wrBurst : out std_logic;
    M_rdBurst : out std_logic;
    PLB_MAddrAck : in std_logic;
    PLB_MSSize : in std_logic_vector(0 to 1);
    PLB_MRearbitrate : in std_logic;
    PLB_MTimeout : in std_logic;
    PLB_MBusy : in std_logic;
    PLB_MRdErr : in std_logic;
    PLB_MWrErr : in std_logic;
    PLB_MIRQ : in std_logic;
    PLB_MRdDBus : in std_logic_vector(0 to 127);
    PLB_MRdWdAddr : in std_logic_vector(0 to 3);
    PLB_MRdDAck : in std_logic;
    PLB_MRdBTerm : in std_logic;
    PLB_MWrDAck : in std_logic;
    PLB_MWrBTerm : in std_logic;
    SYNCH_IN : in std_logic_vector(0 to 31);
    SYNCH_OUT : out std_logic_vector(0 to 31)
  );
end my_core_wrapper;

architecture STRUCTURE of my_core_wrapper is

  component plb_scheduler_tb is
    generic (
      C_BASEADDR : std_logic_vector;
      C_HIGHADDR : std_logic_vector;
      C_SPLB_AWIDTH : integer;
      C_SPLB_DWIDTH : integer;
      C_SPLB_NUM_MASTERS : integer;
      C_SPLB_MID_WIDTH : integer;
      C_SPLB_NATIVE_DWIDTH : integer;
      C_SPLB_P2P : integer;
      C_SPLB_SUPPORT_BURSTS : integer;
      C_SPLB_SMALLEST_MASTER : integer;
      C_SPLB_CLK_PERIOD_PS : integer;
      C_INCLUDE_DPHASE_TIMER : integer;
      C_FAMILY : string;
      C_MPLB_AWIDTH : integer;
      C_MPLB_DWIDTH : integer;
      C_MPLB_NATIVE_DWIDTH : integer;
      C_MPLB_P2P : integer;
      C_MPLB_SMALLEST_SLAVE : integer;
      C_MPLB_CLK_PERIOD_PS : integer
    );
    port (
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      PLB_ABus : in std_logic_vector(0 to (31));
      PLB_UABus : in std_logic_vector(0 to (31));
      PLB_PAValid : in std_logic;
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_masterID : in std_logic_vector(0 to (C_SPLB_MID_WIDTH-1));
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to (C_SPLB_DWIDTH/8-1));
      PLB_MSize : in std_logic_vector(0 to (1));
      PLB_size : in std_logic_vector(0 to (3));
      PLB_type : in std_logic_vector(0 to (2));
      PLB_lockErr : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to (C_SPLB_DWIDTH-1));
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to (1));
      PLB_rdPendPri : in std_logic_vector(0 to (1));
      PLB_reqPri : in std_logic_vector(0 to (1));
      PLB_TAttribute : in std_logic_vector(0 to (15));
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to (1));
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_wrBTerm : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to (C_SPLB_DWIDTH-1));
      Sl_rdWdAddr : out std_logic_vector(0 to (3));
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_rdBTerm : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to (C_SPLB_NUM_MASTERS-1));
      Sl_MWrErr : out std_logic_vector(0 to (C_SPLB_NUM_MASTERS-1));
      Sl_MRdErr : out std_logic_vector(0 to (C_SPLB_NUM_MASTERS-1));
      Sl_MIRQ : out std_logic_vector(0 to (C_SPLB_NUM_MASTERS-1));
      MPLB_Clk : in std_logic;
      MPLB_Rst : in std_logic;
      M_request : out std_logic;
      M_priority : out std_logic_vector(0 to (1));
      M_busLock : out std_logic;
      M_RNW : out std_logic;
      M_BE : out std_logic_vector(0 to (C_MPLB_DWIDTH/8-1));
      M_MSize : out std_logic_vector(0 to (1));
      M_size : out std_logic_vector(0 to (3));
      M_type : out std_logic_vector(0 to (2));
      M_TAttribute : out std_logic_vector(0 to (15));
      M_lockErr : out std_logic;
      M_abort : out std_logic;
      M_UABus : out std_logic_vector(0 to (31));
      M_ABus : out std_logic_vector(0 to (31));
      M_wrDBus : out std_logic_vector(0 to (C_MPLB_DWIDTH-1));
      M_wrBurst : out std_logic;
      M_rdBurst : out std_logic;
      PLB_MAddrAck : in std_logic;
      PLB_MSSize : in std_logic_vector(0 to (1));
      PLB_MRearbitrate : in std_logic;
      PLB_MTimeout : in std_logic;
      PLB_MBusy : in std_logic;
      PLB_MRdErr : in std_logic;
      PLB_MWrErr : in std_logic;
      PLB_MIRQ : in std_logic;
      PLB_MRdDBus : in std_logic_vector(0 to ((C_MPLB_DWIDTH-1)));
      PLB_MRdWdAddr : in std_logic_vector(0 to (3));
      PLB_MRdDAck : in std_logic;
      PLB_MRdBTerm : in std_logic;
      PLB_MWrDAck : in std_logic;
      PLB_MWrBTerm : in std_logic;
      SYNCH_IN : in std_logic_vector(0 to 31);
      SYNCH_OUT : out std_logic_vector(0 to 31)
    );
  end component;

begin

  my_core : plb_scheduler_tb
    generic map (
      C_BASEADDR => X"30000000",
      C_HIGHADDR => X"3000ffff",
      C_SPLB_AWIDTH => 32,
      C_SPLB_DWIDTH => 128,
      C_SPLB_NUM_MASTERS => 2,
      C_SPLB_MID_WIDTH => 1,
      C_SPLB_NATIVE_DWIDTH => 32,
      C_SPLB_P2P => 0,
      C_SPLB_SUPPORT_BURSTS => 0,
      C_SPLB_SMALLEST_MASTER => 32,
      C_SPLB_CLK_PERIOD_PS => 10000,
      C_INCLUDE_DPHASE_TIMER => 0,
      C_FAMILY => "virtex5",
      C_MPLB_AWIDTH => 32,
      C_MPLB_DWIDTH => 128,
      C_MPLB_NATIVE_DWIDTH => 32,
      C_MPLB_P2P => 0,
      C_MPLB_SMALLEST_SLAVE => 32,
      C_MPLB_CLK_PERIOD_PS => 10000
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
      MPLB_Clk => MPLB_Clk,
      MPLB_Rst => MPLB_Rst,
      M_request => M_request,
      M_priority => M_priority,
      M_busLock => M_busLock,
      M_RNW => M_RNW,
      M_BE => M_BE,
      M_MSize => M_MSize,
      M_size => M_size,
      M_type => M_type,
      M_TAttribute => M_TAttribute,
      M_lockErr => M_lockErr,
      M_abort => M_abort,
      M_UABus => M_UABus,
      M_ABus => M_ABus,
      M_wrDBus => M_wrDBus,
      M_wrBurst => M_wrBurst,
      M_rdBurst => M_rdBurst,
      PLB_MAddrAck => PLB_MAddrAck,
      PLB_MSSize => PLB_MSSize,
      PLB_MRearbitrate => PLB_MRearbitrate,
      PLB_MTimeout => PLB_MTimeout,
      PLB_MBusy => PLB_MBusy,
      PLB_MRdErr => PLB_MRdErr,
      PLB_MWrErr => PLB_MWrErr,
      PLB_MIRQ => PLB_MIRQ,
      PLB_MRdDBus => PLB_MRdDBus,
      PLB_MRdWdAddr => PLB_MRdWdAddr,
      PLB_MRdDAck => PLB_MRdDAck,
      PLB_MRdBTerm => PLB_MRdBTerm,
      PLB_MWrDAck => PLB_MWrDAck,
      PLB_MWrBTerm => PLB_MWrBTerm,
      SYNCH_IN => SYNCH_IN,
      SYNCH_OUT => SYNCH_OUT
    );

end architecture STRUCTURE;

