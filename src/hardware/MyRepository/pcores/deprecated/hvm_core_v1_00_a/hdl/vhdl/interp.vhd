-- ************************************
-- Automatically Generated FSM
-- interp
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
entity interp is
generic(
  DATA_BITS : integer := 32;
  REG_FILE_ADDR_BITS : integer := 8;
  MEMORY_ADDR_BITS : integer := 32;
  RESERVED_REG_START : integer := 128;
  RESERVED_REG_STOP : integer := 255;
  PC_REG_ADDR : integer := 195;
  OPCODE_START : integer := 0;
  OPCODE_TYPE_BITS : integer := 4;
  OPCODE_BITS : integer := 8;
  R_DEST_START : integer := 8;
  R_DEST_BITS : integer := 8;
  R_ARG_A_START : integer := 16;
  R_ARG_A_BITS : integer := 8;
  R_ARG_B_START : integer := 24;
  R_ARG_B_BITS : integer := 8
);
port
(
  prog_mem_addr0 : out std_logic_vector(0 to (MEMORY_ADDR_BITS - 1));
  prog_mem_dIN0 : out std_logic_vector(0 to (DATA_BITS - 1));
  prog_mem_dOUT0 : in std_logic_vector(0 to (DATA_BITS - 1));
  prog_mem_rENA0 : out std_logic;
  prog_mem_wENA0 : out std_logic;
  state_mem_addr0 : out std_logic_vector(0 to (REG_FILE_ADDR_BITS - 1));
  state_mem_dIN0 : out std_logic_vector(0 to (DATA_BITS - 1));
  state_mem_dOUT0 : in std_logic_vector(0 to (DATA_BITS - 1));
  state_mem_rENA0 : out std_logic;
  state_mem_wENA0 : out std_logic;


  go : in std_logic;
  mode : in std_logic_vector(0 to 1);
  done : out std_logic;

  clock_sig : in std_logic;
  reset_sig : in std_logic
  );
end entity interp;

-- *************************
-- Architecture Definition
-- *************************
architecture IMPLEMENTATION of interp is

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
begin_export_state,
export_state,
extra1,
extra2,
extra3,
extra4,
store_pc,
fetch,
begin_import_state,
import_state,
extra5,
extra6,
extra7,
extra8,
restore_pc,
extra9,
extra10,
extra11,
extra12,
decode,
extra13,
extra14,
do_arithmetic,
extra15,
extra16,
do_other,
writeback,
extra17,
extra18,
load_lo,
extra19,
extra20,
load_hi,
extra21,
extra22,
memory,
extra23,
extra24,
grab_multiply,
reset,
initRegFile
);
signal current_state,next_state: STATE_MACHINE_TYPE :=reset;

-- ****************************************************
-- Type definitions for FSM signals
-- ****************************************************
signal pc, pc_next : std_logic_vector(0 to MEMORY_ADDR_BITS - 1);
signal instr, instr_next : std_logic_vector(0 to DATA_BITS - 1);
signal a, a_next : std_logic_vector(0 to DATA_BITS - 1);
signal b, b_next : std_logic_vector(0 to DATA_BITS - 1);
signal c, c_next : std_logic_vector(0 to DATA_BITS - 1);
signal d, d_next : std_logic_vector(0 to DATA_BITS - 1);
signal offset, offset_next : std_logic_vector(0 to DATA_BITS - 1);
signal mult_res, mult_res_next : std_logic_vector(0 to DATA_BITS * 2 - 1);
signal reg_counter, reg_counter_next : std_logic_vector(0 to REG_FILE_ADDR_BITS - 1);
signal halt, halt_next : std_logic;

-- **************************
-- BRAM Signals for regfile
-- **************************
signal regfile_addr0 : std_logic_vector(0 to (REG_FILE_ADDR_BITS - 1));
signal regfile_dIN0 : std_logic_vector(0 to (DATA_BITS - 1));
signal regfile_dOUT0 : std_logic_vector(0 to (DATA_BITS - 1));
signal regfile_rENA0 : std_logic;
signal regfile_wENA0 : std_logic;
signal regfile_addr1 : std_logic_vector(0 to (REG_FILE_ADDR_BITS - 1));
signal regfile_dIN1 : std_logic_vector(0 to (DATA_BITS - 1));
signal regfile_dOUT1 : std_logic_vector(0 to (DATA_BITS - 1));
signal regfile_rENA1 : std_logic;
signal regfile_wENA1 : std_logic;


-- ****************************************************
-- User-defined VHDL Section
-- ****************************************************
constant HALFPOINT : integer := DATA_BITS/2;

-- Command modes
-- **************************************************
constant CMD_HALT           : std_logic_vector(0 to 1) := "00";
constant CMD_IMPORT_STATE   : std_logic_vector(0 to 1) := "01";
constant CMD_EXPORT_STATE   : std_logic_vector(0 to 1) := "10";
constant CMD_INTERPRET      : std_logic_vector(0 to 1) := "11";

-- Instruction OPCODES TYPES
-- **************************************************
constant TYPE_ARITHMETIC    : std_logic_vector(0 to OPCODE_TYPE_BITS-1) := conv_std_logic_vector(0, OPCODE_TYPE_BITS);
constant TYPE_OTHER         : std_logic_vector(0 to OPCODE_TYPE_BITS-1) := conv_std_logic_vector(1, OPCODE_TYPE_BITS);

-- Instruction OPCODES
-- **************************************************
constant OPCODE_ADD         : std_logic_vector(0 to OPCODE_BITS-1) := conv_std_logic_vector(0, OPCODE_BITS);
constant OPCODE_SUB         : std_logic_vector(0 to OPCODE_BITS-1) := conv_std_logic_vector(1, OPCODE_BITS);
constant OPCODE_MULT        : std_logic_vector(0 to OPCODE_BITS-1) := conv_std_logic_vector(2, OPCODE_BITS);
constant OPCODE_AND         : std_logic_vector(0 to OPCODE_BITS-1) := conv_std_logic_vector(3, OPCODE_BITS);
constant OPCODE_OR          : std_logic_vector(0 to OPCODE_BITS-1) := conv_std_logic_vector(4, OPCODE_BITS);
constant OPCODE_XOR         : std_logic_vector(0 to OPCODE_BITS-1) := conv_std_logic_vector(5, OPCODE_BITS);
constant OPCODE_SHRA        : std_logic_vector(0 to OPCODE_BITS-1) := conv_std_logic_vector(6, OPCODE_BITS);
constant OPCODE_SHRL        : std_logic_vector(0 to OPCODE_BITS-1) := conv_std_logic_vector(7, OPCODE_BITS);
constant OPCODE_SHL         : std_logic_vector(0 to OPCODE_BITS-1) := conv_std_logic_vector(8, OPCODE_BITS);

constant OPCODE_LOAD_IMM    : std_logic_vector(0 to OPCODE_BITS-1) := conv_std_logic_vector(16, OPCODE_BITS);
constant OPCODE_JEZ         : std_logic_vector(0 to OPCODE_BITS-1) := conv_std_logic_vector(17, OPCODE_BITS);
constant OPCODE_LOAD        : std_logic_vector(0 to OPCODE_BITS-1) := conv_std_logic_vector(18, OPCODE_BITS);
constant OPCODE_STORE       : std_logic_vector(0 to OPCODE_BITS-1) := conv_std_logic_vector(19, OPCODE_BITS);
constant OPCODE_LOAD_LO     : std_logic_vector(0 to OPCODE_BITS-1) := conv_std_logic_vector(20, OPCODE_BITS);
constant OPCODE_LOAD_HI     : std_logic_vector(0 to OPCODE_BITS-1) := conv_std_logic_vector(21, OPCODE_BITS);

-- Amount to increase PC on "normal" instructions
-- **************************************************
constant pcInc : std_logic_vector(0 to MEMORY_ADDR_BITS-1) := conv_std_logic_vector(4, MEMORY_ADDR_BITS);
constant PC_HALT : std_logic_vector(0 to MEMORY_ADDR_BITS-1) := (others => '1');
constant pcStore : std_logic_vector(0 to REG_FILE_ADDR_BITS-1) := conv_std_logic_vector(PC_REG_ADDR, REG_FILE_ADDR_BITS);

-- Aliases for instruction decode:
-- *************************************
-- Opcode-type of the current instruction
alias opcode_type is instr(OPCODE_START to (OPCODE_START+OPCODE_TYPE_BITS-1));

-- Opcode of the current instruction
alias opcode is instr(OPCODE_START to (OPCODE_START+OPCODE_BITS-1));

-- Register destination
alias r_dest is instr(R_DEST_START to (R_DEST_START+R_DEST_BITS-1));

-- Test register (for compares)
alias r_compare_test is instr(R_DEST_START to (R_DEST_START+R_DEST_BITS-1));

-- Register argument A
alias r_arg_a is instr(R_ARG_A_START to (R_ARG_A_START+R_ARG_A_BITS-1));

-- Register argument B
alias r_arg_b is instr(R_ARG_B_START to (R_ARG_B_START+R_ARG_B_BITS-1));

-- Immediate value
constant immediate_pad_length : integer := DATA_BITS-R_ARG_A_BITS-R_ARG_B_BITS;
constant immediate_zero_pad : std_logic_vector(0 to immediate_pad_length -1 ) := conv_std_logic_vector(0, immediate_pad_length); 
alias immediate_value is instr(R_ARG_A_START to (R_ARG_A_START+R_ARG_A_BITS+R_ARG_B_BITS-1));

-- Architecture Section
begin

-- ************************
-- Permanent Connections
-- ************************
done <= halt; 


-- ************************
-- BRAM implementations
-- ************************
regfile_BRAM : infer_bram
generic map (
  ADDRESS_BITS => REG_FILE_ADDR_BITS,
  DATA_BITS => DATA_BITS
)
port map (
  CLKA  => clock_sig,
  ENA   => regfile_rENA0,
  WEA   => regfile_wENA0,
  ADDRA => regfile_addr0,
  DIA   => regfile_dIN0,
  DOA   => regfile_dOUT0,
  CLKB  => clock_sig,
  ENB   => regfile_rENA1,
  WEB   => regfile_wENA1,
  ADDRB => regfile_addr1,
  DIB   => regfile_dIN1,
  DOB   => regfile_dOUT1
);


-- ****************************************************
-- Process to handle the synchronous portion of an FSM
-- ****************************************************
FSM_SYNC_PROCESS : process(
  pc_next,
  instr_next,
  a_next,
  b_next,
  c_next,
  d_next,
  offset_next,
  mult_res_next,
  reg_counter_next,
  halt_next,

  next_state,
  clock_sig, reset_sig) is
begin
  if (clock_sig'event and clock_sig = '1') then
    if (reset_sig = '1') then
    -- Reset all FSM signals, and enter the initial state
      pc <= (others => '0');
      instr <= (others => '0');
      a <= (others => '0');
      b <= (others => '0');
      c <= (others => '0');
      d <= (others => '0');
      offset <= (others => '0');
      mult_res <= (others => '0');
      reg_counter <= (others => '0');
      halt <= '0';

      current_state <= reset;
    else
    -- Transition to next state
      pc <= pc_next;
      instr <= instr_next;
      a <= a_next;
      b <= b_next;
      c <= c_next;
      d <= d_next;
      offset <= offset_next;
      mult_res <= mult_res_next;
      reg_counter <= reg_counter_next;
      halt <= halt_next;

      current_state <= next_state;
    end if;
  end if;
end process FSM_SYNC_PROCESS;

-- ************************************************************************
-- Process to handle the asynchronous (combinational) portion of an FSM
-- ************************************************************************
FSM_COMB_PROCESS : process(
  regfile_dOUT0, regfile_dOUT1,
  prog_mem_dOUT0,
  state_mem_dOUT0,


  go,
  mode,

  pc,
  instr,
  a,
  b,
  c,
  d,
  offset,
  mult_res,
  reg_counter,
  halt,

  current_state) is
begin
  -- Default signal assignments
  pc_next <= pc;
  instr_next <= instr;
  a_next <= a;
  b_next <= b;
  c_next <= c;
  d_next <= d;
  offset_next <= offset;
  mult_res_next <= mult_res;
  reg_counter_next <= reg_counter;
  halt_next <= halt;

  regfile_addr0 <= (others => '0');
  regfile_dIN0  <= (others => '0');
  regfile_rENA0 <= '0';
  regfile_wENA0 <= '0';
  regfile_addr1 <= (others => '0');
  regfile_dIN1  <= (others => '0');
  regfile_rENA1 <= '0';
  regfile_wENA1 <= '0';

  prog_mem_addr0 <= (others => '0');
  prog_mem_dIN0  <= (others => '0');
  prog_mem_rENA0 <= '0';
  prog_mem_wENA0 <= '0';

  state_mem_addr0 <= (others => '0');
  state_mem_dIN0  <= (others => '0');
  state_mem_rENA0 <= '0';
  state_mem_wENA0 <= '0';



  next_state <= current_state;

  -- FSM logic
  case (current_state) is

    when begin_export_state =>
      halt_next <= '0';
      reg_counter_next <= conv_std_logic_vector(RESERVED_REG_STOP,REG_FILE_ADDR_BITS);
      next_state <= export_state;
    when begin_import_state =>
      halt_next <= '0';
      reg_counter_next <= conv_std_logic_vector(RESERVED_REG_STOP,REG_FILE_ADDR_BITS);
      next_state <= import_state;
    when decode =>
      if ( opcode_type = TYPE_ARITHMETIC ) then
        regfile_addr0 <= r_arg_b;
        regfile_rENA0 <= '1';
        regfile_addr1 <= r_arg_a;
        regfile_rENA1 <= '1';
        next_state <= extra13;
      elsif ( opcode_type = TYPE_OTHER ) then
        regfile_addr0 <= r_dest;
        regfile_rENA0 <= '1';
        regfile_addr1 <= r_arg_a;
        regfile_rENA1 <= '1';
        next_state <= extra15;
      end if;
    when do_arithmetic =>
      if ( opcode = OPCODE_ADD ) then
        regfile_addr0 <= r_dest;
        regfile_dIN0 <= a + b;
        regfile_wENA0 <= '1';
        regfile_rENA0 <= '1';
        next_state <= writeback;
      elsif ( opcode = OPCODE_SUB ) then
        regfile_addr0 <= r_dest;
        regfile_dIN0 <= a - b;
        regfile_wENA0 <= '1';
        regfile_rENA0 <= '1';
        next_state <= writeback;
      elsif ( opcode = OPCODE_MULT ) then
        mult_res_next <= a * b;
        next_state <= grab_multiply;
      elsif ( opcode = OPCODE_AND ) then
        regfile_addr0 <= r_dest;
        regfile_dIN0 <= a and b;
        regfile_wENA0 <= '1';
        regfile_rENA0 <= '1';
        next_state <= writeback;
      elsif ( opcode = OPCODE_OR ) then
        regfile_addr0 <= r_dest;
        regfile_dIN0 <= a or b;
        regfile_wENA0 <= '1';
        regfile_rENA0 <= '1';
        next_state <= writeback;
      elsif ( opcode = OPCODE_XOR ) then
        regfile_addr0 <= r_dest;
        regfile_dIN0 <= a xor b;
        regfile_wENA0 <= '1';
        regfile_rENA0 <= '1';
        next_state <= writeback;
      elsif ( opcode = OPCODE_SHRA ) then
        regfile_addr0 <= r_dest;
        regfile_dIN0 <= a(0) & a(0 to DATA_BITS - 2);
        regfile_wENA0 <= '1';
        regfile_rENA0 <= '1';
        next_state <= writeback;
      elsif ( opcode = OPCODE_SHRL ) then
        regfile_addr0 <= r_dest;
        regfile_dIN0 <= '0' & a(0 to DATA_BITS - 2);
        regfile_wENA0 <= '1';
        regfile_rENA0 <= '1';
        next_state <= writeback;
      elsif ( opcode = OPCODE_SHL ) then
        regfile_addr0 <= r_dest;
        regfile_dIN0 <= a(1 to DATA_BITS - 1) & '0';
        regfile_wENA0 <= '1';
        regfile_rENA0 <= '1';
        next_state <= writeback;
      end if;
    when do_other =>
      if ( opcode = OPCODE_LOAD_IMM ) then
        regfile_addr0 <= r_dest;
        regfile_dIN0 <= immediate_zero_pad & immediate_value;
        regfile_wENA0 <= '1';
        regfile_rENA0 <= '1';
        next_state <= writeback;
      elsif ( opcode = OPCODE_LOAD_LO ) then
        regfile_addr0 <= r_dest;
        regfile_rENA0 <= '1';
        next_state <= extra17;
      elsif ( opcode = OPCODE_LOAD_HI ) then
        regfile_addr0 <= r_dest;
        regfile_rENA0 <= '1';
        next_state <= extra19;
      elsif ( opcode = OPCODE_JEZ and c /= 0 ) then
        next_state <= writeback;
      elsif ( opcode = OPCODE_JEZ and c = 0 ) then
        pc_next <= a;
        regfile_addr0 <= pcStore;
        regfile_dIN0 <= a;
        regfile_wENA0 <= '1';
        regfile_rENA0 <= '1';
        next_state <= fetch;
      elsif ( opcode = OPCODE_LOAD ) or ( opcode = OPCODE_STORE ) then
        regfile_addr0 <= r_arg_b;
        regfile_rENA0 <= '1';
        next_state <= extra21;
      end if;
    when export_state =>
      if ( reg_counter > 0 ) then
        regfile_addr0 <= reg_counter;
        regfile_rENA0 <= '1';
        next_state <= extra1;
      elsif ( reg_counter = 0 ) then
        regfile_addr0 <= reg_counter;
        regfile_rENA0 <= '1';
        next_state <= extra3;
      end if;
    when extra1 =>
      next_state <= extra2;
    when extra10 =>
      regfile_addr0 <= pcStore;
      regfile_dIN0 <= state_mem_dOUT0;
      regfile_wENA0 <= '1';
      regfile_rENA0 <= '1';
      pc_next <= state_mem_dOUT0;
      next_state <= fetch;
    when extra11 =>
      next_state <= extra12;
    when extra12 =>
      instr_next <= prog_mem_dOUT0;
      next_state <= decode;
    when extra13 =>
      next_state <= extra14;
    when extra14 =>
      b_next <= regfile_dOUT0;
      a_next <= regfile_dOUT1;
      halt_next <= '0';
      next_state <= do_arithmetic;
    when extra15 =>
      next_state <= extra16;
    when extra16 =>
      c_next <= regfile_dOUT0;
      a_next <= regfile_dOUT1;
      next_state <= do_other;
    when extra17 =>
      next_state <= extra18;
    when extra18 =>
      d_next <= regfile_dOUT0;
      next_state <= load_lo;
    when extra19 =>
      next_state <= extra20;
    when extra2 =>
      reg_counter_next <= reg_counter - 1;
      state_mem_addr0 <= reg_counter;
      state_mem_dIN0 <= regfile_dOUT0;
      state_mem_wENA0 <= '1';
      state_mem_rENA0 <= '1';
      next_state <= export_state;
    when extra20 =>
      d_next <= regfile_dOUT0;
      next_state <= load_hi;
    when extra21 =>
      next_state <= extra22;
    when extra22 =>
      offset_next <= regfile_dOUT0;
      next_state <= memory;
    when extra23 =>
      next_state <= extra24;
    when extra24 =>
      regfile_addr0 <= r_dest;
      regfile_dIN0 <= prog_mem_dOUT0;
      regfile_wENA0 <= '1';
      regfile_rENA0 <= '1';
      next_state <= writeback;
    when extra3 =>
      next_state <= extra4;
    when extra4 =>
      state_mem_addr0 <= reg_counter;
      state_mem_dIN0 <= regfile_dOUT0;
      state_mem_wENA0 <= '1';
      state_mem_rENA0 <= '1';
      next_state <= store_pc;
    when extra5 =>
      next_state <= extra6;
    when extra6 =>
      reg_counter_next <= reg_counter - 1;
      regfile_addr0 <= reg_counter;
      regfile_dIN0 <= state_mem_dOUT0;
      regfile_wENA0 <= '1';
      regfile_rENA0 <= '1';
      next_state <= import_state;
    when extra7 =>
      next_state <= extra8;
    when extra8 =>
      regfile_addr0 <= reg_counter;
      regfile_dIN0 <= state_mem_dOUT0;
      regfile_wENA0 <= '1';
      regfile_rENA0 <= '1';
      next_state <= restore_pc;
    when extra9 =>
      next_state <= extra10;
    when fetch =>
      if ( go = '0' ) then
        next_state <= fetch;
      elsif ( go = '1' and mode = CMD_HALT ) then
        next_state <= fetch;
      elsif ( go = '1' and mode = CMD_EXPORT_STATE ) then
        next_state <= begin_export_state;
      elsif ( go = '1' and mode = CMD_IMPORT_STATE ) then
        next_state <= begin_import_state;
      elsif ( go = '1' and mode = CMD_INTERPRET and pc = PC_HALT ) then
        halt_next <= '1';
        next_state <= fetch;
      elsif ( go = '1' and mode = CMD_INTERPRET ) then
        prog_mem_addr0 <= pc;
        prog_mem_rENA0 <= '1';
        next_state <= extra11;
      end if;
    when grab_multiply =>
      regfile_addr0 <= r_dest;
      regfile_dIN0 <= mult_res(DATA_BITS to DATA_BITS * 2 - 1);
      regfile_wENA0 <= '1';
      regfile_rENA0 <= '1';
      next_state <= writeback;
    when import_state =>
      if ( reg_counter > 0 ) then
        state_mem_addr0 <= reg_counter;
        state_mem_rENA0 <= '1';
        next_state <= extra5;
      elsif ( reg_counter = 0 ) then
        state_mem_addr0 <= reg_counter;
        state_mem_rENA0 <= '1';
        next_state <= extra7;
      end if;
    when initRegFile =>
      if ( reg_counter < RESERVED_REG_STOP ) then
        regfile_addr0 <= reg_counter;
        regfile_dIN0 <= c;
        regfile_wENA0 <= '1';
        regfile_rENA0 <= '1';
        reg_counter_next <= reg_counter + 1;
        c_next <= c + 1;
        next_state <= initRegFile;
      elsif ( reg_counter = RESERVED_REG_STOP ) then
        regfile_addr0 <= reg_counter;
        regfile_dIN0 <= c;
        regfile_wENA0 <= '1';
        regfile_rENA0 <= '1';
        pc_next <= conv_std_logic_vector(0,MEMORY_ADDR_BITS);
        regfile_addr0 <= pcStore;
        regfile_dIN0 <= conv_std_logic_vector(0,MEMORY_ADDR_BITS);
        regfile_wENA0 <= '1';
        regfile_rENA0 <= '1';
        next_state <= fetch;
      end if;
    when load_hi =>
      regfile_addr0 <= r_dest;
      regfile_dIN0 <= immediate_value & d(HALFPOINT to DATA_BITS - 1);
      regfile_wENA0 <= '1';
      regfile_rENA0 <= '1';
      next_state <= writeback;
    when load_lo =>
      regfile_addr0 <= r_dest;
      regfile_dIN0 <= d(0 to HALFPOINT - 1) & immediate_value;
      regfile_wENA0 <= '1';
      regfile_rENA0 <= '1';
      next_state <= writeback;
    when memory =>
      if ( opcode = OPCODE_LOAD ) then
        prog_mem_addr0 <= a + offset;
        prog_mem_rENA0 <= '1';
        next_state <= extra23;
      elsif ( opcode = OPCODE_STORE ) then
        prog_mem_addr0 <= a + offset;
        prog_mem_dIN0 <= c;
        prog_mem_wENA0 <= '1';
        prog_mem_rENA0 <= '1';
        next_state <= writeback;
      end if;
    when reset =>
      halt_next <= '0';
      c_next <= conv_std_logic_vector(0,DATA_BITS);
      reg_counter_next <= conv_std_logic_vector(0,REG_FILE_ADDR_BITS);
      next_state <= initRegFile;
    when restore_pc =>
      state_mem_addr0 <= pcStore;
      state_mem_rENA0 <= '1';
      next_state <= extra9;
    when store_pc =>
      state_mem_addr0 <= pcStore;
      state_mem_dIN0 <= pc;
      state_mem_wENA0 <= '1';
      state_mem_rENA0 <= '1';
      next_state <= fetch;
    when writeback =>
      pc_next <= pc + pcInc;
      regfile_addr0 <= pcStore;
      regfile_dIN0 <= pc + pcInc;
      regfile_wENA0 <= '1';
      regfile_rENA0 <= '1';
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

