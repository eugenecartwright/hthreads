-------------------------------------------------------------------------------
-- scheduler_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library opb_Scheduler_Master_v1_00_a;
use opb_Scheduler_Master_v1_00_a.all;

entity scheduler_wrapper is
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

  attribute x_core_info : STRING;
  attribute x_core_info of scheduler_wrapper : entity is "opb_Scheduler_Master_v1_00_a";

end scheduler_wrapper;

architecture STRUCTURE of scheduler_wrapper is

  component opb_scheduler_master is
    generic (
      C_BASEADDR : std_logic_vector;
      C_HIGHADDR : std_logic_vector;
      C_OPB_AWIDTH : INTEGER;
      C_OPB_DWIDTH : INTEGER;
      C_FAMILY : STRING
    );
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
      OPB_xferAck : in std_logic
    );
  end component;

begin

  scheduler : opb_scheduler_master
    generic map (
      C_BASEADDR => X"12000000",
      C_HIGHADDR => X"12ffffff",
      C_OPB_AWIDTH => 32,
      C_OPB_DWIDTH => 32,
      C_FAMILY => "virtex5"
    )
    port map (
      Soft_Reset => Soft_Reset,
      Reset_Done => Reset_Done,
      Soft_Stop => Soft_Stop,
      SWTM_DOB => SWTM_DOB,
      SWTM_ADDRB => SWTM_ADDRB,
      SWTM_DIB => SWTM_DIB,
      SWTM_ENB => SWTM_ENB,
      SWTM_WEB => SWTM_WEB,
      TM2SCH_current_cpu_tid => TM2SCH_current_cpu_tid,
      TM2SCH_opcode => TM2SCH_opcode,
      TM2SCH_data => TM2SCH_data,
      TM2SCH_request => TM2SCH_request,
      SCH2TM_busy => SCH2TM_busy,
      SCH2TM_data => SCH2TM_data,
      SCH2TM_next_cpu_tid => SCH2TM_next_cpu_tid,
      SCH2TM_next_tid_valid => SCH2TM_next_tid_valid,
      Preemption_Interrupt => Preemption_Interrupt,
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
      OPB_xferAck => OPB_xferAck
    );

end architecture STRUCTURE;

