-- ************************************
-- Automatically Generated FSM
-- PIC
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
entity PIC is
generic(
  IID_WIDTH : integer := 3;
  REG_SIZE : integer := 9;
  CMD_WIDTH : integer := 4;
  C_NUM_INTERRUPTS : integer := 8
);
port
(

  msg_chan_channelDataIn : out std_logic_vector(0 to (8 - 1));
  msg_chan_channelDataOut : in std_logic_vector(0 to (8 - 1));
  msg_chan_exists : in std_logic;
  msg_chan_full : in std_logic;
  msg_chan_channelRead : out std_logic;
  msg_chan_channelWrite : out std_logic;

  go : in std_logic;
  ack : out std_logic;
  TID_IN : in std_logic_vector(0 to 7);
  IID_IN : in std_logic_vector(0 to IID_WIDTH - 1);
  CMD_IN : in std_logic_vector(0 to CMD_WIDTH - 1);
  RUPT_IN : in std_logic_vector(0 to C_NUM_INTERRUPTS - 1);
  IER_OUT : out std_logic_vector(0 to C_NUM_INTERRUPTS - 1);
  IAR_OUT : out std_logic_vector(0 to C_NUM_INTERRUPTS - 1);
  RET_OUT : out std_logic_vector(0 to 7);
  TID_OUT : out std_logic_vector(0 to 7);

  clock_sig : in std_logic;
  reset_sig : in std_logic
  );
end entity PIC;

-- *************************
-- Architecture Definition
-- *************************
architecture IMPLEMENTATION of PIC is

-- ***************************
-- ChipScope Cores
-- ***************************
-- component chipscope_icon_v1_03_a
--   PORT (
--     CONTROL0 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0));
-- 
-- end component;
-- 
-- component chipscope_ila_v1_02_a
--   PORT (
--     CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
--     CLK : IN STD_LOGIC;
--     TRIG0 : IN STD_LOGIC_VECTOR(24 DOWNTO 0));
-- 
-- end component;
-- -- ***************************

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
initMem,
idle,
command,
interrupts,
transaction_complete,
readInterrupt,
extra1,
extra2,
outputMem,
extra3,
extra4,
writeMem,
extra5,
extra6,
readMem,
extra7,
extra8,
clearReg
);
signal currenty_state,next_state: STATE_MACHINE_TYPE :=reset;

-- ****************************************************
-- Type definitions for FSM signals
-- ****************************************************
signal mem_addr_counter, mem_addr_counter_next : std_logic_vector(0 to IID_WIDTH - 1);
signal cur_mem_reg, cur_mem_reg_next : std_logic_vector(0 to REG_SIZE - 1);
signal retcode, retcode_next : std_logic_vector(0 to 7);
signal reg_out, reg_out_next : std_logic_vector(0 to 7);
signal busy, busy_next : std_logic;
signal rupt_addr_counter, rupt_addr_counter_next : std_logic_vector(0 to IID_WIDTH);
signal ier_sig, ier_sig_next : std_logic_vector(0 to C_NUM_INTERRUPTS - 1);
signal iar_sig, iar_sig_next : std_logic_vector(0 to C_NUM_INTERRUPTS - 1);

-- **************************
-- BRAM Signals for array
-- **************************
signal array_addr0 : std_logic_vector(0 to (IID_WIDTH - 1));
signal array_dIN0 : std_logic_vector(0 to (REG_SIZE - 1));
signal array_dOUT0 : std_logic_vector(0 to (REG_SIZE - 1));
signal array_rENA0 : std_logic;
signal array_wENA0 : std_logic;
signal array_addr1 : std_logic_vector(0 to (IID_WIDTH - 1));
signal array_dIN1 : std_logic_vector(0 to (REG_SIZE - 1));
signal array_dOUT1 : std_logic_vector(0 to (REG_SIZE - 1));
signal array_rENA1 : std_logic;
signal array_wENA1 : std_logic;


-- ****************************************************
-- User-defined VHDL Section
-- ****************************************************
constant CMD_READ   : std_logic_vector(0 to CMD_WIDTH-1) := conv_std_logic_vector(0,CMD_WIDTH);
constant CMD_WRITE  : std_logic_vector(0 to CMD_WIDTH-1) := conv_std_logic_vector(1,CMD_WIDTH);
constant CMD_CLEAR  : std_logic_vector(0 to CMD_WIDTH-1) := conv_std_logic_vector(2,CMD_WIDTH);

-- ChipScope signals
-- signal CONTROL0 : std_logic_vector(35 downto 0);
-- signal TRIG0 : std_logic_vector(24 downto 0);
 
-- Architecture Section
begin

-- ************************
-- Permanent Connections
-- ************************
RET_OUT <= retcode; 
TID_OUT <= reg_out; 
ack <= busy; 
IER_OUT <= ier_sig; 
IAR_OUT <= iar_sig; 


-- ChipScope Instantiations

-- pic_icon : chipscope_icon_v1_03_a
--   port map (
--     CONTROL0 => CONTROL0);
-- 
-- pic_ila : chipscope_ila_v1_02_a
--   port map (
--     CONTROL => CONTROL0,
--     CLK => clock_sig,
--     TRIG0 => TRIG0);
-- 
-- TRIG0   <= reset_sig & go & CMD_IN & busy & mem_addr_counter & retcode & reg_out;
 
-- ************************
-- BRAM implementations
-- ************************
array_BRAM : infer_bram
generic map (
  ADDRESS_BITS => IID_WIDTH,
  DATA_BITS => REG_SIZE
)
port map (
  CLKA  => clock_sig,
  ENA   => array_rENA0,
  WEA   => array_wENA0,
  ADDRA => array_addr0,
  DIA   => array_dIN0,
  DOA   => array_dOUT0,
  CLKB  => clock_sig,
  ENB   => array_rENA1,
  WEB   => array_wENA1,
  ADDRB => array_addr1,
  DIB   => array_dIN1,
  DOB   => array_dOUT1
);


-- ****************************************************
-- Process to handle the synchronous portion of an FSM
-- ****************************************************
FSM_SYNC_PROCESS : process(
  mem_addr_counter_next,
  cur_mem_reg_next,
  retcode_next,
  reg_out_next,
  busy_next,
  rupt_addr_counter_next,
  ier_sig_next,
  iar_sig_next,

  next_state,
  clock_sig, reset_sig) is
begin
  if (clock_sig'event and clock_sig = '1') then
    if (reset_sig = '1') then
    -- Reset all FSM signals, and enter the initial state
      mem_addr_counter <= (others => '0');
      cur_mem_reg <= (others => '0');
      retcode <= (others => '0');
      reg_out <= (others => '0');
      busy <= '0';
      rupt_addr_counter <= (others => '0');
      ier_sig <= (others => '0');
      iar_sig <= (others => '0');

      currenty_state <= reset;
    else
    -- Transition to next state
      mem_addr_counter <= mem_addr_counter_next;
      cur_mem_reg <= cur_mem_reg_next;
      retcode <= retcode_next;
      reg_out <= reg_out_next;
      busy <= busy_next;
      rupt_addr_counter <= rupt_addr_counter_next;
      ier_sig <= ier_sig_next;
      iar_sig <= iar_sig_next;

      currenty_state <= next_state;
    end if;
  end if;
end process FSM_SYNC_PROCESS;

-- ************************************************************************
-- Process to handle the asynchronous (combinational) portion of an FSM
-- ************************************************************************
FSM_COMB_PROCESS : process(
  array_dOUT0, array_dOUT1,

  msg_chan_channelDataOut, msg_chan_full, msg_chan_exists,

  go,
  TID_IN,
  IID_IN,
  CMD_IN,
  RUPT_IN,

  mem_addr_counter,
  cur_mem_reg,
  retcode,
  reg_out,
  busy,
  rupt_addr_counter,
  ier_sig,
  iar_sig,

  currenty_state) is
begin
  -- Default signal assignments
  mem_addr_counter_next <= mem_addr_counter;
  cur_mem_reg_next <= cur_mem_reg;
  retcode_next <= retcode;
  reg_out_next <= reg_out;
  busy_next <= busy;
  rupt_addr_counter_next <= rupt_addr_counter;
  ier_sig_next <= ier_sig;
  iar_sig_next <= iar_sig;

  array_addr0 <= (others => '0');
  array_dIN0  <= (others => '0');
  array_rENA0 <= '0';
  array_wENA0 <= '0';
  array_addr1 <= (others => '0');
  array_dIN1  <= (others => '0');
  array_rENA1 <= '0';
  array_wENA1 <= '0';


  msg_chan_channelDataIn <= (others => '0');
  msg_chan_channelRead <= '0';
  msg_chan_channelWrite <= '0';


  next_state <= currenty_state;

  -- FSM logic
  case (currenty_state) is

    when clearReg =>
      array_addr0 <= IID_IN;
      array_dIN0 <= (others => '0');
      array_wENA0 <= '1';
      array_rENA0 <= '1';
      next_state <= transaction_complete;
    when command =>
      if ( CMD_IN = CMD_WRITE ) then
        array_addr0 <= IID_IN;
        array_rENA0 <= '1';
        next_state <= extra3;
      elsif ( CMD_IN = CMD_READ ) then
        array_addr0 <= IID_IN;
        array_rENA0 <= '1';
        next_state <= extra5;
      elsif ( CMD_IN = CMD_CLEAR ) then
        array_addr0 <= IID_IN;
        array_rENA0 <= '1';
        next_state <= extra7;
      else
        next_state <= idle;
      end if;
    when extra1 =>
      next_state <= extra2;
    when extra2 =>
      rupt_addr_counter_next <= rupt_addr_counter + 1;
      cur_mem_reg_next <= array_dOUT0;
      iar_sig_next <= (others => '0');
      next_state <= outputMem;
    when extra3 =>
      next_state <= extra4;
    when extra4 =>
      cur_mem_reg_next <= array_dOUT0;
      next_state <= writeMem;
    when extra5 =>
      next_state <= extra6;
    when extra6 =>
      cur_mem_reg_next <= array_dOUT0;
      next_state <= readMem;
    when extra7 =>
      next_state <= extra8;
    when extra8 =>
      cur_mem_reg_next <= array_dOUT0;
      next_state <= clearReg;
    when idle =>
      if ( go = '1' ) then
        busy_next <= '1';
        next_state <= command;
      elsif ( RUPT_IN /= 0 ) then
        next_state <= interrupts;
      else
        busy_next <= '0';
        next_state <= idle;
      end if;
    when initMem =>
      if ( mem_addr_counter < C_NUM_INTERRUPTS - 1 ) then
        mem_addr_counter_next <= mem_addr_counter + 1;
        array_addr0 <= mem_addr_counter;
        array_dIN0 <= (others => '0');
        array_wENA0 <= '1';
        array_rENA0 <= '1';
        busy_next <= '1';
        next_state <= initMem;
      else
        busy_next <= '0';
        array_addr0 <= mem_addr_counter;
        array_dIN0 <= (others => '0');
        array_wENA0 <= '1';
        array_rENA0 <= '1';
        next_state <= idle;
      end if;
    when interrupts =>
      rupt_addr_counter_next <= (others => '0');
      next_state <= readInterrupt;
    when outputMem =>
      if msg_chan_full /= '0' then
        next_state <= outputMem;
      elsif msg_chan_full = '0' then
        iar_sig_next(conv_integer(rupt_addr_counter - 1)) <= '1';
        ier_sig_next(conv_integer(rupt_addr_counter - 1)) <= '0';
        array_addr0 <= rupt_addr_counter(1 to IID_WIDTH) - 1;
        array_dIN0 <= (others => '0');
        array_wENA0 <= '1';
        array_rENA0 <= '1';
        msg_chan_channelDataIn <= cur_mem_reg(1 to 8);
        msg_chan_channelWrite <= '1';
        reg_out_next <= cur_mem_reg(1 to 8);
        next_state <= readInterrupt;
      end if;
    when readInterrupt =>
      if ( rupt_addr_counter <= C_NUM_INTERRUPTS - 1 and RUPT_IN(conv_integer(rupt_addr_counter)) = '1' ) then
        array_addr0 <= rupt_addr_counter(1 to IID_WIDTH);
        array_rENA0 <= '1';
        next_state <= extra1;
      elsif ( rupt_addr_counter <= C_NUM_INTERRUPTS - 1 and RUPT_IN(conv_integer(rupt_addr_counter)) = '0' ) then
        rupt_addr_counter_next <= rupt_addr_counter + 1;
        iar_sig_next <= (others => '0');
        next_state <= readInterrupt;
      else
        iar_sig_next <= (others => '0');
        next_state <= transaction_complete;
      end if;
    when readMem =>
      if ( cur_mem_reg(0) = '1' ) then
        reg_out_next <= cur_mem_reg(1 to 8);
        next_state <= transaction_complete;
      else
        reg_out_next <= (others => '0');
        next_state <= transaction_complete;
      end if;
    when reset =>
      iar_sig_next <= (others => '0');
      ier_sig_next <= (others => '0');
      rupt_addr_counter_next <= (others => '0');
      busy_next <= '1';
      reg_out_next <= (others => '0');
      retcode_next <= (others => '0');
      cur_mem_reg_next <= (others => '0');
      mem_addr_counter_next <= (others => '0');
      next_state <= initMem;
    when transaction_complete =>
      if ( RUPT_IN /= 0 ) then
        busy_next <= '0';
        next_state <= interrupts;
      else
        busy_next <= '0';
        next_state <= idle;
      end if;
    when writeMem =>
      if ( cur_mem_reg(0) = '0' ) then
        ier_sig_next(conv_integer(IID_IN)) <= '1';
        retcode_next <= conv_std_logic_vector(0,8);
        array_addr0 <= IID_IN;
        array_dIN0 <= '1' & TID_IN;
        array_wENA0 <= '1';
        array_rENA0 <= '1';
        next_state <= transaction_complete;
      elsif ( cur_mem_reg(0) = '1' ) then
        retcode_next <= conv_std_logic_vector(1,8);
        next_state <= transaction_complete;
      else
        next_state <= transaction_complete;
      end if;
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

