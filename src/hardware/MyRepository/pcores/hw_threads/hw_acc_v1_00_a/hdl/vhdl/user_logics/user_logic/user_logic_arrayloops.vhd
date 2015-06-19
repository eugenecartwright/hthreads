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
    FOR_LOOP_1,
    FOR_LOOP_2,
    FOR_LOOP_3,
    FOR_LOOP_4,
    FOR_LOOP_5,
    FOR_LOOP_6,
	END_1,
	END_2,
	END_3,
	END_4,
	END_5,
	END_6,
    FUNCTION_EXIT_1,
    FUNCTION_EXIT_2,
    WAIT_STATE,
    ERROR_STATE);

  -- Function definitions
  constant U_FUNCTION_RESET                      : std_logic_vector(0 to 15) := x"0000";
  constant U_FUNCTION_WAIT                       : std_logic_vector(0 to 15) := x"0001";
  constant U_FUNCTION_USER_SELECT                : std_logic_vector(0 to 15) := x"0002";
  constant U_FUNCTION_START                      : std_logic_vector(0 to 15) := x"0003";
  constant U_END_3                               : std_logic_vector(0 to 15) := x"0103";
  constant U_EXIT_1                              : std_logic_vector(0 to 15) := x"0201";

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

  -- Program constants
  constant NTHREADS                            : std_logic_vector(0 to 31) := x"00000004";
  constant ARRAYSIZE                           : std_logic_vector(0 to 31) := x"00002710";
  constant ITERATIONS                          : std_logic_vector(0 to 31) := x"000009C4";
  --constant ITERATIONS                          : std_logic_vector(0 to 31) := x"00000010";

  signal structAddr, structAddr_next : std_logic_vector(0 to 31);
  signal sumAddr, sumAddr_next : std_logic_vector(0 to 31);
  signal arrayAddr, arrayAddr_next : std_logic_vector(0 to 31);
  signal mutexAddr, mutexAddr_next : std_logic_vector(0 to 31);
  signal tid, tid_next : std_logic_vector(0 to 1);
  signal mySum, mySum_next: std_logic_vector(0 to 31);
  signal i, i_next : std_logic_vector(0 to 31);
  signal start, start_next : std_logic_vector(0 to 31);
  signal endd, endd_next : std_logic_vector(0 to 31);

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
      sumAddr <= sumAddr_next;
      arrayAddr <=  arrayAddr_next;
      mutexAddr <= mutexAddr_next;
      tid <= tid_next;
      mySum <=  mySum_next;
      i <= i_next;
      start <= start_next;
      endd <= endd_next;

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
          when U_END_3 =>
            current_state <= END_3;
          when U_EXIT_1=>
            current_state <= FUNCTION_EXIT_1;

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
    sumAddr_next <= sumAddr;
    arrayAddr_next <=  arrayAddr;
    mutexAddr_next <= mutexAddr;
    tid_next <= tid;
    mySum_next <=  mySum;
    i_next <= i;
    start_next <= start;
    endd_next <= endd;

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
        next_state <= WAIT_STATE;
        return_state_next <= SETUP_1;

      when SETUP_1 =>
        -- Read the argument, which is an address of a struct
        structAddr_next <= toUser_value;
        -- Initiate the reading of the first variable in the struct, sumAddr
        thrd2intrfc_opcode <= OPCODE_LOAD;
        thrd2intrfc_address <= toUser_value;
        next_state <= WAIT_STATE;
        return_state_next <= SETUP_2;

      when SETUP_2 =>
        -- Read the value of sumAddr
        sumAddr_next <= toUser_value;
        -- Initiate the reading of the second variable in the struct, arrayAddr
        thrd2intrfc_opcode <= OPCODE_LOAD;
        thrd2intrfc_address <= structAddr + x"00000004";
        next_state <= WAIT_STATE;
        return_state_next <= SETUP_3;

      when SETUP_3 =>
        -- Read the value of arrayAddr
        arrayAddr_next <= toUser_value;
        -- Initiate the reading of the third variable in the struct, mutexAddr
        thrd2intrfc_opcode <= OPCODE_LOAD;
        thrd2intrfc_address <= structAddr + x"00000008";
        next_state <= WAIT_STATE;
        return_state_next <= SETUP_4;

      when SETUP_4 =>
        -- Read the value of mutexAddr
        mutexAddr_next <= toUser_value;
        -- Initiate the reading of the fourth variable in the struct, tid
        thrd2intrfc_opcode <= OPCODE_LOAD;
        thrd2intrfc_address <= structAddr + x"0000000C";
        next_state <= WAIT_STATE;
        return_state_next <= SETUP_5;

      when SETUP_5 =>
        -- Read the value of tid
        tid_next <= toUser_value(30 to 31);
        -- Calculate the start value
		-- Note: that I'm avoiding the multiplication
        case toUser_value(30 to 31) is
		  when "00" =>
		    start_next <= Z32;
		  when "01" =>
		    start_next <= ITERATIONS;
		  when "10" =>
		    start_next <= ITERATIONS(1 to 31) & '0';
		  when others => -- "11"
		    start_next <= (ITERATIONS(1 to 31) & '0') + ITERATIONS;
		end case;
        next_state <= SETUP_6;

      when SETUP_6 =>
	    -- initialize mySum
		mySum_next <= Z32;
        -- Calculate end value
        endd_next <= start + ITERATIONS;
        next_state <= FOR_LOOP_1;

		-- Skipping the printf statement

      when FOR_LOOP_1 =>
        -- Initialize i value
		i_next <= start;
        next_state <= FOR_LOOP_2;

      when FOR_LOOP_2 =>
	    -- store the value of the a[i] as i
		-- note storing as an int instead of a double
        thrd2intrfc_opcode <= OPCODE_STORE;
        thrd2intrfc_address <= arrayAddr + (i(2 to 31) & "00");
        thrd2intrfc_value <= i;
        next_state <= WAIT_STATE;
        return_state_next <= FOR_LOOP_3;

      when FOR_LOOP_3 =>
        -- Load the value of a[i] (which we just set)
        thrd2intrfc_opcode <= OPCODE_LOAD;
        thrd2intrfc_address <= arrayAddr + (i(2 to 31) & "00");
        next_state <= WAIT_STATE;
        return_state_next <= FOR_LOOP_4;

      when FOR_LOOP_4 =>
        -- increment mySum 
        mySum_next <= mySum + toUser_value;
		next_state <= FOR_LOOP_5;

      when FOR_LOOP_5 =>
        -- Increment i
		i_next <= i + 1;
		next_state <= FOR_LOOP_6;

	  when FOR_LOOP_6 =>
	    -- Check for end of loop condition
		if ( i < endd ) then
		  next_state <= FOR_LOOP_2;
		else
		  next_state <= END_1;
		end if;

      when END_1 =>
	    --push arugment for pthread_mutex_lock
        thrd2intrfc_value <= mutexAddr;
        thrd2intrfc_opcode <= OPCODE_PUSH;
        next_state <= WAIT_STATE;
        return_state_next <= END_2;

	  when END_2 =>
	    --call mutex lock
        thrd2intrfc_function <= FUNCTION_HTHREAD_MUTEX_LOCK;
        thrd2intrfc_value <= Z32(0 to 15) & U_END_3;
        thrd2intrfc_opcode <= OPCODE_CALL;
        next_state <= WAIT_STATE;

	  when END_3 =>
	    --Initiate the reading of the value of sum
        thrd2intrfc_opcode <= OPCODE_LOAD;
        thrd2intrfc_address <= sumAddr;
        next_state <= WAIT_STATE;
        return_state_next <= END_4;

	  when END_4 =>
	    --Add value of sum to mySum and store
        thrd2intrfc_opcode <= OPCODE_STORE;
        thrd2intrfc_address <= sumAddr;
		thrd2intrfc_value <= toUser_value + mySum;
        next_state <= WAIT_STATE;
        return_state_next <= END_5;

      when END_5 =>
	    --push arugment for pthread_mutex_unlock
        thrd2intrfc_value <= mutexAddr;
        thrd2intrfc_opcode <= OPCODE_PUSH;
        next_state <= WAIT_STATE;
        return_state_next <= END_6;

	  when END_6 =>
	    --call mutex unlock
        thrd2intrfc_function <= FUNCTION_HTHREAD_MUTEX_UNLOCK;
        thrd2intrfc_value <= Z32(0 to 15) & U_EXIT_1;
        thrd2intrfc_opcode <= OPCODE_CALL;
        next_state <= WAIT_STATE;

      when FUNCTION_EXIT_1 =>
	    --push the argument for pthread_exit
		--For debug reasons, pushing start instead of NULL
        thrd2intrfc_value <= start;
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
