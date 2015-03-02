------------------------------------------------------------------------------
--
--   This vhdl module is a template for creating IP testbenches using the IBM
--   BFM toolkits. It provides a fixed interface to the subsystem testbench.
--
--   DO NOT CHANGE THE entity name, architecture name, generic parameter
--   declaration or port declaration of this file. You may add components,
--   instances, constants, signals, etc. as you wish.
--
--   See IBM Bus Functional Model Toolkit User's Manual for more information
--   on the BFMs.
--
------------------------------------------------------------------------------
-- plb_hthreads_timer_tb.vhd - entity/architecture pair
------------------------------------------------------------------------------
--
-- ***************************************************************************
-- ** Copyright (c) 1995-2008 Xilinx, Inc.  All rights reserved.            **
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
-- Filename:          plb_hthreads_timer_tb.vhd
-- Version:           1.00.a
-- Description:       IP testbench
-- Date:              Mon Jun 29 12:13:24 2009 (by Create and Import Peripheral Wizard)
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

library plb_hthreads_timer_v1_00_a;

--USER libraries added here

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------

entity plb_hthreads_timer_tb is

  ------------------------------------------
  -- DO NOT CHANGE THIS GENERIC DECLARATION
  ------------------------------------------
  generic
  (
    -- Bus protocol parameters, do not add to or delete
    C_BASEADDR                     : std_logic_vector     := X"FFFFFFFF";
    C_HIGHADDR                     : std_logic_vector     := X"00000000";
    C_SPLB_AWIDTH                  : integer              := 32;
    C_SPLB_DWIDTH                  : integer              := 128;
    C_SPLB_NUM_MASTERS             : integer              := 8;
    C_SPLB_MID_WIDTH               : integer              := 3;
    C_SPLB_NATIVE_DWIDTH           : integer              := 32;
    C_SPLB_P2P                     : integer              := 0;
    C_SPLB_SUPPORT_BURSTS          : integer              := 0;
    C_SPLB_SMALLEST_MASTER         : integer              := 32;
    C_SPLB_CLK_PERIOD_PS           : integer              := 10000;
    C_INCLUDE_DPHASE_TIMER         : integer              := 0;
    C_FAMILY                       : string               := "virtex5"
  );

  ------------------------------------------
  -- DO NOT CHANGE THIS PORT DECLARATION
  ------------------------------------------
  port
  (
    -- PLB (v4.6) bus interface, do not add or delete
    SPLB_Clk                       : in  std_logic;
    SPLB_Rst                       : in  std_logic;
    PLB_ABus                       : in  std_logic_vector(0 to 31);
    PLB_UABus                      : in  std_logic_vector(0 to 31);
    PLB_PAValid                    : in  std_logic;
    PLB_SAValid                    : in  std_logic;
    PLB_rdPrim                     : in  std_logic;
    PLB_wrPrim                     : in  std_logic;
    PLB_masterID                   : in  std_logic_vector(0 to C_SPLB_MID_WIDTH-1);
    PLB_abort                      : in  std_logic;
    PLB_busLock                    : in  std_logic;
    PLB_RNW                        : in  std_logic;
    PLB_BE                         : in  std_logic_vector(0 to C_SPLB_DWIDTH/8-1);
    PLB_MSize                      : in  std_logic_vector(0 to 1);
    PLB_size                       : in  std_logic_vector(0 to 3);
    PLB_type                       : in  std_logic_vector(0 to 2);
    PLB_lockErr                    : in  std_logic;
    PLB_wrDBus                     : in  std_logic_vector(0 to C_SPLB_DWIDTH-1);
    PLB_wrBurst                    : in  std_logic;
    PLB_rdBurst                    : in  std_logic;
    PLB_wrPendReq                  : in  std_logic;
    PLB_rdPendReq                  : in  std_logic;
    PLB_wrPendPri                  : in  std_logic_vector(0 to 1);
    PLB_rdPendPri                  : in  std_logic_vector(0 to 1);
    PLB_reqPri                     : in  std_logic_vector(0 to 1);
    PLB_TAttribute                 : in  std_logic_vector(0 to 15);
    Sl_addrAck                     : out std_logic;
    Sl_SSize                       : out std_logic_vector(0 to 1);
    Sl_wait                        : out std_logic;
    Sl_rearbitrate                 : out std_logic;
    Sl_wrDAck                      : out std_logic;
    Sl_wrComp                      : out std_logic;
    Sl_wrBTerm                     : out std_logic;
    Sl_rdDBus                      : out std_logic_vector(0 to C_SPLB_DWIDTH-1);
    Sl_rdWdAddr                    : out std_logic_vector(0 to 3);
    Sl_rdDAck                      : out std_logic;
    Sl_rdComp                      : out std_logic;
    Sl_rdBTerm                     : out std_logic;
    Sl_MBusy                       : out std_logic_vector(0 to C_SPLB_NUM_MASTERS-1);
    Sl_MWrErr                      : out std_logic_vector(0 to C_SPLB_NUM_MASTERS-1);
    Sl_MRdErr                      : out std_logic_vector(0 to C_SPLB_NUM_MASTERS-1);
    Sl_MIRQ                        : out std_logic_vector(0 to C_SPLB_NUM_MASTERS-1);
    -- BFM synchronization bus interface
    SYNCH_IN                       : in  std_logic_vector(0 to 31) := (others => '0');
    SYNCH_OUT                      : out std_logic_vector(0 to 31) := (others => '0')
  );

end entity plb_hthreads_timer_tb;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture testbench of plb_hthreads_timer_tb is

  --USER testbench signal declarations added here as you wish

  ------------------------------------------
  -- Standard constants for bfl/vhdl communication
  ------------------------------------------
  constant NOP        : integer := 0;
  constant START      : integer := 1;
  constant STOP       : integer := 2;
  constant WAIT_IN    : integer := 3;
  constant WAIT_OUT   : integer := 4;
  constant ASSERT_IN  : integer := 5;
  constant ASSERT_OUT : integer := 6;
  constant ASSIGN_IN  : integer := 7;
  constant ASSIGN_OUT : integer := 8;
  constant RESET_WDT  : integer := 9;
  constant INTERRUPT  : integer := 31;

begin

  ------------------------------------------
  -- Instance of IP under test.
  -- Communication with the BFL is by using SYNCH_IN/SYNCH_OUT signals.
  ------------------------------------------
  UUT : entity plb_hthreads_timer_v1_00_a.plb_hthreads_timer
    generic map
    (
      -- MAP USER GENERICS BELOW THIS LINE ---------------
      --USER generics mapped here
      -- MAP USER GENERICS ABOVE THIS LINE ---------------

      C_BASEADDR                     => C_BASEADDR,
      C_HIGHADDR                     => C_HIGHADDR,
      C_SPLB_AWIDTH                  => C_SPLB_AWIDTH,
      C_SPLB_DWIDTH                  => C_SPLB_DWIDTH,
      C_SPLB_NUM_MASTERS             => C_SPLB_NUM_MASTERS,
      C_SPLB_MID_WIDTH               => C_SPLB_MID_WIDTH,
      C_SPLB_NATIVE_DWIDTH           => C_SPLB_NATIVE_DWIDTH,
      C_SPLB_P2P                     => C_SPLB_P2P,
      C_SPLB_SUPPORT_BURSTS          => C_SPLB_SUPPORT_BURSTS,
      C_SPLB_SMALLEST_MASTER         => C_SPLB_SMALLEST_MASTER,
      C_SPLB_CLK_PERIOD_PS           => C_SPLB_CLK_PERIOD_PS,
      C_INCLUDE_DPHASE_TIMER         => C_INCLUDE_DPHASE_TIMER,
      C_FAMILY                       => C_FAMILY
    )
    port map
    (
      -- MAP USER PORTS BELOW THIS LINE ------------------
      --USER ports mapped here
      -- MAP USER PORTS ABOVE THIS LINE ------------------

      SPLB_Clk                       => SPLB_Clk,
      SPLB_Rst                       => SPLB_Rst,
      PLB_ABus                       => PLB_ABus,
      PLB_UABus                      => PLB_UABus,
      PLB_PAValid                    => PLB_PAValid,
      PLB_SAValid                    => PLB_SAValid,
      PLB_rdPrim                     => PLB_rdPrim,
      PLB_wrPrim                     => PLB_wrPrim,
      PLB_masterID                   => PLB_masterID,
      PLB_abort                      => PLB_abort,
      PLB_busLock                    => PLB_busLock,
      PLB_RNW                        => PLB_RNW,
      PLB_BE                         => PLB_BE,
      PLB_MSize                      => PLB_MSize,
      PLB_size                       => PLB_size,
      PLB_type                       => PLB_type,
      PLB_lockErr                    => PLB_lockErr,
      PLB_wrDBus                     => PLB_wrDBus,
      PLB_wrBurst                    => PLB_wrBurst,
      PLB_rdBurst                    => PLB_rdBurst,
      PLB_wrPendReq                  => PLB_wrPendReq,
      PLB_rdPendReq                  => PLB_rdPendReq,
      PLB_wrPendPri                  => PLB_wrPendPri,
      PLB_rdPendPri                  => PLB_rdPendPri,
      PLB_reqPri                     => PLB_reqPri,
      PLB_TAttribute                 => PLB_TAttribute,
      Sl_addrAck                     => Sl_addrAck,
      Sl_SSize                       => Sl_SSize,
      Sl_wait                        => Sl_wait,
      Sl_rearbitrate                 => Sl_rearbitrate,
      Sl_wrDAck                      => Sl_wrDAck,
      Sl_wrComp                      => Sl_wrComp,
      Sl_wrBTerm                     => Sl_wrBTerm,
      Sl_rdDBus                      => Sl_rdDBus,
      Sl_rdWdAddr                    => Sl_rdWdAddr,
      Sl_rdDAck                      => Sl_rdDAck,
      Sl_rdComp                      => Sl_rdComp,
      Sl_rdBTerm                     => Sl_rdBTerm,
      Sl_MBusy                       => Sl_MBusy,
      Sl_MWrErr                      => Sl_MWrErr,
      Sl_MRdErr                      => Sl_MRdErr,
      Sl_MIRQ                        => Sl_MIRQ
    );

  ------------------------------------------
  -- Zero out the unused synch_out bits
  ------------------------------------------
  SYNCH_OUT(10 to 31)  <= (others => '0');

  ------------------------------------------
  -- Test bench code itself
  --
  -- The test bench itself can be arbitrarily complex and may include
  -- hierarchy as the designer sees fit
  ------------------------------------------
  TEST_PROCESS : process
  begin

    SYNCH_OUT(NOP)        <= '0';
    SYNCH_OUT(START)      <= '0';
    SYNCH_OUT(STOP)       <= '0';
    SYNCH_OUT(WAIT_IN)    <= '0';
    SYNCH_OUT(WAIT_OUT)   <= '0';
    SYNCH_OUT(ASSERT_IN)  <= '0';
    SYNCH_OUT(ASSERT_OUT) <= '0';
    SYNCH_OUT(ASSIGN_IN)  <= '0';
    SYNCH_OUT(ASSIGN_OUT) <= '0';
    SYNCH_OUT(RESET_WDT)  <= '0';

    -- initializations
    -- wait for reset to stabalize after power-up
    wait for 200 ns;
    -- wait for end of reset
    wait until (SPLB_Rst'EVENT and SPLB_Rst = '0');
    assert FALSE report "*** Real simulation starts here ***" severity NOTE;
    -- wait for reset to be completed
    wait for 200 ns;

    ------------------------------------------
    -- Test Software Reset
    ------------------------------------------
    -- send out start signal to begin testing ...
    wait until (SPLB_Clk'EVENT and SPLB_Clk = '1');
    SYNCH_OUT(START) <= '1';
    assert FALSE report "*** Start Software Reset Test ***" severity NOTE;
    wait until (SPLB_Clk'EVENT and SPLB_Clk = '1');
    SYNCH_OUT(START) <= '0';

    -- wait stop signal for end of testing ...
    wait until (SYNCH_IN(STOP)'EVENT and SYNCH_IN(STOP) = '1');
    assert FALSE report "*** Software Reset Test Complete ***" severity NOTE;
    wait for 1 us;

    ------------------------------------------
    -- Test User Logic Slave Register
    ------------------------------------------
    -- send out start signal to begin testing ...
    wait until (SPLB_Clk'EVENT and SPLB_Clk = '1');
    SYNCH_OUT(START) <= '1';
    assert FALSE report "*** Start User Logic Slave Register Test ***" severity NOTE;
    wait until (SPLB_Clk'EVENT and SPLB_Clk = '1');
    SYNCH_OUT(START) <= '0';

    -- wait stop signal for end of testing ...
    wait until (SYNCH_IN(STOP)'EVENT and SYNCH_IN(STOP) = '1');
    assert FALSE report "*** User Logic Slave Register Test Complete ***" severity NOTE;
    wait for 1 us;

    ------------------------------------------
    -- Test User I/Os and other features
    ------------------------------------------
    --USER code added here to stimulate any user I/Os

    wait;

  end process TEST_PROCESS;

end architecture testbench;
