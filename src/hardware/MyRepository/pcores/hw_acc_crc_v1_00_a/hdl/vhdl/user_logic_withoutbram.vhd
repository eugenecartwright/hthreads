-- ************************************
-- Automatically Generated FSM
-- crc_channel
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
entity crc_channel is
generic(
  G_INPUT_WIDTH : integer := 32;
  G_DIVISOR_WIDTH : integer := 4;
  divisor : std_logic_vector(0 to 3) := "1011"
);
port
(

  fsl1_channelDataIn : out std_logic_vector(0 to (G_INPUT_WIDTH - 1));
  fsl1_channelDataOut : in std_logic_vector(0 to (G_INPUT_WIDTH - 1));
  fsl1_exists : in std_logic;
  fsl1_full : in std_logic;
  fsl1_channelRead : out std_logic;
  fsl1_channelWrite : out std_logic;


  clock_sig : in std_logic;
  reset_sig : in std_logic
  );
  

end entity crc_channel;

-- *************************
-- Architecture Definition
-- *************************
architecture IMPLEMENTATION of crc_channel is

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
do_crc
);
signal current_state,next_state: STATE_MACHINE_TYPE :=reset;

-- ****************************************************
-- Type definitions for FSM signals
-- ****************************************************
signal i, i_next : std_logic_vector(0 to 7);
signal result, result_next : std_logic_vector(0 to G_INPUT_WIDTH - 1);


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
  i_next,
  result_next,

  next_state,
  clock_sig, reset_sig) is
begin
  if (clock_sig'event and clock_sig = '1') then
    if (reset_sig = '1') then
    -- Reset all FSM signals, and enter the initial state
      i <= (others => '0');
      result <= (others => '0');

      current_state <= reset;
    else
    -- Transition to next state
      i <= i_next;
      result <= result_next;

      current_state <= next_state;
    end if;
  end if;
end process FSM_SYNC_PROCESS;

-- ************************************************************************
-- Process to handle the asynchronous (combinational) portion of an FSM
-- ************************************************************************
FSM_COMB_PROCESS : process(

  fsl1_channelDataOut, fsl1_full, fsl1_exists,


  i,
  result,

  current_state) is
begin
  -- Default signal assignments
  i_next <= i;
  result_next <= result;


  fsl1_channelDataIn <= (others => '0');
  fsl1_channelRead <= '0';
  fsl1_channelWrite <= '0';


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
      elsif fsl1_full /= '0' then
        next_state <= do_crc;
      elsif fsl1_full = '0' then
        fsl1_channelDataIn <= result;
        fsl1_channelWrite <= '1';
        next_state <= idle;
      end if;
    when idle =>
      if fsl1_exists = '0' then
        next_state <= idle;
      elsif fsl1_exists /= '0' then
        i_next <= conv_std_logic_vector(0,8);
        result_next <= fsl1_channelDataOut;
        fsl1_channelRead <= '1';
        next_state <= do_crc;
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

