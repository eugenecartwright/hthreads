

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_misc.all;

library Unisim;
use Unisim.all;



entity user_logic_hwtul is
generic(
  G_INPUT_WIDTH : integer := 32;
  G_DIVISOR_WIDTH : integer := 4;
  divisor : std_logic_vector(0 to 3) := "1011"
);
  port (
    clock : in std_logic;
    intrfc2thrd : in std_logic_vector(0 to 63);
    thrd2intrfc : out std_logic_vector( 0 to 95);
    rd          : out std_logic;
    wr          : out std_logic;
    exist       : in  std_logic;
    full        : in  std_logic;
    Ttimer      : out  std_logic_vector( 0 to 31)        
   
  );
end entity user_logic_hwtul;

---------------------------------------------------------------------------
-- Architecture section
---------------------------------------------------------------------------

architecture IMP of user_logic_hwtul is


   
  
    alias intrfc2thrd_value    :  std_logic_vector(0 to 31) is intrfc2thrd(0 to 31);
    alias intrfc2thrd_function :  std_logic_vector(0 to 15) is intrfc2thrd(32 to 47);
    alias intrfc2thrd_goWait   :  std_logic is intrfc2thrd(48);

    alias thrd2intrfc_address  :  std_logic_vector(0 to 31)  is thrd2intrfc( 32 to 63);
    alias thrd2intrfc_value    :  std_logic_vector(0 to 31)  is thrd2intrfc( 0 to 31);
    alias thrd2intrfc_function :  std_logic_vector(0 to 15)  is thrd2intrfc( 64 to 79);
    alias thrd2intrfc_opcode   :  std_logic_vector(0 to 5)   is thrd2intrfc( 80 to 85) ;

    signal new_request : std_logic; --when there is a new request to HWTI
    signal timer : std_logic_vector(0 to 31);
    type timer_state_machine is ( idle,counting);
    signal timer_cs : timer_state_machine :=idle;

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
  constant OPCODE_ADDRESSOF                    : std_logic_vector(0 to 5) := "000110";
  -- Function sub-interface specific opcodes
  constant OPCODE_PUSH                         : std_logic_vector(0 to 5) := "010000";
  constant OPCODE_POP                          : std_logic_vector(0 to 5) := "010001";
  constant OPCODE_CALL                         : std_logic_vector(0 to 5) := "010010";
  constant OPCODE_RETURN                       : std_logic_vector(0 to 5) := "010011";

  constant Z32 : std_logic_vector(0 to 31) := (others => '0');

  signal current_state, next_state : state_machine := FUNCTION_RESET;
  signal return_state, return_state_next: state_machine := FUNCTION_RESET;

  
  signal toUser_value : std_logic_vector(0 to 31);
  signal toUser_function : std_logic_vector(0 to 15);
  signal toUser_goWait : std_logic;

  signal structAddr, structAddr_next : std_logic_vector(0 to 31);
  signal size, size_next : std_logic_vector(0 to 31);
  
  signal xAddr, xAddr_next : std_logic_vector(0 to 31);
  signal xVal, xVal_next : std_logic_vector(0 to 31);
  signal i, i_next : std_logic_vector(0 to 7);
  
  signal count, count_next : std_logic_vector(0 to 31);
  
  

  -- misc constants

---------------------------------------------------------------------------
-- Begin architecture
---------------------------------------------------------------------------

begin -- architecture IMP

Ttimer <= timer;  

  timer_process: process(clock)
  begin

      if (clock'event and (clock = '1')) then  

        case timer_cs  is
  
         when idle=>
             timer <= (others =>'0');
             if current_state= FUNCTION_START then
                timer_cs <= counting;
             end if;


         when counting =>
		 timer <= timer + x"00000001";
		 if (current_state= FUNCTION_RESET or current_state=FUNCTION_EXIT_1) then
		       timer_cs <= idle;
		 end if;
 
          when others =>
                 timer <= (others =>'0');
                 timer_cs <= idle;  
         
         end case;
     end if;
end process timer_process;	 
     

  wr <= '0' when ( current_state= WAIT_STATE ) else new_request ;
  rd <= exist;

  HWTUL_STATE_PROCESS : process (clock, exist) is
  begin
    
    if (clock'event and (clock = '1')) then    
      

      return_state <= return_state_next;

      structAddr <= structAddr_next;
      size <= size_next;
    
      xAddr <= xAddr_next;
     
      xVal <= xVal_next;
     
     
      count <= count_next;
 	i <= i_next;
  

      -- Find out if the HWTI is tell us what to do
      if (exist = '1') then

        toUser_value <= intrfc2thrd_value;
        toUser_function <= intrfc2thrd_function;
        toUser_goWait <= intrfc2thrd_goWait;
        
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

      elsif  ( new_request  = '0') then
        current_state <= next_state;
      else         
        current_state <= WAIT_STATE;
      end if;


    end if;

  end process HWTUL_STATE_PROCESS;




  HWTUL_STATE_MACHINE : process (clock) is
  begin

    new_request  <= '1';

    -- Default register assignments
    thrd2intrfc_opcode <= OPCODE_NOOP; -- When issuing an OPCODE, must be a pulse
    thrd2intrfc_address <= Z32;
    thrd2intrfc_value <= Z32;
    thrd2intrfc_function <= U_FUNCTION_USER_SELECT;
    return_state_next <= return_state;
    next_state <= current_state;

    structAddr_next <= structAddr;
    size_next <= size;
   
    xAddr_next <= xAddr;
   
    xVal_next <= xVal;
    
    count_next <= count;
     i_next <= i;

    -- The state machine
    case current_state is
      when FUNCTION_RESET =>
        --Set default values
        thrd2intrfc_opcode <= OPCODE_NOOP;
        thrd2intrfc_address <= Z32;
        thrd2intrfc_value <= Z32;
        thrd2intrfc_function <= U_FUNCTION_START;
        new_request  <= '0';

      when FUNCTION_START =>
        -- POP the argument
        thrd2intrfc_opcode <= OPCODE_POP;
        thrd2intrfc_value <= Z32;
        count_next <= Z32;
 	     i_next <= (others =>'0');
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
        thrd2intrfc_address <= structAddr + x"00000004";
        next_state <= WAIT_STATE;
        return_state_next <= SETUP_6;          

      when SETUP_6 =>
        -- 
        xAddr_next <= toUser_value;
        next_state <=WHILE_LOOP_6;
        new_request  <= '0';   
     

     

      when WHILE_LOOP_6 =>
        -- Check to see if the index is over the size
        if ( count < size ) then
          -- More work to be done
          -- Initiate the read of the X matrix
          thrd2intrfc_opcode <= OPCODE_LOAD;
          thrd2intrfc_address <= xAddr + (count(2 to 31) & "00");
          next_state <= WAIT_STATE;
          return_state_next <= WHILE_LOOP_7;
          i_next <= conv_std_logic_vector(0,8);
        else 
          -- we may exit
          next_state <= FUNCTION_EXIT_1;
          new_request  <= '0';
        end if;

      when WHILE_LOOP_7 =>
        xVal_next <= ToUser_value;
        -- 
        next_state <=WHILE_LOOP_8 ;
        new_request  <= '0';

      when WHILE_LOOP_8 =>
 	if ( i < G_INPUT_WIDTH - G_DIVISOR_WIDTH + 1 ) and ( xVal(conv_integer(i)) = '0' ) then
        i_next <= i + 1;
        next_state <= WHILE_LOOP_8;
        new_request  <= '0';
       elsif ( i < G_INPUT_WIDTH - G_DIVISOR_WIDTH + 1 ) then
        xval_next(conv_integer(i) to conv_integer(i) + ( G_DIVISOR_WIDTH - 1 )) <= xval(conv_integer(i) to conv_integer(i) + ( G_DIVISOR_WIDTH - 1 )) xor divisor;
        i_next <= i + 1;
        next_state <= WHILE_LOOP_8;
        new_request  <= '0';
      else
        -- Initiate the writing of the result
        thrd2intrfc_opcode <= OPCODE_STORE;
        thrd2intrfc_address <= xaddr + (count(2 to 31) & "00");
        thrd2intrfc_value <= xval;
        next_state <= WAIT_STATE;
        return_state_next <= WHILE_LOOP_6;
        -- Increment count
        count_next <= count + x"00000001";
      end if;
       
       
      

      when FUNCTION_EXIT_1 =>
        thrd2intrfc_value <= timer;
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
        new_request  <= '0';
       

      when others =>
        next_state <= ERROR_STATE;
        new_request  <= '0';
       

    end case;
  end process HWTUL_STATE_MACHINE;
end architecture IMP;
