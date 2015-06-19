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

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.all;
use proc_common_v3_00_a.srl_fifo_f;

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

    TM2SCH_current_cpu_tid  : in std_logic_vector(0 to 7);
    TM2SCH_opcode           : in std_logic_vector(0 to 5);
    TM2SCH_data             : in std_logic_vector(0 to 7);
    TM2SCH_request          : in std_logic;
    SCH2TM_busy             : out std_logic;
    SCH2TM_data             : out std_logic_vector(0 to 7);
    SCH2TM_next_cpu_tid     : out std_logic_vector(0 to 7);
    SCH2TM_next_tid_valid   : out std_logic;

    Preemption_Interrupt : out std_logic;
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

  --USER signal declarations added here, as needed for user logic

--  Define the memory map for each command register, Address[24 to 31]
--  This value is the offset from the base address assigned to this module
constant C_TOGGLE_PREEMPTION    : std_logic_vector(0 to 7)	:= "01001000";  -- 0x48
constant C_SET_DEFAULT_PRIORITY : std_logic_vector(0 to 7)	:= "01001100";  -- 0x4C
constant C_GET_IDLE_THREAD 		: std_logic_vector(0 to 7)	:= "01010000";  -- 0x50 
constant C_SET_IDLE_THREAD 		: std_logic_vector(0 to 7)	:= "01010100";  -- 0x54
constant C_GET_ENCODER_OUTPUT  	: std_logic_vector(0 to 7)	:= "01011000";  -- 0x58
constant C_SET_SCHEDPARAM  		: std_logic_vector(0 to 7)	:= "01011100";  -- 0x5C
constant C_GET_ENTRY      		: std_logic_vector(0 to 7)	:= "01100000";  -- 0x60
constant C_GET_SCHEDPARAM  		: std_logic_vector(0 to 7)	:= "01100100";  -- 0x64
constant C_CHECK_SCHEDPARAM  	: std_logic_vector(0 to 7)	:= "01101000";  -- 0x68
  constant C_MALLOC_LOCK          : std_logic_vector(0 to 7) := "01000100";  -- 0x44

-- TM Command Opcodes
constant ENQUEUE_OPCODE			: std_logic_vector(0 to 5) := "000010";
constant DEQUEUE_OPCODE			: std_logic_vector(0 to 5) := "000011";
constant IS_QUEUED_OPCODE		: std_logic_vector(0 to 5) := "000001";
constant IS_EMPTY_OPCODE		: std_logic_vector(0 to 5) := "000110";

-- HW Thread Opcodes
constant HW_THREAD_START		: std_logic_vector(0 to 3) := "0001";

-- Initialization Strings & Constants
constant Z32 				: std_logic_vector(0 to 31) := (others => '0');
constant BRAM_init_string	: std_logic_vector(0 to 31) := Z32(0 to 31);

-- Busy Signals
signal Next_Thread_Valid_reg	: std_logic;
signal Next_Thread_Valid_next	: std_logic;
signal sched_busy		: std_logic;
signal sched_busy_next	: std_logic;

-- ACK signal
signal IP2Bus_Ack : std_logic;

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
signal bus_ack_ready : std_logic;
signal bus_data_out   : std_logic_vector (0 to 31);

-- Interrupt Signals
signal Preemption_Interrupt_Line 		: std_logic;
signal Preemption_Interrupt_Enable 		: std_logic;
signal Preemption_Interrupt_Enable_next : std_logic;

-- Thread ID registers
signal TM2SCH_current_cpu_tid_reg	: std_logic_vector(0 to 7);
signal next_thread_id_reg			: std_logic_vector(0 to 7);
signal next_thread_id_next			: std_logic_vector(0 to 7);

-- TM <--> SCH Debug Register
signal debug_reg		: std_logic_vector(0 to 31);
signal debug_reg_next	: std_logic_vector(0 to 31);

-- Reset Signals
-- FIXME: It would be nice to eliminate the default values here
signal inside_reset			: std_logic := '0';
signal inside_reset_next	: std_logic := '0';

-- Signals for each event type
signal Enqueue_Request				: std_logic;
signal Dequeue_Request				: std_logic;
signal Is_Queued_Request			: std_logic;
signal Is_Empty_Request				: std_logic;
signal Get_EncoderOutput_Request 	: std_logic;
signal Set_SchedParam_Request 		: std_logic;
signal Get_SchedParam_Request 		: std_logic;
signal Check_SchedParam_Request 	: std_logic;
signal Toggle_Preemption_Request 	: std_logic;
signal Get_IdleThread_Request 		: std_logic;
signal Set_IdleThread_Request 		: std_logic;
signal Get_Entry_Request			: std_logic;
signal Default_Priority_Request 	: std_logic;
signal Error_Request 				: std_logic;
  signal MALLOC_Lock_Request       : std_logic;

-- State Machine data signals
signal lookup_entry					: std_logic_vector(0 to 31);
signal lookup_entry_next			: std_logic_vector(0 to 31);
signal dequeue_entry				: std_logic_vector(0 to 31);
signal dequeue_entry_next			: std_logic_vector(0 to 31);
signal enqueue_entry				: std_logic_vector(0 to 31);
signal enqueue_entry_next			: std_logic_vector(0 to 31);
signal enqueue_pri_entry			: std_logic_vector(0 to 31);
signal enqueue_pri_entry_next		: std_logic_vector(0 to 31);
signal deq_pri_entry				: std_logic_vector(0 to 31);
signal deq_pri_entry_next			: std_logic_vector(0 to 31);
signal sched_param					: std_logic_vector(0 to 31);
signal sched_param_next				: std_logic_vector(0 to 31);
signal old_tail_ptr					: std_logic_vector(0 to 7);
signal old_tail_ptr_next			: std_logic_vector(0 to 7);
signal current_entry_pri_value		: std_logic_vector(0 to 6);
signal current_entry_pri_value_next	: std_logic_vector(0 to 6);
signal old_priority					: std_logic_vector(0 to 6);
signal old_priority_next			: std_logic_vector(0 to 6);
signal new_priority					: std_logic_vector(0 to 6);
signal new_priority_next			: std_logic_vector(0 to 6);
signal lookup_id					: std_logic_vector(0 to 7);
signal lookup_id_next				: std_logic_vector(0 to 7);
signal idle_thread_id				: std_logic_vector(0 to 7);
signal idle_thread_id_next			: std_logic_vector(0 to 7);
signal idle_thread_valid			: std_logic;
signal idle_thread_valid_next		: std_logic;
signal temp_valid					: std_logic;
signal temp_valid_next				: std_logic;

-- BRAM Constants
constant BRAM_ADDRESS_BITS	: integer := 9;
constant BRAM_DATA_BITS		: integer := 32;

-- BRAM signals (THREAD_DATA)
signal    DOA   : std_logic_vector(0 to BRAM_DATA_BITS - 1) := (others => '0'); 
signal    ADDRA : std_logic_vector(0 to BRAM_ADDRESS_BITS - 1)  := (others => '0'); 
signal    DIA   : std_logic_vector(0 to BRAM_DATA_BITS - 1) := (others => '0'); 
signal    ENA   : std_logic := '0'; 
signal    WEA   : std_logic := '0';

-- BRAM signals (PRIORITY_DATA)
signal    DOB   : std_logic_vector(0 to BRAM_DATA_BITS - 1) := (others => '0'); 
signal    ADDRB : std_logic_vector(0 to BRAM_ADDRESS_BITS - 1)  := (others => '0'); 
signal    DIB   : std_logic_vector(0 to BRAM_DATA_BITS - 1) := (others => '0'); 
signal    ENB   : std_logic := '0'; 
signal    WEB   : std_logic := '0';

-- BRAM signals (PARAM_DATA)
signal    DOU   : std_logic_vector(0 to BRAM_DATA_BITS - 1) := (others => '0');
signal    ADDRU : std_logic_vector(0 to BRAM_ADDRESS_BITS - 1)  := (others => '0'); 
signal    DIU   : std_logic_vector(0 to BRAM_DATA_BITS - 1) := (others => '0'); 
signal    ENU   : std_logic := '0'; 
signal    WEU   : std_logic := '0';

-- Priority Encoder Constants & Signals
constant	INPUT_BITS	: integer	:= 128;
constant	OUTPUT_BITS	: integer	:= 7;
constant	CHUNK_BITS	: integer	:= 32;
signal encoder_reset		: std_logic;
signal encoder_input		: std_logic_vector(0 to INPUT_BITS - 1);
signal encoder_input_next	: std_logic_vector(0 to INPUT_BITS - 1);
signal encoder_output		: std_logic_vector(0 to OUTPUT_BITS - 1);
signal encoder_enable_next  : std_logic;
signal encoder_enable       : std_logic;

  -- Lock/Mutex signals
  signal lock_op                   : std_logic;
  signal lock_op_next              : std_logic;

  signal lock_count                : std_logic_vector(0 to 3);
  signal lock_count_next           : std_logic_vector(0 to 3);
  
  signal malloc_mutex              : std_logic;
  signal malloc_mutex_next         : std_logic;
 
  signal malloc_mutex_holder       : std_logic_vector(0 to 7);
  signal malloc_mutex_holder_next  : std_logic_vector(0 to 7);

-- signal and type for MASTER FSM
type master_state_type is
(
  idle,					-- idle states
  wait_trans_done,		-- wait for bus transaction to complete

  reset,				-- reset states
  reset_BRAM,
  reset_wait_4_ack,
 
  GET_encoder_output,		-- get_encoder_output state

  SET_SCHED_PARAM_begin,	-- set_sched_param states
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
  SET_SCHED_PARAM_return_with_error,
  SET_SCHED_PARAM_return_with_no_error,

  GET_SCHED_PARAM_begin,	-- get_sched_param states
  GET_SCHED_PARAM_lookup_entry,
  GET_SCHED_PARAM_lookup_entry_idle,
  GET_SCHED_PARAM_lookup_entry_finished,
 
  CHECK_SCHED_PARAM_begin,	-- check_sched_param states
  CHECK_SCHED_PARAM_lookup_entries,
  CHECK_SCHED_PARAM_lookup_entries_idle,
  CHECK_SCHED_PARAM_lookup_entries_finished,

  ENQ_begin,				-- enqueue states	
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
  
  DEQ_begin,				-- dequeue states
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

      MALLOC_LOCK,      -- MALLOC lock states
      MALLOC_LOCK_idle,
      MALLOC_LOCK_idle_finished,
      MALLOC_LOCK_ACQUIRE,
      MALLOC_LOCK_ACQUIRE_RETURN,
      MALLOC_LOCK_RELEASE,
      MALLOC_LOCK_RELEASE_next,
      MALLOC_LOCK_RELEASE_RETURN,

  GET_ENTRY_begin,			-- get entry states
  GET_ENTRY_lookup_entry,
  GET_ENTRY_lookup_entry_idle,
  GET_ENTRY_lookup_entry_finished,

  IS_QUEUED_begin,			-- is_queued states
  IS_QUEUED_lookup_entry,
  IS_QUEUED_lookup_entry_idle,
  IS_QUEUED_lookup_entry_finished,

  IS_EMPTY_check,			-- is_empty states
  IS_EMPTY_finished,

  SET_IDLE_THREAD_begin,	-- set_idle_thread states
  SET_IDLE_THREAD_lookup_entries_idle,
  SET_IDLE_THREAD_lookup_entries_finished,
  SET_IDLE_THREAD_return_with_error,
  SET_IDLE_THREAD_return_with_no_error  
);
signal current_state_master, next_state_master : master_state_type := idle;

---------------------------------------------------
-- is_encoder_bit_zero()
--********************
-- Function used to check an encoder bit
-- Returns booleans: 
--	* '0' --> True
--	* '1' --> False
---------------------------------------------------
function is_encoder_bit_zero(pri_index: integer; e_entry: std_logic_vector(0 to INPUT_BITS-1)) return boolean is
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
-- Function used to set an  encoder bit
--
---------------------------------------------------
function set_encoder_bit(e_bit: std_logic; pri: integer; e_entry: std_logic_vector(0 to INPUT_BITS - 1)) return std_logic_vector is
  variable temp_entry : std_logic_vector(0 to INPUT_BITS-1);
begin
	temp_entry      := e_entry;     -- make a copy of the entry
	temp_entry(pri) := e_bit;	-- update bit in entry
	
	return temp_entry;		-- return new entry
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
--
---------------------------------------------------
function get_head_pointer(entry: std_logic_vector(0 to 31)) return std_logic_vector is
begin
	return entry(0 to 7);
end function get_head_pointer;
---------------------------------------------------

---------------------------------------------------
-- set_head_pointer()
-- *******************
-- function to set the head_pointer field for a
-- priority attribute entry
--
---------------------------------------------------
function set_head_pointer(head_ptr: std_logic_vector(0 to 7); entry: std_logic_vector(0 to 31)) return std_logic_vector is
begin
	return head_ptr & entry(8 to 31);
end function set_head_pointer;
---------------------------------------------------

---------------------------------------------------
-- get_tail_pointer()
-- *******************
-- function to extract the tail_pointer field from a
-- priority attribute entry
--
---------------------------------------------------
function get_tail_pointer(entry: std_logic_vector(0 to 31)) return std_logic_vector is
begin
	return entry(8 to 15);
end function get_tail_pointer;
---------------------------------------------------

---------------------------------------------------
-- set_tail_pointer()
-- *******************
-- function to set the tail_pointer field for a
-- priority attribute entry
--
---------------------------------------------------
function set_tail_pointer(tail_ptr: std_logic_vector(0 to 7); entry: std_logic_vector(0 to 31)) return std_logic_vector is
begin
	return entry(0 to 7) & tail_ptr & entry(16 to 31);
end function set_tail_pointer;
---------------------------------------------------

---------------------------------------------------
-- get_priority()
-- *******************
-- function to extract the priority field from a
-- scheduler attribute entry
--
---------------------------------------------------
function get_priority(entry: std_logic_vector(0 to 31)) return std_logic_vector is
begin
	return entry(9 to 15);
end function get_priority;
---------------------------------------------------

---------------------------------------------------
-- set_priority()
-- *******************
-- function to set the priority field for a
-- scheduler attribute entry
--
---------------------------------------------------
function set_priority(priority: std_logic_vector(0 to 6); entry: std_logic_vector(0 to 31)) return std_logic_vector is
begin
        return entry(0 to 8) & priority & entry(16 to 31);
end function set_priority;
---------------------------------------------------

---------------------------------------------------
-- get_next_pointer()
-- *******************
-- function to extract the next_pointer field from a
-- scheduler attribute entry
--
---------------------------------------------------
function get_next_pointer(entry: std_logic_vector(0 to 31)) return std_logic_vector is
begin
	return entry(1 to 8);
end function get_next_pointer;
---------------------------------------------------

---------------------------------------------------
-- set_next_pointer()
-- *******************
-- function to set the next_pointer field for a
-- scheduler attribute entry
--
---------------------------------------------------
function set_next_pointer(next_ptr: std_logic_vector(0 to 7); entry: std_logic_vector(0 to 31)) return std_logic_vector is
begin
	return entry(0) & next_ptr & entry(9 to 31);
end function set_next_pointer;
---------------------------------------------------

---------------------------------------------------
-- get_prev_pointer()
-- *******************
-- function to extract the prev_pointer field from a
-- scheduler attribute entry
--
---------------------------------------------------
function get_prev_pointer(entry: std_logic_vector(0 to 31)) return std_logic_vector is
begin
	return entry(16 to 23);
end function get_prev_pointer;
---------------------------------------------------

---------------------------------------------------
-- set_prev_pointer()
-- *******************
-- function to set the prev_pointer field for a
-- scheduler attribute entry
--
---------------------------------------------------
function set_prev_pointer(prev_ptr: std_logic_vector(0 to 7); entry: std_logic_vector(0 to 31)) return std_logic_vector is
begin
	return entry(0 to 15) & prev_ptr & entry(24 to 31);
end function set_prev_pointer;
---------------------------------------------------

---------------------------------------------------
-- get_queue_bit()
-- *******************
-- function to extract the queue bit field from a
-- scheduler attribute entry
--
---------------------------------------------------
function get_queue_bit(entry: std_logic_vector(0 to 31)) return std_logic is
begin
	return entry(0);
end function get_queue_bit;
---------------------------------------------------

---------------------------------------------------
-- set_queue_bit()
-- *******************
-- function to set the queue bit field for a
-- scheduler attribute entry
--
---------------------------------------------------
function set_queue_bit(q_bit: std_logic; entry: std_logic_vector(0 to 31)) return std_logic_vector is
begin
	return q_bit & entry(1 to 31);
end function set_queue_bit;
---------------------------------------------------

---------------------------------------------------
-- Component Instantiation of the Priority Encoder
---------------------------------------------------
component parallel
generic
(
    INPUT_BITS  : integer   := 128;
    OUTPUT_BITS : integer   := 7;
	CHUNK_BITS  : integer   := 32
);
port
(
	clk	: in  std_logic;
	rst	: in  std_logic;
	input	: in  std_logic_vector(0 to 127);
	enable	: in  std_logic;        
	output	: out std_logic_vector(0 to 6)
);
end component parallel;

---------------------------------------------------
-- Component Instantiation of the Inferred BRAM entity
---------------------------------------------------
component infer_bram
generic
(
	ADDRESS_BITS	: integer   := 9;
	DATA_BITS		: integer   := 32
);
port (
	CLKA  		: in std_logic; 
	ENA   		: in std_logic; 
	WEA   		: in std_logic;
    ADDRA 		: in std_logic_vector(0 to ADDRESS_BITS - 1); 
    DIA   		: in std_logic_vector(0 to DATA_BITS - 1);
    DOA   		: out  std_logic_vector(0 to DATA_BITS - 1)
);  
end component infer_BRAM;

---------------------------------------------------
--*************************************************
-- Beginning of user_logic ARCHITECTURE
--*************************************************


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

begin

  --USER logic implementation added here

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

---------------------------------------------------
-- Entity Instantiation of the Priority Encoder
---------------------------------------------------
priority_encoder : parallel
generic map
(
	INPUT_BITS	=> INPUT_BITS,
	OUTPUT_BITS	=> OUTPUT_BITS,
	CHUNK_BITS	=> CHUNK_BITS
)
port map
(
	clk	=> Bus2IP_Clk,
	rst	=> encoder_reset,
	input	=> encoder_input,
	enable	=> encoder_enable,
	output	=> encoder_output
);


---------------------------------------------------
-- Entity Instantiation of the THREAD_DATA BRAM
---------------------------------------------------
thread_data_bram : infer_bram
generic map
(
	ADDRESS_BITS	=> BRAM_ADDRESS_BITS,
	DATA_BITS		=> BRAM_DATA_BITS
)
port map
(
	CLKA	=> Bus2IP_Clk,
	ENA		=> ENA,
	WEA		=> WEA,
	ADDRA	=> ADDRA,
	DIA		=> DIA,
	DOA		=> DOA
);

---------------------------------------------------
-- Entity Instantiation of the PRIORITY_DATA BRAM
---------------------------------------------------
priority_data_bram : infer_bram
generic map
(
    ADDRESS_BITS    => BRAM_ADDRESS_BITS,
    DATA_BITS       => BRAM_DATA_BITS
)
port map
(
    CLKA    => Bus2IP_Clk,
    ENA     => ENB,
    WEA     => WEB,
    ADDRA   => ADDRB,
    DIA     => DIB,
    DOA     => DOB
);

---------------------------------------------------
-- Entity Instantiation of the PARAM_DATA BRAM
---------------------------------------------------
param_data_bram : infer_bram
generic map
(
    ADDRESS_BITS    => BRAM_ADDRESS_BITS,
    DATA_BITS       => BRAM_DATA_BITS
)
port map
(
    CLKA    => Bus2IP_Clk,
    ENA     => ENU,
    WEA     => WEU,
    ADDRA   => ADDRU,
    DIA     => DIU,
    DOA     => DOU
);

-- Create concatenation signals
Bus2IP_RdCE_concat		<= bit_set(Bus2IP_RdCE); 
Bus2IP_WrCE_concat		<= bit_set(Bus2IP_WrCE); 

-- Connect registers to external port signals...
SCH2TM_busy				<= sched_busy;
SCH2TM_next_cpu_tid		<= next_thread_id_reg;
SCH2TM_next_tid_valid	<= Next_Thread_Valid_reg;

-- Connect port signals to registers...
TM2SCH_current_cpu_tid_reg	<= TM2SCH_current_cpu_tid;

-- Toggle on/off timeout suppression with read/write requests
--IP2Bus_ToutSup 	<= (Bus2IP_RdCE_concat) or (Bus2IP_WrCE_concat);

-- AND the Preemption Interrupt Enable w/ the Interrupt line
Preemption_Interrupt <= (Preemption_Interrupt_Line) and (Preemption_Interrupt_Enable);

-- *************************************************************************
-- Process: TM_OUTPUT_CONTROLLER
-- Purpose: Control output from IP to TM
--      *   Can be controlled using TM_data_ready and TM_data_out signals.
-- *************************************************************************
TM_OUTPUT_CONTROLLER : process( Bus2IP_Clk, tm_data_ready ) is
begin
    if( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
        if( TM_data_ready = '1' ) then
			SCH2TM_data	<= TM_data_out;		-- put data out to TM and leave until next transaction
        end if;
    end if;
end process TM_OUTPUT_CONTROLLER;

-- *************************************************************************
-- Process:	BUS_OUTPUT_CONTROLLER
-- Purpose:	Control output from IP to Bus
--		*	Can be controlled using bus_data_ready, bus_ack_ready, and bus_data_out signals.
-- *************************************************************************
BUS_OUTPUT_CONTROLLER : process( Bus2IP_Clk, bus_data_ready, bus_ack_ready ) is
begin
	if( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
		if( bus_data_ready = '1' and bus_ack_ready = '1' ) then
			IP2Bus_Data	<= bus_data_out;	-- put data on bus
			IP2Bus_Ack	<= '1';				-- ACK bus
		elsif (bus_data_ready = '1' and bus_ack_ready = '0') then
			IP2Bus_Data	<= bus_data_out;	-- put data on bus
			IP2Bus_Ack	<= '0';				-- turn off ACK
		else
			IP2Bus_Data	<= (others => '0');	-- output 0's on bus
			IP2Bus_Ack	<= '0';		        -- turn off ACK
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
-- Process:	RESET_ADDR_INC
-- Purpose:	Process to increment the "reset" address so that each element of
--			the BRAMs can be indexed and initialized
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
        Enqueue_Request		<= '0';
        Dequeue_Request		<= '0';
        Is_Queued_Request	<= '0';
        Is_Empty_Request	<= '0';

		if (TM2SCH_request = '1') then
			case (TM2SCH_opcode) is
				when ENQUEUE_OPCODE		=>	Enqueue_Request		<= '1';
				when DEQUEUE_OPCODE		=>	Dequeue_Request		<= '1';
				when IS_QUEUED_OPCODE	=>	Is_Queued_Request	<= '1';
				when IS_EMPTY_OPCODE	=>	Is_Empty_Request	<= '1';
				when others				=>  null;
			end case;
		end if;
    end if;
end process TM_CMD_PROC;

-- *************************************************************************
-- Process:	BUS_CMD_PROC
-- Purpose:	Controller and decoder for incoming bus operations (reads and writes)
-- *************************************************************************
BUS_CMD_PROC : process (Bus2IP_Clk, Bus2IP_RdCE_concat, Bus2IP_WrCE_concat, Bus2IP_Addr ) is
begin
	if( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
		Get_EncoderOutput_Request		<= '0';
		Set_SchedParam_Request			<= '0';
		Get_SchedParam_Request			<= '0';
		Check_SchedParam_Request		<= '0';
		Toggle_Preemption_Request		<= '0';
		Get_IdleThread_Request			<= '0';
		Set_IdleThread_Request			<= '0';
		Get_Entry_Request 				<= '0';
		Default_Priority_Request		<= '0';
		Error_Request					<= '0';
        MALLOC_Lock_Request             <= '0';

		if( Bus2IP_WrCE_concat = '1' ) then
			case Bus2IP_Addr(24 to 31) is
				when C_SET_SCHEDPARAM		=> Set_SchedParam_Request		<= '1';
				when C_TOGGLE_PREEMPTION	=> Toggle_Preemption_Request	<= '1';
				when others					=> Error_Request				<= '1';
			end case;
		elsif( Bus2IP_RdCE_concat = '1' ) then
			case Bus2IP_Addr(24 to 31) is
				when C_GET_IDLE_THREAD		=> Get_IdleThread_Request		<= '1';
				when C_SET_IDLE_THREAD		=> Set_IdleThread_Request		<= '1';
				when C_GET_ENTRY			=> Get_Entry_Request 			<= '1';
				when C_GET_ENCODER_OUTPUT	=> Get_EncoderOutput_Request	<= '1';
				when C_SET_DEFAULT_PRIORITY	=> Default_Priority_Request		<= '1';
				when C_GET_SCHEDPARAM		=> Get_SchedParam_Request		<= '1';
				when C_CHECK_SCHEDPARAM		=> Check_SchedParam_Request		<= '1';
                when C_MALLOC_LOCK          => MALLOC_Lock_Request          <= '1';
				when others					=> Error_Request				<= '1';
			end case;
		end if;
	end if;
end process BUS_CMD_PROC;

-- *************************************************************************
-- Process:	MASTER_FSM_STATE_PROC
-- Purpose:	Synchronous FSM controller for the master state machine
-- *************************************************************************
MASTER_FSM_STATE_PROC: process(	
	Bus2IP_Clk,	Soft_Reset, inside_reset, next_state_master, encoder_enable_next,
	enqueue_pri_entry_next, deq_pri_entry_next, old_tail_ptr_next,
	encoder_input_next, next_thread_id_next, lookup_entry_next, sched_param_next,
	dequeue_entry_next, enqueue_entry_next, current_entry_pri_value_next,
	old_priority_next, new_priority_next, lookup_id_next, idle_thread_id_next,
	idle_thread_valid_next, inside_reset_next, Preemption_Interrupt_Enable_next,
	sched_busy_next, Next_Thread_Valid_next, debug_reg_next, temp_valid_next,
    lock_op_next, lock_count_next, malloc_mutex_next, malloc_mutex_holder_next     ) is
begin
	if ( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
		if( Soft_Reset = '1' and inside_reset = '0' ) then
			-- Initialize all signals...
			current_state_master		<= reset;
			encoder_enable				<= '0';
			enqueue_pri_entry			<= (others => '0');
			deq_pri_entry				<= (others => '0');
			old_tail_ptr				<= (others => '0');
			encoder_input				<= (others => '0');
			next_thread_id_reg			<= (others => '0');
			lookup_entry				<= (others => '0');
			sched_param					<= (others => '0');
			dequeue_entry				<= (others => '0');
			enqueue_entry				<= (others => '0');
			current_entry_pri_value		<= (others => '0');
			old_priority				<= (others => '0');
			new_priority				<= (others => '0');
			lookup_id					<= (others => '0');
			idle_thread_id				<= (others => '0');
			debug_reg					<= (others => '0');
			idle_thread_valid			<= '0';
			temp_valid					<= '0';
			inside_reset				<= '1';
			Preemption_Interrupt_Enable	<= '0';
			sched_busy					<= '0';
			Next_Thread_Valid_reg		<= '0';
        lock_count                      <= (others => '0');
        lock_op                         <= '0';
        malloc_mutex                    <= '0';
        malloc_mutex_holder             <= x"FF";
		else
			-- Assign all signals to their next state...
			current_state_master		<= next_state_master;
			encoder_enable				<= encoder_enable_next;
			enqueue_pri_entry			<= enqueue_pri_entry_next;
			deq_pri_entry				<= deq_pri_entry_next;
			old_tail_ptr				<= old_tail_ptr_next;
			encoder_input				<= encoder_input_next;
			next_thread_id_reg			<= next_thread_id_next;
			lookup_entry				<= lookup_entry_next;
			sched_param					<= sched_param_next;
			dequeue_entry				<= dequeue_entry_next;
			enqueue_entry				<= enqueue_entry_next;
			current_entry_pri_value		<= current_entry_pri_value_next;
			old_priority				<= old_priority_next;
			new_priority				<= new_priority_next;
			lookup_id					<= lookup_id_next;
			idle_thread_id				<= idle_thread_id_next;
			debug_reg					<= debug_reg_next;
			idle_thread_valid			<= idle_thread_valid_next;
			temp_valid					<= temp_valid_next;
			inside_reset				<= inside_reset_next;
			Preemption_Interrupt_Enable	<= Preemption_Interrupt_Enable_next;
			sched_busy					<= sched_busy_next;
			Next_Thread_Valid_reg		<= Next_Thread_Valid_next;	
        lock_count                      <= lock_count_next;
        lock_op                         <= lock_op_next;
        malloc_mutex                    <= malloc_mutex_next;
        malloc_mutex_holder             <= malloc_mutex_holder_next;
		end if;
	end if;
end process MASTER_FSM_STATE_PROC;

-- *************************************************************************
-- Process:	MASTER_FSM_LOGIC_PROC
-- Purpose:	Combinational process that contains all state machine logic and
--			state transitions for the master state machine			
-- *************************************************************************
MASTER_FSM_LOGIC_PROC: process (
	reset_addr, next_thread_id_reg, lookup_entry, sched_param, dequeue_entry,
	enqueue_entry, current_entry_pri_value, old_priority, new_priority, lookup_id,
	idle_thread_id, idle_thread_valid, temp_valid, current_state_master, inside_reset,
	Preemption_Interrupt_Enable, Enqueue_Request, Dequeue_Request,
	Is_Queued_Request, Is_Empty_Request, Get_EncoderOutput_Request, Error_Request,
	Set_SchedParam_Request, Get_SchedParam_Request, Check_SchedParam_Request,
	Toggle_Preemption_Request, Bus2IP_Data, Get_IdleThread_Request,
	Set_IdleThread_Request, Get_Entry_Request, Default_Priority_Request,
	Bus2IP_RdCE_concat, Bus2IP_WrCE_concat, Soft_Reset,  DOA, debug_reg,
	TM2SCH_current_cpu_tid_reg, TM2SCH_current_cpu_tid, Bus2IP_Addr, sched_busy,
	Next_Thread_Valid_reg, SWTM_DOB, encoder_input, encoder_output, encoder_enable,
	enqueue_pri_entry, deq_pri_entry, old_tail_ptr, DOB, DOU, TM2SCH_data,
    lock_op, lock_count, malloc_mutex, malloc_mutex_holder, MALLOC_Lock_Request ) is

-- Idle Variable, concatenation of all request signals
variable  idle_concat : std_logic_vector(0 to 14);

begin
	IP2Bus_Error					<= '0';	-- no error
	
	IP2Bus_Addr						<= (others => '0');
    IP2Bus_MstWrReq     <= '0';
    IP2Bus_MstWr_d      <= (others => '0');

	Reset_Done						<= '0'; -- reset is done unless we override it later
	encoder_reset					<= '0';
	ADDRA							<= (others => '0');
	DIA								<= (others => '0');
	ENA								<= '0';
	WEA								<= '0';
	ADDRB							<= (others => '0');
	DIB								<= (others => '0');
	ENB								<= '0';
	WEB								<= '0';
	ADDRU							<= (others => '0');
	DIU								<= (others => '0');
	ENU								<= '0';
	WEU								<= '0';
	SWTM_ADDRB						<= (others => '0');
	SWTM_DIB						<= (others => '0');
	SWTM_ENB						<= '0';
	SWTM_WEB						<= '0';
	encoder_enable_next				<= '0';
    enqueue_pri_entry_next			<= enqueue_pri_entry;
	deq_pri_entry_next				<= deq_pri_entry;
	old_tail_ptr_next				<= old_tail_ptr;
    encoder_input_next				<= encoder_input;
	next_state_master				<= current_state_master;
	next_thread_id_next				<= next_thread_id_reg;
	lookup_entry_next				<= lookup_entry;
	sched_param_next				<= sched_param;
	dequeue_entry_next				<= dequeue_entry;
	enqueue_entry_next				<= enqueue_entry;
	current_entry_pri_value_next	<= current_entry_pri_value;
	old_priority_next				<= old_priority;
	new_priority_next				<= new_priority;
	lookup_id_next					<= lookup_id;
	idle_thread_id_next				<= idle_thread_id;
	debug_reg_next					<= debug_reg;
	idle_thread_valid_next			<= idle_thread_valid;
	temp_valid_next					<= temp_valid;
	inside_reset_next				<= inside_reset;
	bus_data_out					<= (others => '0');
	bus_data_ready					<= '0';
	bus_ack_ready					<= '0';
	TM_data_out						<= (others => '0');
	TM_data_ready					<= '0';
	Preemption_Interrupt_Line		<= '0';
	Preemption_Interrupt_Enable_next<= Preemption_Interrupt_Enable;
	sched_busy_next					<= sched_busy;
	Next_Thread_Valid_next			<= Next_Thread_Valid_reg;
    lock_count_next                     <= lock_count;
    lock_op_next                        <= lock_op;
    malloc_mutex_next                   <= malloc_mutex;
    malloc_mutex_holder_next            <= malloc_mutex_holder;
  
	case current_state_master is
		when idle =>

			-- Assign to variable for case statement
			idle_concat :=	(Enqueue_Request & Dequeue_Request & Is_Queued_Request & Is_Empty_Request & Get_EncoderOutput_Request &
							Set_SchedParam_Request & Toggle_Preemption_Request & Get_IdleThread_Request &
							Set_IdleThread_Request & Get_Entry_Request & Default_Priority_Request &
							Get_SchedParam_Request & Check_SchedParam_Request & MALLOC_Lock_Request & Error_Request);

			-- Decode request
			case (idle_concat) is
	
				when "100000000000000"	=>	next_state_master <= ENQ_begin;						-- Enqueue
				when "010000000000000"	=>	next_state_master <= DEQ_begin;						-- Dequeue
				when "001000000000000"	=>	next_state_master <= IS_QUEUED_begin;				-- Is_Queued
				when "000100000000000"	=>  next_state_master <= IS_EMPTY_check;				-- Is_Empty
				when "000010000000000"	=>	next_state_master <= GET_encoder_output;			-- Get_EncoderOutput
				when "000001000000000"	=>	next_state_master <= SET_SCHED_PARAM_begin;			-- Set_SchedParam
				when "000000100000000"	=>	Preemption_Interrupt_Enable_next <= Bus2IP_Data(0);	-- Toggle_Preemption (single clock cycle op.)
											bus_data_out   <= (others => '0');
											bus_data_ready <= '1';          
											bus_ack_ready  <= '1';          
											next_state_master <= wait_trans_done;
				when "000000010000000"	=>	bus_data_out	<= Z32(0 to 22) & idle_thread_id & idle_thread_valid;		-- Get_IdleThread
											bus_data_ready	<= '1';
											bus_ack_ready   <= '1';          
											next_state_master <= wait_trans_done;
				when "000000001000000"	=>	next_state_master <= SET_IDLE_THREAD_begin;			-- Set_IdleThread
				when "000000000100000"	=>	next_state_master <= GET_ENTRY_begin;				-- Get_Entry
				when "000000000010000"	=>	bus_data_out	<= (others => '1');					-- ERROR (Set_Default_Priority)
											bus_data_ready	<= '1';
											bus_ack_ready   <= '1';          
											next_state_master <= wait_trans_done;
				when "000000000001000"	=>  next_state_master <= GET_SCHED_PARAM_begin;			-- Get_SchedParam
				when "000000000000100"	=>  next_state_master <= CHECK_SCHED_PARAM_begin;		-- Check_SchedParam
				when "000000000000010"	=>  next_state_master <= MALLOC_LOCK;		-- MALLOC Lock
				when "000000000000001"	=>	bus_data_out <= (others => '1');					-- Error!!!
											bus_data_ready <= '1';
											bus_ack_ready  <= '1';          
											next_state_master <= wait_trans_done;
				when others	  			=>	next_state_master <= idle;							-- Others, stay in idle state
			end case;
      
		when wait_trans_done =>
			-- Goal of this state is to return to the idle state ONLY (iff) the bus transaction has COMPLETELY ended!
			bus_data_ready <= '0';  -- de-assert bus transaction signals
			bus_ack_ready  <= '0';          
			if( Bus2IP_RdCE_concat = '0' and Bus2IP_WrCE_concat = '0' ) then
				next_state_master <= idle;
			end if;

		----------------------------
		-- RESET: begin
		----------------------------
		when reset =>
			WEA	  	<= '0'; -- Turn off any BRAM access that was active
			ENA	  	<= '0';
			WEB	  	<= '0';
			ENB	  	<= '0';
			WEU	  	<= '0';
			ENU	  	<= '0';
			SWTM_WEB<= '0';
			SWTM_ENB<= '0';

			encoder_reset 	<= '1';		-- Reset priority encoder
   	  
			TM_data_out			<= (others => '0');	-- Reset TM data out
			TM_data_ready		<= '1';

			Reset_Done	<= '0';	-- De-assert Reset_Done

			next_state_master <= reset_BRAM;
    
		when reset_BRAM =>
			ADDRA <= reset_addr;	-- setup BRAM write to init. THREAD_DATA entry
			DIA   <= set_priority("1000000", BRAM_init_string(0 to 22) & reset_addr);
			ENA   <= '1';
			WEA   <= '1';

			ADDRB <= reset_addr;	-- setup BRAM write to init. PRIORITY_DATA entry
			DIB   <= BRAM_init_string;
			ENB   <= '1';
			WEB   <= '1';

			ADDRU <= reset_addr;	-- setup BRAM write to init. PARAM_DATA entry
			DIU   <= BRAM_init_string;
			ENU   <= '1';
			WEU   <= '1';

			if( reset_addr = "011111111" ) then
				next_state_master		<= reset_wait_4_ack;
			end if;

		when reset_wait_4_ack =>
			ENA 		<= '0';	-- turn off BRAM access
			WEA 		<= '0';
			ENB 		<= '0';	-- turn off BRAM access
			WEB 		<= '0';
			ENU 			<= '0';	-- turn off BRAM access
			WEU 			<= '0';

			Reset_Done	<= '1';	-- Assert that reset has completed

			if( Soft_Reset = '0' ) then				-- if reset is complete
				Reset_Done			<= '0';				-- de-assert that reset is complete
				inside_reset_next	<= '0';				-- de-assert to signal that process is no longer in reset
				next_state_master	<= idle;			-- return to idle stage
			end if;
		----------------------------
		-- RESET: end
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
		-- ENQ: begin
		----------------------------
		when ENQ_begin =>
			debug_reg_next			<= "00" & ENQUEUE_OPCODE & TM2SCH_data & Z32(16 to 31);		-- store debug info

			sched_busy_next			<= '1';		-- assert that scheduler is busy

			lookup_id_next	<= TM2SCH_data;		-- store threadID to ENQ

			ADDRA	<= '0' & TM2SCH_data;	-- setup BRAM read for tid to enqueue from THREAD_DATA
			ENA		<= '1';
			WEA		<= '0';

			ADDRU	<= '0' & TM2SCH_data;	-- setup BRAM read for tid to enqueue from PARAM_DATA
			ENU		<= '1';
			WEU		<= '0';
      
			next_state_master <= ENQ_lookup_enqueue_entry_idle;
      
		when ENQ_lookup_enqueue_entry_idle =>
			-- idle stage
			next_state_master <= ENQ_lookup_enqueue_entry_finished;
      
		when ENQ_lookup_enqueue_entry_finished =>
            -- DOA has THREAD_DATA entry for tid to ENQ
            -- DOU has PARAM_DATA entry for tid to ENQ

            -- Check scheduling paramter:
            --  If HW range:    start HW thread
            --  If SW range:    add thread to ready-to-run queue
            case ( DOU(0 to 24) ) is
                when "0000000000000000000000000" =>
                -- SW-valid range, proceed with ENQ operation...
							debug_reg_next		<= debug_reg(0 to 27) & "1000";

                            Next_Thread_Valid_next  <= '0';     -- invalidate the current next_thread

                            enqueue_entry_next  <= set_queue_bit('1',DOA);  -- store entry and set as queued
                            new_priority_next   <= get_priority(DOA);       -- Assigned priority to this signal b/c used to address encoder_input (used in state below)

                            ADDRB   <= "00" & get_priority(DOA);        -- setup BRAM read to get PRIORITY_DATA entry for the enq'd thread
                            ENB     <= '1';
                            WEB     <= '0';

                            next_state_master <=ENQ_lookup_enqueue_pri_entry_idle;
                when others =>
                -- HW-valid range, proceed with start HW thread operation...
							debug_reg_next		<= debug_reg(0 to 27) & "1110";

                            sched_param_next    <= DOU;     -- store scheduling param. (base addr. of HW thread)

                            TM_data_out         <= Z32(0 to 7);     -- return status to the TM, so the TM will continue processing
                            TM_data_ready       <= '1';             -- and unlock the bus (freeing it so that we can make a master transaction)
                            sched_busy_next     <= '0';

                            -- No longer use these lines for the new PLB interface
				            --bus_data_out        <= Z32(0 to 27) & HW_THREAD_START;  -- put data on bus w/o ACK (for the upcoming write operation)
				            --bus_data_ready      <= '1';
				            --bus_ack_ready       <= '0';

                            next_state_master   <= ENQ_start_hw_thread_begin;
            end case;

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


		when ENQ_lookup_enqueue_pri_entry_idle	=>
			-- idle stage
			next_state_master <= ENQ_lookup_enqueue_pri_entry_finished;

		when ENQ_lookup_enqueue_pri_entry_finished =>
			enqueue_pri_entry_next	<= DOB;		-- store pri_entry

			if ( is_encoder_bit_zero(conv_integer(new_priority), encoder_input)) then
			-- Queue is empty for this priority level
				-- set encoder_input bit for given priority
				encoder_input_next <= set_encoder_bit('1', conv_integer(get_priority(enqueue_entry)), encoder_input);
				encoder_enable_next     <= '1';  -- allow the priority encoder to process, 1
		  		next_state_master <= ENQ_init_head_pointer;
			else
			-- Queue is not empty for this priority level
				old_tail_ptr_next <= get_tail_pointer(DOB);				-- store old tail_ptr
		  		next_state_master <= ENQ_lookup_old_tail_ptr;
			end if;

		when ENQ_init_head_pointer =>
			-- Set head_ptr to the lookup_id
			enqueue_pri_entry_next <= set_head_pointer(lookup_id, enqueue_pri_entry);
			next_state_master <= ENQ_init_tail_pointer;

		when ENQ_init_tail_pointer =>
			-- Set tail_ptr to the lookup_id
			enqueue_pri_entry_next <= set_tail_pointer(lookup_id, enqueue_pri_entry);
			next_state_master <= ENQ_wait_for_encoder_0;
		
		when ENQ_wait_for_encoder_0 =>
			-- idle stage
			next_state_master <= ENQ_write_back_entries;

		when ENQ_lookup_old_tail_ptr =>
			ADDRA	<= '0' & old_tail_ptr;	-- setup read of old tail_ptr
			ENA	<= '1';
			WEA	<= '0';

			next_state_master <= ENQ_lookup_old_tail_ptr_idle;

		when ENQ_lookup_old_tail_ptr_idle =>
			-- idle stage
			next_state_master <= ENQ_lookup_old_tail_ptr_finished;

		when ENQ_lookup_old_tail_ptr_finished =>
			-- setup write to make old_tail_ptr's next_ptr point to newly enq'd thread
			ADDRA	<= '0' & old_tail_ptr;
			ENA	<= '1';
			WEA	<= '1';
			DIA	<= set_next_pointer(lookup_id, DOA);

			-- Update enqueue_entry's prev. ptr to point to old_tail_ptr
			enqueue_entry_next <= set_prev_pointer(old_tail_ptr, enqueue_entry);

			-- Update priority entry's tail_ptr to be newly enq'd thread
			enqueue_pri_entry_next <= set_tail_pointer(lookup_id, enqueue_pri_entry);

			next_state_master <= ENQ_write_back_entries;

		when ENQ_write_back_entries =>
			ADDRA	<= '0' & lookup_id;		-- Write back enqueue_entry
			ENA	<= '1';
			WEA	<= '1';
			DIA	<= enqueue_entry;

			ADDRB	<= "00" & get_priority(enqueue_entry);	-- Write back enqueue_pri_entry
			ENB	<= '1';
			WEB	<= '1';
			DIB	<= enqueue_pri_entry;

			next_state_master <= ENQ_lookup_highest_pri_entry;

		when ENQ_lookup_highest_pri_entry =>
			ADDRB	<= "00"  & encoder_output;	-- setup read of highest PRIORITY_DATA entry in system
			ENB	<= '1';
			WEA	<= '0';

			ADDRA   <= '0' & TM2SCH_current_cpu_tid_reg;	-- setup read of currently running thread
			ENA	<= '1';
			WEA	<= '0';
			
			next_state_master <= ENQ_lookup_highest_pri_entry_idle;

		when ENQ_lookup_highest_pri_entry_idle =>
			-- idle stage
			next_state_master <= ENQ_lookup_highest_pri_entry_finished;

		when ENQ_lookup_highest_pri_entry_finished =>
			-- DOA has current thread entry
			-- DOB has highest priority entry
			current_entry_pri_value_next	<= get_priority(DOA);		-- store current_entry's priority
			next_thread_id_next				<= get_head_pointer(DOB);	-- store next_thread_id
			next_state_master <= ENQ_preemption_check;			

		when ENQ_preemption_check =>
			-- Check if next_thread_id has "better" priority than the current_entry_pri_value
			if( encoder_output < current_entry_pri_value ) then
				Preemption_Interrupt_Line <= '1';
			end if;

			TM_data_out			<= get_queue_bit(enqueue_entry) & Z32(1 to 7);		-- return 0x80 to TM
			TM_data_ready		<= '1';
      
			Next_Thread_Valid_next  <= '1';	-- Assert that the next_thread is valid
			sched_busy_next			<= '0';	-- de-assert busy signal

			next_state_master <= idle;	-- return to idle stage
		----------------------------
		-- ENQ: end
		----------------------------

		----------------------------
		-- DEQ: begin
		----------------------------
		when DEQ_begin =>
			debug_reg_next			<= "00" & DEQUEUE_OPCODE & TM2SCH_data & Z32(16 to 31);		-- store debug info

			sched_busy_next			<= '1';	-- assert that scheduler is busy
			Next_Thread_Valid_next	<= '0';	-- invalidate the next_thread

			ADDRA	<= '0' & TM2SCH_current_cpu_tid;	-- setup BRAM read of thread to dequeue
			ENA		<= '1';
			WEA		<= '0';
      
			next_state_master <= DEQ_lookup_dequeue_entry_idle;
            
		when DEQ_lookup_dequeue_entry_idle =>
			-- idle stage      
			next_state_master <= DEQ_lookup_dequeue_entry_finished;
      
		when DEQ_lookup_dequeue_entry_finished =>
			dequeue_entry_next	<= set_queue_bit('0',DOA); -- store entry in variable and clear queue-bit
      
			ADDRB	<= "00" & get_priority(DOA);		-- setup read of deq_pri_entry
			ENB	<= '1';
			WEB	<= '0';
			
			next_state_master <= DEQ_lookup_deq_pri_entry_idle;

		when DEQ_lookup_deq_pri_entry_idle =>
			-- idle stage
			next_state_master <= DEQ_lookup_deq_pri_entry_finished;

		when DEQ_lookup_deq_pri_entry_finished =>
			deq_pri_entry_next <= DOB;		-- store deq entry from PRIORITY_DATA

			if ( get_head_pointer(DOB) = get_tail_pointer(DOB) ) then
			  -- If list priority Q has 1 element (head = tail) then list will now be empty
				-- Clear encoder bit for given priority
				encoder_input_next <= set_encoder_bit('0', conv_integer(get_priority(dequeue_entry)), encoder_input);

				encoder_enable_next     <= '1';  -- allow the priority encoder to process, 1
				next_state_master <= DEQ_wait_for_encoder_0;
			else
			  -- Otherwise...
				ADDRA	<= '0' & get_head_pointer(DOB);	-- setup read of head_ptr
				ENA	<= '1';
				WEA	<= '0';
				
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
			deq_pri_entry_next <= set_head_pointer( get_next_pointer(DOA), deq_pri_entry);

			next_state_master <= DEQ_write_back_entries;

		when DEQ_write_back_entries =>
			ADDRA	<= '0' & TM2SCH_current_cpu_tid;		-- setup write to update dequeue_entry
			ENA	<= '1';
			WEA	<= '1';
			DIA	<= dequeue_entry;

			ADDRB	<= "00" & get_priority(dequeue_entry);	-- setup write to update deq_pri_entry
			ENB	<= '1';
			WEB	<= '1';
			DIB	<= deq_pri_entry;

			next_state_master <= DEQ_check_encoder_output;

		when DEQ_check_encoder_output =>
			if (encoder_input = 0 ) then
			  -- No queued threads in the system: finish with invalid next thread or with idle thread if one exists
				if (idle_thread_valid = '1') then
					Next_Thread_Valid_next	<= '1';
					next_thread_id_next		<= idle_thread_id;
				else
					Next_Thread_Valid_next	<= '0';
				end if;
	
				TM_data_out			<= Z32(0 to 7);		-- return all 0's (success) to TM
				TM_data_ready		<= '1';
	
				sched_busy_next		<= '0';		-- de-assert busy signal
				next_state_master	<= idle;
			else
			  -- Queued threads exist...
				ADDRB	<= "00" & encoder_output;	-- setup read of highest priority (PRIORITY_DATA) entry
			  	ENB	<= '1';
			  	WEB     <= '0';

				next_state_master <= DEQ_lookup_highest_pri_entry_idle;
			end if;

		when DEQ_lookup_highest_pri_entry_idle =>
			-- idle stage
			next_state_master <= DEQ_lookup_highest_pri_entry_finished;

		when DEQ_lookup_highest_pri_entry_finished =>
			next_thread_id_next		<= get_head_pointer(DOB);	-- store next_thread_id

			TM_data_out			<= Z32(0 to 7);		-- return all 0's (success) to TM
			TM_data_ready		<= '1';

			sched_busy_next			<= '0';						-- de-assert busy signal
			Next_Thread_Valid_next	<= '1';  					-- Assert that the next_thread is valid 
			next_state_master		<= idle;		 			-- return to idle stage
		----------------------------
		-- DEQ: end
		----------------------------
          
		----------------------------
		-- GET_ENTRY: begin
		----------------------------
		when GET_ENTRY_begin =>
			lookup_id_next		<= Bus2IP_Addr(16 to 23);	-- latch thread_id to lookup
			next_state_master <= GET_ENTRY_lookup_entry;

		when GET_ENTRY_lookup_entry =>
			ADDRA	<= '0' & lookup_id;		-- setup BRAM read of lookup thread_id
			ENA		<= '1';
			WEA		<= '0';
    
			next_state_master <= GET_ENTRY_lookup_entry_idle;

		when GET_ENTRY_lookup_entry_idle =>
   			-- idle stage 
			next_state_master <= GET_ENTRY_lookup_entry_finished;
    
		when GET_ENTRY_lookup_entry_finished =>
			ENA	<= '0';	-- turn off BRAM access
			WEA	<= '0';
      
			bus_data_out		<= DOA;	 -- return entry on bus
			bus_data_ready		<= '1';
			bus_ack_ready		<= '1';
      
			next_state_master <= wait_trans_done;    
		----------------------------
		-- GET_ENTRY: end
		----------------------------

        ----------------------------
        -- IS_QUEUED: begin
        ----------------------------
        when IS_QUEUED_begin =>
			debug_reg_next			<= "00" & IS_QUEUED_OPCODE & TM2SCH_data & Z32(16 to 31);		-- store debug info

			sched_busy_next	  <= '1';			-- assert that operation is busy
            lookup_id_next    <= TM2SCH_data;	-- latch thread_id to lookup

            next_state_master <= IS_QUEUED_lookup_entry;

        when IS_QUEUED_lookup_entry =>
            ADDRA   <= '0' & lookup_id;     -- setup BRAM read of lookup thread_id
            ENA     <= '1';
            WEA     <= '0';

            next_state_master <= IS_QUEUED_lookup_entry_idle;

        when IS_QUEUED_lookup_entry_idle =>
			-- idle stage
            next_state_master <= IS_QUEUED_lookup_entry_finished;

        when IS_QUEUED_lookup_entry_finished =>
            ENA <= '0'; -- turn off BRAM access
            WEA <= '0';
	
			TM_data_out		<= Z32(0 to 6) & get_queue_bit(DOA);	-- return data to TM
			TM_data_ready	<= '1';

			sched_busy_next	<= '0';			-- de-assert busy signal

            next_state_master <= idle;
        ----------------------------
        -- IS_QUEUED: end
        ----------------------------

        ----------------------------
        -- IS_EMPTY: begin
        ----------------------------
		when IS_EMPTY_check =>
			debug_reg_next			<= "00" & IS_EMPTY_OPCODE & TM2SCH_data & Z32(16 to 31);		-- store debug info

			sched_busy_next		<= '1';		-- assert that scheduler is busy
			next_state_master	<= IS_EMPTY_finished;


		when IS_EMPTY_finished =>
			-- Check to see if all queues are empty
			if (encoder_input = 0) then				
				TM_data_out			<= Z32(0 to 6) & '1';	-- set data_out to true,		(LSB = 1)
			else
				TM_data_out			<= Z32(0 to 6) & '0';	-- set data_out to false,		(LSB = 0)
			end if; 

			sched_busy_next		<= '0';		--de-assert busy signal
			TM_data_ready		<= '1';		-- return results to TM
			next_state_master	<= idle;
        ----------------------------
        -- IS_EMPTY: end
        ----------------------------

		----------------------------
		-- GET_encoder_output: begin
		----------------------------
		when GET_encoder_output =>
      
--			bus_data_out		<= Z32(0 to 24)& encoder_output;	 -- return highest priority entry on bus
			bus_data_out		<= debug_reg;						 -- return debug reg on bus FIXME (last TM request)
			bus_data_ready		<= '1';
			bus_ack_ready		<= '1';
      
			next_state_master <= wait_trans_done;    
		----------------------------
		-- GET_encoder_output: end
		----------------------------

		----------------------------
		-- SET_sched_param: begin
		----------------------------
		when SET_SCHED_PARAM_begin =>
			debug_reg_next			<= (others => '1');

			temp_valid_next			<= Next_Thread_Valid_reg;		-- Store the current Next_Thread_Valid bit (used for restore later)
			Next_Thread_Valid_next	<= '0';							-- invalidate the next thread

			lookup_id_next		<= Bus2IP_Addr(16 to 23);	-- store tid

			sched_param_next	<= Bus2IP_Data(0 to 31);	-- store sched_param
			new_priority_next	<= Bus2IP_Data(25 to 31);	-- store priority (low 7 bits of sched_param)

			ADDRU	<= '0' & Bus2IP_Addr(16 to 23);	-- setup BRAM write to update sched param value in PARAM_DATA
			DIU		<= Bus2IP_Data(0 to 31);
			ENU		<= '1';
			WEU		<= '1';

			-- Check to see if sched param is in SW-valid range
			case ( Bus2IP_Data(0 to 24) ) is
				when "0000000000000000000000000" 	=>	-- SW-valid range, proceed with a set_priority operation
														next_state_master	<= SET_SCHED_PARAM_lookup_setpri_entries_begin;
				when others							=>	-- HW-valid range, simply end, no error checks
														next_state_master	<= SET_SCHED_PARAM_return_with_no_error;
			end case;

		when SET_SCHED_PARAM_lookup_setpri_entries_begin =>

			ADDRA	<= '0' & lookup_id;		-- setup BRAM read of thread_id to
			ENA		<= '1';
			WEA		<= '0';
      
			ADDRB	<= "00" & new_priority;	-- setup BRAM read of new_priority_entry
			ENB		<= '1';
			WEB		<= '0';

			SWTM_ADDRB	<= '0' & lookup_id;	-- setup SWTM_BRAM read of thread_id
			SWTM_ENB	<= '1';
			SWTM_WEB	<= '0';

			next_state_master <= SET_SCHED_PARAM_lookup_setpri_entries_idle;

		when SET_SCHED_PARAM_lookup_setpri_entries_idle =>
			-- idle stage
			next_state_master <= SET_SCHED_PARAM_lookup_setpri_entries_finished;
        
		when SET_SCHED_PARAM_lookup_setpri_entries_finished =>
			old_priority_next		<= get_priority(DOA);	-- store old_priority value
			lookup_entry_next		<= DOA;					-- store setpri_entry
			enqueue_pri_entry_next	<= DOB;					-- store new_priority_entry

			-- Check Validity of Set_Priority operation
			if	(	(SWTM_DOB(26) = '1')	and
					(	(lookup_id = TM2SCH_current_cpu_tid_reg)		or
				 		(SWTM_DOB(16 to 23) = TM2SCH_current_cpu_tid_reg)
					)
				) then
           
				if(get_queue_bit(DOA) = '1') then
					-- If QUEUED...
					ADDRB <= "00" & get_priority(DOA);	-- setup read of old_pri_entry
					ENB   <= '1';
					WEB   <= '0';
					next_state_master <= SET_SCHED_PARAM_lookup_old_pri_entry_idle;
				else
					-- IF ~QUEUED...
					ADDRA	<= '0' & lookup_id;	-- setup BRAM write to update priority value in THREAD_DATA
					DIA	<= set_priority(new_priority, DOA);
					ENA	<= '1';
					WEA	<= '1';

					next_state_master <= SET_SCHED_PARAM_check_encoder;
				end if;
			else
				-- Otherwise, return with an error b/c operation cannot be completed...
				next_state_master <= SET_SCHED_PARAM_return_with_error;
			end if;

		when SET_SCHED_PARAM_lookup_old_pri_entry_idle =>
			-- idle stage
			next_state_master <= SET_SCHED_PARAM_lookup_old_pri_entry_finished;

		when SET_SCHED_PARAM_lookup_old_pri_entry_finished =>
			deq_pri_entry_next <= DOB;	-- store old_priority_entry

			next_state_master <= SET_SCHED_PARAM_priority_field_check;

		when SET_SCHED_PARAM_priority_field_check =>
			-- update priority value to new_priority
			lookup_entry_next <= set_priority(new_priority, lookup_entry);

			-- FIXME:  The following bunch of IF's could be replaced by a sig_case stmt where
			--         the sigs are head==tail,lookup_id=head,lookup_id=tail

			-- If (head_ptr = tail_ptr) then Q will now be empty
			if ( get_tail_pointer(deq_pri_entry) = get_head_pointer(deq_pri_entry) ) then
				-- Clear encoder bit for given priority
				encoder_input_next <= set_encoder_bit('0', conv_integer(old_priority), encoder_input);
				next_state_master <= SET_SCHED_PARAM_begin_add_to_new_pri_queue;
			else  -- If the Q will not be empty
				-- If the head is being deq'd
				if ( lookup_id = get_head_pointer(deq_pri_entry) ) then
					-- Setup BRAM read of old head_ptr's entry
					ADDRA <= '0' & get_head_pointer(deq_pri_entry);
					ENA   <= '1';
					WEA   <= '0';
					next_state_master <= SET_SCHED_PARAM_lookup_old_head_ptr_idle;

				-- If the tail is being deq'd
				elsif ( lookup_id = get_tail_pointer(deq_pri_entry) ) then
					-- Setup BRAM read of old tail_ptr's entry
					ADDRA <= '0' & get_tail_pointer(deq_pri_entry);
					ENA   <= '1';
					WEA   <= '0';
					next_state_master <= SET_SCHED_PARAM_lookup_old_tail_ptr_idle;

				-- If an item in the "middle" of the list is being deq'd
				else
					-- Setup BRAM read of prev_ptr's entry
					ADDRA <= '0' & get_prev_pointer(lookup_entry);
					ENA   <= '1';
					WEA   <= '0';
					next_state_master <= SET_SCHED_PARAM_lookup_prev_ptr_idle;
				end if;				
			end if;

		when SET_SCHED_PARAM_lookup_old_head_ptr_idle =>
			-- idle stage
			next_state_master <= SET_SCHED_PARAM_lookup_old_head_ptr_finished;

		when SET_SCHED_PARAM_lookup_old_head_ptr_finished =>
			-- DOA has old head_ptr entry on it
			deq_pri_entry_next <= set_head_pointer(get_next_pointer(DOA), deq_pri_entry);
			next_state_master <= SET_SCHED_PARAM_write_back_deq_pri_entry;

		when SET_SCHED_PARAM_lookup_old_tail_ptr_idle =>
			-- idle stage
			next_state_master <= SET_SCHED_PARAM_lookup_old_tail_ptr_finished;

		when SET_SCHED_PARAM_lookup_old_tail_ptr_finished =>
			-- DOA has old tail_ptr entry on it
			deq_pri_entry_next <= set_tail_pointer(get_prev_pointer(DOA), deq_pri_entry);
			next_state_master <= SET_SCHED_PARAM_write_back_deq_pri_entry;

		when SET_SCHED_PARAM_lookup_prev_ptr_idle =>
			-- idle stage
			next_state_master <= SET_SCHED_PARAM_lookup_prev_ptr_finished;

		when SET_SCHED_PARAM_lookup_prev_ptr_finished =>
			-- DOA has prev_ptr entry on it
			-- set next_ptr of prev_ptr to that of next_ptr of setpri_entry (AKA lookup_entry)
			ADDRA <= '0' & get_prev_pointer(lookup_entry);
			ENA   <= '1';
			WEA   <= '1';
			DIA   <= set_next_pointer(get_next_pointer(lookup_entry),DOA);

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
			if ( is_encoder_bit_zero(conv_integer(new_priority), encoder_input)) then
				-- update head_ptr to that of lookup_id (AKA setpri_ID)
				enqueue_pri_entry_next <= set_head_pointer(lookup_id, enqueue_pri_entry);
				-- set encoder input bit for new_priority to '1'
				encoder_input_next <= set_encoder_bit('1', conv_integer(new_priority), encoder_input);
				-- now update the tail_ptr to that of lookup_id (AKA setpri_ID)
				next_state_master <= SET_SCHED_PARAM_init_tail_ptr;
			else	-- new priority Q is not empty
				-- Setup read of old tail_ptr in new Q
				ADDRA <= '0' & get_tail_pointer(enqueue_pri_entry);
				ENA   <= '1';
				WEA   <= '0';
				next_state_master <= SET_SCHED_PARAM_lookup_enq_old_tail_ptr_idle;
			end if;

		when SET_SCHED_PARAM_init_tail_ptr =>
			enqueue_pri_entry_next <= set_tail_pointer(lookup_id, enqueue_pri_entry);
			encoder_enable_next    <= '1';	-- allow priority encoder to process, 1a

			next_state_master <= SET_SCHED_PARAM_write_back_entries;

		when SET_SCHED_PARAM_lookup_enq_old_tail_ptr_idle =>
			-- idle stage
			-- Change the prev_ptr of lookup_id (AKA setpri_ID) to that of old_tail_ptr
			lookup_entry_next <= set_prev_pointer(get_tail_pointer(enqueue_pri_entry), lookup_entry);

			next_state_master <= SET_SCHED_PARAM_update_enqueue_info;
		
		when SET_SCHED_PARAM_update_enqueue_info =>
			-- DOA has old tail_ptr info for new Q
			-- Change & Write-back the old tail_ptr's next_ptr to that of lookup_id (AKA setpri_ID)
			ADDRA	<= '0' & get_tail_pointer(enqueue_pri_entry);
			ENA	<= '1';
			WEA	<= '1';
			DIA	<= set_next_pointer(lookup_id, DOA);

			-- Update the tail_ptr of new priority Q to be that of lookup_id (AKA setpri_ID)
			enqueue_pri_entry_next <= set_tail_pointer(lookup_id, enqueue_pri_entry);

			encoder_enable_next    <= '1';	-- allow priority encoder to process, 1b

			next_state_master <= SET_SCHED_PARAM_write_back_entries;
			
		when SET_SCHED_PARAM_write_back_entries =>
			-- Write back lookup_entry (AKA setpri_entry)
			ADDRA	<= '0' & lookup_id;
			ENA	<= '1';
			WEA	<= '1';
			DIA	<= lookup_entry;  

			-- Write back enqueue_pri_entry (AKA new_priority_entry)
			ADDRB	<= "00" & new_priority;
			ENB	<= '1';
			WEB	<= '1';
			DIB	<= enqueue_pri_entry;

			next_state_master <= SET_SCHED_PARAM_wait_for_encoder_0;

		when SET_SCHED_PARAM_wait_for_encoder_0 =>
			-- idle stage			
			next_state_master      <= SET_SCHED_PARAM_wait_for_encoder_1;

		when SET_SCHED_PARAM_wait_for_encoder_1 =>
			-- idle stage			
			next_state_master      <= SET_SCHED_PARAM_last_wait_0;

		when SET_SCHED_PARAM_last_wait_0=>
			-- idle stage			
			next_state_master <= SET_SCHED_PARAM_last_wait_1;

		when SET_SCHED_PARAM_last_wait_1=>
			-- idle stage			
			next_state_master <= SET_SCHED_PARAM_check_encoder;
		
		when SET_SCHED_PARAM_check_encoder =>
			-- Continue to find highest priority thread in the system...
			ADDRB	<= "00"  & encoder_output;	-- setup read of highest PRIORITY_DATA entry in system
			ENB	<= '1';
			WEA	<= '0';

			ADDRA   <= '0' & TM2SCH_current_cpu_tid_reg;	-- setup read of currently running thread
			ENA	<= '1';
			WEA	<= '0';
			
			next_state_master <= SET_SCHED_PARAM_lookup_highest_pri_entry_idle;

		when SET_SCHED_PARAM_lookup_highest_pri_entry_idle =>
			-- idle stage
			next_state_master <= SET_SCHED_PARAM_lookup_highest_pri_entry_finished;

		when SET_SCHED_PARAM_lookup_highest_pri_entry_finished =>
			-- DOA has current thread entry
			-- DOB has highest priority entry
			current_entry_pri_value_next	<= get_priority(DOA);		-- store current_entry's priority
			next_thread_id_next				<= get_head_pointer(DOB);	-- store next_thread_id
			next_state_master <= SET_SCHED_PARAM_preemption_check;			

		when SET_SCHED_PARAM_preemption_check =>
			-- Check if next_thread_id has "better" priority than the current_entry_pri_value
			if( encoder_output < current_entry_pri_value ) then
				Preemption_Interrupt_Line <= '1';
			end if;
     
            -- Late check for scheduling idle thread when encoder shows there are no
            -- threads to schedule
            if (encoder_input = 0) then
                if (idle_thread_valid = '1') then
                    Next_Thread_Valid_next    <= '1';
                    next_thread_id_next     <= idle_thread_id;
                else
                    Next_Thread_Valid_next    <= '0';
                end if;
            else
                -- There was data to process, so set thread valid
                Next_Thread_Valid_next  <= '1';    -- Assert that the next_thread is valid
            end if;
 
			Next_Thread_Valid_next  <= '1';	-- Assert that the next_thread is valid

			next_state_master <= SET_SCHED_PARAM_return_with_no_error;	-- return to idle stage

		when SET_SCHED_PARAM_return_with_error =>
			ENA <= '0';
			WEA <= '0';

			debug_reg_next	<= debug_reg(0 to 30) & '1';
      
			bus_data_out   <= Z32(0 to 27) & "0000";	-- return with error status (not possible with write op's, so just return all 0's)
			bus_data_ready <= '1';
			bus_ack_ready  <= '1';
      
			Next_Thread_Valid_next  <= temp_valid;	-- restore Next_Thread_Valid
      
			next_state_master <= wait_trans_done;

		when SET_SCHED_PARAM_return_with_no_error =>
			ENA <= '0';
			WEA <= '0';

			debug_reg_next	<= debug_reg(0 to 30) & '0';
      
			bus_data_out   <= Z32(0 to 27) & "0000";	-- return with successful status
			bus_data_ready <= '1';
			bus_ack_ready  <= '1';

			Next_Thread_Valid_next  <= temp_valid;	-- restore Next_Thread_Valid
      
			next_state_master <= wait_trans_done;
		----------------------------
		-- SET_sched_param: end
		----------------------------

        ----------------------------
        -- GET_sched_param: begin
        ----------------------------
        when GET_SCHED_PARAM_begin => 
			lookup_id_next		<= Bus2IP_Addr(16 to 23);
			next_state_master	<= GET_SCHED_PARAM_lookup_entry;

        when GET_SCHED_PARAM_lookup_entry =>
			ADDRU	<= '0' & lookup_id;		-- setup read from PARAM_DATA[tid]
			ENU		<= '1';
			WEU		<= '0';
			next_state_master	<= GET_SCHED_PARAM_lookup_entry_idle;

		when GET_SCHED_PARAM_lookup_entry_idle =>
			-- idle stage
			next_state_master	<= GET_SCHED_PARAM_lookup_entry_finished;

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
			--			* If queued		: sched_param must in the SW-valid range (less than 128)
			--			* If not-queued	: sched param can be in any range

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
		-- SET_IDLE_THREAD: begin
		----------------------------
		when SET_IDLE_THREAD_begin =>
			lookup_id_next	<= Bus2IP_Addr(16 to 23);	-- store thread_id

			ADDRA	<= '0' & Bus2IP_Addr(16 to 23);	-- setup BRAM read of THREAD_DATA[tid]
			ENA		<= '1';
			WEA		<= '0';
      
			ADDRU	<= '0' & Bus2IP_Addr(16 to 23);	-- setup BRAM read of PARAM_DATA[tid]
			ENU		<= '1';
			WEU		<= '0';

			SWTM_ADDRB	<= '0' & Bus2IP_Addr(16 to 23);	-- setup SWTM_BRAM read of thread_id to set_pri
			SWTM_ENB	<= '1';
			SWTM_WEB	<= '0';

			next_state_master <= SET_IDLE_THREAD_lookup_entries_idle;

		when SET_IDLE_THREAD_lookup_entries_idle =>
			-- idle stage
			next_state_master <= SET_IDLE_THREAD_lookup_entries_finished;

		when SET_IDLE_THREAD_lookup_entries_finished =>
			-- Check to see if this thread can become the idle thread
			--  * TID must be ~queued
			--	* TID must be created and used.
			--  * TID must not have a HW sched param.
			if	(	get_queue_bit(DOA) = '0' and
					SWTM_DOB(26) = '1' and
					DOU(0 to 24) = "0000000000000000000000000"					 
				) then
				idle_thread_id_next		<= lookup_id;
				idle_thread_valid_next	<= '1';
				next_state_master		<= SET_IDLE_THREAD_return_with_no_error;
			else
				-- This thread cannot become the idle thread
				next_state_master	<= SET_IDLE_THREAD_return_with_error;
			end if;

		when SET_IDLE_THREAD_return_with_error =>
			bus_data_out		<= Z32(0 to 30) & '1';	-- return LSB=1, error bit, on bus and ACK
			bus_data_ready		<= '1';
			bus_ack_ready  		<= '1';
			next_state_master 	<= wait_trans_done;

		when SET_IDLE_THREAD_return_with_no_error =>
			-- FIXME: this if statement and body may not be needed (idle thread should be set up at all times)
			-- If there is not a next thread ready to run, then make the newly set idle thread ready to run.
			if (Next_Thread_Valid_reg = '0') then
				Next_Thread_Valid_next	<= '1';
				next_thread_id_next		<= idle_thread_id;	
			end if;

			bus_data_out		<= Z32(0 to 31);		-- return all 0's on bus and ACK
			bus_data_ready		<= '1';
			bus_ack_ready  		<= '1';
			next_state_master 	<= wait_trans_done;
		----------------------------
		-- SET_IDLE_THREAD: end
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

