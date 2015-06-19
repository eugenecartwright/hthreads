-------------------------------------------------------------------------------------
-- Copyright (c) 2015, University of Arkansas - Hybridthreads Group
-- All rights reserved.
-- 
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
-- 
--     * Redistributions of source code must retain the above copyright notice,
--       this list of conditions and the following disclaimer.
--     * Redistributions in binary form must reproduce the above copyright notice,
--       this list of conditions and the following disclaimer in the documentation
--       and/or other materials provided with the distribution.
--     * Neither the name of the University of Arkansas nor the name of the
--       Hybridthreads Group nor the names of its contributors may be used to
--       endorse or promote products derived from this software without specific
--       prior written permission.
-- 
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
-- ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-- (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
-- LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
-- ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-- (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-------------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- opb_hwti.vhd - entity/architecture pair
------------------------------------------------------------------------------
-- IMPORTANT:
-- DO NOT MODIFY THIS FILE EXCEPT IN THE DESIGNATED SECTIONS.
--
-- SEARCH FOR --USER TO DETERMINE WHERE CHANGES ARE ALLOWED.
--
-- TYPICALLY, THE ONLY ACCEPTABLE CHANGES INVOLVE ADDING NEW
-- PORTS AND GENERICS THAT GET PASSED THROUGH TO THE INSTANTIATION
-- OF THE USER_LOGIC ENTITY.
------------------------------------------------------------------------------
--
-- ***************************************************************************
-- ** Copyright (c) 1995-2005 Xilinx, Inc.  All rights reserved.            **
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
-- ** YOU MAY COPY AND MODIFY THESE FILES FOR YOUR OWN INTERNAL USE SOLELY  **
-- ** WITH XILINX PROGRAMMABLE LOGIC DEVICES AND XILINX EDK SYSTEM OR       **
-- ** CREATE IP MODULES SOLELY FOR XILINX PROGRAMMABLE LOGIC DEVICES AND    **
-- ** XILINX EDK SYSTEM. NO RIGHTS ARE GRANTED TO DISTRIBUTE ANY FILES      **
-- ** UNLESS THEY ARE DISTRIBUTED IN XILINX PROGRAMMABLE LOGIC DEVICES.     **
-- **                                                                       **
-- ***************************************************************************
--
------------------------------------------------------------------------------
-- Filename:          opb_hwti.vhd
-- Version:           2.00.a
-- Description:       Top level design, instantiates IPIF and user logic.
-- Date:              Mon Aug 15 10:20:24 2005 (by Create and Import Peripheral Wizard)
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
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library proc_common_v1_00_b;
use proc_common_v1_00_b.proc_common_pkg.all;

library ipif_common_v1_00_d;
use ipif_common_v1_00_d.ipif_pkg.all;
library opb_ipif_v2_00_h;
use opb_ipif_v2_00_h.all;

library fsl_v20_v2_11_c;
use fsl_v20_v2_11_c.all;

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_BASEADDR                   -- User logic base address
--   C_HIGHADDR                   -- User logic high address
--   C_OPB_AWIDTH                 -- OPB address bus width
--   C_OPB_DWIDTH                 -- OPB data bus width
--   C_FAMILY                     -- Target FPGA architecture
--
-- Definition of Ports:
--   OPB_Clk                      -- OPB Clock
--   OPB_Rst                      -- OPB Reset
--   Sl_DBus                      -- Slave data bus
--   Sl_errAck                    -- Slave error acknowledge
--   Sl_retry                     -- Slave retry
--   Sl_toutSup                   -- Slave timeout suppress
--   Sl_xferAck                   -- Slave transfer acknowledge
--   OPB_ABus                     -- OPB address bus
--   OPB_BE                       -- OPB byte enable
--   OPB_DBus                     -- OPB data bus
--   OPB_RNW                      -- OPB read/not write
--   OPB_select                   -- OPB select
--   OPB_seqAddr                  -- OPB sequential address
--   M_ABus                       -- Master address bus
--   M_BE                         -- Master byte enables
--   M_busLock                    -- Master buslock
--   M_request                    -- Master bus request
--   M_RNW                        -- Master read, not write
--   M_select                     -- Master select
--   M_seqAddr                    -- Master sequential address
--   OPB_errAck                   -- OPB error acknowledge
--   OPB_MGrant                   -- OPB bus grant
--   OPB_retry                    -- OPB bus cycle retry
--   OPB_timeout                  -- OPB timeout error
--   OPB_xferAck                  -- OPB transfer acknowledge
------------------------------------------------------------------------------

entity opb_hwti is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
    --USER generics added here
    C_NUM_THREADS : integer := 256;
    C_NUM_MUTEXES : integer := 64;
    C_THREAD_MANAGER_BADDR : std_logic_vector(0 to 31) := x"6000_0000";
    C_MUTEX_MANAGER_BADDR : std_logic_vector(0 to 31) := x"7500_0000";
    C_CONVAR_MANAGER_BADDR : std_logic_vector(0 to 31) := x"7600_0000";
    -- ADD USER GENERICS ABOVE THIS LINE ---------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_BASEADDR                     : std_logic_vector     := X"6300_0000";
    C_HIGHADDR                     : std_logic_vector     := X"6300_FFFF";
    C_OPB_AWIDTH                   : integer              := 32;
    C_OPB_DWIDTH                   : integer              := 32;
    C_FAMILY                       : string               := "virtex2p"
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------

      
    OPBintrfc2thrd_value : out std_logic_vector(0 to 31);
    OPBintrfc2thrd_function : out std_logic_vector(0 to 15);
    OPBintrfc2thrd_goWait : out std_logic;

    OPBthrd2intrfc_address : out std_logic_vector(0 to 31);
    OPBthrd2intrfc_value : out std_logic_vector(0 to 31);
    OPBthrd2intrfc_function : out std_logic_vector(0 to 15);
    OPBthrd2intrfc_opcode : out std_logic_vector(0 to 5);

    OPBM_ABus   : out std_logic_vector(0 to 31);
    OPBM_request :out std_logic;
    OPBM_MGrant  : out std_logic;
    OPBM_xferAck : out std_logic;
    OPBM_select  : out std_logic ;
   
    OPBtimer  : out std_logic_vector(0 to 31);




        FSL0_S_Read	: out	std_logic;
        FSL0_S_Data	: in	std_logic_vector(0 to 31);		
	FSL0_S_Exists	: in	std_logic;

        FSL1_S_Read	: out	std_logic;
	FSL1_S_Data	: in	std_logic_vector(0 to 31);		
	FSL1_S_Exists	: in	std_logic;

        FSL2_S_Read	: out	std_logic;
	FSL2_S_Data	: in	std_logic_vector(0 to 31);		
	FSL2_S_Exists	: in	std_logic;
  
	        ------------------------------------------------------	
	FSL0_M_Write	: out	std_logic;
	FSL0_M_Data	: out	std_logic_vector(0 to 31);		
	FSL0_M_Full	: in	std_logic;

	FSL1_M_Write	: out	std_logic;
	FSL1_M_Data	: out	std_logic_vector(0 to 31);		
	FSL1_M_Full	: in	std_logic;
   
   

    -- ADD USER PORTS ABOVE THIS LINE ------------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol ports, do not add to or delete
    OPB_Clk                        : in  std_logic;
    OPB_Rst                        : in  std_logic;

    Sl_DBus                        : out std_logic_vector(0 to C_OPB_DWIDTH-1);
    Sl_errAck                      : out std_logic;
    Sl_retry                       : out std_logic;
    Sl_toutSup                     : out std_logic;
    Sl_xferAck                     : out std_logic;

    OPB_ABus                       : in  std_logic_vector(0 to C_OPB_AWIDTH-1);
    OPB_BE                         : in  std_logic_vector(0 to C_OPB_DWIDTH/8-1);
    OPB_DBus                       : in  std_logic_vector(0 to C_OPB_DWIDTH-1);
    OPB_RNW                        : in  std_logic;
    OPB_select                     : in  std_logic;
    OPB_seqAddr                    : in  std_logic;

    M_ABus                         : out std_logic_vector(0 to C_OPB_AWIDTH-1);
    M_BE                           : out std_logic_vector(0 to C_OPB_DWIDTH/8-1);
    M_busLock                      : out std_logic;
    M_request                      : out std_logic;
    M_RNW                          : out std_logic;
    M_select                       : out std_logic;
    M_seqAddr                      : out std_logic;


    OPB_errAck                     : in  std_logic;
    OPB_MGrant                     : in  std_logic;
    OPB_retry                      : in  std_logic;
    OPB_timeout                    : in  std_logic;
    OPB_xferAck                    : in  std_logic
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );

  attribute SIGIS : string;
  attribute SIGIS of OPB_Clk       : signal is "Clk";
  attribute SIGIS of OPB_Rst       : signal is "Rst";

end entity opb_hwti;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of opb_hwti is
component user_logic_hwti is
  generic ( 
    C_BASEADDR                     : std_logic_vector     := X"6300_0000";
    C_HIGHADDR                     : std_logic_vector     := X"6300_FFFF";
    C_OPB_AWIDTH                   : integer              := 32;
    C_OPB_DWIDTH                   : integer              := 32;
    C_FAMILY                       : string               := "virtex2p";

    C_NUM_THREADS : integer := 256;
    C_NUM_MUTEXES : integer := 64;
    C_THREAD_MANAGER_BADDR : std_logic_vector(0 to 31) := x"6000_0000";
    C_MUTEX_MANAGER_BADDR : std_logic_vector(0 to 31) := x"7500_0000";
    C_CONVAR_MANAGER_BADDR : std_logic_vector(0 to 31) := x"7600_0000"
  );
  port
  (
   OPBtimer  : out std_logic_vector(0 to 31);
    --CONTROL : in STD_LOGIC_VECTOR(35 DOWNTO 0);

    Bus2IP_Addr : in  std_logic_vector(0 to 31);
    Bus2IP_Clk : in  std_logic;
    Bus2IP_CS : in  std_logic;
    Bus2IP_Data : in  std_logic_vector(0 to 31);
    Bus2IP_RdCE : in  std_logic_vector(0 to 3);
    Bus2IP_Reset : in  std_logic;
    Bus2IP_WrCE : in  std_logic_vector(0 to 3);
    Bus2IP_RdReq : in  std_logic;
    Bus2IP_WrReq : in  std_logic;

    IP2Bus_Ack : out  std_logic;
    IP2Bus_Data : out  std_logic_vector(0 to 31);
    IP2Bus_Error : out  std_logic;
    IP2Bus_PostedWrInh : out  std_logic;
    IP2Bus_Retry : out  std_logic;
    IP2Bus_ToutSup : out  std_logic;

    Bus2IP_MstError : in  std_logic;
    Bus2IP_MstLastAck : in  std_logic;
    Bus2IP_MstRdAck : in  std_logic;
    Bus2IP_MstWrAck : in  std_logic;
    Bus2IP_MstRetry : in  std_logic;
    Bus2IP_MstTimeOut : in  std_logic;

    IP2Bus_Addr : out std_logic_vector(0 to 31);
    IP2Bus_MstBE : out std_logic_vector(0 to 3);
    IP2Bus_MstBurst : out std_logic;
    IP2Bus_MstBusLock : out std_logic;
    IP2Bus_MstRdReq : out std_logic;
    IP2Bus_MstWrReq : out std_logic;
    IP2IP_Addr : out std_logic_vector(0 to 31);

    intrfc2thrd : out std_logic_vector(0 to 63);
    thrd2intrfc : in std_logic_vector( 0 to 95);
    rd          : out std_logic;
    wr          : out std_logic;
    exist       : in  std_logic;
    full        : in  std_logic	 	 

    
  );
end component user_logic_hwti;


  ------------------------------------------
  -- constants : generated by wizard for instantiation - do not change
  ------------------------------------------
  -- specify address range definition identifier value, each entry with
  -- predefined identifier indicates inclusion of corresponding ipif
  -- service, following ipif mandatory service identifiers are predefined:
  --   IPIF_INTR
  --   IPIF_RST
  --   IPIF_SEST_SEAR
  --   IPIF_DMA_SG
  --   IPIF_WRFIFO_REG
  --   IPIF_WRFIFO_DATA
  --   IPIF_RDFIFO_REG
  --   IPIF_RDFIFO_DATA
  constant USER_MASTER                    : integer              := USER_10;

  constant ARD_ID_ARRAY                   : INTEGER_ARRAY_TYPE   := 
    (
      0  => USER_MASTER             -- user logic master space (ip master model registers)
    );

  -- specify actual address range (defined by a pair of base address and
  -- high address) for each address space, which are byte relative.
  constant ZERO_ADDR_PAD                  : std_logic_vector(0 to 31) := (others => '0');

--  constant MASTER_BASEADDR                : std_logic_vector     := C_BASEADDR or X"00000000";
  constant MASTER_BASEADDR                : std_logic_vector     := C_BASEADDR;

--  constant MASTER_HIGHADDR                : std_logic_vector     := C_BASEADDR or X"000000FF";
  constant MASTER_HIGHADDR                : std_logic_vector     := C_HIGHADDR;

  constant ARD_ADDR_RANGE_ARRAY           : SLV64_ARRAY_TYPE     := 
    (
      ZERO_ADDR_PAD & MASTER_BASEADDR,            -- user logic master space base address
      ZERO_ADDR_PAD & MASTER_HIGHADDR             -- user logic master space high address
    );

  -- specify data width for each target address range.
  constant USER_DWIDTH                    : integer              := 32;

  constant ARD_DWIDTH_ARRAY               : INTEGER_ARRAY_TYPE   := 
    (
      0  => USER_DWIDTH             -- user logic master space data width
    );

  -- specify desired number of chip enables for each address range,
  -- typically one ce per register and each ipif service has its
  -- predefined value.
  constant USER_NUM_MASTER_CE             : integer              := 4;

  constant USER_NUM_CE                    : integer              := USER_NUM_MASTER_CE;

  constant ARD_NUM_CE_ARRAY               : INTEGER_ARRAY_TYPE   := 
    (
      0  => pad_power2(USER_NUM_MASTER_CE)    -- number of chip enables for user logic master space (one per register)
    );

  -- specify unique properties for each address range, currently
  -- only used for packet fifo data spaces.
  constant ARD_DEPENDENT_PROPS_ARRAY      : DEPENDENT_PROPS_ARRAY_TYPE := 
    (
      0  => (others => 0)           -- user logic master space dependent properties (none defined)
    );

  -- specify user defined device block id, which is used to uniquely
  -- identify a device within a system.
  constant DEV_BLK_ID                     : integer              := 0;

  -- specify inclusion/omission of module information register to be
  -- read via the opb bus.
  constant DEV_MIR_ENABLE                 : integer              := 0;

  -- specify inclusion/omission of additional logic needed to support
  -- opb fixed burst transfers and optimized cacahline transfers.
  constant DEV_BURST_ENABLE               : integer              := 0;

  -- specify the maximum number of bytes that are allowed to be
  -- transferred in a single burst operation, currently this needs
  -- to be fixed at 64.
  constant DEV_MAX_BURST_SIZE             : integer              := 64;

  -- specify inclusion/omission of device interrupt source
  -- controller for internal ipif generated interrupts.
  constant INCLUDE_DEV_ISC                : integer              := 0;

  -- specify inclusion/omission of device interrupt priority
  -- encoder, this is useful in aiding the user interrupt service
  -- routine to resolve the source of an interrupt within a opb
  -- device incorporating an ipif.
  constant INCLUDE_DEV_PENCODER           : integer              := 0;

  -- specify number and capture mode of interrupt events from the
  -- user logic to the ip isc located in the ipif interrupt service,
  -- user logic interrupt event capture mode [1-6]:
  --   1 = Level Pass through (non-inverted)
  --   2 = Level Pass through (invert input)
  --   3 = Registered Event (non-inverted)
  --   4 = Registered Event (inverted input)
  --   5 = Rising Edge Detect
  --   6 = Falling Edge Detect
  constant IP_INTR_MODE_ARRAY             : INTEGER_ARRAY_TYPE   := 
    (
      0  => 0     -- not used
    );

  -- specify inclusion/omission of opb master service for user logic.
  constant IP_MASTER_PRESENT              : integer              := 1;

  -- specify arbitration scheme if both dma and user-logic masters are present,
  -- following schemes are supported:
  --   0 - FAIR
  --   1 - DMA_PRIORITY
  --   2 - IP_PRIORITY
  constant MASTER_ARB_MODEL               : integer              := 0;

  -- specify dma type for each channel (currently only 2 channels
  -- supported), use following number:
  --   0 - simple dma
  --   1 - simple scatter gather
  --   2 - tx scatter gather with packet mode support
  --   3 - rx scatter gather with packet mode support
  constant DMA_CHAN_TYPE_ARRAY            : INTEGER_ARRAY_TYPE   := 
    (
      0 => 0     -- not used
    );

  -- specify maximum width in bits for dma transfer byte counters.
  constant DMA_LENGTH_WIDTH_ARRAY         : INTEGER_ARRAY_TYPE   := 
    (
      0 => 0     -- not used
    );

  -- specify address assigement for the length fifos used in
  -- scatter gather operation.
  constant DMA_PKT_LEN_FIFO_ADDR_ARRAY    : SLV64_ARRAY_TYPE     := 
    (
      0 => X"00000000_00000000"     -- not used
    );

  -- specify address assigement for the status fifos used in
  -- scatter gather operation.
  constant DMA_PKT_STAT_FIFO_ADDR_ARRAY   : SLV64_ARRAY_TYPE     := 
    (
      0 => X"00000000_00000000"     -- not used
    );

  -- specify interrupt coalescing value (number of interrupts to
  -- accrue before issuing interrupt to system) for each dma
  -- channel, apply to software design consideration.
  constant DMA_INTR_COALESCE_ARRAY        : INTEGER_ARRAY_TYPE   := 
    (
      0 => 0     -- not used
    );

  -- specify the size (must be power of 2) of burst that dma uses to
  -- tranfer data on the bus, a value of one causes dma to use single
  -- transactions (burst disabled).
  constant DMA_BURST_SIZE                 : integer              := 16;

  -- specify whether to transfer the dma remanining data as a series of
  -- single transactions or as a short burst.
  constant DMA_SHORT_BURST_REMAINDER      : integer              := 0;

  -- specify maximum allowed time period (in ns) a packet may wait
  -- before transfer by the scatter gather dma (usually left at
  -- default value), apply to software design consideration.
  constant DMA_PACKET_WAIT_UNIT_NS        : integer              := 1000000;

  -- specify period of the opb clock in picoseconds, which is used
  --  by the dma/sg service for timing funtions.
  constant OPB_CLK_PERIOD_PS              : integer              := 10000;

  -- specify ipif data bus size, used for future ipif optimization,
  -- should be set equal to the opb data bus width.
  constant IPIF_DWIDTH                    : integer              := C_OPB_DWIDTH;

  -- specify user logic address bus width, must be same as the target bus.
  constant USER_AWIDTH                    : integer              := C_OPB_AWIDTH;

  -- specify number of chip selects for user logic slave/master spaces.
  constant USER_NUM_CS                    : integer              := 1;

  constant USER_CS_INDEX                  : integer              := get_id_index(ARD_ID_ARRAY, USER_MASTER);

  -- specify index for user logic slave/master spaces chip enable.
  constant USER_MASTER_CE_INDEX           : integer              := calc_start_ce_index(ARD_NUM_CE_ARRAY, get_id_index(ARD_ID_ARRAY, USER_MASTER));

  ------------------------------------------
  -- IP Interconnect (IPIC) signal declarations -- do not delete
  -- prefix 'i' stands for IPIF while prefix 'u' stands for user logic
  -- typically user logic will be hooked up to IPIF directly via i<sig>
  -- unless signal slicing and muxing are needed via u<sig>
  ------------------------------------------
  signal iIP2Bus_Addr                   : std_logic_vector(0 to C_OPB_AWIDTH - 1)   := (others => '0');
  signal iBus2IP_Addr                   : std_logic_vector(0 to C_OPB_AWIDTH - 1);
  signal iBus2IP_Data                   : std_logic_vector(0 to IPIF_DWIDTH - 1);
  signal iBus2IP_CS                     : std_logic_vector(0 to ((ARD_ADDR_RANGE_ARRAY'LENGTH)/2)-1);
  signal iBus2IP_RdCE                   : std_logic_vector(0 to calc_num_ce(ARD_NUM_CE_ARRAY)-1);
  signal iBus2IP_WrCE                   : std_logic_vector(0 to calc_num_ce(ARD_NUM_CE_ARRAY)-1);
  signal iIP2Bus_Data                   : std_logic_vector(0 to IPIF_DWIDTH-1)   := (others => '0');
  signal iIP2Bus_Ack                    : std_logic   := '0';
  signal iIP2Bus_WrAck                  : std_logic   := '0';
  signal iIP2Bus_RdAck                  : std_logic   := '0';
  signal iIP2Bus_Retry                  : std_logic   := '0';
  signal iIP2Bus_Error                  : std_logic   := '0';
  signal iIP2Bus_ToutSup                : std_logic   := '0';
  signal iIP2Bus_PostedWrInh            : std_logic   := '0';
  signal iIP2IP_Addr                    : std_logic_vector(0 to C_OPB_AWIDTH - 1)   := (others => '0');
  signal ZERO_IP2RFIFO_Data             : std_logic_vector(0 to 31)   := (others => '0'); -- work around for XST not taking (others => '0') in port mapping
  signal iIP2Bus_MstBE                  : std_logic_vector(0 to (C_OPB_DWIDTH/8) - 1)   := (others => '0');
  signal iIP2Bus_MstWrReq               : std_logic   := '0';
  signal iIP2Bus_MstRdReq               : std_logic   := '0';
  signal iIP2Bus_MstBurst               : std_logic   := '0';
  signal iIP2Bus_MstBusLock             : std_logic   := '0';
  signal iBus2IP_MstWrAck               : std_logic;
  signal iBus2IP_MstRdAck               : std_logic;
  signal iBus2IP_MstRetry               : std_logic;
  signal iBus2IP_MstError               : std_logic;
  signal iBus2IP_MstTimeOut             : std_logic;
  signal iBus2IP_MstLastAck             : std_logic;
  signal iBus2IP_BE                     : std_logic_vector(0 to (IPIF_DWIDTH/8) - 1);
  signal iBus2IP_WrReq                  : std_logic;
  signal iBus2IP_RdReq                  : std_logic;
  signal iBus2IP_Clk                    : std_logic;
  signal iBus2IP_Reset                  : std_logic;
  signal ZERO_IP2Bus_IntrEvent          : std_logic_vector(0 to IP_INTR_MODE_ARRAY'length - 1)   := (others => '0'); -- work around for XST not taking (others => '0') in port mapping
  signal uBus2IP_Data                   : std_logic_vector(0 to USER_DWIDTH-1);
  signal iBus2IP_RNW                    : std_logic;
  signal uBus2IP_BE                     : std_logic_vector(0 to USER_DWIDTH/8-1);
  signal uBus2IP_CS                     : std_logic_vector(0 to USER_NUM_CS-1);
  signal uBus2IP_RdCE                   : std_logic_vector(0 to USER_NUM_CE-1);
  signal uBus2IP_WrCE                   : std_logic_vector(0 to USER_NUM_CE-1);
  signal uIP2Bus_Data                   : std_logic_vector(0 to USER_DWIDTH-1);
  signal uIP2Bus_MstBE                  : std_logic_vector(0 to USER_DWIDTH/8-1);

  -- HWTI to HWTUL interconnect
    signal  intrfc2thrd :  std_logic_vector(0 to 63);
    signal  thrd2intrfc :  std_logic_vector( 0 to 95);
    signal  rd          :  std_logic;
    signal  wr          :  std_logic;
    signal  exist       :   std_logic;
    signal  full        :   std_logic;  


    signal internal_M_ABus   :  std_logic_vector(0 to 31);
    signal internal_M_request : std_logic;
    signal internal_M_select  : std_logic;
    signal internal_M_RNW  : std_logic;

begin

   OPBM_ABus     <= internal_M_ABus ;
   OPBM_request  <= internal_M_request;
   OPBM_select   <= internal_M_RNW;
   OPBM_MGrant   <= OPB_MGrant;
   OPBM_xferAck  <= OPB_xferAck; 
   
   M_RNW  <= internal_M_RNW;
   M_ABus     <=  internal_M_ABus ;
   M_request  <=  internal_M_request;
   M_select   <=  internal_M_select;

   OPBintrfc2thrd_value    <= intrfc2thrd(0 to 31)  ;
   OPBintrfc2thrd_function <= intrfc2thrd (32 to 47);
   OPBintrfc2thrd_goWait   <= intrfc2thrd (48) ;

   OPBthrd2intrfc_address  <= thrd2intrfc (32 to 63);
   OPBthrd2intrfc_value    <= thrd2intrfc  (0 to 31) ; 
   OPBthrd2intrfc_function <= thrd2intrfc (64 to 79);  
   OPBthrd2intrfc_opcode   <= thrd2intrfc (80 to 85);

   --======================================================= 
   thrd2intrfc <= FSL0_S_Data & FSL1_S_Data &FSL2_S_Data;
   FSL0_M_Data <= intrfc2thrd(0 to 31); 
   FSL1_M_Data <= intrfc2thrd(32 to 63);
   

 --======================================================= 

   full  <= FSL0_M_Full or FSL1_M_Full ;
   exist <= FSL0_S_Exists and FSL1_S_Exists and FSL2_S_Exists;

 --======================================================= 
  FSL0_S_Read <=  rd;
  FSL1_S_Read <=  rd;
  FSL2_S_Read <=  rd;

  FSL0_M_Write  <= wr;
  FSL1_M_Write  <= wr;
  

  ------------------------------------------
  -- instantiate the OPB IPIF
  ------------------------------------------
  OPB_IPIF_I : entity opb_ipif_v2_00_h.opb_ipif
    generic map
    (
      C_ARD_ID_ARRAY                 => ARD_ID_ARRAY,
      C_ARD_ADDR_RANGE_ARRAY         => ARD_ADDR_RANGE_ARRAY,
      C_ARD_DWIDTH_ARRAY             => ARD_DWIDTH_ARRAY,
      C_ARD_NUM_CE_ARRAY             => ARD_NUM_CE_ARRAY,
      C_ARD_DEPENDENT_PROPS_ARRAY    => ARD_DEPENDENT_PROPS_ARRAY,
      C_DEV_BLK_ID                   => DEV_BLK_ID,
      C_DEV_MIR_ENABLE               => DEV_MIR_ENABLE,
      C_DEV_BURST_ENABLE             => DEV_BURST_ENABLE,
      C_DEV_MAX_BURST_SIZE           => DEV_MAX_BURST_SIZE,
      C_INCLUDE_DEV_ISC              => INCLUDE_DEV_ISC,
      C_INCLUDE_DEV_PENCODER         => INCLUDE_DEV_PENCODER,
      C_IP_INTR_MODE_ARRAY           => IP_INTR_MODE_ARRAY,
      C_IP_MASTER_PRESENT            => IP_MASTER_PRESENT,
      C_MASTER_ARB_MODEL             => MASTER_ARB_MODEL,
      C_DMA_CHAN_TYPE_ARRAY          => DMA_CHAN_TYPE_ARRAY,
      C_DMA_LENGTH_WIDTH_ARRAY       => DMA_LENGTH_WIDTH_ARRAY,
      C_DMA_PKT_LEN_FIFO_ADDR_ARRAY  => DMA_PKT_LEN_FIFO_ADDR_ARRAY,
      C_DMA_PKT_STAT_FIFO_ADDR_ARRAY => DMA_PKT_STAT_FIFO_ADDR_ARRAY,
      C_DMA_INTR_COALESCE_ARRAY      => DMA_INTR_COALESCE_ARRAY,
      C_DMA_BURST_SIZE               => DMA_BURST_SIZE,
      C_DMA_SHORT_BURST_REMAINDER    => DMA_SHORT_BURST_REMAINDER,
      C_DMA_PACKET_WAIT_UNIT_NS      => DMA_PACKET_WAIT_UNIT_NS,
      C_OPB_AWIDTH                   => C_OPB_AWIDTH,
      C_OPB_DWIDTH                   => C_OPB_DWIDTH,
      C_OPB_CLK_PERIOD_PS            => OPB_CLK_PERIOD_PS,
      C_IPIF_DWIDTH                  => IPIF_DWIDTH,
      C_FAMILY                       => C_FAMILY
    )
    port map
    (
      OPB_ABus                       => OPB_ABus,
      OPB_DBus                       => OPB_DBus,
      Sln_DBus                       => Sl_DBus,
      Mn_ABus                        => internal_M_ABus,
      IP2Bus_Addr                    => iIP2Bus_Addr,
      Bus2IP_Addr                    => iBus2IP_Addr,
      Bus2IP_Data                    => iBus2IP_Data,
      Bus2IP_RNW                     => iBus2IP_RNW,
      Bus2IP_CS                      => iBus2IP_CS,
      Bus2IP_CE                      => open,
      Bus2IP_RdCE                    => iBus2IP_RdCE,
      Bus2IP_WrCE                    => iBus2IP_WrCE,
      IP2Bus_Data                    => iIP2Bus_Data,
      IP2Bus_WrAck                   => iIP2Bus_WrAck,
      IP2Bus_RdAck                   => iIP2Bus_RdAck,
      IP2Bus_Retry                   => iIP2Bus_Retry,
      IP2Bus_Error                   => iIP2Bus_Error,
      IP2Bus_ToutSup                 => iIP2Bus_ToutSup,
      IP2Bus_PostedWrInh             => iIP2Bus_PostedWrInh,
      IP2DMA_RxLength_Empty          => '0',
      IP2DMA_RxStatus_Empty          => '0',
      IP2DMA_TxLength_Full           => '0',
      IP2DMA_TxStatus_Empty          => '0',
      IP2IP_Addr                     => iIP2IP_Addr,
      IP2RFIFO_Data                  => ZERO_IP2RFIFO_Data,
      IP2RFIFO_WrMark                => '0',
      IP2RFIFO_WrRelease             => '0',
      IP2RFIFO_WrReq                 => '0',
      IP2RFIFO_WrRestore             => '0',
      IP2WFIFO_RdMark                => '0',
      IP2WFIFO_RdRelease             => '0',
      IP2WFIFO_RdReq                 => '0',
      IP2WFIFO_RdRestore             => '0',
      IP2Bus_MstBE                   => iIP2Bus_MstBE,
      IP2Bus_MstWrReq                => iIP2Bus_MstWrReq,
      IP2Bus_MstRdReq                => iIP2Bus_MstRdReq,
      IP2Bus_MstBurst                => iIP2Bus_MstBurst,
      IP2Bus_MstBusLock              => iIP2Bus_MstBusLock,
      Bus2IP_MstWrAck                => iBus2IP_MstWrAck,
      Bus2IP_MstRdAck                => iBus2IP_MstRdAck,
      Bus2IP_MstRetry                => iBus2IP_MstRetry,
      Bus2IP_MstError                => iBus2IP_MstError,
      Bus2IP_MstTimeOut              => iBus2IP_MstTimeOut,
      Bus2IP_MstLastAck              => iBus2IP_MstLastAck,
      Bus2IP_BE                      => iBus2IP_BE,
      Bus2IP_WrReq                   => iBus2IP_WrReq,
      Bus2IP_RdReq                   => iBus2IP_RdReq,
      Bus2IP_IPMstTrans              => open,
      Bus2IP_Burst                   => open,
      Mn_request                     => internal_M_request,
      Mn_busLock                     => M_busLock,
      Mn_select                      => internal_M_select,
      Mn_RNW                         => internal_M_RNW,
      Mn_BE                          => M_BE,
      Mn_seqAddr                     => M_seqAddr,
      OPB_MnGrant                    => OPB_MGrant,
      OPB_xferAck                    => OPB_xferAck,
      OPB_errAck                     => OPB_errAck,
      OPB_retry                      => OPB_retry,
      OPB_timeout                    => OPB_timeout,
      Freeze                         => '0',
      RFIFO2IP_AlmostFull            => open,
      RFIFO2IP_Full                  => open,
      RFIFO2IP_Vacancy               => open,
      RFIFO2IP_WrAck                 => open,
      OPB_select                     => OPB_select,
      OPB_RNW                        => OPB_RNW,
      OPB_seqAddr                    => OPB_seqAddr,
      OPB_BE                         => OPB_BE,
      Sln_xferAck                    => Sl_xferAck,
      Sln_errAck                     => Sl_errAck,
      Sln_toutSup                    => Sl_toutSup,
      Sln_retry                      => Sl_retry,
      WFIFO2IP_AlmostEmpty           => open,
      WFIFO2IP_Data                  => open,
      WFIFO2IP_Empty                 => open,
      WFIFO2IP_Occupancy             => open,
      WFIFO2IP_RdAck                 => open,
      Bus2IP_Clk                     => iBus2IP_Clk,
      Bus2IP_DMA_Ack                 => open,
      Bus2IP_Freeze                  => open,
      Bus2IP_Reset                   => iBus2IP_Reset,
      IP2Bus_Clk                     => '0',
      IP2Bus_DMA_Req                 => '0',
      IP2Bus_IntrEvent               => ZERO_IP2Bus_IntrEvent,
      IP2INTC_Irpt                   => open,
      OPB_Clk                        => OPB_Clk,
      Reset                          => OPB_Rst
    );

  ------------------------------------------
  -- instantiate the User Logic
  ------------------------------------------
  USER_LOGIC_HWTI_I : user_logic_hwti
    generic map (
      C_BASEADDR => C_BASEADDR,
      C_HIGHADDR => C_HIGHADDR,
      C_OPB_AWIDTH => C_OPB_AWIDTH,
      C_OPB_DWIDTH => C_OPB_DWIDTH,
      C_FAMILY => C_FAMILY,
      C_NUM_THREADS => C_NUM_THREADS,
      C_NUM_MUTEXES => C_NUM_MUTEXES,
      C_THREAD_MANAGER_BADDR => C_THREAD_MANAGER_BADDR,
      C_MUTEX_MANAGER_BADDR => C_MUTEX_MANAGER_BADDR,
      C_CONVAR_MANAGER_BADDR => C_CONVAR_MANAGER_BADDR
    )
    port map
    (

      OPBtimer                        => OPBtimer,
      --CONTROL                        => CONTROL ,
      Bus2IP_Clk                     => iBus2IP_Clk,
      Bus2IP_Reset                   => iBus2IP_Reset,
      Bus2IP_Addr                    => iBus2IP_Addr,
      Bus2IP_Data                    => uBus2IP_Data,
--      Bus2IP_BE                      => uBus2IP_BE,
      Bus2IP_CS                      => uBus2IP_CS(0),
      Bus2IP_RdCE                    => uBus2IP_RdCE,
      Bus2IP_WrCE                    => uBus2IP_WrCE,
      Bus2IP_RdReq                   => iBus2IP_RdReq,
      Bus2IP_WrReq                   => iBus2IP_WrReq,
      IP2Bus_Data                    => uIP2Bus_Data,
      IP2Bus_Retry                   => iIP2Bus_Retry,
      IP2Bus_Error                   => iIP2Bus_Error,
      IP2Bus_ToutSup                 => iIP2Bus_ToutSup,
      IP2Bus_PostedWrInh             => iIP2Bus_PostedWrInh,
      IP2Bus_Ack                   => iIP2Bus_Ack,
--      IP2Bus_RdAck                   => iIP2Bus_RdAck,
--      IP2Bus_WrAck                   => iIP2Bus_WrAck,
      Bus2IP_MstError                => iBus2IP_MstError,
      Bus2IP_MstLastAck              => iBus2IP_MstLastAck,
      Bus2IP_MstRdAck                => iBus2IP_MstRdAck,
      Bus2IP_MstWrAck                => iBus2IP_MstWrAck,
      Bus2IP_MstRetry                => iBus2IP_MstRetry,
      Bus2IP_MstTimeOut              => iBus2IP_MstTimeOut,
      IP2Bus_Addr                    => iIP2Bus_Addr,
      IP2Bus_MstBE                   => uIP2Bus_MstBE,
      IP2Bus_MstBurst                => iIP2Bus_MstBurst,
      IP2Bus_MstBusLock              => iIP2Bus_MstBusLock,
      IP2Bus_MstRdReq                => iIP2Bus_MstRdReq,
      IP2Bus_MstWrReq                => iIP2Bus_MstWrReq,
      IP2IP_Addr                     => iIP2IP_Addr,

      intrfc2thrd		     => intrfc2thrd,
      thrd2intrfc 		     => thrd2intrfc,
      rd          		     => rd,
      wr          		     => wr,
      exist      		     => exist,
      full                           => full 
				         
    );
    

  
  ------------------------------------------
  -- hooking up signal slicing
  ------------------------------------------
  iIP2Bus_MstBE <= uIP2Bus_MstBE;
  uBus2IP_Data <= iBus2IP_Data(0 to USER_DWIDTH-1);
  uBus2IP_BE <= iBus2IP_BE(0 to USER_DWIDTH/8-1);
  uBus2IP_CS <= iBus2IP_CS(USER_CS_INDEX to USER_CS_INDEX+USER_NUM_CS-1);
  uBus2IP_RdCE(0 to USER_NUM_MASTER_CE-1) <= iBus2IP_RdCE(USER_MASTER_CE_INDEX to USER_MASTER_CE_INDEX+USER_NUM_MASTER_CE-1);
  uBus2IP_WrCE(0 to USER_NUM_MASTER_CE-1) <= iBus2IP_WrCE(USER_MASTER_CE_INDEX to USER_MASTER_CE_INDEX+USER_NUM_MASTER_CE-1);
  iIP2Bus_Data(0 to USER_DWIDTH-1) <= uIP2Bus_Data;

  iIP2Bus_RdAck  <= iIP2Bus_Ack and iBus2IP_RNW;
  iIP2Bus_WrAck  <= iIP2Bus_Ack and (not iBus2IP_RNW);

end IMP;
