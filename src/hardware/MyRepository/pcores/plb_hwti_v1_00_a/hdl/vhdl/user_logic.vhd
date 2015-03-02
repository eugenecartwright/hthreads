library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library proc_common_v1_00_b;
use proc_common_v1_00_b.proc_common_pkg.all;

library hwti_common_v1_00_a;
use hwti_common_v1_00_a.common.all;

library plb_hwti_v1_00_a;

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_AWIDTH                     -- User logic address bus width
--   C_DWIDTH                     -- User logic data bus width
--   C_NUM_CE                     -- User logic chip enable bus width
--
-- Definition of Ports:
--   Bus2IP_Clk                   -- Bus to IP clock
--   Bus2IP_Reset                 -- Bus to IP reset
--   Bus2IP_Data                  -- Bus to IP data bus for user logic
--   Bus2IP_BE                    -- Bus to IP byte enables for user logic
--   Bus2IP_Burst                 -- Bus to IP burst-mode qualifier
--   Bus2IP_RdCE                  -- Bus to IP read chip enable for user logic
--   Bus2IP_WrCE                  -- Bus to IP write chip enable for user logic
--   Bus2IP_RdReq                 -- Bus to IP read request
--   Bus2IP_WrReq                 -- Bus to IP write request
--   IP2Bus_Data                  -- IP to Bus data bus for user logic
--   IP2Bus_Retry                 -- IP to Bus retry response
--   IP2Bus_Error                 -- IP to Bus error response
--   IP2Bus_ToutSup               -- IP to Bus timeout suppress
--   IP2Bus_RdAck                 -- IP to Bus read transfer acknowledgement
--   IP2Bus_WrAck                 -- IP to Bus write transfer acknowledgement
--   Bus2IP_MstError              -- Bus to IP master error
--   Bus2IP_MstLastAck            -- Bus to IP master last acknowledge
--   Bus2IP_MstRdAck              -- Bus to IP master read acknowledge
--   Bus2IP_MstWrAck              -- Bus to IP master write acknowledge
--   Bus2IP_MstRetry              -- Bus to IP master retry
--   Bus2IP_MstTimeOut            -- Bus to IP mster timeout
--   IP2Bus_Addr                  -- IP to Bus address for the master transaction
--   IP2Bus_MstBE                 -- IP to Bus byte-enables qualifiers
--   IP2Bus_MstBurst              -- IP to Bus burst qualifier
--   IP2Bus_MstBusLock            -- IP to Bus bus-lock qualifier
--   IP2Bus_MstNum                -- IP to Bus burst size indicator
--   IP2Bus_MstRdReq              -- IP to Bus master read request
--   IP2Bus_MstWrReq              -- IP to Bus master write request
--   IP2IP_Addr                   -- IP to IP local device address for the master transaction
------------------------------------------------------------------------------
entity user_logic is
  generic
  (
    MTX_BITS            : natural              := 6;
    TID_BITS            : natural              := 8;
    CMD_BITS            : natural              := 3;
    MTX_BASE            : std_logic_vector     := x"75000000";
    CDV_BASE            : std_logic_vector     := x"74000000";
    SCH_BASE            : std_logic_vector     := x"61000000";
    MNG_BASE            : std_logic_vector     := x"60000000";
    USR_BASE            : std_logic_vector     := x"30000000";
    C_AWIDTH            : integer              := 32;
    C_DWIDTH            : integer              := 64;
    C_NUM_CE            : integer              := 8
  );
  port
  (
    FSL_S_READ          : out std_logic;
    FSL_S_DATA          : in  std_logic_vector(0 to 63);
    FSL_S_CONTROL       : in  std_logic;
    FSL_S_EXISTS        : in  std_logic;

    FSL_M_WRITE         : out std_logic;
    FSL_M_DATA          : out std_logic_vector(0 to 63);
    FSL_M_CONTROL       : out std_logic;
    FSL_M_FULL          : in  std_logic;

    Bus2IP_Clk          : in  std_logic;
    Bus2IP_Reset        : in  std_logic;
    Bus2IP_Data         : in  std_logic_vector(0 to C_DWIDTH-1);
    Bus2IP_BE           : in  std_logic_vector(0 to C_DWIDTH/8-1);
    Bus2IP_Burst        : in  std_logic;
    Bus2IP_RdCE         : in  std_logic_vector(0 to C_NUM_CE-1);
    Bus2IP_WrCE         : in  std_logic_vector(0 to C_NUM_CE-1);
    Bus2IP_RdReq        : in  std_logic;
    Bus2IP_WrReq        : in  std_logic;
    IP2Bus_Data         : out std_logic_vector(0 to C_DWIDTH-1);
    IP2Bus_Retry        : out std_logic;
    IP2Bus_Error        : out std_logic;
    IP2Bus_ToutSup      : out std_logic;
    IP2Bus_RdAck        : out std_logic;
    IP2Bus_WrAck        : out std_logic;
    Bus2IP_MstError     : in  std_logic;
    Bus2IP_MstLastAck   : in  std_logic;
    Bus2IP_MstRdAck     : in  std_logic;
    Bus2IP_MstWrAck     : in  std_logic;
    Bus2IP_MstRetry     : in  std_logic;
    Bus2IP_MstTimeOut   : in  std_logic;
    IP2Bus_Addr         : out std_logic_vector(0 to C_AWIDTH-1);
    IP2Bus_MstBE        : out std_logic_vector(0 to C_DWIDTH/8-1);
    IP2Bus_MstBurst     : out std_logic;
    IP2Bus_MstBusLock   : out std_logic;
    IP2Bus_MstNum       : out std_logic_vector(0 to 4);
    IP2Bus_MstRdReq     : out std_logic;
    IP2Bus_MstWrReq     : out std_logic;
    IP2IP_Addr          : out std_logic_vector(0 to C_AWIDTH-1)
  );
end entity user_logic;

architecture behavioral of user_logic is
  constant BUS_ADDR : std_logic_vector(0 to C_AWIDTH-1) := USR_BASE(0 to 23) & x"18";

  signal tid_data   : std_logic_vector(0 to 31);
  --signal bus_data   : std_logic_vector(0 to C_DWIDTH-1);
  signal sta_data   : std_logic_vector(0 to 31);
  --signal cmd_data   : std_logic_vector(0 to C_DWIDTH-1);
  signal arg_data   : std_logic_vector(0 to 31);
  signal res_data   : std_logic_vector(0 to 31);
  signal mux_data   : std_logic_vector(0 to 31);

  signal mem_rd     : std_logic;
  signal mem_wr     : std_logic;
  signal mem_addr   : std_logic_vector(0 to C_AWIDTH-1);
  signal mem_res    : std_logic_vector(0 to C_DWIDTH-1);
  signal mem_ack    : std_logic;
  signal mem_last   : std_logic;
  signal mem_err    : std_logic;
  signal mem_data   : std_logic_vector(0 to C_DWIDTH-1);
  signal mem_length : std_logic_vector(0 to 23);

  signal cmd_wr    : std_logic;
  signal sta_wr    : std_logic;
  signal res_wr    : std_logic;

  signal tid_rdack : std_logic;
  signal bus_rdack : std_logic;
  signal sta_rdack : std_logic;
  --signal cmd_rdack : std_logic;
  signal arg_rdack : std_logic;
  signal res_rdack : std_logic;

  signal tid_wrack : std_logic;
  signal bus_wrack : std_logic;
  signal sta_wrack : std_logic;
  --signal cmd_wrack : std_logic;
  signal arg_wrack : std_logic;
  --signal res_wrack : std_logic;

  signal tid_value : std_logic_vector(0 to 7);
  --signal bus_value : std_logic_vector(0 to C_DWIDTH-1);
  signal sta_value : std_logic_vector(0 to 7);
  --signal cmd_value : std_logic_vector(0 to 3);
  signal arg_value : std_logic_vector(0 to 31);
  signal res_value : std_logic_vector(0 to 31);

  --signal cmd_iwr   : std_logic;
  --signal sta_iwr   : std_logic;
  --signal sta_idata : std_logic_vector(0 to C_DWIDTH-1);
  --signal cmd_idata : std_logic_vector(0 to C_DWIDTH-1);
  signal sta_wdata : std_logic_vector(0 to 31);
  signal res_wdata : std_logic_vector(0 to 31);
  --signal cmd_wdata : std_logic_vector(0 to C_DWIDTH-1);

  alias tid_read   : std_logic is Bus2IP_RdCE(0);
  alias tmr_read   : std_logic is Bus2IP_RdCE(1);
  alias sta_read   : std_logic is Bus2IP_RdCE(2);
  alias cmd_read   : std_logic is Bus2IP_RdCE(3);
  alias arg_read   : std_logic is Bus2IP_RdCE(4);
  alias res_read   : std_logic is Bus2IP_RdCE(5);
  alias bus_read   : std_logic is Bus2IP_RdCE(6);

  alias tid_write  : std_logic is Bus2IP_WrCE(0);
  alias tmr_write  : std_logic is Bus2IP_WrCE(1);
  alias sta_write  : std_logic is Bus2IP_WrCE(2);
  alias cmd_write  : std_logic is Bus2IP_WrCE(3);
  alias arg_write  : std_logic is Bus2IP_WrCE(4);
  alias res_write  : std_logic is Bus2IP_WrCE(5);
  alias bus_write  : std_logic is Bus2IP_WrCE(6);
begin
    mux_data        <= tid_data or sta_data or arg_data or res_data;
    IP2Bus_Data     <= (mux_data & x"00000000") or mem_data
                       when Bus2IP_RdReq='1' else (others => '0');

    IP2Bus_WrAck    <= tid_wrack or sta_wrack or arg_wrack or res_write or
                       bus_wrack or cmd_write;

    IP2Bus_RdAck    <= tid_rdack or sta_rdack or arg_rdack or res_rdack or
                       bus_rdack or cmd_read;

    IP2Bus_Error    <= '0';
    IP2Bus_Retry    <= '0';
    IP2Bus_ToutSup  <= Bus2IP_RdReq or Bus2IP_WrReq;

    -- Instantiate the Thread ID register as a read/write register
    tidreg : entity hwti_common_v1_00_a.hwtireg
    generic map
    (
        REG_WIDTH   => TID_BITS,
        C_AWIDTH    => C_AWIDTH,
        C_DWIDTH    => 32
    )
    port map
    (
        clk         => Bus2IP_Clk,
        rst         => Bus2IP_Reset,
        rd          => tid_read,
        wr          => tid_write,
        data        => Bus2IP_Data(0 to 31),
        rdack       => tid_rdack,
        wrack       => tid_wrack,
        value       => tid_value,
        output      => tid_data
    );

    -- Instantiate the Timer register as a read/write register
    --busreg : entity hwti_common_v1_00_a.hwtireg
    --generic map
    --(
    --    REG_WIDTH   => C_DWIDTH,
    --    C_AWIDTH    => C_AWIDTH,
    --    C_DWIDTH    => C_DWIDTH
    --)
    --port map
    --(
    --    clk         => Bus2IP_Clk,
    --    rst         => Bus2IP_Reset,
    --    rd          => bus_read,
    --    wr          => bus_write,
    --    data        => Bus2IP_Data,
    --    rdack       => bus_rdack,
    --    wrack       => bus_wrack,
    --    value       => bus_value,
    --    output      => bus_data
    --);

    -- Instantiate the Status register as a read/write register
    stareg : entity hwti_common_v1_00_a.hwtireg
    generic map
    (
        REG_WIDTH   => 8,
        C_AWIDTH    => C_AWIDTH,
        C_DWIDTH    => 32
    )
    port map
    (
        clk         => Bus2IP_Clk,
        rst         => Bus2IP_Reset,
        rd          => sta_read,
        wr          => sta_wr,
        data        => sta_wdata,
        rdack       => sta_rdack,
        wrack       => sta_wrack,
        value       => sta_value,
        output      => sta_data
    );

    -- Make a mux for the command register data and status register data
    --cmd_idata <= Bus2IP_Data when cmd_write = '1' else cmd_wdata;
    --cmd_iwr   <= cmd_wr or cmd_write;
    --sta_idata <= Bus2IP_Data when sta_write = '1' else sta_wdata;
    --sta_iwr   <= sta_wr or sta_write;

    -- Instantiate the Command register as a read/write register
    --cmdreg : entity hwti_common_v1_00_a.hwtireg
    --generic map
    --(
    --    REG_WIDTH   => 4,
    --    C_AWIDTH    => C_AWIDTH,
    --    C_DWIDTH    => C_DWIDTH
    --)
    --port map
    --(
    --    clk         => Bus2IP_Clk,
    --    rst         => Bus2IP_Reset,
    --    rd          => cmd_read,
    --    wr          => cmd_iwr,
    --    data        => cmd_idata,
    --    rdack       => cmd_rdack,
    --    wrack       => cmd_wrack,
    --    value       => cmd_value,
    --    output      => cmd_data
    --);

    -- Instantiate the Argument register as a read/write register
    argreg : entity hwti_common_v1_00_a.hwtireg
    generic map
    (
        REG_WIDTH   => 32,
        C_AWIDTH    => C_AWIDTH,
        C_DWIDTH    => 32
    )
    port map
    (
        clk         => Bus2IP_Clk,
        rst         => Bus2IP_Reset,
        rd          => arg_read,
        wr          => arg_write,
        data        => Bus2IP_Data(0 to 31),
        rdack       => arg_rdack,
        wrack       => arg_wrack,
        value       => arg_value,
        output      => arg_data
    );

    -- Instantiate the Result register as a read/write register
    resreg : entity hwti_common_v1_00_a.hwtireg
    generic map
    (
        REG_WIDTH   => 32,
        USE_HIGH    => true,
        C_AWIDTH    => C_AWIDTH,
        C_DWIDTH    => 32
    )
    port map
    (
        clk         => Bus2IP_Clk,
        rst         => Bus2IP_Reset,
        rd          => res_read,
        wr          => res_wr,
        data        => res_wdata,
        rdack       => res_rdack,
        wrack       => open,
        value       => res_value,
        output      => res_data
    );

    -- Instantiate the memory read/write state machine
    imemory : entity plb_hwti_v1_00_a.memory
    generic map
    (
        MEM_ADDR          => BUS_ADDR,
        C_AWIDTH          => C_AWIDTH,
        C_DWIDTH          => C_DWIDTH
    )
    port map
    (
        clk               => Bus2IP_Clk,
        rst               => Bus2IP_Reset,

        rd                => mem_rd,
        wr                => mem_wr,
        addr              => mem_addr,
        length            => mem_length,
        ack               => mem_ack,
        last              => mem_last,

        Bus2IP_MstError   => Bus2IP_MstError,
        Bus2IP_MstLastAck => Bus2IP_MstLastAck,
        Bus2IP_MstRdAck   => Bus2IP_MstRdAck,
        Bus2IP_MstWrAck   => Bus2IP_MstWrAck,
        Bus2IP_MstRetry   => Bus2IP_MstRetry,
        Bus2IP_MstTimeOut => Bus2IP_MstTimeOut,

        IP2Bus_Addr       => IP2Bus_Addr,
        IP2Bus_MstBE      => IP2Bus_MstBE,
        IP2Bus_MstBurst   => IP2Bus_MstBurst,
        IP2Bus_MstBusLock => IP2Bus_MstBusLock,
        IP2Bus_MstNum     => IP2Bus_MstNum,
        IP2Bus_MstRdReq   => IP2Bus_MstRdReq,
        IP2Bus_MstWrReq   => IP2Bus_MstWrReq,
        IP2IP_Addr        => IP2IP_Addr
    );

    -- Instantiate the command processing state machine
    icommand : entity hwti_common_v1_00_a.command
    generic map
    (
        MTX_BITS       => MTX_BITS,
        TID_BITS       => TID_BITS,
        CMD_BITS       => CMD_BITS,
        MTX_BASE       => MTX_BASE,
        CDV_BASE       => CDV_BASE,
        SCH_BASE       => SCH_BASE,
        MNG_BASE       => MNG_BASE,
        C_AWIDTH       => C_AWIDTH,
        C_DWIDTH       => C_DWIDTH
    )
    port map
    (
        clk            => Bus2IP_Clk,
        rst            => Bus2IP_Reset,

        tid            => tid_value,
        arg            => arg_value,
        opcode_read    => FSL_S_READ,
        opcode_data    => FSL_S_DATA,
        opcode_control => FSL_S_CONTROL,
        opcode_exists  => FSL_S_EXISTS,

        result_write   => FSL_M_WRITE,
        result_data    => FSL_M_DATA,
        result_control => FSL_M_CONTROL,
        result_full    => FSL_M_FULL,

        command        => Bus2IP_Data(C_DWIDTH-4 to C_DWIDTH-1),
        status         => sta_value,

        setsta         => sta_wr,
        outsta         => sta_wdata,
        setres         => res_wr,
        outres         => res_wdata,

        memrd          => bus_read,
        memwr          => bus_write,
        memrdack       => bus_rdack,
        memwrack       => bus_wrack,

        rd             => mem_rd,
        wr             => mem_wr,
        addr           => mem_addr,
        data           => mem_data,
        bytes          => mem_length,
        ack            => mem_ack,
        last           => mem_last,
        err            => '0',
        results        => Bus2IP_Data
    );
end behavioral;
