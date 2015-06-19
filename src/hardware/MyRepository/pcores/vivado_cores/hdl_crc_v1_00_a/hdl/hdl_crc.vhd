

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

    

entity hdl_crc is
	port 
	(
		-- DO NOT EDIT BELOW THIS LINE ---------------------
		-- Bus protocol ports, do not add or delete. 
	 ap_clk : IN STD_LOGIC;
    ap_rst_n : IN STD_LOGIC;
    
    S_AXIS_TDATA : IN STD_LOGIC_VECTOR (31 downto 0);
    S_AXIS_TVALID : IN STD_LOGIC;
    S_AXIS_TREADY : OUT STD_LOGIC;
    
    M_AXIS_TDATA : OUT STD_LOGIC_VECTOR (31 downto 0);
    M_AXIS_TVALID : OUT STD_LOGIC;
    M_AXIS_TREADY : IN STD_LOGIC;
    
      BRAM_A_addr : out std_logic_vector(0 to (32 - 1));
		BRAM_A_dIN  : out std_logic_vector(0 to (32 - 1));
		BRAM_A_dOUT : in std_logic_vector(0 to (32 - 1));
		BRAM_A_en : out std_logic;
		BRAM_A_wEN : out std_logic_vector(0 to (32/8) -1);

	        ------------------------------------------------------	
		BRAM_B_dIN	: out	std_logic_vector(0 to (32 - 1))	;
		BRAM_B_addr	: out	std_logic_vector(0 to (32 - 1))	;
		BRAM_B_dOUT	: in	std_logic_vector(0 to (32 - 1))	;
		BRAM_B_en	: out	std_logic			;
		BRAM_B_wEN	: out	std_logic_vector(0 to (32/8) -1);

		BRAM_C_dIN	: out	std_logic_vector(0 to (32 - 1))	;
		BRAM_C_addr	: out	std_logic_vector(0 to (32 - 1))	;
		BRAM_C_dOUT	: in	std_logic_vector(0 to (32 - 1))	;
		BRAM_C_en	: out	std_logic			;
		BRAM_C_wEN	: out	std_logic_vector(0 to (32/8) -1)
		-- DO NOT EDIT ABOVE THIS LINE ---------------------
	
		
		-- DO NOT EDIT ABOVE THIS LINE ---------------------
	);


end hdl_crc;

-- *************************
-- Architecture Definition
-- *************************
architecture IMPLEMENTATION of hdl_crc is

component crc is
port
(
  array_addr0 : out std_logic_vector(0 to (32 - 1));
  array_dIN0 : out std_logic_vector(0 to (32- 1));
  array_dOUT0 : in std_logic_vector(0 to (32 - 1));
  array_rENA0 : out std_logic;
  array_wENA0 : out std_logic_vector(0 to (32/8) -1);

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

	
 signal ap_rst :  STD_LOGIC;
  
-- Architecture Section
begin    

ap_rst <= not ap_rst_n;

	
uut : crc
port map (

   
  array_addr0 => BRAM_A_addr,
  array_dIN0  => BRAM_A_din, 
  array_dOUT0 => BRAM_A_dout, 
  array_rENA0 => BRAM_A_en,
  array_wENA0 => BRAM_A_wen,

  chan1_channelDataIn => M_AXIS_TDATA,
  chan1_channelDataOut => S_AXIS_TDATA,
  chan1_exists => S_AXIS_Tvalid,
  chan1_full => not M_AXIS_Tready,
  chan1_channelRead => S_AXIS_Tready,
  chan1_channelWrite => M_AXIS_tvalid,


  clock_sig => ap_clk,
  reset_sig => ap_rst
);


end architecture implementation;
