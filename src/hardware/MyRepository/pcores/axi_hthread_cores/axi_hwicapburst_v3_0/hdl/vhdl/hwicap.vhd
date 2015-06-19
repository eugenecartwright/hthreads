-------------------------------------------------------------------------------
-- hwicap.vhd - entity/architecture pair

-------------------------------------------------------------------------------
-- (c) Copyright 2010 - 2011 Xilinx, Inc. All rights reserved.
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
-- PART OF THIS FILE AT ALL TIMES.
--
-------------------------------------------------------------------------------
-- Filename:        hwicap.vhd
-- Description:
--
-- HWICAP module can configure the FPGA using ICAP.It has one write FIFO & one
-- read FIFO. The configuration bitstream will be written in to the write FIFO
-- & from whare the bit stream will be laoded in to the ICAP.
-- Similarly during reading the bitstream loaded in to the read FIFO, from
-- where the processor will read the bit stream. The ocuupany registers will
-- tell the ocupancy value in the FIFOs. The status register tells the status
-- of read. The control register chooses the read or write of configuration
-- bitstream & reseting the registers aswell as FIFOs
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
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library axi_lite_ipif_v3_0;
library lib_cdc_v1_0;
library lib_pkg_v1_0;
use lib_pkg_v1_0.lib_pkg.all;
use axi_lite_ipif_v3_0.ipif_pkg.all;
use lib_cdc_v1_0.cdc_sync;

library unisim;
use unisim.vcomponents.all;

library axi_hwicap_v3_0;
use axi_hwicap_v3_0.all;
-------------------------------------------------------------------------------
-- Definition of Generics:
--  ICAP_DWIDTH         -- ICAP data width
--  C_SAXI_DWIDTH       -- AXI data width
--  C_SIMULATION        -- Parameter is TRUE for functional simulation
--  C_BRAM_SRL_FIFO_TYPE-- type of the FIFO either as distributer or BRAM
--  C_FAMILY            -- target FPGA family
-------------------------------------------------------------------------------
-- --inputs
--
--  ICAP_Clk            -- ICAP clock
--
--  Bus2IP_Clk          -- PLB clock
--  Bus2IP_Reset        -- PLB Reset
--  Bus2IP_BE           -- PLB Byte Enable
--  Bus2IP_Data         -- PLB data bus
--  Bus2IP_rnw          -- Bus to IP read not write signal
--  Bus2IP_cs           -- Bus to IP Chip select signal
--  Bus2IP_wrce         -- Bus to IP write chip enable
--  Bus2IP_rdce         -- Bus to IP read chip enable
-- --outputs
--
--  IP2Bus_Data         -- Slave Data Bus
--  IP2Bus_errAck       -- Slave error acknowledge
--  IP2Bus_RdAck        -- Slave Read Acknowledge
--  IP2Bus_WrAck        -- Slave Write Acknowledge
--  Intr_rst            -- Reset the interrupt controller
--  IP2Bus_AddrAck      -- Slave Address Acknowledge
-------------------------------------------------------------------------------
entity hwicap is
  generic (
    ICAP_DWIDTH         : integer := 16;
    C_WRITE_FIFO_DEPTH  : integer := 16;
    C_READ_FIFO_DEPTH   : integer := 16;
    C_SAXI_DWIDTH       : integer := 32;
    C_SIMULATION        : integer := 2;
    C_BRAM_SRL_FIFO_TYPE: integer := 1;  -- default BRAM
    C_ICAP_WIDTH        : string := "X8";
    C_INCLUDE_STARTUP   : integer := 0;
    C_MODE              : integer := 0;
    C_OPERATION         : integer := 0;
    C_NOREAD            : integer := 0;
    C_ENABLE_ASYNC      : integer := 0;  
    C_DEVICE_ID         : bit_vector := X"04224093";
    C_FAMILY            : string  := "virtex7");
  port(
    ICAP_Clk            : in std_logic;
    Eos_in              : in std_logic;
    Bus2IP_Clk          : in std_logic;
    Bus2IP_Reset        : in std_logic;
    Bus2IP_Addr         : in std_logic_vector(0 to 9-1);
    Bus2IP_BE           : in std_logic_vector(0 to C_SAXI_DWIDTH/8-1);
    Bus2IP_Data         : in std_logic_vector(0 to C_SAXI_DWIDTH-1);
    Bus2IP_rnw          : in std_logic;
    Bus2IP_cs           : in std_logic;
    Bus2IP_wrce         : in std_logic_vector(0 to 7);
    Bus2IP_rdce         : in std_logic_vector(0 to 7);
    IP2Bus_Data         : out std_logic_vector(0 to C_SAXI_DWIDTH-1);
    IP2Bus_errAck       : out std_logic;
    IP2Bus_RdAck        : out std_logic;
    IP2Bus_WrAck        : out std_logic;
    IP2Bus_AddrAck      : out std_logic;
    Intr_rst            : out std_logic;
    IP2Bus_Intr         : out std_logic_vector(0 to 3);
    wrfifo_mst_data    :  in  std_logic_vector(C_SAXI_DWIDTH-ICAP_DWIDTH to C_SAXI_DWIDTH-1);
    wrfifo_mst_wen     : in   std_logic;
    wrfifo_mst_full    : out   std_logic
    );
    );

end entity hwicap;

architecture imp of hwicap is
  attribute DowngradeIPIdentifiedWarnings: string;
  attribute DowngradeIPIdentifiedWarnings of imp : architecture is "yes";


--component axi_hwicap_v3_0_icap_test
--      port (
--        clk           : in std_logic;
--        csb           : in std_logic;
--        rdwrb         : in std_logic;
--        i             : in std_logic_vector (31 downto 0);
--        busy          : out std_logic;
--        o             : out std_logic_vector (31 downto 0));
--end component;
        


constant MTBF_STAGES : integer := 4;
-- signal declaration starts here ...
signal wrfifo_rden      : std_logic;
signal rdfifo_wren      : std_logic;
signal send_done        : std_logic;
signal rdfifo_datain    : std_logic_vector(0 to ICAP_DWIDTH-1);
signal wrfifo_dataout   : std_logic_vector(0 to ICAP_DWIDTH-1);
signal icap_datain      : std_logic_vector(0 to ICAP_DWIDTH-1);
signal icap_dataout     : std_logic_vector(0 to ICAP_DWIDTH-1);
signal writefifo_full   : std_logic;
signal writefifo_empty  : std_logic;
signal readfifo_full    : std_logic;
signal readfifo_empty   : std_logic;
signal rnc              : std_logic_vector(0 to 1);
signal size             : std_logic_vector(0 to 11);
signal icap_busy        : std_logic;
signal icap_ce          : std_logic;
signal icap_we          : std_logic;
signal reset_cr         : std_logic;
signal size_counter     : std_logic_vector(0 to 11);
signal abort            : std_logic;
signal abort_in_progress: std_logic;
signal status_read      : std_logic;
signal icap_status      : std_logic_vector(0 to 31);
signal ICAP_Reset : std_logic;
signal bus2icap_reset_trig_1 : std_logic;
signal bus2icap_reset_trig_2 : std_logic;
signal bus2icap_reset_trig_3 : std_logic;
signal gate_icap : std_logic;
signal gate_icap_p : std_logic;
signal gate_clk : std_logic;
signal gate_clk1 : std_logic;
signal rdfull : std_logic;
signal inv_gate : std_logic;

signal ce_del1 : std_logic;
signal ce_del2 : std_logic;
signal ce_del3 : std_logic;
signal rdwr_int1 : std_logic;
signal rdwr_int2 : std_logic;
signal abort_detect : std_logic;
signal abort_del1 : std_logic;
signal abort_del2 : std_logic;
signal abort_del3 : std_logic;
signal busy_abort : std_logic;
signal busy_int : std_logic;
signal same_cycle : std_logic;
signal hang_status : std_logic;
signal icap_dataout1 : std_logic_vector (0 to 31);
signal icap_datain1 : std_logic_vector (0 to 31);
signal icap_available : std_logic;


begin  -- architecture IMP

  -----------------------------------------------------------------------------
  -- IPIC Interface
  -----------------------------------------------------------------------------
  IPIC_IF_I : entity axi_hwicap_v3_0.ipic_if
    generic map (
      C_SAXI_DWIDTH       => C_SAXI_DWIDTH,
      C_WRITE_FIFO_DEPTH  => C_WRITE_FIFO_DEPTH,
      C_READ_FIFO_DEPTH   => C_READ_FIFO_DEPTH,
      ICAP_DWIDTH         => ICAP_DWIDTH,
      C_MODE              => C_MODE,
      C_NOREAD            => C_NOREAD,
      C_ENABLE_ASYNC      => C_ENABLE_ASYNC,
      C_INCLUDE_STARTUP   => C_INCLUDE_STARTUP,
      C_BRAM_SRL_FIFO_TYPE=> C_BRAM_SRL_FIFO_TYPE,
      C_FAMILY            => C_FAMILY)
    port map (
      ICAP_Clk            => ICAP_Clk,
      ICAP_Reset          => ICAP_Reset,
      Bus2IP_Clk          => Bus2IP_Clk,
      Bus2IP_Reset        => Bus2IP_Reset,
      Send_done           => send_done,
      Reset_cr            => reset_cr,
      Icap_out            => icap_dataout,
      Bus2IP_cs           => Bus2IP_cs,
      Bus2IP_BE           => Bus2IP_BE,
      Bus2IP_rnw          => Bus2IP_rnw,
      Bus2IP_wrce         => Bus2IP_wrce,
      Bus2IP_rdce         => Bus2IP_rdce,
      Bus2IP_Data         => Bus2IP_Data,
      Wrfifo_rden         => wrfifo_rden,
      IP2Bus_Data         => IP2Bus_Data,
      Rdfifo_wren         => rdfifo_wren,
      Rdfifo_datain       => rdfifo_datain,
      Status_read         => status_read,
      Icap_status         => icap_status,
      Wrfifo_dataout      => wrfifo_dataout,
      Writefifo_full      => writefifo_full,
      Writefifo_empty     => writefifo_empty,
      Readfifo_full       => readfifo_full,
      Readfifo_empty      => readfifo_empty,
      Abort               => abort,
      Abort_in_progress   => abort_in_progress,
      Rnc                 => rnc,
      Hang_status         => hang_status,
      Eos_in              => Eos_in,
      icap_available      => icap_available,
      Size                => size,
      Size_counter        => size_counter,
      IP2Bus_RdAck        => IP2Bus_RdAck,
      IP2Bus_WrAck        => IP2Bus_WrAck,
      IP2Bus_AddrAck      => IP2Bus_AddrAck,
      IP2Bus_errAck       => IP2Bus_errAck,
      Intr_rst            => Intr_rst,
      Gate_icap           => gate_icap,
      Gate_icap_p         => gate_icap_p,
      IP2Bus_Intr         => IP2Bus_Intr,
      wrfifo_mst_data          =>   wrfifo_mst_data   ,
	   wrfifo_mst_wen           =>   wrfifo_mst_wen ,
	   wrfifo_mst_full          =>  wrfifo_mst_full
      );
-------------------------------------------------------------------------------
-- icap State Machine
-------------------------------------------------------------------------------

rdfull <= gate_icap_p;

  icap_statemachine_I1: entity axi_hwicap_v3_0.icap_statemachine
    generic map (
      ICAP_DWIDTH         => ICAP_DWIDTH,
      C_MODE              => C_MODE,
      C_FAMILY            => C_FAMILY)
    port map (
      Clk                 => ICAP_Clk,
      Rst                 => ICAP_Reset,
      Wrfifo_dataout      => wrfifo_dataout,
      Icap_dataout        => icap_dataout,
      Wrfifo_full         => writefifo_full,
      Wrfifo_empty        => writefifo_empty,
      Rdfifo_empty        => readfifo_empty,
      Rdfifo_full         => rdfull,
      Icap_busy           => icap_busy,
      Status_read         => status_read,
      Rnc                 => rnc,
      Abort               => abort,
      Size                => size,
      Size_counter        => size_counter,
      Wrfifo_rden         => wrfifo_rden,
      Rdfifo_wren         => rdfifo_wren,
      Icap_ce             => icap_ce,
      Icap_we             => icap_we,
      Abort_in_progress   => abort_in_progress,
      Icap_status         => icap_status,
      Send_done           => send_done,
      Reset_cr            => reset_cr,
      Hang_status         => hang_status,
      Icap_datain         => icap_datain,
      Rdfifo_datain       => rdfifo_datain);


--  GEN_BUS2ICAP_RESET:process (ICAP_Clk)
--  begin
--    if ICAP_Clk'event and ICAP_Clk = '1' then
--       -- generates three flip flop synchronizer bus2icap reset trigger signal
--       -- in ICAP_Clk
--       bus2icap_reset_trig_1 <= Bus2IP_Reset;
--       bus2icap_reset_trig_2 <= bus2icap_reset_trig_1;
--    end if;
--  end process GEN_BUS2ICAP_RESET;

GEN_BUS2ICAP_RESET : entity lib_cdc_v1_0.cdc_sync
    generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_VECTOR_WIDTH             => 32,
        C_MTBF_STAGES              => MTBF_STAGES
    )
    port map (
        prmry_aclk                 => '0',
        prmry_resetn               => '0',
        prmry_in                   => Bus2IP_Reset,
        prmry_vect_in              => (others => '0'),

        scndry_aclk                => ICAP_Clk,
        scndry_resetn              => '0',
        scndry_out                 => bus2icap_reset_trig_2, --awvalid_to,
        scndry_vect_out            => open
    );


  ICAP_Reset <= bus2icap_reset_trig_2;

  -----------------------------------------------------------------------------
  -- simulation only using the FIFO model
  -----------------------------------------------------------------------------

-- gate_bufgce : BUFGCE
--              port map (
--                O => gate_clk,
--                I => ICAP_Clk,
--                CE => inv_gate);

BUFGCTRL_INST : if (C_OPERATION = 1) generate
begin
 
      inv_gate <= not gate_icap;


 gate_bfgctrl : BUFGCTRL 
               port map (
            
    O           => gate_clk,
    CE0         => inv_gate,
    CE1         => '0',
    I0          => ICAP_Clk,
    I1          => '1',
    IGNORE0     => '0',
    IGNORE1     => '1',
    S0          => '1',
    S1          => '0'
    );

end generate BUFGCTRL_INST;


NO_BUFGCTRL_INST : if (C_OPERATION = 0) generate
begin

    gate_clk <= ICAP_Clk; 

end generate NO_BUFGCTRL_INST;


  GEN_FUNCTIONAL : if C_SIMULATION = 1 generate
 --    ICAP_TEST_I : axi_hwicap_v3_0_icap_test
 --     port map (
 --      -- Rst               => ICAP_Reset,
 --       clk                => gate_clk,
 --       csb                => icap_ce, 
 --       rdwrb              => icap_we,
 --       i                  => icap_datain1,
 --       busy               => icap_busy,
 --       o                  => icap_dataout1);



  --     icap_dataout <= icap_dataout1;
  --     icap_datain1 <= icap_datain;


  end generate GEN_FUNCTIONAL;
  -----------------------------------------------------------------------------
  --implementation only code - Simulations using unisim model
  -----------------------------------------------------------------------------
  GEN_FUNCTIONAL_UNISIM : if C_SIMULATION = 2 generate
  begin

   GEN_VIRTEX7_ICAP : if ( 
            (C_FAMILY = "virtex7") or
            (C_FAMILY = "kintex7") or
            (C_FAMILY = "zynq") or
            (C_FAMILY = "artix7")  
           ) generate
    begin
       ICAP_VIRTEX7_I : ICAPE2
         generic map (
           DEVICE_ID         => C_DEVICE_ID,
           ICAP_WIDTH        => C_ICAP_WIDTH)
         port map (
           clk               => gate_clk,
           csib               => icap_ce,
           rdwrb             => icap_we,
           i                 => icap_datain,
       --    busy              => icap_busy,
           o                 => icap_dataout);

       icap_available <= '0';

   end generate GEN_VIRTEX7_ICAP;


   GEN_VIRTEXU_ICAP : if ( 
                          C_FAMILY = "virtexu" or
                          C_FAMILY = "kintexu" or
                          C_FAMILY = "artixu"
                           ) generate
   begin

       ICAP_VIRTEXU_I : ICAPE3
         generic map ( 
           DEVICE_ID         => C_DEVICE_ID)
--           ICAP_WIDTH        => C_ICAP_WIDTH)
         port map (
           clk               => gate_clk,
           csib              => icap_ce,
           rdwrb             => icap_we,
           i                 => icap_datain,
           o                 => icap_dataout,
           prerror           => open,
           prdone            => open,
           avail             => icap_available);

--       icap_available <= '1';


   end generate GEN_VIRTEXU_ICAP;

-- The ICAPE2 does not have the busy pin, hence a dummy busy signal has to be
-- generated so that the same state machine can be used.
-- ICAPE2 works very similar to Virtex6 ICAP.
-- It is observed from Chipscope that the BUSY goes low after 3 clocks following
-- ce assertion for read.
-- Busy goes low immediately after ce, we assertion in case of write
-- A dummy BUSY will be generated by delaying the CE

 process (ICAP_Clk)
 begin
     if (ICAP_Clk'event and ICAP_Clk = '1') then
        if (ICAP_Reset = '1') then
          ce_del1 <= '0';
          ce_del2 <= '0';
          ce_del3 <= '0';
        else 
          ce_del1 <= icap_ce;
          ce_del2 <= ce_del1;
          ce_del3 <= ce_del2;
        end if;
     end if;
  end process;

-- A busy signal has to be genrated for ABORTs as well
-- Following process generates the busy during ABORTs

 process (ICAP_Clk)
 begin
     if (ICAP_Clk'event and ICAP_Clk = '1') then
        if (ICAP_Reset = '1') then
           rdwr_int1 <= '1';
           same_cycle <= '0';
        elsif (icap_ce = '0') then
           rdwr_int1 <= icap_we;
           same_cycle <= '1';
        else
           rdwr_int1 <= '1';
           same_cycle <= '0';
        end if;
     end if;
  end process;

 
 process (ICAP_Clk)
 begin
     if (ICAP_Clk'event and ICAP_Clk = '1') then
        if (ICAP_Reset = '1') then
           abort_detect <= '0';
        elsif (icap_ce = '0' and same_cycle = '1') then
           if (rdwr_int1 = icap_we) then
              abort_detect <= '0';
           else 
              abort_detect <= '1';
           end if;
        end if;
     end if;
 end process;

 process (ICAP_Clk)
 begin
     if (ICAP_Clk'event and ICAP_Clk = '1') then
        if (ICAP_Reset = '1') then
           abort_del1 <= '0';
           abort_del2 <= '0';
           abort_del3 <= '0';
        else
           abort_del1 <= abort_detect;
           abort_del2 <= abort_del1;
           abort_del3 <= abort_del2;
        end if;
    end if;
  end process;

  busy_abort <= abort_del1 or abort_del2 or abort_del3 or abort_detect;

-- Following generates busy for read transactions

  busy_int <= ce_del3 or icap_ce;

-- Following would take care of the busy for read as well as write
-- For a write transaction the "and icap_we" will drag the busy low immediately
-- for a read transaction since the icap_we is high, the final busy will be busy_int
  icap_busy <= (busy_int and icap_we) or busy_abort;
 

 
   
   end generate GEN_FUNCTIONAL_UNISIM;
   
end architecture imp;
