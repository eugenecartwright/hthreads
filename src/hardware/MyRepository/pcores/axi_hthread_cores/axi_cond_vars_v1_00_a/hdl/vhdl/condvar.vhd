-- ************************************
-- Automatically Generated FSM
-- condvar
-- ************************************

-- **********************
-- Library inclusions
-- **********************
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- **********************
-- Entity Definition
-- **********************
entity condvar is
generic(
  G_ADDR_WIDTH : integer := 11;
  G_OP_WIDTH : integer := 2;
  G_TID_WIDTH : integer := 8
);
port
(

  msg_chan_channelDataIn : out std_logic_vector(0 to (G_TID_WIDTH - 1));
  msg_chan_channelDataOut : in std_logic_vector(0 to (G_TID_WIDTH - 1));
  msg_chan_exists : in std_logic;
  msg_chan_full : in std_logic;
  msg_chan_channelRead : out std_logic;
  msg_chan_channelWrite : out std_logic;

  cmd : in std_logic;
  opcode : in std_logic_vector(0 to G_OP_WIDTH - 1);
  cvar : in std_logic_vector(0 to G_TID_WIDTH - 1);
  tid : in std_logic_vector(0 to G_TID_WIDTH - 1);
  ack : out std_logic;

  clock_sig : in std_logic;
  reset_sig : in std_logic
  );
end entity condvar;

-- *************************
-- Architecture Definition
-- *************************
architecture IMPLEMENTATION of condvar is

component infer_bram
generic
(
  ADDRESS_BITS    : integer   := 9;
  DATA_BITS       : integer   := 32
);
port (
  CLKA        : in std_logic;
  ENA         : in std_logic;
  WEA         : in std_logic;
  ADDRA       : in std_logic_vector(0 to (ADDRESS_BITS - 1));
  DIA         : in std_logic_vector(0 to (DATA_BITS - 1));
  DOA         : out  std_logic_vector(0 to (DATA_BITS - 1));
  CLKB        : in std_logic;
  ENB         : in std_logic;
  WEB         : in std_logic;
  ADDRB       : in std_logic_vector(0 to (ADDRESS_BITS - 1));
  DIB         : in std_logic_vector(0 to (DATA_BITS - 1));
  DOB         : out  std_logic_vector(0 to (DATA_BITS - 1))
  );
end component infer_BRAM;

-- ****************************************************
-- Type definitions for state signals
-- ****************************************************
type STATE_MACHINE_TYPE is
(
reset,
init_bram,
idle,
enq_begin,
deq_begin,
deqall_begin,
extra1,
extra2,
enq_adjust_queue,
enq_add_to_empty_queue,
enq_add_to_nonempty_queue,
transaction_complete,
extra3,
extra4,
enq_add_link,
extra5,
extra6,
deq_examine_length,
extra7,
extra8,
deq_remove_only,
extra9,
extra10,
deq_remove_general,
extra11,
extra12,
deq_send_owner,
extra13,
extra14,
deqall_examine_length,
extra15,
extra16,
extra17,
extra18,
deqall_remove_loop,
extra19,
extra20,
deqall_done,
return_to_idle
);
signal current_state,next_state: STATE_MACHINE_TYPE :=reset;

-- ****************************************************
-- Type definitions for FSM signals
-- ****************************************************
signal addr_counter, addr_counter_next : std_logic_vector(0 to G_ADDR_WIDTH - 1);
signal arg_cvar, arg_cvar_next : std_logic_vector(0 to G_TID_WIDTH - 1);
signal arg_tid, arg_tid_next : std_logic_vector(0 to G_TID_WIDTH - 1);
signal entry, entry_next : std_logic_vector(0 to G_TID_WIDTH - 1);
signal done, done_next : std_logic;

-- **************************
-- BRAM Signals for table
-- **************************
signal table_addr0 : std_logic_vector(0 to (G_ADDR_WIDTH - 1));
signal table_dIN0 : std_logic_vector(0 to (G_TID_WIDTH - 1));
signal table_dOUT0 : std_logic_vector(0 to (G_TID_WIDTH - 1));
signal table_rENA0 : std_logic;
signal table_wENA0 : std_logic;
signal table_addr1 : std_logic_vector(0 to (G_ADDR_WIDTH - 1));
signal table_dIN1 : std_logic_vector(0 to (G_TID_WIDTH - 1));
signal table_dOUT1 : std_logic_vector(0 to (G_TID_WIDTH - 1));
signal table_rENA1 : std_logic;
signal table_wENA1 : std_logic;


-- ****************************************************
-- User-defined VHDL Section
-- ****************************************************
constant OPCODE_ENQUEUE : std_logic_vector(0 to G_OP_WIDTH-1) := conv_std_logic_vector(2, G_OP_WIDTH);  -- Opcode for "wait" enqueue
constant OPCODE_DEQUEUE : std_logic_vector(0 to G_OP_WIDTH-1) := conv_std_logic_vector(1, G_OP_WIDTH);  -- Opcode for "signal" dequeue
constant OPCODE_DEQUEUE_ALL : std_logic_vector(0 to G_OP_WIDTH-1) := conv_std_logic_vector(3, G_OP_WIDTH);  -- Opcode for "broadcast" dequeue

-- Helper Functions

pure function lengthEntry(cvar : std_logic_vector(0 to G_TID_WIDTH-1)) return std_logic_vector is
    variable header : std_logic_vector(0 to G_ADDR_WIDTH - G_TID_WIDTH - 1);
begin
  header := conv_std_logic_vector(0,G_ADDR_WIDTH - G_TID_WIDTH);
  return header & cvar;
end function lengthEntry;

pure function linkEntry(tid : std_logic_vector(0 to G_TID_WIDTH-1)) return std_logic_vector is
    variable header : std_logic_vector(0 to G_ADDR_WIDTH - G_TID_WIDTH - 1);
begin
  header := conv_std_logic_vector(1,G_ADDR_WIDTH - G_TID_WIDTH);
  return header & tid;
end function linkEntry;

pure function lastReqEntry(cvar : std_logic_vector(0 to G_TID_WIDTH-1)) return std_logic_vector is
    variable header : std_logic_vector(0 to G_ADDR_WIDTH - G_TID_WIDTH - 1);
begin
  header := conv_std_logic_vector(2,G_ADDR_WIDTH - G_TID_WIDTH);
  return header & cvar;
end function lastReqEntry;

pure function ownerEntry(cvar : std_logic_vector(0 to G_TID_WIDTH-1)) return std_logic_vector is
    variable header : std_logic_vector(0 to G_ADDR_WIDTH - G_TID_WIDTH - 1);
begin
  header := conv_std_logic_vector(3,G_ADDR_WIDTH - G_TID_WIDTH);
  return header & cvar;
end function ownerEntry;

pure function getLength(entry : std_logic_vector(0 to G_TID_WIDTH-1)) return std_logic_vector is
begin
  return entry;
end function getLength;


-- Architecture Section
begin

-- ************************
-- Permanent Connections
-- ************************
ack <= done; 


-- ************************
-- BRAM implementations
-- ************************
table_BRAM : infer_bram
generic map (
  ADDRESS_BITS => G_ADDR_WIDTH,
  DATA_BITS => G_TID_WIDTH
)
port map (
  CLKA  => clock_sig,
  ENA   => table_rENA0,
  WEA   => table_wENA0,
  ADDRA => table_addr0,
  DIA   => table_dIN0,
  DOA   => table_dOUT0,
  CLKB  => clock_sig,
  ENB   => table_rENA1,
  WEB   => table_wENA1,
  ADDRB => table_addr1,
  DIB   => table_dIN1,
  DOB   => table_dOUT1
);


-- ****************************************************
-- Process to handle the synchronous portion of an FSM
-- ****************************************************
FSM_SYNC_PROCESS : process(
  addr_counter_next,
  arg_cvar_next,
  arg_tid_next,
  entry_next,
  done_next,

  next_state,
  clock_sig, reset_sig) is
begin
  if (clock_sig'event and clock_sig = '1') then
    if (reset_sig = '1') then
    -- Reset all FSM signals, and enter the initial state
      addr_counter <= (others => '0');
      arg_cvar <= (others => '0');
      arg_tid <= (others => '0');
      entry <= (others => '0');
      done <= '0';

      current_state <= reset;
    else
    -- Transition to next state
      addr_counter <= addr_counter_next;
      arg_cvar <= arg_cvar_next;
      arg_tid <= arg_tid_next;
      entry <= entry_next;
      done <= done_next;

      current_state <= next_state;
    end if;
  end if;
end process FSM_SYNC_PROCESS;

-- ************************************************************************
-- Process to handle the asynchronous (combinational) portion of an FSM
-- ************************************************************************
FSM_COMB_PROCESS : process(
  table_dOUT0, table_dOUT1,

  msg_chan_channelDataOut, msg_chan_full, msg_chan_exists,

  cmd,
  opcode,
  cvar,
  tid,

  addr_counter,
  arg_cvar,
  arg_tid,
  entry,
  done,

  current_state) is
begin
  -- Default signal assignments
  addr_counter_next <= addr_counter;
  arg_cvar_next <= arg_cvar;
  arg_tid_next <= arg_tid;
  entry_next <= entry;
  done_next <= done;

  table_addr0 <= (others => '0');
  table_dIN0  <= (others => '0');
  table_rENA0 <= '0';
  table_wENA0 <= '0';
  table_addr1 <= (others => '0');
  table_dIN1  <= (others => '0');
  table_rENA1 <= '0';
  table_wENA1 <= '0';


  msg_chan_channelDataIn <= (others => '0');
  msg_chan_channelRead <= '0';
  msg_chan_channelWrite <= '0';


  next_state <= current_state;

  -- FSM logic
  case (current_state) is

    when deq_begin =>
      table_addr0 <= lengthEntry(arg_cvar);
      table_rENA0 <= '1';
      next_state <= extra5;
    when deq_examine_length =>
      if ( getLength(entry) = 0 ) then
        done_next <= '1';
        next_state <= transaction_complete;
      elsif ( getLength(entry) = 1 ) then
        table_addr1 <= ownerEntry(arg_cvar);
        table_rENA1 <= '1';
        next_state <= extra7;
      else
        table_addr1 <= ownerEntry(arg_cvar);
        table_rENA1 <= '1';
        next_state <= extra9;
      end if;
    when deq_remove_general =>
      table_addr1 <= linkEntry(entry);
      table_rENA1 <= '1';
      next_state <= extra11;
    when deq_remove_only =>
      if msg_chan_full /= '0' then
        next_state <= deq_remove_only;
      elsif msg_chan_full = '0' then
        done_next <= '1';
        msg_chan_channelDataIn <= entry;
        msg_chan_channelWrite <= '1';
        next_state <= transaction_complete;
      end if;
    when deq_send_owner =>
      if msg_chan_full /= '0' then
        next_state <= deq_send_owner;
      elsif msg_chan_full = '0' then
        done_next <= '1';
        msg_chan_channelDataIn <= entry;
        msg_chan_channelWrite <= '1';
        next_state <= transaction_complete;
      end if;
    when deqall_begin =>
      table_addr0 <= lengthEntry(arg_cvar);
      table_rENA0 <= '1';
      next_state <= extra13;
    when deqall_done =>
      done_next <= '1';
      next_state <= transaction_complete;
    when deqall_examine_length =>
      if ( getLength(entry) = 0 ) then
        done_next <= '1';
        next_state <= transaction_complete;
      elsif ( getLength(entry) = 1 ) then
        table_addr1 <= ownerEntry(arg_cvar);
        table_rENA1 <= '1';
        next_state <= extra15;
      else
        table_addr1 <= ownerEntry(arg_cvar);
        table_rENA1 <= '1';
        next_state <= extra17;
      end if;
    when deqall_remove_loop =>
      if ( arg_tid > 0 ) then
        table_addr0 <= linkEntry(entry);
        table_rENA0 <= '1';
        next_state <= extra19;
      else
        next_state <= deqall_done;
      end if;
    when enq_add_link =>
      done_next <= '1';
      table_addr0 <= lastReqEntry(arg_cvar);
      table_dIN0 <= arg_tid;
      table_wENA0 <= '1';
      table_rENA0 <= '1';
      table_addr1 <= linkEntry(entry);
      table_dIN1 <= arg_tid;
      table_wENA1 <= '1';
      table_rENA1 <= '1';
      next_state <= transaction_complete;
    when enq_add_to_empty_queue =>
      done_next <= '1';
      table_addr0 <= ownerEntry(arg_cvar);
      table_dIN0 <= arg_tid;
      table_wENA0 <= '1';
      table_rENA0 <= '1';
      table_addr1 <= lastReqEntry(arg_cvar);
      table_dIN1 <= arg_tid;
      table_wENA1 <= '1';
      table_rENA1 <= '1';
      next_state <= transaction_complete;
    when enq_add_to_nonempty_queue =>
      table_addr0 <= lastReqEntry(arg_cvar);
      table_rENA0 <= '1';
      next_state <= extra3;
    when enq_adjust_queue =>
      if ( getLength(entry) = 1 ) then
        table_addr0 <= lengthEntry(arg_cvar);
        table_dIN0 <= entry;
        table_wENA0 <= '1';
        table_rENA0 <= '1';
        next_state <= enq_add_to_empty_queue;
      else
        table_addr0 <= lengthEntry(arg_cvar);
        table_dIN0 <= entry;
        table_wENA0 <= '1';
        table_rENA0 <= '1';
        next_state <= enq_add_to_nonempty_queue;
      end if;
    when enq_begin =>
      table_addr0 <= lengthEntry(arg_cvar);
      table_rENA0 <= '1';
      next_state <= extra1;
    when extra1 =>
      next_state <= extra2;
    when extra10 =>
      entry_next <= table_dOUT1;
      table_addr0 <= lengthEntry(arg_cvar);
      table_dIN0 <= entry - 1;
      table_wENA0 <= '1';
      table_rENA0 <= '1';
      next_state <= deq_remove_general;
    when extra11 =>
      next_state <= extra12;
    when extra12 =>
      table_addr0 <= ownerEntry(arg_cvar);
      table_dIN0 <= table_dOUT1;
      table_wENA0 <= '1';
      table_rENA0 <= '1';
      next_state <= deq_send_owner;
    when extra13 =>
      next_state <= extra14;
    when extra14 =>
      entry_next <= table_dOUT0;
      next_state <= deqall_examine_length;
    when extra15 =>
      next_state <= extra16;
    when extra16 =>
      entry_next <= table_dOUT1;
      table_addr0 <= lengthEntry(arg_cvar);
      table_dIN0 <= (others => '0');
      table_wENA0 <= '1';
      table_rENA0 <= '1';
      next_state <= deq_remove_only;
    when extra17 =>
      next_state <= extra18;
    when extra18 =>
      entry_next <= table_dOUT1;
      arg_tid_next <= getLength(entry);
      table_addr0 <= lengthEntry(arg_cvar);
      table_dIN0 <= (others => '0');
      table_wENA0 <= '1';
      table_rENA0 <= '1';
      next_state <= deqall_remove_loop;
    when extra19 =>
      next_state <= extra20;
    when extra2 =>
      entry_next <= table_dOUT0 + 1;
      next_state <= enq_adjust_queue;
    when extra20 =>
      if msg_chan_full /= '0' then
        next_state <= extra20;
      elsif msg_chan_full = '0' then
        entry_next <= table_dOUT0;
        arg_tid_next <= arg_tid - 1;
        msg_chan_channelDataIn <= entry;
        msg_chan_channelWrite <= '1';
        next_state <= deqall_remove_loop;
      end if;
    when extra3 =>
      next_state <= extra4;
    when extra4 =>
      entry_next <= table_dOUT0;
      next_state <= enq_add_link;
    when extra5 =>
      next_state <= extra6;
    when extra6 =>
      entry_next <= table_dOUT0;
      next_state <= deq_examine_length;
    when extra7 =>
      next_state <= extra8;
    when extra8 =>
      entry_next <= table_dOUT1;
      table_addr0 <= lengthEntry(arg_cvar);
      table_dIN0 <= (others => '0');
      table_wENA0 <= '1';
      table_rENA0 <= '1';
      next_state <= deq_remove_only;
    when extra9 =>
      next_state <= extra10;
    when idle =>
      if ( cmd = '1' and opcode = OPCODE_ENQUEUE ) then
        arg_cvar_next <= cvar;
        arg_tid_next <= tid;
        next_state <= enq_begin;
      elsif ( cmd = '1' and opcode = OPCODE_DEQUEUE ) then
        arg_cvar_next <= cvar;
        next_state <= deq_begin;
      elsif ( cmd = '1' and opcode = OPCODE_DEQUEUE_ALL ) then
        arg_cvar_next <= cvar;
        next_state <= deqall_begin;
      else
        done_next <= '0';
        next_state <= idle;
      end if;
    when init_bram =>
      if ( addr_counter > 0 ) then
        addr_counter_next <= addr_counter - 1;
        table_addr0 <= addr_counter;
        table_dIN0 <= (others => '0');
        table_wENA0 <= '1';
        table_rENA0 <= '1';
        next_state <= init_bram;
      else
        done_next <= '1';
        next_state <= idle;
      end if;
    when reset =>
      table_addr0 <= (others => '0');
      table_dIN0 <= (others => '0');
      table_wENA0 <= '1';
      table_rENA0 <= '1';
      addr_counter_next <= (others => '1');
      next_state <= init_bram;
    when return_to_idle =>
      if ( cmd = '0' ) then
        next_state <= idle;
      else
        next_state <= return_to_idle;
      end if;
    when transaction_complete =>
      done_next <= '0';
      next_state <= return_to_idle;
    when others => 
      next_state <= reset;

  end case;
end process FSM_COMB_PROCESS;

end architecture IMPLEMENTATION;

-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

-- ************************************************
-- Entity used for implementing the inferred BRAMs
-- ************************************************

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_misc.all;
use IEEE.std_logic_misc.all;
use IEEE.numeric_std.all;

-- *************************************************************************
-- Entity declaration
-- *************************************************************************
entity infer_bram is
generic (
  ADDRESS_BITS : integer := 9;
  DATA_BITS : integer := 32
  );
  port (
    CLKA    : in std_logic;
    ENA     : in std_logic;
    WEA     : in std_logic;
    ADDRA   : in std_logic_vector(0 to (ADDRESS_BITS - 1)); 
    DIA     : in std_logic_vector(0 to (DATA_BITS - 1));
    DOA     : out  std_logic_vector(0 to (DATA_BITS - 1));

    CLKB    : in std_logic;
    ENB     : in std_logic;
    WEB     : in std_logic;
    ADDRB   : in std_logic_vector(0 to (ADDRESS_BITS - 1)); 
    DIB     : in std_logic_vector(0 to (DATA_BITS - 1));
    DOB     : out  std_logic_vector(0 to (DATA_BITS - 1))
    );
end entity infer_bram;


-- *************************************************************************
-- Architecture declaration
-- *************************************************************************
architecture implementation of infer_bram is

  -- Constant declarations
  constant BRAM_SIZE  : integer := 2 **ADDRESS_BITS;    -- # of entries in the inferred BRAM 

  -- BRAM data storage (array)
  type bram_storage is array( 0 to BRAM_SIZE - 1 ) of std_logic_vector( 0 to DATA_BITS - 1 );
  shared variable BRAM_DATA : bram_storage;
--  attribute ram_style : string;
--  attribute ram_style of BRAM_DATA : signal is "block";

begin

  -- *************************************************************************
  -- Process: BRAM_CONTROLLER_A
  -- Purpose: Controller for Port A of inferred dual-port BRAM, BRAM_DATA
  -- *************************************************************************
  BRAM_CONTROLLER_A : process(CLKA) is
  begin
    if( CLKA'event and CLKA = '1' ) then
      if( ENA = '1' ) then
        if( WEA = '1' ) then
          BRAM_DATA( conv_integer(ADDRA) )  := DIA;
        end if;

        DOA <= BRAM_DATA( conv_integer(ADDRA) );
      end if;
    end if; 
  end process BRAM_CONTROLLER_A;

    -- *************************************************************************
    -- Process: BRAM_CONTROLLER_B
    -- Purpose: Controller for Port B of inferred dual-port BRAM, BRAM_DATA
    -- *************************************************************************
    BRAM_CONTROLLER_B : process(CLKB) is
    begin
        if( CLKB'event and CLKB = '1' ) then
            if( ENB = '1' ) then
                if( WEB = '1' ) then
                    BRAM_DATA( conv_integer(ADDRB) )  := DIB;
                end if;

                DOB <= BRAM_DATA( conv_integer(ADDRB) );
            end if;
        end if;
    end process BRAM_CONTROLLER_B;

end architecture implementation;

