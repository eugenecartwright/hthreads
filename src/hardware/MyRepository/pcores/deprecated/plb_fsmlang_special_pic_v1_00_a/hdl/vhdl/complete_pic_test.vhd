--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:58:07 09/10/2009
-- Design Name:   
-- Module Name:   /home/abaez/ise_projects/complete_pic/src//complete_pic_test.vhd
-- Project Name:  ise_proj
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: complete_pic
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
 
ENTITY complete_pic_test IS
generic (
    C_NUM_INTERRUPTS : integer := 8;
    C_REG_SIZE       : integer := 9;
    C_CMD_WIDTH      : integer := 4;
)
END complete_pic_test;
 
ARCHITECTURE behavior OF complete_pic_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT complete_pic
    PORT(
         msg_chan_channelDataIn : OUT  std_logic_vector(0 to 7);
         msg_chan_channelDataOut : IN  std_logic_vector(0 to 7);
         msg_chan_exists : IN  std_logic;
         msg_chan_full : IN  std_logic;
         msg_chan_channelRead : OUT  std_logic;
         msg_chan_channelWrite : OUT  std_logic;
         go : IN  std_logic;
         ack : OUT  std_logic;
         TID_IN : IN  std_logic_vector(0 to 7);
         IID_IN : IN  std_logic_vector(0 to log2(C_NUM_INTERRUPTS)-1);
         CMD_IN : IN  std_logic_vector(0 to C_CMD_WIDTH-1);
         RET_OUT : OUT  std_logic_vector(0 to 7);
         TID_OUT : OUT  std_logic_vector(0 to 7);
         interrupts_in : IN  std_logic_vector(0 to C_NUM_INTERRUPTS-1);
         clock_sig : IN  std_logic;
         reset_sig : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal msg_chan_channelDataOut : std_logic_vector(0 to 7) := (others => '0');
   signal msg_chan_exists : std_logic := '0';
   signal msg_chan_full : std_logic := '0';
   signal go : std_logic := '0';
   signal TID_IN : std_logic_vector(0 to 7) := (others => '0');
   signal IID_IN : std_logic_vector(0 to log2(C_NUM_INTERRUPTS)-1) := (others => '0');
   signal CMD_IN : std_logic_vector(0 to C_CMD_WIDTH-1) := (others => '0');
   signal interrupts_in : std_logic_vector(0 to C_CMD_WIDTH-1) := (others => '0');
   signal clock_sig : std_logic := '0';
   signal reset_sig : std_logic := '0';

 	--Outputs
   signal msg_chan_channelDataIn : std_logic_vector(0 to 7);
   signal msg_chan_channelRead : std_logic;
   signal msg_chan_channelWrite : std_logic;
   signal ack : std_logic;
   signal RET_OUT : std_logic_vector(0 to 7);
   signal TID_OUT : std_logic_vector(0 to 7);

   -- Clock period definitions
   constant clock_sig_period : time := 1 us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: complete_pic PORT MAP (
          msg_chan_channelDataIn => msg_chan_channelDataIn,
          msg_chan_channelDataOut => msg_chan_channelDataOut,
          msg_chan_exists => msg_chan_exists,
          msg_chan_full => msg_chan_full,
          msg_chan_channelRead => msg_chan_channelRead,
          msg_chan_channelWrite => msg_chan_channelWrite,
          go => go,
          ack => ack,
          TID_IN => TID_IN,
          IID_IN => IID_IN,
          CMD_IN => CMD_IN,
          RET_OUT => RET_OUT,
          TID_OUT => TID_OUT,
          interrupts_in => interrupts_in,
          clock_sig => clock_sig,
          reset_sig => reset_sig
        );

   -- Clock process definitions
   clock_sig_process :process
   begin
		clock_sig <= '0';
		wait for clock_sig_period/2;
		clock_sig <= '1';
		wait for clock_sig_period/2;
   end process;
 
    -- Calculate the log base 2 of some natural number. This function can be
    -- used to determine the minimum number of bits needed to represent the
    -- given natural number.
    function log2( n : in natural ) return positive is
    begin
        if n <= 2 then
            return 1;
        else
            return 1 + log2(n/2);
        end if;
    end function log2;


   -- Stimulus process
   stim_proc: process
procedure assoc(tid : in std_logic_vector(0 to 7); iid : in std_logic_vector(0 to log2(C_NUM_INTERRUPTS)-1)) is
	begin
		wait until clock_sig = '0';
		TID_IN <= tid;
		IID_IN <= iid;		
		CMD_IN <= "0001";
		go		 <= '1';
		wait until ack = '1';

		wait for 2*clock_sig_period;
		TID_IN <= tid;
		IID_IN <= iid;		
		CMD_IN <= "0001";
		go		 <= '0';
		wait until ack = '0';
	end procedure assoc;

	procedure read_entry(tid : in std_logic_vector(0 to 7); iid : in std_logic_vector(0 to log2(C_NUM_INTERRUPTS)-1)) is
	begin
		wait until clock_sig = '0';
		TID_IN <= tid;
		IID_IN <= iid;		
		CMD_IN <= "0000";
		go		 <= '1';
		wait until ack = '1';

		wait for 2*clock_sig_period;
		TID_IN <= tid;
		IID_IN <= iid;		
		CMD_IN <= "0000";
		go		 <= '0';
		wait until ack = '0';
	end procedure read_entry;

	procedure clear_entry(tid : in std_logic_vector(0 to 7); iid : in std_logic_vector(0 to log2(C_NUM_INTERRUPTS)-1)) is
	begin
		wait until clock_sig = '0';
		TID_IN <= tid;
		IID_IN <= iid;		
		CMD_IN <= "0010";
		go		 <= '1';
		wait until ack = '1';

		wait for 2*clock_sig_period;
		TID_IN <= tid;
		IID_IN <= iid;		
		CMD_IN <= "0010";
		go		 <= '0';
		wait until ack = '0';
	end procedure clear_entry;
	
	procedure generate_interrupt(intr : in std_logic_vector(0 to C_NUM_INTERRUPTS-1)) is
	begin
		wait until clock_sig = '0';
		interrupts_in <= intr;
		wait until clock_sig = '1';

		wait for 5*clock_sig_period;
	end procedure generate_interrupt;
	
   begin		
      -- hold reset state for 100ms.
      wait for 50 ns;
		reset_sig <= '1';
		wait for clock_sig_period;
		reset_sig <= '0';
      wait for 5*clock_sig_period;
		
      -- insert stimulus here
		go <= '0';
		
		-- start. Write into memory #2 and #3 values 15 and 8.		
		assoc("00001111","010");
		assoc("00001000","011");
      
		-- Change the command to interrupt read an empty register
		generate_interrupt("0100");
		read_entry("00001010","010");
		
		-- write another TID to memory #0
		assoc("10110000","000");
		
		-- specify another write to already chosen memory #0 - failure condition
		assoc("00100000","000");

      -- Set go to LOW and try to write.
		wait for 4*clock_sig_period;
		go <= '0';
		TID_IN <= "11001100";
		IID_IN <= "10";
		
		-- Generate an interrupt for registers #0,#1 and #3
		generate_interrupt("1101");
		
		-- read memory address 3
		read_entry("00110011","011");
		
		-- Generate last interrupt
		wait for 5*clock_sig_period;
		generate_interrupt("1111");
		
     wait;
   end process;

END;
