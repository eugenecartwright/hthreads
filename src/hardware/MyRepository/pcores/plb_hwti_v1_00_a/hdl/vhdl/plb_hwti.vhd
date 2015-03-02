library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library proc_common_v1_00_b;
use proc_common_v1_00_b.proc_common_pkg.all;

library ipif_common_v1_00_e;
use ipif_common_v1_00_e.ipif_pkg.all;
library plb_ipif_v2_01_a;
use plb_ipif_v2_01_a.all;

library plb_hwti_v1_00_a;
use plb_hwti_v1_00_a.all;

library fsl_v20_v2_10_a;
use fsl_v20_v2_10_a.all;

entity plb_hwti is
  generic
  (
    C_MANAG_BASE                   : std_logic_vector     := x"60000000";
    C_SCHED_BASE                   : std_logic_vector     := x"61000000";
    C_MUTEX_BASE                   : std_logic_vector     := x"75000000";
    C_CONDV_BASE                   : std_logic_vector     := x"74000000";

    C_BASEADDR                     : std_logic_vector     := X"FFFFFFFF";
    C_HIGHADDR                     : std_logic_vector     := X"00000000";
    C_PLB_AWIDTH                   : integer              := 32;
    C_PLB_DWIDTH                   : integer              := 64;
    C_PLB_NUM_MASTERS              : integer              := 8;
    C_PLB_MID_WIDTH                : integer              := 3;
    C_FAMILY                       : string               := "virtex2p"
  );
  port
  (
    U2HLOW_M_WRITE      :  in std_logic;
    U2HLOW_M_DATA       :  in std_logic_vector(0 to 31);
    U2HLOW_M_CONTROL    :  in std_logic;
    U2HLOW_M_FULL       : out std_logic;

    U2HHIGH_M_WRITE     :  in std_logic;
    U2HHIGH_M_DATA      :  in std_logic_vector(0 to 31);
    U2HHIGH_M_CONTROL   :  in std_logic;
    U2HHIGH_M_FULL      : out std_logic;

    H2ULOW_S_READ       :  in std_logic;
    H2ULOW_S_DATA       : out std_logic_vector(0 to 31);
    H2ULOW_S_CONTROL    : out std_logic;
    H2ULOW_S_EXISTS     : out std_logic;

    H2UHIGH_S_READ      :  in std_logic;
    H2UHIGH_S_DATA      : out std_logic_vector(0 to 31);
    H2UHIGH_S_CONTROL   : out std_logic;
    H2UHIGH_S_EXISTS    : out std_logic;

    PLB_Clk             :  in std_logic;
    PLB_Rst             :  in std_logic;
    Sl_addrAck          : out std_logic;
    Sl_MBusy            : out std_logic_vector(0 to C_PLB_NUM_MASTERS-1);
    Sl_MErr             : out std_logic_vector(0 to C_PLB_NUM_MASTERS-1);
    Sl_rdBTerm          : out std_logic;
    Sl_rdComp           : out std_logic;
    Sl_rdDAck           : out std_logic;
    Sl_rdDBus           : out std_logic_vector(0 to C_PLB_DWIDTH-1);
    Sl_rdWdAddr         : out std_logic_vector(0 to 3);
    Sl_rearbitrate      : out std_logic;
    Sl_SSize            : out std_logic_vector(0 to 1);
    Sl_wait             : out std_logic;
    Sl_wrBTerm          : out std_logic;
    Sl_wrComp           : out std_logic;
    Sl_wrDAck           : out std_logic;
    PLB_abort           :  in std_logic;
    PLB_ABus            :  in std_logic_vector(0 to C_PLB_AWIDTH-1);
    PLB_BE              :  in std_logic_vector(0 to C_PLB_DWIDTH/8-1);
    PLB_busLock         :  in std_logic;
    PLB_compress        :  in std_logic;
    PLB_guarded         :  in std_logic;
    PLB_lockErr         :  in std_logic;
    PLB_masterID        :  in std_logic_vector(0 to C_PLB_MID_WIDTH-1);
    PLB_MSize           :  in std_logic_vector(0 to 1);
    PLB_ordered         :  in std_logic;
    PLB_PAValid         :  in std_logic;
    PLB_pendPri         :  in std_logic_vector(0 to 1);
    PLB_pendReq         :  in std_logic;
    PLB_rdBurst         :  in std_logic;
    PLB_rdPrim          :  in std_logic;
    PLB_reqPri          :  in std_logic_vector(0 to 1);
    PLB_RNW             :  in std_logic;
    PLB_SAValid         :  in std_logic;
    PLB_size            :  in std_logic_vector(0 to 3);
    PLB_type            :  in std_logic_vector(0 to 2);
    PLB_wrBurst         :  in std_logic;
    PLB_wrDBus          :  in std_logic_vector(0 to C_PLB_DWIDTH-1);
    PLB_wrPrim          :  in std_logic;
    M_abort             : out std_logic;
    M_ABus              : out std_logic_vector(0 to C_PLB_AWIDTH-1);
    M_BE                : out std_logic_vector(0 to C_PLB_DWIDTH/8-1);
    M_busLock           : out std_logic;
    M_compress          : out std_logic;
    M_guarded           : out std_logic;
    M_lockErr           : out std_logic;
    M_MSize             : out std_logic_vector(0 to 1);
    M_ordered           : out std_logic;
    M_priority          : out std_logic_vector(0 to 1);
    M_rdBurst           : out std_logic;
    M_request           : out std_logic;
    M_RNW               : out std_logic;
    M_size              : out std_logic_vector(0 to 3);
    M_type              : out std_logic_vector(0 to 2);
    M_wrBurst           : out std_logic;
    M_wrDBus            : out std_logic_vector(0 to C_PLB_DWIDTH-1);
    PLB_MBusy           :  in std_logic;
    PLB_MErr            :  in std_logic;
    PLB_MWrBTerm        :  in std_logic;
    PLB_MWrDAck         :  in std_logic;
    PLB_MAddrAck        :  in std_logic;
    PLB_MRdBTerm        :  in std_logic;
    PLB_MRdDAck         :  in std_logic;
    PLB_MRdDBus         :  in std_logic_vector(0 to (C_PLB_DWIDTH-1));
    PLB_MRdWdAddr       :  in std_logic_vector(0 to 3);
    PLB_MRearbitrate    :  in std_logic;
    PLB_MSSize          :  in std_logic_vector(0 to 1)
  );

  attribute SIGIS : string;
  attribute SIGIS of PLB_Clk       : signal is "Clk";
  attribute SIGIS of PLB_Rst       : signal is "Rst";
end entity plb_hwti;

architecture IMP of plb_hwti is
    signal USER2HWTIL_S_READ      : std_logic;
    signal USER2HWTIL_S_DATA      : std_logic_vector(0 to 31);
    signal USER2HWTIL_S_CONTROL   : std_logic;
    signal USER2HWTIL_S_EXISTS    : std_logic;
    signal USER2HWTIL_M_WRITE     : std_logic;
    signal USER2HWTIL_M_DATA      : std_logic_vector(0 to 31);
    signal USER2HWTIL_M_CONTROL   : std_logic;
    signal USER2HWTIL_M_FULL      : std_logic;

    signal USER2HWTIH_S_READ      : std_logic;
    signal USER2HWTIH_S_DATA      : std_logic_vector(0 to 31);
    signal USER2HWTIH_S_CONTROL   : std_logic;
    signal USER2HWTIH_S_EXISTS    : std_logic;
    signal USER2HWTIH_M_WRITE     : std_logic;
    signal USER2HWTIH_M_DATA      : std_logic_vector(0 to 31);
    signal USER2HWTIH_M_CONTROL   : std_logic;
    signal USER2HWTIH_M_FULL      : std_logic;

    signal USER2HWTI_S_READ       : std_logic;
    signal USER2HWTI_S_DATA       : std_logic_vector(0 to 63);
    signal USER2HWTI_S_CONTROL    : std_logic;
    signal USER2HWTI_S_EXISTS     : std_logic;
    signal USER2HWTI_M_WRITE      : std_logic;
    signal USER2HWTI_M_DATA       : std_logic_vector(0 to 63);
    signal USER2HWTI_M_CONTROL    : std_logic;
    signal USER2HWTI_M_FULL       : std_logic;

    signal HWTI2USERL_S_READ      : std_logic;
    signal HWTI2USERL_S_DATA      : std_logic_vector(0 to 31);
    signal HWTI2USERL_S_CONTROL   : std_logic;
    signal HWTI2USERL_S_EXISTS    : std_logic;
    signal HWTI2USERL_M_WRITE     : std_logic;
    signal HWTI2USERL_M_DATA      : std_logic_vector(0 to 31);
    signal HWTI2USERL_M_CONTROL   : std_logic;
    signal HWTI2USERL_M_FULL      : std_logic;

    signal HWTI2USERH_S_READ      : std_logic;
    signal HWTI2USERH_S_DATA      : std_logic_vector(0 to 31);
    signal HWTI2USERH_S_CONTROL   : std_logic;
    signal HWTI2USERH_S_EXISTS    : std_logic;
    signal HWTI2USERH_M_WRITE     : std_logic;
    signal HWTI2USERH_M_DATA      : std_logic_vector(0 to 31);
    signal HWTI2USERH_M_CONTROL   : std_logic;
    signal HWTI2USERH_M_FULL      : std_logic;

    signal HWTI2USER_S_READ       : std_logic;
    signal HWTI2USER_S_DATA       : std_logic_vector(0 to 63);
    signal HWTI2USER_S_CONTROL    : std_logic;
    signal HWTI2USER_S_EXISTS     : std_logic;
    signal HWTI2USER_M_WRITE      : std_logic;
    signal HWTI2USER_M_DATA       : std_logic_vector(0 to 63);
    signal HWTI2USER_M_CONTROL    : std_logic;
    signal HWTI2USER_M_FULL       : std_logic;

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
  constant USER_SLAVE                     : integer              := USER_00;

  constant USER_MASTER                    : integer              := USER_10;

  constant ARD_ID_ARRAY                   : INTEGER_ARRAY_TYPE   := 
    (
      0  => USER_SLAVE,             -- user logic slave space (s/w addressable constrol/status registers)
      1  => USER_MASTER             -- user logic master space (ip master model registers)
    );

  -- specify actual address range (defined by a pair of base address and
  -- high address) for each address space, which are byte relative.
  constant ZERO_ADDR_PAD                  : std_logic_vector(0 to 31) := (others => '0');

  constant SLAVE_BASEADDR                 : std_logic_vector     := C_BASEADDR or X"00000000";

  constant SLAVE_HIGHADDR                 : std_logic_vector     := C_BASEADDR or X"0000001F";

  constant MASTER_BASEADDR                : std_logic_vector     := C_BASEADDR or X"00000020";

  constant MASTER_HIGHADDR                : std_logic_vector     := C_BASEADDR or X"0000002F";

  constant ARD_ADDR_RANGE_ARRAY           : SLV64_ARRAY_TYPE     := 
    (
      ZERO_ADDR_PAD & SLAVE_BASEADDR,             -- user logic slave space base address
      ZERO_ADDR_PAD & SLAVE_HIGHADDR,             -- user logic slave space high address
      ZERO_ADDR_PAD & MASTER_BASEADDR,            -- user logic master space base address
      ZERO_ADDR_PAD & MASTER_HIGHADDR             -- user logic master space high address
    );

  -- specify data width for each target address range.
  constant USER_DWIDTH                    : integer              := 64;

  constant ARD_DWIDTH_ARRAY               : INTEGER_ARRAY_TYPE   := 
    (
      0  => 32,                     -- user logic slave space data width
      1  => 32                      -- user logic master space data width
    );

  -- specify desired number of chip enables for each address range,
  -- typically one ce per register and each ipif service has its
  -- predefined value.
  constant USER_NUM_SLAVE_CE              : integer              := 8;

  constant USER_NUM_MASTER_CE             : integer              := 8;

  constant USER_NUM_CE                    : integer              := USER_NUM_SLAVE_CE+USER_NUM_MASTER_CE;

  constant ARD_NUM_CE_ARRAY               : INTEGER_ARRAY_TYPE   := 
    (
      0  => pad_power2(USER_NUM_SLAVE_CE),    -- number of chip enableds for user logic slave space (one per register)
      1  => pad_power2(USER_NUM_MASTER_CE)    -- number of chip enables for user logic master space (one per register)
    );

  -- specify unique properties for each address range, currently
  -- only used for packet fifo data spaces.
  constant ARD_DEPENDENT_PROPS_ARRAY      : DEPENDENT_PROPS_ARRAY_TYPE := 
    (
      0  => (others => 0),          -- user logic slave space dependent properties (none defined)
      1  => (others => 0)           -- user logic master space dependent properties (none defined)
    );

  -- specify determinate timing parameters to be used during read
  -- accesses for each address range, these values are used to optimize
  -- data beat timing response for burst reads from addresses sources such
  -- as ddr and sdram memory, each address space requires three integer
  -- entries for mode [0-2], latency [0-31] and wait states [0-31].
  constant ARD_DTIME_READ_ARRAY           : INTEGER_ARRAY_TYPE   := 
    (
      0, 0, 0,    -- user logic slave space determinate read parameters
      0, 0, 0     -- user logic master space determinate read parameters
    );

  -- specify determinate timing parameters to be used during write
  -- accesses for each address range, they not used currently, so
  -- all entries should be set to zeros.
  constant ARD_DTIME_WRITE_ARRAY          : INTEGER_ARRAY_TYPE   := 
    (
      0, 0, 0,    -- user logic slave space determinate write parameters
      0, 0, 0     -- user logic master space determinate write parameters
    );

  -- specify user defined device block id, which is used to uniquely
  -- identify a device within a system.
  constant DEV_BLK_ID                     : integer              := 0;

  -- specify inclusion/omission of module information register to be
  -- read via the plb bus.
  constant DEV_MIR_ENABLE                 : integer              := 0;

  -- specify inclusion/omission of additional logic needed to support
  -- plb fixed burst transfers and optimized cacahline transfers.
  constant DEV_BURST_ENABLE               : integer              := 1;

  -- specify the maximum number of bytes that are allowed to be
  -- transferred in a single burst operation, currently this needs
  -- to be fixed at 128.
  constant DEV_MAX_BURST_SIZE             : integer              := 128;

  -- specify size of the largest target burstable memory space (in
  -- bytes and a power of 2), this is to optimize the size of the
  -- internal burst address counters.
  constant DEV_BURST_PAGE_SIZE            : integer              := 1024;

  -- specify number of plb clock cycles are allowed before a
  -- data phase transfer timeout, this feature is useful during
  -- system integration and debug.
  constant DEV_DPHASE_TIMEOUT             : integer              := 64;

  -- specify inclusion/omission of device interrupt source
  -- controller for internal ipif generated interrupts.
  constant INCLUDE_DEV_ISC                : integer              := 0;

  -- specify inclusion/omission of device interrupt priority
  -- encoder, this is useful in aiding the user interrupt service
  -- routine to resolve the source of an interrupt within a plb
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

  -- specify inclusion/omission of plb master service for user logic.
  constant IP_MASTER_PRESENT              : integer              := 1;

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

  -- specify allowing dma busrt mode transactions or not.
  constant DMA_ALLOW_BURST                : integer              := 0;

  -- specify maximum allowed time period (in ns) a packet may wait
  -- before transfer by the scatter gather dma, apply to software
  -- design consideration.
  constant DMA_PACKET_WAIT_UNIT_NS        : integer              := 1000;

  -- specify period of the plb clock in picoseconds, which is used
  --  by the dma/sg service for timing funtions.
  constant PLB_CLK_PERIOD_PS              : integer              := 10000;

  -- specify ipif data bus size, used for future ipif optimization,
  -- should be set equal to the plb data bus width.
  constant IPIF_DWIDTH                    : integer              := C_PLB_DWIDTH;

  -- specify ipif address bus size, used for future ipif optimization,
  -- should be set equal to the plb address bus width.
  constant IPIF_AWIDTH                    : integer              := C_PLB_AWIDTH;

  -- specify user logic address bus width, must be same as the target bus.
  constant USER_AWIDTH                    : integer              := C_PLB_AWIDTH;

  -- specify index for user logic slave/master spaces chip enable.
  constant USER_SLAVE_CE_INDEX            : integer              := calc_start_ce_index(ARD_NUM_CE_ARRAY, get_id_index(ARD_ID_ARRAY, USER_SLAVE));

  constant USER_MASTER_CE_INDEX           : integer              := calc_start_ce_index(ARD_NUM_CE_ARRAY, get_id_index(ARD_ID_ARRAY, USER_MASTER));

  ------------------------------------------
  -- IP Interconnect (IPIC) signal declarations -- do not delete
  -- prefix 'i' stands for IPIF while prefix 'u' stands for user logic
  -- typically user logic will be hooked up to IPIF directly via i<sig>
  -- unless signal slicing and muxing are needed via u<sig>
  ------------------------------------------
  signal iBus2IP_Clk                    : std_logic;
  signal iBus2IP_Reset                  : std_logic;
  signal ZERO_IP2Bus_IntrEvent          : std_logic_vector(0 to IP_INTR_MODE_ARRAY'length - 1)   := (others => '0'); -- work around for XST not taking (others => '0') in port mapping
  signal iIP2Bus_Data                   : std_logic_vector(0 to C_PLB_DWIDTH-1)   := (others => '0');
  signal iIP2Bus_WrAck                  : std_logic   := '0';
  signal iIP2Bus_RdAck                  : std_logic   := '0';
  signal iIP2Bus_Retry                  : std_logic   := '0';
  signal iIP2Bus_Error                  : std_logic   := '0';
  signal iIP2Bus_ToutSup                : std_logic   := '0';
  signal iBus2IP_Data                   : std_logic_vector(0 to C_PLB_DWIDTH - 1);
  signal iBus2IP_BE                     : std_logic_vector(0 to (C_PLB_DWIDTH/8) - 1);
  signal iBus2IP_Burst                  : std_logic;
  signal iBus2IP_WrReq                  : std_logic;
  signal iBus2IP_RdReq                  : std_logic;
  signal iBus2IP_RdCE                   : std_logic_vector(0 to calc_num_ce(ARD_NUM_CE_ARRAY)-1);
  signal iBus2IP_WrCE                   : std_logic_vector(0 to calc_num_ce(ARD_NUM_CE_ARRAY)-1);
  signal iIP2Bus_Addr                   : std_logic_vector(0 to IPIF_AWIDTH - 1)   := (others => '0');
  signal iIP2Bus_MstBE                  : std_logic_vector(0 to (IPIF_DWIDTH/8) - 1)   := (others => '0');
  signal iIP2IP_Addr                    : std_logic_vector(0 to IPIF_AWIDTH - 1)   := (others => '0');
  signal iIP2Bus_MstWrReq               : std_logic   := '0';
  signal iIP2Bus_MstRdReq               : std_logic   := '0';
  signal iIP2Bus_MstBurst               : std_logic   := '0';
  signal iIP2Bus_MstBusLock             : std_logic   := '0';
  signal iIP2Bus_MstNum                 : std_logic_vector(0 to log2(DEV_MAX_BURST_SIZE/(C_PLB_DWIDTH/8)))   := (others => '0');
  signal iBus2IP_MstWrAck               : std_logic;
  signal iBus2IP_MstRdAck               : std_logic;
  signal iBus2IP_MstRetry               : std_logic;
  signal iBus2IP_MstError               : std_logic;
  signal iBus2IP_MstTimeOut             : std_logic;
  signal iBus2IP_MstLastAck             : std_logic;
  signal ZERO_IP2RFIFO_Data             : std_logic_vector(0 to find_id_dwidth(ARD_ID_ARRAY, ARD_DWIDTH_ARRAY, IPIF_RDFIFO_DATA, 32)-1)   := (others => '0'); -- work around for XST not taking (others => '0') in port mapping
  signal uBus2IP_Data                   : std_logic_vector(0 to USER_DWIDTH-1);
  signal uBus2IP_BE                     : std_logic_vector(0 to USER_DWIDTH/8-1);
  signal uBus2IP_RdCE                   : std_logic_vector(0 to USER_NUM_CE-1);
  signal uBus2IP_WrCE                   : std_logic_vector(0 to USER_NUM_CE-1);
  signal uIP2Bus_Data                   : std_logic_vector(0 to USER_DWIDTH-1);
  signal uIP2Bus_MstBE                  : std_logic_vector(0 to USER_DWIDTH/8-1);

begin
    ------------------------------------------
    -- instantiate the PLB IPIF
    ------------------------------------------
    PLB_IPIF_I : entity plb_ipif_v2_01_a.plb_ipif
    generic map
    (
      C_ARD_ID_ARRAY                 => ARD_ID_ARRAY,
      C_ARD_ADDR_RANGE_ARRAY         => ARD_ADDR_RANGE_ARRAY,
      C_ARD_DWIDTH_ARRAY             => ARD_DWIDTH_ARRAY,
      C_ARD_NUM_CE_ARRAY             => ARD_NUM_CE_ARRAY,
      C_ARD_DEPENDENT_PROPS_ARRAY    => ARD_DEPENDENT_PROPS_ARRAY,
      C_ARD_DTIME_READ_ARRAY         => ARD_DTIME_READ_ARRAY,
      C_ARD_DTIME_WRITE_ARRAY        => ARD_DTIME_WRITE_ARRAY,
      C_DEV_BLK_ID                   => DEV_BLK_ID,
      C_DEV_MIR_ENABLE               => DEV_MIR_ENABLE,
      C_DEV_BURST_ENABLE             => DEV_BURST_ENABLE,
      C_DEV_MAX_BURST_SIZE           => DEV_MAX_BURST_SIZE,
      C_DEV_BURST_PAGE_SIZE          => DEV_BURST_PAGE_SIZE,
      C_DEV_DPHASE_TIMEOUT           => DEV_DPHASE_TIMEOUT,
      C_INCLUDE_DEV_ISC              => INCLUDE_DEV_ISC,
      C_INCLUDE_DEV_PENCODER         => INCLUDE_DEV_PENCODER,
      C_IP_INTR_MODE_ARRAY           => IP_INTR_MODE_ARRAY,
      C_IP_MASTER_PRESENT            => IP_MASTER_PRESENT,
      C_DMA_CHAN_TYPE_ARRAY          => DMA_CHAN_TYPE_ARRAY,
      C_DMA_LENGTH_WIDTH_ARRAY       => DMA_LENGTH_WIDTH_ARRAY,
      C_DMA_PKT_LEN_FIFO_ADDR_ARRAY  => DMA_PKT_LEN_FIFO_ADDR_ARRAY,
      C_DMA_PKT_STAT_FIFO_ADDR_ARRAY => DMA_PKT_STAT_FIFO_ADDR_ARRAY,
      C_DMA_INTR_COALESCE_ARRAY      => DMA_INTR_COALESCE_ARRAY,
      C_DMA_ALLOW_BURST              => DMA_ALLOW_BURST,
      C_DMA_PACKET_WAIT_UNIT_NS      => DMA_PACKET_WAIT_UNIT_NS,
      C_PLB_MID_WIDTH                => C_PLB_MID_WIDTH,
      C_PLB_NUM_MASTERS              => C_PLB_NUM_MASTERS,
      C_PLB_AWIDTH                   => C_PLB_AWIDTH,
      C_PLB_DWIDTH                   => C_PLB_DWIDTH,
      C_PLB_CLK_PERIOD_PS            => PLB_CLK_PERIOD_PS,
      C_IPIF_DWIDTH                  => IPIF_DWIDTH,
      C_IPIF_AWIDTH                  => IPIF_AWIDTH,
      C_FAMILY                       => C_FAMILY
    )
    port map
    (
      PLB_clk                        => PLB_Clk,
      Reset                          => PLB_Rst,
      Freeze                         => '0',
      IP2INTC_Irpt                   => open,
      PLB_ABus                       => PLB_ABus,
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
      PLB_compress                   => PLB_compress,
      PLB_guarded                    => PLB_guarded,
      PLB_ordered                    => PLB_ordered,
      PLB_lockErr                    => PLB_lockErr,
      PLB_wrDBus                     => PLB_wrDBus,
      PLB_wrBurst                    => PLB_wrBurst,
      PLB_rdBurst                    => PLB_rdBurst,
      PLB_pendReq                    => PLB_pendReq,
      PLB_pendPri                    => PLB_pendPri,
      PLB_reqPri                     => PLB_reqPri,
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
      Sl_MErr                        => Sl_MErr,
      PLB_MAddrAck                   => PLB_MAddrAck,
      PLB_MSSize                     => PLB_MSSize,
      PLB_MRearbitrate               => PLB_MRearbitrate,
      PLB_MBusy                      => PLB_MBusy,
      PLB_MErr                       => PLB_MErr,
      PLB_MWrDAck                    => PLB_MWrDAck,
      PLB_MRdDBus                    => PLB_MRdDBus,
      PLB_MRdWdAddr                  => PLB_MRdWdAddr,
      PLB_MRdDAck                    => PLB_MRdDAck,
      PLB_MRdBTerm                   => PLB_MRdBTerm,
      PLB_MWrBTerm                   => PLB_MWrBTerm,
      M_request                      => M_request,
      M_priority                     => M_priority,
      M_busLock                      => M_busLock,
      M_RNW                          => M_RNW,
      M_BE                           => M_BE,
      M_MSize                        => M_MSize,
      M_size                         => M_size,
      M_type                         => M_type,
      M_compress                     => M_compress,
      M_guarded                      => M_guarded,
      M_ordered                      => M_ordered,
      M_lockErr                      => M_lockErr,
      M_abort                        => M_abort,
      M_ABus                         => M_ABus,
      M_wrDBus                       => M_wrDBus,
      M_wrBurst                      => M_wrBurst,
      M_rdBurst                      => M_rdBurst,
      IP2Bus_Clk                     => '0',
      Bus2IP_Clk                     => iBus2IP_Clk,
      Bus2IP_Reset                   => iBus2IP_Reset,
      Bus2IP_Freeze                  => open,
      IP2Bus_IntrEvent               => ZERO_IP2Bus_IntrEvent,
      IP2Bus_Data                    => iIP2Bus_Data,
      IP2Bus_WrAck                   => iIP2Bus_WrAck,
      IP2Bus_RdAck                   => iIP2Bus_RdAck,
      IP2Bus_Retry                   => iIP2Bus_Retry,
      IP2Bus_Error                   => iIP2Bus_Error,
      IP2Bus_ToutSup                 => iIP2Bus_ToutSup,
      IP2Bus_PostedWrInh             => '0',
      Bus2IP_Addr                    => open,
      Bus2IP_Data                    => iBus2IP_Data,
      Bus2IP_RNW                     => open,
      Bus2IP_BE                      => iBus2IP_BE,
      Bus2IP_Burst                   => iBus2IP_Burst,
      Bus2IP_WrReq                   => iBus2IP_WrReq,
      Bus2IP_RdReq                   => iBus2IP_RdReq,
      Bus2IP_CS                      => open,
      Bus2IP_CE                      => open,
      Bus2IP_RdCE                    => iBus2IP_RdCE,
      Bus2IP_WrCE                    => iBus2IP_WrCE,
      IP2DMA_RxLength_Empty          => '0',
      IP2DMA_RxStatus_Empty          => '0',
      IP2DMA_TxLength_Full           => '0',
      IP2DMA_TxStatus_Empty          => '0',
      IP2Bus_Addr                    => iIP2Bus_Addr,
      IP2Bus_MstBE                   => iIP2Bus_MstBE,
      IP2IP_Addr                     => iIP2IP_Addr,
      IP2Bus_MstWrReq                => iIP2Bus_MstWrReq,
      IP2Bus_MstRdReq                => iIP2Bus_MstRdReq,
      IP2Bus_MstBurst                => iIP2Bus_MstBurst,
      IP2Bus_MstBusLock              => iIP2Bus_MstBusLock,
      IP2Bus_MstNum                  => iIP2Bus_MstNum,
      Bus2IP_MstWrAck                => iBus2IP_MstWrAck,
      Bus2IP_MstRdAck                => iBus2IP_MstRdAck,
      Bus2IP_MstRetry                => iBus2IP_MstRetry,
      Bus2IP_MstError                => iBus2IP_MstError,
      Bus2IP_MstTimeOut              => iBus2IP_MstTimeOut,
      Bus2IP_MstLastAck              => iBus2IP_MstLastAck,
      Bus2IP_IPMstTrans              => open,
      IP2RFIFO_WrReq                 => '0',
      IP2RFIFO_Data                  => ZERO_IP2RFIFO_Data,
      IP2RFIFO_WrMark                => '0',
      IP2RFIFO_WrRelease             => '0',
      IP2RFIFO_WrRestore             => '0',
      RFIFO2IP_WrAck                 => open,
      RFIFO2IP_AlmostFull            => open,
      RFIFO2IP_Full                  => open,
      RFIFO2IP_Vacancy               => open,
      IP2WFIFO_RdReq                 => '0',
      IP2WFIFO_RdMark                => '0',
      IP2WFIFO_RdRelease             => '0',
      IP2WFIFO_RdRestore             => '0',
      WFIFO2IP_Data                  => open,
      WFIFO2IP_RdAck                 => open,
      WFIFO2IP_AlmostEmpty           => open,
      WFIFO2IP_Empty                 => open,
      WFIFO2IP_Occupancy             => open,
      IP2Bus_DMA_Req                 => '0',
      Bus2IP_DMA_Ack                 => open
    );

    ------------------------------------------
    -- instantiate the User Logic
    ------------------------------------------
    USER_LOGIC_I : entity plb_hwti_v1_00_a.user_logic
    generic map
    (
      --C_MANAG_BASEADDR               : std_logic_vector     := x"00000000";
      --C_SCHED_BASEADDR               : std_logic_vector     := x"00000000";
      --C_MUTEX_BASEADDR               : std_logic_vector     := x"00000000";
      --C_CONDV_BASEADDR               : std_logic_vector     := x"00000000";

      USR_BASE                       => C_BASEADDR,
      MTX_BASE                       => C_MUTEX_BASE,
      CDV_BASE                       => C_CONDV_BASE,
      SCH_BASE                       => C_SCHED_BASE,
      MNG_BASE                       => C_MANAG_BASE,
      C_AWIDTH                       => USER_AWIDTH,
      C_DWIDTH                       => USER_DWIDTH,
      C_NUM_CE                       => USER_NUM_CE
    )
    port map
    (
      FSL_S_READ                     => USER2HWTI_S_READ,
      FSL_S_DATA                     => USER2HWTI_S_DATA,
      FSL_S_CONTROL                  => USER2HWTI_S_CONTROL,
      FSL_S_EXISTS                   => USER2HWTI_S_EXISTS,

      FSL_M_WRITE                    => HWTI2USER_M_WRITE,
      FSL_M_DATA                     => HWTI2USER_M_DATA,
      FSL_M_CONTROL                  => HWTI2USER_M_CONTROL,
      FSL_M_FULL                     => HWTI2USER_M_FULL,

      Bus2IP_Clk                     => iBus2IP_Clk,
      Bus2IP_Reset                   => iBus2IP_Reset,
      Bus2IP_Data                    => uBus2IP_Data,
      Bus2IP_BE                      => uBus2IP_BE,
      Bus2IP_Burst                   => iBus2IP_Burst,
      Bus2IP_RdCE                    => uBus2IP_RdCE,
      Bus2IP_WrCE                    => uBus2IP_WrCE,
      Bus2IP_RdReq                   => iBus2IP_RdReq,
      Bus2IP_WrReq                   => iBus2IP_WrReq,
      IP2Bus_Data                    => uIP2Bus_Data,
      IP2Bus_Retry                   => iIP2Bus_Retry,
      IP2Bus_Error                   => iIP2Bus_Error,
      IP2Bus_ToutSup                 => iIP2Bus_ToutSup,
      IP2Bus_RdAck                   => iIP2Bus_RdAck,
      IP2Bus_WrAck                   => iIP2Bus_WrAck,
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
      IP2Bus_MstNum                  => iIP2Bus_MstNum,
      IP2Bus_MstRdReq                => iIP2Bus_MstRdReq,
      IP2Bus_MstWrReq                => iIP2Bus_MstWrReq,
      IP2IP_Addr                     => iIP2IP_Addr
    );

    user2hwti_low : entity fsl_v20_v2_10_a.fsl_v20
    generic map
    (
        C_EXT_RESET_HIGH => 1,
        C_ASYNC_CLKS     => 0,
        C_IMPL_STYLE     => 0,
        C_USE_CONTROL    => 1,
        C_FSL_DWIDTH     => 32,
        C_FSL_DEPTH      => 16
    )
    port map
    (
        FSL_Clk         => PLB_Clk,
        SYS_Rst         => PLB_Rst,
        FSL_Rst         => open,

        FSL_M_Clk       => '0',
        FSL_M_Data      => USER2HWTIL_M_Data,
        FSL_M_Control   => USER2HWTIL_M_Control,
        FSL_M_Write     => USER2HWTIL_M_Write,
        FSL_M_Full      => USER2HWTIL_M_Full,

        FSL_S_Clk       => '0',
        FSL_S_Data      => USER2HWTIL_S_Data,
        FSL_S_Control   => USER2HWTIL_S_Control,
        FSL_S_Read      => USER2HWTIL_S_Read,
        FSL_S_Exists    => USER2HWTIL_S_Exists,

        FSL_Full        => open,
        FSL_Has_Data    => open,
        FSL_Control_IRQ => open
    );

    user2hwti_high : entity fsl_v20_v2_10_a.fsl_v20
    generic map
    (
        C_EXT_RESET_HIGH => 1,
        C_ASYNC_CLKS     => 0,
        C_IMPL_STYLE     => 0,
        C_USE_CONTROL    => 1,
        C_FSL_DWIDTH     => 32,
        C_FSL_DEPTH      => 16
    )
    port map
    (
        FSL_Clk         => PLB_Clk,
        SYS_Rst         => PLB_Rst,
        FSL_Rst         => open,

        FSL_M_Clk       => '0',
        FSL_M_Data      => USER2HWTIH_M_DATA,
        FSL_M_Control   => USER2HWTIH_M_CONTROL,
        FSL_M_Write     => USER2HWTIH_M_WRITE,
        FSL_M_Full      => USER2HWTIH_M_FULL,

        FSL_S_Clk       => '0',
        FSL_S_Data      => USER2HWTIH_S_DATA,
        FSL_S_Control   => USER2HWTIH_S_CONTROL,
        FSL_S_Read      => USER2HWTIH_S_READ,
        FSL_S_Exists    => USER2HWTIH_S_EXISTS,

        FSL_Full        => open,
        FSL_Has_Data    => open,
        FSL_Control_IRQ => open
    );

    hwti2user_low : entity fsl_v20_v2_10_a.fsl_v20
    generic map
    (
        C_EXT_RESET_HIGH => 1,
        C_ASYNC_CLKS     => 0,
        C_IMPL_STYLE     => 0,
        C_USE_CONTROL    => 1,
        C_FSL_DWIDTH     => 32,
        C_FSL_DEPTH      => 16
    )
    port map
    (
        FSL_Clk         => PLB_Clk,
        SYS_Rst         => PLB_Rst,
        FSL_Rst         => open,

        FSL_M_Clk       => '0',
        FSL_M_Data      => HWTI2USERL_M_DATA,
        FSL_M_Control   => HWTI2USERL_M_CONTROL,
        FSL_M_Write     => HWTI2USERL_M_WRITE,
        FSL_M_Full      => HWTI2USERL_M_FULL,

        FSL_S_Clk       => '0',
        FSL_S_Data      => HWTI2USERL_S_DATA,
        FSL_S_Control   => HWTI2USERL_S_CONTROL,
        FSL_S_Read      => HWTI2USERL_S_READ,
        FSL_S_Exists    => HWTI2USERL_S_EXISTS,

        FSL_Full        => open,
        FSL_Has_Data    => open,
        FSL_Control_IRQ => open
    );

    hwti2user_high : entity fsl_v20_v2_10_a.fsl_v20
    generic map
    (
        C_EXT_RESET_HIGH => 1,
        C_ASYNC_CLKS     => 0,
        C_IMPL_STYLE     => 0,
        C_USE_CONTROL    => 1,
        C_FSL_DWIDTH     => 32,
        C_FSL_DEPTH      => 16
    )
    port map
    (
        FSL_Clk         => PLB_Clk,
        SYS_Rst         => PLB_Rst,
        FSL_Rst         => open,

        FSL_M_Clk       => '0',
        FSL_M_Data      => HWTI2USERH_M_DATA,
        FSL_M_Control   => HWTI2USERH_M_CONTROL,
        FSL_M_Write     => HWTI2USERH_M_WRITE,
        FSL_M_Full      => HWTI2USERH_M_FULL,

        FSL_S_Clk       => '0',
        FSL_S_Data      => HWTI2USERH_S_DATA,
        FSL_S_Control   => HWTI2USERH_S_CONTROL,
        FSL_S_Read      => HWTI2USERH_S_READ,
        FSL_S_Exists    => HWTI2USERH_S_EXISTS,

        FSL_Full        => open,
        FSL_Has_Data    => open,
        FSL_Control_IRQ => open
    );

    HWTI2USERL_M_DATA    <= HWTI2USER_M_DATA(32 to 63);
    HWTI2USERH_M_DATA    <= HWTI2USER_M_DATA(0 to 31);
    HWTI2USERL_M_CONTROL <= HWTI2USER_M_CONTROL;
    HWTI2USERH_M_CONTROL <= HWTI2USER_M_CONTROL;
    HWTI2USERL_M_WRITE   <= HWTI2USER_M_WRITE;
    HWTI2USERH_M_WRITE   <= HWTI2USER_M_WRITE;
    HWTI2USER_M_FULL     <= HWTI2USERL_M_FULL or HWTI2USERH_M_FULL;

    H2ULOW_S_DATA        <= HWTI2USERL_S_DATA;
    H2UHIGH_S_DATA       <= HWTI2USERH_S_DATA;
    H2ULOW_S_CONTROL     <= HWTI2USERL_S_CONTROL;
    H2UHIGH_S_CONTROL    <= HWTI2USERH_S_CONTROL;
    H2ULOW_S_EXISTS      <= HWTI2USERL_S_EXISTS;
    H2UHIGH_S_EXISTS     <= HWTI2USERH_S_EXISTS;
    HWTI2USERL_S_READ    <= H2ULOW_S_READ or H2UHIGH_S_READ;
    HWTI2USERH_S_READ    <= H2ULOW_S_READ or H2UHIGH_S_READ;

    USER2HWTIL_M_DATA    <= U2HLOW_M_DATA;
    USER2HWTIH_M_DATA    <= U2HHIGH_M_DATA;
    USER2HWTIL_M_CONTROL <= U2HLOW_M_CONTROL;
    USER2HWTIH_M_CONTROL <= U2HHIGH_M_CONTROL;
    USER2HWTIL_M_WRITE   <= U2HLOW_M_WRITE;
    USER2HWTIH_M_WRITE   <= U2HHIGH_M_WRITE;
    U2HLOW_M_FULL        <= USER2HWTIL_M_FULL or USER2HWTIH_M_FULL;
    U2HHIGH_M_FULL       <= USER2HWTIL_M_FULL or USER2HWTIH_M_FULL;

    USER2HWTI_S_DATA     <= USER2HWTIH_S_DATA & USER2HWTIL_S_DATA;
    USER2HWTI_S_CONTROL  <= USER2HWTIL_S_CONTROL or USER2HWTIH_S_CONTROL;
    USER2HWTI_S_EXISTS   <= USER2HWTIL_S_EXISTS and USER2HWTIH_S_EXISTS;
    USER2HWTIL_S_READ    <= USER2HWTI_S_READ;
    USER2HWTIH_S_READ    <= USER2HWTI_S_READ;

    --USER2HWTI_M_WRITE    <= U2HLOW_M_WRITE    and U2HHIGH_M_WRITE;
    --USER2HWTI_M_DATA     <= U2HLOW_M_DATA     &   U2HHIGH_M_DATA;
    --USER2HWTI_M_CONTROL  <= U2HLOW_M_CONTROL  or  U2HHIGH_M_CONTROL;
    --USER2HWTI_M_FULL     <= USER2HWTIH_M_FULL or  USER2HWTIL_M_FULL;
    --U2HLOW_M_FULL        <= USER2HWTIL_M_FULL;
    --U2HHIGH_M_FULL       <= USER2HWTIH_M_FULL;

    --HWTI2USER_S_READ     <= H2ULOW_S_READ or H2UHIGH_S_READ;
    --H2ULOW_S_DATA        <= HWTI2USERL_S_DATA;
    --H2ULOW_S_CONTROL     <= HWTI2USERL_S_CONTROL;
    --H2ULOW_S_EXISTS      <= HWTI2USERL_S_EXISTS;
    --H2UHIGH_S_DATA       <= HWTI2USERH_S_DATA;
    --H2UHIGH_S_CONTROL    <= HWTI2USERH_S_CONTROL;
    --H2UHIGH_S_EXISTS     <= HWTI2USERH_S_EXISTS;

    --USER2HWTIL_S_READ    <= USER2HWTI_S_READ;
    --USER2HWTIH_S_READ    <= USER2HWTI_S_READ;
    --USER2HWTI_S_DATA     <= USER2HWTIH_S_DATA    &   USER2HWTIL_S_DATA;
    --USER2HWTI_S_CONTROL  <= USER2HWTIH_S_CONTROL or  USER2HWTIL_S_CONTROL;
    --USER2HWTI_S_EXISTS   <= USER2HWTIH_S_EXISTS  and USER2HWTIL_S_EXISTS;


    --HWTI2USERH_M_WRITE   <= HWTI2USER_M_WRITE;
    --HWTI2USERL_M_WRITE   <= HWTI2USER_M_WRITE;
    --HWTI2USERH_M_DATA    <= HWTI2USER_M_DATA(0 to 31);
    --HWTI2USERL_M_DATA    <= HWTI2USER_M_DATA(32 to 63);
    --HWTI2USERH_M_CONTROL <= HWTI2USER_M_CONTROL;
    --HWTI2USERL_M_CONTROL <= HWTI2USER_M_CONTROL;
    --HWTI2USER_M_FULL     <= HWTI2USERH_M_FULL or HWTI2USERL_M_FULL;

    --HWTI2USER_S_READ    <= FSL_S_READ;
    --FSL_S_DATA          <= HWTI2USER_S_DATA;
    --FSL_S_CONTROL       <= HWTI2USER_S_CONTROL;
    --FSL_S_EXISTS        <= HWTI2USER_S_EXISTS;

    --USER2HWTI_M_WRITE   <= FSL_M_WRITE;
    --USER2HWTI_M_DATA    <= FSL_M_DATA;
    --USER2HWTI_M_CONTROL <= FSL_M_CONTROL;
    --FSL_M_FULL          <= USER2HWTI_M_FULL;

    ------------------------------------------
    -- hooking up signal slicing
    ------------------------------------------
    iIP2Bus_MstBE <= uIP2Bus_MstBE;
    uBus2IP_Data <= iBus2IP_Data(0 to USER_DWIDTH-1);
    uBus2IP_BE <= iBus2IP_BE(0 to USER_DWIDTH/8-1);
    uBus2IP_RdCE(0 to USER_NUM_SLAVE_CE-1) <= iBus2IP_RdCE(USER_SLAVE_CE_INDEX to USER_SLAVE_CE_INDEX+USER_NUM_SLAVE_CE-1);
    uBus2IP_RdCE(USER_NUM_SLAVE_CE to USER_NUM_CE-1) <= iBus2IP_RdCE(USER_MASTER_CE_INDEX to USER_MASTER_CE_INDEX+USER_NUM_MASTER_CE-1);
    uBus2IP_WrCE(0 to USER_NUM_SLAVE_CE-1) <= iBus2IP_WrCE(USER_SLAVE_CE_INDEX to USER_SLAVE_CE_INDEX+USER_NUM_SLAVE_CE-1);
    uBus2IP_WrCE(USER_NUM_SLAVE_CE to USER_NUM_CE-1) <= iBus2IP_WrCE(USER_MASTER_CE_INDEX to USER_MASTER_CE_INDEX+USER_NUM_MASTER_CE-1);
    iIP2Bus_Data(0 to USER_DWIDTH-1) <= uIP2Bus_Data;
end IMP;
