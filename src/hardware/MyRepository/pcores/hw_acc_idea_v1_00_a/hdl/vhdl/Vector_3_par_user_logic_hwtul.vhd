--accm
-- ************************************
-- Automatically Generated FSM
-- vector_chan
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
  G_DATA_WIDTH : integer := 32;
  OPCODE_BITS : integer := 6;
  FUNC_BITS : integer := 6
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
fetch,
get_instr,
read_size,
read_index,
decode,
defunc,
halt,
addv_for_loop,
extra1,
addv_ALU,
addv_write_back,
mulv_for_loop,
extra2,
mulv_ALU,
mulv_write_back,
redv_for_loop,
extra3,
redv_ALU,
redv_write_back
);
signal current_state,next_state: STATE_MACHINE_TYPE :=reset;

-- ****************************************************
-- Type definitions for FSM signals
-- ****************************************************

signal in_Vector_A_addr0 :  std_logic_vector(0 to (G_ADDR_WIDTH - 1));
signal in_Vector_B_addr0 :  std_logic_vector(0 to (G_ADDR_WIDTH - 1));
signal in_Vector_C_addr0 :  std_logic_vector(0 to (G_ADDR_WIDTH - 1));
signal swapped, swapped_next : std_logic;
signal i, i_next : std_logic_vector(0 to G_ADDR_WIDTH - 1);
signal n, n_next : std_logic_vector(0 to G_DATA_WIDTH - 1);
signal n_new, n_new_next : std_logic_vector(0 to G_DATA_WIDTH - 1);
signal instruction, instruction_next : std_logic_vector(0 to G_DATA_WIDTH - 1);
signal index, index_next : std_logic_vector(0 to G_DATA_WIDTH - 1);
signal ret, ret_next : std_logic_vector(0 to G_DATA_WIDTH - 1);
signal dataA1, dataA1_next : std_logic_vector(0 to G_DATA_WIDTH - 1);
signal dataA2, dataA2_next : std_logic_vector(0 to G_DATA_WIDTH - 1);
signal dataB1, dataB1_next : std_logic_vector(0 to G_DATA_WIDTH - 1);
signal dataB2, dataB2_next : std_logic_vector(0 to G_DATA_WIDTH - 1);
signal dataC1, dataC1_next : std_logic_vector(0 to G_DATA_WIDTH - 1);
signal dataC2, dataC2_next : std_logic_vector(0 to G_DATA_WIDTH - 1);
signal dataMUL, dataMUL_next : std_logic_vector(0 to G_DATA_WIDTH + G_DATA_WIDTH - 1);
signal op, op_next : std_logic_vector(0 to 5);
signal rs, rs_next : std_logic_vector(0 to 4);
signal rt, rt_next : std_logic_vector(0 to 4);
signal rd, rd_next : std_logic_vector(0 to 4);
signal sh, sh_next : std_logic_vector(0 to 4);
signal fn, fn_next : std_logic_vector(0 to 5);


-- ****************************************************
-- User-defined VHDL Section
-- ****************************************************
constant OP_R		:	std_logic_vector(0 to OPCODE_BITS-1)	:=	"000000";
constant FN_NOP		:	std_logic_vector(0 to FUNC_BITS-1)	:=	"000000"; -- 0/00H
constant FN_ADDV	:	std_logic_vector(0 to FUNC_BITS-1)	:=	"110000"; -- 0/30H
constant FN_MULV	:	std_logic_vector(0 to FUNC_BITS-1)	:=	"110001"; -- 0/31
constant FN_REDV	:	std_logic_vector(0 to FUNC_BITS-1)	:=	"110010"; -- 0/32

--constant OP_NOP		:	std_logic_vector(0 to OPCODE_BITS-1)	:=	x"0";
--constant OP_ADD		:	std_logic_vector(0 to OPCODE_BITS-1)	:=	x"1";
--constant OP_SUB		:	std_logic_vector(0 to OPCODE_BITS-1)	:=	x"2";
--constant OP_ADDi	:	std_logic_vector(0 to OPCODE_BITS-1)	:=	x"3";
--constant OP_SUBi	:	std_logic_vector(0 to OPCODE_BITS-1)	:=	x"4";
--constant OP_ADDV	:	std_logic_vector(0 to OPCODE_BITS-1)	:=	x"5";
--constant OP_SUBV	:	std_logic_vector(0 to OPCODE_BITS-1)	:=	x"6";
--constant OP_ADDVS	:	std_logic_vector(0 to OPCODE_BITS-1)	:=	x"7";
--constant OP_SUBVS	:	std_logic_vector(0 to OPCODE_BITS-1)	:=	x"8";
--constant OP_SNEV	:	std_logic_vector(0 to OPCODE_BITS-1)	:=	x"9";
--constant OP_SNEVS	:	std_logic_vector(0 to OPCODE_BITS-1)	:=	x"A";
--constant OP_SLTV	:	std_logic_vector(0 to OPCODE_BITS-1)	:=	x"B";
--constant OP_SLTVS	:	std_logic_vector(0 to OPCODE_BITS-1)	:=	x"C";
--constant OP_CVM		:	std_logic_vector(0 to OPCODE_BITS-1)	:=	x"D";
--constant OP_SVLR	:	std_logic_vector(0 to OPCODE_BITS-1)	:=	x"E";
--constant OP_SVMR	:	std_logic_vector(0 to OPCODE_BITS-1)	:=	x"F";


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
  instruction_next,
  index_next,
  ret_next,
  dataA1_next,
  dataA2_next,
  dataB1_next,
  dataB2_next,
  dataC1_next,
  dataC2_next,
  dataMUL_next,
  op_next,
  rs_next,
  rt_next,
  rd_next,
  sh_next,
  fn_next,

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
      instruction <= (others => '0');
      index <= (others => '0');
      ret <= (others => '0');
      dataA1 <= (others => '0');
      dataA2 <= (others => '0');
      dataB1 <= (others => '0');
      dataB2 <= (others => '0');
      dataC1 <= (others => '0');
      dataC2 <= (others => '0');
      dataMUL <= (others => '0');
      op <= (others => '0');
      rs <= (others => '0');
      rt <= (others => '0');
      rd <= (others => '0');
      sh <= (others => '0');
      fn <= (others => '0');

      current_state <= reset;
    else
    -- Transition to next state
      swapped <= swapped_next;
      i <= i_next;
      n <= n_next;
      n_new <= n_new_next;
      instruction <= instruction_next;
      index <= index_next;
      ret <= ret_next;
      dataA1 <= dataA1_next;
      dataA2 <= dataA2_next;
      dataB1 <= dataB1_next;
      dataB2 <= dataB2_next;
      dataC1 <= dataC1_next;
      dataC2 <= dataC2_next;
      dataMUL <= dataMUL_next;
      op <= op_next;
      rs <= rs_next;
      rt <= rt_next;
      rd <= rd_next;
      sh <= sh_next;
      fn <= fn_next;

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
  instruction,
  index,
  ret,
  dataA1,
  dataA2,
  dataB1,
  dataB2,
  dataC1,
  dataC2,
  dataMUL,
  op,
  rs,
  rt,
  rd,
  sh,
  fn,

  current_state) is
begin
  -- Default signal assignments
  swapped_next <= swapped;
  i_next <= i;
  n_next <= n;
  n_new_next <= n_new;
  instruction_next <= instruction;
  index_next <= index;
  ret_next <= ret;
  dataA1_next <= dataA1;
  dataA2_next <= dataA2;
  dataB1_next <= dataB1;
  dataB2_next <= dataB2;
  dataC1_next <= dataC1;
  dataC2_next <= dataC2;
  dataMUL_next <= dataMUL;
  op_next <= op;
  rs_next <= rs;
  rt_next <= rt;
  rd_next <= rd;
  sh_next <= sh;
  fn_next <= fn;

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

    when addv_ALU =>
      dataC1_next <= dataA1 + dataB1;
      next_state <= addv_write_back;
    when addv_for_loop =>
      if ( i >= n ) then
        next_state <= halt;
      elsif ( i < n ) then
in_Vector_A_addr0 <= i;
        Vector_A_rENA0 <= '1';
in_Vector_B_addr0 <= i;
        Vector_B_rENA0 <= '1';
        next_state <= extra1;
      end if;
    when addv_write_back =>
      i_next <= i + 1;
in_Vector_C_addr0 <= i;
      Vector_C_dIN0 <= dataC1;
      Vector_C_wENA0 <= (others => '1');
      Vector_C_rENA0 <= '1';
      next_state <= addv_for_loop;
    when decode =>
      if ( op = OP_R ) then
        next_state <= defunc;
      end if;
    when defunc =>
      if ( fn = FN_NOP ) then
        next_state <= halt;
      elsif ( fn = FN_ADDV ) then
        i_next <= index;
        next_state <= addv_for_loop;
      elsif ( fn = FN_MULV ) then
        i_next <= index;
        next_state <= mulv_for_loop;
      elsif ( fn = FN_REDV ) then
        i_next <= index;
        next_state <= redv_for_loop;
      end if;
    when extra1 =>
      dataB1_next <= Vector_B_dOUT0;
      dataA1_next <= Vector_A_dOUT0;
      next_state <= addv_ALU;
    when extra2 =>
      dataB1_next <= Vector_B_dOUT0;
      dataA1_next <= Vector_A_dOUT0;
      next_state <= mulv_ALU;
    when extra3 =>
      dataB1_next <= Vector_B_dOUT0;
      dataA1_next <= Vector_A_dOUT0;
      next_state <= redv_ALU;
    when fetch =>
      if chan1_exists = '0' then
        next_state <= fetch;
      elsif chan1_exists /= '0' then
        instruction_next <= chan1_channelDataOut;
        chan1_channelRead <= '1';
        next_state <= get_instr;
      end if;
    when get_instr =>
      ret_next <= (others => '0');
      fn_next <= instruction(26 to 31);
      sh_next <= instruction(21 to 25);
      rt_next <= instruction(16 to 20);
      rs_next <= instruction(11 to 15);
      rd_next <= instruction(6 to 10);
      op_next <= instruction(0 to 5);
      next_state <= read_size;
    when halt =>
      if chan1_full /= '0' then
        next_state <= halt;
      elsif chan1_full = '0' then
        chan1_channelDataIn <= ret;
        chan1_channelWrite <= '1';
        next_state <= fetch;
      end if;
    when mulv_ALU =>
      dataMUL_next <= dataA1 * dataB1;
      next_state <= mulv_write_back;
    when mulv_for_loop =>
      if ( i >= n ) then
        next_state <= halt;
      elsif ( i < n ) then
in_Vector_A_addr0 <= i;
        Vector_A_rENA0 <= '1';
in_Vector_B_addr0 <= i;
        Vector_B_rENA0 <= '1';
        next_state <= extra2;
      end if;
    when mulv_write_back =>
      i_next <= i + 1;
in_Vector_C_addr0 <= i;
      Vector_C_dIN0 <= dataMUL(32 to 63);
      Vector_C_wENA0 <= (others => '1');
      Vector_C_rENA0 <= '1';
      next_state <= mulv_for_loop;
    when read_index =>
      if chan1_exists = '0' then
        next_state <= read_index;
      elsif chan1_exists /= '0' then
        index_next <= chan1_channelDataOut;
        chan1_channelRead <= '1';
        next_state <= decode;
      end if;
    when read_size =>
      if chan1_exists = '0' then
        next_state <= read_size;
      elsif chan1_exists /= '0' then
        n_next <= chan1_channelDataOut;
        chan1_channelRead <= '1';
        next_state <= read_index;
      end if;
    when redv_ALU =>
      dataMUL_next <= dataA1 * dataB1;
      next_state <= redv_write_back;
    when redv_for_loop =>
      if ( i >= n ) then
        next_state <= halt;
      elsif ( i < n ) then
in_Vector_A_addr0 <= i;
        Vector_A_rENA0 <= '1';
in_Vector_B_addr0 <= i;
        Vector_B_rENA0 <= '1';
        next_state <= extra3;
      end if;
    when redv_write_back =>
      i_next <= i + 1;
      ret_next <= ret + dataMUL(32 to 63);
      next_state <= redv_for_loop;
    when reset =>
      next_state <= fetch;
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

