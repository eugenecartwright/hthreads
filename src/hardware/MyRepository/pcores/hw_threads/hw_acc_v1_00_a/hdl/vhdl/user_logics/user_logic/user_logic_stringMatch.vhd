---------------------------------------------------------------------------
--
--  Title: Hardware Thread User Logic String Match
--  Thread implements a string matching routine
--  Passed in argument is a pointer to following struct
--  struct threadArgument {
--    hthread_mutex_t * mutex;
--    int * packetIndex;
--    int * foundStringIndex;
--    int * foundStrings;
--    int sPrimaryCount;
--    int sSecondaryCount;
--    char * T;
-- };
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
    FUNCTION_START,
    READ_STRUCT_1,
    READ_STRUCT_2,
    READ_STRUCT_4,
    READ_STRUCT_5,
    READ_STRUCT_6,
    READ_STRUCT_7,
    READ_STRUCT_8,
    READ_STRUCT_9,
    ALLOCATE_MEMORY_1,
    ALLOCATE_MEMORY_2,
    ALLOCATE_MEMORY_3,
    ALLOCATE_MEMORY_4,
    ALLOCATE_MEMORY_5,
    INDEX_MUTEXLOCK_1,
    INDEX_MUTEXLOCK_2,
    INDEX_INCREMENT_1,
    INDEX_INCREMENT_2,
    INDEX_MUTEXUNLOCK_1,
    INDEX_MUTEXUNLOCK_2,
    INDEX_CHECK_1,
    INDEX_CHECK_2,
    COPY_T_1,
    COPY_T_2,
    COPY_T_3,
    COPY_T_4,
    CHAR_MATCH_LOOP_1,
    CHAR_MATCH_LOOP_2,
    CHAR_MATCH_LOOP_3,
    --CHAR_MATCH_LOOP_4,
    --CHAR_MATCH_LOOP_5,
    CHAR_MATCH_LOOP_6,
    CHAR_MATCH_LOOP_7,
    CHAR_MATCH_LOOP_8,
    CHAR_MATCH_LOOP_9,
    CHAR_MATCH_LOOP_10,
    CHAR_MATCH_LOOP_11,
    CHAR_MATCH_LOOP_12,
    CHAR_MATCH_LOOP_13,
    CHAR_MATCH_LOOP_14,
    EXIT_THREAD_1,
    SEARCH_1,
    SEARCH_2,
    SEARCH_3,
    SEARCH_4,
    SEARCH_5,
    SEARCH_6,
    SEARCH_6a,
    SEARCH_7,
    SEARCH_8,
    MATCH_1,
    MATCH_2,
    MATCH_3,
    MATCH_3a,
    MATCH_3b,
    MATCH_4,
    MATCH_5,
    MATCH_6,
    MATCH_7,
    MATCH_8,
    MATCH_9,
    MATCH_10,
    MATCH_11,
    MATCH_12,
    MATCH_13,
    MATCH_14,
    MATCH_15,
    MATCH_16,
    MATCH_17,
    MATCH_18,
    MATCH_19,
    MATCH_20,
    MATCH_21,
    MATCH_22,
    REPORT_STRING_1,
    REPORT_STRING_2,
    REPORT_STRING_3,
    REPORT_STRING_4,
    REPORT_STRING_5,
    REPORT_STRING_6,
    REPORT_STRING_7,
    REPORT_STRING_8,
    REPORT_STRING_9,
    REPORT_STRING_10,
    REPORT_STRING_11,
    REPORT_STRING_12,
    WAIT_STATE,
    ERROR_STATE);

  -- Function definitions
  constant C_FUNCTION_RESET                    : std_logic_vector(0 to 15) := x"0000";
  constant C_FUNCTION_WAIT                     : std_logic_vector(0 to 15) := x"0001";
  constant C_FUNCTION_USER_SELECT              : std_logic_vector(0 to 15) := x"0002";
  constant C_FUNCTION_START                    : std_logic_vector(0 to 15) := x"0003";
  constant C_ALLOCATE_MEMORY_3                 : std_logic_vector(0 to 15) := x"0103";
  constant C_ALLOCATE_MEMORY_5                 : std_logic_vector(0 to 15) := x"0105";
  constant C_INDEX_INCREMENT_1                 : std_logic_vector(0 to 15) := x"0201";
  constant C_INDEX_CHECK_2                     : std_logic_vector(0 to 15) := x"0302";
  constant C_INDEX_MUTEXUNLOCK_1               : std_logic_vector(0 to 15) := x"0801";
  constant C_CHAR_MATCH_LOOP_11                : std_logic_vector(0 to 15) := x"0411";
  constant C_CHAR_MATCH_LOOP_14                : std_logic_vector(0 to 15) := x"0414";
  constant C_MATCH_1                           : std_logic_vector(0 to 15) := x"0501";
  constant C_MATCH_12                          : std_logic_vector(0 to 15) := x"0512";
  constant C_MATCH_15                          : std_logic_vector(0 to 15) := x"0515";
  constant C_MATCH_18                          : std_logic_vector(0 to 15) := x"0518";
  constant C_REPORT_STRING_1                   : std_logic_vector(0 to 15) := x"0701";
  constant C_REPORT_STRING_5                   : std_logic_vector(0 to 15) := x"0705";
  constant C_REPORT_STRING_11                  : std_logic_vector(0 to 15) := x"0711";

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
  constant FUNCTION_HTHREAD_MUTEXATTR_INIT     : std_logic_vector(0 to 15) := x"8020";
  constant FUNCTION_HTHREAD_MUTEXATTR_DESTROY  : std_logic_vector(0 to 15) := x"8021";
  constant FUNCTION_HTHREAD_MUTEXATTR_SETNUM   : std_logic_vector(0 to 15) := x"8022";
  constant FUNCTION_HTHREAD_MUTEXATTR_GETNUM   : std_logic_vector(0 to 15) := x"8023";
  constant FUNCTION_HTHREAD_MUTEX_INIT         : std_logic_vector(0 to 15) := x"8030";
  constant FUNCTION_HTHREAD_MUTEX_DESTROY      : std_logic_vector(0 to 15) := x"8031";
  constant FUNCTION_HTHREAD_MUTEX_LOCK         : std_logic_vector(0 to 15) := x"8032";
  constant FUNCTION_HTHREAD_MUTEX_UNLOCK       : std_logic_vector(0 to 15) := x"8033";
  constant FUNCTION_HTHREAD_MUTEX_TRYLOCK      : std_logic_vector(0 to 15) := x"8034";
  -- constant FUNCTION_HTHREAD_CONDATTR_INIT      : std_logic_vector(0 to 15) := x"8040";
  -- constant FUNCTION_HTHREAD_CONDATTR_DESTROY   : std_logic_vector(0 to 15) := x"8041";
  -- constant FUNCTION_HTHREAD_CONDATTR_SETNUM    : std_logic_vector(0 to 15) := x"8042";
  -- constant FUNCTION_HTHREAD_CONDATTR_GETNUM    : std_logic_vector(0 to 15) := x"8043";
  constant FUNCTION_HTHREAD_COND_INIT          : std_logic_vector(0 to 15) := x"8050";
  constant FUNCTION_HTHREAD_COND_DESTROY       : std_logic_vector(0 to 15) := x"8051";
  constant FUNCTION_HTHREAD_COND_SIGNAL        : std_logic_vector(0 to 15) := x"8052";
  constant FUNCTION_HTHREAD_COND_BROADCAST     : std_logic_vector(0 to 15) := x"8053";
  constant FUNCTION_HTHREAD_COND_WAIT          : std_logic_vector(0 to 15) := x"8054";
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
  
  constant C_PACKET_LENGTH                     : std_logic_vector(0 to 31) := x"00000400";
  constant C_NUMBER_PACKETS                    : std_logic_vector(0 to 7) := x"64";

  signal current_state, next_state : state_machine := FUNCTION_RESET;
  signal return_state, return_state_next : state_machine := FUNCTION_RESET;
  
  signal mutexPtr, mutexPtr_next : std_logic_vector(0 to 31);
  signal packetIndexPtr, packetIndexPtr_next : std_logic_vector(0 to 31);
  signal foundStringIndexPtr, foundStringIndexPtr_next : std_logic_vector(0 to 31);
  signal foundStringsPtr, foundStringsPtr_next : std_logic_vector(0 to 31);
  signal sPrimaryCount, sPrimaryCount_next : std_logic_vector(0 to 11);
  signal sPrimaryPtr, sPrimaryPtr_next : std_logic_vector(0 to 31);
  signal TPtr, TPtr_next : std_logic_vector(0 to 31);
  signal i, i_next : std_logic_vector(0 to 9);
  signal localTPtr, localTPtr_next : std_logic_vector(0 to 31);
  signal reg1, reg1_next : std_logic_vector(0 to 31);
  signal reg2, reg2_next : std_logic_vector(0 to 31);
  signal reg3, reg3_next : std_logic_vector(0 to 31);
  signal reg4, reg4_next : std_logic_vector(0 to 31);
  
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

      mutexPtr <= mutexPtr_next;
      packetIndexPtr <= packetIndexPtr_next;
	  foundStringIndexPtr <= foundStringIndexPtr_next;
	  foundStringsPtr <= foundStringsPtr_next;
	  sPrimaryCount <= sPrimaryCount_next;
	  sPrimaryPtr <= sPrimaryPtr_next;
	  TPtr <= TPtr_next;
	  i <= i_next;
      localTPtr <= localTPtr_next;
      reg1 <= reg1_next;
      reg2 <= reg2_next;
      reg3 <= reg3_next;
      reg4 <= reg4_next;
      return_state <= return_state_next;

      -- Find out if the HWTI is tell us what to do
      if (intrfc2thrd_goWait = '1') then
        case intrfc2thrd_function is
          -- Typically the HWTI will tell us to control our own destiny
          when C_FUNCTION_USER_SELECT =>
            current_state <= next_state;

          -- List all the functions the HWTI could tell us to run
          when C_FUNCTION_RESET =>
            current_state <= FUNCTION_RESET;
          when C_FUNCTION_START =>
            current_state <= FUNCTION_START;
          when C_ALLOCATE_MEMORY_3 =>
            current_state <= ALLOCATE_MEMORY_3;
          when C_ALLOCATE_MEMORY_5 =>
            current_state <= ALLOCATE_MEMORY_5;
          when C_INDEX_INCREMENT_1 =>
            current_state <= INDEX_INCREMENT_1;
          when C_INDEX_CHECK_2 =>
            current_state <= INDEX_CHECK_2;
          when C_INDEX_MUTEXUNLOCK_1 =>
            current_state <= INDEX_MUTEXUNLOCK_1;
          when C_CHAR_MATCH_LOOP_11 =>
            current_state <= CHAR_MATCH_LOOP_11;
          when C_CHAR_MATCH_LOOP_14 =>
            current_state <= CHAR_MATCH_LOOP_14;
          when C_MATCH_1 =>
            current_state <= MATCH_1;
          when C_MATCH_12 =>
            current_state <= MATCH_12;
          when C_MATCH_15 =>
            current_state <= MATCH_15;
          when C_MATCH_18 =>
            current_state <= MATCH_18;
          when C_REPORT_STRING_1 =>
            current_state <= REPORT_STRING_1;
          when C_REPORT_STRING_5 =>
            current_state <= REPORT_STRING_5;
          when C_REPORT_STRING_11 =>
            current_state <= REPORT_STRING_11;

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
    thrd2intrfc_function <= C_FUNCTION_USER_SELECT;
    next_state <= current_state;
    return_state_next <= return_state;

    mutexPtr_next <= mutexPtr;
    packetIndexPtr_next <= packetIndexPtr;
	foundStringIndexPtr_next <= foundStringIndexPtr;
	foundStringsPtr_next <= foundStringsPtr;
	sPrimaryCount_next <= sPrimaryCount;
	sPrimaryPtr_next <= sPrimaryPtr;
	TPtr_next <= TPtr;
	i_next <= i;
	localTPtr_next <= localTPtr;
	reg1_next <= reg1;
	reg2_next <= reg2;
	reg3_next <= reg3;
	reg4_next <= reg4;

    -- The state machine
        case current_state is
          when FUNCTION_RESET =>
            --Set default values
            thrd2intrfc_opcode <= OPCODE_NOOP;
            thrd2intrfc_address <= Z32;
            thrd2intrfc_value <= Z32;
            thrd2intrfc_function <= C_FUNCTION_START;
            mutexPtr_next <= (others => '0');
            packetIndexPtr_next <= (others => '0');
            foundStringIndexPtr_next <= (others => '0');
            foundStringsPtr_next <= (others => '0');
            sPrimaryCount_next <= (others => '0');
            sPrimaryPtr_next <= (others => '0');
            -- sSecondaryCount_next <= (others => '0');
            TPtr_next <= (others => '0');
            localTPtr_next <= (others => '0');
            i_next <= (others => '0');
            reg1_next <= (others => '0');
            reg2_next <= (others => '0');
            reg3_next <= (others => '0');
            reg4_next <= (others => '0');

          when FUNCTION_START =>
            -- read the passed in argument
            thrd2intrfc_opcode <= OPCODE_POP;
            thrd2intrfc_address <= Z32;
            return_state_next <= READ_STRUCT_1;
            next_state <= WAIT_STATE;
    
          -- argument = (struct threadArgument *) arg;
          when READ_STRUCT_1 =>
            -- reg1 will hold address of passed in struct
            reg1_next <= toUser_value;
            -- Read the mutex address
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= toUser_value;
            return_state_next <= READ_STRUCT_2;
            next_state <= WAIT_STATE;

          when READ_STRUCT_2 =>
            mutexPtr_next <= toUser_value;
            -- Read the packetIndexPtr address
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= reg1 + 4;
            return_state_next <= READ_STRUCT_4;
            next_state <= WAIT_STATE;

          when READ_STRUCT_4 =>
            packetIndexPtr_next <= toUser_value;
            -- Read the foundStringIndex address
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= reg1 + 8;
            return_state_next <= READ_STRUCT_5;
            next_state <= WAIT_STATE;

          when READ_STRUCT_5 =>
            foundStringIndexPtr_next <= toUser_value;
            -- Read the foundStrings address
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= reg1 + 12;
            return_state_next <= READ_STRUCT_6;
            next_state <= WAIT_STATE;

          when READ_STRUCT_6 =>
            foundStringsPtr_next <= toUser_value;
            -- Read the sPrimaryCount value
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= reg1 + 16;
            return_state_next <= READ_STRUCT_7;
            next_state <= WAIT_STATE;

          when READ_STRUCT_7 =>
            sPrimaryCount_next <= toUser_value(20 to 31);
            -- Read the sSecondaryCount value
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= reg1 + 20;
            return_state_next <= READ_STRUCT_8;
            next_state <= WAIT_STATE;

          when READ_STRUCT_8 =>
            reg2_next <= toUser_value;
            -- Read the T address
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= reg1 + 24;
            return_state_next <= READ_STRUCT_9;
            next_state <= WAIT_STATE;

          when READ_STRUCT_9 =>
            TPtr_next <= toUser_value;
            next_state <= ALLOCATE_MEMORY_1;

          --Need to allocate two chunks of memory.  The first is to hold the
          --local copy of T.  The second, is to hold the S data structures.
          -- localTPtr = malloc( C_PACKET_LENGTH );
          when ALLOCATE_MEMORY_1 =>
            thrd2intrfc_opcode <= OPCODE_PUSH;
            thrd2intrfc_value <= C_PACKET_LENGTH;
            return_state_next <= ALLOCATE_MEMORY_2;
            next_state <= WAIT_STATE;

          when ALLOCATE_MEMORY_2 =>
            thrd2intrfc_opcode <= OPCODE_CALL;
            thrd2intrfc_value <= Z32(0 to 15) & C_ALLOCATE_MEMORY_3;
            thrd2intrfc_function <= FUNCTION_MALLOC;
            next_state <= WAIT_STATE;

          when ALLOCATE_MEMORY_3 =>
            localTPtr_next <= toUser_value;
            -- malloc( (reg2 + sPrimaryCount) * 8 )
            -- reg2 holds size of sSecondaryCount that was pushed to this thread
            -- 8 is the length of a data element in S
            thrd2intrfc_opcode <= OPCODE_PUSH;
            thrd2intrfc_value <= (reg2(3 to 31) + ("0000000000000000" & sPrimaryCount)) & "000";
            return_state_next <= ALLOCATE_MEMORY_4;
            next_state <= WAIT_STATE;

          when ALLOCATE_MEMORY_4 =>
            -- decrementing sPrimaryCount here, so I don't have to instantiate a second adder in the search routine
            sPrimaryCount_next <= sPrimaryCount - 1;
            -- now back to our regularly scheduled statemachine
            thrd2intrfc_opcode <= OPCODE_CALL;
            thrd2intrfc_value <= Z32(0 to 15) & C_ALLOCATE_MEMORY_5;
            thrd2intrfc_function <= FUNCTION_MALLOC;
            next_state <= WAIT_STATE;

          when ALLOCATE_MEMORY_5 =>
            sPrimaryPtr_next <= toUser_value;
            next_state <= INDEX_MUTEXLOCK_1;

          -- while( 1 ) {
          -- hthread_mutex_lock( argument->mutex );
          when INDEX_MUTEXLOCK_1 =>
            thrd2intrfc_opcode <= OPCODE_PUSH;
            thrd2intrfc_value <= mutexPtr;
            return_state_next <= INDEX_MUTEXLOCK_2;
            next_state <= WAIT_STATE;

          when INDEX_MUTEXLOCK_2 =>
            thrd2intrfc_opcode <= OPCODE_CALL;
            thrd2intrfc_value <= Z32(0 to 15) & C_INDEX_INCREMENT_1;
            thrd2intrfc_function <= FUNCTION_HTHREAD_MUTEX_LOCK;
            next_state <= WAIT_STATE;

          -- index = *argument->packetIndex;
          when INDEX_INCREMENT_1 =>
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= packetIndexPtr;
            return_state_next <= INDEX_INCREMENT_2;
            next_state <= WAIT_STATE;

          -- *argument->packetIndex = index + 1;
          when INDEX_INCREMENT_2 =>
            -- reg1 now holds the index into T (the argument ptr is not longer needed)
            reg1_next <= toUser_value;
            thrd2intrfc_opcode <= OPCODE_STORE;
            thrd2intrfc_address <= packetIndexPtr;
            thrd2intrfc_value <= toUser_value + 1;
            return_state_next <= INDEX_CHECK_1;
            next_state <= WAIT_STATE;

          -- if ( index >= NUMBER_PACKETS ) break;
          when INDEX_CHECK_1 =>
            if ( reg1(24 to 31) >= C_NUMBER_PACKETS ) then
              next_state <= INDEX_MUTEXUNLOCK_1;
            else
              next_state <= COPY_T_1;
            end if;

          -- T = &argument->T[ index * C_PACKET_LENGTH ];
          -- implemented as
          -- memcpy( T[index * C_PACKET_LENGTH], localT, C_PACKET_LENGTH )
          when COPY_T_1 =>
            thrd2intrfc_opcode <= OPCODE_PUSH;
            thrd2intrfc_value <= C_PACKET_LENGTH;
            return_state_next <= COPY_T_2;
            next_state <= WAIT_STATE;

          when COPY_T_2 =>
            thrd2intrfc_opcode <= OPCODE_PUSH;
            thrd2intrfc_value <= TPtr + (reg1(10 to 31) & "0000000000");
            return_state_next <= COPY_T_3;
            next_state <= WAIT_STATE;

          when COPY_T_3 =>
            thrd2intrfc_opcode <= OPCODE_PUSH;
            thrd2intrfc_value <= localTPtr;
            return_state_next <= COPY_T_4;
            next_state <= WAIT_STATE;

          when COPY_T_4 =>
            thrd2intrfc_opcode <= OPCODE_CALL;
            thrd2intrfc_value <= Z32(0 to 15) & C_INDEX_MUTEXUNLOCK_1;
            thrd2intrfc_function <= FUNCTION_MEMCPY;
            next_state <= WAIT_STATE;

          -- hthread_mutex_unlock( argument->mutex );
          when INDEX_MUTEXUNLOCK_1 =>
            thrd2intrfc_opcode <= OPCODE_PUSH;
            thrd2intrfc_value <= mutexPtr;
            return_state_next <= INDEX_MUTEXUNLOCK_2;
            next_state <= WAIT_STATE;

          when INDEX_MUTEXUNLOCK_2 =>
            thrd2intrfc_opcode <= OPCODE_CALL;
            thrd2intrfc_value <= Z32(0 to 15) & C_INDEX_CHECK_2;
            thrd2intrfc_function <= FUNCTION_HTHREAD_MUTEX_UNLOCK;
            next_state <= WAIT_STATE;

          when INDEX_CHECK_2 =>
            if ( reg1(24 to 31) >= C_NUMBER_PACKETS ) then
              next_state <= EXIT_THREAD_1;
            else
              next_state <= CHAR_MATCH_LOOP_1;
            end if;

          -- for( i = 0; i<1021; i++ ) {
          when CHAR_MATCH_LOOP_1 =>
            i_next <= (others => '0');
            next_state <= CHAR_MATCH_LOOP_2;

          when CHAR_MATCH_LOOP_2 =>
            case i is
              when "1111111101" =>
                next_state <= INDEX_MUTEXLOCK_1;
              when others =>
                next_state <= CHAR_MATCH_LOOP_3;
            end case;

          -- charString = *(unsigned int *)&T[i];
          when CHAR_MATCH_LOOP_3 =>
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= localTPtr(0 to 21) & (localTPtr(22 to 31) + i);
            --return_state_next <= CHAR_MATCH_LOOP_4;
            return_state_next <= SEARCH_1;
            next_state <= WAIT_STATE;

          -- subStringPtr = search( charString );
          --when CHAR_MATCH_LOOP_4 =>
          --  thrd2intrfc_opcode <= OPCODE_PUSH;
          --  thrd2intrfc_value <= toUser_value;
          --  return_state_next <= CHAR_MATCH_LOOP_5;
          --  next_state <= WAIT_STATE;

          --when CHAR_MATCH_LOOP_5 =>
          --  thrd2intrfc_opcode <= OPCODE_CALL;
          --  thrd2intrfc_value <= Z32(0 to 15) & C_CHAR_MATCH_LOOP_6;
          --  thrd2intrfc_function <= C_SEARCH_1;
          --  next_state <= WAIT_STATE;

          -- if ( subStringPtr != NULL ) {
          when CHAR_MATCH_LOOP_6 =>
            --case toUser_value is
            case reg1 is
              when Z32 =>
                next_state <= CHAR_MATCH_LOOP_14;
              when others =>
                -- reg1_next <= toUser_value;
                next_state <= CHAR_MATCH_LOOP_7;
            end case;

          -- if ( subStringPtr->stringNumber > 0 ) {
          when CHAR_MATCH_LOOP_7 =>
            --load the data portion of the S dataset
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= reg1 + 4;
            return_state_next <= CHAR_MATCH_LOOP_8;
            next_state <= WAIT_STATE;

          when CHAR_MATCH_LOOP_8 =>
            reg2_next <= toUser_value;
            --inspect the stringNumber portion of datapacket
            case toUser_value(2 to 13) is
              when "000000000000" =>
                -- so far, the match does not represent a string
                next_state <= CHAR_MATCH_LOOP_11;
              when others =>
                next_state <= CHAR_MATCH_LOOP_9;
            end case;

          -- reportString( subStringPtr->stringNumber );
          when CHAR_MATCH_LOOP_9 =>
            thrd2intrfc_opcode <= OPCODE_PUSH;
            thrd2intrfc_value <= Z32(0 to 19) & reg2(2 to 13);
            return_state_next <= CHAR_MATCH_LOOP_10;
            next_state <= WAIT_STATE;

          when CHAR_MATCH_LOOP_10 =>
            thrd2intrfc_opcode <= OPCODE_CALL;
            thrd2intrfc_value <= Z32(0 to 15) & C_CHAR_MATCH_LOOP_11;
            thrd2intrfc_function <= C_REPORT_STRING_1;
            next_state <= WAIT_STATE;

          -- match( T, i, subStringPtr->nextPtr );
          when CHAR_MATCH_LOOP_11 =>
		    --Check that the nextPtr is not zero
		    case reg2(15 to 31) is
			  when "00000000000000000" =>
			    next_state <= CHAR_MATCH_LOOP_14;
			  when OTHERS =>
                thrd2intrfc_opcode <= OPCODE_PUSH;
                thrd2intrfc_value <= x"630" & reg2(15 to 31) & "000";
                return_state_next <= CHAR_MATCH_LOOP_12;
                next_state <= WAIT_STATE;
			end case;

          when CHAR_MATCH_LOOP_12 =>
            thrd2intrfc_opcode <= OPCODE_PUSH;
            thrd2intrfc_value <= Z32(0 to 21) & i;
            return_state_next <= CHAR_MATCH_LOOP_13;
            next_state <= WAIT_STATE;

          when CHAR_MATCH_LOOP_13 =>
            thrd2intrfc_opcode <= OPCODE_CALL;
            thrd2intrfc_value <= Z32(0 to 15) & C_CHAR_MATCH_LOOP_14;
            thrd2intrfc_function <= C_MATCH_1;
            next_state <= WAIT_STATE;

          -- continuation of: for( i = 0; i<1021; i++ ) {
          when CHAR_MATCH_LOOP_14 =>
            i_next <= i + 1;
            next_state <= CHAR_MATCH_LOOP_2;

          when EXIT_THREAD_1 =>
            -- Return
            thrd2intrfc_opcode <= OPCODE_RETURN;
            thrd2intrfc_value <= Z32;
            next_state <= WAIT_STATE;

--------------------------------------------------------------------------------
-- struct subString * search (unsigned int charString) {
-- reg1 = charString
-- reg2 = lowIndex
-- reg3 = highIndex
-- reg4 = midIndex
-- reg5 = value of ptr
--------------------------------------------------------------------------------
          -- int lowIndex = 0;
          -- int highIndex = globalSPrimaryCount-1;
          when SEARCH_1 =>
		    reg1_next <= toUser_value;
            -- initializing variables as pointers instead of indexes
            -- note that sPrimaryCount was decremented in ALLOCATE_MEMORY_4
            reg2_next <= sPrimaryPtr;
            reg3_next <= sPrimaryPtr(0 to 16) & (sPrimaryPtr(17 to 28) + sPrimaryCount) & "000";
            -- pop the charString
            --thrd2intrfc_opcode <= OPCODE_POP;
            --thrd2intrfc_value <= Z32;
            return_state_next <= SEARCH_2;
            next_state <= WAIT_STATE;

          -- if ( charString < globalSPrimary[lowIndex].charString ) return NULL;
          -- if ( charString == globalSPrimary[lowIndex].charString ) return &globalSPrimary[lowIndex];
          when SEARCH_2 =>
            --reg1_next <= toUser_value;
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= reg2;
            return_state_next <= SEARCH_3;
            next_state <= WAIT_STATE;

          when SEARCH_3 =>
            if ( reg1 < toUser_value ) then
              --thrd2intrfc_opcode <= OPCODE_RETURN;
              --thrd2intrfc_value <= Z32;
              --next_state <= WAIT_STATE;
			  reg1_next <= Z32;
			  next_state <= CHAR_MATCH_LOOP_6;
            elsif (reg1 = toUser_value ) then
              --thrd2intrfc_opcode <= OPCODE_RETURN;
              --thrd2intrfc_value <= reg2;
              --next_state <= WAIT_STATE;            
			  reg1_next <= reg2;
			  next_state <= CHAR_MATCH_LOOP_6;
            else
              next_state <= SEARCH_4;
            end if;

          -- if ( charString > globalSPrimary[highIndex].charString ) return NULL; 
          -- if ( charString == globalSPrimary[highIndex].charString ) return &globalSPrimary[highIndex];
          when SEARCH_4 =>
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= reg3;
            return_state_next <= SEARCH_5;
            next_state <= WAIT_STATE;

          when SEARCH_5 =>
            if ( reg1 > toUser_value ) then
              --thrd2intrfc_opcode <= OPCODE_RETURN;
              --thrd2intrfc_value <= Z32;
              --next_state <= WAIT_STATE;
			  reg1_next <= Z32;
			  next_state <= CHAR_MATCH_LOOP_6;
            elsif (reg1 = toUser_value ) then
              --thrd2intrfc_opcode <= OPCODE_RETURN;
              --thrd2intrfc_value <= reg3;
              --next_state <= WAIT_STATE;            
			  reg1_next <= reg3;
			  next_state <= CHAR_MATCH_LOOP_6;
            else
              next_state <= SEARCH_6;
            end if;

          -- while ( lowIndex <= highIndex ) {
          -- midIndex = (lowIndex + highIndex) / 2;
          -- ...
          -- }
          -- return NULL
          when SEARCH_6 =>
            if ( reg2 <= reg3 ) then
              reg4_next <= Z32(0 to 15) & (reg2(16 to 31) + reg3(16 to 31)); 
              next_state <= SEARCH_6a;
            else
              --thrd2intrfc_opcode <= OPCODE_RETURN;
              --thrd2intrfc_value <= Z32;
              --next_state <= WAIT_STATE;
			  reg1_next <= Z32;
			  next_state <= CHAR_MATCH_LOOP_6;
            end if;
		  
		  when SEARCH_6a =>
		    reg4_next <= reg2(0 to 16) & reg4(16 to 27) & "000";
			next_state <= SEARCH_7;

          -- if ( charString > globalSPrimary[midIndex].charString ) lowIndex = midIndex+1;
          -- else if ( charString < globalSPrimary[midIndex].charString ) highIndex = midIndex-1;
          -- else return &globalSPrimary[midIndex];
          when SEARCH_7 =>
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= reg4;
            return_state_next <= SEARCH_8;
            next_state <= WAIT_STATE;

          when SEARCH_8 =>
            if ( reg1 > toUser_value ) then
              reg2_next <= reg4 + 8;
              next_state <= SEARCH_6;
            elsif ( reg1 < toUser_value ) then
              reg3_next <= reg4 - 8;
              next_state <= SEARCH_6;
            else
              --thrd2intrfc_opcode <= OPCODE_RETURN;
              --thrd2intrfc_value <= reg3;
              --next_state <= WAIT_STATE; 
			  reg1_next <= reg3;
			  next_state <= CHAR_MATCH_LOOP_6;
            end if;
              
--------------------------------------------------------------------------------
-- void match( int tIndex, struct subString * subStringPtr ) {
-- reg1 = tIndex
-- reg2 = subStringPtr
-- reg3 = charString
-- reg4 = data
--------------------------------------------------------------------------------
         -- Save reg1 .. reg4 
         when MATCH_1 =>
           thrd2intrfc_opcode <= OPCODE_DECLARE;
           thrd2intrfc_value <= x"00000004";
           return_state_next <= MATCH_2;
           next_state <= WAIT_STATE;

         when MATCH_2 =>
           thrd2intrfc_opcode <= OPCODE_WRITE;
           thrd2intrfc_value <= reg1;
           thrd2intrfc_address <= Z32;
           return_state_next <= MATCH_3;
           next_state <= WAIT_STATE;

         when MATCH_3 =>
           thrd2intrfc_opcode <= OPCODE_WRITE;
           thrd2intrfc_value <= reg2;
           thrd2intrfc_address <= x"00000001";
           return_state_next <= MATCH_3a;
           next_state <= WAIT_STATE;

         when MATCH_3a =>
           thrd2intrfc_opcode <= OPCODE_WRITE;
           thrd2intrfc_value <= reg3;
           thrd2intrfc_address <= x"00000002";
           return_state_next <= MATCH_3b;
           next_state <= WAIT_STATE;

         when MATCH_3b =>
           thrd2intrfc_opcode <= OPCODE_WRITE;
           thrd2intrfc_value <= reg4;
           thrd2intrfc_address <= x"00000003";
           return_state_next <= MATCH_4;
           next_state <= WAIT_STATE;

         -- read the value of passed in parameters
         when MATCH_4 =>
           thrd2intrfc_opcode <= OPCODE_POP;
           thrd2intrfc_value <= Z32;
           return_state_next <= MATCH_5;
           next_state <= WAIT_STATE;

         when MATCH_5 =>
           reg1_next <= toUser_value;
           thrd2intrfc_opcode <= OPCODE_POP;
           thrd2intrfc_value <= x"00000001";
           return_state_next <= MATCH_6;
           next_state <= WAIT_STATE;

         -- if ( tIndex >= 1020 ) return;
         -- charString = *(unsigned int *)&T[ tIndex+4 ];
         when MATCH_6 =>
           reg2_next <= toUser_value;
           if ( reg1 >= 1020 ) then
             next_state <= MATCH_18;
           else
             thrd2intrfc_opcode <= OPCODE_LOAD;
             thrd2intrfc_address <= TPtr + reg1 + 4;
             return_state_next <= MATCH_7;
             next_state <= WAIT_STATE;
           end if;

          -- if ( (subStringPtr->ignore==0 & charString == subStringPtr->charString)
          -- || (subStringPtr->ignore==1 && (charString & 0xFFFFFF00) == (subStringPtr->charString & 0xFFFFFF00) )
          -- || (subStringPtr->ignore==2 && (charString & 0xFFFF0000) == (subStringPtr->charString & 0xFFFF0000) )
          -- || (subStringPtr->ignore==3 && (charString & 0xFF000000) == (subStringPtr->charString & 0xFF000000) ) ) {
          when MATCH_7 =>
            reg3_next <= toUser_value;
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= reg2+4;
            return_state_next <= MATCH_8;
            next_state <= WAIT_STATE;

          when MATCH_8 =>
            reg4_next <= toUser_value;
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= reg2;
            return_state_next <= MATCH_9;
            next_state <= WAIT_STATE;

          when MATCH_9 =>
            case reg4(0 to 1) is
              when "00" => -- ignore=0
                if ( toUser_value = reg3 ) then
                  next_state <= MATCH_10;
                else
                  next_state <= MATCH_15;
                end if;
              when "01" => -- ignore=1
                if ( toUser_value(0 to 23) = reg3(0 to 23) ) then
                  next_state <= MATCH_10;
                else
                  next_state <= MATCH_15;
                end if;
              when "10" => -- ignore=2
                if ( toUser_value(0 to 15) = reg3(0 to 15) ) then
                  next_state <= MATCH_10;
                else
                  next_state <= MATCH_15;
                end if;
              when OTHERS => -- ignore=3
                if ( toUser_value(0 to 7) = reg3(0 to 7) ) then
                  next_state <= MATCH_10;
                else
                  next_state <= MATCH_15;
                end if;
            end case;

          -- if ( subStringPtr->stringNumber > 0 ) {
          -- reportString( subStringPtr->stringNumber );
          -- }
          when MATCH_10 =>
            case reg4(3 to 14) is
              when "000000000000" =>
                next_state <= MATCH_12;
              when OTHERS =>
                thrd2intrfc_opcode <= OPCODE_PUSH;
                thrd2intrfc_value <= Z32(0 to 19) & reg4(2 to 13);
                return_state_next <= MATCH_11;
                next_state <= WAIT_STATE;
            end case;

          when MATCH_11 =>
            thrd2intrfc_opcode <= OPCODE_CALL;
            thrd2intrfc_value <= Z32(0 to 15) & C_MATCH_12;
            thrd2intrfc_function <= C_REPORT_STRING_1;
            next_state <= WAIT_STATE;

          -- if ( subStringPtr->nextPtr != NULL ) {
          -- match( T, tIndex+4, subStringPtr->nextPtr );
          -- }
          when MATCH_12 =>
            case reg4(15 to 31) is
              when "00000000000000000" =>
                next_state <= MATCH_15;
              when OTHERS =>
                thrd2intrfc_opcode <= OPCODE_PUSH;
                thrd2intrfc_value <= x"630" & reg4(15 to 31) & "000";
                return_state_next <= MATCH_13;
                next_state <= WAIT_STATE;
            end case;
          
          when MATCH_13 =>
            thrd2intrfc_opcode <= OPCODE_PUSH;
            thrd2intrfc_value <= reg1 + 4;
            return_state_next <= MATCH_14;
            next_state <= WAIT_STATE;

          when MATCH_14 =>
            thrd2intrfc_opcode <= OPCODE_CALL;
            thrd2intrfc_value <= Z32(0 to 15) & C_MATCH_15;
            thrd2intrfc_function <= C_MATCH_1;
            next_state <= WAIT_STATE;

          -- if ( subStringPtr->parrallelPtr != NULL ) {
          -- match( T, tIndex, subStringPtr->parrallelPtr );
          -- }
          when MATCH_15 =>
            case reg4(14) is
              when '0' =>
                next_state <= MATCH_18;
              when OTHERS =>
                thrd2intrfc_opcode <= OPCODE_PUSH;
                thrd2intrfc_value <= reg2 + 8;
                return_state_next <= MATCH_16;
                next_state <= WAIT_STATE;
            end case;
          
          when MATCH_16 =>
            thrd2intrfc_opcode <= OPCODE_PUSH;
            thrd2intrfc_value <= reg1;
            return_state_next <= MATCH_17;
            next_state <= WAIT_STATE;

          when MATCH_17 =>
            thrd2intrfc_opcode <= OPCODE_CALL;
            thrd2intrfc_value <= Z32(0 to 15) & C_MATCH_18;
            thrd2intrfc_function <= C_MATCH_1;
            next_state <= WAIT_STATE;

          -- restore all the registers before returning
          when MATCH_18 =>
            thrd2intrfc_opcode <= OPCODE_READ;
            thrd2intrfc_value <= Z32;
            return_state_next <= MATCH_19;
            next_state <= WAIT_STATE;

          when MATCH_19 =>
            reg1_next <= toUser_value;
            thrd2intrfc_opcode <= OPCODE_READ;
            thrd2intrfc_value <= x"00000001";
            return_state_next <= MATCH_20;
            next_state <= WAIT_STATE;

          when MATCH_20 =>
            reg2_next <= toUser_value;
            thrd2intrfc_opcode <= OPCODE_READ;
            thrd2intrfc_value <= x"00000002";
            return_state_next <= MATCH_21;
            next_state <= WAIT_STATE;

          when MATCH_21 =>
            reg3_next <= toUser_value;
            thrd2intrfc_opcode <= OPCODE_READ;
            thrd2intrfc_value <= x"00000003";
            return_state_next <= MATCH_22;
            next_state <= WAIT_STATE;

          when MATCH_22 =>
            reg4_next <= toUser_value;
            thrd2intrfc_opcode <= OPCODE_RETURN;
            thrd2intrfc_value <= Z32;
            next_state <= WAIT_STATE;

--------------------------------------------------------------------------------
-- report_string(int stringNumber);
-- reg1 value of foundStringsIndexPtr
--------------------------------------------------------------------------------
         -- Save reg1
         when REPORT_STRING_1 =>
           thrd2intrfc_opcode <= OPCODE_DECLARE;
           thrd2intrfc_value <= x"00000001";
           return_state_next <= REPORT_STRING_2;
           next_state <= WAIT_STATE;
           
         when REPORT_STRING_2 =>
           thrd2intrfc_opcode <= OPCODE_WRITE;
           thrd2intrfc_value <= reg1;
           return_state_next <= REPORT_STRING_3;
           next_state <= WAIT_STATE;
           
          -- hthread_mutex_lock( mutex );
          when REPORT_STRING_3 =>
            thrd2intrfc_opcode <= OPCODE_PUSH;
            thrd2intrfc_value <= mutexPtr;
            return_state_next <= REPORT_STRING_4;
            next_state <= WAIT_STATE;

          when REPORT_STRING_4 =>
            thrd2intrfc_opcode <= OPCODE_CALL;
            thrd2intrfc_value <= Z32(0 to 15) & C_REPORT_STRING_5;
            thrd2intrfc_function <= FUNCTION_HTHREAD_MUTEX_LOCK;
            next_state <= WAIT_STATE;

          -- index = *globalFoundStringIndex;
          when REPORT_STRING_5 =>
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= foundStringIndexPtr;
            return_state_next <= REPORT_STRING_6;
            next_state <= WAIT_STATE;

          -- globalFoundStrings[ index ] = stringNum;
          when REPORT_STRING_6 =>
            reg1_next <= toUser_value;
            -- pop the stringNum
            thrd2intrfc_opcode <= OPCODE_POP;
            thrd2intrfc_value <= Z32;
            return_state_next <= REPORT_STRING_7;
            next_state <= WAIT_STATE;
            
          when REPORT_STRING_7 =>
            -- store the string number to the foundStrings array
            thrd2intrfc_opcode <= OPCODE_STORE;
            thrd2intrfc_value <= toUser_value;
            thrd2intrfc_address <= foundStringsPtr + (reg1(2 to 31) & "00");
            return_state_next <= REPORT_STRING_8;
            next_state <= WAIT_STATE;
            
          -- *globalFoundStringIndex = index+1;
          when REPORT_STRING_8 =>
            thrd2intrfc_opcode <= OPCODE_STORE;
            thrd2intrfc_address <= foundStringIndexPtr;
            thrd2intrfc_value <= reg1 + 1;
            return_state_next <= REPORT_STRING_9;
            next_state <= WAIT_STATE;

          -- hthread_mutex_unlock( mutex );
          when REPORT_STRING_9 =>
            thrd2intrfc_opcode <= OPCODE_PUSH;
            thrd2intrfc_value <= mutexPtr;
            return_state_next <= REPORT_STRING_10;
            next_state <= WAIT_STATE;

          when REPORT_STRING_10 =>
            thrd2intrfc_opcode <= OPCODE_CALL;
            thrd2intrfc_value <= Z32(0 to 15) & C_REPORT_STRING_11;
            thrd2intrfc_function <= FUNCTION_HTHREAD_MUTEX_UNLOCK;
            next_state <= WAIT_STATE;

          -- restore all the registers before returning
          when REPORT_STRING_11 =>
            thrd2intrfc_opcode <= OPCODE_READ;
            thrd2intrfc_value <= Z32;
            return_state_next <= REPORT_STRING_12;
            next_state <= WAIT_STATE;

          when REPORT_STRING_12 =>
            reg1_next <= toUser_value;
            thrd2intrfc_opcode <= OPCODE_RETURN;
            thrd2intrfc_value <= Z32;
            next_state <= WAIT_STATE;
--------------------------------------------------------------------------------
-- Common states
--------------------------------------------------------------------------------
          when ERROR_STATE =>
            next_state <= ERROR_STATE;
            
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
