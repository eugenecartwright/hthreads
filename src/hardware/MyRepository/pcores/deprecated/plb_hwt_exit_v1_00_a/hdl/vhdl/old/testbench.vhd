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

library plb_v34_v1_02_a;
library opb_v20_v1_10_c;
library plb2opb_bridge_v1_01_a;

entity testbench is
end entity;

architecture behavioral of testbench is
    constant PLB_NUM_MASTERS : integer := 1;
    constant PLB_NUM_SLAVES  : integer := 1;
    constant PLB_AWIDTH      : integer := 32;
    constant PLB_DWIDTH      : integer := 64;
    constant OPB_NUM_MASTERS : integer := 1;
    constant OPB_NUM_SLAVES  : integer := 1;
    constant OPB_AWIDTH      : integer := 32;
    constant OPB_DWIDTH      : integer := 32;
    constant DCR_AWIDTH      : integer := 10;
    constant DCR_DWIDTH      : integer := 32;
    constant PLB_MID_WIDTH   : integer := 2;
    constant PLB_TAWIDTH     : integer := PLB_NUM_MASTERS*PLB_AWIDTH;
    constant PLB_TDWIDTH     : integer := PLB_NUM_MASTERS*PLB_DWIDTH;
    constant PLB_SAWIDTH     : integer := PLB_NUM_SLAVES*PLB_AWIDTH;
    constant PLB_SDWIDTH     : integer := PLB_NUM_SLAVES*PLB_DWIDTH;
    constant PLB_SLVMST      : integer := PLB_NUM_SLAVES*PLB_NUM_MASTERS;

    constant HWTI_SLV : integer := 0;
    constant HWTI_MST : integer := 0;

    -- Signals for the PLB bus
    signal PLB_SaddrAck      : std_logic;
    signal PLB2OPB_rearb     : std_logic_vector(0 to PLB_NUM_SLAVES-1);
    signal DCR_ABus          : std_logic_vector(0 to DCR_AWIDTH-1);
    signal DCR_DBus          : std_logic_vector(0 to DCR_DWIDTH-1);
    signal DCR_Read          : std_logic;
    signal DCR_Write         : std_logic;
    signal PLB_dcrAck        : std_logic;
    signal PLB_dcrDBus       : std_logic_vector(0 to DCR_DWIDTH-1);
    signal M_ABus            : std_logic_vector(0 to PLB_TAWIDTH-1);
    signal M_BE              : std_logic_vector(0 to PLB_TDWIDTH/8-1);
    signal M_RNW             : std_logic_vector(0 to PLB_NUM_MASTERS-1);
    signal M_abort           : std_logic_vector(0 to PLB_NUM_MASTERS-1);
    signal M_busLock         : std_logic_vector(0 to PLB_NUM_MASTERS-1);
    signal M_compress        : std_logic_vector(0 to PLB_NUM_MASTERS-1);
    signal M_guarded         : std_logic_vector(0 to PLB_NUM_MASTERS-1);
    signal M_lockErr         : std_logic_vector(0 to PLB_NUM_MASTERS-1);
    signal M_MSize           : std_logic_vector(0 to PLB_NUM_MASTERS*2-1);
    signal M_ordered         : std_logic_vector(0 to PLB_NUM_MASTERS-1);
    signal M_priority        : std_logic_vector(0 to PLB_NUM_MASTERS*2-1);
    signal M_rdBurst         : std_logic_vector(0 to PLB_NUM_MASTERS-1);
    signal M_request         : std_logic_vector(0 to PLB_NUM_MASTERS-1);
    signal M_size            : std_logic_vector(0 to PLB_NUM_MASTERS*4-1);
    signal M_type            : std_logic_vector(0 to PLB_NUM_MASTERS*3-1);
    signal M_wrBurst         : std_logic_vector(0 to PLB_NUM_MASTERS-1);
    signal M_wrDBus          : std_logic_vector(0 to PLB_TDWIDTH-1);
    signal PLB_ABus          : std_logic_vector(0 to PLB_AWIDTH-1);
    signal PLB_BE            : std_logic_vector(0 to PLB_DWIDTH/8-1);
    signal PLB_MAddrAck      : std_logic_vector(0 to PLB_NUM_MASTERS-1);
    signal PLB_MBusy         : std_logic_vector(0 to PLB_NUM_MASTERS-1);
    signal PLB_MErr          : std_logic_vector(0 to PLB_NUM_MASTERS-1);
    signal PLB_MRdBTerm      : std_logic_vector(0 to PLB_NUM_MASTERS-1);
    signal PLB_MRdDAck       : std_logic_vector(0 to PLB_NUM_MASTERS-1);
    signal PLB_MRdDBus       : std_logic_vector(0 to PLB_TDWIDTH-1);
    signal PLB_MRdWdAddr     : std_logic_vector(0 to PLB_NUM_MASTERS*4-1);
    signal PLB_MRearbitrate  : std_logic_vector(0 to PLB_NUM_MASTERS-1);
    signal PLB_MWrBTerm      : std_logic_vector(0 to PLB_NUM_MASTERS-1);
    signal PLB_MWrDAck       : std_logic_vector(0 to PLB_NUM_MASTERS-1);
    signal PLB_MSSize        : std_logic_vector(0 to PLB_NUM_MASTERS*2-1);
    signal PLB_PAValid       : std_logic;
    signal PLB_RNW           : std_logic;
    signal PLB_SAValid       : std_logic;
    signal PLB_abort         : std_logic;
    signal PLB_busLock       : std_logic;
    signal PLB_compress      : std_logic;
    signal PLB_guarded       : std_logic;
    signal PLB_lockErr       : std_logic;
    signal PLB_masterID      : std_logic_vector(0 to PLB_MID_WIDTH-1);
    signal PLB_MSize         : std_logic_vector(0 to 1);
    signal PLB_ordered       : std_logic;
    signal PLB_pendPri       : std_logic_vector(0 to 1);
    signal PLB_pendReq       : std_logic;
    signal PLB_rdBurst       : std_logic;
    signal PLB_rdPrim        : std_logic;
    signal PLB_reqPri        : std_logic_vector(0 to 1);
    signal PLB_size          : std_logic_vector(0 to 3);
    signal PLB_type          : std_logic_vector(0 to 2);
    signal PLB_wrBurst       : std_logic;
    signal PLB_wrDBus        : std_logic_vector(0 to PLB_DWIDTH-1);
    signal PLB_wrPrim        : std_logic;
    signal Sl_addrAck        : std_logic_vector(0 to PLB_NUM_SLAVES-1);
    signal Sl_MErr           : std_logic_vector(0 to PLB_SLVMST-1);
    signal Sl_MBusy          : std_logic_vector(0 to PLB_SLVMST-1);
    signal Sl_rdBTerm        : std_logic_vector(0 to PLB_NUM_SLAVES-1);
    signal Sl_rdComp         : std_logic_vector(0 to PLB_NUM_SLAVES-1);
    signal Sl_rdDAck         : std_logic_vector(0 to PLB_NUM_SLAVES-1);
    signal Sl_rdDBus         : std_logic_vector(0 to PLB_SDWIDTH-1);
    signal Sl_rdWdAddr       : std_logic_vector(0 to PLB_NUM_SLAVES*4-1);
    signal Sl_rearbitrate    : std_logic_vector(0 to PLB_NUM_SLAVES-1);
    signal Sl_SSize          : std_logic_vector(0 to PLB_NUM_SLAVES*2-1);
    signal Sl_wait           : std_logic_vector(0 to PLB_NUM_SLAVES-1);
    signal Sl_wrBTerm        : std_logic_vector(0 to PLB_NUM_SLAVES-1);
    signal Sl_wrComp         : std_logic_vector(0 to PLB_NUM_SLAVES-1);
    signal Sl_wrDAck         : std_logic_vector(0 to PLB_NUM_SLAVES-1);
    signal PLB_SMErr         : std_logic_vector(0 to PLB_NUM_MASTERS-1);
    signal PLB_SMBusy        : std_logic_vector(0 to PLB_NUM_MASTERS-1);
    signal PLB_SrdBTerm      : std_logic;
    signal PLB_SrdComp       : std_logic;
    signal PLB_SrdDAck       : std_logic;
    signal PLB_SrdDBus       : std_logic_vector(0 to PLB_DWIDTH-1);
    signal PLB_SrdWdAddr     : std_logic_vector(0 to 3);
    signal PLB_Srearbitrate  : std_logic;
    signal PLB_Sssize        : std_logic_vector(0 to 1);
    signal PLB_Swait         : std_logic;
    signal PLB_SwrBTerm      : std_logic;
    signal PLB_SwrComp       : std_logic;
    signal PLB_SwrDAck       : std_logic;
    signal ArbAddrVldReg     : std_logic;
    signal SYS_Rst           : std_logic;
    signal Bus_Error_Det     : std_logic;
    signal PLB_Rst           : std_logic;
    signal PLB_Clk           : std_logic;

    -- Signals for the OPB bus
    signal Debug_SYS_Rst   : std_logic;
    signal WDT_Rst         : std_logic;
    signal OPB_Clk         : std_logic;
    signal OPB_Rst         : std_logic;
    signal OM_ABus         : std_logic_vector(0 to OPB_AWIDTH*OPB_NUM_MASTERS-1);
    signal OM_BE           : std_logic_vector(0 to (OPB_DWIDTH+7)/8*OPB_NUM_MASTERS-1);
    signal OM_beXfer       : std_logic_vector(0 to OPB_NUM_MASTERS-1);
    signal OM_busLock      : std_logic_vector(0 to OPB_NUM_MASTERS-1);
    signal OM_DBus         : std_logic_vector(0 to OPB_DWIDTH*OPB_NUM_MASTERS-1);
    signal OM_DBusEn       : std_logic_vector(0 to OPB_NUM_MASTERS-1);
    signal OM_DBusEn32_63  : std_logic_vector(0 to OPB_NUM_MASTERS-1);
    signal OM_dwXfer       : std_logic_vector(0 to OPB_NUM_MASTERS-1);
    signal OM_fwXfer       : std_logic_vector(0 to OPB_NUM_MASTERS-1);
    signal OM_hwXfer       : std_logic_vector(0 to OPB_NUM_MASTERS-1);
    signal OM_request      : std_logic_vector(0 to OPB_NUM_MASTERS-1);
    signal OM_RNW          : std_logic_vector(0 to OPB_NUM_MASTERS-1);
    signal OM_select       : std_logic_vector(0 to OPB_NUM_MASTERS-1);
    signal OM_seqAddr      : std_logic_vector(0 to OPB_NUM_MASTERS-1);
    signal OSl_beAck       : std_logic_vector(0 to OPB_NUM_SLAVES-1);
    signal OSl_DBus        : std_logic_vector(0 to OPB_DWIDTH*OPB_NUM_SLAVES-1);
    signal OSl_DBusEn      : std_logic_vector(0 to OPB_NUM_SLAVES-1);
    signal OSl_DBusEn32_63 : std_logic_vector(0 to OPB_NUM_SLAVES-1);
    signal OSl_errAck      : std_logic_vector(0 to OPB_NUM_SLAVES-1);
    signal OSl_dwAck       : std_logic_vector(0 to OPB_NUM_SLAVES-1);
    signal OSl_fwAck       : std_logic_vector(0 to OPB_NUM_SLAVES-1);
    signal OSl_hwAck       : std_logic_vector(0 to OPB_NUM_SLAVES-1);
    signal OSl_retry       : std_logic_vector(0 to OPB_NUM_SLAVES-1);
    signal OSl_toutSup     : std_logic_vector(0 to OPB_NUM_SLAVES-1);
    signal OSl_xferAck     : std_logic_vector(0 to OPB_NUM_SLAVES-1);
    signal OPB_MRequest    : std_logic_vector(0 to OPB_NUM_MASTERS-1);
    signal OPB_ABus        : std_logic_vector(0 to OPB_AWIDTH-1);
    signal OPB_BE          : std_logic_vector(0 to (OPB_DWIDTH+7)/8-1);
    signal OPB_beXfer      : std_logic;
    signal OPB_beAck       : std_logic;
    signal OPB_busLock     : std_logic;
    signal OPB_rdDBus      : std_logic_vector(0 to OPB_DWIDTH-1);
    signal OPB_wrDBus      : std_logic_vector(0 to OPB_DWIDTH-1);
    signal OPB_DBus        : std_logic_vector(0 to OPB_DWIDTH-1);
    signal OPB_errAck      : std_logic;
    signal OPB_dwAck       : std_logic;
    signal OPB_dwXfer      : std_logic;
    signal OPB_fwAck       : std_logic;
    signal OPB_fwXfer      : std_logic;
    signal OPB_hwAck       : std_logic;
    signal OPB_hwXfer      : std_logic;
    signal OPB_MGrant      : std_logic_vector(0 to OPB_NUM_MASTERS-1);
    signal OPB_pendReq     : std_logic_vector(0 to OPB_NUM_MASTERS-1);
    signal OPB_retry       : std_logic;
    signal OPB_RNW         : std_logic;
    signal OPB_select      : std_logic;
    signal OPB_seqAddr     : std_logic;
    signal OPB_timeout     : std_logic;
    signal OPB_toutSup     : std_logic;
    signal OPB_xferAck     : std_logic;

    -- Signals for the PLB2OPB bridge
    PLB_Rst         : std_logic;         -- unused input
    PLB_Clk         : std_logic;
    OPB_Rst         : std_logic;
    OPB_Clk         : std_logic;
    Bus_Error_Det   : std_logic;
    BGI_Trans_Abort : std_logic;
    PLB_abort       : std_logic;
    PLB_ABus        : std_logic_vector (0 to C_PLB_AWIDTH-1);
    PLB_BE          : std_logic_vector (0 to C_PLB_DWIDTH/8-1);
    PLB_busLock     : std_logic;
    PLB_compress    : std_logic;
    PLB_guarded     : std_logic;
    PLB_lockErr     : std_logic;
    PLB_masterID    : std_logic_vector (0 to C_PLB_MID_WIDTH-1);
    PLB_MSize       : std_logic_vector (0 to 1);
    PLB_ordered     : std_logic;
    PLB_PAValid     : std_logic;
    PLB_RNW         : std_logic;
    PLB_size        : std_logic_vector (0 to 3);
    PLB_type        : std_logic_vector (0 to 2);
    BGO_addrAck     : std_logic;
    BGO_MBusy       : std_logic_vector (0 to C_PLB_NUM_MASTERS-1);
    BGO_MErr        : std_logic_vector (0 to C_PLB_NUM_MASTERS-1);
    BGO_rearbitrate : std_logic;
    BGO_SSize       : std_logic_vector (0 to 1);
    BGO_wait        : std_logic;
    PLB_rdPrim      : std_logic;
    PLB_SAValid     : std_logic;
    PLB_wrPrim      : std_logic;
    PLB_wrBurst     : std_logic;
    PLB_wrDBus      : std_logic_vector (0 to C_PLB_DWIDTH-1);
    BGO_wrBTerm     : std_logic;
    BGO_wrComp      : std_logic;
    BGO_wrDAck      : std_logic;
    PLB_rdBurst     : std_logic;
    BGO_rdBTerm     : std_logic;
    BGO_rdComp      : std_logic;
    BGO_rdDAck      : std_logic;
    BGO_rdDBus      : std_logic_vector (0 to C_PLB_DWIDTH-1);
    BGO_rdWdAddr    : std_logic_vector (0 to 3) ;
    OPB_DBus        : std_logic_vector (0 to C_OPB_DWIDTH-1);
    OPB_errAck      : std_logic;
    OPB_MnGrant     : std_logic;
    OPB_retry       : std_logic;
    OPB_timeout     : std_logic;
    OPB_xferAck     : std_logic;
    BGO_ABus        : std_logic_vector (0 to C_OPB_AWIDTH-1);
    BGO_BE          : std_logic_vector (0 to C_OPB_DWIDTH/8-1) ;
    BGO_busLock     : std_logic;
    BGO_DBus        : std_logic_vector (0 to C_OPB_DWIDTH-1);
    BGO_request     : std_logic;
    BGO_RNW         : std_logic;
    BGO_select      : std_logic;
    BGO_seqAddr     : std_logic;
    DCR_ABus        : std_logic_vector (0 to C_DCR_AWIDTH-1);
    DCR_DBus        : std_logic_vector (0 to C_DCR_DWIDTH-1);
    DCR_Read        : std_logic;
    DCR_Write       : std_logic;
    BGO_dcrAck      : std_logic;
    BGO_dcrDBus     : std_logic_vector (0 to C_DCR_DWIDTH-1);
    PLB2OPB_rearb   : std_logic

    -- Signals for the HWTI
    signal tid               : std_logic_vector(0 to 7);
    signal arg               : std_logic_vector(0 to 31);
    signal opgo              : std_logic;
    signal opcode            : std_logic_vector(0 to 7);
    signal oparg             : std_logic_vector(0 to 31);
    signal opack             : std_logic;
    signal operr             : std_logic;
    signal opres             : std_logic_vector(0 to 31);
begin
    ihwti : entity plb_hwti_v1_00_a.plb_hwti
    generic map
    (
        C_MANAG_BASEADDR  => x"00000000",
        C_SCHED_BASEADDR  => x"00000000",
        C_MUTEX_BASEADDR  => x"00000000",
        C_CONDV_BASEADDR  => x"00000000",
        C_BASEADDR        => X"FFFFFFFF",
        C_HIGHADDR        => X"00000000",
        C_PLB_AWIDTH      => PLB_AWIDTH,
        C_PLB_DWIDTH      => PLB_DWIDTH,
        C_PLB_NUM_MASTERS => PLB_NUM_MASTERS,
        C_PLB_MID_WIDTH   => PLB_MID_WIDTH
    )
    port map
    (
        tid               => tid,
        arg               => arg,
        opgo              => opgo,
        opcode            => opcode,
        oparg             => oparg,
        opack             => opack,
        operr             => operr,
        opres             => opres,
        PLB_Clk           => PLB_Clk,
        PLB_Rst           => PLB_Rst,
        Sl_addrAck        => Sl_addrAck(0),
        Sl_MBusy          => Sl_MBusy(0*PLB_NUM_MASTERS to 1*PLB_NUM_MASTERS-1),
        Sl_MErr           => Sl_MErr(0*PLB_NUM_MASTERS to 1*PLB_NUM_MASTERS-1),
        Sl_rdBTerm        => Sl_rdBTerm(0),
        Sl_rdComp         => Sl_rdComp(0),
        Sl_rdDAck         => Sl_rdDAck(0),
        Sl_rdDBus         => Sl_rdDBus(0*PLB_DWIDTH to 1*PLB_DWIDTH-1),
        Sl_rdWdAddr       => Sl_rdWdAddr(0*4 to 1*4-1),
        Sl_rearbitrate    => Sl_rearbitrate(0),
        Sl_SSize          => Sl_SSize(0*2 to 1*2-1),
        Sl_wait           => Sl_wait(0),
        Sl_wrBTerm        => Sl_wrBTerm(0),
        Sl_wrComp         => Sl_wrComp(0),
        Sl_wrDAck         => SL_wrDAck(0),
        PLB_abort         => PLB_abort,
        PLB_ABus          => PLB_ABus,
        PLB_BE            => PLB_BE,
        PLB_busLock       => PLB_busLock,
        PLB_compress      => PLB_compress,
        PLB_guarded       => PLB_guarded,
        PLB_lockErr       => PLB_lockErr,
        PLB_masterID      => PLB_masterID,
        PLB_MSize         => PLB_MSize,
        PLB_ordered       => PLB_ordered,
        PLB_PAValid       => PLB_PAValid,
        PLB_pendPri       => PLB_pendPri,
        PLB_pendReq       => PLB_pendReq,
        PLB_rdBurst       => PLB_rdBurst,
        PLB_rdPrim        => PLB_rdPrim,
        PLB_reqPri        => PLB_reqPri,
        PLB_RNW           => PLB_RNW,
        PLB_SAValid       => PLB_SAValid,
        PLB_size          => PLB_size,
        PLB_type          => PLB_type,
        PLB_wrBurst       => PLB_wrBurst,
        PLB_wrDBus        => PLB_wrDBus,
        PLB_wrPrim        => PLB_wrPrim,
        M_abort           => M_abort(0),
        M_ABus            => M_ABus(0*PLB_AWIDTH to 1*PLB_AWIDTH-1),
        M_BE              => M_BE(0*(PLB_DWIDTH/8) to 1*(PLB_DWIDTH/8)-1),
        M_busLock         => M_busLock(0),
        M_compress        => M_compress(0),
        M_guarded         => M_guarded(0),
        M_lockErr         => M_lockErr(0),
        M_MSize           => M_MSize(0*2 to 1*2-1),
        M_ordered         => M_ordered(0),
        M_priority        => M_priority(0*2 to 1*2-1),
        M_rdBurst         => M_rdBurst(0),
        M_request         => M_request(0),
        M_RNW             => M_RNW(0),
        M_size            => M_size(0*4 to 1*4-1),
        M_type            => M_type(0*3 to 1*3-1),
        M_wrBurst         => M_wrBurst(0),
        M_wrDBus          => M_wrDBus(0*PLB_DWIDTH to 1*PLB_DWIDTH-1),
        PLB_MBusy         => PLB_MBusy(0),
        PLB_MErr          => PLB_MErr(0),
        PLB_MWrBTerm      => PLB_MWrBTerm(0),
        PLB_MWrDAck       => PLB_MWrDAck(0),
        PLB_MAddrAck      => PLB_MAddrAck(0),
        PLB_MRdBTerm      => PLB_MRdBTerm(0),
        PLB_MRdDAck       => PLB_MRdDAck(0),
        PLB_MRdDBus       => PLB_MRdDBus(0*PLB_DWIDTH to 1*PLB_DWIDTH-1),
        PLB_MRdWdAddr     => PLB_MRdWdAddr(0*4 to 1*4-1),
        PLB_MRearbitrate  => PLB_MRearbitrate(0),
        PLB_MSSize        => PLB_MSSize(0*2 to 1*2-1)
    );

    iplb : entity plb_v34_v1_02_a.plb_v34
    generic map
    (
        C_PLB_NUM_MASTERS  => PLB_NUM_MASTERS,
        C_PLB_NUM_SLAVES   => PLB_NUM_SLAVES,
        C_PLB_MID_WIDTH    => PLB_MID_WIDTH,
        C_PLB_AWIDTH       => PLB_AWIDTH,
        C_PLB_DWIDTH       => PLB_DWIDTH,
        C_DCR_INTFCE       => 0,
        C_BASEADDR         => "1111111111",
        C_HIGHADDR         => "0000000000",
        C_DCR_AWIDTH       => DCR_AWIDTH,
        C_DCR_DWIDTH       => DCR_DWIDTH,
        C_EXT_RESET_HIGH   => 1,
        C_IRQ_ACTIVE       => '1',
        C_NUM_OPBCLK_PLB2OPB_REARB => 25
    )
    port map
    (
        DCR_ABus           => DCR_ABus,
        DCR_DBus           => DCR_DBus,
        DCR_Read           => DCR_Read,
        DCR_Write          => DCR_Write,
        PLB_dcrAck         => PLB_dcrAck,
        PLB_dcrDBus        => PLB_dcrDBus,
        M_ABus             => M_ABus,
        M_BE               => M_BE,
        M_RNW              => M_RNW,
        M_abort            => M_abort,
        M_busLock          => M_busLock,
        M_compress         => M_compress,
        M_guarded          => M_guarded,
        M_lockErr          => M_lockErr,
        M_MSize            => M_MSize,
        M_ordered          => M_ordered,
        M_priority         => M_priority,
        M_rdBurst          => M_rdBurst,
        M_request          => M_request,
        M_size             => M_size,
        M_type             => M_type,
        M_wrBurst          => M_wrBurst,
        M_wrDBus           => M_wrDBus,
        PLB_ABus           => PLB_ABus,
        PLB_BE             => PLB_BE,
        PLB_MAddrAck       => PLB_MAddrAck,
        PLB_MBusy          => PLB_MBusy,
        PLB_MErr           => PLB_MErr,
        PLB_MRdBTerm       => PLB_MRdBTerm,
        PLB_MRdDAck        => PLB_MRdDAck,
        PLB_MRdDBus        => PLB_MRdDBus,
        PLB_MRdWdAddr      => PLB_MRdWdAddr,
        PLB_MRearbitrate   => PLB_MRearbitrate,
        PLB_MWrBTerm       => PLB_MWrBTerm,
        PLB_MWrDAck        => PLB_MWrDAck,
        PLB_MSSize         => PLB_MSSize,
        PLB_PAValid        => PLB_PAValid,
        PLB_RNW            => PLB_RNW,
        PLB_SAValid        => PLB_SAValid,
        PLB_abort          => PLB_abort,
        PLB_busLock        => PLB_busLock,
        PLB_compress       => PLB_compress,
        PLB_guarded        => PLB_guarded,
        PLB_lockErr        => PLB_lockErr,
        PLB_masterID       => PLB_masterID,
        PLB_MSize          => PLB_MSize,
        PLB_ordered        => PLB_ordered,
        PLB_pendPri        => PLB_pendPri,
        PLB_pendReq        => PLB_pendReq,
        PLB_rdBurst        => PLB_rdBurst,
        PLB_rdPrim         => PLB_rdPrim,
        PLB_reqPri         => PLB_reqPri,
        PLB_size           => PLB_size,
        PLB_type           => PLB_type,
        PLB_wrBurst        => PLB_wrBurst,
        PLB_wrDBus         => PLB_wrDBus,
        PLB_wrPrim         => PLB_wrPrim,
        Sl_addrAck         => Sl_addrAck,
        Sl_MErr            => Sl_MErr,
        Sl_MBusy           => Sl_MBusy,
        Sl_rdBTerm         => Sl_rdBTerm,
        Sl_rdComp          => Sl_rdComp,
        Sl_rdDAck          => Sl_rdDAck,
        Sl_rdDBus          => Sl_rdDBus,
        Sl_rdWdAddr        => Sl_rdWdAddr,
        Sl_rearbitrate     => Sl_rearbitrate,
        Sl_SSize           => Sl_SSize,
        Sl_wait            => Sl_wait,
        Sl_wrBTerm         => Sl_wrBTerm,
        Sl_wrComp          => Sl_wrComp,
        Sl_wrDAck          => Sl_wrDAck,
        PLB_SaddrAck       => PLB_SaddrAck,
        PLB_SMErr          => PLB_SMErr,   
        PLB_SMBusy         => PLB_SMBusy,   
        PLB_SrdBTerm       => PLB_SrdBTerm,   
        PLB_SrdComp        => PLB_SrdComp,
        PLB_SrdDAck        => PLB_SrdDAck,
        PLB_SrdDBus        => PLB_SrdDBus,   
        PLB_SrdWdAddr      => PLB_SrdWdAddr,
        PLB_Srearbitrate   => PLB_Srearbitrate,
        PLB_Sssize         => PLB_Sssize,
        PLB_Swait          => PLB_Swait,
        PLB_SwrBTerm       => PLB_SwrBTerm,
        PLB_SwrComp        => PLB_SwrComp,
        PLB_SwrDAck        => PLB_SwrDAck,
        PLB2OPB_rearb      => PLB2OPB_rearb,
        ArbAddrVldReg      => ArbAddrVldReg,
        SYS_Rst            => SYS_Rst,
        Bus_Error_Det      => Bus_Error_Det,
        PLB_Rst            => PLB_Rst,
        PLB_Clk            => PLB_Clk
    );

    iopb : entity opb_v20_v1_10_c.opb_v20
    generic map
    (
        C_OPB_AWIDTH       => OPB_AWIDTH,
        C_OPB_DWIDTH       => OPB_DWIDTH,
        C_NUM_MASTERS      => OPB_NUM_MASTERS,
        C_NUM_SLAVES       => OPB_NUM_SLAVES,
        C_USE_LUT_OR       => 0,
        C_EXT_RESET_HIGH   => 1,
        C_BASEADDR         => x"10000000",
        C_HIGHADDR         => x"100001FF",
        C_DYNAM_PRIORITY   => 1,
        C_PARK             => 1,
        C_PROC_INTRFCE     => 1,
        C_REG_GRANTS       => 1,
        C_DEV_BLK_ID       => 0,
        C_DEV_MIR_ENABLE   => 0
    )
    port map
    (
        SYS_Rst          => SYS_Rst,
        Debug_SYS_Rst    => Debug_SYS_Rst,
        WDT_Rst          => WDT_Rst,
        OPB_Clk          => OPB_Clk,
        OPB_Rst          => OPB_Rst,
        M_ABus           => OM_ABus,
        M_BE             => OM_BE,
        M_beXfer         => OM_beXfer,
        M_busLock        => OM_busLock,
        M_DBus           => OM_DBus,
        M_DBusEn         => OM_DBusEn,
        M_DBusEn32_63    => OM_DBusEn32_63,
        M_dwXfer         => OM_dwXfer,
        M_fwXfer         => OM_fwXfer,
        M_hwXfer         => OM_hwXfer,
        M_request        => OM_request,
        M_RNW            => OM_RNW,
        M_select         => OM_select,
        M_seqAddr        => OM_seqAddr,
        Sl_beAck         => OSl_beAck,
        Sl_DBus          => OSl_DBus,
        Sl_DBusEn        => OSl_DBusEn,
        Sl_DBusEn32_63   => OSl_DBusEn32_63,
        Sl_errAck        => OSl_errAck,
        Sl_dwAck         => OSl_dwAck,
        Sl_fwAck         => OSl_fwAck,
        Sl_hwAck         => OSl_hwAck,
        Sl_retry         => OSl_retry,
        Sl_toutSup       => OSl_toutSup,
        Sl_xferAck       => OSl_xferAck,
        OPB_MRequest     => OPB_MRequest,
        OPB_ABus         => OPB_ABus,
        OPB_BE           => OPB_BE,
        OPB_beXfer       => OPB_beXfer,
        OPB_beAck        => OPB_beAck,
        OPB_busLock      => OPB_busLock,
        OPB_rdDBus       => OPB_rdDBus,
        OPB_wrDBus       => OPB_wrDBus,
        OPB_DBus         => OPB_DBus,
        OPB_errAck       => OPB_errAck,
        OPB_dwAck        => OPB_dwAck,
        OPB_dwXfer       => OPB_dwXfer,
        OPB_fwAck        => OPB_fwAck,
        OPB_fwXfer       => OPB_fwXfer,
        OPB_hwAck        => OPB_hwAck,
        OPB_hwXfer       => OPB_hwXfer,
        OPB_MGrant       => OPB_MGrant,
        OPB_pendReq      => OPB_pendReq,
        OPB_retry        => OPB_retry,
        OPB_RNW          => OPB_RNW,
        OPB_select       => OPB_select,
        OPB_seqAddr      => OPB_seqAddr,
        OPB_timeout      => OPB_timeout,
        OPB_toutSup      => OPB_toutSup,
        OPB_xferAck      => OPB_xferAck
    );

    iplb2opb : entity plb2opb_bridge_v1_01_a.plb2opb_bridge
    generic map
    (
        C_NO_PLB_BURST      => 0,
        C_DCR_INTFCE        => 0,
        C_NUM_ADDR_RNG      => 1,
        C_RNG0_BASEADDR     => x"00000000";
        C_RNG0_HIGHADDR     => x"0003FFFF";
        C_RNG1_BASEADDR     => x"00000000";
        C_RNG1_HIGHADDR     => x"00000000";
        C_RNG2_BASEADDR     => x"00000000";
        C_RNG2_HIGHADDR     => x"00000000";
        C_RNG3_BASEADDR     => x"00000000";
        C_RNG3_HIGHADDR     => x"00000000";
        C_PLB_AWIDTH        => PLB_AWIDTH,
        C_PLB_DWIDTH        => PLB_DWIDTH,
        C_PLB_NUM_MASTERS   => PLB_NUM_MASTERS,
        C_PLB_MID_WIDTH     => PLB_MID_WIDTH,
        C_OPB_AWIDTH        => OPB_AWIDTH,
        C_OPB_DWIDTH        => OPB_DWIDTH,
        C_DCR_BASEADDR      => "0000000000",
        C_DCR_HIGHADDR      => "0000000111",
        C_DCR_AWIDTH        => DCR_AWIDTH,
        C_DCR_DWIDTH        => DCR_DWIDTH
    )
    port map
    (
        PLB_Rst          => PLB_Rst,
        PLB_Clk          => PLB_Clk,
        OPB_Rst          => OPB_Rst,
        OPB_Clk          => OPB_Clk,
        Bus_Error_Det    => Bus_Error_Det,
        BGI_Trans_Abort  => BGI_Trans_Abort,
        PLB_abort        => PLB_abort,
        PLB_ABus         => PLB_ABus,
        PLB_BE           => PLB_BE,
        PLB_busLock      => PLB_busLock,
        PLB_compress     => PLB_compress,
        PLB_guarded      => PLB_guarded,
        PLB_lockErr      => PLB_lockErr,
        PLB_masterID     => PLB_masterID,
        PLB_MSize        => PLB_MSize,
        PLB_ordered      => PLB_ordered,
        PLB_PAValid      => PLB_PAValid,
        PLB_RNW          => PLB_RNW,
        PLB_size         => PLB_size,
        PLB_type         => PLB_type,
        BGO_addrAck      => BGO_addrAck,
        BGO_MBusy        => BGO_MBusy,
        BGO_MErr         => BGO_MErr,
        BGO_rearbitrate  => BGO_rearbitrate,
        BGO_SSize        => BGO_SSize,
        BGO_wait         => BGO_wait,
        PLB_rdPrim       => PLB_rdPrim,
        PLB_SAValid      => PLB_SAValid,
        PLB_wrPrim       => PLB_wrPrim,
        PLB_wrBurst      => PLB_wrBurst,
        PLB_wrDBus       => PLB_wrDBus,
        BGO_wrBTerm      => BGO_wrBTerm,
        BGO_wrComp       => BGO_wrComp,
        BGO_wrDAck       => BGO_wrDAck,
        PLB_rdBurst      => PLB_rdBurst,
        BGO_rdBTerm      => BGO_rdBTerm,
        BGO_rdComp       => BGO_rdComp,
        BGO_rdDAck       => BGO_rdDAck,
        BGO_rdDBus       => BGO_rdDBus,
        BGO_rdWdAddr     => BGO_rdWdAddr,
        OPB_DBus         => OPB_DBus,
        OPB_errAck       => OPB_errAck,
        OPB_MnGrant      => OPB_MnGrant,
        OPB_retry        => OPB_retry,
        OPB_timeout      => OPB_timeout,
        OPB_xferAck      => OPB_xferAck,
        BGO_ABus         => BGO_ABus,
        BGO_BE           => BGO_BE,
        BGO_busLock      => BGO_busLock,
        BGO_DBus         => BGO_DBus,
        BGO_request      => BGO_request,
        BGO_RNW          => BGO_RNW,
        BGO_select       => BGO_select,
        BGO_seqAddr      => BGO_seqAddr,
        DCR_ABus         => DCR_ABus,
        DCR_DBus         => DCR_DBus,
        DCR_Read         => DCR_Read,
        DCR_Write        => DCR_Write,
        BGO_dcrAck       => BGO_dcrAck,
        BGO_dcrDBus      => BGO_dcrDBus,
        PLB2OPB_rearb    => PLB2OPB_rearb
    );
end behavioral;
