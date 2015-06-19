

--Piplelining the rad and write from BRAMS, it processes the 4k data in 40us ( 100MHZ)  

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
read_arg,
decode,
state1,
halt,
extra1,
addv_state1,
mulv_state1,
mulv_state2,
redv_state1
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
signal ret, ret_next : std_logic_vector(0 to G_DATA_WIDTH + G_DATA_WIDTH - 1);
signal dataA1, dataA1_next : std_logic_vector(0 to G_DATA_WIDTH - 1);
signal dataA2, dataA2_next : std_logic_vector(0 to G_DATA_WIDTH - 1);
signal dataB1, dataB1_next : std_logic_vector(0 to G_DATA_WIDTH - 1);
signal dataB2, dataB2_next : std_logic_vector(0 to G_DATA_WIDTH - 1);
signal dataC1, dataC1_next : std_logic_vector(0 to G_DATA_WIDTH - 1);
signal dataC2, dataC2_next : std_logic_vector(0 to G_DATA_WIDTH - 1);
signal dataMUL, dataMUL_next : std_logic_vector(0 to G_DATA_WIDTH + G_DATA_WIDTH - 1);
signal op, op_next : std_logic_vector(0 to 1);
signal rs, rs_next : std_logic_vector(2 to 16);
signal rt, rt_next : std_logic_vector(17 to 31);


-- ****************************************************
-- User-defined VHDL Section
-- ****************************************************
constant OP_ADDV	:	std_logic_vector(0 to 1)	:=	"00";
constant OP_MULV	:	std_logic_vector(0 to 1)	:=	"01";
constant OP_REDV	:	std_logic_vector(0 to 1)	:=	"10";

--constant OP_R		:	std_logic_vector(0 to OPCODE_BITS-1)	:=	"000000";
--constant FN_NOP		:	std_logic_vector(0 to FUNC_BITS-1)	:=	"000000"; -- 0/00H
--constant FN_ADDV	:	std_logic_vector(0 to FUNC_BITS-1)	:=	"110000"; -- 0/30H
--constant FN_MULV	:	std_logic_vector(0 to FUNC_BITS-1)	:=	"110001"; -- 0/31
--constant FN_REDV	:	std_logic_vector(0 to FUNC_BITS-1)	:=	"110010"; -- 0/32

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
		when reset =>
			next_state <= fetch;

		when fetch =>
			if chan1_exists = '0' then
				next_state		<= fetch;
			elsif chan1_exists /= '0' then
				index_next		<= "00000000000000000" & chan1_channelDataOut(17 to 31);
				n_next			<= "00000000000000000" & chan1_channelDataOut(2 to 16);
				op_next			<= chan1_channelDataOut(0 to 1);
				ret_next		<= (others => '0');
				chan1_channelRead	<= '1';
				next_state		<= decode;
			end if;

		when decode =>
			i_next 				<= index;
			in_Vector_A_addr0 		<= index;
			Vector_A_rENA0 			<= '1';
			in_Vector_B_addr0 		<= index;
			Vector_B_rENA0 			<= '1';

			-- ADDV --
			if	( op = OP_ADDV ) then
					next_state 	<= addv_state1;
			-- MULV --
			elsif	( op = OP_MULV ) then
					next_state 	<= mulv_state1;
			-- REDV --
			elsif	( op = OP_REDV ) then
					next_state 	<= redv_state1;
			end if;

		when addv_state1 =>
			if ( i >= n-1 ) then
				next_state <= halt;
			elsif ( i < n-1 ) then
				-- Write VC i
				in_Vector_C_addr0 <= i;
				Vector_C_dIN0 <= Vector_A_dOUT0 + Vector_B_dOUT0;
				Vector_C_wENA0 <= (others => '1');
				Vector_C_rENA0 <= '1';
				-- Read VA i+1
				in_Vector_A_addr0 <= i+1;
				Vector_A_rENA0 <= '1';
				-- Read VB i+1
				in_Vector_B_addr0 <= i+1;
				Vector_B_rENA0 <= '1';
				-- i++
				i_next <= i+1;
				-- Loop
				next_state <= addv_state1;
			end if;

		when mulv_state1 =>
			ret_next <= Vector_A_dOUT0 * Vector_B_dOUT0;			
			-- Read VA i+1
			in_Vector_A_addr0 <= i+1;
			Vector_A_rENA0 <= '1';
			-- Read VB i+1
			in_Vector_B_addr0 <= i+1;
			Vector_B_rENA0 <= '1';
			-- i++
			i_next <= i+1;
			-- next
			next_state <= mulv_state2;

		when mulv_state2 =>
			if ( i >= n-1 ) then
				ret_next <= Vector_A_dOUT0 * Vector_B_dOUT0;
				-- Write VC i
				in_Vector_C_addr0 <= i-1;
				Vector_C_dIN0	<= ret(32 to 63);
				Vector_C_wENA0 <= (others => '1');
				Vector_C_rENA0 <= '1';
				-- Loop
				next_state <= halt;
			elsif ( i < n-1 ) then
				ret_next <= Vector_A_dOUT0 * Vector_B_dOUT0;
				-- Write VC i
				in_Vector_C_addr0 <= i-1;
				Vector_C_dIN0	<= ret(32 to 63);
				Vector_C_wENA0 <= (others => '1');
				Vector_C_rENA0 <= '1';
				-- Read VA i+1
				in_Vector_A_addr0 <= i+1;
				Vector_A_rENA0 <= '1';
				-- Read VB i+1
				in_Vector_B_addr0 <= i+1;
				Vector_B_rENA0 <= '1';
				-- i++
				i_next <= i+1;
				-- Loop
				next_state <= mulv_state2;
			end if;

		when redv_state1 =>
			if ( i >= n-1 ) then
				ret_next <= Vector_A_dOUT0 * Vector_B_dOUT0 + ret;				
				next_state <= halt;
			elsif ( i < n-1 ) then
				ret_next <= Vector_A_dOUT0 * Vector_B_dOUT0 + ret;
				-- Read VA i+1
				in_Vector_A_addr0 <= i+1;
				Vector_A_rENA0 <= '1';
				-- Read VB i+1
				in_Vector_B_addr0 <= i+1;
				Vector_B_rENA0 <= '1';
				-- i++
				i_next <= i+1;
				-- loop
				next_state <= redv_state1;
			end if;

		when halt =>
			if chan1_full /= '0' then
				next_state <= halt;
			elsif chan1_full = '0' then
				if ( op = OP_ADDV ) then
					-- Write VC last one
					in_Vector_C_addr0 <= i;
					Vector_C_dIN0 <= Vector_A_dOUT0 + Vector_B_dOUT0;
					Vector_C_wENA0 <= (others => '1');
					Vector_C_rENA0 <= '1';
					-- Send arg back say : Done!
					chan1_channelDataIn <= ret(32 to 63);
					chan1_channelWrite <= '1';
					next_state <= fetch;

				elsif ( op = OP_MULV ) then
					-- Write VC i
					in_Vector_C_addr0 <= i;
					Vector_C_dIN0	<= ret(32 to 63);
					Vector_C_wENA0 <= (others => '1');
					Vector_C_rENA0 <= '1';
					-- Send arg back say : Done!
					chan1_channelDataIn <= ret(32 to 63);
					chan1_channelWrite <= '1';
					next_state <= fetch;
				
				elsif	( op = OP_REDV ) then
					-- Send arg back say : Done!
					chan1_channelDataIn <= ret(32 to 63);
					chan1_channelWrite <= '1';
					next_state <= fetch;
				end if;
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

