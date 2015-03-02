-- ************************************
-- Automatically Generated FSM
-- sort_chan
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
entity sort_chan is
generic(
  G_ADDR_WIDTH : integer := 32;
  G_DATA_WIDTH : integer := 32
);
port
(
  array_addr0 : out std_logic_vector(0 to (G_ADDR_WIDTH - 1));
  array_dIN0 : out std_logic_vector(0 to (G_DATA_WIDTH - 1));
  array_dOUT0 : in std_logic_vector(0 to (G_DATA_WIDTH - 1));
  array_rENA0 : out std_logic;
  array_wENA0 : out std_logic_vector(0 to (G_DATA_WIDTH/8) -1);

  chan1_channelDataIn : out std_logic_vector(0 to (32 - 1));
  chan1_channelDataOut : in std_logic_vector(0 to (32 - 1));
  chan1_exists : in std_logic;
  chan1_full : in std_logic;
  chan1_channelRead : out std_logic;
  chan1_channelWrite : out std_logic;


  clock_sig : in std_logic;
  reset_sig : in std_logic
  );
end entity sort_chan;

-- *************************
-- Architecture Definition
-- *************************
architecture IMPLEMENTATION of sort_chan is

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
before_begin,
begin_sort,
halt,
extra1,
extra2,
for_loop,
extra3,
extra4,
cond_check,
cond_body
);
signal current_state,next_state: STATE_MACHINE_TYPE :=reset;

-- ****************************************************
-- Type definitions for FSM signals
-- ****************************************************
signal swapped, swapped_next : std_logic;
signal i, i_next : std_logic_vector(0 to G_ADDR_WIDTH - 1);
signal n, n_next : std_logic_vector(0 to G_ADDR_WIDTH - 1);
signal n_new, n_new_next : std_logic_vector(0 to G_ADDR_WIDTH - 1);
signal data1, data1_next : std_logic_vector(0 to G_DATA_WIDTH - 1);
signal data2, data2_next : std_logic_vector(0 to G_DATA_WIDTH - 1);
signal in_array_addr0 :  std_logic_vector(0 to (G_ADDR_WIDTH - 1));

-- ****************************************************
-- User-defined VHDL Section
-- ****************************************************


-- Architecture Section
begin

-- ************************
-- Permanent Connections
-- ************************
array_addr0 <= in_array_addr0(2 to 31) & "00"; --The external memory is organized in this way.

-- ************************
-- BRAM implementations
-- ************************

-- ****************************************************
-- Process to handle the synchronous portion of an FSM
-- ****************************************************
FSM_SYNC_PROCESS : process(
  swapped_next,
  i_next,
  n_next,
  n_new_next,
  data1_next,
  data2_next,

  next_state,
  clock_sig, reset_sig) is
begin
  if (clock_sig'event and clock_sig = '1') then
    if (reset_sig = '1') then
    -- Reset all FSM signals, and enter the initial state
      swapped <= '0';
      i <= (others => '0');
      n <= (others => '0');
      n_new <= (others => '0');
      data1 <= (others => '0');
      data2 <= (others => '0');

      current_state <= reset;
    else
    -- Transition to next state
      swapped <= swapped_next;
      i <= i_next;
      n <= n_next;
      n_new <= n_new_next;
      data1 <= data1_next;
      data2 <= data2_next;

      current_state <= next_state;
    end if;
  end if;
end process FSM_SYNC_PROCESS;

-- ************************************************************************
-- Process to handle the asynchronous (combinational) portion of an FSM
-- ************************************************************************
FSM_COMB_PROCESS : process(
  array_dOUT0,

  chan1_channelDataOut, chan1_full, chan1_exists,


  swapped,
  i,
  n,
  n_new,
  data1,
  data2,

  current_state) is
begin
  -- Default signal assignments
  swapped_next <= swapped;
  i_next <= i;
  n_next <= n;
  n_new_next <= n_new;
  data1_next <= data1;
  data2_next <= data2;

  in_array_addr0 <= (others => '0');
  array_dIN0  <= (others => '0');
  array_rENA0 <= '0';
  array_wENA0 <= (others => '0');


  chan1_channelDataIn <= (others => '0');
  chan1_channelRead <= '0';
  chan1_channelWrite <= '0';


  next_state <= current_state;

  -- FSM logic
  case (current_state) is

    when before_begin =>
      n_new_next <= n;
      next_state <= begin_sort;
    when begin_sort =>
      if ( swapped = '0' ) then
        next_state <= halt;
      elsif ( swapped = '1' ) then
        in_array_addr0 <= (others => '0');
        array_rENA0 <= '1';
        next_state <= extra2;
      end if;
    when cond_body =>
      i_next <= i + 1;
      swapped_next <= '1';
      n_new_next <= i;
      in_array_addr0 <= i + 1;
      array_dIN0 <= data1;
      array_wENA0 <= (others => '1');
      array_rENA0 <= '1';
      next_state <= for_loop;
    when cond_check =>
      if ( data1 <= data2 ) then
        i_next <= i + 1;
        data1_next <= data2;
        next_state <= for_loop;
      elsif ( data1 > data2 ) then
        in_array_addr0 <= i;
        array_dIN0 <= data2;
        array_wENA0 <= (others => '1');
        array_rENA0 <= '1';
        next_state <= cond_body;
      end if;
    --when extra1 =>
      --next_state <= extra2;
    when extra2 =>
      data1_next <= array_dOUT0;
      i_next <= (others => '0');
      swapped_next <= '0';
      next_state <= for_loop;
    --when extra3 =>
      --next_state <= extra4;
    when extra4 =>
      data2_next <= array_dOUT0;
      next_state <= cond_check;
    when for_loop =>
      if ( i >= n ) then
        n_next <= n_new;
        next_state <= begin_sort;
      elsif ( i < n ) then
        in_array_addr0 <= i + 1;
        array_rENA0 <= '1';
        next_state <= extra4;
      end if;
    when halt =>
      if chan1_full /= '0' then
        next_state <= halt;
      elsif chan1_full = '0' then
        chan1_channelDataIn <= (others => '1');
        chan1_channelWrite <= '1';
        next_state <= idle;
      end if;
    when idle =>
      if chan1_exists = '0' then
        next_state <= idle;
      elsif chan1_exists /= '0' then
        swapped_next <= '1';
        n_next <= chan1_channelDataOut;
        chan1_channelRead <= '1';
        next_state <= before_begin;
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
  ADDRESS_BITS : integer := 32;
  DATA_BITS : integer := 32
  );
  port (
    CLKA    : in std_logic;
    ENA     : in std_logic;
    WEA     : in std_logic_vector(0 to 3);
    ADDRA   : in std_logic_vector(0 to (ADDRESS_BITS - 1)); 
    DIA     : in std_logic_vector(0 to (DATA_BITS - 1));
    DOA     : out  std_logic_vector(0 to (DATA_BITS - 1));

    CLKB    : in std_logic;
    ENB     : in std_logic;
    WEB     : in std_logic_vector(0 to 3);
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
  constant BRAM_SIZE  : integer := 8;    -- # of entries in the inferred BRAM 

  -- BRAM data storage (array)
  type bram_storage is array( 0 to BRAM_SIZE - 1 ) of std_logic_vector( 0 to DATA_BITS - 1 );
  SIGNAL BRAM_DATA : bram_storage:= ( X"00000002",X"00000008",X"00000003",X"00000005", others => (others =>'0'));
  --  attribute ram_style : string;
--  attribute ram_style of BRAM_DATA : signal is "block";

begin

  -- *************************************************************************
  -- Process: BRAM_CONTROLLER_A
  -- Purpose: Controller for Port A of inferred dual-port BRAM, BRAM_DATA
  -- *************************************************************************

    -- *************************************************************************
    -- Process: BRAM_CONTROLLER_B
    -- Purpose: Controller for Port B of inferred dual-port BRAM, BRAM_DATA
    -- *************************************************************************
    BRAM_CONTROLLER_B : process(CLKB) is
    begin
        if( CLKB'event and CLKB = '1' ) then
            if( ENB = '1' ) then
                if( WEB = "1111" ) then
                    BRAM_DATA( conv_integer(ADDRB) )  <=  DIB;
                end if;

                DOB <= BRAM_DATA( conv_integer(ADDRB) );
            end if;
        end if;
    end process BRAM_CONTROLLER_B;

end architecture implementation;

