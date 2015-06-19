---------------------------------------------------------------------------
--
--  Title: Hardware Thread User Logic Quicksort
--  Thread implements the quicksort algorithm
--  Passed in argument is a pointer to following struct
-- struct sortData {
--   int * startData; //pointer to start of array
--   int * endData; //pointer to end of array
--   int cacheOption // 1 operate on data where it is, 0 copy into HWTI first
--  There is not return argument, the HWT just sorts the data.
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
    READ_SORTDATA_1,
    READ_SORTDATA_2,
    READ_SORTDATA_3,
    READ_SORTDATA_4,
    READ_SORTDATA_5,
    READ_SORTDATA_6,
    READ_SORTDATA_7,
    READ_SORTDATA_8,
    COPY_DATA_1,
    COPY_DATA_2,
    COPY_DATA_3,
    COPY_DATA_4,
    COPY_DATA_5,
    COPY_DATA_6,
    COPY_DATA_7,
    RECOPY_DATA_1,
    RECOPY_DATA_2,
    RECOPY_DATA_3,
    RECOPY_DATA_4,
	FREE_1,
	FREE_2,
    CALL_QSORT_1,
    CALL_QSORT_2,
    CALL_QSORT_3,
    READ_ARRAY_1,
    READ_ARRAY_2,
    READ_ARRAY_3,
    READ_ARRAY_4,
    READ_ARRAY_5,
    READ_ARRAY_6,
    EXIT_THREAD_1,
    EXIT_THREAD_2,
    QUICKSORT_1,
    QUICKSORT_2,
    QUICKSORT_3,
    QUICKSORT_4,
    QUICKSORT_5,
    QUICKSORT_6,
    QUICKSORT_7,
    QUICKSORT_8,
    QUICKSORT_9,
    QUICKSORT_A,
    QUICKSORT_B,
    QUICKSORT_DO,
    QUICKSORT_WHILE_LEFT_0,
    QUICKSORT_WHILE_LEFT_1,
    QUICKSORT_WHILE_LEFT_2,
    QUICKSORT_WHILE_LEFT_3,
    QUICKSORT_BREAK,
    QUICKSORT_WHILE_RIGHT_1,
    QUICKSORT_WHILE_RIGHT_2,
    QUICKSORT_WHILE_RIGHT_3,
    QUICKSORT_SWAP_1,
    QUICKSORT_SWAP_2,
    QUICKSORT_SWAP_3,
    QUICKSORT_SWAP_4,
    QUICKSORT_SWAP_5,
    QUICKSORT_WHILE,
    QUICKSORT_CALL_QS_0,
    QUICKSORT_CALL_QS_1,
    QUICKSORT_CALL_QS_2,
    QUICKSORT_CALL_QS_3,
    QUICKSORT_CALL_QS_4,
    QUICKSORT_CALL_QS_5,
    QUICKSORT_CALL_QS_6,
    QUICKSORT_CALL_QS_7,
    QUICKSORT_CALL_QS_8,
    QUICKSORT_CALL_QS_9,
    QUICKSORT_CALL_QS_A,
    QUICKSORT_RETURN,
    WAIT_STATE,
    ERROR_STATE);

  -- Function definitions
  constant U_FUNCTION_RESET                    : std_logic_vector(0 to 15) := x"0000";
  constant U_FUNCTION_WAIT                     : std_logic_vector(0 to 15) := x"0001";
  constant U_FUNCTION_USER_SELECT              : std_logic_vector(0 to 15) := x"0002";
  constant U_FUNCTION_START                    : std_logic_vector(0 to 15) := x"0003";
  constant U_READ_SORTDATA_5                   : std_logic_vector(0 to 15) := x"0007";
  constant U_COPY_DATA_3                       : std_logic_vector(0 to 15) := x"0053";
  constant U_READ_ARRAY_1                      : std_logic_vector(0 to 15) := x"0031";
  constant U_EXIT_THREAD_1                     : std_logic_vector(0 to 15) := x"0021";
  constant U_FREE_1                            : std_logic_vector(0 to 15) := x"0041";
  constant U_QUICKSORT_1                       : std_logic_vector(0 to 15) := x"0101";
  constant U_QUICKSORT_CALL_QS_6               : std_logic_vector(0 to 15) := x"0171";
  constant U_QUICKSORT_RETURN                  : std_logic_vector(0 to 15) := x"0181";

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
  -- constant FUNCTION_HTHREAD_MUTEX_LOCK         : std_logic_vector(0 to 15) := x"8032";
  -- constant FUNCTION_HTHREAD_MUTEX_UNLOCK       : std_logic_vector(0 to 15) := x"8033";
  -- constant FUNCTION_HTHREAD_MUTEX_TRYLOCK      : std_logic_vector(0 to 15) := x"8034";
  -- constant FUNCTION_HTHREAD_CONDATTR_INIT      : std_logic_vector(0 to 15) := x"8040";
  -- constant FUNCTION_HTHREAD_CONDATTR_DESTROY   : std_logic_vector(0 to 15) := x"8041";
  -- constant FUNCTION_HTHREAD_CONDATTR_SETNUM    : std_logic_vector(0 to 15) := x"8042";
  -- constant FUNCTION_HTHREAD_CONDATTR_GETNUM    : std_logic_vector(0 to 15) := x"8043";
  -- constant FUNCTION_HTHREAD_COND_INIT          : std_logic_vector(0 to 15) := x"8050";
  -- constant FUNCTION_HTHREAD_COND_DESTROY       : std_logic_vector(0 to 15) := x"8051";
  -- constant FUNCTION_HTHREAD_COND_SIGNAL        : std_logic_vector(0 to 15) := x"8052";
  -- constant FUNCTION_HTHREAD_COND_BROADCAST     : std_logic_vector(0 to 15) := x"8053";
  -- constant FUNCTION_HTHREAD_COND_WAIT          : std_logic_vector(0 to 15) := x"8054";
  -- Ranged A000 to FFFF reserved for supported library calls
  constant FUNCTION_MALLOC                     : std_logic_vector(0 to 15) := x"A000";
  constant FUNCTION_CALLOC                     : std_logic_vector(0 to 15) := x"A001";
  constant FUNCTION_FREE                       : std_logic_vector(0 to 15) := x"A002";
  constant FUNCTION_MEMCPY                     : std_logic_vector(0 to 15) := x"A100";

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
  signal return_state, return_state_next : state_machine := FUNCTION_RESET;
  signal startPtr, startPtr_next : std_logic_vector(0 to 31);
  signal endPtr, endPtr_next : std_logic_vector(0 to 31);
  signal leftPtr, leftPtr_next : std_logic_vector(0 to 31);
  signal rightPtr, rightPtr_next : std_logic_vector(0 to 31);
  signal left, left_next : std_logic_vector(0 to 31);
  signal right, right_next : std_logic_vector(0 to 31);
  signal pivot, pivot_next : std_logic_vector(0 to 31);
  signal cache, cache_next : std_logic;

  signal toUser_address : std_logic_vector(0 to 31);
  signal toUser_value : std_logic_vector(0 to 31);
  signal toUser_function : std_logic_vector(0 to 15);
  signal toUser_goWait : std_logic;

---------------------------------------------------------------------------
-- Begin architecture
---------------------------------------------------------------------------

begin -- architecture IMP

  HWTUL_STATE_PROCESS : process (clock) is
  begin
    
    if (clock'event and (clock = '1')) then
      toUser_address <= intrfc2thrd_address;
      toUser_value <= intrfc2thrd_value;
      toUser_function <= intrfc2thrd_function;
      toUser_goWait <= intrfc2thrd_goWait;

      startPtr <= startPtr_next;
      endPtr <= endPtr_next;
      leftPtr <= leftPtr_next;
      rightPtr <= rightPtr_next;
      left <= left_next;
      right <= right_next;
      pivot <= pivot_next;
      cache <= cache_next;
      return_state <= return_state_next;

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
          when U_READ_SORTDATA_5 =>
            current_state <= READ_SORTDATA_5;
          when U_COPY_DATA_3 =>
            current_state <= COPY_DATA_3;
          when U_READ_ARRAY_1 =>
            current_state <= READ_ARRAY_1;
          when U_FREE_1 =>
            current_state <= FREE_1;
          when U_EXIT_THREAD_1 =>
            current_state <= EXIT_THREAD_1;
          when U_QUICKSORT_1 =>
            current_state <= QUICKSORT_1;
          when U_QUICKSORT_CALL_QS_6 =>
            current_state <= QUICKSORT_CALL_QS_6;
          when U_QUICKSORT_RETURN =>
            current_state <= QUICKSORT_RETURN;

          -- If the HWTI tells us to do something we don't know, error
          when OTHERS =>
            current_state <= ERROR_STATE;
        end case;
      else
        current_state <= WAIT_STATE;
      end if;
    end if;
  end process HWTUL_STATE_PROCESS;


  HWTUL_STATE_MACHINE : process (current_state) is
  begin

    -- Default register assignments
    thrd2intrfc_opcode <= OPCODE_NOOP; -- When issuing an OPCODE, must be a pulse
    thrd2intrfc_address <= Z32;
    thrd2intrfc_value <= Z32;
    thrd2intrfc_function <= U_FUNCTION_USER_SELECT;
    next_state <= current_state;
    return_state_next <= return_state;

    startPtr_next <= startPtr;
    endPtr_next <= endPtr;
    leftPtr_next <= leftPtr;
    rightPtr_next <= rightPtr;
    left_next <= left;
    right_next <= right;
    pivot_next <= pivot;
    cache_next <= cache;

    -- The state machine
        case current_state is
          when FUNCTION_RESET =>
            --Set default values
            thrd2intrfc_opcode <= OPCODE_NOOP;
            thrd2intrfc_address <= Z32;
            thrd2intrfc_value <= Z32;
            thrd2intrfc_function <= U_FUNCTION_START;
            startPtr_next <= Z32;
            endPtr_next <= Z32;
            leftPtr_next <= Z32;
            rightPtr_next <= Z32;
            left_next <= Z32;
            right_next <= Z32;
            pivot_next <= Z32;
            cache_next <= '1';

          when FUNCTION_START => -- 0002
            -- read the passed in argument
            thrd2intrfc_opcode <= OPCODE_POP;
            thrd2intrfc_address <= Z32;
            return_state_next <= READ_SORTDATA_1;
            next_state <= WAIT_STATE;
    
          when READ_SORTDATA_1 => -- 0003
            -- The passed in argument is address of struct sortdata
            -- For the time being, store value in startPtr
            startPtr_next <= toUser_value;
            -- Read the endPtr address
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= toUser_value + 4;
            return_state_next <= READ_SORTDATA_2;
            next_state <= WAIT_STATE;

          when READ_SORTDATA_2 => -- 0004
            endPtr_next <= toUser_value;
            -- Read the cache option
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= startPtr + 8;
            return_state_next <= READ_SORTDATA_3;
            next_state <= WAIT_STATE;

          when READ_SORTDATA_3 => -- 0005
            cache_next <= toUser_value(31);
            -- Now read the address of startPtr
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= startPtr;
            return_state_next <= READ_SORTDATA_4;
            next_state <= WAIT_STATE;

          when READ_SORTDATA_4 => -- 0006
            startPtr_next <= toUser_value;
            leftPtr_next <= toUser_value;
            rightPtr_next <= endPtr;
            -- Declare four local variables to hold start, end, left, right pointers
            thrd2intrfc_opcode <= OPCODE_DECLARE;
            thrd2intrfc_value <= x"00000004";
            if ( cache = '1' ) then
              -- copy the global data locally
              return_state_next <= COPY_DATA_1;
              next_state <= WAIT_STATE;
            else
              -- work on data where it is
              return_state_next <= READ_SORTDATA_5;
              next_state <= WAIT_STATE;
            end if;

          when READ_SORTDATA_5 => -- 0007
            -- Save the start pointer
            thrd2intrfc_opcode <= OPCODE_WRITE;
            thrd2intrfc_address <= Z32;
            thrd2intrfc_value <= startPtr;
            return_state_next <= READ_SORTDATA_6;
            next_state <= WAIT_STATE;

          when READ_SORTDATA_6 => -- 0008
            -- Save the end pointer
            thrd2intrfc_opcode <= OPCODE_WRITE;
            thrd2intrfc_address <= x"00000001";
            thrd2intrfc_value <= endPtr;
            return_state_next <= READ_SORTDATA_7;
            next_state <= WAIT_STATE;

          when READ_SORTDATA_7 => -- 0009
            -- Save the left pointer
            thrd2intrfc_opcode <= OPCODE_WRITE;
            thrd2intrfc_address <= x"00000002";
            thrd2intrfc_value <= leftPtr;
            return_state_next <= READ_SORTDATA_8;
            next_state <= WAIT_STATE;

          when READ_SORTDATA_8 => -- 000A
            -- Save the right pointer
            thrd2intrfc_opcode <= OPCODE_WRITE;
            thrd2intrfc_address <= x"00000003";
            thrd2intrfc_value <= rightPtr;
            -- Sort the data!
            return_state_next <= CALL_QSORT_1;
            next_state <= WAIT_STATE;

          when CALL_QSORT_1 => -- 0011
            -- Push the second argument, endPtr;
            thrd2intrfc_opcode <= OPCODE_PUSH;
            thrd2intrfc_value <= rightPtr;
            return_state_next <= CALL_QSORT_2;
            next_state <= WAIT_STATE;

          when CALL_QSORT_2 => -- 0012
            -- Push the first argument, startPtr;
            thrd2intrfc_opcode <= OPCODE_PUSH;
            thrd2intrfc_value <= leftPtr;
            return_state_next <= CALL_QSORT_3;
            next_state <= WAIT_STATE;

          when CALL_QSORT_3 => -- 0013
            -- Call quicksort
            thrd2intrfc_opcode <= OPCODE_CALL;
            thrd2intrfc_function <= U_QUICKSORT_1;
            thrd2intrfc_value <= Z32(0 to 15) & U_READ_ARRAY_1;
            return_state_next <= WAIT_STATE;
            next_state <= WAIT_STATE;

          when READ_ARRAY_1 => -- 0031
            -- Read the startPtr from memory
            thrd2intrfc_opcode <= OPCODE_READ;
            thrd2intrfc_address <= Z32;
            return_state_next <= READ_ARRAY_2;
            next_state <= WAIT_STATE;

          when READ_ARRAY_2 => -- 0032
            startPtr_next <= toUser_value;
            -- Read the endPtr from memory
            thrd2intrfc_opcode <= OPCODE_READ;
            thrd2intrfc_address <= x"00000001";
            return_state_next <= READ_ARRAY_3;
            next_state <= WAIT_STATE;

          when READ_ARRAY_3 => -- 0033
            endPtr_next <= toUser_value;
            -- Read the leftPtr from memory
            thrd2intrfc_opcode <= OPCODE_READ;
            thrd2intrfc_address <= x"00000002";
            return_state_next <= READ_ARRAY_4;
            next_state <= WAIT_STATE;

          when READ_ARRAY_4 => -- 0034
            leftPtr_next <= toUser_value;
            -- Read the rightPtr from memory
            thrd2intrfc_opcode <= OPCODE_READ;
            thrd2intrfc_address <= x"00000003";
            return_state_next <= READ_ARRAY_5;
            next_state <= WAIT_STATE;

          when READ_ARRAY_5 => -- 0035
            rightPtr_next <= toUser_value;
            next_state <= READ_ARRAY_6;

          when READ_ARRAY_6 => -- 0037
            if ( cache = '1' ) then
              -- Recopy data
              next_state <= RECOPY_DATA_1;
            else
              next_state <= EXIT_THREAD_1;
            end if;

          when RECOPY_DATA_1 => -- 0061
            -- Push the number of bytes to allocate to stack
            thrd2intrfc_opcode <= OPCODE_PUSH;
            thrd2intrfc_value <= (rightPtr - leftPtr + 4);
            return_state_next <= RECOPY_DATA_2;
            next_state <= WAIT_STATE;

          when RECOPY_DATA_2 => -- 0062
            -- Push the address to start cpying from
            thrd2intrfc_opcode <= OPCODE_PUSH;
            thrd2intrfc_value <= leftPtr;
            return_state_next <= RECOPY_DATA_3;
            next_state <= WAIT_STATE;

          when RECOPY_DATA_3 => -- 0063
            -- Push the address to copy to
            thrd2intrfc_opcode <= OPCODE_PUSH;
            thrd2intrfc_value <= startPtr;
            return_state_next <= RECOPY_DATA_4;
            next_state <= WAIT_STATE;

          when RECOPY_DATA_4 => -- 0064
            -- Call mempy
            thrd2intrfc_opcode <= OPCODE_CALL;
            thrd2intrfc_function <= FUNCTION_MEMCPY;
            thrd2intrfc_value <= Z32(0 to 15) & U_FREE_1;
            return_state_next <= WAIT_STATE;
            next_state <= WAIT_STATE;

		  when FREE_1 =>
		    -- Push the address to free
			thrd2intrfc_opcode <= OPCODE_PUSH;
			thrd2intrfc_value <= leftPtr;
			return_state_next <= FREE_2;
			next_state <= WAIT_STATE;

		  when FREE_2 =>
		    -- Call free
            thrd2intrfc_opcode <= OPCODE_CALL;
            thrd2intrfc_function <= FUNCTION_FREE;
            thrd2intrfc_value <= Z32(0 to 15) & U_EXIT_THREAD_1;
            return_state_next <= WAIT_STATE;
            next_state <= WAIT_STATE;

          when COPY_DATA_1 => -- 0051
            -- Push the number of bytes to allocate to stack
            thrd2intrfc_opcode <= OPCODE_PUSH;
            thrd2intrfc_value <= (endPtr - startPtr + 4);
            return_state_next <= COPY_DATA_2;
            next_state <= WAIT_STATE;

          when COPY_DATA_2 => -- 0052
            -- Call the malloc function
            thrd2intrfc_opcode <= OPCODE_CALL;
            thrd2intrfc_function <= FUNCTION_MALLOC;
            thrd2intrfc_value <= Z32(0 to 15) & U_COPY_DATA_3;
            return_state_next <= WAIT_STATE;
            next_state <= WAIT_STATE;

          when COPY_DATA_3 => -- 0053
            -- Record the starting address of allocated data
            leftPtr_next <= toUser_value;
            -- Calculate the ending address of allocated dta
            rightPtr_next <= toUser_value + (endPtr - startPtr);
            -- Copy the data
            next_state <= COPY_DATA_4;

          when COPY_DATA_4 => -- 0054
            -- Push the number of bytes to copy
            thrd2intrfc_opcode <= OPCODE_PUSH;
            thrd2intrfc_value <= (endPtr - startPtr + 4);
            return_state_next <= COPY_DATA_5;
            next_state <= WAIT_STATE;

          when COPY_DATA_5 => -- 0055
            -- Push the address to start copying from
            thrd2intrfc_opcode <= OPCODE_PUSH;
            thrd2intrfc_value <= startPtr;
            return_state_next <= COPY_DATA_6;
            next_state <= WAIT_STATE;

          when COPY_DATA_6 => -- 0056
            -- Push the address to copy data to
            thrd2intrfc_opcode <= OPCODE_PUSH;
            thrd2intrfc_value <= leftPtr;
            return_state_next <= COPY_DATA_7;
            next_state <= WAIT_STATE;

          when COPY_DATA_7 => -- 0057
            -- Call memcopy
            thrd2intrfc_opcode <= OPCODE_CALL;
            thrd2intrfc_function <= FUNCTION_MEMCPY;
            thrd2intrfc_value <= Z32(0 to 15) & U_READ_SORTDATA_5;
            return_state_next <= WAIT_STATE;
            next_state <= WAIT_STATE;

          when EXIT_THREAD_1 => -- 0021
            -- Push a null argument onto stack, as required by hthread_exit;
            thrd2intrfc_opcode <= OPCODE_PUSH;
            thrd2intrfc_value <= Z32;
            return_state_next <= EXIT_THREAD_2;
            next_state <= WAIT_STATE;

          when EXIT_THREAD_2 => -- 0022
            -- Call exit thread
            thrd2intrfc_opcode <= OPCODE_CALL;
            thrd2intrfc_function <= FUNCTION_HTHREAD_EXIT;
            thrd2intrfc_value <= Z32(0 to 15) & U_FUNCTION_RESET;
            return_state_next <= WAIT_STATE;
            next_state <= WAIT_STATE;

          when ERROR_STATE => -- 7999
            next_state <= ERROR_STATE;

-----------------------------------------------------------------------
-- Quicksort function
-- argument 1 - start pointer
-- argument 2 - end pointer
-----------------------------------------------------------------------
          when QUICKSORT_1 => -- 0101
            -- Read the first argument
            thrd2intrfc_opcode <= OPCODE_POP;
            thrd2intrfc_value <= Z32;
            return_state_next <= QUICKSORT_2;
            next_state <= WAIT_STATE;

          when QUICKSORT_2 => -- 0102
            startPtr_next <= toUser_value;
            -- Read the second argument
            thrd2intrfc_opcode <= OPCODE_POP;
            thrd2intrfc_value <= x"00000001";
            return_state_next <= QUICKSORT_3;
            next_state <= WAIT_STATE;

          when QUICKSORT_3 => -- 0103
            endPtr_next <= toUser_value;
            next_state <= QUICKSORT_4;

          when QUICKSORT_4 => -- 0104
            -- Declare 5 variables
            thrd2intrfc_opcode <= OPCODE_DECLARE;
            thrd2intrfc_value <= x"00000002";
            return_state_next <= QUICKSORT_5;
            next_state <= WAIT_STATE;

          when QUICKSORT_5 => -- 0105
            -- Copy the start and end pointers
            leftPtr_next <= startPtr;
            rightPtr_next <= endPtr;
            next_state <= QUICKSORT_6;

          when QUICKSORT_6 => -- 0106
            -- check to see if left and right pointers are equal
            if ( leftPtr >= rightPtr ) then
              -- Nothing to sort, return
              next_state <= QUICKSORT_RETURN;
            else
              next_state <= QUICKSORT_7;
            end if;

          when QUICKSORT_7 => -- 0107
            -- Read the value of the leftPtr
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= leftPtr;
            return_state_next <= QUICKSORT_8;
            next_state <= WAIT_STATE;

          when QUICKSORT_8 => -- 0108
            left_next <= toUser_value;
            -- Read the value of the rightPtr
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= rightPtr;
            return_state_next <= QUICKSORT_9;
            next_state <= WAIT_STATE;

          when QUICKSORT_9 => -- 0109
            right_next <= toUser_value;
            next_state <= QUICKSORT_A;

          when QUICKSORT_A => -- 010A
            -- determine the pivot value by first taking sum of left and right
            pivot_next <= left + right;
            next_state <= QUICKSORT_B;

          when QUICKSORT_B => -- 010B
            -- next divide the sum of left and right by two (or shift)
            pivot_next <= '0' & pivot(0 to 30);
            next_state <= QUICKSORT_DO;

          when QUICKSORT_DO => -- 0111
            -- This is a placeholder for my own sanity
            next_state <= QUICKSORT_WHILE_LEFT_0;

          when QUICKSORT_WHILE_LEFT_0 => -- 0121
            -- check to see if leftPtr moved past rightPtr
            if ( leftPtr < rightPtr ) then
              next_state <= QUICKSORT_WHILE_LEFT_1;
            else
              leftPtr_next <= rightPtr;
              next_state <= QUICKSORT_BREAK;
            end if;

          when QUICKSORT_WHILE_LEFT_1 => -- 0121
            -- check to see if left < pivot
            if ( left <= pivot ) then
              -- left does not have to be swapped, increment leftPtr
              leftPtr_next <= leftPtr + 4;
              next_state <= QUICKSORT_WHILE_LEFT_2;
            else
              -- left needs to be swapped, end the while loop
              next_state <= QUICKSORT_BREAK;
            end if;

          when QUICKSORT_WHILE_LEFT_2 => -- 0122
            -- read value of leftPtr
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= leftPtr;
            return_state_next <= QUICKSORT_WHILE_LEFT_3;
            next_state <= WAIT_STATE;

          when QUICKSORT_WHILE_LEFT_3 => -- 0123
            left_next <= toUser_value;
            next_state <= QUICKSORT_WHILE_LEFT_0;

          when QUICKSORT_BREAK => -- 0131
            -- Check that we did not move past right ptr
            if ( leftPtr >= rightPtr ) then
              -- we are done swapping
              next_state <= QUICKSORT_CALL_QS_0;
            else
              next_state <= QUICKSORT_WHILE_RIGHT_1;
            end if;

         when QUICKSORT_WHILE_RIGHT_1 => -- 0141
            -- check to see if right < pivot
            if ( right > pivot ) then
              -- right does not have to be swapped, decrement rightPtr 
              rightPtr_next <= rightPtr - 4;
              next_state <= QUICKSORT_WHILE_RIGHT_2;
            else
              -- right needs to be swapped, end the while loop
              next_state <= QUICKSORT_SWAP_1;
            end if;

          when QUICKSORT_WHILE_RIGHT_2 => -- 0142
            -- read value of rightPtr
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= rightPtr;
            return_state_next <= QUICKSORT_WHILE_RIGHT_3;
            next_state <= WAIT_STATE;

          when QUICKSORT_WHILE_RIGHT_3 => -- 0143
            right_next <= toUser_value;
            next_state <= QUICKSORT_BREAK;

          when QUICKSORT_SWAP_1 => -- 0151
            -- write the value of rightPtr with left
            thrd2intrfc_opcode <= OPCODE_STORE;
            thrd2intrfc_address <= rightPtr;
            thrd2intrfc_value <= left;
            return_state_next <= QUICKSORT_SWAP_2;
            next_state <= WAIT_STATE;

          when QUICKSORT_SWAP_2 => -- 0152
            -- write the value of leftPtr with right
            thrd2intrfc_opcode <= OPCODE_STORE;
            thrd2intrfc_address <= leftPtr;
            thrd2intrfc_value <= right;
            return_state_next <= QUICKSORT_SWAP_3;
            next_state <= WAIT_STATE;

          when QUICKSORT_SWAP_3 => -- 0153
            -- increment/decrement pointers
            leftPtr_next <= leftPtr + 4;
            rightPtr_next <= rightPtr - 4;
            next_state <= QUICKSORT_SWAP_4;

          when QUICKSORT_SWAP_4 => -- 0154
            -- read new value of left
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= leftPtr;
            return_state_next <= QUICKSORT_SWAP_5;
            next_state <= WAIT_STATE;

          when QUICKSORT_SWAP_5 => -- 0155
            left_next <= toUser_value;
            -- read new value of right
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= rightPtr;
            return_state_next <= QUICKSORT_WHILE;
            next_state <= WAIT_STATE;

          when QUICKSORT_WHILE => -- 0161
            right_next <= toUser_value;
            -- check to make sure leftPtr < rightPtr
            if ( leftPtr < rightPtr ) then
              next_state <= QUICKSORT_DO;
            else
              next_state <= QUICKSORT_CALL_QS_0;
            end if;

          when QUICKSORT_CALL_QS_0 => -- 0170
            -- Check to see if leftPtr == rightPtr
            if ( leftPtr = rightPtr ) then
              -- Check to see if right > pivot
              if ( right >= pivot ) then
                leftPtr_next <= rightPtr - 4;
              else
                rightPtr_next <= rightPtr + 4;
              end if;
            else 
              if ( right > pivot ) then
                leftPtr_next <= rightPtr - 4;
              else
                leftPtr_next <= rightPtr;
                rightPtr_next <= leftPtr;
              end if;
            end if;
            next_state <= QUICKSORT_CALL_QS_1;

          when QUICKSORT_CALL_QS_1 => -- 0171
            -- Before calling quicksort need to save rightPtr and endPtr
            -- Save the rightPtr
            thrd2intrfc_opcode <= OPCODE_WRITE;
            thrd2intrfc_address <= x"00000000";
            thrd2intrfc_value <= rightPtr;
            return_state_next <= QUICKSORT_CALL_QS_2;
            next_state <= WAIT_STATE;

          when QUICKSORT_CALL_QS_2 => -- 0172
            -- Save the endPtr
            thrd2intrfc_opcode <= OPCODE_WRITE;
            thrd2intrfc_address <= x"00000001";
            thrd2intrfc_value <= endPtr;
            return_state_next <= QUICKSORT_CALL_QS_3;
            next_state <= WAIT_STATE;

          when QUICKSORT_CALL_QS_3 => -- 0173
            -- Push the leftPtr
            thrd2intrfc_opcode <= OPCODE_PUSH;
            thrd2intrfc_value <= leftPtr;
            return_state_next <= QUICKSORT_CALL_QS_4;
            next_state <= WAIT_STATE;

          when QUICKSORT_CALL_QS_4 => -- 0174
            -- Push the startPtr 
            thrd2intrfc_opcode <= OPCODE_PUSH;
            thrd2intrfc_value <= startPtr;
            return_state_next <= QUICKSORT_CALL_QS_5;
            next_state <= WAIT_STATE;

          when QUICKSORT_CALL_QS_5 => -- 0175
            -- Call quicksort
            thrd2intrfc_opcode <= OPCODE_CALL;
            thrd2intrfc_function <= U_QUICKSORT_1;
            thrd2intrfc_value <= Z32(0 to 15) & U_QUICKSORT_CALL_QS_6;
            return_state_next <= WAIT_STATE;
            next_state <= WAIT_STATE;

          when QUICKSORT_CALL_QS_6 => -- 0176
            -- read the value of endPtr
            thrd2intrfc_opcode <= OPCODE_READ;
            thrd2intrfc_address <= x"00000001";
            return_state_next <= QUICKSORT_CALL_QS_7;
            next_state <= WAIT_STATE;

          when QUICKSORT_CALL_QS_7 => -- 0177
            endPtr_next <= toUser_value;
            -- read the value of rightPtr
            thrd2intrfc_opcode <= OPCODE_READ;
            thrd2intrfc_address <= x"00000000";
            return_state_next <= QUICKSORT_CALL_QS_8;
            next_state <= WAIT_STATE;

          when QUICKSORT_CALL_QS_8 => -- 0178
            rightPtr_next <= toUser_value;
            -- Push the rightPtr
            thrd2intrfc_opcode <= OPCODE_PUSH;
            thrd2intrfc_value <= endPtr;
            return_state_next <= QUICKSORT_CALL_QS_9;
            next_state <= WAIT_STATE;

          when QUICKSORT_CALL_QS_9 => -- 0179
            -- push the endPtr
            thrd2intrfc_opcode <= OPCODE_PUSH;
            thrd2intrfc_value <= rightPtr;
            return_state_next <= QUICKSORT_CALL_QS_A;
            next_state <= WAIT_STATE;

          when QUICKSORT_CALL_QS_A => -- 017A
            -- Call quicksort
            thrd2intrfc_opcode <= OPCODE_CALL;
            thrd2intrfc_function <= U_QUICKSORT_1;
            thrd2intrfc_value <= Z32(0 to 15) & U_QUICKSORT_RETURN;
            return_state_next <= WAIT_STATE;
            next_state <= WAIT_STATE;

          when QUICKSORT_RETURN => -- 0181
            -- Return
            thrd2intrfc_opcode <= OPCODE_RETURN;
            thrd2intrfc_value <= Z32;
            return_state_next <= ERROR_STATE;
            next_state <= WAIT_STATE;

          when WAIT_STATE => 
            case toUser_goWait is
              when '1' => --Here because HWTUL chose to be here for one clock cycle
                next_state <= return_state;
              when OTHERS => --ie '0', Here because HWTI is telling us to wait
                next_state <= return_state;
            end case;

          when others =>
            next_state <= ERROR_STATE;

        end case;
      
  end process HWTUL_STATE_MACHINE;
end architecture IMP;
