

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_misc.all;

library Unisim;
use Unisim.all;



entity user_logic_hwtul is
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
    STATE_21,
    STATE_22,
    STATE_23,
    STATE_24,
    STATE_25,
    STATE_26,
    STATE_27,
    STATE_28,
    STATE_29,
    STATE_30,
    FUNCTION_EXIT_1,
    FUNCTION_EXIT_2,    
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
  constant U_STATE_21                            : std_logic_vector(0 to 15) := x"0121";
  constant U_STATE_22                            : std_logic_vector(0 to 15) := x"0122";
  constant U_STATE_23                            : std_logic_vector(0 to 15) := x"0123";
  constant U_STATE_24                            : std_logic_vector(0 to 15) := x"0124";
  constant U_STATE_25                            : std_logic_vector(0 to 15) := x"0125";
  constant U_STATE_26                            : std_logic_vector(0 to 15) := x"0126";
  constant U_STATE_27                            : std_logic_vector(0 to 15) := x"0127";
  constant U_STATE_28                            : std_logic_vector(0 to 15) := x"0128";
  constant U_STATE_29                            : std_logic_vector(0 to 15) := x"0129";
  constant U_STATE_30                            : std_logic_vector(0 to 15) := x"0130";

     

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
  signal index, index_next : std_logic_vector(0 to 31);
  signal mutexAddr1, mutexAddr1_next : std_logic_vector(0 to 31);
  signal condAddr1, condAddr1_next : std_logic_vector(0 to 31);
  signal mutexAddr2, mutexAddr2_next : std_logic_vector(0 to 31);
  signal condAddr2, condAddr2_next : std_logic_vector(0 to 31);
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
      mutexAddr1 <= mutexAddr1_next;   
      condAddr1 <= condAddr1_next;   
      mutexAddr2 <= mutexAddr2_next;   
      condAddr2 <= condAddr2_next;      
      count <= count_next;
  

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
          when U_STATE_21 =>
            current_state <= STATE_21;
          when U_STATE_22 =>
            current_state <= STATE_22;
          when U_STATE_23 =>
            current_state <= STATE_23;
          when U_STATE_24 =>
            current_state <= STATE_24;
          when U_STATE_25 =>
            current_state <= STATE_25;
          when U_STATE_26 =>
            current_state <= STATE_26;
          when U_STATE_27 =>
            current_state <= STATE_27;
          when U_STATE_28 =>
            current_state <= STATE_28;
          when U_STATE_29 =>
            current_state <= STATE_29;
          when U_STATE_30 =>
            current_state <= STATE_30;        


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
    mutexAddr1_next <= mutexAddr1;  
    condAddr1_next<= condAddr1;    
    mutexAddr2_next <= mutexAddr2;  
    condAddr2_next<= condAddr2;       
    count_next <= count;

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
        next_state <= WAIT_STATE;
        return_state_next <= STATE_1;

-----------------------------------------------------
--Read size( number of tests), mutex and cond addr
-----------------------------------------------------

      when STATE_1 =>
        -- Read the argument, which is an address of a struct
        structAddr_next <= toUser_value;
        -- Initiate the reading of the first variable in the struct, size
        thrd2intrfc_opcode <= OPCODE_LOAD;
        thrd2intrfc_address <= toUser_value;
        next_state <= WAIT_STATE;
        return_state_next <= STATE_2;

      when STATE_2 =>
        -- Read the value of size
        size_next <= toUser_value;
        -- Initiate the reading of the second variable in the struct, mutex1
        thrd2intrfc_opcode <= OPCODE_LOAD;
        thrd2intrfc_address <= structAddr + x"00000004";
        next_state <= WAIT_STATE;
        return_state_next <= STATE_3;

      when STATE_3 =>
        -- Read the value of xAddr
        mutexAddr1_next <= toUser_value;
        -- Initiate the reading of the fourth variable in the struct, condAddr1
        thrd2intrfc_opcode <= OPCODE_LOAD;
        thrd2intrfc_address <= structAddr + x"00000008";
        next_state <= WAIT_STATE;
        return_state_next <= STATE_4; 
     

      when STATE_4 =>
        -- Read the value of condAddr1
        condAddr1_next <= toUser_value;
       -- Initiate the reading of the fourth variable in the struct, mutexaddr2
        thrd2intrfc_opcode <= OPCODE_LOAD;
        thrd2intrfc_address <= structAddr + x"0000000C";
        next_state <= WAIT_STATE;
        return_state_next <= STATE_19; 
   
       when STATE_19 =>
        -- Read the value of mutexAddr1
        mutexAddr2_next <= toUser_value;
       -- Initiate the reading of the fourth variable in the struct, condaddrr2
        thrd2intrfc_opcode <= OPCODE_LOAD;
        thrd2intrfc_address <= structAddr + x"00000010";
        next_state <= WAIT_STATE;
        return_state_next <= STATE_20;  

       when STATE_20 =>       
        condAddr2_next <= toUser_value; 
        next_state <= STATE_24;
        new_request  <= '0';
-----------------------------------------------------
--Cond_signal part;
-----------------------------------------------------

--Wait until C=1
     when STATE_24 =>
        -- LOAD C
        thrd2intrfc_opcode <= OPCODE_LOAD;
        thrd2intrfc_address <= structAddr + x"00000018";       
        next_state <= WAIT_STATE;
        return_state_next <= STATE_25;

      when STATE_25 =>
        if (toUser_value =x"00000001") then
            next_state <= STATE_5;
            new_request  <= '0';
        else
           next_state <= STATE_24;
           new_request  <= '0';
        end if;

--Lock the mutex
      when STATE_5 =>
        -- Lock the mutex, push the address of the mutex
        thrd2intrfc_opcode <= OPCODE_PUSH;
        thrd2intrfc_value <= mutexAddr2;
        next_state <= WAIT_STATE;
        return_state_next <= STATE_6;

      when STATE_6 =>
        -- Call mutex lock
        thrd2intrfc_opcode <= OPCODE_CALL;
        thrd2intrfc_function <= FUNCTION_HTHREAD_MUTEX_LOCK;
        thrd2intrfc_value <= Z32(0 to 15) & U_STATE_7;
        next_state <= WAIT_STATE;


--signal the cond variable    
      when STATE_7 =>        
             thrd2intrfc_opcode <= OPCODE_PUSH;
             thrd2intrfc_value <= condAddr2;
             next_state <= WAIT_STATE;
             return_state_next <= STATE_8;
        

       when STATE_8 =>
        -- Unlock the mutex
        thrd2intrfc_opcode <= OPCODE_CALL;
        thrd2intrfc_function <= FUNCTION_HTHREAD_COND_SIGNAL;
        thrd2intrfc_value <= Z32(0 to 15) & U_STATE_23;
        next_state <= WAIT_STATE;

-- C=3;
     when STATE_23 =>
        index_next <= toUser_value;
        -- increment index
        thrd2intrfc_opcode <= OPCODE_STORE;
        thrd2intrfc_address <= structAddr + x"00000018";
        thrd2intrfc_value <= x"00000003";
        next_state <= WAIT_STATE;
        return_state_next <= STATE_9;

--unlock the mutex
      when STATE_9 =>
        thrd2intrfc_opcode <= OPCODE_PUSH;
        thrd2intrfc_value <= mutexAddr2;
        next_state <= WAIT_STATE;
        return_state_next <= STATE_10;

      when STATE_10 =>
        -- Unlock the mutex
        thrd2intrfc_opcode <= OPCODE_CALL;
        thrd2intrfc_function <= FUNCTION_HTHREAD_MUTEX_UNLOCK;
        thrd2intrfc_value <= Z32(0 to 15) & U_STATE_11;
        next_state <= WAIT_STATE;


  -----------------------------------------------------
--cond_wait part
-----------------------------------------------------    


--Lock the mutex
     when STATE_11 =>
        -- Lock the mutex, push the address of the mutex
        thrd2intrfc_opcode <= OPCODE_PUSH;
        thrd2intrfc_value <= mutexAddr1;
        next_state <= WAIT_STATE;
        return_state_next <= STATE_12;

      when STATE_12 =>
        -- Call mutex lock
        thrd2intrfc_opcode <= OPCODE_CALL;
        thrd2intrfc_function <= FUNCTION_HTHREAD_MUTEX_LOCK;
        thrd2intrfc_value <= Z32(0 to 15) & U_STATE_21;
        next_state <= WAIT_STATE;

--C = 1;
    
      when STATE_21 =>
        index_next <= toUser_value;
        -- increment index
        thrd2intrfc_opcode <= OPCODE_STORE;
        thrd2intrfc_address <= structAddr + x"00000014";
        thrd2intrfc_value <= x"00000001";
        next_state <= WAIT_STATE;
        return_state_next <= STATE_13;


--Wait for (cond,mutex)
      when STATE_13 =>
        thrd2intrfc_opcode <= OPCODE_PUSH;
        thrd2intrfc_value <= mutexAddr1;
        next_state <= WAIT_STATE;
        return_state_next <= STATE_14;

      when STATE_14 =>
        thrd2intrfc_opcode <= OPCODE_PUSH;
        thrd2intrfc_value <= condAddr1;
        next_state <= WAIT_STATE;
        return_state_next <= STATE_15; 

       when STATE_15 =>
        -- Call mutex lock
        thrd2intrfc_opcode <= OPCODE_CALL;
        thrd2intrfc_function <= FUNCTION_HTHREAD_COND_WAIT;
        thrd2intrfc_value <= Z32(0 to 15) & U_STATE_22;
        next_state <= WAIT_STATE;




--C = 2;

      when STATE_22 =>
        index_next <= toUser_value;
        -- increment index
        thrd2intrfc_opcode <= OPCODE_STORE;
        thrd2intrfc_address <= structAddr + x"00000014";
        thrd2intrfc_value <= x"00000002";
        next_state <= WAIT_STATE;
        return_state_next <= STATE_16;


--UnLock the mutex
       when STATE_16 =>
        thrd2intrfc_opcode <= OPCODE_PUSH;
        thrd2intrfc_value <= mutexAddr1;
        next_state <= WAIT_STATE;
        return_state_next <= STATE_17;

      when STATE_17 =>
        -- Unlock the mutex
        thrd2intrfc_opcode <= OPCODE_CALL;
        thrd2intrfc_function <= FUNCTION_HTHREAD_MUTEX_UNLOCK;
        thrd2intrfc_value <= Z32(0 to 15) & U_STATE_18;
        next_state <= WAIT_STATE;


-----------------------------------------------------
--Check To see if have done enough iteration?
-----------------------------------------------------
       when STATE_18 =>
        -- Increment count
        count_next <= count + x"00000001";
        -- Check to see if the index is over the size
        if ( count = size ) then
            next_state <=FUNCTION_EXIT_1;
            new_request  <= '0';       
        else
           next_state <=STATE_24;
           new_request  <= '0'; 
        end if;  

     
-----------------------------------------------------
--Exit
-----------------------------------------------------
       

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
