-------------------------------------------------------------------------------
-- $Id: fsl_v20.vhd,v 1.1.2.1 2010/10/28 11:17:56 goran Exp $
-------------------------------------------------------------------------------
-- fsl_v20.vhd - Entity and architecture
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
-- Filename:        fsl_v20.vhd
--
-- Description:     
--                  
-- VHDL-Standard:   VHDL'93
-------------------------------------------------------------------------------
-- Structure:   
--              fsl_v20.vhdenv\Databases\ip2\processor\hardware\doc\bram_block\bram_block_v1_00_a
--
-------------------------------------------------------------------------------
-- Author:          satish
-- Revision:        $Revision: 1.1.2.1 $
-- Date:            $Date: 2010/10/28 11:17:56 $
--
-- History:
--   satish  2003-02-13    First Version
--   satish  2004-03-03    New Version
--   rolandp 2006-08-20    BRAM in asynch mode 
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

library Unisim;
use Unisim.vcomponents.all;

library fsl_v20_v2_11_f;
use fsl_v20_v2_11_f.sync_fifo;
use fsl_v20_v2_11_f.async_fifo;


entity fsl_v20 is
  generic (
    C_EXT_RESET_HIGH    : integer := 1;
    C_ASYNC_CLKS        : integer := 0;
    C_IMPL_STYLE        : integer := 0;
    C_USE_CONTROL       : integer := 1;
    C_FSL_DWIDTH        : integer := 32;
    C_FSL_DEPTH         : integer := 16;
    C_READ_CLOCK_PERIOD : integer := 0
    );
  port (
    -- Clock and reset signals
    FSL_Clk : in  std_logic;
    SYS_Rst : in  std_logic;
    FSL_Rst : out std_logic;

    -- FSL master signals
    FSL_M_Clk     : in  std_logic;
    FSL_M_Data    : in  std_logic_vector(0 to C_FSL_DWIDTH-1);
    FSL_M_Control : in  std_logic;
    FSL_M_Write   : in  std_logic;
    FSL_M_Full    : out std_logic;

    -- FSL slave signals
    FSL_S_Clk     : in  std_logic;
    FSL_S_Data    : out std_logic_vector(0 to C_FSL_DWIDTH-1);
    FSL_S_Control : out std_logic;
    FSL_S_Read    : in  std_logic;
    FSL_S_Exists  : out std_logic;

    -- FIFO status signals
    FSL_Full        : out std_logic;
    FSL_Has_Data    : out std_logic;
    FSL_Control_IRQ : out std_logic
    );
end entity fsl_v20;

architecture IMP of fsl_v20 is

  component Sync_FIFO is
    generic (
      C_IMPL_STYLE : Integer;
      WordSize     : Integer;
      MemSize      : Integer);
    port (
      Reset : in Std_Logic;
      Clk   : in Std_Logic;

      WE      : in  Std_Logic;
      DataIn  : in  Std_Logic_Vector(WordSize-1 downto 0);
      Full    : out Std_Logic;
      RD      : in  Std_Logic;
      DataOut : out Std_Logic_Vector(WordSize-1 downto 0);
      Exists  : out Std_Logic);
  end component Sync_FIFO;
                        
  component Async_FIFO is
    generic (
      WordSize : Integer;
      MemSize  : Integer;
      Protect  : Boolean);
    port (
      Reset   : in  Std_Logic;
      -- Clock region WrClk
      WrClk   : in  Std_Logic;
      WE      : in  Std_Logic;
      DataIn  : in  Std_Logic_Vector(WordSize-1 downto 0);
      Full    : out Std_Logic;
      -- Clock region RdClk
      RdClk   : in  Std_Logic;
      RD      : in  Std_Logic;
      DataOut : out Std_Logic_Vector(WordSize-1 downto 0);
      Exists  : out Std_Logic);
  end component Async_FIFO;

  component Async_FIFO_BRAM is
    generic (
      WordSize : Integer;
      MemSize  : Integer;
      Protect  : Boolean);
    port (
      Reset   : in  Std_Logic;
      -- Clock region WrClk
      WrClk   : in  Std_Logic;
      WE      : in  Std_Logic;
      DataIn  : in  Std_Logic_Vector(WordSize-1 downto 0);
      Full    : out Std_Logic;
      -- Clock region RdClk
      RdClk   : in  Std_Logic;
      RD      : in  Std_Logic;
      DataOut : out Std_Logic_Vector(WordSize-1 downto 0);
      Exists  : out Std_Logic);
  end component Async_FIFO_BRAM;
  
  signal sys_rst_i    : std_logic;
  signal srl_time_out : std_logic;
  signal fsl_rst_i    : std_logic;
  signal Data_In      : std_logic_vector(0 to C_FSL_DWIDTH);
  signal Data_Out     : std_logic_vector(0 to C_FSL_DWIDTH);

  signal fifo_full       : std_logic;
  -- signal fifo_half_full  : std_logic;
  -- signal fifo_half_empty : std_logic;
  signal fifo_has_data   : std_logic;

  signal fsl_s_control_i : std_logic;

  signal srl_clk : std_logic;
  
begin  -- architecture IMP

  SYS_RST_PROC : process (SYS_Rst) is
    variable sys_rst_input : std_logic;
  begin
    if C_EXT_RESET_HIGH = 0 then
      sys_rst_i <= not SYS_Rst;
    else
      sys_rst_i <= SYS_Rst;
    end if;
  end process SYS_RST_PROC;

  Rst_Delay_Async: if (C_ASYNC_CLKS /= 0) generate
    srl_clk <= FSL_M_Clk;
    
  end generate Rst_Delay_Async;

  Rst_Delay_Sync: if (C_ASYNC_CLKS = 0) generate
    srl_clk <= FSL_Clk;
  end generate Rst_Delay_Sync;

  POR_SRL_I : SRL16
    generic map (
      INIT => X"FFFF") 
    port map (
      D   => '0',
      CLK => srl_Clk,
      A0  => '1',
      A1  => '1',
      A2  => '1',
      A3  => '1',
      Q   => srl_time_out);

  POR_FF_I : FDS
    port map (
      Q => fsl_rst_i,
      D => srl_time_out,
      C => srl_Clk,
      S => sys_rst_i);
  
  FSL_Rst <= fsl_rst_i;


  -----------------------------------------------------------------------------
  -- Width is 1, so implement a registers
  -----------------------------------------------------------------------------
  Only_Register : if (C_FSL_DEPTH = 1) generate
    signal fsl_s_exists_i : std_logic;
    signal fsl_m_full_i   : std_logic;
  begin

    -- FSL_S_Clk and FSL_M_Clk are the same
    Sync_Clocks: if (C_ASYNC_CLKS = 0) generate

      FIFO : process (FSL_Clk) is
        variable fifo_full : std_logic;
      begin  -- process FIFO
        if FSL_Clk'event and FSL_Clk = '1' then  -- rising clock edge
          if fsl_rst_i = '1' then                  -- synchronous reset (active high)
            fifo_full      := '0';
            Fsl_m_full_i   <= '1';
            Fsl_s_exists_i <= '0';
          else
            if (fifo_full = '0') then              -- Empty
              if (FSL_M_Write = '1') then
                fifo_full       := '1';
                FSL_S_Data      <= FSL_M_Data;
                fsl_s_control_i <= FSL_M_Control;
              end if;
            end if;
            if (fifo_full = '1') then              -- Has data
              if (FSL_S_Read = '1') then
                fifo_full := '0';
              end if;
            end if;
            Fsl_m_full_i   <= fifo_full;
            Fsl_s_exists_i <= fifo_full;
          end if;
        end if;
      end process FIFO;
    end generate Sync_Clocks;

    FSL_S_Exists <= fsl_s_exists_i;
    FSL_Has_Data <= fsl_s_exists_i;

    FSL_M_Full <= fsl_m_full_i;
    FSL_Full   <= fsl_m_full_i;
    
    FSL_S_Control   <= fsl_s_control_i when C_USE_CONTROL /= 0 else '0';
    FSL_Control_IRQ <= fsl_s_control_i and fsl_s_exists_i when C_USE_CONTROL /= 0 else '0';

  end generate Only_Register;

  Using_FIFO: if (C_FSL_DEPTH > 1) generate
  begin
    -- Map Master Data/Control signal
    Data_In(0 to C_FSL_DWIDTH-1) <= FSL_M_Data;

    -- Map Slave Data/Control signal
    FSL_S_Data    <= Data_Out(0 to C_FSL_DWIDTH-1);

    -- SRL FIFO BASED IMPLEMENTATION
    Sync_FIFO_Gen : if (C_ASYNC_CLKS = 0) generate
      Use_Control: if (C_USE_CONTROL /= 0) generate

        Data_In(C_FSL_DWIDTH)        <= FSL_M_Control;        
        fsl_s_control_i <= Data_Out(C_FSL_DWIDTH);            

        Sync_FIFO_I1 : Sync_FIFO
          generic map (
            C_IMPL_STYLE => C_IMPL_STYLE,
            WordSize     => C_FSL_DWIDTH + 1,
            MemSize      => C_FSL_DEPTH)
          port map (
            Reset   => fsl_rst_i,
            Clk     => FSL_Clk,
            WE      => FSL_M_Write,
            DataIn  => Data_In,
            Full    => fifo_full,
            RD      => FSL_S_Read,
            DataOut => Data_Out,
            Exists  => fifo_has_data);
      end generate Use_Control;

      Use_Data: if (C_USE_CONTROL = 0) generate

        fsl_s_control_i <= '0';
        
        Sync_FIFO_I1 : Sync_FIFO
          generic map (
            C_IMPL_STYLE => C_IMPL_STYLE,
            WordSize     => C_FSL_DWIDTH,
            MemSize      => C_FSL_DEPTH)
          port map (
            Reset   => fsl_rst_i,
            Clk     => FSL_Clk,
            WE      => FSL_M_Write,
            DataIn  => Data_In(0 to C_FSL_DWIDTH-1),
            Full    => fifo_full,
            RD      => FSL_S_Read,
            DataOut => Data_Out(0 to C_FSL_DWIDTH-1),
            Exists  => fifo_has_data);
        
      end generate Use_Data;
    end generate Sync_FIFO_Gen;
    
    Async_FIFO_Gen: if (C_ASYNC_CLKS /= 0) generate

      Use_Control: if (C_USE_CONTROL /= 0) generate

        Data_In(C_FSL_DWIDTH)        <= FSL_M_Control;        
        fsl_s_control_i <= Data_Out(C_FSL_DWIDTH);            

        Use_DPRAM1: if (C_IMPL_STYLE = 0) generate
          -- LUT RAM implementation
          Async_FIFO_I1: Async_FIFO
            generic map (
              WordSize     => C_FSL_DWIDTH + 1,  -- [Integer]
              MemSize      => C_FSL_DEPTH,  -- [Integer]
              Protect      => true)         -- [Boolean]
            port map (
              Reset   => fsl_rst_i,         -- [in  Std_Logic]
              -- Clock region WrClk
              WrClk   => FSL_M_Clk,         -- [in  Std_Logic]
              WE      => FSL_M_Write,       -- [in  Std_Logic]
              DataIn  => Data_In,   -- [in  Std_Logic_Vector(WordSize-1 downto 0)]
              Full    => fifo_full,         -- [out Std_Logic]
              -- Clock region RdClk
              RdClk   => FSL_S_Clk,         -- [in  Std_Logic]
              RD      => FSL_S_Read,        -- [in  Std_Logic]
              DataOut => Data_Out,  -- [out Std_Logic_Vector(WordSize-1 downto 0)]
              Exists  => fifo_has_data);    -- [out Std_Logic]
        end generate Use_DPRAM1;

        Use_BRAM1: if (C_IMPL_STYLE /= 0) generate
          -- BRAM implementation
          Async_FIFO_BRAM_I1 : Async_FIFO_BRAM
            generic map (
              WordSize     => C_FSL_DWIDTH + 1,  -- [Integer]
              MemSize      => C_FSL_DEPTH,       -- [Integer]
              Protect      => true)              -- [Boolean]
            port map (
              Reset   => fsl_rst_i,         -- [in  Std_Logic]
              -- Clock region WrClk
              WrClk   => FSL_M_Clk,         -- [in  Std_Logic]
              WE      => FSL_M_Write,       -- [in  Std_Logic]
              DataIn  => Data_In,   -- [in  Std_Logic_Vector(WordSize-1 downto 0)]
              Full    => fifo_full,         -- [out Std_Logic]
              -- Clock region RdClk
              RdClk   => FSL_S_Clk,         -- [in  Std_Logic]
              RD      => FSL_S_Read,        -- [in  Std_Logic]
              DataOut => Data_Out,  -- [out Std_Logic_Vector(WordSize-1 downto 0)]
              Exists  => fifo_has_data);    -- [out Std_Logic]
        end generate Use_BRAM1;

      end generate Use_Control;
      
      Use_Data: if (C_USE_CONTROL = 0) generate

        fsl_s_control_i <= '0';
        
        Use_DPRAM0: if (C_IMPL_STYLE = 0) generate
          -- LUT RAM implementation
          Async_FIFO_I1 : Async_FIFO
            generic map (
              WordSize     => C_FSL_DWIDTH,  -- [Integer]
              MemSize      => C_FSL_DEPTH,  -- [Integer]
              Protect      => true)         -- [Boolean]
            port map (
              Reset   => fsl_rst_i,         -- [in  Std_Logic]
              -- Clock region WrClk
              WrClk   => FSL_M_Clk,         -- [in  Std_Logic]
              WE      => FSL_M_Write,       -- [in  Std_Logic]
              DataIn  => Data_In(0 to C_FSL_DWIDTH-1),   -- [in  Std_Logic_Vector(WordSize-1 downto 0)]
              Full    => fifo_full,         -- [out Std_Logic]
              -- Clock region RdClk
              RdClk   => FSL_S_Clk,         -- [in  Std_Logic]
              RD      => FSL_S_Read,        -- [in  Std_Logic]
              DataOut => Data_Out(0 to C_FSL_DWIDTH-1),  -- [out Std_Logic_Vector(WordSize-1 downto 0)]
              Exists  => fifo_has_data);    -- [out Std_Logic]
        end generate Use_DPRAM0;

        Use_BRAM0: if (C_IMPL_STYLE /= 0) generate
          -- BRAM implementation
          Async_FIFO_BRAM_I1 : Async_FIFO_BRAM
            generic map (
              WordSize     => C_FSL_DWIDTH,  -- [Integer]
              MemSize      => C_FSL_DEPTH,  -- [Integer]
              Protect      => true)         -- [Boolean]
            port map (
              Reset   => fsl_rst_i,         -- [in  Std_Logic]
              -- Clock region WrClk
              WrClk   => FSL_M_Clk,         -- [in  Std_Logic]
              WE      => FSL_M_Write,       -- [in  Std_Logic]
              DataIn  => Data_In(0 to C_FSL_DWIDTH-1),   -- [in  Std_Logic_Vector(WordSize-1 downto 0)]
              Full    => fifo_full,         -- [out Std_Logic]
              -- Clock region RdClk
              RdClk   => FSL_S_Clk,         -- [in  Std_Logic]
              RD      => FSL_S_Read,        -- [in  Std_Logic]
              DataOut => Data_Out(0 to C_FSL_DWIDTH-1),  -- [out Std_Logic_Vector(WordSize-1 downto 0)]
              Exists  => fifo_has_data);    -- [out Std_Logic]
         end generate Use_BRAM0;

      end generate Use_Data;
      
    end generate Async_FIFO_Gen;

    FSL_M_Full <= fifo_full or fsl_rst_i;  -- Inhibit writes during reset by
                                           -- forcing full to '1'
    FSL_S_Exists <= fifo_has_data;

    FSL_Full     <= fifo_full;
    FSL_Has_Data <= fifo_has_data;

    FSL_S_Control   <= fsl_s_control_i;
    FSL_Control_IRQ <= fsl_s_control_i and fifo_has_data;
    
  end generate Using_FIFO;
  
end architecture IMP;

