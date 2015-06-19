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
--
--  Title    Thread Manager
--
--  26 Jul 2004: Mike Finley: Original author
--  08 Jun 2005: Erik Anderson: Changes for new interface between TM and 
--      Scheduler.  Also adding function isQueue().
--  15 Apr 2009: Jim Stevens: Ported to PLB version 4.6.
--
---------------------------------------------------------------------------
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

-- DO NOT EDIT ABOVE THIS LINE --------------------

--USER libraries added here

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_SLV_DWIDTH                 -- Slave interface data bus width
--   C_NUM_REG                    -- Number of software accessible registers
--
-- Definition of Ports:
--   Bus2IP_Clk                   -- Bus to IP clock
--   Bus2IP_Reset                 -- Bus to IP reset
--   Bus2IP_Addr                  -- Bus to IP address bus
--   Bus2IP_CS                    -- Bus to IP chip select
--   Bus2IP_RNW                   -- Bus to IP read/not write
--   Bus2IP_Data                  -- Bus to IP data bus
--   Bus2IP_BE                    -- Bus to IP byte enables
--   Bus2IP_RdCE                  -- Bus to IP read chip enable
--   Bus2IP_WrCE                  -- Bus to IP write chip enable
--   IP2Bus_Data                  -- IP to Bus data bus
--   IP2Bus_RdAck                 -- IP to Bus read transfer acknowledgement
--   IP2Bus_WrAck                 -- IP to Bus write transfer acknowledgement
--   IP2Bus_Error                 -- IP to Bus error response
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
    C_NUM_REG                      : integer              := 1;
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
    C_RESET_TIMEOUT : natural := 4096
  );
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------
    --USER ports added here
    -- ADD USER PORTS ABOVE THIS LINE ------------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol ports, do not add to or delete
    Bus2IP_Clk                     : in  std_logic;
    Bus2IP_Reset                   : in  std_logic;
    Bus2IP_Addr                    : in  std_logic_vector(0 to 31);
    Bus2IP_CS                      : in  std_logic_vector(0 to 0);
    Bus2IP_RNW                     : in  std_logic;
    Bus2IP_Data                    : in  std_logic_vector(0 to C_SLV_DWIDTH-1);
    Bus2IP_BE                      : in  std_logic_vector(0 to C_SLV_DWIDTH/8-1);
    Bus2IP_RdCE                    : in  std_logic_vector(0 to C_NUM_REG-1);
    Bus2IP_WrCE                    : in  std_logic_vector(0 to C_NUM_REG-1);
    IP2Bus_Data                    : out std_logic_vector(0 to C_SLV_DWIDTH-1);
    IP2Bus_RdAck                   : out std_logic;
    IP2Bus_WrAck                   : out std_logic;
    IP2Bus_Error                   : out std_logic;
    -- DO NOT EDIT ABOVE THIS LINE ---------------------

    Access_Intr                : out std_logic;

    Scheduler_Reset            : out std_logic;
    Scheduler_Reset_Done       : in  std_logic;

    Semaphore_Reset            : out std_logic;
    Semaphore_Reset_Done       : in  std_logic;

    SpinLock_Reset             : out std_logic;
    SpinLock_Reset_Done        : in  std_logic;

    User_IP_Reset              : out std_logic;
    User_IP_Reset_Done         : in  std_logic;

    Soft_Stop                  : out std_logic;

    tm2sch_cpu_thread_id       : out std_logic_vector(0 to 7);
    tm2sch_opcode              : out std_logic_vector(0 to 5);
    tm2sch_data                : out std_logic_vector(0 to 7);
    tm2sch_request             : out std_logic;

    tm2sch_DOB                 : out std_logic_vector(0 to 31);
    sch2tm_ADDRB               : in std_logic_vector(0 to 8);
    sch2tm_DIB                 : in std_logic_vector(0 to 31);
    sch2tm_ENB                 : in std_logic;
    sch2tm_WEB                 : in std_logic;

    sch2tm_busy                : in  std_logic;
    sch2tm_data                : in  std_logic_vector(0 to 7);
    sch2tm_next_id             : in  std_logic_vector(0 to 7);
    sch2tm_next_id_valid       : in  std_logic
  );

  attribute SIGIS : string;
  attribute SIGIS of Bus2IP_Clk    : signal is "CLK";
  attribute SIGIS of Bus2IP_Reset  : signal is "RST";

end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is

--  Define the memory map for each register, Address[16 to 21]
--
  constant C_CLEAR_THREAD      : std_logic_vector(0 to 5) := "000000";
  constant C_JOIN_THREAD       : std_logic_vector(0 to 5) := "000001";
  constant C_READ_THREAD       : std_logic_vector(0 to 5) := "000011";
  constant C_ADD_THREAD        : std_logic_vector(0 to 5) := "000100";

  constant C_CREATE_THREAD_J   : std_logic_vector(0 to 5) := "000101";
  constant C_CREATE_THREAD_D   : std_logic_vector(0 to 5) := "000110";
  constant C_EXIT_THREAD       : std_logic_vector(0 to 5) := "000111";
  constant C_NEXT_THREAD       : std_logic_vector(0 to 5) := "001000";
  constant C_YIELD_THREAD      : std_logic_vector(0 to 5) := "001001";

  constant C_CURRENT_THREAD    : std_logic_vector(0 to 5) := "010000";
  constant C_IS_DETACHED       : std_logic_vector(0 to 5) := "011000";
  constant C_IS_QUEUED         : std_logic_vector(0 to 5) := "011001";

  constant C_EXCEPTION_ADDR    : std_logic_vector(0 to 5) := "010011";
  constant C_EXCEPTION_REG     : std_logic_vector(0 to 5) := "010100";

  constant C_SOFT_START        : std_logic_vector(0 to 5) := "010101";
  constant C_SOFT_STOP         : std_logic_vector(0 to 5) := "010110";
  constant C_SOFT_RESET        : std_logic_vector(0 to 5) := "010111";
  constant C_SCHED_LINES       : std_logic_vector(0 to 5) := "011010";

  constant OPCODE_NOOP         : std_logic_vector(0 to 5) := "000000";
  constant OPCODE_IS_QUEUED    : std_logic_vector(0 to 5) := "000001";
  constant OPCODE_ENQUEUE      : std_logic_vector(0 to 5) := "000010";
  constant OPCODE_DEQUEUE      : std_logic_vector(0 to 5) := "000011";
  constant OPCODE_IS_EMPTY     : std_logic_vector(0 to 5) := "000110";

  constant Z32                 : std_logic_vector(0 to 31) := (others => '0');
  constant H32                 : std_logic_vector(0 to 31) := (others => '1');

  constant MAX_QUEUE_SIZE      : std_logic_vector(0 to 7) := (others => '1');
  constant TOUT_CYCLES         : natural := 3;    -- assert timeout suppress

  signal   cycle_count         : std_logic_vector(0 to 15);
  signal   timeout_expired     : std_logic;

--  Extended Thread Error Codes returned in lower 4 bits
  constant ERROR_IN_STATUS                : std_logic_vector(0 to 3) := "0001";
  constant THREAD_ALREADY_TERMINATED      : std_logic_vector(0 to 3) := "0011";
  constant THREAD_ALREADY_QUEUED          : std_logic_vector(0 to 3) := "0101";
  constant ERROR_FROM_SCHEDULER           : std_logic_vector(0 to 3) := "0111";
  constant JOIN_ERROR_CHILD_JOINED        : std_logic_vector(0 to 3) := "1001";
  constant JOIN_ERROR_NOT_CHILD           : std_logic_vector(0 to 3) := "1011";
  constant JOIN_ERROR_CHILD_DETACHED      : std_logic_vector(0 to 3) := "1101";
  constant JOIN_ERROR_CHILD_NOT_USED      : std_logic_vector(0 to 3) := "1111";
  constant JOIN_ERROR_UNKNOWN             : std_logic_vector(0 to 3) := "0001";
  constant CLEAR_ERROR_NOT_USED           : std_logic_vector(0 to 3) := "1001";

--  Exception "cause" returned in Exception register
  constant EXCEPTION_WRITE_TO_READ_ONLY  : std_logic_vector(0 to 3) := "0001";
  constant EXCEPTION_UNDEFINED_ADDRESS   : std_logic_vector(0 to 3) := "0010";
  constant EXCEPTION_TO_SOFT_RESET       : std_logic_vector(0 to 3) := "0011";
  constant EXCEPTION_TO_SCHD_ISQUEUED    : std_logic_vector(0 to 3) := "0100";
  constant EXCEPTION_TO_SCHD_ENQUEUE     : std_logic_vector(0 to 3) := "0101";
  constant EXCEPTION_TO_SCHD_DEQUEUE     : std_logic_vector(0 to 3) := "0110";
  constant EXCEPTION_TO_SCHD_ISEMPTY     : std_logic_vector(0 to 3) := "0111";
  constant EXCEPTION_TO_SCHD_NEXT_THREAD : std_logic_vector(0 to 3) := "1000";
  constant EXCEPTION_SCHD_INVALID_THREAD : std_logic_vector(0 to 3) := "1001";
  constant EXCEPTION_ILLEGAL_STATE       : std_logic_vector(0 to 3) := "1111";

-- BRAM constants
  constant BRAM_ADDRESS_BITS   : integer := 9;
  constant BRAM_DATA_BITS      : integer := 32;
  
--  Address,Cause for access exceptions
--
  signal Exception_Address      : std_logic_vector(0 to 31);
  signal Exception_Address_next : std_logic_vector(0 to 31);
  signal Exception_Cause        : std_logic_vector(0 to 3);
  signal Exception_Cause_next   : std_logic_vector(0 to 3);
  signal access_error           : std_logic;


--  Debug control signals
--
--      Soft reset signals, LSB = SWTM reset; reset IP(s) if '1'
--  Resets done, handshake from IPs if done resetting(1)
--      core_stop       , halt state machines at next appropriate point if '1'
--
  signal soft_resets           : std_logic_vector(0 to 4);
  signal soft_resets_next      : std_logic_vector(0 to 4);
  signal resets_done           : std_logic_vector(0 to 4);

  signal reset_status          : std_logic_vector(0 to 4);
  signal reset_status_next     : std_logic_vector(0 to 4);

  signal core_stop             : std_logic;
  signal core_stop_next        : std_logic;


--  Declarations for each register

--  Current thread,Idle thread : bits 0..7 = ID, bit 8 = '1' = invalid
  signal current_cpu_thread        : std_logic_vector(0 to 8);
  signal current_cpu_thread_next   : std_logic_vector(0 to 8);

--  internal signals
  signal next_ID               : std_logic_vector(0 to 8);
  signal next_ID_next          : std_logic_vector(0 to 8);
  signal temp_thread_id        : std_logic_vector(0 to 7);
  signal temp_thread_id_next   : std_logic_vector(0 to 7);
  signal temp_thread_id2        : std_logic_vector(0 to 7);
  signal temp_thread_id2_next   : std_logic_vector(0 to 7);

  signal reset_ID              : std_logic_vector(0 to 8);

  type swtm_state_type is
    (IDLE_STATE,

     SOFT_RESET_WRITE_INIT,
     SOFT_RESET_INIT_TABLE,
     SOFT_RESET_WAIT,

     READ_THREAD_INIT,
     READ_THREAD_RD_WAIT,
     READ_THREAD_DONE,

     CREATE_THREAD_INIT,
     CT_NEW_ID_RD_WAIT,
     CT_NEW_ID_AVAILABLE,
     CT_ENTRY_RD_WAIT,
     CT_ENTRY_AVAILABLE,
     CT_DONE,

     CLEAR_THREAD_INIT,
     CLEAR_ENTRY_RD_WAIT,
     CLEAR_ENTRY_AVAIABLE,
     DEALLOCATE_ID,
     DEALLOCATE_NEXT_ENTRY_RD_WAIT,
     DEALLOCATE_NEXT_ENTRY_AVAIL,

     JOIN_THREAD_INIT,
     JOIN_RD_ENTRY_RD_WAIT,
     JOIN_RD_ENTRY_AVAILABLE,

	 IS_QUEUED_INIT,
	 IS_QUEUED_DONE,

     IS_DETACHED_THREAD_INIT,
     IS_DETACHED_ENTRY_RD_WAIT,
     IS_DETACHED_ENTRY_AVAILABLE,

     NEXT_THREAD_INIT,
     NEXT_THREAD_WAIT4_SCHEDULER,
     NEXT_THREAD_RD_WAIT,
     NEXT_THREAD_AVAILABLE,
     NEXT_THREAD_CHECK_DEQUEUE,

     ADD_THREAD_INIT,
     AT_ENTRY_RD_WAIT,
     AT_ENTRY_AVAILABLE,
	 AT_ISQUEUED_WAIT,
	 AT_CHECK_ISQUEUE,
	 AT_ENQUEUE_WAIT,
     AT_CHECK_ENQUEUE,

	 ISQUEUED_WAIT_ACK,
	 ISQUEUED_WAIT_COMPLETE,

	 ENQUEUE_WAIT_ACK,
	 ENQUEUE_WAIT_COMPLETE,

	 DEQUEUE_WAIT_ACK,
	 DEQUEUE_WAIT_COMPLETE,

	 IS_QUEUE_EMPTY_WAIT_ACK,
	 IS_QUEUE_EMPTY_WAIT_COMPLETE,

     YIELD_THREAD_INIT,
     YIELD_CURRENT_THREAD_RD_WAIT,
     YIELD_CURRENT_THREAD_AVAILABLE,
     YIELD_CHECK_QUEUE_EMPTY,
	 YIELD_ENQUEUE,
	 YIELD_CHECK_ENQUEUE,
--	 YIELD_dummy_is_queued,
	 YIELD_DEQUEUE,
	 YIELD_CHECK_DEQUEUE,

     EXIT_THREAD_INIT,
     EXIT_THREAD_RD_WAIT,
     EXIT_THREAD_AVAIABLE,
     EXIT_DEALLOCATE,
     EXIT_NEXT_THREAD_RD_WAIT,
     EXIT_NEXT_THREAD_AVAILABLE,
     EXIT_READ_PARENT,
     EXIT_READ_PARENT_WAIT,
     EXIT_READ_PARENT_AVAILABLE,
     EXIT_CHECK_ENQUEUE,
 
     RAISE_EXCEPTION,

     END_TRANSACTION,
     END_TRANSACTION_WAIT);

        
  signal current_state, next_state : swtm_state_type := IDLE_STATE;
  signal return_state, return_state_next : swtm_state_type := IDLE_STATE;

  signal bus_data_out          : std_logic_vector(0 to 31);
  signal bus_data_out_next     : std_logic_vector(0 to 31);

  signal current_status        : std_logic_vector(0 to 31);
  signal current_status_next   : std_logic_vector(0 to 31);
  
  signal Swtm_Reset_Done       : std_logic;
  signal Swtm_Reset_Done_next  : std_logic;

  signal new_ID                : std_logic_vector(0 to 7);
  signal new_ID_next           : std_logic_vector(0 to 7);

  signal tm2sch_request_next   : std_logic;
  signal tm2sch_request_reg    : std_logic;
  signal tm2sch_data_next      : std_logic_vector(0 to 7);
  signal tm2sch_data_reg      : std_logic_vector(0 to 7);
  signal tm2sch_opcode_next    : std_logic_vector(0 to 5);
  signal tm2sch_opcode_reg    : std_logic_vector(0 to 5);

  -- Signals for thread table BRAM
  signal ENA                   : std_logic;
  signal WEA                   : std_logic;
  signal ADDRA                 : std_logic_vector(0 to BRAM_ADDRESS_BITS - 1);
  signal DIA                   : std_logic_vector(0 to BRAM_DATA_BITS - 1);
  signal DOA                   : std_logic_vector(0 to BRAM_DATA_BITS - 1);

  alias addr                   :std_logic_vector(0 to 5) is Bus2IP_Addr(16 to 21);

---------------------------------------------------------------------------
-- Component Instantiation of inferred dual ported block RAM
---------------------------------------------------------------------------

component infer_bram_dual_port is
  generic (
    ADDRESS_BITS    : integer := 9;
    DATA_BITS       : integer := 32
  );
  port (
    CLKA    : in std_logic;
    ENA     : in std_logic;
    WEA     : in std_logic;
    ADDRA   : in std_logic_vector(0 to ADDRESS_BITS - 1);
    DIA     : in std_logic_vector(0 to DATA_BITS - 1);
    DOA     : out  std_logic_vector(0 to DATA_BITS - 1);

    CLKB    : in std_logic;
    ENB     : in std_logic;
    WEB     : in std_logic;
    ADDRB   : in std_logic_vector(0 to ADDRESS_BITS - 1);
    DIB     : in std_logic_vector(0 to DATA_BITS - 1);
    DOB     : out  std_logic_vector(0 to DATA_BITS - 1)
  );
end component infer_bram_dual_port;

  -------------------------------------------------------------------
  --  ICON core signal declarations
  -------------------------------------------------------------------
  signal control0              : std_logic_vector(35 downto 0);
  signal my_ack, my_tout_sup, my_error, my_sched_req : std_logic; -- TODO: This line might be gone.
  signal my_counter : std_logic_vector(0 to 31);
  
  

  -------------------------------------------------------------------
  --  ICON core component declaration
  -------------------------------------------------------------------
  -- simulation translate_off  
  --component chipscope_icon_v1_03_a
  --  port
  --    (
  --     control0               :   out std_logic_vector(35 downto 0)
  --      );
  --end component;
  -- simulation translate_on

  -------------------------------------------------------------------
  --  ILA core component declaration
  -------------------------------------------------------------------
  -- simulation translate_off
  --component chipscope_ila_v1_02_a
  --  port
  --    (
  ---      control                : in    std_logic_vector(35 downto 0);
  --      clk                    : in    std_logic;
  --      trig0                  : in    std_logic_vector(63 downto 0);
  --      trig1                  : in    std_logic_vector(63 downto 0);
  --      trig2                  : in    std_logic_vector(31 downto 0);
  --      trig3                  : in    std_logic_vector(31 downto 0);
  --      trig4                  : in    std_logic_vector(15 downto 0)
  --  );
  --end component;
  -- simulation translate_on

begin

  thread_table_bram : infer_bram_dual_port
  generic map (
    ADDRESS_BITS               => BRAM_ADDRESS_BITS,
	DATA_BITS                  => BRAM_DATA_BITS
  )
  port map (
    CLKA                       => Bus2IP_Clk,
	ENA                        => ENA,
	WEA                        => WEA,
	ADDRA                      => ADDRA,
	DIA                        => DIA,
	DOA                        => DOA,

    CLKB                       => Bus2IP_Clk,
	ENB                        => sch2tm_ENB,
	WEB                        => sch2tm_WEB,
	ADDRB                      => sch2tm_ADDRB,
	DIB                        => sch2tm_DIB,
	DOB                        => tm2sch_DOB
  );

  tm2sch_opcode <= tm2sch_opcode_reg;
  tm2sch_data <= tm2sch_data_reg;
  tm2sch_request <= tm2sch_request_reg;
  Soft_Stop               <= core_stop;

  Scheduler_Reset         <= soft_resets(3);
  Semaphore_Reset         <= soft_resets(2);
  SpinLock_Reset          <= soft_resets(1);
  User_IP_Reset           <= soft_resets(0);

  Access_Intr             <= access_error;

  CYCLE_PROC : process (Bus2IP_Clk, Bus2IP_CS) is
  begin
    if( Bus2IP_Clk'event and Bus2IP_Clk='1' ) then
      if( Bus2IP_CS(0) = '0' ) then
        cycle_count <= (others => '0');
      else
        cycle_count <= cycle_count + 1;
      end if;
    end if;
  end process CYCLE_PROC;

  --  
  --  create a counter for the number of elapsed cycles
  --        in each bus transaction.
  --      assert TimeOut suppress when count = TOUT_CYCLES
  --
  CYCLE_CONTROL : process( cycle_count ) is
  begin
    IP2Bus_Error       <= '0';    -- no error

    --
    --  count the number of elapsed clock cycles in transaction
    --
    if cycle_count < C_RESET_TIMEOUT then
      timeout_expired <= '0';
    else 
      --timeout_expired <= '1';
      timeout_expired <= '0'; -- Disable timeouts.
    end if;

    --
    --  activate time out suppress if count exceeds TOUT_CYCLES
    -- edk. Why isn't this done inside the clk_event ???
    --
--    if cycle_count > TOUT_CYCLES then
--     --IP2Bus_ToutSup <= '1';     -- halt time out counter
--    my_tout_sup <= '1';     -- halt time out counter
--    else
--      --IP2Bus_ToutSup <= '0';             -- release
--      my_tout_sup <= '0';             -- release
--    end if;
  end process CYCLE_CONTROL;

--      IP2Bus_ToutSup <= my_tout_sup;

  RESET_PROC : process (Bus2IP_Clk, addr, current_state)
  begin
    if( Bus2IP_Clk'event and Bus2IP_Clk = '1' ) then
      if( addr = C_SOFT_RESET and current_state = SOFT_RESET_WRITE_INIT ) then
        reset_ID  <= (others => '0');
      else
        reset_ID  <= reset_ID + 1;
      end if;
    end if;
  end process;

  ACK_PROC : process(my_ack, Bus2IP_RdCE, Bus2IP_WrCE)
  begin
    if (Bus2IP_RdCE(0) = '1') then
      IP2Bus_RdAck <= my_ack;
    else
      IP2Bus_RdAck <= '0';
    end if;

    if (Bus2IP_WrCE(0) = '1') then
      IP2Bus_WrAck <= my_ack;
    else
      IP2Bus_WrAck <= '0';
    end if;
  end process;

  SWTM_STATE_PROC : process (Bus2IP_Clk, core_stop_next, new_ID_next, next_ID_next, temp_thread_id_next, temp_thread_id2_next, current_cpu_thread_next, Current_status_next, soft_resets_next, reset_status_next, Swtm_Reset_Done_next, Scheduler_Reset_Done, Semaphore_Reset_Done, SpinLock_Reset_Done, User_IP_Reset_Done, next_state, return_state_next, Bus2IP_Reset,Exception_Cause_next) is
  begin
    if (Bus2IP_Clk'event and (Bus2IP_Clk = '1')) then
      core_stop            <= core_stop_next;
      new_ID               <= new_ID_next;
      next_ID              <= next_ID_next;
      temp_thread_id       <= temp_thread_id_next;
      temp_thread_id2       <= temp_thread_id2_next;
      current_cpu_thread   <= current_cpu_thread_next;
      tm2sch_cpu_thread_id <= current_cpu_thread_next(0 to 7);
      tm2sch_data_reg      <= tm2sch_data_next;
      tm2sch_opcode_reg    <= tm2sch_opcode_next;
      tm2sch_request_reg   <= tm2sch_request_next;
      current_status       <= current_status_next;
      Exception_Address    <= Exception_Address_next;
      Exception_Cause      <= Exception_Cause_next;

      soft_resets          <= soft_resets_next;
      reset_status         <= reset_status_next;
      bus_data_out         <= bus_data_out_next;

      Swtm_Reset_Done      <= Swtm_Reset_Done_next;
      resets_done(4)       <= Swtm_Reset_Done_next;
      resets_done(3)       <= Scheduler_Reset_Done;    
      resets_done(2)       <= Semaphore_Reset_Done;
      resets_done(1)       <= SpinLock_Reset_Done;
      resets_done(0)       <= User_IP_Reset_Done;

      return_state         <= return_state_next;
      if( Bus2IP_Reset = '1' ) then
        current_state      <= IDLE_STATE;
      else
        current_state      <= next_state;
      end if;
    end if;

  end process SWTM_STATE_PROC;

--    IP2Bus_Ack   <= my_ack;   -- pulse(010) to end bus transaction

  SWTM_LOGIC_PROC : process (current_state, core_stop, new_ID, next_ID, current_cpu_thread, current_status, reset_status, Swtm_Reset_Done, soft_resets, Bus2IP_Addr, Bus2IP_Data, Exception_Address, Bus2IP_WrCE, addr, Bus2IP_RdCE, reset_ID, resets_done, timeout_expired, DOA, sch2tm_next_id_valid, sch2tm_next_id, sch2tm_busy, bus_data_out, Exception_Cause, tm2sch_request_reg, tm2sch_data_reg, tm2sch_opcode_reg, temp_thread_id, temp_thread_id2) is

  begin

    -- -------------------------------------------------
    -- default output signal assignments
    -- -------------------------------------------------
    my_ack   <= '0';   -- pulse(010) to end bus transaction
    access_error <= '0';   -- pulse(010) for access error interrupt

    IP2Bus_Data  <= (others => '0');

    ADDRA <= (others => '0');
    ENA <= '0';
    WEA <= '0';
    DIA <= (others => '0');

    -- -------------------------------------------------
    -- default register assignments
    -- -------------------------------------------------
    next_state              <= current_state;
    return_state_next       <= return_state;
    core_stop_next          <= core_stop;
    new_ID_next             <= new_ID;
    next_ID_next            <= next_ID;
    temp_thread_id_next     <= temp_thread_id;
    temp_thread_id2_next     <= temp_thread_id2;
    current_cpu_thread_next <= current_cpu_thread;
    current_status_next     <= current_status;
    Exception_Address_next  <= Exception_Address;
    reset_status_next       <= reset_status;
    Swtm_Reset_Done_next    <= Swtm_Reset_Done;
    Exception_Cause_next    <= Exception_Cause;
    tm2sch_request_next     <= tm2sch_request_reg;
    tm2sch_data_next        <= tm2sch_data_reg;
    tm2sch_opcode_next      <= tm2sch_opcode_reg;

    bus_data_out_next       <= bus_data_out;
    soft_resets_next        <= soft_resets;
    
    case current_state is

      -- Command (addr) decode whenever we are waiting for something new to do.
      when IDLE_STATE =>
        bus_data_out_next <= (others => '0');

        if (Bus2IP_WrCE(0) = '1') then
          case addr is
            when C_SOFT_START     =>
              --    Any write to soft_start address clears
              --    all soft reset signals and the Soft_Stop signal
              soft_resets_next     <= (others => '0');
              swtm_reset_done_next <= '0';  -- clear SWTM's reset done

              core_stop_next <= '0';               -- clear core_stop
              next_state     <= END_TRANSACTION;

            when C_SOFT_STOP      =>
              --  write any data to Soft_Stop to assert the Soft_Stop signal
              core_stop_next <= '1';
              next_state <= END_TRANSACTION;
                                     
            when C_SOFT_RESET     =>
              next_state <= SOFT_RESET_WRITE_INIT;

            when C_READ_THREAD    =>
              if (core_stop = '1') then 
                ADDRA <= '0' & Bus2IP_Addr(22 to 29); -- thread ID
                WEA  <= '1';
                ENA  <= '1';
                DIA  <= Bus2IP_Data(0 to 31);
                next_state <= END_TRANSACTION;
              else
                Exception_Cause_next <= EXCEPTION_WRITE_TO_READ_ONLY;
                next_state <= RAISE_EXCEPTION;
              end if;
              
            when others =>
              Exception_Cause_next <= EXCEPTION_UNDEFINED_ADDRESS;
              next_state <= RAISE_EXCEPTION;
          end case;
        elsif (Bus2IP_RdCE(0) = '1') then
          case addr is
            when C_SOFT_START     =>
              bus_data_out_next <= (others => '0');
              next_state <= END_TRANSACTION;

            when C_SOFT_STOP      => 
              --    returns signal level in LSB on read
              bus_data_out_next <= Z32(0 to 30) & core_stop;
              next_state <= END_TRANSACTION;
              
            when C_SOFT_RESET     => 
              -- returns 1's in bit positions that failed
              bus_data_out_next <= Z32(0 to 26) & reset_status;
              next_state <=  END_TRANSACTION;
              
            when C_CURRENT_THREAD =>
              bus_data_out_next <= Z32(0 to 22) & current_cpu_thread;
              next_state <= END_TRANSACTION;

            when C_EXCEPTION_ADDR =>
              bus_data_out_next <= Exception_Address;
    		  Exception_Address_next <= (others => '0');
              next_state <= END_TRANSACTION;

            when C_EXCEPTION_REG  =>
              bus_data_out_next <= Z32(0 to 27) & Exception_Cause;
    		  Exception_Cause_next <= (others => '0');
              next_state <= END_TRANSACTION;

            when C_SCHED_LINES    =>
              bus_data_out_next <= Z32(0 to 6) & sch2tm_busy & sch2tm_data & 
                                   Z32(16 to 22) & sch2tm_next_id_valid & 
                                   sch2tm_next_id;
              next_state <= END_TRANSACTION;

            when C_READ_THREAD    => next_state <= READ_THREAD_INIT;
            when C_CREATE_THREAD_D => next_state <= CREATE_THREAD_INIT;
            when C_CREATE_THREAD_J => next_state <= CREATE_THREAD_INIT;
            when C_CLEAR_THREAD   => next_state <= CLEAR_THREAD_INIT;
            when C_JOIN_THREAD    => next_state <= JOIN_THREAD_INIT;
            when C_IS_DETACHED    => next_state <= IS_DETACHED_THREAD_INIT;
			when C_IS_QUEUED      => next_state <= IS_QUEUED_INIT;
            when C_NEXT_THREAD    => next_state <= NEXT_THREAD_INIT;
            when C_ADD_THREAD     => next_state <= ADD_THREAD_INIT;
            when C_YIELD_THREAD   => next_state <= YIELD_THREAD_INIT;
            when C_EXIT_THREAD    => next_state <= EXIT_THREAD_INIT;
            when others =>
              Exception_Cause_next <= EXCEPTION_UNDEFINED_ADDRESS;
              next_state <= RAISE_EXCEPTION;
          end case;
        end if;
        
        --
        --  read/write to the soft resets register (1 bit per IP)
        --      write '1' to reset, reads '1' if timeout error occured
        --    before IP reports finished
        --
        --  SW Thread Manager = bit#4  (LSB)
        --  Scheduler         = bit#3
        --  Semaphore         = bit#2
        --  SpinLock          = bit#1
        --  User_IP           = bit#0
        --
      when SOFT_RESET_WRITE_INIT =>
        soft_resets_next    <= Bus2IP_Data(27 to 31);
        reset_status_next   <= (others => '0');
        swtm_reset_done_next <= '0';    -- clear SWTM's reset_done

        if (Bus2IP_Data(31) = '1') then  -- soft_resets(4)
          --
          --  perform a soft reset on SWTM
          --
          bus_data_out_next        <= (others => '0');
          new_ID_next              <= (others => '0');
          next_ID_next             <= (others => '0');
          temp_thread_id_next      <= (others => '0');
          current_cpu_thread_next  <= Z32(0 to 7) & '1';
          core_stop_next           <= '0';
		  tm2sch_opcode_next       <= OPCODE_NOOP;
		  tm2sch_data_next         <= (others => '0');
		  tm2sch_request_next      <= '0';
          next_state <= SOFT_RESET_INIT_TABLE;
        else
          next_state <= SOFT_RESET_WAIT;
        end if;


        --  initialize the thread ID table to all zeros
        --   and the next available stack to 0..255
      when SOFT_RESET_INIT_TABLE =>
        ADDRA   <= reset_ID;
        ENA     <= '1';
        WEA     <= '1';

        if( reset_ID(0) = '0' ) then
          --  init available ID stack & thread ID table
          DIA <= reset_ID(1 to 8) & Z32(0 to 23);
        else
          --  clear 2nd half of table (unused)
          DIA <= Z32(0 to 31);
        end if;

        if( reset_ID = H32(0 to 8) ) then
          swtm_reset_done_next<= '1';        -- done
          next_state <= soft_reset_wait;
        end if;

        --  wait for all IPs to finish initialization or
        --   the maximum time to be exceeded then
        --   ack to finish transaction
      when SOFT_RESET_WAIT =>
        if (resets_done = soft_resets) then     -- done
          next_state <= END_TRANSACTION;
        elsif (timeout_expired = '1') then
          reset_status_next <= (resets_done xor soft_resets);
          Exception_Cause_next <= EXCEPTION_TO_SOFT_RESET;
          next_state <= RAISE_EXCEPTION; -- timeout
        else
          next_state <= current_state;
        end if;

      when READ_THREAD_INIT =>
        ADDRA <= '0' & Bus2IP_Addr(22 to 29); -- thread ID
        WEA  <= '0';
        ENA  <= '1';
        next_state <= READ_THREAD_RD_WAIT;

      when READ_THREAD_RD_WAIT =>
        next_state <= READ_THREAD_DONE;

      when READ_THREAD_DONE =>
        bus_data_out_next <= DOA;
        next_state <= END_TRANSACTION;

      when CREATE_THREAD_INIT =>
        if next_ID(0) = '1' then
          --  no IDs available, return with error bit set
          --
          bus_data_out_next <= Z32(0 to 30) & '1';
          next_state <= END_TRANSACTION;
        else
          -- read next ID from stack
          --
          ADDRA <= next_ID;
          ENA   <= '1';
          next_state <= CT_NEW_ID_RD_WAIT;
        end if;

      when CT_NEW_ID_RD_WAIT =>
        next_state <= CT_NEW_ID_AVAILABLE;

      when CT_NEW_ID_AVAILABLE =>
        new_ID_next <= DOA(0 to 7);  -- save new ID#
        ADDRA <= '0' & DOA(0 to 7);  -- point to new thread
        ENA   <= '1';
        next_state <= CT_ENTRY_RD_WAIT;

      when CT_ENTRY_RD_WAIT =>
        next_state <= CT_ENTRY_AVAILABLE;

      when CT_ENTRY_AVAILABLE =>
        ADDRA <= '0' & new_ID;
        ENA <= '1';
        WEA <= '1';   -- enable write to bram
        -- Determine if the thread to create is DETACHED / JOINABLE
        if addr = C_CREATE_THREAD_D then      -- set new thread status
          --  create detached
          DIA <= DOA(0 to 7) & Z32(0 to 7) &
                 Z32(0 to 7) & "1011" & Z32(0 to 3);
        else
          --  create joinable
          DIA <= DOA(0 to 7) & Z32(0 to 7) &
                 current_cpu_thread(0 to 7) & "0011" & Z32(0 to 3);
        end if;
        next_state <= CT_DONE;

      when CT_DONE =>
        --  return new ID with no error,
        bus_data_out_next <= Z32(0 to 22) & new_ID & '0';
        --  point to next available ID
        next_ID_next <= next_ID + 1;
        next_state <= END_TRANSACTION;

      when CLEAR_THREAD_INIT =>
        --  clear the encoded thread ID if it is used and exited
        ADDRA  <= '0' & Bus2IP_Addr(22 to 29);  -- thread ID
        ENA    <= '1';
        next_state <= CLEAR_ENTRY_RD_WAIT;
      when CLEAR_ENTRY_RD_WAIT =>
        next_state <= CLEAR_ENTRY_AVAIABLE ;

      when CLEAR_ENTRY_AVAIABLE =>
        if (DOA(26 to 27) = "10")  then                     -- used and exited
          bus_data_out_next <= Z32;                         -- success, return zero

          ADDRA  <= '0' & Bus2IP_Addr(22 to 29);            -- thread ID
          ENA <= '1';
          WEA <= '1';                                       -- clear old status but
          DIA <= DOA(0 to 7) & Z32(0 to 23);                --  preserve ID stack
          next_state <= DEALLOCATE_ID;
        else
          --  error occurred, return thread status w/ LSB=1
          bus_data_out_next <= DOA(0 to 27) & CLEAR_ERROR_NOT_USED;
          next_state <= END_TRANSACTION;
        end if;

      when DEALLOCATE_ID =>
        if (next_ID /= Z32(0 to 8)) then
          ADDRA   <= next_ID - 1;
          ENA <= '1';
          next_ID_next <= next_ID - 1;
          next_state <= DEALLOCATE_NEXT_ENTRY_RD_WAIT;
        else
          next_state <= END_TRANSACTION;
        end if;

      when DEALLOCATE_NEXT_ENTRY_RD_WAIT =>
        next_state <= DEALLOCATE_NEXT_ENTRY_AVAIL;

      when DEALLOCATE_NEXT_ENTRY_AVAIL =>
        -- put ID back on stack,   preserve other bits
        ADDRA   <= next_ID;
        ENA <= '1';
        WEA <= '1';
        DIA <= Bus2IP_Addr(22 to 29) & DOA(8 to 31);
        next_state <= END_TRANSACTION;

      when JOIN_THREAD_INIT =>
        --  join on the encoded thread ID if its PID = current_thread
        --    and its status = used,~joined,~detached
        ADDRA  <= '0' & Bus2IP_Addr(22 to 29);  -- thread ID
        ENA    <= '1';
        next_state <= JOIN_RD_ENTRY_RD_WAIT;

      when JOIN_RD_ENTRY_RD_WAIT =>
        next_state <= JOIN_RD_ENTRY_AVAILABLE;

      when JOIN_RD_ENTRY_AVAILABLE =>
        if ((DOA(16 to 23) & '0' = current_cpu_thread) and  -- PID = current thread
            (DOA(24 to 25) =  "00")  and                -- ~detached,~joined
            (DOA(26 to 27) /= "00"))  then              -- not unused
          if DOA(27) = '0' then
            -- thread has already exited, return a WARNING code
            bus_data_out_next <= Z32(0 to 27) & THREAD_ALREADY_TERMINATED;

            next_state <= END_TRANSACTION;

          else
		    -- thread has not exited
            bus_data_out_next <= Z32;        -- success, return zero

            ADDRA  <= '0' & Bus2IP_Addr(22 to 29);  -- thread ID
            ENA <= '1';
            WEA <= '1';
            -- clear old status but
            -- set joined bit; and preserve all other bits
            DIA <= DOA(0 to 24) & '1' & DOA(26 to 31);
            next_state <= END_TRANSACTION;
          end if;

        else
          -- An error occured.  Determine the error and return correct error code.
          if( DOA(24) =  '1' ) then
		    -- trying to join on a detached thread
            bus_data_out_next <= DOA(0 to 27) & JOIN_ERROR_CHILD_DETACHED;
		  elsif ( DOA(24 to 25) = "01" ) then
		    -- tyring to join on a thread that is already joined
            bus_data_out_next <= DOA(0 to 27) & JOIN_ERROR_CHILD_JOINED;
          elsif( DOA(26) = '0' ) then
		    -- trying to join on a thread that is not used
            bus_data_out_next <= DOA(0 to 27) & JOIN_ERROR_CHILD_NOT_USED;
          elsif( DOA(16 to 23) & '0' /= current_cpu_thread ) then
		    -- trying to join to a thread that is not the current thread's child
            bus_data_out_next <= DOA(0 to 27) & JOIN_ERROR_NOT_CHILD;
          else
            bus_data_out_next <= DOA(0 to 27) & JOIN_ERROR_UNKNOWN;
          end if;
          next_state <= END_TRANSACTION;
        end if;

      when IS_DETACHED_THREAD_INIT =>
        -- Returns a 1 if the encoded thread ID is detached, else returns 0
        ADDRA  <= '0' & Bus2IP_Addr(22 to 29);  -- thread ID
        ENA    <= '1';
        next_state <= IS_DETACHED_ENTRY_RD_WAIT;

      when IS_DETACHED_ENTRY_RD_WAIT =>
        next_state <= IS_DETACHED_ENTRY_AVAILABLE;

      when IS_DETACHED_ENTRY_AVAILABLE =>
        if (DOA(24) = '1' and DOA(26) = '1') then
          -- Thread is detached, return 1
          bus_data_out_next <= Z32(0 to 29) & "10"; -- The 0 in the last bit indicates no error
		else
		  -- Thread is not detached, or not used, return 0
          bus_data_out_next <= Z32;
        end if;
		next_state <= END_TRANSACTION;
	
	  when IS_QUEUED_INIT =>
	    tm2sch_opcode_next <= OPCODE_IS_QUEUED;
		tm2sch_request_next <= '1';
		tm2sch_data_next <= Bus2IP_Addr(22 to 29); -- thread ID
		next_state <= ISQUEUED_WAIT_ACK;
		return_state_next <= IS_QUEUED_DONE;
	  
	  when IS_QUEUED_DONE =>
	    bus_data_out_next <= Z32(0 to 22) & sch2tm_data & '0';
		next_state <= END_TRANSACTION;

      when NEXT_THREAD_INIT =>
	    -- Return to the caller the value of the next thread to run
        if sch2tm_next_id_valid = '1' then
          --  the next thread has been identified,
          --  read from Scheduler and check thread status
          --  as stored by SWTM for consistency
          ADDRA <= '0' & sch2tm_next_id;
          ENA   <= '1';
          next_state <= NEXT_THREAD_RD_WAIT;
        else
          next_state <= NEXT_THREAD_WAIT4_SCHEDULER;
        end if;

      when NEXT_THREAD_WAIT4_SCHEDULER =>
        if (sch2tm_next_id_valid = '1') then
		  -- Scheduler has made a scheduling decision
          ADDRA <= '0' & sch2tm_next_id;
          ENA   <= '1';
          next_state <= NEXT_THREAD_RD_WAIT;
        elsif (timeout_expired = '1') then
		  -- Timed out waiting for scheduler
          Exception_Cause_next <= EXCEPTION_TO_SCHD_NEXT_THREAD;
          next_state <= RAISE_EXCEPTION; -- timeout
        else
		  -- Continue waiting for scheduler
          next_state <= current_state;
        end if;

      when NEXT_THREAD_RD_WAIT =>
        next_state <= NEXT_THREAD_AVAILABLE;

      when NEXT_THREAD_AVAILABLE =>
        if DOA(26 to 27) = "11" then
          --  thread status is used and not exited
          --  dequeue the next_thread_id from the scheduler's queue
          current_cpu_thread_next  <= sch2tm_next_id & '0';

          --  Send dequeue opperation to scheduler
		  tm2sch_opcode_next <= OPCODE_DEQUEUE;
		  tm2sch_request_next <= '1';
          tm2sch_data_next <= Z32(0 to 7);
          next_state <= DEQUEUE_WAIT_ACK;
		  return_state_next <= NEXT_THREAD_CHECK_DEQUEUE;
        else
          --  TM and SCHEDULER disagree if thread was used and not exited
          --  return thread ID, set error bit and raise exception
          bus_data_out_next <= Z32(0 to 22) & sch2tm_next_id & '1';
          Exception_Cause_next <= EXCEPTION_SCHD_INVALID_THREAD;
          next_state <= RAISE_EXCEPTION; -- timeout

        end if;

      when NEXT_THREAD_CHECK_DEQUEUE =>
	    -- Perform a check to make sure scheduler completed successfully
        if sch2tm_data(7) = '1' then
		  -- error during enqueue
		  bus_data_out_next <= Z32(0 to 27) & ERROR_FROM_SCHEDULER; 
          next_state <= END_TRANSACTION;
        else
		  -- enqueue completed correctly
		  -- return the value of the next thread id (which by now is in the current_cpu_thread register)
		  bus_data_out_next <= Z32(0 to 22) & current_cpu_thread(0 to 7) & '0';
          next_state <= END_TRANSACTION;
        end if;

      when ADD_THREAD_INIT =>
        --  if the thread is !used or exited return error
		--  call scheduler to check queued status
		--  if queued return error
		--  call scheduler to enqueue thread ID
		
        ADDRA <= '0' & Bus2IP_Addr(22 to 29);  -- encoded thread ID
        ENA   <= '1';
        next_state <= AT_ENTRY_RD_WAIT;

      when AT_ENTRY_RD_WAIT =>
        next_state <= AT_ENTRY_AVAILABLE;

      when AT_ENTRY_AVAILABLE =>
	    -- check to see if the thread is used and !exited
        if (DOA(26 to 27) = "11")  then
		  -- thread is used and not exited
          -- call scheduler isQueued
		  tm2sch_request_next <= '1';
		  tm2sch_data_next <= Bus2IP_Addr(22 to 29);
		  tm2sch_opcode_next <= OPCODE_IS_QUEUED;
		  next_state <= ISQUEUED_WAIT_ACK;
		  return_state_next <= AT_CHECK_ISQUEUE;
        else
          --  thread is unused or exited (or both)
          --  operation failed, return error code
          bus_data_out_next <= DOA(0 to 27) & ERROR_IN_STATUS;
          next_state <= END_TRANSACTION;
        end if;

      when AT_CHECK_ISQUEUE =>
	    -- Check to see if the thread is queued
	    if sch2tm_data(7) = '0' then
		  -- Thread is not queued, call scheduler's enqueue
		  tm2sch_request_next <= '1';
		  tm2sch_data_next <= Bus2IP_Addr(22 to 29);
		  tm2sch_opcode_next <= OPCODE_ENQUEUE;
		  next_state <= ENQUEUE_WAIT_ACK;
		  return_state_next <= AT_CHECK_ENQUEUE;
		else 
		  -- Thread is queued, return error
          bus_data_out_next <= DOA(0 to 7) & sch2tm_data & DOA(16 to 27) & THREAD_ALREADY_QUEUED;
          next_state <= END_TRANSACTION;
		end if;

      when AT_CHECK_ENQUEUE =>
        -- Check to make sure the scheduler added the thread correctly
        if sch2tm_data(7) = '1' then
		  -- error during enqueue
		  bus_data_out_next <= Z32(0 to 7) & sch2tm_data & Z32(16 to 27) & ERROR_FROM_SCHEDULER; 
          next_state <= END_TRANSACTION;
        else
		  -- enqueue completed correctly
		  bus_data_out_next <= Z32(0 to 7) & sch2tm_data & Z32(16 to 31); 
          next_state <= END_TRANSACTION;
        end if;

      when ISQUEUED_WAIT_ACK =>
	    -- wait for the scheduler to acknowledge the isqueued request
        if sch2tm_busy = '0' then
          -- scheduler has not yet responded to request
		  next_state <= current_state;
		elsif (timeout_expired = '1') then
		  -- timed out waiting for scheduler
          Exception_Cause_next <= EXCEPTION_TO_SCHD_ISQUEUED;
          next_state <= RAISE_EXCEPTION;
		else
		  -- scheduler acknowledged request, lower request line
		  tm2sch_request_next <= '0';
		  tm2sch_data_next <= Z32(0 to 7);
		  tm2sch_opcode_next <= OPCODE_NOOP;
		  next_state <= ISQUEUED_WAIT_COMPLETE;
		end if;

      when ISQUEUED_WAIT_COMPLETE =>
	    -- wait for the scheduler to complete the isqueued request
		if sch2tm_busy = '1' then
		  -- scheduler has not yet completed request
		  next_state <= current_state;
		elsif (timeout_expired = '1') then
		  -- timed out waiting for scheduler
          Exception_Cause_next <= EXCEPTION_TO_SCHD_ISQUEUED;
          next_state <= RAISE_EXCEPTION;
		else
		  -- scheduler finished request, and (should) have data on data_return line
		  tm2sch_data_next <= Z32(0 to 7);
		  tm2sch_opcode_next <= OPCODE_NOOP;
		  next_state <= return_state;
		end if;

      when ENQUEUE_WAIT_ACK =>
	    -- Wait for the scheduler to acknowledge the enqueue request
        if sch2tm_busy = '0' then
		  -- Scheduler has not yet responded
			next_state <= current_state;
        elsif (timeout_expired = '1') then
		  -- Timed out waiting for queue
          Exception_Cause_next <= EXCEPTION_TO_SCHD_ENQUEUE;
          next_state <= RAISE_EXCEPTION;
        else
		  -- Scheduler has acknowledged the request
		  tm2sch_request_next <= '0';
		  tm2sch_data_next <= Z32(0 to 7);
		  tm2sch_opcode_next <= OPCODE_NOOP;
          next_state <= ENQUEUE_WAIT_COMPLETE;
        end if;

      when ENQUEUE_WAIT_COMPLETE =>
	    -- wait for the scheduler to complete the enqueue request
		if sch2tm_busy = '1' then
		  -- scheduler has notyet completed request
        elsif (timeout_expired = '1') then
		  -- Timed out waiting for queue
          Exception_Cause_next <= EXCEPTION_TO_SCHD_ENQUEUE;
          next_state <= RAISE_EXCEPTION;
        else
		  -- Scheduler has completed the request
		  tm2sch_data_next <= Z32(0 to 7);
		  tm2sch_opcode_next <= OPCODE_NOOP;
		  next_state <= return_state;
		end if;

      when DEQUEUE_WAIT_ACK =>
	    -- Wait for the scheduler to acknowledge the dequeue request
        if sch2tm_busy = '0' then
		  -- Scheduler has not yet responded
          next_state <= current_state;
        elsif (timeout_expired = '1') then
		  -- Timed out waiting for queue
          Exception_Cause_next <= EXCEPTION_TO_SCHD_DEQUEUE;
          next_state <= RAISE_EXCEPTION;
        else
		  -- Scheduler has acknowledged the request
		  tm2sch_request_next <= '0';
		  tm2sch_data_next <= Z32(0 to 7);
		  tm2sch_opcode_next <= OPCODE_NOOP;
          next_state <= DEQUEUE_WAIT_COMPLETE;
        end if;

      when DEQUEUE_WAIT_COMPLETE =>
	    -- wait for the scheduler to complete the dequeue request
		if sch2tm_busy = '1' then
		  -- scheduler has not yet completed request
        elsif (timeout_expired = '1') then
		  -- Timed out waiting for queue
          Exception_Cause_next <= EXCEPTION_TO_SCHD_DEQUEUE;
          next_state <= RAISE_EXCEPTION;
        else
		  -- Scheduler has completed the request
		  tm2sch_data_next <= Z32(0 to 7);
		  tm2sch_opcode_next <= OPCODE_NOOP;
		  next_state <= return_state;
		end if;

      when IS_QUEUE_EMPTY_WAIT_ACK =>
	    -- Wait for the scheduler to acknowledge the is queue empty request
        if sch2tm_busy = '0' then
		  -- Scheduler has not yet responded
          next_state <= current_state;
        elsif (timeout_expired = '1') then
		  -- Timed out waiting for queue
          Exception_Cause_next <= EXCEPTION_TO_SCHD_ISEMPTY;
          next_state <= RAISE_EXCEPTION;
        else
		  -- Scheduler has acknowledged the request
		  tm2sch_request_next <= '0';
		  tm2sch_data_next <= Z32(0 to 7);
		  tm2sch_opcode_next <= OPCODE_NOOP;
          next_state <= IS_QUEUE_EMPTY_WAIT_COMPLETE;
        end if;

      when IS_QUEUE_EMPTY_WAIT_COMPLETE =>
	    -- wait for the scheduler to complete the is queue empty request
		if sch2tm_busy = '1' then
		  -- scheduler has not yet completed request
        elsif (timeout_expired = '1') then
		  -- Timed out waiting for queue
          Exception_Cause_next <= EXCEPTION_TO_SCHD_ISEMPTY;
          next_state <= RAISE_EXCEPTION;
        else
		  -- Scheduler has completed the request
		  tm2sch_data_next <= Z32(0 to 7);
		  tm2sch_opcode_next <= OPCODE_NOOP;
		  next_state <= return_state;
		end if;

      when YIELD_THREAD_INIT =>
        --  Retrieve the status of the current cpu thread
        ADDRA <= '0' & current_cpu_thread(0 to 7);
        ENA   <= '1';
        next_state <= YIELD_CURRENT_THREAD_RD_WAIT;
        
      when YIELD_CURRENT_THREAD_RD_WAIT =>
        next_state <= YIELD_CURRENT_THREAD_AVAILABLE;

      when YIELD_CURRENT_THREAD_AVAILABLE =>
        --  check to see if thread's status is  used,~exited,~queued
        if (DOA(26 to 27) = "11") then
		  -- check to see if the scheduler's queue is empty
          tm2sch_request_next <= '1';
		  tm2sch_opcode_next <= OPCODE_IS_EMPTY;
		  tm2sch_data_next <= Z32(0 to 7);
		  next_state <= IS_QUEUE_EMPTY_WAIT_ACK;
		  return_state_next <= YIELD_CHECK_QUEUE_EMPTY;
        else
          --  operation failed, return error code
          bus_data_out_next <= DOA(0 to 27) & ERROR_IN_STATUS;
          next_state <= END_TRANSACTION;
        end if;
	  
      when YIELD_CHECK_QUEUE_EMPTY =>
		if (sch2tm_data(7) = '1') then
		  -- Queue is empty, return the current thread id
          bus_data_out_next <= Z32(0 to 22) & current_cpu_thread;
          next_state <= END_TRANSACTION;
		else
		  -- Queue is not empty, add currently running thread to Q and then follow with a DEQ
	      next_state	<= YIELD_ENQUEUE;
		end if;

	  when YIELD_ENQUEUE =>
          tm2sch_request_next <= '1';
		  tm2sch_opcode_next <= OPCODE_ENQUEUE;
		  tm2sch_data_next <= current_cpu_thread(0 to 7);
		  next_state <= ENQUEUE_WAIT_ACK;
		  return_state_next <= YIELD_CHECK_ENQUEUE;

	  when YIELD_CHECK_ENQUEUE =>
		if (sch2tm_data(7) = '0') then
			-- ENQ was successful, now DEQ to get next scheduling decision
			current_cpu_thread_next	<= sch2tm_next_id & '0';					-- update the currently running thread to the one that is scheduled to run next (AKA to be DEQ'd)
--			next_state				<= YIELD_dummy_is_queued;
			next_state				<= YIELD_DEQUEUE;
		else
			-- ENQ failed, return error to caller
			bus_data_out_next	<= Z32(0 to 27) & ERROR_FROM_SCHEDULER;
			next_state			<= END_TRANSACTION;
		end if;

--	  when YIELD_dummy_is_queued =>
--	        tm2sch_request_next 	<= '1';							-- request the dummy is_queued operation
  --			tm2sch_opcode_next 		<= OPCODE_IS_QUEUED;
	--  		tm2sch_data_next 		<= "11111111";
	--	  	next_state 				<= ISQUEUED_WAIT_ACK;
	--	  	return_state_next 		<= YIELD_DEQUEUE;

	  when YIELD_DEQUEUE =>
	        tm2sch_request_next 	<= '1';							-- request the DEQ operation to remove the thread to run from Q
  			tm2sch_opcode_next 		<= OPCODE_DEQUEUE;
	  		tm2sch_data_next 		<= Z32(0 to 7);
		  	next_state 				<= DEQUEUE_WAIT_ACK;
		  	return_state_next 		<= YIELD_CHECK_DEQUEUE;	

	  when YIELD_CHECK_DEQUEUE =>
		if (sch2tm_data(7) = '1') then
			-- error during DEQ...
		    bus_data_out_next <= Z32(0 to 27) & ERROR_FROM_SCHEDULER; 
			next_state	<= END_TRANSACTION;
		else
			-- DEQ completed successfully, end operation
			bus_data_out_next		<= Z32(0 to 22) & current_cpu_thread(0 to 7) & '0';		-- setup the return value of the next thread to run (now in the currently running thread)
			next_state	<= END_TRANSACTION;
		end if;
	  
      when EXIT_THREAD_INIT =>
        bus_data_out_next <= Z32; -- change if failure occurs

        ADDRA <= '0' & Bus2IP_Addr(22 to 29);
        ENA   <= '1';
        next_state <= EXIT_THREAD_RD_WAIT;
        
      when EXIT_THREAD_RD_WAIT =>
        next_state <= EXIT_THREAD_AVAIABLE;

      when EXIT_THREAD_AVAIABLE =>
        -- full entry for the current_thread is required in later states
        current_status_next <= DOA(0 to 31);

        ADDRA <= '0' & Bus2IP_Addr(22 to 29);
        ENA   <= '1';
        WEA <= '1';
        if (DOA(24) = '1') then 
          --  Thread is detached
		  --  Make the thread status used and exited.
          DIA <= DOA(0 to 25) & "10" & DOA(28 to 31);
          next_state <= END_TRANSACTION;
		elsif (DOA(25) = '1') then
		  -- Thread is joined
		  -- Make the thread status used and exited, and wake the parent
          DIA <= DOA(0 to 25) & "10" & DOA(28 to 31);
		  next_state <= EXIT_READ_PARENT;
        else
          -- Thread is not detached and still joinable
		  -- Set the thread status to used and exited
          DIA <= DOA(0 to 25) & "10" & DOA(28 to 31);
          next_state <= END_TRANSACTION;
        end if;

      when EXIT_READ_PARENT =>
	    -- The thread that is exiting was joined, wake the parent up
        ADDRA <= '0' & current_status(16 to 23);
        ENA   <= '1';
        next_state <= EXIT_READ_PARENT_WAIT;

      when EXIT_READ_PARENT_WAIT =>
        next_state <= EXIT_READ_PARENT_AVAILABLE;
		
      when EXIT_READ_PARENT_AVAILABLE =>
	    -- Make sure the parent thread is used and not exited
        if (DOA(26 to 27) = "11") then
          -- Parent thread is used and not exited.
		  -- Add the parent thread tothe scheduler's queue
		  tm2sch_opcode_next <= OPCODE_ENQUEUE;
		  tm2sch_request_next <= '1';
		  tm2sch_data_next <= current_status(16 to 23);
		  return_state_next <= EXIT_CHECK_ENQUEUE;
		  next_state <= ENQUEUE_WAIT_ACK;
        else
          -- Parent thread is either unused or exited, neither of which it should be
          -- operation failed, return error code
          bus_data_out_next <= DOA(0 to 27) & ERROR_IN_STATUS;
          next_state <= END_TRANSACTION;
        end if;
        
      when EXIT_CHECK_ENQUEUE =>
        -- Check to make sure the scheduler added the thread correctly
        if sch2tm_data(7) = '1' then
		  -- error during enqueue
		  bus_data_out_next <= Z32(0 to 27) & ERROR_FROM_SCHEDULER; 
          next_state <= END_TRANSACTION;
        else
		  -- enqueue completed correctly
		  bus_data_out_next <= Z32(0 to 31);
          next_state <= END_TRANSACTION;
        end if;

      when RAISE_EXCEPTION =>
        -- NOTE !!! You must assign Exception_Cause
        -- where-ever you assign next_state <= RAISE_EXCEPTION;
        Exception_Address_next <= Bus2IP_Addr(0 to 31);  -- save address
        access_error <= '1';                        -- assert interrupt
        my_ack   <= '1';      -- done, "ack" the bus

        next_state <= END_TRANSACTION_WAIT;
        
      when END_TRANSACTION =>
        IP2Bus_Data <= bus_data_out;
        my_ack  <= '1';      -- done, "ack" the bus
        next_state  <= END_TRANSACTION_WAIT;

      when END_TRANSACTION_WAIT =>
        if( Bus2IP_RdCE(0)='0' and Bus2IP_WrCE(0)='0' ) then
          next_state <= IDLE_STATE;
        else
          next_state <= current_state;
        end if;

      when others =>
        Exception_Cause_next <= EXCEPTION_ILLEGAL_STATE;
        next_state           <= RAISE_EXCEPTION;
    end case;       -- case current_state
  end process SWTM_LOGIC_PROC;

  -------------------------------------------------------------------
  --  ICON core instance
  -------------------------------------------------------------------
--  -- simulation translate_off
--  i_icon : chipscope_icon_v1_03_a
--    port map
--    (
--      control0    => control0
--      );
--  -- simulation translate_on  
--
--  COUNTER_PROC : process (Bus2IP_Clk) is
--  begin
--    if( Bus2IP_Clk'event and Bus2IP_Clk='1' ) then
--        if (Bus2IP_Reset = '1') then
--            my_counter <= (others => '0');
--        else
--            my_counter <= my_counter + 1;
--        end if;
--    end if;
--  end process COUNTER_PROC;
--
--  --  
--
--  -------------------------------------------------------------------
--  --  ILA core instance 
--  -------------------------------------------------------------------
--
--  -- simulation translate_off
--  i_ila : chipscope_ila_v1_02_a
--    port map
--    (
--      control   => control0,
--      clk       => Bus2IP_Clk,
--      trig0(63 downto 32)   => Bus2IP_Data,
--		trig0(31 downto 0)  => my_counter,       -- 64 bits           -- Add in chipscope signals and run on board!!!!
--      trig1(63 downto 32)   => Bus2IP_Addr,
--		trig1(31 downto 0) => bus_data_out,      -- 64 bits
--      trig2     => current_status,                  -- 32 bits
--      trig3     => Bus2IP_Addr,                     -- 32 bits
--      trig4(0)  => Bus2IP_RdCE,              -- 16 bits
--      trig4(1)  => Bus2IP_WrCE,
--      trig4(2)  => my_ack,
--      trig4(3)  => my_tout_sup,
--      trig4(4)  => Bus2IP_Reset,
--      trig4(5)  => '0',
--      trig4(6)  => tm2sch_request_reg,
--      trig4(7)  => next_ID(0),
--      trig4(8)  => next_ID(1),
--      trig4(9)  => next_ID(2),
--      trig4(10) => next_ID(3),
--      trig4(11) => next_ID(4),
--      trig4(12) => next_ID(5),
--      trig4(13) => next_ID(6),
--      trig4(14) => next_ID(7),
--      trig4(15) => next_ID(8)
--    );  
--  -- simulation translate_on
--

end IMP;
