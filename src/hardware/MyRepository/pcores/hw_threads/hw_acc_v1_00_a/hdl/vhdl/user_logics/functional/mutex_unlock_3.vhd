---------------------------------------------------------------------------
--
--  Title: Hardware Thread User Logic Exit Thread
--  To be used as a place holder, and size estimate for HWTI
--
---------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_misc.all;

library Unisim;
use Unisim.all;

---------------------------------------------------------------------------
-- Port declarations
---------------------------------------------------------------------------
-- Definition of Ports:
--
--  Misc. Signals
--    clock
--
--  HWTI to HWTUL interconnect
--    intrfc2thrd_address      32 bits   memory    
--    intrfc2thrd_value        32 bits   memory    function
--    intrfc2thrd_function     16 bits                       control
--    intrfc2thrd_goWait        1 bits                       control
--
--  HWTUL to HWTI interconnect
--    thrd2intrfc_address      32 bits   memory
--    thrd2intrfc_value        32 bits   memory    function
--    thrd2intrfc_function     16 bits             function
--    thrd2intrfc_opcode        6 bits   memory    function
--


---------------------------------------------------------------------------
-- Thread Manager Entity section
---------------------------------------------------------------------------

entity user_logic_hwtul is
  port (
    clock : in std_logic;
    intrfc2thrd_address : in std_logic_vector(0 to 31);
    intrfc2thrd_value : in std_logic_vector(0 to 31);
    intrfc2thrd_function : in std_logic_vector(0 to 15);
    intrfc2thrd_goWait : in std_logic;

    thrd2intrfc_address : out std_logic_vector(0 to 31);
    thrd2intrfc_value : out std_logic_vector(0 to 31);
    thrd2intrfc_function : out std_logic_vector(0 to 15);
    thrd2intrfc_opcode : out std_logic_vector(0 to 5)
  );
end entity user_logic_hwtul;

---------------------------------------------------------------------------
-- Architecture section
---------------------------------------------------------------------------

architecture IMP of user_logic_hwtul is

---------------------------------------------------------------------------
-- Signal declarations
---------------------------------------------------------------------------

  type state_machine is (
    FUNCTION_RESET,
    FUNCTION_USER_SELECT,
    FUNCTION_START,
    FUNCTION_EXIT,
    STATE_1,
    STATE_2,
    STATE_3,
    STATE_4,
    STATE_5,
    STATE_6,
    STATE_7,
    STATE_8,
    STATE_9,
    STATE_10,
    STATE_11,
    STATE_12,
    STATE_13,
    STATE_14,
    STATE_15,
    STATE_16,
    STATE_17,
    STATE_18,
    STATE_19,
    STATE_20,
    WAIT_STATE,
    ERROR_STATE);

  -- Function definitions
  constant U_FUNCTION_RESET                      : std_logic_vector(0 to 15) := x"0000";
  constant U_FUNCTION_WAIT                       : std_logic_vector(0 to 15) := x"0001";
  constant U_FUNCTION_USER_SELECT                : std_logic_vector(0 to 15) := x"0002";
  constant U_FUNCTION_START                      : std_logic_vector(0 to 15) := x"0003";
  constant U_STATE_1                             : std_logic_vector(0 to 15) := x"0101";
  constant U_STATE_2                             : std_logic_vector(0 to 15) := x"0102";
  constant U_STATE_3                             : std_logic_vector(0 to 15) := x"0103";
  constant U_STATE_4                             : std_logic_vector(0 to 15) := x"0104";
  constant U_STATE_5                             : std_logic_vector(0 to 15) := x"0105";
  constant U_STATE_6                             : std_logic_vector(0 to 15) := x"0106";
  constant U_STATE_7                             : std_logic_vector(0 to 15) := x"0107";
  constant U_STATE_8                             : std_logic_vector(0 to 15) := x"0108";
  constant U_STATE_9                             : std_logic_vector(0 to 15) := x"0109";
  constant U_STATE_10                            : std_logic_vector(0 to 15) := x"0110";
  constant U_STATE_11                            : std_logic_vector(0 to 15) := x"0111";
  constant U_STATE_12                            : std_logic_vector(0 to 15) := x"0112";
  constant U_STATE_13                            : std_logic_vector(0 to 15) := x"0113";
  constant U_STATE_14                            : std_logic_vector(0 to 15) := x"0114";
  constant U_STATE_15                            : std_logic_vector(0 to 15) := x"0115";
  constant U_STATE_16                            : std_logic_vector(0 to 15) := x"0116";
  constant U_STATE_17                            : std_logic_vector(0 to 15) := x"0117";
  constant U_STATE_18                            : std_logic_vector(0 to 15) := x"0118";
  constant U_STATE_19                            : std_logic_vector(0 to 15) := x"0119";
  constant U_STATE_20                            : std_logic_vector(0 to 15) := x"0120";
  -- Range 0003 to 7999 reserved for user logic's state machine
  -- Range 8000 to 9999 reserved for system calls
  constant FUNCTION_HTHREAD_ATTR_INIT          : std_logic_vector(0 to 15) := x"8000";
  constant FUNCTION_HTHREAD_ATTR_DESTROY       : std_logic_vector(0 to 15) := x"8001";
  constant FUNCTION_HTHREAD_CREATE             : std_logic_vector(0 to 15) := x"8010";
  constant FUNCTION_HTHREAD_JOIN               : std_logic_vector(0 to 15) := x"8011";
  constant FUNCTION_HTHREAD_SELF               : std_logic_vector(0 to 15) := x"8012";
  constant FUNCTION_HTHREAD_YIELD              : std_logic_vector(0 to 15) := x"8013";
  constant FUNCTION_HTHREAD_EQUAL              : std_logic_vector(0 to 15) := x"8014";
  constant FUNCTION_HTHREAD_EXIT               : std_logic_vector(0 to 15) := x"8015";
  constant FUNCTION_HTHREAD_EXIT_ERROR         : std_logic_vector(0 to 15) := x"8016";
  constant FUNCTION_HTHREAD_MUTEXATTR_INIT     : std_logic_vector(0 to 15) := x"8020";
  constant FUNCTION_HTHREAD_MUTEXATTR_DESTROY  : std_logic_vector(0 to 15) := x"8021";
  constant FUNCTION_HTHREAD_MUTEXATTR_SETNUM   : std_logic_vector(0 to 15) := x"8022";
  constant FUNCTION_HTHREAD_MUTEXATTR_GETNUM   : std_logic_vector(0 to 15) := x"8023";
  constant FUNCTION_HTHREAD_MUTEX_INIT         : std_logic_vector(0 to 15) := x"8030";
  constant FUNCTION_HTHREAD_MUTEX_DESTROY      : std_logic_vector(0 to 15) := x"8031";
  constant FUNCTION_HTHREAD_MUTEX_LOCK         : std_logic_vector(0 to 15) := x"8032";
  constant FUNCTION_HTHREAD_MUTEX_UNLOCK       : std_logic_vector(0 to 15) := x"8033";
  constant FUNCTION_HTHREAD_MUTEX_TRYLOCK      : std_logic_vector(0 to 15) := x"8034";
  constant FUNCTION_HTHREAD_CONDATTR_INIT      : std_logic_vector(0 to 15) := x"8040";
  constant FUNCTION_HTHREAD_CONDATTR_DESTROY   : std_logic_vector(0 to 15) := x"8041";
  constant FUNCTION_HTHREAD_CONDATTR_SETNUM    : std_logic_vector(0 to 15) := x"8042";
  constant FUNCTION_HTHREAD_CONDATTR_GETNUM    : std_logic_vector(0 to 15) := x"8043";
  constant FUNCTION_HTHREAD_COND_INIT          : std_logic_vector(0 to 15) := x"8050";
  constant FUNCTION_HTHREAD_COND_DESTROY       : std_logic_vector(0 to 15) := x"8051";
  constant FUNCTION_HTHREAD_COND_SIGNAL        : std_logic_vector(0 to 15) := x"8052";
  constant FUNCTION_HTHREAD_COND_BROADCAST     : std_logic_vector(0 to 15) := x"8053";
  constant FUNCTION_HTHREAD_COND_WAIT          : std_logic_vector(0 to 15) := x"8054";
  -- Ranged A000 to FFFF reserved for supported library calls
  constant FUNCTION_MALLOC                     : std_logic_vector(0 to 15) := x"A000";
  constant FUNCTION_CALLOC                     : std_logic_vector(0 to 15) := x"A001";
  constant FUNCTION_FREE                       : std_logic_vector(0 to 15) := x"A002";

  -- user_opcode Constants
  constant OPCODE_NOOP                         : std_logic_vector(0 to 5) := "000000";
  -- Memory sub-interface specific opcodes
  constant OPCODE_LOAD                         : std_logic_vector(0 to 5) := "000001";
  constant OPCODE_STORE                        : std_logic_vector(0 to 5) := "000010";
  constant OPCODE_DECLARE                      : std_logic_vector(0 to 5) := "000011";
  constant OPCODE_READ                         : std_logic_vector(0 to 5) := "000100";
  constant OPCODE_WRITE                        : std_logic_vector(0 to 5) := "000101";
  constant OPCODE_ADDRESS                      : std_logic_vector(0 to 5) := "000110";
  -- Function sub-interface specific opcodes
  constant OPCODE_PUSH                         : std_logic_vector(0 to 5) := "010000";
  constant OPCODE_POP                          : std_logic_vector(0 to 5) := "010001";
  constant OPCODE_CALL                         : std_logic_vector(0 to 5) := "010010";
  constant OPCODE_RETURN                       : std_logic_vector(0 to 5) := "010011";

  constant Z32 : std_logic_vector(0 to 31) := (others => '0');

  signal current_state, next_state : state_machine := FUNCTION_RESET;
  signal return_state, return_state_next: state_machine := FUNCTION_RESET;

  signal toUser_address : std_logic_vector(0 to 31);
  signal toUser_value : std_logic_vector(0 to 31);
  signal toUser_function : std_logic_vector(0 to 15);
  signal toUser_goWait : std_logic;

  signal retVal, retVal_next : std_logic_vector(0 to 31);
  signal arg, arg_next : std_logic_vector(0 to 31);
  signal reg1, reg1_next : std_logic_vector(0 to 31);
  signal reg2, reg2_next : std_logic_vector(0 to 31);
  signal reg3, reg3_next : std_logic_vector(0 to 31);
  signal reg4, reg4_next : std_logic_vector(0 to 31);
  signal reg5, reg5_next : std_logic_vector(0 to 31);
  signal reg6, reg6_next : std_logic_vector(0 to 31);
  signal reg7, reg7_next : std_logic_vector(0 to 31);
  signal reg8, reg8_next : std_logic_vector(0 to 31);

---------------------------------------------------------------------------
-- Begin architecture
---------------------------------------------------------------------------

begin -- architecture IMP

  HWTUL_STATE_PROCESS : process (clock, intrfc2thrd_goWait) is
  begin
    
    if (clock'event and (clock = '1')) then
      toUser_address <= intrfc2thrd_address;
      toUser_value <= intrfc2thrd_value;
      toUser_function <= intrfc2thrd_function;
      toUser_goWait <= intrfc2thrd_goWait;

      return_state <= return_state_next;

      retVal <= retVal_next;
      arg <= arg_next;
      reg1 <= reg1_next;
      reg2 <= reg2_next;
      reg3 <= reg3_next;
      reg4 <= reg4_next;
      reg5 <= reg5_next;
      reg6 <= reg6_next;
      reg7 <= reg7_next;
      reg8 <= reg8_next;

      -- Find out if the HWTI is tell us what to do
      if (intrfc2thrd_goWait = '1') then
        case intrfc2thrd_function is
          -- Typically the HWTI will tell us to control our own destiny
          when U_FUNCTION_USER_SELECT =>
            current_state <= next_state;

          -- List all the functions the HWTI could tell us to run
          when U_FUNCTION_RESET =>
            current_state <= FUNCTION_RESET;
          when U_FUNCTION_START =>
            current_state <= FUNCTION_START;
          when U_STATE_1 =>
            current_state <= STATE_1;
          when U_STATE_2 =>
            current_state <= STATE_2;
          when U_STATE_3 =>
            current_state <= STATE_3;
          when U_STATE_4 =>
            current_state <= STATE_4;
          when U_STATE_5 =>
            current_state <= STATE_5;
          when U_STATE_6 =>
            current_state <= STATE_6;
          when U_STATE_7 =>
            current_state <= STATE_7;
          when U_STATE_8 =>
            current_state <= STATE_8;
          when U_STATE_9 =>
            current_state <= STATE_9;
          when U_STATE_10 =>
            current_state <= STATE_10;
          when U_STATE_11 =>
            current_state <= STATE_11;
          when U_STATE_12 =>
            current_state <= STATE_12;
          when U_STATE_13 =>
            current_state <= STATE_13;
          when U_STATE_14 =>
            current_state <= STATE_14;
          when U_STATE_15 =>
            current_state <= STATE_15;
          when U_STATE_16 =>
            current_state <= STATE_16;
          when U_STATE_17 =>
            current_state <= STATE_17;
          when U_STATE_18 =>
            current_state <= STATE_18;
          when U_STATE_19 =>
            current_state <= STATE_19;
          when U_STATE_20 =>
            current_state <= STATE_20;

          -- If the HWTI tells us to do something we don't know, error
          when OTHERS =>
            current_state <= ERROR_STATE;
        end case;
      else
        current_state <= WAIT_STATE;
      end if;
    end if;
  end process HWTUL_STATE_PROCESS;


  HWTUL_STATE_MACHINE : process (clock) is
  begin

    -- Default register assignments
    thrd2intrfc_opcode <= OPCODE_NOOP; -- When issuing an OPCODE, must be a pulse
    thrd2intrfc_address <= Z32;
    thrd2intrfc_value <= Z32;
    thrd2intrfc_function <= U_FUNCTION_USER_SELECT;
    return_state_next <= return_state;
    next_state <= current_state;

    retVal_next <= retVal;
    arg_next <= arg;
    reg1_next <= reg1;
    reg2_next <= reg2;
    reg3_next <= reg3;
    reg4_next <= reg4;
    reg5_next <= reg5;
    reg6_next <= reg6;
    reg7_next <= reg7;
    reg8_next <= reg8;

-----------------------------------------------------------------------
-- mutex_unlock_3.c
-----------------------------------------------------------------------

    -- The state machine
    case current_state is
      when FUNCTION_RESET =>
        --Set default values
        thrd2intrfc_opcode <= OPCODE_NOOP;
        thrd2intrfc_address <= Z32;
        thrd2intrfc_value <= Z32;
        thrd2intrfc_function <= U_FUNCTION_START;

      -- hthread_mutex_t * mutex = (hthread_mutex_t *) arg
      when FUNCTION_START =>
        -- Pop the argument
        thrd2intrfc_value <= Z32;
        thrd2intrfc_opcode <= OPCODE_POP;
        next_state <= WAIT_STATE;
		return_state_next <= STATE_1;

      when STATE_1 =>
	    arg_next <= intrfc2thrd_value;
        next_state <= STATE_2;

      -- hthread_mutex_lock( mutex );
      when STATE_2 =>
	    -- Push mutex
		thrd2intrfc_opcode <= OPCODE_PUSH;
		thrd2intrfc_value <= arg;
        next_state <= WAIT_STATE;
		return_state_next <= STATE_3;

	  when STATE_3 =>
	    -- Call hthread_mutex_lock
		thrd2intrfc_opcode <= OPCODE_CALL;
		thrd2intrfc_function <= FUNCTION_HTHREAD_MUTEX_LOCK;
		thrd2intrfc_value <= Z32(0 to 15) & U_STATE_4;
		next_state <= WAIT_STATE;

      -- retVal = hthread_mutex_unlock( mutex );
      when STATE_4 =>
	    -- Push mutex
		thrd2intrfc_opcode <= OPCODE_PUSH;
		thrd2intrfc_value <= arg;
        next_state <= WAIT_STATE;
		return_state_next <= STATE_5;

	  when STATE_5 =>
	    -- Call hthread_mutex_unlock
		thrd2intrfc_opcode <= OPCODE_CALL;
		thrd2intrfc_function <= FUNCTION_HTHREAD_MUTEX_UNLOCK;
		thrd2intrfc_value <= Z32(0 to 15) & U_STATE_6;
		next_state <= WAIT_STATE;

      when STATE_6 =>
		retVal_next <= intrfc2thrc_value;
	    next_state <= FUNCTION_EXIT;

      when FUNCTION_EXIT =>
        --Same as hthread_exit( (void *) retVal );
        thrd2intrfc_value <= retVal;
        thrd2intrfc_opcode <= OPCODE_RETURN;
        next_state <= WAIT_STATE;

      when WAIT_STATE =>
        next_state <= return_state;

      when ERROR_STATE =>
        next_state <= ERROR_STATE;

      when others =>
        next_state <= ERROR_STATE;

    end case;
  end process HWTUL_STATE_MACHINE;
end architecture IMP;
