--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:46:38 06/16/2009
-- Design Name:   
-- Module Name:   /home/jagron/ise_projects/cond_var/proj/condvar_tb.vhd
-- Project Name:  proj
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: condvar
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

 
ENTITY condvar_tb IS
END condvar_tb;
 
ARCHITECTURE behavior OF condvar_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT condvar
    PORT(
         msg_chan_channelDataIn : OUT  std_logic_vector(0 to 7);
         msg_chan_channelDataOut : IN  std_logic_vector(0 to 7);
         msg_chan_exists : IN  std_logic;
         msg_chan_full : IN  std_logic;
         msg_chan_channelRead : OUT  std_logic;
         msg_chan_channelWrite : OUT  std_logic;
         cmd : IN  std_logic;
         opcode : IN  std_logic_vector(0 to 1);
         cvar : IN  std_logic_vector(0 to 7);
         tid : IN  std_logic_vector(0 to 7);
         ack : OUT  std_logic;
         clock_sig : IN  std_logic;
         reset_sig : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal msg_chan_channelDataOut : std_logic_vector(0 to 7) := (others => '0');
   signal msg_chan_exists : std_logic := '0';
   signal msg_chan_full : std_logic := '0';
   signal cmd : std_logic := '0';
   signal opcode : std_logic_vector(0 to 1) := (others => '0');
   signal cvar : std_logic_vector(0 to 7) := (others => '0');
   signal tid : std_logic_vector(0 to 7) := (others => '0');
   signal clock_sig : std_logic := '0';
   signal reset_sig : std_logic := '0';

 	--Outputs
   signal msg_chan_channelDataIn : std_logic_vector(0 to 7);
   signal msg_chan_channelRead : std_logic;
   signal msg_chan_channelWrite : std_logic;
   signal ack : std_logic;

   -- Clock period definitions
   constant clock_sig_period : time := 10 ns;


constant C_ENQ : std_logic_vector(0 to 2-1) := conv_std_logic_vector(0, 2);  -- Opcode for "wait" enqueue
constant C_DEQ : std_logic_vector(0 to 2-1) := conv_std_logic_vector(1, 2);  -- Opcode for "signal" dequeue
constant C_DEQALL : std_logic_vector(0 to 2-1) := conv_std_logic_vector(2, 2);  -- Opcode for "broadcast" dequeue
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: condvar PORT MAP (
          msg_chan_channelDataIn => msg_chan_channelDataIn,
          msg_chan_channelDataOut => msg_chan_channelDataOut,
          msg_chan_exists => msg_chan_exists,
          msg_chan_full => msg_chan_full,
          msg_chan_channelRead => msg_chan_channelRead,
          msg_chan_channelWrite => msg_chan_channelWrite,
          cmd => cmd,
          opcode => opcode,
          cvar => cvar,
          tid => tid,
          ack => ack,
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
 

   -- Stimulus process
   stim_proc: process

	 procedure operation(aopcode : in std_logic_vector(0 to 1); acvar: in integer; atid : in integer) is
	 begin
		-- Send a packet
		wait until clock_sig = '0' and ack = '0';
		    cvar	<= conv_std_logic_vector(acvar,8);
    		tid	<= conv_std_logic_vector(atid,8);
	    	cmd	<= '1';
		    opcode <= aopcode;
		wait until ack = '1';
		    cvar	<= conv_std_logic_vector(0, 8);
		    tid	<= conv_std_logic_vector(0, 8);
		    cmd	<= '0';
		    opcode <= "00";
		wait until clock_sig = '0';
		wait for 4*clock_sig_period;
	end procedure operation;

   begin		
      wait for clock_sig_period*10;      
		-- Reset the core
		reset_sig <= '1';
      wait for clock_sig_period;
		reset_sig <= '0';
      wait for clock_sig_period;

		-- Delay
      wait for clock_sig_period*2048;

		-- ENQ
        operation(C_ENQ,0,9);	

		-- ENQ
        operation(C_ENQ,0,7);

		-- ENQ
        operation(C_ENQ,0,5);

		-- ENQ
        operation(C_ENQ,0,3);

		-- ENQ
        operation(C_ENQ,1,10);

		-- ENQ
        operation(C_ENQ,1,8);

		-- ENQ
        operation(C_ENQ,1,6);

		-- ENQ
        operation(C_ENQ,1,4);

        -- DEQ
        operation(C_DEQ,0,0);
        operation(C_DEQ,0,0);
        operation(C_DEQ,0,0);

        -- DEQ-ALL
        operation(C_DEQALL,1,0);

        -- DEQ-ALL
        operation(C_DEQALL,0,0);

      wait;
   end process;

END;
