-------------------------------------------------------------------------------
-- intc_core - entity / architecture pair
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
-- Filename:        intc_core.vhd
-- Version:         v2.01a
-- Description:     Interrupt controller without a bus interface
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
--   NSK      2/23/2007        First version
-- ^^^^^^^
-- Version intc_core v1.00a functionality is based on intc_core v1.00d wherein 
-- the design is completed recoded for better readiabilty, save resources,
-- increase frequecny and remove the structural code.
-- ~~~~~~~
--   NSK      6/07/2007
-- ^^^^^^^
-- Correct the logic for generation of ivr_data_in. This is now depend on isr 
-- and ier. Removed irq_gen dependency on this signal.
-- The problem reported by Rick - When interrupt(2) and interrupt(3) are active
-- but only interrupt(3) is enabled. IVR reads 0x2 instead of 0x3.
-- ~~~~~~~
--   NSK      7/31/2007
-- ^^^^^^^
-- 1. Valid_rd and Valid_wr changed to 7-bit vector length.
-- 2. Deleted process decoding Reg_add to register_en. Removed signal 
--    register_en.
-- 3. Added signal read and used for generation of rd_data_int.
-- 4. Deleted the output ports Wr_ack & Rd_ack. Also the logic to generate 
--    these signals.
-- ~~~~~~~
--   NSK      8/10/2007
-- ^^^^^^^
-- Updated to fix CR #445886 (by Rick). IVR need to be 32-bit to work with the 
-- existing SW. Note that the reason of changing 32-bit register to width
-- equal to C_NUM_INTR is to save resources (Flip Flops).
-- 1. Signals mer, ipr & ivr is changed to width equal to C_DWIDTH from 
--    REG_WIDTH.
-- 2. Added signals ier_out & isr_out of width equal to C_DWIDTH.
-- 3. Replaced the two generate statement MER_EQ_GEN & MER_NOT_EQ_GEN with 
--    the direct assignment as mer is of width equal to C_DWIDTH.
-- 4. Added two generate blocks for signals ier_out & isr_out 
--    REG_OUT_GEN_DWIDTH_NOT_EQ_NUM_INTR (C_NUM_INTR_INPUTS /= C_DWIDTH) & 
--    REG_OUT_GEN_DWIDTH_EQ_NUM_INTR (C_NUM_INTR_INPUTS = C_DWIDTH).
-- 5. In the process IPR_P generating ipr; isr & ier changed to isr_out & 
--    ier_out respectively.
-- 6. In the generate block IVR_GEN signal ivr_data_in changed to width equal 
--    to C_DWIDTH.
-- 7. In the process IVR_DATA_GEN_P variable ivr_in changed to width equal 
--    to C_DWIDTH.
-- 8. Removed the two different generate statement (OUTPUT_DATA_ONE_INTR_GEN & 
--    OUTPUT_DATA_MULTI_INTR_GEN) for generating rd_data_int.
-- 9. Rd_data is directly generate in process OUTPUT_DATA_GEN_P; not 
--    not depending on rd_data_int.
-- 10. Removed the unused signal rd_data_int.
-- ~~~~~~~
--   NSK      9/13/2008           version v2.00.a
-- ^^^^^^^
--   NSK      9/13/2008
-- ^^^^^^^
-- 1. Rolled to revision v2.00.a.
-- 2. Changed the library proc_common from v2_00_a to v3_00_a.
-- 3. Fixed CR #442790 to support edge on Irq.
--    I.   Added generic C_IRQ_IS_LEVEL
--         a. If set to 0 generates edge interrupt
--         b. If set to 1 generates level interrupt
--    II.  Changed the definition of generic C_IRQ_ACTIVE
--         a. Defines the edge for output interrupt if C_IRQ_IS_LEVEL=0 
--            -- "0" = FALLING EDGE
--            -- "1" = RISING EDGE
--         b. Defines the level for output interrupt if C_IRQ_IS_LEVEL=1 
--            -- "0" = LOW LEVEL
--            -- "1" = HIGH LEVEL
--    III. Added generic C_IRQ_IS_LEVEL in generic map of instance INTC_CORE_I 
--         for component "intc_core" from library "xps_intc_v2_00_a."
--    IV.  Added "C_IRQ_IS_LEVEL" in Definition of Generics section in 
--         comments.
--    V.   Modified the logic for edge generation on Irq.
--         a. Variable "irq_int" in process "IRQ_GEN_P" is changed to 
--            irq_gen_int.
--         b. Added to seperate generate statement for generating Irq
--            -- IRQ_LEVEL_GEN: if (C_IRQ_IS_LEVEL = 1)
--            -- IRQ_EDGE_GEN: if (C_IRQ_IS_LEVEL = 0)
-- ~~~~~~~
--   NSK      9/15/2008
-- ^^^^^^^
-- Removed unused parameter C_FAMILY.
-- ~~~~~~~
--   NSK      9/17/2008
-- ^^^^^^^
-- Update for linting: -
-- 1. Removed unused constant "REG_WIDTH" & function "get_reg_width".
-- 2. Process in generate block "RISING_EDGE_GEN" & "FALLING_EDGE_GEN" given 
--    two different names "REG_INTR_RISE_P" & "REG_INTR_FALL_P" respectively.
-- 3. Corrected the same name conflict in the generate block "SIE_GEN" & 
--    "CIE_GEN": -
--    a. Generate label in generate block "SIE_GEN" is chagned from "SIE_BIT" 
--       to "SIE_BIT_GEN".
--    b. Generate label in generate block "CIE_GEN" is chagned from "SIE_BIT" 
--       to "CIE_BIT_GEN".
-- ~~~~~~~
--   NSK      9/30/2008
-- ^^^^^^^
-- Type changed for the parameter C_DWIDTH & C_NUM_INTR_INPUTS from positive 
-- to integer to have consistency with xps_intc.vhd.
-- ~~~~~~~
--   NSK      10/01/2008
-- ^^^^^^^
-- Updated the latest Copyright and removed XCS label.
-- ~~~~~~~
--   NSK      11/17/2008
-- ^^^^^^^
-- Update to fix IR #496531 - Irq toggles when C_IRQ_IS_LEVEL = 0
-- 1. Seperate generate blocks
--    a. ONE_INTR_IRQ_EDGE_GEN when C_IRQ_IS_LEVEL=0 & C_NUM_INTR_INPUTS=1.
--    b. MULTI_INTR_IRQ_EDGE_GEN when C_IRQ_IS_LEVEL=0 & C_NUM_INTR_INPUTS>1.
-- 2. Behavior of Irq is changed from pulse to a signal kind of level but goes
--    LOW when interrupt is ACKNOWLEDGED or DISABLED.
-- 3. For MULTI_INTR_IRQ_EDGE_GEN: -
--    a. Signal "active_intr" ANDing of ISE and IER detects active interrupts.
--    b. Signal "active_intr_d1" registers "active_intr".
--    c. Signal "deactive_intr_edge" detects the falling edge of "active_intr".
--       This means either the interrupt is acknowledge or disabled.
--    d. Signal "ack_disabled_detected" is ORed of "deactive_intr_edge". This
--       means any one of the active interrupt is acknowledge or disabled. 
--    e. Signal "irq_int" goes to RESET when "ack_disabled_detected"=HIGH
--4. For ONE_INTR_IRQ_EDGE_GEN: -
--   Behavior is same as C_IRQ_IS_LEVEL=1 & C_NUM_INTR_INPUTS=1
-- ~~~~~~~
--   NSK      12/10/2008
-- ^^^^^^^
-- Update to fix IR #497895 - IRQ o/p for edge based interrupts does not 
-- toggle to default value after a clock edge.
-- 1. Removed the logic added as above (Date - 11/17/2008) to fix IR #496531.
-- 2. Used generate block "ACK_OR_GEN" to generate the "ack_or" signal to 
--    find if the current interrupt is acknowleged.
-- 3. Used state machine "GEN_CS_P" to generate "Irq".
-- ~~~~~~~--
--   NSK      12/11/2008
-- ^^^^^^^
-- Update for compile errors. 
-- ~~~~~~~--
--   NSK      01/05/2009
-- ^^^^^^^
-- Update to fix IR #501183 - XPS INTC sometimes misses falling edge 
--                            interrupts, needs input synchronization
-- Below are the updates in generate block - INTR_DETECT_GEN/EDGE_DETECT_GEN
-- 1. Added signals
--    a. intr_sync - Assigned HIGH/LOW (depend on C_KIND_OF_EDGE) on event on 
--                   Intr (used as clock)
--    b. intr_p1   - register of intr_sync (Clk - used as clock)
--    c. intr_p2   - register of intr_p1 (Clk - used as clock)
-- 2. Assignment for intr_d1(i) is changed to intr_p2(i) (from Intr(i))
-- ~~~~~~~
--   NSK      01/07/2009
-- ^^^^^^^
-- Corrected:- 
-- For intr_edge(i) assignment Intr(old) is changed to intr_p2(new).
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.CONV_STD_LOGIC_VECTOR;

library proc_common_v3_00_a;
-------------------------------------------------------------------------
-- Package proc_common_pkg is used because it contains the RESET_ACTIVE 
-- constant used to assign reset as active high status.
-------------------------------------------------------------------------
use proc_common_v3_00_a.proc_common_pkg.RESET_ACTIVE;

-------------------------------------------------------------------------------
-- Definition of Generics:
--  -- Intc Parameters
--       C_DWIDTH              -- Data bus width
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
-------------------------------------------------------------------------------
-- Definition of Ports:
--  -- Clocks and reset
--       Clk      -- Clock
--       Rst      -- Reset
--  -- Intc Interface Signals
--       Intr     -- Input Interruput request
--       Reg_addr -- Address bus
--       Valid_rd -- Read
--       Valid_wr -- Write
--       Wr_data  -- Write data bus
--       Rd_data  -- Read data bus
--       Irq      -- Output Interruput request
-------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- Entity
------------------------------------------------------------------------------
entity intc_core is
    generic
    (
      C_DWIDTH          : integer := 32;
      C_NUM_INTR_INPUTS : integer range 1 to 32 := 2;
      C_KIND_OF_INTR    : std_logic_vector(31 downto 0) 
                          := "11111111111111111111111111111111";
      C_KIND_OF_EDGE    : std_logic_vector(31 downto 0) 
                          := "11111111111111111111111111111111";
      C_KIND_OF_LVL     : std_logic_vector(31 downto 0) 
                          := "11111111111111111111111111111111";
      C_HAS_IPR         : integer range 0 to 1 := 1;
      C_HAS_SIE         : integer range 0 to 1 := 1;
      C_HAS_CIE         : integer range 0 to 1 := 1;
      C_HAS_IVR         : integer range 0 to 1 := 1;
      C_IRQ_IS_LEVEL    : integer range 0 to 1 := 1;
      C_IRQ_ACTIVE      : std_logic := '1'
    );
    port
    (
      -- Inputs
      Clk      : in  std_logic;
      Rst      : in  std_logic;
      Intr     : in  std_logic_vector(C_NUM_INTR_INPUTS - 1 downto 0);
      Reg_addr : in  std_logic_vector(2 downto 0);
      Valid_rd : in  std_logic_vector(0 to 7);
      Valid_wr : in  std_logic_vector(0 to 7);
      Wr_data  : in  std_logic_vector(C_DWIDTH - 1 downto 0);
      -- Outputs
      Rd_data  : out std_logic_vector(C_DWIDTH - 1 downto 0);
      Irq      : out std_logic
    );

-------------------------------------------------------------------------------
-- Attributes
-------------------------------------------------------------------------------

attribute buffer_type: string; 
attribute buffer_type of Intr: signal is "none";

end intc_core;

------------------------------------------------------------------------------
-- Architecture
------------------------------------------------------------------------------
architecture imp of intc_core is

    -- Signal declaration
    -- ==================
    signal wr_data_int : std_logic_vector(C_NUM_INTR_INPUTS - 1 downto 0);
    signal mer_int     : std_logic_vector(1 downto 0);
    signal mer         : std_logic_vector(C_DWIDTH - 1 downto 0);
    signal sie         : std_logic_vector(C_NUM_INTR_INPUTS - 1 downto 0);
    signal cie         : std_logic_vector(C_NUM_INTR_INPUTS - 1 downto 0);
    signal iar         : std_logic_vector(C_NUM_INTR_INPUTS - 1 downto 0);
    signal ier         : std_logic_vector(C_NUM_INTR_INPUTS - 1 downto 0);
    signal isr_en      : std_logic;
    signal hw_intr     : std_logic_vector(C_NUM_INTR_INPUTS - 1 downto 0);
    signal isr_data_in : std_logic_vector(C_NUM_INTR_INPUTS - 1 downto 0);
    signal isr         : std_logic_vector(C_NUM_INTR_INPUTS - 1 downto 0);
    signal ipr         : std_logic_vector(C_DWIDTH - 1 downto 0);
    signal ivr         : std_logic_vector(C_DWIDTH - 1 downto 0);
    signal irq_gen     : std_logic;
    signal read        : std_logic;
    signal ier_out     : std_logic_vector(C_DWIDTH - 1 downto 0);
    signal isr_out     : std_logic_vector(C_DWIDTH - 1 downto 0);
    signal ack_or      : std_logic;


-- Begin of architecture
begin


    read <= Valid_rd(0) or Valid_rd(1) or Valid_rd(2) or Valid_rd(6) or 
            Valid_rd(7);


    --------------------------------------------------------------------------
    --                      GENERATING ALL REGISTERS
    --------------------------------------------------------------------------
    wr_data_int <= Wr_data(C_NUM_INTR_INPUTS - 1 downto 0);

    --------------------------------------------------------------------------
    -- Process MER_ME_P for MER ME bit generation
    --------------------------------------------------------------------------
    MER_ME_P: process (Clk) is
    begin
        if (Clk'event and Clk = '1') then
            if (Rst = RESET_ACTIVE) then
                mer_int(0) <= '0';
            elsif (Valid_wr(7) = '1') then
                mer_int(0) <= Wr_data(0);
            end if;
        end if;
    end process MER_ME_P;

    --------------------------------------------------------------------------
    -- Process MER_HIE_P for generating MER HIE bit
    --------------------------------------------------------------------------
    MER_HIE_P: process (Clk) is
    begin
        if (Clk'event and Clk = '1') then
            if (Rst = RESET_ACTIVE) then
                mer_int(1) <= '0';
            elsif ((Valid_wr(7) = '1') and (mer_int(1) = '0')) then
                mer_int(1) <= Wr_data(1);
            end if;
        end if;
    end process MER_HIE_P;

    mer(1 downto 0) <= mer_int;
    mer(C_DWIDTH - 1 downto 2) <= (others => '0');


    ----------------------------------------------------------------------
    -- Generate SIE if (C_HAS_SIE = 1)
    ----------------------------------------------------------------------
    SIE_GEN: if (C_HAS_SIE = 1) generate
        SIE_BIT_GEN : for i in 0 to (C_NUM_INTR_INPUTS - 1) generate
            --------------------------------------------------------------
            -- Process SIE_P for generating SIE register
            --------------------------------------------------------------
            SIE_P: process (Clk) is
            begin
                if (Clk'event and Clk = '1') then
                    if ((Rst = RESET_ACTIVE) or (sie(i) = '1')) then
                        sie(i) <= '0';
                    elsif (Valid_wr(4) = '1') then
                        sie(i) <= wr_data_int(i);
                    end if;
                end if;
            end process SIE_P;
        end generate SIE_BIT_GEN;
    end generate SIE_GEN;

    ----------------------------------------------------------------------
    -- Assign sie_out ALL ZEROS if (C_HAS_SIE = 0)
    ----------------------------------------------------------------------
    SIE_NO_GEN: if (C_HAS_SIE = 0) generate
        sie <= (others => '0');
    end generate SIE_NO_GEN;

    ----------------------------------------------------------------------
    -- Generate CIE if (C_HAS_CIE = 1)
    ----------------------------------------------------------------------
    CIE_GEN: if (C_HAS_CIE = 1) generate
        CIE_BIT_GEN : for i in 0 to (C_NUM_INTR_INPUTS - 1) generate
            ------------------------------------------------------------------
            -- Process CIE_P for generating CIE register
            ------------------------------------------------------------------
            CIE_P: process (Clk) is
            begin
                if (Clk'event and Clk = '1') then
                    if ((Rst = RESET_ACTIVE) or (cie(i) = '1')) then
                        cie(i) <= '0';
                    elsif (Valid_wr(5) = '1') then
                        cie(i) <= wr_data_int(i);
                    end if;
                end if;
            end process CIE_P;
        end generate CIE_BIT_GEN;
    end generate CIE_GEN;

    ----------------------------------------------------------------------
    -- Assign cie_out ALL ZEROS if (C_HAS_CIE = 0)
    ----------------------------------------------------------------------
    CIE_NO_GEN: if (C_HAS_CIE = 0) generate
        cie <= (others => '0');
    end generate CIE_NO_GEN;

    -- Generating write enable & data input for ISR
    isr_en      <= mer(1) or Valid_wr(0);
    isr_data_in <= hw_intr when mer(1) = '1' else 
                   Wr_data(C_NUM_INTR_INPUTS - 1 downto 0);

    --------------------------------------------------------------------------
    -- Generate Registers of width equal C_NUM_INTR_INPUTS
    --------------------------------------------------------------------------
    REG_GEN : for i in 0 to (C_NUM_INTR_INPUTS - 1) generate
        ----------------------------------------------------------------------
        -- Process IAR_BIT_P for generating IAR register
        ----------------------------------------------------------------------
        IAR_BIT_P: process (Clk) is
        begin
            if (Clk'event and Clk = '1') then
                if ((Rst = RESET_ACTIVE) or (iar(i) = '1')) then
                    iar(i) <= '0';
                elsif (Valid_wr(3) = '1') then
                    iar(i) <= wr_data_int(i);
                end if;
            end if;
        end process IAR_BIT_P;

        ----------------------------------------------------------------------
        -- Process IER_BIT_P for generating IER register
        ----------------------------------------------------------------------
        IER_BIT_P: process (Clk) is
        begin
            if (Clk'event and Clk = '1') then
                if ((Rst = RESET_ACTIVE) or (cie(i) = '1')) then
                    ier(i) <= '0';
                elsif (sie(i) = '1') then
                    ier(i) <= '1';
                elsif (Valid_wr(2) = '1') then
                    ier(i) <= wr_data_int(i);
                end if;
            end if;
        end process IER_BIT_P;

        ----------------------------------------------------------------------
        -- Process ISR_P for generating ISR register
        ----------------------------------------------------------------------
        ISR_P: process (Clk) is
        begin
            if (Clk'event and Clk = '1') then
                if ((Rst = RESET_ACTIVE) or (iar(i) = '1')) then
                    isr(i) <= '0';
                elsif (isr_en = '1') then
                   isr(i) <= isr_data_in(i);
                end if;
            end if;
        end process ISR_P;

    end generate REG_GEN;

    -----------------------------------------------------------------------
    -- Generating ier_out & isr_out if C_NUM_INTR_INPUTS /= C_DWIDTH
    -----------------------------------------------------------------------
    REG_OUT_GEN_DWIDTH_NOT_EQ_NUM_INTR: if (C_NUM_INTR_INPUTS /= C_DWIDTH) 
    generate
        ier_out(C_NUM_INTR_INPUTS - 1 downto 0) <= ier;
        ier_out(C_DWIDTH - 1 downto C_NUM_INTR_INPUTS) <= (others => '0');

        isr_out(C_NUM_INTR_INPUTS - 1 downto 0) <= isr;
        isr_out(C_DWIDTH - 1 downto C_NUM_INTR_INPUTS) <= (others => '0');
    end generate REG_OUT_GEN_DWIDTH_NOT_EQ_NUM_INTR;

    ------------------------------------------------------------------------
    -- Generating ier_out & isr_out if C_NUM_INTR_INPUTS = C_DWIDTH
    ------------------------------------------------------------------------
    REG_OUT_GEN_DWIDTH_EQ_NUM_INTR: if (C_NUM_INTR_INPUTS = C_DWIDTH) 
    generate
        ier_out <= ier;
        isr_out <= isr;
    end generate REG_OUT_GEN_DWIDTH_EQ_NUM_INTR;

    --------------------------------------------------------------------------
    -- Generate IPR if (C_HAS_IPR = 1)
    --------------------------------------------------------------------------
    IPR_GEN: if (C_HAS_IPR = 1) generate
        ----------------------------------------------------------------------
        -- Process IPR_P for generating IPR register
        ----------------------------------------------------------------------
        IPR_P: process (Clk) is
        begin
            if (Clk'event and Clk = '1') then
                if (Rst = RESET_ACTIVE) then
                    ipr <= (others => '0');
                else
                    ipr <= isr_out and ier_out;
                end if;
            end if;
        end process IPR_P;
    end generate IPR_GEN;

    --------------------------------------------------------------------------
    -- Assign IPR ALL ZEROS if (C_HAS_IPR = 0)
    --------------------------------------------------------------------------
    IPR_NO_GEN: if (C_HAS_IPR = 0) generate
        ipr <= (others => '0');
    end generate IPR_NO_GEN;

    --------------------------------------------------------------------------
    -- Generate IVR if (C_HAS_IVR = 1)
    --------------------------------------------------------------------------
    IVR_GEN: if (C_HAS_IVR = 1) generate
        signal ivr_data_in : std_logic_vector(C_DWIDTH - 1 downto 0);
    begin
        ----------------------------------------------------------------------
        -- Process IVR_DATA_GEN_P for generating interrupt vector address
        ----------------------------------------------------------------------
        IVR_DATA_GEN_P: process (isr, ier)
        variable ivr_in : std_logic_vector(C_DWIDTH - 1 downto 0)
	                               := (others => '1');
        begin
            for i in 0 to (C_NUM_INTR_INPUTS - 1) loop
                if ((isr(i) = '1') and (ier(i) = '1')) then
                    ivr_in := CONV_STD_LOGIC_VECTOR(i, C_DWIDTH);
                    exit;
                else
                    ivr_in := (others => '1');
                end if;
            end loop;
            ivr_data_in <= ivr_in;
        end process IVR_DATA_GEN_P;

        ----------------------------------------------------------------------
        -- Process IVR_P for generating IVR register
        ----------------------------------------------------------------------
        IVR_P: process (Clk) is
        begin
            if (Clk'event and Clk = '1') then
                if (Rst = RESET_ACTIVE) then
                    ivr <= (others => '1');
                else
                    ivr <= ivr_data_in;
                end if;
            end if;
        end process IVR_P;
    end generate IVR_GEN;

    --------------------------------------------------------------------------
    -- Assign IVR ALL ZEROS if (C_HAS_IVR = 0)
    --------------------------------------------------------------------------
    IVR_NO_GEN: if (C_HAS_IVR = 0) generate
        ivr <= (others => '1');
    end generate IVR_NO_GEN;

    --------------------------------------------------------------------------
    --                      DETECTING HW INTERRUPT
    --------------------------------------------------------------------------
    ---------------------------------------------------------------------------
    -- Detecting the interrupts
    ---------------------------------------------------------------------------
    INTR_DETECT_GEN: for i in 0 to C_NUM_INTR_INPUTS - 1 generate
        -----------------------------------------------------------------------
        -- Generating the edge trigeered interrupts if C_KIND_OF_INTR(i) = 1
        -----------------------------------------------------------------------
        EDGE_DETECT_GEN: if (C_KIND_OF_INTR(i) = '1') generate
            signal intr_d1   : std_logic_vector(C_NUM_INTR_INPUTS - 1 downto 0);
            signal intr_edge : std_logic_vector(C_NUM_INTR_INPUTS - 1 downto 0);
            signal intr_sync : std_logic_vector(C_NUM_INTR_INPUTS - 1 downto 0);
            signal intr_p1   : std_logic_vector(C_NUM_INTR_INPUTS - 1 downto 0);
            signal intr_p2   : std_logic_vector(C_NUM_INTR_INPUTS - 1 downto 0);
        begin
            -------------------------------------------------------------------
            -- Generating the rising edge interrupts if C_KIND_OF_EDGE(i) = 1
            -------------------------------------------------------------------
            RISING_EDGE_GEN: if (C_KIND_OF_EDGE(i) = '1') generate
                ---------------------------------------------------------------
                -- Process SYNC_INTR_RISE_P to synchronize the interrupt signal
                ---------------------------------------------------------------
                SYNC_INTR_RISE_P : process (Rst, Intr, iar) is
                begin
                    if ((Rst = RESET_ACTIVE) or (iar(i) = '1')) then
                        intr_sync(i) <= '0';
                    elsif(Intr(i)'event and Intr(i)='1') then
                        intr_sync(i) <= '1';
                    end if;
                end process SYNC_INTR_RISE_P;

                ---------------------------------------------------------------
                -- Process REG_INTR_P to regiter the interrupt signal
                ---------------------------------------------------------------
                REG_INTR_RISE_P : process (Clk) is
                begin
                    if(Clk'event and Clk='1') then
                        if (Rst = RESET_ACTIVE) then
                            intr_p1(i) <= '0';
                            intr_p2(i) <= '0';
                            intr_d1(i) <= '1';
                        else
                            intr_p1(i) <= intr_sync(i);
                            intr_p2(i) <= intr_p1(i);
                            intr_d1(i) <= intr_p2(i);
                        end if;
                    end if;
                end process REG_INTR_RISE_P;

                -- Creating one-shot rising edge triggered interrupts
                intr_edge(i) <= '1' when ( (intr_p2(i) = '1') and 
                                           (intr_d1(i) = '0') ) 
                                 else '0';
            end generate RISING_EDGE_GEN;
        
            -------------------------------------------------------------------
            -- Generating the falling edge interrupts if C_KIND_OF_EDGE(i) = 0
            -------------------------------------------------------------------
            FALLING_EDGE_GEN: if (C_KIND_OF_EDGE(i) = '0') generate
                ---------------------------------------------------------------
                -- Process SYNC_INTR_FALL_P to synchronize the interrupt signal
                ---------------------------------------------------------------
                SYNC_INTR_FALL_P : process (Rst, Intr, iar) is
                begin
                    if ((Rst = RESET_ACTIVE) or (iar(i) = '1')) then
                        intr_sync(i) <= '1';
                    elsif(Intr(i)'event and Intr(i)='0') then
                        intr_sync(i) <= '0';
                    end if;
                end process SYNC_INTR_FALL_P;

                ---------------------------------------------------------------
                -- Process REG_INTR_P to regiter the interrupt signal
                ---------------------------------------------------------------
                REG_INTR_FALL_P : process (Clk) is
                begin
                    if(Clk'event and Clk='1') then
                        if (Rst = RESET_ACTIVE) then
                            intr_p1(i) <= '1';
                            intr_p2(i) <= '1';
                            intr_d1(i) <= '0';
                        else
                            intr_p1(i) <= intr_sync(i);
			    intr_p2(i) <= intr_p1(i);
                            intr_d1(i) <= intr_p2(i);
                        end if;
                    end if;
                end process REG_INTR_FALL_P;
            
                -- Creating one-shot falling edge triggered interrupts
                intr_edge(i) <= '1' when ( (intr_p2(i) = '0') and 
                                           (intr_d1(i) = '1') ) 
                                  else '0';
            end generate FALLING_EDGE_GEN;

            ------------------------------------------------------------------
            -- Process DETECT_INTR_P to generate the edge trigeered interrupts
            ------------------------------------------------------------------
            DETECT_INTR_P : process (Clk) is
            begin
                if(Clk'event and Clk='1') then
                    if ((Rst = RESET_ACTIVE) or (iar(i) = '1')) then
                        hw_intr(i) <= '0';
                    elsif (intr_edge(i) = '1') then
                        hw_intr(i) <= '1';
                    end if;
                end if;
            end process DETECT_INTR_P;
        end generate EDGE_DETECT_GEN;

        ----------------------------------------------------------------------
        -- Generating the Level trigeered interrupts if C_KIND_OF_INTR(i) = 0
        ----------------------------------------------------------------------
        LVL_DETECT_GEN: if (C_KIND_OF_INTR(i) = '0') generate
            ------------------------------------------------------------------
            -- Generating the active high interrupts if C_KIND_OF_LVL(i) = 1
            ------------------------------------------------------------------
            ACTIVE_HIGH_GEN: if (C_KIND_OF_LVL(i) = '1') generate
                --------------------------------------------------------------
                -- Process ACTIVE_HIGH_LVL_P to generate hw_intr (active high)
                --------------------------------------------------------------
                ACTIVE_HIGH_LVL_P : process (Clk) is
                begin
                    if (Clk'event and Clk = '1') then
                        if ((Rst = RESET_ACTIVE) or (iar(i) = '1')) then
                            hw_intr(i) <= '0';
                        elsif(Intr(i) = '1') then
                            hw_intr(i) <= '1';
                        end if;
                    end if;
                end process ACTIVE_HIGH_LVL_P;
            end generate ACTIVE_HIGH_GEN;
            ------------------------------------------------------------------
            -- Generating the active low interrupts if C_KIND_OF_LVL(i) = 0
            ------------------------------------------------------------------
            ACTIVE_LOW_GEN: if (C_KIND_OF_LVL(i) = '0') generate
                --------------------------------------------------------------
                -- Process ACTIVE_LOW_LVL_P to generate hw_intr (active low)
                --------------------------------------------------------------
                ACTIVE_LOW_LVL_P : process (Clk) is
                begin
                    if (Clk'event and Clk = '1') then
                        if ((Rst = RESET_ACTIVE) or (iar(i) = '1')) then
                            hw_intr(i) <= '0';
                        elsif(Intr(i) = '0') then
                            hw_intr(i) <= '1';
                        end if;
                    end if;
                end process ACTIVE_LOW_LVL_P;
            end generate ACTIVE_LOW_GEN;
        end generate LVL_DETECT_GEN;

        -----------------------------------------------------------------------
        -- Generating All Interrupr Zero if C_KIND_OF_INTR(i) /= 1 or 0
        -----------------------------------------------------------------------
        NO_DETECT_GEN: if ( (C_KIND_OF_INTR(i) /= '1') and 
                            (C_KIND_OF_INTR(i) /= '0') )
                       generate
            hw_intr(i) <= '0';
        end generate NO_DETECT_GEN;

    end generate INTR_DETECT_GEN;

    --------------------------------------------------------------------------
    -- Checking Active Interrupt/Interrupts
    --------------------------------------------------------------------------
    IRQ_ONE_INTR_GEN: if (C_NUM_INTR_INPUTS = 1) generate
        irq_gen <= isr(0) and ier(0);
    end generate IRQ_ONE_INTR_GEN;

    IRQ_MULTI_INTR_GEN: if (C_NUM_INTR_INPUTS > 1) generate
        --------------------------------------------------------------
        -- Process IRQ_GEN_P to generate irq_gen
        --------------------------------------------------------------
        IRQ_GEN_P: process (isr, ier)
            variable irq_gen_int : std_logic := '0';
        begin
            irq_gen_int := isr(0) and ier(0);
            for i in 1 to (isr'length - 1) loop
                irq_gen_int := irq_gen_int or (isr(i) and ier(i));
            end loop;
            irq_gen <= irq_gen_int;
        end process IRQ_GEN_P;
    end generate IRQ_MULTI_INTR_GEN;


    --------------------------------------------------------------------------
    -- Generating LEVEL interrupt if C_IRQ_IS_LEVEL = 1
    --------------------------------------------------------------------------
    IRQ_LEVEL_GEN: if (C_IRQ_IS_LEVEL = 1) generate

        --------------------------------------------------------------------
        -- Process IRQ_LEVEL_P for generating LEVEL interrupt 
        --------------------------------------------------------------------
        IRQ_LEVEL_P: process (Clk) is
        begin
            if(Clk'event and Clk = '1') then
                if ((Rst = RESET_ACTIVE) or (irq_gen = '0')) then
                    Irq <= not C_IRQ_ACTIVE;
                elsif ((irq_gen = '1') and (mer(0) = '1')) then
                    Irq <= C_IRQ_ACTIVE;
                end if;
            end if;
        end process IRQ_LEVEL_P;

    end generate IRQ_LEVEL_GEN;



    --------------------------------------------------------------------------
    -- Generating ack_or for edge output interrupt (if C_IRQ_IS_LEVEL = 0)
    --------------------------------------------------------------------------
    ACK_OR_GEN: if (C_IRQ_IS_LEVEL = 0) generate

        ----------------------------------------------------------------------
        -- Generating ack_or for C_NUM_INTR_INPUTS = 1
        ----------------------------------------------------------------------
        ACK_OR_ONE_INTR_GEN: if (C_NUM_INTR_INPUTS = 1) generate
            ack_or <= iar(0);
        end generate ACK_OR_ONE_INTR_GEN;

        ----------------------------------------------------------------------
        -- Generating ack_or for C_NUM_INTR_INPUTS > 1
        ----------------------------------------------------------------------
        ACK_OR_MULTI_INTR_GEN: if (C_NUM_INTR_INPUTS > 1) generate

	    --------------------------------------------------------------
	    -- Process ACK_OR_GEN_P to generate ack_or (ORed Acks)
	    --------------------------------------------------------------
	    ACK_OR_GEN_P: process (iar)
	        variable ack_or_int : std_logic := '0';
	    begin
	        ack_or_int := iar(0);
	        for i in 1 to (iar'length - 1) loop
	            ack_or_int := ack_or_int or (iar(i));
	        end loop;
	        ack_or <= ack_or_int;
	    end process ACK_OR_GEN_P;

        end generate ACK_OR_MULTI_INTR_GEN;

    end generate ACK_OR_GEN;

    --------------------------------------------------------------------------
    -- Generating EDGE interrupt if C_IRQ_IS_LEVEL = 0
    --------------------------------------------------------------------------
    IRQ_EDGE_GEN: if (C_IRQ_IS_LEVEL = 0) generate

        -- Type declaration
	type STATE_TYPE is (IDLE, GEN_PULSE, WAIT_ACK);
	-- Signal declaration
        signal current_state : STATE_TYPE;
        signal irq_int       : std_logic;

    begin

        --------------------------------------------------------------
        --The sequential process below maintains the current_state
        --------------------------------------------------------------
        GEN_CS_P : process (Clk)
        begin
            if(Clk'event and Clk='1') then
                if (Rst = '1') then
                    current_state <= IDLE;
                else
                    case current_state is
                        when IDLE => if ((irq_gen='1') and (mer(0)='1')) then
                                         current_state <= GEN_PULSE;
                                     else
                                         current_state <= IDLE;
                                     end if;
                        when GEN_PULSE => current_state <= WAIT_ACK;
                        when WAIT_ACK  => if (ack_or = '1') then
                                              current_state <= IDLE;
                                          else
                                              current_state <= WAIT_ACK;
                                          end if;
                    end case;
                end if;
            end if;
        end process GEN_CS_P;


        Irq <= C_IRQ_ACTIVE when (current_state = GEN_PULSE) else 
               (not C_IRQ_ACTIVE);

    end generate IRQ_EDGE_GEN;


    ------------------------------------------------------------------------
    -- Process OUTPUT_DATA_GEN_P for generating Rd_data
    ------------------------------------------------------------------------
    OUTPUT_DATA_GEN_P: process (read, Reg_addr, isr_out, ipr, ier_out, ivr, 
                                mer) is
    begin
        if (read = '1') then
            case Reg_addr is
                when "000"  => Rd_data <= isr_out; -- ISR (R/W)
                when "001"  => Rd_data <= ipr;     -- IPR (Read only)
                when "010"  => Rd_data <= ier_out; -- IER (R/W)
                when "110"  => Rd_data <= ivr;     -- IVR (Read only)
                when "111"  => Rd_data <= mer;     -- MER (R/W)
                               -- IAR, SIE, CIE (Write only)
                when others => Rd_data <= (others => '0');
            end case;
        else
            Rd_data <= (others => '0');
        end if;
    end process OUTPUT_DATA_GEN_P;

end imp;
