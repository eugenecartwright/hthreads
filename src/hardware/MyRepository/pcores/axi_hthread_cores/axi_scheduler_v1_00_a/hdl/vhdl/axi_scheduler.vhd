------------------------------------------------------------------------------
-- axi_scheduler.vhd - entity/architecture pair
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
-- ** Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.            **
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
-- Filename:          axi_scheduler.vhd
-- Version:           1.00.a
-- Description:       Top level design, instantiates library components and user logic.
-- Date:              Thu Jun 26 14:24:54 2014 (by Create and Import Peripheral Wizard)
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

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.all;
use proc_common_v3_00_a.ipif_pkg.all;

library axi_lite_ipif_v1_01_a;
use axi_lite_ipif_v1_01_a.axi_lite_ipif;

library axi_master_lite_v1_00_a;
use axi_master_lite_v1_00_a.axi_master_lite;

library axi_scheduler_v1_00_a;
use axi_scheduler_v1_00_a.user_logic;

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_S_AXI_DATA_WIDTH           -- AXI4LITE slave: Data width
--   C_S_AXI_ADDR_WIDTH           -- AXI4LITE slave: Address Width
--   C_S_AXI_MIN_SIZE             -- AXI4LITE slave: Min Size
--   C_USE_WSTRB                  -- AXI4LITE slave: Write Strobe
--   C_DPHASE_TIMEOUT             -- AXI4LITE slave: Data Phase Timeout
--   C_BASEADDR                   -- AXI4LITE slave: base address
--   C_HIGHADDR                   -- AXI4LITE slave: high address
--   C_FAMILY                     -- FPGA Family
--   C_NUM_REG                    -- Number of software accessible registers
--   C_NUM_MEM                    -- Number of address-ranges
--   C_SLV_AWIDTH                 -- Slave interface address bus width
--   C_SLV_DWIDTH                 -- Slave interface data bus width
--   C_M_AXI_LITE_ADDR_WIDTH      -- Master-Intf address bus width
--   C_M_AXI_LITE_DATA_WIDTH      -- Master-Intf data bus width
--
-- Definition of Ports:
--   S_AXI_ACLK                   -- AXI4LITE slave: Clock 
--   S_AXI_ARESETN                -- AXI4LITE slave: Reset
--   S_AXI_AWADDR                 -- AXI4LITE slave: Write address
--   S_AXI_AWVALID                -- AXI4LITE slave: Write address valid
--   S_AXI_WDATA                  -- AXI4LITE slave: Write data
--   S_AXI_WSTRB                  -- AXI4LITE slave: Write strobe
--   S_AXI_WVALID                 -- AXI4LITE slave: Write data valid
--   S_AXI_BREADY                 -- AXI4LITE slave: Response ready
--   S_AXI_ARADDR                 -- AXI4LITE slave: Read address
--   S_AXI_ARVALID                -- AXI4LITE slave: Read address valid
--   S_AXI_RREADY                 -- AXI4LITE slave: Read data ready
--   S_AXI_ARREADY                -- AXI4LITE slave: read addres ready
--   S_AXI_RDATA                  -- AXI4LITE slave: Read data
--   S_AXI_RRESP                  -- AXI4LITE slave: Read data response
--   S_AXI_RVALID                 -- AXI4LITE slave: Read data valid
--   S_AXI_WREADY                 -- AXI4LITE slave: Write data ready
--   S_AXI_BRESP                  -- AXI4LITE slave: Response
--   S_AXI_BVALID                 -- AXI4LITE slave: Resonse valid
--   S_AXI_AWREADY                -- AXI4LITE slave: Wrte address ready
--   m_axi_lite_aclk              -- AXI4LITE master: Clock
--   m_axi_lite_aresetn           -- AXI4LITE master: Reset
--   md_error                     -- AXI4LITE master: Error
--   m_axi_lite_arready           -- AXI4LITE master: Read address ready
--   m_axi_lite_arvalid           -- AXI4LITE master: read address valid
--   m_axi_lite_araddr            -- AXI4LITE master: read address protection
--   m_axi_lite_arprot            -- AXI4LITE master: Read address protection
--   m_axi_lite_rready            -- AXI4LITE master: Read data ready
--   m_axi_lite_rvalid            -- AXI4LITE master: Read data valid
--   m_axi_lite_rdata             -- AXI4LITE master: Read data
--   m_axi_lite_rresp             -- AXI4LITE master: read data response
--   m_axi_lite_awready           -- AXI4LITE master: write address ready
--   m_axi_lite_awvalid           -- AXI4LITE master: write address valid
--   m_axi_lite_awaddr            -- AXI4LITE master: write address valid
--   m_axi_lite_awprot            -- AXI4LITE master: write address protection
--   m_axi_lite_wready            -- AXI4LITE master: write data ready
--   m_axi_lite_wvalid            -- AXI4LITE master: write data valid
--   m_axi_lite_wdata             -- AXI4LITE master: write data
--   m_axi_lite_wstrb             -- AXI4LITE master: write data strobe
--   m_axi_lite_bready            -- AXI4LITE master: read response ready
--   m_axi_lite_bvalid            -- AXI4LITE master: read response valid
--   m_axi_lite_bresp             -- AXI4LITE master: read response
------------------------------------------------------------------------------

entity axi_scheduler is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
    --USER generics added here
    -- ADD USER GENERICS ABOVE THIS LINE ---------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_S_AXI_DATA_WIDTH             : integer              := 32;
    C_S_AXI_ADDR_WIDTH             : integer              := 32;
    C_S_AXI_MIN_SIZE               : std_logic_vector     := X"00FFFFFF";
    C_USE_WSTRB                    : integer              := 0;
    C_DPHASE_TIMEOUT               : integer              := 0;
    C_BASEADDR                     : std_logic_vector(0 to 31)     := X"FFFFFFFF";
    C_HIGHADDR                     : std_logic_vector(0 to 31)     := X"00000000";
    C_FAMILY                       : string               := "virtex6";
    C_NUM_REG                      : integer              := 1;
    C_NUM_MEM                      : integer              := 1;
    C_SLV_AWIDTH                   : integer              := 32;
    C_SLV_DWIDTH                   : integer              := 32;
    C_M_AXI_LITE_ADDR_WIDTH        : integer              := 32;
    C_M_AXI_LITE_DATA_WIDTH        : integer              := 32
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------
   Soft_Reset      : in  std_logic;

    Reset_Done      : out std_logic;
    Soft_Stop       : in  std_logic;
    
    SWTM_DOB        : in  std_logic_vector(0 to 31); 
    SWTM_ADDRB      : out std_logic_vector(0 to 8);
    SWTM_DIB        : out std_logic_vector(0 to 31);
    SWTM_ENB        : out std_logic;  
    SWTM_WEB        : out std_logic;

    TM2SCH_current_cpu_tid  : in std_logic_vector(0 to 7);
    TM2SCH_opcode           : in std_logic_vector(0 to 5);
    TM2SCH_data             : in std_logic_vector(0 to 7);
    TM2SCH_request          : in std_logic;
    SCH2TM_busy             : out std_logic;
    SCH2TM_data             : out std_logic_vector(0 to 7);
    SCH2TM_next_cpu_tid     : out std_logic_vector(0 to 7);
    SCH2TM_next_tid_valid   : out std_logic;

    Preemption_Interrupt : out std_logic;
    -- ADD USER PORTS ABOVE THIS LINE ------------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol ports, do not add to or delete
    S_AXI_ACLK                     : in  std_logic;
    S_AXI_ARESETN                  : in  std_logic;
    S_AXI_AWADDR                   : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_AWVALID                  : in  std_logic;
    S_AXI_WDATA                    : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_WSTRB                    : in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
    S_AXI_WVALID                   : in  std_logic;
    S_AXI_BREADY                   : in  std_logic;
    S_AXI_ARADDR                   : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_ARVALID                  : in  std_logic;
    S_AXI_RREADY                   : in  std_logic;
    S_AXI_ARREADY                  : out std_logic;
    S_AXI_RDATA                    : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_RRESP                    : out std_logic_vector(1 downto 0);
    S_AXI_RVALID                   : out std_logic;
    S_AXI_WREADY                   : out std_logic;
    S_AXI_BRESP                    : out std_logic_vector(1 downto 0);
    S_AXI_BVALID                   : out std_logic;
    S_AXI_AWREADY                  : out std_logic;
    m_axi_lite_aclk                : in  std_logic;
    m_axi_lite_aresetn             : in  std_logic;
    md_error                       : out std_logic;
    m_axi_lite_arready             : in  std_logic;
    m_axi_lite_arvalid             : out std_logic;
    m_axi_lite_araddr              : out std_logic_vector(C_M_AXI_LITE_ADDR_WIDTH-1 downto 0);
    m_axi_lite_arprot              : out std_logic_vector(2 downto 0);
    m_axi_lite_rready              : out std_logic;
    m_axi_lite_rvalid              : in  std_logic;
    m_axi_lite_rdata               : in  std_logic_vector(C_M_AXI_LITE_DATA_WIDTH-1 downto 0);
    m_axi_lite_rresp               : in  std_logic_vector(1 downto 0);
    m_axi_lite_awready             : in  std_logic;
    m_axi_lite_awvalid             : out std_logic;
    m_axi_lite_awaddr              : out std_logic_vector(C_M_AXI_LITE_ADDR_WIDTH-1 downto 0);
    m_axi_lite_awprot              : out std_logic_vector(2 downto 0);
    m_axi_lite_wready              : in  std_logic;
    m_axi_lite_wvalid              : out std_logic;
    m_axi_lite_wdata               : out std_logic_vector(C_M_AXI_LITE_DATA_WIDTH-1 downto 0);
    m_axi_lite_wstrb               : out std_logic_vector((C_M_AXI_LITE_DATA_WIDTH/8)-1 downto 0);
    m_axi_lite_bready              : out std_logic;
    m_axi_lite_bvalid              : in  std_logic;
    m_axi_lite_bresp               : in  std_logic_vector(1 downto 0)
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );

  attribute MAX_FANOUT : string;
  attribute SIGIS : string;
  attribute MAX_FANOUT of S_AXI_ACLK       : signal is "10000";
  attribute MAX_FANOUT of S_AXI_ARESETN       : signal is "10000";
  attribute SIGIS of S_AXI_ACLK       : signal is "Clk";
  attribute SIGIS of S_AXI_ARESETN       : signal is "Rst";

  attribute MAX_FANOUT of m_axi_lite_aclk       : signal is "10000";
  attribute MAX_FANOUT of m_axi_lite_aresetn       : signal is "10000";
  attribute SIGIS of m_axi_lite_aclk       : signal is "Clk";
  attribute SIGIS of m_axi_lite_aresetn       : signal is "Rst";
end entity axi_scheduler;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of axi_scheduler is

  constant USER_SLV_DWIDTH                : integer              := C_S_AXI_DATA_WIDTH;

  constant IPIF_SLV_DWIDTH                : integer              := C_S_AXI_DATA_WIDTH;

  constant ZERO_ADDR_PAD                  : std_logic_vector(0 to 31) := (others => '0');
  constant USER_SLV_BASEADDR              : std_logic_vector(0 to 31)     := C_BASEADDR or X"00000000";
  constant USER_SLV_HIGHADDR              : std_logic_vector(0 to 31)     := C_BASEADDR or X"000000FF";
  --constant USER_MST_BASEADDR              : std_logic_vector     := C_BASEADDR or X"00000100";
 -- constant USER_MST_HIGHADDR              : std_logic_vector     := C_BASEADDR or X"000001FF";

  constant IPIF_ARD_ADDR_RANGE_ARRAY      : SLV64_ARRAY_TYPE     := 
    (
      ZERO_ADDR_PAD & USER_SLV_BASEADDR,  -- user logic slave space base address
      ZERO_ADDR_PAD & USER_SLV_HIGHADDR  -- user logic slave space high address
      --ZERO_ADDR_PAD & USER_MST_BASEADDR,  -- user logic master space base address
      --ZERO_ADDR_PAD & USER_MST_HIGHADDR   -- user logic master space high address
    );

  constant USER_SLV_NUM_REG               : integer              := 1;
  --constant USER_MST_NUM_REG               : integer              := 4;
  constant USER_NUM_REG                   : integer              := USER_SLV_NUM_REG;--+USER_MST_NUM_REG;
  constant TOTAL_IPIF_CE                  : integer              := USER_NUM_REG;

  constant IPIF_ARD_NUM_CE_ARRAY          : INTEGER_ARRAY_TYPE   := 
    (
      0  => (USER_SLV_NUM_REG)           -- number of ce for user logic slave space
    --  1  => (USER_MST_NUM_REG)            -- number of ce for user logic master space
    );

  ------------------------------------------
  -- Width of the master address bus (32 only)
  ------------------------------------------
  constant USER_MST_AWIDTH                : integer              := C_M_AXI_LITE_ADDR_WIDTH;

  ------------------------------------------
  -- Width of the master data bus (32 only)
  ------------------------------------------
  constant USER_MST_DWIDTH                : integer              := C_M_AXI_LITE_DATA_WIDTH;

  ------------------------------------------
  -- Index for CS/CE
  ------------------------------------------
  constant USER_SLV_CS_INDEX              : integer              := 0;
  constant USER_SLV_CE_INDEX              : integer              := calc_start_ce_index(IPIF_ARD_NUM_CE_ARRAY, USER_SLV_CS_INDEX);
  --constant USER_MST_CS_INDEX              : integer              := 1;
  --constant USER_MST_CE_INDEX              : integer              := calc_start_ce_index(IPIF_ARD_NUM_CE_ARRAY, USER_MST_CS_INDEX);

  constant USER_CE_INDEX                  : integer              := USER_SLV_CE_INDEX;

  ------------------------------------------
  -- IP Interconnect (IPIC) signal declarations
  ------------------------------------------
  signal ipif_Bus2IP_Clk                : std_logic;
  signal ipif_Bus2IP_Resetn             : std_logic;
  signal ipif_Bus2IP_Reset              : std_logic;
  signal ipif_Bus2IP_Addr               : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
  signal ipif_Bus2IP_RNW                : std_logic;
  signal ipif_Bus2IP_BE                 : std_logic_vector(IPIF_SLV_DWIDTH/8-1 downto 0);
  signal ipif_Bus2IP_CS                 : std_logic_vector((IPIF_ARD_ADDR_RANGE_ARRAY'LENGTH)/2-1 downto 0);
  signal ipif_Bus2IP_RdCE               : std_logic_vector(calc_num_ce(IPIF_ARD_NUM_CE_ARRAY)-1 downto 0);
  signal ipif_Bus2IP_WrCE               : std_logic_vector(calc_num_ce(IPIF_ARD_NUM_CE_ARRAY)-1 downto 0);
  signal ipif_Bus2IP_Data               : std_logic_vector(IPIF_SLV_DWIDTH-1 downto 0);
  signal ipif_IP2Bus_WrAck              : std_logic;
  signal ipif_IP2Bus_RdAck              : std_logic;
  signal ipif_IP2Bus_Error              : std_logic;
  signal ipif_IP2Bus_Data               : std_logic_vector(IPIF_SLV_DWIDTH-1 downto 0);
  signal ipif_ip2bus_mstrd_req          : std_logic;
  signal ipif_ip2bus_mstwr_req          : std_logic;
  signal ipif_ip2bus_mst_addr           : std_logic_vector(0 to C_M_AXI_LITE_ADDR_WIDTH-1);
  signal ipif_ip2bus_mst_be             : std_logic_vector(0 to (C_M_AXI_LITE_DATA_WIDTH/8)-1);
  signal ipif_ip2bus_mst_lock           : std_logic;
  signal ipif_ip2bus_mst_reset          : std_logic;
  signal ipif_bus2ip_mst_cmdack         : std_logic;
  signal ipif_bus2ip_mst_cmplt          : std_logic;
  signal ipif_bus2ip_mst_error          : std_logic;
  signal ipif_bus2ip_mst_rearbitrate    : std_logic;
  signal ipif_bus2ip_mst_cmd_timeout    : std_logic;
  signal ipif_bus2ip_mstrd_d            : std_logic_vector(0 to C_M_AXI_LITE_DATA_WIDTH-1);
  signal ipif_bus2ip_mstrd_src_rdy_n    : std_logic;
  signal ipif_ip2bus_mstwr_d            : std_logic_vector(0 to C_M_AXI_LITE_DATA_WIDTH-1);
  signal ipif_bus2ip_mstwr_dst_rdy_n    : std_logic;
  signal user_Bus2IP_RdCE               : std_logic_vector(USER_NUM_REG-1 downto 0);
  signal user_Bus2IP_WrCE               : std_logic_vector(USER_NUM_REG-1 downto 0);
  signal user_IP2Bus_Data               : std_logic_vector(USER_SLV_DWIDTH-1 downto 0);
  signal user_IP2Bus_RdAck              : std_logic;
  signal user_IP2Bus_WrAck              : std_logic;
  signal user_IP2Bus_Error              : std_logic;

begin

  ------------------------------------------
  -- instantiate axi_lite_ipif
  ------------------------------------------
  AXI_LITE_IPIF_I : entity axi_lite_ipif_v1_01_a.axi_lite_ipif
    generic map
    (
      C_S_AXI_DATA_WIDTH             => IPIF_SLV_DWIDTH,
      C_S_AXI_ADDR_WIDTH             => C_S_AXI_ADDR_WIDTH,
      C_S_AXI_MIN_SIZE               => C_S_AXI_MIN_SIZE,
      C_USE_WSTRB                    => C_USE_WSTRB,
      C_DPHASE_TIMEOUT               => C_DPHASE_TIMEOUT,
      C_ARD_ADDR_RANGE_ARRAY         => IPIF_ARD_ADDR_RANGE_ARRAY,
      C_ARD_NUM_CE_ARRAY             => IPIF_ARD_NUM_CE_ARRAY,
      C_FAMILY                       => C_FAMILY
    )
    port map
    (
      S_AXI_ACLK                     => S_AXI_ACLK,
      S_AXI_ARESETN                  => S_AXI_ARESETN,
      S_AXI_AWADDR                   => S_AXI_AWADDR,
      S_AXI_AWVALID                  => S_AXI_AWVALID,
      S_AXI_WDATA                    => S_AXI_WDATA,
      S_AXI_WSTRB                    => S_AXI_WSTRB,
      S_AXI_WVALID                   => S_AXI_WVALID,
      S_AXI_BREADY                   => S_AXI_BREADY,
      S_AXI_ARADDR                   => S_AXI_ARADDR,
      S_AXI_ARVALID                  => S_AXI_ARVALID,
      S_AXI_RREADY                   => S_AXI_RREADY,
      S_AXI_ARREADY                  => S_AXI_ARREADY,
      S_AXI_RDATA                    => S_AXI_RDATA,
      S_AXI_RRESP                    => S_AXI_RRESP,
      S_AXI_RVALID                   => S_AXI_RVALID,
      S_AXI_WREADY                   => S_AXI_WREADY,
      S_AXI_BRESP                    => S_AXI_BRESP,
      S_AXI_BVALID                   => S_AXI_BVALID,
      S_AXI_AWREADY                  => S_AXI_AWREADY,
      Bus2IP_Clk                     => ipif_Bus2IP_Clk,
      Bus2IP_Resetn                  => ipif_Bus2IP_Resetn,
      Bus2IP_Addr                    => ipif_Bus2IP_Addr,
      Bus2IP_RNW                     => ipif_Bus2IP_RNW,
      Bus2IP_BE                      => ipif_Bus2IP_BE,
      Bus2IP_CS                      => ipif_Bus2IP_CS,
      Bus2IP_RdCE                    => ipif_Bus2IP_RdCE,
      Bus2IP_WrCE                    => ipif_Bus2IP_WrCE,
      Bus2IP_Data                    => ipif_Bus2IP_Data,
      IP2Bus_WrAck                   => ipif_IP2Bus_WrAck,
      IP2Bus_RdAck                   => ipif_IP2Bus_RdAck,
      IP2Bus_Error                   => ipif_IP2Bus_Error,
      IP2Bus_Data                    => ipif_IP2Bus_Data
    );

  ------------------------------------------
  -- instantiate axi_master_lite
  ------------------------------------------
  AXI_MASTER_LITE_I : entity axi_master_lite_v1_00_a.axi_master_lite
    generic map
    (
      C_M_AXI_LITE_ADDR_WIDTH        => C_M_AXI_LITE_ADDR_WIDTH,
      C_M_AXI_LITE_DATA_WIDTH        => C_M_AXI_LITE_DATA_WIDTH,
      C_FAMILY                       => C_FAMILY
    )
    port map
    (
      m_axi_lite_aclk                => m_axi_lite_aclk,
      m_axi_lite_aresetn             => m_axi_lite_aresetn,
      md_error                       => md_error,
      m_axi_lite_arready             => m_axi_lite_arready,
      m_axi_lite_arvalid             => m_axi_lite_arvalid,
      m_axi_lite_araddr              => m_axi_lite_araddr,
      m_axi_lite_arprot              => m_axi_lite_arprot,
      m_axi_lite_rready              => m_axi_lite_rready,
      m_axi_lite_rvalid              => m_axi_lite_rvalid,
      m_axi_lite_rdata               => m_axi_lite_rdata,
      m_axi_lite_rresp               => m_axi_lite_rresp,
      m_axi_lite_awready             => m_axi_lite_awready,
      m_axi_lite_awvalid             => m_axi_lite_awvalid,
      m_axi_lite_awaddr              => m_axi_lite_awaddr,
      m_axi_lite_awprot              => m_axi_lite_awprot,
      m_axi_lite_wready              => m_axi_lite_wready,
      m_axi_lite_wvalid              => m_axi_lite_wvalid,
      m_axi_lite_wdata               => m_axi_lite_wdata,
      m_axi_lite_wstrb               => m_axi_lite_wstrb,
      m_axi_lite_bready              => m_axi_lite_bready,
      m_axi_lite_bvalid              => m_axi_lite_bvalid,
      m_axi_lite_bresp               => m_axi_lite_bresp,
      ip2bus_mstrd_req               => ipif_ip2bus_mstrd_req,
      ip2bus_mstwr_req               => ipif_ip2bus_mstwr_req,
      ip2bus_mst_addr                => ipif_ip2bus_mst_addr,
      ip2bus_mst_be                  => ipif_ip2bus_mst_be,
      ip2bus_mst_lock                => ipif_ip2bus_mst_lock,
      ip2bus_mst_reset               => ipif_ip2bus_mst_reset,
      bus2ip_mst_cmdack              => ipif_bus2ip_mst_cmdack,
      bus2ip_mst_cmplt               => ipif_bus2ip_mst_cmplt,
      bus2ip_mst_error               => ipif_bus2ip_mst_error,
      bus2ip_mst_rearbitrate         => ipif_bus2ip_mst_rearbitrate,
      bus2ip_mst_cmd_timeout         => ipif_bus2ip_mst_cmd_timeout,
      bus2ip_mstrd_d                 => ipif_bus2ip_mstrd_d,
      bus2ip_mstrd_src_rdy_n         => ipif_bus2ip_mstrd_src_rdy_n,
      ip2bus_mstwr_d                 => ipif_ip2bus_mstwr_d,
      bus2ip_mstwr_dst_rdy_n         => ipif_bus2ip_mstwr_dst_rdy_n
    );

  ------------------------------------------
  -- instantiate User Logic
  ------------------------------------------
  USER_LOGIC_I : entity axi_scheduler_v1_00_a.user_logic
    generic map
    (
      -- MAP USER GENERICS BELOW THIS LINE ---------------
      --USER generics mapped here
      -- MAP USER GENERICS ABOVE THIS LINE ---------------

      C_MST_AWIDTH                   => USER_MST_AWIDTH,
      C_MST_DWIDTH                   => USER_MST_DWIDTH,
      C_NUM_REG                      => USER_NUM_REG,
      C_SLV_DWIDTH                   => USER_SLV_DWIDTH
    )
    port map
    (
      -- MAP USER PORTS BELOW THIS LINE ------------------
    Soft_Reset       =>     Soft_Reset      ,

    Reset_Done       =>     Reset_Done      ,
    Soft_Stop        =>     Soft_Stop       ,
    
    SWTM_DOB         =>     SWTM_DOB        ,
    SWTM_ADDRB       =>     SWTM_ADDRB      ,
    SWTM_DIB         =>     SWTM_DIB        ,
    SWTM_ENB         =>     SWTM_ENB        ,
    SWTM_WEB         =>     SWTM_WEB        ,

    TM2SCH_current_cpu_tid   =>     TM2SCH_current_cpu_tid  ,
    TM2SCH_opcode            =>     TM2SCH_opcode           ,
    TM2SCH_data              =>     TM2SCH_data             ,
    TM2SCH_request           =>     TM2SCH_request          ,
    SCH2TM_busy              =>     SCH2TM_busy             ,
    SCH2TM_data              =>     SCH2TM_data             ,
    SCH2TM_next_cpu_tid      =>     SCH2TM_next_cpu_tid     ,
    SCH2TM_next_tid_valid    =>     SCH2TM_next_tid_valid   ,

    Preemption_Interrupt  =>     Preemption_Interrupt ,
      -- MAP USER PORTS ABOVE THIS LINE ------------------

      Bus2IP_Clk                     => ipif_Bus2IP_Clk,
      Bus2IP_Reset                   => ipif_Bus2IP_Reset,
      Bus2IP_Addr                    => ipif_Bus2IP_Addr,
      Bus2IP_Data                    => ipif_Bus2IP_Data,
      Bus2IP_BE                      => ipif_Bus2IP_BE,
      Bus2IP_RdCE                    => user_Bus2IP_RdCE,
      Bus2IP_WrCE                    => user_Bus2IP_WrCE,
      IP2Bus_Data                    => user_IP2Bus_Data,
      IP2Bus_RdAck                   => user_IP2Bus_RdAck,
      IP2Bus_WrAck                   => user_IP2Bus_WrAck,
      IP2Bus_Error                   => user_IP2Bus_Error,
      ip2bus_mstrd_req               => ipif_ip2bus_mstrd_req,
      ip2bus_mstwr_req               => ipif_ip2bus_mstwr_req,
      ip2bus_mst_addr                => ipif_ip2bus_mst_addr,
      ip2bus_mst_be                  => ipif_ip2bus_mst_be,
      ip2bus_mst_lock                => ipif_ip2bus_mst_lock,
      ip2bus_mst_reset               => ipif_ip2bus_mst_reset,
      bus2ip_mst_cmdack              => ipif_bus2ip_mst_cmdack,
      bus2ip_mst_cmplt               => ipif_bus2ip_mst_cmplt,
      bus2ip_mst_error               => ipif_bus2ip_mst_error,
      bus2ip_mst_rearbitrate         => ipif_bus2ip_mst_rearbitrate,
      bus2ip_mst_cmd_timeout         => ipif_bus2ip_mst_cmd_timeout,
      bus2ip_mstrd_d                 => ipif_bus2ip_mstrd_d,
      bus2ip_mstrd_src_rdy_n         => ipif_bus2ip_mstrd_src_rdy_n,
      ip2bus_mstwr_d                 => ipif_ip2bus_mstwr_d,
      bus2ip_mstwr_dst_rdy_n         => ipif_bus2ip_mstwr_dst_rdy_n
    );

  ------------------------------------------
  -- connect internal signals
  ------------------------------------------
  IP2BUS_DATA_MUX_PROC : process( ipif_Bus2IP_CS, user_IP2Bus_Data ) is
  begin

    case ipif_Bus2IP_CS   is
      when "1" => ipif_IP2Bus_Data <= user_IP2Bus_Data;
      when others => ipif_IP2Bus_Data <= (others => '0');
    end case;

  end process IP2BUS_DATA_MUX_PROC;

  ipif_IP2Bus_WrAck <= user_IP2Bus_WrAck;
  ipif_IP2Bus_RdAck <= user_IP2Bus_RdAck;
  ipif_IP2Bus_Error <= user_IP2Bus_Error;

  user_Bus2IP_RdCE(USER_SLV_NUM_REG-1 downto 0) <= ipif_Bus2IP_RdCE(TOTAL_IPIF_CE -USER_SLV_CE_INDEX -1 downto TOTAL_IPIF_CE - USER_SLV_CE_INDEX -USER_SLV_NUM_REG);
  user_Bus2IP_WrCE(USER_SLV_NUM_REG-1 downto 0) <= ipif_Bus2IP_WrCE(TOTAL_IPIF_CE -USER_SLV_CE_INDEX -1 downto TOTAL_IPIF_CE - USER_SLV_CE_INDEX -USER_SLV_NUM_REG);
 -- user_Bus2IP_RdCE(USER_NUM_REG-1 downto USER_NUM_REG-USER_MST_NUM_REG) <= ipif_Bus2IP_RdCE(TOTAL_IPIF_CE - USER_MST_CE_INDEX -1 downto TOTAL_IPIF_CE - USER_MST_CE_INDEX -USER_MST_NUM_REG);
 -- user_Bus2IP_WrCE(USER_NUM_REG-1 downto USER_NUM_REG- USER_MST_NUM_REG) <= ipif_Bus2IP_WrCE(TOTAL_IPIF_CE - USER_MST_CE_INDEX -1 downto TOTAL_IPIF_CE - USER_MST_CE_INDEX -USER_MST_NUM_REG);
  
  ipif_Bus2IP_Reset <=  not ipif_Bus2IP_Resetn;

end IMP;
