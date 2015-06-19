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
	READ_ARGS_4,
	READ_ARGS_5,
	WHILE_1,
	WHILE_2,
	WHILE_3,
	DO_1,
	DO_2,
	DO_3,
	DO_4,
	DO_5,
	DO_6,
	DONE_1,
	DONE_2,
	DONE_3,
	DONE_4,
	MUL_A1,
	MUL_A2,
	MUL_A3,
	MUL_B1,
	MUL_B2,
	MUL_B3,
	MUL_C1,
	MUL_C2,
	MUL_C3,
	MUL_D1,
	MUL_D2,
	MUL_D3,
	MUL_E1,
	MUL_E2,
	MUL_E3,
	MUL_F1,
	MUL_F2,
	MUL_F3,
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
  constant Z16 : std_logic_vector(0 to 15) := (others => '0');

  constant ROUNDS: std_logic_vector(0 to 15) := x"0008";

  signal current_state, next_state : state_machine := FUNCTION_RESET;
  signal return_state, return_state_next : state_machine := FUNCTION_RESET;
  signal arg, arg_next : std_logic_vector(0 to 31);
  signal inPtr, inPtr_next : std_logic_vector(0 to 31);
  signal outPtr, outPtr_next : std_logic_vector(0 to 31);
  signal zPtr, zPtr_next : std_logic_vector(0 to 31);
  signal origZPtr, origZPtr_next : std_logic_vector(0 to 31);
  signal count, count_next : std_logic_vector(0 to 31);
  signal t32, t32_next : std_logic_vector(0 to 31);
  signal x1, x1_next : std_logic_vector(0 to 15);
  signal x2, x2_next : std_logic_vector(0 to 15);
  signal x3, x3_next : std_logic_vector(0 to 15);
  signal x4, x4_next : std_logic_vector(0 to 15);
  signal t1, t1_next : std_logic_vector(0 to 15);
  signal t2, t2_next : std_logic_vector(0 to 15);
  signal r, r_next : std_logic_vector(0 to 15);
  signal a, a_next : std_logic_vector(0 to 15);
  signal b, b_next : std_logic_vector(0 to 15);

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
	  inPtr <= inPtr_next;
	  outPtr <= outPtr_next;
	  zPtr <= zPtr_next;
	  origZPtr <= origZPtr_next;
	  count <= count_next;
	  t32 <= t32_next;
	  x1 <= x1_next;
	  x2 <= x2_next;
	  x3 <= x3_next;
	  x4 <= x4_next;
	  t1 <= t1_next;
	  t2 <= t2_next;
	  r <= r_next;
	  a <= a_next;
	  b <= b_next;
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
	inPtr_next <= inPtr;
	outPtr_next <= outPtr;
	zPtr_next <= zPtr;
	origZPtr_next <= origZPtr;
	count_next <= count;
	t32_next <= t32;
	x1_next <= x1;
	x2_next <= x2;
	x3_next <= x3;
	x4_next <= x4;
	t1_next <= t1;
	t2_next <= t2;
	r_next <= r;
	a_next <= a;
	b_next <= b;

    -- The state machine
        case current_state is
          when FUNCTION_RESET =>
            --Set default values
            thrd2intrfc_opcode <= OPCODE_NOOP;
            thrd2intrfc_address <= Z32;
            thrd2intrfc_value <= Z32;
            thrd2intrfc_function <= U_FUNCTION_START;

			arg_next <= Z32;
	        inPtr_next <= Z32;
        	outPtr_next <= Z32;
        	zPtr_next <= Z32;
			origZPtr_next <= Z32;
			count_next <= count;
        	t32_next <= Z32;
        	x1_next <= Z16;
        	x2_next <= Z16;
        	x3_next <= Z16;
        	x4_next <= Z16;
        	t1_next <= Z16;
        	t2_next <= Z16;
        	r_next <= Z16;
			a_next <= Z16;
			b_next <= Z16;

          when FUNCTION_START => 
            -- read the passed in argument
            thrd2intrfc_opcode <= OPCODE_POP;
            thrd2intrfc_address <= Z32;
            return_state_next <= READ_ARGS_1;
            next_state <= WAIT_STATE;
  
          when READ_ARGS_1 =>
            arg_next <= toUser_value;
			-- Read the inPtr address
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= toUser_value;
            return_state_next <= READ_ARGS_2;
            next_state <= WAIT_STATE;

          when READ_ARGS_2 =>
		    inPtr_next <= toUser_value;
            -- Read the outPtr address
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= arg + 4;
            return_state_next <= READ_ARGS_3;
            next_state <= WAIT_STATE;

          when READ_ARGS_3 => 
		    outPtr_next <= toUser_value;
            -- Read count
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= arg + 8;
            return_state_next <= READ_ARGS_4;
            next_state <= WAIT_STATE;

          when READ_ARGS_4 => 
		    count_next <= toUser_value;
            -- Read address of z
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= arg + 12;
            return_state_next <= READ_ARGS_5;
            next_state <= WAIT_STATE;

          when READ_ARGS_5 =>
		    origZPtr_next <= toUser_value;
			next_state <= WHILE_1;

          -- while ( count > 0 ) {
		  --   Z = origZ;
		  --   r = ROUNDS;
		  --   count--;
		  -- x1 = *inPtr++;
		  -- x2 = *inPtr++;
          when WHILE_1 =>
		    case count is 
			  when x"00000000" =>
			    next_state <= EXIT_THREAD;
			  when others =>
			    count_next <= count - x"00000001";
			    r_next <= ROUNDS;
				zPtr_next <= origZPtr;
                -- Read first 32 bits of inPtr
                thrd2intrfc_opcode <= OPCODE_LOAD;
                thrd2intrfc_address <= inPtr;
			    -- increment inPtr
			    inPtr_next <= inPtr + x"00000004";
				return_state_next <= WHILE_2;
                next_state <= WAIT_STATE;
			end case;

		  -- x3 = *inPtr++;
		  -- x4 = *inPtr;
          when WHILE_2 => 
		    x1_next <= toUser_value(0 to 15);
			x2_next <= toUser_value(16 to 31);
            -- Read second 32 bits of inPtr
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= inPtr;
			-- increment inPtr
			inPtr_next <= inPtr + x"00000004";
            return_state_next <= WHILE_3;
            next_state <= WAIT_STATE;

          when WHILE_3 => 
		    x3_next <= toUser_value(0 to 15);
			x4_next <= toUser_value(16 to 31);
			next_state <= DO_1;

          when DO_1 =>
		    -- Read the value of zPtr
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= zPtr;
			-- Increment zPtr
			zPtr_next <= zPtr + x"00000004";
            return_state_next <= MUL_A1;
            next_state <= WAIT_STATE;

          -- MUL(x1, *Z++)
          -- x2 += *Z++
		  when MUL_A1 =>
			a_next <= x1;
			b_next <= toUser_value(0 to 15);
			x2_next <= x2 + toUser_value(16 to 31);
			next_state <= MUL_A2;

		  when MUL_A2 =>
		    case a is
			  when x"0000" =>
			    x1_next <= x"0001" - b;
				next_state <= DO_2;
			  when others =>
			    case b is
				  when x"0000" =>
				    x1_next <= x"0001" - a;
					next_state <= DO_2;
				  when others =>
				    t32_next <= a * b;
					next_state <= MUL_A3;
				end case;
			end case;

          when MUL_A3 =>
		    if ( t32(16 to 31) < t32(0 to 15 ) ) then
			  x1_next <= t32(16 to 31) - t32(0 to 15) + x"0001";
			  next_state <= DO_2;
			else
			  x1_next <= t32(16 to 31) - t32(0 to 15);
			  next_state <= DO_2;
			end if;

          -- x3 += *Z++
		  -- MUL(x4, *Z++ );
		  when DO_2 =>
		    -- Read the value of zPtr
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= zPtr;
			-- Increment zPtr
			zPtr_next <= zPtr + x"00000004";
            return_state_next <= MUL_B1;
            next_state <= WAIT_STATE;

		  when MUL_B1 =>
			x3_next <= x3 + toUser_value(0 to 15);
			a_next <= x4;
			b_next <= toUser_value(16 to 31);
			next_state <= MUL_B2;

		  when MUL_B2 =>
		    case a is
			  when x"0000" =>
			    x4_next <= x"0001" - b;
				next_state <= DO_3;
			  when others =>
			    case b is
				  when x"0000" =>
				    x4_next <= x"0001" - a;
					next_state <= DO_3;
				  when others =>
				    t32_next <= a * b;
					next_state <= MUL_B3;
				end case;
			end case;

          when MUL_B3 =>
		    if ( t32(16 to 31) < t32(0 to 15 ) ) then
			  x4_next <= t32(16 to 31) - t32(0 to 15) + x"0001";
			  next_state <= DO_3;
			else
			  x4_next <= t32(16 to 31) - t32(0 to 15);
			  next_state <= DO_3;
			end if;

          -- t2 = x1^x3;
		  -- MUL( t2, *Z++ );
		  -- t1 = t2 + ( x2^x4 );
		  -- MUL( t1, *Z++ );
		  when DO_3 =>
		    t2_next <= x1 xor x3;
		    -- Read the value of zPtr
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= zPtr;
			-- Increment zPtr
			zPtr_next <= zPtr + x"00000004";
            return_state_next <= MUL_C1;
            next_state <= WAIT_STATE;

		  when MUL_C1 =>
			a_next <= t2;
			b_next <= toUser_value(0 to 15);
			next_state <= MUL_C2;

		  when MUL_C2 =>
		    case a is
			  when x"0000" =>
			    t2_next <= x"0001" - b;
				next_state <= MUL_D1;
			  when others =>
			    case b is
				  when x"0000" =>
				    t2_next <= x"0001" - a;
					next_state <= MUL_D1;
				  when others =>
				    t32_next <= a * b;
					next_state <= MUL_C3;
				end case;
			end case;

          when MUL_C3 =>
		    if ( t32(16 to 31) < t32(0 to 15 ) ) then
			  t2_next <= t32(16 to 31) - t32(0 to 15) + x"0001";
			  next_state <= MUL_D1;
			else
			  t2_next <= t32(16 to 31) - t32(0 to 15);
			  next_state <= MUL_D1;
			end if;

		  when MUL_D1 =>
		    a_next <= t2 + (x2 xor x4);
			b_next <= toUser_value(16 to 31);
			next_state <= MUL_D2;

		  when MUL_D2 =>
		    case a is
			  when x"0000" =>
			    t1_next <= x"0001" - b;
				next_state <= DO_4;
			  when others =>
			    case b is
				  when x"0000" =>
				    t1_next <= x"0001" - a;
					next_state <= DO_4;
				  when others =>
				    t32_next <= a * b;
					next_state <= MUL_D3;
				end case;
			end case;

          when MUL_D3 =>
		    if ( t32(16 to 31) < t32(0 to 15 ) ) then
			  t1_next <= t32(16 to 31) - t32(0 to 15) + x"0001";
			  next_state <= DO_4;
			else
			  t1_next <= t32(16 to 31) - t32(0 to 15);
			  next_state <= DO_4;
			end if;

          -- t2 = t1+t2;
		  -- x1 ^= t1;
          when DO_4 =>
		    t2_next <= t1 + t2;
			x1_next <= x1 xor t1;
			next_state <= DO_5;

		  -- x4 ^= t2;
		  -- t2 ^= x2;
          when DO_5 =>
		    x4_next <= x4 xor t2;
			t2_next <= t2 xor x2;
			next_state <= DO_6;

		  -- x2 = x3^t1;
		  -- x3 = t2;
		  -- while (--r);
          when DO_6 =>
		    x2_next <= x3 xor t1;
			x3_next <= t2;
			case r is
			  when x"0001" =>
				next_state <= DONE_1;
			  when others =>
			    r_next <= r - x"0001";
				next_state <= DO_1;
			end case;

          -- MUL(x1, *Z++);
		  -- out++ = x1;
		  -- out++ = x3 + *Z++;
		  when DONE_1 =>
		    -- Read the value of zPtr
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= zPtr;
			-- Increment zPtr
			zPtr_next <= zPtr + x"00000004";
            return_state_next <= MUL_E1;
            next_state <= WAIT_STATE;

		  when MUL_E1 =>
			a_next <= x1;
			b_next <= toUser_value(0 to 15);
			next_state <= MUL_E2;

		  when MUL_E2 =>
		    case a is
			  when x"0000" =>
			    x1_next <= x"0001" - b;
				next_state <= DONE_2;
			  when others =>
			    case b is
				  when x"0000" =>
				    x1_next <= x"0001" - a;
					next_state <= DONE_2;
				  when others =>
				    t32_next <= a * b;
					next_state <= MUL_E3;
				end case;
			end case;

          when MUL_E3 =>
		    if ( t32(16 to 31) < t32(0 to 15 ) ) then
			  x1_next <= t32(16 to 31) - t32(0 to 15) + x"0001";
			  next_state <= DONE_2;
			else
			  x1_next <= t32(16 to 31) - t32(0 to 15);
			  next_state <= DONE_2;
			end if;

		  when DONE_2 =>
		    thrd2intrfc_opcode <= OPCODE_STORE;
			thrd2intrfc_address <= outPtr;
			thrd2intrfc_value <= x1 & (x3 + toUser_value(16 to 31));
			outPtr_next <= outPtr + x"00000004";
			next_state <= WAIT_STATE;
			return_state_next <= DONE_3;

         -- *out++ = x2 + *Z++;
		 -- MUL(x4, *Z);
		 -- *out = x4;
		  when DONE_3 =>
		    -- Read the value of zPtr
            thrd2intrfc_opcode <= OPCODE_LOAD;
            thrd2intrfc_address <= zPtr;
            return_state_next <= MUL_F1;
            next_state <= WAIT_STATE;

		  when MUL_F1 =>
			a_next <= x4;
			b_next <= toUser_value(16 to 31);
			next_state <= MUL_F2;

		  when MUL_F2 =>
		    case a is
			  when x"0000" =>
			    x4_next <= x"0001" - b;
				next_state <= DONE_4;
			  when others =>
			    case b is
				  when x"0000" =>
				    x4_next <= x"0001" - a;
					next_state <= DONE_4;
				  when others =>
				    t32_next <= a * b;
					next_state <= MUL_F3;
				end case;
			end case;

          when MUL_F3 =>
		    if ( t32(16 to 31) < t32(0 to 15 ) ) then
			  x4_next <= t32(16 to 31) - t32(0 to 15) + x"0001";
			  next_state <= DONE_4;
			else
			  x4_next <= t32(16 to 31) - t32(0 to 15);
			  next_state <= DONE_4;
			end if;

		  when DONE_4 =>
		    thrd2intrfc_opcode <= OPCODE_STORE;
			thrd2intrfc_address <= outPtr;
			thrd2intrfc_value <= (x2 + toUser_value(0 to 15)) & x4;
			outPtr_next <= outPtr + x"00000004";
			next_state <= WAIT_STATE;
			return_state_next <= WHILE_1;
		    
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
