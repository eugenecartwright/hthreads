-------------------------------------------------------------------------------
-- xps_intc - entity / architecture pair
-------------------------------------------------------------------------------
--
-- ***************************************************************************
-- DISCLAIMER OF LIABILITY
--
-- This file contains proprietary and confidential information of
-- Xilinx, Inc. ("Xilinx"), that is distributed under a license
-- from Xilinx, and may be used, copied and/or disclosed only
-- pursuant to the terms of a valid license agreement with Xilinx.
--
-- XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION
-- ("MATERIALS") "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
-- EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING WITHOUT
-- LIMITATION, ANY WARRANTY WITH RESPECT TO NONINFRINGEMENT,
-- MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. Xilinx
-- does not warrant that functions included in the Materials will
-- meet the requirements of Licensee, or that the operation of the
-- Materials will be uninterrupted or error-free, or that defects
-- in the Materials will be corrected. Furthermore, Xilinx does
-- not warrant or make any representations regarding use, or the
-- results of the use, of the Materials in terms of correctness,
-- accuracy, reliability or otherwise.
--
-- Xilinx products are not designed or intended to be fail-safe,
-- or for use in any application requiring fail-safe performance,
-- such as life-support or safety devices or systems, Class III
-- medical devices, nuclear facilities, applications related to
-- the deployment of airbags, or any other applications that could
-- lead to death, personal injury or severe property or
-- environmental damage (individually and collectively, "critical
-- applications"). Customer assumes the sole risk and liability
-- of any use of Xilinx products in critical applications,
-- subject only to applicable laws and regulations governing
-- limitations on product liability.
--
-- Copyright 2007, 2009 Xilinx, Inc.
-- All rights reserved.
--
-- This disclaimer and copyright notice must be retained as part
-- of this file at all times.
-- ***************************************************************************
--
-------------------------------------------------------------------------------
-- Filename:        xps_intc.vhd
-- Version:         v2.01a
-- Description:     Interrupt controller interfaced to plb v46 bus.
--
-- VHDL-Standard:   VHDL'93
-------------------------------------------------------------------------------
-- Structure:
--           -- xps_intc.vhd  (wrapper for top level)
--               -- plbv46_slave_single
--                  -plb_slave_attachment
--                  -plb_address_decoder
--               -- intc_core
--
-------------------------------------------------------------------------------
-- Author:      NSK
-- History:
--   NSK      2/23/2007           First version
-- ^^^^^^^
-- Version xps_intc v1.00a functionality is based on opb_intc v1.00c wherein 
-- the design is completed recoded for better readiabilty, save resources,
-- increase frequecny and remove the structural code. This provides interface 
-- to plb_v46 bus.
-- ~~~~~~~
--   NSK      7/31/2007
-- ^^^^^^^
-- 1. Modified the generation of CE. Now generating 4 CEs to fix the problem 
--    reported while accessign non existing address location with the updated 
--    plbv46_slave_single design.
-- 2. Modified generation of ip2bus_rdack_int & ip2bus_wrack_int.
-- 3. Removed the bit (0) from the port mapping of intc_core. The signals 
--    bus2ip_rdce and bus2ip_wrce are 8-bit.
-- 4. Removed unused ports Wr_ack & Rd_ack from port mapping of intc_core.
-- ~~~~~~~
--   NSK      9/13/2008           version v2.00a
-- ^^^^^^^
--   NSK      9/13/2008
-- ^^^^^^^
-- 1. Rolled to revision v2.00a.
-- 2. Removed the old EDK Changlog as per guideline.
-- 3. Changed the library proc_common from v2_00_a to v3_00_a.
-- 4. Changed the library plbv46_slave_single from v1_00_a to v1_01_a.
-- 5. Changed the library xps_intc from v1_00_a to v2_00_a.
-- 6. Fixed CR #442790 to support edge on Irq.
--    I.   Added generic C_IRQ_IS_LEVEL
--         a. If set to 0 generates edge interrupt
--         b. If set to 1 generates level interrupt
--    II.  Changed the definition of generic C_IRQ_ACTIVE
--         a. Defines the edge for output interrupt if C_IRQ_IS_LEVEL=0 
--            "0" = FALLING EDGE
--            "1" = RISING EDGE
--         b. Defines the level for output interrupt if C_IRQ_IS_LEVEL=1 
--            "0" = LOW LEVEL
--            "1" = HIGH LEVEL
--    III. Added generic C_IRQ_IS_LEVEL in generic map of instance INTC_CORE_I 
--         for component "intc_core" from library "xps_intc_v2_00_a."
--    IV.  Added "C_IRQ_IS_LEVEL" in Definition of Generics section in 
--         comments.
-- ~~~~~~~
--   NSK      9/15/2008
-- ^^^^^^^
-- Removed unused parameter C_FAMILY from the instance of intc_core.
-- ~~~~~~~
--   NSK      9/23/2008
-- ^^^^^^^
-- Removed XRANGE PSFUtil attribute. As per new guidline this is part of 
-- prime.mpd and not hdl.mpd.
-- ~~~~~~~
--   NSK      9/30/2008
-- ^^^^^^^
-- 1. Removed unused signals "wr_ack" & "rd_ack" from signal declaration.
-- 2. Updated for code review
--    A. Added C_INCLUDE_DPHASE_TIMER in the generic map of 
--       plbv46_slave_single and tied to 1.
--    B. Reduce one clock delay in assertion of "Ack"
--         a. ip2bus_rdack is assigned to the registered output of 
--            ip2bus_rdack_prev2.
--         b. ip2bus_wrack is assigned to the registered output of 
--            ip2bus_wrack_prev2.
--         c. Removed unused signals ip2bus_rdack_prev1 & ip2bus_wrack_prev1.
-- ~~~~~~~
--   NSK      10/01/2008
-- ^^^^^^^
-- Updated the latest Copyright and removed XCS label.
-- ~~~~~~~
-- ~~~~~~~
--   BSB      01/31/2010
-- ^^^^^^^
-- New version v2.01.a created. attribute buffer type added on signal Intr
-- ~~~~~~~
-------------------------------------------------------------------------------
-- Naming Conventions:
--      active low signals:                     "*_n"
--      clock signals:                          "clk", "clk_div#", "clk_#x"
--      reset signals:                          "rst", "rst_n"
--      generics:                               "C_*"
--      user defined types:                     "*_TYPE"
--      state machine next state:               "*_ns"
--      state machine current state:            "*_cs"
--      combinatorial signals:                  "*_cmb"
--      pipelined or register delay signals:    "*_d#"
--      counter signals:                        "*cnt*"
--      clock enable signals:                   "*_ce"
--      internal version of output port         "*_i"
--      device pins:                            "*_pin"
--      ports:                                  - Names begin with Uppercase
--      processes:                              "*_PROCESS"
--      component instantiations:               "<ENTITY_>I_<#|FUNC>
-------------------------------------------------------------------------------
--
library ieee;
use ieee.std_logic_1164.all;

library proc_common_v3_00_a;
-------------------------------------------------------------------------
-- Package proc_common_pkg is used because it contains the RESET_ACTIVE 
-- constant used to assign reset as active high status.
-------------------------------------------------------------------------
use proc_common_v3_00_a.proc_common_pkg.RESET_ACTIVE;
-------------------------------------------------------------------------
-- Package ipif_pkg is used because it contains the calc_num_ce, 
-- INTEGER_ARRAY_TYPE & SLV64_ARRAY_TYPE.
-- 1. calc_num_ce is used to get the number of chip selects.
--    INTEGER_ARRAY_TYPE is used for type declaration on constants 
-- 2. ARD_ID_ARRAY & ARD_NUM_CE_ARRAY.
--    type declaration on constants ARD_ID_ARRAY & ARD_NUM_CE_ARRAY.
-- 3. SLV64_ARRAY_TYPE is used for type declaration on constants 
--    on constants ARD_ADDR_RANGE_ARRAY.
-------------------------------------------------------------------------
use proc_common_v3_00_a.ipif_pkg.calc_num_ce;
use proc_common_v3_00_a.ipif_pkg.INTEGER_ARRAY_TYPE;
use proc_common_v3_00_a.ipif_pkg.SLV64_ARRAY_TYPE;

-------------------------------------------------------------------------
-- Library plbv46_slave_single_v1_01_a is used because it contains the 
-- plbv46_slave_single which interraces intc_core to plb_v46.
-------------------------------------------------------------------------
library plbv46_slave_single_v1_01_a;
use plbv46_slave_single_v1_01_a.plbv46_slave_single;

-------------------------------------------------------------------------
-- Library xps_intc_v2_01_a is used because it contains the intc_core.
-- The complete interrupt controller logic is designed in intc_core.
-------------------------------------------------------------------------
library xps_intc_v2_01_a;
use xps_intc_v2_01_a.intc_core;

-------------------------------------------------------------------------------
-- Definition of Generics:
--  -- System Parameter
--       C_FAMILY              -- Target FPGA family
--  -- PLB Parameters
--       C_BASEADDR            -- User logic base address
--       C_HIGHADDR            -- User logic high address
--       C_SPLB_AWIDTH         -- PLBv46 address bus width
--       C_SPLB_DWIDTH         -- PLBv46 data bus width
--       C_SPLB_P2P            -- Selects point-to-point or shared plb topology
--       C_SPLB_NUM_MASTERS    -- Number of PLB Masters
--       C_SPLB_MID_WIDTH      -- PLB Master ID Bus Width
--       C_SPLB_NATIVE_DWIDTH  -- Width of the slave data bus
--       C_SPLB_SUPPORT_BURSTS -- Burst support
--  -- Intc Parameters
--       C_NUM_INTR_INPUTS     -- Number of interrupt inputs
--       C_KIND_OF_INTR        -- Kind of interrupt (0-Level/1-Edge)
--       C_KIND_OF_EDGE        -- Kind of edge (0-falling/1-rising)
--       C_KIND_OF_LVL         -- Kind of level (0-low/1-high)
--       C_HAS_IPR             -- Set to 1 if has Interrupt Pending Register
--       C_HAS_SIE             -- Set to 1 if has Set Interrupt Enable Bits
--                                Register
--       C_HAS_CIE             -- Set to 1 if has Clear Interrupt Enable Bits
--                                Register
--       C_HAS_IVR             -- Set to 1 if has Interrupt Vector Register
--       C_IRQ_IS_LEVEL        -- If set to 0 generates edge interrupt
--                             -- If set to 1 generates level interrupt
--       C_IRQ_ACTIVE          -- Defines the edge for output interrupt if 
--                             -- C_IRQ_IS_LEVEL=0 (0-FALLING/1-RISING)
--                             -- Defines the level for output interrupt if 
--                             -- C_IRQ_IS_LEVEL=1 (0-LOW/1-HIGH)
--
-------------------------------------------------------------------------------
-- Definition of Ports:
--  -- Clocks and reset
--       SPLB_Clk       -- PLB clock
--       SPLB_Rst       -- PLB Reset
--  -- PLB Interface Signals
--       PLB_ABus       -- PLB address bus
--       PLB_PAValid    -- PLB primary address valid indicator
--       PLB_masterID   -- PLB current master indicator
--       PLB_RNW        -- PLB read not write
--       PLB_BE         -- PLB byte enables
--       PLB_size       -- PLB transfer size
--       PLB_type       -- PLB transfer type
--       PLB_wrDBus     -- PLB write data bus
--  -- Unused PLB Interface Signals
--       PLB_UABus      -- Slave address bits
--       PLB_SAValid    -- PLB secondary address valid indicator
--       PLB_rdPrim     -- PLB secondary to primary read request indicator
--       PLB_wrPrim     -- PLB secondary to primary write request indicator
--       PLB_abort      -- PLB abort bus request indicator
--       PLB_busLock    -- PLB bus lock
--       PLB_MSize      -- PLB master data bus size
--       PLB_lockErr    -- PLB lock error indicator
--       PLB_wrBurst    -- PLB burst write transfer indicator
--       PLB_rdBurst    -- PLB burst read transfer indicator
--       PLB_wrPendReq  -- PLB pending write request
--       PLB_rdPendReq  -- PLB pending read request
--       PLB_wrPendPri  -- PLB pending write request priority
--       PLB_rdPendPri  -- PLB pending read request priority
--       PLB_reqPri     -- PLB request priority
--       PLB_TAttribute -- PLB transfer attribute
--  -- PLB Slave Interface Signals
--       Sl_addrAck     -- Slave address acknowledge
--       Sl_SSize       -- Slave data bus sizer
--       Sl_wait        -- Slave wait indicator
--       Sl_rearbitrate -- Slave rearbitrate bus indicator
--       Sl_wrDAck      -- Slave write data acknowledge
--       Sl_wrComp      -- Slave write transfer complete indicator
--       Sl_rdDBus      -- Slave read bus
--       Sl_rdDAck      -- Slave read data acknowledge
--       Sl_rdComp      -- Slave read transfer complete indicator
--       Sl_MBusy       -- Slave busy indicator
--       Sl_MWrErr      -- Slave write error indicator
--       Sl_MRdErr      -- Slave read error indicator
--  -- Unused PLB Slave Interface Signals
--       Sl_wrBTerm     -- Slave terminate write burst transfer
--       Sl_rdWdAddr    -- Slave read word address
--       Sl_rdBTerm     -- Slave terminate read burst transfer
--       Sl_MIRQ        -- Slave interrupt indicator
--  -- Intc Interface Signals
--       Intr           -- Input Interruput request
--       Irq            -- Output Interruput request
-------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Entity
------------------------------------------------------------------------------
entity xps_intc is
    generic
    (
--  -- System Parameter
        C_FAMILY              : string  := "virtex5";
--  -- PLB Parameters
        C_BASEADDR            : std_logic_vector(0 to 31) := X"FFFFFFFF";
        C_HIGHADDR            : std_logic_vector(0 to 31) := X"00000000";
        C_SPLB_AWIDTH         : integer := 32;
        C_SPLB_DWIDTH         : integer range 32 to 128 := 32;
        C_SPLB_P2P            : integer range 0 to 1 := 0;
        C_SPLB_NUM_MASTERS    : integer range 1 to 16 := 1;
        C_SPLB_MID_WIDTH      : integer range 1 to 4 := 1;
        C_SPLB_NATIVE_DWIDTH  : integer := 32;
        C_SPLB_SUPPORT_BURSTS : integer := 0;
--  -- Intc Parameters
        C_NUM_INTR_INPUTS     : integer range 1 to 32 := 2;
        C_KIND_OF_INTR        : std_logic_vector(31 downto 0) :=
                                 "11111111111111111111111111111111";
        C_KIND_OF_EDGE        : std_logic_vector(31 downto 0) :=
                                 "11111111111111111111111111111111";
        C_KIND_OF_LVL         : std_logic_vector(31 downto 0) :=
                                 "11111111111111111111111111111111";
        C_HAS_IPR             : integer range 0 to 1 := 1;
        C_HAS_SIE             : integer range 0 to 1 := 1;
        C_HAS_CIE             : integer range 0 to 1 := 1;
        C_HAS_IVR             : integer range 0 to 1 := 1;
        C_IRQ_IS_LEVEL        : integer range 0 to 1 := 1;
        C_IRQ_ACTIVE          : std_logic := '1'
    );
    port
    (
--  -- System Signals
        SPLB_Clk       : in  std_logic;
        SPLB_Rst       : in  std_logic;
--  -- PLB Interface Signals
        PLB_ABus       : in  std_logic_vector(0 to 31);
        PLB_PAValid    : in  std_logic;
        PLB_masterID   : in  std_logic_vector(0 to C_SPLB_MID_WIDTH-1);
        PLB_RNW        : in  std_logic;
        PLB_BE         : in  std_logic_vector(0 to (C_SPLB_DWIDTH/8)-1);
        PLB_size       : in  std_logic_vector(0 to 3);
        PLB_type       : in  std_logic_vector(0 to 2);
        PLB_wrDBus     : in  std_logic_vector(0 to C_SPLB_DWIDTH-1);
--  -- Unused PLB Interface Signals
        PLB_UABus      : in  std_logic_vector(0 to 31);
        PLB_SAValid    : in  std_logic;
        PLB_rdPrim     : in  std_logic;
        PLB_wrPrim     : in  std_logic;
        PLB_abort      : in  std_logic;
        PLB_busLock    : in  std_logic;
        PLB_MSize      : in  std_logic_vector(0 to 1);
        PLB_lockErr    : in  std_logic;
        PLB_wrBurst    : in  std_logic;
        PLB_rdBurst    : in  std_logic;
        PLB_wrPendReq  : in  std_logic;
        PLB_rdPendReq  : in  std_logic;
        PLB_wrPendPri  : in  std_logic_vector(0 to 1);
        PLB_rdPendPri  : in  std_logic_vector(0 to 1);
        PLB_reqPri     : in  std_logic_vector(0 to 1);
        PLB_TAttribute : in  std_logic_vector(0 to 15);
--  -- PLB Slave Interface Signals
        Sl_addrAck     : out std_logic;
        Sl_SSize       : out std_logic_vector(0 to 1);
        Sl_wait        : out std_logic;
        Sl_rearbitrate : out std_logic;
        Sl_wrDAck      : out std_logic;
        Sl_wrComp      : out std_logic;
        Sl_rdDBus      : out std_logic_vector(0 to C_SPLB_DWIDTH-1);
        Sl_rdDAck      : out std_logic;
        Sl_rdComp      : out std_logic;
        Sl_MBusy       : out std_logic_vector (0 to C_SPLB_NUM_MASTERS-1);
        Sl_MWrErr      : out std_logic_vector (0 to C_SPLB_NUM_MASTERS-1);
        Sl_MRdErr      : out std_logic_vector (0 to C_SPLB_NUM_MASTERS-1);
--  -- Unused PLB Slave Interface Signals
        Sl_wrBTerm     : out std_logic;
        Sl_rdWdAddr    : out std_logic_vector(0 to 3);
        Sl_rdBTerm     : out std_logic;
        Sl_MIRQ        : out std_logic_vector (0 to C_SPLB_NUM_MASTERS-1);
--  -- Intc Interface Signals
        Intr           : in  std_logic_vector(C_NUM_INTR_INPUTS-1 downto 0);
        Irq            : out std_logic
    );

-------------------------------------------------------------------------------
-- Attributes
-------------------------------------------------------------------------------
  -- Fan-Out attributes for XST
    ATTRIBUTE MAX_FANOUT               : string;
    ATTRIBUTE MAX_FANOUT  of SPLB_Clk  : signal is "10000";
    ATTRIBUTE MAX_FANOUT  of SPLB_Rst  : signal is "10000";

-----------------------------------------------------------------
  -- Start of PSFUtil MPD attributes
-----------------------------------------------------------------
    -- SIGIS attribute for specifying clocks,interrupts,resets for EDK
    ATTRIBUTE IP_GROUP                    : string;
    ATTRIBUTE IP_GROUP of xps_intc        : entity is "LOGICORE";

    ATTRIBUTE IPTYPE                      : string;
    ATTRIBUTE IPTYPE of xps_intc          : entity is "PERIPHERAL";

    ATTRIBUTE HDL                         : string;
    ATTRIBUTE HDL of xps_intc             : entity is "VHDL";

    ATTRIBUTE STYLE                       : string;
    ATTRIBUTE STYLE of xps_intc           : entity is "HDL";

    ATTRIBUTE IMP_NETLIST                 : string;
    ATTRIBUTE IMP_NETLIST of xps_intc     : entity is "TRUE";

    ATTRIBUTE RUN_NGCBUILD                : string;
    ATTRIBUTE RUN_NGCBUILD of xps_intc    : entity is "TRUE";

    ATTRIBUTE ADDR_TYPE                   : string;
    ATTRIBUTE ADDR_TYPE of C_BASEADDR     : constant is "REGISTER";
    ATTRIBUTE ADDR_TYPE of C_HIGHADDR     : constant is "REGISTER";

    ATTRIBUTE ASSIGNMENT                  : string;
    ATTRIBUTE ASSIGNMENT of C_BASEADDR    : constant is "REQUIRE";
    ATTRIBUTE ASSIGNMENT of C_HIGHADDR    : constant is "REQUIRE";

    ATTRIBUTE SIGIS                       : string;
    ATTRIBUTE SIGIS of SPLB_Clk           : signal is "Clk";
    ATTRIBUTE SIGIS of SPLB_Rst           : signal is "Rst";


end xps_intc;

-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------
architecture imp of xps_intc is

    ---------------------------------------------------------------------------
    -- Component Declarations
    ---------------------------------------------------------------------------
    constant ZERO_ADDR_PAD : std_logic_vector(0 to 64-C_SPLB_AWIDTH-1) 
                             := (others => '0');
    constant ARD_ID_ARRAY : INTEGER_ARRAY_TYPE := (0 => 1);
    constant ARD_ADDR_RANGE_ARRAY : SLV64_ARRAY_TYPE 
                    := ( 
                         ZERO_ADDR_PAD & C_BASEADDR,
                         ZERO_ADDR_PAD & (C_BASEADDR or X"0000001F")
                       );
    constant ARD_NUM_CE_ARRAY : INTEGER_ARRAY_TYPE := (0 => 8);
    
    constant BUS2CORE_CLK_RATIO : integer := 1;

    ---------------------------------------------------------------------------
    -- Signal Declarations
    ---------------------------------------------------------------------------
    signal register_address : std_logic_vector(2 downto 0);
    signal read_data      : std_logic_vector(C_SPLB_NATIVE_DWIDTH-1 downto 0);
    signal write_data     : std_logic_vector(C_SPLB_NATIVE_DWIDTH-1 downto 0);

    signal bus2ip_clk          : std_logic;
    signal bus2ip_reset        : std_logic;
    signal bus2ip_addr         : std_logic_vector(0 to C_SPLB_AWIDTH-1);
    signal bus2ip_rnw          : std_logic;
    signal bus2ip_cs           : std_logic_vector(0 to ARD_ID_ARRAY'LENGTH-1);
    signal ip2bus_wrack        : std_logic;
    signal ip2bus_rdack        : std_logic;
    signal ip2bus_error        : std_logic;
    signal ip2bus_rdack_int    : std_logic;
    signal ip2bus_wrack_int    : std_logic;
    signal ip2bus_rdack_int_d1 : std_logic;
    signal ip2bus_wrack_int_d1 : std_logic;
    signal ip2bus_rdack_prev2  : std_logic;
    signal ip2bus_wrack_prev2  : std_logic;

    signal bus2ip_rdce : std_logic_vector(0 to calc_num_ce(ARD_NUM_CE_ARRAY)-1);
    signal bus2ip_wrce : std_logic_vector(0 to calc_num_ce(ARD_NUM_CE_ARRAY)-1);
    signal bus2ip_be   : std_logic_vector(0 to (C_SPLB_NATIVE_DWIDTH/8)-1);
    signal word_access : std_logic;

begin

    register_address <= bus2ip_addr(C_SPLB_AWIDTH-5 to C_SPLB_AWIDTH-3);

    -- Internal ack signals
    ip2bus_rdack_int <= bus2ip_rdce(0) or bus2ip_rdce(1) or bus2ip_rdce(2) or
                        bus2ip_rdce(3) or bus2ip_rdce(4) or bus2ip_rdce(5) or 
                        bus2ip_rdce(6) or bus2ip_rdce(7);
    ip2bus_wrack_int <= bus2ip_wrce(0) or bus2ip_wrce(1) or bus2ip_wrce(2) or 
                        bus2ip_wrce(3) or bus2ip_wrce(4) or bus2ip_wrce(5) or 
                        bus2ip_wrce(6) or bus2ip_wrce(7);

    -- Error signal generation
    word_access <= bus2ip_be(0) and bus2ip_be(1) and bus2ip_be(2) and 
                                    bus2ip_be(3);
    ip2bus_error <= not word_access;

    --------------------------------------------------------------------------
    -- Process DACK_DELAY_P for generating write and read data acknowledge 
    -- signals.
    --------------------------------------------------------------------------
    DACK_DELAY_P: process (Bus2IP_Clk) is
    begin
        if Bus2IP_Clk'event and Bus2IP_Clk='1' then
            if Bus2IP_Reset = RESET_ACTIVE then
                ip2bus_rdack_int_d1 <= '0';
                ip2bus_wrack_int_d1 <= '0';
                ip2bus_rdack        <= '0';
                ip2bus_wrack        <= '0';
            else
                ip2bus_rdack_int_d1 <= ip2bus_rdack_int;
                ip2bus_wrack_int_d1 <= ip2bus_wrack_int;
                ip2bus_rdack        <= ip2bus_rdack_prev2;
                ip2bus_wrack        <= ip2bus_wrack_prev2;
            end if;
        end if;
    end process DACK_DELAY_P;

    -- Detecting rising edge by creating one shot
    ip2bus_rdack_prev2 <= ip2bus_rdack_int and (not ip2bus_rdack_int_d1);
    ip2bus_wrack_prev2 <= ip2bus_wrack_int and (not ip2bus_wrack_int_d1);

   ---------------------------------------------------------------------------
   -- Component Instantiations
   ---------------------------------------------------------------------------
   -- Instantiating intc_core from xps_intc_v2_01_a library
   INTC_CORE_I : entity xps_intc_v2_01_a.intc_core
     generic map
     (
       C_DWIDTH          => C_SPLB_NATIVE_DWIDTH,
       C_NUM_INTR_INPUTS => C_NUM_INTR_INPUTS,
       C_KIND_OF_INTR    => C_KIND_OF_INTR,
       C_KIND_OF_EDGE    => C_KIND_OF_EDGE,
       C_KIND_OF_LVL     => C_KIND_OF_LVL,
       C_HAS_IPR         => C_HAS_IPR,
       C_HAS_SIE         => C_HAS_SIE,
       C_HAS_CIE         => C_HAS_CIE,
       C_HAS_IVR         => C_HAS_IVR,
       C_IRQ_IS_LEVEL    => C_IRQ_IS_LEVEL,
       C_IRQ_ACTIVE      => C_IRQ_ACTIVE
     )
     port map
     (
      -- Inputs
       Clk      => Bus2IP_Clk,
       Rst      => Bus2IP_Reset,
       Intr     => Intr,
       Reg_addr => register_address,
       Valid_rd => bus2ip_rdce,
       Valid_wr => bus2ip_wrce,
       Wr_data  => write_data,
      -- Outputs
       Rd_data  => read_data,
       Irq      => Irq
     );
   
   --Instantiating plbv46_slave_single from plbv46_slave_single_v1_01_a library
   PLBV46_I : entity plbv46_slave_single_v1_01_a.plbv46_slave_single
     generic map
     (
       C_ARD_ADDR_RANGE_ARRAY => ARD_ADDR_RANGE_ARRAY,
       C_ARD_NUM_CE_ARRAY     => ARD_NUM_CE_ARRAY,
       C_SPLB_P2P             => C_SPLB_P2P,
       C_BUS2CORE_CLK_RATIO   => BUS2CORE_CLK_RATIO,
       C_INCLUDE_DPHASE_TIMER => 1,
       C_SPLB_MID_WIDTH       => C_SPLB_MID_WIDTH,
       C_SPLB_NUM_MASTERS     => C_SPLB_NUM_MASTERS,
       C_SPLB_AWIDTH          => C_SPLB_AWIDTH,
       C_SPLB_DWIDTH          => C_SPLB_DWIDTH,
       C_SIPIF_DWIDTH         => C_SPLB_NATIVE_DWIDTH,
       C_FAMILY               => C_FAMILY
     )
     port map
     (
       -- System signals
       SPLB_Clk       => SPLB_Clk,
       SPLB_Rst       => SPLB_Rst,
       -- Bus Slave signals
       PLB_ABus       => PLB_ABus,
       PLB_UABus      => PLB_UABus,
       PLB_PAValid    => PLB_PAValid,
       PLB_SAValid    => PLB_SAValid,
       PLB_rdPrim     => PLB_rdPrim,
       PLB_wrPrim     => PLB_wrPrim,
       PLB_masterID   => PLB_masterID,
       PLB_abort      => PLB_abort,
       PLB_busLock    => PLB_busLock,
       PLB_RNW        => PLB_RNW,
       PLB_BE         => PLB_BE,
       PLB_MSize      => PLB_MSize,
       PLB_size       => PLB_size,
       PLB_type       => PLB_type,
       PLB_lockErr    => PLB_lockErr,
       PLB_wrDBus     => PLB_wrDBus,
       PLB_wrBurst    => PLB_wrBurst,
       PLB_rdBurst    => PLB_rdBurst,
       PLB_wrPendReq  => PLB_wrPendReq,
       PLB_rdPendReq  => PLB_rdPendReq,
       PLB_wrPendPri  => PLB_wrPendPri,
       PLB_rdPendPri  => PLB_rdPendPri,
       PLB_reqPri     => PLB_reqPri,
       PLB_TAttribute => PLB_TAttribute,
       -- Slave Response Signals
       Sl_addrAck     => Sl_addrAck,
       Sl_SSize       => Sl_SSize,
       Sl_wait        => Sl_wait,
       Sl_rearbitrate => Sl_rearbitrate,
       Sl_wrDAck      => Sl_wrDAck,
       Sl_wrComp      => Sl_wrComp,
       Sl_wrBTerm     => Sl_wrBTerm,
       Sl_rdDBus      => Sl_rdDBus,
       Sl_rdWdAddr    => Sl_rdWdAddr,
       Sl_rdDAck      => Sl_rdDAck,
       Sl_rdComp      => Sl_rdComp,
       Sl_rdBTerm     => Sl_rdBTerm,
       Sl_MBusy       => Sl_MBusy,
       Sl_MWrErr      => Sl_MWrErr,
       Sl_MRdErr      => Sl_MRdErr,
       Sl_MIRQ        => Sl_MIRQ,
       -- IP Interconnect (IPIC) port signals
       Bus2IP_Clk     => Bus2IP_Clk,
       Bus2IP_Reset   => Bus2IP_Reset,
       IP2Bus_Data    => read_data,
       IP2Bus_WrAck   => ip2bus_wrack,
       IP2Bus_RdAck   => ip2bus_rdack,
       IP2Bus_Error   => ip2bus_error,
       Bus2IP_Addr    => bus2ip_addr,
       Bus2IP_Data    => write_data,
       Bus2IP_RNW     => bus2ip_rnw,
       Bus2IP_BE      => bus2ip_be,
       Bus2IP_CS      => bus2ip_cs,
       Bus2IP_RdCE    => bus2ip_rdce,
       Bus2IP_WrCE    => bus2ip_wrce
     );

end imp;
