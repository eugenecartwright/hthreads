--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:59:18 06/17/2009
-- Design Name:   
-- Module Name:   /home/jagron/uark_research/uark_ht_trunk/src/hardware/MyRepository/pcores/plb_cond_vars_v1_00_a/hdl/vhdl//user_logic_tb.vhd
-- Project Name:  ise_proj
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: user_logic
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
 
ENTITY user_logic_tb IS
END user_logic_tb;
 
ARCHITECTURE behavior OF user_logic_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT user_logic
    PORT(
         Soft_Reset : IN  std_logic;
         Reset_Done : OUT  std_logic;
         Bus2IP_Clk : IN  std_logic;
         Bus2IP_Reset : IN  std_logic;
         Bus2IP_Addr : IN  std_logic_vector(0 to 31);
         Bus2IP_Data : IN  std_logic_vector(0 to 31);
         Bus2IP_BE : IN  std_logic_vector(0 to 3);
         Bus2IP_RdCE : IN  std_logic_vector(0 to 4);
         Bus2IP_WrCE : IN  std_logic_vector(0 to 4);
         IP2Bus_Data : OUT  std_logic_vector(0 to 31);
         IP2Bus_RdAck : OUT  std_logic;
         IP2Bus_WrAck : OUT  std_logic;
         IP2Bus_Error : OUT  std_logic;
         IP2Bus_MstRd_Req : OUT  std_logic;
         IP2Bus_MstWr_Req : OUT  std_logic;
         IP2Bus_Mst_Addr : OUT  std_logic_vector(0 to 31);
         IP2Bus_Mst_BE : OUT  std_logic_vector(0 to 3);
         IP2Bus_Mst_Lock : OUT  std_logic;
         IP2Bus_Mst_Reset : OUT  std_logic;
         Bus2IP_Mst_CmdAck : IN  std_logic;
         Bus2IP_Mst_Cmplt : IN  std_logic;
         Bus2IP_Mst_Error : IN  std_logic;
         Bus2IP_Mst_Rearbitrate : IN  std_logic;
         Bus2IP_Mst_Cmd_Timeout : IN  std_logic;
         Bus2IP_MstRd_d : IN  std_logic_vector(0 to 31);
         Bus2IP_MstRd_src_rdy_n : IN  std_logic;
         IP2Bus_MstWr_d : OUT  std_logic_vector(0 to 31);
         Bus2IP_MstWr_dst_rdy_n : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Soft_Reset : std_logic := '0';
   signal Bus2IP_Clk : std_logic := '0';
   signal Bus2IP_Reset : std_logic := '0';
   signal Bus2IP_Addr : std_logic_vector(0 to 31) := (others => '0');
   signal Bus2IP_Data : std_logic_vector(0 to 31) := (others => '0');
   signal Bus2IP_BE : std_logic_vector(0 to 3) := (others => '0');
   signal Bus2IP_RdCE : std_logic_vector(0 to 4) := (others => '0');
   signal Bus2IP_WrCE : std_logic_vector(0 to 4) := (others => '0');
   signal Bus2IP_Mst_CmdAck : std_logic := '0';
   signal Bus2IP_Mst_Cmplt : std_logic := '0';
   signal Bus2IP_Mst_Error : std_logic := '0';
   signal Bus2IP_Mst_Rearbitrate : std_logic := '0';
   signal Bus2IP_Mst_Cmd_Timeout : std_logic := '0';
   signal Bus2IP_MstRd_d : std_logic_vector(0 to 31) := (others => '0');
   signal Bus2IP_MstRd_src_rdy_n : std_logic := '0';
   signal Bus2IP_MstWr_dst_rdy_n : std_logic := '0';

 	--Outputs
   signal Reset_Done : std_logic;
   signal IP2Bus_Data : std_logic_vector(0 to 31);
   signal IP2Bus_RdAck : std_logic;
   signal IP2Bus_WrAck : std_logic;
   signal IP2Bus_Error : std_logic;
   signal IP2Bus_MstRd_Req : std_logic;
   signal IP2Bus_MstWr_Req : std_logic;
   signal IP2Bus_Mst_Addr : std_logic_vector(0 to 31);
   signal IP2Bus_Mst_BE : std_logic_vector(0 to 3);
   signal IP2Bus_Mst_Lock : std_logic;
   signal IP2Bus_Mst_Reset : std_logic;
   signal IP2Bus_MstWr_d : std_logic_vector(0 to 31);

   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: user_logic PORT MAP (
          Soft_Reset => Soft_Reset,
          Reset_Done => Reset_Done,
          Bus2IP_Clk => Bus2IP_Clk,
          Bus2IP_Reset => Bus2IP_Reset,
          Bus2IP_Addr => Bus2IP_Addr,
          Bus2IP_Data => Bus2IP_Data,
          Bus2IP_BE => Bus2IP_BE,
          Bus2IP_RdCE => Bus2IP_RdCE,
          Bus2IP_WrCE => Bus2IP_WrCE,
          IP2Bus_Data => IP2Bus_Data,
          IP2Bus_RdAck => IP2Bus_RdAck,
          IP2Bus_WrAck => IP2Bus_WrAck,
          IP2Bus_Error => IP2Bus_Error,
          IP2Bus_MstRd_Req => IP2Bus_MstRd_Req,
          IP2Bus_MstWr_Req => IP2Bus_MstWr_Req,
          IP2Bus_Mst_Addr => IP2Bus_Mst_Addr,
          IP2Bus_Mst_BE => IP2Bus_Mst_BE,
          IP2Bus_Mst_Lock => IP2Bus_Mst_Lock,
          IP2Bus_Mst_Reset => IP2Bus_Mst_Reset,
          Bus2IP_Mst_CmdAck => Bus2IP_Mst_CmdAck,
          Bus2IP_Mst_Cmplt => Bus2IP_Mst_Cmplt,
          Bus2IP_Mst_Error => Bus2IP_Mst_Error,
          Bus2IP_Mst_Rearbitrate => Bus2IP_Mst_Rearbitrate,
          Bus2IP_Mst_Cmd_Timeout => Bus2IP_Mst_Cmd_Timeout,
          Bus2IP_MstRd_d => Bus2IP_MstRd_d,
          Bus2IP_MstRd_src_rdy_n => Bus2IP_MstRd_src_rdy_n,
          IP2Bus_MstWr_d => IP2Bus_MstWr_d,
          Bus2IP_MstWr_dst_rdy_n => Bus2IP_MstWr_dst_rdy_n
        );
 

	
   Bus2IP_Clk_process :process
   begin
		Bus2IP_Clk <= '0';
		wait for clock_period/2;
		Bus2IP_Clk <= '1';
		wait for clock_period/2;
   end process;
 
	ACK_proc : process 
	begin
		wait until IP2Bus_MstRd_Req = '1';
		Bus2IP_Mst_Cmplt	<= '1';
		Bus2IP_Mst_CmdAck	<= '1';
		wait until IP2Bus_MstRd_Req = '0';
		Bus2IP_Mst_Cmplt	<= '0';
		Bus2IP_Mst_CmdAck	<= '0';
		wait for 5*clock_period;	
	end process;

   -- Stimulus process
   stim_proc: process
   begin		
      wait for clock_period*10;
      
		-- Reset the core
		Soft_Reset <= '1';
		wait until Reset_Done = '1';
		wait for clock_period*5;
		Soft_Reset <= '0';
		wait for 5*clock_period;
		
		-- Perform an ENQ
		Bus2IP_Addr	<= x"11140100";
		Bus2IP_RdCE	<= (others => '1');
		wait until IP2Bus_RdAck = '1';
		Bus2IP_Addr	<= (others => '0');
		Bus2IP_RdCE	<= (others => '0');
		wait for 10*clock_period;

		-- Perform an ENQ
		Bus2IP_Addr	<= x"11140300";
		Bus2IP_RdCE	<= (others => '1');
		wait until IP2Bus_RdAck = '1';
		Bus2IP_Addr	<= (others => '0');
		Bus2IP_RdCE	<= (others => '0');
		wait for 10*clock_period;
		
		-- Perform a DEQ-ALL
		Bus2IP_Addr	<= x"11160000";
		Bus2IP_RdCE	<= (others => '1');
		wait until IP2Bus_RdAck = '1';
		Bus2IP_Addr	<= (others => '0');
		Bus2IP_RdCE	<= (others => '0');
		wait for 10*clock_period;
		

      wait;
   end process;

END;
