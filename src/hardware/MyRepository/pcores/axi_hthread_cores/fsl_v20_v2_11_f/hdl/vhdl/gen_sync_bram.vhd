-------------------------------------------------------------------------------
-- $Id: gen_sync_bram.vhd,v 1.1.2.1 2010/10/28 11:17:56 goran Exp $
-------------------------------------------------------------------------------
-- gen_sync_bram.vhd - Entity and architecture
-------------------------------------------------------------------------------
--
-- (c) Copyright [2003] - [2010] Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and 
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES
--
-------------------------------------------------------------------------------
-- Author:          satish
-- Revision:        $Revision: 1.1.2.1 $
-- Date:            $Date: 2010/10/28 11:17:56 $
--
-- History:
--   satish  2004-03-24    New Version
--
-- Description:
-- Code to infer synchronous dual port bram and separate read/write clock dual
-- port bram
--
-------------------------------------------------------------------------------
-- Naming Conventions:
--      active low signals:                     "*_n"
--      clock signals:                          "clk", "clk_div#", "clk_#x" 
--      reset signals:                          "rst", "rst_n" 
--      generics:                               "C_*" 
--      user defined types:                     "*_TYPE" 
--      state machine next state:               "*_ns" 
--      state machine current state:            "*_cs" 
--      combinatorial signals:                  "*_com" 
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
use ieee.std_logic_unsigned.all;
entity Sync_BRAM is
  generic (
    C_DWIDTH : integer := 32;
    C_AWIDTH : integer := 16
    );    
  port (
    clk     : in  std_logic;
    -- Write port
    we      : in  std_logic;
    a       : in  std_logic_vector(C_AWIDTH-1 downto 0);
    di      : in  std_logic_vector(C_DWIDTH-1 downto 0);
    -- Read port
    dpra_en : in  std_logic;
    dpra    : in  std_logic_vector(C_AWIDTH-1 downto 0);
    dpo     : out std_logic_vector(C_DWIDTH-1 downto 0)
    ); 
end Sync_BRAM;

architecture syn of Sync_BRAM is 
  type ram_type is array ((2**C_AWIDTH)-1 downto 0) of std_logic_vector ((C_DWIDTH-1) downto 0); 
  -- signal ram_mem : ram_type := (others => (others => '0')); 
  signal ram_mem : ram_type;
  signal read_a : std_logic_vector(C_AWIDTH-1 downto 0); 
  signal read_dpra : std_logic_vector(C_AWIDTH-1 downto 0); 
begin 
  process (clk) 
  begin 
    if (clk'event and clk = '1') then 
      if (we = '1') then 
        ram_mem(conv_integer(a)) <= di; 
      end if; 
      read_a <= a;
      if (dpra_en = '1') then
        read_dpra <= dpra;         
      end if;
    end if; 
  end process; 
  dpo <= ram_mem(conv_integer(read_dpra)); 
end syn; 



