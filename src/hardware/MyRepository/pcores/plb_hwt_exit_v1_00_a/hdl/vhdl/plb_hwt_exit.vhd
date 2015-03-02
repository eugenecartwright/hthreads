library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library plb_hwti_v1_00_a;
library plb_hwt_exit_v1_00_a;
use plb_hwti_v1_00_a.all;

entity plb_hwt_exit is
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
end entity plb_hwt_exit;

architecture imp of plb_hwt_exit is
    signal HWTI2USER_READ    : std_logic;
    signal HWTI2USER_DATA    : std_logic_vector(0 to 63);
    signal HWTI2USER_CONTROL : std_logic;
    signal HWTI2USER_EXISTS  : std_logic;

    signal USER2HWTI_WRITE   : std_logic;
    signal USER2HWTI_DATA    : std_logic_vector(0 to 63);
    signal USER2HWTI_CONTROL : std_logic;
    signal USER2HWTI_FULL    : std_logic;

    signal U2HLOW_M_WRITE    : std_logic;
    signal U2HLOW_M_DATA     : std_logic_vector(0 to 31);
    signal U2HLOW_M_CONTROL  : std_logic;
    signal U2HLOW_M_FULL     : std_logic;

    signal U2HHIGH_M_WRITE   : std_logic;
    signal U2HHIGH_M_DATA    : std_logic_vector(0 to 31);
    signal U2HHIGH_M_CONTROL : std_logic;
    signal U2HHIGH_M_FULL    : std_logic;

    signal H2ULOW_S_READ     : std_logic;
    signal H2ULOW_S_DATA     : std_logic_vector(0 to 31);
    signal H2ULOW_S_CONTROL  : std_logic;
    signal H2ULOW_S_EXISTS   : std_logic;

    signal H2UHIGH_S_READ    : std_logic;
    signal H2UHIGH_S_DATA    : std_logic_vector(0 to 31);
    signal H2UHIGH_S_CONTROL : std_logic;
    signal H2UHIGH_S_EXISTS  : std_logic;
begin
    ihwti : entity plb_hwti_v1_00_a.plb_hwti
    generic map
    (
		C_MANAG_BASE        => C_MANAG_BASE,
		C_SCHED_BASE        => C_SCHED_BASE,
		C_MUTEX_BASE        => C_MUTEX_BASE,
		C_CONDV_BASE        => C_CONDV_BASE,

		C_BASEADDR          => C_BASEADDR,
		C_HIGHADDR          => C_HIGHADDR,
		C_PLB_AWIDTH        => C_PLB_AWIDTH,
		C_PLB_DWIDTH        => C_PLB_DWIDTH,
		C_PLB_NUM_MASTERS   => C_PLB_NUM_MASTERS,
		C_PLB_MID_WIDTH     => C_PLB_MID_WIDTH,
		C_FAMILY            => C_FAMILY
    )
    port map
    (
		U2HLOW_M_WRITE      => U2HLOW_M_WRITE,
		U2HLOW_M_DATA       => U2HLOW_M_DATA,
		U2HLOW_M_CONTROL    => U2HLOW_M_CONTROL,
		U2HLOW_M_FULL       => U2HLOW_M_FULL,

		U2HHIGH_M_WRITE     => U2HHIGH_M_WRITE,
		U2HHIGH_M_DATA      => U2HHIGH_M_DATA,
		U2HHIGH_M_CONTROL   => U2HHIGH_M_CONTROL,
		U2HHIGH_M_FULL      => U2HHIGH_M_FULL,

		H2ULOW_S_READ       => H2ULOW_S_READ,
		H2ULOW_S_DATA       => H2ULOW_S_DATA,
		H2ULOW_S_CONTROL    => H2ULOW_S_CONTROL,
		H2ULOW_S_EXISTS     => H2ULOW_S_EXISTS,

		H2UHIGH_S_READ      => H2UHIGH_S_READ,
		H2UHIGH_S_DATA      => H2UHIGH_S_DATA,
		H2UHIGH_S_CONTROL   => H2UHIGH_S_CONTROL,
		H2UHIGH_S_EXISTS    => H2UHIGH_S_EXISTS,

		PLB_Clk             => PLB_Clk,
		PLB_Rst             => PLB_Rst,
		Sl_addrAck          => Sl_addrAck,
		Sl_MBusy            => Sl_MBusy,
		Sl_MErr             => Sl_MErr,
		Sl_rdBTerm          => Sl_rdBTerm,
		Sl_rdComp           => Sl_rdComp,
		Sl_rdDAck           => Sl_rdDAck,
		Sl_rdDBus           => Sl_rdDBus,
		Sl_rdWdAddr         => Sl_rdWdAddr,
		Sl_rearbitrate      => Sl_rearbitrate,
		Sl_SSize            => Sl_SSize,
		Sl_wait             => Sl_wait,
		Sl_wrBTerm          => Sl_wrBTerm,
		Sl_wrComp           => Sl_wrComp,
		Sl_wrDAck           => Sl_wrDAck,
		PLB_abort           => PLB_abort,
		PLB_ABus            => PLB_ABus,
		PLB_BE              => PLB_BE,
		PLB_busLock         => PLB_busLock,
		PLB_compress        => PLB_compress,
		PLB_guarded         => PLB_guarded,
		PLB_lockErr         => PLB_lockErr,
		PLB_masterID        => PLB_masterID,
		PLB_MSize           => PLB_MSize,
		PLB_ordered         => PLB_ordered,
		PLB_PAValid         => PLB_PAValid,
		PLB_pendPri         => PLB_pendPri,
		PLB_pendReq         => PLB_pendReq,
		PLB_rdBurst         => PLB_rdBurst,
		PLB_rdPrim          => PLB_rdPrim,
		PLB_reqPri          => PLB_reqPri,
		PLB_RNW             => PLB_RNW,
		PLB_SAValid         => PLB_SAValid,
		PLB_size            => PLB_size,
		PLB_type            => PLB_type,
		PLB_wrBurst         => PLB_wrBurst,
		PLB_wrDBus          => PLB_wrDBus,
		PLB_wrPrim          => PLB_wrPrim,
		M_abort             => M_abort,
		M_ABus              => M_ABus,
		M_BE                => M_BE,
		M_busLock           => M_busLock,
		M_compress          => M_compress,
		M_guarded           => M_guarded,
		M_lockErr           => M_lockErr,
		M_MSize             => M_MSize,
		M_ordered           => M_ordered,
		M_priority          => M_priority,
		M_rdBurst           => M_rdBurst,
		M_request           => M_request,
		M_RNW               => M_RNW,
		M_size              => M_size,
		M_type              => M_type,
		M_wrBurst           => M_wrBurst,
		M_wrDBus            => M_wrDBus,
		PLB_MBusy           => PLB_MBusy,
		PLB_MErr            => PLB_MErr,
		PLB_MWrBTerm        => PLB_MWrBTerm,
		PLB_MWrDAck         => PLB_MWrDAck,
		PLB_MAddrAck        => PLB_MAddrAck,
		PLB_MRdBTerm        => PLB_MRdBTerm,
		PLB_MRdDAck         => PLB_MRdDAck,
		PLB_MRdDBus         => PLB_MRdDBus,
		PLB_MRdWdAddr       => PLB_MRdWdAddr,
		PLB_MRearbitrate    => PLB_MRearbitrate,
		PLB_MSSize          => PLB_MSSize
    );

    ihwt : entity plb_hwt_exit_v1_00_a.hwtexit
    port map
    (
		clk                 => PLB_Clk,
		rst                 => PLB_Rst,

        HWTI2USER_READ      => HWTI2USER_READ,
        HWTI2USER_DATA      => HWTI2USER_DATA,
        HWTI2USER_CONTROL   => HWTI2USER_CONTROL,
        HWTI2USER_EXISTS    => HWTI2USER_EXISTS,

        USER2HWTI_WRITE     => USER2HWTI_WRITE,
        USER2HWTI_DATA      => USER2HWTI_DATA,
        USER2HWTI_CONTROL   => USER2HWTI_CONTROL,
        USER2HWTI_FULL      => USER2HWTI_FULL
    );

    H2ULOW_S_READ       <= HWTI2USER_READ;
    H2UHIGH_S_READ      <= HWTI2USER_READ;
    HWTI2USER_DATA      <= H2UHIGH_S_DATA & H2ULOW_S_DATA;
    HWTI2USER_CONTROL   <= H2UHIGH_S_CONTROL or H2ULOW_S_CONTROL;
    HWTI2USER_EXISTS    <= H2UHIGH_S_EXISTS and H2ULOW_S_EXISTS;

    U2HLOW_M_WRITE      <= USER2HWTI_WRITE;
    U2HHIGH_M_WRITE     <= USER2HWTI_WRITE;
    U2HLOW_M_DATA       <= USER2HWTI_DATA(32 to 63);
    U2HHIGH_M_DATA      <= USER2HWTI_DATA(0 to 31);
    U2HLOW_M_CONTROL    <= USER2HWTI_CONTROL;
    U2HHIGH_M_CONTROL   <= USER2HWTI_CONTROL;
    USER2HWTI_FULL      <= U2HLOW_M_FULL or U2HHIGH_M_FULL;
end imp;
