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
    SETUP_1,
    SETUP_2,
    SETUP_3,
    SETUP_4,
    SETUP_5,
    SETUP_6,
    WHILE_LOOP_1,
    WHILE_LOOP_2,
    WHILE_LOOP_3,
    WHILE_LOOP_4,
    WHILE_LOOP_4a,
    WHILE_LOOP_5,
    WHILE_LOOP_6,
    WHILE_LOOP_7,
    WHILE_LOOP_8,
    WHILE_LOOP_9,
    FUNCTION_EXIT_1,
    FUNCTION_EXIT_2,
    WAIT_STATE,
    ERROR_STATE);

  -- Function definitions
  constant U_FUNCTION_RESET                      : std_logic_vector(0 to 15) := x"0000";
  constant U_FUNCTION_WAIT                       : std_logic_vector(0 to 15) := x"0001";
  constant U_FUNCTION_USER_SELECT                : std_logic_vector(0 to 15) := x"0002";
  constant U_FUNCTION_START                      : std_logic_vector(0 to 15) := x"0003";
  constant U_WHILE_LOOP_3                        : std_logic_vector(0 to 15) := x"0103";
  constant U_WHILE_LOOP_6                        : std_logic_vector(0 to 15) := x"0106";

  -- Range 0003 to 7999 reserved for user logic's state machine
  -- Range 8000 to 9999 reserved for system calls
  -- constant FUNCTION_HTHREAD_ATTR_INIT          : std_logic_vector(0 to 15) := x"8000";
  -- constant FUNCTION_HTHREAD_ATTR_DESTROY       : std_logic_vector(0 to 15) := x"8001";
  -- constant FUNCTION_HTHREAD_CREATE             : std_logic_vector(0 to 15) := x"8010";
  -- constant FUNCTION_HTHREAD_JOIN               : std_logic_vector(0 to 15) := x"8011";
  constant FUNCTION_HTHREAD_SELF               : std_logic_vector(0 to 15) := x"8012";
  constant FUNCTION_HTHREAD_YIELD              : std_logic_vector(0 to 15) := x"8013";
  constant FUNCTION_HTHREAD_EQUAL              : std_logic_vector(0 to 15) := x"8014";
  constant FUNCTION_HTHREAD_EXIT               : std_logic_vector(0 to 15) := x"8015";
  constant FUNCTION_HTHREAD_EXIT_ERROR         : std_logic_vector(0 to 15) := x"8016";
  -- constant FUNCTION_HTHREAD_MUTEXATTR_INIT     : std_logic_vector(0 to 15) := x"8020";
  -- constant FUNCTION_HTHREAD_MUTEXATTR_DESTROY  : std_logic_vector(0 to 15) := x"8021";
  -- constant FUNCTION_HTHREAD_MUTEXATTR_SETNUM   : std_logic_vector(0 to 15) := x"8022";
  -- constant FUNCTION_HTHREAD_MUTEXATTR_GETNUM   : std_logic_vector(0 to 15) := x"8023";
  -- constant FUNCTION_HTHREAD_MUTEX_INIT         : std_logic_vector(0 to 15) := x"8030";
  -- constant FUNCTION_HTHREAD_MUTEX_DESTROY      : std_logic_vector(0 to 15) := x"8031";
  constant FUNCTION_HTHREAD_MUTEX_LOCK         : std_logic_vector(0 to 15) := x"8032";
  constant FUNCTION_HTHREAD_MUTEX_UNLOCK       : std_logic_vector(0 to 15) := x"8033";
  constant FUNCTION_HTHREAD_MUTEX_TRYLOCK      : std_logic_vector(0 to 15) := x"8034";
  -- constant FUNCTION_HTHREAD_CONDATTR_INIT      : std_logic_vector(0 to 15) := x"8040";
  -- constant FUNCTION_HTHREAD_CONDATTR_DESTROY   : std_logic_vector(0 to 15) := x"8041";
  -- constant FUNCTION_HTHREAD_CONDATTR_SETNUM    : std_logic_vector(0 to 15) := x"8042";
  -- constant FUNCTION_HTHREAD_CONDATTR_GETNUM    : std_logic_vector(0 to 15) := x"8043";
  -- constant FUNCTION_HTHREAD_COND_INIT          : std_logic_vector(0 to 15) := x"8050";
  -- constant FUNCTION_HTHREAD_COND_DESTROY       : std_logic_vector(0 to 15) := x"8051";
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

  signal structAddr, structAddr_next : std_logic_vector(0 to 31);
  signal size, size_next : std_logic_vector(0 to 31);
  signal index, index_next : std_logic_vector(0 to 31);
  signal xAddr, xAddr_next : std_logic_vector(0 to 31);
  signal yAddr, yAddr_next : std_logic_vector(0 to 31);
  signal zAddr, zAddr_next : std_logic_vector(0 to 31);
  signal xVal, xVal_next : std_logic_vector(0 to 31);
  signal yVal, yVal_next : std_logic_vector(0 to 31);
  signal mutexAddr, mutexAddr_next : std_logic_vector(0 to 31);
  signal count, count_next : std_logic_vector(0 to 31);

  -- misc constants

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

      structAddr <= structAddr_next;
      size <= size_next;
      index <= index_next;
      xAddr <= xAddr_next;
      yAddr <= yAddr_next;
      zAddr <= zAddr_next;
      xVal <= xVal_next;
      yVal <= yVal_next;
      mutexAddr <= mutexAddr_next;
      count <= count_next;

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
          when U_WHILE_LOOP_3 =>
            current_state <= WHILE_LOOP_3;
          when U_WHILE_LOOP_6 =>
            current_state <= WHILE_LOOP_6;

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

    structAddr_next <= structAddr;
    size_next <= size;
    index_next <= index;
    xAddr_next <= xAddr;
    yAddr_next <= yAddr;
    zAddr_next <= zAddr;
    xVal_next <= xVal;
    yVal_next <= yVal;
    mutexAddr_next <= mutexAddr;
    count_next <= count;

    -- The state machine
    case current_state is
      when FUNCTION_RESET =>
        --Set default values
        thrd2intrfc_opcode <= OPCODE_NOOP;
        thrd2intrfc_address <= Z32;
        thrd2intrfc_value <= Z32;
        thrd2intrfc_function <= U_FUNCTION_START;

      when FUNCTION_START =>
        -- POP the argument
        thrd2intrfc_opcode <= OPCODE_POP;
        thrd2intrfc_value <= Z32;
        count_next <= Z32;
        next_state <= WAIT_STATE;
        return_state_next <= SETUP_1;

      when SETUP_1 =>
        -- Read the argument, which is an address of a struct
        structAddr_next <= toUser_value;
        -- Initiate the reading of the first variable in the struct, size
        thrd2intrfc_opcode <= OPCODE_LOAD;
        thrd2intrfc_address <= toUser_value;
        next_state <= WAIT_STATE;
        return_state_next <= SETUP_2;

      when SETUP_2 =>
        -- Read the value of size
        size_next <= toUser_value;
        -- Initiate the reading of the third variable in the struct, xAddr
        thrd2intrfc_opcode <= OPCODE_LOAD;
        thrd2intrfc_address <= structAddr + x"00000008";
        next_state <= WAIT_STATE;
        return_state_next <= SETUP_3;

      when SETUP_3 =>
        -- Read the value of xAddr
        xAddr_next <= toUser_value;
        -- Initiate the reading of the fourth variable in the struct, yAddr
        thrd2intrfc_opcode <= OPCODE_LOAD;
        thrd2intrfc_address <= structAddr + x"0000000C";
        next_state <= WAIT_STATE;
        return_state_next <= SETUP_4;

      when SETUP_4 =>
        -- Read the value of yAddr
        yAddr_next <= toUser_value;
        -- Initiate the reading of the fifth variable in the struct, zAddr
        thrd2intrfc_opcode <= OPCODE_LOAD;
        thrd2intrfc_address <= structAddr + x"00000010";
        next_state <= WAIT_STATE;
        return_state_next <= SETUP_5;

      when SETUP_5 =>
        -- Read the value of zAddr
        zAddr_next <= toUser_value;
        -- Initiate the reading of the sixth variable in the struct, mutexAddr
        thrd2intrfc_opcode <= OPCODE_LOAD;
        thrd2intrfc_address <= structAddr + x"00000014";
        next_state <= WAIT_STATE;
        return_state_next <= SETUP_6;

      when SETUP_6 =>
        -- Read the value of mutexAddr
        mutexAddr_next <= toUser_value;
        next_state <= WHILE_LOOP_1;

      when WHILE_LOOP_1 =>
        -- Lock the mutex, push the address of the mutex
        thrd2intrfc_opcode <= OPCODE_PUSH;
        thrd2intrfc_value <= mutexAddr;
        next_state <= WAIT_STATE;
        return_state_next <= WHILE_LOOP_2;

      when WHILE_LOOP_2 =>
        -- Call mutex lock
        thrd2intrfc_opcode <= OPCODE_CALL;
        thrd2intrfc_function <= FUNCTION_HTHREAD_MUTEX_TRYLOCK;
        thrd2intrfc_value <= Z32(0 to 15) & U_WHILE_LOOP_3;
        next_state <= WAIT_STATE;

      when WHILE_LOOP_3 =>
        -- We now have a lock on index, initiate the read on index
        thrd2intrfc_opcode <= OPCODE_LOAD;
        thrd2intrfc_address <= structAddr + x"00000004";
        next_state <= WAIT_STATE;
        return_state_next <= WHILE_LOOP_4;

      when WHILE_LOOP_4 =>
        index_next <= toUser_value;
        -- increment index
        thrd2intrfc_opcode <= OPCODE_STORE;
        thrd2intrfc_address <= structAddr + x"00000004";
        thrd2intrfc_value <= toUser_value + x"00000001";
        next_state <= WAIT_STATE;
        return_state_next <= WHILE_LOOP_4a;

      when WHILE_LOOP_4a =>
        thrd2intrfc_opcode <= OPCODE_PUSH;
        thrd2intrfc_value <= mutexAddr;
        next_state <= WAIT_STATE;
        return_state_next <= WHILE_LOOP_5;

      when WHILE_LOOP_5 =>
        -- Unlock the mutex
        thrd2intrfc_opcode <= OPCODE_CALL;
        thrd2intrfc_function <= FUNCTION_HTHREAD_MUTEX_UNLOCK;
        thrd2intrfc_value <= Z32(0 to 15) & U_WHILE_LOOP_6;
        next_state <= WAIT_STATE;

      when WHILE_LOOP_6 =>
        -- Check to see if the index is over the size
        if ( index < size ) then
          -- More work to be done
          -- Initiate the read of the X matrix
          thrd2intrfc_opcode <= OPCODE_LOAD;
          thrd2intrfc_address <= xAddr + (index(2 to 31) & "00");
          next_state <= WAIT_STATE;
          return_state_next <= WHILE_LOOP_7;
        else 
          -- we may exit
          next_state <= FUNCTION_EXIT_1;
        end if;

      when WHILE_LOOP_7 =>
        xVal_next <= ToUser_value;
        -- Initiate the read of the Y matrix
        thrd2intrfc_opcode <= OPCODE_LOAD;
        thrd2intrfc_address <= yAddr + (index(2 to 31) & "00");
        next_state <= WAIT_STATE;
        return_state_next <= WHILE_LOOP_8;

      when WHILE_LOOP_8 =>
        yVal_next <= ToUser_value;
        next_state <= WHILE_LOOP_9;

      when WHILE_LOOP_9 =>
        -- Initiate the writing of the Z matrix
        thrd2intrfc_opcode <= OPCODE_STORE;
        thrd2intrfc_address <= zAddr + (index(2 to 31) & "00");
        thrd2intrfc_value <= xVal + yVal;
        next_state <= WAIT_STATE;
        return_state_next <= WHILE_LOOP_1;
        -- Increment count
        count_next <= count + x"00000001";

      when FUNCTION_EXIT_1 =>
        thrd2intrfc_value <= count;
        thrd2intrfc_opcode <= OPCODE_PUSH;
        next_state <= WAIT_STATE;
        return_state_next <= FUNCTION_EXIT_2;

      when FUNCTION_EXIT_2 =>
        --Immediatly exit
        thrd2intrfc_function <= FUNCTION_HTHREAD_EXIT;
        thrd2intrfc_value <= Z32(0 to 15) & U_FUNCTION_RESET;
        thrd2intrfc_opcode <= OPCODE_CALL;
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
