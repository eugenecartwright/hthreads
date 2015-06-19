

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

entity hw_acc_vector is
	port 
	(
		--chipscope_icon_control : in	std_logic_vector(35 downto 0);
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

end hw_acc_vector;

-- *************************
-- Architecture Definition
-- *************************
architecture IMPLEMENTATION of hw_acc_vector is

component vector_chan is
generic(
  G_ADDR_WIDTH : integer := 32;
  G_DATA_WIDTH : integer := 32
);
port
(
  Vector_A_addr0 : out std_logic_vector(0 to (G_ADDR_WIDTH - 1));
  Vector_A_dIN0 : out std_logic_vector(0 to (G_DATA_WIDTH - 1));
  Vector_A_dOUT0 : in std_logic_vector(0 to (G_DATA_WIDTH - 1));
  Vector_A_rENA0 : out std_logic;
  Vector_A_wENA0 : out std_logic_vector(0 to (G_DATA_WIDTH/8) -1);
  Vector_B_addr0 : out std_logic_vector(0 to (G_ADDR_WIDTH - 1));
  Vector_B_dIN0 : out std_logic_vector(0 to (G_DATA_WIDTH - 1));
  Vector_B_dOUT0 : in std_logic_vector(0 to (G_DATA_WIDTH - 1));
  Vector_B_rENA0 : out std_logic;
  Vector_B_wENA0 : out std_logic_vector(0 to (G_DATA_WIDTH/8) -1);
  Vector_C_addr0 : out std_logic_vector(0 to (G_ADDR_WIDTH - 1));
  Vector_C_dIN0 : out std_logic_vector(0 to (G_DATA_WIDTH - 1));
  Vector_C_dOUT0 : in std_logic_vector(0 to (G_DATA_WIDTH - 1));
  Vector_C_rENA0 : out std_logic;
  Vector_C_wENA0 : out std_logic_vector(0 to (G_DATA_WIDTH/8) -1);

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

component chipscope_ila
  PORT (
    CONTROL : in STD_LOGIC_VECTOR(35 DOWNTO 0);
    CLK : IN STD_LOGIC;
    TRIG0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    TRIG1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    TRIG2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    TRIG3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    TRIG4 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    TRIG5 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    TRIG6 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    TRIG7 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    TRIG8 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    TRIG9 : IN STD_LOGIC_VECTOR(0 TO 0);
    TRIG10 : IN STD_LOGIC_VECTOR(0 TO 0);
    TRIG11 : IN STD_LOGIC_VECTOR(0 TO 0);
    TRIG12 : IN STD_LOGIC_VECTOR(0 TO 0);
    TRIG13 : IN STD_LOGIC_VECTOR(0 TO 0);
    TRIG14 : IN STD_LOGIC_VECTOR(0 TO 0);
    TRIG15 : IN STD_LOGIC_VECTOR(0 TO 0));

end component;

component chipscope_icon
  PORT (
    CONTROL0 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0));
end component;
   

	signal CONTROL0 :  STD_LOGIC_VECTOR(35 DOWNTO 0);

	signal	sBRAM_A_addr	:	std_logic_vector(0 to (32 - 1))	;
	signal	sBRAM_A_dIN	:	std_logic_vector(0 to (32 - 1))	;
	signal	sBRAM_A_dOUT	:	std_logic_vector(0 to (32 - 1))	;
	signal	sBRAM_A_en	:	std_logic_vector(0 to 0)	;
	signal	sBRAM_A_wEN	:	std_logic_vector(0 to (32/8) -1);

	signal	sBRAM_B_addr	:	std_logic_vector(0 to (32 - 1))	;
	signal	sBRAM_B_dIN	:	std_logic_vector(0 to (32 - 1))	;
	signal	sBRAM_B_dOUT	:	std_logic_vector(0 to (32 - 1))	;
	signal	sBRAM_B_en	:	std_logic_vector(0 to 0)	;
	signal	sBRAM_B_wEN	:	std_logic_vector(0 to (32/8) -1);

	signal	sBRAM_C_addr	:	std_logic_vector(0 to (32 - 1))	;
	signal	sBRAM_C_dIN	:	std_logic_vector(0 to (32 - 1))	;
	signal	sBRAM_C_dOUT	:	std_logic_vector(0 to (32 - 1))	;
	signal	sBRAM_C_en	:	std_logic_vector(0 to 0)	;
	signal	sBRAM_C_wEN	:	std_logic_vector(0 to (32/8) -1);
				
	signal	sFSL0_S_Read	: 	std_logic_vector(0 to 0);	
	signal	sFSL0_S_Data	: 	std_logic_vector(0 to 31);		
	signal	sFSL0_S_Exists	: 	std_logic_vector(0 to 0);	             
  
	        ------------------------------------------------------	
	signal	sFSL0_M_Write	: 	std_logic_vector(0 to 0);	
	signal	sFSL0_M_Data	: 	std_logic_vector(0 to 31);		
	signal	sFSL0_M_Full	:	std_logic_vector(0 to 0);	


  signal reset_sig : std_logic;
  
-- Architecture Section
begin    

	reset_sig  <= rst or FSL1_S_Exists;
	FSL1_S_read <= FSL1_S_Exists ; 

	sBRAM_A_dIN  <= BRAM_A_din; 
	BRAM_A_addr  <= sBRAM_A_addr;
	BRAM_A_dOUT  <= sBRAM_A_dout;
	BRAM_A_en    <= sBRAM_A_en(0);
	BRAM_A_wEN   <= sBRAM_A_wen; 
	
	sBRAM_B_dIN	<=	BRAM_B_din	;
	BRAM_B_addr	<=	sBRAM_B_addr	;
	BRAM_B_dOUT	<=	sBRAM_B_dout	;
	BRAM_B_en	<=	sBRAM_B_en(0)	;
	BRAM_B_wEN	<=	sBRAM_B_wen	;

	sBRAM_C_dIN	<=	BRAM_C_din	;
	BRAM_C_addr	<=	sBRAM_C_addr	;
	BRAM_C_dOUT	<=	sBRAM_C_dout	;
	BRAM_C_en	<=	sBRAM_C_en(0)	;
	BRAM_C_wEN	<=	sBRAM_C_wen	;

	FSL0_S_Read<= sFSL0_S_Read(0);
	sFSL0_S_Data<= FSL0_S_data;	
	sFSL0_S_Exists(0)	<= FSL0_S_exists;           

	------------------------------------------------------	
	FSL0_M_Write	<= sFSL0_M_Write(0);
	FSL0_M_Data	<= sFSL0_M_data;
	sFSL0_M_Full(0)	<= FSL0_M_full;



--icon_uut : chipscope_icon
--  port map (
 --   CONTROL0 => CONTROL0);
    
 --   ila_uut : chipscope_ila
 -- port map (
 --   CONTROL => chipscope_icon_control,
--    CLK => clk,
--    TRIG0 => sBRAM_C_addr,
--    TRIG1 => sBRAM_C_din,
   -- TRIG2 => sBRAM_C_dout,
   --  TRIG3 => sFSL0_M_Data,
   --  TRIG4 => sFSL0_S_Data,
   --  TRIG5 => X"0000" ,
   --  TRIG6 => X"00" ,
   --  TRIG7 => X"0",
   --  TRIG8 => sBRAM_c_wen,
   --  TRIG9 => sBRAM_C_en(0 to 0),
   --  TRIG10 => sFSL0_S_Exists(0 to 0),
   --  TRIG11 => sFSL0_S_Read(0 to 0),
   --  TRIG12 => sFSL0_M_Write(0 to 0),
   --  TRIG13 => sFSL0_M_Write(0 to 0),
   --  TRIG14 => sFSL0_M_Write(0 to 0),
   --  TRIG15 => sFSL0_M_Write(0 to 0));

uut : vector_chan
port map (

	Vector_A_addr0 => sBRAM_A_addr,
	Vector_A_dIN0  => sBRAM_A_dout, 
	Vector_A_dOUT0 => sBRAM_A_din,
	Vector_A_rENA0 => sBRAM_A_en(0),
	Vector_A_wENA0 => sBRAM_A_wen,

	Vector_B_addr0 => sBRAM_B_addr,
	Vector_B_dIN0  => sBRAM_B_dout, 
	Vector_B_dOUT0 => sBRAM_B_din,
	Vector_B_rENA0 => sBRAM_B_en(0),
	Vector_B_wENA0 => sBRAM_B_wen,

	Vector_C_addr0 => sBRAM_C_addr,
	Vector_C_dIN0  => sBRAM_C_dout, 
	Vector_C_dOUT0 => sBRAM_C_din,
	Vector_C_rENA0 => sBRAM_C_en(0),
	Vector_C_wENA0 => sBRAM_C_wen,

  chan1_channelDataIn => sFSL0_M_Data,
  chan1_channelDataOut => sFSL0_S_Data,
  chan1_exists => sFSL0_S_Exists(0),
  chan1_full => sFSL0_M_Full(0),
  chan1_channelRead => sFSL0_S_Read(0),
  chan1_channelWrite => sFSL0_M_Write(0),


  clock_sig => clk,
  reset_sig => reset_sig
);


end architecture implementation;
