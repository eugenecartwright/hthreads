-------------------------------------------------------------------------------------
-- Copyright (c) 2006, University of Kansas - Hybridthreads Group
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
--     * Neither the name of the University of Kansas nor the name of the
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

use work.common.SYNCH_LOCK;
use work.common.SYNCH_UNLOCK;
use work.common.SYNCH_TRY;
use work.common.SYNCH_OWNER;
use work.common.SYNCH_KIND;
use work.common.SYNCH_COUNT;
use work.common.SYNCH_RESULT;

entity opb_SynchManager is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
    C_NUM_THREADS       : integer           := 256;
    C_NUM_MUTEXES       : integer           := 64;
    C_SCHED_BADDR       : std_logic_vector  := X"00000000";
    C_SCHED_HADDR       : std_logic_vector  := X"00000000";
    -- ADD USER GENERICS ABOVE THIS LINE ---------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_BASEADDR          : std_logic_vector  := X"00000000";
    C_HIGHADDR          : std_logic_vector  := X"00FFFFFF";
    C_OPB_AWIDTH        : integer           := 32;
    C_OPB_DWIDTH        : integer           := 32;
    C_FAMILY            : string            := "virtex2p"
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------
    system_reset                   :  in std_logic;
    system_resetdone               : out std_logic;
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
end entity opb_SynchManager;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture imp of opb_SynchManager is
  -- Constants for the number of bits needed to represent certain data
  constant MUTEX_BITS     : integer   := log2(C_NUM_MUTEXES);
  constant THREAD_BITS    : integer   := log2(C_NUM_THREADS);
  constant KIND_BITS      : integer   := 2;
  constant COUNT_BITS     : integer   := 8;
  constant COMMAND_BITS   : integer   := 3;

  function calc_base( cmd : in std_logic_vector(0 to COMMAND_BITS-1) )
      return std_logic_vector is
      variable addr : std_logic_vector(0 to C_OPB_AWIDTH - 1);
  begin
      addr := C_BASEADDR;
      addr(C_OPB_AWIDTH - MUTEX_BITS - THREAD_BITS - COMMAND_BITS - 2 to 
           C_OPB_AWIDTH - MUTEX_BITS - THREAD_BITS - 3) := cmd;
      return addr;
  end function calc_base;

  function calc_high( cmd : in std_logic_vector(0 to COMMAND_BITS-1) )
      return std_logic_vector is
      variable addr : std_logic_vector(0 to C_OPB_AWIDTH - 1);
  begin
      addr := C_BASEADDR;
      addr(C_OPB_AWIDTH - MUTEX_BITS - 2 to 
           C_OPB_AWIDTH - 3) := (others => '1');
      addr(C_OPB_AWIDTH - MUTEX_BITS - THREAD_BITS - 2 to
           C_OPB_AWIDTH - MUTEX_BITS - 3) := (others => '1');
      addr(C_OPB_AWIDTH - MUTEX_BITS - THREAD_BITS - COMMAND_BITS - 2 to
           C_OPB_AWIDTH - MUTEX_BITS - THREAD_BITS - 3) := cmd;
      return addr;
  end function calc_high;

  ------------------------------------------
  -- constants: figure out addresses of address ranges
  ------------------------------------------
  constant LOCK_BASE:std_logic_vector(0 to C_OPB_AWIDTH-1)
    := calc_base(SYNCH_LOCK);

  constant LOCK_HIGH : std_logic_vector(0 to C_OPB_AWIDTH-1)
    := calc_high(SYNCH_LOCK);

  constant UNLOCK_BASE : std_logic_vector(0 to C_OPB_AWIDTH-1)
    := calc_base(SYNCH_UNLOCK);
  
  constant UNLOCK_HIGH : std_logic_vector(0 to C_OPB_AWIDTH-1)
    := calc_high(SYNCH_UNLOCK);

  constant TRY_BASE : std_logic_vector(0 to C_OPB_AWIDTH-1)
    := calc_base(SYNCH_TRY);

  constant TRY_HIGH : std_logic_vector(0 to C_OPB_AWIDTH-1)
    := calc_high(SYNCH_TRY);

  constant OWNER_BASE : std_logic_vector(0 to C_OPB_AWIDTH-1)
    := calc_base(SYNCH_OWNER);

  constant OWNER_HIGH : std_logic_vector(0 to C_OPB_AWIDTH-1)
    := calc_high(SYNCH_OWNER);

  constant KIND_BASE : std_logic_vector(0 to C_OPB_AWIDTH-1)
    := calc_base(SYNCH_KIND);

  constant KIND_HIGH : std_logic_vector(0 to C_OPB_AWIDTH-1)
    := calc_high(SYNCH_KIND);

  constant COUNT_BASE : std_logic_vector(0 to C_OPB_AWIDTH-1)
    := calc_base(SYNCH_COUNT);

  constant COUNT_HIGH : std_logic_vector(0 to C_OPB_AWIDTH-1)
    := calc_high(SYNCH_COUNT);

  constant RESULT_BASE : std_logic_vector(0 to C_OPB_AWIDTH-1)
    := calc_base(SYNCH_RESULT);

  constant RESULT_HIGH : std_logic_vector(0 to C_OPB_AWIDTH-1)
    := calc_high(SYNCH_RESULT);

  constant C_AR0_BASEADDR  : std_logic_vector     := LOCK_BASE;
  constant C_AR0_HIGHADDR  : std_logic_vector     := LOCK_HIGH;
  constant C_AR1_BASEADDR  : std_logic_vector     := UNLOCK_BASE;
  constant C_AR1_HIGHADDR  : std_logic_vector     := UNLOCK_HIGH;
  constant C_AR2_BASEADDR  : std_logic_vector     := TRY_BASE;
  constant C_AR2_HIGHADDR  : std_logic_vector     := TRY_HIGH;
  constant C_AR3_BASEADDR  : std_logic_vector     := OWNER_BASE;
  constant C_AR3_HIGHADDR  : std_logic_vector     := OWNER_HIGH;
  constant C_AR4_BASEADDR  : std_logic_vector     := KIND_BASE;
  constant C_AR4_HIGHADDR  : std_logic_vector     := KIND_HIGH;
  constant C_AR5_BASEADDR  : std_logic_vector     := COUNT_BASE;
  constant C_AR5_HIGHADDR  : std_logic_vector     := COUNT_HIGH;
  constant C_AR6_BASEADDR  : std_logic_vector     := RESULT_BASE;
  constant C_AR6_HIGHADDR  : std_logic_vector     := RESULT_HIGH;

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

  constant ARD_ID_ARRAY                   : INTEGER_ARRAY_TYPE   := 
    (
      0  => USER_01,                -- user logic address range 0 bank
      1  => USER_02,                -- user logic address range 1 bank
      2  => USER_03,                -- user logic address range 2 bank
      3  => USER_04,                -- user logic address range 3 bank
      4  => USER_05,                -- user logic address range 4 bank
      5  => USER_06,                -- user logic address range 5 bank
      6  => USER_07                 -- user logic address range 6 bank
    );

  -- specify actual address range (defined by a pair of base address and
  -- high address) for each address space, which are byte relative.
  constant ZERO_ADDR_PAD                  : std_logic_vector(0 to 31) := (others => '0');

  constant ARD_ADDR_RANGE_ARRAY           : SLV64_ARRAY_TYPE     := 
    (
      ZERO_ADDR_PAD & C_AR0_BASEADDR,     -- user logic address range 0 base address
      ZERO_ADDR_PAD & C_AR0_HIGHADDR,     -- user logic address range 0 high address
      ZERO_ADDR_PAD & C_AR1_BASEADDR,     -- user logic address range 1 base address
      ZERO_ADDR_PAD & C_AR1_HIGHADDR,     -- user logic address range 1 high address
      ZERO_ADDR_PAD & C_AR2_BASEADDR,     -- user logic address range 2 base address
      ZERO_ADDR_PAD & C_AR2_HIGHADDR,     -- user logic address range 2 high address
      ZERO_ADDR_PAD & C_AR3_BASEADDR,     -- user logic address range 3 base address
      ZERO_ADDR_PAD & C_AR3_HIGHADDR,     -- user logic address range 3 high address
      ZERO_ADDR_PAD & C_AR4_BASEADDR,     -- user logic address range 4 base address
      ZERO_ADDR_PAD & C_AR4_HIGHADDR,     -- user logic address range 4 high address
      ZERO_ADDR_PAD & C_AR5_BASEADDR,     -- user logic address range 5 base address
      ZERO_ADDR_PAD & C_AR5_HIGHADDR,     -- user logic address range 5 high address
      ZERO_ADDR_PAD & C_AR6_BASEADDR,     -- user logic address range 6 base address
      ZERO_ADDR_PAD & C_AR6_HIGHADDR      -- user logic address range 6 high address
    );

  -- specify data width for each target address range.
  constant USER_AR0_DWIDTH                : integer              := 32;
  constant USER_AR1_DWIDTH                : integer              := 32;
  constant USER_AR2_DWIDTH                : integer              := 32;
  constant USER_AR3_DWIDTH                : integer              := 32;
  constant USER_AR4_DWIDTH                : integer              := 32;
  constant USER_AR5_DWIDTH                : integer              := 32;
  constant USER_AR6_DWIDTH                : integer              := 32;

  constant ARD_DWIDTH_ARRAY               : INTEGER_ARRAY_TYPE   := 
    (
      0  => USER_AR0_DWIDTH,        -- user logic address range 0 data width
      1  => USER_AR1_DWIDTH,        -- user logic address range 1 data width
      2  => USER_AR2_DWIDTH,        -- user logic address range 2 data width
      3  => USER_AR3_DWIDTH,        -- user logic address range 3 data width
      4  => USER_AR4_DWIDTH,        -- user logic address range 4 data width
      5  => USER_AR5_DWIDTH,        -- user logic address range 5 data width
      6  => USER_AR6_DWIDTH         -- user logic address range 6 data width
    );

  -- specify desired number of chip enables for each address range,
  -- typically one ce per register and each ipif service has its
  -- predefined value.
  constant ARD_NUM_CE_ARRAY               : INTEGER_ARRAY_TYPE   := 
    (
      0  => 1,        -- user logic address range 0 bank (always 1 chip enable)
      1  => 1,        -- user logic address range 1 bank (always 1 chip enable)
      2  => 1,        -- user logic address range 2 bank (always 1 chip enable)
      3  => 1,        -- user logic address range 3 bank (always 1 chip enable)
      4  => 1,        -- user logic address range 4 bank (always 1 chip enable)
      5  => 1,        -- user logic address range 5 bank (always 1 chip enable)
      6  => 1         -- user logic address range 6 bank (always 1 chip enable)
    );

  -- specify unique properties for each address range, currently
  -- only used for packet fifo data spaces.
  constant ARD_DEPENDENT_PROPS_ARRAY      : DEPENDENT_PROPS_ARRAY_TYPE := 
    (
      0=>(others => 0), -- user logic address range 0 dependent properties (none defined)
      1=>(others => 0), -- user logic address range 1 dependent properties (none defined)
      2=>(others => 0), -- user logic address range 2 dependent properties (none defined)
      3=>(others => 0), -- user logic address range 3 dependent properties (none defined)
      4=>(others => 0), -- user logic address range 4 dependent properties (none defined)
      5=>(others => 0), -- user logic address range 5 dependent properties (none defined)
      6=>(others => 0)  -- user logic address range 6 dependent properties (none defined)
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

  -- specify maximum data bus width among all user logic address ranges.
  constant USER_DWIDTH                    : integer              := 32;

  -- specify number of user logic chip enables
  constant USER_NUM_CE                    : integer              := 1;

  -- specify number of user logic address ranges.
  constant USER_NUM_ADDR_RNG              : integer              := 7;

  ------------------------------------------
  -- IP Interconnect (IPIC) signal declarations -- do not delete
  -- prefix 'i' stands for IPIF while prefix 'u' stands for user logic
  -- typically user logic will be hooked up to IPIF directly via i<sig>
  -- unless signal slicing and muxing are needed via u<sig>
  ------------------------------------------
  signal iIP2Bus_Addr           : std_logic_vector(0 to C_OPB_AWIDTH - 1)   := (others => '0');
  signal iBus2IP_Addr           : std_logic_vector(0 to C_OPB_AWIDTH - 1);
  signal iBus2IP_Data           : std_logic_vector(0 to IPIF_DWIDTH - 1);
  signal iBus2IP_RNW            : std_logic;
  signal iBus2IP_RdCE           : std_logic_vector(0 to calc_num_ce(ARD_NUM_CE_ARRAY)-1);
  signal iBus2IP_WrCE           : std_logic_vector(0 to calc_num_ce(ARD_NUM_CE_ARRAY)-1);
  signal iIP2Bus_Data           : std_logic_vector(0 to IPIF_DWIDTH-1)   := (others => '0');
  signal iIP2Bus_WrAck          : std_logic   := '0';
  signal iIP2Bus_RdAck          : std_logic   := '0';
  signal iIP2Bus_Retry          : std_logic   := '0';
  signal iIP2Bus_Error          : std_logic   := '0';
  signal iIP2Bus_ToutSup        : std_logic   := '0';
  signal iIP2IP_Addr            : std_logic_vector(0 to C_OPB_AWIDTH - 1)   := (others => '0');
  signal ZERO_IP2RFIFO_Data     : std_logic_vector(0 to 31)   := (others => '0'); -- work around for XST not taking (others => '0') in port mapping
  signal iIP2Bus_MstBE          : std_logic_vector(0 to (C_OPB_DWIDTH/8) - 1)   := (others => '0');
  signal iIP2Bus_MstWrReq       : std_logic   := '0';
  signal iIP2Bus_MstRdReq       : std_logic   := '0';
  signal iIP2Bus_MstBurst       : std_logic   := '0';
  signal iIP2Bus_MstBusLock     : std_logic   := '0';
  signal iBus2IP_MstWrAck       : std_logic;
  signal iBus2IP_MstRdAck       : std_logic;
  signal iBus2IP_MstRetry       : std_logic;
  signal iBus2IP_MstError       : std_logic;
  signal iBus2IP_MstTimeOut     : std_logic;
  signal iBus2IP_MstLastAck     : std_logic;
  signal iBus2IP_BE             : std_logic_vector(0 to (IPIF_DWIDTH/8) - 1);
  signal iBus2IP_WrReq          : std_logic;
  signal iBus2IP_RdReq          : std_logic;
  signal iBus2IP_Clk            : std_logic;
  signal iBus2IP_Reset          : std_logic;
  signal ZERO_IP2Bus_IntrEvent  : std_logic_vector(0 to IP_INTR_MODE_ARRAY'length - 1)   := (others => '0'); -- work around for XST not taking (others => '0') in port mapping
  signal iBus2IP_CS             : std_logic_vector(0 to ((ARD_ADDR_RANGE_ARRAY'LENGTH)/2)-1);
  signal uBus2IP_Data           : std_logic_vector(0 to USER_DWIDTH-1);
  signal uBus2IP_BE             : std_logic_vector(0 to USER_DWIDTH/8-1);
  signal uBus2IP_RdCE           : std_logic_vector(0 to USER_NUM_CE-1);
  signal uBus2IP_WrCE           : std_logic_vector(0 to USER_NUM_CE-1);
  signal uIP2Bus_Data           : std_logic_vector(0 to USER_DWIDTH-1);
  signal uIP2Bus_MstBE          : std_logic_vector(0 to USER_DWIDTH/8-1);
  signal uBus2IP_CS           : std_logic_vector(0 to USER_NUM_ADDR_RNG-1);

  -- Signals for the master and slave interaction
  signal send_ena               : std_logic;
  signal send_id                : std_logic_vector(0 to log2(C_NUM_THREADS)-1);
  signal send_ack               : std_logic;

  -- Signals for the send thread id store
  signal siaddr                 : std_logic_vector(0 to log2(C_NUM_THREADS)-1);
  signal siena                  : std_logic;
  signal siwea                  : std_logic;
  signal sinext                 : std_logic_vector(0 to log2(C_NUM_THREADS)-1);
  signal sonext                 : std_logic_vector(0 to log2(C_NUM_THREADS)-1);

  -- Signals for the system reset
  signal master_resetdone       : std_logic;
  signal slave_resetdone        : std_logic;
begin
    ------------------------------------------
    -- instantiate the OPB IPIF
    ------------------------------------------
    opb_ipif_i : entity opb_ipif_v2_00_h.opb_ipif
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
            Mn_ABus                        => M_ABus,
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
            IP2Bus_PostedWrInh             => '1',
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
            Mn_request                     => M_request,
            Mn_busLock                     => M_busLock,
            Mn_select                      => M_select,
            Mn_RNW                         => M_RNW,
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

    --------------------------------------------------------------------------
    -- Instantiate the Slave Logic
    --------------------------------------------------------------------------
    slave_logic_i : entity work.slave
        generic map
        (
            C_NUM_THREADS       => C_NUM_THREADS,
            C_NUM_MUTEXES       => C_NUM_MUTEXES,

            C_AWIDTH            => USER_AWIDTH,
            C_DWIDTH            => USER_DWIDTH,

            C_MAX_AR_DWIDTH     => USER_DWIDTH,
            C_NUM_ADDR_RNG      => USER_NUM_ADDR_RNG,
            C_NUM_CE            => USER_NUM_CE
        )
        port map
        (
            Bus2IP_Clk          => iBus2IP_Clk,
            Bus2IP_Reset        => iBus2IP_Reset,
            Bus2IP_Addr         => iBus2IP_Addr,
            Bus2IP_Data         => uBus2IP_Data,
            Bus2IP_BE           => uBus2IP_BE,
            Bus2IP_CS           => uBus2IP_CS,
            Bus2IP_RNW          => iBus2IP_RNW,
            Bus2IP_RdCE         => uBus2IP_RdCE,
            Bus2IP_WrCE         => uBus2IP_WrCE,
            Bus2IP_RdReq        => iBus2IP_RdReq,
            Bus2IP_WrReq        => iBus2IP_WrReq,
            IP2Bus_Data         => uIP2Bus_Data,
            IP2Bus_Retry        => iIP2Bus_Retry,
            IP2Bus_Error        => iIP2Bus_Error,
            IP2Bus_ToutSup      => iIP2Bus_ToutSup,
            IP2Bus_RdAck        => iIP2Bus_RdAck,
            IP2Bus_WrAck        => iIP2Bus_WrAck,

            system_reset        => system_reset,
            system_resetdone    => slave_resetdone,
            send_ena            => send_ena,
            send_id             => send_id,
            send_ack            => send_ack,

            siaddr              => siaddr,
            siena               => siena,
            siwea               => siwea,
            sinext              => sinext,
            sonext              => sonext
        );

    --------------------------------------------------------------------------
    -- Instantiate the Master Logic
    --------------------------------------------------------------------------
    master_logic_i : entity work.master
        generic map
        (
            C_BASEADDR          => C_BASEADDR,
            C_HIGHADDR          => C_HIGHADDR,
            C_SCHED_BASEADDR    => C_SCHED_BADDR,
            C_RESULT_BASEADDR   => RESULT_BASE,

            C_NUM_THREADS       => C_NUM_THREADS,
            C_NUM_MUTEXES       => C_NUM_MUTEXES,

            C_AWIDTH            => USER_AWIDTH,
            C_DWIDTH            => USER_DWIDTH,
            C_MAX_AR_DWIDTH     => USER_DWIDTH,
            C_NUM_ADDR_RNG      => USER_NUM_ADDR_RNG,
            C_NUM_CE            => USER_NUM_CE
        )
        port map
        (
            Bus2IP_Clk          => iBus2IP_Clk,
            Bus2IP_Reset        => iBus2IP_Reset,
            Bus2IP_Addr         => iBus2IP_Addr,
            Bus2IP_Data         => uBus2IP_Data,
            Bus2IP_BE           => uBus2IP_BE,
            Bus2IP_RNW          => iBus2IP_RNW,
            Bus2IP_RdCE         => uBus2IP_RdCE,
            Bus2IP_WrCE         => uBus2IP_WrCE,
            Bus2IP_RdReq        => iBus2IP_RdReq,
            Bus2IP_WrReq        => iBus2IP_WrReq,
            Bus2IP_MstError     => iBus2IP_MstError,
            Bus2IP_MstLastAck   => iBus2IP_MstLastAck,
            Bus2IP_MstRdAck     => iBus2IP_MstRdAck,
            Bus2IP_MstWrAck     => iBus2IP_MstWrAck,
            Bus2IP_MstRetry     => iBus2IP_MstRetry,
            Bus2IP_MstTimeOut   => iBus2IP_MstTimeOut,
            IP2Bus_Addr         => iIP2Bus_Addr,
            IP2Bus_MstBE        => uIP2Bus_MstBE,
            IP2Bus_MstBurst     => iIP2Bus_MstBurst,
            IP2Bus_MstBusLock   => iIP2Bus_MstBusLock,
            IP2Bus_MstRdReq     => iIP2Bus_MstRdReq,
            IP2Bus_MstWrReq     => iIP2Bus_MstWrReq,
            IP2IP_Addr          => iIP2IP_Addr,

            system_reset        => system_reset,
            system_resetdone    => master_resetdone,
            send_ena            => send_ena,
            send_id             => send_id,
            send_ack            => send_ack,

            saddr               => siaddr,
            sena                => siena,
            swea                => siwea,
            sonext              => sinext,
            sinext              => sonext
        );

    ------------------------------------------
    -- hooking reset done signals
    ------------------------------------------
    system_resetdone <= master_resetdone and slave_resetdone;

    ------------------------------------------
    -- hooking up signal slicing
    ------------------------------------------
    iIP2Bus_MstBE <= uIP2Bus_MstBE;
    uBus2IP_Data <= iBus2IP_Data(0 to USER_DWIDTH-1);
    uBus2IP_BE <= iBus2IP_BE(0 to USER_DWIDTH/8-1);
    uBus2IP_RdCE(0 to USER_NUM_CE-1) <= iBus2IP_RdCE(0 to USER_NUM_CE-1);
    uBus2IP_WrCE(0 to USER_NUM_CE-1) <= iBus2IP_WrCE(0 to USER_NUM_CE-1);
    uBus2IP_CS <= iBus2IP_CS;
    iIP2Bus_Data(0 to USER_DWIDTH-1) <= uIP2Bus_Data;

end imp;
