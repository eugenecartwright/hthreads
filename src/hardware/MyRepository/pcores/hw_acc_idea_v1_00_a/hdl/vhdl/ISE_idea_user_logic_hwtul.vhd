--accm
-- ************************************
-- Automatically Generated FSM
-- IDEA_chan
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
entity IDEA_chan is
generic(
  G_ADDR_WIDTH : integer := 32;
  G_DATA_WIDTH : integer := 32;
  DATA_WIDTH : integer := 32;
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
end entity IDEA_chan;

-- *************************
-- Architecture Definition
-- *************************
architecture IMPLEMENTATION of IDEA_chan is

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
decode,
IDEA_state1,
extra1,
read_x1,
extra2,
read_x2,
extra3,
read_x3,
extra4,
start_round,
extra5,
r1_1,
extra6,
r1_2,
extra7,
r1_3,
extra8,
r1_4,
extra9,
r1_5,
extra10,
r1_6,
extra11,
r1_7,
extra12,
round_part0,
extra13,
r2_1,
extra14,
r2_2,
extra15,
r2_3,
extra16,
r2_4,
extra17,
r2_5,
extra18,
r2_6,
extra19,
r2_7,
extra20,
extra21,
r3_1,
extra22,
r3_2,
extra23,
r3_3,
extra24,
r3_4,
extra25,
r3_5,
extra26,
r3_6,
extra27,
r3_7,
extra28,
extra29,
r4_1,
extra30,
r4_2,
extra31,
r4_3,
extra32,
r4_4,
extra33,
r4_5,
extra34,
r4_6,
extra35,
r4_7,
extra36,
extra37,
r5_1,
extra38,
r5_2,
extra39,
r5_3,
extra40,
r5_4,
extra41,
r5_5,
extra42,
r5_6,
extra43,
r5_7,
extra44,
extra45,
r6_1,
extra46,
r6_2,
extra47,
r6_3,
extra48,
r6_4,
extra49,
r6_5,
extra50,
r6_6,
extra51,
r6_7,
extra52,
extra53,
r7_1,
extra54,
r7_2,
extra55,
r7_3,
extra56,
r7_4,
extra57,
r7_5,
extra58,
r7_6,
extra59,
r7_7,
extra60,
extra61,
r8_1,
extra62,
r8_2,
extra63,
r8_3,
extra64,
r8_4,
extra65,
r8_5,
extra66,
r8_6,
extra67,
r8_7,
extra68,
extra69,
r9_4,
extra70,
r9_2,
extra71,
r9_3,
extra72,
pre_calc_results,
round_part1,
round_part2,
round_part3,
round_part4,
round_part5,
round_part6,
round_part7,
round_part8,
calc_results,
output_results,
next_result,
next_next_result,
next_next_next_result,
halt
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
signal op, op_next : std_logic_vector(0 to 1);
signal rs, rs_next : std_logic_vector(2 to 16);
signal rt, rt_next : std_logic_vector(17 to 31);
signal r, r_next : std_logic_vector(0 to DATA_WIDTH - 1);
signal mult_res1, mult_res1_next : std_logic_vector(0 to DATA_WIDTH + DATA_WIDTH - 1);
signal mult_res2, mult_res2_next : std_logic_vector(0 to DATA_WIDTH + DATA_WIDTH - 1);
signal mult_res3, mult_res3_next : std_logic_vector(0 to DATA_WIDTH - 1);
signal mult_res4, mult_res4_next : std_logic_vector(0 to DATA_WIDTH - 1);
signal out1, out1_next : std_logic_vector(0 to DATA_WIDTH - 1);
signal out2, out2_next : std_logic_vector(0 to DATA_WIDTH - 1);
signal out3, out3_next : std_logic_vector(0 to DATA_WIDTH - 1);
signal out4, out4_next : std_logic_vector(0 to DATA_WIDTH - 1);
signal x1, x1_next : std_logic_vector(0 to DATA_WIDTH - 1);
signal x2, x2_next : std_logic_vector(0 to DATA_WIDTH - 1);
signal x3, x3_next : std_logic_vector(0 to DATA_WIDTH - 1);
signal x4, x4_next : std_logic_vector(0 to DATA_WIDTH - 1);
signal kk, kk_next : std_logic_vector(0 to DATA_WIDTH - 1);
signal t1, t1_next : std_logic_vector(0 to DATA_WIDTH - 1);
signal t2, t2_next : std_logic_vector(0 to DATA_WIDTH - 1);
signal a, a_next : std_logic_vector(0 to DATA_WIDTH - 1);
signal z1_r, z1_r_next : std_logic_vector(0 to DATA_WIDTH - 1);
signal z2_r, z2_r_next : std_logic_vector(0 to DATA_WIDTH - 1);
signal z3_r, z3_r_next : std_logic_vector(0 to DATA_WIDTH - 1);
signal z4_r, z4_r_next : std_logic_vector(0 to DATA_WIDTH - 1);
signal z5_r, z5_r_next : std_logic_vector(0 to DATA_WIDTH - 1);
signal z6_r, z6_r_next : std_logic_vector(0 to DATA_WIDTH - 1);
signal z7_r, z7_r_next : std_logic_vector(0 to DATA_WIDTH - 1);
signal z8_r, z8_r_next : std_logic_vector(0 to DATA_WIDTH - 1);
signal z9_r, z9_r_next : std_logic_vector(0 to DATA_WIDTH - 1);


-- ****************************************************
-- User-defined VHDL Section
-- ****************************************************
constant maxim : std_logic_vector(0 to DATA_WIDTH-1) := conv_std_logic_vector(65537,DATA_WIDTH);
constant one : std_logic_vector(0 to DATA_WIDTH-1) := conv_std_logic_vector(65535,DATA_WIDTH);

function mul( a : std_logic_vector(0 to DATA_WIDTH -1); b : std_logic_vector(0 to DATA_WIDTH-1); q : std_logic_vector(0 to DATA_WIDTH-1)) return std_logic_vector is
 variable p : std_logic_vector(0 to DATA_WIDTH-1);
 variable x : std_logic_vector(0 to DATA_WIDTH-1);
begin
  if (a = 0) then
	p := maxim - b;

  elsif (b = 0) then
    p := maxim - a;

  else
    x := (q and one);
    p := x - (x"0000" & q(0 to DATA_WIDTH/2-1));
    --if (p <= 0) then	-- Need to change this check to handle signed/unsigned stuff, probably just check the MSB
    if (p(0) = '1') then	-- Need to change this check to handle signed/unsigned stuff, probably just check the MSB
      p := p + maxim;
    end if;
  end if; 

  return (p and one);

end function mul;


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
  r_next,
  mult_res1_next,
  mult_res2_next,
  mult_res3_next,
  mult_res4_next,
  out1_next,
  out2_next,
  out3_next,
  out4_next,
  x1_next,
  x2_next,
  x3_next,
  x4_next,
  kk_next,
  t1_next,
  t2_next,
  a_next,
  z1_r_next,
  z2_r_next,
  z3_r_next,
  z4_r_next,
  z5_r_next,
  z6_r_next,
  z7_r_next,
  z8_r_next,
  z9_r_next,

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
      r <= (others => '0');
      mult_res1 <= (others => '0');
      mult_res2 <= (others => '0');
      mult_res3 <= (others => '0');
      mult_res4 <= (others => '0');
      out1 <= (others => '0');
      out2 <= (others => '0');
      out3 <= (others => '0');
      out4 <= (others => '0');
      x1 <= (others => '0');
      x2 <= (others => '0');
      x3 <= (others => '0');
      x4 <= (others => '0');
      kk <= (others => '0');
      t1 <= (others => '0');
      t2 <= (others => '0');
      a <= (others => '0');
      z1_r <= (others => '0');
      z2_r <= (others => '0');
      z3_r <= (others => '0');
      z4_r <= (others => '0');
      z5_r <= (others => '0');
      z6_r <= (others => '0');
      z7_r <= (others => '0');
      z8_r <= (others => '0');
      z9_r <= (others => '0');

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
      r <= r_next;
      mult_res1 <= mult_res1_next;
      mult_res2 <= mult_res2_next;
      mult_res3 <= mult_res3_next;
      mult_res4 <= mult_res4_next;
      out1 <= out1_next;
      out2 <= out2_next;
      out3 <= out3_next;
      out4 <= out4_next;
      x1 <= x1_next;
      x2 <= x2_next;
      x3 <= x3_next;
      x4 <= x4_next;
      kk <= kk_next;
      t1 <= t1_next;
      t2 <= t2_next;
      a <= a_next;
      z1_r <= z1_r_next;
      z2_r <= z2_r_next;
      z3_r <= z3_r_next;
      z4_r <= z4_r_next;
      z5_r <= z5_r_next;
      z6_r <= z6_r_next;
      z7_r <= z7_r_next;
      z8_r <= z8_r_next;
      z9_r <= z9_r_next;

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
  r,
  mult_res1,
  mult_res2,
  mult_res3,
  mult_res4,
  out1,
  out2,
  out3,
  out4,
  x1,
  x2,
  x3,
  x4,
  kk,
  t1,
  t2,
  a,
  z1_r,
  z2_r,
  z3_r,
  z4_r,
  z5_r,
  z6_r,
  z7_r,
  z8_r,
  z9_r,

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
  r_next <= r;
  mult_res1_next <= mult_res1;
  mult_res2_next <= mult_res2;
  mult_res3_next <= mult_res3;
  mult_res4_next <= mult_res4;
  out1_next <= out1;
  out2_next <= out2;
  out3_next <= out3;
  out4_next <= out4;
  x1_next <= x1;
  x2_next <= x2;
  x3_next <= x3;
  x4_next <= x4;
  kk_next <= kk;
  t1_next <= t1;
  t2_next <= t2;
  a_next <= a;
  z1_r_next <= z1_r;
  z2_r_next <= z2_r;
  z3_r_next <= z3_r;
  z4_r_next <= z4_r;
  z5_r_next <= z5_r;
  z6_r_next <= z6_r;
  z7_r_next <= z7_r;
  z8_r_next <= z8_r;
  z9_r_next <= z9_r;

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

    when IDEA_state1 =>
in_Vector_A_addr0 <= i + 0;
      Vector_A_rENA0 <= '1';
      next_state <= extra1;
    when calc_results =>
      out4_next <= mul(x4,z4_r,mult_res2(32 to 63));
      out3_next <= ( x2 + z3_r ) and one;
      out2_next <= ( x3 + z2_r ) and one;
      out1_next <= mul(x1,z1_r,mult_res1(32 to 63));
      next_state <= output_results;
    when decode =>
      i_next <= index;
      next_state <= IDEA_state1;
    when extra1 =>
      x1_next <= Vector_A_dOUT0;
      next_state <= read_x1;
    when extra10 =>
      z6_r_next <= Vector_B_dOUT0;
      next_state <= r1_6;
    when extra11 =>
      z7_r_next <= Vector_B_dOUT0;
      next_state <= r1_7;
    when extra12 =>
      z8_r_next <= Vector_B_dOUT0;
      next_state <= round_part0;
    when extra13 =>
      z1_r_next <= Vector_B_dOUT0;
      next_state <= r2_1;
    when extra14 =>
      z2_r_next <= Vector_B_dOUT0;
      next_state <= r2_2;
    when extra15 =>
      z3_r_next <= Vector_B_dOUT0;
      next_state <= r2_3;
    when extra16 =>
      z4_r_next <= Vector_B_dOUT0;
      next_state <= r2_4;
    when extra17 =>
      z5_r_next <= Vector_B_dOUT0;
      next_state <= r2_5;
    when extra18 =>
      z6_r_next <= Vector_B_dOUT0;
      next_state <= r2_6;
    when extra19 =>
      z7_r_next <= Vector_B_dOUT0;
      next_state <= r2_7;
    when extra2 =>
      x2_next <= Vector_A_dOUT0;
      next_state <= read_x2;
    when extra20 =>
      z8_r_next <= Vector_B_dOUT0;
      next_state <= round_part0;
    when extra21 =>
      z1_r_next <= Vector_B_dOUT0;
      next_state <= r3_1;
    when extra22 =>
      z2_r_next <= Vector_B_dOUT0;
      next_state <= r3_2;
    when extra23 =>
      z3_r_next <= Vector_B_dOUT0;
      next_state <= r3_3;
    when extra24 =>
      z4_r_next <= Vector_B_dOUT0;
      next_state <= r3_4;
    when extra25 =>
      z5_r_next <= Vector_B_dOUT0;
      next_state <= r3_5;
    when extra26 =>
      z6_r_next <= Vector_B_dOUT0;
      next_state <= r3_6;
    when extra27 =>
      z7_r_next <= Vector_B_dOUT0;
      next_state <= r3_7;
    when extra28 =>
      z8_r_next <= Vector_B_dOUT0;
      next_state <= round_part0;
    when extra29 =>
      z1_r_next <= Vector_B_dOUT0;
      next_state <= r4_1;
    when extra3 =>
      x3_next <= Vector_A_dOUT0;
      next_state <= read_x3;
    when extra30 =>
      z2_r_next <= Vector_B_dOUT0;
      next_state <= r4_2;
    when extra31 =>
      z3_r_next <= Vector_B_dOUT0;
      next_state <= r4_3;
    when extra32 =>
      z4_r_next <= Vector_B_dOUT0;
      next_state <= r4_4;
    when extra33 =>
      z5_r_next <= Vector_B_dOUT0;
      next_state <= r4_5;
    when extra34 =>
      z6_r_next <= Vector_B_dOUT0;
      next_state <= r4_6;
    when extra35 =>
      z7_r_next <= Vector_B_dOUT0;
      next_state <= r4_7;
    when extra36 =>
      z8_r_next <= Vector_B_dOUT0;
      next_state <= round_part0;
    when extra37 =>
      z1_r_next <= Vector_B_dOUT0;
      next_state <= r5_1;
    when extra38 =>
      z2_r_next <= Vector_B_dOUT0;
      next_state <= r5_2;
    when extra39 =>
      z3_r_next <= Vector_B_dOUT0;
      next_state <= r5_3;
    when extra4 =>
      r_next <= conv_std_logic_vector(1,DATA_WIDTH);
      x4_next <= Vector_A_dOUT0;
      next_state <= start_round;
    when extra40 =>
      z4_r_next <= Vector_B_dOUT0;
      next_state <= r5_4;
    when extra41 =>
      z5_r_next <= Vector_B_dOUT0;
      next_state <= r5_5;
    when extra42 =>
      z6_r_next <= Vector_B_dOUT0;
      next_state <= r5_6;
    when extra43 =>
      z7_r_next <= Vector_B_dOUT0;
      next_state <= r5_7;
    when extra44 =>
      z8_r_next <= Vector_B_dOUT0;
      next_state <= round_part0;
    when extra45 =>
      z1_r_next <= Vector_B_dOUT0;
      next_state <= r6_1;
    when extra46 =>
      z2_r_next <= Vector_B_dOUT0;
      next_state <= r6_2;
    when extra47 =>
      z3_r_next <= Vector_B_dOUT0;
      next_state <= r6_3;
    when extra48 =>
      z4_r_next <= Vector_B_dOUT0;
      next_state <= r6_4;
    when extra49 =>
      z5_r_next <= Vector_B_dOUT0;
      next_state <= r6_5;
    when extra5 =>
      z1_r_next <= Vector_B_dOUT0;
      next_state <= r1_1;
    when extra50 =>
      z6_r_next <= Vector_B_dOUT0;
      next_state <= r6_6;
    when extra51 =>
      z7_r_next <= Vector_B_dOUT0;
      next_state <= r6_7;
    when extra52 =>
      z8_r_next <= Vector_B_dOUT0;
      next_state <= round_part0;
    when extra53 =>
      z1_r_next <= Vector_B_dOUT0;
      next_state <= r7_1;
    when extra54 =>
      z2_r_next <= Vector_B_dOUT0;
      next_state <= r7_2;
    when extra55 =>
      z3_r_next <= Vector_B_dOUT0;
      next_state <= r7_3;
    when extra56 =>
      z4_r_next <= Vector_B_dOUT0;
      next_state <= r7_4;
    when extra57 =>
      z5_r_next <= Vector_B_dOUT0;
      next_state <= r7_5;
    when extra58 =>
      z6_r_next <= Vector_B_dOUT0;
      next_state <= r7_6;
    when extra59 =>
      z7_r_next <= Vector_B_dOUT0;
      next_state <= r7_7;
    when extra6 =>
      z2_r_next <= Vector_B_dOUT0;
      next_state <= r1_2;
    when extra60 =>
      z8_r_next <= Vector_B_dOUT0;
      next_state <= round_part0;
    when extra61 =>
      z1_r_next <= Vector_B_dOUT0;
      next_state <= r8_1;
    when extra62 =>
      z2_r_next <= Vector_B_dOUT0;
      next_state <= r8_2;
    when extra63 =>
      z3_r_next <= Vector_B_dOUT0;
      next_state <= r8_3;
    when extra64 =>
      z4_r_next <= Vector_B_dOUT0;
      next_state <= r8_4;
    when extra65 =>
      z5_r_next <= Vector_B_dOUT0;
      next_state <= r8_5;
    when extra66 =>
      z6_r_next <= Vector_B_dOUT0;
      next_state <= r8_6;
    when extra67 =>
      z7_r_next <= Vector_B_dOUT0;
      next_state <= r8_7;
    when extra68 =>
      z8_r_next <= Vector_B_dOUT0;
      next_state <= round_part0;
    when extra69 =>
      z1_r_next <= Vector_B_dOUT0;
      next_state <= r9_4;
    when extra7 =>
      z3_r_next <= Vector_B_dOUT0;
      next_state <= r1_3;
    when extra70 =>
      z4_r_next <= Vector_B_dOUT0;
      next_state <= r9_2;
    when extra71 =>
      z2_r_next <= Vector_B_dOUT0;
      next_state <= r9_3;
    when extra72 =>
      z3_r_next <= Vector_B_dOUT0;
      next_state <= pre_calc_results;
    when extra8 =>
      z4_r_next <= Vector_B_dOUT0;
      next_state <= r1_4;
    when extra9 =>
      z5_r_next <= Vector_B_dOUT0;
      next_state <= r1_5;
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
      index_next <= "00000000000000000" & instruction(17 to 31);
      n_next <= "00000000000000000" & instruction(2 to 16);
      op_next <= instruction(0 to 1);
      next_state <= decode;
    when halt =>
      if chan1_full /= '0' then
        next_state <= halt;
      elsif chan1_full = '0' then
        chan1_channelDataIn <= out1;
        chan1_channelWrite <= '1';
        next_state <= fetch;
      end if;
    when next_next_next_result =>
in_Vector_B_addr0 <= i + 3;
      Vector_B_dIN0 <= out4;
      Vector_B_wENA0 <= (others => '1');
      Vector_B_rENA0 <= '1';
      next_state <= halt;
    when next_next_result =>
in_Vector_B_addr0 <= i + 2;
      Vector_B_dIN0 <= out3;
      Vector_B_wENA0 <= (others => '1');
      Vector_B_rENA0 <= '1';
      next_state <= next_next_next_result;
    when next_result =>
in_Vector_B_addr0 <= i + 1;
      Vector_B_dIN0 <= out2;
      Vector_B_wENA0 <= (others => '1');
      Vector_B_rENA0 <= '1';
      next_state <= next_next_result;
    when output_results =>
in_Vector_B_addr0 <= i + 0;
      Vector_B_dIN0 <= out1;
      Vector_B_wENA0 <= (others => '1');
      Vector_B_rENA0 <= '1';
      next_state <= next_result;
    when pre_calc_results =>
      mult_res2_next <= x4 * z4_r;
      mult_res1_next <= x1 * z1_r;
      next_state <= calc_results;
    when r1_1 =>
in_Vector_B_addr0 <= ret + 1;
      Vector_B_rENA0 <= '1';
      next_state <= extra6;
    when r1_2 =>
in_Vector_B_addr0 <= ret + 2;
      Vector_B_rENA0 <= '1';
      next_state <= extra7;
    when r1_3 =>
in_Vector_B_addr0 <= ret + 3;
      Vector_B_rENA0 <= '1';
      next_state <= extra8;
    when r1_4 =>
in_Vector_B_addr0 <= ret + 4;
      Vector_B_rENA0 <= '1';
      next_state <= extra9;
    when r1_5 =>
in_Vector_B_addr0 <= ret + 5;
      Vector_B_rENA0 <= '1';
      next_state <= extra10;
    when r1_6 =>
in_Vector_B_addr0 <= ret + 6;
      Vector_B_rENA0 <= '1';
      next_state <= extra11;
    when r1_7 =>
in_Vector_B_addr0 <= ret + 7;
      Vector_B_rENA0 <= '1';
      next_state <= extra12;
    when r2_1 =>
in_Vector_B_addr0 <= ret + 9;
      Vector_B_rENA0 <= '1';
      next_state <= extra14;
    when r2_2 =>
in_Vector_B_addr0 <= ret + 10;
      Vector_B_rENA0 <= '1';
      next_state <= extra15;
    when r2_3 =>
in_Vector_B_addr0 <= ret + 11;
      Vector_B_rENA0 <= '1';
      next_state <= extra16;
    when r2_4 =>
in_Vector_B_addr0 <= ret + 12;
      Vector_B_rENA0 <= '1';
      next_state <= extra17;
    when r2_5 =>
in_Vector_B_addr0 <= ret + 13;
      Vector_B_rENA0 <= '1';
      next_state <= extra18;
    when r2_6 =>
in_Vector_B_addr0 <= ret + 14;
      Vector_B_rENA0 <= '1';
      next_state <= extra19;
    when r2_7 =>
in_Vector_B_addr0 <= ret + 15;
      Vector_B_rENA0 <= '1';
      next_state <= extra20;
    when r3_1 =>
in_Vector_B_addr0 <= ret + 17;
      Vector_B_rENA0 <= '1';
      next_state <= extra22;
    when r3_2 =>
in_Vector_B_addr0 <= ret + 18;
      Vector_B_rENA0 <= '1';
      next_state <= extra23;
    when r3_3 =>
in_Vector_B_addr0 <= ret + 19;
      Vector_B_rENA0 <= '1';
      next_state <= extra24;
    when r3_4 =>
in_Vector_B_addr0 <= ret + 20;
      Vector_B_rENA0 <= '1';
      next_state <= extra25;
    when r3_5 =>
in_Vector_B_addr0 <= ret + 21;
      Vector_B_rENA0 <= '1';
      next_state <= extra26;
    when r3_6 =>
in_Vector_B_addr0 <= ret + 22;
      Vector_B_rENA0 <= '1';
      next_state <= extra27;
    when r3_7 =>
in_Vector_B_addr0 <= ret + 23;
      Vector_B_rENA0 <= '1';
      next_state <= extra28;
    when r4_1 =>
in_Vector_B_addr0 <= ret + 25;
      Vector_B_rENA0 <= '1';
      next_state <= extra30;
    when r4_2 =>
in_Vector_B_addr0 <= ret + 26;
      Vector_B_rENA0 <= '1';
      next_state <= extra31;
    when r4_3 =>
in_Vector_B_addr0 <= ret + 27;
      Vector_B_rENA0 <= '1';
      next_state <= extra32;
    when r4_4 =>
in_Vector_B_addr0 <= ret + 28;
      Vector_B_rENA0 <= '1';
      next_state <= extra33;
    when r4_5 =>
in_Vector_B_addr0 <= ret + 29;
      Vector_B_rENA0 <= '1';
      next_state <= extra34;
    when r4_6 =>
in_Vector_B_addr0 <= ret + 30;
      Vector_B_rENA0 <= '1';
      next_state <= extra35;
    when r4_7 =>
in_Vector_B_addr0 <= ret + 31;
      Vector_B_rENA0 <= '1';
      next_state <= extra36;
    when r5_1 =>
in_Vector_B_addr0 <= ret + 33;
      Vector_B_rENA0 <= '1';
      next_state <= extra38;
    when r5_2 =>
in_Vector_B_addr0 <= ret + 34;
      Vector_B_rENA0 <= '1';
      next_state <= extra39;
    when r5_3 =>
in_Vector_B_addr0 <= ret + 35;
      Vector_B_rENA0 <= '1';
      next_state <= extra40;
    when r5_4 =>
in_Vector_B_addr0 <= ret + 36;
      Vector_B_rENA0 <= '1';
      next_state <= extra41;
    when r5_5 =>
in_Vector_B_addr0 <= ret + 37;
      Vector_B_rENA0 <= '1';
      next_state <= extra42;
    when r5_6 =>
in_Vector_B_addr0 <= ret + 38;
      Vector_B_rENA0 <= '1';
      next_state <= extra43;
    when r5_7 =>
in_Vector_B_addr0 <= ret + 39;
      Vector_B_rENA0 <= '1';
      next_state <= extra44;
    when r6_1 =>
in_Vector_B_addr0 <= ret + 41;
      Vector_B_rENA0 <= '1';
      next_state <= extra46;
    when r6_2 =>
in_Vector_B_addr0 <= ret + 42;
      Vector_B_rENA0 <= '1';
      next_state <= extra47;
    when r6_3 =>
in_Vector_B_addr0 <= ret + 43;
      Vector_B_rENA0 <= '1';
      next_state <= extra48;
    when r6_4 =>
in_Vector_B_addr0 <= ret + 44;
      Vector_B_rENA0 <= '1';
      next_state <= extra49;
    when r6_5 =>
in_Vector_B_addr0 <= ret + 45;
      Vector_B_rENA0 <= '1';
      next_state <= extra50;
    when r6_6 =>
in_Vector_B_addr0 <= ret + 46;
      Vector_B_rENA0 <= '1';
      next_state <= extra51;
    when r6_7 =>
in_Vector_B_addr0 <= ret + 47;
      Vector_B_rENA0 <= '1';
      next_state <= extra52;
    when r7_1 =>
in_Vector_B_addr0 <= ret + 49;
      Vector_B_rENA0 <= '1';
      next_state <= extra54;
    when r7_2 =>
in_Vector_B_addr0 <= ret + 50;
      Vector_B_rENA0 <= '1';
      next_state <= extra55;
    when r7_3 =>
in_Vector_B_addr0 <= ret + 51;
      Vector_B_rENA0 <= '1';
      next_state <= extra56;
    when r7_4 =>
in_Vector_B_addr0 <= ret + 52;
      Vector_B_rENA0 <= '1';
      next_state <= extra57;
    when r7_5 =>
in_Vector_B_addr0 <= ret + 53;
      Vector_B_rENA0 <= '1';
      next_state <= extra58;
    when r7_6 =>
in_Vector_B_addr0 <= ret + 54;
      Vector_B_rENA0 <= '1';
      next_state <= extra59;
    when r7_7 =>
in_Vector_B_addr0 <= ret + 55;
      Vector_B_rENA0 <= '1';
      next_state <= extra60;
    when r8_1 =>
in_Vector_B_addr0 <= ret + 57;
      Vector_B_rENA0 <= '1';
      next_state <= extra62;
    when r8_2 =>
in_Vector_B_addr0 <= ret + 58;
      Vector_B_rENA0 <= '1';
      next_state <= extra63;
    when r8_3 =>
in_Vector_B_addr0 <= ret + 59;
      Vector_B_rENA0 <= '1';
      next_state <= extra64;
    when r8_4 =>
in_Vector_B_addr0 <= ret + 60;
      Vector_B_rENA0 <= '1';
      next_state <= extra65;
    when r8_5 =>
in_Vector_B_addr0 <= ret + 61;
      Vector_B_rENA0 <= '1';
      next_state <= extra66;
    when r8_6 =>
in_Vector_B_addr0 <= ret + 62;
      Vector_B_rENA0 <= '1';
      next_state <= extra67;
    when r8_7 =>
in_Vector_B_addr0 <= ret + 63;
      Vector_B_rENA0 <= '1';
      next_state <= extra68;
    when r9_2 =>
in_Vector_B_addr0 <= ret + 65;
      Vector_B_rENA0 <= '1';
      next_state <= extra71;
    when r9_3 =>
in_Vector_B_addr0 <= ret + 66;
      Vector_B_rENA0 <= '1';
      next_state <= extra72;
    when r9_4 =>
in_Vector_B_addr0 <= ret + 67;
      Vector_B_rENA0 <= '1';
      next_state <= extra70;
    when read_x1 =>
in_Vector_A_addr0 <= i + 1;
      Vector_A_rENA0 <= '1';
      next_state <= extra2;
    when read_x2 =>
in_Vector_A_addr0 <= i + 2;
      Vector_A_rENA0 <= '1';
      next_state <= extra3;
    when read_x3 =>
in_Vector_A_addr0 <= i + 3;
      Vector_A_rENA0 <= '1';
      next_state <= extra4;
    when reset =>
      next_state <= fetch;
    when round_part0 =>
      mult_res2_next <= x4 * z4_r;
      mult_res1_next <= x1 * z1_r;
      next_state <= round_part1;
    when round_part1 =>
      x4_next <= mul(x4,z4_r,mult_res2(32 to 63));
      x3_next <= ( x3 + z3_r ) and one;
      x2_next <= ( x2 + z2_r ) and one;
      x1_next <= mul(x1,z1_r,mult_res1(32 to 63));
      next_state <= round_part2;
    when round_part2 =>
      mult_res1_next <= z5_r * ( x1 xor x3 );
      kk_next <= ( x1 xor x3 );
      next_state <= round_part3;
    when round_part3 =>
      kk_next <= mul(z5_r,kk,mult_res1(32 to 63));
      next_state <= round_part4;
    when round_part4 =>
      mult_res1_next <= z6_r * ( ( kk + ( x2 xor x4 ) ) and one );
      t1_next <= ( kk + ( x2 xor x4 ) ) and one;
      next_state <= round_part5;
    when round_part5 =>
      t1_next <= mul(z6_r,t1,mult_res1(32 to 63));
      next_state <= round_part6;
    when round_part6 =>
      t2_next <= ( kk + t1 ) and one;
      next_state <= round_part7;
    when round_part7 =>
      x3_next <= x2 xor t2;
      a_next <= x2 xor t2;
      x4_next <= x4 xor t2;
      x2_next <= x3 xor t1;
      x1_next <= x1 xor t1;
      next_state <= round_part8;
    when round_part8 =>
      r_next <= r + 1;
      next_state <= start_round;
    when start_round =>
      if ( r = 1 ) then
in_Vector_B_addr0 <= ret + 0;
        Vector_B_rENA0 <= '1';
        next_state <= extra5;
      elsif ( r = 2 ) then
in_Vector_B_addr0 <= ret + 8;
        Vector_B_rENA0 <= '1';
        next_state <= extra13;
      elsif ( r = 3 ) then
in_Vector_B_addr0 <= ret + 16;
        Vector_B_rENA0 <= '1';
        next_state <= extra21;
      elsif ( r = 4 ) then
in_Vector_B_addr0 <= ret + 24;
        Vector_B_rENA0 <= '1';
        next_state <= extra29;
      elsif ( r = 5 ) then
in_Vector_B_addr0 <= ret + 32;
        Vector_B_rENA0 <= '1';
        next_state <= extra37;
      elsif ( r = 6 ) then
in_Vector_B_addr0 <= ret + 40;
        Vector_B_rENA0 <= '1';
        next_state <= extra45;
      elsif ( r = 7 ) then
in_Vector_B_addr0 <= ret + 48;
        Vector_B_rENA0 <= '1';
        next_state <= extra53;
      elsif ( r = 8 ) then
in_Vector_B_addr0 <= ret + 56;
        Vector_B_rENA0 <= '1';
        next_state <= extra61;
      else
in_Vector_B_addr0 <= ret + 64;
        Vector_B_rENA0 <= '1';
        next_state <= extra69;
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

