-------------------------------------------------------------------------------
-- synch_manager_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library opb_SynchManager_v1_00_c;
use opb_SynchManager_v1_00_c.all;

entity synch_manager_wrapper is
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

  attribute x_core_info : STRING;
  attribute x_core_info of synch_manager_wrapper : entity is "opb_SynchManager_v1_00_c";

end synch_manager_wrapper;

architecture STRUCTURE of synch_manager_wrapper is

  component opb_synchmanager is
    generic (
      C_BASEADDR : std_logic_vector;
      C_HIGHADDR : std_logic_vector;
      C_NUM_THREADS : integer;
      C_NUM_MUTEXES : integer;
      C_SCHED_BADDR : std_logic_vector;
      C_SCHED_HADDR : std_logic_vector;
      C_OPB_AWIDTH : INTEGER;
      C_OPB_DWIDTH : INTEGER;
      C_FAMILY : STRING
    );
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to (C_OPB_DWIDTH-1));
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to (C_OPB_AWIDTH-1));
      OPB_BE : in std_logic_vector(0 to ((C_OPB_DWIDTH/8)-1));
      OPB_DBus : in std_logic_vector(0 to (C_OPB_DWIDTH-1));
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      M_ABus : out std_logic_vector(0 to (C_OPB_AWIDTH-1));
      M_BE : out std_logic_vector(0 to ((C_OPB_DWIDTH/8)-1));
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

begin

  synch_manager : opb_synchmanager
    generic map (
      C_BASEADDR => X"13000000",
      C_HIGHADDR => X"13FFFFFF",
      C_NUM_THREADS => 256,
      C_NUM_MUTEXES => 64,
      C_SCHED_BADDR => X"11000000",
      C_SCHED_HADDR => X"1100ffff",
      C_OPB_AWIDTH => 32,
      C_OPB_DWIDTH => 32,
      C_FAMILY => "virtex5"
    )
    port map (
      OPB_Clk => OPB_Clk,
      OPB_Rst => OPB_Rst,
      Sl_DBus => Sl_DBus,
      Sl_errAck => Sl_errAck,
      Sl_retry => Sl_retry,
      Sl_toutSup => Sl_toutSup,
      Sl_xferAck => Sl_xferAck,
      OPB_ABus => OPB_ABus,
      OPB_BE => OPB_BE,
      OPB_DBus => OPB_DBus,
      OPB_RNW => OPB_RNW,
      OPB_select => OPB_select,
      OPB_seqAddr => OPB_seqAddr,
      M_ABus => M_ABus,
      M_BE => M_BE,
      M_busLock => M_busLock,
      M_request => M_request,
      M_RNW => M_RNW,
      M_select => M_select,
      M_seqAddr => M_seqAddr,
      OPB_errAck => OPB_errAck,
      OPB_MGrant => OPB_MGrant,
      OPB_retry => OPB_retry,
      OPB_timeout => OPB_timeout,
      OPB_xferAck => OPB_xferAck,
      system_reset => system_reset,
      system_resetdone => system_resetdone
    );

end architecture STRUCTURE;

