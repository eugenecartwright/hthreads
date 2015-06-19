-- ************************************
-- Automatically Generated FSM
-- INTC
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
entity INTC is
generic(
  C_NUM_INTERRUPTS : integer := 8;
  NEW_IID_WIDTH : integer := 3
);
port
(


  interrupts_in : in std_logic_vector(0 to C_NUM_INTERRUPTS - 1);
  ier_in : in std_logic_vector(0 to C_NUM_INTERRUPTS - 1);
  iar_in : in std_logic_vector(0 to C_NUM_INTERRUPTS - 1);
  interrupts_out : out std_logic_vector(0 to C_NUM_INTERRUPTS - 1);

  clock_sig : in std_logic;
  reset_sig : in std_logic
  );
end entity INTC;

-- *************************
-- Architecture Definition
-- *************************
architecture IMPLEMENTATION of INTC is

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
check_interrupts
);
signal current_state,next_state: STATE_MACHINE_TYPE :=reset;

-- ****************************************************
-- Type definitions for FSM signals
-- ****************************************************
signal pending, pending_next : std_logic_vector(0 to C_NUM_INTERRUPTS - 1);
signal interrupts_d, interrupts_d_next : std_logic_vector(0 to C_NUM_INTERRUPTS - 1);
signal local_int, local_int_next : std_logic_vector(0 to C_NUM_INTERRUPTS - 1);
signal accum_int, accum_int_next : std_logic_vector(0 to C_NUM_INTERRUPTS - 1);


-- ****************************************************
-- User-defined VHDL Section
-- ****************************************************

-- Architecture Section
begin

-- ************************
-- Permanent Connections
-- ************************
interrupts_out <= pending; 


-- ************************
-- BRAM implementations
-- ************************

-- ****************************************************
-- Process to handle the synchronous portion of an FSM
-- ****************************************************
FSM_SYNC_PROCESS : process(
  pending_next,
  interrupts_d_next,
  local_int_next,
  accum_int_next,

  next_state,
  clock_sig, reset_sig) is
begin
  if (clock_sig'event and clock_sig = '1') then
    if (reset_sig = '1') then
    -- Reset all FSM signals, and enter the initial state
      pending <= (others => '0');
      interrupts_d <= (others => '0');
      local_int <= (others => '0');
      accum_int <= (others => '0');

      current_state <= reset;
    else
    -- Transition to next state
      pending <= pending_next;
      interrupts_d <= interrupts_d_next;
      local_int <= local_int_next;
      accum_int <= accum_int_next;

      current_state <= next_state;
    end if;
  end if;
end process FSM_SYNC_PROCESS;

-- ************************************************************************
-- Process to handle the asynchronous (combinational) portion of an FSM
-- ************************************************************************
FSM_COMB_PROCESS : process(


  interrupts_in,
  ier_in,
  iar_in,

  pending,
  interrupts_d,
  local_int,
  accum_int,

  current_state) is
begin
  -- Default signal assignments
  pending_next <= pending;
  interrupts_d_next <= interrupts_d;
  local_int_next <= local_int;
  accum_int_next <= accum_int;



  next_state <= current_state;

  -- FSM logic
  case (current_state) is

    when check_interrupts =>
      pending_next <= ( accum_int and ier_in );
      accum_int_next <= ( accum_int or local_int ) and ( not iar_in );
      local_int_next <= interrupts_in and ( not interrupts_d );
      interrupts_d_next <= interrupts_in;
      next_state <= check_interrupts;
    when reset =>
      accum_int_next <= (others => '0');
      local_int_next <= (others => '0');
      interrupts_d_next <= (others => '0');
      pending_next <= (others => '0');
      next_state <= check_interrupts;
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

