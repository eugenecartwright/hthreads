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
entity vector_chan is
generic(
  G_ADDR_WIDTH : integer := 32;
  G_DATA_WIDTH : integer := 32
);
port
(
  Vector_A_addr0 : out std_logic_vector(0 to (G_ADDR_WIDTH - 1));
  Vector_A_dIN0 : out std_logic_vector(0 to (G_DATA_WIDTH - 1));
  Vector_A_dOUT0 : in std_logic_vector(0 to (G_DATA_WIDTH - 1));
  Vector_A_rENA0 : out std_logic;
  Vector_A_wENA0 : out std_logic_vector(0 to (G_DATA_WIDTH/8) -1);
  Vector_B_addr0 : out std_logic_vector(0 to (G_ADDR_WIDTH - 1));
  Vector_B_dIN0 : out std_logic_vector(0 to (G_DATA_WIDTH - 1));
  Vector_B_dOUT0 : in std_logic_vector(0 to (G_DATA_WIDTH - 1));
  Vector_B_rENA0 : out std_logic;
  Vector_B_wENA0 : out std_logic_vector(0 to (G_DATA_WIDTH/8) -1);
  Vector_C_addr0 : out std_logic_vector(0 to (G_ADDR_WIDTH - 1));
  Vector_C_dIN0 : out std_logic_vector(0 to (G_DATA_WIDTH - 1));
  Vector_C_dOUT0 : in std_logic_vector(0 to (G_DATA_WIDTH - 1));
  Vector_C_rENA0 : out std_logic;
  Vector_C_wENA0 : out std_logic_vector(0 to (G_DATA_WIDTH/8) -1);

  chan1_channelDataIn : out std_logic_vector(0 to (32 - 1));
  chan1_channelDataOut : in std_logic_vector(0 to (32 - 1));
  chan1_exists : in std_logic;
  chan1_full : in std_logic;
  chan1_channelRead : out std_logic;
  chan1_channelWrite : out std_logic;


  clock_sig : in std_logic;
  reset_sig : in std_logic
  );
end entity vector_chan;

-- *************************
-- Architecture Definition
-- *************************
architecture IMPLEMENTATION of vector_chan is

component infer_bram
generic
(
  ADDRESS_BITS    : integer   := 32;
  DATA_BITS       : integer   := 32
);
port (
  CLKA        : in std_logic;
  ENA         : in std_logic;
  WEA         : in std_logic_vector(0 to 3);
  ADDRA       : in std_logic_vector(0 to (ADDRESS_BITS - 1));
  DIA         : in std_logic_vector(0 to (DATA_BITS - 1));
  DOA         : out  std_logic_vector(0 to (DATA_BITS - 1));
  CLKB        : in std_logic;
  ENB         : in std_logic;
  WEB         : in std_logic_vector(0 to 3);
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
get_en,
begin_sort,
for_loop,
halt,
extra1,
ALU,
write_back
);
signal current_state,next_state: STATE_MACHINE_TYPE :=reset;

-- ****************************************************
-- Type definitions for FSM signals
-- ****************************************************
signal swapped, swapped_next : std_logic;
signal i, i_next : std_logic_vector(0 to G_ADDR_WIDTH - 1);
signal n, n_next : std_logic_vector(0 to G_ADDR_WIDTH - 1);
signal n_new, n_new_next : std_logic_vector(0 to G_ADDR_WIDTH - 1);
signal e, e_next : std_logic_vector(0 to G_ADDR_WIDTH - 1);
signal dataA1, dataA1_next : std_logic_vector(0 to G_DATA_WIDTH - 1);
signal dataA2, dataA2_next : std_logic_vector(0 to G_DATA_WIDTH - 1);
signal dataB1, dataB1_next : std_logic_vector(0 to G_DATA_WIDTH - 1);
signal dataB2, dataB2_next : std_logic_vector(0 to G_DATA_WIDTH - 1);
signal dataC1, dataC1_next : std_logic_vector(0 to G_DATA_WIDTH - 1);
signal dataC2, dataC2_next : std_logic_vector(0 to G_DATA_WIDTH - 1);
signal in_Vector_A_addr0 :  std_logic_vector(0 to (G_ADDR_WIDTH - 1));
signal in_Vector_B_addr0 :  std_logic_vector(0 to (G_ADDR_WIDTH - 1));
signal in_Vector_C_addr0 :  std_logic_vector(0 to (G_ADDR_WIDTH - 1));

-- ****************************************************
-- User-defined VHDL Section
-- ****************************************************

-- Architecture Section
begin

-- ************************
-- Permanent Connections
-- ************************
Vector_A_addr0 <= in_Vector_A_addr0(2 to 31) & "00";
Vector_B_addr0 <= in_Vector_B_addr0(2 to 31) & "00";
Vector_C_addr0 <= in_Vector_C_addr0(2 to 31) & "00";


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
  e_next,
  dataA1_next,
  dataA2_next,
  dataB1_next,
  dataB2_next,
  dataC1_next,
  dataC2_next,

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
      e <= (others => '0');
      dataA1 <= (others => '0');
      dataA2 <= (others => '0');
      dataB1 <= (others => '0');
      dataB2 <= (others => '0');
      dataC1 <= (others => '0');
      dataC2 <= (others => '0');

      current_state <= reset;
    else
    -- Transition to next state
      swapped <= swapped_next;
      i <= i_next;
      n <= n_next;
      n_new <= n_new_next;
      e <= e_next;
      dataA1 <= dataA1_next;
      dataA2 <= dataA2_next;
      dataB1 <= dataB1_next;
      dataB2 <= dataB2_next;
      dataC1 <= dataC1_next;
      dataC2 <= dataC2_next;

      current_state <= next_state;
    end if;
  end if;
end process FSM_SYNC_PROCESS;

-- ************************************************************************
-- Process to handle the asynchronous (combinational) portion of an FSM
-- ************************************************************************
FSM_COMB_PROCESS : process(
  Vector_A_dOUT0,
  Vector_B_dOUT0,
  Vector_C_dOUT0,

  chan1_channelDataOut, chan1_full, chan1_exists,


  swapped,
  i,
  n,
  n_new,
  e,
  dataA1,
  dataA2,
  dataB1,
  dataB2,
  dataC1,
  dataC2,

  current_state) is
begin
  -- Default signal assignments
  swapped_next <= swapped;
  i_next <= i;
  n_next <= n;
  n_new_next <= n_new;
  e_next <= e;
  dataA1_next <= dataA1;
  dataA2_next <= dataA2;
  dataB1_next <= dataB1;
  dataB2_next <= dataB2;
  dataC1_next <= dataC1;
  dataC2_next <= dataC2;

  in_Vector_A_addr0 <= (others => '0');
  Vector_A_dIN0  <= (others => '0');
  Vector_A_rENA0 <= '0';
  Vector_A_wENA0 <= (others => '0');

  in_Vector_B_addr0 <= (others => '0');
  Vector_B_dIN0  <= (others => '0');
  Vector_B_rENA0 <= '0';
  Vector_B_wENA0 <= (others => '0');

  in_Vector_C_addr0 <= (others => '0');
  Vector_C_dIN0  <= (others => '0');
  Vector_C_rENA0 <= '0';
  Vector_C_wENA0 <= (others => '0');


  chan1_channelDataIn <= (others => '0');
  chan1_channelRead <= '0';
  chan1_channelWrite <= '0';


  next_state <= current_state;

  -- FSM logic
  case (current_state) is

    when ALU =>
      dataC1_next <= dataA1 + dataB1;
      next_state <= write_back;
    when begin_sort =>
      i_next <= e;
      next_state <= for_loop;
    when extra1 =>
      dataB1_next <= Vector_B_dOUT0;
      dataA1_next <= Vector_A_dOUT0;
      next_state <= ALU;
    when for_loop =>
      if ( i >= n ) then
        next_state <= halt;
      elsif ( i < n ) then
        in_Vector_A_addr0 <= i;
        Vector_A_rENA0 <= '1';
        in_Vector_B_addr0 <= i;
        Vector_B_rENA0 <= '1';
        next_state <= extra1;
      end if;
    when get_en =>
      if chan1_exists = '0' then
        next_state <= get_en;
      elsif chan1_exists /= '0' then
        e_next <= chan1_channelDataOut;
        chan1_channelRead <= '1';
        next_state <= begin_sort;
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
        next_state <= get_en;
      end if;
    when reset =>
      next_state <= idle;
    when write_back =>
      i_next <= i + 1;
      in_Vector_C_addr0 <= i;
      Vector_C_dIN0 <= dataC1;
      Vector_C_wENA0 <= (others => '1');
      Vector_C_rENA0 <= '1';
      next_state <= for_loop;
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
                    BRAM_DATA( conv_integer(ADDRB) )  <= DIB;
                end if;

                DOB <= BRAM_DATA( conv_integer(ADDRB) );
            end if;
        end if;
    end process BRAM_CONTROLLER_B;

end architecture implementation;

