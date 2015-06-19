------------------------------------------------------------------------------
-- add_sub_core - entity/architecture pair
------------------------------------------------------------------------------
--
-- ***************************************************************************
-- ** Copyright (c) 1995-2010 Xilinx, Inc.  All rights reserved.            **
-- **                                                                       **
-- ** Xilinx, Inc.                                                          **
-- ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"         **
-- ** AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND       **
-- ** SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,        **
-- ** OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,        **
-- ** APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION           **
-- ** THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,     **
-- ** AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE      **
-- ** FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY              **
-- ** WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE               **
-- ** IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR        **
-- ** REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF       **
-- ** INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       **
-- ** FOR A PARTICULAR PURPOSE.                                             **
-- **                                                                       **
-- ***************************************************************************
--
------------------------------------------------------------------------------
-- Filename:          add_sub_core
-- Version:           1.00.a
-- Description:       Example FSL core (VHDL).
-- Date:              Thu Aug  9 10:06:10 2012 (by Create and Import Peripheral Wizard)
-- VHDL Standard:     VHDL'93
------------------------------------------------------------------------------
-- Naming Conventions:
--   active low signals:                    "*_n"
--   clock signals:                         "clk", "clk_div#", "clk_#x"
--   reset signals:                         "rst", "rst_n"
--   generics:                              "C_*"
--   user defined types:                    "*_TYPE"
--   state machine next state:              "*_ns"
--   state machine current state:           "*_cs"
--   combinatorial signals:                 "*_com"
--   pipelined or register delay signals:   "*_d#"
--   counter signals:                       "*cnt*"
--   clock enable signals:                  "*_ce"
--   internal version of output port:       "*_i"
--   device pins:                           "*_pin"
--   ports:                                 "- Names begin with Uppercase"
--   processes:                             "*_PROCESS"
--   component instantiations:              "<ENTITY_>I_<#|FUNC>"
------------------------------------------------------------------------------

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

entity hw_thcrc is
	port 
	(


		    Tintrfc2thrd_value : out std_logic_vector(0 to 31);
		    Tintrfc2thrd_function : out std_logic_vector(0 to 15);
		    Tintrfc2thrd_goWait : out std_logic;

		    Tthrd2intrfc_address : out std_logic_vector(0 to 31);
		    Tthrd2intrfc_value : out std_logic_vector(0 to 31);
		    Tthrd2intrfc_function : out std_logic_vector(0 to 15);
		    Tthrd2intrfc_opcode : out std_logic_vector(0 to 5);
                    Ttimer      : out  std_logic_vector( 0 to 31);

		-- DO NOT EDIT BELOW THIS LINE ---------------------
		-- Bus protocol ports, do not add or delete. 
		FSL_Clk	        : in	std_logic;
				
		FSL0_S_Read	: out	std_logic;
		FSL0_S_Data	: in	std_logic_vector(0 to 31);		
		FSL0_S_Exists	: in	std_logic;

                FSL1_S_Read	: out	std_logic;
		FSL1_S_Data	: in	std_logic_vector(0 to 31);		
		FSL1_S_Exists	: in	std_logic;
  
	        ------------------------------------------------------	
		FSL0_M_Write	: out	std_logic;
		FSL0_M_Data	: out	std_logic_vector(0 to 31);		
		FSL0_M_Full	: in	std_logic;

		FSL1_M_Write	: out	std_logic;
		FSL1_M_Data	: out	std_logic_vector(0 to 31);		
		FSL1_M_Full	: in	std_logic;

		FSL2_M_Write	: out	std_logic;
		FSL2_M_Data	: out	std_logic_vector(0 to 31);		
		FSL2_M_Full	: in	std_logic

	
		
		
		
		-- DO NOT EDIT ABOVE THIS LINE ---------------------
	);

attribute SIGIS : string; 
attribute SIGIS of FSL_Clk : signal is "Clk"; 

 

end hw_thcrc;

-- *************************
-- Architecture Definition
-- *************************
architecture IMPLEMENTATION of hw_thcrc is

component user_logic_hwtul is
  port (
    clock       : in std_logic;
    intrfc2thrd : in std_logic_vector(0 to 63);
    thrd2intrfc : out std_logic_vector( 0 to 95);
    rd          : out std_logic;
    wr          : out std_logic;
    exist       : in  std_logic ;
    full        : in  std_logic ;
    Ttimer      : out  std_logic_vector( 0 to 31)    
   
  );
end component user_logic_hwtul;

    signal  intrfc2thrd :  std_logic_vector(0 to 63);
    signal  thrd2intrfc :  std_logic_vector( 0 to 95);
    signal  rd          :  std_logic;
    signal  wr          :  std_logic;
    signal  exist       :   std_logic;
    signal  full        :   std_logic;   
    signal  timer      :   std_logic_vector( 0 to 31) ;



-- Architecture Section
begin

   Tintrfc2thrd_value    <= intrfc2thrd(0 to 31)  ;
   Tintrfc2thrd_function <= intrfc2thrd (32 to 47);
   Tintrfc2thrd_goWait   <= exist ;

   Tthrd2intrfc_address  <= thrd2intrfc (32 to 63);
   Tthrd2intrfc_value    <= thrd2intrfc  (0 to 31) ; 
   Tthrd2intrfc_function <= thrd2intrfc (64 to 79);  
   Tthrd2intrfc_opcode   <= thrd2intrfc (80 to 85);
   Ttimer                <= timer;  



   intrfc2thrd <= FSL0_S_Data & FSL1_S_Data;
   FSL0_M_Data <= thrd2intrfc(0 to 31); 
   FSL1_M_Data <= thrd2intrfc(32 to 63);
   FSL2_M_Data <= thrd2intrfc(64 to 95);

 --======================================================= 

   full  <= FSL0_M_Full or FSL1_M_Full or FSL2_M_Full;
   exist <= FSL0_S_Exists and FSL1_S_Exists ;

 --======================================================= 
  FSL0_S_Read <=  rd;
  FSL1_S_Read <=  rd;

  FSL0_M_Write  <= wr;
  FSL1_M_Write  <= wr;
  FSL2_M_Write  <= wr;

 


USER_LOGIC_HWTUL_I : user_logic_hwtul
  port map
  (
      clock                          => FSL_Clk,
      intrfc2thrd		     => intrfc2thrd,
      thrd2intrfc 		     => thrd2intrfc,
      rd          		     => rd,
      wr          		     => wr,
      exist      		     => exist,
      full                           => full,
      Ttimer                         => timer

  );


end architecture implementation;
