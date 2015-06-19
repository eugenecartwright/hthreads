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
	READ_ARGS_1,
	READ_ARGS_2,
	READ_ARGS_3,
	WHILE_1,
	WHILE_2,
	WHILE_3,
	WHILE_4,
	WHILE_5,
	WHILE_6,
	WHILE_7,
	WHILE_8,
	FOO,
	LOOP_1,
	LOOP_2,
	LOOP_3,
	LOOP_4,
	LOOP_5,
	LOOP_6,
    EXIT_THREAD,
    EXIT_THREAD_1,
    WAIT_STATE,
    ERROR_STATE);

  -- Function definitions
  constant U_FUNCTION_RESET                    : std_logic_vector(0 to 15) := x"0000";
  constant U_FUNCTION_WAIT                     : std_logic_vector(0 to 15) := x"0001";
  constant U_FUNCTION_USER_SELECT              : std_logic_vector(0 to 15) := x"0002";
  constant U_FUNCTION_START                    : std_logic_vector(0 to 15) := x"0003";

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
  signal arg, arg_next : std_logic_vector(0 to 31);
  signal sig, sig_next : std_logic_vector(0 to 31);
  signal len, len_next : std_logic_vector(0 to 31);
  signal i, i_next : std_logic_vector(0 to 31);
  signal r1, r1_next : std_logic_vector(0 to 31);
  signal r2, r2_next : std_logic_vector(0 to 31);
  signal r3, r3_next : std_logic_vector(0 to 31);
  signal r4, r4_next : std_logic_vector(0 to 31);

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

	  arg <= arg_next;
	  sig <= sig_next;
	  len <= len_next;
	  i <= i_next;
	  r1 <= r1_next;
	  r2 <= r2_next;
	  r3 <= r3_next;
	  r4 <= r4_next;
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

	arg_next <= arg;
	sig_next <= sig;
	len_next <= len;
	i_next <= i;
	r1_next <= r1;
	r2_next <= r2;
	r3_next <= r3;
	r4_next <= r4;

    -- The state machine
        case current_state is
          when FUNCTION_RESET =>
            --Set default values
            thrd2intrfc_opcode <= OPCODE_NOOP;
            thrd2intrfc_address <= Z32;
            thrd2intrfc_value <= Z32;
            thrd2intrfc_function <= U_FUNCTION_START;

			arg_next <= Z32;
			sig_next <= Z32;
			len_next <= Z32;
			i_next <= Z32;
			r1_next <= Z32;
			r2_next <= Z32;
			r3_next <= Z32;
			r4_next <= Z32;

          when FUNCTION_START => 
            -- read the passed in argument
            thrd2intrfc_opcode <= OPCODE_POP;
            thrd2intrfc_address <= Z32;
            return_state_next <= READ_ARGS_1;
            next_state <= WAIT_STATE;
   
          -- struct Array * arrayPtr;
		  -- arrayPtr = (struct Array *) arg;
		  -- Huint * sig = arrayPtr->data;
          when READ_ARGS_1 =>
            arg_next <= toUser_value;
            -- Read the address of the data array
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= toUser_value;
            return_state_next <= READ_ARGS_2;
            next_state <= WAIT_STATE;

          -- Huint len = arrayPtr->length
          when READ_ARGS_2 =>
            sig_next <= toUser_value;
            -- Read value of length
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= arg + 4;
            return_state_next <= READ_ARGS_3;
            next_state <= WAIT_STATE;

          -- int i=0
		  -- Huint tmp[LENGTH];
          when READ_ARGS_3 => 
            len_next <= toUser_value;
            -- initialize i
			i_next <= Z32;
			-- Declare len number of variables on the stack
            thrd2intrfc_opcode <= OPCODE_DECLARE;
            thrd2intrfc_value <= toUser_value;
            return_state_next <= WHILE_1;
            next_state <= WAIT_STATE;

          -- while ( i < (len >> 1 ) ) {
          when WHILE_1 =>
            -- set r1 to len >> 1
			r1_next <= '0' & len(0 to 30);
			-- set r2 to i << 1
			r2_next <= i(1 to 31) & '0';
			next_state <= WHILE_2;

		  when WHILE_2 =>
		    if ( i < r1 ) then
			  next_state <= WHILE_3;
			else
			  next_state <= FOO;
			end if;

		  -- tmp[(i<<1)+1] = (sig[(i<<1)] + sig[(i<<1)+1]) >> 1;
		  when WHILE_3 =>
		    -- Read the value of sig[(i<<1)]
			thrd2intrfc_opcode <= OPCODE_LOAD;
			thrd2intrfc_address <= sig + (r2(2 to 31) & "00");
			return_state_next <= WHILE_4;
			next_state <= WAIT_STATE;

		  when WHILE_4 =>
		    r3_next <= toUser_value;
		    -- Read the value of sig[(i<<1) + 1]
			thrd2intrfc_opcode <= OPCODE_LOAD;
			thrd2intrfc_address <= sig + (r2(2 to 31) & "00") + x"00000004";
			return_state_next <= WHILE_5;
			next_state <= WAIT_STATE;

		  when WHILE_5 =>
		    -- Calculate the averaged value 
			r4_next <= ('0' & r3(0 to 30)) + ('0' & toUser_value(0 to 30));
			next_state <= WHILE_6;

          when WHILE_6 =>
		    -- write the average value to tmp array
		    thrd2intrfc_opcode <= OPCODE_WRITE;
			thrd2intrfc_address <= r2 + x"00000001";
			thrd2intrfc_value <= r4;
			return_state_next <= WHILE_7;
			next_state <= WAIT_STATE;

		  -- tmp[(i<<1)] = (sig[(i<<1)] - tmp[(i<<1) + 1];
		  when WHILE_7 =>
		    -- write the difference to tmp array
			thrd2intrfc_opcode <= OPCODE_WRITE;
			thrd2intrfc_address <= r2;
			thrd2intrfc_value <= r3 - r4;
			return_state_next <= WHILE_8;
			next_state <= WAIT_STATE;
		 
		  -- i++;
		  when WHILE_8 =>
		    -- increment i
			i_next <= i + x"00000001";
			next_state <= WHILE_1;

		  -- i=0;
		  when FOO =>
		    i_next <= Z32;
			next_state <= LOOP_1;

          -- while ( i < (len >> 1 ) ) {
          when LOOP_1 =>
			-- set r2 to i << 1
			r2_next <= i(1 to 31) & '0';
			-- Check the while condition
		    if ( i < r1 ) then
			  next_state <= LOOP_2;
			else
			  next_state <= EXIT_THREAD;
			end if;

          -- sig[i] = tmp[(i<<1)+1];
          when LOOP_2 =>
		    -- read the value of the tmp array
		    thrd2intrfc_opcode <= OPCODE_READ;
			thrd2intrfc_address <= r2 + x"00000001";
			return_state_next <= LOOP_3;
			next_state <= WAIT_STATE;

          when LOOP_3 =>
		    -- write the temp value back to data array
			thrd2intrfc_opcode <= OPCODE_STORE;
			thrd2intrfc_address <= sig + (i(2 to 31) & "00");
			thrd2intrfc_value <= toUser_value;
			return_state_next <= LOOP_4;
			next_state <= WAIT_STATE;

          -- sig[(len>>1)+i] = tmp[(i<<1)];
          when LOOP_4 =>
		    -- read the value of the tmp array
		    thrd2intrfc_opcode <= OPCODE_READ;
			thrd2intrfc_address <= r2;
			return_state_next <= LOOP_5;
			next_state <= WAIT_STATE;

          when LOOP_5 =>
		    -- write the temp value back to data array
			thrd2intrfc_opcode <= OPCODE_STORE;
			thrd2intrfc_address <= sig + (r1(2 to 31) & "00") + (i(2 to 31) & "00");
			thrd2intrfc_value <= toUser_value;
			return_state_next <= LOOP_6;
			next_state <= WAIT_STATE;
         
		  when LOOP_6 =>
		    -- increment i
			i_next <= i + x"00000001";
			next_state <= LOOP_1;

          when EXIT_THREAD =>
		    thrd2intrfc_opcode <= OPCODE_PUSH;
			thrd2intrfc_value <= Z32;
			return_state_next <= EXIT_THREAD_1;
			next_state <= WAIT_STATE;

		  when EXIT_THREAD_1 =>
		    thrd2intrfc_opcode <= OPCODE_CALL;
			thrd2intrfc_value <= Z32;
			thrd2intrfc_function <= FUNCTION_HTHREAD_EXIT;
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
