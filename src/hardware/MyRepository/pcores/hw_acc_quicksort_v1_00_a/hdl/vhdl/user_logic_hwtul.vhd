-- ************************************
-- Automatically Generated FSM
-- Author :Alborz Sad.
-- hw_acc_quicksort
-- ************************************


--      request send         6bitOpcode,10bitReseved,16bitparam1         32bit param2(if opcode is push or write)       
--      response from mb                       32bitMblaze_return

--API ( User puts  the appropirate values into Opcode, Param1, and param2 and return_state, then calls send_request. U can get the value
--      returned by mblaze in mb_ret. For load and store into global memory, just simply update addr,data, wren,ren of brams and go to the
--      next state.

--Example :
          -- when Q4=>            
          --  opcode_next <=  OPCODE_WRITE;
          --  param1_next <= x"0002";
          --  param2_next <= x"BEAF";
          --  return_state_next <= Q5;
          --  next_state <= send_request;



-- Request                      Opcode-6bit        Parm1-16bit   Param2-32bits  Mblaze_ret32bits       next_state
--push                          16                    --             value          --                return_state
--pop                           17                    --              --            value             return_state
 

--Declare                        3                    num             --             --                return_state
--read(local variable)           4                    addr            --             value             return_state  
--write((local variable)         5                    addr            value          --                return_state




--call                          18                    next_pc          --             --               return_state   
--return                        19                    --               --             next_pc          next_pc(mb_ret value)   
--done                          0                     -----------------------------------------------------------------
--
--Load(from BRAM)               in_array_addr0 <= addr;    array_rENA0 <= '1';   next_state <= QUICKSORT_WHILE;	  
--	                        when QUICKSORT_WHILE =>  
--                                      right_next <=array_dout0;
        
          
--Store(into BRAM)       in_array_addr0 <= addr; array_dIN0 <= value; array_wENA0 <= (others => '1'); array_rENA0 <= '1'; next_state   <=QUICKSORT_SWAP_2;
--
--
-- 
--
--
--
--
--


-- **********************
-- Library inclusions
-- **********************
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- **********************
-- Entity Definition
-- **********************
entity quicksort is
port
(
  array_addr0 : out std_logic_vector(0 to 31);
  array_dIN0 : out std_logic_vector(0 to 31);
  array_dOUT0 : in std_logic_vector(0 to 31);
  array_rENA0 : out std_logic;
  array_wENA0 : out std_logic_vector( 0 to 3);


  chan1_channelDataIn : out std_logic_vector(0 to (32 - 1));
  chan1_channelDataOut : in std_logic_vector(0 to (32 - 1));
  chan1_exists : in std_logic;
  chan1_full : in std_logic;
  chan1_channelRead : out std_logic;
  chan1_channelWrite : out std_logic;


  clock_sig : in std_logic;
  reset_sig : in std_logic
  );
end entity quicksort;

-- *************************************************
-- Architecture Definition
-- **************************************************
architecture IMPLEMENTATION of quicksort is

-- *********************************************************************************************************
-- Type definitions for state signals
-- **********************************************************************************************************
type STATE_MACHINE_TYPE is
(
	reset,
	idle,
	decode,
	send_request,
	send_request2,
	wait_for_mblaze,
	extra1,
	extra2,


--user defined states
   
    READ_SORTDATA_1,
    READ_SORTDATA_2,
    READ_SORTDATA_3,
    READ_SORTDATA_4,
    READ_SORTDATA_5,
    READ_SORTDATA_6,
    READ_SORTDATA_7,
    READ_SORTDATA_8,
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
    QUICKSORT_RETURN,A,B,C,D,E,F,G,H,I,J,K

);
 signal current_state,next_state: STATE_MACHINE_TYPE :=reset;
 signal return_state, return_state_next : state_machine_type := reset;



-- *********************************************************************************************************
-- Constant Definition
-- **********************************************************************************************************
 
  constant U_EXIT_THREAD_1                     : std_logic_vector(0 to 15) := x"0021";
  constant U_QUICKSORT_1                       : std_logic_vector(0 to 15) := x"0101";
  constant U_QUICKSORT_CALL_QS_6               : std_logic_vector(0 to 15) := x"0171";
  constant U_QUICKSORT_RETURN                  : std_logic_vector(0 to 15) := x"0181";
 
  -- Memory sub-interface specific opcodes
  constant OPCODE_LOAD                         : std_logic_vector(0 to 5) := "000001";
  constant OPCODE_STORE                        : std_logic_vector(0 to 5) := "000010";
  constant OPCODE_DECLARE                      : std_logic_vector(0 to 5) := "000011";
  constant OPCODE_READ                         : std_logic_vector(0 to 5) := "000100";
  constant OPCODE_WRITE                        : std_logic_vector(0 to 5) := "000101";

  -- Function sub-interface specific opcodes
  constant OPCODE_PUSH                         : std_logic_vector(0 to 5) := "010000";
  constant OPCODE_POP                          : std_logic_vector(0 to 5) := "010001";
  constant OPCODE_CALL                         : std_logic_vector(0 to 5) := "010010";
  constant OPCODE_RETURN                       : std_logic_vector(0 to 5) := "010011";
  constant Z32 : std_logic_vector(0 to 31) := (others => '0');



-- ****************************************************
-- Type definitions for FSM signals
-- ****************************************************
  signal startPtr, startPtr_next : std_logic_vector(0 to 31);
  signal endPtr, endPtr_next : std_logic_vector(0 to 31);
  signal leftPtr, leftPtr_next : std_logic_vector(0 to 31);
  signal rightPtr, rightPtr_next : std_logic_vector(0 to 31);
  signal left, left_next : std_logic_vector(0 to 31);
  signal right, right_next : std_logic_vector(0 to 31);
  signal pivot, pivot_next : std_logic_vector(0 to 31);


signal data1, data1_next : std_logic_vector(0 to 31);
signal data2, data2_next : std_logic_vector(0 to 31);
signal arg1, arg1_next : std_logic_vector(0 to 31);
signal arg2, arg2_next : std_logic_vector(0 to 31);


signal param1,param1_next :std_logic_vector(0 to 15);
signal param2,param2_next :std_logic_vector(0 to 31);
signal opcode,opcode_next :std_logic_vector(0 to 5);
signal mblaze_ret,mblaze_ret_next :std_logic_vector(0 to 31);



-- ****************************************************
-- User-defined VHDL Section
-- ****************************************************
signal in_array_addr0 :  std_logic_vector(0 to (32 - 1));
-- Architecture Section
begin

-- ************************
-- Permanent Connections
-- ************************
  --array_addr0 <= in_array_addr0(2 to 31) & "00"; --The external memory is organized in this way.
  array_addr0 <= in_array_addr0; --the address is already adding /subtracting by four in vhdl code.

-- ************************
-- BRAM implementations
-- ************************

-- ****************************************************
-- Process to handle the synchronous portion of an FSM
-- ****************************************************
FSM_SYNC_PROCESS : process(
  
  data1_next,
  data2_next,
  arg1_next,
  arg2_next,
  
  param1_next,
  param2_next,
  opcode_next,
  return_state_next,
  mblaze_ret_next,



  next_state,
  clock_sig, reset_sig) is
begin
  if (clock_sig'event and clock_sig = '1') then
    if (reset_sig = '1') then
    -- Reset all FSM signals, and enter the initial state
     
      data1 <= (others => '0');
      data2 <= (others => '0');
      arg1 <= (others => '0');
      arg2 <= (others => '0');

      startPtr <= (others => '0');
      endPtr <=(others => '0');
      leftPtr <= (others => '0');
      rightPtr <= (others => '0');
      left <= (others => '0');
      right <=(others => '0');
      pivot <= (others => '0');
      return_state <= reset;

	param1 <= (others => '0');
	param2 <= (others => '0');
	opcode <= (others => '0');
	mblaze_ret <= (others => '0');

      current_state <= reset;
    else
    -- Transition to next state
      
      data1 <= data1_next;
      data2 <= data2_next;
      arg1 <= arg1_next;
      arg2 <= arg2_next;


      startPtr <= startPtr_next;
      endPtr <= endPtr_next;
      leftPtr <= leftPtr_next;
      rightPtr <= rightPtr_next;
      left <= left_next;
      right <= right_next;
      pivot <= pivot_next;
      return_state <= return_state_next;

	param1 <= param1_next;
	param2 <= param2_next;
	opcode <= opcode_next;
	return_state <=return_state_next;
	mblaze_ret <= mblaze_ret_next;


      current_state <= next_state;
    end if;
  end if;
end process FSM_SYNC_PROCESS;

-- ************************************************************************
-- Process to handle the asynchronous (combinational) portion of an FSM
-- ************************************************************************
FSM_COMB_PROCESS : process(
  array_dOUT0,

  chan1_channelDataOut, chan1_full, chan1_exists,


  data1,
  data2,
  arg1,
  arg2,

  param1,
  param2,
  opcode,
  return_state,
  mblaze_ret,


  current_state) is
begin
  -- Default signal assignments
 
  data1_next <= data1;
  data2_next <= data2;
  arg1_next <= arg1;
  arg2_next <= arg2;

   return_state_next <= return_state;

    startPtr_next <= startPtr;
    endPtr_next <= endPtr;
    leftPtr_next <= leftPtr;
    rightPtr_next <= rightPtr;
    left_next <= left;
    right_next <= right;
    pivot_next <= pivot;


  param1_next <= param1;
  param2_next <=  param2;
  opcode_next<=opcode;
  return_state_next <= return_state;
  mblaze_ret_next <=mblaze_ret;

  in_array_addr0 <= (others => '0');
  array_dIN0  <= (others => '0');
  array_rENA0 <= '0';
  array_wENA0 <= (others => '0');

  
  chan1_channelDataIn <= (others => '0');
  chan1_channelRead <= '0';
  chan1_channelWrite <= '0';


  next_state <= current_state;

  -- FSM logic
  case (current_state) is

   when send_request=>
      if chan1_full /= '0' then
        next_state <= send_request;
      elsif chan1_full = '0' then
        chan1_channelDataIn <= opcode & "0000000000" &param1;
        chan1_channelWrite <= '1'; 
        if (opcode = OPCODE_PUSH or opcode=OPCODE_WRITE) then  --so we should send parameter2, which is the value    
             next_state <= send_request2;
        else
             next_state <= wait_for_mblaze;
         end if;		  
      end if;

    when send_request2 =>
      if chan1_full /= '0' then
        next_state <= send_request2;
      elsif chan1_full = '0' then
        chan1_channelDataIn <= param2;
        chan1_channelWrite <= '1';        
        next_state <= wait_for_mblaze;
      end if;

   when wait_for_mblaze =>
      if chan1_exists = '0' then
        next_state <= wait_for_mblaze;
      elsif chan1_exists /= '0' then
        mblaze_ret_next <= chan1_channelDataOut;
        chan1_channelRead <= '1';

        if (opcode /=  OPCODE_RETURN) then            
            next_state <= return_state;
        else
            case (chan1_channelDataOut(16 to 31)) is	
		  when U_QUICKSORT_CALL_QS_6 =>
			 next_state <= QUICKSORT_CALL_QS_6;
		  when U_QUICKSORT_RETURN =>
			 next_state <= QUICKSORT_RETURN;
		  when U_EXIT_THREAD_1 =>
			 next_state <= EXIT_THREAD_1;
		  when others =>
			 next_state <= reset;
            end case; 
        end if;
      end if;


   when reset =>
      next_state <= idle;
		
				 

   when idle =>
      if chan1_exists = '0' then
        next_state <= idle;
      elsif chan1_exists /= '0' then
        data1_next <= chan1_channelDataOut;
        chan1_channelRead <= '1';
        next_state <= decode;
      end if;

    
    when decode =>
      arg2_next <= "00000000000000000" & data1(2 to 16);  --end address
      arg1_next <= "00000000000000000" & data1(17 to 31);  --start adderss
      next_state <= READ_SORTDATA_4 ;
    
         
                 
          when READ_SORTDATA_4 => -- 0006
            endPtr_next <= arg2;
            startPtr_next <= arg1;
            leftPtr_next <= arg1;
            rightPtr_next <= arg2;
            -- Declare four local variables to hold start, end, left, right pointers
            opcode_next <= OPCODE_DECLARE;
            param1_next <= x"0004";  
            
            return_state_next <= READ_SORTDATA_5;
            next_state <= send_request;  
        
           
           

          when READ_SORTDATA_5 => -- 0007
            -- Save the start pointer
            opcode_next <= OPCODE_WRITE;
            param1_next <= x"0000";  
            param2_next <= startPtr;      
            return_state_next <= READ_SORTDATA_6;
            next_state <= send_request;  

           
          when READ_SORTDATA_6 => -- 0008
            -- Save the end pointer
            opcode_next <=  OPCODE_WRITE;
            param1_next <= x"0001";
            param2_next <= endPtr;
            return_state_next <= READ_SORTDATA_7;
            next_state <= send_request;

          when READ_SORTDATA_7 => -- 0009
            -- Save the left pointer
            opcode_next <=  OPCODE_WRITE;
            param1_next <= x"0002";
            param2_next <= leftPtr;
            return_state_next <= READ_SORTDATA_8;
            next_state <= send_request;

          when READ_SORTDATA_8 => -- 000A
            -- Save the right pointer
            opcode_next <=  OPCODE_WRITE;
            param1_next <= x"0003";
            param2_next <= rightPtr;
            -- Sort the data!
            return_state_next <= CALL_QSORT_1;
            next_state <= send_request;

          when CALL_QSORT_1 => -- 0011
            -- Push the second argument, endPtr;
            opcode_next <=  OPCODE_PUSH;
            param2_next <= rightPtr;
            return_state_next <= CALL_QSORT_2;
            next_state <= send_request;

          when CALL_QSORT_2 => -- 0012
            -- Push the first argument, startPtr;
            opcode_next <=  OPCODE_PUSH;
            param2_next <= leftPtr;
            return_state_next <= CALL_QSORT_3;
            next_state <= send_request;

          when CALL_QSORT_3 => -- 0013
            -- Call quicksort
            opcode_next <=  OPCODE_CALL;

            param1_next <=  U_EXIT_THREAD_1;
            return_state_next <= QUICKSORT_1;
            next_state <= send_request;

       
          when EXIT_THREAD_1 => -- 0021
            opcode_next <=  (others => '0');  --means I am done.
            param1_next <=  (others => '0');
            return_state_next <= idle;
            next_state <= send_request;

       

        

-----------------------------------------------------------------------
-- Quicksort function
-- argument 1 - start pointer
-- argument 2 - end pointer
-----------------------------------------------------------------------
          when QUICKSORT_1 => -- 0101
            -- Read the first argument
            opcode_next <=  OPCODE_POP;
          
            return_state_next <= QUICKSORT_2;
            next_state <= send_request;

          when QUICKSORT_2 => -- 0102
            startPtr_next <=mblaze_ret;
            -- Read the second argument
            opcode_next <=  OPCODE_POP;
           
            return_state_next <= QUICKSORT_3;
            next_state <= send_request;

          when QUICKSORT_3 => -- 0103
            endPtr_next <=mblaze_ret;
            next_state <= QUICKSORT_4;
           

          when QUICKSORT_4 => -- 0104
            -- Declare 5 variables
            opcode_next <=  OPCODE_DECLARE;
            param1_next <= x"0002";
            return_state_next <= QUICKSORT_5;
            next_state <= send_request;

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
           -- opcode_next <=  OPCODE_LOAD;
            --param1_next <= leftPtr(16 to 31);
            --return_state_next <= QUICKSORT_8;
            --next_state <= send_request;

	    in_array_addr0 <= leftPtr;
	    array_rENA0 <= '1';	  
            next_state <= QUICKSORT_8;



          when QUICKSORT_8 => -- 0108
            left_next <= array_dOUT0;
            -- Read the value of the rightPtr
           -- opcode_next <=  OPCODE_LOAD;
           -- param1_next <= rightPtr(16 to 31);
           -- return_state_next <= QUICKSORT_9;
           -- next_state <= send_request;

            in_array_addr0 <= rightptr;
	    array_rENA0 <= '1';	  
            next_state <= QUICKSORT_9;

          when QUICKSORT_9 => -- 0109
            right_next <= array_dout0;
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
           -- opcode_next <=  OPCODE_LOAD;
            --param1_next <= leftPtr(16 to 31);
           -- return_state_next <= QUICKSORT_WHILE_LEFT_3;
           -- next_state <= send_request;

            in_array_addr0 <= leftPtr;
	    array_rENA0 <= '1';	  
            next_state <= QUICKSORT_WHILE_LEFT_3;

          when QUICKSORT_WHILE_LEFT_3 => -- 0123
            left_next <=array_dout0;
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
            --opcode_next <=  OPCODE_LOAD;
            --param1_next <= rightPtr(16 to 31);
            --return_state_next <= QUICKSORT_WHILE_RIGHT_3;
            --next_state <= send_request;

            in_array_addr0 <= rightptr;
	    array_rENA0 <= '1';	  
            next_state <= QUICKSORT_WHILE_RIGHT_3;



          when QUICKSORT_WHILE_RIGHT_3 => -- 0143
            right_next <=array_dout0;
            next_state <= QUICKSORT_BREAK;
           

          when QUICKSORT_SWAP_1 => -- 0151
            -- write the value of rightPtr with left
            --opcode_next <=  OPCODE_STORE;
           -- param1_next <= rightPtr(16 to 31);
            --param2_next <= left;
            --return_state_next <= QUICKSORT_SWAP_2;
            --next_state <= send_request;

            in_array_addr0 <= rightPtr;
            array_dIN0 <= left;
            array_wENA0 <= (others => '1');
            array_rENA0 <= '1';
            next_state   <=QUICKSORT_SWAP_2;

          when QUICKSORT_SWAP_2 => -- 0152
            -- write the value of leftPtr with right
            --opcode_next <=  OPCODE_STORE;
            --param1_next <= leftPtr(16 to 31);
           -- param2_next <= right;
           -- return_state_next <= QUICKSORT_SWAP_3;
            --next_state <= send_request;

            in_array_addr0 <= leftPtr;
            array_dIN0 <= right;
            array_wENA0 <= (others => '1');
            array_rENA0 <= '1';
            next_state   <=QUICKSORT_SWAP_3;

          when QUICKSORT_SWAP_3 => -- 0153
            -- increment/decrement pointers
            leftPtr_next <= leftPtr + 4;
            rightPtr_next <= rightPtr - 4;
            next_state <= QUICKSORT_SWAP_4;
           

          when QUICKSORT_SWAP_4 => -- 0154
            -- read new value of left
            --opcode_next <=  OPCODE_LOAD;
           -- param1_next <= leftPtr(16 to 31);
            --return_state_next <= QUICKSORT_SWAP_5;
            --next_state <= send_request;

            in_array_addr0 <= leftPtr;
	    array_rENA0 <= '1';	  
            next_state <= QUICKSORT_SWAP_5;

          when QUICKSORT_SWAP_5 => -- 0155
            left_next <=array_dout0;
            -- read new value of right
            --opcode_next <=  OPCODE_LOAD;
            --param1_next <= rightPtr(16 to 31);
            --return_state_next <= QUICKSORT_WHILE;
            --next_state <= send_request;

            in_array_addr0 <= rightptr;
	    array_rENA0 <= '1';	  
            next_state <= QUICKSORT_WHILE;



          when QUICKSORT_WHILE => -- 0161
            right_next <=array_dout0;
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
            opcode_next <=  OPCODE_WRITE;
            param1_next <= x"0000";
            param2_next <= rightPtr;
            return_state_next <= QUICKSORT_CALL_QS_2;
            next_state <= send_request;

          when QUICKSORT_CALL_QS_2 => -- 0172
            -- Save the endPtr
            opcode_next <=  OPCODE_WRITE;
            param1_next <= x"0001";
            param2_next <= endPtr;
            return_state_next <= QUICKSORT_CALL_QS_3;
            next_state <= send_request;

          when QUICKSORT_CALL_QS_3 => -- 0173
            -- Push the leftPtr
            opcode_next <=  OPCODE_PUSH;
            param2_next <= leftPtr;
            return_state_next <= QUICKSORT_CALL_QS_4;
            next_state <= send_request;

          when QUICKSORT_CALL_QS_4 => -- 0174
            -- Push the startPtr 
            opcode_next <=  OPCODE_PUSH;
            param2_next <= startPtr;
            return_state_next <= QUICKSORT_CALL_QS_5;
            next_state <= send_request;

          when QUICKSORT_CALL_QS_5 => -- 0175
            -- Call quicksort
            opcode_next <=  OPCODE_CALL;

            param1_next <=  U_QUICKSORT_CALL_QS_6;
            return_state_next <= QUICKSORT_1;
            next_state <= send_request;

          when QUICKSORT_CALL_QS_6 => -- 0176
            -- read the value of endPtr
            opcode_next <=  OPCODE_READ;
            param1_next <= x"0001";
            return_state_next <= QUICKSORT_CALL_QS_7;
            next_state <= send_request;

          when QUICKSORT_CALL_QS_7 => -- 0177
            endPtr_next <=mblaze_ret;
            -- read the value of rightPtr
            opcode_next <=  OPCODE_READ;
            param1_next <= x"0000";
            return_state_next <= QUICKSORT_CALL_QS_8;
            next_state <= send_request;

          when QUICKSORT_CALL_QS_8 => -- 0178
            rightPtr_next <=mblaze_ret;
            -- Push the rightPtr
            opcode_next <=  OPCODE_PUSH;
            param2_next <= endPtr;
            return_state_next <= QUICKSORT_CALL_QS_9;
            next_state <= send_request;

          when QUICKSORT_CALL_QS_9 => -- 0179
            -- push the endPtr
            opcode_next <=  OPCODE_PUSH;
            param2_next <= rightPtr;
            return_state_next <= QUICKSORT_CALL_QS_A;
            next_state <= send_request;

          when QUICKSORT_CALL_QS_A => -- 017A
            -- Call quicksort
            opcode_next <=  OPCODE_CALL;

            param1_next <= U_QUICKSORT_RETURN;
            return_state_next <= QUICKSORT_1;
            next_state <= send_request;

          when QUICKSORT_RETURN => -- 0181
            -- Return
            opcode_next <=  OPCODE_RETURN;
            next_state <= send_request;

 	


    when others => 
      next_state <= reset;

  end case;
end process FSM_COMB_PROCESS;

end architecture IMPLEMENTATION;



