-- ************************************
-- Automatically Generated FSM
-- crc
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
entity crc is
generic(
  G_INPUT_WIDTH : integer := 32;
  G_ADDR_WIDTH : integer := 32;
  G_DIVISOR_WIDTH : integer := 4;
  divisor : std_logic_vector(0 to 3) := "1011"
);
port
(
  array_addr0 : out std_logic_vector(0 to (G_ADDR_WIDTH - 1));
  array_dIN0 : out std_logic_vector(0 to (G_INPUT_WIDTH - 1));
  array_dOUT0 : in std_logic_vector(0 to (G_INPUT_WIDTH - 1));
  array_rENA0 : out std_logic;
  array_wENA0 : out std_logic_vector(0 to (G_INPUT_WIDTH/8) -1);


  chan1_channelDataIn : out std_logic_vector(0 to (G_INPUT_WIDTH - 1));
  chan1_channelDataOut : in std_logic_vector(0 to (G_INPUT_WIDTH - 1));
  chan1_exists : in std_logic;
  chan1_full : in std_logic;
  chan1_channelRead : out std_logic;
  chan1_channelWrite : out std_logic;


  clock_sig : in std_logic;
  reset_sig : in std_logic
  );
end entity crc;

-- *************************
-- Architecture Definition
-- *************************
architecture IMPLEMENTATION of crc is

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
read_data,
extra1,
do_crc
);
signal current_state,next_state: STATE_MACHINE_TYPE :=reset;

-- ****************************************************
-- Type definitions for FSM signals
-- ****************************************************
signal i, i_next : std_logic_vector(0 to 7);
signal j, j_next : std_logic_vector(0 to 31);
signal result, result_next : std_logic_vector(0 to G_INPUT_WIDTH - 1);
signal size, size_next : std_logic_vector(0 to G_INPUT_WIDTH - 1);
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
-- Permanent Connections
-- ************************


-- ************************
-- BRAM implementations
-- ************************

-- ****************************************************
-- Process to handle the synchronous portion of an FSM
-- ****************************************************
FSM_SYNC_PROCESS : process(
  i_next,
  j_next,
  result_next,
  size_next,

  next_state,
  clock_sig, reset_sig) is
begin
  if (clock_sig'event and clock_sig = '1') then
    if (reset_sig = '1') then
    -- Reset all FSM signals, and enter the initial state
      i <= (others => '0');
      j <= (others => '0');
      result <= (others => '0');
      size <= (others => '0');

      current_state <= reset;
    else
    -- Transition to next state
      i <= i_next;
      j <= j_next;
      result <= result_next;
      size <= size_next;

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


  i,
  j,
  result,
  size,

  current_state) is
begin
  -- Default signal assignments
  i_next <= i;
  j_next <= j;
  result_next <= result;
  size_next <= size;

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

    when do_crc =>
      if ( i < G_INPUT_WIDTH - G_DIVISOR_WIDTH + 1 ) and ( result(conv_integer(i)) = '0' ) then
        i_next <= i + 1;
        next_state <= do_crc;
      elsif ( i < G_INPUT_WIDTH - G_DIVISOR_WIDTH + 1 ) then
        result_next(conv_integer(i) to conv_integer(i) + ( G_DIVISOR_WIDTH - 1 )) <= result(conv_integer(i) to conv_integer(i) + ( G_DIVISOR_WIDTH - 1 )) xor divisor;
        i_next <= i + 1;
        next_state <= do_crc;
      else
        in_array_addr0 <= j;
        array_dIN0 <= result;
        array_wENA0 <= (others => '1');
        array_rENA0 <= '1';
        next_state <= read_data;
        j_next <= j + 1;
      end if;
    when extra1 =>      
      i_next <= conv_std_logic_vector(0,8);
      result_next <= array_dOUT0;
      next_state <= do_crc;
    when idle =>
      if chan1_exists = '0' then
        next_state <= idle;
      elsif chan1_exists /= '0' then
        j_next <= "00000000000000000" & chan1_channelDataOut(17 to 31);
        size_next <= "00000000000000000" & chan1_channelDataOut(2 to 16);
        chan1_channelRead <= '1';
        next_state <= read_data;
      end if;
    when read_data =>
      if ( j < size ) then
        in_array_addr0 <= j;
        array_rENA0 <= '1';
        next_state <= extra1; 
      elsif chan1_full /= '0' then
        next_state <= read_data;
      elsif chan1_full = '0' then
        chan1_channelDataIn <= (others => '0');
        chan1_channelWrite <= '1';
        next_state <= idle;
      end if;
    when reset =>
      next_state <= idle;
    when others => 
      next_state <= reset;

  end case;
end process FSM_COMB_PROCESS;

end architecture IMPLEMENTATION;


