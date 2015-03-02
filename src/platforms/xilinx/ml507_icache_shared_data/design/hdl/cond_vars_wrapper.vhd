-------------------------------------------------------------------------------
-- cond_vars_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library opb_blk_mcvar_v1_00_b;
use opb_blk_mcvar_v1_00_b.all;

entity cond_vars_wrapper is
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

  attribute x_core_info : STRING;
  attribute x_core_info of cond_vars_wrapper : entity is "opb_blk_mcvar_v1_00_b";

end cond_vars_wrapper;

architecture STRUCTURE of cond_vars_wrapper is

  component opb_blk_mcvar is
    generic (
      C_DEVICE_ID : integer;
      C_IP_MASTER_PRESENT : integer;
      C_SEMA_INTR_ADDR : std_logic_vector;
      C_SWTHR_BASE_ADDR : std_logic_vector;
      C_HWTHR_BASE_ADDR : std_logic_vector;
      C_DEV_BURST_ENABLE : integer;
      C_OPB_CLK_PERIOD_PS : integer;
      C_DEV_BLK_ID : integer;
      C_DEV_MIR_ENABLE : integer;
      C_BASEADDR : std_logic_vector;
      C_HIGHADDR : std_logic_vector;
      C_OPB_AWIDTH : integer;
      C_OPB_DWIDTH : integer;
      C_FAMILY : string
    );
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Interrupt : out std_logic;
      IP2Bus_IntrEvent : in std_logic_vector(0 to 0);
      OPB_ABus : in std_logic_vector(0 to C_OPB_AWIDTH-1);
      OPB_DBus : in std_logic_vector(0 to C_OPB_DWIDTH-1);
      OPB_BE : in std_logic_vector(0 to C_OPB_DWIDTH/8-1);
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
      Mn_BE : out std_logic_vector(0 to C_OPB_DWIDTH/8-1);
      Mn_seqAddr : out std_logic;
      Mn_ABus : out std_logic_vector(0 to C_OPB_AWIDTH-1);
      Sln_xferAck : out std_logic;
      Sln_errAck : out std_logic;
      Sln_retry : out std_logic;
      Sln_toutSup : out std_logic;
      Sln_DBus : out std_logic_vector(0 to C_OPB_DWIDTH-1);
      Sema_Reset : in std_logic;
      Sema_Rst_Ack : out std_logic
    );
  end component;

begin

  cond_vars : opb_blk_mcvar
    generic map (
      C_DEVICE_ID => 300,
      C_IP_MASTER_PRESENT => 1,
      C_SEMA_INTR_ADDR => X"04000014",
      C_SWTHR_BASE_ADDR => X"11001000",
      C_HWTHR_BASE_ADDR => X"11001000",
      C_DEV_BURST_ENABLE => 0,
      C_OPB_CLK_PERIOD_PS => 10000,
      C_DEV_BLK_ID => 1,
      C_DEV_MIR_ENABLE => 0,
      C_BASEADDR => X"11100000",
      C_HIGHADDR => X"1117FFFF",
      C_OPB_AWIDTH => 32,
      C_OPB_DWIDTH => 32,
      C_FAMILY => "virtex5"
    )
    port map (
      OPB_Clk => OPB_Clk,
      OPB_Rst => OPB_Rst,
      Interrupt => Interrupt,
      IP2Bus_IntrEvent => IP2Bus_IntrEvent,
      OPB_ABus => OPB_ABus,
      OPB_DBus => OPB_DBus,
      OPB_BE => OPB_BE,
      OPB_RNW => OPB_RNW,
      OPB_select => OPB_select,
      OPB_seqAddr => OPB_seqAddr,
      OPB_errAck => OPB_errAck,
      OPB_MnGrant => OPB_MnGrant,
      OPB_retry => OPB_retry,
      OPB_timeout => OPB_timeout,
      OPB_xferAck => OPB_xferAck,
      Mn_request => Mn_request,
      Mn_busLock => Mn_busLock,
      Mn_select => Mn_select,
      Mn_RNW => Mn_RNW,
      Mn_BE => Mn_BE,
      Mn_seqAddr => Mn_seqAddr,
      Mn_ABus => Mn_ABus,
      Sln_xferAck => Sln_xferAck,
      Sln_errAck => Sln_errAck,
      Sln_retry => Sln_retry,
      Sln_toutSup => Sln_toutSup,
      Sln_DBus => Sln_DBus,
      Sema_Reset => Sema_Reset,
      Sema_Rst_Ack => Sema_Rst_Ack
    );

end architecture STRUCTURE;

