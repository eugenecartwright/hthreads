-------------------------------------------------------------------------------
-- thread_manager_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library opb_threadCore_v1_00_a;
use opb_threadCore_v1_00_a.all;

entity thread_manager_wrapper is
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

  attribute x_core_info : STRING;
  attribute x_core_info of thread_manager_wrapper : entity is "opb_threadCore_v1_00_a";

end thread_manager_wrapper;

architecture STRUCTURE of thread_manager_wrapper is

  component opb_threadcore is
    generic (
      C_BASEADDR : std_logic_vector(0 to 31);
      C_HIGHADDR : std_logic_vector(0 to 31);
      C_OPB_AWIDTH : INTEGER;
      C_OPB_DWIDTH : INTEGER;
      C_FAMILY : STRING;
      C_RESET_TIMEOUT : NATURAL
    );
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      OPB_ABus : in std_logic_vector(0 to (C_OPB_AWIDTH-1));
      OPB_BE : in std_logic_vector(0 to ((C_OPB_DWIDTH/8)-1));
      OPB_DBus : in std_logic_vector(0 to (C_OPB_DWIDTH-1));
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      Sln_DBus : out std_logic_vector(0 to (C_OPB_DWIDTH-1));
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

begin

  thread_manager : opb_threadcore
    generic map (
      C_BASEADDR => X"11000000",
      C_HIGHADDR => X"1103FFFF",
      C_OPB_AWIDTH => 32,
      C_OPB_DWIDTH => 32,
      C_FAMILY => "virtex5",
      C_RESET_TIMEOUT => 4096
    )
    port map (
      OPB_Clk => OPB_Clk,
      OPB_Rst => OPB_Rst,
      OPB_ABus => OPB_ABus,
      OPB_BE => OPB_BE,
      OPB_DBus => OPB_DBus,
      OPB_RNW => OPB_RNW,
      OPB_select => OPB_select,
      OPB_seqAddr => OPB_seqAddr,
      Sln_DBus => Sln_DBus,
      Sln_errAck => Sln_errAck,
      Sln_retry => Sln_retry,
      Sln_toutSup => Sln_toutSup,
      Sln_xferAck => Sln_xferAck,
      Access_Intr => Access_Intr,
      Scheduler_Reset => Scheduler_Reset,
      Scheduler_Reset_Done => Scheduler_Reset_Done,
      Semaphore_Reset => Semaphore_Reset,
      Semaphore_Reset_Done => Semaphore_Reset_Done,
      SpinLock_Reset => SpinLock_Reset,
      SpinLock_Reset_Done => SpinLock_Reset_Done,
      User_IP_Reset => User_IP_Reset,
      User_IP_Reset_Done => User_IP_Reset_Done,
      Soft_Stop => Soft_Stop,
      tm2sch_cpu_thread_id => tm2sch_cpu_thread_id,
      tm2sch_opcode => tm2sch_opcode,
      tm2sch_data => tm2sch_data,
      tm2sch_request => tm2sch_request,
      sch2tm_busy => sch2tm_busy,
      sch2tm_data => sch2tm_data,
      sch2tm_next_id => sch2tm_next_id,
      sch2tm_next_id_valid => sch2tm_next_id_valid,
      tm2sch_DOB => tm2sch_DOB,
      sch2tm_ADDRB => sch2tm_ADDRB,
      sch2tm_DIB => sch2tm_DIB,
      sch2tm_ENB => sch2tm_ENB,
      sch2tm_WEB => sch2tm_WEB
    );

end architecture STRUCTURE;

