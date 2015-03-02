-------------------------------------------------------------------------------
-- my_core_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library plb_thread_manager_tb_v1_00_a;
use plb_thread_manager_tb_v1_00_a.all;

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
    Sl_MBusy : out std_logic_vector(0 to 0);
    Sl_MWrErr : out std_logic_vector(0 to 0);
    Sl_MRdErr : out std_logic_vector(0 to 0);
    Sl_MIRQ : out std_logic_vector(0 to 0);
    SYNCH_IN : in std_logic_vector(0 to 31);
    SYNCH_OUT : out std_logic_vector(0 to 31)
  );
end my_core_wrapper;

architecture STRUCTURE of my_core_wrapper is

  component plb_thread_manager_tb is
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
      C_FAMILY : string
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
      SYNCH_IN : in std_logic_vector(0 to 31);
      SYNCH_OUT : out std_logic_vector(0 to 31)
    );
  end component;

begin

  my_core : plb_thread_manager_tb
    generic map (
      C_BASEADDR => X"30000000",
      C_HIGHADDR => X"3000ffff",
      C_SPLB_AWIDTH => 32,
      C_SPLB_DWIDTH => 128,
      C_SPLB_NUM_MASTERS => 1,
      C_SPLB_MID_WIDTH => 1,
      C_SPLB_NATIVE_DWIDTH => 32,
      C_SPLB_P2P => 0,
      C_SPLB_SUPPORT_BURSTS => 0,
      C_SPLB_SMALLEST_MASTER => 128,
      C_SPLB_CLK_PERIOD_PS => 10000,
      C_INCLUDE_DPHASE_TIMER => 0,
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
      SYNCH_IN => SYNCH_IN,
      SYNCH_OUT => SYNCH_OUT
    );

end architecture STRUCTURE;

