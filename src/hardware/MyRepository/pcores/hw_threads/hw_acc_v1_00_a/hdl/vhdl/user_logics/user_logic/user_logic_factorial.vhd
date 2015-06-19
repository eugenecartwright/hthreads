-------------------------------------------------------------------------------------
-- Copyright (c) 2006, University of Kansas - Hybridthreads Group
-- All rights reserved.
-- 
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
-- 
--     * Redistributions of source code must retain the above copyright notice,
--       this list of conditions and the following disclaimer.
--     * Redistributions in binary form must reproduce the above copyright notice,
--       this list of conditions and the following disclaimer in the documentation
--       and/or other materials provided with the distribution.
--     * Neither the name of the University of Kansas nor the name of the
--       Hybridthreads Group nor the names of its contributors may be used to
--       endorse or promote products derived from this software without specific
--       prior written permission.
-- 
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
-- ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-- (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
-- LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
-- ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-- (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-------------------------------------------------------------------------------------

---------------------------------------------------------------------------
--
--  Title: Hardware Thread User Logic Factorial
--  Computes the factorial of the inputed number (cast to an int), using
--  a recursive algorithm.
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
--    intrfc2thrd_address      32 bits   memory    function
--    intrfc2thrd_value        32 bits   memory
--    intrfc2thrd_function     16 bits                       control
--    thrd2intrfc_goWait        1 bit                        control
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
    READ_ARGUMENT,
    PUSH_ARGUMENT,
    CALL_FACTORIAL,
    READ_FACTORIAL_RETURN,
    PUSH_RETURN,
    CALL_EXIT,
    FACTORIAL_1,
    FACTORIAL_2,
    FACTORIAL_3,
    FACTORIAL_4,
    FACTORIAL_5,
    FACTORIAL_6,
    FACTORIAL_7,
    FACTORIAL_8,
    FACTORIAL_9,
    FACTORIAL_END,
    ERROR_STATE,
    WAIT_STATE );

  -- Function definitions
  constant U_FUNCTION_RESET                    : std_logic_vector(0 to 15) := x"0000";
  constant U_FUNCTION_WAIT                     : std_logic_vector(0 to 15) := x"0001";
  constant U_FUNCTION_USER_SELECT              : std_logic_vector(0 to 15) := x"0002";
  constant U_FUNCTION_START                    : std_logic_vector(0 to 15) := x"0003";
  constant U_READ_FACTORIAL_RETURN             : std_logic_vector(0 to 15) := x"0007";
  constant U_FACTORIAL_1                       : std_logic_vector(0 to 15) := x"0101";
  constant U_FACTORIAL_7                       : std_logic_vector(0 to 15) := x"0107";

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
  -- constant FUNCTION_MALLOC                     : std_logic_vector(0 to 15) := x"A000";
  -- constant FUNCTION_CALLOC                     : std_logic_vector(0 to 15) := x"A001";
  -- constant FUNCTION_FREE                       : std_logic_vector(0 to 15) := x"A002";

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

  signal argument, argument_next : std_logic_vector(0 to 31);
  signal varOne, varOne_next : std_logic_vector(0 to 31);
  signal varTwo, varTwo_next : std_logic_vector(0 to 31);
  signal result, result_next : std_logic_vector(0 to 31);

  signal toUser_address : std_logic_vector(0 to 31);
  signal toUser_value : std_logic_vector(0 to 31);
  signal toUser_function : std_logic_vector(0 to 15);
  signal toUser_goWait : std_logic;

  -- misc constants

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

      argument <= argument_next;
      varOne <= varOne_next;
      varTwo <= varTwo_next;
      result <= result_next;
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
          when U_FACTORIAL_1 =>
            current_state <= FACTORIAL_1;
          when U_READ_FACTORIAL_RETURN =>
            current_state <= READ_FACTORIAL_RETURN;
          when U_FACTORIAL_7 =>
            current_state <= FACTORIAL_7;

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
    -- next_state <= current_state;
    thrd2intrfc_opcode <= OPCODE_NOOP; -- When issuing an OPCODE, must be a pulse
    thrd2intrfc_address <= Z32;
    thrd2intrfc_value <= Z32;
    thrd2intrfc_function <= U_FUNCTION_USER_SELECT;
    next_state <= current_state;
    return_state_next <= return_state;

    argument_next <= argument;
    varOne_next <= varOne;
    varTwo_next <= varTwo;
    result_next <= result;
   
    -- The state machine
    case current_state is
      when FUNCTION_RESET =>
        --Set default values
        result_next <= Z32;
        argument_next <= Z32;
        varOne_next <= Z32;
        varTwo_next <= Z32;
        thrd2intrfc_opcode <= OPCODE_NOOP;
        thrd2intrfc_address <= Z32;
        thrd2intrfc_value <= Z32;
        thrd2intrfc_function <= U_FUNCTION_START;

      when FUNCTION_START =>
        -- Ask the HWTI the value of the passed in argument
        thrd2intrfc_value <= Z32;
        thrd2intrfc_opcode <= OPCODE_POP;
        return_state_next <= READ_ARGUMENT;
        next_state <= WAIT_STATE;

      when READ_ARGUMENT => --0004
        -- read the value of the passed in argument
        argument_next <= toUser_value;
        next_state <= PUSH_ARGUMENT;

      when PUSH_ARGUMENT => --0005
        -- push the argument, for the factorial function, on the stack
        thrd2intrfc_value <= argument;
        thrd2intrfc_opcode <= OPCODE_PUSH;
        return_state_next <= CALL_FACTORIAL;
        next_state <= WAIT_STATE;

      when CALL_FACTORIAL => -- 0006
        -- make a call to the factorial function
        thrd2intrfc_function <= U_FACTORIAL_1;
        thrd2intrfc_value <= Z32(0 to 15) & U_READ_FACTORIAL_RETURN;
        thrd2intrfc_opcode <= OPCODE_CALL;
        return_state_next <= READ_FACTORIAL_RETURN;
        next_state <= WAIT_STATE;
    
      when READ_FACTORIAL_RETURN => -- 0007
        -- read the return value
        result_next <= toUser_value;
        next_state <= PUSH_RETURN;

      when PUSH_RETURN => -- 0008
        -- Push a return value
        thrd2intrfc_value <= result; 
        thrd2intrfc_opcode <= OPCODE_PUSH;
        return_state_next <= CALL_EXIT;
        next_state <= WAIT_STATE;

      when CALL_EXIT => -- 000A
        --Immediatly exit
        thrd2intrfc_function <= FUNCTION_HTHREAD_EXIT;
        thrd2intrfc_value <= Z32;
        thrd2intrfc_opcode <= OPCODE_CALL;
        next_state <= WAIT_STATE;

      when ERROR_STATE =>
        next_state <= ERROR_STATE;

-----------------------------------------------------------------------
-- Factorial function
-- computes the factorial of the input parameter using recursion
-----------------------------------------------------------------------
      when FACTORIAL_1 => -- 0101
        -- Read the passed in parameter
        thrd2intrfc_value <= Z32;
        thrd2intrfc_opcode <= OPCODE_POP;
        return_state_next <= FACTORIAL_2;
        next_state <= WAIT_STATE;

      when FACTORIAL_2 => -- 0102
        -- store the passed in parameter in a register
        varOne_next <= intrfc2thrd_value;
        next_state <= FACTORIAL_3;

      when FACTORIAL_3 => -- 0103
        -- Declare one variable
        thrd2intrfc_value <= x"00000001";
        thrd2intrfc_opcode <= OPCODE_DECLARE;
        return_state_next <= FACTORIAL_4;
        next_state <= WAIT_STATE;

      when FACTORIAL_4 => -- 0104
        -- store the register as a saved variable
        thrd2intrfc_value <= varOne;
        thrd2intrfc_address <= Z32;
        thrd2intrfc_opcode <= OPCODE_WRITE;
        return_state_next <= FACTORIAL_5;
        next_state <= WAIT_STATE;

      when FACTORIAL_5 => -- 0105
        -- check if param <= 1
        case varOne is
          when x"00000001" =>
            -- return a 1
            thrd2intrfc_value <= x"00000001";
            thrd2intrfc_opcode <= OPCODE_RETURN;
            next_state <= WAIT_STATE;
          when Z32 =>
            -- return a 1
            thrd2intrfc_value <= x"00000000";
            thrd2intrfc_opcode <= OPCODE_RETURN;
            next_state <= WAIT_STATE;
          when others =>
            -- recursively call factorial, prepare by pushing param-1
            thrd2intrfc_value <= (varOne - 1);
            thrd2intrfc_opcode <= OPCODE_PUSH;
            return_state_next <= FACTORIAL_6;
            next_state <= WAIT_STATE;
        end case;

      when FACTORIAL_6 => -- 0106
        -- recursively call factorial
        thrd2intrfc_value <= Z32(0 to 15) & U_FACTORIAL_7;
        thrd2intrfc_function <= U_FACTORIAL_1;
        thrd2intrfc_opcode <= OPCODE_CALL;
        return_state_next <= FACTORIAL_7;
        next_state <= WAIT_STATE;

      when FACTORIAL_7 => -- 0107
        -- read the return value, save to a register
        -- TODO, change this to multipliation
        varTwo_next <= toUser_value;
        -- read the save variable
        thrd2intrfc_address <= Z32;
        thrd2intrfc_opcode <= OPCODE_READ;
        return_state_next <= FACTORIAL_8;
        next_state <= WAIT_STATE;

      when FACTORIAL_8 => -- 0108
        -- store the variable back to varOne
        varOne_next <= toUser_value;
        next_state <= FACTORIAL_9;

      when FACTORIAL_9 => -- 0109
        -- return
        thrd2intrfc_value <= varTwo + varOne;
        thrd2intrfc_opcode <= OPCODE_RETURN;
        next_state <= FACTORIAL_END;    

      when FACTORIAL_END => -- 010A
        -- if everything is working, should never reach this state
        next_state <= FACTORIAL_END;

      when WAIT_STATE =>
        next_state <= return_state;

    end case;
  end process HWTUL_STATE_MACHINE;
end architecture IMP;
