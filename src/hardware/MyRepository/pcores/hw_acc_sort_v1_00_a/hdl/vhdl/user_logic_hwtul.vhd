-- ************************************
-- Automatically Generated FSM
-- mergesort
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
entity mergesort is
generic(
  G_ADDR_WIDTH : integer := 32;
  G_DATA_WIDTH : integer := 32
);
port
(
  array0_addr0 : out std_logic_vector(0 to (G_ADDR_WIDTH - 1));
  array0_dIN0 : out std_logic_vector(0 to (G_DATA_WIDTH - 1));
  array0_dOUT0 : in std_logic_vector(0 to (G_DATA_WIDTH - 1));
  array0_rENA0 : out std_logic;
  array0_wENA0 : out std_logic;
  array1_addr0 : out std_logic_vector(0 to (G_ADDR_WIDTH - 1));
  array1_dIN0 : out std_logic_vector(0 to (G_DATA_WIDTH - 1));
  array1_dOUT0 : in std_logic_vector(0 to (G_DATA_WIDTH - 1));
  array1_rENA0 : out std_logic;
  array1_wENA0 : out std_logic;

  chan1_channelDataIn : out std_logic_vector(0 to (32 - 1));
  chan1_channelDataOut : in std_logic_vector(0 to (32 - 1));
  chan1_exists : in std_logic;
  chan1_full : in std_logic;
  chan1_channelRead : out std_logic;
  chan1_channelWrite : out std_logic;


  clock_sig : in std_logic;
  reset_sig : in std_logic
  );
end entity mergesort;

-- *************************
-- Architecture Definition
-- *************************
architecture IMPLEMENTATION of mergesort is

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
idle,
decode,
dispatch,
begin_sort,
halt,
extra1,
for_loop,
extra2,
cond_check,
cond_body
);
signal current_state,next_state: STATE_MACHINE_TYPE :=reset;

-- ****************************************************
-- Type definitions for FSM signals
-- ****************************************************
signal swapped, swapped_next : std_logic;
signal n, n_next : std_logic_vector(0 to G_ADDR_WIDTH - 1);
signal n_new, n_new_next : std_logic_vector(0 to G_ADDR_WIDTH - 1);
signal i, i_next : std_logic_vector(0 to G_ADDR_WIDTH - 1);
signal data1, data1_next : std_logic_vector(0 to G_DATA_WIDTH - 1);
signal data2, data2_next : std_logic_vector(0 to G_DATA_WIDTH - 1);
signal arg1, arg1_next : std_logic_vector(0 to G_DATA_WIDTH - 1);
signal arg2, arg2_next : std_logic_vector(0 to G_DATA_WIDTH - 1);


-- ****************************************************
-- User-defined VHDL Section
-- ****************************************************

-- Architecture Section
begin

-- ************************
-- Permanent Connections
-- ************************


-- ************************
-- BRAM implementations
-- ************************

-- ****************************************************
-- Process to handle the synchronous portion of an FSM
-- ****************************************************
FSM_SYNC_PROCESS : process(
  swapped_next,
  n_next,
  n_new_next,
  i_next,
  data1_next,
  data2_next,
  arg1_next,
  arg2_next,

  next_state,
  clock_sig, reset_sig) is
begin
  if (clock_sig'event and clock_sig = '1') then
    if (reset_sig = '1') then
    -- Reset all FSM signals, and enter the initial state
      swapped <= '0';
      n <= (others => '0');
      n_new <= (others => '0');
      i <= (others => '0');
      data1 <= (others => '0');
      data2 <= (others => '0');
      arg1 <= (others => '0');
      arg2 <= (others => '0');

      current_state <= reset;
    else
    -- Transition to next state
      swapped <= swapped_next;
      n <= n_next;
      n_new <= n_new_next;
      i <= i_next;
      data1 <= data1_next;
      data2 <= data2_next;
      arg1 <= arg1_next;
      arg2 <= arg2_next;

      current_state <= next_state;
    end if;
  end if;
end process FSM_SYNC_PROCESS;

-- ************************************************************************
-- Process to handle the asynchronous (combinational) portion of an FSM
-- ************************************************************************
FSM_COMB_PROCESS : process(
  array0_dOUT0,
  array1_dOUT0,

  chan1_channelDataOut, chan1_full, chan1_exists,


  swapped,
  n,
  n_new,
  i,
  data1,
  data2,
  arg1,
  arg2,

  current_state) is
begin
  -- Default signal assignments
  swapped_next <= swapped;
  n_next <= n;
  n_new_next <= n_new;
  i_next <= i;
  data1_next <= data1;
  data2_next <= data2;
  arg1_next <= arg1;
  arg2_next <= arg2;

  array0_addr0 <= (others => '0');
  array0_dIN0  <= (others => '0');
  array0_rENA0 <= '0';
  array0_wENA0 <= '0';

  array1_addr0 <= (others => '0');
  array1_dIN0  <= (others => '0');
  array1_rENA0 <= '0';
  array1_wENA0 <= '0';


  chan1_channelDataIn <= (others => '0');
  chan1_channelRead <= '0';
  chan1_channelWrite <= '0';


  next_state <= current_state;

  -- FSM logic
  case (current_state) is

    when begin_sort =>
      if ( swapped = '0' ) then
        next_state <= halt;
      elsif ( swapped = '1' ) then
        array0_addr0 <= arg1;
        array0_rENA0 <= '1';
        next_state <= extra1;
      end if;
    when cond_body =>
      i_next <= i + 1;
      swapped_next <= '1';
      n_new_next <= i;
      array0_addr0 <= i + 1;
      array0_dIN0 <= data1;
      array0_wENA0 <= '1';
      array0_rENA0 <= '1';
      next_state <= for_loop;
    when cond_check =>
      if ( data1 <= data2 ) then
        i_next <= i + 1;
        data1_next <= data2;
        next_state <= for_loop;
      elsif ( data1 > data2 ) then
        array0_addr0 <= i;
        array0_dIN0 <= data2;
        array0_wENA0 <= '1';
        array0_rENA0 <= '1';
        next_state <= cond_body;
      end if;
    when decode =>
      arg2_next <= "00000000000000000" & n(2 to 16);
      arg1_next <= "00000000000000000" & n(17 to 31);
      next_state <= dispatch;
    when dispatch =>
      swapped_next <= '1';
      n_next <= arg2;
      n_new_next <= arg2;
      next_state <= begin_sort;
    when extra1 =>
      data1_next <= array0_dOUT0;
      i_next <= arg1;
      swapped_next <= '0';
      next_state <= for_loop;
    when extra2 =>
      data2_next <= array0_dOUT0;
      next_state <= cond_check;
    when for_loop =>
      if ( i >= n ) then
        n_next <= n_new;
        next_state <= begin_sort;
      elsif ( i < n ) then
        array0_addr0 <= i + 1;
        array0_rENA0 <= '1';
        next_state <= extra2;
      end if;
    when halt =>
      if chan1_full /= '0' then
        next_state <= halt;
      elsif chan1_full = '0' then
        chan1_channelDataIn <= (others => '0');
        chan1_channelWrite <= '1';
        next_state <= idle;
      end if;
    when idle =>
      if chan1_exists = '0' then
        next_state <= idle;
      elsif chan1_exists /= '0' then
        n_next <= chan1_channelDataOut;
        chan1_channelRead <= '1';
        next_state <= decode;
      end if;
    when reset =>
      next_state <= idle;
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

