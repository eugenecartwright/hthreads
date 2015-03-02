----------------------------------------------------------------------------------
-- Written by Jason Agron
-- Summer '07
-- ******************************
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:25:12 12/22/2006 
-- Design Name: 
-- Module Name:    hvm_core - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISPM;
--use UNISPM.VComponents.all;

library hvm_core_v1_00_a;
use hvm_core_v1_00_a.all;

entity hvm_core is
port(
	clk : in std_logic;
	reset : in std_logic;
    go : IN std_logic;
    done : OUT std_logic;
	mode : IN std_logic_vector(0 to 1);
    debug_address : out std_logic_vector(0 to 31);
    debug_data : out std_logic_vector(0 to 31);

	BRAM_Clk_PM : out std_logic;
	BRAM_EN_PM	: out std_logic;
	BRAM_WE_PM	: out std_logic_vector(0 to 3);
	BRAM_Addr_PM	: out std_logic_vector(0 to 31);
	BRAM_Din_PM	: in std_logic_vector(0 to 31);
	BRAM_Dout_PM	: out std_logic_vector(0 to 31);

	BRAM_Clk_SM : out std_logic;
	BRAM_EN_SM	: out std_logic;
	BRAM_WE_SM	: out std_logic_vector(0 to 3);
	BRAM_Addr_SM	: out std_logic_vector(0 to 31);
	BRAM_Din_SM	: in std_logic_vector(0 to 31);
	BRAM_Dout_SM	: out std_logic_vector(0 to 31)
);
end hvm_core;

architecture Behavioral of hvm_core is

	COMPONENT interp
	PORT(
		prog_mem_dOUT0 : IN std_logic_vector(0 to 31);
		state_mem_dOUT0 : IN std_logic_vector(0 to 31);
		go : IN std_logic;
		mode : IN std_logic_vector(0 to 1);
		done : out std_logic;
		clock_sig : IN std_logic;
		reset_sig : IN std_logic;          
		prog_mem_addr0 : OUT std_logic_vector(0 to 31);
		prog_mem_dIN0 : OUT std_logic_vector(0 to 31);
		prog_mem_rENA0 : OUT std_logic;
		prog_mem_wENA0 : OUT std_logic;
		state_mem_addr0 : OUT std_logic_vector(0 to 7);
		state_mem_dIN0 : OUT std_logic_vector(0 to 31);
		state_mem_rENA0 : OUT std_logic;
		state_mem_wENA0 : OUT std_logic
		);
	END COMPONENT;

	SIGNAL prog_mem_dOUT0 :  std_logic_vector(0 to 31);
	SIGNAL state_mem_dOUT0 :  std_logic_vector(0 to 31);
	SIGNAL prog_mem_addr0 :  std_logic_vector(0 to 31);
	SIGNAL prog_mem_dIN0 :  std_logic_vector(0 to 31);
	SIGNAL prog_mem_rENA0 :  std_logic;
	SIGNAL prog_mem_wENA0 :  std_logic;
	SIGNAL state_mem_addr0 :  std_logic_vector(0 to 7);
	SIGNAL state_mem_dIN0 :  std_logic_vector(0 to 31);
	SIGNAL state_mem_rENA0 :  std_logic;
	SIGNAL state_mem_wENA0 :  std_logic;

begin
	-- Instantiate the Unit Under Test (UUT)
	uut: interp PORT MAP(
		prog_mem_addr0 => prog_mem_addr0,
		prog_mem_dIN0 => prog_mem_dIN0,
		prog_mem_dOUT0 => prog_mem_dOUT0,
		prog_mem_rENA0 => prog_mem_rENA0,
		prog_mem_wENA0 => prog_mem_wENA0,
		state_mem_addr0 => state_mem_addr0,
		state_mem_dIN0 => state_mem_dIN0,
		state_mem_dOUT0 => state_mem_dOUT0,
		state_mem_rENA0 => state_mem_rENA0,
		state_mem_wENA0 => state_mem_wENA0,
		go => go,
		done => done,
		mode => mode,
		clock_sig => clk,
		reset_sig => reset
	);

-- Old method (before done was internal to the interpreter)
--    done <= '1' when prog_mem_addr0 = x"FFFFFFFF" else '0';

-- Hook up debug interface
    debug_address   <= prog_mem_addr0;
    debug_data      <= prog_mem_dOUT0;
	
-- Connect up PM BRAM interface
	BRAM_Clk_PM <= clk;
	BRAM_EN_PM <= prog_mem_rENA0;
	BRAM_WE_PM <= prog_mem_wENA0 & prog_mem_wENA0 & prog_mem_wENA0 & prog_mem_wENA0;
	BRAM_Addr_PM <= prog_mem_addr0;
	prog_mem_dOUT0 <= BRAM_Din_PM;
	BRAM_Dout_PM <= prog_mem_dIN0;

-- Connect up SM BRAM interface
	BRAM_Clk_SM <= clk;
	BRAM_EN_SM <= state_mem_rENA0;
	BRAM_WE_SM <= state_mem_wENA0 & state_mem_wENA0 & state_mem_wENA0 & state_mem_wENA0;
	BRAM_Addr_SM <= x"00000" & "00" & state_mem_addr0 & "00";   -- Make addresses word addressable
	state_mem_dOUT0 <= BRAM_Din_SM;
	BRAM_Dout_SM <= state_mem_dIN0;

end Behavioral;

