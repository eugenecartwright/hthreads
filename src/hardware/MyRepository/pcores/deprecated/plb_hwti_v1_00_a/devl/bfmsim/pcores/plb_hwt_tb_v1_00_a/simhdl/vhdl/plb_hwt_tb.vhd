library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library hwti_common_v1_00_a;
use hwti_common_v1_00_a.common.all;

library plb_hwti_v1_00_a;
use plb_hwti_v1_00_a.all;

library fsl_v20_v2_10_a;
use fsl_v20_v2_10_a.all;

entity plb_hwt_tb is
  generic
  (
    -- Bus protocol parameters, do not add to or delete
    C_BASEADDR                     : std_logic_vector     := X"FFFFFFFF";
    C_HIGHADDR                     : std_logic_vector     := X"00000000";
    C_MANAG_BASEADDR               : std_logic_vector     := X"FFFFFFFF";
    C_SCHED_BASEADDR               : std_logic_vector     := X"FFFFFFFF";
    C_MUTEX_BASEADDR               : std_logic_vector     := X"FFFFFFFF";
    C_CONDV_BASEADDR               : std_logic_vector     := X"FFFFFFFF";
    C_PLB_AWIDTH                   : integer              := 32;
    C_PLB_DWIDTH                   : integer              := 64;
    C_PLB_NUM_MASTERS              : integer              := 8;
    C_PLB_MID_WIDTH                : integer              := 3;
    C_FAMILY                       : string               := "virtex2p"
  );
  port
  (
    -- PLB bus interface, do not add or delete
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
    PLB_MSSize          :  in std_logic_vector(0 to 1);

    -- BFM synchronization bus interface
    SYNCH_IN                       : in  std_logic_vector(0 to 31) := (others => '0');
    SYNCH_OUT                      : out std_logic_vector(0 to 31) := (others => '0')
  );

end entity plb_hwt_tb;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture testbench of plb_hwt_tb is
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

  ------------------------------------------
  -- FSL Link Signals To HWTI
  ------------------------------------------
  signal FSL_M_Data      : std_logic_vector(0 to 63);
  signal FSL_M_Control   : std_logic;
  signal FSL_M_Write     : std_logic;
  signal FSL_M_Full      : std_logic;
  signal FSL_S_Data      : std_logic_vector(0 to 63);
  signal FSL_S_Control   : std_logic;
  signal FSL_S_Read      : std_logic;
  signal FSL_S_Exists    : std_logic;

  ------------------------------------------
  -- Signals for the HWTUL
  ------------------------------------------
  signal tid              : std_logic_vector(0 to 7);
  signal arg              : std_logic_vector(0 to 31);
begin
  ------------------------------------------
  -- Instance of the PLB HWTI
  ------------------------------------------
  hwti : entity plb_hwti_v1_00_a.plb_hwti
    generic map
    (
      -- MAP USER GENERICS BELOW THIS LINE ---------------
      C_MANAG_BASE  => C_MANAG_BASEADDR,
      C_SCHED_BASE  => C_SCHED_BASEADDR,
      C_MUTEX_BASE  => C_MUTEX_BASEADDR,
      C_CONDV_BASE  => C_CONDV_BASEADDR,
      -- MAP USER GENERICS ABOVE THIS LINE ---------------

      C_BASEADDR        => C_BASEADDR,
      C_HIGHADDR        => C_HIGHADDR,
      C_PLB_AWIDTH      => C_PLB_AWIDTH,
      C_PLB_DWIDTH      => C_PLB_DWIDTH,
      C_PLB_NUM_MASTERS => C_PLB_NUM_MASTERS,
      C_PLB_MID_WIDTH   => C_PLB_MID_WIDTH,
      C_FAMILY          => C_FAMILY
    )
    port map
    (
      -- MAP USER PORTS BELOW THIS LINE ------------------
      H2ULOW_S_READ        => FSL_S_READ,
      H2ULOW_S_DATA        => FSL_S_DATA(32 to 63),
      H2ULOW_S_CONTROL     => FSL_S_CONTROL,
      H2ULOW_S_EXISTS      => FSL_S_EXISTS,

      H2UHIGH_S_READ       => FSL_S_READ,
      H2UHIGH_S_DATA       => FSL_S_DATA(0 to 31),
      H2UHIGH_S_CONTROL    => open,
      H2UHIGH_S_EXISTS     => open,

      U2HLOW_M_WRITE       => FSL_M_WRITE,
      U2HLOW_M_DATA        => FSL_M_DATA(32 to 63),
      U2HLOW_M_CONTROL     => FSL_M_CONTROL,
      U2HLOW_M_FULL        => FSL_M_FULL,

      U2HHIGH_M_WRITE      => FSL_M_WRITE,
      U2HHIGH_M_DATA       => FSL_M_DATA(0 to 31),
      U2HHIGH_M_CONTROL    => FSL_M_CONTROL,
      U2HHIGH_M_FULL       => open,
      -- MAP USER PORTS ABOVE THIS LINE ------------------

      PLB_Clk              => PLB_Clk,
      PLB_Rst              => PLB_Rst,
      Sl_addrAck           => Sl_addrAck,
      Sl_MBusy             => Sl_MBusy,
      Sl_MErr              => Sl_MErr,
      Sl_rdBTerm           => Sl_rdBTerm,
      Sl_rdComp            => Sl_rdComp,
      Sl_rdDAck            => Sl_rdDAck,
      Sl_rdDBus            => Sl_rdDBus,
      Sl_rdWdAddr          => Sl_rdWdAddr,
      Sl_rearbitrate       => Sl_rearbitrate,
      Sl_SSize             => Sl_SSize,
      Sl_wait              => Sl_wait,
      Sl_wrBTerm           => Sl_wrBTerm,
      Sl_wrComp            => Sl_wrComp,
      Sl_wrDAck            => Sl_wrDAck,
      PLB_abort            => PLB_abort,
      PLB_ABus             => PLB_ABus,
      PLB_BE               => PLB_BE,
      PLB_busLock          => PLB_busLock,
      PLB_compress         => PLB_compress,
      PLB_guarded          => PLB_guarded,
      PLB_lockErr          => PLB_lockErr,
      PLB_masterID         => PLB_masterID,
      PLB_MSize            => PLB_MSize,
      PLB_ordered          => PLB_ordered,
      PLB_PAValid          => PLB_PAValid,
      PLB_pendPri          => PLB_pendPri,
      PLB_pendReq          => PLB_pendReq,
      PLB_rdBurst          => PLB_rdBurst,
      PLB_rdPrim           => PLB_rdPrim,
      PLB_reqPri           => PLB_reqPri,
      PLB_RNW              => PLB_RNW,
      PLB_SAValid          => PLB_SAValid,
      PLB_size             => PLB_size,
      PLB_type             => PLB_type,
      PLB_wrBurst          => PLB_wrBurst,
      PLB_wrDBus           => PLB_wrDBus,
      PLB_wrPrim           => PLB_wrPrim,
      M_abort              => M_abort,
      M_ABus               => M_ABus,
      M_BE                 => M_BE,
      M_busLock            => M_busLock,
      M_compress           => M_compress,
      M_guarded            => M_guarded,
      M_lockErr            => M_lockErr,
      M_MSize              => M_MSize,
      M_ordered            => M_ordered,
      M_priority           => M_priority,
      M_rdBurst            => M_rdBurst,
      M_request            => M_request,
      M_RNW                => M_RNW,
      M_size               => M_size,
      M_type               => M_type,
      M_wrBurst            => M_wrBurst,
      M_wrDBus             => M_wrDBus,
      PLB_MBusy            => PLB_MBusy,
      PLB_MErr             => PLB_MErr,
      PLB_MWrBTerm         => PLB_MWrBTerm,
      PLB_MWrDAck          => PLB_MWrDAck,
      PLB_MAddrAck         => PLB_MAddrAck,
      PLB_MRdBTerm         => PLB_MRdBTerm,
      PLB_MRdDAck          => PLB_MRdDAck,
      PLB_MRdDBus          => PLB_MRdDBus,
      PLB_MRdWdAddr        => PLB_MRdWdAddr,
      PLB_MRearbitrate     => PLB_MRearbitrate,
      PLB_MSSize           => PLB_MSSize
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
    procedure reset is
    begin
        FSL_M_WRITE   <= '0';
        FSL_M_CONTROL <= '0';
        FSL_M_DATA    <= (others => '0');
        FSL_S_READ    <= '0';

        wait for 20 ns;
        wait until falling_edge(PLB_Rst);
        wait for 20 ns;
        assert FALSE report "*** Real simulation starts here ***" severity NOTE;
    end procedure;

    procedure dostart is
    begin
        wait until rising_edge(PLB_Clk);
        SYNCH_OUT(START) <= '1';
        wait until rising_edge(PLB_Clk);
        SYNCH_OUT(START) <= '0';
    end procedure;

    procedure dostop is
    begin
        wait until rising_edge(SYNCH_IN(STOP));
        wait for 1 us;
    end procedure;

    procedure dowake(signal tid : out std_logic_vector(0 to 7);
                     signal arg : out std_logic_vector(0 to 31)) is
    begin
        wait until rising_edge(PLB_Clk) and FSL_S_EXISTS='1';
        tid        <= FSL_S_DATA(24 to 31);
        arg        <= FSL_S_DATA(32 to 63);
        FSL_S_READ <= '1';
        wait until rising_edge(PLB_Clk);
        FSL_S_READ <= '0';
    end procedure;

    procedure dohwti(fsl : std_logic_vector(0 to 63)) is
    begin
        wait until rising_edge(PLB_Clk) and FSL_M_FULL='0';
        FSL_M_WRITE   <= '1';
        FSL_M_CONTROL <= '0';
        FSL_M_DATA    <= fsl;

        wait until rising_edge(PLB_Clk);
        FSL_M_WRITE   <= '0';
        FSL_M_CONTROL <= '0';
        FSL_M_DATA    <= (others => '0');
    end procedure;

    procedure waitres is
    begin
        wait until rising_edge(PLB_Clk) and FSL_S_EXISTS='1';
        FSL_S_READ <= '1';
        wait until rising_edge(PLB_Clk);
        FSL_S_READ <= '0';
    end procedure;

    procedure mtx_lock(mtx : in integer) is
    begin
        dohwti( hwti_mtx_lock(conv_std_logic_vector(mtx,6)) );
    end procedure;

    procedure mtx_unlock(mtx : in integer) is
    begin
        dohwti( hwti_mtx_unlock(conv_std_logic_vector(mtx,6)) );
    end procedure;

    procedure mtx_trylock(mtx : in integer) is
    begin
        dohwti( hwti_mtx_trylock(conv_std_logic_vector(mtx,6)) );
    end procedure;

    procedure mtx_owner(mtx : in integer) is
    begin
        dohwti( hwti_mtx_owner(conv_std_logic_vector(mtx,6)) );
    end procedure;

    procedure mtx_kind(mtx : in integer) is
    begin
        dohwti( hwti_mtx_kind(conv_std_logic_vector(mtx,6)) );
    end procedure;

    procedure mtx_count(mtx : in integer) is
    begin
        dohwti( hwti_mtx_count(conv_std_logic_vector(mtx,6)) );
    end procedure;

    procedure cdv_owner(cdv : in integer) is
    begin
        dohwti( hwti_cdv_owner(conv_std_logic_vector(cdv,6)) );
    end procedure;

    procedure cdv_wait(cdv : in integer) is
    begin
        dohwti( hwti_cdv_wait(conv_std_logic_vector(cdv,6)) );
    end procedure;

    procedure cdv_signal(cdv : in integer) is
    begin
        dohwti( hwti_cdv_signal(conv_std_logic_vector(cdv,6)) );
    end procedure;

    procedure cdv_broadcast(cdv : in integer) is
    begin
        dohwti( hwti_cdv_broadcast(conv_std_logic_vector(cdv,6)) );
    end procedure;

    procedure man_exit(res : in std_logic_vector(0 to 31)) is
    begin
        dohwti( hwti_thr_exit(res) );
    end procedure;

    procedure mem_read(addr : std_logic_vector(0 to 31);
                       byte : integer) is
    begin
        dohwti( hwti_mem_read(addr,conv_std_logic_vector(byte,24)) );
    end procedure;

    procedure mem_write(addr : std_logic_vector(0 to 31);
                        byte : integer) is
    begin
        dohwti( hwti_mem_write(addr,conv_std_logic_vector(byte,24)) );
    end procedure;

    procedure mem_fill( byte : integer ) is
    begin
        for i in 0 to (byte/8)-1 loop
            wait until rising_edge(PLB_Clk) and FSL_M_FULL='0';
            FSL_M_WRITE   <= '1';
            FSL_M_CONTROL <= '0';
            FSL_M_DATA    <= conv_std_logic_vector(2*i,32) &
                             conv_std_logic_vector(2*i+1,32);
        end loop;

        wait until rising_edge(PLB_Clk);
        FSL_M_WRITE   <= '0';
        FSL_M_CONTROL <= '0';
        FSL_M_DATA    <= (others => '0');
    end procedure;

    procedure mem_drain( byte : integer ) is
    begin
        for i in 0 to (byte/8)-1 loop
            FSL_S_READ <= '1';
            wait until rising_edge(PLB_Clk) and FSL_S_EXISTS='1';
        end loop;

        wait until rising_edge(PLB_Clk);
        FSL_S_READ <= '0';
    end procedure;
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

    ------------------------------------------
    -- Reset the System
    ------------------------------------------
    reset;

    ------------------------------------------
    -- Setup the memory values
    ------------------------------------------
    assert FALSE report "*** Memory Setup Starting ***" severity NOTE;
    dostart;
    dostop;
    assert FALSE report "*** Memory Setup Finished ***" severity NOTE;

    ------------------------------------------
    -- Setup the Hthreads System
    ------------------------------------------
    assert FALSE report "*** System Setup Starting ***" severity NOTE;
    dostart;
    dostop;
    assert FALSE report "*** System Setup Finished ***" severity NOTE;

    ------------------------------------------
    -- Setup the Hardware Thread
    ------------------------------------------
    assert FALSE report "*** HWT Setup Starting ***" severity NOTE;
    dostart;
    dostop;
    assert FALSE report "*** HWT Setup Finished ***" severity NOTE;

    ------------------------------------------
    -- Wait until we are woken up by the system
    ------------------------------------------
    dowake(tid,arg);

    ------------------------------------------
    -- Attempt to mutex operations
    ------------------------------------------
    assert FALSE report "*** Mutex Operations Starting ***" severity NOTE;
    mtx_lock(0); waitres;
    mtx_lock(1); waitres;
    mtx_lock(2); waitres;
    mtx_trylock(2); waitres;
    mtx_unlock(2); waitres;
    mtx_owner(0); waitres;
    mtx_kind(0); waitres;
    mtx_count(0); waitres;
    assert FALSE report "*** Mutex Operations Finished ***" severity NOTE;

    ------------------------------------------
    -- Attempt condition variable operations
    ------------------------------------------
    assert FALSE report "*** Condition Variables Starting ***" severity NOTE;
    cdv_wait(0); wait for 1 us; dostart; dostop; waitres;
    cdv_wait(1); wait for 1 us; dostart; dostop; waitres;
    cdv_signal(0); waitres;
    cdv_signal(1); waitres;
    cdv_broadcast(0); waitres;
    cdv_broadcast(1); waitres;
    assert FALSE report "*** Condition Variables Finished ***" severity NOTE;

    ------------------------------------------
    -- Attempt burst memory read and write
    ------------------------------------------
    mem_read(x"10000000", 256);  mem_drain(256);
    mem_write(x"20000000", 256); mem_fill(256);

    ------------------------------------------
    -- End the test
    ------------------------------------------
    man_exit(x"CAFEBABE");
    wait for 2000 ns;

    ------------------------------------------
    -- Setup the Hthreads System
    ------------------------------------------
    assert FALSE report "*** Starting Results Reading ***" severity NOTE;
    dostart;
    dostop;
    assert FALSE report "*** Finished Results Reading ***" severity NOTE;

    wait;
  end process TEST_PROCESS;

end architecture testbench;
