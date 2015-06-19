

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-------------------------------------------------------------------------------------
--
--
-- Definition of Ports
-- FSL_Clk             : Synchronous clock
-- FSL_Rst           : System reset, should always come from FSL bus
-- FSL_S_Clk       : Slave asynchronous clock
-- FSL_S_Read      : Read signal, requiring next available input to be read
-- FSL_S_Data      : Input data
-- FSL_S_CONTROL   : Control Bit, indicating the input data are control word
-- FSL_S_Exists    : Data Exist Bit, indicating data exist in the input FSL bus
-- FSL_M_Clk       : Master asynchronous clock
-- FSL_M_Write     : Write signal, enabling writing to output FSL bus
-- FSL_M_Data      : Output data
-- FSL_M_Control   : Control Bit, indicating the output data are contol word
-- FSL_M_Full      : Full Bit, indicating output FSL bus is full
--
-------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Entity Section
------------------------------------------------------------------------------

entity hw_acc_mergesort is
	port 
	(
		-- DO NOT EDIT BELOW THIS LINE ---------------------
		-- Bus protocol ports, do not add or delete. 
		Clk	        : in	std_logic;
		RST             : in    std_logic;
		
		BRAM_A_addr : out std_logic_vector(0 to (32 - 1));
		BRAM_A_dIN  : in std_logic_vector(0 to (32 - 1));
		BRAM_A_dOUT : out std_logic_vector(0 to (32 - 1));
		BRAM_A_en : out std_logic;
		BRAM_A_wEN : out std_logic_vector(0 to (32/8) -1);

	        ------------------------------------------------------	
		BRAM_B_dIN	: in	std_logic_vector(0 to (32 - 1))	;
		BRAM_B_addr	: out	std_logic_vector(0 to (32 - 1))	;
		BRAM_B_dOUT	: out	std_logic_vector(0 to (32 - 1))	;
		BRAM_B_en	: out	std_logic			;
		BRAM_B_wEN	: out	std_logic_vector(0 to (32/8) -1);

		BRAM_C_dIN	: in	std_logic_vector(0 to (32 - 1))	;
		BRAM_C_addr	: out	std_logic_vector(0 to (32 - 1))	;
		BRAM_C_dOUT	: out	std_logic_vector(0 to (32 - 1))	;
		BRAM_C_en	: out	std_logic			;
		BRAM_C_wEN	: out	std_logic_vector(0 to (32/8) -1);
	        ------------------------------------------------------					
		FSL0_S_Read	: out	std_logic;
		FSL0_S_Data	: in	std_logic_vector(0 to 31);		
		FSL0_S_Exists	: in	std_logic;               
  
	      ------------------------------------------------------	
		FSL0_M_Write	: out	std_logic;
		FSL0_M_Data	: out	std_logic_vector(0 to 31);		
		FSL0_M_Full	: in	std_logic;
		
		--This is just used for reseting
		FSL1_S_Read	: out	std_logic;
		FSL1_S_Data	: in	std_logic_vector(0 to 31);		
		FSL1_S_Exists	: in	std_logic
		-- DO NOT EDIT ABOVE THIS LINE ---------------------
	);

end hw_acc_mergesort;

-- *************************
-- Architecture Definition
-- *************************
architecture IMPLEMENTATION of hw_acc_mergesort is

component mergesort is
port
(
   array0_addr0 : out std_logic_vector(0 to (32 - 1));
  array0_dIN0 : out std_logic_vector(0 to (32 - 1));
  array0_dOUT0 : in std_logic_vector(0 to (32 - 1));
  array0_rENA0 : out std_logic;
  array0_wENA0 :  out std_logic;
  array1_addr0 : out std_logic_vector(0 to (32 - 1));
  array1_dIN0 : out std_logic_vector(0 to (32 - 1));
  array1_dOUT0 : in std_logic_vector(0 to (32 - 1));
  array1_rENA0 : out std_logic;
  array1_wENA0 :  out std_logic;

  chan1_channelDataIn : out std_logic_vector(0 to (32 - 1));
  chan1_channelDataOut : in std_logic_vector(0 to (32 - 1));
  chan1_exists : in std_logic;
  chan1_full : in std_logic;
  chan1_channelRead : out std_logic;
  chan1_channelWrite : out std_logic;


  clock_sig : in std_logic;
  reset_sig : in std_logic
  );
end component;


	signal reset_sig : std_logic;
	signal in_BRAM_A_addr :  std_logic_vector(0 to (32 - 1));
	signal  in_BRAM_A_wEN :  std_logic;
	signal  in_BRAM_B_addr :  std_logic_vector(0 to (32 - 1));
	signal  in_BRAM_B_wEN :  std_logic;
	signal  in_BRAM_C_addr :  std_logic_vector(0 to (32 - 1));
	signal  in_BRAM_C_wEN :  std_logic;
-- Architecture Section
begin    

	reset_sig  <= rst or FSL1_S_Exists;
	FSL1_S_read <= FSL1_S_Exists ;

	BRAM_A_addr  <= in_BRAM_A_addr(2 to 31) & "00"; --The external memory is organized in this way.
	BRAM_A_wEN   <= in_BRAM_A_WEN&in_BRAM_A_WEN&in_BRAM_A_WEN&in_BRAM_A_WEN;


	BRAM_B_addr  <= in_BRAM_B_addr(2 to 31) & "00"; --The external memory is organized in this way.
	BRAM_B_wEN   <= in_BRAM_B_WEN&in_BRAM_B_WEN&in_BRAM_B_WEN&in_BRAM_B_WEN;


	BRAM_C_addr  <= in_BRAM_C_addr(2 to 31) & "00"; --The external memory is organized in this way.
	BRAM_C_wEN   <= in_BRAM_C_WEN&in_BRAM_C_WEN&in_BRAM_C_WEN&in_BRAM_C_WEN;






	
uut : mergesort
port map (

  array0_addr0 => in_BRAM_A_addr,
  array0_dIN0  => BRAM_A_dout, 
  array0_dOUT0 => BRAM_A_din,
  array0_rENA0 => BRAM_A_en,
  array0_wENA0 => in_BRAM_A_wen,

  array1_addr0 => in_BRAM_B_addr,
  array1_dIN0  => BRAM_B_dout, 
  array1_dOUT0 => BRAM_B_din,
  array1_rENA0 => BRAM_B_en,
  array1_wENA0 => in_BRAM_B_wen,

  chan1_channelDataIn => FSL0_M_Data,
  chan1_channelDataOut => FSL0_S_Data,
  chan1_exists => FSL0_S_Exists,
  chan1_full => FSL0_M_Full,
  chan1_channelRead => FSL0_S_Read,
  chan1_channelWrite => FSL0_M_Write,


  clock_sig => clk,
  reset_sig => reset_sig
);


end architecture implementation;
