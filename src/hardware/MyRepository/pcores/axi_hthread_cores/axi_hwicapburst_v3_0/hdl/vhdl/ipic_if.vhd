-------------------------------------------------------------------------------
-- ipic_if.vhd - entity/architecture pair

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
-- Filename:        ipic_if.vhd
-- Version :        v7.01a
-- Description:     This module provides the interface to the ICAP & the 
--                  AXI-LITE
--
-------------------------------------------------------------------------------
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library unisim;
use unisim.vcomponents.all;

library lib_fifo_v1_0;
    use lib_fifo_v1_0.async_fifo_fg;

library lib_cdc_v1_0;
library lib_pkg_v1_0;
use lib_pkg_v1_0.lib_pkg.all;
use ieee.std_logic_unsigned."+";
use ieee.std_logic_unsigned."-";


-------------------------------------------------------------------------------
-- Definition of Generics:
--  C_SAXI_DWIDTH         -- Processor Data Bus Width
--  C_WRITE_FIFO_DEPTH    -- Write Fifo Depth
--  C_READ_FIFO_DEPTH     -- Read Fifo Depth
--  ICAP_DWIDTH           -- Icap Data Width
--  C_BRAM_SRL_FIFO_TYPE  -- type of the FIFO either distributed RAM or BRAM
--  C_FAMILY              -- Family of FPGA
--
-- Definition of Ports:
--  ICAP_Clk              -- ICAP Clock
--  ICAP_Reset            -- ICAP Reset
--
--  Bus2IP_Clk            -- Clock
--  Bus2IP_Reset          -- Reset
--  Bus2IP_cs             -- Chip select
--  Bus2IP_BE             -- Byte enables
--  Bus2IP_rnw            -- Read Not Write
--  Bus2IP_wrce           -- Write ce
--  Bus2IP_rdce           -- Read ce
--  Bus2IP_Data           -- Bus2ip data
--  Send_done             -- Read done
--  Reset_cr              -- Reset the control register
--  Icap_out              -- ICAP data out
--  Icap_status           -- ICAP status
--  Abort_in_progress     -- Abort in progress
--  Wrfifo_rden           -- Write fifo rden
--  Rdfifo_wren           -- Read fifo wren
--  Rdfifo_datain         -- Read fifo data in
--  Wrfifo_dataout        -- Write fifo data out
--  IP2Bus_Data           -- IP2 Bus data
--  Writefifo_full        -- Write fifo full
--  Writefifo_empty       -- Write fifo empty
--  Readfifo_full         -- Read fifo full
--  Readfifo_empty        -- Read fifo empty
--  Rnc                   -- Read not configure
--  Size                  -- Size of data transfer in words
--  IP2Bus_RdAck          -- IP2 Bus Read Ack
--  IP2Bus_WrAck          -- IP2 Bus Write Ack
--  IP2Bus_AddrAck        -- IP2 Bus Address Ack
--  IP2Bus_errAck         -- IP2 Bus error Ack
--  Intr_rst              -- Intrrupt control logic reset
--  IP2Bus_Intr           -- IP2 Bus interrupt
-------------------------------------------------------------------------------
-- Port declarations
-------------------------------------------------------------------------------

entity ipic_if is
    generic (
        C_ENABLE_ASYNC       : integer := 0;
        C_MODE               : integer := 0; 
        C_NOREAD             : integer := 0;
        C_INCLUDE_STARTUP    : integer := 0;
        C_SAXI_DWIDTH        : integer;
        C_WRITE_FIFO_DEPTH   : integer:= 16;
        C_READ_FIFO_DEPTH    : integer:= 16;
        ICAP_DWIDTH          : integer := 16;
        C_BRAM_SRL_FIFO_TYPE : integer := 1;  -- default BRAM
        C_FAMILY             : string  := "virtex7");
    port (
        ICAP_Clk             : in  std_logic;
        ICAP_Reset           : in  std_logic;
        Bus2IP_Clk           : in  std_logic;
        Bus2IP_Reset         : in  std_logic;
        Bus2IP_cs            : in  std_logic;
        Bus2IP_BE            : in  std_logic_vector(0 to C_SAXI_DWIDTH/8-1);
        Bus2IP_rnw           : in  std_logic;
        Bus2IP_wrce          : in  std_logic_vector(0 to 7);
        Bus2IP_rdce          : in  std_logic_vector(0 to 7);
        Bus2IP_Data          : in  std_logic_vector(0 to C_SAXI_DWIDTH-1);
        Send_done            : in  std_logic;
        Reset_cr             : in  std_logic;
        Icap_out             : in  std_logic_vector(0 to ICAP_DWIDTH-1);
        Icap_status          : in  std_logic_vector(0 to 31);
        Abort_in_progress    : in  std_logic;
        Wrfifo_rden          : in  std_logic;
        Rdfifo_wren          : in  std_logic;
        Hang_status          : in  std_logic; 
        Eos_in               : in  std_logic;
        icap_available       : in  std_logic; 
        Rdfifo_datain        : in  std_logic_vector(0 to ICAP_DWIDTH-1);
        Wrfifo_dataout       : out std_logic_vector(0 to ICAP_DWIDTH-1);
        IP2Bus_Data          : out std_logic_vector(0 to C_SAXI_DWIDTH-1);
        Writefifo_full       : out std_logic;
        Writefifo_empty      : out std_logic;
        Readfifo_full        : out std_logic;
        Readfifo_empty       : out std_logic;
        Abort                : out std_logic;
        Rnc                  : out std_logic_vector(0 to 1);
        Status_read          : out std_logic;
        Size                 : out std_logic_vector(0 to 11);
        Size_counter         : in  std_logic_vector(0 to 11);
        IP2Bus_RdAck         : out std_logic;
        IP2Bus_WrAck         : out std_logic;
        IP2Bus_AddrAck       : out std_logic;
        IP2Bus_errAck        : out std_logic;
        Intr_rst             : out std_logic;
        Gate_icap            : out std_logic;
        Gate_icap_p          : out std_logic;
        IP2Bus_Intr          : out std_logic_vector(0 to 3);
        
        	wrfifo_mst_data    : in   std_logic_vector(C_SAXI_DWIDTH-ICAP_DWIDTH to C_SAXI_DWIDTH-1);
		   wrfifo_mst_wen     : in   std_logic;
		   wrfifo_mst_full    : out  std_logic
    );
end entity ipic_if;

-------------------------------------------------------------------------------
-- Architecture section
-------------------------------------------------------------------------------

architecture imp of ipic_if is
  attribute DowngradeIPIdentifiedWarnings: string;
  attribute DowngradeIPIdentifiedWarnings of imp : architecture is "yes";


constant MTBF_STAGES : integer := 4;
constant Z : std_logic_vector(0 to 99) := (others => '0');
constant FGEN_CNT_WIDTH_WR     : integer := log2(C_WRITE_FIFO_DEPTH);
constant ADJ_FGEN_CNT_WIDTH_WR : integer := FGEN_CNT_WIDTH_WR;
constant FGEN_CNT_WIDTH_RD     : integer := log2(C_READ_FIFO_DEPTH);
constant ADJ_FGEN_CNT_WIDTH_RD : integer := FGEN_CNT_WIDTH_RD;
constant ADJ_RDFIFO_DEPTH      : integer := C_READ_FIFO_DEPTH;
constant ADJ_WRFIFO_DEPTH      : integer := C_WRITE_FIFO_DEPTH;
constant HALF_WRFIFO_DEPTH     : integer := C_WRITE_FIFO_DEPTH/2;
constant HALF_RDFIFO_DEPTH     : integer := C_READ_FIFO_DEPTH/2;
constant RD_FIFO_ALMOST_FULL   : integer := C_READ_FIFO_DEPTH-4;
ATTRIBUTE async_reg                      : STRING;
attribute mark_debug : string;

-------------------------------------------------------------------------------
-- Signal Declaration
-------------------------------------------------------------------------------
signal wroccy            : std_logic_vector(0 to ADJ_FGEN_CNT_WIDTH_WR-1);
signal wrvacancy         : std_logic_vector(0 to ADJ_FGEN_CNT_WIDTH_WR-1);
attribute mark_debug of wrvacancy: signal is "true";
signal wr_count         : std_logic_vector(0 to ADJ_FGEN_CNT_WIDTH_RD-1);
signal rd_occy_i         : std_logic_vector(0 to ADJ_FGEN_CNT_WIDTH_RD-1);
signal rdoccy            : std_logic_vector(0 to ADJ_FGEN_CNT_WIDTH_RD-1);
attribute mark_debug of rdoccy: signal is "true";
signal sz_i              : std_logic_vector(0 to 11);
attribute mark_debug of sz_i: signal is "true";
signal Size_i_cdc_tig              : std_logic_vector(0 to 11);
signal Size_i2              : std_logic_vector(0 to 11);
signal Size_counter_i_cdc_tig              : std_logic_vector(0 to 11);
signal Size_counter_i2              : std_logic_vector(0 to 11);
signal Size_counter_i3              : std_logic_vector(0 to 11);
--  ATTRIBUTE async_reg OF Size_i_cdc_tig  : SIGNAL IS "true";
--  ATTRIBUTE async_reg OF Size_i2  : SIGNAL IS "true";
--  ATTRIBUTE async_reg OF Size_counter_i_cdc_tig  : SIGNAL IS "true";
--  ATTRIBUTE async_reg OF Size_counter_i2  : SIGNAL IS "true";
signal cr_i              : std_logic_vector(0 to 4);
attribute mark_debug of cr_i: signal is "true";
signal sr_i              : std_logic_vector(0 to 31);
signal sr_icap2bus_1_cdc_tig     : std_logic_vector(0 to 31);
signal sr_icap2bus_2     : std_logic_vector(0 to 31);
--  ATTRIBUTE async_reg OF sr_icap2bus_1_cdc_tig  : SIGNAL IS "true";
--  ATTRIBUTE async_reg OF sr_icap2bus_2  : SIGNAL IS "true";

signal sr_icap2bus_3     : std_logic_vector(0 to 31);
signal fifo_rst          : std_logic;
signal wrfifo_occy       : std_logic;
signal rdfifo_occy       : std_logic;
signal fifo_clear        : std_logic;
signal sw_reset          : std_logic;
signal IP2Bus_Rderrack   : std_logic;
signal abort_onreset     : std_logic;
signal dt_fifo_wr_i      : std_logic;
signal read_en_qual      : std_logic;
signal wrfifo_full       : std_logic;
signal wrfifo_empty      : std_logic;
signal wrfifo_empty_int      : std_logic;
signal wrfifo_empty_cdc_tig : std_logic;
signal dt_fifo_rd_i      : std_logic;
signal rdfifo_dataout    : std_logic_vector(0 to ICAP_DWIDTH-1);
signal RdFifo_Dout       : std_logic_vector(0 to C_SAXI_DWIDTH-1);
signal rdfifo_full_int       : std_logic;
signal rdfifo_full_cdc_tig       : std_logic;
signal rdfifo_full       : std_logic;
signal rdfifo_empty      : std_logic;
signal rdfifo_rdack      : std_logic;
signal status_read_bus2icap : std_logic;
signal send_done_icap2bus: std_logic;
signal reset_cr_icap2bus : std_logic;
signal send_done_icap2bus_i_cdc_tig : std_logic;
signal reset_cr_icap2bus_i_cdc_tig : std_logic;

--  ATTRIBUTE async_reg OF rdfifo_full_cdc_tig  : SIGNAL IS "true";
--  ATTRIBUTE async_reg OF rdfifo_full  : SIGNAL IS "true";

--  ATTRIBUTE async_reg OF wrfifo_empty_cdc_tig  : SIGNAL IS "true";
--  ATTRIBUTE async_reg OF wrfifo_empty  : SIGNAL IS "true";

--  ATTRIBUTE async_reg OF send_done_icap2bus_i_cdc_tig  : SIGNAL IS "true";
--  ATTRIBUTE async_reg OF status_read_bus2icap  : SIGNAL IS "true";

--  ATTRIBUTE async_reg OF reset_cr_icap2bus_i_cdc_tig  : SIGNAL IS "true";
--  ATTRIBUTE async_reg OF reset_cr_icap2bus  : SIGNAL IS "true";
signal Abort_i_cdc_tig           : std_logic;
signal Abort_i2           : std_logic;
signal Rnc_i_cdc_tig             : std_logic_vector(0 to 1);
signal Rnc_i2             : std_logic_vector(0 to 1);

--  ATTRIBUTE async_reg OF Abort_i_cdc_tig  : SIGNAL IS "true";
--  ATTRIBUTE async_reg OF Abort_i2  : SIGNAL IS "true";
--  ATTRIBUTE async_reg OF Rnc_i_cdc_tig  : SIGNAL IS "true";
--  ATTRIBUTE async_reg OF Rnc_i2  : SIGNAL IS "true";
signal Status_read_i     : std_logic;
signal rdfifo_wren_q     : std_logic;
signal gate_s : std_logic;
signal gate_s_p : std_logic;
signal rdfifo_almost_full : std_logic;
signal gate_signal : std_logic;
signal gate_signal_p : std_logic;
signal rdfifo_half_wr : std_logic;
signal write_data : std_logic_vector(0 to ICAP_DWIDTH-1);
signal Wrfifo_dataout_int : std_logic_vector(0 to ICAP_DWIDTH-1);
signal fifo_full, fifo_empty : std_logic;
signal hang_status_i_cdc_tig, hang_status_i2 : std_logic;
signal ipbus_0, ipbus_1, ipbus_2 : std_logic;
signal ipbus_ack_fifo, ipbus_ack : std_logic;
signal busip_0, busip_1, busip_2 : std_logic;
signal busip_ack_fifo, busip_ack : std_logic;

signal eos_int : std_logic;
signal eos_status_i_cdc_tig : std_logic;
signal eos_status_i2 : std_logic;
signal full_int_1 : std_logic;
signal full_int_2 : std_logic;

signal fifo_full_mask : std_logic;
signal rdfifo_full_d1 : std_logic;
signal rdfifo_full_ip2bus : std_logic;
signal rdfifo_full_fall : std_logic;
--  ATTRIBUTE async_reg OF eos_status_i_cdc_tig  : SIGNAL IS "true";
--  ATTRIBUTE async_reg OF eos_status_i2  : SIGNAL IS "true";

--  ATTRIBUTE async_reg OF hang_status_i_cdc_tig  : SIGNAL IS "true";
--  ATTRIBUTE async_reg OF hang_status_i2  : SIGNAL IS "true";
--signal count_rdce : std_logic_vector (11 downto 0);
--signal count_wrce : std_logic_vector (11 downto 0);
--attribute keep : string;
--attribute keep of count_rdce : signal is "true";
--attribute keep of count_wrce : signal is "true";
-----------------------------------------------------------------------------
-- Begin architecture
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--  Function Declarations
-------------------------------------------------------------------------------
----------------------------------------------------------------------------
-- Replicate sl into a std_logic_vector of width 32.
----------------------------------------------------------------------------
function r32(sl : std_logic) return std_logic_vector is
    variable slv : std_logic_vector(0 to 31) := (others => sl);
begin
    return slv;
end r32;
----------------------------------------------------------------------------
-- Bitwise OR of a std_logic_vector.
----------------------------------------------------------------------------
function or_reduce(slv : std_logic_vector) return std_logic is
    variable r : std_logic := '0';
begin
    for i in slv'range loop
        r := r or slv(i);
    end loop;
    return r;
end or_reduce;

begin -- architecture IMP

-- SIZE_REGISTER_PROCESS
-------------------------------------------------------------------------------
-- This process loads data from the PLB Bus into size register when the
-- corresponding write chip enable is high
-------------------------------------------------------------------------------
  SIZE_REGISTER_PROCESS:process (Bus2IP_Clk)
  begin
    if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
      if sw_reset = '1' then
         sz_i <= (others => '0');
      elsif Bus2IP_wrce(2)= '1' then
         sz_i(0 to 11) <= Bus2IP_Data(20 to 31);
      else
         sz_i <= sz_i;
      end if;
    end if;
  end process SIZE_REGISTER_PROCESS;

BUS2ICAP_SIZE_REGISTER_PROCESS : entity lib_cdc_v1_0.cdc_sync
    generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 0,
        C_VECTOR_WIDTH             => 12,
        C_MTBF_STAGES              => MTBF_STAGES
    )
    port map (
        prmry_aclk                 => Bus2IP_Clk,
        prmry_resetn               => '0',
        prmry_in                   => '0',
        prmry_vect_in              => sz_i,

        scndry_aclk                => ICAP_Clk,
        scndry_resetn              => '0',
        scndry_out                 => open, --awvalid_to,
        scndry_vect_out            => Size
    );



--  BUS2ICAP_SIZE_REGISTER_PROCESS:process (ICAP_Clk)
--  begin
--    if ICAP_Clk'event and ICAP_Clk = '1' then
--      Size_i_cdc_tig     <= sz_i;
--      Size_i2    <= Size_i_cdc_tig;
--      Size    <= Size_i2;
--    end if;
--  end process BUS2ICAP_SIZE_REGISTER_PROCESS;

-- CONTROL_REGISTER_PROCESS
-------------------------------------------------------------------------------
-- This process loads data from the PLB Bus into control register when the
-- corresponding write chip enable is high
-------------------------------------------------------------------------------
  CONTROL_REGISTER_PROCESS:process (Bus2IP_Clk)
  begin
    if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
      if sw_reset = '1' or reset_cr_icap2bus = '1' then
         cr_i <= (others => '0');
      elsif Bus2IP_wrce(3)= '1' then
         cr_i(0 to 4) <= Bus2IP_Data(27 to 31);
      else
         cr_i <= cr_i;
      end if;
    end if;
  end process CONTROL_REGISTER_PROCESS;

-------------------------------------------------------------------------------
-- STATUS_REGISTER_PROCESS
-------------------------------------------------------------------------------
-- This process loads data from Icap_status when Abort_in_progress enabled else
-- loads the Icap_out data into status register
-------------------------------------------------------------------------------
  STATUS_REGISTER_PROCESS:process (ICAP_Clk)
  begin
    if ICAP_Clk'event and ICAP_Clk = '1' then
      if ICAP_Reset = '1' then
         sr_i <= (others => '0');
      elsif Abort_in_progress = '1' then
         sr_i <= Icap_status;
      else
         sr_i <= sr_i; --"00000000000000000000000" & Icap_out(ICAP_DWIDTH-8 to ICAP_DWIDTH-1);
      end if;
    end if;
  end process STATUS_REGISTER_PROCESS;


ICAP2BUS_STATUS_REGISTER_PROCESS : entity lib_cdc_v1_0.cdc_sync
    generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 0,
        C_VECTOR_WIDTH             => 32,
        C_MTBF_STAGES              => MTBF_STAGES
    )
    port map (
        prmry_aclk                 => ICAP_Clk,
        prmry_resetn               => '0',
        prmry_in                   => '0',
        prmry_vect_in              => sr_i,

        scndry_aclk                => Bus2IP_Clk,
        scndry_resetn              => '0',
        scndry_out                 => open, --awvalid_to,
        scndry_vect_out            => sr_icap2bus_3
    );


--  ICAP2BUS_STATUS_REGISTER_PROCESS:process (Bus2IP_Clk)
--  begin
--    if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
--       sr_icap2bus_1_cdc_tig <= sr_i;
--       sr_icap2bus_2 <= sr_icap2bus_1_cdc_tig;
--       sr_icap2bus_3 <= sr_icap2bus_2;
--    end if;
--  end process ICAP2BUS_STATUS_REGISTER_PROCESS;

-------------------------------------------------------------------------------
-- DATA FIFO INSTANTIATION
-------------------------------------------------------------------------------

WRFIFO : if (C_MODE = 0) generate
begin
   read_en_qual <= Wrfifo_rden and not wrfifo_empty_int;
   --dt_fifo_wr_i <= Bus2IP_wrce(0) and not(wrfifo_full) and (busip_ack);
   dt_fifo_wr_i <= wrfifo_mst_wen and not(wrfifo_full) ;   
   wrfifo_mst_full <= wrfifo_full;

   WRDATA_FIFO_I: entity lib_fifo_v1_0.async_fifo_fg
     generic map(
       C_ALLOW_2N_DEPTH   => 1,  -- New paramter to leverage FIFO Gen 2**N depth
       C_FAMILY           => C_FAMILY,  -- new for FIFO Gen
       C_DATA_WIDTH       => ICAP_DWIDTH,
       C_ENABLE_RLOCS     => 0,  -- not supported in FG
       C_FIFO_DEPTH       => ADJ_WRFIFO_DEPTH,
       C_HAS_ALMOST_EMPTY => 1,
       C_HAS_ALMOST_FULL  => 1,
       C_HAS_RD_ACK       => 1,
       C_HAS_RD_COUNT     => 1,
       C_HAS_RD_ERR       => 0,
       C_HAS_WR_ACK       => 1,
       C_HAS_WR_COUNT     => 1,
       C_HAS_WR_ERR       => 0,
       C_RD_ACK_LOW       => 0,
       C_RD_COUNT_WIDTH   => ADJ_FGEN_CNT_WIDTH_WR,
       C_RD_ERR_LOW       => 0,
       C_USE_BLOCKMEM     => C_BRAM_SRL_FIFO_TYPE,  -- 0 = distributed RAM, 1 = BRAM
       C_WR_ACK_LOW       => 0,
       C_WR_COUNT_WIDTH   => ADJ_FGEN_CNT_WIDTH_WR,
       C_WR_ERR_LOW       => 0,
       C_SYNCHRONIZER_STAGE  =>  MTBF_STAGES 
     )
     port map(
       Din            => wrfifo_mst_data, --Bus2IP_Data(C_SAXI_DWIDTH-ICAP_DWIDTH to C_SAXI_DWIDTH-1),
       Wr_en          => dt_fifo_wr_i,
       Wr_clk         => Bus2IP_Clk,
       Rd_en          => read_en_qual,
       Rd_clk         => ICAP_Clk,
       Ainit          => fifo_clear,
       Dout           => Wrfifo_dataout,
       Full           => wrfifo_full,
       Empty          => wrfifo_empty_int,
       Almost_full    => open,
       Almost_empty   => open,
       Wr_count       => wroccy,
       Rd_count       => open,
       Rd_ack         => open,
       Rd_err         => open,
       Wr_ack         => open,
       Wr_err         => open
     );



   wrvacancy <= ((conv_std_logic_vector((C_WRITE_FIFO_DEPTH),(log2(C_WRITE_FIFO_DEPTH))) - (wroccy)) -1);

WREMPTY_SYNCH : entity lib_cdc_v1_0.cdc_sync
    generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_VECTOR_WIDTH             => 32,
        C_MTBF_STAGES              => MTBF_STAGES
    )
    port map (
        prmry_aclk                 => ICAP_Clk,
        prmry_resetn               => '0',
        prmry_in                   => wrfifo_empty_int,
        prmry_vect_in              => (others => '0'),

        scndry_aclk                => Bus2IP_Clk,
        scndry_resetn              => '0',
        scndry_out                 => wrfifo_empty, --awvalid_to,
        scndry_vect_out            => open
    );



--  WREMPTY_SYNCH:process (Bus2IP_Clk)
--  begin
--    if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
--       wrfifo_empty_cdc_tig <= wrfifo_empty_int;
--       wrfifo_empty <= wrfifo_empty_cdc_tig;
--
--    end if;
--  end process;


end generate WRFIFO;

NO_WRFIFO : if (C_MODE = 1) generate
begin
-- Write from AXI4-Lite
   read_en_qual <= Wrfifo_rden; -- and not wrfifo_empty;
   dt_fifo_wr_i <= Bus2IP_wrce(0); -- and not(wrfifo_full);

  WRT_PROCESS:process (fifo_clear, Bus2IP_Clk)
  begin
    if (fifo_clear = '1') then
        write_data <= (others => '0');
        wrfifo_full <= '0';
        fifo_empty <= '1'; 
        wrvacancy (ADJ_FGEN_CNT_WIDTH_WR-1) <= '1';
        wrvacancy (0 to ADJ_FGEN_CNT_WIDTH_WR-2) <= (others => '0'); 
    elsif Bus2IP_Clk'event and Bus2IP_Clk = '1' then
      if (dt_fifo_wr_i = '1') then
        write_data <= Bus2IP_Data(C_SAXI_DWIDTH-ICAP_DWIDTH to C_SAXI_DWIDTH-1); 
        wrfifo_full <= '1';
        wrvacancy <= (others => '0');
        fifo_empty <= '0'; 
      else
        write_data <= write_data;
        wrfifo_full <= wrfifo_full and fifo_full;
        wrvacancy <= wrvacancy; 
        fifo_empty <= fifo_empty; 
      end if;
    end if;
  end process WRT_PROCESS;


  RD_PROCESS:process (fifo_clear, ICAP_Clk)
  begin
    if (fifo_clear = '1') then
      Wrfifo_dataout_int <= (others => '0');
      wrfifo_empty <= '1';
      fifo_full <= '0';
    elsif ICAP_Clk'event and ICAP_Clk = '1' then
      if (read_en_qual = '1') then
        Wrfifo_dataout_int <= write_data;
        wrfifo_empty <= '1';
        fifo_full <= '0';
      else
        Wrfifo_dataout_int <= Wrfifo_dataout_int;
        wrfifo_empty <= fifo_empty and wrfifo_empty;
        fifo_full <= wrfifo_full;
      end if;
    end if;
  end process RD_PROCESS;

Wrfifo_dataout <= Wrfifo_dataout_int;

end generate NO_WRFIFO;

RD_FIFO : if (C_NOREAD = 0) generate
   rdfifo_wren_q <= Rdfifo_wren and (not rdfifo_full_int);


   RDDATA_FIFO_I: entity lib_fifo_v1_0.async_fifo_fg
     generic map(
       C_ALLOW_2N_DEPTH   => 1,  -- New paramter to leverage FIFO Gen 2**N depth
       C_FAMILY           => C_FAMILY,  -- new for FIFO Gen
       C_DATA_WIDTH       => ICAP_DWIDTH,
       C_ENABLE_RLOCS     => 0,  -- not supported in FG
       C_FIFO_DEPTH       => ADJ_RDFIFO_DEPTH,
       C_HAS_ALMOST_EMPTY => 1,
       C_HAS_ALMOST_FULL  => 1,
       C_HAS_RD_ACK       => 1,
       C_HAS_RD_COUNT     => 1,
       C_HAS_RD_ERR       => 0,
       C_HAS_WR_ACK       => 1,
       C_HAS_WR_COUNT     => 1,
       C_HAS_WR_ERR       => 0,
       C_RD_ACK_LOW       => 0,
       C_RD_COUNT_WIDTH   => ADJ_FGEN_CNT_WIDTH_RD,
       C_RD_ERR_LOW       => 0,
       C_USE_BLOCKMEM     => C_BRAM_SRL_FIFO_TYPE,  -- 0 = distributed RAM, 1 = BRAM
       C_WR_ACK_LOW       => 0,
       C_WR_COUNT_WIDTH   => ADJ_FGEN_CNT_WIDTH_RD,
       C_WR_ERR_LOW       => 0,
       C_SYNCHRONIZER_STAGE  =>  MTBF_STAGES
     )
     port map(
       Din            => Rdfifo_datain,
       Wr_en          => rdfifo_wren_q, --Rdfifo_wren,
       Wr_clk         => ICAP_Clk,
       Rd_en          => dt_fifo_rd_i,
       Rd_clk         => Bus2IP_Clk,
       Ainit          => fifo_clear,
       Dout           => rdfifo_dataout,
       Full           => rdfifo_full_int,
       Empty          => rdfifo_empty,
       Almost_full    => open,
       Almost_empty   => open,
       Wr_count       => wr_count,
       Rd_count       => rd_occy_i,
       Rd_ack         => rdfifo_rdack,
       Rd_err         => open,
       Wr_ack         => open,
       Wr_err         => open
     );


   rdoccy    <= rd_occy_i;

--   dt_fifo_rd_i <= Bus2IP_rdce(1) and not(rdfifo_empty) and (not rdfifo_rdack);
   dt_fifo_rd_i <= Bus2IP_rdce(1) and not(rdfifo_empty) and (ipbus_ack);

--  process (ICAP_Clk,fifo_clear)
--  begin
--    if (fifo_clear = '1') then
--      full_int_clear_1 <= '1';
--      full_int_clear_2 <= '1';
--    elsif ICAP_Clk'event and ICAP_Clk = '1' then
--      full_int_clear_1 <= '0';
--      full_int_clear_2 <= full_int_clear_1;
--    end if;
--  end process;

--   FIFO_FULL_PROCESS:process (ICAP_Clk,full_int_clear_2)
--  begin
--    if (fifo_int_clear_2 = '1') then
--      full_int_1 <= '1';
--      full_int_2 <= '0';
--    elsif ICAP_Clk'event and ICAP_Clk = '1' then
--      if ((full_int_1 = '1') and (rdfifo_full_int = '1'))  then
--        full_int_2 <= '0';
--      else
--        full_int_2 <= rdfifo_full_int;
--        full_int_1 <= '0';
--      end if;
--    end if;
--  end process FIFO_FULL_PROCESS;
  
   

RDFULL_SYNCH : entity lib_cdc_v1_0.cdc_sync
    generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_VECTOR_WIDTH             => 32,
        C_MTBF_STAGES              => MTBF_STAGES-1
    )
    port map (
        prmry_aclk                 => ICAP_Clk,
        prmry_resetn               => '0',
        prmry_in                   => rdfifo_full_int,
        prmry_vect_in              => (others => '0'),

        scndry_aclk                => Bus2IP_Clk,
        scndry_resetn              => '0',
        scndry_out                 => rdfifo_full_ip2bus, --awvalid_to,
        scndry_vect_out            => open
    );


    process (Bus2IP_Clk)
    begin
      if (Bus2IP_Clk'event and Bus2IP_Clk = '1') then
               rdfifo_full_d1 <= rdfifo_full_ip2bus;
      end if;
    end process;

        rdfifo_full_fall <= rdfifo_full_d1 and (not rdfifo_full_ip2bus);

    process (Bus2IP_Clk)
    begin
      if (Bus2IP_Clk'event and Bus2IP_Clk = '1') then
          if (fifo_clear = '1') then
               fifo_full_mask <= '0';
          elsif (rdfifo_full_fall = '1') then
               fifo_full_mask <= '1';
          end if;
      end if;
    end process;

     rdfifo_full <= fifo_full_mask and rdfifo_full_d1;

--  RDFULL_SYNCH:process (Bus2IP_Clk)
--  begin
--    if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
--       rdfifo_full_cdc_tig <= rdfifo_full_int;
--       rdfifo_full <= rdfifo_full_cdc_tig;
--
--    end if;
--  end process;

end generate RD_FIFO;

NORD_FIFO : if (C_NOREAD = 1) generate
begin

rdfifo_dataout <= (others => '0');
rdfifo_full <= '0';
rdfifo_empty <= '0';
wr_count <= (others => '0');
rdoccy <= (others => '0');
rdfifo_rdack <= '1'; -- to make sure read does not hang

end generate NORD_FIFO;
-- In order to gate the ICAP_Clk, a gating signal has to be generated
-- This signal is generated when RDFIFO is at RD_FIFO_ALMOST_FULL
-- This makes sure that the ICAP is gated at the right time such that
-- no data is lost and also the FIFO becomes full
-- The gating signal is them released when RDFIFO is HALF_RDFIFO_DEPTH
-- To be on the safer side, gating signal is driven on negedge of ICAP_Clk

   rdfifo_almost_full <= '1' when (wr_count >= RD_FIFO_ALMOST_FULL) else '0';
   rdfifo_half_wr <= '1' when (wr_count <= HALF_RDFIFO_DEPTH) else '0';


   gate_s <= rdfifo_almost_full;

   gate_stretch_process : process (ICAP_Clk)
   begin
      if ICAP_Clk'event and ICAP_Clk = '0' then
         if ICAP_Reset = '1' then
            gate_signal <= '0';
         elsif (gate_s = '1') then
            gate_signal <= '1';
         elsif (rdfifo_half_wr = '1') then
            gate_signal <= '0';
         else
            gate_signal <= gate_signal;
         end if;
      end if;
   end process;
          
   Gate_icap <= gate_signal;

-- A replica of gating signal is generated on posedge
-- This is required to make sure that extra or invalid 
-- wren are not generated for RDFIFO when the ICAP is
-- gated

   gate_s_p <= rdfifo_almost_full;

   gate_stretch_p_process : process (ICAP_Clk)
   begin
      if ICAP_Clk'event and ICAP_Clk = '1' then
         if ICAP_Reset = '1' then
            gate_signal_p <= '0';
         elsif (gate_s_p = '1') then
            gate_signal_p <= '1';
         elsif (rdfifo_half_wr = '1') then
            gate_signal_p <= '0';
         else
            gate_signal_p <= gate_signal_p;
         end if;
      end if;
   end process;
          
   Gate_icap_p <= gate_signal_p;



--   count_rdce_process : process (Bus2IP_Clk)
--   begin
--		if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
--			if (dt_fifo_rd_i = '1') then
--                           count_rdce <= count_rdce + '1';
--                        end if;
--                 end if;
--   end process;
--   count_wrce_process : process (ICAP_Clk)
--   begin
--		if ICAP_Clk'event and ICAP_Clk = '1' then
--			if (rdfifo_wren_q = '1') then
--                           count_wrce <= count_wrce + '1';
--                        end if;
--                 end if;
--   end process;

-------------------------------------------------------------------------------
-- FIFO_RESET_PROCESS
-------------------------------------------------------------------------------
-- This process generates fifo reset signal based on status in control register
-------------------------------------------------------------------------------

  FIFO_RESET_PROCESS:process (Bus2IP_Clk)
  begin
    if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
      if Bus2IP_Reset = '1' then
        abort_onreset<= '1';
        fifo_rst  <= '1';
        sw_reset  <= '1';
        Intr_rst  <= '1';
        Size_counter_i3 <= (others => '0'); 
      else
        abort_onreset<= (cr_i(0) and reset_cr_icap2bus);
        Intr_rst  <= cr_i(1);
        sw_reset  <= cr_i(1);
        fifo_rst  <= cr_i(2);
        Size_counter_i3 <= Size_counter_i2;
      end if;
    end if;
  end process FIFO_RESET_PROCESS;

  fifo_clear <= sw_reset or fifo_rst or abort_onreset;

-------------------------------------------------------------------------------
-- Interrupt generation
-------------------------------------------------------------------------------

wrfifo_occy <= '1' when wroccy <= HALF_WRFIFO_DEPTH else
                   '0';  -- generation of interupt based on PIRQ value
rdfifo_occy <= '1' when rdoccy >= HALF_RDFIFO_DEPTH else
                   '0';  -- generation of interupt based on PIRQ value

-------------------------------------------------------------------------------
-- Pasing out the interrupts
-------------------------------------------------------------------------------

  IP2Bus_Intr <= (others => '0') when sw_reset = '1' else
               wrfifo_occy & rdfifo_occy & wrfifo_empty & rdfifo_full;
-------------------------------------------------------------------------------
-- READ_REGISTER_PROCESS
-------------------------------------------------------------------------------
-- Process for IP2Bus_Data. This process is for reading data from the Control
-- register,FIFO, FIFO occupancy register and pirq register. This reading of
-- data depends on assertion of one of the bits of Bus2IP_rdce on rising edge
-- of Bus2IP_CLK. Reading of any of
-- these registers is accompanied by assertion of IP to Bus read acknowledge
-- signal.
-------------------------------------------------------------------------------

  READ_REGISTER_PROCESS : process(Bus2IP_CLK)
  begin
     if (Bus2IP_CLK'event and Bus2IP_CLK = '1') then
       if sw_reset = '1' then
         IP2Bus_Data <= (others=> '0');
         IP2Bus_RdAck<= '0';
         IP2Bus_Rderrack <= '0';
         IP2Bus_WrAck   <= '0';
       else
         IP2Bus_Data <=
              (r32(Bus2IP_rdce(1)) and (RdFifo_Dout))
           or (r32(Bus2IP_rdce(2)) and (Z(0 to 19) & Size_counter_i3(0 to 11)))
           or (r32(Bus2IP_rdce(3)) and (Z(0 to 26) & cr_i(0 to 4)))
           or (r32(Bus2IP_rdce(4)) and (Z(0 to 28) & eos_status_i2 & hang_status_i2 & send_done_icap2bus))
           or (r32(Bus2IP_rdce(5)) and (Z(0 to (31 -log2(C_WRITE_FIFO_DEPTH))) & wrvacancy(0 to log2(C_WRITE_FIFO_DEPTH)-1)))
           or (r32(Bus2IP_rdce(6)) and (Z(0 to (31 -log2(C_READ_FIFO_DEPTH))) & rdoccy(0 to log2(C_READ_FIFO_DEPTH)-1)))
           or (r32(Bus2IP_rdce(7)) and (sr_icap2bus_3));
         IP2Bus_RdAck   <= ((or_reduce(Bus2IP_rdce(2 to 7))) and ipbus_ack) or
                             (Bus2IP_rdce(1) and ipbus_ack_fifo);
         IP2Bus_Rderrack<= (Bus2IP_rdce(0));
         IP2Bus_WrAck   <= ((or_reduce(Bus2IP_wrce(1 to 7)) 
		                     or (Bus2IP_wrce(0) and (not (wrfifo_full))))
							  and busip_ack);
       end if;
     end if;
  end process READ_REGISTER_PROCESS;

-------------------------------------------------------------------------------
-- RdFifo_Dout
-------------------------------------------------------------------------------
RDFIFO_DATA: process (rdfifo_dataout) is
  begin
        RdFifo_Dout <= rdfifo_dataout;
  end process RDFIFO_DATA;

-------------------------------------------------------------------------------
-- IP2BUS_ACK
-------------------------------------------------------------------------------
-- IP2Bus_Ack on same cycle as data is taken.
-------------------------------------------------------------------------------
   ipbus_0 <= (or_reduce (Bus2IP_rdce(0 to 7)));

  IPBUS_SYNCH:process (Bus2IP_Clk)
  begin
    if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
       ipbus_1 <= ipbus_0;
       ipbus_2 <= ipbus_1;
     
       ipbus_ack_fifo <= ipbus_ack;  
     
    end if;
  end process;

   ipbus_ack <= ipbus_1 and (not ipbus_2);

   busip_0 <= (or_reduce (Bus2IP_wrce(0 to 7)));

  BUSIP_SYNCH:process (Bus2IP_Clk)
  begin
    if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
       busip_1 <= busip_0;
       busip_2 <= busip_1;
     
       busip_ack_fifo <= busip_ack;  
     
    end if;
  end process;

   busip_ack <= busip_0 and (not busip_1);
--   IP2Bus_RdAck   <= ((or_reduce(Bus2IP_rdce(2 to 7)))) or
--                             (Bus2IP_rdce(1) and rdfifo_rdack);

--   IP2Bus_RdAck   <= ((or_reduce(Bus2IP_rdce(2 to 7))) and ipbus_ack) or
--                             (Bus2IP_rdce(1) and ipbus_ack_fifo);

 --  IP2Bus_Rderrack<= (Bus2IP_rdce(0)or
  --                           Bus2IP_rdce(7));
--   IP2Bus_WrAck   <= or_reduce(Bus2IP_wrce(0 to 7) and busip_ack);
   IP2Bus_AddrAck <= or_reduce(Bus2IP_wrce(0 to 7)) or 
                     (or_reduce(Bus2IP_rdce(0 to 7)));

   IP2Bus_errAck <= '0'; --Bus2IP_wrce(1) or or_reduce(Bus2IP_wrce(4 to 7)) or
                         --  IP2Bus_Rderrack;

   Writefifo_full <=  wrfifo_full;
WRFIFO_INCL : if (C_MODE = 0) generate
begin
   Writefifo_empty<=  wrfifo_empty_int;
end generate WRFIFO_INCL;

WRFIFO_NOT_INCL : if (C_MODE = 1) generate
begin
   Writefifo_empty<=  wrfifo_empty;
end generate WRFIFO_NOT_INCL;

   Readfifo_full  <=  rdfifo_full_int;
   Readfifo_empty <=  rdfifo_empty;

-------------------------------------------------------------------------------
-- This process generates synchronizes signals from plb bus to ICAP clock
-------------------------------------------------------------------------------

PLB2ICAP_SYNCH1 : entity lib_cdc_v1_0.cdc_sync
    generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_VECTOR_WIDTH             => 32,
        C_MTBF_STAGES              => MTBF_STAGES
    )
    port map (
        prmry_aclk                 => Bus2IP_Clk,
        prmry_resetn               => '0',
        prmry_in                   => cr_i(0),
        prmry_vect_in              => (others => '0'),

        scndry_aclk                => ICAP_Clk,
        scndry_resetn              => '0',
        scndry_out                 => Abort, --awvalid_to,
        scndry_vect_out            => open
    );

PLB2ICAP_SYNCH2 : entity lib_cdc_v1_0.cdc_sync
    generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_VECTOR_WIDTH             => 32,
        C_MTBF_STAGES              => MTBF_STAGES
    )
    port map (
        prmry_aclk                 => Bus2IP_Clk,
        prmry_resetn               => '0',
        prmry_in                   => cr_i(3),
        prmry_vect_in              => (others => '0'),

        scndry_aclk                => ICAP_Clk,
        scndry_resetn              => '0',
        scndry_out                 => Rnc(0), --awvalid_to,
        scndry_vect_out            => open
    );

PLB2ICAP_SYNCH3 : entity lib_cdc_v1_0.cdc_sync
    generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_VECTOR_WIDTH             => 32,
        C_MTBF_STAGES              => MTBF_STAGES
    )
    port map (
        prmry_aclk                 => Bus2IP_Clk,
        prmry_resetn               => '0',
        prmry_in                   => cr_i(4),
        prmry_vect_in              => (others => '0'),

        scndry_aclk                => ICAP_Clk,
        scndry_resetn              => '0',
        scndry_out                 => Rnc(1), --awvalid_to,
        scndry_vect_out            => open
    );




  PLB2ICAP_SYNCH:process (ICAP_Clk)
  begin
    if ICAP_Clk'event and ICAP_Clk = '1' then
--        Abort_i_cdc_tig      <= cr_i(0);
--        Rnc_i_cdc_tig        <= cr_i(3 to 4);
        Status_read_i<= status_read_bus2icap;
--        Abort_i2     <= Abort_i_cdc_tig;      
--        Abort        <= Abort_i2;      
--        Rnc_i2       <= Rnc_i_cdc_tig;        
--        Rnc          <= Rnc_i2;        
        Status_read  <= Status_read_i;
    end if;
  end process PLB2ICAP_SYNCH;

-------------------------------------------------------------------------------
-- This process generates synchronizes signals from ICAP clock to plb clock
-------------------------------------------------------------------------------

ICAP2PLB_SYNCH1 : entity lib_cdc_v1_0.cdc_sync
    generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_VECTOR_WIDTH             => 32,
        C_MTBF_STAGES              => MTBF_STAGES
    )
    port map (
        prmry_aclk                 => ICAP_Clk,
        prmry_resetn               => '0',
        prmry_in                   => Send_done,
        prmry_vect_in              => (others => '0'),

        scndry_aclk                => Bus2IP_Clk,
        scndry_resetn              => '0',
        scndry_out                 => send_done_icap2bus,
        scndry_vect_out            => open
    );

ICAP2PLB_SYNCH2 : entity lib_cdc_v1_0.cdc_sync
    generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_VECTOR_WIDTH             => 32,
        C_MTBF_STAGES              => MTBF_STAGES
    )
    port map (
        prmry_aclk                 => ICAP_Clk,
        prmry_resetn               => '0',
        prmry_in                   => Reset_cr,
        prmry_vect_in              => (others => '0'),

        scndry_aclk                => Bus2IP_Clk,
        scndry_resetn              => '0',
        scndry_out                 => reset_cr_icap2bus,
        scndry_vect_out            => open
    );


ICAP2PLB_SYNCH3 : entity lib_cdc_v1_0.cdc_sync
    generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_VECTOR_WIDTH             => 32,
        C_MTBF_STAGES              => MTBF_STAGES
    )
    port map (
        prmry_aclk                 => ICAP_Clk,
        prmry_resetn               => '0',
        prmry_in                   => Hang_status,
        prmry_vect_in              => (others => '0'),

        scndry_aclk                => Bus2IP_Clk,
        scndry_resetn              => '0',
        scndry_out                 => hang_status_i2,
        scndry_vect_out            => open
    );

ICAP2PLB_SYNCH4 : entity lib_cdc_v1_0.cdc_sync
    generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_VECTOR_WIDTH             => 32,
        C_MTBF_STAGES              => MTBF_STAGES
    )
    port map (
        prmry_aclk                 => ICAP_Clk,
        prmry_resetn               => '0',
        prmry_in                   => eos_int,
        prmry_vect_in              => (others => '0'),

        scndry_aclk                => Bus2IP_Clk,
        scndry_resetn              => '0',
        scndry_out                 => eos_status_i2,
        scndry_vect_out            => open
    );


ICAP2PLB_SYNCH5 : entity lib_cdc_v1_0.cdc_sync
    generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 0,
        C_VECTOR_WIDTH             => 12,
        C_MTBF_STAGES              => MTBF_STAGES
    )
    port map (
        prmry_aclk                 => ICAP_Clk,
        prmry_resetn               => '0',
        prmry_in                   => '0',
        prmry_vect_in              => Size_counter,

        scndry_aclk                => Bus2IP_Clk,
        scndry_resetn              => '0',
        scndry_out                 => open,
        scndry_vect_out            => Size_counter_i2
    );

--  ICAP2PLB_SYNCH:process (Bus2IP_Clk)
--  begin
--    if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
--        send_done_icap2bus_i_cdc_tig <= Send_done;
--        reset_cr_icap2bus_i_cdc_tig  <= Reset_cr;
--        send_done_icap2bus   <= send_done_icap2bus_i_cdc_tig;
--        reset_cr_icap2bus    <= reset_cr_icap2bus_i_cdc_tig;

--        hang_status_i_cdc_tig <= Hang_status;
--        hang_status_i2 <= hang_status_i_cdc_tig;

--        eos_status_i_cdc_tig <= eos_int;
--        eos_status_i2 <= eos_status_i_cdc_tig;

--        Size_counter_i_cdc_tig <= Size_counter;
--        Size_counter_i2 <= Size_counter_i_cdc_tig;
--    end if;
--  end process ICAP2PLB_SYNCH;

STARTUP_INCLUDE : if (C_INCLUDE_STARTUP = 1) generate
begin


GEN_7Series_STARTUP : if ( 
            (C_FAMILY = "virtex7") or
            (C_FAMILY = "kintex7") or
            (C_FAMILY = "zynq") or
            (C_FAMILY = "artix7")  
           )
generate

    STARTUPE2_inst : STARTUPE2
    generic map (
    PROG_USR => "FALSE", 
    SIM_CCLK_FREQ => 0.0 
    )
    port map (
    CFGCLK => open,
    CFGMCLK => open,
    EOS => eos_int,
    PREQ => open,
    CLK => '0',
    GSR => '0',
    GTS => '0',
    KEYCLEARB => '0',
    PACK => '0',
    USRCCLKO => '0',
    USRCCLKTS => '0',
    USRDONEO => '1',
    USRDONETS => '0'
);

end generate GEN_7Series_STARTUP;


end generate STARTUP_INCLUDE;


NOSTARTUP_INCLUDE : if (C_INCLUDE_STARTUP = 0) generate
begin

GEN_7Series_NOSTARTUP : if ( 
            (C_FAMILY = "virtex7") or
            (C_FAMILY = "kintex7") or
            (C_FAMILY = "zynq") or
            (C_FAMILY = "artix7")  
           ) generate
begin
     eos_int <= Eos_in;

end generate GEN_7Series_NOSTARTUP;


GEN_8Series_NOSTARTUP : if ( 
                          C_FAMILY = "virtexu" or
                          C_FAMILY = "kintexu" or
                          C_FAMILY = "artixu"
                           ) generate
begin

     eos_int <= icap_available;

end generate GEN_8Series_NOSTARTUP;

end generate NOSTARTUP_INCLUDE;

end imp;

