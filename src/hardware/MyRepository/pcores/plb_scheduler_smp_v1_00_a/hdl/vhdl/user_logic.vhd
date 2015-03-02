------------------------------------------------------------------------------
-- user_logic.vhd - entity/architecture pair
------------------------------------------------------------------------------
--
-- ***************************************************************************
-- ** Copyright (c) 1995-2008 Xilinx, Inc.  All rights reserved.            **
-- **                                                                       **
-- ** Xilinx, Inc.                                                          **
-- ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"         **
-- ** AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND       **
-- ** SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,        **
-- ** OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,        **
-- ** APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION           **
-- ** THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,     **
-- ** AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE      **
-- ** FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY              **
-- ** WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE               **
-- ** IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR        **
-- ** REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF       **
-- ** INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       **
-- ** FOR A PARTICULAR PURPOSE.                                             **
-- **                                                                       **
-- ***************************************************************************
--
------------------------------------------------------------------------------
-- Filename:          user_logic.vhd
-- Version:           1.00.a
-- Description:       User logic.
-- Date:              Mon Apr  6 14:20:46 2009 (by Create and Import Peripheral Wizard)
-- VHDL Standard:     VHDL'93
------------------------------------------------------------------------------
-- Naming Conventions:
--   active low signals:                    "*_n"
--   clock signals:                         "clk", "clk_div#", "clk_#x"
--   reset signals:                         "rst", "rst_n"
--   generics:                              "C_*"
--   user defined types:                    "*_TYPE"
--   state machine next state:              "*_ns"
--   state machine current state:           "*_cs"
--   combinatorial signals:                 "*_com"
--   pipelined or register delay signals:   "*_d#"
--   counter signals:                       "*cnt*"
--   clock enable signals:                  "*_ce"
--   internal version of output port:       "*_i"
--   device pins:                           "*_pin"
--   ports:                                 "- Names begin with Uppercase"
--   processes:                             "*_PROCESS"
--   component instantiations:              "<ENTITY_>I_<#|FUNC>"
------------------------------------------------------------------------------

-- DO NOT EDIT BELOW THIS LINE --------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--library proc_common_v2_00_a;
--use proc_common_v2_00_a.proc_common_pkg.all;
--use proc_common_v2_00_a.srl_fifo_f;

-- DO NOT EDIT ABOVE THIS LINE --------------------

--USER libraries added here

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_SLV_DWIDTH                 -- Slave interface data bus width
--   C_MST_AWIDTH                 -- Master interface address bus width
--   C_MST_DWIDTH                 -- Master interface data bus width
--   C_NUM_REG                    -- Number of software accessible registers
--
-- Definition of Ports:
--   Bus2IP_Clk                   -- Bus to IP clock
--   Bus2IP_Reset                 -- Bus to IP reset
--   Bus2IP_Addr                  -- Bus to IP address bus
--   Bus2IP_Data                  -- Bus to IP data bus
--   Bus2IP_BE                    -- Bus to IP byte enables
--   Bus2IP_RdCE                  -- Bus to IP read chip enable
--   Bus2IP_WrCE                  -- Bus to IP write chip enable
--   IP2Bus_Data                  -- IP to Bus data bus
--   IP2Bus_RdAck                 -- IP to Bus read transfer acknowledgement
--   IP2Bus_WrAck                 -- IP to Bus write transfer acknowledgement
--   IP2Bus_Error                 -- IP to Bus error response
--   IP2Bus_MstRd_Req             -- IP to Bus master read request
--   IP2Bus_MstWr_Req             -- IP to Bus master write request
--   IP2Bus_Mst_Addr              -- IP to Bus master address bus
--   IP2Bus_Mst_BE                -- IP to Bus master byte enables
--   IP2Bus_Mst_Lock              -- IP to Bus master lock
--   IP2Bus_Mst_Reset             -- IP to Bus master reset
--   Bus2IP_Mst_CmdAck            -- Bus to IP master command acknowledgement
--   Bus2IP_Mst_Cmplt             -- Bus to IP master transfer completion
--   Bus2IP_Mst_Error             -- Bus to IP master error response
--   Bus2IP_Mst_Rearbitrate       -- Bus to IP master re-arbitrate
--   Bus2IP_Mst_Cmd_Timeout       -- Bus to IP master command timeout
--   Bus2IP_MstRd_d               -- Bus to IP master read data bus
--   Bus2IP_MstRd_src_rdy_n       -- Bus to IP master read source ready
--   IP2Bus_MstWr_d               -- IP to Bus master write data bus
--   Bus2IP_MstWr_dst_rdy_n       -- Bus to IP master write destination ready
------------------------------------------------------------------------------

entity user_logic is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
    --USER generics added here
      C_NUM_CPUS :    integer := 2;
    -- ADD USER GENERICS ABOVE THIS LINE ---------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_SLV_DWIDTH                   : integer              := 32;
    C_MST_AWIDTH                   : integer              := 32;
    C_MST_DWIDTH                   : integer              := 32;
    C_NUM_REG                      : integer              := 5
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------
    --USER ports added here
    Soft_Reset      : in  std_logic;

    Reset_Done      : out std_logic;
    Soft_Stop       : in  std_logic;
    
    SWTM_DOB        : in  std_logic_vector(0 to 31); 
    SWTM_ADDRB      : out std_logic_vector(0 to 8);
    SWTM_DIB        : out std_logic_vector(0 to 31);
    SWTM_ENB        : out std_logic;  
    SWTM_WEB        : out std_logic;

      -- current_thread for CPU 0 = TM2SCH_current_cpu_tid(0 to 7)
      -- current_thread for CPU 1 = TM2SCH_current_cpu_tid(8 to 15)
      -- current_thread for CPU N = TM2SCH_current_cpu_tid(8*(N-1) to 8*N-1)
    TM2SCH_current_cpu_tid    : in std_logic_vector(0 to 8*C_NUM_CPUS - 1);        

    TM2SCH_opcode           : in std_logic_vector(0 to 5);
    TM2SCH_data             : in std_logic_vector(0 to 7);
    TM2SCH_request          : in std_logic;
    SCH2TM_busy             : out std_logic;
    SCH2TM_data             : out std_logic_vector(0 to 7);
    SCH2TM_next_cpu_tid     : out std_logic_vector(0 to 7);
    SCH2TM_next_tid_valid   : out std_logic;

      -- preempt for CPU 0 = Preemption_Interrupt(0)
      -- preempt for CPU 1 = Preemption_Interrupt(1)
      -- preempt for CPU N = Preemption_Interrupt(N-1)
    Preemption_Interrupt      : out std_logic_vector(0 to C_NUM_CPUS - 1);
    -- ADD USER PORTS ABOVE THIS LINE ------------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol ports, do not add to or delete
    Bus2IP_Clk                     : in  std_logic;
    Bus2IP_Reset                   : in  std_logic;
    Bus2IP_Addr                    : in  std_logic_vector(0 to 31);
    Bus2IP_Data                    : in  std_logic_vector(0 to C_SLV_DWIDTH-1);
    Bus2IP_BE                      : in  std_logic_vector(0 to C_SLV_DWIDTH/8-1);
    Bus2IP_RdCE                    : in  std_logic_vector(0 to C_NUM_REG-1);
    Bus2IP_WrCE                    : in  std_logic_vector(0 to C_NUM_REG-1);
    IP2Bus_Data                    : out std_logic_vector(0 to C_SLV_DWIDTH-1);
    IP2Bus_RdAck                   : out std_logic;
    IP2Bus_WrAck                   : out std_logic;
    IP2Bus_Error                   : out std_logic;
    IP2Bus_MstRd_Req               : out std_logic;
    IP2Bus_MstWr_Req               : out std_logic;
    IP2Bus_Mst_Addr                : out std_logic_vector(0 to C_MST_AWIDTH-1);
    IP2Bus_Mst_BE                  : out std_logic_vector(0 to C_MST_DWIDTH/8-1);
    IP2Bus_Mst_Lock                : out std_logic;
    IP2Bus_Mst_Reset               : out std_logic;
    Bus2IP_Mst_CmdAck              : in  std_logic;
    Bus2IP_Mst_Cmplt               : in  std_logic;
    Bus2IP_Mst_Error               : in  std_logic;
    Bus2IP_Mst_Rearbitrate         : in  std_logic;
    Bus2IP_Mst_Cmd_Timeout         : in  std_logic;
    Bus2IP_MstRd_d                 : in  std_logic_vector(0 to C_MST_DWIDTH-1);
    Bus2IP_MstRd_src_rdy_n         : in  std_logic;
    IP2Bus_MstWr_d                 : out std_logic_vector(0 to C_MST_DWIDTH-1);
    Bus2IP_MstWr_dst_rdy_n         : in  std_logic
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );

  attribute SIGIS : string;
  attribute SIGIS of Bus2IP_Clk    : signal is "CLK";
  attribute SIGIS of Bus2IP_Reset  : signal is "RST";
  attribute SIGIS of IP2Bus_Mst_Reset: signal is "RST";

end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

  -- Local copy of port signal SCH2TM_next_tid_valid
  signal Next_Thread_Valid_reg                  : std_logic;
  signal Next_Thread_Valid_next                 : std_logic;

  -- Store temporary value of Next_Thread_Valid_reg
  signal temp_valid                             : std_logic;
  signal temp_valid_next                        : std_logic;

  -- Local copy of cpu specific preemption signals
  signal Preemption_Interrupt_Line              : std_logic_vector(0 to C_NUM_CPUS - 1);
  signal Preemption_Interrupt_Enable            : std_logic_vector(0 to C_NUM_CPUS - 1);
  signal Preemption_Interrupt_Enable_next       : std_logic_vector(0 to C_NUM_CPUS - 1);

  -- Local copy of port signal TM2SCH_current_cpu_tid
  signal current_thread_id_reg                  : std_logic_vector(0 to 8*C_NUM_CPUS - 1);

  -- Track the priorities of threads executing on all CPU's
  -- 0 to 7   implies CPU 0, 8 to 15  implies CPU 1
  -- 16 to 23 implies CPU 2, 24 to 31 implies CPU 4  
  signal current_priority_reg                   : std_logic_vector(0 to 7*C_NUM_CPUS - 1);-- := (others => '1');
  signal current_priority_next                  : std_logic_vector(0 to 7*C_NUM_CPUS - 1);-- := (others => '1');

  -- Local copy of port signal SCH2TM_next_cpu_tid
  signal next_thread_id_reg                     : std_logic_vector(0 to 7);
  signal next_thread_id_next                    : std_logic_vector(0 to 7);

  -- ACK signal
  signal IP2Bus_Ack : std_logic;

  -- Track idle_thread information for each processor
  signal idle_thread_id                         : std_logic_vector(0 to 8*C_NUM_CPUS - 1);
  signal idle_thread_id_next                    : std_logic_vector(0 to 8*C_NUM_CPUS - 1);
  signal idle_thread_valid                      : std_logic_vector(0 to C_NUM_CPUS - 1);
  signal idle_thread_valid_next                 : std_logic_vector(0 to C_NUM_CPUS - 1);

  -- This signal stores information about which CPU we are currently using
  signal current_CPU      : integer := 0;
  signal current_CPU_next : integer := 0;

  -- Define the memory map for each command register, Address[24 to 31]
  -- This value is the offset from the base address assigned to this module
  constant C_SYSCALL_LOCK         : std_logic_vector(0 to 7) := "00111100";  -- 0x3C
  constant C_MALLOC_LOCK          : std_logic_vector(0 to 7) := "01000100";  -- 0x44
  constant C_SET_PREEMPTION       : std_logic_vector(0 to 7) := "01001000";  -- 0x48
  constant C_GET_IDLE_THREAD      : std_logic_vector(0 to 7) := "01010000";  -- 0x50 
  constant C_SET_IDLE_THREAD      : std_logic_vector(0 to 7) := "01010100";  -- 0x54
  constant C_READ_DEBUG_0         : std_logic_vector(0 to 7) := "01011000";  -- 0x58
  constant C_SET_SCHEDPARAM       : std_logic_vector(0 to 7) := "01011100";  -- 0x5C
  constant C_GET_ENTRY            : std_logic_vector(0 to 7) := "01100000";  -- 0x60
  constant C_GET_SCHEDPARAM       : std_logic_vector(0 to 7) := "01100100";  -- 0x64
  constant C_CHECK_SCHEDPARAM     : std_logic_vector(0 to 7) := "01101000";  -- 0x68
  constant C_MASTER_READ_DATA     : std_logic_vector(0 to 7) := "01110000";  -- 0x70
  constant C_READ_DEBUG_1         : std_logic_vector(0 to 7) := "01110100";  -- 0x74
  constant C_READ_DEBUG_2         : std_logic_vector(0 to 7) := "01111000";  -- 0x78
  constant C_READ_CURRENT         : std_logic_vector(0 to 7) := "10000000";  -- 0x80
  constant C_READ_NEXT            : std_logic_vector(0 to 7) := "10000100";  -- 0x84
  constant C_READ_PRIORITY        : std_logic_vector(0 to 7) := "10001000";  -- 0x88

  -- TM Command Opcodes
  constant ENQUEUE_OPCODE         : std_logic_vector(0 to 5) := "000010";
  constant DEQUEUE_OPCODE         : std_logic_vector(0 to 5) := "000011";
  constant IS_QUEUED_OPCODE       : std_logic_vector(0 to 5) := "000001";
  constant IS_EMPTY_OPCODE        : std_logic_vector(0 to 5) := "000110";
  constant IDLE_ID_REQ_OPCODE     : std_logic_vector(0 to 5) := "001100";

  -- HW Thread Opcodes
  constant HW_THREAD_START : std_logic_vector(0 to 3) := "0001";

  -- Initialization Strings & Constants
  constant Z32              : std_logic_vector(0 to 31) := (others => '0');
  constant BRAM_init_string : std_logic_vector(0 to 31) := Z32(0 to 31);

  -- Busy Signals
  signal sched_busy      : std_logic;
  signal sched_busy_next : std_logic;

  -- Reset Signals
  signal reset_addr : std_logic_vector(0 to 8);

  -- CE concatenation signals
  signal Bus2IP_RdCE_concat : std_logic;
  signal Bus2IP_WrCE_concat : std_logic;

  -- TM Output Controller signals
  signal TM_data_ready : std_logic;
  signal TM_data_out   : std_logic_vector (0 to 7);

  -- Bus Output Controller signals
  signal bus_data_ready : std_logic;
  signal bus_ack_ready  : std_logic;
  signal bus_data_out   : std_logic_vector (0 to 31);

  -- Debug Registers
  -- debug_reg_0: Unchanged from previous design
  --
  -- debug_reg_1 definition:
  -- bit(s)  signal
  -- 0-7     current_thread_id_reg(CPUID)
  -- 8-15    next_thread_id_reg(CPUID)
  -- 16-23   idle_thread_id(CPUID)
  -- 24      '0'
  -- 25-31   current_priority_reg(CPUID)   
  --
  -- debug_reg_2 definition:
  -- bit(s)  signal
  -- 0-22    variable
  -- 23      Preemption_Interrupt_Line(CPUID)
  -- 24      Preemption_Interrupt_Enable(CPUID)
  -- 25      temp_valid
  -- 26      '0'
  -- 27      Next_Thread_Valid_reg
  -- 28      idle_thread_valid(CPUID)
  -- 29-31   CPUID    
  signal debug_reg_0      : std_logic_vector(0 to 31);
  signal debug_reg_next_0 : std_logic_vector(0 to 31);
  signal debug_reg_1      : std_logic_vector(0 to 31);
  signal debug_reg_2      : std_logic_vector(0 to 31);

  -- Lock/Mutex signals
  signal lock_op                   : std_logic;
  signal lock_op_next              : std_logic;

  signal lock_count                : std_logic_vector(0 to 3);
  signal lock_count_next           : std_logic_vector(0 to 3);
  
  signal syscall_mutex             : std_logic;
  signal syscall_mutex_next        : std_logic;

  signal malloc_mutex              : std_logic;
  signal malloc_mutex_next         : std_logic;

  signal syscall_mutex_holder      : std_logic_vector(0 to 1);
  signal syscall_mutex_holder_next : std_logic_vector(0 to 1);
  
  signal malloc_mutex_holder       : std_logic_vector(0 to 7);
  signal malloc_mutex_holder_next  : std_logic_vector(0 to 7);
  
  -- Reset Signals
  signal inside_reset              : std_logic := '0';
  signal inside_reset_next         : std_logic := '0';

  -- Signals for each event type
  signal Enqueue_Request           : std_logic;
  signal Dequeue_Request           : std_logic;
  signal Set_SchedParam_Request    : std_logic;
  signal Get_SchedParam_Request    : std_logic;
  signal Check_SchedParam_Request  : std_logic;
  signal Preemption_Request        : std_logic;
  signal Get_IdleThread_Request    : std_logic;
  signal Set_IdleThread_Request    : std_logic;
  signal Is_Queued_Request         : std_logic;
  signal Is_Empty_Request          : std_logic;
  signal Get_Entry_Request         : std_logic;
  signal SYSCALL_Lock_Request      : std_logic;
  signal MALLOC_Lock_Request       : std_logic;
  signal Idle_Id_Request           : std_logic;
  signal Current_Request           : std_logic;
  signal Next_Request              : std_logic;
  signal Priority_Request          : std_logic;
  signal Debug_0_Request           : std_logic;
  signal Debug_1_Request           : std_logic;
  signal Debug_2_Request           : std_logic;
  signal Error_Request             : std_logic;

  -- State Machine data signals
  signal lookup_entry           : std_logic_vector(0 to 31);
  signal lookup_entry_next      : std_logic_vector(0 to 31);
  signal dequeue_entry          : std_logic_vector(0 to 31);
  signal dequeue_entry_next     : std_logic_vector(0 to 31);
  signal enqueue_entry          : std_logic_vector(0 to 31);
  signal enqueue_entry_next     : std_logic_vector(0 to 31);
  signal enqueue_pri_entry      : std_logic_vector(0 to 31);
  signal enqueue_pri_entry_next : std_logic_vector(0 to 31);
  signal deq_pri_entry          : std_logic_vector(0 to 31);
  signal deq_pri_entry_next     : std_logic_vector(0 to 31);
  signal sched_param            : std_logic_vector(0 to 31);
  signal sched_param_next       : std_logic_vector(0 to 31);
  signal old_tail_ptr           : std_logic_vector(0 to 7);
  signal old_tail_ptr_next      : std_logic_vector(0 to 7);
  signal old_priority           : std_logic_vector(0 to 6);
  signal old_priority_next      : std_logic_vector(0 to 6);
  signal new_priority           : std_logic_vector(0 to 6);
  signal new_priority_next      : std_logic_vector(0 to 6);
  signal lookup_id              : std_logic_vector(0 to 7);
  signal lookup_id_next         : std_logic_vector(0 to 7);

  signal temp_id                : std_logic_vector(0 to 7);
  signal temp_id_next           : std_logic_vector(0 to 7);

  signal temp_idle_id           : std_logic_vector(0 to 7);
  signal temp_idle_id_next      : std_logic_vector(0 to 7);

  -- BRAM Constants
  constant BRAM_ADDRESS_BITS : integer := 9;
  constant BRAM_DATA_BITS    : integer := 32;

  -- BRAM signals (THREAD_DATA)
  signal DOA   : std_logic_vector(0 to BRAM_DATA_BITS - 1)    := (others => '0');
  signal ADDRA : std_logic_vector(0 to BRAM_ADDRESS_BITS - 1) := (others => '0');
  signal DIA   : std_logic_vector(0 to BRAM_DATA_BITS - 1)    := (others => '0');
  signal ENA   : std_logic                                    := '0';
  signal WEA   : std_logic                                    := '0';

  -- BRAM signals (PRIORITY_DATA)
  signal DOB   : std_logic_vector(0 to BRAM_DATA_BITS - 1)    := (others => '0');
  signal ADDRB : std_logic_vector(0 to BRAM_ADDRESS_BITS - 1) := (others => '0');
  signal DIB   : std_logic_vector(0 to BRAM_DATA_BITS - 1)    := (others => '0');
  signal ENB   : std_logic                                    := '0';
  signal WEB   : std_logic                                    := '0';

  -- BRAM signals (PARAM_DATA)
  signal DOU   : std_logic_vector(0 to BRAM_DATA_BITS - 1)    := (others => '0');
  signal ADDRU : std_logic_vector(0 to BRAM_ADDRESS_BITS - 1) := (others => '0');
  signal DIU   : std_logic_vector(0 to BRAM_DATA_BITS - 1)    := (others => '0');
  signal ENU   : std_logic                                    := '0';
  signal WEU   : std_logic                                    := '0';

  -- Priority Encoder Constants & Signals
  constant INPUT_BITS          : integer := 128;
  constant OUTPUT_BITS         : integer := 7;
  constant CHUNK_BITS          : integer := 32;
  signal   encoder_reset       : std_logic;
  signal   encoder_input       : std_logic_vector(0 to INPUT_BITS - 1);
  signal   encoder_input_next  : std_logic_vector(0 to INPUT_BITS - 1);
  signal   encoder_output      : std_logic_vector(0 to OUTPUT_BITS - 1);
  signal   encoder_enable_next : std_logic;
  signal   encoder_enable      : std_logic;

  -- signal and type for MASTER FSM
  type master_state_type is
    (
      idle,                             -- idle states
      wait_trans_done,                  -- wait for bus transaction to complete

      reset,                            -- reset states
      reset_BRAM,
      reset_wait_4_ack,

      -- enqueue states 
      ENQ_begin,
	  ENQ_check_idle,
      ENQ_lookup_enqueue_entry_idle,
      ENQ_lookup_enqueue_entry_finished,
      ENQ_start_hw_thread_begin,
      ENQ_start_hw_thread_finished,
      ENQ_lookup_enqueue_pri_entry_idle,
      ENQ_lookup_enqueue_pri_entry_finished,
      ENQ_init_head_pointer,
      ENQ_init_tail_pointer,
      ENQ_wait_for_encoder_0,
      ENQ_lookup_old_tail_ptr,
      ENQ_lookup_old_tail_ptr_idle,
      ENQ_lookup_old_tail_ptr_finished,
      ENQ_write_back_entries,      
      ENQ_lookup_highest_pri_entry,
      ENQ_lookup_highest_pri_entry_idle,
      ENQ_lookup_highest_pri_entry_finished,
      ENQ_preemption_check,
      ENQ_preemption_check_idle,

      -- dequeue states
      DEQ_begin,
      DEQ_get_CPU_idle,
      DEQ_lookup_dequeue_entry,
      DEQ_lookup_dequeue_entry_idle,
      DEQ_lookup_dequeue_entry_finished,
      DEQ_lookup_deq_pri_entry_idle,
      DEQ_lookup_deq_pri_entry_finished,
      DEQ_lookup_old_head_ptr_idle,
      DEQ_lookup_old_head_ptr_finished,
      DEQ_write_back_entries,
      DEQ_wait_for_encoder_0,
      DEQ_wait_for_encoder_1,
      DEQ_wait_for_encoder_2,
      DEQ_check_encoder_output,
      DEQ_lookup_highest_pri_entry_idle,
      DEQ_lookup_highest_pri_entry_finished,

      -- set_sched_param states
      SET_SCHED_PARAM_begin,
      SET_SCHED_PARAM_revalidate,
      SET_SCHED_PARAM_lookup_setpri_entries_begin,
      SET_SCHED_PARAM_lookup_setpri_entries_idle,
      SET_SCHED_PARAM_lookup_setpri_entries_finished,
      SET_SCHED_PARAM_lookup_old_pri_entry_idle,
      SET_SCHED_PARAM_lookup_old_pri_entry_finished,
      SET_SCHED_PARAM_priority_field_check,
      SET_SCHED_PARAM_lookup_old_head_ptr_idle,
      SET_SCHED_PARAM_lookup_old_head_ptr_finished,
      SET_SCHED_PARAM_lookup_old_tail_ptr_idle,
      SET_SCHED_PARAM_lookup_old_tail_ptr_finished,
      SET_SCHED_PARAM_lookup_prev_ptr_idle,
      SET_SCHED_PARAM_lookup_prev_ptr_finished,
      SET_SCHED_PARAM_write_back_deq_pri_entry,
      SET_SCHED_PARAM_begin_add_to_new_pri_queue,
      SET_SCHED_PARAM_init_tail_ptr,
      SET_SCHED_PARAM_lookup_enq_old_tail_ptr_idle,
      SET_SCHED_PARAM_update_enqueue_info,
      SET_SCHED_PARAM_write_back_entries,
      SET_SCHED_PARAM_wait_for_encoder_0,
      SET_SCHED_PARAM_wait_for_encoder_1,
      SET_SCHED_PARAM_last_wait_0,
      SET_SCHED_PARAM_last_wait_1,
      SET_SCHED_PARAM_check_encoder,
      SET_SCHED_PARAM_lookup_highest_pri_entry_idle,
      SET_SCHED_PARAM_lookup_highest_pri_entry_finished,
      SET_SCHED_PARAM_preemption_check,
      SET_SCHED_PARAM_preemption_check_idle,
      SET_SCHED_PARAM_return_with_error,
      SET_SCHED_PARAM_return_with_no_error,
      SET_SCHED_PARAM_check_if_current,
      SET_SCHED_PARAM_update_current_priorities,

      -- get_sched_param states
      GET_SCHED_PARAM_begin,
      GET_SCHED_PARAM_lookup_entry,
      GET_SCHED_PARAM_lookup_entry_idle,
      GET_SCHED_PARAM_lookup_entry_finished,

      -- check_sched_param states
      CHECK_SCHED_PARAM_begin,
      CHECK_SCHED_PARAM_lookup_entries,
      CHECK_SCHED_PARAM_lookup_entries_idle,
      CHECK_SCHED_PARAM_lookup_entries_finished,

      -- toggle_preemption states
      SET_PREEMPTION_begin,
      SET_PREEMPTION_idle,
      SET_PREEMPTION_finished,

      -- get_idle_thread states
      GET_IDLE_THREAD_begin,
      GET_IDLE_THREAD_idle,
      GET_IDLE_THREAD_finished,

      -- set_idle_thread states
      SET_IDLE_THREAD_begin,
      SET_IDLE_THREAD_lookup_entries_idle,
      SET_IDLE_THREAD_lookup_entries_finished,
      SET_IDLE_THREAD_return_with_error,
      SET_IDLE_THREAD_return_with_no_error,

      -- is_queued states
      IS_QUEUED_begin,
      IS_QUEUED_lookup_entry,
      IS_QUEUED_lookup_entry_idle,
      IS_QUEUED_lookup_entry_finished,

      -- is_empty states
      IS_EMPTY_check,
      IS_EMPTY_finished,

      -- get_entry states
      GET_ENTRY_begin,
      GET_ENTRY_lookup_entry,
      GET_ENTRY_lookup_entry_idle,
      GET_ENTRY_lookup_entry_finished,

      SYSCALL_LOCK,
      SYSCALL_LOCK_idle,
      SYSCALL_LOCK_idle_finished,
      SYSCALL_LOCK_ACQUIRE,
      SYSCALL_LOCK_RELEASE,

      MALLOC_LOCK,
      MALLOC_LOCK_idle,
      MALLOC_LOCK_idle_finished,
      MALLOC_LOCK_ACQUIRE,
      MALLOC_LOCK_ACQUIRE_RETURN,
      MALLOC_LOCK_RELEASE,
      MALLOC_LOCK_RELEASE_next,
      MALLOC_LOCK_RELEASE_RETURN,

      IDLE_ID_DEQ,
      IDLE_ID_DEQ_CPU_idle,
      IDLE_ID_DEQ_return,

      READ_CURRENT,
      READ_NEXT,
      READ_PRIORITY,
      READ_DEBUG_0,
      READ_DEBUG_1,
      READ_DEBUG_2
      );
  signal current_state_master, next_state_master : master_state_type := idle;

---------------------------------------------------
-- is_encoder_bit_zero()
--********************
-- Function used to check an encoder bit
-- Returns booleans:
-- * '0'                                --> True
-- * '1'                                --> False
---------------------------------------------------
  function is_encoder_bit_zero(pri_index : integer; e_entry : std_logic_vector(0 to INPUT_BITS-1)) return boolean is
  begin
    if (e_entry(pri_index) = '0') then
      return true;
    else
      return false;
    end if;
  end function is_encoder_bit_zero;
---------------------------------------------------

---------------------------------------------------
-- set_encoder_bit()
-- *******************
-- Function used to set an encoder bit
---------------------------------------------------
  function set_encoder_bit(e_bit : std_logic; pri : integer; e_entry : std_logic_vector(0 to INPUT_BITS - 1)) return std_logic_vector is
    variable temp_entry          : std_logic_vector(0 to INPUT_BITS-1);
  begin
    temp_entry      := e_entry;         -- make a copy of the entry
    temp_entry(pri) := e_bit;           -- update bit in entry

    return temp_entry;                  -- return new entry
  end function set_encoder_bit;
---------------------------------------------------

---------------------------------------------------
-- bit_set()
-- *******************
-- Determine if any bit in the array is set.
-- If any of the bits are set then '1' is returned,
-- otherwise '0' is returned.
---------------------------------------------------
  function bit_set( data : in std_logic_vector ) return std_logic is
  begin
    for i in data'range loop
      if( data(i) = '1' ) then
        return '1';
      end if;
    end loop;

    return '0';
  end function;
---------------------------------------------------

---------------------------------------------------
-- get_head_pointer()
-- *******************
-- function to extract the head_pointer field from a
-- priority attribute entry
---------------------------------------------------
  function get_head_pointer(entry : std_logic_vector(0 to 31)) return std_logic_vector is
  begin
    return entry(0 to 7);
  end function get_head_pointer;
---------------------------------------------------

---------------------------------------------------
-- set_head_pointer()
-- *******************
-- function to set the head_pointer field for a
-- priority attribute entry
---------------------------------------------------
  function set_head_pointer(head_ptr : std_logic_vector(0 to 7); entry : std_logic_vector(0 to 31)) return std_logic_vector is
  begin
    return head_ptr & entry(8 to 31);
  end function set_head_pointer;
---------------------------------------------------

---------------------------------------------------
-- get_tail_pointer()
-- *******************
-- function to extract the tail_pointer field from a
-- priority attribute entry
---------------------------------------------------
  function get_tail_pointer(entry : std_logic_vector(0 to 31)) return std_logic_vector is
  begin
    return entry(8 to 15);
  end function get_tail_pointer;
---------------------------------------------------

---------------------------------------------------
-- set_tail_pointer()
-- *******************
-- function to set the tail_pointer field for a
-- priority attribute entry
---------------------------------------------------
  function set_tail_pointer(tail_ptr : std_logic_vector(0 to 7); entry : std_logic_vector(0 to 31)) return std_logic_vector is
  begin
    return entry(0 to 7) & tail_ptr & entry(16 to 31);
  end function set_tail_pointer;
---------------------------------------------------

---------------------------------------------------
-- get_priority()
-- *******************
-- function to extract the priority field from a
-- scheduler attribute entry
---------------------------------------------------
  function get_priority(entry : std_logic_vector(0 to 31)) return std_logic_vector is
  begin
    return entry(9 to 15);
  end function get_priority;
---------------------------------------------------

---------------------------------------------------
-- set_priority()
-- *******************
-- function to set the priority field for a
-- scheduler attribute entry
---------------------------------------------------
  function set_priority(priority : std_logic_vector(0 to 6); entry : std_logic_vector(0 to 31)) return std_logic_vector is
  begin
    return entry(0 to 8) & priority & entry(16 to 31);
  end function set_priority;
---------------------------------------------------

---------------------------------------------------
-- get_next_pointer()
-- *******************
-- function to extract the next_pointer field from a
-- scheduler attribute entry
---------------------------------------------------
  function get_next_pointer(entry : std_logic_vector(0 to 31)) return std_logic_vector is
  begin
    return entry(1 to 8);
  end function get_next_pointer;
---------------------------------------------------

---------------------------------------------------
-- set_next_pointer()
-- *******************
-- function to set the next_pointer field for a
-- scheduler attribute entry
---------------------------------------------------
  function set_next_pointer(next_ptr : std_logic_vector(0 to 7); entry : std_logic_vector(0 to 31)) return std_logic_vector is
  begin
    return entry(0) & next_ptr & entry(9 to 31);
  end function set_next_pointer;
---------------------------------------------------

---------------------------------------------------
-- get_prev_pointer()
-- *******************
-- function to extract the prev_pointer field from a
-- scheduler attribute entry
---------------------------------------------------
  function get_prev_pointer(entry : std_logic_vector(0 to 31)) return std_logic_vector is
  begin
    return entry(16 to 23);
  end function get_prev_pointer;
---------------------------------------------------

---------------------------------------------------
-- set_prev_pointer()
-- *******************
-- function to set the prev_pointer field for a
-- scheduler attribute entry
---------------------------------------------------
  function set_prev_pointer(prev_ptr : std_logic_vector(0 to 7); entry : std_logic_vector(0 to 31)) return std_logic_vector is
  begin
    return entry(0 to 15) & prev_ptr & entry(24 to 31);
  end function set_prev_pointer;
---------------------------------------------------

---------------------------------------------------
-- get_queue_bit()
-- *******************
-- function to extract the queue bit field from a
-- scheduler attribute entry
---------------------------------------------------
  function get_queue_bit(entry : std_logic_vector(0 to 31)) return std_logic is
  begin
    return entry(0);
  end function get_queue_bit;
---------------------------------------------------

---------------------------------------------------
-- set_queue_bit()
-- *******************
-- function to set the queue bit field for a
-- scheduler attribute entry
---------------------------------------------------
  function set_queue_bit(q_bit : std_logic; entry : std_logic_vector(0 to 31)) return std_logic_vector is
  begin
    return q_bit & entry(1 to 31);
  end function set_queue_bit;
---------------------------------------------------

---------------------------------------------------
-- check_preempt()
-- *******************
-- Check to see if we need to preempt a processor with a higher priority thread.
-- This function is called when either a new thread is added to the R2RQ or the
-- priority of a thread has changed due to a call to SET_SCHED_PARAM.  This
-- function will determine the lowest priority thread that is interruptable.
-- For example, in a 4 CPU system with priorities 5 10 15 20 and the new thread
-- being added to the R2RQ has a priority of 12, it would be inefficient to
-- preempt the thread with a priority of 15 because this thread would just turn
-- around and preempt the thread with a priority of 20
---------------------------------------------------
  function check_preempt(entry : std_logic_vector(0 to 6); compare : std_logic_vector(0 to 7*C_NUM_CPUS - 1)) return integer is
    variable diff : integer := 0;
    variable prev_diff : integer := 0;
    variable ret_val : integer := conv_integer(C_NUM_CPUS);
  begin
    for i in 0 to (C_NUM_CPUS - 1) loop
      if(compare((i * 7) to ((i * 7) + 6)) > entry) then
         diff := conv_integer(compare((i * 7) to ((i * 7) + 6)) - entry);
         if(diff > prev_diff) then
           prev_diff := diff;
           ret_val := i;
         end if;
		end if;
    end loop;  
    return ret_val;
  end function check_preempt;

---------------------------------------------------
-- check_if_current()
-- *******************
-- Check to see if the thread is "currently running", or equal to any of the currently running thread IDs
  function check_if_current(entry : std_logic_vector(0 to 7); compare : std_logic_vector(0 to 8*C_NUM_CPUS - 1)) return integer is
    variable diff : integer := 0;
    variable prev_diff : integer := 0;
    variable ret_val : integer := conv_integer(C_NUM_CPUS);
  begin
    for i in 0 to (C_NUM_CPUS - 1) loop
      if(compare((i * 8) to ((i * 8) + 7)) = entry) then
         ret_val := i;
      end if;
    end loop;  
    return ret_val;
  end function check_if_current;

---------------------------------------------------
-- Component Instantiation of the Priority Encoder
---------------------------------------------------
  component parallel
    generic
      (
        INPUT_BITS  :     integer := 128;
        OUTPUT_BITS :     integer := 7;
        CHUNK_BITS  :     integer := 32
      );
    port
      (
        clk         : in  std_logic;
        rst         : in  std_logic;
        input       : in  std_logic_vector(0 to 127);
        enable      : in  std_logic;
        output      : out std_logic_vector(0 to 6)
      );
  end component parallel;

---------------------------------------------------
-- Component Instantiation of the Inferred BRAM entity
---------------------------------------------------
  component infer_bram
    generic
      (
        ADDRESS_BITS :     integer := 9;
        DATA_BITS    :     integer := 32
      );
    port
      (
        CLKA         : in  std_logic;
        ENA          : in  std_logic;
        WEA          : in  std_logic;
        ADDRA        : in  std_logic_vector(0 to ADDRESS_BITS - 1);
        DIA          : in  std_logic_vector(0 to DATA_BITS - 1);
        DOA          : out std_logic_vector(0 to DATA_BITS - 1)
      );
  end component infer_BRAM;

---------------------------------------------------
--*************************************************
-- Beginning of user_logic ARCHITECTURE
--*************************************************
---------------------------------------------------

  ------------------------------------------
  -- Signals for user logic master model example
  ------------------------------------------
  -- signals for master model control/status registers write/read
  signal mst_ip2bus_data                : std_logic_vector(0 to C_SLV_DWIDTH-1);
  -- signals for master model control/status registers
  type BYTE_REG_TYPE is array(0 to 15) of std_logic_vector(0 to 7);
  signal mst_go, IP2Bus_MstWrReq                         : std_logic;
  -- signals for master model command interface state machine
  type CMD_CNTL_SM_TYPE is (CMD_IDLE, CMD_RUN, CMD_WAIT_FOR_DATA, CMD_DONE);
  signal mst_cmd_sm_state               : CMD_CNTL_SM_TYPE;
  signal mst_cmd_sm_set_done            : std_logic;
  signal mst_cmd_sm_set_error           : std_logic;
  signal mst_cmd_sm_set_timeout         : std_logic;
  signal mst_cmd_sm_busy                : std_logic;
  signal mst_cmd_sm_clr_go              : std_logic;
  signal mst_cmd_sm_rd_req              : std_logic;
  signal mst_cmd_sm_wr_req              : std_logic;
  signal mst_cmd_sm_reset               : std_logic;
  signal mst_cmd_sm_bus_lock            : std_logic;
  signal IP2Bus_Addr, mst_cmd_sm_ip2bus_addr         : std_logic_vector(0 to C_MST_AWIDTH-1);
  signal mst_cmd_sm_ip2bus_be           : std_logic_vector(0 to C_MST_DWIDTH/8-1);
  signal mst_fifo_valid_write_xfer      : std_logic;
  signal mst_fifo_valid_read_xfer       : std_logic;

begin  -- architecture IMP

---------------------------------------------------
-- Entity Instantiation of the Priority Encoder
---------------------------------------------------
  priority_encoder : parallel
    generic map
    (
      INPUT_BITS  => INPUT_BITS,
      OUTPUT_BITS => OUTPUT_BITS,
      CHUNK_BITS  => CHUNK_BITS
    )
    port map
    (
      clk         => Bus2IP_Clk,
      rst         => encoder_reset,
      input       => encoder_input,
      enable      => encoder_enable,
      output      => encoder_output
    );

---------------------------------------------------
-- Entity Instantiation of the THREAD_DATA BRAM
---------------------------------------------------
  thread_data_bram : infer_bram
    generic map
    (
      ADDRESS_BITS => BRAM_ADDRESS_BITS,
      DATA_BITS    => BRAM_DATA_BITS
    )
    port map
    (
      CLKA         => Bus2IP_Clk,
      ENA          => ENA,
      WEA          => WEA,
      ADDRA        => ADDRA,
      DIA          => DIA,
      DOA          => DOA
    );

---------------------------------------------------
-- Entity Instantiation of the PRIORITY_DATA BRAM
---------------------------------------------------
  priority_data_bram : infer_bram
    generic map
    (
      ADDRESS_BITS => BRAM_ADDRESS_BITS,
      DATA_BITS    => BRAM_DATA_BITS
    )
    port map
    (
      CLKA         => Bus2IP_Clk,
      ENA          => ENB,
      WEA          => WEB,
      ADDRA        => ADDRB,
      DIA          => DIB,
      DOA          => DOB
    );

---------------------------------------------------
-- Entity Instantiation of the PARAM_DATA BRAM
---------------------------------------------------
  param_data_bram : infer_bram
    generic map
    (
      ADDRESS_BITS => BRAM_ADDRESS_BITS,
      DATA_BITS    => BRAM_DATA_BITS
    )
    port map
    (
      CLKA         => Bus2IP_Clk,
      ENA          => ENU,
      WEA          => WEU,
      ADDRA        => ADDRU,
      DIA          => DIU,
      DOA          => DOU
    );

    -- Connect registers to external port signals...
  SCH2TM_next_cpu_tid   <= next_thread_id_reg;
  SCH2TM_next_tid_valid <= Next_Thread_Valid_reg;

  -- Connect port signals to registers...
  current_thread_id_reg <= TM2SCH_current_cpu_tid;

  -- AND the Preemption Interrupt Enable w/ the Interrupt line
  -- Preemption is system wide and therefore not unique to each processor
  Preemption_Interrupt  <= Preemption_Interrupt_Line and Preemption_Interrupt_Enable;

  -- Create concatenation signals
  Bus2IP_RdCE_concat    <= bit_set(Bus2IP_RdCE);
  Bus2IP_WrCE_concat    <= bit_set(Bus2IP_WrCE);

  -- Connect registers to external port signals...
  SCH2TM_busy           <= sched_busy;

  -- Toggle on/off timeout suppression with read/write requests
  --IP2Bus_ToutSup        <= (Bus2IP_RdCE_concat) or (Bus2IP_WrCE_concat);

-- ***************************************************
-- Bus Master FSM
-- ***************************************************
  -- user logic master command interface assignments
  IP2Bus_MstRd_Req  <= mst_cmd_sm_rd_req;
  IP2Bus_MstWr_Req  <= mst_cmd_sm_wr_req;
  IP2Bus_Mst_Addr   <= mst_cmd_sm_ip2bus_addr;
  IP2Bus_Mst_BE     <= mst_cmd_sm_ip2bus_be;
  IP2Bus_Mst_Lock   <= mst_cmd_sm_bus_lock;
  IP2Bus_Mst_Reset  <= mst_cmd_sm_reset;

  --implement master command interface state machine

  mst_go <= IP2Bus_MstWrReq;

  MASTER_CMD_SM_PROC : process( Bus2IP_Clk ) is
  begin

    if ( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
      if ( Bus2IP_Reset = '1' ) then

        -- reset condition
        mst_cmd_sm_state          <= CMD_IDLE;
        mst_cmd_sm_clr_go         <= '0';
        mst_cmd_sm_rd_req         <= '0';
        mst_cmd_sm_wr_req         <= '0';
        mst_cmd_sm_bus_lock       <= '0';
        mst_cmd_sm_reset          <= '0';
        mst_cmd_sm_ip2bus_addr    <= (others => '0');
        mst_cmd_sm_ip2bus_be      <= (others => '0');
        mst_cmd_sm_set_done       <= '0';
        mst_cmd_sm_set_error      <= '0';
        mst_cmd_sm_set_timeout    <= '0';
        mst_cmd_sm_busy           <= '0';
                
      else

        -- default condition
        mst_cmd_sm_clr_go         <= '0';
        mst_cmd_sm_rd_req         <= '0';
        mst_cmd_sm_wr_req         <= '0';
        mst_cmd_sm_bus_lock       <= '0';
        mst_cmd_sm_reset          <= '0';
        mst_cmd_sm_ip2bus_addr    <= (others => '0');
        mst_cmd_sm_ip2bus_be      <= (others => '0');
        mst_cmd_sm_set_done       <= '0';
        mst_cmd_sm_set_error      <= '0';
        mst_cmd_sm_set_timeout    <= '0';
        mst_cmd_sm_busy           <= '1';
                
        -- state transition
        case mst_cmd_sm_state is

          when CMD_IDLE =>
            if ( mst_go = '1' ) then
              mst_cmd_sm_state  <= CMD_RUN;
              mst_cmd_sm_clr_go <= '1';
            else
              mst_cmd_sm_state  <= CMD_IDLE;
              mst_cmd_sm_busy   <= '0';
            end if;

          when CMD_RUN =>
            if ( Bus2IP_Mst_CmdAck = '1' and Bus2IP_Mst_Cmplt = '0' ) then
              mst_cmd_sm_state <= CMD_WAIT_FOR_DATA;
            elsif ( Bus2IP_Mst_Cmplt = '1' ) then
              mst_cmd_sm_state <= CMD_DONE;
              if ( Bus2IP_Mst_Cmd_Timeout = '1' ) then
                -- PLB address phase timeout
                mst_cmd_sm_set_error   <= '1';
                mst_cmd_sm_set_timeout <= '1';
              elsif ( Bus2IP_Mst_Error = '1' ) then
                -- PLB data transfer error
                mst_cmd_sm_set_error   <= '1';
              end if;
            else
              mst_cmd_sm_state       <= CMD_RUN;
              mst_cmd_sm_rd_req      <= '0';                -- Perform a write (rd = '0', wr = '1')
              mst_cmd_sm_wr_req      <= '1';

              mst_cmd_sm_ip2bus_addr <= IP2Bus_Addr;        -- Setup address

              mst_cmd_sm_ip2bus_be   <= (others => '1');    -- Use all byte lanes
              mst_cmd_sm_bus_lock    <= '0';                -- De-assert bus lock
            end if;

          when CMD_WAIT_FOR_DATA =>
            if ( Bus2IP_Mst_Cmplt = '1' ) then
              mst_cmd_sm_state <= CMD_DONE;
            else
              mst_cmd_sm_state <= CMD_WAIT_FOR_DATA;
            end if;

          when CMD_DONE =>
            mst_cmd_sm_state    <= CMD_IDLE;
            mst_cmd_sm_set_done <= '1';
            mst_cmd_sm_busy     <= '0';

          when others =>
            mst_cmd_sm_state    <= CMD_IDLE;
            mst_cmd_sm_busy     <= '0';

        end case;

      end if;
    end if;

  end process MASTER_CMD_SM_PROC;

-- *************************************************************************
-- Process: TM_OUTPUT_CONTROLLER
-- Purpose: Control output from IP to TM
-- * Can be controlled using TM_data_ready and TM_data_out signals.
-- *************************************************************************
  TM_OUTPUT_CONTROLLER : process( Bus2IP_Clk, tm_data_ready ) is
  begin
    if( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
      if( TM_data_ready = '1' ) then
        SCH2TM_data <= TM_data_out;     -- put data out to TM
      end if;
    end if;
  end process TM_OUTPUT_CONTROLLER;

-- *************************************************************************
-- Process: BUS_OUTPUT_CONTROLLER
-- Purpose: Control output from IP to Bus
-- * Can be controlled using bus_data_ready, bus_ack_ready, and bus_data_out signals.
-- *************************************************************************
  BUS_OUTPUT_CONTROLLER : process( Bus2IP_Clk, bus_data_ready, bus_ack_ready ) is
  begin
    if( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
      if( bus_data_ready = '1' and bus_ack_ready = '1' ) then
        IP2Bus_Data <= bus_data_out;     -- put data on bus
        IP2Bus_Ack  <= '1';              -- ACK bus
      elsif (bus_data_ready = '1' and bus_ack_ready = '0') then
        IP2Bus_Data <= bus_data_out;     -- put data on bus
        IP2Bus_Ack  <= '0';              -- turn off ACK
      else
        IP2Bus_Data <= (others => '0');  -- output 0's on bus
        IP2Bus_Ack  <= '0';              -- turn off ACK
      end if;
    end if;
  end process BUS_OUTPUT_CONTROLLER;

ACK_ROUTER : process (IP2Bus_Ack, Bus2IP_RdCE_concat, Bus2IP_WrCE_concat) is
begin
    -- Turn an "ACK" into a specific ACK (read or write ACK)
    if (Bus2IP_RdCE_concat = '1') then
        IP2Bus_RdAck <= IP2Bus_Ack;
        IP2Bus_WrAck <= '0';
    else
        IP2Bus_RdAck <= '0';
        IP2Bus_WrAck <= IP2Bus_Ack;
    end if;    
end process;

-- FIXME: This process should be incorporated into the FSM
-- *************************************************************************
-- Process: RESET_ADDR_INC
-- Purpose: Process to increment the "reset" address so that each element of
-- the BRAMs can be indexed and initialized
-- *************************************************************************
  RESET_ADDR_INC : process( Bus2IP_Clk, Soft_Reset, inside_reset, ENA ) is
  begin
    if( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
      if( Soft_Reset = '1' and inside_reset = '0' ) then
        reset_addr <= (others => '0');
      elsif( ENA = '1' ) then
        reset_addr <= reset_addr + 1;
      end if;
    end if;
  end process RESET_ADDR_INC;

-- *************************************************************************
-- Process: TM_CMD_PROC
-- Purpose: Controller and decoder for incoming TM operations (requests)
-- *************************************************************************
  TM_CMD_PROC : process (Bus2IP_Clk, TM2SCH_opcode, TM2SCH_data, TM2SCH_request ) is
  begin
    if( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
      Enqueue_Request   <= '0';
      Dequeue_Request   <= '0';
      Is_Queued_Request <= '0';
      Is_Empty_Request  <= '0';
      Idle_Id_Request   <= '0';

      if (TM2SCH_request = '1') then
        case (TM2SCH_opcode) is
          when ENQUEUE_OPCODE      => Enqueue_Request   <= '1';
          when DEQUEUE_OPCODE      => Dequeue_Request   <= '1';
          when IS_QUEUED_OPCODE    => Is_Queued_Request <= '1';
          when IS_EMPTY_OPCODE     => Is_Empty_Request  <= '1';
          when IDLE_ID_REQ_OPCODE  => Idle_Id_Request   <= '1';
          when others              => null;
        end case;
      end if;
    end if;
  end process TM_CMD_PROC;

-- *************************************************************************
-- Process: BUS_CMD_PROC
-- Purpose: Controller and decoder for incoming bus operations (reads and writes)
-- *************************************************************************
  BUS_CMD_PROC : process (Bus2IP_Clk, Bus2IP_RdCE_concat, Bus2IP_WrCE_concat, Bus2IP_Addr ) is
  begin
    if( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
      SYSCALL_Lock_Request      <= '0';
      MALLOC_Lock_Request       <= '0';
      Current_Request           <= '0';
      Next_Request              <= '0';
      Priority_Request          <= '0';
      Debug_0_Request           <= '0';
      Debug_1_Request           <= '0';
      Debug_2_Request           <= '0';
      Set_SchedParam_Request    <= '0';
      Get_SchedParam_Request    <= '0';
      Check_SchedParam_Request  <= '0';
      Preemption_Request        <= '0';
      Get_IdleThread_Request    <= '0';
      Set_IdleThread_Request    <= '0';
      Get_Entry_Request         <= '0';
      Error_Request             <= '0';

      if( Bus2IP_WrCE_concat = '1' ) then
        case Bus2IP_Addr(24 to 31) is
          when C_SET_SCHEDPARAM    => Set_SchedParam_Request    <= '1';
          when C_SET_PREEMPTION    => Preemption_Request        <= '1';
          when others              => Error_Request             <= '1';
        end case;
      elsif( Bus2IP_RdCE_concat = '1' ) then
        case Bus2IP_Addr(24 to 31) is
          when C_GET_SCHEDPARAM       => Get_SchedParam_Request    <= '1';
          when C_CHECK_SCHEDPARAM     => Check_SchedParam_Request  <= '1';
          when C_GET_IDLE_THREAD      => Get_IdleThread_Request    <= '1';
          when C_SET_IDLE_THREAD      => Set_IdleThread_Request    <= '1';
          when C_GET_ENTRY            => Get_Entry_Request         <= '1';
          when C_SYSCALL_LOCK         => SYSCALL_Lock_Request      <= '1';
          when C_MALLOC_LOCK          => MALLOC_Lock_Request       <= '1';
          when C_READ_CURRENT         => Current_Request           <= '1';
          when C_READ_NEXT            => Next_Request              <= '1';
          when C_READ_PRIORITY        => Priority_Request          <= '1';
          when C_READ_DEBUG_0         => Debug_0_Request           <= '1';
          when C_READ_DEBUG_1         => Debug_1_Request           <= '1';
          when C_READ_DEBUG_2         => Debug_2_Request           <= '1';
          when others                 => Error_Request             <= '1';
        end case;
      end if;
    end if;
  end process BUS_CMD_PROC;


-- *************************************************************************
-- Process: MASTER_FSM_STATE_PROC
-- Purpose: Synchronous FSM controller for the master state machine
-- *************************************************************************
  MASTER_FSM_STATE_PROC : process(
    Bus2IP_Clk, Soft_Reset, inside_reset, next_state_master, encoder_enable_next, enqueue_pri_entry_next,
    deq_pri_entry_next, old_tail_ptr_next, encoder_input_next, next_thread_id_next, lookup_entry_next,
    sched_param_next, dequeue_entry_next, enqueue_entry_next, old_priority_next, new_priority_next, lookup_id_next,
    idle_thread_id_next, idle_thread_valid_next, inside_reset_next, Preemption_Interrupt_Enable_next,
    sched_busy_next, Next_Thread_Valid_next, lock_op_next, lock_count_next, syscall_mutex_next, 
    malloc_mutex_next, syscall_mutex_holder_next, malloc_mutex_holder_next, debug_reg_next_0, 
    temp_valid_next, current_CPU_next, current_priority_next, temp_id_next, temp_idle_id_next) is  

    variable temp_CPUID : std_logic_vector(0 to 2);
	 	 
  begin
    if ( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
      if( Soft_Reset = '1' and inside_reset = '0' ) then
        -- Initialize all signals...
        current_state_master            <= reset;
        encoder_enable                  <= '0';
        inside_reset                    <= '1';
        sched_busy                      <= '0';
        Next_Thread_Valid_reg           <= '0';
        temp_valid                      <= '0';
        Preemption_Interrupt_Enable     <= (others => '0');
        idle_thread_valid               <= (others => '0');
        enqueue_pri_entry               <= (others => '0');
        deq_pri_entry                   <= (others => '0');
        old_tail_ptr                    <= (others => '0');
        encoder_input                   <= (others => '0');
        next_thread_id_reg              <= (others => '0');
        lookup_entry                    <= (others => '0');
        sched_param                     <= (others => '0');
        dequeue_entry                   <= (others => '0');
        enqueue_entry                   <= (others => '0');
        old_priority                    <= (others => '0');
        new_priority                    <= (others => '0');
        lookup_id                       <= (others => '0');
        idle_thread_id                  <= (others => '0');
        lock_count                      <= (others => '0');
        lock_op                         <= '0';
        syscall_mutex                   <= '0';
        malloc_mutex                    <= '0';
        syscall_mutex_holder            <= (others => '1');
        malloc_mutex_holder             <= x"FF";
        debug_reg_0                     <= (others => '0');
        debug_reg_1                     <= (others => '0');
        debug_reg_2                     <= (others => '0');
        temp_CPUID                      := (others => '0');
        current_priority_reg            <= (others => '1');
        temp_id                         <= (others => '0');
        temp_idle_id                    <= (others => '0');
      else
        -- Assign all signals to their next state...
        current_state_master            <= next_state_master;
        encoder_enable                  <= encoder_enable_next;
        enqueue_pri_entry               <= enqueue_pri_entry_next;
        deq_pri_entry                   <= deq_pri_entry_next;
        old_tail_ptr                    <= old_tail_ptr_next;
        encoder_input                   <= encoder_input_next;
        next_thread_id_reg              <= next_thread_id_next;
        lookup_entry                    <= lookup_entry_next;
        sched_param                     <= sched_param_next;
        dequeue_entry                   <= dequeue_entry_next;
        enqueue_entry                   <= enqueue_entry_next;
        old_priority                    <= old_priority_next;
        new_priority                    <= new_priority_next;
        lookup_id                       <= lookup_id_next;
        idle_thread_id                  <= idle_thread_id_next;
        lock_count                      <= lock_count_next;
        lock_op                         <= lock_op_next;
        syscall_mutex                   <= syscall_mutex_next;
        malloc_mutex                    <= malloc_mutex_next;
        syscall_mutex_holder            <= syscall_mutex_holder_next;
        malloc_mutex_holder             <= malloc_mutex_holder_next;
        debug_reg_0                     <= debug_reg_next_0;
        current_priority_reg            <= current_priority_next;
        temp_id                         <= temp_id_next;
        temp_idle_id                    <= temp_idle_id_next;

        debug_reg_1 <= current_thread_id_reg((8 * current_CPU) to (8 * current_CPU + 7)) &
                       next_thread_id_reg((8 * current_CPU) to (8 * current_CPU + 7))    &
                       idle_thread_id((8 * current_CPU) to (8 * current_CPU + 7)) & '0'  &
                       current_priority_reg((7 * current_CPU) to (7 * current_CPU + 6));
		  case current_CPU is
			when 0 		=> temp_CPUID := "000";
			when 1 		=> temp_CPUID := "001";
			when 2 		=> temp_CPUID := "010";
			when 3  	=> temp_CPUID := "011";
			when others => temp_CPUID := "111";
		  end case;
		debug_reg_2 <= Z32(0 to 22) & Preemption_Interrupt_Line(current_CPU) & Preemption_Interrupt_Enable(current_CPU) &
                       temp_valid & '0' & Next_Thread_Valid_reg & idle_thread_valid(current_CPU) & temp_CPUID;

        idle_thread_valid               <= idle_thread_valid_next;
        temp_valid                      <= temp_valid_next;
        inside_reset                    <= inside_reset_next;
        Preemption_Interrupt_Enable     <= Preemption_Interrupt_Enable_next;
        sched_busy                      <= sched_busy_next;
        Next_Thread_Valid_reg           <= Next_Thread_Valid_next;
        current_CPU                     <= current_CPU_next;
      end if;
    end if;
  end process MASTER_FSM_STATE_PROC;

-- *************************************************************************
-- Process: MASTER_FSM_LOGIC_PROC
-- Purpose: Combinational process that contains all state machine logic and
-- state transitions for the master state machine
-- *************************************************************************
  MASTER_FSM_LOGIC_PROC : process (
    reset_addr, next_thread_id_reg, lookup_entry, sched_param, dequeue_entry, enqueue_entry, old_priority,
    new_priority, lookup_id, idle_thread_id, idle_thread_valid, temp_valid, current_state_master, inside_reset,
    Preemption_Interrupt_Enable, Enqueue_Request, Dequeue_Request, Is_Queued_Request, Is_Empty_Request, Idle_Id_Request, 
    SYSCALL_Lock_Request, MALLOC_Lock_Request, Current_Request, Next_Request, Priority_Request, 
    Debug_0_Request, Debug_1_Request, Debug_2_Request, Error_Request, Set_SchedParam_Request, Get_SchedParam_Request, 
    Check_SchedParam_Request, Preemption_Request, Bus2IP_Data, Get_IdleThread_Request, Set_IdleThread_Request, 
    Get_Entry_Request, Bus2IP_RdCE_concat, Bus2IP_WrCE_concat, Soft_Reset, DOA, lock_op, syscall_mutex, malloc_mutex,
    lock_count, syscall_mutex_holder, malloc_mutex_holder, debug_reg_0, current_thread_id_reg, TM2SCH_current_cpu_tid, Bus2IP_Addr,
    sched_busy, Next_Thread_Valid_reg, SWTM_DOB, encoder_input, encoder_output, encoder_enable, enqueue_pri_entry, deq_pri_entry, 
    old_tail_ptr, DOB, DOU, TM2SCH_data,current_priority_reg, current_CPU, temp_id, temp_idle_id, mst_cmd_sm_busy, debug_reg_1, debug_reg_2) is

    -- Idle Variable, concatenation of all request signals
    variable idle_concat             : std_logic_vector(0 to 20);

    -- Checks the validity of the SET_SCHED_PARAM request
    variable check_valid                    : std_logic_vector(0 to 7);

  begin
    IP2Bus_Error                        <= '0';                -- no error

	IP2Bus_Addr						<= (others => '0');
    IP2Bus_MstWrReq     <= '0';
    IP2Bus_MstWr_d      <= (others => '0');

    Reset_Done                          <= '0';      -- reset is done unless we override it later
    encoder_reset                       <= '0';
    encoder_enable_next                 <= '0';

    bus_data_out                        <= (others => '0');
    bus_data_ready                      <= '0';
    bus_ack_ready                       <= '0';
    TM_data_out                         <= (others => '0');
    TM_data_ready                       <= '0';

    ADDRA                               <= (others => '0');
    DIA                                 <= (others => '0');
    ENA                                 <= '0';
    WEA                                 <= '0';

    ADDRB                               <= (others => '0');
    DIB                                 <= (others => '0');
    ENB                                 <= '0';
    WEB                                 <= '0';

    ADDRU                               <= (others => '0');
    DIU                                 <= (others => '0');
    ENU                                 <= '0';
    WEU                                 <= '0';

    SWTM_ADDRB                          <= (others => '0');
    SWTM_DIB                            <= (others => '0');
    SWTM_ENB                            <= '0';
    SWTM_WEB                            <= '0';

    enqueue_pri_entry_next              <= enqueue_pri_entry;
    deq_pri_entry_next                  <= deq_pri_entry;
    old_tail_ptr_next                   <= old_tail_ptr;
    encoder_input_next                  <= encoder_input;
    next_state_master                   <= current_state_master;    
    next_thread_id_next                 <= next_thread_id_reg;
    lookup_entry_next                   <= lookup_entry;
    sched_param_next                    <= sched_param;
    dequeue_entry_next                  <= dequeue_entry;
    enqueue_entry_next                  <= enqueue_entry;
    old_priority_next                   <= old_priority;
    new_priority_next                   <= new_priority;
    lookup_id_next                      <= lookup_id;
    idle_thread_id_next                 <= idle_thread_id;  
    lock_count_next                     <= lock_count;
    lock_op_next                        <= lock_op;
    syscall_mutex_next                  <= syscall_mutex;
    malloc_mutex_next                   <= malloc_mutex;
    syscall_mutex_holder_next           <= syscall_mutex_holder;
    malloc_mutex_holder_next            <= malloc_mutex_holder;
    debug_reg_next_0                    <= debug_reg_0;
    idle_thread_valid_next              <= idle_thread_valid;
    temp_valid_next                     <= temp_valid;
    inside_reset_next                   <= inside_reset;
    sched_busy_next                     <= sched_busy;
    Next_Thread_Valid_next              <= Next_Thread_Valid_reg;
    current_CPU_next                    <= current_CPU;
    current_priority_next               <= current_priority_reg;
    temp_id_next                        <= temp_id;
    temp_idle_id_next                   <= temp_idle_id;

    Preemption_Interrupt_Line           <= (others => '0');
    Preemption_Interrupt_Enable_next    <= Preemption_Interrupt_Enable;

    case current_state_master is
      when idle =>

        -- Assign to variable for case statement
        idle_concat := (Enqueue_Request & Dequeue_Request & Set_SchedParam_Request & Get_SchedParam_Request & Check_SchedParam_Request &
                        Preemption_Request & Get_IdleThread_Request & Set_IdleThread_Request & Is_Queued_Request & Is_Empty_Request & 
                        Get_Entry_Request & SYSCALL_Lock_Request & MALLOC_Lock_Request & Idle_Id_Request & Current_Request & 
                        Next_Request & Priority_Request & Debug_0_Request & Debug_1_Request & Debug_2_Request &  Error_Request);

        -- Decode request
        case (idle_concat) is

          when "100000000000000000000"          => next_state_master                   <= ENQ_begin;                   -- Enqueue
          when "010000000000000000000"          => next_state_master                   <= DEQ_begin;                   -- Dequeue
          when "001000000000000000000"          => next_state_master                   <= SET_SCHED_PARAM_begin;       -- Set_SchedParam
          when "000100000000000000000"          => next_state_master                   <= GET_SCHED_PARAM_begin;       -- Get_SchedParam
          when "000010000000000000000"          => next_state_master                   <= CHECK_SCHED_PARAM_begin;     -- Check_SchedParam
          when "000001000000000000000"          => next_state_master                   <= SET_PREEMPTION_begin;        -- SET_Preemption
          when "000000100000000000000"          => next_state_master                   <= GET_IDLE_THREAD_begin;       -- Get_IdleThread
          when "000000010000000000000"          => next_state_master                   <= SET_IDLE_THREAD_begin;       -- Set_IdleThread
          when "000000001000000000000"          => next_state_master                   <= IS_QUEUED_begin;             -- Is_Queued
          when "000000000100000000000"          => next_state_master                   <= IS_EMPTY_check;              -- Is_Empty
          when "000000000010000000000"          => next_state_master                   <= GET_ENTRY_begin;             -- Get_Entry
          when "000000000001000000000"          => next_state_master                   <= SYSCALL_LOCK;                -- Lock syscalls
          when "000000000000100000000"          => next_state_master                   <= MALLOC_LOCK;                 -- Lock context switches
          when "000000000000010000000"          => next_state_master                   <= IDLE_ID_DEQ;                 -- Run Idle Thread
          when "000000000000001000000"          => next_state_master                   <= READ_CURRENT;                -- Read Current Thread ID's
          when "000000000000000100000"          => next_state_master                   <= READ_NEXT;                   -- Read Next Thread ID
          when "000000000000000010000"          => next_state_master                   <= READ_PRIORITY;               -- Read Priority Register
          when "000000000000000001000"          => next_state_master                   <= READ_DEBUG_0;                -- Read Debug Reg 0
          when "000000000000000000100"          => next_state_master                   <= READ_DEBUG_1;                -- Read Debug Reg 1
          when "000000000000000000010"          => next_state_master                   <= READ_DEBUG_2;                -- Read Debug Reg 2
          when "000000000000000000001"          => bus_data_out                        <= (others => '1');             -- Error!!!
                                                  bus_data_ready                         <= '1';
                                                  bus_ack_ready                          <= '1';
                                                  next_state_master                      <= wait_trans_done;
          when others                             => next_state_master                   <= idle;                        -- Others, stay in idle state
        end case;

      when wait_trans_done =>
        -- Goal of this state is to return to the idle state ONLY (iff) the bus transaction has COMPLETELY ended!
        bus_data_ready      <= '0';             -- de-assert bus transaction signals
        bus_ack_ready       <= '0';
        if( Bus2IP_RdCE_concat = '0' and Bus2IP_WrCE_concat = '0' ) then
          next_state_master <= idle;
        end if;

        ----------------------------
        -- RESET: begin
        ----------------------------
      when reset =>
        WEA      <= '0';                        -- Turn off any BRAM access that was active
        ENA      <= '0';
        WEB      <= '0';
        ENB      <= '0';
        WEU      <= '0';
        ENU      <= '0';
        SWTM_WEB <= '0';
        SWTM_ENB <= '0';

        encoder_reset <= '1';                   -- Reset priority encoder

        TM_data_out   <= (others => '0');       -- Reset TM data out
        TM_data_ready <= '1';

        Reset_Done <= '0';                      -- De-assert Reset_Done

        next_state_master <= reset_BRAM;

      when reset_BRAM =>
        ADDRA <= reset_addr;                    -- setup BRAM write to init. THREAD_DATA entry
        DIA   <= set_priority("1000000", BRAM_init_string(0 to 22) & reset_addr);
        ENA   <= '1';
        WEA   <= '1';

        ADDRB <= reset_addr;                    -- setup BRAM write to init. PRIORITY_DATA entry
        DIB   <= BRAM_init_string;
        ENB   <= '1';
        WEB   <= '1';

        ADDRU <= reset_addr;                    -- setup BRAM write to init. PARAM_DATA entry
        DIU   <= BRAM_init_string;
        ENU   <= '1';
        WEU   <= '1';

        if( reset_addr = "011111111" ) then
          next_state_master <= reset_wait_4_ack;
        end if;

      when reset_wait_4_ack =>
        ENA <= '0';                             -- turn off BRAM access
        WEA <= '0';
        ENB <= '0';                             -- turn off BRAM access
        WEB <= '0';
        ENU <= '0';                             -- turn off BRAM access
        WEU <= '0';

        Reset_Done <= '1';                      -- Assert that reset has completed

        if( Soft_Reset = '0' ) then             -- if reset is complete
          Reset_Done        <= '0';             -- de-assert that reset is complete
          inside_reset_next <= '0';             -- de-assert to signal that process is no longer in reset
          debug_reg_next_0  <= x"AAAAAAAA";

          -- Default values for system locks
          lock_count_next           <= (others => '0');
          syscall_mutex_next        <= '0';
          malloc_mutex_next         <= '0';
          syscall_mutex_holder_next <= (others => '1');
          malloc_mutex_holder_next  <= x"FF";

          next_state_master <= idle;            -- return to idle stage
        end if;
        ----------------------------
        -- RESET: end
        ----------------------------

        ----------------------------
        -- ENQ: begin
        ----------------------------
      when ENQ_begin =>
        debug_reg_next_0 <= TM2SCH_data & Z32(8 to 31);  -- store debug info

        sched_busy_next <= '1';                 -- assert that scheduler is busy

        lookup_id_next <= TM2SCH_data;          -- store threadID to ENQ

        ADDRA <= '0' & TM2SCH_data;             -- setup BRAM read for tid to enqueue from THREAD_DATA
        ENA   <= '1';
        WEA   <= '0';

        ADDRU <= '0' & TM2SCH_data;             -- setup BRAM read for tid to enqueue from PARAM_DATA
        ENU   <= '1';
        WEU   <= '0';

        next_state_master <= ENQ_lookup_enqueue_entry_idle;

      when ENQ_lookup_enqueue_entry_idle =>
        -- idle stage
		next_state_master <= ENQ_check_idle;

	  when ENQ_check_idle =>
		-- Default assumes not an idle thread
		next_state_master <= ENQ_lookup_enqueue_entry_finished;
		for i in 0 to (C_NUM_CPUS - 1) loop
			if(lookup_id = idle_thread_id((i * 8) to ((i * 8) + 7))) then
				-- TM is trying to add an idle thread to the R2RQ, abort ENQUEUE operation
				TM_data_out             <= x"80";
        		TM_data_ready           <= '1';
        		sched_busy_next         <= '0';
        		next_state_master       <= idle;
			end if;
		end loop;

      when ENQ_lookup_enqueue_entry_finished =>
        -- DOA has THREAD_DATA entry for tid to ENQ
        -- DOU has PARAM_DATA entry for tid to ENQ

        -- Check scheduling paramter:
        --  If HW range:    start HW thread
        --  If SW range:    add thread to ready-to-run queue
        case ( DOU(0 to 24) ) is
          when "0000000000000000000000000" =>
            -- SW-valid range, proceed with ENQ operation...
            debug_reg_next_0              <= debug_reg_0(0 to 27) & "1000";

            Next_Thread_Valid_next      <= '0';							-- Invalidate next_thread register

            enqueue_entry_next          <= set_queue_bit('1', DOA);     -- Set as queued and store entry
            new_priority_next           <= get_priority(DOA);           -- Assigned priority to this signal b/c used to address encoder_input

            ADDRB <= "00" & get_priority(DOA);                          -- setup BRAM read to get PRIORITY_DATA entry for the enq'd thread
            ENB   <= '1';
            WEB   <= '0';

            next_state_master <= ENQ_lookup_enqueue_pri_entry_idle;

          when others =>
            -- HW-valid range, proceed with start HW thread operation...
            debug_reg_next_0 <= debug_reg_0(0 to 27) & "1110";

            sched_param_next <= DOU;    -- store scheduling param. (base addr. of HW thread)

            TM_data_out     <= Z32(0 to 7);  -- return status to the TM, so the TM will continue processing
            TM_data_ready   <= '1';     -- and unlock the bus
            sched_busy_next <= '0';

            bus_data_out   <= Z32(0 to 27) & HW_THREAD_START;  -- put data on bus w/o ACK (for the upcoming write operation)
            bus_data_ready <= '1';
            bus_ack_ready  <= '0';

            next_state_master <= ENQ_start_hw_thread_begin;
        end case;


-- ***************************************************************************************************
        when ENQ_start_hw_thread_begin =>
            -- Start a bus write transaction to start HW thread
            IP2Bus_Addr         <= sched_param;     -- write to base addr. of HW thread (data was put on bus in previous state)
            IP2Bus_MstWrReq     <= '1';
            IP2Bus_MstWr_d      <= Z32(0 to 27) & HW_THREAD_START;  -- put data to write on bus w/o ACK
            next_state_master   <= ENQ_start_hw_thread_finished;

        when ENQ_start_hw_thread_finished =>
              if (mst_cmd_sm_busy = '0') then
                    -- Master FSM has finished our request, de-assert request lines, and continue on
                    -- HW thread has been started
                    -- TM has already been ACK'ed
                    -- now just return to idle
                    IP2Bus_Addr         <= (others => '0');     -- write to base addr. of HW thread (data was put on bus in previous state)
                    IP2Bus_MstWrReq     <= '0';
                    IP2Bus_MstWr_d      <= (others => '0');  -- put data to write on bus w/o ACK
                    next_state_master   <= idle;
              else
                    -- Master FSM has not yet detected the request, persist
                    IP2Bus_Addr         <= sched_param;     -- write to base addr. of HW thread (data was put on bus in previous state)
                    IP2Bus_MstWrReq     <= '1';
                    IP2Bus_MstWr_d      <= Z32(0 to 27) & HW_THREAD_START;  -- put data to write on bus w/o ACK
                    next_state_master   <= ENQ_start_hw_thread_finished;
              end if;

-- ***************************************************************************************************
      when ENQ_lookup_enqueue_pri_entry_idle =>
        -- idle stage
        next_state_master <= ENQ_lookup_enqueue_pri_entry_finished;

      when ENQ_lookup_enqueue_pri_entry_finished =>
        enqueue_pri_entry_next <= DOB;  -- store pri_entry

        if(is_encoder_bit_zero(conv_integer(new_priority), encoder_input)) then
          -- Queue is empty for this priority level
          -- set encoder_input bit for given priority
          encoder_input_next  <= set_encoder_bit('1', conv_integer(get_priority(enqueue_entry)), encoder_input);
          encoder_enable_next <= '1';   -- allow the priority encoder to process, 1
          next_state_master   <= ENQ_init_head_pointer;
        else
          -- Queue is not empty for this priority level
          old_tail_ptr_next   <= get_tail_pointer(DOB);  -- store old tail_ptr
          next_state_master   <= ENQ_lookup_old_tail_ptr;
        end if;

      when ENQ_init_head_pointer =>
        -- Set head_ptr to the lookup_id
        enqueue_pri_entry_next <= set_head_pointer(lookup_id, enqueue_pri_entry);
        next_state_master      <= ENQ_init_tail_pointer;

      when ENQ_init_tail_pointer =>
        -- Set tail_ptr to the lookup_id
        enqueue_pri_entry_next <= set_tail_pointer(lookup_id, enqueue_pri_entry);
        next_state_master      <= ENQ_wait_for_encoder_0;

      when ENQ_wait_for_encoder_0 =>
        -- idle stage
        next_state_master <= ENQ_write_back_entries;

      when ENQ_lookup_old_tail_ptr =>
        ADDRA <= '0' & old_tail_ptr;    -- setup read of old tail_ptr
        ENA   <= '1';
        WEA   <= '0';

        next_state_master <= ENQ_lookup_old_tail_ptr_idle;

      when ENQ_lookup_old_tail_ptr_idle =>
        -- idle stage
        next_state_master <= ENQ_lookup_old_tail_ptr_finished;

      when ENQ_lookup_old_tail_ptr_finished =>
        -- setup write to make old_tail_ptr's next_ptr point to newly enq'd thread
        ADDRA <= '0' & old_tail_ptr;
        ENA   <= '1';
        WEA   <= '1';
        DIA   <= set_next_pointer(lookup_id, DOA);

        -- Update enqueue_entry's prev. ptr to point to old_tail_ptr
        enqueue_entry_next <= set_prev_pointer(old_tail_ptr, enqueue_entry);

        -- Update priority entry's tail_ptr to be newly enq'd thread
        enqueue_pri_entry_next <= set_tail_pointer(lookup_id, enqueue_pri_entry);

        next_state_master <= ENQ_write_back_entries;

      when ENQ_write_back_entries =>
        ADDRA <= '0' & lookup_id;       -- Write back enqueue_entry
        ENA   <= '1';
        WEA   <= '1';
        DIA   <= enqueue_entry;

        ADDRB <= "00" & get_priority(enqueue_entry);  -- Write back enqueue_pri_entry
        ENB   <= '1';
        WEB   <= '1';
        DIB   <= enqueue_pri_entry;

        next_state_master <= ENQ_lookup_highest_pri_entry;

      when ENQ_lookup_highest_pri_entry =>
        ADDRB	<= "00"  & encoder_output;	-- setup read of highest PRIORITY_DATA entry in system
        ENB	<= '1';
        WEA	<= '0';

        --ADDRA   <= '0' & TM2SCH_current_cpu_tid_reg;	-- setup read of currently running thread
        --ENA	<= '1';
        --WEA	<= '0';

        next_state_master <= ENQ_lookup_highest_pri_entry_idle;

      when ENQ_lookup_highest_pri_entry_idle =>
        -- idle stage
        next_state_master <= ENQ_lookup_highest_pri_entry_finished;

      when ENQ_lookup_highest_pri_entry_finished =>
        -- DOA has current thread entry
        -- DOB has highest priority entry
        --current_entry_pri_value_next	<= get_priority(DOA);		-- store current_entry's priority
        next_thread_id_next  	<= get_head_pointer(DOB);	-- store next_thread_id
        current_CPU_next <= check_preempt(encoder_output, current_priority_reg);
        next_state_master     <= ENQ_preemption_check_idle;

      when ENQ_preemption_check_idle =>
        -- idle state
        next_state_master <= ENQ_preemption_check;

      when ENQ_preemption_check =>
        if(current_CPU < C_NUM_CPUS) then
          -- If we make it here then we have found a processor that should be preempted in favor of the
          -- newly enqueued thread.  This means that a thread with a 'better' priority exists in the R2RQ
          -- than what is currently executing on current_CPU.  When this occurs, preempt the corresponding CPU.
          debug_reg_next_0 <= debug_reg_0(0 to 7) & get_head_pointer(DOB) & encoder_output & '1' & debug_reg_0(24 to 31);

          -- Preempt the corresponding processor
          Preemption_Interrupt_Line(current_CPU) <= '1';
        else
            debug_reg_next_0 <= debug_reg_0(0 to 7) & get_head_pointer(DOB) & encoder_output & '0' & debug_reg_0(24 to 31);
        end if;

        TM_data_out             <= get_queue_bit(enqueue_entry) & Z32(1 to 7);  -- return 0x80 to TM
        TM_data_ready           <= '1';

        Next_Thread_Valid_next  <= '1';       -- Revalidate
        sched_busy_next         <= '0';

        next_state_master       <= idle;
        ----------------------------
        -- ENQ: end
        ----------------------------

        ----------------------------
        -- DEQ: begin
        ----------------------------
      when DEQ_begin =>
		debug_reg_next_0          <= debug_reg_0(0 to 16) & TM2SCH_data & Z32(25 to 31);  -- store debug info

        sched_busy_next         <= '1';  	-- assert that scheduler is busy
        Next_Thread_Valid_next  <= '0';	

        -- Get CPU to Dequeue from the ThreadManager
        current_CPU_next <= conv_integer(TM2SCH_data);
        next_state_master <= DEQ_get_CPU_idle;

      when DEQ_get_CPU_idle =>
        -- idle state
        next_state_master <= DEQ_lookup_dequeue_entry;

      when DEQ_lookup_dequeue_entry =>
        -- Dequeue thread from processor current_CPU
        ADDRA <= '0' & TM2SCH_current_cpu_tid((8 * current_CPU) to (8 * current_CPU + 7)); -- setup BRAM read of thread to dequeue
        ENA   <= '1';
        WEA   <= '0';

        next_state_master <= DEQ_lookup_dequeue_entry_idle;

      when DEQ_lookup_dequeue_entry_idle =>
        -- idle stage      
        next_state_master <= DEQ_lookup_dequeue_entry_finished;

      when DEQ_lookup_dequeue_entry_finished =>

        dequeue_entry_next <= set_queue_bit('0', DOA);  -- store entry in variable and clear queue-bit
        ADDRB <= "00" & get_priority(DOA);  -- setup read of deq_pri_entry
        ENB   <= '1';
        WEB   <= '0';

        -- Update priorities!!!
        current_priority_next((7 * current_CPU) to (7 * current_CPU + 6)) <= get_priority(DOA);

        next_state_master <= DEQ_lookup_deq_pri_entry_idle;

      when DEQ_lookup_deq_pri_entry_idle =>
        -- idle stage
        next_state_master <= DEQ_lookup_deq_pri_entry_finished;

      when DEQ_lookup_deq_pri_entry_finished =>
        deq_pri_entry_next <= DOB;      -- store deq entry from PRIORITY_DATA

        if(get_head_pointer(DOB) = get_tail_pointer(DOB)) then
          -- If list priority Q has 1 element (head = tail) then list will now be empty
          -- Clear encoder bit for given priority
          encoder_input_next <= set_encoder_bit('0', conv_integer(get_priority(dequeue_entry)), encoder_input);

          encoder_enable_next <= '1';   -- allow the priority encoder to process, 1
          next_state_master   <= DEQ_wait_for_encoder_0;
        else
          -- Otherwise...
          ADDRA               <= '0' & get_head_pointer(DOB);  -- setup read of head_ptr
          ENA                 <= '1';
          WEA                 <= '0';

          next_state_master <= DEQ_lookup_old_head_ptr_idle;
        end if;

      when DEQ_wait_for_encoder_0 =>
        -- idle stage
        next_state_master <= DEQ_wait_for_encoder_1;

      when DEQ_wait_for_encoder_1 =>
        -- idle stage
        next_state_master <= DEQ_wait_for_encoder_2;

      when DEQ_wait_for_encoder_2 =>
        -- idle stage
        next_state_master <= DEQ_write_back_entries;

      when DEQ_lookup_old_head_ptr_idle =>
        -- idle stage
        next_state_master <= DEQ_lookup_old_head_ptr_finished;

      when DEQ_lookup_old_head_ptr_finished =>
        -- DOA has old_head_ptr entry

        -- update head_ptr to be next_ptr of old head_ptr
        deq_pri_entry_next <= set_head_pointer(get_next_pointer(DOA), deq_pri_entry);

        next_state_master <= DEQ_write_back_entries;

      when DEQ_write_back_entries =>
        ADDRA <= '0' & TM2SCH_current_cpu_tid((8 * current_CPU) to (8 * current_CPU) + 7);
        ENA   <= '1';
        WEA   <= '1';
        DIA   <= dequeue_entry;

        ADDRB <= "00" & get_priority(dequeue_entry);  -- setup write to update deq_pri_entry
        ENB   <= '1';
        WEB   <= '1';
        DIB   <= deq_pri_entry;

        next_state_master <= DEQ_check_encoder_output;

      when DEQ_check_encoder_output =>
        if(encoder_input = 0 ) then
		  debug_reg_next_0 <= debug_reg_0(0 to 29) & "01";
          -- No queued threads in the system: finish with invalid next thread
          Next_Thread_Valid_next      <= '0';

          TM_data_out   <= Z32(0 to 7);  -- return all 0's (success) to TM
          TM_data_ready <= '1';

          sched_busy_next   <= '0';     -- de-assert busy signal
          next_state_master <= idle;
        else
		  -- Queued threads exist...
          ADDRB             <= "00" & encoder_output;  -- setup read of highest priority (PRIORITY_DATA) entry
          ENB               <= '1';
          WEB               <= '0';

          next_state_master <= DEQ_lookup_highest_pri_entry_idle;
        end if;

      when DEQ_lookup_highest_pri_entry_idle =>
        -- idle stage
        next_state_master <= DEQ_lookup_highest_pri_entry_finished;

      when DEQ_lookup_highest_pri_entry_finished =>
        next_thread_id_next     <= get_head_pointer(DOB);  -- store next_thread_id

		debug_reg_next_0 <= debug_reg_0(0 to 29) & "11";
        TM_data_out             <= Z32(0 to 7);         -- return all 0's (success) to TM
        TM_data_ready           <= '1';

        Next_Thread_Valid_next  <= '1';
        sched_busy_next         <= '0';			-- de-assert busy signal

        next_state_master       <= idle;
        ----------------------------
        -- DEQ: end
        ----------------------------

        ----------------------------
        -- SET_sched_param: begin
        ----------------------------
      when SET_SCHED_PARAM_begin  =>
        temp_valid_next         <= Next_Thread_Valid_reg;
        Next_Thread_Valid_next  <= '0';                         -- Invalidate ALL current threads

        -- Get CPU info from the bus
        current_CPU_next <= conv_integer(Bus2IP_Addr(14 to 15));

        lookup_id_next <= Bus2IP_Addr(16 to 23);  -- store tid

        sched_param_next  <= Bus2IP_Data(0 to 31);  -- store sched_param
        new_priority_next <= Bus2IP_Data(25 to 31);  -- store priority (low 7 bits of sched_param)

        ADDRU <= '0' & Bus2IP_Addr(16 to 23);  -- setup BRAM write to update sched param value in PARAM_DATA
        DIU   <= Bus2IP_Data(0 to 31);
        ENU   <= '1';
        WEU   <= '1';

        -- Check to see if sched param is in SW-valid range
        case ( Bus2IP_Data(0 to 24) ) is
          when "0000000000000000000000000" =>  -- SW-valid range, proceed with a set_priority operation
            debug_reg_next_0 <= "10" & Z32(2 to 31);
            next_state_master <= SET_SCHED_PARAM_lookup_setpri_entries_begin;
          when others                      =>  -- HW-valid range, simply end, no error checks
            debug_reg_next_0 <= "01" & Z32(2 to 31);
			next_state_master <= SET_SCHED_PARAM_revalidate;
        end case;

  	  when SET_SCHED_PARAM_revalidate =>
			Next_Thread_Valid_next                  <= temp_valid;       -- Revalidate ALL current threads
			next_state_master <= SET_SCHED_PARAM_return_with_no_error;

      when SET_SCHED_PARAM_lookup_setpri_entries_begin =>
        ADDRA           <= '0'  & lookup_id;            -- setup BRAM read of thread_id
        ENA             <= '1';
        WEA             <= '0';

        ADDRB           <= "00" & new_priority;         -- setup BRAM read of new_priority_entry
        ENB             <= '1';
        WEB             <= '0';

        SWTM_ADDRB      <= '0'  & lookup_id;            -- setup SWTM_BRAM read of thread_id
        SWTM_ENB        <= '1';
        SWTM_WEB        <= '0';

        next_state_master <= SET_SCHED_PARAM_lookup_setpri_entries_idle;

      when SET_SCHED_PARAM_lookup_setpri_entries_idle =>
        -- idle stage
        next_state_master <= SET_SCHED_PARAM_lookup_setpri_entries_finished;

      when SET_SCHED_PARAM_lookup_setpri_entries_finished =>
        old_priority_next      <= get_priority(DOA);  -- store old_priority value
        lookup_entry_next      <= DOA;  -- store setpri_entry
        enqueue_pri_entry_next <= DOB;  -- store new_priority_entry

        -- Check Validity of Set_Priority operation
        check_valid := TM2SCH_current_cpu_tid((8 * current_CPU) to ((8 * current_CPU) + 7));
		  -- Commented line out below - Maximum frequency changed from 130 MHz to 119 MHz
		  --if((SWTM_DOB(26) = '1') and ((lookup_id or SWTM_DOB(16 to 23)) = check_valid)) then
		  if((SWTM_DOB(26) = '1') and ((lookup_id = check_valid) or (SWTM_DOB(16 to 23) = check_valid))) then		
          if(get_queue_bit(DOA) = '1') then
            debug_reg_next_0 <= debug_reg_0(0 to 1) & "10" & check_valid & Z32(12 to 31);

            -- If QUEUED...
            ADDRB             <= "00" & get_priority(DOA);  -- setup read of old_pri_entry
            ENB               <= '1';
            WEB               <= '0';

            next_state_master <= SET_SCHED_PARAM_lookup_old_pri_entry_idle;
          else
            debug_reg_next_0 <= debug_reg_0(0 to 1) & "01" & check_valid & Z32(12 to 31);

            -- IF ~QUEUED...
            ADDRA             <= '0' & lookup_id;  -- setup BRAM write to update priority value in THREAD_DATA
            DIA               <= set_priority(new_priority, DOA);
            ENA               <= '1';
            WEA               <= '1';

            -- Skip the preemption check
            current_CPU_next  <= C_NUM_CPUS;

            -- Finish by merging back into path of queued thread
            --next_state_master <= SET_SCHED_PARAM_revalidate;
            next_state_master <= SET_SCHED_PARAM_check_if_current;
          end if;			  
        else
          -- Otherwise, return with an error b/c operation cannot be completed...
          next_state_master   <= SET_SCHED_PARAM_return_with_error;
        end if;

    when SET_SCHED_PARAM_check_if_current =>
        current_CPU_next    <= check_if_current(lookup_id, current_thread_id_reg);
        next_state_master <= SET_SCHED_PARAM_update_current_priorities;
      
    when SET_SCHED_PARAM_update_current_priorities =>
        -- Update current priority field if this thread is currently running
        if (current_CPU < C_NUM_CPUS) then
        	current_priority_next((7 * current_CPU) to (7 * current_CPU + 6)) <= new_priority;
        end if;

        next_state_master <= SET_SCHED_PARAM_check_encoder;

      when SET_SCHED_PARAM_lookup_old_pri_entry_idle =>
        -- idle stage
        next_state_master <= SET_SCHED_PARAM_lookup_old_pri_entry_finished;

      when SET_SCHED_PARAM_lookup_old_pri_entry_finished =>
        deq_pri_entry_next <= DOB;      -- store old_priority_entry

        next_state_master <= SET_SCHED_PARAM_priority_field_check;

      when SET_SCHED_PARAM_priority_field_check =>
        -- update priority value to new_priority
        lookup_entry_next <= set_priority(new_priority, lookup_entry);

        -- If (head_ptr = tail_ptr) then Q will now be empty
        if(get_tail_pointer(deq_pri_entry) = get_head_pointer(deq_pri_entry)) then
          -- Clear encoder bit for given priority
          encoder_input_next  <= set_encoder_bit('0', conv_integer(old_priority), encoder_input);
          next_state_master   <= SET_SCHED_PARAM_begin_add_to_new_pri_queue;
        else                            -- If the Q will not be empty
          -- If the head is being deq'd
          if(lookup_id = get_head_pointer(deq_pri_entry)) then
            -- Setup BRAM read of old head_ptr's entry
            ADDRA             <= '0' & get_head_pointer(deq_pri_entry);
            ENA               <= '1';
            WEA               <= '0';
            next_state_master <= SET_SCHED_PARAM_lookup_old_head_ptr_idle;

          -- If the tail is being deq'd
          elsif ( lookup_id = get_tail_pointer(deq_pri_entry) ) then
            -- Setup BRAM read of old tail_ptr's entry
            ADDRA             <= '0' & get_tail_pointer(deq_pri_entry);
            ENA               <= '1';
            WEA               <= '0';
            next_state_master <= SET_SCHED_PARAM_lookup_old_tail_ptr_idle;

          -- If an item in the "middle" of the list is being deq'd
          else
            -- Setup BRAM read of prev_ptr's entry
            ADDRA             <= '0' & get_prev_pointer(lookup_entry);
            ENA               <= '1';
            WEA               <= '0';
            next_state_master <= SET_SCHED_PARAM_lookup_prev_ptr_idle;
          end if;
        end if;

      when SET_SCHED_PARAM_lookup_old_head_ptr_idle =>
        -- idle stage
        next_state_master <= SET_SCHED_PARAM_lookup_old_head_ptr_finished;

      when SET_SCHED_PARAM_lookup_old_head_ptr_finished =>
        -- DOA has old head_ptr entry on it
        deq_pri_entry_next <= set_head_pointer(get_next_pointer(DOA), deq_pri_entry);
        next_state_master  <= SET_SCHED_PARAM_write_back_deq_pri_entry;

      when SET_SCHED_PARAM_lookup_old_tail_ptr_idle =>
        -- idle stage
        next_state_master <= SET_SCHED_PARAM_lookup_old_tail_ptr_finished;

      when SET_SCHED_PARAM_lookup_old_tail_ptr_finished =>
        -- DOA has old tail_ptr entry on it
        deq_pri_entry_next <= set_tail_pointer(get_prev_pointer(DOA), deq_pri_entry);
        next_state_master  <= SET_SCHED_PARAM_write_back_deq_pri_entry;

      when SET_SCHED_PARAM_lookup_prev_ptr_idle =>
        -- idle stage
        next_state_master <= SET_SCHED_PARAM_lookup_prev_ptr_finished;

      when SET_SCHED_PARAM_lookup_prev_ptr_finished =>
        -- DOA has prev_ptr entry on it
        -- set next_ptr of prev_ptr to that of next_ptr of setpri_entry (AKA lookup_entry)
        ADDRA <= '0' & get_prev_pointer(lookup_entry);
        ENA   <= '1';
        WEA   <= '1';
        DIA   <= set_next_pointer(get_next_pointer(lookup_entry), DOA);

        next_state_master <= SET_SCHED_PARAM_begin_add_to_new_pri_queue;

      when SET_SCHED_PARAM_write_back_deq_pri_entry =>
        -- Write back old_priority entry (AKA deq_pri_entry)
        ADDRB <= "00" & old_priority;
        ENB   <= '1';
        WEB   <= '1';
        DIB   <= deq_pri_entry;

        next_state_master <= SET_SCHED_PARAM_begin_add_to_new_pri_queue;

      when SET_SCHED_PARAM_begin_add_to_new_pri_queue =>
        -- If the new priority Q is empty...
        if(is_encoder_bit_zero(conv_integer(new_priority), encoder_input)) then
          -- update head_ptr to that of lookup_id (AKA setpri_ID)
          enqueue_pri_entry_next <= set_head_pointer(lookup_id, enqueue_pri_entry);
          -- set encoder input bit for new_priority to '1'
          encoder_input_next     <= set_encoder_bit('1', conv_integer(new_priority), encoder_input);
          -- now update the tail_ptr to that of lookup_id (AKA setpri_ID)
          next_state_master      <= SET_SCHED_PARAM_init_tail_ptr;
        else                            -- new priority Q is not empty
          -- Setup read of old tail_ptr in new Q
          ADDRA                  <= '0' & get_tail_pointer(enqueue_pri_entry);
          ENA                    <= '1';
          WEA                    <= '0';
          next_state_master      <= SET_SCHED_PARAM_lookup_enq_old_tail_ptr_idle;
        end if;

      when SET_SCHED_PARAM_init_tail_ptr =>
        enqueue_pri_entry_next <= set_tail_pointer(lookup_id, enqueue_pri_entry);
        encoder_enable_next    <= '1';  -- allow priority encoder to process, 1a

        next_state_master <= SET_SCHED_PARAM_write_back_entries;

      when SET_SCHED_PARAM_lookup_enq_old_tail_ptr_idle =>
        -- idle stage
        -- Change the prev_ptr of lookup_id (AKA setpri_ID) to that of old_tail_ptr
        lookup_entry_next <= set_prev_pointer(get_tail_pointer(enqueue_pri_entry), lookup_entry);

        next_state_master <= SET_SCHED_PARAM_update_enqueue_info;

      when SET_SCHED_PARAM_update_enqueue_info =>
        -- DOA has old tail_ptr info for new Q
        -- Change & Write-back the old tail_ptr's next_ptr to that of lookup_id (AKA setpri_ID)
        ADDRA <= '0' & get_tail_pointer(enqueue_pri_entry);
        ENA   <= '1';
        WEA   <= '1';
        DIA   <= set_next_pointer(lookup_id, DOA);

        -- Update the tail_ptr of new priority Q to be that of lookup_id (AKA setpri_ID)
        enqueue_pri_entry_next <= set_tail_pointer(lookup_id, enqueue_pri_entry);

        encoder_enable_next <= '1';     -- allow priority encoder to process, 1b

        next_state_master <= SET_SCHED_PARAM_write_back_entries;

      when SET_SCHED_PARAM_write_back_entries =>
        -- Write back lookup_entry (AKA setpri_entry)
        ADDRA <= '0' & lookup_id;
        ENA   <= '1';
        WEA   <= '1';
        DIA   <= lookup_entry;

        -- Write back enqueue_pri_entry (AKA new_priority_entry)
        ADDRB <= "00" & new_priority;
        ENB   <= '1';
        WEB   <= '1';
        DIB   <= enqueue_pri_entry;

        next_state_master <= SET_SCHED_PARAM_wait_for_encoder_0;

      when SET_SCHED_PARAM_wait_for_encoder_0 =>
        -- idle stage
        next_state_master <= SET_SCHED_PARAM_wait_for_encoder_1;

      when SET_SCHED_PARAM_wait_for_encoder_1 =>
        -- idle stage
        next_state_master <= SET_SCHED_PARAM_last_wait_0;

      when SET_SCHED_PARAM_last_wait_0 =>
        -- idle stage
        next_state_master <= SET_SCHED_PARAM_last_wait_1;

      when SET_SCHED_PARAM_last_wait_1 =>
        next_state_master       <= SET_SCHED_PARAM_check_encoder;

      when SET_SCHED_PARAM_check_encoder =>
        debug_reg_next_0 <= debug_reg_0(0 to 11) & new_priority & encoder_output & Z32(26 to 31);
		  
		  -- Continue to find highest priority thread in the system...
        ADDRB	<= "00"  & encoder_output;	-- setup read of highest PRIORITY_DATA entry in system
        ENB	<= '1';
        WEA	<= '0';

        next_state_master <= SET_SCHED_PARAM_lookup_highest_pri_entry_idle;

      when SET_SCHED_PARAM_lookup_highest_pri_entry_idle =>
        -- idle stage
        next_state_master <= SET_SCHED_PARAM_lookup_highest_pri_entry_finished;

      when SET_SCHED_PARAM_lookup_highest_pri_entry_finished =>
        -- DOA has current thread entry
        -- DOB has highest priority entry
        next_thread_id_next  	<= get_head_pointer(DOB);	-- store next_thread_id
        current_CPU_next <= check_preempt(encoder_output, current_priority_reg);

        -- We now know that we have a valid thread in the next_thread register
        Next_Thread_Valid_next	<= temp_valid;  -- '1';

        next_state_master <= SET_SCHED_PARAM_preemption_check_idle;
 
      when SET_SCHED_PARAM_preemption_check_idle =>
        -- idle stage
        next_state_master              <= SET_SCHED_PARAM_preemption_check;

      when SET_SCHED_PARAM_preemption_check =>
        if(current_CPU < C_NUM_CPUS) and (temp_valid = '1') then
          debug_reg_next_0 <= debug_reg_0(0 to 25) & '1' & Z32(27 to 31);
		
          -- Preempt the corresponding processor
          Preemption_Interrupt_Line(current_CPU)        <= '1';
        end if;

        next_state_master <= SET_SCHED_PARAM_return_with_no_error;  -- return to idle stage

      when SET_SCHED_PARAM_return_with_error =>
        ENA <= '0';
        WEA <= '0';

        debug_reg_next_0 <= debug_reg_0(0 to 30) & '1';

        bus_data_out   <= Z32(0 to 27) & "0000";  -- return with error status (not possible with write op's, so just return all 0's)
        bus_data_ready <= '1';
        bus_ack_ready  <= '1';

        Next_Thread_Valid_next                  <= temp_valid;       -- Revalidate ALL current threads

        next_state_master <= wait_trans_done;

      when SET_SCHED_PARAM_return_with_no_error =>
        ENA <= '0';
        WEA <= '0';

        debug_reg_next_0 <= debug_reg_0(0 to 30) & '0';

        bus_data_out   <= Z32(0 to 27) & "0000";  -- return with successful status
        bus_data_ready <= '1';
        bus_ack_ready  <= '1';

        next_state_master <= wait_trans_done;
        ----------------------------
        -- SET_sched_param: end
        ----------------------------

        ----------------------------
        -- GET_sched_param: begin
        ----------------------------
      when GET_SCHED_PARAM_begin =>
        lookup_id_next    <= Bus2IP_Addr(16 to 23);
        next_state_master <= GET_SCHED_PARAM_lookup_entry;

      when GET_SCHED_PARAM_lookup_entry =>
        ADDRU             <= '0' & lookup_id;  -- setup read from PARAM_DATA[tid]
        ENU               <= '1';
        WEU               <= '0';
        next_state_master <= GET_SCHED_PARAM_lookup_entry_idle;

      when GET_SCHED_PARAM_lookup_entry_idle =>
        -- idle stage
        next_state_master <= GET_SCHED_PARAM_lookup_entry_finished;

      when GET_SCHED_PARAM_lookup_entry_finished =>
        -- DOU has sched_param on it

        bus_data_out	<= DOU(0 to 31);	-- return sched_param on bus and ACK
        bus_data_ready	<= '1';
        bus_ack_ready   <= '1';
	
        next_state_master	<= wait_trans_done;
        ----------------------------
        -- GET_sched_param: end
        ----------------------------

        ----------------------------
        -- CHECK_sched_param: begin
        ----------------------------
      when CHECK_SCHED_PARAM_begin =>
        lookup_id_next      <= Bus2IP_Addr(16 to 23);
        next_state_master   <= CHECK_SCHED_PARAM_lookup_entries;

      when CHECK_SCHED_PARAM_lookup_entries =>
        ADDRA	<= '0' & lookup_id;		-- Setup read from THREAD_DATA[tid]
        ENA		<= '1';
        WEA		<= '0';

        ADDRU	<= '0' & lookup_id;		-- Setup read from PARAM_DATA[tid]
        ENU		<= '1';
        WEU		<= '0';

        SWTM_ADDRB	<= '0' & lookup_id;		-- Setup read from SWTM_DATA[tid]
        SWTM_ENB		<= '1';
        SWTM_WEB		<= '0';

        next_state_master	<= CHECK_SCHED_PARAM_lookup_entries_idle;

      when CHECK_SCHED_PARAM_lookup_entries_idle =>
        -- idle stage
        next_state_master	<= CHECK_SCHED_PARAM_lookup_entries_finished;

      when CHECK_SCHED_PARAM_lookup_entries_finished =>
        -- DOA, DOU, and SWTM DOB have entries on them

        -- Error check for properness of sched_param:
        -- * If queued		: sched_param must in the SW-valid range (less than 128)
        -- * If not-queued	: sched param can be in any range
        if(get_queue_bit(DOA) = '1') then
          -- thread is QUEUED
          -- then check to see if Most Significant 25 bits of sched_param are 0's => in SW-valid range
          case ( DOU(0 to 24) ) is
            when "0000000000000000000000000" 	=>	-- SW-valid range, return all 0's
              bus_data_out <= Z32(0 to 31);
            when others							=>	-- Not in SW-valid range, return LSB=1, error bit
              bus_data_out <= Z32(0 to 30) & '1';
          end case;
        else
          -- thread is ~QUEUED, return all 0's
          bus_data_out	<= Z32(0 to 31);
        end if;

        bus_data_ready	<= '1';		-- ACK Bus, with data put on it
        bus_ack_ready   <= '1';

        next_state_master 	<= wait_trans_done;
        ----------------------------
        -- CHECK_sched_param: end
        ----------------------------

        ----------------------------
        -- SET_PREEMPTION: begin
        ----------------------------
		-- Communication - BusCOM
		-- Enables or Disable system wide preemption
		-- returns 0
	  when SET_PREEMPTION_begin =>
        -- Get CPU info from the processor off the bus (bits 14 and 15)
        current_CPU_next  <= conv_integer(Bus2IP_Addr(14 to 15));
        next_state_master <= SET_PREEMPTION_idle;

      when SET_PREEMPTION_idle =>
        -- idle state
        next_state_master <= SET_PREEMPTION_finished;

      when SET_PREEMPTION_finished =>
        -- Enable or Disable preemption based on value sent in Bus2IP_Data
		if(Bus2IP_Data(0) = '0') then
			Preemption_Interrupt_Enable_next <= (others => '0');
		else
			Preemption_Interrupt_Enable_next <= (others => '1');
		end if;

		-- This code allows the user to manually generate an interrupt to the specified processor (debug only)
		if(Bus2IP_Addr(13) = '1') then
	    	Preemption_Interrupt_Line(current_CPU) <= '1';
	    end if;
		  
        bus_data_out                      <= (others => '0');
        bus_data_ready                    <= '1';
        bus_ack_ready                     <= '1';
        next_state_master                 <= wait_trans_done;
        ----------------------------
        -- SET_PREEMPTION: end
        ----------------------------

        ----------------------------
        -- GET_IDLE_THREAD: begin
        ----------------------------
      when GET_IDLE_THREAD_begin =>
        -- Get CPU info from the processor off the bus (bits 14 and 15)
        current_CPU_next <= conv_integer(Bus2IP_Addr(14 to 15));

        next_state_master <= GET_IDLE_THREAD_idle;

      when GET_IDLE_THREAD_idle =>
        -- idle state
        next_state_master <= GET_IDLE_THREAD_finished;

      when GET_IDLE_THREAD_finished =>
        bus_data_out            <= Z32(0 to 22) & idle_thread_id((8 * current_CPU) to ((8 * current_CPU) + 7)) & idle_thread_valid(current_CPU);
        bus_data_ready          <= '1';
        bus_ack_ready           <= '1';
        next_state_master       <= wait_trans_done;
        ----------------------------
        -- GET_IDLE_THREAD: end
        ----------------------------

        ----------------------------
        -- SET_IDLE_THREAD: begin
        ----------------------------
      when SET_IDLE_THREAD_begin =>
        -- Get CPU info from the processor off the bus (bits 14 and 15)
        current_CPU_next <= conv_integer(Bus2IP_Addr(14 to 15));

        lookup_id_next	<= Bus2IP_Addr(16 to 23);               -- store thread_id

        ADDRA 	<= '0' & Bus2IP_Addr(16 to 23);         -- setup BRAM read of THREAD_DATA[tid]
        ENA		<= '1';
        WEA		<= '0';

        ADDRU   <= '0' & Bus2IP_Addr(16 to 23);         -- setup BRAM read of PARAM_DATA[tid]
        ENU		<= '1';
        WEU		<= '0';

        SWTM_ADDRB	<= '0' & Bus2IP_Addr(16 to 23);         -- setup SWTM_BRAM read of thread_id to set_pri
        SWTM_ENB	<= '1';
        SWTM_WEB	<= '0';

        next_state_master <= SET_IDLE_THREAD_lookup_entries_idle;

      when SET_IDLE_THREAD_lookup_entries_idle =>
        -- idle stage
        next_state_master <= SET_IDLE_THREAD_lookup_entries_finished;

      when SET_IDLE_THREAD_lookup_entries_finished =>
        -- Check to see if this thread can become the idle thread
        --  * TID must be ~queued
        --  * TID must be created and used.
        --  * TID must not have a HW sched param.
        if(get_queue_bit(DOA) = '0' and
           SWTM_DOB(26) = '1' and
           DOU(0 to 24) = "0000000000000000000000000") then

          idle_thread_id_next((8 * current_CPU) to (8 * current_CPU + 7))       <= lookup_id;
          idle_thread_valid_next(current_CPU)                                   <= '1';

          debug_reg_next_0 <= Z32(0 to 21) & '0' & '1' & idle_thread_id_next((8 * current_CPU) to (8 * current_CPU + 7));
          next_state_master     <= SET_IDLE_THREAD_return_with_no_error;
        else
          debug_reg_next_0 <= Z32(0 to 21) & '0' & '0' & idle_thread_id_next((8 * current_CPU) to (8 * current_CPU + 7));
          -- This thread cannot become the idle thread
          next_state_master	<= SET_IDLE_THREAD_return_with_error;
        end if;

      when SET_IDLE_THREAD_return_with_error =>
        bus_data_out		<= Z32(0 to 30) & '1';	-- return LSB=1, error bit, on bus and ACK
        bus_data_ready		<= '1';
        bus_ack_ready  		<= '1';
        next_state_master 	<= wait_trans_done;

      when SET_IDLE_THREAD_return_with_no_error =>
        bus_data_out		<= Z32(0 to 31);		-- return all 0's on bus and ACK
        bus_data_ready		<= '1';
        bus_ack_ready  		<= '1';
        next_state_master 	<= wait_trans_done;
        ----------------------------
        -- SET_IDLE_THREAD: end
        ----------------------------

        ----------------------------
        -- IS_QUEUED: begin
        ----------------------------
      when IS_QUEUED_begin =>
        debug_reg_next_0 <= "00" & IS_QUEUED_OPCODE & TM2SCH_data & Z32(16 to 31);  -- store debug info

        sched_busy_next <= '1';          -- assert that operation is busy
        lookup_id_next  <= TM2SCH_data;  -- latch thread_id to lookup

        next_state_master <= IS_QUEUED_lookup_entry;

      when IS_QUEUED_lookup_entry =>
        ADDRA <= '0' & lookup_id;       -- setup BRAM read of lookup thread_id
        ENA   <= '1';
        WEA   <= '0';

        next_state_master <= IS_QUEUED_lookup_entry_idle;

      when IS_QUEUED_lookup_entry_idle =>
        -- idle stage
        next_state_master <= IS_QUEUED_lookup_entry_finished;

      when IS_QUEUED_lookup_entry_finished =>
        ENA <= '0';                     -- turn off BRAM access
        WEA <= '0';

        TM_data_out   <= Z32(0 to 6) & get_queue_bit(DOA);  -- return data to TM
        TM_data_ready <= '1';

        sched_busy_next <= '0';         -- de-assert busy signal

        next_state_master <= idle;
        ----------------------------
        -- IS_QUEUED: end
        ----------------------------

        ----------------------------
        -- IS_EMPTY: begin
        ----------------------------
      when IS_EMPTY_check =>
        debug_reg_next_0 <= "00" & IS_EMPTY_OPCODE & TM2SCH_data & Z32(16 to 31);  -- store debug info

        sched_busy_next   <= '1';       -- assert that scheduler is busy
        next_state_master <= IS_EMPTY_finished;


      when IS_EMPTY_finished =>
        -- Check to see if all queues are empty
        if (encoder_input = 0) then
          TM_data_out <= Z32(0 to 6) & '1';  -- set data_out to true,                (LSB = 1)
        else
          TM_data_out <= Z32(0 to 6) & '0';  -- set data_out to false,               (LSB = 0)
        end if;

        sched_busy_next   <= '0';       -- de-assert busy signal
        TM_data_ready     <= '1';       -- return results to TM
        next_state_master <= idle;
        ----------------------------
        -- IS_EMPTY: end
        ----------------------------

        ----------------------------
        -- GET_ENTRY: begin
        ----------------------------
      when GET_ENTRY_begin =>
        lookup_id_next    <= Bus2IP_Addr(16 to 23);  -- latch thread_id to lookup
        next_state_master <= GET_ENTRY_lookup_entry;

      when GET_ENTRY_lookup_entry =>
        ADDRA <= '0' & lookup_id;       -- setup BRAM read of lookup thread_id
        ENA   <= '1';
        WEA   <= '0';

        next_state_master <= GET_ENTRY_lookup_entry_idle;

      when GET_ENTRY_lookup_entry_idle =>
        -- idle stage 
        next_state_master <= GET_ENTRY_lookup_entry_finished;

      when GET_ENTRY_lookup_entry_finished =>
        ENA <= '0';                     -- turn off BRAM access
        WEA <= '0';

        bus_data_out   <= DOA;          -- return entry on bus
        bus_data_ready <= '1';
        bus_ack_ready  <= '1';

        next_state_master <= wait_trans_done;
        ----------------------------
        -- GET_ENTRY: end
        ----------------------------

		----------------------------
		-- SYSCALL_LOCK: begin
		----------------------------
		-- Communication - BusCom
		-- Submit a request to acquire or release the system call lock
		-- returns zero if the request was denied, one if the request was granted
		when SYSCALL_LOCK =>
			-- Bus2IP_Addr(13) = 0 : RELEASE lock
			-- Bus2IP_Addr(13) = 1 : ACQUIRE lock
			lock_op_next <= Bus2IP_Addr(13);
			
			-- Get CPU info from the processor off the bus (bits 14 and 15)
			current_CPU_next  <= conv_integer(Bus2IP_Addr(14 to 15));
			
			next_state_master <= SYSCALL_LOCK_IDLE;
		
		when SYSCALL_LOCK_idle =>	
			-- idle state
			next_state_master <= SYSCALL_LOCK_idle_finished;
		
		when SYSCALL_LOCK_idle_finished =>
			-- default next state
			next_state_master <= SYSCALL_LOCK_ACQUIRE;
			
			if(lock_op = '0') then
				-- Override default next state
				next_state_master <= SYSCALL_LOCK_RELEASE;
			end if;
		
		when SYSCALL_LOCK_ACQUIRE =>
			if(syscall_mutex = '0') then
				-- Set the mutex
				syscall_mutex_holder_next <= Bus2IP_Addr(14 to 15);
				syscall_mutex_next        <= '1';
				bus_data_out              <= Z32(0 to 30) & '1';
			else
				-- Otherwise return zero on the bus
				bus_data_out   <= Z32(0 to 31);
			end if;
			
			bus_data_ready <= '1';
			bus_ack_ready  <= '1';
			next_state_master <= wait_trans_done;
		
		when SYSCALL_LOCK_RELEASE =>
			if(syscall_mutex_holder = Bus2IP_Addr(14 to 15)) then 
				-- Release the lock
				syscall_mutex_holder_next <= (others => '1');
				syscall_mutex_next        <= '0';
				bus_data_out              <= Z32(0 to 30) & '1';
			else
				bus_data_out       <= Z32(0 to 31);
			end if;
			
			bus_data_ready <= '1';
			bus_ack_ready  <= '1';
			next_state_master <= wait_trans_done;
		----------------------------
		-- SYSCALL_LOCK: end
		----------------------------

		----------------------------
      -- MALLOC_LOCK: begin
      ----------------------------
		-- Communication - BusCom
		-- Submit a request to acquire or release the malloc lock
		-- returns zero if the request was denied, one if the request was granted
      when MALLOC_LOCK =>
			-- Bus2IP_Addr(13) = 0 : RELEASE lock
			-- Bus2IP_Addr(13) = 1 : ACQUIRE lock
			lock_op_next <= Bus2IP_Addr(13);

			-- Store tid requesting the lock
         lookup_id_next <= Bus2IP_Addr(16 to 23);
			
			next_state_master <= MALLOC_LOCK_IDLE;
      
		when MALLOC_LOCK_idle =>	
			-- idle state
			next_state_master <= MALLOC_LOCK_idle_finished;

      when MALLOC_LOCK_idle_finished =>
			-- default next state
			next_state_master <= MALLOC_LOCK_ACQUIRE;

			if(lock_op = '0') then
				-- Override default next state
				next_state_master <= MALLOC_LOCK_RELEASE;
			end if;

      when MALLOC_LOCK_ACQUIRE =>
			if(malloc_mutex = '0') then
				malloc_mutex_holder_next <= lookup_id;
				lock_count_next          <= lock_count + 1;
				malloc_mutex_next        <= '1';
			elsif(malloc_mutex = '1' AND malloc_mutex_holder = lookup_id) then
				lock_count_next <= lock_count + 1;
			end if;
			
			next_state_master <= MALLOC_LOCK_ACQUIRE_RETURN;
		
		when MALLOC_LOCK_ACQUIRE_RETURN =>
			if(malloc_mutex_holder = lookup_id) then
				bus_data_out           <= Z32(0 to 3) & lock_count & malloc_mutex_holder & Z32(16 to 30) & '1';
			else
				bus_data_out           <= Z32(0 to 3) & lock_count & malloc_mutex_holder & Z32(16 to 31);
			end if;
			
			bus_data_ready <= '1';
       	bus_ack_ready  <= '1';
       	next_state_master <= wait_trans_done;

      when MALLOC_LOCK_RELEASE =>
			if(malloc_mutex_holder = lookup_id) then
				lock_count_next <= lock_count - 1;
			end if;	
			next_state_master <= MALLOC_LOCK_RELEASE_next;
			
		when MALLOC_LOCK_RELEASE_next =>
			if(lock_count = x"0") then
				-- Release the lock
				malloc_mutex_next <= '0';
				malloc_mutex_holder_next    <= x"FF";				
			end if;
			next_state_master <= MALLOC_LOCK_RELEASE_RETURN;
		
		when MALLOC_LOCK_RELEASE_RETURN =>
			if(malloc_mutex_holder = lookup_id) then
				bus_data_out <= Z32(0 to 3) & lock_count & malloc_mutex_holder & Z32(16 to 30) & '1';
			else
				bus_data_out <= Z32(0 to 3) & lock_count & malloc_mutex_holder & Z32(16 to 31);
			end if;
			bus_data_ready <= '1';
       	bus_ack_ready  <= '1';
       	next_state_master <= wait_trans_done;
		----------------------------
        -- MALLOC_LOCK: end
      ----------------------------
		  
		----------------------------
        -- IDLE_ID_DEQ: begin
        ----------------------------
		-- Communication - TMCom
		-- This call is similar to get_idle_thread however it is used by the thread manager only
		-- The purpose of this call is to do a pseudo-dequeue of the idle thread, pseudo because idle thread's
		-- are not allowed on the R2RQ
		-- returns the idle thread id for the requesting processor
      when IDLE_ID_DEQ =>
		-- assert that scheduler is busy
		sched_busy_next         <= '1';

        -- Get CPU to Dequeue from the ThreadManager
        current_CPU_next <= conv_integer(TM2SCH_data);
        next_state_master <= IDLE_ID_DEQ_CPU_idle;

      when IDLE_ID_DEQ_CPU_idle =>
		-- idle state
		next_state_master <= IDLE_ID_DEQ_return;

      when IDLE_ID_DEQ_return =>
		-- This must always be true!!
		--if(idle_thread_valid(current_CPU) = '1') then
			TM_data_out <= idle_thread_id((8*current_CPU) to (8*current_CPU + 7));
	
        	-- Set the priority to the default idle thread priority
        	current_priority_next((7 * current_CPU) to (7 * current_CPU + 6)) <= x"7F";
		--else
			-- Return an error to the thread manager
			--TM_data_out <= x"FF";
        --end if;

		TM_data_ready <= '1';
		sched_busy_next <= '0';
		next_state_master <= idle;	
		----------------------------
        -- IDLE_ID_DEQ: end
        ----------------------------

        ----------------------------
        ----------------------------
        -- DEBUG STATES
        ----------------------------
        ----------------------------
        ----------------------------
        -- READ_CURRENT: begin
        ----------------------------
      when READ_CURRENT =>
        bus_data_out   <= current_thread_id_reg(0 to 15) & Z32(16 to 31);    
        bus_data_ready <= '1';
        bus_ack_ready  <= '1';

        next_state_master <= wait_trans_done;
        ----------------------------
        -- READ_CURRENT: end
        ----------------------------

        ----------------------------
        -- READ_NEXT: begin
        ----------------------------
      when READ_NEXT =>
        bus_data_out   <= next_thread_id_reg(0 to 7) & Z32(8 to 31);    
        bus_data_ready <= '1';
        bus_ack_ready  <= '1';

        next_state_master <= wait_trans_done;
        ----------------------------
        -- READ_NEXT: end
        ----------------------------

        ----------------------------
        -- READ_PRIORITY: begin
        ----------------------------
      when READ_PRIORITY =>
        bus_data_out   <= current_priority_reg(0 to 13) & Z32(14 to 31);    
        bus_data_ready <= '1';
        bus_ack_ready  <= '1';

        next_state_master <= wait_trans_done;
        ----------------------------
        -- READ_PRIORITY: end
        ----------------------------

        ----------------------------
        -- READ_DEBUG_0: begin
        ----------------------------
      when READ_DEBUG_0 =>
        bus_data_out   <= debug_reg_0;    
        bus_data_ready <= '1';
        bus_ack_ready  <= '1';

        next_state_master <= wait_trans_done;
        ----------------------------
        -- READ_DEBUG_0: end
        ----------------------------
	
        ----------------------------
        -- READ_DEBUG_1: begin
        ----------------------------
      when READ_DEBUG_1 =>
        bus_data_out   <= debug_reg_1;
        bus_data_ready <= '1';
        bus_ack_ready  <= '1';

        next_state_master <= wait_trans_done;
        ----------------------------
        -- READ_DEBUG_1: end
        ----------------------------

        ----------------------------
        -- READ_DEBUG_2: begin
        ----------------------------
      when READ_DEBUG_2 =>
        bus_data_out   <= debug_reg_2;
        bus_data_ready <= '1';
        bus_ack_ready  <= '1';

        next_state_master <= wait_trans_done;
        ----------------------------
        -- READ_DEBUG_2: end
        ----------------------------
        ----------------------------
        ----------------------------
        -- END OF DEBUG STATES
        ----------------------------
        ----------------------------

      when others => 
        ENA <= '0';		-- turn off any BRAM access
        WEA <= '0';
        ENB <= '0';
        WEB <= '0';
        ENU <= '0';
        WEU <= '0';
        next_state_master <= idle;
    end case;	-- END CASE (current_state_master)
  end process MASTER_FSM_LOGIC_PROC;

end architecture IMP;
