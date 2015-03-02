-------------------------------------------------------------------------------
-- system.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity system is
  port (
    fpga_0_RS232_Uart_1_RX_pin : in std_logic;
    fpga_0_RS232_Uart_1_TX_pin : out std_logic;
    fpga_0_LEDs_8Bit_GPIO_IO_pin : inout std_logic_vector(0 to 7);
    fpga_0_SRAM_Mem_A_pin : out std_logic_vector(7 to 30);
    fpga_0_SRAM_Mem_DQ_pin : inout std_logic_vector(0 to 31);
    fpga_0_SRAM_Mem_BEN_pin : out std_logic_vector(0 to 3);
    fpga_0_SRAM_Mem_OEN_pin : out std_logic;
    fpga_0_SRAM_Mem_CEN_pin : out std_logic;
    fpga_0_SRAM_Mem_ADV_LDN_pin : out std_logic;
    fpga_0_SRAM_Mem_WEN_pin : out std_logic;
    fpga_0_DDR2_SDRAM_DDR2_ODT_pin : out std_logic_vector(1 downto 0);
    fpga_0_DDR2_SDRAM_DDR2_Addr_pin : out std_logic_vector(12 downto 0);
    fpga_0_DDR2_SDRAM_DDR2_BankAddr_pin : out std_logic_vector(1 downto 0);
    fpga_0_DDR2_SDRAM_DDR2_CAS_n_pin : out std_logic;
    fpga_0_DDR2_SDRAM_DDR2_CE_pin : out std_logic_vector(0 to 0);
    fpga_0_DDR2_SDRAM_DDR2_CS_n_pin : out std_logic_vector(0 to 0);
    fpga_0_DDR2_SDRAM_DDR2_RAS_n_pin : out std_logic;
    fpga_0_DDR2_SDRAM_DDR2_WE_n_pin : out std_logic;
    fpga_0_DDR2_SDRAM_DDR2_Clk_pin : out std_logic_vector(1 downto 0);
    fpga_0_DDR2_SDRAM_DDR2_Clk_n_pin : out std_logic_vector(1 downto 0);
    fpga_0_DDR2_SDRAM_DDR2_DM_pin : out std_logic_vector(7 downto 0);
    fpga_0_DDR2_SDRAM_DDR2_DQS : inout std_logic_vector(7 downto 0);
    fpga_0_DDR2_SDRAM_DDR2_DQS_n : inout std_logic_vector(7 downto 0);
    fpga_0_DDR2_SDRAM_DDR2_DQ : inout std_logic_vector(63 downto 0);
    fpga_0_SRAM_CLK : out std_logic;
    fpga_0_SRAM_CLK_FB : in std_logic;
    sys_clk_pin : in std_logic;
    sys_rst_pin : in std_logic
  );
end system;

architecture STRUCTURE of system is

  component ppc440_0_wrapper is
    port (
      CPMC440CLK : in std_logic;
      CPMC440CLKEN : in std_logic;
      CPMINTERCONNECTCLK : in std_logic;
      CPMINTERCONNECTCLKEN : in std_logic;
      CPMINTERCONNECTCLKNTO1 : in std_logic;
      CPMC440CORECLOCKINACTIVE : in std_logic;
      CPMC440TIMERCLOCK : in std_logic;
      C440MACHINECHECK : out std_logic;
      C440CPMCORESLEEPREQ : out std_logic;
      C440CPMDECIRPTREQ : out std_logic;
      C440CPMFITIRPTREQ : out std_logic;
      C440CPMMSRCE : out std_logic;
      C440CPMMSREE : out std_logic;
      C440CPMTIMERRESETREQ : out std_logic;
      C440CPMWDIRPTREQ : out std_logic;
      PPCCPMINTERCONNECTBUSY : out std_logic;
      DBGC440DEBUGHALT : in std_logic;
      DBGC440DEBUGHALTNEG : in std_logic;
      DBGC440SYSTEMSTATUS : in std_logic_vector(0 to 4);
      DBGC440UNCONDDEBUGEVENT : in std_logic;
      C440DBGSYSTEMCONTROL : out std_logic_vector(0 to 7);
      SPLB0_Error : out std_logic_vector(0 to 3);
      SPLB1_Error : out std_logic_vector(0 to 3);
      EICC440CRITIRQ : in std_logic;
      EICC440EXTIRQ : in std_logic;
      PPCEICINTERCONNECTIRQ : out std_logic;
      CPMDCRCLK : in std_logic;
      DCRPPCDMACK : in std_logic;
      DCRPPCDMDBUSIN : in std_logic_vector(0 to 31);
      DCRPPCDMTIMEOUTWAIT : in std_logic;
      PPCDMDCRREAD : out std_logic;
      PPCDMDCRWRITE : out std_logic;
      PPCDMDCRABUS : out std_logic_vector(0 to 9);
      PPCDMDCRDBUSOUT : out std_logic_vector(0 to 31);
      DCRPPCDSREAD : in std_logic;
      DCRPPCDSWRITE : in std_logic;
      DCRPPCDSABUS : in std_logic_vector(0 to 9);
      DCRPPCDSDBUSOUT : in std_logic_vector(0 to 31);
      PPCDSDCRACK : out std_logic;
      PPCDSDCRDBUSIN : out std_logic_vector(0 to 31);
      PPCDSDCRTIMEOUTWAIT : out std_logic;
      CPMFCMCLK : in std_logic;
      FCMAPUCR : in std_logic_vector(0 to 3);
      FCMAPUDONE : in std_logic;
      FCMAPUEXCEPTION : in std_logic;
      FCMAPUFPSCRFEX : in std_logic;
      FCMAPURESULT : in std_logic_vector(0 to 31);
      FCMAPURESULTVALID : in std_logic;
      FCMAPUSLEEPNOTREADY : in std_logic;
      FCMAPUCONFIRMINSTR : in std_logic;
      FCMAPUSTOREDATA : in std_logic_vector(0 to 127);
      APUFCMDECNONAUTON : out std_logic;
      APUFCMDECFPUOP : out std_logic;
      APUFCMDECLDSTXFERSIZE : out std_logic_vector(0 to 2);
      APUFCMDECLOAD : out std_logic;
      APUFCMNEXTINSTRREADY : out std_logic;
      APUFCMDECSTORE : out std_logic;
      APUFCMDECUDI : out std_logic_vector(0 to 3);
      APUFCMDECUDIVALID : out std_logic;
      APUFCMENDIAN : out std_logic;
      APUFCMFLUSH : out std_logic;
      APUFCMINSTRUCTION : out std_logic_vector(0 to 31);
      APUFCMINSTRVALID : out std_logic;
      APUFCMLOADBYTEADDR : out std_logic_vector(0 to 3);
      APUFCMLOADDATA : out std_logic_vector(0 to 127);
      APUFCMLOADDVALID : out std_logic;
      APUFCMOPERANDVALID : out std_logic;
      APUFCMRADATA : out std_logic_vector(0 to 31);
      APUFCMRBDATA : out std_logic_vector(0 to 31);
      APUFCMWRITEBACKOK : out std_logic;
      APUFCMMSRFE0 : out std_logic;
      APUFCMMSRFE1 : out std_logic;
      JTGC440TCK : in std_logic;
      JTGC440TDI : in std_logic;
      JTGC440TMS : in std_logic;
      JTGC440TRSTNEG : in std_logic;
      C440JTGTDO : out std_logic;
      C440JTGTDOEN : out std_logic;
      CPMMCCLK : in std_logic;
      MCMIREADDATA : in std_logic_vector(0 to 127);
      MCMIREADDATAVALID : in std_logic;
      MCMIREADDATAERR : in std_logic;
      MCMIADDRREADYTOACCEPT : in std_logic;
      MIMCREADNOTWRITE : out std_logic;
      MIMCADDRESS : out std_logic_vector(0 to 35);
      MIMCADDRESSVALID : out std_logic;
      MIMCWRITEDATA : out std_logic_vector(0 to 127);
      MIMCWRITEDATAVALID : out std_logic;
      MIMCBYTEENABLE : out std_logic_vector(0 to 15);
      MIMCBANKCONFLICT : out std_logic;
      MIMCROWCONFLICT : out std_logic;
      CPMPPCMPLBCLK : in std_logic;
      PLBPPCMMBUSY : in std_logic;
      PLBPPCMMIRQ : in std_logic;
      PLBPPCMMRDERR : in std_logic;
      PLBPPCMMWRERR : in std_logic;
      PLBPPCMADDRACK : in std_logic;
      PLBPPCMRDBTERM : in std_logic;
      PLBPPCMRDDACK : in std_logic;
      PLBPPCMRDDBUS : in std_logic_vector(0 to 127);
      PLBPPCMRDWDADDR : in std_logic_vector(0 to 3);
      PLBPPCMREARBITRATE : in std_logic;
      PLBPPCMSSIZE : in std_logic_vector(0 to 1);
      PLBPPCMTIMEOUT : in std_logic;
      PLBPPCMWRBTERM : in std_logic;
      PLBPPCMWRDACK : in std_logic;
      PLBPPCMRDPENDPRI : in std_logic_vector(0 to 1);
      PLBPPCMRDPENDREQ : in std_logic;
      PLBPPCMREQPRI : in std_logic_vector(0 to 1);
      PLBPPCMWRPENDPRI : in std_logic_vector(0 to 1);
      PLBPPCMWRPENDREQ : in std_logic;
      PPCMPLBABORT : out std_logic;
      PPCMPLBABUS : out std_logic_vector(0 to 31);
      PPCMPLBBE : out std_logic_vector(0 to 15);
      PPCMPLBBUSLOCK : out std_logic;
      PPCMPLBLOCKERR : out std_logic;
      PPCMPLBMSIZE : out std_logic_vector(0 to 1);
      PPCMPLBPRIORITY : out std_logic_vector(0 to 1);
      PPCMPLBRDBURST : out std_logic;
      PPCMPLBREQUEST : out std_logic;
      PPCMPLBRNW : out std_logic;
      PPCMPLBSIZE : out std_logic_vector(0 to 3);
      PPCMPLBTATTRIBUTE : out std_logic_vector(0 to 15);
      PPCMPLBTYPE : out std_logic_vector(0 to 2);
      PPCMPLBUABUS : out std_logic_vector(0 to 31);
      PPCMPLBWRBURST : out std_logic;
      PPCMPLBWRDBUS : out std_logic_vector(0 to 127);
      CPMPPCS0PLBCLK : in std_logic;
      PLBPPCS0MASTERID : in std_logic_vector(0 to 0);
      PLBPPCS0PAVALID : in std_logic;
      PLBPPCS0SAVALID : in std_logic;
      PLBPPCS0RDPENDREQ : in std_logic;
      PLBPPCS0WRPENDREQ : in std_logic;
      PLBPPCS0RDPENDPRI : in std_logic_vector(0 to 1);
      PLBPPCS0WRPENDPRI : in std_logic_vector(0 to 1);
      PLBPPCS0REQPRI : in std_logic_vector(0 to 1);
      PLBPPCS0RDPRIM : in std_logic;
      PLBPPCS0WRPRIM : in std_logic;
      PLBPPCS0BUSLOCK : in std_logic;
      PLBPPCS0ABORT : in std_logic;
      PLBPPCS0RNW : in std_logic;
      PLBPPCS0BE : in std_logic_vector(0 to 15);
      PLBPPCS0SIZE : in std_logic_vector(0 to 3);
      PLBPPCS0TYPE : in std_logic_vector(0 to 2);
      PLBPPCS0TATTRIBUTE : in std_logic_vector(0 to 15);
      PLBPPCS0LOCKERR : in std_logic;
      PLBPPCS0MSIZE : in std_logic_vector(0 to 1);
      PLBPPCS0UABUS : in std_logic_vector(0 to 31);
      PLBPPCS0ABUS : in std_logic_vector(0 to 31);
      PLBPPCS0WRDBUS : in std_logic_vector(0 to 127);
      PLBPPCS0WRBURST : in std_logic;
      PLBPPCS0RDBURST : in std_logic;
      PPCS0PLBADDRACK : out std_logic;
      PPCS0PLBWAIT : out std_logic;
      PPCS0PLBREARBITRATE : out std_logic;
      PPCS0PLBWRDACK : out std_logic;
      PPCS0PLBWRCOMP : out std_logic;
      PPCS0PLBRDDBUS : out std_logic_vector(0 to 127);
      PPCS0PLBRDWDADDR : out std_logic_vector(0 to 3);
      PPCS0PLBRDDACK : out std_logic;
      PPCS0PLBRDCOMP : out std_logic;
      PPCS0PLBRDBTERM : out std_logic;
      PPCS0PLBWRBTERM : out std_logic;
      PPCS0PLBMBUSY : out std_logic_vector(0 to 0);
      PPCS0PLBMRDERR : out std_logic_vector(0 to 0);
      PPCS0PLBMWRERR : out std_logic_vector(0 to 0);
      PPCS0PLBMIRQ : out std_logic_vector(0 to 0);
      PPCS0PLBSSIZE : out std_logic_vector(0 to 1);
      CPMPPCS1PLBCLK : in std_logic;
      PLBPPCS1MASTERID : in std_logic_vector(0 to 0);
      PLBPPCS1PAVALID : in std_logic;
      PLBPPCS1SAVALID : in std_logic;
      PLBPPCS1RDPENDREQ : in std_logic;
      PLBPPCS1WRPENDREQ : in std_logic;
      PLBPPCS1RDPENDPRI : in std_logic_vector(0 to 1);
      PLBPPCS1WRPENDPRI : in std_logic_vector(0 to 1);
      PLBPPCS1REQPRI : in std_logic_vector(0 to 1);
      PLBPPCS1RDPRIM : in std_logic;
      PLBPPCS1WRPRIM : in std_logic;
      PLBPPCS1BUSLOCK : in std_logic;
      PLBPPCS1ABORT : in std_logic;
      PLBPPCS1RNW : in std_logic;
      PLBPPCS1BE : in std_logic_vector(0 to 15);
      PLBPPCS1SIZE : in std_logic_vector(0 to 3);
      PLBPPCS1TYPE : in std_logic_vector(0 to 2);
      PLBPPCS1TATTRIBUTE : in std_logic_vector(0 to 15);
      PLBPPCS1LOCKERR : in std_logic;
      PLBPPCS1MSIZE : in std_logic_vector(0 to 1);
      PLBPPCS1UABUS : in std_logic_vector(0 to 31);
      PLBPPCS1ABUS : in std_logic_vector(0 to 31);
      PLBPPCS1WRDBUS : in std_logic_vector(0 to 127);
      PLBPPCS1WRBURST : in std_logic;
      PLBPPCS1RDBURST : in std_logic;
      PPCS1PLBADDRACK : out std_logic;
      PPCS1PLBWAIT : out std_logic;
      PPCS1PLBREARBITRATE : out std_logic;
      PPCS1PLBWRDACK : out std_logic;
      PPCS1PLBWRCOMP : out std_logic;
      PPCS1PLBRDDBUS : out std_logic_vector(0 to 127);
      PPCS1PLBRDWDADDR : out std_logic_vector(0 to 3);
      PPCS1PLBRDDACK : out std_logic;
      PPCS1PLBRDCOMP : out std_logic;
      PPCS1PLBRDBTERM : out std_logic;
      PPCS1PLBWRBTERM : out std_logic;
      PPCS1PLBMBUSY : out std_logic_vector(0 to 0);
      PPCS1PLBMRDERR : out std_logic_vector(0 to 0);
      PPCS1PLBMWRERR : out std_logic_vector(0 to 0);
      PPCS1PLBMIRQ : out std_logic_vector(0 to 0);
      PPCS1PLBSSIZE : out std_logic_vector(0 to 1);
      CPMDMA0LLCLK : in std_logic;
      LLDMA0TXDSTRDYN : in std_logic;
      LLDMA0RXD : in std_logic_vector(0 to 31);
      LLDMA0RXREM : in std_logic_vector(0 to 3);
      LLDMA0RXSOFN : in std_logic;
      LLDMA0RXEOFN : in std_logic;
      LLDMA0RXSOPN : in std_logic;
      LLDMA0RXEOPN : in std_logic;
      LLDMA0RXSRCRDYN : in std_logic;
      LLDMA0RSTENGINEREQ : in std_logic;
      DMA0LLTXD : out std_logic_vector(0 to 31);
      DMA0LLTXREM : out std_logic_vector(0 to 3);
      DMA0LLTXSOFN : out std_logic;
      DMA0LLTXEOFN : out std_logic;
      DMA0LLTXSOPN : out std_logic;
      DMA0LLTXEOPN : out std_logic;
      DMA0LLTXSRCRDYN : out std_logic;
      DMA0LLRXDSTRDYN : out std_logic;
      DMA0LLRSTENGINEACK : out std_logic;
      DMA0TXIRQ : out std_logic;
      DMA0RXIRQ : out std_logic;
      CPMDMA1LLCLK : in std_logic;
      LLDMA1TXDSTRDYN : in std_logic;
      LLDMA1RXD : in std_logic_vector(0 to 31);
      LLDMA1RXREM : in std_logic_vector(0 to 3);
      LLDMA1RXSOFN : in std_logic;
      LLDMA1RXEOFN : in std_logic;
      LLDMA1RXSOPN : in std_logic;
      LLDMA1RXEOPN : in std_logic;
      LLDMA1RXSRCRDYN : in std_logic;
      LLDMA1RSTENGINEREQ : in std_logic;
      DMA1LLTXD : out std_logic_vector(0 to 31);
      DMA1LLTXREM : out std_logic_vector(0 to 3);
      DMA1LLTXSOFN : out std_logic;
      DMA1LLTXEOFN : out std_logic;
      DMA1LLTXSOPN : out std_logic;
      DMA1LLTXEOPN : out std_logic;
      DMA1LLTXSRCRDYN : out std_logic;
      DMA1LLRXDSTRDYN : out std_logic;
      DMA1LLRSTENGINEACK : out std_logic;
      DMA1TXIRQ : out std_logic;
      DMA1RXIRQ : out std_logic;
      CPMDMA2LLCLK : in std_logic;
      LLDMA2TXDSTRDYN : in std_logic;
      LLDMA2RXD : in std_logic_vector(0 to 31);
      LLDMA2RXREM : in std_logic_vector(0 to 3);
      LLDMA2RXSOFN : in std_logic;
      LLDMA2RXEOFN : in std_logic;
      LLDMA2RXSOPN : in std_logic;
      LLDMA2RXEOPN : in std_logic;
      LLDMA2RXSRCRDYN : in std_logic;
      LLDMA2RSTENGINEREQ : in std_logic;
      DMA2LLTXD : out std_logic_vector(0 to 31);
      DMA2LLTXREM : out std_logic_vector(0 to 3);
      DMA2LLTXSOFN : out std_logic;
      DMA2LLTXEOFN : out std_logic;
      DMA2LLTXSOPN : out std_logic;
      DMA2LLTXEOPN : out std_logic;
      DMA2LLTXSRCRDYN : out std_logic;
      DMA2LLRXDSTRDYN : out std_logic;
      DMA2LLRSTENGINEACK : out std_logic;
      DMA2TXIRQ : out std_logic;
      DMA2RXIRQ : out std_logic;
      CPMDMA3LLCLK : in std_logic;
      LLDMA3TXDSTRDYN : in std_logic;
      LLDMA3RXD : in std_logic_vector(0 to 31);
      LLDMA3RXREM : in std_logic_vector(0 to 3);
      LLDMA3RXSOFN : in std_logic;
      LLDMA3RXEOFN : in std_logic;
      LLDMA3RXSOPN : in std_logic;
      LLDMA3RXEOPN : in std_logic;
      LLDMA3RXSRCRDYN : in std_logic;
      LLDMA3RSTENGINEREQ : in std_logic;
      DMA3LLTXD : out std_logic_vector(0 to 31);
      DMA3LLTXREM : out std_logic_vector(0 to 3);
      DMA3LLTXSOFN : out std_logic;
      DMA3LLTXEOFN : out std_logic;
      DMA3LLTXSOPN : out std_logic;
      DMA3LLTXEOPN : out std_logic;
      DMA3LLTXSRCRDYN : out std_logic;
      DMA3LLRXDSTRDYN : out std_logic;
      DMA3LLRSTENGINEACK : out std_logic;
      DMA3TXIRQ : out std_logic;
      DMA3RXIRQ : out std_logic;
      RSTC440RESETCORE : in std_logic;
      RSTC440RESETCHIP : in std_logic;
      RSTC440RESETSYSTEM : in std_logic;
      C440RSTCORERESETREQ : out std_logic;
      C440RSTCHIPRESETREQ : out std_logic;
      C440RSTSYSTEMRESETREQ : out std_logic;
      TRCC440TRACEDISABLE : in std_logic;
      TRCC440TRIGGEREVENTIN : in std_logic;
      C440TRCBRANCHSTATUS : out std_logic_vector(0 to 2);
      C440TRCCYCLE : out std_logic;
      C440TRCEXECUTIONSTATUS : out std_logic_vector(0 to 4);
      C440TRCTRACESTATUS : out std_logic_vector(0 to 6);
      C440TRCTRIGGEREVENTOUT : out std_logic;
      C440TRCTRIGGEREVENTTYPE : out std_logic_vector(0 to 13)
    );
  end component;

  component plb_v46_0_wrapper is
    port (
      PLB_Clk : in std_logic;
      SYS_Rst : in std_logic;
      PLB_Rst : out std_logic;
      SPLB_Rst : out std_logic_vector(0 to 11);
      MPLB_Rst : out std_logic_vector(0 to 7);
      PLB_dcrAck : out std_logic;
      PLB_dcrDBus : out std_logic_vector(0 to 31);
      DCR_ABus : in std_logic_vector(0 to 9);
      DCR_DBus : in std_logic_vector(0 to 31);
      DCR_Read : in std_logic;
      DCR_Write : in std_logic;
      M_ABus : in std_logic_vector(0 to 255);
      M_UABus : in std_logic_vector(0 to 255);
      M_BE : in std_logic_vector(0 to 127);
      M_RNW : in std_logic_vector(0 to 7);
      M_abort : in std_logic_vector(0 to 7);
      M_busLock : in std_logic_vector(0 to 7);
      M_TAttribute : in std_logic_vector(0 to 127);
      M_lockErr : in std_logic_vector(0 to 7);
      M_MSize : in std_logic_vector(0 to 15);
      M_priority : in std_logic_vector(0 to 15);
      M_rdBurst : in std_logic_vector(0 to 7);
      M_request : in std_logic_vector(0 to 7);
      M_size : in std_logic_vector(0 to 31);
      M_type : in std_logic_vector(0 to 23);
      M_wrBurst : in std_logic_vector(0 to 7);
      M_wrDBus : in std_logic_vector(0 to 1023);
      Sl_addrAck : in std_logic_vector(0 to 11);
      Sl_MRdErr : in std_logic_vector(0 to 95);
      Sl_MWrErr : in std_logic_vector(0 to 95);
      Sl_MBusy : in std_logic_vector(0 to 95);
      Sl_rdBTerm : in std_logic_vector(0 to 11);
      Sl_rdComp : in std_logic_vector(0 to 11);
      Sl_rdDAck : in std_logic_vector(0 to 11);
      Sl_rdDBus : in std_logic_vector(0 to 1535);
      Sl_rdWdAddr : in std_logic_vector(0 to 47);
      Sl_rearbitrate : in std_logic_vector(0 to 11);
      Sl_SSize : in std_logic_vector(0 to 23);
      Sl_wait : in std_logic_vector(0 to 11);
      Sl_wrBTerm : in std_logic_vector(0 to 11);
      Sl_wrComp : in std_logic_vector(0 to 11);
      Sl_wrDAck : in std_logic_vector(0 to 11);
      Sl_MIRQ : in std_logic_vector(0 to 95);
      PLB_MIRQ : out std_logic_vector(0 to 7);
      PLB_ABus : out std_logic_vector(0 to 31);
      PLB_UABus : out std_logic_vector(0 to 31);
      PLB_BE : out std_logic_vector(0 to 15);
      PLB_MAddrAck : out std_logic_vector(0 to 7);
      PLB_MTimeout : out std_logic_vector(0 to 7);
      PLB_MBusy : out std_logic_vector(0 to 7);
      PLB_MRdErr : out std_logic_vector(0 to 7);
      PLB_MWrErr : out std_logic_vector(0 to 7);
      PLB_MRdBTerm : out std_logic_vector(0 to 7);
      PLB_MRdDAck : out std_logic_vector(0 to 7);
      PLB_MRdDBus : out std_logic_vector(0 to 1023);
      PLB_MRdWdAddr : out std_logic_vector(0 to 31);
      PLB_MRearbitrate : out std_logic_vector(0 to 7);
      PLB_MWrBTerm : out std_logic_vector(0 to 7);
      PLB_MWrDAck : out std_logic_vector(0 to 7);
      PLB_MSSize : out std_logic_vector(0 to 15);
      PLB_PAValid : out std_logic;
      PLB_RNW : out std_logic;
      PLB_SAValid : out std_logic;
      PLB_abort : out std_logic;
      PLB_busLock : out std_logic;
      PLB_TAttribute : out std_logic_vector(0 to 15);
      PLB_lockErr : out std_logic;
      PLB_masterID : out std_logic_vector(0 to 2);
      PLB_MSize : out std_logic_vector(0 to 1);
      PLB_rdPendPri : out std_logic_vector(0 to 1);
      PLB_wrPendPri : out std_logic_vector(0 to 1);
      PLB_rdPendReq : out std_logic;
      PLB_wrPendReq : out std_logic;
      PLB_rdBurst : out std_logic;
      PLB_rdPrim : out std_logic_vector(0 to 11);
      PLB_reqPri : out std_logic_vector(0 to 1);
      PLB_size : out std_logic_vector(0 to 3);
      PLB_type : out std_logic_vector(0 to 2);
      PLB_wrBurst : out std_logic;
      PLB_wrDBus : out std_logic_vector(0 to 127);
      PLB_wrPrim : out std_logic_vector(0 to 11);
      PLB_SaddrAck : out std_logic;
      PLB_SMRdErr : out std_logic_vector(0 to 7);
      PLB_SMWrErr : out std_logic_vector(0 to 7);
      PLB_SMBusy : out std_logic_vector(0 to 7);
      PLB_SrdBTerm : out std_logic;
      PLB_SrdComp : out std_logic;
      PLB_SrdDAck : out std_logic;
      PLB_SrdDBus : out std_logic_vector(0 to 127);
      PLB_SrdWdAddr : out std_logic_vector(0 to 3);
      PLB_Srearbitrate : out std_logic;
      PLB_Sssize : out std_logic_vector(0 to 1);
      PLB_Swait : out std_logic;
      PLB_SwrBTerm : out std_logic;
      PLB_SwrComp : out std_logic;
      PLB_SwrDAck : out std_logic;
      Bus_Error_Det : out std_logic
    );
  end component;

  component xps_bram_if_cntlr_1_wrapper is
    port (
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 2);
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to 15);
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_lockErr : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to 127);
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_wrBTerm : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 127);
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_rdBTerm : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 7);
      Sl_MWrErr : out std_logic_vector(0 to 7);
      Sl_MRdErr : out std_logic_vector(0 to 7);
      Sl_MIRQ : out std_logic_vector(0 to 7);
      BRAM_Rst : out std_logic;
      BRAM_Clk : out std_logic;
      BRAM_EN : out std_logic;
      BRAM_WEN : out std_logic_vector(0 to 7);
      BRAM_Addr : out std_logic_vector(0 to 31);
      BRAM_Din : in std_logic_vector(0 to 63);
      BRAM_Dout : out std_logic_vector(0 to 63)
    );
  end component;

  component xps_bram_if_cntlr_1_bram_wrapper is
    port (
      BRAM_Rst_A : in std_logic;
      BRAM_Clk_A : in std_logic;
      BRAM_EN_A : in std_logic;
      BRAM_WEN_A : in std_logic_vector(0 to 7);
      BRAM_Addr_A : in std_logic_vector(0 to 31);
      BRAM_Din_A : out std_logic_vector(0 to 63);
      BRAM_Dout_A : in std_logic_vector(0 to 63);
      BRAM_Rst_B : in std_logic;
      BRAM_Clk_B : in std_logic;
      BRAM_EN_B : in std_logic;
      BRAM_WEN_B : in std_logic_vector(0 to 7);
      BRAM_Addr_B : in std_logic_vector(0 to 31);
      BRAM_Din_B : out std_logic_vector(0 to 63);
      BRAM_Dout_B : in std_logic_vector(0 to 63)
    );
  end component;

  component rs232_uart_1_wrapper is
    port (
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 2);
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to 15);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_wrDBus : in std_logic_vector(0 to 127);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_lockErr : in std_logic;
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 127);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 7);
      Sl_MWrErr : out std_logic_vector(0 to 7);
      Sl_MRdErr : out std_logic_vector(0 to 7);
      Sl_wrBTerm : out std_logic;
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdBTerm : out std_logic;
      Sl_MIRQ : out std_logic_vector(0 to 7);
      RX : in std_logic;
      TX : out std_logic;
      Interrupt : out std_logic
    );
  end component;

  component leds_8bit_wrapper is
    port (
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 2);
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to 15);
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_lockErr : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to 127);
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_wrBTerm : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 127);
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_rdBTerm : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 7);
      Sl_MWrErr : out std_logic_vector(0 to 7);
      Sl_MRdErr : out std_logic_vector(0 to 7);
      Sl_MIRQ : out std_logic_vector(0 to 7);
      IP2INTC_Irpt : out std_logic;
      GPIO_IO_I : in std_logic_vector(0 to 7);
      GPIO_IO_O : out std_logic_vector(0 to 7);
      GPIO_IO_T : out std_logic_vector(0 to 7);
      GPIO_in : in std_logic_vector(0 to 7);
      GPIO_d_out : out std_logic_vector(0 to 7);
      GPIO_t_out : out std_logic_vector(0 to 7);
      GPIO2_IO_I : in std_logic_vector(0 to 7);
      GPIO2_IO_O : out std_logic_vector(0 to 7);
      GPIO2_IO_T : out std_logic_vector(0 to 7);
      GPIO2_in : in std_logic_vector(0 to 7);
      GPIO2_d_out : out std_logic_vector(0 to 7);
      GPIO2_t_out : out std_logic_vector(0 to 7)
    );
  end component;

  component sram_wrapper is
    port (
      MCH_PLB_Clk : in std_logic;
      RdClk : in std_logic;
      MCH_PLB_Rst : in std_logic;
      MCH0_Access_Control : in std_logic;
      MCH0_Access_Data : in std_logic_vector(0 to 31);
      MCH0_Access_Write : in std_logic;
      MCH0_Access_Full : out std_logic;
      MCH0_ReadData_Control : out std_logic;
      MCH0_ReadData_Data : out std_logic_vector(0 to 31);
      MCH0_ReadData_Read : in std_logic;
      MCH0_ReadData_Exists : out std_logic;
      MCH1_Access_Control : in std_logic;
      MCH1_Access_Data : in std_logic_vector(0 to 31);
      MCH1_Access_Write : in std_logic;
      MCH1_Access_Full : out std_logic;
      MCH1_ReadData_Control : out std_logic;
      MCH1_ReadData_Data : out std_logic_vector(0 to 31);
      MCH1_ReadData_Read : in std_logic;
      MCH1_ReadData_Exists : out std_logic;
      MCH2_Access_Control : in std_logic;
      MCH2_Access_Data : in std_logic_vector(0 to 31);
      MCH2_Access_Write : in std_logic;
      MCH2_Access_Full : out std_logic;
      MCH2_ReadData_Control : out std_logic;
      MCH2_ReadData_Data : out std_logic_vector(0 to 31);
      MCH2_ReadData_Read : in std_logic;
      MCH2_ReadData_Exists : out std_logic;
      MCH3_Access_Control : in std_logic;
      MCH3_Access_Data : in std_logic_vector(0 to 31);
      MCH3_Access_Write : in std_logic;
      MCH3_Access_Full : out std_logic;
      MCH3_ReadData_Control : out std_logic;
      MCH3_ReadData_Data : out std_logic_vector(0 to 31);
      MCH3_ReadData_Read : in std_logic;
      MCH3_ReadData_Exists : out std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 2);
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to 15);
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_lockErr : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to 127);
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_wrBTerm : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 127);
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_rdBTerm : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 7);
      Sl_MWrErr : out std_logic_vector(0 to 7);
      Sl_MRdErr : out std_logic_vector(0 to 7);
      Sl_MIRQ : out std_logic_vector(0 to 7);
      Mem_DQ_I : in std_logic_vector(0 to 31);
      Mem_DQ_O : out std_logic_vector(0 to 31);
      Mem_DQ_T : out std_logic_vector(0 to 31);
      Mem_A : out std_logic_vector(0 to 31);
      Mem_RPN : out std_logic;
      Mem_CEN : out std_logic_vector(0 to 0);
      Mem_OEN : out std_logic_vector(0 to 0);
      Mem_WEN : out std_logic;
      Mem_QWEN : out std_logic_vector(0 to 3);
      Mem_BEN : out std_logic_vector(0 to 3);
      Mem_CE : out std_logic_vector(0 to 0);
      Mem_ADV_LDN : out std_logic;
      Mem_LBON : out std_logic;
      Mem_CKEN : out std_logic;
      Mem_RNW : out std_logic
    );
  end component;

  component ddr2_sdram_wrapper is
    port (
      FSL0_M_Clk : in std_logic;
      FSL0_M_Write : in std_logic;
      FSL0_M_Data : in std_logic_vector(0 to 31);
      FSL0_M_Control : in std_logic;
      FSL0_M_Full : out std_logic;
      FSL0_S_Clk : in std_logic;
      FSL0_S_Read : in std_logic;
      FSL0_S_Data : out std_logic_vector(0 to 31);
      FSL0_S_Control : out std_logic;
      FSL0_S_Exists : out std_logic;
      SPLB0_Clk : in std_logic;
      SPLB0_Rst : in std_logic;
      SPLB0_PLB_ABus : in std_logic_vector(0 to 31);
      SPLB0_PLB_PAValid : in std_logic;
      SPLB0_PLB_SAValid : in std_logic;
      SPLB0_PLB_masterID : in std_logic_vector(0 to 0);
      SPLB0_PLB_RNW : in std_logic;
      SPLB0_PLB_BE : in std_logic_vector(0 to 7);
      SPLB0_PLB_UABus : in std_logic_vector(0 to 31);
      SPLB0_PLB_rdPrim : in std_logic;
      SPLB0_PLB_wrPrim : in std_logic;
      SPLB0_PLB_abort : in std_logic;
      SPLB0_PLB_busLock : in std_logic;
      SPLB0_PLB_MSize : in std_logic_vector(0 to 1);
      SPLB0_PLB_size : in std_logic_vector(0 to 3);
      SPLB0_PLB_type : in std_logic_vector(0 to 2);
      SPLB0_PLB_lockErr : in std_logic;
      SPLB0_PLB_wrPendReq : in std_logic;
      SPLB0_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SPLB0_PLB_rdPendReq : in std_logic;
      SPLB0_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SPLB0_PLB_reqPri : in std_logic_vector(0 to 1);
      SPLB0_PLB_TAttribute : in std_logic_vector(0 to 15);
      SPLB0_PLB_rdBurst : in std_logic;
      SPLB0_PLB_wrBurst : in std_logic;
      SPLB0_PLB_wrDBus : in std_logic_vector(0 to 63);
      SPLB0_Sl_addrAck : out std_logic;
      SPLB0_Sl_SSize : out std_logic_vector(0 to 1);
      SPLB0_Sl_wait : out std_logic;
      SPLB0_Sl_rearbitrate : out std_logic;
      SPLB0_Sl_wrDAck : out std_logic;
      SPLB0_Sl_wrComp : out std_logic;
      SPLB0_Sl_wrBTerm : out std_logic;
      SPLB0_Sl_rdDBus : out std_logic_vector(0 to 63);
      SPLB0_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SPLB0_Sl_rdDAck : out std_logic;
      SPLB0_Sl_rdComp : out std_logic;
      SPLB0_Sl_rdBTerm : out std_logic;
      SPLB0_Sl_MBusy : out std_logic_vector(0 to 0);
      SPLB0_Sl_MRdErr : out std_logic_vector(0 to 0);
      SPLB0_Sl_MWrErr : out std_logic_vector(0 to 0);
      SPLB0_Sl_MIRQ : out std_logic_vector(0 to 0);
      SDMA0_Clk : in std_logic;
      SDMA0_Rx_IntOut : out std_logic;
      SDMA0_Tx_IntOut : out std_logic;
      SDMA0_RstOut : out std_logic;
      SDMA0_TX_D : out std_logic_vector(0 to 31);
      SDMA0_TX_Rem : out std_logic_vector(0 to 3);
      SDMA0_TX_SOF : out std_logic;
      SDMA0_TX_EOF : out std_logic;
      SDMA0_TX_SOP : out std_logic;
      SDMA0_TX_EOP : out std_logic;
      SDMA0_TX_Src_Rdy : out std_logic;
      SDMA0_TX_Dst_Rdy : in std_logic;
      SDMA0_RX_D : in std_logic_vector(0 to 31);
      SDMA0_RX_Rem : in std_logic_vector(0 to 3);
      SDMA0_RX_SOF : in std_logic;
      SDMA0_RX_EOF : in std_logic;
      SDMA0_RX_SOP : in std_logic;
      SDMA0_RX_EOP : in std_logic;
      SDMA0_RX_Src_Rdy : in std_logic;
      SDMA0_RX_Dst_Rdy : out std_logic;
      SDMA_CTRL0_Clk : in std_logic;
      SDMA_CTRL0_Rst : in std_logic;
      SDMA_CTRL0_PLB_ABus : in std_logic_vector(0 to 31);
      SDMA_CTRL0_PLB_PAValid : in std_logic;
      SDMA_CTRL0_PLB_SAValid : in std_logic;
      SDMA_CTRL0_PLB_masterID : in std_logic_vector(0 to 0);
      SDMA_CTRL0_PLB_RNW : in std_logic;
      SDMA_CTRL0_PLB_BE : in std_logic_vector(0 to 7);
      SDMA_CTRL0_PLB_UABus : in std_logic_vector(0 to 31);
      SDMA_CTRL0_PLB_rdPrim : in std_logic;
      SDMA_CTRL0_PLB_wrPrim : in std_logic;
      SDMA_CTRL0_PLB_abort : in std_logic;
      SDMA_CTRL0_PLB_busLock : in std_logic;
      SDMA_CTRL0_PLB_MSize : in std_logic_vector(0 to 1);
      SDMA_CTRL0_PLB_size : in std_logic_vector(0 to 3);
      SDMA_CTRL0_PLB_type : in std_logic_vector(0 to 2);
      SDMA_CTRL0_PLB_lockErr : in std_logic;
      SDMA_CTRL0_PLB_wrPendReq : in std_logic;
      SDMA_CTRL0_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL0_PLB_rdPendReq : in std_logic;
      SDMA_CTRL0_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL0_PLB_reqPri : in std_logic_vector(0 to 1);
      SDMA_CTRL0_PLB_TAttribute : in std_logic_vector(0 to 15);
      SDMA_CTRL0_PLB_rdBurst : in std_logic;
      SDMA_CTRL0_PLB_wrBurst : in std_logic;
      SDMA_CTRL0_PLB_wrDBus : in std_logic_vector(0 to 63);
      SDMA_CTRL0_Sl_addrAck : out std_logic;
      SDMA_CTRL0_Sl_SSize : out std_logic_vector(0 to 1);
      SDMA_CTRL0_Sl_wait : out std_logic;
      SDMA_CTRL0_Sl_rearbitrate : out std_logic;
      SDMA_CTRL0_Sl_wrDAck : out std_logic;
      SDMA_CTRL0_Sl_wrComp : out std_logic;
      SDMA_CTRL0_Sl_wrBTerm : out std_logic;
      SDMA_CTRL0_Sl_rdDBus : out std_logic_vector(0 to 63);
      SDMA_CTRL0_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SDMA_CTRL0_Sl_rdDAck : out std_logic;
      SDMA_CTRL0_Sl_rdComp : out std_logic;
      SDMA_CTRL0_Sl_rdBTerm : out std_logic;
      SDMA_CTRL0_Sl_MBusy : out std_logic_vector(0 to 0);
      SDMA_CTRL0_Sl_MRdErr : out std_logic_vector(0 to 0);
      SDMA_CTRL0_Sl_MWrErr : out std_logic_vector(0 to 0);
      SDMA_CTRL0_Sl_MIRQ : out std_logic_vector(0 to 0);
      PIM0_Addr : in std_logic_vector(31 downto 0);
      PIM0_AddrReq : in std_logic;
      PIM0_AddrAck : out std_logic;
      PIM0_RNW : in std_logic;
      PIM0_Size : in std_logic_vector(3 downto 0);
      PIM0_RdModWr : in std_logic;
      PIM0_WrFIFO_Data : in std_logic_vector(63 downto 0);
      PIM0_WrFIFO_BE : in std_logic_vector(7 downto 0);
      PIM0_WrFIFO_Push : in std_logic;
      PIM0_RdFIFO_Data : out std_logic_vector(63 downto 0);
      PIM0_RdFIFO_Pop : in std_logic;
      PIM0_RdFIFO_RdWdAddr : out std_logic_vector(3 downto 0);
      PIM0_WrFIFO_Empty : out std_logic;
      PIM0_WrFIFO_AlmostFull : out std_logic;
      PIM0_WrFIFO_Flush : in std_logic;
      PIM0_RdFIFO_Empty : out std_logic;
      PIM0_RdFIFO_Flush : in std_logic;
      PIM0_RdFIFO_Latency : out std_logic_vector(1 downto 0);
      PIM0_InitDone : out std_logic;
      PPC440MC0_MIMCReadNotWrite : in std_logic;
      PPC440MC0_MIMCAddress : in std_logic_vector(0 to 35);
      PPC440MC0_MIMCAddressValid : in std_logic;
      PPC440MC0_MIMCWriteData : in std_logic_vector(0 to 127);
      PPC440MC0_MIMCWriteDataValid : in std_logic;
      PPC440MC0_MIMCByteEnable : in std_logic_vector(0 to 15);
      PPC440MC0_MIMCBankConflict : in std_logic;
      PPC440MC0_MIMCRowConflict : in std_logic;
      PPC440MC0_MCMIReadData : out std_logic_vector(0 to 127);
      PPC440MC0_MCMIReadDataValid : out std_logic;
      PPC440MC0_MCMIReadDataErr : out std_logic;
      PPC440MC0_MCMIAddrReadyToAccept : out std_logic;
      VFBC0_Cmd_Clk : in std_logic;
      VFBC0_Cmd_Reset : in std_logic;
      VFBC0_Cmd_Data : in std_logic_vector(31 downto 0);
      VFBC0_Cmd_Write : in std_logic;
      VFBC0_Cmd_End : in std_logic;
      VFBC0_Cmd_Full : out std_logic;
      VFBC0_Cmd_Almost_Full : out std_logic;
      VFBC0_Cmd_Idle : out std_logic;
      VFBC0_Wd_Clk : in std_logic;
      VFBC0_Wd_Reset : in std_logic;
      VFBC0_Wd_Write : in std_logic;
      VFBC0_Wd_End_Burst : in std_logic;
      VFBC0_Wd_Flush : in std_logic;
      VFBC0_Wd_Data : in std_logic_vector(31 downto 0);
      VFBC0_Wd_Data_BE : in std_logic_vector(3 downto 0);
      VFBC0_Wd_Full : out std_logic;
      VFBC0_Wd_Almost_Full : out std_logic;
      VFBC0_Rd_Clk : in std_logic;
      VFBC0_Rd_Reset : in std_logic;
      VFBC0_Rd_Read : in std_logic;
      VFBC0_Rd_End_Burst : in std_logic;
      VFBC0_Rd_Flush : in std_logic;
      VFBC0_Rd_Data : out std_logic_vector(31 downto 0);
      VFBC0_Rd_Empty : out std_logic;
      VFBC0_Rd_Almost_Empty : out std_logic;
      FSL1_M_Clk : in std_logic;
      FSL1_M_Write : in std_logic;
      FSL1_M_Data : in std_logic_vector(0 to 31);
      FSL1_M_Control : in std_logic;
      FSL1_M_Full : out std_logic;
      FSL1_S_Clk : in std_logic;
      FSL1_S_Read : in std_logic;
      FSL1_S_Data : out std_logic_vector(0 to 31);
      FSL1_S_Control : out std_logic;
      FSL1_S_Exists : out std_logic;
      SPLB1_Clk : in std_logic;
      SPLB1_Rst : in std_logic;
      SPLB1_PLB_ABus : in std_logic_vector(0 to 31);
      SPLB1_PLB_PAValid : in std_logic;
      SPLB1_PLB_SAValid : in std_logic;
      SPLB1_PLB_masterID : in std_logic_vector(0 to 0);
      SPLB1_PLB_RNW : in std_logic;
      SPLB1_PLB_BE : in std_logic_vector(0 to 7);
      SPLB1_PLB_UABus : in std_logic_vector(0 to 31);
      SPLB1_PLB_rdPrim : in std_logic;
      SPLB1_PLB_wrPrim : in std_logic;
      SPLB1_PLB_abort : in std_logic;
      SPLB1_PLB_busLock : in std_logic;
      SPLB1_PLB_MSize : in std_logic_vector(0 to 1);
      SPLB1_PLB_size : in std_logic_vector(0 to 3);
      SPLB1_PLB_type : in std_logic_vector(0 to 2);
      SPLB1_PLB_lockErr : in std_logic;
      SPLB1_PLB_wrPendReq : in std_logic;
      SPLB1_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SPLB1_PLB_rdPendReq : in std_logic;
      SPLB1_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SPLB1_PLB_reqPri : in std_logic_vector(0 to 1);
      SPLB1_PLB_TAttribute : in std_logic_vector(0 to 15);
      SPLB1_PLB_rdBurst : in std_logic;
      SPLB1_PLB_wrBurst : in std_logic;
      SPLB1_PLB_wrDBus : in std_logic_vector(0 to 63);
      SPLB1_Sl_addrAck : out std_logic;
      SPLB1_Sl_SSize : out std_logic_vector(0 to 1);
      SPLB1_Sl_wait : out std_logic;
      SPLB1_Sl_rearbitrate : out std_logic;
      SPLB1_Sl_wrDAck : out std_logic;
      SPLB1_Sl_wrComp : out std_logic;
      SPLB1_Sl_wrBTerm : out std_logic;
      SPLB1_Sl_rdDBus : out std_logic_vector(0 to 63);
      SPLB1_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SPLB1_Sl_rdDAck : out std_logic;
      SPLB1_Sl_rdComp : out std_logic;
      SPLB1_Sl_rdBTerm : out std_logic;
      SPLB1_Sl_MBusy : out std_logic_vector(0 to 0);
      SPLB1_Sl_MRdErr : out std_logic_vector(0 to 0);
      SPLB1_Sl_MWrErr : out std_logic_vector(0 to 0);
      SPLB1_Sl_MIRQ : out std_logic_vector(0 to 0);
      SDMA1_Clk : in std_logic;
      SDMA1_Rx_IntOut : out std_logic;
      SDMA1_Tx_IntOut : out std_logic;
      SDMA1_RstOut : out std_logic;
      SDMA1_TX_D : out std_logic_vector(0 to 31);
      SDMA1_TX_Rem : out std_logic_vector(0 to 3);
      SDMA1_TX_SOF : out std_logic;
      SDMA1_TX_EOF : out std_logic;
      SDMA1_TX_SOP : out std_logic;
      SDMA1_TX_EOP : out std_logic;
      SDMA1_TX_Src_Rdy : out std_logic;
      SDMA1_TX_Dst_Rdy : in std_logic;
      SDMA1_RX_D : in std_logic_vector(0 to 31);
      SDMA1_RX_Rem : in std_logic_vector(0 to 3);
      SDMA1_RX_SOF : in std_logic;
      SDMA1_RX_EOF : in std_logic;
      SDMA1_RX_SOP : in std_logic;
      SDMA1_RX_EOP : in std_logic;
      SDMA1_RX_Src_Rdy : in std_logic;
      SDMA1_RX_Dst_Rdy : out std_logic;
      SDMA_CTRL1_Clk : in std_logic;
      SDMA_CTRL1_Rst : in std_logic;
      SDMA_CTRL1_PLB_ABus : in std_logic_vector(0 to 31);
      SDMA_CTRL1_PLB_PAValid : in std_logic;
      SDMA_CTRL1_PLB_SAValid : in std_logic;
      SDMA_CTRL1_PLB_masterID : in std_logic_vector(0 to 0);
      SDMA_CTRL1_PLB_RNW : in std_logic;
      SDMA_CTRL1_PLB_BE : in std_logic_vector(0 to 7);
      SDMA_CTRL1_PLB_UABus : in std_logic_vector(0 to 31);
      SDMA_CTRL1_PLB_rdPrim : in std_logic;
      SDMA_CTRL1_PLB_wrPrim : in std_logic;
      SDMA_CTRL1_PLB_abort : in std_logic;
      SDMA_CTRL1_PLB_busLock : in std_logic;
      SDMA_CTRL1_PLB_MSize : in std_logic_vector(0 to 1);
      SDMA_CTRL1_PLB_size : in std_logic_vector(0 to 3);
      SDMA_CTRL1_PLB_type : in std_logic_vector(0 to 2);
      SDMA_CTRL1_PLB_lockErr : in std_logic;
      SDMA_CTRL1_PLB_wrPendReq : in std_logic;
      SDMA_CTRL1_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL1_PLB_rdPendReq : in std_logic;
      SDMA_CTRL1_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL1_PLB_reqPri : in std_logic_vector(0 to 1);
      SDMA_CTRL1_PLB_TAttribute : in std_logic_vector(0 to 15);
      SDMA_CTRL1_PLB_rdBurst : in std_logic;
      SDMA_CTRL1_PLB_wrBurst : in std_logic;
      SDMA_CTRL1_PLB_wrDBus : in std_logic_vector(0 to 63);
      SDMA_CTRL1_Sl_addrAck : out std_logic;
      SDMA_CTRL1_Sl_SSize : out std_logic_vector(0 to 1);
      SDMA_CTRL1_Sl_wait : out std_logic;
      SDMA_CTRL1_Sl_rearbitrate : out std_logic;
      SDMA_CTRL1_Sl_wrDAck : out std_logic;
      SDMA_CTRL1_Sl_wrComp : out std_logic;
      SDMA_CTRL1_Sl_wrBTerm : out std_logic;
      SDMA_CTRL1_Sl_rdDBus : out std_logic_vector(0 to 63);
      SDMA_CTRL1_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SDMA_CTRL1_Sl_rdDAck : out std_logic;
      SDMA_CTRL1_Sl_rdComp : out std_logic;
      SDMA_CTRL1_Sl_rdBTerm : out std_logic;
      SDMA_CTRL1_Sl_MBusy : out std_logic_vector(0 to 0);
      SDMA_CTRL1_Sl_MRdErr : out std_logic_vector(0 to 0);
      SDMA_CTRL1_Sl_MWrErr : out std_logic_vector(0 to 0);
      SDMA_CTRL1_Sl_MIRQ : out std_logic_vector(0 to 0);
      PIM1_Addr : in std_logic_vector(31 downto 0);
      PIM1_AddrReq : in std_logic;
      PIM1_AddrAck : out std_logic;
      PIM1_RNW : in std_logic;
      PIM1_Size : in std_logic_vector(3 downto 0);
      PIM1_RdModWr : in std_logic;
      PIM1_WrFIFO_Data : in std_logic_vector(63 downto 0);
      PIM1_WrFIFO_BE : in std_logic_vector(7 downto 0);
      PIM1_WrFIFO_Push : in std_logic;
      PIM1_RdFIFO_Data : out std_logic_vector(63 downto 0);
      PIM1_RdFIFO_Pop : in std_logic;
      PIM1_RdFIFO_RdWdAddr : out std_logic_vector(3 downto 0);
      PIM1_WrFIFO_Empty : out std_logic;
      PIM1_WrFIFO_AlmostFull : out std_logic;
      PIM1_WrFIFO_Flush : in std_logic;
      PIM1_RdFIFO_Empty : out std_logic;
      PIM1_RdFIFO_Flush : in std_logic;
      PIM1_RdFIFO_Latency : out std_logic_vector(1 downto 0);
      PIM1_InitDone : out std_logic;
      PPC440MC1_MIMCReadNotWrite : in std_logic;
      PPC440MC1_MIMCAddress : in std_logic_vector(0 to 35);
      PPC440MC1_MIMCAddressValid : in std_logic;
      PPC440MC1_MIMCWriteData : in std_logic_vector(0 to 127);
      PPC440MC1_MIMCWriteDataValid : in std_logic;
      PPC440MC1_MIMCByteEnable : in std_logic_vector(0 to 15);
      PPC440MC1_MIMCBankConflict : in std_logic;
      PPC440MC1_MIMCRowConflict : in std_logic;
      PPC440MC1_MCMIReadData : out std_logic_vector(0 to 127);
      PPC440MC1_MCMIReadDataValid : out std_logic;
      PPC440MC1_MCMIReadDataErr : out std_logic;
      PPC440MC1_MCMIAddrReadyToAccept : out std_logic;
      VFBC1_Cmd_Clk : in std_logic;
      VFBC1_Cmd_Reset : in std_logic;
      VFBC1_Cmd_Data : in std_logic_vector(31 downto 0);
      VFBC1_Cmd_Write : in std_logic;
      VFBC1_Cmd_End : in std_logic;
      VFBC1_Cmd_Full : out std_logic;
      VFBC1_Cmd_Almost_Full : out std_logic;
      VFBC1_Cmd_Idle : out std_logic;
      VFBC1_Wd_Clk : in std_logic;
      VFBC1_Wd_Reset : in std_logic;
      VFBC1_Wd_Write : in std_logic;
      VFBC1_Wd_End_Burst : in std_logic;
      VFBC1_Wd_Flush : in std_logic;
      VFBC1_Wd_Data : in std_logic_vector(31 downto 0);
      VFBC1_Wd_Data_BE : in std_logic_vector(3 downto 0);
      VFBC1_Wd_Full : out std_logic;
      VFBC1_Wd_Almost_Full : out std_logic;
      VFBC1_Rd_Clk : in std_logic;
      VFBC1_Rd_Reset : in std_logic;
      VFBC1_Rd_Read : in std_logic;
      VFBC1_Rd_End_Burst : in std_logic;
      VFBC1_Rd_Flush : in std_logic;
      VFBC1_Rd_Data : out std_logic_vector(31 downto 0);
      VFBC1_Rd_Empty : out std_logic;
      VFBC1_Rd_Almost_Empty : out std_logic;
      FSL2_M_Clk : in std_logic;
      FSL2_M_Write : in std_logic;
      FSL2_M_Data : in std_logic_vector(0 to 31);
      FSL2_M_Control : in std_logic;
      FSL2_M_Full : out std_logic;
      FSL2_S_Clk : in std_logic;
      FSL2_S_Read : in std_logic;
      FSL2_S_Data : out std_logic_vector(0 to 31);
      FSL2_S_Control : out std_logic;
      FSL2_S_Exists : out std_logic;
      SPLB2_Clk : in std_logic;
      SPLB2_Rst : in std_logic;
      SPLB2_PLB_ABus : in std_logic_vector(0 to 31);
      SPLB2_PLB_PAValid : in std_logic;
      SPLB2_PLB_SAValid : in std_logic;
      SPLB2_PLB_masterID : in std_logic_vector(0 to 0);
      SPLB2_PLB_RNW : in std_logic;
      SPLB2_PLB_BE : in std_logic_vector(0 to 7);
      SPLB2_PLB_UABus : in std_logic_vector(0 to 31);
      SPLB2_PLB_rdPrim : in std_logic;
      SPLB2_PLB_wrPrim : in std_logic;
      SPLB2_PLB_abort : in std_logic;
      SPLB2_PLB_busLock : in std_logic;
      SPLB2_PLB_MSize : in std_logic_vector(0 to 1);
      SPLB2_PLB_size : in std_logic_vector(0 to 3);
      SPLB2_PLB_type : in std_logic_vector(0 to 2);
      SPLB2_PLB_lockErr : in std_logic;
      SPLB2_PLB_wrPendReq : in std_logic;
      SPLB2_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SPLB2_PLB_rdPendReq : in std_logic;
      SPLB2_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SPLB2_PLB_reqPri : in std_logic_vector(0 to 1);
      SPLB2_PLB_TAttribute : in std_logic_vector(0 to 15);
      SPLB2_PLB_rdBurst : in std_logic;
      SPLB2_PLB_wrBurst : in std_logic;
      SPLB2_PLB_wrDBus : in std_logic_vector(0 to 63);
      SPLB2_Sl_addrAck : out std_logic;
      SPLB2_Sl_SSize : out std_logic_vector(0 to 1);
      SPLB2_Sl_wait : out std_logic;
      SPLB2_Sl_rearbitrate : out std_logic;
      SPLB2_Sl_wrDAck : out std_logic;
      SPLB2_Sl_wrComp : out std_logic;
      SPLB2_Sl_wrBTerm : out std_logic;
      SPLB2_Sl_rdDBus : out std_logic_vector(0 to 63);
      SPLB2_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SPLB2_Sl_rdDAck : out std_logic;
      SPLB2_Sl_rdComp : out std_logic;
      SPLB2_Sl_rdBTerm : out std_logic;
      SPLB2_Sl_MBusy : out std_logic_vector(0 to 0);
      SPLB2_Sl_MRdErr : out std_logic_vector(0 to 0);
      SPLB2_Sl_MWrErr : out std_logic_vector(0 to 0);
      SPLB2_Sl_MIRQ : out std_logic_vector(0 to 0);
      SDMA2_Clk : in std_logic;
      SDMA2_Rx_IntOut : out std_logic;
      SDMA2_Tx_IntOut : out std_logic;
      SDMA2_RstOut : out std_logic;
      SDMA2_TX_D : out std_logic_vector(0 to 31);
      SDMA2_TX_Rem : out std_logic_vector(0 to 3);
      SDMA2_TX_SOF : out std_logic;
      SDMA2_TX_EOF : out std_logic;
      SDMA2_TX_SOP : out std_logic;
      SDMA2_TX_EOP : out std_logic;
      SDMA2_TX_Src_Rdy : out std_logic;
      SDMA2_TX_Dst_Rdy : in std_logic;
      SDMA2_RX_D : in std_logic_vector(0 to 31);
      SDMA2_RX_Rem : in std_logic_vector(0 to 3);
      SDMA2_RX_SOF : in std_logic;
      SDMA2_RX_EOF : in std_logic;
      SDMA2_RX_SOP : in std_logic;
      SDMA2_RX_EOP : in std_logic;
      SDMA2_RX_Src_Rdy : in std_logic;
      SDMA2_RX_Dst_Rdy : out std_logic;
      SDMA_CTRL2_Clk : in std_logic;
      SDMA_CTRL2_Rst : in std_logic;
      SDMA_CTRL2_PLB_ABus : in std_logic_vector(0 to 31);
      SDMA_CTRL2_PLB_PAValid : in std_logic;
      SDMA_CTRL2_PLB_SAValid : in std_logic;
      SDMA_CTRL2_PLB_masterID : in std_logic_vector(0 to 0);
      SDMA_CTRL2_PLB_RNW : in std_logic;
      SDMA_CTRL2_PLB_BE : in std_logic_vector(0 to 7);
      SDMA_CTRL2_PLB_UABus : in std_logic_vector(0 to 31);
      SDMA_CTRL2_PLB_rdPrim : in std_logic;
      SDMA_CTRL2_PLB_wrPrim : in std_logic;
      SDMA_CTRL2_PLB_abort : in std_logic;
      SDMA_CTRL2_PLB_busLock : in std_logic;
      SDMA_CTRL2_PLB_MSize : in std_logic_vector(0 to 1);
      SDMA_CTRL2_PLB_size : in std_logic_vector(0 to 3);
      SDMA_CTRL2_PLB_type : in std_logic_vector(0 to 2);
      SDMA_CTRL2_PLB_lockErr : in std_logic;
      SDMA_CTRL2_PLB_wrPendReq : in std_logic;
      SDMA_CTRL2_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL2_PLB_rdPendReq : in std_logic;
      SDMA_CTRL2_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL2_PLB_reqPri : in std_logic_vector(0 to 1);
      SDMA_CTRL2_PLB_TAttribute : in std_logic_vector(0 to 15);
      SDMA_CTRL2_PLB_rdBurst : in std_logic;
      SDMA_CTRL2_PLB_wrBurst : in std_logic;
      SDMA_CTRL2_PLB_wrDBus : in std_logic_vector(0 to 63);
      SDMA_CTRL2_Sl_addrAck : out std_logic;
      SDMA_CTRL2_Sl_SSize : out std_logic_vector(0 to 1);
      SDMA_CTRL2_Sl_wait : out std_logic;
      SDMA_CTRL2_Sl_rearbitrate : out std_logic;
      SDMA_CTRL2_Sl_wrDAck : out std_logic;
      SDMA_CTRL2_Sl_wrComp : out std_logic;
      SDMA_CTRL2_Sl_wrBTerm : out std_logic;
      SDMA_CTRL2_Sl_rdDBus : out std_logic_vector(0 to 63);
      SDMA_CTRL2_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SDMA_CTRL2_Sl_rdDAck : out std_logic;
      SDMA_CTRL2_Sl_rdComp : out std_logic;
      SDMA_CTRL2_Sl_rdBTerm : out std_logic;
      SDMA_CTRL2_Sl_MBusy : out std_logic_vector(0 to 0);
      SDMA_CTRL2_Sl_MRdErr : out std_logic_vector(0 to 0);
      SDMA_CTRL2_Sl_MWrErr : out std_logic_vector(0 to 0);
      SDMA_CTRL2_Sl_MIRQ : out std_logic_vector(0 to 0);
      PIM2_Addr : in std_logic_vector(31 downto 0);
      PIM2_AddrReq : in std_logic;
      PIM2_AddrAck : out std_logic;
      PIM2_RNW : in std_logic;
      PIM2_Size : in std_logic_vector(3 downto 0);
      PIM2_RdModWr : in std_logic;
      PIM2_WrFIFO_Data : in std_logic_vector(63 downto 0);
      PIM2_WrFIFO_BE : in std_logic_vector(7 downto 0);
      PIM2_WrFIFO_Push : in std_logic;
      PIM2_RdFIFO_Data : out std_logic_vector(63 downto 0);
      PIM2_RdFIFO_Pop : in std_logic;
      PIM2_RdFIFO_RdWdAddr : out std_logic_vector(3 downto 0);
      PIM2_WrFIFO_Empty : out std_logic;
      PIM2_WrFIFO_AlmostFull : out std_logic;
      PIM2_WrFIFO_Flush : in std_logic;
      PIM2_RdFIFO_Empty : out std_logic;
      PIM2_RdFIFO_Flush : in std_logic;
      PIM2_RdFIFO_Latency : out std_logic_vector(1 downto 0);
      PIM2_InitDone : out std_logic;
      PPC440MC2_MIMCReadNotWrite : in std_logic;
      PPC440MC2_MIMCAddress : in std_logic_vector(0 to 35);
      PPC440MC2_MIMCAddressValid : in std_logic;
      PPC440MC2_MIMCWriteData : in std_logic_vector(0 to 127);
      PPC440MC2_MIMCWriteDataValid : in std_logic;
      PPC440MC2_MIMCByteEnable : in std_logic_vector(0 to 15);
      PPC440MC2_MIMCBankConflict : in std_logic;
      PPC440MC2_MIMCRowConflict : in std_logic;
      PPC440MC2_MCMIReadData : out std_logic_vector(0 to 127);
      PPC440MC2_MCMIReadDataValid : out std_logic;
      PPC440MC2_MCMIReadDataErr : out std_logic;
      PPC440MC2_MCMIAddrReadyToAccept : out std_logic;
      VFBC2_Cmd_Clk : in std_logic;
      VFBC2_Cmd_Reset : in std_logic;
      VFBC2_Cmd_Data : in std_logic_vector(31 downto 0);
      VFBC2_Cmd_Write : in std_logic;
      VFBC2_Cmd_End : in std_logic;
      VFBC2_Cmd_Full : out std_logic;
      VFBC2_Cmd_Almost_Full : out std_logic;
      VFBC2_Cmd_Idle : out std_logic;
      VFBC2_Wd_Clk : in std_logic;
      VFBC2_Wd_Reset : in std_logic;
      VFBC2_Wd_Write : in std_logic;
      VFBC2_Wd_End_Burst : in std_logic;
      VFBC2_Wd_Flush : in std_logic;
      VFBC2_Wd_Data : in std_logic_vector(31 downto 0);
      VFBC2_Wd_Data_BE : in std_logic_vector(3 downto 0);
      VFBC2_Wd_Full : out std_logic;
      VFBC2_Wd_Almost_Full : out std_logic;
      VFBC2_Rd_Clk : in std_logic;
      VFBC2_Rd_Reset : in std_logic;
      VFBC2_Rd_Read : in std_logic;
      VFBC2_Rd_End_Burst : in std_logic;
      VFBC2_Rd_Flush : in std_logic;
      VFBC2_Rd_Data : out std_logic_vector(31 downto 0);
      VFBC2_Rd_Empty : out std_logic;
      VFBC2_Rd_Almost_Empty : out std_logic;
      FSL3_M_Clk : in std_logic;
      FSL3_M_Write : in std_logic;
      FSL3_M_Data : in std_logic_vector(0 to 31);
      FSL3_M_Control : in std_logic;
      FSL3_M_Full : out std_logic;
      FSL3_S_Clk : in std_logic;
      FSL3_S_Read : in std_logic;
      FSL3_S_Data : out std_logic_vector(0 to 31);
      FSL3_S_Control : out std_logic;
      FSL3_S_Exists : out std_logic;
      SPLB3_Clk : in std_logic;
      SPLB3_Rst : in std_logic;
      SPLB3_PLB_ABus : in std_logic_vector(0 to 31);
      SPLB3_PLB_PAValid : in std_logic;
      SPLB3_PLB_SAValid : in std_logic;
      SPLB3_PLB_masterID : in std_logic_vector(0 to 0);
      SPLB3_PLB_RNW : in std_logic;
      SPLB3_PLB_BE : in std_logic_vector(0 to 7);
      SPLB3_PLB_UABus : in std_logic_vector(0 to 31);
      SPLB3_PLB_rdPrim : in std_logic;
      SPLB3_PLB_wrPrim : in std_logic;
      SPLB3_PLB_abort : in std_logic;
      SPLB3_PLB_busLock : in std_logic;
      SPLB3_PLB_MSize : in std_logic_vector(0 to 1);
      SPLB3_PLB_size : in std_logic_vector(0 to 3);
      SPLB3_PLB_type : in std_logic_vector(0 to 2);
      SPLB3_PLB_lockErr : in std_logic;
      SPLB3_PLB_wrPendReq : in std_logic;
      SPLB3_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SPLB3_PLB_rdPendReq : in std_logic;
      SPLB3_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SPLB3_PLB_reqPri : in std_logic_vector(0 to 1);
      SPLB3_PLB_TAttribute : in std_logic_vector(0 to 15);
      SPLB3_PLB_rdBurst : in std_logic;
      SPLB3_PLB_wrBurst : in std_logic;
      SPLB3_PLB_wrDBus : in std_logic_vector(0 to 63);
      SPLB3_Sl_addrAck : out std_logic;
      SPLB3_Sl_SSize : out std_logic_vector(0 to 1);
      SPLB3_Sl_wait : out std_logic;
      SPLB3_Sl_rearbitrate : out std_logic;
      SPLB3_Sl_wrDAck : out std_logic;
      SPLB3_Sl_wrComp : out std_logic;
      SPLB3_Sl_wrBTerm : out std_logic;
      SPLB3_Sl_rdDBus : out std_logic_vector(0 to 63);
      SPLB3_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SPLB3_Sl_rdDAck : out std_logic;
      SPLB3_Sl_rdComp : out std_logic;
      SPLB3_Sl_rdBTerm : out std_logic;
      SPLB3_Sl_MBusy : out std_logic_vector(0 to 0);
      SPLB3_Sl_MRdErr : out std_logic_vector(0 to 0);
      SPLB3_Sl_MWrErr : out std_logic_vector(0 to 0);
      SPLB3_Sl_MIRQ : out std_logic_vector(0 to 0);
      SDMA3_Clk : in std_logic;
      SDMA3_Rx_IntOut : out std_logic;
      SDMA3_Tx_IntOut : out std_logic;
      SDMA3_RstOut : out std_logic;
      SDMA3_TX_D : out std_logic_vector(0 to 31);
      SDMA3_TX_Rem : out std_logic_vector(0 to 3);
      SDMA3_TX_SOF : out std_logic;
      SDMA3_TX_EOF : out std_logic;
      SDMA3_TX_SOP : out std_logic;
      SDMA3_TX_EOP : out std_logic;
      SDMA3_TX_Src_Rdy : out std_logic;
      SDMA3_TX_Dst_Rdy : in std_logic;
      SDMA3_RX_D : in std_logic_vector(0 to 31);
      SDMA3_RX_Rem : in std_logic_vector(0 to 3);
      SDMA3_RX_SOF : in std_logic;
      SDMA3_RX_EOF : in std_logic;
      SDMA3_RX_SOP : in std_logic;
      SDMA3_RX_EOP : in std_logic;
      SDMA3_RX_Src_Rdy : in std_logic;
      SDMA3_RX_Dst_Rdy : out std_logic;
      SDMA_CTRL3_Clk : in std_logic;
      SDMA_CTRL3_Rst : in std_logic;
      SDMA_CTRL3_PLB_ABus : in std_logic_vector(0 to 31);
      SDMA_CTRL3_PLB_PAValid : in std_logic;
      SDMA_CTRL3_PLB_SAValid : in std_logic;
      SDMA_CTRL3_PLB_masterID : in std_logic_vector(0 to 0);
      SDMA_CTRL3_PLB_RNW : in std_logic;
      SDMA_CTRL3_PLB_BE : in std_logic_vector(0 to 7);
      SDMA_CTRL3_PLB_UABus : in std_logic_vector(0 to 31);
      SDMA_CTRL3_PLB_rdPrim : in std_logic;
      SDMA_CTRL3_PLB_wrPrim : in std_logic;
      SDMA_CTRL3_PLB_abort : in std_logic;
      SDMA_CTRL3_PLB_busLock : in std_logic;
      SDMA_CTRL3_PLB_MSize : in std_logic_vector(0 to 1);
      SDMA_CTRL3_PLB_size : in std_logic_vector(0 to 3);
      SDMA_CTRL3_PLB_type : in std_logic_vector(0 to 2);
      SDMA_CTRL3_PLB_lockErr : in std_logic;
      SDMA_CTRL3_PLB_wrPendReq : in std_logic;
      SDMA_CTRL3_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL3_PLB_rdPendReq : in std_logic;
      SDMA_CTRL3_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL3_PLB_reqPri : in std_logic_vector(0 to 1);
      SDMA_CTRL3_PLB_TAttribute : in std_logic_vector(0 to 15);
      SDMA_CTRL3_PLB_rdBurst : in std_logic;
      SDMA_CTRL3_PLB_wrBurst : in std_logic;
      SDMA_CTRL3_PLB_wrDBus : in std_logic_vector(0 to 63);
      SDMA_CTRL3_Sl_addrAck : out std_logic;
      SDMA_CTRL3_Sl_SSize : out std_logic_vector(0 to 1);
      SDMA_CTRL3_Sl_wait : out std_logic;
      SDMA_CTRL3_Sl_rearbitrate : out std_logic;
      SDMA_CTRL3_Sl_wrDAck : out std_logic;
      SDMA_CTRL3_Sl_wrComp : out std_logic;
      SDMA_CTRL3_Sl_wrBTerm : out std_logic;
      SDMA_CTRL3_Sl_rdDBus : out std_logic_vector(0 to 63);
      SDMA_CTRL3_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SDMA_CTRL3_Sl_rdDAck : out std_logic;
      SDMA_CTRL3_Sl_rdComp : out std_logic;
      SDMA_CTRL3_Sl_rdBTerm : out std_logic;
      SDMA_CTRL3_Sl_MBusy : out std_logic_vector(0 to 0);
      SDMA_CTRL3_Sl_MRdErr : out std_logic_vector(0 to 0);
      SDMA_CTRL3_Sl_MWrErr : out std_logic_vector(0 to 0);
      SDMA_CTRL3_Sl_MIRQ : out std_logic_vector(0 to 0);
      PIM3_Addr : in std_logic_vector(31 downto 0);
      PIM3_AddrReq : in std_logic;
      PIM3_AddrAck : out std_logic;
      PIM3_RNW : in std_logic;
      PIM3_Size : in std_logic_vector(3 downto 0);
      PIM3_RdModWr : in std_logic;
      PIM3_WrFIFO_Data : in std_logic_vector(63 downto 0);
      PIM3_WrFIFO_BE : in std_logic_vector(7 downto 0);
      PIM3_WrFIFO_Push : in std_logic;
      PIM3_RdFIFO_Data : out std_logic_vector(63 downto 0);
      PIM3_RdFIFO_Pop : in std_logic;
      PIM3_RdFIFO_RdWdAddr : out std_logic_vector(3 downto 0);
      PIM3_WrFIFO_Empty : out std_logic;
      PIM3_WrFIFO_AlmostFull : out std_logic;
      PIM3_WrFIFO_Flush : in std_logic;
      PIM3_RdFIFO_Empty : out std_logic;
      PIM3_RdFIFO_Flush : in std_logic;
      PIM3_RdFIFO_Latency : out std_logic_vector(1 downto 0);
      PIM3_InitDone : out std_logic;
      PPC440MC3_MIMCReadNotWrite : in std_logic;
      PPC440MC3_MIMCAddress : in std_logic_vector(0 to 35);
      PPC440MC3_MIMCAddressValid : in std_logic;
      PPC440MC3_MIMCWriteData : in std_logic_vector(0 to 127);
      PPC440MC3_MIMCWriteDataValid : in std_logic;
      PPC440MC3_MIMCByteEnable : in std_logic_vector(0 to 15);
      PPC440MC3_MIMCBankConflict : in std_logic;
      PPC440MC3_MIMCRowConflict : in std_logic;
      PPC440MC3_MCMIReadData : out std_logic_vector(0 to 127);
      PPC440MC3_MCMIReadDataValid : out std_logic;
      PPC440MC3_MCMIReadDataErr : out std_logic;
      PPC440MC3_MCMIAddrReadyToAccept : out std_logic;
      VFBC3_Cmd_Clk : in std_logic;
      VFBC3_Cmd_Reset : in std_logic;
      VFBC3_Cmd_Data : in std_logic_vector(31 downto 0);
      VFBC3_Cmd_Write : in std_logic;
      VFBC3_Cmd_End : in std_logic;
      VFBC3_Cmd_Full : out std_logic;
      VFBC3_Cmd_Almost_Full : out std_logic;
      VFBC3_Cmd_Idle : out std_logic;
      VFBC3_Wd_Clk : in std_logic;
      VFBC3_Wd_Reset : in std_logic;
      VFBC3_Wd_Write : in std_logic;
      VFBC3_Wd_End_Burst : in std_logic;
      VFBC3_Wd_Flush : in std_logic;
      VFBC3_Wd_Data : in std_logic_vector(31 downto 0);
      VFBC3_Wd_Data_BE : in std_logic_vector(3 downto 0);
      VFBC3_Wd_Full : out std_logic;
      VFBC3_Wd_Almost_Full : out std_logic;
      VFBC3_Rd_Clk : in std_logic;
      VFBC3_Rd_Reset : in std_logic;
      VFBC3_Rd_Read : in std_logic;
      VFBC3_Rd_End_Burst : in std_logic;
      VFBC3_Rd_Flush : in std_logic;
      VFBC3_Rd_Data : out std_logic_vector(31 downto 0);
      VFBC3_Rd_Empty : out std_logic;
      VFBC3_Rd_Almost_Empty : out std_logic;
      FSL4_M_Clk : in std_logic;
      FSL4_M_Write : in std_logic;
      FSL4_M_Data : in std_logic_vector(0 to 31);
      FSL4_M_Control : in std_logic;
      FSL4_M_Full : out std_logic;
      FSL4_S_Clk : in std_logic;
      FSL4_S_Read : in std_logic;
      FSL4_S_Data : out std_logic_vector(0 to 31);
      FSL4_S_Control : out std_logic;
      FSL4_S_Exists : out std_logic;
      SPLB4_Clk : in std_logic;
      SPLB4_Rst : in std_logic;
      SPLB4_PLB_ABus : in std_logic_vector(0 to 31);
      SPLB4_PLB_PAValid : in std_logic;
      SPLB4_PLB_SAValid : in std_logic;
      SPLB4_PLB_masterID : in std_logic_vector(0 to 0);
      SPLB4_PLB_RNW : in std_logic;
      SPLB4_PLB_BE : in std_logic_vector(0 to 7);
      SPLB4_PLB_UABus : in std_logic_vector(0 to 31);
      SPLB4_PLB_rdPrim : in std_logic;
      SPLB4_PLB_wrPrim : in std_logic;
      SPLB4_PLB_abort : in std_logic;
      SPLB4_PLB_busLock : in std_logic;
      SPLB4_PLB_MSize : in std_logic_vector(0 to 1);
      SPLB4_PLB_size : in std_logic_vector(0 to 3);
      SPLB4_PLB_type : in std_logic_vector(0 to 2);
      SPLB4_PLB_lockErr : in std_logic;
      SPLB4_PLB_wrPendReq : in std_logic;
      SPLB4_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SPLB4_PLB_rdPendReq : in std_logic;
      SPLB4_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SPLB4_PLB_reqPri : in std_logic_vector(0 to 1);
      SPLB4_PLB_TAttribute : in std_logic_vector(0 to 15);
      SPLB4_PLB_rdBurst : in std_logic;
      SPLB4_PLB_wrBurst : in std_logic;
      SPLB4_PLB_wrDBus : in std_logic_vector(0 to 63);
      SPLB4_Sl_addrAck : out std_logic;
      SPLB4_Sl_SSize : out std_logic_vector(0 to 1);
      SPLB4_Sl_wait : out std_logic;
      SPLB4_Sl_rearbitrate : out std_logic;
      SPLB4_Sl_wrDAck : out std_logic;
      SPLB4_Sl_wrComp : out std_logic;
      SPLB4_Sl_wrBTerm : out std_logic;
      SPLB4_Sl_rdDBus : out std_logic_vector(0 to 63);
      SPLB4_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SPLB4_Sl_rdDAck : out std_logic;
      SPLB4_Sl_rdComp : out std_logic;
      SPLB4_Sl_rdBTerm : out std_logic;
      SPLB4_Sl_MBusy : out std_logic_vector(0 to 0);
      SPLB4_Sl_MRdErr : out std_logic_vector(0 to 0);
      SPLB4_Sl_MWrErr : out std_logic_vector(0 to 0);
      SPLB4_Sl_MIRQ : out std_logic_vector(0 to 0);
      SDMA4_Clk : in std_logic;
      SDMA4_Rx_IntOut : out std_logic;
      SDMA4_Tx_IntOut : out std_logic;
      SDMA4_RstOut : out std_logic;
      SDMA4_TX_D : out std_logic_vector(0 to 31);
      SDMA4_TX_Rem : out std_logic_vector(0 to 3);
      SDMA4_TX_SOF : out std_logic;
      SDMA4_TX_EOF : out std_logic;
      SDMA4_TX_SOP : out std_logic;
      SDMA4_TX_EOP : out std_logic;
      SDMA4_TX_Src_Rdy : out std_logic;
      SDMA4_TX_Dst_Rdy : in std_logic;
      SDMA4_RX_D : in std_logic_vector(0 to 31);
      SDMA4_RX_Rem : in std_logic_vector(0 to 3);
      SDMA4_RX_SOF : in std_logic;
      SDMA4_RX_EOF : in std_logic;
      SDMA4_RX_SOP : in std_logic;
      SDMA4_RX_EOP : in std_logic;
      SDMA4_RX_Src_Rdy : in std_logic;
      SDMA4_RX_Dst_Rdy : out std_logic;
      SDMA_CTRL4_Clk : in std_logic;
      SDMA_CTRL4_Rst : in std_logic;
      SDMA_CTRL4_PLB_ABus : in std_logic_vector(0 to 31);
      SDMA_CTRL4_PLB_PAValid : in std_logic;
      SDMA_CTRL4_PLB_SAValid : in std_logic;
      SDMA_CTRL4_PLB_masterID : in std_logic_vector(0 to 0);
      SDMA_CTRL4_PLB_RNW : in std_logic;
      SDMA_CTRL4_PLB_BE : in std_logic_vector(0 to 7);
      SDMA_CTRL4_PLB_UABus : in std_logic_vector(0 to 31);
      SDMA_CTRL4_PLB_rdPrim : in std_logic;
      SDMA_CTRL4_PLB_wrPrim : in std_logic;
      SDMA_CTRL4_PLB_abort : in std_logic;
      SDMA_CTRL4_PLB_busLock : in std_logic;
      SDMA_CTRL4_PLB_MSize : in std_logic_vector(0 to 1);
      SDMA_CTRL4_PLB_size : in std_logic_vector(0 to 3);
      SDMA_CTRL4_PLB_type : in std_logic_vector(0 to 2);
      SDMA_CTRL4_PLB_lockErr : in std_logic;
      SDMA_CTRL4_PLB_wrPendReq : in std_logic;
      SDMA_CTRL4_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL4_PLB_rdPendReq : in std_logic;
      SDMA_CTRL4_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL4_PLB_reqPri : in std_logic_vector(0 to 1);
      SDMA_CTRL4_PLB_TAttribute : in std_logic_vector(0 to 15);
      SDMA_CTRL4_PLB_rdBurst : in std_logic;
      SDMA_CTRL4_PLB_wrBurst : in std_logic;
      SDMA_CTRL4_PLB_wrDBus : in std_logic_vector(0 to 63);
      SDMA_CTRL4_Sl_addrAck : out std_logic;
      SDMA_CTRL4_Sl_SSize : out std_logic_vector(0 to 1);
      SDMA_CTRL4_Sl_wait : out std_logic;
      SDMA_CTRL4_Sl_rearbitrate : out std_logic;
      SDMA_CTRL4_Sl_wrDAck : out std_logic;
      SDMA_CTRL4_Sl_wrComp : out std_logic;
      SDMA_CTRL4_Sl_wrBTerm : out std_logic;
      SDMA_CTRL4_Sl_rdDBus : out std_logic_vector(0 to 63);
      SDMA_CTRL4_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SDMA_CTRL4_Sl_rdDAck : out std_logic;
      SDMA_CTRL4_Sl_rdComp : out std_logic;
      SDMA_CTRL4_Sl_rdBTerm : out std_logic;
      SDMA_CTRL4_Sl_MBusy : out std_logic_vector(0 to 0);
      SDMA_CTRL4_Sl_MRdErr : out std_logic_vector(0 to 0);
      SDMA_CTRL4_Sl_MWrErr : out std_logic_vector(0 to 0);
      SDMA_CTRL4_Sl_MIRQ : out std_logic_vector(0 to 0);
      PIM4_Addr : in std_logic_vector(31 downto 0);
      PIM4_AddrReq : in std_logic;
      PIM4_AddrAck : out std_logic;
      PIM4_RNW : in std_logic;
      PIM4_Size : in std_logic_vector(3 downto 0);
      PIM4_RdModWr : in std_logic;
      PIM4_WrFIFO_Data : in std_logic_vector(63 downto 0);
      PIM4_WrFIFO_BE : in std_logic_vector(7 downto 0);
      PIM4_WrFIFO_Push : in std_logic;
      PIM4_RdFIFO_Data : out std_logic_vector(63 downto 0);
      PIM4_RdFIFO_Pop : in std_logic;
      PIM4_RdFIFO_RdWdAddr : out std_logic_vector(3 downto 0);
      PIM4_WrFIFO_Empty : out std_logic;
      PIM4_WrFIFO_AlmostFull : out std_logic;
      PIM4_WrFIFO_Flush : in std_logic;
      PIM4_RdFIFO_Empty : out std_logic;
      PIM4_RdFIFO_Flush : in std_logic;
      PIM4_RdFIFO_Latency : out std_logic_vector(1 downto 0);
      PIM4_InitDone : out std_logic;
      PPC440MC4_MIMCReadNotWrite : in std_logic;
      PPC440MC4_MIMCAddress : in std_logic_vector(0 to 35);
      PPC440MC4_MIMCAddressValid : in std_logic;
      PPC440MC4_MIMCWriteData : in std_logic_vector(0 to 127);
      PPC440MC4_MIMCWriteDataValid : in std_logic;
      PPC440MC4_MIMCByteEnable : in std_logic_vector(0 to 15);
      PPC440MC4_MIMCBankConflict : in std_logic;
      PPC440MC4_MIMCRowConflict : in std_logic;
      PPC440MC4_MCMIReadData : out std_logic_vector(0 to 127);
      PPC440MC4_MCMIReadDataValid : out std_logic;
      PPC440MC4_MCMIReadDataErr : out std_logic;
      PPC440MC4_MCMIAddrReadyToAccept : out std_logic;
      VFBC4_Cmd_Clk : in std_logic;
      VFBC4_Cmd_Reset : in std_logic;
      VFBC4_Cmd_Data : in std_logic_vector(31 downto 0);
      VFBC4_Cmd_Write : in std_logic;
      VFBC4_Cmd_End : in std_logic;
      VFBC4_Cmd_Full : out std_logic;
      VFBC4_Cmd_Almost_Full : out std_logic;
      VFBC4_Cmd_Idle : out std_logic;
      VFBC4_Wd_Clk : in std_logic;
      VFBC4_Wd_Reset : in std_logic;
      VFBC4_Wd_Write : in std_logic;
      VFBC4_Wd_End_Burst : in std_logic;
      VFBC4_Wd_Flush : in std_logic;
      VFBC4_Wd_Data : in std_logic_vector(31 downto 0);
      VFBC4_Wd_Data_BE : in std_logic_vector(3 downto 0);
      VFBC4_Wd_Full : out std_logic;
      VFBC4_Wd_Almost_Full : out std_logic;
      VFBC4_Rd_Clk : in std_logic;
      VFBC4_Rd_Reset : in std_logic;
      VFBC4_Rd_Read : in std_logic;
      VFBC4_Rd_End_Burst : in std_logic;
      VFBC4_Rd_Flush : in std_logic;
      VFBC4_Rd_Data : out std_logic_vector(31 downto 0);
      VFBC4_Rd_Empty : out std_logic;
      VFBC4_Rd_Almost_Empty : out std_logic;
      FSL5_M_Clk : in std_logic;
      FSL5_M_Write : in std_logic;
      FSL5_M_Data : in std_logic_vector(0 to 31);
      FSL5_M_Control : in std_logic;
      FSL5_M_Full : out std_logic;
      FSL5_S_Clk : in std_logic;
      FSL5_S_Read : in std_logic;
      FSL5_S_Data : out std_logic_vector(0 to 31);
      FSL5_S_Control : out std_logic;
      FSL5_S_Exists : out std_logic;
      SPLB5_Clk : in std_logic;
      SPLB5_Rst : in std_logic;
      SPLB5_PLB_ABus : in std_logic_vector(0 to 31);
      SPLB5_PLB_PAValid : in std_logic;
      SPLB5_PLB_SAValid : in std_logic;
      SPLB5_PLB_masterID : in std_logic_vector(0 to 0);
      SPLB5_PLB_RNW : in std_logic;
      SPLB5_PLB_BE : in std_logic_vector(0 to 7);
      SPLB5_PLB_UABus : in std_logic_vector(0 to 31);
      SPLB5_PLB_rdPrim : in std_logic;
      SPLB5_PLB_wrPrim : in std_logic;
      SPLB5_PLB_abort : in std_logic;
      SPLB5_PLB_busLock : in std_logic;
      SPLB5_PLB_MSize : in std_logic_vector(0 to 1);
      SPLB5_PLB_size : in std_logic_vector(0 to 3);
      SPLB5_PLB_type : in std_logic_vector(0 to 2);
      SPLB5_PLB_lockErr : in std_logic;
      SPLB5_PLB_wrPendReq : in std_logic;
      SPLB5_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SPLB5_PLB_rdPendReq : in std_logic;
      SPLB5_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SPLB5_PLB_reqPri : in std_logic_vector(0 to 1);
      SPLB5_PLB_TAttribute : in std_logic_vector(0 to 15);
      SPLB5_PLB_rdBurst : in std_logic;
      SPLB5_PLB_wrBurst : in std_logic;
      SPLB5_PLB_wrDBus : in std_logic_vector(0 to 63);
      SPLB5_Sl_addrAck : out std_logic;
      SPLB5_Sl_SSize : out std_logic_vector(0 to 1);
      SPLB5_Sl_wait : out std_logic;
      SPLB5_Sl_rearbitrate : out std_logic;
      SPLB5_Sl_wrDAck : out std_logic;
      SPLB5_Sl_wrComp : out std_logic;
      SPLB5_Sl_wrBTerm : out std_logic;
      SPLB5_Sl_rdDBus : out std_logic_vector(0 to 63);
      SPLB5_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SPLB5_Sl_rdDAck : out std_logic;
      SPLB5_Sl_rdComp : out std_logic;
      SPLB5_Sl_rdBTerm : out std_logic;
      SPLB5_Sl_MBusy : out std_logic_vector(0 to 0);
      SPLB5_Sl_MRdErr : out std_logic_vector(0 to 0);
      SPLB5_Sl_MWrErr : out std_logic_vector(0 to 0);
      SPLB5_Sl_MIRQ : out std_logic_vector(0 to 0);
      SDMA5_Clk : in std_logic;
      SDMA5_Rx_IntOut : out std_logic;
      SDMA5_Tx_IntOut : out std_logic;
      SDMA5_RstOut : out std_logic;
      SDMA5_TX_D : out std_logic_vector(0 to 31);
      SDMA5_TX_Rem : out std_logic_vector(0 to 3);
      SDMA5_TX_SOF : out std_logic;
      SDMA5_TX_EOF : out std_logic;
      SDMA5_TX_SOP : out std_logic;
      SDMA5_TX_EOP : out std_logic;
      SDMA5_TX_Src_Rdy : out std_logic;
      SDMA5_TX_Dst_Rdy : in std_logic;
      SDMA5_RX_D : in std_logic_vector(0 to 31);
      SDMA5_RX_Rem : in std_logic_vector(0 to 3);
      SDMA5_RX_SOF : in std_logic;
      SDMA5_RX_EOF : in std_logic;
      SDMA5_RX_SOP : in std_logic;
      SDMA5_RX_EOP : in std_logic;
      SDMA5_RX_Src_Rdy : in std_logic;
      SDMA5_RX_Dst_Rdy : out std_logic;
      SDMA_CTRL5_Clk : in std_logic;
      SDMA_CTRL5_Rst : in std_logic;
      SDMA_CTRL5_PLB_ABus : in std_logic_vector(0 to 31);
      SDMA_CTRL5_PLB_PAValid : in std_logic;
      SDMA_CTRL5_PLB_SAValid : in std_logic;
      SDMA_CTRL5_PLB_masterID : in std_logic_vector(0 to 0);
      SDMA_CTRL5_PLB_RNW : in std_logic;
      SDMA_CTRL5_PLB_BE : in std_logic_vector(0 to 7);
      SDMA_CTRL5_PLB_UABus : in std_logic_vector(0 to 31);
      SDMA_CTRL5_PLB_rdPrim : in std_logic;
      SDMA_CTRL5_PLB_wrPrim : in std_logic;
      SDMA_CTRL5_PLB_abort : in std_logic;
      SDMA_CTRL5_PLB_busLock : in std_logic;
      SDMA_CTRL5_PLB_MSize : in std_logic_vector(0 to 1);
      SDMA_CTRL5_PLB_size : in std_logic_vector(0 to 3);
      SDMA_CTRL5_PLB_type : in std_logic_vector(0 to 2);
      SDMA_CTRL5_PLB_lockErr : in std_logic;
      SDMA_CTRL5_PLB_wrPendReq : in std_logic;
      SDMA_CTRL5_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL5_PLB_rdPendReq : in std_logic;
      SDMA_CTRL5_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL5_PLB_reqPri : in std_logic_vector(0 to 1);
      SDMA_CTRL5_PLB_TAttribute : in std_logic_vector(0 to 15);
      SDMA_CTRL5_PLB_rdBurst : in std_logic;
      SDMA_CTRL5_PLB_wrBurst : in std_logic;
      SDMA_CTRL5_PLB_wrDBus : in std_logic_vector(0 to 63);
      SDMA_CTRL5_Sl_addrAck : out std_logic;
      SDMA_CTRL5_Sl_SSize : out std_logic_vector(0 to 1);
      SDMA_CTRL5_Sl_wait : out std_logic;
      SDMA_CTRL5_Sl_rearbitrate : out std_logic;
      SDMA_CTRL5_Sl_wrDAck : out std_logic;
      SDMA_CTRL5_Sl_wrComp : out std_logic;
      SDMA_CTRL5_Sl_wrBTerm : out std_logic;
      SDMA_CTRL5_Sl_rdDBus : out std_logic_vector(0 to 63);
      SDMA_CTRL5_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SDMA_CTRL5_Sl_rdDAck : out std_logic;
      SDMA_CTRL5_Sl_rdComp : out std_logic;
      SDMA_CTRL5_Sl_rdBTerm : out std_logic;
      SDMA_CTRL5_Sl_MBusy : out std_logic_vector(0 to 0);
      SDMA_CTRL5_Sl_MRdErr : out std_logic_vector(0 to 0);
      SDMA_CTRL5_Sl_MWrErr : out std_logic_vector(0 to 0);
      SDMA_CTRL5_Sl_MIRQ : out std_logic_vector(0 to 0);
      PIM5_Addr : in std_logic_vector(31 downto 0);
      PIM5_AddrReq : in std_logic;
      PIM5_AddrAck : out std_logic;
      PIM5_RNW : in std_logic;
      PIM5_Size : in std_logic_vector(3 downto 0);
      PIM5_RdModWr : in std_logic;
      PIM5_WrFIFO_Data : in std_logic_vector(63 downto 0);
      PIM5_WrFIFO_BE : in std_logic_vector(7 downto 0);
      PIM5_WrFIFO_Push : in std_logic;
      PIM5_RdFIFO_Data : out std_logic_vector(63 downto 0);
      PIM5_RdFIFO_Pop : in std_logic;
      PIM5_RdFIFO_RdWdAddr : out std_logic_vector(3 downto 0);
      PIM5_WrFIFO_Empty : out std_logic;
      PIM5_WrFIFO_AlmostFull : out std_logic;
      PIM5_WrFIFO_Flush : in std_logic;
      PIM5_RdFIFO_Empty : out std_logic;
      PIM5_RdFIFO_Flush : in std_logic;
      PIM5_RdFIFO_Latency : out std_logic_vector(1 downto 0);
      PIM5_InitDone : out std_logic;
      PPC440MC5_MIMCReadNotWrite : in std_logic;
      PPC440MC5_MIMCAddress : in std_logic_vector(0 to 35);
      PPC440MC5_MIMCAddressValid : in std_logic;
      PPC440MC5_MIMCWriteData : in std_logic_vector(0 to 127);
      PPC440MC5_MIMCWriteDataValid : in std_logic;
      PPC440MC5_MIMCByteEnable : in std_logic_vector(0 to 15);
      PPC440MC5_MIMCBankConflict : in std_logic;
      PPC440MC5_MIMCRowConflict : in std_logic;
      PPC440MC5_MCMIReadData : out std_logic_vector(0 to 127);
      PPC440MC5_MCMIReadDataValid : out std_logic;
      PPC440MC5_MCMIReadDataErr : out std_logic;
      PPC440MC5_MCMIAddrReadyToAccept : out std_logic;
      VFBC5_Cmd_Clk : in std_logic;
      VFBC5_Cmd_Reset : in std_logic;
      VFBC5_Cmd_Data : in std_logic_vector(31 downto 0);
      VFBC5_Cmd_Write : in std_logic;
      VFBC5_Cmd_End : in std_logic;
      VFBC5_Cmd_Full : out std_logic;
      VFBC5_Cmd_Almost_Full : out std_logic;
      VFBC5_Cmd_Idle : out std_logic;
      VFBC5_Wd_Clk : in std_logic;
      VFBC5_Wd_Reset : in std_logic;
      VFBC5_Wd_Write : in std_logic;
      VFBC5_Wd_End_Burst : in std_logic;
      VFBC5_Wd_Flush : in std_logic;
      VFBC5_Wd_Data : in std_logic_vector(31 downto 0);
      VFBC5_Wd_Data_BE : in std_logic_vector(3 downto 0);
      VFBC5_Wd_Full : out std_logic;
      VFBC5_Wd_Almost_Full : out std_logic;
      VFBC5_Rd_Clk : in std_logic;
      VFBC5_Rd_Reset : in std_logic;
      VFBC5_Rd_Read : in std_logic;
      VFBC5_Rd_End_Burst : in std_logic;
      VFBC5_Rd_Flush : in std_logic;
      VFBC5_Rd_Data : out std_logic_vector(31 downto 0);
      VFBC5_Rd_Empty : out std_logic;
      VFBC5_Rd_Almost_Empty : out std_logic;
      FSL6_M_Clk : in std_logic;
      FSL6_M_Write : in std_logic;
      FSL6_M_Data : in std_logic_vector(0 to 31);
      FSL6_M_Control : in std_logic;
      FSL6_M_Full : out std_logic;
      FSL6_S_Clk : in std_logic;
      FSL6_S_Read : in std_logic;
      FSL6_S_Data : out std_logic_vector(0 to 31);
      FSL6_S_Control : out std_logic;
      FSL6_S_Exists : out std_logic;
      SPLB6_Clk : in std_logic;
      SPLB6_Rst : in std_logic;
      SPLB6_PLB_ABus : in std_logic_vector(0 to 31);
      SPLB6_PLB_PAValid : in std_logic;
      SPLB6_PLB_SAValid : in std_logic;
      SPLB6_PLB_masterID : in std_logic_vector(0 to 0);
      SPLB6_PLB_RNW : in std_logic;
      SPLB6_PLB_BE : in std_logic_vector(0 to 7);
      SPLB6_PLB_UABus : in std_logic_vector(0 to 31);
      SPLB6_PLB_rdPrim : in std_logic;
      SPLB6_PLB_wrPrim : in std_logic;
      SPLB6_PLB_abort : in std_logic;
      SPLB6_PLB_busLock : in std_logic;
      SPLB6_PLB_MSize : in std_logic_vector(0 to 1);
      SPLB6_PLB_size : in std_logic_vector(0 to 3);
      SPLB6_PLB_type : in std_logic_vector(0 to 2);
      SPLB6_PLB_lockErr : in std_logic;
      SPLB6_PLB_wrPendReq : in std_logic;
      SPLB6_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SPLB6_PLB_rdPendReq : in std_logic;
      SPLB6_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SPLB6_PLB_reqPri : in std_logic_vector(0 to 1);
      SPLB6_PLB_TAttribute : in std_logic_vector(0 to 15);
      SPLB6_PLB_rdBurst : in std_logic;
      SPLB6_PLB_wrBurst : in std_logic;
      SPLB6_PLB_wrDBus : in std_logic_vector(0 to 63);
      SPLB6_Sl_addrAck : out std_logic;
      SPLB6_Sl_SSize : out std_logic_vector(0 to 1);
      SPLB6_Sl_wait : out std_logic;
      SPLB6_Sl_rearbitrate : out std_logic;
      SPLB6_Sl_wrDAck : out std_logic;
      SPLB6_Sl_wrComp : out std_logic;
      SPLB6_Sl_wrBTerm : out std_logic;
      SPLB6_Sl_rdDBus : out std_logic_vector(0 to 63);
      SPLB6_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SPLB6_Sl_rdDAck : out std_logic;
      SPLB6_Sl_rdComp : out std_logic;
      SPLB6_Sl_rdBTerm : out std_logic;
      SPLB6_Sl_MBusy : out std_logic_vector(0 to 0);
      SPLB6_Sl_MRdErr : out std_logic_vector(0 to 0);
      SPLB6_Sl_MWrErr : out std_logic_vector(0 to 0);
      SPLB6_Sl_MIRQ : out std_logic_vector(0 to 0);
      SDMA6_Clk : in std_logic;
      SDMA6_Rx_IntOut : out std_logic;
      SDMA6_Tx_IntOut : out std_logic;
      SDMA6_RstOut : out std_logic;
      SDMA6_TX_D : out std_logic_vector(0 to 31);
      SDMA6_TX_Rem : out std_logic_vector(0 to 3);
      SDMA6_TX_SOF : out std_logic;
      SDMA6_TX_EOF : out std_logic;
      SDMA6_TX_SOP : out std_logic;
      SDMA6_TX_EOP : out std_logic;
      SDMA6_TX_Src_Rdy : out std_logic;
      SDMA6_TX_Dst_Rdy : in std_logic;
      SDMA6_RX_D : in std_logic_vector(0 to 31);
      SDMA6_RX_Rem : in std_logic_vector(0 to 3);
      SDMA6_RX_SOF : in std_logic;
      SDMA6_RX_EOF : in std_logic;
      SDMA6_RX_SOP : in std_logic;
      SDMA6_RX_EOP : in std_logic;
      SDMA6_RX_Src_Rdy : in std_logic;
      SDMA6_RX_Dst_Rdy : out std_logic;
      SDMA_CTRL6_Clk : in std_logic;
      SDMA_CTRL6_Rst : in std_logic;
      SDMA_CTRL6_PLB_ABus : in std_logic_vector(0 to 31);
      SDMA_CTRL6_PLB_PAValid : in std_logic;
      SDMA_CTRL6_PLB_SAValid : in std_logic;
      SDMA_CTRL6_PLB_masterID : in std_logic_vector(0 to 0);
      SDMA_CTRL6_PLB_RNW : in std_logic;
      SDMA_CTRL6_PLB_BE : in std_logic_vector(0 to 7);
      SDMA_CTRL6_PLB_UABus : in std_logic_vector(0 to 31);
      SDMA_CTRL6_PLB_rdPrim : in std_logic;
      SDMA_CTRL6_PLB_wrPrim : in std_logic;
      SDMA_CTRL6_PLB_abort : in std_logic;
      SDMA_CTRL6_PLB_busLock : in std_logic;
      SDMA_CTRL6_PLB_MSize : in std_logic_vector(0 to 1);
      SDMA_CTRL6_PLB_size : in std_logic_vector(0 to 3);
      SDMA_CTRL6_PLB_type : in std_logic_vector(0 to 2);
      SDMA_CTRL6_PLB_lockErr : in std_logic;
      SDMA_CTRL6_PLB_wrPendReq : in std_logic;
      SDMA_CTRL6_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL6_PLB_rdPendReq : in std_logic;
      SDMA_CTRL6_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL6_PLB_reqPri : in std_logic_vector(0 to 1);
      SDMA_CTRL6_PLB_TAttribute : in std_logic_vector(0 to 15);
      SDMA_CTRL6_PLB_rdBurst : in std_logic;
      SDMA_CTRL6_PLB_wrBurst : in std_logic;
      SDMA_CTRL6_PLB_wrDBus : in std_logic_vector(0 to 63);
      SDMA_CTRL6_Sl_addrAck : out std_logic;
      SDMA_CTRL6_Sl_SSize : out std_logic_vector(0 to 1);
      SDMA_CTRL6_Sl_wait : out std_logic;
      SDMA_CTRL6_Sl_rearbitrate : out std_logic;
      SDMA_CTRL6_Sl_wrDAck : out std_logic;
      SDMA_CTRL6_Sl_wrComp : out std_logic;
      SDMA_CTRL6_Sl_wrBTerm : out std_logic;
      SDMA_CTRL6_Sl_rdDBus : out std_logic_vector(0 to 63);
      SDMA_CTRL6_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SDMA_CTRL6_Sl_rdDAck : out std_logic;
      SDMA_CTRL6_Sl_rdComp : out std_logic;
      SDMA_CTRL6_Sl_rdBTerm : out std_logic;
      SDMA_CTRL6_Sl_MBusy : out std_logic_vector(0 to 0);
      SDMA_CTRL6_Sl_MRdErr : out std_logic_vector(0 to 0);
      SDMA_CTRL6_Sl_MWrErr : out std_logic_vector(0 to 0);
      SDMA_CTRL6_Sl_MIRQ : out std_logic_vector(0 to 0);
      PIM6_Addr : in std_logic_vector(31 downto 0);
      PIM6_AddrReq : in std_logic;
      PIM6_AddrAck : out std_logic;
      PIM6_RNW : in std_logic;
      PIM6_Size : in std_logic_vector(3 downto 0);
      PIM6_RdModWr : in std_logic;
      PIM6_WrFIFO_Data : in std_logic_vector(63 downto 0);
      PIM6_WrFIFO_BE : in std_logic_vector(7 downto 0);
      PIM6_WrFIFO_Push : in std_logic;
      PIM6_RdFIFO_Data : out std_logic_vector(63 downto 0);
      PIM6_RdFIFO_Pop : in std_logic;
      PIM6_RdFIFO_RdWdAddr : out std_logic_vector(3 downto 0);
      PIM6_WrFIFO_Empty : out std_logic;
      PIM6_WrFIFO_AlmostFull : out std_logic;
      PIM6_WrFIFO_Flush : in std_logic;
      PIM6_RdFIFO_Empty : out std_logic;
      PIM6_RdFIFO_Flush : in std_logic;
      PIM6_RdFIFO_Latency : out std_logic_vector(1 downto 0);
      PIM6_InitDone : out std_logic;
      PPC440MC6_MIMCReadNotWrite : in std_logic;
      PPC440MC6_MIMCAddress : in std_logic_vector(0 to 35);
      PPC440MC6_MIMCAddressValid : in std_logic;
      PPC440MC6_MIMCWriteData : in std_logic_vector(0 to 127);
      PPC440MC6_MIMCWriteDataValid : in std_logic;
      PPC440MC6_MIMCByteEnable : in std_logic_vector(0 to 15);
      PPC440MC6_MIMCBankConflict : in std_logic;
      PPC440MC6_MIMCRowConflict : in std_logic;
      PPC440MC6_MCMIReadData : out std_logic_vector(0 to 127);
      PPC440MC6_MCMIReadDataValid : out std_logic;
      PPC440MC6_MCMIReadDataErr : out std_logic;
      PPC440MC6_MCMIAddrReadyToAccept : out std_logic;
      VFBC6_Cmd_Clk : in std_logic;
      VFBC6_Cmd_Reset : in std_logic;
      VFBC6_Cmd_Data : in std_logic_vector(31 downto 0);
      VFBC6_Cmd_Write : in std_logic;
      VFBC6_Cmd_End : in std_logic;
      VFBC6_Cmd_Full : out std_logic;
      VFBC6_Cmd_Almost_Full : out std_logic;
      VFBC6_Cmd_Idle : out std_logic;
      VFBC6_Wd_Clk : in std_logic;
      VFBC6_Wd_Reset : in std_logic;
      VFBC6_Wd_Write : in std_logic;
      VFBC6_Wd_End_Burst : in std_logic;
      VFBC6_Wd_Flush : in std_logic;
      VFBC6_Wd_Data : in std_logic_vector(31 downto 0);
      VFBC6_Wd_Data_BE : in std_logic_vector(3 downto 0);
      VFBC6_Wd_Full : out std_logic;
      VFBC6_Wd_Almost_Full : out std_logic;
      VFBC6_Rd_Clk : in std_logic;
      VFBC6_Rd_Reset : in std_logic;
      VFBC6_Rd_Read : in std_logic;
      VFBC6_Rd_End_Burst : in std_logic;
      VFBC6_Rd_Flush : in std_logic;
      VFBC6_Rd_Data : out std_logic_vector(31 downto 0);
      VFBC6_Rd_Empty : out std_logic;
      VFBC6_Rd_Almost_Empty : out std_logic;
      FSL7_M_Clk : in std_logic;
      FSL7_M_Write : in std_logic;
      FSL7_M_Data : in std_logic_vector(0 to 31);
      FSL7_M_Control : in std_logic;
      FSL7_M_Full : out std_logic;
      FSL7_S_Clk : in std_logic;
      FSL7_S_Read : in std_logic;
      FSL7_S_Data : out std_logic_vector(0 to 31);
      FSL7_S_Control : out std_logic;
      FSL7_S_Exists : out std_logic;
      SPLB7_Clk : in std_logic;
      SPLB7_Rst : in std_logic;
      SPLB7_PLB_ABus : in std_logic_vector(0 to 31);
      SPLB7_PLB_PAValid : in std_logic;
      SPLB7_PLB_SAValid : in std_logic;
      SPLB7_PLB_masterID : in std_logic_vector(0 to 2);
      SPLB7_PLB_RNW : in std_logic;
      SPLB7_PLB_BE : in std_logic_vector(0 to 15);
      SPLB7_PLB_UABus : in std_logic_vector(0 to 31);
      SPLB7_PLB_rdPrim : in std_logic;
      SPLB7_PLB_wrPrim : in std_logic;
      SPLB7_PLB_abort : in std_logic;
      SPLB7_PLB_busLock : in std_logic;
      SPLB7_PLB_MSize : in std_logic_vector(0 to 1);
      SPLB7_PLB_size : in std_logic_vector(0 to 3);
      SPLB7_PLB_type : in std_logic_vector(0 to 2);
      SPLB7_PLB_lockErr : in std_logic;
      SPLB7_PLB_wrPendReq : in std_logic;
      SPLB7_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SPLB7_PLB_rdPendReq : in std_logic;
      SPLB7_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SPLB7_PLB_reqPri : in std_logic_vector(0 to 1);
      SPLB7_PLB_TAttribute : in std_logic_vector(0 to 15);
      SPLB7_PLB_rdBurst : in std_logic;
      SPLB7_PLB_wrBurst : in std_logic;
      SPLB7_PLB_wrDBus : in std_logic_vector(0 to 127);
      SPLB7_Sl_addrAck : out std_logic;
      SPLB7_Sl_SSize : out std_logic_vector(0 to 1);
      SPLB7_Sl_wait : out std_logic;
      SPLB7_Sl_rearbitrate : out std_logic;
      SPLB7_Sl_wrDAck : out std_logic;
      SPLB7_Sl_wrComp : out std_logic;
      SPLB7_Sl_wrBTerm : out std_logic;
      SPLB7_Sl_rdDBus : out std_logic_vector(0 to 127);
      SPLB7_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SPLB7_Sl_rdDAck : out std_logic;
      SPLB7_Sl_rdComp : out std_logic;
      SPLB7_Sl_rdBTerm : out std_logic;
      SPLB7_Sl_MBusy : out std_logic_vector(0 to 7);
      SPLB7_Sl_MRdErr : out std_logic_vector(0 to 7);
      SPLB7_Sl_MWrErr : out std_logic_vector(0 to 7);
      SPLB7_Sl_MIRQ : out std_logic_vector(0 to 7);
      SDMA7_Clk : in std_logic;
      SDMA7_Rx_IntOut : out std_logic;
      SDMA7_Tx_IntOut : out std_logic;
      SDMA7_RstOut : out std_logic;
      SDMA7_TX_D : out std_logic_vector(0 to 31);
      SDMA7_TX_Rem : out std_logic_vector(0 to 3);
      SDMA7_TX_SOF : out std_logic;
      SDMA7_TX_EOF : out std_logic;
      SDMA7_TX_SOP : out std_logic;
      SDMA7_TX_EOP : out std_logic;
      SDMA7_TX_Src_Rdy : out std_logic;
      SDMA7_TX_Dst_Rdy : in std_logic;
      SDMA7_RX_D : in std_logic_vector(0 to 31);
      SDMA7_RX_Rem : in std_logic_vector(0 to 3);
      SDMA7_RX_SOF : in std_logic;
      SDMA7_RX_EOF : in std_logic;
      SDMA7_RX_SOP : in std_logic;
      SDMA7_RX_EOP : in std_logic;
      SDMA7_RX_Src_Rdy : in std_logic;
      SDMA7_RX_Dst_Rdy : out std_logic;
      SDMA_CTRL7_Clk : in std_logic;
      SDMA_CTRL7_Rst : in std_logic;
      SDMA_CTRL7_PLB_ABus : in std_logic_vector(0 to 31);
      SDMA_CTRL7_PLB_PAValid : in std_logic;
      SDMA_CTRL7_PLB_SAValid : in std_logic;
      SDMA_CTRL7_PLB_masterID : in std_logic_vector(0 to 0);
      SDMA_CTRL7_PLB_RNW : in std_logic;
      SDMA_CTRL7_PLB_BE : in std_logic_vector(0 to 7);
      SDMA_CTRL7_PLB_UABus : in std_logic_vector(0 to 31);
      SDMA_CTRL7_PLB_rdPrim : in std_logic;
      SDMA_CTRL7_PLB_wrPrim : in std_logic;
      SDMA_CTRL7_PLB_abort : in std_logic;
      SDMA_CTRL7_PLB_busLock : in std_logic;
      SDMA_CTRL7_PLB_MSize : in std_logic_vector(0 to 1);
      SDMA_CTRL7_PLB_size : in std_logic_vector(0 to 3);
      SDMA_CTRL7_PLB_type : in std_logic_vector(0 to 2);
      SDMA_CTRL7_PLB_lockErr : in std_logic;
      SDMA_CTRL7_PLB_wrPendReq : in std_logic;
      SDMA_CTRL7_PLB_wrPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL7_PLB_rdPendReq : in std_logic;
      SDMA_CTRL7_PLB_rdPendPri : in std_logic_vector(0 to 1);
      SDMA_CTRL7_PLB_reqPri : in std_logic_vector(0 to 1);
      SDMA_CTRL7_PLB_TAttribute : in std_logic_vector(0 to 15);
      SDMA_CTRL7_PLB_rdBurst : in std_logic;
      SDMA_CTRL7_PLB_wrBurst : in std_logic;
      SDMA_CTRL7_PLB_wrDBus : in std_logic_vector(0 to 63);
      SDMA_CTRL7_Sl_addrAck : out std_logic;
      SDMA_CTRL7_Sl_SSize : out std_logic_vector(0 to 1);
      SDMA_CTRL7_Sl_wait : out std_logic;
      SDMA_CTRL7_Sl_rearbitrate : out std_logic;
      SDMA_CTRL7_Sl_wrDAck : out std_logic;
      SDMA_CTRL7_Sl_wrComp : out std_logic;
      SDMA_CTRL7_Sl_wrBTerm : out std_logic;
      SDMA_CTRL7_Sl_rdDBus : out std_logic_vector(0 to 63);
      SDMA_CTRL7_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      SDMA_CTRL7_Sl_rdDAck : out std_logic;
      SDMA_CTRL7_Sl_rdComp : out std_logic;
      SDMA_CTRL7_Sl_rdBTerm : out std_logic;
      SDMA_CTRL7_Sl_MBusy : out std_logic_vector(0 to 0);
      SDMA_CTRL7_Sl_MRdErr : out std_logic_vector(0 to 0);
      SDMA_CTRL7_Sl_MWrErr : out std_logic_vector(0 to 0);
      SDMA_CTRL7_Sl_MIRQ : out std_logic_vector(0 to 0);
      PIM7_Addr : in std_logic_vector(31 downto 0);
      PIM7_AddrReq : in std_logic;
      PIM7_AddrAck : out std_logic;
      PIM7_RNW : in std_logic;
      PIM7_Size : in std_logic_vector(3 downto 0);
      PIM7_RdModWr : in std_logic;
      PIM7_WrFIFO_Data : in std_logic_vector(63 downto 0);
      PIM7_WrFIFO_BE : in std_logic_vector(7 downto 0);
      PIM7_WrFIFO_Push : in std_logic;
      PIM7_RdFIFO_Data : out std_logic_vector(63 downto 0);
      PIM7_RdFIFO_Pop : in std_logic;
      PIM7_RdFIFO_RdWdAddr : out std_logic_vector(3 downto 0);
      PIM7_WrFIFO_Empty : out std_logic;
      PIM7_WrFIFO_AlmostFull : out std_logic;
      PIM7_WrFIFO_Flush : in std_logic;
      PIM7_RdFIFO_Empty : out std_logic;
      PIM7_RdFIFO_Flush : in std_logic;
      PIM7_RdFIFO_Latency : out std_logic_vector(1 downto 0);
      PIM7_InitDone : out std_logic;
      PPC440MC7_MIMCReadNotWrite : in std_logic;
      PPC440MC7_MIMCAddress : in std_logic_vector(0 to 35);
      PPC440MC7_MIMCAddressValid : in std_logic;
      PPC440MC7_MIMCWriteData : in std_logic_vector(0 to 127);
      PPC440MC7_MIMCWriteDataValid : in std_logic;
      PPC440MC7_MIMCByteEnable : in std_logic_vector(0 to 15);
      PPC440MC7_MIMCBankConflict : in std_logic;
      PPC440MC7_MIMCRowConflict : in std_logic;
      PPC440MC7_MCMIReadData : out std_logic_vector(0 to 127);
      PPC440MC7_MCMIReadDataValid : out std_logic;
      PPC440MC7_MCMIReadDataErr : out std_logic;
      PPC440MC7_MCMIAddrReadyToAccept : out std_logic;
      VFBC7_Cmd_Clk : in std_logic;
      VFBC7_Cmd_Reset : in std_logic;
      VFBC7_Cmd_Data : in std_logic_vector(31 downto 0);
      VFBC7_Cmd_Write : in std_logic;
      VFBC7_Cmd_End : in std_logic;
      VFBC7_Cmd_Full : out std_logic;
      VFBC7_Cmd_Almost_Full : out std_logic;
      VFBC7_Cmd_Idle : out std_logic;
      VFBC7_Wd_Clk : in std_logic;
      VFBC7_Wd_Reset : in std_logic;
      VFBC7_Wd_Write : in std_logic;
      VFBC7_Wd_End_Burst : in std_logic;
      VFBC7_Wd_Flush : in std_logic;
      VFBC7_Wd_Data : in std_logic_vector(31 downto 0);
      VFBC7_Wd_Data_BE : in std_logic_vector(3 downto 0);
      VFBC7_Wd_Full : out std_logic;
      VFBC7_Wd_Almost_Full : out std_logic;
      VFBC7_Rd_Clk : in std_logic;
      VFBC7_Rd_Reset : in std_logic;
      VFBC7_Rd_Read : in std_logic;
      VFBC7_Rd_End_Burst : in std_logic;
      VFBC7_Rd_Flush : in std_logic;
      VFBC7_Rd_Data : out std_logic_vector(31 downto 0);
      VFBC7_Rd_Empty : out std_logic;
      VFBC7_Rd_Almost_Empty : out std_logic;
      MPMC_CTRL_Clk : in std_logic;
      MPMC_CTRL_Rst : in std_logic;
      MPMC_CTRL_PLB_ABus : in std_logic_vector(0 to 31);
      MPMC_CTRL_PLB_PAValid : in std_logic;
      MPMC_CTRL_PLB_SAValid : in std_logic;
      MPMC_CTRL_PLB_masterID : in std_logic_vector(0 to 0);
      MPMC_CTRL_PLB_RNW : in std_logic;
      MPMC_CTRL_PLB_BE : in std_logic_vector(0 to 7);
      MPMC_CTRL_PLB_UABus : in std_logic_vector(0 to 31);
      MPMC_CTRL_PLB_rdPrim : in std_logic;
      MPMC_CTRL_PLB_wrPrim : in std_logic;
      MPMC_CTRL_PLB_abort : in std_logic;
      MPMC_CTRL_PLB_busLock : in std_logic;
      MPMC_CTRL_PLB_MSize : in std_logic_vector(0 to 1);
      MPMC_CTRL_PLB_size : in std_logic_vector(0 to 3);
      MPMC_CTRL_PLB_type : in std_logic_vector(0 to 2);
      MPMC_CTRL_PLB_lockErr : in std_logic;
      MPMC_CTRL_PLB_wrPendReq : in std_logic;
      MPMC_CTRL_PLB_wrPendPri : in std_logic_vector(0 to 1);
      MPMC_CTRL_PLB_rdPendReq : in std_logic;
      MPMC_CTRL_PLB_rdPendPri : in std_logic_vector(0 to 1);
      MPMC_CTRL_PLB_reqPri : in std_logic_vector(0 to 1);
      MPMC_CTRL_PLB_TAttribute : in std_logic_vector(0 to 15);
      MPMC_CTRL_PLB_rdBurst : in std_logic;
      MPMC_CTRL_PLB_wrBurst : in std_logic;
      MPMC_CTRL_PLB_wrDBus : in std_logic_vector(0 to 63);
      MPMC_CTRL_Sl_addrAck : out std_logic;
      MPMC_CTRL_Sl_SSize : out std_logic_vector(0 to 1);
      MPMC_CTRL_Sl_wait : out std_logic;
      MPMC_CTRL_Sl_rearbitrate : out std_logic;
      MPMC_CTRL_Sl_wrDAck : out std_logic;
      MPMC_CTRL_Sl_wrComp : out std_logic;
      MPMC_CTRL_Sl_wrBTerm : out std_logic;
      MPMC_CTRL_Sl_rdDBus : out std_logic_vector(0 to 63);
      MPMC_CTRL_Sl_rdWdAddr : out std_logic_vector(0 to 3);
      MPMC_CTRL_Sl_rdDAck : out std_logic;
      MPMC_CTRL_Sl_rdComp : out std_logic;
      MPMC_CTRL_Sl_rdBTerm : out std_logic;
      MPMC_CTRL_Sl_MBusy : out std_logic_vector(0 to 0);
      MPMC_CTRL_Sl_MRdErr : out std_logic_vector(0 to 0);
      MPMC_CTRL_Sl_MWrErr : out std_logic_vector(0 to 0);
      MPMC_CTRL_Sl_MIRQ : out std_logic_vector(0 to 0);
      MPMC_Clk0 : in std_logic;
      MPMC_Clk0_DIV2 : in std_logic;
      MPMC_Clk90 : in std_logic;
      MPMC_Clk_200MHz : in std_logic;
      MPMC_Rst : in std_logic;
      MPMC_Clk_Mem : in std_logic;
      MPMC_Idelayctrl_Rdy_I : in std_logic;
      MPMC_Idelayctrl_Rdy_O : out std_logic;
      MPMC_InitDone : out std_logic;
      MPMC_ECC_Intr : out std_logic;
      MPMC_DCM_PSEN : out std_logic;
      MPMC_DCM_PSINCDEC : out std_logic;
      MPMC_DCM_PSDONE : in std_logic;
      SDRAM_Clk : out std_logic_vector(1 downto 0);
      SDRAM_CE : out std_logic_vector(1 downto 0);
      SDRAM_CS_n : out std_logic_vector(1 downto 0);
      SDRAM_RAS_n : out std_logic;
      SDRAM_CAS_n : out std_logic;
      SDRAM_WE_n : out std_logic;
      SDRAM_BankAddr : out std_logic_vector(1 downto 0);
      SDRAM_Addr : out std_logic_vector(12 downto 0);
      SDRAM_DQ : inout std_logic_vector(63 downto 0);
      SDRAM_DM : out std_logic_vector(7 downto 0);
      DDR_Clk : out std_logic_vector(1 downto 0);
      DDR_Clk_n : out std_logic_vector(1 downto 0);
      DDR_CE : out std_logic_vector(1 downto 0);
      DDR_CS_n : out std_logic_vector(1 downto 0);
      DDR_RAS_n : out std_logic;
      DDR_CAS_n : out std_logic;
      DDR_WE_n : out std_logic;
      DDR_BankAddr : out std_logic_vector(1 downto 0);
      DDR_Addr : out std_logic_vector(12 downto 0);
      DDR_DQ : inout std_logic_vector(63 downto 0);
      DDR_DM : out std_logic_vector(7 downto 0);
      DDR_DQS : inout std_logic_vector(7 downto 0);
      DDR_DQS_Div_O : out std_logic;
      DDR_DQS_Div_I : in std_logic;
      DDR2_Clk : out std_logic_vector(1 downto 0);
      DDR2_Clk_n : out std_logic_vector(1 downto 0);
      DDR2_CE : out std_logic_vector(1 downto 0);
      DDR2_CS_n : out std_logic_vector(1 downto 0);
      DDR2_ODT : out std_logic_vector(1 downto 0);
      DDR2_RAS_n : out std_logic;
      DDR2_CAS_n : out std_logic;
      DDR2_WE_n : out std_logic;
      DDR2_BankAddr : out std_logic_vector(1 downto 0);
      DDR2_Addr : out std_logic_vector(12 downto 0);
      DDR2_DQ : inout std_logic_vector(63 downto 0);
      DDR2_DM : out std_logic_vector(7 downto 0);
      DDR2_DQS : inout std_logic_vector(7 downto 0);
      DDR2_DQS_n : inout std_logic_vector(7 downto 0);
      DDR2_DQS_Div_O : out std_logic;
      DDR2_DQS_Div_I : in std_logic
    );
  end component;

  component sram_util_bus_split_0_wrapper is
    port (
      Sig : in std_logic_vector(0 to 31);
      Out1 : out std_logic_vector(7 to 30);
      Out2 : out std_logic_vector(31 to 31)
    );
  end component;

  component ddr2_sdram_util_bus_split_1_wrapper is
    port (
      Sig : in std_logic_vector(0 to 1);
      Out1 : out std_logic_vector(0 to 0);
      Out2 : out std_logic_vector(1 to 1)
    );
  end component;

  component ddr2_sdram_util_bus_split_2_wrapper is
    port (
      Sig : in std_logic_vector(0 to 1);
      Out1 : out std_logic_vector(0 to 0);
      Out2 : out std_logic_vector(1 to 1)
    );
  end component;

  component clock_generator_0_wrapper is
    port (
      CLKIN : in std_logic;
      CLKFBIN : in std_logic;
      CLKOUT0 : out std_logic;
      CLKOUT1 : out std_logic;
      CLKOUT2 : out std_logic;
      CLKOUT3 : out std_logic;
      CLKOUT4 : out std_logic;
      CLKOUT5 : out std_logic;
      CLKOUT6 : out std_logic;
      CLKOUT7 : out std_logic;
      CLKOUT8 : out std_logic;
      CLKOUT9 : out std_logic;
      CLKOUT10 : out std_logic;
      CLKOUT11 : out std_logic;
      CLKOUT12 : out std_logic;
      CLKOUT13 : out std_logic;
      CLKOUT14 : out std_logic;
      CLKOUT15 : out std_logic;
      CLKFBOUT : out std_logic;
      RST : in std_logic;
      LOCKED : out std_logic
    );
  end component;

  component jtagppc_cntlr_0_wrapper is
    port (
      TRSTNEG : in std_logic;
      HALTNEG0 : in std_logic;
      DBGC405DEBUGHALT0 : out std_logic;
      HALTNEG1 : in std_logic;
      DBGC405DEBUGHALT1 : out std_logic;
      C405JTGTDO0 : in std_logic;
      C405JTGTDOEN0 : in std_logic;
      JTGC405TCK0 : out std_logic;
      JTGC405TDI0 : out std_logic;
      JTGC405TMS0 : out std_logic;
      JTGC405TRSTNEG0 : out std_logic;
      C405JTGTDO1 : in std_logic;
      C405JTGTDOEN1 : in std_logic;
      JTGC405TCK1 : out std_logic;
      JTGC405TDI1 : out std_logic;
      JTGC405TMS1 : out std_logic;
      JTGC405TRSTNEG1 : out std_logic
    );
  end component;

  component proc_sys_reset_0_wrapper is
    port (
      Slowest_sync_clk : in std_logic;
      Ext_Reset_In : in std_logic;
      Aux_Reset_In : in std_logic;
      MB_Debug_Sys_Rst : in std_logic;
      Core_Reset_Req_0 : in std_logic;
      Chip_Reset_Req_0 : in std_logic;
      System_Reset_Req_0 : in std_logic;
      Core_Reset_Req_1 : in std_logic;
      Chip_Reset_Req_1 : in std_logic;
      System_Reset_Req_1 : in std_logic;
      Dcm_locked : in std_logic;
      RstcPPCresetcore_0 : out std_logic;
      RstcPPCresetchip_0 : out std_logic;
      RstcPPCresetsys_0 : out std_logic;
      RstcPPCresetcore_1 : out std_logic;
      RstcPPCresetchip_1 : out std_logic;
      RstcPPCresetsys_1 : out std_logic;
      MB_Reset : out std_logic;
      Bus_Struct_Reset : out std_logic_vector(0 to 0);
      Peripheral_Reset : out std_logic_vector(0 to 0)
    );
  end component;

  component xps_intc_0_wrapper is
    port (
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 2);
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to 15);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_wrDBus : in std_logic_vector(0 to 127);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_lockErr : in std_logic;
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 127);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 7);
      Sl_MWrErr : out std_logic_vector(0 to 7);
      Sl_MRdErr : out std_logic_vector(0 to 7);
      Sl_wrBTerm : out std_logic;
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdBTerm : out std_logic;
      Sl_MIRQ : out std_logic_vector(0 to 7);
      Intr : in std_logic_vector(0 downto 0);
      Irq : out std_logic
    );
  end component;

  component plbv46_opb_bridge_0_wrapper is
    port (
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 2);
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to 15);
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_lockErr : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to 127);
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_wrBTerm : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 127);
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_rdBTerm : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 7);
      Sl_MWrErr : out std_logic_vector(0 to 7);
      Sl_MRdErr : out std_logic_vector(0 to 7);
      Sl_MIRQ : out std_logic_vector(0 to 7);
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Mn_request : out std_logic;
      Mn_busLock : out std_logic;
      Mn_select : out std_logic;
      Mn_RNW : out std_logic;
      Mn_BE : out std_logic_vector(0 to 3);
      Mn_seqAddr : out std_logic;
      Mn_DBus : out std_logic_vector(0 to 31);
      Mn_ABus : out std_logic_vector(0 to 31);
      OPB_MGrant : in std_logic;
      OPB_xferAck : in std_logic;
      OPB_errAck : in std_logic;
      OPB_retry : in std_logic;
      OPB_timeout : in std_logic;
      OPB_DBus : in std_logic_vector(0 to 31)
    );
  end component;

  component opb_plbv46_bridge_0_wrapper is
    port (
      MPLB_Clk : in std_logic;
      MPLB_Rst : in std_logic;
      MD_Error : out std_logic;
      M_request : out std_logic;
      M_priority : out std_logic_vector(0 to 1);
      M_busLock : out std_logic;
      M_RNW : out std_logic;
      M_BE : out std_logic_vector(0 to 15);
      M_MSize : out std_logic_vector(0 to 1);
      M_size : out std_logic_vector(0 to 3);
      M_type : out std_logic_vector(0 to 2);
      M_ABus : out std_logic_vector(0 to 31);
      M_wrBurst : out std_logic;
      M_rdBurst : out std_logic;
      M_wrDBus : out std_logic_vector(0 to 127);
      PLB_MAddrAck : in std_logic;
      PLB_MSSize : in std_logic_vector(0 to 1);
      PLB_MRearbitrate : in std_logic;
      PLB_MTimeout : in std_logic;
      PLB_MRdErr : in std_logic;
      PLB_MWrErr : in std_logic;
      PLB_MRdDBus : in std_logic_vector(0 to 127);
      PLB_MRdDAck : in std_logic;
      PLB_MRdBTerm : in std_logic;
      PLB_MWrDAck : in std_logic;
      PLB_MWrBTerm : in std_logic;
      M_TAttribute : out std_logic_vector(0 to 15);
      M_lockErr : out std_logic;
      M_abort : out std_logic;
      M_UABus : out std_logic_vector(0 to 31);
      PLB_MBusy : in std_logic;
      PLB_MIRQ : in std_logic;
      PLB_MRdWdAddr : in std_logic_vector(0 to 3);
      SOPB_rst : in std_logic;
      SOPB_clk : in std_logic;
      OPB_Select : in std_logic;
      OPB_RNW : in std_logic;
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_seqAddr : in std_logic;
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_ABus : in std_logic_vector(0 to 31);
      Sl_xferAck : out std_logic;
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_ToutSup : out std_logic;
      Sl_DBus : out std_logic_vector(0 to 31)
    );
  end component;

  component opb_v20_0_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : out std_logic;
      SYS_Rst : in std_logic;
      Debug_SYS_Rst : in std_logic;
      WDT_Rst : in std_logic;
      M_ABus : in std_logic_vector(0 to 127);
      M_BE : in std_logic_vector(0 to 15);
      M_beXfer : in std_logic_vector(0 to 3);
      M_busLock : in std_logic_vector(0 to 3);
      M_DBus : in std_logic_vector(0 to 127);
      M_DBusEn : in std_logic_vector(0 to 3);
      M_DBusEn32_63 : in std_logic_vector(0 to 3);
      M_dwXfer : in std_logic_vector(0 to 3);
      M_fwXfer : in std_logic_vector(0 to 3);
      M_hwXfer : in std_logic_vector(0 to 3);
      M_request : in std_logic_vector(0 to 3);
      M_RNW : in std_logic_vector(0 to 3);
      M_select : in std_logic_vector(0 to 3);
      M_seqAddr : in std_logic_vector(0 to 3);
      Sl_beAck : in std_logic_vector(0 to 5);
      Sl_DBus : in std_logic_vector(0 to 191);
      Sl_DBusEn : in std_logic_vector(0 to 5);
      Sl_DBusEn32_63 : in std_logic_vector(0 to 5);
      Sl_errAck : in std_logic_vector(0 to 5);
      Sl_dwAck : in std_logic_vector(0 to 5);
      Sl_fwAck : in std_logic_vector(0 to 5);
      Sl_hwAck : in std_logic_vector(0 to 5);
      Sl_retry : in std_logic_vector(0 to 5);
      Sl_toutSup : in std_logic_vector(0 to 5);
      Sl_xferAck : in std_logic_vector(0 to 5);
      OPB_MRequest : out std_logic_vector(0 to 3);
      OPB_ABus : out std_logic_vector(0 to 31);
      OPB_BE : out std_logic_vector(0 to 3);
      OPB_beXfer : out std_logic;
      OPB_beAck : out std_logic;
      OPB_busLock : out std_logic;
      OPB_rdDBus : out std_logic_vector(0 to 31);
      OPB_wrDBus : out std_logic_vector(0 to 31);
      OPB_DBus : out std_logic_vector(0 to 31);
      OPB_errAck : out std_logic;
      OPB_dwAck : out std_logic;
      OPB_dwXfer : out std_logic;
      OPB_fwAck : out std_logic;
      OPB_fwXfer : out std_logic;
      OPB_hwAck : out std_logic;
      OPB_hwXfer : out std_logic;
      OPB_MGrant : out std_logic_vector(0 to 3);
      OPB_pendReq : out std_logic_vector(0 to 3);
      OPB_retry : out std_logic;
      OPB_RNW : out std_logic;
      OPB_select : out std_logic;
      OPB_seqAddr : out std_logic;
      OPB_timeout : out std_logic;
      OPB_toutSup : out std_logic;
      OPB_xferAck : out std_logic
    );
  end component;

  component opb_bram_if_cntlr_1_wrapper is
    port (
      opb_clk : in std_logic;
      opb_rst : in std_logic;
      opb_abus : in std_logic_vector(0 to 31);
      opb_dbus : in std_logic_vector(0 to 31);
      sln_dbus : out std_logic_vector(0 to 31);
      opb_select : in std_logic;
      opb_rnw : in std_logic;
      opb_seqaddr : in std_logic;
      opb_be : in std_logic_vector(0 to 3);
      sln_xferack : out std_logic;
      sln_errack : out std_logic;
      sln_toutsup : out std_logic;
      sln_retry : out std_logic;
      bram_rst : out std_logic;
      bram_clk : out std_logic;
      bram_en : out std_logic;
      bram_wen : out std_logic_vector(0 to 3);
      bram_addr : out std_logic_vector(0 to 31);
      bram_din : in std_logic_vector(0 to 31);
      bram_dout : out std_logic_vector(0 to 31)
    );
  end component;

  component bram_block_0_wrapper is
    port (
      BRAM_Rst_A : in std_logic;
      BRAM_Clk_A : in std_logic;
      BRAM_EN_A : in std_logic;
      BRAM_WEN_A : in std_logic_vector(0 to 3);
      BRAM_Addr_A : in std_logic_vector(0 to 31);
      BRAM_Din_A : out std_logic_vector(0 to 31);
      BRAM_Dout_A : in std_logic_vector(0 to 31);
      BRAM_Rst_B : in std_logic;
      BRAM_Clk_B : in std_logic;
      BRAM_EN_B : in std_logic;
      BRAM_WEN_B : in std_logic_vector(0 to 3);
      BRAM_Addr_B : in std_logic_vector(0 to 31);
      BRAM_Din_B : out std_logic_vector(0 to 31);
      BRAM_Dout_B : in std_logic_vector(0 to 31)
    );
  end component;

  component xps_bram_if_cntlr_0_wrapper is
    port (
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 2);
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to 15);
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_lockErr : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to 127);
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_wrBTerm : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 127);
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_rdBTerm : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 7);
      Sl_MWrErr : out std_logic_vector(0 to 7);
      Sl_MRdErr : out std_logic_vector(0 to 7);
      Sl_MIRQ : out std_logic_vector(0 to 7);
      BRAM_Rst : out std_logic;
      BRAM_Clk : out std_logic;
      BRAM_EN : out std_logic;
      BRAM_WEN : out std_logic_vector(0 to 3);
      BRAM_Addr : out std_logic_vector(0 to 31);
      BRAM_Din : in std_logic_vector(0 to 31);
      BRAM_Dout : out std_logic_vector(0 to 31)
    );
  end component;

  component plb_hthread_reset_core_0_wrapper is
    port (
      reset_port0 : out std_logic;
      reset_response_port0 : in std_logic;
      reset_port1 : out std_logic;
      reset_response_port1 : in std_logic;
      reset_port2 : out std_logic;
      reset_response_port2 : in std_logic;
      reset_port3 : out std_logic;
      reset_response_port3 : in std_logic;
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 2);
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to 15);
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_lockErr : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to 127);
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_wrBTerm : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 127);
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_rdBTerm : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 7);
      Sl_MWrErr : out std_logic_vector(0 to 7);
      Sl_MRdErr : out std_logic_vector(0 to 7);
      Sl_MIRQ : out std_logic_vector(0 to 7)
    );
  end component;

  component thread_manager_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      Sln_DBus : out std_logic_vector(0 to 31);
      Sln_errAck : out std_logic;
      Sln_retry : out std_logic;
      Sln_toutSup : out std_logic;
      Sln_xferAck : out std_logic;
      Access_Intr : out std_logic;
      Scheduler_Reset : out std_logic;
      Scheduler_Reset_Done : in std_logic;
      Semaphore_Reset : out std_logic;
      Semaphore_Reset_Done : in std_logic;
      SpinLock_Reset : out std_logic;
      SpinLock_Reset_Done : in std_logic;
      User_IP_Reset : out std_logic;
      User_IP_Reset_Done : in std_logic;
      Soft_Stop : out std_logic;
      tm2sch_cpu_thread_id : out std_logic_vector(0 to 7);
      tm2sch_opcode : out std_logic_vector(0 to 5);
      tm2sch_data : out std_logic_vector(0 to 7);
      tm2sch_request : out std_logic;
      sch2tm_busy : in std_logic;
      sch2tm_data : in std_logic_vector(0 to 7);
      sch2tm_next_id : in std_logic_vector(0 to 7);
      sch2tm_next_id_valid : in std_logic;
      tm2sch_DOB : out std_logic_vector(0 to 31);
      sch2tm_ADDRB : in std_logic_vector(0 to 8);
      sch2tm_DIB : in std_logic_vector(0 to 31);
      sch2tm_ENB : in std_logic;
      sch2tm_WEB : in std_logic
    );
  end component;

  component scheduler_wrapper is
    port (
      Soft_Reset : in std_logic;
      Reset_Done : out std_logic;
      Soft_Stop : in std_logic;
      SWTM_DOB : in std_logic_vector(0 to 31);
      SWTM_ADDRB : out std_logic_vector(0 to 8);
      SWTM_DIB : out std_logic_vector(0 to 31);
      SWTM_ENB : out std_logic;
      SWTM_WEB : out std_logic;
      TM2SCH_current_cpu_tid : in std_logic_vector(0 to 7);
      TM2SCH_opcode : in std_logic_vector(0 to 5);
      TM2SCH_data : in std_logic_vector(0 to 7);
      TM2SCH_request : in std_logic;
      SCH2TM_busy : out std_logic;
      SCH2TM_data : out std_logic_vector(0 to 7);
      SCH2TM_next_cpu_tid : out std_logic_vector(0 to 7);
      SCH2TM_next_tid_valid : out std_logic;
      Preemption_Interrupt : out std_logic;
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      M_ABus : out std_logic_vector(0 to 31);
      M_BE : out std_logic_vector(0 to 3);
      M_busLock : out std_logic;
      M_request : out std_logic;
      M_RNW : out std_logic;
      M_select : out std_logic;
      M_seqAddr : out std_logic;
      OPB_errAck : in std_logic;
      OPB_MGrant : in std_logic;
      OPB_retry : in std_logic;
      OPB_timeout : in std_logic;
      OPB_xferAck : in std_logic
    );
  end component;

  component synch_manager_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      M_ABus : out std_logic_vector(0 to 31);
      M_BE : out std_logic_vector(0 to 3);
      M_busLock : out std_logic;
      M_request : out std_logic;
      M_RNW : out std_logic;
      M_select : out std_logic;
      M_seqAddr : out std_logic;
      OPB_errAck : in std_logic;
      OPB_MGrant : in std_logic;
      OPB_retry : in std_logic;
      OPB_timeout : in std_logic;
      OPB_xferAck : in std_logic;
      system_reset : in std_logic;
      system_resetdone : out std_logic
    );
  end component;

  component cond_vars_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Interrupt : out std_logic;
      IP2Bus_IntrEvent : in std_logic_vector(0 to 0);
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      OPB_errAck : in std_logic;
      OPB_MnGrant : in std_logic;
      OPB_retry : in std_logic;
      OPB_timeout : in std_logic;
      OPB_xferAck : in std_logic;
      Mn_request : out std_logic;
      Mn_busLock : out std_logic;
      Mn_select : out std_logic;
      Mn_RNW : out std_logic;
      Mn_BE : out std_logic_vector(0 to 3);
      Mn_seqAddr : out std_logic;
      Mn_ABus : out std_logic_vector(0 to 31);
      Sln_xferAck : out std_logic;
      Sln_errAck : out std_logic;
      Sln_retry : out std_logic;
      Sln_toutSup : out std_logic;
      Sln_DBus : out std_logic_vector(0 to 31);
      Sema_Reset : in std_logic;
      Sema_Rst_Ack : out std_logic
    );
  end component;

  component xps_timer_0_wrapper is
    port (
      CaptureTrig0 : in std_logic;
      CaptureTrig1 : in std_logic;
      GenerateOut0 : out std_logic;
      GenerateOut1 : out std_logic;
      PWM0 : out std_logic;
      Interrupt : out std_logic;
      Freeze : in std_logic;
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 2);
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to 15);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_wrDBus : in std_logic_vector(0 to 127);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 127);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 7);
      Sl_MWrErr : out std_logic_vector(0 to 7);
      Sl_MRdErr : out std_logic_vector(0 to 7);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_lockErr : in std_logic;
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_wrBTerm : out std_logic;
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdBTerm : out std_logic;
      Sl_MIRQ : out std_logic_vector(0 to 7)
    );
  end component;

  component xps_hw_thread_bram_cntlr_wrapper is
    port (
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 2);
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to 15);
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_lockErr : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to 127);
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_wrBTerm : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 127);
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_rdBTerm : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 7);
      Sl_MWrErr : out std_logic_vector(0 to 7);
      Sl_MRdErr : out std_logic_vector(0 to 7);
      Sl_MIRQ : out std_logic_vector(0 to 7);
      BRAM_Rst : out std_logic;
      BRAM_Clk : out std_logic;
      BRAM_EN : out std_logic;
      BRAM_WEN : out std_logic_vector(0 to 3);
      BRAM_Addr : out std_logic_vector(0 to 31);
      BRAM_Din : in std_logic_vector(0 to 31);
      BRAM_Dout : out std_logic_vector(0 to 31)
    );
  end component;

  component hw_thread_bram_wrapper is
    port (
      BRAM_Rst_A : in std_logic;
      BRAM_Clk_A : in std_logic;
      BRAM_EN_A : in std_logic;
      BRAM_WEN_A : in std_logic_vector(0 to 3);
      BRAM_Addr_A : in std_logic_vector(0 to 31);
      BRAM_Din_A : out std_logic_vector(0 to 31);
      BRAM_Dout_A : in std_logic_vector(0 to 31);
      BRAM_Rst_B : in std_logic;
      BRAM_Clk_B : in std_logic;
      BRAM_EN_B : in std_logic;
      BRAM_WEN_B : in std_logic_vector(0 to 3);
      BRAM_Addr_B : in std_logic_vector(0 to 31);
      BRAM_Din_B : out std_logic_vector(0 to 31);
      BRAM_Dout_B : in std_logic_vector(0 to 31)
    );
  end component;

  component microblaze_0_wrapper is
    port (
      CLK : in std_logic;
      RESET : in std_logic;
      MB_RESET : in std_logic;
      INTERRUPT : in std_logic;
      EXT_BRK : in std_logic;
      EXT_NM_BRK : in std_logic;
      DBG_STOP : in std_logic;
      MB_Halted : out std_logic;
      INSTR : in std_logic_vector(0 to 31);
      I_ADDRTAG : out std_logic_vector(0 to 3);
      IREADY : in std_logic;
      IWAIT : in std_logic;
      INSTR_ADDR : out std_logic_vector(0 to 31);
      IFETCH : out std_logic;
      I_AS : out std_logic;
      IPLB_M_ABort : out std_logic;
      IPLB_M_ABus : out std_logic_vector(0 to 31);
      IPLB_M_UABus : out std_logic_vector(0 to 31);
      IPLB_M_BE : out std_logic_vector(0 to 3);
      IPLB_M_busLock : out std_logic;
      IPLB_M_lockErr : out std_logic;
      IPLB_M_MSize : out std_logic_vector(0 to 1);
      IPLB_M_priority : out std_logic_vector(0 to 1);
      IPLB_M_rdBurst : out std_logic;
      IPLB_M_request : out std_logic;
      IPLB_M_RNW : out std_logic;
      IPLB_M_size : out std_logic_vector(0 to 3);
      IPLB_M_TAttribute : out std_logic_vector(0 to 15);
      IPLB_M_type : out std_logic_vector(0 to 2);
      IPLB_M_wrBurst : out std_logic;
      IPLB_M_wrDBus : out std_logic_vector(0 to 31);
      IPLB_MBusy : in std_logic;
      IPLB_MRdErr : in std_logic;
      IPLB_MWrErr : in std_logic;
      IPLB_MIRQ : in std_logic;
      IPLB_MWrBTerm : in std_logic;
      IPLB_MWrDAck : in std_logic;
      IPLB_MAddrAck : in std_logic;
      IPLB_MRdBTerm : in std_logic;
      IPLB_MRdDAck : in std_logic;
      IPLB_MRdDBus : in std_logic_vector(0 to 31);
      IPLB_MRdWdAddr : in std_logic_vector(0 to 3);
      IPLB_MRearbitrate : in std_logic;
      IPLB_MSSize : in std_logic_vector(0 to 1);
      IPLB_MTimeout : in std_logic;
      DATA_READ : in std_logic_vector(0 to 31);
      DREADY : in std_logic;
      DWAIT : in std_logic;
      DATA_WRITE : out std_logic_vector(0 to 31);
      DATA_ADDR : out std_logic_vector(0 to 31);
      D_ADDRTAG : out std_logic_vector(0 to 3);
      D_AS : out std_logic;
      READ_STROBE : out std_logic;
      WRITE_STROBE : out std_logic;
      BYTE_ENABLE : out std_logic_vector(0 to 3);
      DM_ABUS : out std_logic_vector(0 to 31);
      DM_BE : out std_logic_vector(0 to 3);
      DM_BUSLOCK : out std_logic;
      DM_DBUS : out std_logic_vector(0 to 31);
      DM_REQUEST : out std_logic;
      DM_RNW : out std_logic;
      DM_SELECT : out std_logic;
      DM_SEQADDR : out std_logic;
      DOPB_DBUS : in std_logic_vector(0 to 31);
      DOPB_ERRACK : in std_logic;
      DOPB_MGRANT : in std_logic;
      DOPB_RETRY : in std_logic;
      DOPB_TIMEOUT : in std_logic;
      DOPB_XFERACK : in std_logic;
      DPLB_M_ABort : out std_logic;
      DPLB_M_ABus : out std_logic_vector(0 to 31);
      DPLB_M_UABus : out std_logic_vector(0 to 31);
      DPLB_M_BE : out std_logic_vector(0 to 3);
      DPLB_M_busLock : out std_logic;
      DPLB_M_lockErr : out std_logic;
      DPLB_M_MSize : out std_logic_vector(0 to 1);
      DPLB_M_priority : out std_logic_vector(0 to 1);
      DPLB_M_rdBurst : out std_logic;
      DPLB_M_request : out std_logic;
      DPLB_M_RNW : out std_logic;
      DPLB_M_size : out std_logic_vector(0 to 3);
      DPLB_M_TAttribute : out std_logic_vector(0 to 15);
      DPLB_M_type : out std_logic_vector(0 to 2);
      DPLB_M_wrBurst : out std_logic;
      DPLB_M_wrDBus : out std_logic_vector(0 to 31);
      DPLB_MBusy : in std_logic;
      DPLB_MRdErr : in std_logic;
      DPLB_MWrErr : in std_logic;
      DPLB_MIRQ : in std_logic;
      DPLB_MWrBTerm : in std_logic;
      DPLB_MWrDAck : in std_logic;
      DPLB_MAddrAck : in std_logic;
      DPLB_MRdBTerm : in std_logic;
      DPLB_MRdDAck : in std_logic;
      DPLB_MRdDBus : in std_logic_vector(0 to 31);
      DPLB_MRdWdAddr : in std_logic_vector(0 to 3);
      DPLB_MRearbitrate : in std_logic;
      DPLB_MSSize : in std_logic_vector(0 to 1);
      DPLB_MTimeout : in std_logic;
      IM_ABUS : out std_logic_vector(0 to 31);
      IM_BE : out std_logic_vector(0 to 3);
      IM_BUSLOCK : out std_logic;
      IM_DBUS : out std_logic_vector(0 to 31);
      IM_REQUEST : out std_logic;
      IM_RNW : out std_logic;
      IM_SELECT : out std_logic;
      IM_SEQADDR : out std_logic;
      IOPB_DBUS : in std_logic_vector(0 to 31);
      IOPB_ERRACK : in std_logic;
      IOPB_MGRANT : in std_logic;
      IOPB_RETRY : in std_logic;
      IOPB_TIMEOUT : in std_logic;
      IOPB_XFERACK : in std_logic;
      DBG_CLK : in std_logic;
      DBG_TDI : in std_logic;
      DBG_TDO : out std_logic;
      DBG_REG_EN : in std_logic_vector(0 to 4);
      DBG_SHIFT : in std_logic;
      DBG_CAPTURE : in std_logic;
      DBG_UPDATE : in std_logic;
      DEBUG_RST : in std_logic;
      Trace_Instruction : out std_logic_vector(0 to 31);
      Trace_Valid_Instr : out std_logic;
      Trace_PC : out std_logic_vector(0 to 31);
      Trace_Reg_Write : out std_logic;
      Trace_Reg_Addr : out std_logic_vector(0 to 4);
      Trace_MSR_Reg : out std_logic_vector(0 to 14);
      Trace_PID_Reg : out std_logic_vector(0 to 7);
      Trace_New_Reg_Value : out std_logic_vector(0 to 31);
      Trace_Exception_Taken : out std_logic;
      Trace_Exception_Kind : out std_logic_vector(0 to 4);
      Trace_Jump_Taken : out std_logic;
      Trace_Delay_Slot : out std_logic;
      Trace_Data_Address : out std_logic_vector(0 to 31);
      Trace_Data_Access : out std_logic;
      Trace_Data_Read : out std_logic;
      Trace_Data_Write : out std_logic;
      Trace_Data_Write_Value : out std_logic_vector(0 to 31);
      Trace_Data_Byte_Enable : out std_logic_vector(0 to 3);
      Trace_DCache_Req : out std_logic;
      Trace_DCache_Hit : out std_logic;
      Trace_ICache_Req : out std_logic;
      Trace_ICache_Hit : out std_logic;
      Trace_OF_PipeRun : out std_logic;
      Trace_EX_PipeRun : out std_logic;
      Trace_MEM_PipeRun : out std_logic;
      Trace_MB_Halted : out std_logic;
      FSL0_S_CLK : out std_logic;
      FSL0_S_READ : out std_logic;
      FSL0_S_DATA : in std_logic_vector(0 to 31);
      FSL0_S_CONTROL : in std_logic;
      FSL0_S_EXISTS : in std_logic;
      FSL0_M_CLK : out std_logic;
      FSL0_M_WRITE : out std_logic;
      FSL0_M_DATA : out std_logic_vector(0 to 31);
      FSL0_M_CONTROL : out std_logic;
      FSL0_M_FULL : in std_logic;
      FSL1_S_CLK : out std_logic;
      FSL1_S_READ : out std_logic;
      FSL1_S_DATA : in std_logic_vector(0 to 31);
      FSL1_S_CONTROL : in std_logic;
      FSL1_S_EXISTS : in std_logic;
      FSL1_M_CLK : out std_logic;
      FSL1_M_WRITE : out std_logic;
      FSL1_M_DATA : out std_logic_vector(0 to 31);
      FSL1_M_CONTROL : out std_logic;
      FSL1_M_FULL : in std_logic;
      FSL2_S_CLK : out std_logic;
      FSL2_S_READ : out std_logic;
      FSL2_S_DATA : in std_logic_vector(0 to 31);
      FSL2_S_CONTROL : in std_logic;
      FSL2_S_EXISTS : in std_logic;
      FSL2_M_CLK : out std_logic;
      FSL2_M_WRITE : out std_logic;
      FSL2_M_DATA : out std_logic_vector(0 to 31);
      FSL2_M_CONTROL : out std_logic;
      FSL2_M_FULL : in std_logic;
      FSL3_S_CLK : out std_logic;
      FSL3_S_READ : out std_logic;
      FSL3_S_DATA : in std_logic_vector(0 to 31);
      FSL3_S_CONTROL : in std_logic;
      FSL3_S_EXISTS : in std_logic;
      FSL3_M_CLK : out std_logic;
      FSL3_M_WRITE : out std_logic;
      FSL3_M_DATA : out std_logic_vector(0 to 31);
      FSL3_M_CONTROL : out std_logic;
      FSL3_M_FULL : in std_logic;
      FSL4_S_CLK : out std_logic;
      FSL4_S_READ : out std_logic;
      FSL4_S_DATA : in std_logic_vector(0 to 31);
      FSL4_S_CONTROL : in std_logic;
      FSL4_S_EXISTS : in std_logic;
      FSL4_M_CLK : out std_logic;
      FSL4_M_WRITE : out std_logic;
      FSL4_M_DATA : out std_logic_vector(0 to 31);
      FSL4_M_CONTROL : out std_logic;
      FSL4_M_FULL : in std_logic;
      FSL5_S_CLK : out std_logic;
      FSL5_S_READ : out std_logic;
      FSL5_S_DATA : in std_logic_vector(0 to 31);
      FSL5_S_CONTROL : in std_logic;
      FSL5_S_EXISTS : in std_logic;
      FSL5_M_CLK : out std_logic;
      FSL5_M_WRITE : out std_logic;
      FSL5_M_DATA : out std_logic_vector(0 to 31);
      FSL5_M_CONTROL : out std_logic;
      FSL5_M_FULL : in std_logic;
      FSL6_S_CLK : out std_logic;
      FSL6_S_READ : out std_logic;
      FSL6_S_DATA : in std_logic_vector(0 to 31);
      FSL6_S_CONTROL : in std_logic;
      FSL6_S_EXISTS : in std_logic;
      FSL6_M_CLK : out std_logic;
      FSL6_M_WRITE : out std_logic;
      FSL6_M_DATA : out std_logic_vector(0 to 31);
      FSL6_M_CONTROL : out std_logic;
      FSL6_M_FULL : in std_logic;
      FSL7_S_CLK : out std_logic;
      FSL7_S_READ : out std_logic;
      FSL7_S_DATA : in std_logic_vector(0 to 31);
      FSL7_S_CONTROL : in std_logic;
      FSL7_S_EXISTS : in std_logic;
      FSL7_M_CLK : out std_logic;
      FSL7_M_WRITE : out std_logic;
      FSL7_M_DATA : out std_logic_vector(0 to 31);
      FSL7_M_CONTROL : out std_logic;
      FSL7_M_FULL : in std_logic;
      FSL8_S_CLK : out std_logic;
      FSL8_S_READ : out std_logic;
      FSL8_S_DATA : in std_logic_vector(0 to 31);
      FSL8_S_CONTROL : in std_logic;
      FSL8_S_EXISTS : in std_logic;
      FSL8_M_CLK : out std_logic;
      FSL8_M_WRITE : out std_logic;
      FSL8_M_DATA : out std_logic_vector(0 to 31);
      FSL8_M_CONTROL : out std_logic;
      FSL8_M_FULL : in std_logic;
      FSL9_S_CLK : out std_logic;
      FSL9_S_READ : out std_logic;
      FSL9_S_DATA : in std_logic_vector(0 to 31);
      FSL9_S_CONTROL : in std_logic;
      FSL9_S_EXISTS : in std_logic;
      FSL9_M_CLK : out std_logic;
      FSL9_M_WRITE : out std_logic;
      FSL9_M_DATA : out std_logic_vector(0 to 31);
      FSL9_M_CONTROL : out std_logic;
      FSL9_M_FULL : in std_logic;
      FSL10_S_CLK : out std_logic;
      FSL10_S_READ : out std_logic;
      FSL10_S_DATA : in std_logic_vector(0 to 31);
      FSL10_S_CONTROL : in std_logic;
      FSL10_S_EXISTS : in std_logic;
      FSL10_M_CLK : out std_logic;
      FSL10_M_WRITE : out std_logic;
      FSL10_M_DATA : out std_logic_vector(0 to 31);
      FSL10_M_CONTROL : out std_logic;
      FSL10_M_FULL : in std_logic;
      FSL11_S_CLK : out std_logic;
      FSL11_S_READ : out std_logic;
      FSL11_S_DATA : in std_logic_vector(0 to 31);
      FSL11_S_CONTROL : in std_logic;
      FSL11_S_EXISTS : in std_logic;
      FSL11_M_CLK : out std_logic;
      FSL11_M_WRITE : out std_logic;
      FSL11_M_DATA : out std_logic_vector(0 to 31);
      FSL11_M_CONTROL : out std_logic;
      FSL11_M_FULL : in std_logic;
      FSL12_S_CLK : out std_logic;
      FSL12_S_READ : out std_logic;
      FSL12_S_DATA : in std_logic_vector(0 to 31);
      FSL12_S_CONTROL : in std_logic;
      FSL12_S_EXISTS : in std_logic;
      FSL12_M_CLK : out std_logic;
      FSL12_M_WRITE : out std_logic;
      FSL12_M_DATA : out std_logic_vector(0 to 31);
      FSL12_M_CONTROL : out std_logic;
      FSL12_M_FULL : in std_logic;
      FSL13_S_CLK : out std_logic;
      FSL13_S_READ : out std_logic;
      FSL13_S_DATA : in std_logic_vector(0 to 31);
      FSL13_S_CONTROL : in std_logic;
      FSL13_S_EXISTS : in std_logic;
      FSL13_M_CLK : out std_logic;
      FSL13_M_WRITE : out std_logic;
      FSL13_M_DATA : out std_logic_vector(0 to 31);
      FSL13_M_CONTROL : out std_logic;
      FSL13_M_FULL : in std_logic;
      FSL14_S_CLK : out std_logic;
      FSL14_S_READ : out std_logic;
      FSL14_S_DATA : in std_logic_vector(0 to 31);
      FSL14_S_CONTROL : in std_logic;
      FSL14_S_EXISTS : in std_logic;
      FSL14_M_CLK : out std_logic;
      FSL14_M_WRITE : out std_logic;
      FSL14_M_DATA : out std_logic_vector(0 to 31);
      FSL14_M_CONTROL : out std_logic;
      FSL14_M_FULL : in std_logic;
      FSL15_S_CLK : out std_logic;
      FSL15_S_READ : out std_logic;
      FSL15_S_DATA : in std_logic_vector(0 to 31);
      FSL15_S_CONTROL : in std_logic;
      FSL15_S_EXISTS : in std_logic;
      FSL15_M_CLK : out std_logic;
      FSL15_M_WRITE : out std_logic;
      FSL15_M_DATA : out std_logic_vector(0 to 31);
      FSL15_M_CONTROL : out std_logic;
      FSL15_M_FULL : in std_logic;
      ICACHE_FSL_IN_CLK : out std_logic;
      ICACHE_FSL_IN_READ : out std_logic;
      ICACHE_FSL_IN_DATA : in std_logic_vector(0 to 31);
      ICACHE_FSL_IN_CONTROL : in std_logic;
      ICACHE_FSL_IN_EXISTS : in std_logic;
      ICACHE_FSL_OUT_CLK : out std_logic;
      ICACHE_FSL_OUT_WRITE : out std_logic;
      ICACHE_FSL_OUT_DATA : out std_logic_vector(0 to 31);
      ICACHE_FSL_OUT_CONTROL : out std_logic;
      ICACHE_FSL_OUT_FULL : in std_logic;
      DCACHE_FSL_IN_CLK : out std_logic;
      DCACHE_FSL_IN_READ : out std_logic;
      DCACHE_FSL_IN_DATA : in std_logic_vector(0 to 31);
      DCACHE_FSL_IN_CONTROL : in std_logic;
      DCACHE_FSL_IN_EXISTS : in std_logic;
      DCACHE_FSL_OUT_CLK : out std_logic;
      DCACHE_FSL_OUT_WRITE : out std_logic;
      DCACHE_FSL_OUT_DATA : out std_logic_vector(0 to 31);
      DCACHE_FSL_OUT_CONTROL : out std_logic;
      DCACHE_FSL_OUT_FULL : in std_logic
    );
  end component;

  component mb_ilmb_wrapper is
    port (
      LMB_Clk : in std_logic;
      SYS_Rst : in std_logic;
      LMB_Rst : out std_logic;
      M_ABus : in std_logic_vector(0 to 31);
      M_ReadStrobe : in std_logic;
      M_WriteStrobe : in std_logic;
      M_AddrStrobe : in std_logic;
      M_DBus : in std_logic_vector(0 to 31);
      M_BE : in std_logic_vector(0 to 3);
      Sl_DBus : in std_logic_vector(0 to 31);
      Sl_Ready : in std_logic_vector(0 to 0);
      LMB_ABus : out std_logic_vector(0 to 31);
      LMB_ReadStrobe : out std_logic;
      LMB_WriteStrobe : out std_logic;
      LMB_AddrStrobe : out std_logic;
      LMB_ReadDBus : out std_logic_vector(0 to 31);
      LMB_WriteDBus : out std_logic_vector(0 to 31);
      LMB_Ready : out std_logic;
      LMB_BE : out std_logic_vector(0 to 3)
    );
  end component;

  component mb_dlmb_wrapper is
    port (
      LMB_Clk : in std_logic;
      SYS_Rst : in std_logic;
      LMB_Rst : out std_logic;
      M_ABus : in std_logic_vector(0 to 31);
      M_ReadStrobe : in std_logic;
      M_WriteStrobe : in std_logic;
      M_AddrStrobe : in std_logic;
      M_DBus : in std_logic_vector(0 to 31);
      M_BE : in std_logic_vector(0 to 3);
      Sl_DBus : in std_logic_vector(0 to 31);
      Sl_Ready : in std_logic_vector(0 to 0);
      LMB_ABus : out std_logic_vector(0 to 31);
      LMB_ReadStrobe : out std_logic;
      LMB_WriteStrobe : out std_logic;
      LMB_AddrStrobe : out std_logic;
      LMB_ReadDBus : out std_logic_vector(0 to 31);
      LMB_WriteDBus : out std_logic_vector(0 to 31);
      LMB_Ready : out std_logic;
      LMB_BE : out std_logic_vector(0 to 3)
    );
  end component;

  component ilmb_cntlr_wrapper is
    port (
      LMB_Clk : in std_logic;
      LMB_Rst : in std_logic;
      LMB_ABus : in std_logic_vector(0 to 31);
      LMB_WriteDBus : in std_logic_vector(0 to 31);
      LMB_AddrStrobe : in std_logic;
      LMB_ReadStrobe : in std_logic;
      LMB_WriteStrobe : in std_logic;
      LMB_BE : in std_logic_vector(0 to 3);
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_Ready : out std_logic;
      BRAM_Rst_A : out std_logic;
      BRAM_Clk_A : out std_logic;
      BRAM_EN_A : out std_logic;
      BRAM_WEN_A : out std_logic_vector(0 to 3);
      BRAM_Addr_A : out std_logic_vector(0 to 31);
      BRAM_Din_A : in std_logic_vector(0 to 31);
      BRAM_Dout_A : out std_logic_vector(0 to 31)
    );
  end component;

  component dlmb_cntlr_wrapper is
    port (
      LMB_Clk : in std_logic;
      LMB_Rst : in std_logic;
      LMB_ABus : in std_logic_vector(0 to 31);
      LMB_WriteDBus : in std_logic_vector(0 to 31);
      LMB_AddrStrobe : in std_logic;
      LMB_ReadStrobe : in std_logic;
      LMB_WriteStrobe : in std_logic;
      LMB_BE : in std_logic_vector(0 to 3);
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_Ready : out std_logic;
      BRAM_Rst_A : out std_logic;
      BRAM_Clk_A : out std_logic;
      BRAM_EN_A : out std_logic;
      BRAM_WEN_A : out std_logic_vector(0 to 3);
      BRAM_Addr_A : out std_logic_vector(0 to 31);
      BRAM_Din_A : in std_logic_vector(0 to 31);
      BRAM_Dout_A : out std_logic_vector(0 to 31)
    );
  end component;

  component mb_bram_wrapper is
    port (
      BRAM_Rst_A : in std_logic;
      BRAM_Clk_A : in std_logic;
      BRAM_EN_A : in std_logic;
      BRAM_WEN_A : in std_logic_vector(0 to 3);
      BRAM_Addr_A : in std_logic_vector(0 to 31);
      BRAM_Din_A : out std_logic_vector(0 to 31);
      BRAM_Dout_A : in std_logic_vector(0 to 31);
      BRAM_Rst_B : in std_logic;
      BRAM_Clk_B : in std_logic;
      BRAM_EN_B : in std_logic;
      BRAM_WEN_B : in std_logic_vector(0 to 3);
      BRAM_Addr_B : in std_logic_vector(0 to 31);
      BRAM_Din_B : out std_logic_vector(0 to 31);
      BRAM_Dout_B : in std_logic_vector(0 to 31)
    );
  end component;

  component mdm_0_wrapper is
    port (
      Interrupt : out std_logic;
      Debug_SYS_Rst : out std_logic;
      Ext_BRK : out std_logic;
      Ext_NM_BRK : out std_logic;
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 2);
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to 15);
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_lockErr : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to 127);
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_wrBTerm : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 127);
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_rdBTerm : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 7);
      Sl_MWrErr : out std_logic_vector(0 to 7);
      Sl_MRdErr : out std_logic_vector(0 to 7);
      Sl_MIRQ : out std_logic_vector(0 to 7);
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      OPB_DBus : in std_logic_vector(0 to 31);
      MDM_DBus : out std_logic_vector(0 to 31);
      MDM_errAck : out std_logic;
      MDM_retry : out std_logic;
      MDM_toutSup : out std_logic;
      MDM_xferAck : out std_logic;
      Dbg_Clk_0 : out std_logic;
      Dbg_TDI_0 : out std_logic;
      Dbg_TDO_0 : in std_logic;
      Dbg_Reg_En_0 : out std_logic_vector(0 to 4);
      Dbg_Capture_0 : out std_logic;
      Dbg_Shift_0 : out std_logic;
      Dbg_Update_0 : out std_logic;
      Dbg_Rst_0 : out std_logic;
      Dbg_Clk_1 : out std_logic;
      Dbg_TDI_1 : out std_logic;
      Dbg_TDO_1 : in std_logic;
      Dbg_Reg_En_1 : out std_logic_vector(0 to 4);
      Dbg_Capture_1 : out std_logic;
      Dbg_Shift_1 : out std_logic;
      Dbg_Update_1 : out std_logic;
      Dbg_Rst_1 : out std_logic;
      Dbg_Clk_2 : out std_logic;
      Dbg_TDI_2 : out std_logic;
      Dbg_TDO_2 : in std_logic;
      Dbg_Reg_En_2 : out std_logic_vector(0 to 4);
      Dbg_Capture_2 : out std_logic;
      Dbg_Shift_2 : out std_logic;
      Dbg_Update_2 : out std_logic;
      Dbg_Rst_2 : out std_logic;
      Dbg_Clk_3 : out std_logic;
      Dbg_TDI_3 : out std_logic;
      Dbg_TDO_3 : in std_logic;
      Dbg_Reg_En_3 : out std_logic_vector(0 to 4);
      Dbg_Capture_3 : out std_logic;
      Dbg_Shift_3 : out std_logic;
      Dbg_Update_3 : out std_logic;
      Dbg_Rst_3 : out std_logic;
      Dbg_Clk_4 : out std_logic;
      Dbg_TDI_4 : out std_logic;
      Dbg_TDO_4 : in std_logic;
      Dbg_Reg_En_4 : out std_logic_vector(0 to 4);
      Dbg_Capture_4 : out std_logic;
      Dbg_Shift_4 : out std_logic;
      Dbg_Update_4 : out std_logic;
      Dbg_Rst_4 : out std_logic;
      Dbg_Clk_5 : out std_logic;
      Dbg_TDI_5 : out std_logic;
      Dbg_TDO_5 : in std_logic;
      Dbg_Reg_En_5 : out std_logic_vector(0 to 4);
      Dbg_Capture_5 : out std_logic;
      Dbg_Shift_5 : out std_logic;
      Dbg_Update_5 : out std_logic;
      Dbg_Rst_5 : out std_logic;
      Dbg_Clk_6 : out std_logic;
      Dbg_TDI_6 : out std_logic;
      Dbg_TDO_6 : in std_logic;
      Dbg_Reg_En_6 : out std_logic_vector(0 to 4);
      Dbg_Capture_6 : out std_logic;
      Dbg_Shift_6 : out std_logic;
      Dbg_Update_6 : out std_logic;
      Dbg_Rst_6 : out std_logic;
      Dbg_Clk_7 : out std_logic;
      Dbg_TDI_7 : out std_logic;
      Dbg_TDO_7 : in std_logic;
      Dbg_Reg_En_7 : out std_logic_vector(0 to 4);
      Dbg_Capture_7 : out std_logic;
      Dbg_Shift_7 : out std_logic;
      Dbg_Update_7 : out std_logic;
      Dbg_Rst_7 : out std_logic;
      bscan_tdi : out std_logic;
      bscan_reset : out std_logic;
      bscan_shift : out std_logic;
      bscan_update : out std_logic;
      bscan_capture : out std_logic;
      bscan_sel1 : out std_logic;
      bscan_drck1 : out std_logic;
      bscan_tdo1 : in std_logic;
      FSL0_S_CLK : out std_logic;
      FSL0_S_READ : out std_logic;
      FSL0_S_DATA : in std_logic_vector(0 to 31);
      FSL0_S_CONTROL : in std_logic;
      FSL0_S_EXISTS : in std_logic;
      FSL0_M_CLK : out std_logic;
      FSL0_M_WRITE : out std_logic;
      FSL0_M_DATA : out std_logic_vector(0 to 31);
      FSL0_M_CONTROL : out std_logic;
      FSL0_M_FULL : in std_logic;
      Ext_JTAG_DRCK : out std_logic;
      Ext_JTAG_RESET : out std_logic;
      Ext_JTAG_SEL : out std_logic;
      Ext_JTAG_CAPTURE : out std_logic;
      Ext_JTAG_SHIFT : out std_logic;
      Ext_JTAG_UPDATE : out std_logic;
      Ext_JTAG_TDI : out std_logic;
      Ext_JTAG_TDO : in std_logic
    );
  end component;

  component microblaze_1_wrapper is
    port (
      CLK : in std_logic;
      RESET : in std_logic;
      MB_RESET : in std_logic;
      INTERRUPT : in std_logic;
      EXT_BRK : in std_logic;
      EXT_NM_BRK : in std_logic;
      DBG_STOP : in std_logic;
      MB_Halted : out std_logic;
      INSTR : in std_logic_vector(0 to 31);
      I_ADDRTAG : out std_logic_vector(0 to 3);
      IREADY : in std_logic;
      IWAIT : in std_logic;
      INSTR_ADDR : out std_logic_vector(0 to 31);
      IFETCH : out std_logic;
      I_AS : out std_logic;
      IPLB_M_ABort : out std_logic;
      IPLB_M_ABus : out std_logic_vector(0 to 31);
      IPLB_M_UABus : out std_logic_vector(0 to 31);
      IPLB_M_BE : out std_logic_vector(0 to 3);
      IPLB_M_busLock : out std_logic;
      IPLB_M_lockErr : out std_logic;
      IPLB_M_MSize : out std_logic_vector(0 to 1);
      IPLB_M_priority : out std_logic_vector(0 to 1);
      IPLB_M_rdBurst : out std_logic;
      IPLB_M_request : out std_logic;
      IPLB_M_RNW : out std_logic;
      IPLB_M_size : out std_logic_vector(0 to 3);
      IPLB_M_TAttribute : out std_logic_vector(0 to 15);
      IPLB_M_type : out std_logic_vector(0 to 2);
      IPLB_M_wrBurst : out std_logic;
      IPLB_M_wrDBus : out std_logic_vector(0 to 31);
      IPLB_MBusy : in std_logic;
      IPLB_MRdErr : in std_logic;
      IPLB_MWrErr : in std_logic;
      IPLB_MIRQ : in std_logic;
      IPLB_MWrBTerm : in std_logic;
      IPLB_MWrDAck : in std_logic;
      IPLB_MAddrAck : in std_logic;
      IPLB_MRdBTerm : in std_logic;
      IPLB_MRdDAck : in std_logic;
      IPLB_MRdDBus : in std_logic_vector(0 to 31);
      IPLB_MRdWdAddr : in std_logic_vector(0 to 3);
      IPLB_MRearbitrate : in std_logic;
      IPLB_MSSize : in std_logic_vector(0 to 1);
      IPLB_MTimeout : in std_logic;
      DATA_READ : in std_logic_vector(0 to 31);
      DREADY : in std_logic;
      DWAIT : in std_logic;
      DATA_WRITE : out std_logic_vector(0 to 31);
      DATA_ADDR : out std_logic_vector(0 to 31);
      D_ADDRTAG : out std_logic_vector(0 to 3);
      D_AS : out std_logic;
      READ_STROBE : out std_logic;
      WRITE_STROBE : out std_logic;
      BYTE_ENABLE : out std_logic_vector(0 to 3);
      DM_ABUS : out std_logic_vector(0 to 31);
      DM_BE : out std_logic_vector(0 to 3);
      DM_BUSLOCK : out std_logic;
      DM_DBUS : out std_logic_vector(0 to 31);
      DM_REQUEST : out std_logic;
      DM_RNW : out std_logic;
      DM_SELECT : out std_logic;
      DM_SEQADDR : out std_logic;
      DOPB_DBUS : in std_logic_vector(0 to 31);
      DOPB_ERRACK : in std_logic;
      DOPB_MGRANT : in std_logic;
      DOPB_RETRY : in std_logic;
      DOPB_TIMEOUT : in std_logic;
      DOPB_XFERACK : in std_logic;
      DPLB_M_ABort : out std_logic;
      DPLB_M_ABus : out std_logic_vector(0 to 31);
      DPLB_M_UABus : out std_logic_vector(0 to 31);
      DPLB_M_BE : out std_logic_vector(0 to 3);
      DPLB_M_busLock : out std_logic;
      DPLB_M_lockErr : out std_logic;
      DPLB_M_MSize : out std_logic_vector(0 to 1);
      DPLB_M_priority : out std_logic_vector(0 to 1);
      DPLB_M_rdBurst : out std_logic;
      DPLB_M_request : out std_logic;
      DPLB_M_RNW : out std_logic;
      DPLB_M_size : out std_logic_vector(0 to 3);
      DPLB_M_TAttribute : out std_logic_vector(0 to 15);
      DPLB_M_type : out std_logic_vector(0 to 2);
      DPLB_M_wrBurst : out std_logic;
      DPLB_M_wrDBus : out std_logic_vector(0 to 31);
      DPLB_MBusy : in std_logic;
      DPLB_MRdErr : in std_logic;
      DPLB_MWrErr : in std_logic;
      DPLB_MIRQ : in std_logic;
      DPLB_MWrBTerm : in std_logic;
      DPLB_MWrDAck : in std_logic;
      DPLB_MAddrAck : in std_logic;
      DPLB_MRdBTerm : in std_logic;
      DPLB_MRdDAck : in std_logic;
      DPLB_MRdDBus : in std_logic_vector(0 to 31);
      DPLB_MRdWdAddr : in std_logic_vector(0 to 3);
      DPLB_MRearbitrate : in std_logic;
      DPLB_MSSize : in std_logic_vector(0 to 1);
      DPLB_MTimeout : in std_logic;
      IM_ABUS : out std_logic_vector(0 to 31);
      IM_BE : out std_logic_vector(0 to 3);
      IM_BUSLOCK : out std_logic;
      IM_DBUS : out std_logic_vector(0 to 31);
      IM_REQUEST : out std_logic;
      IM_RNW : out std_logic;
      IM_SELECT : out std_logic;
      IM_SEQADDR : out std_logic;
      IOPB_DBUS : in std_logic_vector(0 to 31);
      IOPB_ERRACK : in std_logic;
      IOPB_MGRANT : in std_logic;
      IOPB_RETRY : in std_logic;
      IOPB_TIMEOUT : in std_logic;
      IOPB_XFERACK : in std_logic;
      DBG_CLK : in std_logic;
      DBG_TDI : in std_logic;
      DBG_TDO : out std_logic;
      DBG_REG_EN : in std_logic_vector(0 to 4);
      DBG_SHIFT : in std_logic;
      DBG_CAPTURE : in std_logic;
      DBG_UPDATE : in std_logic;
      DEBUG_RST : in std_logic;
      Trace_Instruction : out std_logic_vector(0 to 31);
      Trace_Valid_Instr : out std_logic;
      Trace_PC : out std_logic_vector(0 to 31);
      Trace_Reg_Write : out std_logic;
      Trace_Reg_Addr : out std_logic_vector(0 to 4);
      Trace_MSR_Reg : out std_logic_vector(0 to 14);
      Trace_PID_Reg : out std_logic_vector(0 to 7);
      Trace_New_Reg_Value : out std_logic_vector(0 to 31);
      Trace_Exception_Taken : out std_logic;
      Trace_Exception_Kind : out std_logic_vector(0 to 4);
      Trace_Jump_Taken : out std_logic;
      Trace_Delay_Slot : out std_logic;
      Trace_Data_Address : out std_logic_vector(0 to 31);
      Trace_Data_Access : out std_logic;
      Trace_Data_Read : out std_logic;
      Trace_Data_Write : out std_logic;
      Trace_Data_Write_Value : out std_logic_vector(0 to 31);
      Trace_Data_Byte_Enable : out std_logic_vector(0 to 3);
      Trace_DCache_Req : out std_logic;
      Trace_DCache_Hit : out std_logic;
      Trace_ICache_Req : out std_logic;
      Trace_ICache_Hit : out std_logic;
      Trace_OF_PipeRun : out std_logic;
      Trace_EX_PipeRun : out std_logic;
      Trace_MEM_PipeRun : out std_logic;
      Trace_MB_Halted : out std_logic;
      FSL0_S_CLK : out std_logic;
      FSL0_S_READ : out std_logic;
      FSL0_S_DATA : in std_logic_vector(0 to 31);
      FSL0_S_CONTROL : in std_logic;
      FSL0_S_EXISTS : in std_logic;
      FSL0_M_CLK : out std_logic;
      FSL0_M_WRITE : out std_logic;
      FSL0_M_DATA : out std_logic_vector(0 to 31);
      FSL0_M_CONTROL : out std_logic;
      FSL0_M_FULL : in std_logic;
      FSL1_S_CLK : out std_logic;
      FSL1_S_READ : out std_logic;
      FSL1_S_DATA : in std_logic_vector(0 to 31);
      FSL1_S_CONTROL : in std_logic;
      FSL1_S_EXISTS : in std_logic;
      FSL1_M_CLK : out std_logic;
      FSL1_M_WRITE : out std_logic;
      FSL1_M_DATA : out std_logic_vector(0 to 31);
      FSL1_M_CONTROL : out std_logic;
      FSL1_M_FULL : in std_logic;
      FSL2_S_CLK : out std_logic;
      FSL2_S_READ : out std_logic;
      FSL2_S_DATA : in std_logic_vector(0 to 31);
      FSL2_S_CONTROL : in std_logic;
      FSL2_S_EXISTS : in std_logic;
      FSL2_M_CLK : out std_logic;
      FSL2_M_WRITE : out std_logic;
      FSL2_M_DATA : out std_logic_vector(0 to 31);
      FSL2_M_CONTROL : out std_logic;
      FSL2_M_FULL : in std_logic;
      FSL3_S_CLK : out std_logic;
      FSL3_S_READ : out std_logic;
      FSL3_S_DATA : in std_logic_vector(0 to 31);
      FSL3_S_CONTROL : in std_logic;
      FSL3_S_EXISTS : in std_logic;
      FSL3_M_CLK : out std_logic;
      FSL3_M_WRITE : out std_logic;
      FSL3_M_DATA : out std_logic_vector(0 to 31);
      FSL3_M_CONTROL : out std_logic;
      FSL3_M_FULL : in std_logic;
      FSL4_S_CLK : out std_logic;
      FSL4_S_READ : out std_logic;
      FSL4_S_DATA : in std_logic_vector(0 to 31);
      FSL4_S_CONTROL : in std_logic;
      FSL4_S_EXISTS : in std_logic;
      FSL4_M_CLK : out std_logic;
      FSL4_M_WRITE : out std_logic;
      FSL4_M_DATA : out std_logic_vector(0 to 31);
      FSL4_M_CONTROL : out std_logic;
      FSL4_M_FULL : in std_logic;
      FSL5_S_CLK : out std_logic;
      FSL5_S_READ : out std_logic;
      FSL5_S_DATA : in std_logic_vector(0 to 31);
      FSL5_S_CONTROL : in std_logic;
      FSL5_S_EXISTS : in std_logic;
      FSL5_M_CLK : out std_logic;
      FSL5_M_WRITE : out std_logic;
      FSL5_M_DATA : out std_logic_vector(0 to 31);
      FSL5_M_CONTROL : out std_logic;
      FSL5_M_FULL : in std_logic;
      FSL6_S_CLK : out std_logic;
      FSL6_S_READ : out std_logic;
      FSL6_S_DATA : in std_logic_vector(0 to 31);
      FSL6_S_CONTROL : in std_logic;
      FSL6_S_EXISTS : in std_logic;
      FSL6_M_CLK : out std_logic;
      FSL6_M_WRITE : out std_logic;
      FSL6_M_DATA : out std_logic_vector(0 to 31);
      FSL6_M_CONTROL : out std_logic;
      FSL6_M_FULL : in std_logic;
      FSL7_S_CLK : out std_logic;
      FSL7_S_READ : out std_logic;
      FSL7_S_DATA : in std_logic_vector(0 to 31);
      FSL7_S_CONTROL : in std_logic;
      FSL7_S_EXISTS : in std_logic;
      FSL7_M_CLK : out std_logic;
      FSL7_M_WRITE : out std_logic;
      FSL7_M_DATA : out std_logic_vector(0 to 31);
      FSL7_M_CONTROL : out std_logic;
      FSL7_M_FULL : in std_logic;
      FSL8_S_CLK : out std_logic;
      FSL8_S_READ : out std_logic;
      FSL8_S_DATA : in std_logic_vector(0 to 31);
      FSL8_S_CONTROL : in std_logic;
      FSL8_S_EXISTS : in std_logic;
      FSL8_M_CLK : out std_logic;
      FSL8_M_WRITE : out std_logic;
      FSL8_M_DATA : out std_logic_vector(0 to 31);
      FSL8_M_CONTROL : out std_logic;
      FSL8_M_FULL : in std_logic;
      FSL9_S_CLK : out std_logic;
      FSL9_S_READ : out std_logic;
      FSL9_S_DATA : in std_logic_vector(0 to 31);
      FSL9_S_CONTROL : in std_logic;
      FSL9_S_EXISTS : in std_logic;
      FSL9_M_CLK : out std_logic;
      FSL9_M_WRITE : out std_logic;
      FSL9_M_DATA : out std_logic_vector(0 to 31);
      FSL9_M_CONTROL : out std_logic;
      FSL9_M_FULL : in std_logic;
      FSL10_S_CLK : out std_logic;
      FSL10_S_READ : out std_logic;
      FSL10_S_DATA : in std_logic_vector(0 to 31);
      FSL10_S_CONTROL : in std_logic;
      FSL10_S_EXISTS : in std_logic;
      FSL10_M_CLK : out std_logic;
      FSL10_M_WRITE : out std_logic;
      FSL10_M_DATA : out std_logic_vector(0 to 31);
      FSL10_M_CONTROL : out std_logic;
      FSL10_M_FULL : in std_logic;
      FSL11_S_CLK : out std_logic;
      FSL11_S_READ : out std_logic;
      FSL11_S_DATA : in std_logic_vector(0 to 31);
      FSL11_S_CONTROL : in std_logic;
      FSL11_S_EXISTS : in std_logic;
      FSL11_M_CLK : out std_logic;
      FSL11_M_WRITE : out std_logic;
      FSL11_M_DATA : out std_logic_vector(0 to 31);
      FSL11_M_CONTROL : out std_logic;
      FSL11_M_FULL : in std_logic;
      FSL12_S_CLK : out std_logic;
      FSL12_S_READ : out std_logic;
      FSL12_S_DATA : in std_logic_vector(0 to 31);
      FSL12_S_CONTROL : in std_logic;
      FSL12_S_EXISTS : in std_logic;
      FSL12_M_CLK : out std_logic;
      FSL12_M_WRITE : out std_logic;
      FSL12_M_DATA : out std_logic_vector(0 to 31);
      FSL12_M_CONTROL : out std_logic;
      FSL12_M_FULL : in std_logic;
      FSL13_S_CLK : out std_logic;
      FSL13_S_READ : out std_logic;
      FSL13_S_DATA : in std_logic_vector(0 to 31);
      FSL13_S_CONTROL : in std_logic;
      FSL13_S_EXISTS : in std_logic;
      FSL13_M_CLK : out std_logic;
      FSL13_M_WRITE : out std_logic;
      FSL13_M_DATA : out std_logic_vector(0 to 31);
      FSL13_M_CONTROL : out std_logic;
      FSL13_M_FULL : in std_logic;
      FSL14_S_CLK : out std_logic;
      FSL14_S_READ : out std_logic;
      FSL14_S_DATA : in std_logic_vector(0 to 31);
      FSL14_S_CONTROL : in std_logic;
      FSL14_S_EXISTS : in std_logic;
      FSL14_M_CLK : out std_logic;
      FSL14_M_WRITE : out std_logic;
      FSL14_M_DATA : out std_logic_vector(0 to 31);
      FSL14_M_CONTROL : out std_logic;
      FSL14_M_FULL : in std_logic;
      FSL15_S_CLK : out std_logic;
      FSL15_S_READ : out std_logic;
      FSL15_S_DATA : in std_logic_vector(0 to 31);
      FSL15_S_CONTROL : in std_logic;
      FSL15_S_EXISTS : in std_logic;
      FSL15_M_CLK : out std_logic;
      FSL15_M_WRITE : out std_logic;
      FSL15_M_DATA : out std_logic_vector(0 to 31);
      FSL15_M_CONTROL : out std_logic;
      FSL15_M_FULL : in std_logic;
      ICACHE_FSL_IN_CLK : out std_logic;
      ICACHE_FSL_IN_READ : out std_logic;
      ICACHE_FSL_IN_DATA : in std_logic_vector(0 to 31);
      ICACHE_FSL_IN_CONTROL : in std_logic;
      ICACHE_FSL_IN_EXISTS : in std_logic;
      ICACHE_FSL_OUT_CLK : out std_logic;
      ICACHE_FSL_OUT_WRITE : out std_logic;
      ICACHE_FSL_OUT_DATA : out std_logic_vector(0 to 31);
      ICACHE_FSL_OUT_CONTROL : out std_logic;
      ICACHE_FSL_OUT_FULL : in std_logic;
      DCACHE_FSL_IN_CLK : out std_logic;
      DCACHE_FSL_IN_READ : out std_logic;
      DCACHE_FSL_IN_DATA : in std_logic_vector(0 to 31);
      DCACHE_FSL_IN_CONTROL : in std_logic;
      DCACHE_FSL_IN_EXISTS : in std_logic;
      DCACHE_FSL_OUT_CLK : out std_logic;
      DCACHE_FSL_OUT_WRITE : out std_logic;
      DCACHE_FSL_OUT_DATA : out std_logic_vector(0 to 31);
      DCACHE_FSL_OUT_CONTROL : out std_logic;
      DCACHE_FSL_OUT_FULL : in std_logic
    );
  end component;

  component mb_ilmb1_wrapper is
    port (
      LMB_Clk : in std_logic;
      SYS_Rst : in std_logic;
      LMB_Rst : out std_logic;
      M_ABus : in std_logic_vector(0 to 31);
      M_ReadStrobe : in std_logic;
      M_WriteStrobe : in std_logic;
      M_AddrStrobe : in std_logic;
      M_DBus : in std_logic_vector(0 to 31);
      M_BE : in std_logic_vector(0 to 3);
      Sl_DBus : in std_logic_vector(0 to 31);
      Sl_Ready : in std_logic_vector(0 to 0);
      LMB_ABus : out std_logic_vector(0 to 31);
      LMB_ReadStrobe : out std_logic;
      LMB_WriteStrobe : out std_logic;
      LMB_AddrStrobe : out std_logic;
      LMB_ReadDBus : out std_logic_vector(0 to 31);
      LMB_WriteDBus : out std_logic_vector(0 to 31);
      LMB_Ready : out std_logic;
      LMB_BE : out std_logic_vector(0 to 3)
    );
  end component;

  component mb_dlmb1_wrapper is
    port (
      LMB_Clk : in std_logic;
      SYS_Rst : in std_logic;
      LMB_Rst : out std_logic;
      M_ABus : in std_logic_vector(0 to 31);
      M_ReadStrobe : in std_logic;
      M_WriteStrobe : in std_logic;
      M_AddrStrobe : in std_logic;
      M_DBus : in std_logic_vector(0 to 31);
      M_BE : in std_logic_vector(0 to 3);
      Sl_DBus : in std_logic_vector(0 to 31);
      Sl_Ready : in std_logic_vector(0 to 0);
      LMB_ABus : out std_logic_vector(0 to 31);
      LMB_ReadStrobe : out std_logic;
      LMB_WriteStrobe : out std_logic;
      LMB_AddrStrobe : out std_logic;
      LMB_ReadDBus : out std_logic_vector(0 to 31);
      LMB_WriteDBus : out std_logic_vector(0 to 31);
      LMB_Ready : out std_logic;
      LMB_BE : out std_logic_vector(0 to 3)
    );
  end component;

  component ilmb_cntlr1_wrapper is
    port (
      LMB_Clk : in std_logic;
      LMB_Rst : in std_logic;
      LMB_ABus : in std_logic_vector(0 to 31);
      LMB_WriteDBus : in std_logic_vector(0 to 31);
      LMB_AddrStrobe : in std_logic;
      LMB_ReadStrobe : in std_logic;
      LMB_WriteStrobe : in std_logic;
      LMB_BE : in std_logic_vector(0 to 3);
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_Ready : out std_logic;
      BRAM_Rst_A : out std_logic;
      BRAM_Clk_A : out std_logic;
      BRAM_EN_A : out std_logic;
      BRAM_WEN_A : out std_logic_vector(0 to 3);
      BRAM_Addr_A : out std_logic_vector(0 to 31);
      BRAM_Din_A : in std_logic_vector(0 to 31);
      BRAM_Dout_A : out std_logic_vector(0 to 31)
    );
  end component;

  component dlmb_cntlr1_wrapper is
    port (
      LMB_Clk : in std_logic;
      LMB_Rst : in std_logic;
      LMB_ABus : in std_logic_vector(0 to 31);
      LMB_WriteDBus : in std_logic_vector(0 to 31);
      LMB_AddrStrobe : in std_logic;
      LMB_ReadStrobe : in std_logic;
      LMB_WriteStrobe : in std_logic;
      LMB_BE : in std_logic_vector(0 to 3);
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_Ready : out std_logic;
      BRAM_Rst_A : out std_logic;
      BRAM_Clk_A : out std_logic;
      BRAM_EN_A : out std_logic;
      BRAM_WEN_A : out std_logic_vector(0 to 3);
      BRAM_Addr_A : out std_logic_vector(0 to 31);
      BRAM_Din_A : in std_logic_vector(0 to 31);
      BRAM_Dout_A : out std_logic_vector(0 to 31)
    );
  end component;

  component mb_bram1_wrapper is
    port (
      BRAM_Rst_A : in std_logic;
      BRAM_Clk_A : in std_logic;
      BRAM_EN_A : in std_logic;
      BRAM_WEN_A : in std_logic_vector(0 to 3);
      BRAM_Addr_A : in std_logic_vector(0 to 31);
      BRAM_Din_A : out std_logic_vector(0 to 31);
      BRAM_Dout_A : in std_logic_vector(0 to 31);
      BRAM_Rst_B : in std_logic;
      BRAM_Clk_B : in std_logic;
      BRAM_EN_B : in std_logic;
      BRAM_WEN_B : in std_logic_vector(0 to 3);
      BRAM_Addr_B : in std_logic_vector(0 to 31);
      BRAM_Din_B : out std_logic_vector(0 to 31);
      BRAM_Dout_B : in std_logic_vector(0 to 31)
    );
  end component;

  component mb0_plb_bridge_wrapper is
    port (
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      IP2INTC_Irpt : out std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 0);
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to 3);
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_lockErr : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to 31);
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_wrBTerm : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 31);
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_rdBTerm : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 1);
      Sl_MWrErr : out std_logic_vector(0 to 1);
      Sl_MRdErr : out std_logic_vector(0 to 1);
      Sl_MIRQ : out std_logic_vector(0 to 1);
      MPLB_Clk : in std_logic;
      MPLB_Rst : in std_logic;
      M_request : out std_logic;
      M_priority : out std_logic_vector(0 to 1);
      M_busLock : out std_logic;
      M_RNW : out std_logic;
      M_BE : out std_logic_vector(0 to 15);
      M_MSize : out std_logic_vector(0 to 1);
      M_size : out std_logic_vector(0 to 3);
      M_type : out std_logic_vector(0 to 2);
      M_ABus : out std_logic_vector(0 to 31);
      M_wrBurst : out std_logic;
      M_rdBurst : out std_logic;
      M_wrDBus : out std_logic_vector(0 to 127);
      PLB_MAddrAck : in std_logic;
      PLB_MSSize : in std_logic_vector(0 to 1);
      PLB_MRearbitrate : in std_logic;
      PLB_MTimeout : in std_logic;
      PLB_MRdErr : in std_logic;
      PLB_MWrErr : in std_logic;
      PLB_MRdDBus : in std_logic_vector(0 to 127);
      PLB_MRdDAck : in std_logic;
      PLB_MRdBTerm : in std_logic;
      PLB_MWrDAck : in std_logic;
      PLB_MWrBTerm : in std_logic;
      M_TAttribute : out std_logic_vector(0 to 15);
      M_lockErr : out std_logic;
      M_abort : out std_logic;
      M_UABus : out std_logic_vector(0 to 31);
      PLB_MBusy : in std_logic;
      PLB_MIRQ : in std_logic;
      PLB_MRdWdAddr : in std_logic_vector(0 to 3)
    );
  end component;

  component mb0_plb_bus_wrapper is
    port (
      PLB_Clk : in std_logic;
      SYS_Rst : in std_logic;
      PLB_Rst : out std_logic;
      SPLB_Rst : out std_logic_vector(0 to 0);
      MPLB_Rst : out std_logic_vector(0 to 1);
      PLB_dcrAck : out std_logic;
      PLB_dcrDBus : out std_logic_vector(0 to 31);
      DCR_ABus : in std_logic_vector(0 to 9);
      DCR_DBus : in std_logic_vector(0 to 31);
      DCR_Read : in std_logic;
      DCR_Write : in std_logic;
      M_ABus : in std_logic_vector(0 to 63);
      M_UABus : in std_logic_vector(0 to 63);
      M_BE : in std_logic_vector(0 to 7);
      M_RNW : in std_logic_vector(0 to 1);
      M_abort : in std_logic_vector(0 to 1);
      M_busLock : in std_logic_vector(0 to 1);
      M_TAttribute : in std_logic_vector(0 to 31);
      M_lockErr : in std_logic_vector(0 to 1);
      M_MSize : in std_logic_vector(0 to 3);
      M_priority : in std_logic_vector(0 to 3);
      M_rdBurst : in std_logic_vector(0 to 1);
      M_request : in std_logic_vector(0 to 1);
      M_size : in std_logic_vector(0 to 7);
      M_type : in std_logic_vector(0 to 5);
      M_wrBurst : in std_logic_vector(0 to 1);
      M_wrDBus : in std_logic_vector(0 to 63);
      Sl_addrAck : in std_logic_vector(0 to 0);
      Sl_MRdErr : in std_logic_vector(0 to 1);
      Sl_MWrErr : in std_logic_vector(0 to 1);
      Sl_MBusy : in std_logic_vector(0 to 1);
      Sl_rdBTerm : in std_logic_vector(0 to 0);
      Sl_rdComp : in std_logic_vector(0 to 0);
      Sl_rdDAck : in std_logic_vector(0 to 0);
      Sl_rdDBus : in std_logic_vector(0 to 31);
      Sl_rdWdAddr : in std_logic_vector(0 to 3);
      Sl_rearbitrate : in std_logic_vector(0 to 0);
      Sl_SSize : in std_logic_vector(0 to 1);
      Sl_wait : in std_logic_vector(0 to 0);
      Sl_wrBTerm : in std_logic_vector(0 to 0);
      Sl_wrComp : in std_logic_vector(0 to 0);
      Sl_wrDAck : in std_logic_vector(0 to 0);
      Sl_MIRQ : in std_logic_vector(0 to 1);
      PLB_MIRQ : out std_logic_vector(0 to 1);
      PLB_ABus : out std_logic_vector(0 to 31);
      PLB_UABus : out std_logic_vector(0 to 31);
      PLB_BE : out std_logic_vector(0 to 3);
      PLB_MAddrAck : out std_logic_vector(0 to 1);
      PLB_MTimeout : out std_logic_vector(0 to 1);
      PLB_MBusy : out std_logic_vector(0 to 1);
      PLB_MRdErr : out std_logic_vector(0 to 1);
      PLB_MWrErr : out std_logic_vector(0 to 1);
      PLB_MRdBTerm : out std_logic_vector(0 to 1);
      PLB_MRdDAck : out std_logic_vector(0 to 1);
      PLB_MRdDBus : out std_logic_vector(0 to 63);
      PLB_MRdWdAddr : out std_logic_vector(0 to 7);
      PLB_MRearbitrate : out std_logic_vector(0 to 1);
      PLB_MWrBTerm : out std_logic_vector(0 to 1);
      PLB_MWrDAck : out std_logic_vector(0 to 1);
      PLB_MSSize : out std_logic_vector(0 to 3);
      PLB_PAValid : out std_logic;
      PLB_RNW : out std_logic;
      PLB_SAValid : out std_logic;
      PLB_abort : out std_logic;
      PLB_busLock : out std_logic;
      PLB_TAttribute : out std_logic_vector(0 to 15);
      PLB_lockErr : out std_logic;
      PLB_masterID : out std_logic_vector(0 to 0);
      PLB_MSize : out std_logic_vector(0 to 1);
      PLB_rdPendPri : out std_logic_vector(0 to 1);
      PLB_wrPendPri : out std_logic_vector(0 to 1);
      PLB_rdPendReq : out std_logic;
      PLB_wrPendReq : out std_logic;
      PLB_rdBurst : out std_logic;
      PLB_rdPrim : out std_logic_vector(0 to 0);
      PLB_reqPri : out std_logic_vector(0 to 1);
      PLB_size : out std_logic_vector(0 to 3);
      PLB_type : out std_logic_vector(0 to 2);
      PLB_wrBurst : out std_logic;
      PLB_wrDBus : out std_logic_vector(0 to 31);
      PLB_wrPrim : out std_logic_vector(0 to 0);
      PLB_SaddrAck : out std_logic;
      PLB_SMRdErr : out std_logic_vector(0 to 1);
      PLB_SMWrErr : out std_logic_vector(0 to 1);
      PLB_SMBusy : out std_logic_vector(0 to 1);
      PLB_SrdBTerm : out std_logic;
      PLB_SrdComp : out std_logic;
      PLB_SrdDAck : out std_logic;
      PLB_SrdDBus : out std_logic_vector(0 to 31);
      PLB_SrdWdAddr : out std_logic_vector(0 to 3);
      PLB_Srearbitrate : out std_logic;
      PLB_Sssize : out std_logic_vector(0 to 1);
      PLB_Swait : out std_logic;
      PLB_SwrBTerm : out std_logic;
      PLB_SwrComp : out std_logic;
      PLB_SwrDAck : out std_logic;
      Bus_Error_Det : out std_logic
    );
  end component;

  component mb1_plb_bridge_wrapper is
    port (
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      IP2INTC_Irpt : out std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 0);
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to 3);
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_lockErr : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to 31);
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_wrBTerm : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 31);
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_rdBTerm : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 1);
      Sl_MWrErr : out std_logic_vector(0 to 1);
      Sl_MRdErr : out std_logic_vector(0 to 1);
      Sl_MIRQ : out std_logic_vector(0 to 1);
      MPLB_Clk : in std_logic;
      MPLB_Rst : in std_logic;
      M_request : out std_logic;
      M_priority : out std_logic_vector(0 to 1);
      M_busLock : out std_logic;
      M_RNW : out std_logic;
      M_BE : out std_logic_vector(0 to 15);
      M_MSize : out std_logic_vector(0 to 1);
      M_size : out std_logic_vector(0 to 3);
      M_type : out std_logic_vector(0 to 2);
      M_ABus : out std_logic_vector(0 to 31);
      M_wrBurst : out std_logic;
      M_rdBurst : out std_logic;
      M_wrDBus : out std_logic_vector(0 to 127);
      PLB_MAddrAck : in std_logic;
      PLB_MSSize : in std_logic_vector(0 to 1);
      PLB_MRearbitrate : in std_logic;
      PLB_MTimeout : in std_logic;
      PLB_MRdErr : in std_logic;
      PLB_MWrErr : in std_logic;
      PLB_MRdDBus : in std_logic_vector(0 to 127);
      PLB_MRdDAck : in std_logic;
      PLB_MRdBTerm : in std_logic;
      PLB_MWrDAck : in std_logic;
      PLB_MWrBTerm : in std_logic;
      M_TAttribute : out std_logic_vector(0 to 15);
      M_lockErr : out std_logic;
      M_abort : out std_logic;
      M_UABus : out std_logic_vector(0 to 31);
      PLB_MBusy : in std_logic;
      PLB_MIRQ : in std_logic;
      PLB_MRdWdAddr : in std_logic_vector(0 to 3)
    );
  end component;

  component mb1_plb_bus_wrapper is
    port (
      PLB_Clk : in std_logic;
      SYS_Rst : in std_logic;
      PLB_Rst : out std_logic;
      SPLB_Rst : out std_logic_vector(0 to 0);
      MPLB_Rst : out std_logic_vector(0 to 1);
      PLB_dcrAck : out std_logic;
      PLB_dcrDBus : out std_logic_vector(0 to 31);
      DCR_ABus : in std_logic_vector(0 to 9);
      DCR_DBus : in std_logic_vector(0 to 31);
      DCR_Read : in std_logic;
      DCR_Write : in std_logic;
      M_ABus : in std_logic_vector(0 to 63);
      M_UABus : in std_logic_vector(0 to 63);
      M_BE : in std_logic_vector(0 to 7);
      M_RNW : in std_logic_vector(0 to 1);
      M_abort : in std_logic_vector(0 to 1);
      M_busLock : in std_logic_vector(0 to 1);
      M_TAttribute : in std_logic_vector(0 to 31);
      M_lockErr : in std_logic_vector(0 to 1);
      M_MSize : in std_logic_vector(0 to 3);
      M_priority : in std_logic_vector(0 to 3);
      M_rdBurst : in std_logic_vector(0 to 1);
      M_request : in std_logic_vector(0 to 1);
      M_size : in std_logic_vector(0 to 7);
      M_type : in std_logic_vector(0 to 5);
      M_wrBurst : in std_logic_vector(0 to 1);
      M_wrDBus : in std_logic_vector(0 to 63);
      Sl_addrAck : in std_logic_vector(0 to 0);
      Sl_MRdErr : in std_logic_vector(0 to 1);
      Sl_MWrErr : in std_logic_vector(0 to 1);
      Sl_MBusy : in std_logic_vector(0 to 1);
      Sl_rdBTerm : in std_logic_vector(0 to 0);
      Sl_rdComp : in std_logic_vector(0 to 0);
      Sl_rdDAck : in std_logic_vector(0 to 0);
      Sl_rdDBus : in std_logic_vector(0 to 31);
      Sl_rdWdAddr : in std_logic_vector(0 to 3);
      Sl_rearbitrate : in std_logic_vector(0 to 0);
      Sl_SSize : in std_logic_vector(0 to 1);
      Sl_wait : in std_logic_vector(0 to 0);
      Sl_wrBTerm : in std_logic_vector(0 to 0);
      Sl_wrComp : in std_logic_vector(0 to 0);
      Sl_wrDAck : in std_logic_vector(0 to 0);
      Sl_MIRQ : in std_logic_vector(0 to 1);
      PLB_MIRQ : out std_logic_vector(0 to 1);
      PLB_ABus : out std_logic_vector(0 to 31);
      PLB_UABus : out std_logic_vector(0 to 31);
      PLB_BE : out std_logic_vector(0 to 3);
      PLB_MAddrAck : out std_logic_vector(0 to 1);
      PLB_MTimeout : out std_logic_vector(0 to 1);
      PLB_MBusy : out std_logic_vector(0 to 1);
      PLB_MRdErr : out std_logic_vector(0 to 1);
      PLB_MWrErr : out std_logic_vector(0 to 1);
      PLB_MRdBTerm : out std_logic_vector(0 to 1);
      PLB_MRdDAck : out std_logic_vector(0 to 1);
      PLB_MRdDBus : out std_logic_vector(0 to 63);
      PLB_MRdWdAddr : out std_logic_vector(0 to 7);
      PLB_MRearbitrate : out std_logic_vector(0 to 1);
      PLB_MWrBTerm : out std_logic_vector(0 to 1);
      PLB_MWrDAck : out std_logic_vector(0 to 1);
      PLB_MSSize : out std_logic_vector(0 to 3);
      PLB_PAValid : out std_logic;
      PLB_RNW : out std_logic;
      PLB_SAValid : out std_logic;
      PLB_abort : out std_logic;
      PLB_busLock : out std_logic;
      PLB_TAttribute : out std_logic_vector(0 to 15);
      PLB_lockErr : out std_logic;
      PLB_masterID : out std_logic_vector(0 to 0);
      PLB_MSize : out std_logic_vector(0 to 1);
      PLB_rdPendPri : out std_logic_vector(0 to 1);
      PLB_wrPendPri : out std_logic_vector(0 to 1);
      PLB_rdPendReq : out std_logic;
      PLB_wrPendReq : out std_logic;
      PLB_rdBurst : out std_logic;
      PLB_rdPrim : out std_logic_vector(0 to 0);
      PLB_reqPri : out std_logic_vector(0 to 1);
      PLB_size : out std_logic_vector(0 to 3);
      PLB_type : out std_logic_vector(0 to 2);
      PLB_wrBurst : out std_logic;
      PLB_wrDBus : out std_logic_vector(0 to 31);
      PLB_wrPrim : out std_logic_vector(0 to 0);
      PLB_SaddrAck : out std_logic;
      PLB_SMRdErr : out std_logic_vector(0 to 1);
      PLB_SMWrErr : out std_logic_vector(0 to 1);
      PLB_SMBusy : out std_logic_vector(0 to 1);
      PLB_SrdBTerm : out std_logic;
      PLB_SrdComp : out std_logic;
      PLB_SrdDAck : out std_logic;
      PLB_SrdDBus : out std_logic_vector(0 to 31);
      PLB_SrdWdAddr : out std_logic_vector(0 to 3);
      PLB_Srearbitrate : out std_logic;
      PLB_Sssize : out std_logic_vector(0 to 1);
      PLB_Swait : out std_logic;
      PLB_SwrBTerm : out std_logic;
      PLB_SwrComp : out std_logic;
      PLB_SwrDAck : out std_logic;
      Bus_Error_Det : out std_logic
    );
  end component;

  component microblaze_2_wrapper is
    port (
      CLK : in std_logic;
      RESET : in std_logic;
      MB_RESET : in std_logic;
      INTERRUPT : in std_logic;
      EXT_BRK : in std_logic;
      EXT_NM_BRK : in std_logic;
      DBG_STOP : in std_logic;
      MB_Halted : out std_logic;
      INSTR : in std_logic_vector(0 to 31);
      I_ADDRTAG : out std_logic_vector(0 to 3);
      IREADY : in std_logic;
      IWAIT : in std_logic;
      INSTR_ADDR : out std_logic_vector(0 to 31);
      IFETCH : out std_logic;
      I_AS : out std_logic;
      IPLB_M_ABort : out std_logic;
      IPLB_M_ABus : out std_logic_vector(0 to 31);
      IPLB_M_UABus : out std_logic_vector(0 to 31);
      IPLB_M_BE : out std_logic_vector(0 to 3);
      IPLB_M_busLock : out std_logic;
      IPLB_M_lockErr : out std_logic;
      IPLB_M_MSize : out std_logic_vector(0 to 1);
      IPLB_M_priority : out std_logic_vector(0 to 1);
      IPLB_M_rdBurst : out std_logic;
      IPLB_M_request : out std_logic;
      IPLB_M_RNW : out std_logic;
      IPLB_M_size : out std_logic_vector(0 to 3);
      IPLB_M_TAttribute : out std_logic_vector(0 to 15);
      IPLB_M_type : out std_logic_vector(0 to 2);
      IPLB_M_wrBurst : out std_logic;
      IPLB_M_wrDBus : out std_logic_vector(0 to 31);
      IPLB_MBusy : in std_logic;
      IPLB_MRdErr : in std_logic;
      IPLB_MWrErr : in std_logic;
      IPLB_MIRQ : in std_logic;
      IPLB_MWrBTerm : in std_logic;
      IPLB_MWrDAck : in std_logic;
      IPLB_MAddrAck : in std_logic;
      IPLB_MRdBTerm : in std_logic;
      IPLB_MRdDAck : in std_logic;
      IPLB_MRdDBus : in std_logic_vector(0 to 31);
      IPLB_MRdWdAddr : in std_logic_vector(0 to 3);
      IPLB_MRearbitrate : in std_logic;
      IPLB_MSSize : in std_logic_vector(0 to 1);
      IPLB_MTimeout : in std_logic;
      DATA_READ : in std_logic_vector(0 to 31);
      DREADY : in std_logic;
      DWAIT : in std_logic;
      DATA_WRITE : out std_logic_vector(0 to 31);
      DATA_ADDR : out std_logic_vector(0 to 31);
      D_ADDRTAG : out std_logic_vector(0 to 3);
      D_AS : out std_logic;
      READ_STROBE : out std_logic;
      WRITE_STROBE : out std_logic;
      BYTE_ENABLE : out std_logic_vector(0 to 3);
      DM_ABUS : out std_logic_vector(0 to 31);
      DM_BE : out std_logic_vector(0 to 3);
      DM_BUSLOCK : out std_logic;
      DM_DBUS : out std_logic_vector(0 to 31);
      DM_REQUEST : out std_logic;
      DM_RNW : out std_logic;
      DM_SELECT : out std_logic;
      DM_SEQADDR : out std_logic;
      DOPB_DBUS : in std_logic_vector(0 to 31);
      DOPB_ERRACK : in std_logic;
      DOPB_MGRANT : in std_logic;
      DOPB_RETRY : in std_logic;
      DOPB_TIMEOUT : in std_logic;
      DOPB_XFERACK : in std_logic;
      DPLB_M_ABort : out std_logic;
      DPLB_M_ABus : out std_logic_vector(0 to 31);
      DPLB_M_UABus : out std_logic_vector(0 to 31);
      DPLB_M_BE : out std_logic_vector(0 to 3);
      DPLB_M_busLock : out std_logic;
      DPLB_M_lockErr : out std_logic;
      DPLB_M_MSize : out std_logic_vector(0 to 1);
      DPLB_M_priority : out std_logic_vector(0 to 1);
      DPLB_M_rdBurst : out std_logic;
      DPLB_M_request : out std_logic;
      DPLB_M_RNW : out std_logic;
      DPLB_M_size : out std_logic_vector(0 to 3);
      DPLB_M_TAttribute : out std_logic_vector(0 to 15);
      DPLB_M_type : out std_logic_vector(0 to 2);
      DPLB_M_wrBurst : out std_logic;
      DPLB_M_wrDBus : out std_logic_vector(0 to 31);
      DPLB_MBusy : in std_logic;
      DPLB_MRdErr : in std_logic;
      DPLB_MWrErr : in std_logic;
      DPLB_MIRQ : in std_logic;
      DPLB_MWrBTerm : in std_logic;
      DPLB_MWrDAck : in std_logic;
      DPLB_MAddrAck : in std_logic;
      DPLB_MRdBTerm : in std_logic;
      DPLB_MRdDAck : in std_logic;
      DPLB_MRdDBus : in std_logic_vector(0 to 31);
      DPLB_MRdWdAddr : in std_logic_vector(0 to 3);
      DPLB_MRearbitrate : in std_logic;
      DPLB_MSSize : in std_logic_vector(0 to 1);
      DPLB_MTimeout : in std_logic;
      IM_ABUS : out std_logic_vector(0 to 31);
      IM_BE : out std_logic_vector(0 to 3);
      IM_BUSLOCK : out std_logic;
      IM_DBUS : out std_logic_vector(0 to 31);
      IM_REQUEST : out std_logic;
      IM_RNW : out std_logic;
      IM_SELECT : out std_logic;
      IM_SEQADDR : out std_logic;
      IOPB_DBUS : in std_logic_vector(0 to 31);
      IOPB_ERRACK : in std_logic;
      IOPB_MGRANT : in std_logic;
      IOPB_RETRY : in std_logic;
      IOPB_TIMEOUT : in std_logic;
      IOPB_XFERACK : in std_logic;
      DBG_CLK : in std_logic;
      DBG_TDI : in std_logic;
      DBG_TDO : out std_logic;
      DBG_REG_EN : in std_logic_vector(0 to 4);
      DBG_SHIFT : in std_logic;
      DBG_CAPTURE : in std_logic;
      DBG_UPDATE : in std_logic;
      DEBUG_RST : in std_logic;
      Trace_Instruction : out std_logic_vector(0 to 31);
      Trace_Valid_Instr : out std_logic;
      Trace_PC : out std_logic_vector(0 to 31);
      Trace_Reg_Write : out std_logic;
      Trace_Reg_Addr : out std_logic_vector(0 to 4);
      Trace_MSR_Reg : out std_logic_vector(0 to 14);
      Trace_PID_Reg : out std_logic_vector(0 to 7);
      Trace_New_Reg_Value : out std_logic_vector(0 to 31);
      Trace_Exception_Taken : out std_logic;
      Trace_Exception_Kind : out std_logic_vector(0 to 4);
      Trace_Jump_Taken : out std_logic;
      Trace_Delay_Slot : out std_logic;
      Trace_Data_Address : out std_logic_vector(0 to 31);
      Trace_Data_Access : out std_logic;
      Trace_Data_Read : out std_logic;
      Trace_Data_Write : out std_logic;
      Trace_Data_Write_Value : out std_logic_vector(0 to 31);
      Trace_Data_Byte_Enable : out std_logic_vector(0 to 3);
      Trace_DCache_Req : out std_logic;
      Trace_DCache_Hit : out std_logic;
      Trace_ICache_Req : out std_logic;
      Trace_ICache_Hit : out std_logic;
      Trace_OF_PipeRun : out std_logic;
      Trace_EX_PipeRun : out std_logic;
      Trace_MEM_PipeRun : out std_logic;
      Trace_MB_Halted : out std_logic;
      FSL0_S_CLK : out std_logic;
      FSL0_S_READ : out std_logic;
      FSL0_S_DATA : in std_logic_vector(0 to 31);
      FSL0_S_CONTROL : in std_logic;
      FSL0_S_EXISTS : in std_logic;
      FSL0_M_CLK : out std_logic;
      FSL0_M_WRITE : out std_logic;
      FSL0_M_DATA : out std_logic_vector(0 to 31);
      FSL0_M_CONTROL : out std_logic;
      FSL0_M_FULL : in std_logic;
      FSL1_S_CLK : out std_logic;
      FSL1_S_READ : out std_logic;
      FSL1_S_DATA : in std_logic_vector(0 to 31);
      FSL1_S_CONTROL : in std_logic;
      FSL1_S_EXISTS : in std_logic;
      FSL1_M_CLK : out std_logic;
      FSL1_M_WRITE : out std_logic;
      FSL1_M_DATA : out std_logic_vector(0 to 31);
      FSL1_M_CONTROL : out std_logic;
      FSL1_M_FULL : in std_logic;
      FSL2_S_CLK : out std_logic;
      FSL2_S_READ : out std_logic;
      FSL2_S_DATA : in std_logic_vector(0 to 31);
      FSL2_S_CONTROL : in std_logic;
      FSL2_S_EXISTS : in std_logic;
      FSL2_M_CLK : out std_logic;
      FSL2_M_WRITE : out std_logic;
      FSL2_M_DATA : out std_logic_vector(0 to 31);
      FSL2_M_CONTROL : out std_logic;
      FSL2_M_FULL : in std_logic;
      FSL3_S_CLK : out std_logic;
      FSL3_S_READ : out std_logic;
      FSL3_S_DATA : in std_logic_vector(0 to 31);
      FSL3_S_CONTROL : in std_logic;
      FSL3_S_EXISTS : in std_logic;
      FSL3_M_CLK : out std_logic;
      FSL3_M_WRITE : out std_logic;
      FSL3_M_DATA : out std_logic_vector(0 to 31);
      FSL3_M_CONTROL : out std_logic;
      FSL3_M_FULL : in std_logic;
      FSL4_S_CLK : out std_logic;
      FSL4_S_READ : out std_logic;
      FSL4_S_DATA : in std_logic_vector(0 to 31);
      FSL4_S_CONTROL : in std_logic;
      FSL4_S_EXISTS : in std_logic;
      FSL4_M_CLK : out std_logic;
      FSL4_M_WRITE : out std_logic;
      FSL4_M_DATA : out std_logic_vector(0 to 31);
      FSL4_M_CONTROL : out std_logic;
      FSL4_M_FULL : in std_logic;
      FSL5_S_CLK : out std_logic;
      FSL5_S_READ : out std_logic;
      FSL5_S_DATA : in std_logic_vector(0 to 31);
      FSL5_S_CONTROL : in std_logic;
      FSL5_S_EXISTS : in std_logic;
      FSL5_M_CLK : out std_logic;
      FSL5_M_WRITE : out std_logic;
      FSL5_M_DATA : out std_logic_vector(0 to 31);
      FSL5_M_CONTROL : out std_logic;
      FSL5_M_FULL : in std_logic;
      FSL6_S_CLK : out std_logic;
      FSL6_S_READ : out std_logic;
      FSL6_S_DATA : in std_logic_vector(0 to 31);
      FSL6_S_CONTROL : in std_logic;
      FSL6_S_EXISTS : in std_logic;
      FSL6_M_CLK : out std_logic;
      FSL6_M_WRITE : out std_logic;
      FSL6_M_DATA : out std_logic_vector(0 to 31);
      FSL6_M_CONTROL : out std_logic;
      FSL6_M_FULL : in std_logic;
      FSL7_S_CLK : out std_logic;
      FSL7_S_READ : out std_logic;
      FSL7_S_DATA : in std_logic_vector(0 to 31);
      FSL7_S_CONTROL : in std_logic;
      FSL7_S_EXISTS : in std_logic;
      FSL7_M_CLK : out std_logic;
      FSL7_M_WRITE : out std_logic;
      FSL7_M_DATA : out std_logic_vector(0 to 31);
      FSL7_M_CONTROL : out std_logic;
      FSL7_M_FULL : in std_logic;
      FSL8_S_CLK : out std_logic;
      FSL8_S_READ : out std_logic;
      FSL8_S_DATA : in std_logic_vector(0 to 31);
      FSL8_S_CONTROL : in std_logic;
      FSL8_S_EXISTS : in std_logic;
      FSL8_M_CLK : out std_logic;
      FSL8_M_WRITE : out std_logic;
      FSL8_M_DATA : out std_logic_vector(0 to 31);
      FSL8_M_CONTROL : out std_logic;
      FSL8_M_FULL : in std_logic;
      FSL9_S_CLK : out std_logic;
      FSL9_S_READ : out std_logic;
      FSL9_S_DATA : in std_logic_vector(0 to 31);
      FSL9_S_CONTROL : in std_logic;
      FSL9_S_EXISTS : in std_logic;
      FSL9_M_CLK : out std_logic;
      FSL9_M_WRITE : out std_logic;
      FSL9_M_DATA : out std_logic_vector(0 to 31);
      FSL9_M_CONTROL : out std_logic;
      FSL9_M_FULL : in std_logic;
      FSL10_S_CLK : out std_logic;
      FSL10_S_READ : out std_logic;
      FSL10_S_DATA : in std_logic_vector(0 to 31);
      FSL10_S_CONTROL : in std_logic;
      FSL10_S_EXISTS : in std_logic;
      FSL10_M_CLK : out std_logic;
      FSL10_M_WRITE : out std_logic;
      FSL10_M_DATA : out std_logic_vector(0 to 31);
      FSL10_M_CONTROL : out std_logic;
      FSL10_M_FULL : in std_logic;
      FSL11_S_CLK : out std_logic;
      FSL11_S_READ : out std_logic;
      FSL11_S_DATA : in std_logic_vector(0 to 31);
      FSL11_S_CONTROL : in std_logic;
      FSL11_S_EXISTS : in std_logic;
      FSL11_M_CLK : out std_logic;
      FSL11_M_WRITE : out std_logic;
      FSL11_M_DATA : out std_logic_vector(0 to 31);
      FSL11_M_CONTROL : out std_logic;
      FSL11_M_FULL : in std_logic;
      FSL12_S_CLK : out std_logic;
      FSL12_S_READ : out std_logic;
      FSL12_S_DATA : in std_logic_vector(0 to 31);
      FSL12_S_CONTROL : in std_logic;
      FSL12_S_EXISTS : in std_logic;
      FSL12_M_CLK : out std_logic;
      FSL12_M_WRITE : out std_logic;
      FSL12_M_DATA : out std_logic_vector(0 to 31);
      FSL12_M_CONTROL : out std_logic;
      FSL12_M_FULL : in std_logic;
      FSL13_S_CLK : out std_logic;
      FSL13_S_READ : out std_logic;
      FSL13_S_DATA : in std_logic_vector(0 to 31);
      FSL13_S_CONTROL : in std_logic;
      FSL13_S_EXISTS : in std_logic;
      FSL13_M_CLK : out std_logic;
      FSL13_M_WRITE : out std_logic;
      FSL13_M_DATA : out std_logic_vector(0 to 31);
      FSL13_M_CONTROL : out std_logic;
      FSL13_M_FULL : in std_logic;
      FSL14_S_CLK : out std_logic;
      FSL14_S_READ : out std_logic;
      FSL14_S_DATA : in std_logic_vector(0 to 31);
      FSL14_S_CONTROL : in std_logic;
      FSL14_S_EXISTS : in std_logic;
      FSL14_M_CLK : out std_logic;
      FSL14_M_WRITE : out std_logic;
      FSL14_M_DATA : out std_logic_vector(0 to 31);
      FSL14_M_CONTROL : out std_logic;
      FSL14_M_FULL : in std_logic;
      FSL15_S_CLK : out std_logic;
      FSL15_S_READ : out std_logic;
      FSL15_S_DATA : in std_logic_vector(0 to 31);
      FSL15_S_CONTROL : in std_logic;
      FSL15_S_EXISTS : in std_logic;
      FSL15_M_CLK : out std_logic;
      FSL15_M_WRITE : out std_logic;
      FSL15_M_DATA : out std_logic_vector(0 to 31);
      FSL15_M_CONTROL : out std_logic;
      FSL15_M_FULL : in std_logic;
      ICACHE_FSL_IN_CLK : out std_logic;
      ICACHE_FSL_IN_READ : out std_logic;
      ICACHE_FSL_IN_DATA : in std_logic_vector(0 to 31);
      ICACHE_FSL_IN_CONTROL : in std_logic;
      ICACHE_FSL_IN_EXISTS : in std_logic;
      ICACHE_FSL_OUT_CLK : out std_logic;
      ICACHE_FSL_OUT_WRITE : out std_logic;
      ICACHE_FSL_OUT_DATA : out std_logic_vector(0 to 31);
      ICACHE_FSL_OUT_CONTROL : out std_logic;
      ICACHE_FSL_OUT_FULL : in std_logic;
      DCACHE_FSL_IN_CLK : out std_logic;
      DCACHE_FSL_IN_READ : out std_logic;
      DCACHE_FSL_IN_DATA : in std_logic_vector(0 to 31);
      DCACHE_FSL_IN_CONTROL : in std_logic;
      DCACHE_FSL_IN_EXISTS : in std_logic;
      DCACHE_FSL_OUT_CLK : out std_logic;
      DCACHE_FSL_OUT_WRITE : out std_logic;
      DCACHE_FSL_OUT_DATA : out std_logic_vector(0 to 31);
      DCACHE_FSL_OUT_CONTROL : out std_logic;
      DCACHE_FSL_OUT_FULL : in std_logic
    );
  end component;

  component mb_ilmb2_wrapper is
    port (
      LMB_Clk : in std_logic;
      SYS_Rst : in std_logic;
      LMB_Rst : out std_logic;
      M_ABus : in std_logic_vector(0 to 31);
      M_ReadStrobe : in std_logic;
      M_WriteStrobe : in std_logic;
      M_AddrStrobe : in std_logic;
      M_DBus : in std_logic_vector(0 to 31);
      M_BE : in std_logic_vector(0 to 3);
      Sl_DBus : in std_logic_vector(0 to 31);
      Sl_Ready : in std_logic_vector(0 to 0);
      LMB_ABus : out std_logic_vector(0 to 31);
      LMB_ReadStrobe : out std_logic;
      LMB_WriteStrobe : out std_logic;
      LMB_AddrStrobe : out std_logic;
      LMB_ReadDBus : out std_logic_vector(0 to 31);
      LMB_WriteDBus : out std_logic_vector(0 to 31);
      LMB_Ready : out std_logic;
      LMB_BE : out std_logic_vector(0 to 3)
    );
  end component;

  component mb_dlmb2_wrapper is
    port (
      LMB_Clk : in std_logic;
      SYS_Rst : in std_logic;
      LMB_Rst : out std_logic;
      M_ABus : in std_logic_vector(0 to 31);
      M_ReadStrobe : in std_logic;
      M_WriteStrobe : in std_logic;
      M_AddrStrobe : in std_logic;
      M_DBus : in std_logic_vector(0 to 31);
      M_BE : in std_logic_vector(0 to 3);
      Sl_DBus : in std_logic_vector(0 to 31);
      Sl_Ready : in std_logic_vector(0 to 0);
      LMB_ABus : out std_logic_vector(0 to 31);
      LMB_ReadStrobe : out std_logic;
      LMB_WriteStrobe : out std_logic;
      LMB_AddrStrobe : out std_logic;
      LMB_ReadDBus : out std_logic_vector(0 to 31);
      LMB_WriteDBus : out std_logic_vector(0 to 31);
      LMB_Ready : out std_logic;
      LMB_BE : out std_logic_vector(0 to 3)
    );
  end component;

  component ilmb_cntlr2_wrapper is
    port (
      LMB_Clk : in std_logic;
      LMB_Rst : in std_logic;
      LMB_ABus : in std_logic_vector(0 to 31);
      LMB_WriteDBus : in std_logic_vector(0 to 31);
      LMB_AddrStrobe : in std_logic;
      LMB_ReadStrobe : in std_logic;
      LMB_WriteStrobe : in std_logic;
      LMB_BE : in std_logic_vector(0 to 3);
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_Ready : out std_logic;
      BRAM_Rst_A : out std_logic;
      BRAM_Clk_A : out std_logic;
      BRAM_EN_A : out std_logic;
      BRAM_WEN_A : out std_logic_vector(0 to 3);
      BRAM_Addr_A : out std_logic_vector(0 to 31);
      BRAM_Din_A : in std_logic_vector(0 to 31);
      BRAM_Dout_A : out std_logic_vector(0 to 31)
    );
  end component;

  component dlmb_cntlr2_wrapper is
    port (
      LMB_Clk : in std_logic;
      LMB_Rst : in std_logic;
      LMB_ABus : in std_logic_vector(0 to 31);
      LMB_WriteDBus : in std_logic_vector(0 to 31);
      LMB_AddrStrobe : in std_logic;
      LMB_ReadStrobe : in std_logic;
      LMB_WriteStrobe : in std_logic;
      LMB_BE : in std_logic_vector(0 to 3);
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_Ready : out std_logic;
      BRAM_Rst_A : out std_logic;
      BRAM_Clk_A : out std_logic;
      BRAM_EN_A : out std_logic;
      BRAM_WEN_A : out std_logic_vector(0 to 3);
      BRAM_Addr_A : out std_logic_vector(0 to 31);
      BRAM_Din_A : in std_logic_vector(0 to 31);
      BRAM_Dout_A : out std_logic_vector(0 to 31)
    );
  end component;

  component mb_bram2_wrapper is
    port (
      BRAM_Rst_A : in std_logic;
      BRAM_Clk_A : in std_logic;
      BRAM_EN_A : in std_logic;
      BRAM_WEN_A : in std_logic_vector(0 to 3);
      BRAM_Addr_A : in std_logic_vector(0 to 31);
      BRAM_Din_A : out std_logic_vector(0 to 31);
      BRAM_Dout_A : in std_logic_vector(0 to 31);
      BRAM_Rst_B : in std_logic;
      BRAM_Clk_B : in std_logic;
      BRAM_EN_B : in std_logic;
      BRAM_WEN_B : in std_logic_vector(0 to 3);
      BRAM_Addr_B : in std_logic_vector(0 to 31);
      BRAM_Din_B : out std_logic_vector(0 to 31);
      BRAM_Dout_B : in std_logic_vector(0 to 31)
    );
  end component;

  component mb2_plb_bridge_wrapper is
    port (
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      IP2INTC_Irpt : out std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 0);
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to 3);
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_lockErr : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to 31);
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_wrBTerm : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 31);
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_rdBTerm : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 1);
      Sl_MWrErr : out std_logic_vector(0 to 1);
      Sl_MRdErr : out std_logic_vector(0 to 1);
      Sl_MIRQ : out std_logic_vector(0 to 1);
      MPLB_Clk : in std_logic;
      MPLB_Rst : in std_logic;
      M_request : out std_logic;
      M_priority : out std_logic_vector(0 to 1);
      M_busLock : out std_logic;
      M_RNW : out std_logic;
      M_BE : out std_logic_vector(0 to 15);
      M_MSize : out std_logic_vector(0 to 1);
      M_size : out std_logic_vector(0 to 3);
      M_type : out std_logic_vector(0 to 2);
      M_ABus : out std_logic_vector(0 to 31);
      M_wrBurst : out std_logic;
      M_rdBurst : out std_logic;
      M_wrDBus : out std_logic_vector(0 to 127);
      PLB_MAddrAck : in std_logic;
      PLB_MSSize : in std_logic_vector(0 to 1);
      PLB_MRearbitrate : in std_logic;
      PLB_MTimeout : in std_logic;
      PLB_MRdErr : in std_logic;
      PLB_MWrErr : in std_logic;
      PLB_MRdDBus : in std_logic_vector(0 to 127);
      PLB_MRdDAck : in std_logic;
      PLB_MRdBTerm : in std_logic;
      PLB_MWrDAck : in std_logic;
      PLB_MWrBTerm : in std_logic;
      M_TAttribute : out std_logic_vector(0 to 15);
      M_lockErr : out std_logic;
      M_abort : out std_logic;
      M_UABus : out std_logic_vector(0 to 31);
      PLB_MBusy : in std_logic;
      PLB_MIRQ : in std_logic;
      PLB_MRdWdAddr : in std_logic_vector(0 to 3)
    );
  end component;

  component mb2_plb_bus_wrapper is
    port (
      PLB_Clk : in std_logic;
      SYS_Rst : in std_logic;
      PLB_Rst : out std_logic;
      SPLB_Rst : out std_logic_vector(0 to 0);
      MPLB_Rst : out std_logic_vector(0 to 1);
      PLB_dcrAck : out std_logic;
      PLB_dcrDBus : out std_logic_vector(0 to 31);
      DCR_ABus : in std_logic_vector(0 to 9);
      DCR_DBus : in std_logic_vector(0 to 31);
      DCR_Read : in std_logic;
      DCR_Write : in std_logic;
      M_ABus : in std_logic_vector(0 to 63);
      M_UABus : in std_logic_vector(0 to 63);
      M_BE : in std_logic_vector(0 to 7);
      M_RNW : in std_logic_vector(0 to 1);
      M_abort : in std_logic_vector(0 to 1);
      M_busLock : in std_logic_vector(0 to 1);
      M_TAttribute : in std_logic_vector(0 to 31);
      M_lockErr : in std_logic_vector(0 to 1);
      M_MSize : in std_logic_vector(0 to 3);
      M_priority : in std_logic_vector(0 to 3);
      M_rdBurst : in std_logic_vector(0 to 1);
      M_request : in std_logic_vector(0 to 1);
      M_size : in std_logic_vector(0 to 7);
      M_type : in std_logic_vector(0 to 5);
      M_wrBurst : in std_logic_vector(0 to 1);
      M_wrDBus : in std_logic_vector(0 to 63);
      Sl_addrAck : in std_logic_vector(0 to 0);
      Sl_MRdErr : in std_logic_vector(0 to 1);
      Sl_MWrErr : in std_logic_vector(0 to 1);
      Sl_MBusy : in std_logic_vector(0 to 1);
      Sl_rdBTerm : in std_logic_vector(0 to 0);
      Sl_rdComp : in std_logic_vector(0 to 0);
      Sl_rdDAck : in std_logic_vector(0 to 0);
      Sl_rdDBus : in std_logic_vector(0 to 31);
      Sl_rdWdAddr : in std_logic_vector(0 to 3);
      Sl_rearbitrate : in std_logic_vector(0 to 0);
      Sl_SSize : in std_logic_vector(0 to 1);
      Sl_wait : in std_logic_vector(0 to 0);
      Sl_wrBTerm : in std_logic_vector(0 to 0);
      Sl_wrComp : in std_logic_vector(0 to 0);
      Sl_wrDAck : in std_logic_vector(0 to 0);
      Sl_MIRQ : in std_logic_vector(0 to 1);
      PLB_MIRQ : out std_logic_vector(0 to 1);
      PLB_ABus : out std_logic_vector(0 to 31);
      PLB_UABus : out std_logic_vector(0 to 31);
      PLB_BE : out std_logic_vector(0 to 3);
      PLB_MAddrAck : out std_logic_vector(0 to 1);
      PLB_MTimeout : out std_logic_vector(0 to 1);
      PLB_MBusy : out std_logic_vector(0 to 1);
      PLB_MRdErr : out std_logic_vector(0 to 1);
      PLB_MWrErr : out std_logic_vector(0 to 1);
      PLB_MRdBTerm : out std_logic_vector(0 to 1);
      PLB_MRdDAck : out std_logic_vector(0 to 1);
      PLB_MRdDBus : out std_logic_vector(0 to 63);
      PLB_MRdWdAddr : out std_logic_vector(0 to 7);
      PLB_MRearbitrate : out std_logic_vector(0 to 1);
      PLB_MWrBTerm : out std_logic_vector(0 to 1);
      PLB_MWrDAck : out std_logic_vector(0 to 1);
      PLB_MSSize : out std_logic_vector(0 to 3);
      PLB_PAValid : out std_logic;
      PLB_RNW : out std_logic;
      PLB_SAValid : out std_logic;
      PLB_abort : out std_logic;
      PLB_busLock : out std_logic;
      PLB_TAttribute : out std_logic_vector(0 to 15);
      PLB_lockErr : out std_logic;
      PLB_masterID : out std_logic_vector(0 to 0);
      PLB_MSize : out std_logic_vector(0 to 1);
      PLB_rdPendPri : out std_logic_vector(0 to 1);
      PLB_wrPendPri : out std_logic_vector(0 to 1);
      PLB_rdPendReq : out std_logic;
      PLB_wrPendReq : out std_logic;
      PLB_rdBurst : out std_logic;
      PLB_rdPrim : out std_logic_vector(0 to 0);
      PLB_reqPri : out std_logic_vector(0 to 1);
      PLB_size : out std_logic_vector(0 to 3);
      PLB_type : out std_logic_vector(0 to 2);
      PLB_wrBurst : out std_logic;
      PLB_wrDBus : out std_logic_vector(0 to 31);
      PLB_wrPrim : out std_logic_vector(0 to 0);
      PLB_SaddrAck : out std_logic;
      PLB_SMRdErr : out std_logic_vector(0 to 1);
      PLB_SMWrErr : out std_logic_vector(0 to 1);
      PLB_SMBusy : out std_logic_vector(0 to 1);
      PLB_SrdBTerm : out std_logic;
      PLB_SrdComp : out std_logic;
      PLB_SrdDAck : out std_logic;
      PLB_SrdDBus : out std_logic_vector(0 to 31);
      PLB_SrdWdAddr : out std_logic_vector(0 to 3);
      PLB_Srearbitrate : out std_logic;
      PLB_Sssize : out std_logic_vector(0 to 1);
      PLB_Swait : out std_logic;
      PLB_SwrBTerm : out std_logic;
      PLB_SwrComp : out std_logic;
      PLB_SwrDAck : out std_logic;
      Bus_Error_Det : out std_logic
    );
  end component;

  component microblaze_mb3_wrapper is
    port (
      CLK : in std_logic;
      RESET : in std_logic;
      MB_RESET : in std_logic;
      INTERRUPT : in std_logic;
      EXT_BRK : in std_logic;
      EXT_NM_BRK : in std_logic;
      DBG_STOP : in std_logic;
      MB_Halted : out std_logic;
      INSTR : in std_logic_vector(0 to 31);
      I_ADDRTAG : out std_logic_vector(0 to 3);
      IREADY : in std_logic;
      IWAIT : in std_logic;
      INSTR_ADDR : out std_logic_vector(0 to 31);
      IFETCH : out std_logic;
      I_AS : out std_logic;
      IPLB_M_ABort : out std_logic;
      IPLB_M_ABus : out std_logic_vector(0 to 31);
      IPLB_M_UABus : out std_logic_vector(0 to 31);
      IPLB_M_BE : out std_logic_vector(0 to 3);
      IPLB_M_busLock : out std_logic;
      IPLB_M_lockErr : out std_logic;
      IPLB_M_MSize : out std_logic_vector(0 to 1);
      IPLB_M_priority : out std_logic_vector(0 to 1);
      IPLB_M_rdBurst : out std_logic;
      IPLB_M_request : out std_logic;
      IPLB_M_RNW : out std_logic;
      IPLB_M_size : out std_logic_vector(0 to 3);
      IPLB_M_TAttribute : out std_logic_vector(0 to 15);
      IPLB_M_type : out std_logic_vector(0 to 2);
      IPLB_M_wrBurst : out std_logic;
      IPLB_M_wrDBus : out std_logic_vector(0 to 31);
      IPLB_MBusy : in std_logic;
      IPLB_MRdErr : in std_logic;
      IPLB_MWrErr : in std_logic;
      IPLB_MIRQ : in std_logic;
      IPLB_MWrBTerm : in std_logic;
      IPLB_MWrDAck : in std_logic;
      IPLB_MAddrAck : in std_logic;
      IPLB_MRdBTerm : in std_logic;
      IPLB_MRdDAck : in std_logic;
      IPLB_MRdDBus : in std_logic_vector(0 to 31);
      IPLB_MRdWdAddr : in std_logic_vector(0 to 3);
      IPLB_MRearbitrate : in std_logic;
      IPLB_MSSize : in std_logic_vector(0 to 1);
      IPLB_MTimeout : in std_logic;
      DATA_READ : in std_logic_vector(0 to 31);
      DREADY : in std_logic;
      DWAIT : in std_logic;
      DATA_WRITE : out std_logic_vector(0 to 31);
      DATA_ADDR : out std_logic_vector(0 to 31);
      D_ADDRTAG : out std_logic_vector(0 to 3);
      D_AS : out std_logic;
      READ_STROBE : out std_logic;
      WRITE_STROBE : out std_logic;
      BYTE_ENABLE : out std_logic_vector(0 to 3);
      DM_ABUS : out std_logic_vector(0 to 31);
      DM_BE : out std_logic_vector(0 to 3);
      DM_BUSLOCK : out std_logic;
      DM_DBUS : out std_logic_vector(0 to 31);
      DM_REQUEST : out std_logic;
      DM_RNW : out std_logic;
      DM_SELECT : out std_logic;
      DM_SEQADDR : out std_logic;
      DOPB_DBUS : in std_logic_vector(0 to 31);
      DOPB_ERRACK : in std_logic;
      DOPB_MGRANT : in std_logic;
      DOPB_RETRY : in std_logic;
      DOPB_TIMEOUT : in std_logic;
      DOPB_XFERACK : in std_logic;
      DPLB_M_ABort : out std_logic;
      DPLB_M_ABus : out std_logic_vector(0 to 31);
      DPLB_M_UABus : out std_logic_vector(0 to 31);
      DPLB_M_BE : out std_logic_vector(0 to 3);
      DPLB_M_busLock : out std_logic;
      DPLB_M_lockErr : out std_logic;
      DPLB_M_MSize : out std_logic_vector(0 to 1);
      DPLB_M_priority : out std_logic_vector(0 to 1);
      DPLB_M_rdBurst : out std_logic;
      DPLB_M_request : out std_logic;
      DPLB_M_RNW : out std_logic;
      DPLB_M_size : out std_logic_vector(0 to 3);
      DPLB_M_TAttribute : out std_logic_vector(0 to 15);
      DPLB_M_type : out std_logic_vector(0 to 2);
      DPLB_M_wrBurst : out std_logic;
      DPLB_M_wrDBus : out std_logic_vector(0 to 31);
      DPLB_MBusy : in std_logic;
      DPLB_MRdErr : in std_logic;
      DPLB_MWrErr : in std_logic;
      DPLB_MIRQ : in std_logic;
      DPLB_MWrBTerm : in std_logic;
      DPLB_MWrDAck : in std_logic;
      DPLB_MAddrAck : in std_logic;
      DPLB_MRdBTerm : in std_logic;
      DPLB_MRdDAck : in std_logic;
      DPLB_MRdDBus : in std_logic_vector(0 to 31);
      DPLB_MRdWdAddr : in std_logic_vector(0 to 3);
      DPLB_MRearbitrate : in std_logic;
      DPLB_MSSize : in std_logic_vector(0 to 1);
      DPLB_MTimeout : in std_logic;
      IM_ABUS : out std_logic_vector(0 to 31);
      IM_BE : out std_logic_vector(0 to 3);
      IM_BUSLOCK : out std_logic;
      IM_DBUS : out std_logic_vector(0 to 31);
      IM_REQUEST : out std_logic;
      IM_RNW : out std_logic;
      IM_SELECT : out std_logic;
      IM_SEQADDR : out std_logic;
      IOPB_DBUS : in std_logic_vector(0 to 31);
      IOPB_ERRACK : in std_logic;
      IOPB_MGRANT : in std_logic;
      IOPB_RETRY : in std_logic;
      IOPB_TIMEOUT : in std_logic;
      IOPB_XFERACK : in std_logic;
      DBG_CLK : in std_logic;
      DBG_TDI : in std_logic;
      DBG_TDO : out std_logic;
      DBG_REG_EN : in std_logic_vector(0 to 4);
      DBG_SHIFT : in std_logic;
      DBG_CAPTURE : in std_logic;
      DBG_UPDATE : in std_logic;
      DEBUG_RST : in std_logic;
      Trace_Instruction : out std_logic_vector(0 to 31);
      Trace_Valid_Instr : out std_logic;
      Trace_PC : out std_logic_vector(0 to 31);
      Trace_Reg_Write : out std_logic;
      Trace_Reg_Addr : out std_logic_vector(0 to 4);
      Trace_MSR_Reg : out std_logic_vector(0 to 14);
      Trace_PID_Reg : out std_logic_vector(0 to 7);
      Trace_New_Reg_Value : out std_logic_vector(0 to 31);
      Trace_Exception_Taken : out std_logic;
      Trace_Exception_Kind : out std_logic_vector(0 to 4);
      Trace_Jump_Taken : out std_logic;
      Trace_Delay_Slot : out std_logic;
      Trace_Data_Address : out std_logic_vector(0 to 31);
      Trace_Data_Access : out std_logic;
      Trace_Data_Read : out std_logic;
      Trace_Data_Write : out std_logic;
      Trace_Data_Write_Value : out std_logic_vector(0 to 31);
      Trace_Data_Byte_Enable : out std_logic_vector(0 to 3);
      Trace_DCache_Req : out std_logic;
      Trace_DCache_Hit : out std_logic;
      Trace_ICache_Req : out std_logic;
      Trace_ICache_Hit : out std_logic;
      Trace_OF_PipeRun : out std_logic;
      Trace_EX_PipeRun : out std_logic;
      Trace_MEM_PipeRun : out std_logic;
      Trace_MB_Halted : out std_logic;
      FSL0_S_CLK : out std_logic;
      FSL0_S_READ : out std_logic;
      FSL0_S_DATA : in std_logic_vector(0 to 31);
      FSL0_S_CONTROL : in std_logic;
      FSL0_S_EXISTS : in std_logic;
      FSL0_M_CLK : out std_logic;
      FSL0_M_WRITE : out std_logic;
      FSL0_M_DATA : out std_logic_vector(0 to 31);
      FSL0_M_CONTROL : out std_logic;
      FSL0_M_FULL : in std_logic;
      FSL1_S_CLK : out std_logic;
      FSL1_S_READ : out std_logic;
      FSL1_S_DATA : in std_logic_vector(0 to 31);
      FSL1_S_CONTROL : in std_logic;
      FSL1_S_EXISTS : in std_logic;
      FSL1_M_CLK : out std_logic;
      FSL1_M_WRITE : out std_logic;
      FSL1_M_DATA : out std_logic_vector(0 to 31);
      FSL1_M_CONTROL : out std_logic;
      FSL1_M_FULL : in std_logic;
      FSL2_S_CLK : out std_logic;
      FSL2_S_READ : out std_logic;
      FSL2_S_DATA : in std_logic_vector(0 to 31);
      FSL2_S_CONTROL : in std_logic;
      FSL2_S_EXISTS : in std_logic;
      FSL2_M_CLK : out std_logic;
      FSL2_M_WRITE : out std_logic;
      FSL2_M_DATA : out std_logic_vector(0 to 31);
      FSL2_M_CONTROL : out std_logic;
      FSL2_M_FULL : in std_logic;
      FSL3_S_CLK : out std_logic;
      FSL3_S_READ : out std_logic;
      FSL3_S_DATA : in std_logic_vector(0 to 31);
      FSL3_S_CONTROL : in std_logic;
      FSL3_S_EXISTS : in std_logic;
      FSL3_M_CLK : out std_logic;
      FSL3_M_WRITE : out std_logic;
      FSL3_M_DATA : out std_logic_vector(0 to 31);
      FSL3_M_CONTROL : out std_logic;
      FSL3_M_FULL : in std_logic;
      FSL4_S_CLK : out std_logic;
      FSL4_S_READ : out std_logic;
      FSL4_S_DATA : in std_logic_vector(0 to 31);
      FSL4_S_CONTROL : in std_logic;
      FSL4_S_EXISTS : in std_logic;
      FSL4_M_CLK : out std_logic;
      FSL4_M_WRITE : out std_logic;
      FSL4_M_DATA : out std_logic_vector(0 to 31);
      FSL4_M_CONTROL : out std_logic;
      FSL4_M_FULL : in std_logic;
      FSL5_S_CLK : out std_logic;
      FSL5_S_READ : out std_logic;
      FSL5_S_DATA : in std_logic_vector(0 to 31);
      FSL5_S_CONTROL : in std_logic;
      FSL5_S_EXISTS : in std_logic;
      FSL5_M_CLK : out std_logic;
      FSL5_M_WRITE : out std_logic;
      FSL5_M_DATA : out std_logic_vector(0 to 31);
      FSL5_M_CONTROL : out std_logic;
      FSL5_M_FULL : in std_logic;
      FSL6_S_CLK : out std_logic;
      FSL6_S_READ : out std_logic;
      FSL6_S_DATA : in std_logic_vector(0 to 31);
      FSL6_S_CONTROL : in std_logic;
      FSL6_S_EXISTS : in std_logic;
      FSL6_M_CLK : out std_logic;
      FSL6_M_WRITE : out std_logic;
      FSL6_M_DATA : out std_logic_vector(0 to 31);
      FSL6_M_CONTROL : out std_logic;
      FSL6_M_FULL : in std_logic;
      FSL7_S_CLK : out std_logic;
      FSL7_S_READ : out std_logic;
      FSL7_S_DATA : in std_logic_vector(0 to 31);
      FSL7_S_CONTROL : in std_logic;
      FSL7_S_EXISTS : in std_logic;
      FSL7_M_CLK : out std_logic;
      FSL7_M_WRITE : out std_logic;
      FSL7_M_DATA : out std_logic_vector(0 to 31);
      FSL7_M_CONTROL : out std_logic;
      FSL7_M_FULL : in std_logic;
      FSL8_S_CLK : out std_logic;
      FSL8_S_READ : out std_logic;
      FSL8_S_DATA : in std_logic_vector(0 to 31);
      FSL8_S_CONTROL : in std_logic;
      FSL8_S_EXISTS : in std_logic;
      FSL8_M_CLK : out std_logic;
      FSL8_M_WRITE : out std_logic;
      FSL8_M_DATA : out std_logic_vector(0 to 31);
      FSL8_M_CONTROL : out std_logic;
      FSL8_M_FULL : in std_logic;
      FSL9_S_CLK : out std_logic;
      FSL9_S_READ : out std_logic;
      FSL9_S_DATA : in std_logic_vector(0 to 31);
      FSL9_S_CONTROL : in std_logic;
      FSL9_S_EXISTS : in std_logic;
      FSL9_M_CLK : out std_logic;
      FSL9_M_WRITE : out std_logic;
      FSL9_M_DATA : out std_logic_vector(0 to 31);
      FSL9_M_CONTROL : out std_logic;
      FSL9_M_FULL : in std_logic;
      FSL10_S_CLK : out std_logic;
      FSL10_S_READ : out std_logic;
      FSL10_S_DATA : in std_logic_vector(0 to 31);
      FSL10_S_CONTROL : in std_logic;
      FSL10_S_EXISTS : in std_logic;
      FSL10_M_CLK : out std_logic;
      FSL10_M_WRITE : out std_logic;
      FSL10_M_DATA : out std_logic_vector(0 to 31);
      FSL10_M_CONTROL : out std_logic;
      FSL10_M_FULL : in std_logic;
      FSL11_S_CLK : out std_logic;
      FSL11_S_READ : out std_logic;
      FSL11_S_DATA : in std_logic_vector(0 to 31);
      FSL11_S_CONTROL : in std_logic;
      FSL11_S_EXISTS : in std_logic;
      FSL11_M_CLK : out std_logic;
      FSL11_M_WRITE : out std_logic;
      FSL11_M_DATA : out std_logic_vector(0 to 31);
      FSL11_M_CONTROL : out std_logic;
      FSL11_M_FULL : in std_logic;
      FSL12_S_CLK : out std_logic;
      FSL12_S_READ : out std_logic;
      FSL12_S_DATA : in std_logic_vector(0 to 31);
      FSL12_S_CONTROL : in std_logic;
      FSL12_S_EXISTS : in std_logic;
      FSL12_M_CLK : out std_logic;
      FSL12_M_WRITE : out std_logic;
      FSL12_M_DATA : out std_logic_vector(0 to 31);
      FSL12_M_CONTROL : out std_logic;
      FSL12_M_FULL : in std_logic;
      FSL13_S_CLK : out std_logic;
      FSL13_S_READ : out std_logic;
      FSL13_S_DATA : in std_logic_vector(0 to 31);
      FSL13_S_CONTROL : in std_logic;
      FSL13_S_EXISTS : in std_logic;
      FSL13_M_CLK : out std_logic;
      FSL13_M_WRITE : out std_logic;
      FSL13_M_DATA : out std_logic_vector(0 to 31);
      FSL13_M_CONTROL : out std_logic;
      FSL13_M_FULL : in std_logic;
      FSL14_S_CLK : out std_logic;
      FSL14_S_READ : out std_logic;
      FSL14_S_DATA : in std_logic_vector(0 to 31);
      FSL14_S_CONTROL : in std_logic;
      FSL14_S_EXISTS : in std_logic;
      FSL14_M_CLK : out std_logic;
      FSL14_M_WRITE : out std_logic;
      FSL14_M_DATA : out std_logic_vector(0 to 31);
      FSL14_M_CONTROL : out std_logic;
      FSL14_M_FULL : in std_logic;
      FSL15_S_CLK : out std_logic;
      FSL15_S_READ : out std_logic;
      FSL15_S_DATA : in std_logic_vector(0 to 31);
      FSL15_S_CONTROL : in std_logic;
      FSL15_S_EXISTS : in std_logic;
      FSL15_M_CLK : out std_logic;
      FSL15_M_WRITE : out std_logic;
      FSL15_M_DATA : out std_logic_vector(0 to 31);
      FSL15_M_CONTROL : out std_logic;
      FSL15_M_FULL : in std_logic;
      ICACHE_FSL_IN_CLK : out std_logic;
      ICACHE_FSL_IN_READ : out std_logic;
      ICACHE_FSL_IN_DATA : in std_logic_vector(0 to 31);
      ICACHE_FSL_IN_CONTROL : in std_logic;
      ICACHE_FSL_IN_EXISTS : in std_logic;
      ICACHE_FSL_OUT_CLK : out std_logic;
      ICACHE_FSL_OUT_WRITE : out std_logic;
      ICACHE_FSL_OUT_DATA : out std_logic_vector(0 to 31);
      ICACHE_FSL_OUT_CONTROL : out std_logic;
      ICACHE_FSL_OUT_FULL : in std_logic;
      DCACHE_FSL_IN_CLK : out std_logic;
      DCACHE_FSL_IN_READ : out std_logic;
      DCACHE_FSL_IN_DATA : in std_logic_vector(0 to 31);
      DCACHE_FSL_IN_CONTROL : in std_logic;
      DCACHE_FSL_IN_EXISTS : in std_logic;
      DCACHE_FSL_OUT_CLK : out std_logic;
      DCACHE_FSL_OUT_WRITE : out std_logic;
      DCACHE_FSL_OUT_DATA : out std_logic_vector(0 to 31);
      DCACHE_FSL_OUT_CONTROL : out std_logic;
      DCACHE_FSL_OUT_FULL : in std_logic
    );
  end component;

  component mb_ilmb_mb3_wrapper is
    port (
      LMB_Clk : in std_logic;
      SYS_Rst : in std_logic;
      LMB_Rst : out std_logic;
      M_ABus : in std_logic_vector(0 to 31);
      M_ReadStrobe : in std_logic;
      M_WriteStrobe : in std_logic;
      M_AddrStrobe : in std_logic;
      M_DBus : in std_logic_vector(0 to 31);
      M_BE : in std_logic_vector(0 to 3);
      Sl_DBus : in std_logic_vector(0 to 31);
      Sl_Ready : in std_logic_vector(0 to 0);
      LMB_ABus : out std_logic_vector(0 to 31);
      LMB_ReadStrobe : out std_logic;
      LMB_WriteStrobe : out std_logic;
      LMB_AddrStrobe : out std_logic;
      LMB_ReadDBus : out std_logic_vector(0 to 31);
      LMB_WriteDBus : out std_logic_vector(0 to 31);
      LMB_Ready : out std_logic;
      LMB_BE : out std_logic_vector(0 to 3)
    );
  end component;

  component mb_dlmb_mb3_wrapper is
    port (
      LMB_Clk : in std_logic;
      SYS_Rst : in std_logic;
      LMB_Rst : out std_logic;
      M_ABus : in std_logic_vector(0 to 31);
      M_ReadStrobe : in std_logic;
      M_WriteStrobe : in std_logic;
      M_AddrStrobe : in std_logic;
      M_DBus : in std_logic_vector(0 to 31);
      M_BE : in std_logic_vector(0 to 3);
      Sl_DBus : in std_logic_vector(0 to 31);
      Sl_Ready : in std_logic_vector(0 to 0);
      LMB_ABus : out std_logic_vector(0 to 31);
      LMB_ReadStrobe : out std_logic;
      LMB_WriteStrobe : out std_logic;
      LMB_AddrStrobe : out std_logic;
      LMB_ReadDBus : out std_logic_vector(0 to 31);
      LMB_WriteDBus : out std_logic_vector(0 to 31);
      LMB_Ready : out std_logic;
      LMB_BE : out std_logic_vector(0 to 3)
    );
  end component;

  component ilmb_cntlr_mb3_wrapper is
    port (
      LMB_Clk : in std_logic;
      LMB_Rst : in std_logic;
      LMB_ABus : in std_logic_vector(0 to 31);
      LMB_WriteDBus : in std_logic_vector(0 to 31);
      LMB_AddrStrobe : in std_logic;
      LMB_ReadStrobe : in std_logic;
      LMB_WriteStrobe : in std_logic;
      LMB_BE : in std_logic_vector(0 to 3);
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_Ready : out std_logic;
      BRAM_Rst_A : out std_logic;
      BRAM_Clk_A : out std_logic;
      BRAM_EN_A : out std_logic;
      BRAM_WEN_A : out std_logic_vector(0 to 3);
      BRAM_Addr_A : out std_logic_vector(0 to 31);
      BRAM_Din_A : in std_logic_vector(0 to 31);
      BRAM_Dout_A : out std_logic_vector(0 to 31)
    );
  end component;

  component dlmb_cntlr_mb3_wrapper is
    port (
      LMB_Clk : in std_logic;
      LMB_Rst : in std_logic;
      LMB_ABus : in std_logic_vector(0 to 31);
      LMB_WriteDBus : in std_logic_vector(0 to 31);
      LMB_AddrStrobe : in std_logic;
      LMB_ReadStrobe : in std_logic;
      LMB_WriteStrobe : in std_logic;
      LMB_BE : in std_logic_vector(0 to 3);
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_Ready : out std_logic;
      BRAM_Rst_A : out std_logic;
      BRAM_Clk_A : out std_logic;
      BRAM_EN_A : out std_logic;
      BRAM_WEN_A : out std_logic_vector(0 to 3);
      BRAM_Addr_A : out std_logic_vector(0 to 31);
      BRAM_Din_A : in std_logic_vector(0 to 31);
      BRAM_Dout_A : out std_logic_vector(0 to 31)
    );
  end component;

  component mb3_bram_wrapper is
    port (
      BRAM_Rst_A : in std_logic;
      BRAM_Clk_A : in std_logic;
      BRAM_EN_A : in std_logic;
      BRAM_WEN_A : in std_logic_vector(0 to 3);
      BRAM_Addr_A : in std_logic_vector(0 to 31);
      BRAM_Din_A : out std_logic_vector(0 to 31);
      BRAM_Dout_A : in std_logic_vector(0 to 31);
      BRAM_Rst_B : in std_logic;
      BRAM_Clk_B : in std_logic;
      BRAM_EN_B : in std_logic;
      BRAM_WEN_B : in std_logic_vector(0 to 3);
      BRAM_Addr_B : in std_logic_vector(0 to 31);
      BRAM_Din_B : out std_logic_vector(0 to 31);
      BRAM_Dout_B : in std_logic_vector(0 to 31)
    );
  end component;

  component mb3_plb_bridge_wrapper is
    port (
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      IP2INTC_Irpt : out std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 0);
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to 3);
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_lockErr : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to 31);
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_wrBTerm : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 31);
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_rdBTerm : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 1);
      Sl_MWrErr : out std_logic_vector(0 to 1);
      Sl_MRdErr : out std_logic_vector(0 to 1);
      Sl_MIRQ : out std_logic_vector(0 to 1);
      MPLB_Clk : in std_logic;
      MPLB_Rst : in std_logic;
      M_request : out std_logic;
      M_priority : out std_logic_vector(0 to 1);
      M_busLock : out std_logic;
      M_RNW : out std_logic;
      M_BE : out std_logic_vector(0 to 15);
      M_MSize : out std_logic_vector(0 to 1);
      M_size : out std_logic_vector(0 to 3);
      M_type : out std_logic_vector(0 to 2);
      M_ABus : out std_logic_vector(0 to 31);
      M_wrBurst : out std_logic;
      M_rdBurst : out std_logic;
      M_wrDBus : out std_logic_vector(0 to 127);
      PLB_MAddrAck : in std_logic;
      PLB_MSSize : in std_logic_vector(0 to 1);
      PLB_MRearbitrate : in std_logic;
      PLB_MTimeout : in std_logic;
      PLB_MRdErr : in std_logic;
      PLB_MWrErr : in std_logic;
      PLB_MRdDBus : in std_logic_vector(0 to 127);
      PLB_MRdDAck : in std_logic;
      PLB_MRdBTerm : in std_logic;
      PLB_MWrDAck : in std_logic;
      PLB_MWrBTerm : in std_logic;
      M_TAttribute : out std_logic_vector(0 to 15);
      M_lockErr : out std_logic;
      M_abort : out std_logic;
      M_UABus : out std_logic_vector(0 to 31);
      PLB_MBusy : in std_logic;
      PLB_MIRQ : in std_logic;
      PLB_MRdWdAddr : in std_logic_vector(0 to 3)
    );
  end component;

  component mb3_plb_bus_wrapper is
    port (
      PLB_Clk : in std_logic;
      SYS_Rst : in std_logic;
      PLB_Rst : out std_logic;
      SPLB_Rst : out std_logic_vector(0 to 0);
      MPLB_Rst : out std_logic_vector(0 to 1);
      PLB_dcrAck : out std_logic;
      PLB_dcrDBus : out std_logic_vector(0 to 31);
      DCR_ABus : in std_logic_vector(0 to 9);
      DCR_DBus : in std_logic_vector(0 to 31);
      DCR_Read : in std_logic;
      DCR_Write : in std_logic;
      M_ABus : in std_logic_vector(0 to 63);
      M_UABus : in std_logic_vector(0 to 63);
      M_BE : in std_logic_vector(0 to 7);
      M_RNW : in std_logic_vector(0 to 1);
      M_abort : in std_logic_vector(0 to 1);
      M_busLock : in std_logic_vector(0 to 1);
      M_TAttribute : in std_logic_vector(0 to 31);
      M_lockErr : in std_logic_vector(0 to 1);
      M_MSize : in std_logic_vector(0 to 3);
      M_priority : in std_logic_vector(0 to 3);
      M_rdBurst : in std_logic_vector(0 to 1);
      M_request : in std_logic_vector(0 to 1);
      M_size : in std_logic_vector(0 to 7);
      M_type : in std_logic_vector(0 to 5);
      M_wrBurst : in std_logic_vector(0 to 1);
      M_wrDBus : in std_logic_vector(0 to 63);
      Sl_addrAck : in std_logic_vector(0 to 0);
      Sl_MRdErr : in std_logic_vector(0 to 1);
      Sl_MWrErr : in std_logic_vector(0 to 1);
      Sl_MBusy : in std_logic_vector(0 to 1);
      Sl_rdBTerm : in std_logic_vector(0 to 0);
      Sl_rdComp : in std_logic_vector(0 to 0);
      Sl_rdDAck : in std_logic_vector(0 to 0);
      Sl_rdDBus : in std_logic_vector(0 to 31);
      Sl_rdWdAddr : in std_logic_vector(0 to 3);
      Sl_rearbitrate : in std_logic_vector(0 to 0);
      Sl_SSize : in std_logic_vector(0 to 1);
      Sl_wait : in std_logic_vector(0 to 0);
      Sl_wrBTerm : in std_logic_vector(0 to 0);
      Sl_wrComp : in std_logic_vector(0 to 0);
      Sl_wrDAck : in std_logic_vector(0 to 0);
      Sl_MIRQ : in std_logic_vector(0 to 1);
      PLB_MIRQ : out std_logic_vector(0 to 1);
      PLB_ABus : out std_logic_vector(0 to 31);
      PLB_UABus : out std_logic_vector(0 to 31);
      PLB_BE : out std_logic_vector(0 to 3);
      PLB_MAddrAck : out std_logic_vector(0 to 1);
      PLB_MTimeout : out std_logic_vector(0 to 1);
      PLB_MBusy : out std_logic_vector(0 to 1);
      PLB_MRdErr : out std_logic_vector(0 to 1);
      PLB_MWrErr : out std_logic_vector(0 to 1);
      PLB_MRdBTerm : out std_logic_vector(0 to 1);
      PLB_MRdDAck : out std_logic_vector(0 to 1);
      PLB_MRdDBus : out std_logic_vector(0 to 63);
      PLB_MRdWdAddr : out std_logic_vector(0 to 7);
      PLB_MRearbitrate : out std_logic_vector(0 to 1);
      PLB_MWrBTerm : out std_logic_vector(0 to 1);
      PLB_MWrDAck : out std_logic_vector(0 to 1);
      PLB_MSSize : out std_logic_vector(0 to 3);
      PLB_PAValid : out std_logic;
      PLB_RNW : out std_logic;
      PLB_SAValid : out std_logic;
      PLB_abort : out std_logic;
      PLB_busLock : out std_logic;
      PLB_TAttribute : out std_logic_vector(0 to 15);
      PLB_lockErr : out std_logic;
      PLB_masterID : out std_logic_vector(0 to 0);
      PLB_MSize : out std_logic_vector(0 to 1);
      PLB_rdPendPri : out std_logic_vector(0 to 1);
      PLB_wrPendPri : out std_logic_vector(0 to 1);
      PLB_rdPendReq : out std_logic;
      PLB_wrPendReq : out std_logic;
      PLB_rdBurst : out std_logic;
      PLB_rdPrim : out std_logic_vector(0 to 0);
      PLB_reqPri : out std_logic_vector(0 to 1);
      PLB_size : out std_logic_vector(0 to 3);
      PLB_type : out std_logic_vector(0 to 2);
      PLB_wrBurst : out std_logic;
      PLB_wrDBus : out std_logic_vector(0 to 31);
      PLB_wrPrim : out std_logic_vector(0 to 0);
      PLB_SaddrAck : out std_logic;
      PLB_SMRdErr : out std_logic_vector(0 to 1);
      PLB_SMWrErr : out std_logic_vector(0 to 1);
      PLB_SMBusy : out std_logic_vector(0 to 1);
      PLB_SrdBTerm : out std_logic;
      PLB_SrdComp : out std_logic;
      PLB_SrdDAck : out std_logic;
      PLB_SrdDBus : out std_logic_vector(0 to 31);
      PLB_SrdWdAddr : out std_logic_vector(0 to 3);
      PLB_Srearbitrate : out std_logic;
      PLB_Sssize : out std_logic_vector(0 to 1);
      PLB_Swait : out std_logic;
      PLB_SwrBTerm : out std_logic;
      PLB_SwrComp : out std_logic;
      PLB_SwrDAck : out std_logic;
      Bus_Error_Det : out std_logic
    );
  end component;

  component microblaze_mb4_wrapper is
    port (
      CLK : in std_logic;
      RESET : in std_logic;
      MB_RESET : in std_logic;
      INTERRUPT : in std_logic;
      EXT_BRK : in std_logic;
      EXT_NM_BRK : in std_logic;
      DBG_STOP : in std_logic;
      MB_Halted : out std_logic;
      INSTR : in std_logic_vector(0 to 31);
      I_ADDRTAG : out std_logic_vector(0 to 3);
      IREADY : in std_logic;
      IWAIT : in std_logic;
      INSTR_ADDR : out std_logic_vector(0 to 31);
      IFETCH : out std_logic;
      I_AS : out std_logic;
      IPLB_M_ABort : out std_logic;
      IPLB_M_ABus : out std_logic_vector(0 to 31);
      IPLB_M_UABus : out std_logic_vector(0 to 31);
      IPLB_M_BE : out std_logic_vector(0 to 3);
      IPLB_M_busLock : out std_logic;
      IPLB_M_lockErr : out std_logic;
      IPLB_M_MSize : out std_logic_vector(0 to 1);
      IPLB_M_priority : out std_logic_vector(0 to 1);
      IPLB_M_rdBurst : out std_logic;
      IPLB_M_request : out std_logic;
      IPLB_M_RNW : out std_logic;
      IPLB_M_size : out std_logic_vector(0 to 3);
      IPLB_M_TAttribute : out std_logic_vector(0 to 15);
      IPLB_M_type : out std_logic_vector(0 to 2);
      IPLB_M_wrBurst : out std_logic;
      IPLB_M_wrDBus : out std_logic_vector(0 to 31);
      IPLB_MBusy : in std_logic;
      IPLB_MRdErr : in std_logic;
      IPLB_MWrErr : in std_logic;
      IPLB_MIRQ : in std_logic;
      IPLB_MWrBTerm : in std_logic;
      IPLB_MWrDAck : in std_logic;
      IPLB_MAddrAck : in std_logic;
      IPLB_MRdBTerm : in std_logic;
      IPLB_MRdDAck : in std_logic;
      IPLB_MRdDBus : in std_logic_vector(0 to 31);
      IPLB_MRdWdAddr : in std_logic_vector(0 to 3);
      IPLB_MRearbitrate : in std_logic;
      IPLB_MSSize : in std_logic_vector(0 to 1);
      IPLB_MTimeout : in std_logic;
      DATA_READ : in std_logic_vector(0 to 31);
      DREADY : in std_logic;
      DWAIT : in std_logic;
      DATA_WRITE : out std_logic_vector(0 to 31);
      DATA_ADDR : out std_logic_vector(0 to 31);
      D_ADDRTAG : out std_logic_vector(0 to 3);
      D_AS : out std_logic;
      READ_STROBE : out std_logic;
      WRITE_STROBE : out std_logic;
      BYTE_ENABLE : out std_logic_vector(0 to 3);
      DM_ABUS : out std_logic_vector(0 to 31);
      DM_BE : out std_logic_vector(0 to 3);
      DM_BUSLOCK : out std_logic;
      DM_DBUS : out std_logic_vector(0 to 31);
      DM_REQUEST : out std_logic;
      DM_RNW : out std_logic;
      DM_SELECT : out std_logic;
      DM_SEQADDR : out std_logic;
      DOPB_DBUS : in std_logic_vector(0 to 31);
      DOPB_ERRACK : in std_logic;
      DOPB_MGRANT : in std_logic;
      DOPB_RETRY : in std_logic;
      DOPB_TIMEOUT : in std_logic;
      DOPB_XFERACK : in std_logic;
      DPLB_M_ABort : out std_logic;
      DPLB_M_ABus : out std_logic_vector(0 to 31);
      DPLB_M_UABus : out std_logic_vector(0 to 31);
      DPLB_M_BE : out std_logic_vector(0 to 3);
      DPLB_M_busLock : out std_logic;
      DPLB_M_lockErr : out std_logic;
      DPLB_M_MSize : out std_logic_vector(0 to 1);
      DPLB_M_priority : out std_logic_vector(0 to 1);
      DPLB_M_rdBurst : out std_logic;
      DPLB_M_request : out std_logic;
      DPLB_M_RNW : out std_logic;
      DPLB_M_size : out std_logic_vector(0 to 3);
      DPLB_M_TAttribute : out std_logic_vector(0 to 15);
      DPLB_M_type : out std_logic_vector(0 to 2);
      DPLB_M_wrBurst : out std_logic;
      DPLB_M_wrDBus : out std_logic_vector(0 to 31);
      DPLB_MBusy : in std_logic;
      DPLB_MRdErr : in std_logic;
      DPLB_MWrErr : in std_logic;
      DPLB_MIRQ : in std_logic;
      DPLB_MWrBTerm : in std_logic;
      DPLB_MWrDAck : in std_logic;
      DPLB_MAddrAck : in std_logic;
      DPLB_MRdBTerm : in std_logic;
      DPLB_MRdDAck : in std_logic;
      DPLB_MRdDBus : in std_logic_vector(0 to 31);
      DPLB_MRdWdAddr : in std_logic_vector(0 to 3);
      DPLB_MRearbitrate : in std_logic;
      DPLB_MSSize : in std_logic_vector(0 to 1);
      DPLB_MTimeout : in std_logic;
      IM_ABUS : out std_logic_vector(0 to 31);
      IM_BE : out std_logic_vector(0 to 3);
      IM_BUSLOCK : out std_logic;
      IM_DBUS : out std_logic_vector(0 to 31);
      IM_REQUEST : out std_logic;
      IM_RNW : out std_logic;
      IM_SELECT : out std_logic;
      IM_SEQADDR : out std_logic;
      IOPB_DBUS : in std_logic_vector(0 to 31);
      IOPB_ERRACK : in std_logic;
      IOPB_MGRANT : in std_logic;
      IOPB_RETRY : in std_logic;
      IOPB_TIMEOUT : in std_logic;
      IOPB_XFERACK : in std_logic;
      DBG_CLK : in std_logic;
      DBG_TDI : in std_logic;
      DBG_TDO : out std_logic;
      DBG_REG_EN : in std_logic_vector(0 to 4);
      DBG_SHIFT : in std_logic;
      DBG_CAPTURE : in std_logic;
      DBG_UPDATE : in std_logic;
      DEBUG_RST : in std_logic;
      Trace_Instruction : out std_logic_vector(0 to 31);
      Trace_Valid_Instr : out std_logic;
      Trace_PC : out std_logic_vector(0 to 31);
      Trace_Reg_Write : out std_logic;
      Trace_Reg_Addr : out std_logic_vector(0 to 4);
      Trace_MSR_Reg : out std_logic_vector(0 to 14);
      Trace_PID_Reg : out std_logic_vector(0 to 7);
      Trace_New_Reg_Value : out std_logic_vector(0 to 31);
      Trace_Exception_Taken : out std_logic;
      Trace_Exception_Kind : out std_logic_vector(0 to 4);
      Trace_Jump_Taken : out std_logic;
      Trace_Delay_Slot : out std_logic;
      Trace_Data_Address : out std_logic_vector(0 to 31);
      Trace_Data_Access : out std_logic;
      Trace_Data_Read : out std_logic;
      Trace_Data_Write : out std_logic;
      Trace_Data_Write_Value : out std_logic_vector(0 to 31);
      Trace_Data_Byte_Enable : out std_logic_vector(0 to 3);
      Trace_DCache_Req : out std_logic;
      Trace_DCache_Hit : out std_logic;
      Trace_ICache_Req : out std_logic;
      Trace_ICache_Hit : out std_logic;
      Trace_OF_PipeRun : out std_logic;
      Trace_EX_PipeRun : out std_logic;
      Trace_MEM_PipeRun : out std_logic;
      Trace_MB_Halted : out std_logic;
      FSL0_S_CLK : out std_logic;
      FSL0_S_READ : out std_logic;
      FSL0_S_DATA : in std_logic_vector(0 to 31);
      FSL0_S_CONTROL : in std_logic;
      FSL0_S_EXISTS : in std_logic;
      FSL0_M_CLK : out std_logic;
      FSL0_M_WRITE : out std_logic;
      FSL0_M_DATA : out std_logic_vector(0 to 31);
      FSL0_M_CONTROL : out std_logic;
      FSL0_M_FULL : in std_logic;
      FSL1_S_CLK : out std_logic;
      FSL1_S_READ : out std_logic;
      FSL1_S_DATA : in std_logic_vector(0 to 31);
      FSL1_S_CONTROL : in std_logic;
      FSL1_S_EXISTS : in std_logic;
      FSL1_M_CLK : out std_logic;
      FSL1_M_WRITE : out std_logic;
      FSL1_M_DATA : out std_logic_vector(0 to 31);
      FSL1_M_CONTROL : out std_logic;
      FSL1_M_FULL : in std_logic;
      FSL2_S_CLK : out std_logic;
      FSL2_S_READ : out std_logic;
      FSL2_S_DATA : in std_logic_vector(0 to 31);
      FSL2_S_CONTROL : in std_logic;
      FSL2_S_EXISTS : in std_logic;
      FSL2_M_CLK : out std_logic;
      FSL2_M_WRITE : out std_logic;
      FSL2_M_DATA : out std_logic_vector(0 to 31);
      FSL2_M_CONTROL : out std_logic;
      FSL2_M_FULL : in std_logic;
      FSL3_S_CLK : out std_logic;
      FSL3_S_READ : out std_logic;
      FSL3_S_DATA : in std_logic_vector(0 to 31);
      FSL3_S_CONTROL : in std_logic;
      FSL3_S_EXISTS : in std_logic;
      FSL3_M_CLK : out std_logic;
      FSL3_M_WRITE : out std_logic;
      FSL3_M_DATA : out std_logic_vector(0 to 31);
      FSL3_M_CONTROL : out std_logic;
      FSL3_M_FULL : in std_logic;
      FSL4_S_CLK : out std_logic;
      FSL4_S_READ : out std_logic;
      FSL4_S_DATA : in std_logic_vector(0 to 31);
      FSL4_S_CONTROL : in std_logic;
      FSL4_S_EXISTS : in std_logic;
      FSL4_M_CLK : out std_logic;
      FSL4_M_WRITE : out std_logic;
      FSL4_M_DATA : out std_logic_vector(0 to 31);
      FSL4_M_CONTROL : out std_logic;
      FSL4_M_FULL : in std_logic;
      FSL5_S_CLK : out std_logic;
      FSL5_S_READ : out std_logic;
      FSL5_S_DATA : in std_logic_vector(0 to 31);
      FSL5_S_CONTROL : in std_logic;
      FSL5_S_EXISTS : in std_logic;
      FSL5_M_CLK : out std_logic;
      FSL5_M_WRITE : out std_logic;
      FSL5_M_DATA : out std_logic_vector(0 to 31);
      FSL5_M_CONTROL : out std_logic;
      FSL5_M_FULL : in std_logic;
      FSL6_S_CLK : out std_logic;
      FSL6_S_READ : out std_logic;
      FSL6_S_DATA : in std_logic_vector(0 to 31);
      FSL6_S_CONTROL : in std_logic;
      FSL6_S_EXISTS : in std_logic;
      FSL6_M_CLK : out std_logic;
      FSL6_M_WRITE : out std_logic;
      FSL6_M_DATA : out std_logic_vector(0 to 31);
      FSL6_M_CONTROL : out std_logic;
      FSL6_M_FULL : in std_logic;
      FSL7_S_CLK : out std_logic;
      FSL7_S_READ : out std_logic;
      FSL7_S_DATA : in std_logic_vector(0 to 31);
      FSL7_S_CONTROL : in std_logic;
      FSL7_S_EXISTS : in std_logic;
      FSL7_M_CLK : out std_logic;
      FSL7_M_WRITE : out std_logic;
      FSL7_M_DATA : out std_logic_vector(0 to 31);
      FSL7_M_CONTROL : out std_logic;
      FSL7_M_FULL : in std_logic;
      FSL8_S_CLK : out std_logic;
      FSL8_S_READ : out std_logic;
      FSL8_S_DATA : in std_logic_vector(0 to 31);
      FSL8_S_CONTROL : in std_logic;
      FSL8_S_EXISTS : in std_logic;
      FSL8_M_CLK : out std_logic;
      FSL8_M_WRITE : out std_logic;
      FSL8_M_DATA : out std_logic_vector(0 to 31);
      FSL8_M_CONTROL : out std_logic;
      FSL8_M_FULL : in std_logic;
      FSL9_S_CLK : out std_logic;
      FSL9_S_READ : out std_logic;
      FSL9_S_DATA : in std_logic_vector(0 to 31);
      FSL9_S_CONTROL : in std_logic;
      FSL9_S_EXISTS : in std_logic;
      FSL9_M_CLK : out std_logic;
      FSL9_M_WRITE : out std_logic;
      FSL9_M_DATA : out std_logic_vector(0 to 31);
      FSL9_M_CONTROL : out std_logic;
      FSL9_M_FULL : in std_logic;
      FSL10_S_CLK : out std_logic;
      FSL10_S_READ : out std_logic;
      FSL10_S_DATA : in std_logic_vector(0 to 31);
      FSL10_S_CONTROL : in std_logic;
      FSL10_S_EXISTS : in std_logic;
      FSL10_M_CLK : out std_logic;
      FSL10_M_WRITE : out std_logic;
      FSL10_M_DATA : out std_logic_vector(0 to 31);
      FSL10_M_CONTROL : out std_logic;
      FSL10_M_FULL : in std_logic;
      FSL11_S_CLK : out std_logic;
      FSL11_S_READ : out std_logic;
      FSL11_S_DATA : in std_logic_vector(0 to 31);
      FSL11_S_CONTROL : in std_logic;
      FSL11_S_EXISTS : in std_logic;
      FSL11_M_CLK : out std_logic;
      FSL11_M_WRITE : out std_logic;
      FSL11_M_DATA : out std_logic_vector(0 to 31);
      FSL11_M_CONTROL : out std_logic;
      FSL11_M_FULL : in std_logic;
      FSL12_S_CLK : out std_logic;
      FSL12_S_READ : out std_logic;
      FSL12_S_DATA : in std_logic_vector(0 to 31);
      FSL12_S_CONTROL : in std_logic;
      FSL12_S_EXISTS : in std_logic;
      FSL12_M_CLK : out std_logic;
      FSL12_M_WRITE : out std_logic;
      FSL12_M_DATA : out std_logic_vector(0 to 31);
      FSL12_M_CONTROL : out std_logic;
      FSL12_M_FULL : in std_logic;
      FSL13_S_CLK : out std_logic;
      FSL13_S_READ : out std_logic;
      FSL13_S_DATA : in std_logic_vector(0 to 31);
      FSL13_S_CONTROL : in std_logic;
      FSL13_S_EXISTS : in std_logic;
      FSL13_M_CLK : out std_logic;
      FSL13_M_WRITE : out std_logic;
      FSL13_M_DATA : out std_logic_vector(0 to 31);
      FSL13_M_CONTROL : out std_logic;
      FSL13_M_FULL : in std_logic;
      FSL14_S_CLK : out std_logic;
      FSL14_S_READ : out std_logic;
      FSL14_S_DATA : in std_logic_vector(0 to 31);
      FSL14_S_CONTROL : in std_logic;
      FSL14_S_EXISTS : in std_logic;
      FSL14_M_CLK : out std_logic;
      FSL14_M_WRITE : out std_logic;
      FSL14_M_DATA : out std_logic_vector(0 to 31);
      FSL14_M_CONTROL : out std_logic;
      FSL14_M_FULL : in std_logic;
      FSL15_S_CLK : out std_logic;
      FSL15_S_READ : out std_logic;
      FSL15_S_DATA : in std_logic_vector(0 to 31);
      FSL15_S_CONTROL : in std_logic;
      FSL15_S_EXISTS : in std_logic;
      FSL15_M_CLK : out std_logic;
      FSL15_M_WRITE : out std_logic;
      FSL15_M_DATA : out std_logic_vector(0 to 31);
      FSL15_M_CONTROL : out std_logic;
      FSL15_M_FULL : in std_logic;
      ICACHE_FSL_IN_CLK : out std_logic;
      ICACHE_FSL_IN_READ : out std_logic;
      ICACHE_FSL_IN_DATA : in std_logic_vector(0 to 31);
      ICACHE_FSL_IN_CONTROL : in std_logic;
      ICACHE_FSL_IN_EXISTS : in std_logic;
      ICACHE_FSL_OUT_CLK : out std_logic;
      ICACHE_FSL_OUT_WRITE : out std_logic;
      ICACHE_FSL_OUT_DATA : out std_logic_vector(0 to 31);
      ICACHE_FSL_OUT_CONTROL : out std_logic;
      ICACHE_FSL_OUT_FULL : in std_logic;
      DCACHE_FSL_IN_CLK : out std_logic;
      DCACHE_FSL_IN_READ : out std_logic;
      DCACHE_FSL_IN_DATA : in std_logic_vector(0 to 31);
      DCACHE_FSL_IN_CONTROL : in std_logic;
      DCACHE_FSL_IN_EXISTS : in std_logic;
      DCACHE_FSL_OUT_CLK : out std_logic;
      DCACHE_FSL_OUT_WRITE : out std_logic;
      DCACHE_FSL_OUT_DATA : out std_logic_vector(0 to 31);
      DCACHE_FSL_OUT_CONTROL : out std_logic;
      DCACHE_FSL_OUT_FULL : in std_logic
    );
  end component;

  component mb_ilmb_mb4_wrapper is
    port (
      LMB_Clk : in std_logic;
      SYS_Rst : in std_logic;
      LMB_Rst : out std_logic;
      M_ABus : in std_logic_vector(0 to 31);
      M_ReadStrobe : in std_logic;
      M_WriteStrobe : in std_logic;
      M_AddrStrobe : in std_logic;
      M_DBus : in std_logic_vector(0 to 31);
      M_BE : in std_logic_vector(0 to 3);
      Sl_DBus : in std_logic_vector(0 to 31);
      Sl_Ready : in std_logic_vector(0 to 0);
      LMB_ABus : out std_logic_vector(0 to 31);
      LMB_ReadStrobe : out std_logic;
      LMB_WriteStrobe : out std_logic;
      LMB_AddrStrobe : out std_logic;
      LMB_ReadDBus : out std_logic_vector(0 to 31);
      LMB_WriteDBus : out std_logic_vector(0 to 31);
      LMB_Ready : out std_logic;
      LMB_BE : out std_logic_vector(0 to 3)
    );
  end component;

  component mb_dlmb_mb4_wrapper is
    port (
      LMB_Clk : in std_logic;
      SYS_Rst : in std_logic;
      LMB_Rst : out std_logic;
      M_ABus : in std_logic_vector(0 to 31);
      M_ReadStrobe : in std_logic;
      M_WriteStrobe : in std_logic;
      M_AddrStrobe : in std_logic;
      M_DBus : in std_logic_vector(0 to 31);
      M_BE : in std_logic_vector(0 to 3);
      Sl_DBus : in std_logic_vector(0 to 31);
      Sl_Ready : in std_logic_vector(0 to 0);
      LMB_ABus : out std_logic_vector(0 to 31);
      LMB_ReadStrobe : out std_logic;
      LMB_WriteStrobe : out std_logic;
      LMB_AddrStrobe : out std_logic;
      LMB_ReadDBus : out std_logic_vector(0 to 31);
      LMB_WriteDBus : out std_logic_vector(0 to 31);
      LMB_Ready : out std_logic;
      LMB_BE : out std_logic_vector(0 to 3)
    );
  end component;

  component ilmb_cntlr_mb4_wrapper is
    port (
      LMB_Clk : in std_logic;
      LMB_Rst : in std_logic;
      LMB_ABus : in std_logic_vector(0 to 31);
      LMB_WriteDBus : in std_logic_vector(0 to 31);
      LMB_AddrStrobe : in std_logic;
      LMB_ReadStrobe : in std_logic;
      LMB_WriteStrobe : in std_logic;
      LMB_BE : in std_logic_vector(0 to 3);
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_Ready : out std_logic;
      BRAM_Rst_A : out std_logic;
      BRAM_Clk_A : out std_logic;
      BRAM_EN_A : out std_logic;
      BRAM_WEN_A : out std_logic_vector(0 to 3);
      BRAM_Addr_A : out std_logic_vector(0 to 31);
      BRAM_Din_A : in std_logic_vector(0 to 31);
      BRAM_Dout_A : out std_logic_vector(0 to 31)
    );
  end component;

  component dlmb_cntlr_mb4_wrapper is
    port (
      LMB_Clk : in std_logic;
      LMB_Rst : in std_logic;
      LMB_ABus : in std_logic_vector(0 to 31);
      LMB_WriteDBus : in std_logic_vector(0 to 31);
      LMB_AddrStrobe : in std_logic;
      LMB_ReadStrobe : in std_logic;
      LMB_WriteStrobe : in std_logic;
      LMB_BE : in std_logic_vector(0 to 3);
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_Ready : out std_logic;
      BRAM_Rst_A : out std_logic;
      BRAM_Clk_A : out std_logic;
      BRAM_EN_A : out std_logic;
      BRAM_WEN_A : out std_logic_vector(0 to 3);
      BRAM_Addr_A : out std_logic_vector(0 to 31);
      BRAM_Din_A : in std_logic_vector(0 to 31);
      BRAM_Dout_A : out std_logic_vector(0 to 31)
    );
  end component;

  component mb4_bram_wrapper is
    port (
      BRAM_Rst_A : in std_logic;
      BRAM_Clk_A : in std_logic;
      BRAM_EN_A : in std_logic;
      BRAM_WEN_A : in std_logic_vector(0 to 3);
      BRAM_Addr_A : in std_logic_vector(0 to 31);
      BRAM_Din_A : out std_logic_vector(0 to 31);
      BRAM_Dout_A : in std_logic_vector(0 to 31);
      BRAM_Rst_B : in std_logic;
      BRAM_Clk_B : in std_logic;
      BRAM_EN_B : in std_logic;
      BRAM_WEN_B : in std_logic_vector(0 to 3);
      BRAM_Addr_B : in std_logic_vector(0 to 31);
      BRAM_Din_B : out std_logic_vector(0 to 31);
      BRAM_Dout_B : in std_logic_vector(0 to 31)
    );
  end component;

  component mb4_plb_bridge_wrapper is
    port (
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      IP2INTC_Irpt : out std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 0);
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to 3);
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_lockErr : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to 31);
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_wrBTerm : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 31);
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_rdBTerm : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 1);
      Sl_MWrErr : out std_logic_vector(0 to 1);
      Sl_MRdErr : out std_logic_vector(0 to 1);
      Sl_MIRQ : out std_logic_vector(0 to 1);
      MPLB_Clk : in std_logic;
      MPLB_Rst : in std_logic;
      M_request : out std_logic;
      M_priority : out std_logic_vector(0 to 1);
      M_busLock : out std_logic;
      M_RNW : out std_logic;
      M_BE : out std_logic_vector(0 to 15);
      M_MSize : out std_logic_vector(0 to 1);
      M_size : out std_logic_vector(0 to 3);
      M_type : out std_logic_vector(0 to 2);
      M_ABus : out std_logic_vector(0 to 31);
      M_wrBurst : out std_logic;
      M_rdBurst : out std_logic;
      M_wrDBus : out std_logic_vector(0 to 127);
      PLB_MAddrAck : in std_logic;
      PLB_MSSize : in std_logic_vector(0 to 1);
      PLB_MRearbitrate : in std_logic;
      PLB_MTimeout : in std_logic;
      PLB_MRdErr : in std_logic;
      PLB_MWrErr : in std_logic;
      PLB_MRdDBus : in std_logic_vector(0 to 127);
      PLB_MRdDAck : in std_logic;
      PLB_MRdBTerm : in std_logic;
      PLB_MWrDAck : in std_logic;
      PLB_MWrBTerm : in std_logic;
      M_TAttribute : out std_logic_vector(0 to 15);
      M_lockErr : out std_logic;
      M_abort : out std_logic;
      M_UABus : out std_logic_vector(0 to 31);
      PLB_MBusy : in std_logic;
      PLB_MIRQ : in std_logic;
      PLB_MRdWdAddr : in std_logic_vector(0 to 3)
    );
  end component;

  component mb4_plb_bus_wrapper is
    port (
      PLB_Clk : in std_logic;
      SYS_Rst : in std_logic;
      PLB_Rst : out std_logic;
      SPLB_Rst : out std_logic_vector(0 to 0);
      MPLB_Rst : out std_logic_vector(0 to 1);
      PLB_dcrAck : out std_logic;
      PLB_dcrDBus : out std_logic_vector(0 to 31);
      DCR_ABus : in std_logic_vector(0 to 9);
      DCR_DBus : in std_logic_vector(0 to 31);
      DCR_Read : in std_logic;
      DCR_Write : in std_logic;
      M_ABus : in std_logic_vector(0 to 63);
      M_UABus : in std_logic_vector(0 to 63);
      M_BE : in std_logic_vector(0 to 7);
      M_RNW : in std_logic_vector(0 to 1);
      M_abort : in std_logic_vector(0 to 1);
      M_busLock : in std_logic_vector(0 to 1);
      M_TAttribute : in std_logic_vector(0 to 31);
      M_lockErr : in std_logic_vector(0 to 1);
      M_MSize : in std_logic_vector(0 to 3);
      M_priority : in std_logic_vector(0 to 3);
      M_rdBurst : in std_logic_vector(0 to 1);
      M_request : in std_logic_vector(0 to 1);
      M_size : in std_logic_vector(0 to 7);
      M_type : in std_logic_vector(0 to 5);
      M_wrBurst : in std_logic_vector(0 to 1);
      M_wrDBus : in std_logic_vector(0 to 63);
      Sl_addrAck : in std_logic_vector(0 to 0);
      Sl_MRdErr : in std_logic_vector(0 to 1);
      Sl_MWrErr : in std_logic_vector(0 to 1);
      Sl_MBusy : in std_logic_vector(0 to 1);
      Sl_rdBTerm : in std_logic_vector(0 to 0);
      Sl_rdComp : in std_logic_vector(0 to 0);
      Sl_rdDAck : in std_logic_vector(0 to 0);
      Sl_rdDBus : in std_logic_vector(0 to 31);
      Sl_rdWdAddr : in std_logic_vector(0 to 3);
      Sl_rearbitrate : in std_logic_vector(0 to 0);
      Sl_SSize : in std_logic_vector(0 to 1);
      Sl_wait : in std_logic_vector(0 to 0);
      Sl_wrBTerm : in std_logic_vector(0 to 0);
      Sl_wrComp : in std_logic_vector(0 to 0);
      Sl_wrDAck : in std_logic_vector(0 to 0);
      Sl_MIRQ : in std_logic_vector(0 to 1);
      PLB_MIRQ : out std_logic_vector(0 to 1);
      PLB_ABus : out std_logic_vector(0 to 31);
      PLB_UABus : out std_logic_vector(0 to 31);
      PLB_BE : out std_logic_vector(0 to 3);
      PLB_MAddrAck : out std_logic_vector(0 to 1);
      PLB_MTimeout : out std_logic_vector(0 to 1);
      PLB_MBusy : out std_logic_vector(0 to 1);
      PLB_MRdErr : out std_logic_vector(0 to 1);
      PLB_MWrErr : out std_logic_vector(0 to 1);
      PLB_MRdBTerm : out std_logic_vector(0 to 1);
      PLB_MRdDAck : out std_logic_vector(0 to 1);
      PLB_MRdDBus : out std_logic_vector(0 to 63);
      PLB_MRdWdAddr : out std_logic_vector(0 to 7);
      PLB_MRearbitrate : out std_logic_vector(0 to 1);
      PLB_MWrBTerm : out std_logic_vector(0 to 1);
      PLB_MWrDAck : out std_logic_vector(0 to 1);
      PLB_MSSize : out std_logic_vector(0 to 3);
      PLB_PAValid : out std_logic;
      PLB_RNW : out std_logic;
      PLB_SAValid : out std_logic;
      PLB_abort : out std_logic;
      PLB_busLock : out std_logic;
      PLB_TAttribute : out std_logic_vector(0 to 15);
      PLB_lockErr : out std_logic;
      PLB_masterID : out std_logic_vector(0 to 0);
      PLB_MSize : out std_logic_vector(0 to 1);
      PLB_rdPendPri : out std_logic_vector(0 to 1);
      PLB_wrPendPri : out std_logic_vector(0 to 1);
      PLB_rdPendReq : out std_logic;
      PLB_wrPendReq : out std_logic;
      PLB_rdBurst : out std_logic;
      PLB_rdPrim : out std_logic_vector(0 to 0);
      PLB_reqPri : out std_logic_vector(0 to 1);
      PLB_size : out std_logic_vector(0 to 3);
      PLB_type : out std_logic_vector(0 to 2);
      PLB_wrBurst : out std_logic;
      PLB_wrDBus : out std_logic_vector(0 to 31);
      PLB_wrPrim : out std_logic_vector(0 to 0);
      PLB_SaddrAck : out std_logic;
      PLB_SMRdErr : out std_logic_vector(0 to 1);
      PLB_SMWrErr : out std_logic_vector(0 to 1);
      PLB_SMBusy : out std_logic_vector(0 to 1);
      PLB_SrdBTerm : out std_logic;
      PLB_SrdComp : out std_logic;
      PLB_SrdDAck : out std_logic;
      PLB_SrdDBus : out std_logic_vector(0 to 31);
      PLB_SrdWdAddr : out std_logic_vector(0 to 3);
      PLB_Srearbitrate : out std_logic;
      PLB_Sssize : out std_logic_vector(0 to 1);
      PLB_Swait : out std_logic;
      PLB_SwrBTerm : out std_logic;
      PLB_SwrComp : out std_logic;
      PLB_SwrDAck : out std_logic;
      Bus_Error_Det : out std_logic
    );
  end component;

  component microblaze_mb5_wrapper is
    port (
      CLK : in std_logic;
      RESET : in std_logic;
      MB_RESET : in std_logic;
      INTERRUPT : in std_logic;
      EXT_BRK : in std_logic;
      EXT_NM_BRK : in std_logic;
      DBG_STOP : in std_logic;
      MB_Halted : out std_logic;
      INSTR : in std_logic_vector(0 to 31);
      I_ADDRTAG : out std_logic_vector(0 to 3);
      IREADY : in std_logic;
      IWAIT : in std_logic;
      INSTR_ADDR : out std_logic_vector(0 to 31);
      IFETCH : out std_logic;
      I_AS : out std_logic;
      IPLB_M_ABort : out std_logic;
      IPLB_M_ABus : out std_logic_vector(0 to 31);
      IPLB_M_UABus : out std_logic_vector(0 to 31);
      IPLB_M_BE : out std_logic_vector(0 to 3);
      IPLB_M_busLock : out std_logic;
      IPLB_M_lockErr : out std_logic;
      IPLB_M_MSize : out std_logic_vector(0 to 1);
      IPLB_M_priority : out std_logic_vector(0 to 1);
      IPLB_M_rdBurst : out std_logic;
      IPLB_M_request : out std_logic;
      IPLB_M_RNW : out std_logic;
      IPLB_M_size : out std_logic_vector(0 to 3);
      IPLB_M_TAttribute : out std_logic_vector(0 to 15);
      IPLB_M_type : out std_logic_vector(0 to 2);
      IPLB_M_wrBurst : out std_logic;
      IPLB_M_wrDBus : out std_logic_vector(0 to 31);
      IPLB_MBusy : in std_logic;
      IPLB_MRdErr : in std_logic;
      IPLB_MWrErr : in std_logic;
      IPLB_MIRQ : in std_logic;
      IPLB_MWrBTerm : in std_logic;
      IPLB_MWrDAck : in std_logic;
      IPLB_MAddrAck : in std_logic;
      IPLB_MRdBTerm : in std_logic;
      IPLB_MRdDAck : in std_logic;
      IPLB_MRdDBus : in std_logic_vector(0 to 31);
      IPLB_MRdWdAddr : in std_logic_vector(0 to 3);
      IPLB_MRearbitrate : in std_logic;
      IPLB_MSSize : in std_logic_vector(0 to 1);
      IPLB_MTimeout : in std_logic;
      DATA_READ : in std_logic_vector(0 to 31);
      DREADY : in std_logic;
      DWAIT : in std_logic;
      DATA_WRITE : out std_logic_vector(0 to 31);
      DATA_ADDR : out std_logic_vector(0 to 31);
      D_ADDRTAG : out std_logic_vector(0 to 3);
      D_AS : out std_logic;
      READ_STROBE : out std_logic;
      WRITE_STROBE : out std_logic;
      BYTE_ENABLE : out std_logic_vector(0 to 3);
      DM_ABUS : out std_logic_vector(0 to 31);
      DM_BE : out std_logic_vector(0 to 3);
      DM_BUSLOCK : out std_logic;
      DM_DBUS : out std_logic_vector(0 to 31);
      DM_REQUEST : out std_logic;
      DM_RNW : out std_logic;
      DM_SELECT : out std_logic;
      DM_SEQADDR : out std_logic;
      DOPB_DBUS : in std_logic_vector(0 to 31);
      DOPB_ERRACK : in std_logic;
      DOPB_MGRANT : in std_logic;
      DOPB_RETRY : in std_logic;
      DOPB_TIMEOUT : in std_logic;
      DOPB_XFERACK : in std_logic;
      DPLB_M_ABort : out std_logic;
      DPLB_M_ABus : out std_logic_vector(0 to 31);
      DPLB_M_UABus : out std_logic_vector(0 to 31);
      DPLB_M_BE : out std_logic_vector(0 to 3);
      DPLB_M_busLock : out std_logic;
      DPLB_M_lockErr : out std_logic;
      DPLB_M_MSize : out std_logic_vector(0 to 1);
      DPLB_M_priority : out std_logic_vector(0 to 1);
      DPLB_M_rdBurst : out std_logic;
      DPLB_M_request : out std_logic;
      DPLB_M_RNW : out std_logic;
      DPLB_M_size : out std_logic_vector(0 to 3);
      DPLB_M_TAttribute : out std_logic_vector(0 to 15);
      DPLB_M_type : out std_logic_vector(0 to 2);
      DPLB_M_wrBurst : out std_logic;
      DPLB_M_wrDBus : out std_logic_vector(0 to 31);
      DPLB_MBusy : in std_logic;
      DPLB_MRdErr : in std_logic;
      DPLB_MWrErr : in std_logic;
      DPLB_MIRQ : in std_logic;
      DPLB_MWrBTerm : in std_logic;
      DPLB_MWrDAck : in std_logic;
      DPLB_MAddrAck : in std_logic;
      DPLB_MRdBTerm : in std_logic;
      DPLB_MRdDAck : in std_logic;
      DPLB_MRdDBus : in std_logic_vector(0 to 31);
      DPLB_MRdWdAddr : in std_logic_vector(0 to 3);
      DPLB_MRearbitrate : in std_logic;
      DPLB_MSSize : in std_logic_vector(0 to 1);
      DPLB_MTimeout : in std_logic;
      IM_ABUS : out std_logic_vector(0 to 31);
      IM_BE : out std_logic_vector(0 to 3);
      IM_BUSLOCK : out std_logic;
      IM_DBUS : out std_logic_vector(0 to 31);
      IM_REQUEST : out std_logic;
      IM_RNW : out std_logic;
      IM_SELECT : out std_logic;
      IM_SEQADDR : out std_logic;
      IOPB_DBUS : in std_logic_vector(0 to 31);
      IOPB_ERRACK : in std_logic;
      IOPB_MGRANT : in std_logic;
      IOPB_RETRY : in std_logic;
      IOPB_TIMEOUT : in std_logic;
      IOPB_XFERACK : in std_logic;
      DBG_CLK : in std_logic;
      DBG_TDI : in std_logic;
      DBG_TDO : out std_logic;
      DBG_REG_EN : in std_logic_vector(0 to 4);
      DBG_SHIFT : in std_logic;
      DBG_CAPTURE : in std_logic;
      DBG_UPDATE : in std_logic;
      DEBUG_RST : in std_logic;
      Trace_Instruction : out std_logic_vector(0 to 31);
      Trace_Valid_Instr : out std_logic;
      Trace_PC : out std_logic_vector(0 to 31);
      Trace_Reg_Write : out std_logic;
      Trace_Reg_Addr : out std_logic_vector(0 to 4);
      Trace_MSR_Reg : out std_logic_vector(0 to 14);
      Trace_PID_Reg : out std_logic_vector(0 to 7);
      Trace_New_Reg_Value : out std_logic_vector(0 to 31);
      Trace_Exception_Taken : out std_logic;
      Trace_Exception_Kind : out std_logic_vector(0 to 4);
      Trace_Jump_Taken : out std_logic;
      Trace_Delay_Slot : out std_logic;
      Trace_Data_Address : out std_logic_vector(0 to 31);
      Trace_Data_Access : out std_logic;
      Trace_Data_Read : out std_logic;
      Trace_Data_Write : out std_logic;
      Trace_Data_Write_Value : out std_logic_vector(0 to 31);
      Trace_Data_Byte_Enable : out std_logic_vector(0 to 3);
      Trace_DCache_Req : out std_logic;
      Trace_DCache_Hit : out std_logic;
      Trace_ICache_Req : out std_logic;
      Trace_ICache_Hit : out std_logic;
      Trace_OF_PipeRun : out std_logic;
      Trace_EX_PipeRun : out std_logic;
      Trace_MEM_PipeRun : out std_logic;
      Trace_MB_Halted : out std_logic;
      FSL0_S_CLK : out std_logic;
      FSL0_S_READ : out std_logic;
      FSL0_S_DATA : in std_logic_vector(0 to 31);
      FSL0_S_CONTROL : in std_logic;
      FSL0_S_EXISTS : in std_logic;
      FSL0_M_CLK : out std_logic;
      FSL0_M_WRITE : out std_logic;
      FSL0_M_DATA : out std_logic_vector(0 to 31);
      FSL0_M_CONTROL : out std_logic;
      FSL0_M_FULL : in std_logic;
      FSL1_S_CLK : out std_logic;
      FSL1_S_READ : out std_logic;
      FSL1_S_DATA : in std_logic_vector(0 to 31);
      FSL1_S_CONTROL : in std_logic;
      FSL1_S_EXISTS : in std_logic;
      FSL1_M_CLK : out std_logic;
      FSL1_M_WRITE : out std_logic;
      FSL1_M_DATA : out std_logic_vector(0 to 31);
      FSL1_M_CONTROL : out std_logic;
      FSL1_M_FULL : in std_logic;
      FSL2_S_CLK : out std_logic;
      FSL2_S_READ : out std_logic;
      FSL2_S_DATA : in std_logic_vector(0 to 31);
      FSL2_S_CONTROL : in std_logic;
      FSL2_S_EXISTS : in std_logic;
      FSL2_M_CLK : out std_logic;
      FSL2_M_WRITE : out std_logic;
      FSL2_M_DATA : out std_logic_vector(0 to 31);
      FSL2_M_CONTROL : out std_logic;
      FSL2_M_FULL : in std_logic;
      FSL3_S_CLK : out std_logic;
      FSL3_S_READ : out std_logic;
      FSL3_S_DATA : in std_logic_vector(0 to 31);
      FSL3_S_CONTROL : in std_logic;
      FSL3_S_EXISTS : in std_logic;
      FSL3_M_CLK : out std_logic;
      FSL3_M_WRITE : out std_logic;
      FSL3_M_DATA : out std_logic_vector(0 to 31);
      FSL3_M_CONTROL : out std_logic;
      FSL3_M_FULL : in std_logic;
      FSL4_S_CLK : out std_logic;
      FSL4_S_READ : out std_logic;
      FSL4_S_DATA : in std_logic_vector(0 to 31);
      FSL4_S_CONTROL : in std_logic;
      FSL4_S_EXISTS : in std_logic;
      FSL4_M_CLK : out std_logic;
      FSL4_M_WRITE : out std_logic;
      FSL4_M_DATA : out std_logic_vector(0 to 31);
      FSL4_M_CONTROL : out std_logic;
      FSL4_M_FULL : in std_logic;
      FSL5_S_CLK : out std_logic;
      FSL5_S_READ : out std_logic;
      FSL5_S_DATA : in std_logic_vector(0 to 31);
      FSL5_S_CONTROL : in std_logic;
      FSL5_S_EXISTS : in std_logic;
      FSL5_M_CLK : out std_logic;
      FSL5_M_WRITE : out std_logic;
      FSL5_M_DATA : out std_logic_vector(0 to 31);
      FSL5_M_CONTROL : out std_logic;
      FSL5_M_FULL : in std_logic;
      FSL6_S_CLK : out std_logic;
      FSL6_S_READ : out std_logic;
      FSL6_S_DATA : in std_logic_vector(0 to 31);
      FSL6_S_CONTROL : in std_logic;
      FSL6_S_EXISTS : in std_logic;
      FSL6_M_CLK : out std_logic;
      FSL6_M_WRITE : out std_logic;
      FSL6_M_DATA : out std_logic_vector(0 to 31);
      FSL6_M_CONTROL : out std_logic;
      FSL6_M_FULL : in std_logic;
      FSL7_S_CLK : out std_logic;
      FSL7_S_READ : out std_logic;
      FSL7_S_DATA : in std_logic_vector(0 to 31);
      FSL7_S_CONTROL : in std_logic;
      FSL7_S_EXISTS : in std_logic;
      FSL7_M_CLK : out std_logic;
      FSL7_M_WRITE : out std_logic;
      FSL7_M_DATA : out std_logic_vector(0 to 31);
      FSL7_M_CONTROL : out std_logic;
      FSL7_M_FULL : in std_logic;
      FSL8_S_CLK : out std_logic;
      FSL8_S_READ : out std_logic;
      FSL8_S_DATA : in std_logic_vector(0 to 31);
      FSL8_S_CONTROL : in std_logic;
      FSL8_S_EXISTS : in std_logic;
      FSL8_M_CLK : out std_logic;
      FSL8_M_WRITE : out std_logic;
      FSL8_M_DATA : out std_logic_vector(0 to 31);
      FSL8_M_CONTROL : out std_logic;
      FSL8_M_FULL : in std_logic;
      FSL9_S_CLK : out std_logic;
      FSL9_S_READ : out std_logic;
      FSL9_S_DATA : in std_logic_vector(0 to 31);
      FSL9_S_CONTROL : in std_logic;
      FSL9_S_EXISTS : in std_logic;
      FSL9_M_CLK : out std_logic;
      FSL9_M_WRITE : out std_logic;
      FSL9_M_DATA : out std_logic_vector(0 to 31);
      FSL9_M_CONTROL : out std_logic;
      FSL9_M_FULL : in std_logic;
      FSL10_S_CLK : out std_logic;
      FSL10_S_READ : out std_logic;
      FSL10_S_DATA : in std_logic_vector(0 to 31);
      FSL10_S_CONTROL : in std_logic;
      FSL10_S_EXISTS : in std_logic;
      FSL10_M_CLK : out std_logic;
      FSL10_M_WRITE : out std_logic;
      FSL10_M_DATA : out std_logic_vector(0 to 31);
      FSL10_M_CONTROL : out std_logic;
      FSL10_M_FULL : in std_logic;
      FSL11_S_CLK : out std_logic;
      FSL11_S_READ : out std_logic;
      FSL11_S_DATA : in std_logic_vector(0 to 31);
      FSL11_S_CONTROL : in std_logic;
      FSL11_S_EXISTS : in std_logic;
      FSL11_M_CLK : out std_logic;
      FSL11_M_WRITE : out std_logic;
      FSL11_M_DATA : out std_logic_vector(0 to 31);
      FSL11_M_CONTROL : out std_logic;
      FSL11_M_FULL : in std_logic;
      FSL12_S_CLK : out std_logic;
      FSL12_S_READ : out std_logic;
      FSL12_S_DATA : in std_logic_vector(0 to 31);
      FSL12_S_CONTROL : in std_logic;
      FSL12_S_EXISTS : in std_logic;
      FSL12_M_CLK : out std_logic;
      FSL12_M_WRITE : out std_logic;
      FSL12_M_DATA : out std_logic_vector(0 to 31);
      FSL12_M_CONTROL : out std_logic;
      FSL12_M_FULL : in std_logic;
      FSL13_S_CLK : out std_logic;
      FSL13_S_READ : out std_logic;
      FSL13_S_DATA : in std_logic_vector(0 to 31);
      FSL13_S_CONTROL : in std_logic;
      FSL13_S_EXISTS : in std_logic;
      FSL13_M_CLK : out std_logic;
      FSL13_M_WRITE : out std_logic;
      FSL13_M_DATA : out std_logic_vector(0 to 31);
      FSL13_M_CONTROL : out std_logic;
      FSL13_M_FULL : in std_logic;
      FSL14_S_CLK : out std_logic;
      FSL14_S_READ : out std_logic;
      FSL14_S_DATA : in std_logic_vector(0 to 31);
      FSL14_S_CONTROL : in std_logic;
      FSL14_S_EXISTS : in std_logic;
      FSL14_M_CLK : out std_logic;
      FSL14_M_WRITE : out std_logic;
      FSL14_M_DATA : out std_logic_vector(0 to 31);
      FSL14_M_CONTROL : out std_logic;
      FSL14_M_FULL : in std_logic;
      FSL15_S_CLK : out std_logic;
      FSL15_S_READ : out std_logic;
      FSL15_S_DATA : in std_logic_vector(0 to 31);
      FSL15_S_CONTROL : in std_logic;
      FSL15_S_EXISTS : in std_logic;
      FSL15_M_CLK : out std_logic;
      FSL15_M_WRITE : out std_logic;
      FSL15_M_DATA : out std_logic_vector(0 to 31);
      FSL15_M_CONTROL : out std_logic;
      FSL15_M_FULL : in std_logic;
      ICACHE_FSL_IN_CLK : out std_logic;
      ICACHE_FSL_IN_READ : out std_logic;
      ICACHE_FSL_IN_DATA : in std_logic_vector(0 to 31);
      ICACHE_FSL_IN_CONTROL : in std_logic;
      ICACHE_FSL_IN_EXISTS : in std_logic;
      ICACHE_FSL_OUT_CLK : out std_logic;
      ICACHE_FSL_OUT_WRITE : out std_logic;
      ICACHE_FSL_OUT_DATA : out std_logic_vector(0 to 31);
      ICACHE_FSL_OUT_CONTROL : out std_logic;
      ICACHE_FSL_OUT_FULL : in std_logic;
      DCACHE_FSL_IN_CLK : out std_logic;
      DCACHE_FSL_IN_READ : out std_logic;
      DCACHE_FSL_IN_DATA : in std_logic_vector(0 to 31);
      DCACHE_FSL_IN_CONTROL : in std_logic;
      DCACHE_FSL_IN_EXISTS : in std_logic;
      DCACHE_FSL_OUT_CLK : out std_logic;
      DCACHE_FSL_OUT_WRITE : out std_logic;
      DCACHE_FSL_OUT_DATA : out std_logic_vector(0 to 31);
      DCACHE_FSL_OUT_CONTROL : out std_logic;
      DCACHE_FSL_OUT_FULL : in std_logic
    );
  end component;

  component mb_ilmb_mb5_wrapper is
    port (
      LMB_Clk : in std_logic;
      SYS_Rst : in std_logic;
      LMB_Rst : out std_logic;
      M_ABus : in std_logic_vector(0 to 31);
      M_ReadStrobe : in std_logic;
      M_WriteStrobe : in std_logic;
      M_AddrStrobe : in std_logic;
      M_DBus : in std_logic_vector(0 to 31);
      M_BE : in std_logic_vector(0 to 3);
      Sl_DBus : in std_logic_vector(0 to 31);
      Sl_Ready : in std_logic_vector(0 to 0);
      LMB_ABus : out std_logic_vector(0 to 31);
      LMB_ReadStrobe : out std_logic;
      LMB_WriteStrobe : out std_logic;
      LMB_AddrStrobe : out std_logic;
      LMB_ReadDBus : out std_logic_vector(0 to 31);
      LMB_WriteDBus : out std_logic_vector(0 to 31);
      LMB_Ready : out std_logic;
      LMB_BE : out std_logic_vector(0 to 3)
    );
  end component;

  component mb_dlmb_mb5_wrapper is
    port (
      LMB_Clk : in std_logic;
      SYS_Rst : in std_logic;
      LMB_Rst : out std_logic;
      M_ABus : in std_logic_vector(0 to 31);
      M_ReadStrobe : in std_logic;
      M_WriteStrobe : in std_logic;
      M_AddrStrobe : in std_logic;
      M_DBus : in std_logic_vector(0 to 31);
      M_BE : in std_logic_vector(0 to 3);
      Sl_DBus : in std_logic_vector(0 to 31);
      Sl_Ready : in std_logic_vector(0 to 0);
      LMB_ABus : out std_logic_vector(0 to 31);
      LMB_ReadStrobe : out std_logic;
      LMB_WriteStrobe : out std_logic;
      LMB_AddrStrobe : out std_logic;
      LMB_ReadDBus : out std_logic_vector(0 to 31);
      LMB_WriteDBus : out std_logic_vector(0 to 31);
      LMB_Ready : out std_logic;
      LMB_BE : out std_logic_vector(0 to 3)
    );
  end component;

  component ilmb_cntlr_mb5_wrapper is
    port (
      LMB_Clk : in std_logic;
      LMB_Rst : in std_logic;
      LMB_ABus : in std_logic_vector(0 to 31);
      LMB_WriteDBus : in std_logic_vector(0 to 31);
      LMB_AddrStrobe : in std_logic;
      LMB_ReadStrobe : in std_logic;
      LMB_WriteStrobe : in std_logic;
      LMB_BE : in std_logic_vector(0 to 3);
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_Ready : out std_logic;
      BRAM_Rst_A : out std_logic;
      BRAM_Clk_A : out std_logic;
      BRAM_EN_A : out std_logic;
      BRAM_WEN_A : out std_logic_vector(0 to 3);
      BRAM_Addr_A : out std_logic_vector(0 to 31);
      BRAM_Din_A : in std_logic_vector(0 to 31);
      BRAM_Dout_A : out std_logic_vector(0 to 31)
    );
  end component;

  component dlmb_cntlr_mb5_wrapper is
    port (
      LMB_Clk : in std_logic;
      LMB_Rst : in std_logic;
      LMB_ABus : in std_logic_vector(0 to 31);
      LMB_WriteDBus : in std_logic_vector(0 to 31);
      LMB_AddrStrobe : in std_logic;
      LMB_ReadStrobe : in std_logic;
      LMB_WriteStrobe : in std_logic;
      LMB_BE : in std_logic_vector(0 to 3);
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_Ready : out std_logic;
      BRAM_Rst_A : out std_logic;
      BRAM_Clk_A : out std_logic;
      BRAM_EN_A : out std_logic;
      BRAM_WEN_A : out std_logic_vector(0 to 3);
      BRAM_Addr_A : out std_logic_vector(0 to 31);
      BRAM_Din_A : in std_logic_vector(0 to 31);
      BRAM_Dout_A : out std_logic_vector(0 to 31)
    );
  end component;

  component mb5_bram_wrapper is
    port (
      BRAM_Rst_A : in std_logic;
      BRAM_Clk_A : in std_logic;
      BRAM_EN_A : in std_logic;
      BRAM_WEN_A : in std_logic_vector(0 to 3);
      BRAM_Addr_A : in std_logic_vector(0 to 31);
      BRAM_Din_A : out std_logic_vector(0 to 31);
      BRAM_Dout_A : in std_logic_vector(0 to 31);
      BRAM_Rst_B : in std_logic;
      BRAM_Clk_B : in std_logic;
      BRAM_EN_B : in std_logic;
      BRAM_WEN_B : in std_logic_vector(0 to 3);
      BRAM_Addr_B : in std_logic_vector(0 to 31);
      BRAM_Din_B : out std_logic_vector(0 to 31);
      BRAM_Dout_B : in std_logic_vector(0 to 31)
    );
  end component;

  component mb5_plb_bus_wrapper is
    port (
      PLB_Clk : in std_logic;
      SYS_Rst : in std_logic;
      PLB_Rst : out std_logic;
      SPLB_Rst : out std_logic_vector(0 to 0);
      MPLB_Rst : out std_logic_vector(0 to 1);
      PLB_dcrAck : out std_logic;
      PLB_dcrDBus : out std_logic_vector(0 to 31);
      DCR_ABus : in std_logic_vector(0 to 9);
      DCR_DBus : in std_logic_vector(0 to 31);
      DCR_Read : in std_logic;
      DCR_Write : in std_logic;
      M_ABus : in std_logic_vector(0 to 63);
      M_UABus : in std_logic_vector(0 to 63);
      M_BE : in std_logic_vector(0 to 7);
      M_RNW : in std_logic_vector(0 to 1);
      M_abort : in std_logic_vector(0 to 1);
      M_busLock : in std_logic_vector(0 to 1);
      M_TAttribute : in std_logic_vector(0 to 31);
      M_lockErr : in std_logic_vector(0 to 1);
      M_MSize : in std_logic_vector(0 to 3);
      M_priority : in std_logic_vector(0 to 3);
      M_rdBurst : in std_logic_vector(0 to 1);
      M_request : in std_logic_vector(0 to 1);
      M_size : in std_logic_vector(0 to 7);
      M_type : in std_logic_vector(0 to 5);
      M_wrBurst : in std_logic_vector(0 to 1);
      M_wrDBus : in std_logic_vector(0 to 63);
      Sl_addrAck : in std_logic_vector(0 to 0);
      Sl_MRdErr : in std_logic_vector(0 to 1);
      Sl_MWrErr : in std_logic_vector(0 to 1);
      Sl_MBusy : in std_logic_vector(0 to 1);
      Sl_rdBTerm : in std_logic_vector(0 to 0);
      Sl_rdComp : in std_logic_vector(0 to 0);
      Sl_rdDAck : in std_logic_vector(0 to 0);
      Sl_rdDBus : in std_logic_vector(0 to 31);
      Sl_rdWdAddr : in std_logic_vector(0 to 3);
      Sl_rearbitrate : in std_logic_vector(0 to 0);
      Sl_SSize : in std_logic_vector(0 to 1);
      Sl_wait : in std_logic_vector(0 to 0);
      Sl_wrBTerm : in std_logic_vector(0 to 0);
      Sl_wrComp : in std_logic_vector(0 to 0);
      Sl_wrDAck : in std_logic_vector(0 to 0);
      Sl_MIRQ : in std_logic_vector(0 to 1);
      PLB_MIRQ : out std_logic_vector(0 to 1);
      PLB_ABus : out std_logic_vector(0 to 31);
      PLB_UABus : out std_logic_vector(0 to 31);
      PLB_BE : out std_logic_vector(0 to 3);
      PLB_MAddrAck : out std_logic_vector(0 to 1);
      PLB_MTimeout : out std_logic_vector(0 to 1);
      PLB_MBusy : out std_logic_vector(0 to 1);
      PLB_MRdErr : out std_logic_vector(0 to 1);
      PLB_MWrErr : out std_logic_vector(0 to 1);
      PLB_MRdBTerm : out std_logic_vector(0 to 1);
      PLB_MRdDAck : out std_logic_vector(0 to 1);
      PLB_MRdDBus : out std_logic_vector(0 to 63);
      PLB_MRdWdAddr : out std_logic_vector(0 to 7);
      PLB_MRearbitrate : out std_logic_vector(0 to 1);
      PLB_MWrBTerm : out std_logic_vector(0 to 1);
      PLB_MWrDAck : out std_logic_vector(0 to 1);
      PLB_MSSize : out std_logic_vector(0 to 3);
      PLB_PAValid : out std_logic;
      PLB_RNW : out std_logic;
      PLB_SAValid : out std_logic;
      PLB_abort : out std_logic;
      PLB_busLock : out std_logic;
      PLB_TAttribute : out std_logic_vector(0 to 15);
      PLB_lockErr : out std_logic;
      PLB_masterID : out std_logic_vector(0 to 0);
      PLB_MSize : out std_logic_vector(0 to 1);
      PLB_rdPendPri : out std_logic_vector(0 to 1);
      PLB_wrPendPri : out std_logic_vector(0 to 1);
      PLB_rdPendReq : out std_logic;
      PLB_wrPendReq : out std_logic;
      PLB_rdBurst : out std_logic;
      PLB_rdPrim : out std_logic_vector(0 to 0);
      PLB_reqPri : out std_logic_vector(0 to 1);
      PLB_size : out std_logic_vector(0 to 3);
      PLB_type : out std_logic_vector(0 to 2);
      PLB_wrBurst : out std_logic;
      PLB_wrDBus : out std_logic_vector(0 to 31);
      PLB_wrPrim : out std_logic_vector(0 to 0);
      PLB_SaddrAck : out std_logic;
      PLB_SMRdErr : out std_logic_vector(0 to 1);
      PLB_SMWrErr : out std_logic_vector(0 to 1);
      PLB_SMBusy : out std_logic_vector(0 to 1);
      PLB_SrdBTerm : out std_logic;
      PLB_SrdComp : out std_logic;
      PLB_SrdDAck : out std_logic;
      PLB_SrdDBus : out std_logic_vector(0 to 31);
      PLB_SrdWdAddr : out std_logic_vector(0 to 3);
      PLB_Srearbitrate : out std_logic;
      PLB_Sssize : out std_logic_vector(0 to 1);
      PLB_Swait : out std_logic;
      PLB_SwrBTerm : out std_logic;
      PLB_SwrComp : out std_logic;
      PLB_SwrDAck : out std_logic;
      Bus_Error_Det : out std_logic
    );
  end component;

  component mb5_plb_bridge_wrapper is
    port (
      SPLB_Clk : in std_logic;
      SPLB_Rst : in std_logic;
      IP2INTC_Irpt : out std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_UABus : in std_logic_vector(0 to 31);
      PLB_PAValid : in std_logic;
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 0);
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to 3);
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_lockErr : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to 31);
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_wrPendReq : in std_logic;
      PLB_rdPendReq : in std_logic;
      PLB_wrPendPri : in std_logic_vector(0 to 1);
      PLB_rdPendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_TAttribute : in std_logic_vector(0 to 15);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_wrBTerm : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 31);
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_rdBTerm : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 1);
      Sl_MWrErr : out std_logic_vector(0 to 1);
      Sl_MRdErr : out std_logic_vector(0 to 1);
      Sl_MIRQ : out std_logic_vector(0 to 1);
      MPLB_Clk : in std_logic;
      MPLB_Rst : in std_logic;
      M_request : out std_logic;
      M_priority : out std_logic_vector(0 to 1);
      M_busLock : out std_logic;
      M_RNW : out std_logic;
      M_BE : out std_logic_vector(0 to 15);
      M_MSize : out std_logic_vector(0 to 1);
      M_size : out std_logic_vector(0 to 3);
      M_type : out std_logic_vector(0 to 2);
      M_ABus : out std_logic_vector(0 to 31);
      M_wrBurst : out std_logic;
      M_rdBurst : out std_logic;
      M_wrDBus : out std_logic_vector(0 to 127);
      PLB_MAddrAck : in std_logic;
      PLB_MSSize : in std_logic_vector(0 to 1);
      PLB_MRearbitrate : in std_logic;
      PLB_MTimeout : in std_logic;
      PLB_MRdErr : in std_logic;
      PLB_MWrErr : in std_logic;
      PLB_MRdDBus : in std_logic_vector(0 to 127);
      PLB_MRdDAck : in std_logic;
      PLB_MRdBTerm : in std_logic;
      PLB_MWrDAck : in std_logic;
      PLB_MWrBTerm : in std_logic;
      M_TAttribute : out std_logic_vector(0 to 15);
      M_lockErr : out std_logic;
      M_abort : out std_logic;
      M_UABus : out std_logic_vector(0 to 31);
      PLB_MBusy : in std_logic;
      PLB_MIRQ : in std_logic;
      PLB_MRdWdAddr : in std_logic_vector(0 to 3)
    );
  end component;

  component IOBUF is
    port (
      I : in std_logic;
      IO : inout std_logic;
      O : out std_logic;
      T : in std_logic
    );
  end component;

  -- Internal signals

  signal DDR2_SDRAM_MPMC_Clk_Div2 : std_logic;
  signal DDR2_SDRAM_mpmc_clk_90_s : std_logic;
  signal Dcm_all_locked : std_logic;
  signal Debug_SYS_Rst : std_logic;
  signal Ext_BRK : std_logic;
  signal Ext_NM_BRK : std_logic;
  signal ZBT_CLK_FB_s : std_logic;
  signal ZBT_CLK_OUT_s : std_logic;
  signal clk_200mhz_s : std_logic;
  signal core_sch2tm_addrb : std_logic_vector(0 to 8);
  signal core_sch2tm_busy : std_logic;
  signal core_sch2tm_data : std_logic_vector(0 to 7);
  signal core_sch2tm_dib : std_logic_vector(0 to 31);
  signal core_sch2tm_enb : std_logic;
  signal core_sch2tm_next_id : std_logic_vector(0 to 7);
  signal core_sch2tm_next_id_valid : std_logic;
  signal core_sch2tm_web : std_logic;
  signal core_tm2sch_cpu_thread_id : std_logic_vector(0 to 7);
  signal core_tm2sch_data : std_logic_vector(0 to 7);
  signal core_tm2sch_dob : std_logic_vector(0 to 31);
  signal core_tm2sch_opcode : std_logic_vector(0 to 5);
  signal core_tm2sch_request : std_logic;
  signal dcm_clk_s : std_logic;
  signal dlmb_cntlr_BRAM_PORT1_BRAM_Addr : std_logic_vector(0 to 31);
  signal dlmb_cntlr_BRAM_PORT1_BRAM_Clk : std_logic;
  signal dlmb_cntlr_BRAM_PORT1_BRAM_Din : std_logic_vector(0 to 31);
  signal dlmb_cntlr_BRAM_PORT1_BRAM_Dout : std_logic_vector(0 to 31);
  signal dlmb_cntlr_BRAM_PORT1_BRAM_EN : std_logic;
  signal dlmb_cntlr_BRAM_PORT1_BRAM_Rst : std_logic;
  signal dlmb_cntlr_BRAM_PORT1_BRAM_WEN : std_logic_vector(0 to 3);
  signal dlmb_cntlr_BRAM_PORT2_BRAM_Addr : std_logic_vector(0 to 31);
  signal dlmb_cntlr_BRAM_PORT2_BRAM_Clk : std_logic;
  signal dlmb_cntlr_BRAM_PORT2_BRAM_Din : std_logic_vector(0 to 31);
  signal dlmb_cntlr_BRAM_PORT2_BRAM_Dout : std_logic_vector(0 to 31);
  signal dlmb_cntlr_BRAM_PORT2_BRAM_EN : std_logic;
  signal dlmb_cntlr_BRAM_PORT2_BRAM_Rst : std_logic;
  signal dlmb_cntlr_BRAM_PORT2_BRAM_WEN : std_logic_vector(0 to 3);
  signal dlmb_cntlr_BRAM_PORT_BRAM_Addr : std_logic_vector(0 to 31);
  signal dlmb_cntlr_BRAM_PORT_BRAM_Clk : std_logic;
  signal dlmb_cntlr_BRAM_PORT_BRAM_Din : std_logic_vector(0 to 31);
  signal dlmb_cntlr_BRAM_PORT_BRAM_Dout : std_logic_vector(0 to 31);
  signal dlmb_cntlr_BRAM_PORT_BRAM_EN : std_logic;
  signal dlmb_cntlr_BRAM_PORT_BRAM_Rst : std_logic;
  signal dlmb_cntlr_BRAM_PORT_BRAM_WEN : std_logic_vector(0 to 3);
  signal dlmb_cntlr_BRAM_PORT_mb3_BRAM_Addr : std_logic_vector(0 to 31);
  signal dlmb_cntlr_BRAM_PORT_mb3_BRAM_Clk : std_logic;
  signal dlmb_cntlr_BRAM_PORT_mb3_BRAM_Din : std_logic_vector(0 to 31);
  signal dlmb_cntlr_BRAM_PORT_mb3_BRAM_Dout : std_logic_vector(0 to 31);
  signal dlmb_cntlr_BRAM_PORT_mb3_BRAM_EN : std_logic;
  signal dlmb_cntlr_BRAM_PORT_mb3_BRAM_Rst : std_logic;
  signal dlmb_cntlr_BRAM_PORT_mb3_BRAM_WEN : std_logic_vector(0 to 3);
  signal dlmb_cntlr_BRAM_PORT_mb4_BRAM_Addr : std_logic_vector(0 to 31);
  signal dlmb_cntlr_BRAM_PORT_mb4_BRAM_Clk : std_logic;
  signal dlmb_cntlr_BRAM_PORT_mb4_BRAM_Din : std_logic_vector(0 to 31);
  signal dlmb_cntlr_BRAM_PORT_mb4_BRAM_Dout : std_logic_vector(0 to 31);
  signal dlmb_cntlr_BRAM_PORT_mb4_BRAM_EN : std_logic;
  signal dlmb_cntlr_BRAM_PORT_mb4_BRAM_Rst : std_logic;
  signal dlmb_cntlr_BRAM_PORT_mb4_BRAM_WEN : std_logic_vector(0 to 3);
  signal dlmb_cntlr_BRAM_PORT_mb5_BRAM_Addr : std_logic_vector(0 to 31);
  signal dlmb_cntlr_BRAM_PORT_mb5_BRAM_Clk : std_logic;
  signal dlmb_cntlr_BRAM_PORT_mb5_BRAM_Din : std_logic_vector(0 to 31);
  signal dlmb_cntlr_BRAM_PORT_mb5_BRAM_Dout : std_logic_vector(0 to 31);
  signal dlmb_cntlr_BRAM_PORT_mb5_BRAM_EN : std_logic;
  signal dlmb_cntlr_BRAM_PORT_mb5_BRAM_Rst : std_logic;
  signal dlmb_cntlr_BRAM_PORT_mb5_BRAM_WEN : std_logic_vector(0 to 3);
  signal fpga_0_DDR2_SDRAM_DDR2_Addr : std_logic_vector(12 downto 0);
  signal fpga_0_DDR2_SDRAM_DDR2_BankAddr : std_logic_vector(1 downto 0);
  signal fpga_0_DDR2_SDRAM_DDR2_CAS_n : std_logic;
  signal fpga_0_DDR2_SDRAM_DDR2_CE : std_logic_vector(0 to 0);
  signal fpga_0_DDR2_SDRAM_DDR2_CE_split : std_logic_vector(0 to 1);
  signal fpga_0_DDR2_SDRAM_DDR2_CS_n : std_logic_vector(0 to 0);
  signal fpga_0_DDR2_SDRAM_DDR2_CS_n_split : std_logic_vector(0 to 1);
  signal fpga_0_DDR2_SDRAM_DDR2_Clk : std_logic_vector(1 downto 0);
  signal fpga_0_DDR2_SDRAM_DDR2_Clk_n : std_logic_vector(1 downto 0);
  signal fpga_0_DDR2_SDRAM_DDR2_DM : std_logic_vector(7 downto 0);
  signal fpga_0_DDR2_SDRAM_DDR2_ODT : std_logic_vector(1 downto 0);
  signal fpga_0_DDR2_SDRAM_DDR2_RAS_n : std_logic;
  signal fpga_0_DDR2_SDRAM_DDR2_WE_n : std_logic;
  signal fpga_0_LEDs_8Bit_GPIO_IO_I : std_logic_vector(0 to 7);
  signal fpga_0_LEDs_8Bit_GPIO_IO_O : std_logic_vector(0 to 7);
  signal fpga_0_LEDs_8Bit_GPIO_IO_T : std_logic_vector(0 to 7);
  signal fpga_0_RS232_Uart_1_RX : std_logic;
  signal fpga_0_RS232_Uart_1_TX : std_logic;
  signal fpga_0_SRAM_Mem_A : std_logic_vector(7 to 30);
  signal fpga_0_SRAM_Mem_ADV_LDN : std_logic;
  signal fpga_0_SRAM_Mem_A_split : std_logic_vector(0 to 31);
  signal fpga_0_SRAM_Mem_BEN : std_logic_vector(0 to 3);
  signal fpga_0_SRAM_Mem_CEN : std_logic_vector(0 to 0);
  signal fpga_0_SRAM_Mem_DQ_I : std_logic_vector(0 to 31);
  signal fpga_0_SRAM_Mem_DQ_O : std_logic_vector(0 to 31);
  signal fpga_0_SRAM_Mem_DQ_T : std_logic_vector(0 to 31);
  signal fpga_0_SRAM_Mem_OEN : std_logic_vector(0 to 0);
  signal fpga_0_SRAM_Mem_WEN : std_logic;
  signal hthread_resp_condvar : std_logic;
  signal hthread_resp_sched : std_logic;
  signal hthread_resp_synch : std_logic;
  signal hthread_rst_condvar : std_logic;
  signal hthread_rst_sched : std_logic;
  signal hthread_rst_synch : std_logic;
  signal ilmb_cntlr_BRAM_PORT1_BRAM_Addr : std_logic_vector(0 to 31);
  signal ilmb_cntlr_BRAM_PORT1_BRAM_Clk : std_logic;
  signal ilmb_cntlr_BRAM_PORT1_BRAM_Din : std_logic_vector(0 to 31);
  signal ilmb_cntlr_BRAM_PORT1_BRAM_Dout : std_logic_vector(0 to 31);
  signal ilmb_cntlr_BRAM_PORT1_BRAM_EN : std_logic;
  signal ilmb_cntlr_BRAM_PORT1_BRAM_Rst : std_logic;
  signal ilmb_cntlr_BRAM_PORT1_BRAM_WEN : std_logic_vector(0 to 3);
  signal ilmb_cntlr_BRAM_PORT2_BRAM_Addr : std_logic_vector(0 to 31);
  signal ilmb_cntlr_BRAM_PORT2_BRAM_Clk : std_logic;
  signal ilmb_cntlr_BRAM_PORT2_BRAM_Din : std_logic_vector(0 to 31);
  signal ilmb_cntlr_BRAM_PORT2_BRAM_Dout : std_logic_vector(0 to 31);
  signal ilmb_cntlr_BRAM_PORT2_BRAM_EN : std_logic;
  signal ilmb_cntlr_BRAM_PORT2_BRAM_Rst : std_logic;
  signal ilmb_cntlr_BRAM_PORT2_BRAM_WEN : std_logic_vector(0 to 3);
  signal ilmb_cntlr_BRAM_PORT_BRAM_Addr : std_logic_vector(0 to 31);
  signal ilmb_cntlr_BRAM_PORT_BRAM_Clk : std_logic;
  signal ilmb_cntlr_BRAM_PORT_BRAM_Din : std_logic_vector(0 to 31);
  signal ilmb_cntlr_BRAM_PORT_BRAM_Dout : std_logic_vector(0 to 31);
  signal ilmb_cntlr_BRAM_PORT_BRAM_EN : std_logic;
  signal ilmb_cntlr_BRAM_PORT_BRAM_Rst : std_logic;
  signal ilmb_cntlr_BRAM_PORT_BRAM_WEN : std_logic_vector(0 to 3);
  signal ilmb_cntlr_BRAM_PORT_mb3_BRAM_Addr : std_logic_vector(0 to 31);
  signal ilmb_cntlr_BRAM_PORT_mb3_BRAM_Clk : std_logic;
  signal ilmb_cntlr_BRAM_PORT_mb3_BRAM_Din : std_logic_vector(0 to 31);
  signal ilmb_cntlr_BRAM_PORT_mb3_BRAM_Dout : std_logic_vector(0 to 31);
  signal ilmb_cntlr_BRAM_PORT_mb3_BRAM_EN : std_logic;
  signal ilmb_cntlr_BRAM_PORT_mb3_BRAM_Rst : std_logic;
  signal ilmb_cntlr_BRAM_PORT_mb3_BRAM_WEN : std_logic_vector(0 to 3);
  signal ilmb_cntlr_BRAM_PORT_mb4_BRAM_Addr : std_logic_vector(0 to 31);
  signal ilmb_cntlr_BRAM_PORT_mb4_BRAM_Clk : std_logic;
  signal ilmb_cntlr_BRAM_PORT_mb4_BRAM_Din : std_logic_vector(0 to 31);
  signal ilmb_cntlr_BRAM_PORT_mb4_BRAM_Dout : std_logic_vector(0 to 31);
  signal ilmb_cntlr_BRAM_PORT_mb4_BRAM_EN : std_logic;
  signal ilmb_cntlr_BRAM_PORT_mb4_BRAM_Rst : std_logic;
  signal ilmb_cntlr_BRAM_PORT_mb4_BRAM_WEN : std_logic_vector(0 to 3);
  signal ilmb_cntlr_BRAM_PORT_mb5_BRAM_Addr : std_logic_vector(0 to 31);
  signal ilmb_cntlr_BRAM_PORT_mb5_BRAM_Clk : std_logic;
  signal ilmb_cntlr_BRAM_PORT_mb5_BRAM_Din : std_logic_vector(0 to 31);
  signal ilmb_cntlr_BRAM_PORT_mb5_BRAM_Dout : std_logic_vector(0 to 31);
  signal ilmb_cntlr_BRAM_PORT_mb5_BRAM_EN : std_logic;
  signal ilmb_cntlr_BRAM_PORT_mb5_BRAM_Rst : std_logic;
  signal ilmb_cntlr_BRAM_PORT_mb5_BRAM_WEN : std_logic_vector(0 to 3);
  signal jtagppc_cntlr_0_0_C405JTGTDO : std_logic;
  signal jtagppc_cntlr_0_0_C405JTGTDOEN : std_logic;
  signal jtagppc_cntlr_0_0_JTGC405TCK : std_logic;
  signal jtagppc_cntlr_0_0_JTGC405TDI : std_logic;
  signal jtagppc_cntlr_0_0_JTGC405TMS : std_logic;
  signal jtagppc_cntlr_0_0_JTGC405TRSTNEG : std_logic;
  signal mb0_plb_bus_M_ABort : std_logic_vector(0 to 1);
  signal mb0_plb_bus_M_ABus : std_logic_vector(0 to 63);
  signal mb0_plb_bus_M_BE : std_logic_vector(0 to 7);
  signal mb0_plb_bus_M_MSize : std_logic_vector(0 to 3);
  signal mb0_plb_bus_M_RNW : std_logic_vector(0 to 1);
  signal mb0_plb_bus_M_TAttribute : std_logic_vector(0 to 31);
  signal mb0_plb_bus_M_UABus : std_logic_vector(0 to 63);
  signal mb0_plb_bus_M_busLock : std_logic_vector(0 to 1);
  signal mb0_plb_bus_M_lockErr : std_logic_vector(0 to 1);
  signal mb0_plb_bus_M_priority : std_logic_vector(0 to 3);
  signal mb0_plb_bus_M_rdBurst : std_logic_vector(0 to 1);
  signal mb0_plb_bus_M_request : std_logic_vector(0 to 1);
  signal mb0_plb_bus_M_size : std_logic_vector(0 to 7);
  signal mb0_plb_bus_M_type : std_logic_vector(0 to 5);
  signal mb0_plb_bus_M_wrBurst : std_logic_vector(0 to 1);
  signal mb0_plb_bus_M_wrDBus : std_logic_vector(0 to 63);
  signal mb0_plb_bus_PLB_ABus : std_logic_vector(0 to 31);
  signal mb0_plb_bus_PLB_BE : std_logic_vector(0 to 3);
  signal mb0_plb_bus_PLB_MAddrAck : std_logic_vector(0 to 1);
  signal mb0_plb_bus_PLB_MBusy : std_logic_vector(0 to 1);
  signal mb0_plb_bus_PLB_MIRQ : std_logic_vector(0 to 1);
  signal mb0_plb_bus_PLB_MRdBTerm : std_logic_vector(0 to 1);
  signal mb0_plb_bus_PLB_MRdDAck : std_logic_vector(0 to 1);
  signal mb0_plb_bus_PLB_MRdDBus : std_logic_vector(0 to 63);
  signal mb0_plb_bus_PLB_MRdErr : std_logic_vector(0 to 1);
  signal mb0_plb_bus_PLB_MRdWdAddr : std_logic_vector(0 to 7);
  signal mb0_plb_bus_PLB_MRearbitrate : std_logic_vector(0 to 1);
  signal mb0_plb_bus_PLB_MSSize : std_logic_vector(0 to 3);
  signal mb0_plb_bus_PLB_MSize : std_logic_vector(0 to 1);
  signal mb0_plb_bus_PLB_MTimeout : std_logic_vector(0 to 1);
  signal mb0_plb_bus_PLB_MWrBTerm : std_logic_vector(0 to 1);
  signal mb0_plb_bus_PLB_MWrDAck : std_logic_vector(0 to 1);
  signal mb0_plb_bus_PLB_MWrErr : std_logic_vector(0 to 1);
  signal mb0_plb_bus_PLB_PAValid : std_logic;
  signal mb0_plb_bus_PLB_RNW : std_logic;
  signal mb0_plb_bus_PLB_SAValid : std_logic;
  signal mb0_plb_bus_PLB_TAttribute : std_logic_vector(0 to 15);
  signal mb0_plb_bus_PLB_UABus : std_logic_vector(0 to 31);
  signal mb0_plb_bus_PLB_abort : std_logic;
  signal mb0_plb_bus_PLB_busLock : std_logic;
  signal mb0_plb_bus_PLB_lockErr : std_logic;
  signal mb0_plb_bus_PLB_masterID : std_logic_vector(0 to 0);
  signal mb0_plb_bus_PLB_rdBurst : std_logic;
  signal mb0_plb_bus_PLB_rdPendPri : std_logic_vector(0 to 1);
  signal mb0_plb_bus_PLB_rdPendReq : std_logic;
  signal mb0_plb_bus_PLB_rdPrim : std_logic_vector(0 to 0);
  signal mb0_plb_bus_PLB_reqPri : std_logic_vector(0 to 1);
  signal mb0_plb_bus_PLB_size : std_logic_vector(0 to 3);
  signal mb0_plb_bus_PLB_type : std_logic_vector(0 to 2);
  signal mb0_plb_bus_PLB_wrBurst : std_logic;
  signal mb0_plb_bus_PLB_wrDBus : std_logic_vector(0 to 31);
  signal mb0_plb_bus_PLB_wrPendPri : std_logic_vector(0 to 1);
  signal mb0_plb_bus_PLB_wrPendReq : std_logic;
  signal mb0_plb_bus_PLB_wrPrim : std_logic_vector(0 to 0);
  signal mb0_plb_bus_SPLB_Rst : std_logic_vector(0 to 0);
  signal mb0_plb_bus_Sl_MBusy : std_logic_vector(0 to 1);
  signal mb0_plb_bus_Sl_MIRQ : std_logic_vector(0 to 1);
  signal mb0_plb_bus_Sl_MRdErr : std_logic_vector(0 to 1);
  signal mb0_plb_bus_Sl_MWrErr : std_logic_vector(0 to 1);
  signal mb0_plb_bus_Sl_SSize : std_logic_vector(0 to 1);
  signal mb0_plb_bus_Sl_addrAck : std_logic_vector(0 to 0);
  signal mb0_plb_bus_Sl_rdBTerm : std_logic_vector(0 to 0);
  signal mb0_plb_bus_Sl_rdComp : std_logic_vector(0 to 0);
  signal mb0_plb_bus_Sl_rdDAck : std_logic_vector(0 to 0);
  signal mb0_plb_bus_Sl_rdDBus : std_logic_vector(0 to 31);
  signal mb0_plb_bus_Sl_rdWdAddr : std_logic_vector(0 to 3);
  signal mb0_plb_bus_Sl_rearbitrate : std_logic_vector(0 to 0);
  signal mb0_plb_bus_Sl_wait : std_logic_vector(0 to 0);
  signal mb0_plb_bus_Sl_wrBTerm : std_logic_vector(0 to 0);
  signal mb0_plb_bus_Sl_wrComp : std_logic_vector(0 to 0);
  signal mb0_plb_bus_Sl_wrDAck : std_logic_vector(0 to 0);
  signal mb1_plb_bus_M_ABort : std_logic_vector(0 to 1);
  signal mb1_plb_bus_M_ABus : std_logic_vector(0 to 63);
  signal mb1_plb_bus_M_BE : std_logic_vector(0 to 7);
  signal mb1_plb_bus_M_MSize : std_logic_vector(0 to 3);
  signal mb1_plb_bus_M_RNW : std_logic_vector(0 to 1);
  signal mb1_plb_bus_M_TAttribute : std_logic_vector(0 to 31);
  signal mb1_plb_bus_M_UABus : std_logic_vector(0 to 63);
  signal mb1_plb_bus_M_busLock : std_logic_vector(0 to 1);
  signal mb1_plb_bus_M_lockErr : std_logic_vector(0 to 1);
  signal mb1_plb_bus_M_priority : std_logic_vector(0 to 3);
  signal mb1_plb_bus_M_rdBurst : std_logic_vector(0 to 1);
  signal mb1_plb_bus_M_request : std_logic_vector(0 to 1);
  signal mb1_plb_bus_M_size : std_logic_vector(0 to 7);
  signal mb1_plb_bus_M_type : std_logic_vector(0 to 5);
  signal mb1_plb_bus_M_wrBurst : std_logic_vector(0 to 1);
  signal mb1_plb_bus_M_wrDBus : std_logic_vector(0 to 63);
  signal mb1_plb_bus_PLB_ABus : std_logic_vector(0 to 31);
  signal mb1_plb_bus_PLB_BE : std_logic_vector(0 to 3);
  signal mb1_plb_bus_PLB_MAddrAck : std_logic_vector(0 to 1);
  signal mb1_plb_bus_PLB_MBusy : std_logic_vector(0 to 1);
  signal mb1_plb_bus_PLB_MIRQ : std_logic_vector(0 to 1);
  signal mb1_plb_bus_PLB_MRdBTerm : std_logic_vector(0 to 1);
  signal mb1_plb_bus_PLB_MRdDAck : std_logic_vector(0 to 1);
  signal mb1_plb_bus_PLB_MRdDBus : std_logic_vector(0 to 63);
  signal mb1_plb_bus_PLB_MRdErr : std_logic_vector(0 to 1);
  signal mb1_plb_bus_PLB_MRdWdAddr : std_logic_vector(0 to 7);
  signal mb1_plb_bus_PLB_MRearbitrate : std_logic_vector(0 to 1);
  signal mb1_plb_bus_PLB_MSSize : std_logic_vector(0 to 3);
  signal mb1_plb_bus_PLB_MSize : std_logic_vector(0 to 1);
  signal mb1_plb_bus_PLB_MTimeout : std_logic_vector(0 to 1);
  signal mb1_plb_bus_PLB_MWrBTerm : std_logic_vector(0 to 1);
  signal mb1_plb_bus_PLB_MWrDAck : std_logic_vector(0 to 1);
  signal mb1_plb_bus_PLB_MWrErr : std_logic_vector(0 to 1);
  signal mb1_plb_bus_PLB_PAValid : std_logic;
  signal mb1_plb_bus_PLB_RNW : std_logic;
  signal mb1_plb_bus_PLB_SAValid : std_logic;
  signal mb1_plb_bus_PLB_TAttribute : std_logic_vector(0 to 15);
  signal mb1_plb_bus_PLB_UABus : std_logic_vector(0 to 31);
  signal mb1_plb_bus_PLB_abort : std_logic;
  signal mb1_plb_bus_PLB_busLock : std_logic;
  signal mb1_plb_bus_PLB_lockErr : std_logic;
  signal mb1_plb_bus_PLB_masterID : std_logic_vector(0 to 0);
  signal mb1_plb_bus_PLB_rdBurst : std_logic;
  signal mb1_plb_bus_PLB_rdPendPri : std_logic_vector(0 to 1);
  signal mb1_plb_bus_PLB_rdPendReq : std_logic;
  signal mb1_plb_bus_PLB_rdPrim : std_logic_vector(0 to 0);
  signal mb1_plb_bus_PLB_reqPri : std_logic_vector(0 to 1);
  signal mb1_plb_bus_PLB_size : std_logic_vector(0 to 3);
  signal mb1_plb_bus_PLB_type : std_logic_vector(0 to 2);
  signal mb1_plb_bus_PLB_wrBurst : std_logic;
  signal mb1_plb_bus_PLB_wrDBus : std_logic_vector(0 to 31);
  signal mb1_plb_bus_PLB_wrPendPri : std_logic_vector(0 to 1);
  signal mb1_plb_bus_PLB_wrPendReq : std_logic;
  signal mb1_plb_bus_PLB_wrPrim : std_logic_vector(0 to 0);
  signal mb1_plb_bus_SPLB_Rst : std_logic_vector(0 to 0);
  signal mb1_plb_bus_Sl_MBusy : std_logic_vector(0 to 1);
  signal mb1_plb_bus_Sl_MIRQ : std_logic_vector(0 to 1);
  signal mb1_plb_bus_Sl_MRdErr : std_logic_vector(0 to 1);
  signal mb1_plb_bus_Sl_MWrErr : std_logic_vector(0 to 1);
  signal mb1_plb_bus_Sl_SSize : std_logic_vector(0 to 1);
  signal mb1_plb_bus_Sl_addrAck : std_logic_vector(0 to 0);
  signal mb1_plb_bus_Sl_rdBTerm : std_logic_vector(0 to 0);
  signal mb1_plb_bus_Sl_rdComp : std_logic_vector(0 to 0);
  signal mb1_plb_bus_Sl_rdDAck : std_logic_vector(0 to 0);
  signal mb1_plb_bus_Sl_rdDBus : std_logic_vector(0 to 31);
  signal mb1_plb_bus_Sl_rdWdAddr : std_logic_vector(0 to 3);
  signal mb1_plb_bus_Sl_rearbitrate : std_logic_vector(0 to 0);
  signal mb1_plb_bus_Sl_wait : std_logic_vector(0 to 0);
  signal mb1_plb_bus_Sl_wrBTerm : std_logic_vector(0 to 0);
  signal mb1_plb_bus_Sl_wrComp : std_logic_vector(0 to 0);
  signal mb1_plb_bus_Sl_wrDAck : std_logic_vector(0 to 0);
  signal mb2_plb_bus_M_ABort : std_logic_vector(0 to 1);
  signal mb2_plb_bus_M_ABus : std_logic_vector(0 to 63);
  signal mb2_plb_bus_M_BE : std_logic_vector(0 to 7);
  signal mb2_plb_bus_M_MSize : std_logic_vector(0 to 3);
  signal mb2_plb_bus_M_RNW : std_logic_vector(0 to 1);
  signal mb2_plb_bus_M_TAttribute : std_logic_vector(0 to 31);
  signal mb2_plb_bus_M_UABus : std_logic_vector(0 to 63);
  signal mb2_plb_bus_M_busLock : std_logic_vector(0 to 1);
  signal mb2_plb_bus_M_lockErr : std_logic_vector(0 to 1);
  signal mb2_plb_bus_M_priority : std_logic_vector(0 to 3);
  signal mb2_plb_bus_M_rdBurst : std_logic_vector(0 to 1);
  signal mb2_plb_bus_M_request : std_logic_vector(0 to 1);
  signal mb2_plb_bus_M_size : std_logic_vector(0 to 7);
  signal mb2_plb_bus_M_type : std_logic_vector(0 to 5);
  signal mb2_plb_bus_M_wrBurst : std_logic_vector(0 to 1);
  signal mb2_plb_bus_M_wrDBus : std_logic_vector(0 to 63);
  signal mb2_plb_bus_PLB_ABus : std_logic_vector(0 to 31);
  signal mb2_plb_bus_PLB_BE : std_logic_vector(0 to 3);
  signal mb2_plb_bus_PLB_MAddrAck : std_logic_vector(0 to 1);
  signal mb2_plb_bus_PLB_MBusy : std_logic_vector(0 to 1);
  signal mb2_plb_bus_PLB_MIRQ : std_logic_vector(0 to 1);
  signal mb2_plb_bus_PLB_MRdBTerm : std_logic_vector(0 to 1);
  signal mb2_plb_bus_PLB_MRdDAck : std_logic_vector(0 to 1);
  signal mb2_plb_bus_PLB_MRdDBus : std_logic_vector(0 to 63);
  signal mb2_plb_bus_PLB_MRdErr : std_logic_vector(0 to 1);
  signal mb2_plb_bus_PLB_MRdWdAddr : std_logic_vector(0 to 7);
  signal mb2_plb_bus_PLB_MRearbitrate : std_logic_vector(0 to 1);
  signal mb2_plb_bus_PLB_MSSize : std_logic_vector(0 to 3);
  signal mb2_plb_bus_PLB_MSize : std_logic_vector(0 to 1);
  signal mb2_plb_bus_PLB_MTimeout : std_logic_vector(0 to 1);
  signal mb2_plb_bus_PLB_MWrBTerm : std_logic_vector(0 to 1);
  signal mb2_plb_bus_PLB_MWrDAck : std_logic_vector(0 to 1);
  signal mb2_plb_bus_PLB_MWrErr : std_logic_vector(0 to 1);
  signal mb2_plb_bus_PLB_PAValid : std_logic;
  signal mb2_plb_bus_PLB_RNW : std_logic;
  signal mb2_plb_bus_PLB_SAValid : std_logic;
  signal mb2_plb_bus_PLB_TAttribute : std_logic_vector(0 to 15);
  signal mb2_plb_bus_PLB_UABus : std_logic_vector(0 to 31);
  signal mb2_plb_bus_PLB_abort : std_logic;
  signal mb2_plb_bus_PLB_busLock : std_logic;
  signal mb2_plb_bus_PLB_lockErr : std_logic;
  signal mb2_plb_bus_PLB_masterID : std_logic_vector(0 to 0);
  signal mb2_plb_bus_PLB_rdBurst : std_logic;
  signal mb2_plb_bus_PLB_rdPendPri : std_logic_vector(0 to 1);
  signal mb2_plb_bus_PLB_rdPendReq : std_logic;
  signal mb2_plb_bus_PLB_rdPrim : std_logic_vector(0 to 0);
  signal mb2_plb_bus_PLB_reqPri : std_logic_vector(0 to 1);
  signal mb2_plb_bus_PLB_size : std_logic_vector(0 to 3);
  signal mb2_plb_bus_PLB_type : std_logic_vector(0 to 2);
  signal mb2_plb_bus_PLB_wrBurst : std_logic;
  signal mb2_plb_bus_PLB_wrDBus : std_logic_vector(0 to 31);
  signal mb2_plb_bus_PLB_wrPendPri : std_logic_vector(0 to 1);
  signal mb2_plb_bus_PLB_wrPendReq : std_logic;
  signal mb2_plb_bus_PLB_wrPrim : std_logic_vector(0 to 0);
  signal mb2_plb_bus_SPLB_Rst : std_logic_vector(0 to 0);
  signal mb2_plb_bus_Sl_MBusy : std_logic_vector(0 to 1);
  signal mb2_plb_bus_Sl_MIRQ : std_logic_vector(0 to 1);
  signal mb2_plb_bus_Sl_MRdErr : std_logic_vector(0 to 1);
  signal mb2_plb_bus_Sl_MWrErr : std_logic_vector(0 to 1);
  signal mb2_plb_bus_Sl_SSize : std_logic_vector(0 to 1);
  signal mb2_plb_bus_Sl_addrAck : std_logic_vector(0 to 0);
  signal mb2_plb_bus_Sl_rdBTerm : std_logic_vector(0 to 0);
  signal mb2_plb_bus_Sl_rdComp : std_logic_vector(0 to 0);
  signal mb2_plb_bus_Sl_rdDAck : std_logic_vector(0 to 0);
  signal mb2_plb_bus_Sl_rdDBus : std_logic_vector(0 to 31);
  signal mb2_plb_bus_Sl_rdWdAddr : std_logic_vector(0 to 3);
  signal mb2_plb_bus_Sl_rearbitrate : std_logic_vector(0 to 0);
  signal mb2_plb_bus_Sl_wait : std_logic_vector(0 to 0);
  signal mb2_plb_bus_Sl_wrBTerm : std_logic_vector(0 to 0);
  signal mb2_plb_bus_Sl_wrComp : std_logic_vector(0 to 0);
  signal mb2_plb_bus_Sl_wrDAck : std_logic_vector(0 to 0);
  signal mb3_plb_bus_M_ABort : std_logic_vector(0 to 1);
  signal mb3_plb_bus_M_ABus : std_logic_vector(0 to 63);
  signal mb3_plb_bus_M_BE : std_logic_vector(0 to 7);
  signal mb3_plb_bus_M_MSize : std_logic_vector(0 to 3);
  signal mb3_plb_bus_M_RNW : std_logic_vector(0 to 1);
  signal mb3_plb_bus_M_TAttribute : std_logic_vector(0 to 31);
  signal mb3_plb_bus_M_UABus : std_logic_vector(0 to 63);
  signal mb3_plb_bus_M_busLock : std_logic_vector(0 to 1);
  signal mb3_plb_bus_M_lockErr : std_logic_vector(0 to 1);
  signal mb3_plb_bus_M_priority : std_logic_vector(0 to 3);
  signal mb3_plb_bus_M_rdBurst : std_logic_vector(0 to 1);
  signal mb3_plb_bus_M_request : std_logic_vector(0 to 1);
  signal mb3_plb_bus_M_size : std_logic_vector(0 to 7);
  signal mb3_plb_bus_M_type : std_logic_vector(0 to 5);
  signal mb3_plb_bus_M_wrBurst : std_logic_vector(0 to 1);
  signal mb3_plb_bus_M_wrDBus : std_logic_vector(0 to 63);
  signal mb3_plb_bus_PLB_ABus : std_logic_vector(0 to 31);
  signal mb3_plb_bus_PLB_BE : std_logic_vector(0 to 3);
  signal mb3_plb_bus_PLB_MAddrAck : std_logic_vector(0 to 1);
  signal mb3_plb_bus_PLB_MBusy : std_logic_vector(0 to 1);
  signal mb3_plb_bus_PLB_MIRQ : std_logic_vector(0 to 1);
  signal mb3_plb_bus_PLB_MRdBTerm : std_logic_vector(0 to 1);
  signal mb3_plb_bus_PLB_MRdDAck : std_logic_vector(0 to 1);
  signal mb3_plb_bus_PLB_MRdDBus : std_logic_vector(0 to 63);
  signal mb3_plb_bus_PLB_MRdErr : std_logic_vector(0 to 1);
  signal mb3_plb_bus_PLB_MRdWdAddr : std_logic_vector(0 to 7);
  signal mb3_plb_bus_PLB_MRearbitrate : std_logic_vector(0 to 1);
  signal mb3_plb_bus_PLB_MSSize : std_logic_vector(0 to 3);
  signal mb3_plb_bus_PLB_MSize : std_logic_vector(0 to 1);
  signal mb3_plb_bus_PLB_MTimeout : std_logic_vector(0 to 1);
  signal mb3_plb_bus_PLB_MWrBTerm : std_logic_vector(0 to 1);
  signal mb3_plb_bus_PLB_MWrDAck : std_logic_vector(0 to 1);
  signal mb3_plb_bus_PLB_MWrErr : std_logic_vector(0 to 1);
  signal mb3_plb_bus_PLB_PAValid : std_logic;
  signal mb3_plb_bus_PLB_RNW : std_logic;
  signal mb3_plb_bus_PLB_SAValid : std_logic;
  signal mb3_plb_bus_PLB_TAttribute : std_logic_vector(0 to 15);
  signal mb3_plb_bus_PLB_UABus : std_logic_vector(0 to 31);
  signal mb3_plb_bus_PLB_abort : std_logic;
  signal mb3_plb_bus_PLB_busLock : std_logic;
  signal mb3_plb_bus_PLB_lockErr : std_logic;
  signal mb3_plb_bus_PLB_masterID : std_logic_vector(0 to 0);
  signal mb3_plb_bus_PLB_rdBurst : std_logic;
  signal mb3_plb_bus_PLB_rdPendPri : std_logic_vector(0 to 1);
  signal mb3_plb_bus_PLB_rdPendReq : std_logic;
  signal mb3_plb_bus_PLB_rdPrim : std_logic_vector(0 to 0);
  signal mb3_plb_bus_PLB_reqPri : std_logic_vector(0 to 1);
  signal mb3_plb_bus_PLB_size : std_logic_vector(0 to 3);
  signal mb3_plb_bus_PLB_type : std_logic_vector(0 to 2);
  signal mb3_plb_bus_PLB_wrBurst : std_logic;
  signal mb3_plb_bus_PLB_wrDBus : std_logic_vector(0 to 31);
  signal mb3_plb_bus_PLB_wrPendPri : std_logic_vector(0 to 1);
  signal mb3_plb_bus_PLB_wrPendReq : std_logic;
  signal mb3_plb_bus_PLB_wrPrim : std_logic_vector(0 to 0);
  signal mb3_plb_bus_SPLB_Rst : std_logic_vector(0 to 0);
  signal mb3_plb_bus_Sl_MBusy : std_logic_vector(0 to 1);
  signal mb3_plb_bus_Sl_MIRQ : std_logic_vector(0 to 1);
  signal mb3_plb_bus_Sl_MRdErr : std_logic_vector(0 to 1);
  signal mb3_plb_bus_Sl_MWrErr : std_logic_vector(0 to 1);
  signal mb3_plb_bus_Sl_SSize : std_logic_vector(0 to 1);
  signal mb3_plb_bus_Sl_addrAck : std_logic_vector(0 to 0);
  signal mb3_plb_bus_Sl_rdBTerm : std_logic_vector(0 to 0);
  signal mb3_plb_bus_Sl_rdComp : std_logic_vector(0 to 0);
  signal mb3_plb_bus_Sl_rdDAck : std_logic_vector(0 to 0);
  signal mb3_plb_bus_Sl_rdDBus : std_logic_vector(0 to 31);
  signal mb3_plb_bus_Sl_rdWdAddr : std_logic_vector(0 to 3);
  signal mb3_plb_bus_Sl_rearbitrate : std_logic_vector(0 to 0);
  signal mb3_plb_bus_Sl_wait : std_logic_vector(0 to 0);
  signal mb3_plb_bus_Sl_wrBTerm : std_logic_vector(0 to 0);
  signal mb3_plb_bus_Sl_wrComp : std_logic_vector(0 to 0);
  signal mb3_plb_bus_Sl_wrDAck : std_logic_vector(0 to 0);
  signal mb4_plb_bus_M_ABort : std_logic_vector(0 to 1);
  signal mb4_plb_bus_M_ABus : std_logic_vector(0 to 63);
  signal mb4_plb_bus_M_BE : std_logic_vector(0 to 7);
  signal mb4_plb_bus_M_MSize : std_logic_vector(0 to 3);
  signal mb4_plb_bus_M_RNW : std_logic_vector(0 to 1);
  signal mb4_plb_bus_M_TAttribute : std_logic_vector(0 to 31);
  signal mb4_plb_bus_M_UABus : std_logic_vector(0 to 63);
  signal mb4_plb_bus_M_busLock : std_logic_vector(0 to 1);
  signal mb4_plb_bus_M_lockErr : std_logic_vector(0 to 1);
  signal mb4_plb_bus_M_priority : std_logic_vector(0 to 3);
  signal mb4_plb_bus_M_rdBurst : std_logic_vector(0 to 1);
  signal mb4_plb_bus_M_request : std_logic_vector(0 to 1);
  signal mb4_plb_bus_M_size : std_logic_vector(0 to 7);
  signal mb4_plb_bus_M_type : std_logic_vector(0 to 5);
  signal mb4_plb_bus_M_wrBurst : std_logic_vector(0 to 1);
  signal mb4_plb_bus_M_wrDBus : std_logic_vector(0 to 63);
  signal mb4_plb_bus_PLB_ABus : std_logic_vector(0 to 31);
  signal mb4_plb_bus_PLB_BE : std_logic_vector(0 to 3);
  signal mb4_plb_bus_PLB_MAddrAck : std_logic_vector(0 to 1);
  signal mb4_plb_bus_PLB_MBusy : std_logic_vector(0 to 1);
  signal mb4_plb_bus_PLB_MIRQ : std_logic_vector(0 to 1);
  signal mb4_plb_bus_PLB_MRdBTerm : std_logic_vector(0 to 1);
  signal mb4_plb_bus_PLB_MRdDAck : std_logic_vector(0 to 1);
  signal mb4_plb_bus_PLB_MRdDBus : std_logic_vector(0 to 63);
  signal mb4_plb_bus_PLB_MRdErr : std_logic_vector(0 to 1);
  signal mb4_plb_bus_PLB_MRdWdAddr : std_logic_vector(0 to 7);
  signal mb4_plb_bus_PLB_MRearbitrate : std_logic_vector(0 to 1);
  signal mb4_plb_bus_PLB_MSSize : std_logic_vector(0 to 3);
  signal mb4_plb_bus_PLB_MSize : std_logic_vector(0 to 1);
  signal mb4_plb_bus_PLB_MTimeout : std_logic_vector(0 to 1);
  signal mb4_plb_bus_PLB_MWrBTerm : std_logic_vector(0 to 1);
  signal mb4_plb_bus_PLB_MWrDAck : std_logic_vector(0 to 1);
  signal mb4_plb_bus_PLB_MWrErr : std_logic_vector(0 to 1);
  signal mb4_plb_bus_PLB_PAValid : std_logic;
  signal mb4_plb_bus_PLB_RNW : std_logic;
  signal mb4_plb_bus_PLB_SAValid : std_logic;
  signal mb4_plb_bus_PLB_TAttribute : std_logic_vector(0 to 15);
  signal mb4_plb_bus_PLB_UABus : std_logic_vector(0 to 31);
  signal mb4_plb_bus_PLB_abort : std_logic;
  signal mb4_plb_bus_PLB_busLock : std_logic;
  signal mb4_plb_bus_PLB_lockErr : std_logic;
  signal mb4_plb_bus_PLB_masterID : std_logic_vector(0 to 0);
  signal mb4_plb_bus_PLB_rdBurst : std_logic;
  signal mb4_plb_bus_PLB_rdPendPri : std_logic_vector(0 to 1);
  signal mb4_plb_bus_PLB_rdPendReq : std_logic;
  signal mb4_plb_bus_PLB_rdPrim : std_logic_vector(0 to 0);
  signal mb4_plb_bus_PLB_reqPri : std_logic_vector(0 to 1);
  signal mb4_plb_bus_PLB_size : std_logic_vector(0 to 3);
  signal mb4_plb_bus_PLB_type : std_logic_vector(0 to 2);
  signal mb4_plb_bus_PLB_wrBurst : std_logic;
  signal mb4_plb_bus_PLB_wrDBus : std_logic_vector(0 to 31);
  signal mb4_plb_bus_PLB_wrPendPri : std_logic_vector(0 to 1);
  signal mb4_plb_bus_PLB_wrPendReq : std_logic;
  signal mb4_plb_bus_PLB_wrPrim : std_logic_vector(0 to 0);
  signal mb4_plb_bus_SPLB_Rst : std_logic_vector(0 to 0);
  signal mb4_plb_bus_Sl_MBusy : std_logic_vector(0 to 1);
  signal mb4_plb_bus_Sl_MIRQ : std_logic_vector(0 to 1);
  signal mb4_plb_bus_Sl_MRdErr : std_logic_vector(0 to 1);
  signal mb4_plb_bus_Sl_MWrErr : std_logic_vector(0 to 1);
  signal mb4_plb_bus_Sl_SSize : std_logic_vector(0 to 1);
  signal mb4_plb_bus_Sl_addrAck : std_logic_vector(0 to 0);
  signal mb4_plb_bus_Sl_rdBTerm : std_logic_vector(0 to 0);
  signal mb4_plb_bus_Sl_rdComp : std_logic_vector(0 to 0);
  signal mb4_plb_bus_Sl_rdDAck : std_logic_vector(0 to 0);
  signal mb4_plb_bus_Sl_rdDBus : std_logic_vector(0 to 31);
  signal mb4_plb_bus_Sl_rdWdAddr : std_logic_vector(0 to 3);
  signal mb4_plb_bus_Sl_rearbitrate : std_logic_vector(0 to 0);
  signal mb4_plb_bus_Sl_wait : std_logic_vector(0 to 0);
  signal mb4_plb_bus_Sl_wrBTerm : std_logic_vector(0 to 0);
  signal mb4_plb_bus_Sl_wrComp : std_logic_vector(0 to 0);
  signal mb4_plb_bus_Sl_wrDAck : std_logic_vector(0 to 0);
  signal mb5_plb_bus_M_ABort : std_logic_vector(0 to 1);
  signal mb5_plb_bus_M_ABus : std_logic_vector(0 to 63);
  signal mb5_plb_bus_M_BE : std_logic_vector(0 to 7);
  signal mb5_plb_bus_M_MSize : std_logic_vector(0 to 3);
  signal mb5_plb_bus_M_RNW : std_logic_vector(0 to 1);
  signal mb5_plb_bus_M_TAttribute : std_logic_vector(0 to 31);
  signal mb5_plb_bus_M_UABus : std_logic_vector(0 to 63);
  signal mb5_plb_bus_M_busLock : std_logic_vector(0 to 1);
  signal mb5_plb_bus_M_lockErr : std_logic_vector(0 to 1);
  signal mb5_plb_bus_M_priority : std_logic_vector(0 to 3);
  signal mb5_plb_bus_M_rdBurst : std_logic_vector(0 to 1);
  signal mb5_plb_bus_M_request : std_logic_vector(0 to 1);
  signal mb5_plb_bus_M_size : std_logic_vector(0 to 7);
  signal mb5_plb_bus_M_type : std_logic_vector(0 to 5);
  signal mb5_plb_bus_M_wrBurst : std_logic_vector(0 to 1);
  signal mb5_plb_bus_M_wrDBus : std_logic_vector(0 to 63);
  signal mb5_plb_bus_PLB_ABus : std_logic_vector(0 to 31);
  signal mb5_plb_bus_PLB_BE : std_logic_vector(0 to 3);
  signal mb5_plb_bus_PLB_MAddrAck : std_logic_vector(0 to 1);
  signal mb5_plb_bus_PLB_MBusy : std_logic_vector(0 to 1);
  signal mb5_plb_bus_PLB_MIRQ : std_logic_vector(0 to 1);
  signal mb5_plb_bus_PLB_MRdBTerm : std_logic_vector(0 to 1);
  signal mb5_plb_bus_PLB_MRdDAck : std_logic_vector(0 to 1);
  signal mb5_plb_bus_PLB_MRdDBus : std_logic_vector(0 to 63);
  signal mb5_plb_bus_PLB_MRdErr : std_logic_vector(0 to 1);
  signal mb5_plb_bus_PLB_MRdWdAddr : std_logic_vector(0 to 7);
  signal mb5_plb_bus_PLB_MRearbitrate : std_logic_vector(0 to 1);
  signal mb5_plb_bus_PLB_MSSize : std_logic_vector(0 to 3);
  signal mb5_plb_bus_PLB_MSize : std_logic_vector(0 to 1);
  signal mb5_plb_bus_PLB_MTimeout : std_logic_vector(0 to 1);
  signal mb5_plb_bus_PLB_MWrBTerm : std_logic_vector(0 to 1);
  signal mb5_plb_bus_PLB_MWrDAck : std_logic_vector(0 to 1);
  signal mb5_plb_bus_PLB_MWrErr : std_logic_vector(0 to 1);
  signal mb5_plb_bus_PLB_PAValid : std_logic;
  signal mb5_plb_bus_PLB_RNW : std_logic;
  signal mb5_plb_bus_PLB_SAValid : std_logic;
  signal mb5_plb_bus_PLB_TAttribute : std_logic_vector(0 to 15);
  signal mb5_plb_bus_PLB_UABus : std_logic_vector(0 to 31);
  signal mb5_plb_bus_PLB_abort : std_logic;
  signal mb5_plb_bus_PLB_busLock : std_logic;
  signal mb5_plb_bus_PLB_lockErr : std_logic;
  signal mb5_plb_bus_PLB_masterID : std_logic_vector(0 to 0);
  signal mb5_plb_bus_PLB_rdBurst : std_logic;
  signal mb5_plb_bus_PLB_rdPendPri : std_logic_vector(0 to 1);
  signal mb5_plb_bus_PLB_rdPendReq : std_logic;
  signal mb5_plb_bus_PLB_rdPrim : std_logic_vector(0 to 0);
  signal mb5_plb_bus_PLB_reqPri : std_logic_vector(0 to 1);
  signal mb5_plb_bus_PLB_size : std_logic_vector(0 to 3);
  signal mb5_plb_bus_PLB_type : std_logic_vector(0 to 2);
  signal mb5_plb_bus_PLB_wrBurst : std_logic;
  signal mb5_plb_bus_PLB_wrDBus : std_logic_vector(0 to 31);
  signal mb5_plb_bus_PLB_wrPendPri : std_logic_vector(0 to 1);
  signal mb5_plb_bus_PLB_wrPendReq : std_logic;
  signal mb5_plb_bus_PLB_wrPrim : std_logic_vector(0 to 0);
  signal mb5_plb_bus_SPLB_Rst : std_logic_vector(0 to 0);
  signal mb5_plb_bus_Sl_MBusy : std_logic_vector(0 to 1);
  signal mb5_plb_bus_Sl_MIRQ : std_logic_vector(0 to 1);
  signal mb5_plb_bus_Sl_MRdErr : std_logic_vector(0 to 1);
  signal mb5_plb_bus_Sl_MWrErr : std_logic_vector(0 to 1);
  signal mb5_plb_bus_Sl_SSize : std_logic_vector(0 to 1);
  signal mb5_plb_bus_Sl_addrAck : std_logic_vector(0 to 0);
  signal mb5_plb_bus_Sl_rdBTerm : std_logic_vector(0 to 0);
  signal mb5_plb_bus_Sl_rdComp : std_logic_vector(0 to 0);
  signal mb5_plb_bus_Sl_rdDAck : std_logic_vector(0 to 0);
  signal mb5_plb_bus_Sl_rdDBus : std_logic_vector(0 to 31);
  signal mb5_plb_bus_Sl_rdWdAddr : std_logic_vector(0 to 3);
  signal mb5_plb_bus_Sl_rearbitrate : std_logic_vector(0 to 0);
  signal mb5_plb_bus_Sl_wait : std_logic_vector(0 to 0);
  signal mb5_plb_bus_Sl_wrBTerm : std_logic_vector(0 to 0);
  signal mb5_plb_bus_Sl_wrComp : std_logic_vector(0 to 0);
  signal mb5_plb_bus_Sl_wrDAck : std_logic_vector(0 to 0);
  signal mb_dlmb1_LMB_ABus : std_logic_vector(0 to 31);
  signal mb_dlmb1_LMB_AddrStrobe : std_logic;
  signal mb_dlmb1_LMB_BE : std_logic_vector(0 to 3);
  signal mb_dlmb1_LMB_ReadDBus : std_logic_vector(0 to 31);
  signal mb_dlmb1_LMB_ReadStrobe : std_logic;
  signal mb_dlmb1_LMB_Ready : std_logic;
  signal mb_dlmb1_LMB_WriteDBus : std_logic_vector(0 to 31);
  signal mb_dlmb1_LMB_WriteStrobe : std_logic;
  signal mb_dlmb1_M_ABus : std_logic_vector(0 to 31);
  signal mb_dlmb1_M_AddrStrobe : std_logic;
  signal mb_dlmb1_M_BE : std_logic_vector(0 to 3);
  signal mb_dlmb1_M_DBus : std_logic_vector(0 to 31);
  signal mb_dlmb1_M_ReadStrobe : std_logic;
  signal mb_dlmb1_M_WriteStrobe : std_logic;
  signal mb_dlmb1_OPB_Rst : std_logic;
  signal mb_dlmb1_Sl_DBus : std_logic_vector(0 to 31);
  signal mb_dlmb1_Sl_Ready : std_logic_vector(0 to 0);
  signal mb_dlmb2_LMB_ABus : std_logic_vector(0 to 31);
  signal mb_dlmb2_LMB_AddrStrobe : std_logic;
  signal mb_dlmb2_LMB_BE : std_logic_vector(0 to 3);
  signal mb_dlmb2_LMB_ReadDBus : std_logic_vector(0 to 31);
  signal mb_dlmb2_LMB_ReadStrobe : std_logic;
  signal mb_dlmb2_LMB_Ready : std_logic;
  signal mb_dlmb2_LMB_WriteDBus : std_logic_vector(0 to 31);
  signal mb_dlmb2_LMB_WriteStrobe : std_logic;
  signal mb_dlmb2_M_ABus : std_logic_vector(0 to 31);
  signal mb_dlmb2_M_AddrStrobe : std_logic;
  signal mb_dlmb2_M_BE : std_logic_vector(0 to 3);
  signal mb_dlmb2_M_DBus : std_logic_vector(0 to 31);
  signal mb_dlmb2_M_ReadStrobe : std_logic;
  signal mb_dlmb2_M_WriteStrobe : std_logic;
  signal mb_dlmb2_OPB_Rst : std_logic;
  signal mb_dlmb2_Sl_DBus : std_logic_vector(0 to 31);
  signal mb_dlmb2_Sl_Ready : std_logic_vector(0 to 0);
  signal mb_dlmb_LMB_ABus : std_logic_vector(0 to 31);
  signal mb_dlmb_LMB_AddrStrobe : std_logic;
  signal mb_dlmb_LMB_BE : std_logic_vector(0 to 3);
  signal mb_dlmb_LMB_ReadDBus : std_logic_vector(0 to 31);
  signal mb_dlmb_LMB_ReadStrobe : std_logic;
  signal mb_dlmb_LMB_Ready : std_logic;
  signal mb_dlmb_LMB_WriteDBus : std_logic_vector(0 to 31);
  signal mb_dlmb_LMB_WriteStrobe : std_logic;
  signal mb_dlmb_M_ABus : std_logic_vector(0 to 31);
  signal mb_dlmb_M_AddrStrobe : std_logic;
  signal mb_dlmb_M_BE : std_logic_vector(0 to 3);
  signal mb_dlmb_M_DBus : std_logic_vector(0 to 31);
  signal mb_dlmb_M_ReadStrobe : std_logic;
  signal mb_dlmb_M_WriteStrobe : std_logic;
  signal mb_dlmb_OPB_Rst : std_logic;
  signal mb_dlmb_Sl_DBus : std_logic_vector(0 to 31);
  signal mb_dlmb_Sl_Ready : std_logic_vector(0 to 0);
  signal mb_dlmb_mb3_LMB_ABus : std_logic_vector(0 to 31);
  signal mb_dlmb_mb3_LMB_AddrStrobe : std_logic;
  signal mb_dlmb_mb3_LMB_BE : std_logic_vector(0 to 3);
  signal mb_dlmb_mb3_LMB_ReadDBus : std_logic_vector(0 to 31);
  signal mb_dlmb_mb3_LMB_ReadStrobe : std_logic;
  signal mb_dlmb_mb3_LMB_Ready : std_logic;
  signal mb_dlmb_mb3_LMB_WriteDBus : std_logic_vector(0 to 31);
  signal mb_dlmb_mb3_LMB_WriteStrobe : std_logic;
  signal mb_dlmb_mb3_M_ABus : std_logic_vector(0 to 31);
  signal mb_dlmb_mb3_M_AddrStrobe : std_logic;
  signal mb_dlmb_mb3_M_BE : std_logic_vector(0 to 3);
  signal mb_dlmb_mb3_M_DBus : std_logic_vector(0 to 31);
  signal mb_dlmb_mb3_M_ReadStrobe : std_logic;
  signal mb_dlmb_mb3_M_WriteStrobe : std_logic;
  signal mb_dlmb_mb3_OPB_Rst : std_logic;
  signal mb_dlmb_mb3_Sl_DBus : std_logic_vector(0 to 31);
  signal mb_dlmb_mb3_Sl_Ready : std_logic_vector(0 to 0);
  signal mb_dlmb_mb4_LMB_ABus : std_logic_vector(0 to 31);
  signal mb_dlmb_mb4_LMB_AddrStrobe : std_logic;
  signal mb_dlmb_mb4_LMB_BE : std_logic_vector(0 to 3);
  signal mb_dlmb_mb4_LMB_ReadDBus : std_logic_vector(0 to 31);
  signal mb_dlmb_mb4_LMB_ReadStrobe : std_logic;
  signal mb_dlmb_mb4_LMB_Ready : std_logic;
  signal mb_dlmb_mb4_LMB_WriteDBus : std_logic_vector(0 to 31);
  signal mb_dlmb_mb4_LMB_WriteStrobe : std_logic;
  signal mb_dlmb_mb4_M_ABus : std_logic_vector(0 to 31);
  signal mb_dlmb_mb4_M_AddrStrobe : std_logic;
  signal mb_dlmb_mb4_M_BE : std_logic_vector(0 to 3);
  signal mb_dlmb_mb4_M_DBus : std_logic_vector(0 to 31);
  signal mb_dlmb_mb4_M_ReadStrobe : std_logic;
  signal mb_dlmb_mb4_M_WriteStrobe : std_logic;
  signal mb_dlmb_mb4_OPB_Rst : std_logic;
  signal mb_dlmb_mb4_Sl_DBus : std_logic_vector(0 to 31);
  signal mb_dlmb_mb4_Sl_Ready : std_logic_vector(0 to 0);
  signal mb_dlmb_mb5_LMB_ABus : std_logic_vector(0 to 31);
  signal mb_dlmb_mb5_LMB_AddrStrobe : std_logic;
  signal mb_dlmb_mb5_LMB_BE : std_logic_vector(0 to 3);
  signal mb_dlmb_mb5_LMB_ReadDBus : std_logic_vector(0 to 31);
  signal mb_dlmb_mb5_LMB_ReadStrobe : std_logic;
  signal mb_dlmb_mb5_LMB_Ready : std_logic;
  signal mb_dlmb_mb5_LMB_WriteDBus : std_logic_vector(0 to 31);
  signal mb_dlmb_mb5_LMB_WriteStrobe : std_logic;
  signal mb_dlmb_mb5_M_ABus : std_logic_vector(0 to 31);
  signal mb_dlmb_mb5_M_AddrStrobe : std_logic;
  signal mb_dlmb_mb5_M_BE : std_logic_vector(0 to 3);
  signal mb_dlmb_mb5_M_DBus : std_logic_vector(0 to 31);
  signal mb_dlmb_mb5_M_ReadStrobe : std_logic;
  signal mb_dlmb_mb5_M_WriteStrobe : std_logic;
  signal mb_dlmb_mb5_OPB_Rst : std_logic;
  signal mb_dlmb_mb5_Sl_DBus : std_logic_vector(0 to 31);
  signal mb_dlmb_mb5_Sl_Ready : std_logic_vector(0 to 0);
  signal mb_ilmb1_LMB_ABus : std_logic_vector(0 to 31);
  signal mb_ilmb1_LMB_AddrStrobe : std_logic;
  signal mb_ilmb1_LMB_BE : std_logic_vector(0 to 3);
  signal mb_ilmb1_LMB_ReadDBus : std_logic_vector(0 to 31);
  signal mb_ilmb1_LMB_ReadStrobe : std_logic;
  signal mb_ilmb1_LMB_Ready : std_logic;
  signal mb_ilmb1_LMB_WriteDBus : std_logic_vector(0 to 31);
  signal mb_ilmb1_LMB_WriteStrobe : std_logic;
  signal mb_ilmb1_M_ABus : std_logic_vector(0 to 31);
  signal mb_ilmb1_M_AddrStrobe : std_logic;
  signal mb_ilmb1_M_ReadStrobe : std_logic;
  signal mb_ilmb1_OPB_Rst : std_logic;
  signal mb_ilmb1_Sl_DBus : std_logic_vector(0 to 31);
  signal mb_ilmb1_Sl_Ready : std_logic_vector(0 to 0);
  signal mb_ilmb2_LMB_ABus : std_logic_vector(0 to 31);
  signal mb_ilmb2_LMB_AddrStrobe : std_logic;
  signal mb_ilmb2_LMB_BE : std_logic_vector(0 to 3);
  signal mb_ilmb2_LMB_ReadDBus : std_logic_vector(0 to 31);
  signal mb_ilmb2_LMB_ReadStrobe : std_logic;
  signal mb_ilmb2_LMB_Ready : std_logic;
  signal mb_ilmb2_LMB_WriteDBus : std_logic_vector(0 to 31);
  signal mb_ilmb2_LMB_WriteStrobe : std_logic;
  signal mb_ilmb2_M_ABus : std_logic_vector(0 to 31);
  signal mb_ilmb2_M_AddrStrobe : std_logic;
  signal mb_ilmb2_M_ReadStrobe : std_logic;
  signal mb_ilmb2_OPB_Rst : std_logic;
  signal mb_ilmb2_Sl_DBus : std_logic_vector(0 to 31);
  signal mb_ilmb2_Sl_Ready : std_logic_vector(0 to 0);
  signal mb_ilmb_LMB_ABus : std_logic_vector(0 to 31);
  signal mb_ilmb_LMB_AddrStrobe : std_logic;
  signal mb_ilmb_LMB_BE : std_logic_vector(0 to 3);
  signal mb_ilmb_LMB_ReadDBus : std_logic_vector(0 to 31);
  signal mb_ilmb_LMB_ReadStrobe : std_logic;
  signal mb_ilmb_LMB_Ready : std_logic;
  signal mb_ilmb_LMB_WriteDBus : std_logic_vector(0 to 31);
  signal mb_ilmb_LMB_WriteStrobe : std_logic;
  signal mb_ilmb_M_ABus : std_logic_vector(0 to 31);
  signal mb_ilmb_M_AddrStrobe : std_logic;
  signal mb_ilmb_M_ReadStrobe : std_logic;
  signal mb_ilmb_OPB_Rst : std_logic;
  signal mb_ilmb_Sl_DBus : std_logic_vector(0 to 31);
  signal mb_ilmb_Sl_Ready : std_logic_vector(0 to 0);
  signal mb_ilmb_mb3_LMB_ABus : std_logic_vector(0 to 31);
  signal mb_ilmb_mb3_LMB_AddrStrobe : std_logic;
  signal mb_ilmb_mb3_LMB_BE : std_logic_vector(0 to 3);
  signal mb_ilmb_mb3_LMB_ReadDBus : std_logic_vector(0 to 31);
  signal mb_ilmb_mb3_LMB_ReadStrobe : std_logic;
  signal mb_ilmb_mb3_LMB_Ready : std_logic;
  signal mb_ilmb_mb3_LMB_WriteDBus : std_logic_vector(0 to 31);
  signal mb_ilmb_mb3_LMB_WriteStrobe : std_logic;
  signal mb_ilmb_mb3_M_ABus : std_logic_vector(0 to 31);
  signal mb_ilmb_mb3_M_AddrStrobe : std_logic;
  signal mb_ilmb_mb3_M_ReadStrobe : std_logic;
  signal mb_ilmb_mb3_OPB_Rst : std_logic;
  signal mb_ilmb_mb3_Sl_DBus : std_logic_vector(0 to 31);
  signal mb_ilmb_mb3_Sl_Ready : std_logic_vector(0 to 0);
  signal mb_ilmb_mb4_LMB_ABus : std_logic_vector(0 to 31);
  signal mb_ilmb_mb4_LMB_AddrStrobe : std_logic;
  signal mb_ilmb_mb4_LMB_BE : std_logic_vector(0 to 3);
  signal mb_ilmb_mb4_LMB_ReadDBus : std_logic_vector(0 to 31);
  signal mb_ilmb_mb4_LMB_ReadStrobe : std_logic;
  signal mb_ilmb_mb4_LMB_Ready : std_logic;
  signal mb_ilmb_mb4_LMB_WriteDBus : std_logic_vector(0 to 31);
  signal mb_ilmb_mb4_LMB_WriteStrobe : std_logic;
  signal mb_ilmb_mb4_M_ABus : std_logic_vector(0 to 31);
  signal mb_ilmb_mb4_M_AddrStrobe : std_logic;
  signal mb_ilmb_mb4_M_ReadStrobe : std_logic;
  signal mb_ilmb_mb4_OPB_Rst : std_logic;
  signal mb_ilmb_mb4_Sl_DBus : std_logic_vector(0 to 31);
  signal mb_ilmb_mb4_Sl_Ready : std_logic_vector(0 to 0);
  signal mb_ilmb_mb5_LMB_ABus : std_logic_vector(0 to 31);
  signal mb_ilmb_mb5_LMB_AddrStrobe : std_logic;
  signal mb_ilmb_mb5_LMB_BE : std_logic_vector(0 to 3);
  signal mb_ilmb_mb5_LMB_ReadDBus : std_logic_vector(0 to 31);
  signal mb_ilmb_mb5_LMB_ReadStrobe : std_logic;
  signal mb_ilmb_mb5_LMB_Ready : std_logic;
  signal mb_ilmb_mb5_LMB_WriteDBus : std_logic_vector(0 to 31);
  signal mb_ilmb_mb5_LMB_WriteStrobe : std_logic;
  signal mb_ilmb_mb5_M_ABus : std_logic_vector(0 to 31);
  signal mb_ilmb_mb5_M_AddrStrobe : std_logic;
  signal mb_ilmb_mb5_M_ReadStrobe : std_logic;
  signal mb_ilmb_mb5_OPB_Rst : std_logic;
  signal mb_ilmb_mb5_Sl_DBus : std_logic_vector(0 to 31);
  signal mb_ilmb_mb5_Sl_Ready : std_logic_vector(0 to 0);
  signal microblaze_0_IXCL_FSL_M_Clk : std_logic;
  signal microblaze_0_IXCL_FSL_M_Control : std_logic;
  signal microblaze_0_IXCL_FSL_M_Data : std_logic_vector(0 to 31);
  signal microblaze_0_IXCL_FSL_M_Full : std_logic;
  signal microblaze_0_IXCL_FSL_M_Write : std_logic;
  signal microblaze_0_IXCL_FSL_S_Clk : std_logic;
  signal microblaze_0_IXCL_FSL_S_Control : std_logic;
  signal microblaze_0_IXCL_FSL_S_Data : std_logic_vector(0 to 31);
  signal microblaze_0_IXCL_FSL_S_Exists : std_logic;
  signal microblaze_0_IXCL_FSL_S_Read : std_logic;
  signal microblaze_0_MBDEBUG_Dbg_Capture : std_logic;
  signal microblaze_0_MBDEBUG_Dbg_Clk : std_logic;
  signal microblaze_0_MBDEBUG_Dbg_Reg_En : std_logic_vector(0 to 4);
  signal microblaze_0_MBDEBUG_Dbg_Shift : std_logic;
  signal microblaze_0_MBDEBUG_Dbg_TDI : std_logic;
  signal microblaze_0_MBDEBUG_Dbg_TDO : std_logic;
  signal microblaze_0_MBDEBUG_Dbg_Update : std_logic;
  signal microblaze_0_MBDEBUG_Debug_Rst : std_logic;
  signal microblaze_1_IXCL_FSL_M_Clk : std_logic;
  signal microblaze_1_IXCL_FSL_M_Control : std_logic;
  signal microblaze_1_IXCL_FSL_M_Data : std_logic_vector(0 to 31);
  signal microblaze_1_IXCL_FSL_M_Full : std_logic;
  signal microblaze_1_IXCL_FSL_M_Write : std_logic;
  signal microblaze_1_IXCL_FSL_S_Clk : std_logic;
  signal microblaze_1_IXCL_FSL_S_Control : std_logic;
  signal microblaze_1_IXCL_FSL_S_Data : std_logic_vector(0 to 31);
  signal microblaze_1_IXCL_FSL_S_Exists : std_logic;
  signal microblaze_1_IXCL_FSL_S_Read : std_logic;
  signal microblaze_1_MBDEBUG_Dbg_Capture : std_logic;
  signal microblaze_1_MBDEBUG_Dbg_Clk : std_logic;
  signal microblaze_1_MBDEBUG_Dbg_Reg_En : std_logic_vector(0 to 4);
  signal microblaze_1_MBDEBUG_Dbg_Shift : std_logic;
  signal microblaze_1_MBDEBUG_Dbg_TDI : std_logic;
  signal microblaze_1_MBDEBUG_Dbg_TDO : std_logic;
  signal microblaze_1_MBDEBUG_Dbg_Update : std_logic;
  signal microblaze_1_MBDEBUG_Debug_Rst : std_logic;
  signal microblaze_2_IXCL_FSL_M_Clk : std_logic;
  signal microblaze_2_IXCL_FSL_M_Control : std_logic;
  signal microblaze_2_IXCL_FSL_M_Data : std_logic_vector(0 to 31);
  signal microblaze_2_IXCL_FSL_M_Full : std_logic;
  signal microblaze_2_IXCL_FSL_M_Write : std_logic;
  signal microblaze_2_IXCL_FSL_S_Clk : std_logic;
  signal microblaze_2_IXCL_FSL_S_Control : std_logic;
  signal microblaze_2_IXCL_FSL_S_Data : std_logic_vector(0 to 31);
  signal microblaze_2_IXCL_FSL_S_Exists : std_logic;
  signal microblaze_2_IXCL_FSL_S_Read : std_logic;
  signal microblaze_2_MBDEBUG_Dbg_Capture : std_logic;
  signal microblaze_2_MBDEBUG_Dbg_Clk : std_logic;
  signal microblaze_2_MBDEBUG_Dbg_Reg_En : std_logic_vector(0 to 4);
  signal microblaze_2_MBDEBUG_Dbg_Shift : std_logic;
  signal microblaze_2_MBDEBUG_Dbg_TDI : std_logic;
  signal microblaze_2_MBDEBUG_Dbg_TDO : std_logic;
  signal microblaze_2_MBDEBUG_Dbg_Update : std_logic;
  signal microblaze_2_MBDEBUG_Debug_Rst : std_logic;
  signal microblaze_mb3_IXCL_FSL_M_Clk : std_logic;
  signal microblaze_mb3_IXCL_FSL_M_Control : std_logic;
  signal microblaze_mb3_IXCL_FSL_M_Data : std_logic_vector(0 to 31);
  signal microblaze_mb3_IXCL_FSL_M_Full : std_logic;
  signal microblaze_mb3_IXCL_FSL_M_Write : std_logic;
  signal microblaze_mb3_IXCL_FSL_S_Clk : std_logic;
  signal microblaze_mb3_IXCL_FSL_S_Control : std_logic;
  signal microblaze_mb3_IXCL_FSL_S_Data : std_logic_vector(0 to 31);
  signal microblaze_mb3_IXCL_FSL_S_Exists : std_logic;
  signal microblaze_mb3_IXCL_FSL_S_Read : std_logic;
  signal microblaze_mb4_IXCL_FSL_M_Clk : std_logic;
  signal microblaze_mb4_IXCL_FSL_M_Control : std_logic;
  signal microblaze_mb4_IXCL_FSL_M_Data : std_logic_vector(0 to 31);
  signal microblaze_mb4_IXCL_FSL_M_Full : std_logic;
  signal microblaze_mb4_IXCL_FSL_M_Write : std_logic;
  signal microblaze_mb4_IXCL_FSL_S_Clk : std_logic;
  signal microblaze_mb4_IXCL_FSL_S_Control : std_logic;
  signal microblaze_mb4_IXCL_FSL_S_Data : std_logic_vector(0 to 31);
  signal microblaze_mb4_IXCL_FSL_S_Exists : std_logic;
  signal microblaze_mb4_IXCL_FSL_S_Read : std_logic;
  signal microblaze_mb5_IXCL_FSL_M_Clk : std_logic;
  signal microblaze_mb5_IXCL_FSL_M_Control : std_logic;
  signal microblaze_mb5_IXCL_FSL_M_Data : std_logic_vector(0 to 31);
  signal microblaze_mb5_IXCL_FSL_M_Full : std_logic;
  signal microblaze_mb5_IXCL_FSL_M_Write : std_logic;
  signal microblaze_mb5_IXCL_FSL_S_Clk : std_logic;
  signal microblaze_mb5_IXCL_FSL_S_Control : std_logic;
  signal microblaze_mb5_IXCL_FSL_S_Data : std_logic_vector(0 to 31);
  signal microblaze_mb5_IXCL_FSL_S_Exists : std_logic;
  signal microblaze_mb5_IXCL_FSL_S_Read : std_logic;
  signal net_gnd0 : std_logic;
  signal net_gnd1 : std_logic_vector(0 to 0);
  signal net_gnd2 : std_logic_vector(0 to 1);
  signal net_gnd3 : std_logic_vector(0 to 2);
  signal net_gnd4 : std_logic_vector(0 to 3);
  signal net_gnd5 : std_logic_vector(0 to 4);
  signal net_gnd6 : std_logic_vector(0 to 5);
  signal net_gnd8 : std_logic_vector(0 to 7);
  signal net_gnd10 : std_logic_vector(0 to 9);
  signal net_gnd16 : std_logic_vector(0 to 15);
  signal net_gnd32 : std_logic_vector(0 to 31);
  signal net_gnd36 : std_logic_vector(0 to 35);
  signal net_gnd64 : std_logic_vector(0 to 63);
  signal net_gnd128 : std_logic_vector(0 to 127);
  signal net_vcc0 : std_logic;
  signal net_vcc4 : std_logic_vector(0 to 3);
  signal net_vcc6 : std_logic_vector(0 to 5);
  signal opb_bram_if_cntlr_1_PORTA_BRAM_Addr : std_logic_vector(0 to 31);
  signal opb_bram_if_cntlr_1_PORTA_BRAM_Clk : std_logic;
  signal opb_bram_if_cntlr_1_PORTA_BRAM_Din : std_logic_vector(0 to 31);
  signal opb_bram_if_cntlr_1_PORTA_BRAM_Dout : std_logic_vector(0 to 31);
  signal opb_bram_if_cntlr_1_PORTA_BRAM_EN : std_logic;
  signal opb_bram_if_cntlr_1_PORTA_BRAM_Rst : std_logic;
  signal opb_bram_if_cntlr_1_PORTA_BRAM_WEN : std_logic_vector(0 to 3);
  signal opb_v20_0_M_ABus : std_logic_vector(0 to 127);
  signal opb_v20_0_M_BE : std_logic_vector(0 to 15);
  signal opb_v20_0_M_DBus : std_logic_vector(0 to 127);
  signal opb_v20_0_M_RNW : std_logic_vector(0 to 3);
  signal opb_v20_0_M_busLock : std_logic_vector(0 to 3);
  signal opb_v20_0_M_request : std_logic_vector(0 to 3);
  signal opb_v20_0_M_select : std_logic_vector(0 to 3);
  signal opb_v20_0_M_seqAddr : std_logic_vector(0 to 3);
  signal opb_v20_0_OPB_ABus : std_logic_vector(0 to 31);
  signal opb_v20_0_OPB_BE : std_logic_vector(0 to 3);
  signal opb_v20_0_OPB_DBus : std_logic_vector(0 to 31);
  signal opb_v20_0_OPB_MGrant : std_logic_vector(0 to 3);
  signal opb_v20_0_OPB_RNW : std_logic;
  signal opb_v20_0_OPB_Rst : std_logic;
  signal opb_v20_0_OPB_errAck : std_logic;
  signal opb_v20_0_OPB_retry : std_logic;
  signal opb_v20_0_OPB_select : std_logic;
  signal opb_v20_0_OPB_seqAddr : std_logic;
  signal opb_v20_0_OPB_timeout : std_logic;
  signal opb_v20_0_OPB_xferAck : std_logic;
  signal opb_v20_0_Sl_DBus : std_logic_vector(0 to 191);
  signal opb_v20_0_Sl_errAck : std_logic_vector(0 to 5);
  signal opb_v20_0_Sl_retry : std_logic_vector(0 to 5);
  signal opb_v20_0_Sl_toutSup : std_logic_vector(0 to 5);
  signal opb_v20_0_Sl_xferAck : std_logic_vector(0 to 5);
  signal plb_v46_0_MPLB_Rst : std_logic_vector(0 to 7);
  signal plb_v46_0_M_ABus : std_logic_vector(0 to 255);
  signal plb_v46_0_M_BE : std_logic_vector(0 to 127);
  signal plb_v46_0_M_MSize : std_logic_vector(0 to 15);
  signal plb_v46_0_M_RNW : std_logic_vector(0 to 7);
  signal plb_v46_0_M_TAttribute : std_logic_vector(0 to 127);
  signal plb_v46_0_M_UABus : std_logic_vector(0 to 255);
  signal plb_v46_0_M_abort : std_logic_vector(0 to 7);
  signal plb_v46_0_M_busLock : std_logic_vector(0 to 7);
  signal plb_v46_0_M_lockErr : std_logic_vector(0 to 7);
  signal plb_v46_0_M_priority : std_logic_vector(0 to 15);
  signal plb_v46_0_M_rdBurst : std_logic_vector(0 to 7);
  signal plb_v46_0_M_request : std_logic_vector(0 to 7);
  signal plb_v46_0_M_size : std_logic_vector(0 to 31);
  signal plb_v46_0_M_type : std_logic_vector(0 to 23);
  signal plb_v46_0_M_wrBurst : std_logic_vector(0 to 7);
  signal plb_v46_0_M_wrDBus : std_logic_vector(0 to 1023);
  signal plb_v46_0_PLB_ABus : std_logic_vector(0 to 31);
  signal plb_v46_0_PLB_BE : std_logic_vector(0 to 15);
  signal plb_v46_0_PLB_MAddrAck : std_logic_vector(0 to 7);
  signal plb_v46_0_PLB_MBusy : std_logic_vector(0 to 7);
  signal plb_v46_0_PLB_MIRQ : std_logic_vector(0 to 7);
  signal plb_v46_0_PLB_MRdBTerm : std_logic_vector(0 to 7);
  signal plb_v46_0_PLB_MRdDAck : std_logic_vector(0 to 7);
  signal plb_v46_0_PLB_MRdDBus : std_logic_vector(0 to 1023);
  signal plb_v46_0_PLB_MRdErr : std_logic_vector(0 to 7);
  signal plb_v46_0_PLB_MRdWdAddr : std_logic_vector(0 to 31);
  signal plb_v46_0_PLB_MRearbitrate : std_logic_vector(0 to 7);
  signal plb_v46_0_PLB_MSSize : std_logic_vector(0 to 15);
  signal plb_v46_0_PLB_MSize : std_logic_vector(0 to 1);
  signal plb_v46_0_PLB_MTimeout : std_logic_vector(0 to 7);
  signal plb_v46_0_PLB_MWrBTerm : std_logic_vector(0 to 7);
  signal plb_v46_0_PLB_MWrDAck : std_logic_vector(0 to 7);
  signal plb_v46_0_PLB_MWrErr : std_logic_vector(0 to 7);
  signal plb_v46_0_PLB_PAValid : std_logic;
  signal plb_v46_0_PLB_RNW : std_logic;
  signal plb_v46_0_PLB_SAValid : std_logic;
  signal plb_v46_0_PLB_TAttribute : std_logic_vector(0 to 15);
  signal plb_v46_0_PLB_UABus : std_logic_vector(0 to 31);
  signal plb_v46_0_PLB_abort : std_logic;
  signal plb_v46_0_PLB_busLock : std_logic;
  signal plb_v46_0_PLB_lockErr : std_logic;
  signal plb_v46_0_PLB_masterID : std_logic_vector(0 to 2);
  signal plb_v46_0_PLB_rdBurst : std_logic;
  signal plb_v46_0_PLB_rdPendPri : std_logic_vector(0 to 1);
  signal plb_v46_0_PLB_rdPendReq : std_logic;
  signal plb_v46_0_PLB_rdPrim : std_logic_vector(0 to 11);
  signal plb_v46_0_PLB_reqPri : std_logic_vector(0 to 1);
  signal plb_v46_0_PLB_size : std_logic_vector(0 to 3);
  signal plb_v46_0_PLB_type : std_logic_vector(0 to 2);
  signal plb_v46_0_PLB_wrBurst : std_logic;
  signal plb_v46_0_PLB_wrDBus : std_logic_vector(0 to 127);
  signal plb_v46_0_PLB_wrPendPri : std_logic_vector(0 to 1);
  signal plb_v46_0_PLB_wrPendReq : std_logic;
  signal plb_v46_0_PLB_wrPrim : std_logic_vector(0 to 11);
  signal plb_v46_0_SPLB_Rst : std_logic_vector(0 to 11);
  signal plb_v46_0_Sl_MBusy : std_logic_vector(0 to 95);
  signal plb_v46_0_Sl_MIRQ : std_logic_vector(0 to 95);
  signal plb_v46_0_Sl_MRdErr : std_logic_vector(0 to 95);
  signal plb_v46_0_Sl_MWrErr : std_logic_vector(0 to 95);
  signal plb_v46_0_Sl_SSize : std_logic_vector(0 to 23);
  signal plb_v46_0_Sl_addrAck : std_logic_vector(0 to 11);
  signal plb_v46_0_Sl_rdBTerm : std_logic_vector(0 to 11);
  signal plb_v46_0_Sl_rdComp : std_logic_vector(0 to 11);
  signal plb_v46_0_Sl_rdDAck : std_logic_vector(0 to 11);
  signal plb_v46_0_Sl_rdDBus : std_logic_vector(0 to 1535);
  signal plb_v46_0_Sl_rdWdAddr : std_logic_vector(0 to 47);
  signal plb_v46_0_Sl_rearbitrate : std_logic_vector(0 to 11);
  signal plb_v46_0_Sl_wait : std_logic_vector(0 to 11);
  signal plb_v46_0_Sl_wrBTerm : std_logic_vector(0 to 11);
  signal plb_v46_0_Sl_wrComp : std_logic_vector(0 to 11);
  signal plb_v46_0_Sl_wrDAck : std_logic_vector(0 to 11);
  signal ppc440_0_PPC440MC0_MCMIADDRREADYTOACCEPT : std_logic;
  signal ppc440_0_PPC440MC0_MCMIREADDATA : std_logic_vector(0 to 127);
  signal ppc440_0_PPC440MC0_MCMIREADDATAERR : std_logic;
  signal ppc440_0_PPC440MC0_MCMIREADDATAVALID : std_logic;
  signal ppc440_0_PPC440MC0_MIMCADDRESS : std_logic_vector(0 to 35);
  signal ppc440_0_PPC440MC0_MIMCADDRESSVALID : std_logic;
  signal ppc440_0_PPC440MC0_MIMCBANKCONFLICT : std_logic;
  signal ppc440_0_PPC440MC0_MIMCBYTEENABLE : std_logic_vector(0 to 15);
  signal ppc440_0_PPC440MC0_MIMCREADNOTWRITE : std_logic;
  signal ppc440_0_PPC440MC0_MIMCROWCONFLICT : std_logic;
  signal ppc440_0_PPC440MC0_MIMCWRITEDATA : std_logic_vector(0 to 127);
  signal ppc440_0_PPC440MC0_MIMCWRITEDATAVALID : std_logic;
  signal ppc_reset_bus_Chip_Reset_Req : std_logic;
  signal ppc_reset_bus_Core_Reset_Req : std_logic;
  signal ppc_reset_bus_RstcPPCresetcore : std_logic;
  signal ppc_reset_bus_RstcPPCresetsys : std_logic;
  signal ppc_reset_bus_RstsPPCresetchip : std_logic;
  signal ppc_reset_bus_System_Reset_Req : std_logic;
  signal proc_clk_s : std_logic;
  signal soft_stop : std_logic;
  signal sys_bus_reset : std_logic_vector(0 to 0);
  signal sys_clk_s : std_logic;
  signal sys_periph_reset : std_logic_vector(0 to 0);
  signal sys_rst_s : std_logic;
  signal uart_interrupt : std_logic_vector(0 downto 0);
  signal xps_bram_if_cntlr_0_PORTA_BRAM_Addr : std_logic_vector(0 to 31);
  signal xps_bram_if_cntlr_0_PORTA_BRAM_Clk : std_logic;
  signal xps_bram_if_cntlr_0_PORTA_BRAM_Din : std_logic_vector(0 to 31);
  signal xps_bram_if_cntlr_0_PORTA_BRAM_Dout : std_logic_vector(0 to 31);
  signal xps_bram_if_cntlr_0_PORTA_BRAM_EN : std_logic;
  signal xps_bram_if_cntlr_0_PORTA_BRAM_Rst : std_logic;
  signal xps_bram_if_cntlr_0_PORTA_BRAM_WEN : std_logic_vector(0 to 3);
  signal xps_bram_if_cntlr_1_port_BRAM_Addr : std_logic_vector(0 to 31);
  signal xps_bram_if_cntlr_1_port_BRAM_Clk : std_logic;
  signal xps_bram_if_cntlr_1_port_BRAM_Din : std_logic_vector(0 to 63);
  signal xps_bram_if_cntlr_1_port_BRAM_Dout : std_logic_vector(0 to 63);
  signal xps_bram_if_cntlr_1_port_BRAM_EN : std_logic;
  signal xps_bram_if_cntlr_1_port_BRAM_Rst : std_logic;
  signal xps_bram_if_cntlr_1_port_BRAM_WEN : std_logic_vector(0 to 7);
  signal xps_hw_thread_bram_cntlr_PORTA_BRAM_Addr : std_logic_vector(0 to 31);
  signal xps_hw_thread_bram_cntlr_PORTA_BRAM_Clk : std_logic;
  signal xps_hw_thread_bram_cntlr_PORTA_BRAM_Din : std_logic_vector(0 to 31);
  signal xps_hw_thread_bram_cntlr_PORTA_BRAM_Dout : std_logic_vector(0 to 31);
  signal xps_hw_thread_bram_cntlr_PORTA_BRAM_EN : std_logic;
  signal xps_hw_thread_bram_cntlr_PORTA_BRAM_Rst : std_logic;
  signal xps_hw_thread_bram_cntlr_PORTA_BRAM_WEN : std_logic_vector(0 to 3);

  attribute BOX_TYPE : STRING;
  attribute BOX_TYPE of ppc440_0_wrapper : component is "black_box";
  attribute BOX_TYPE of plb_v46_0_wrapper : component is "black_box";
  attribute BOX_TYPE of xps_bram_if_cntlr_1_wrapper : component is "black_box";
  attribute BOX_TYPE of xps_bram_if_cntlr_1_bram_wrapper : component is "black_box";
  attribute BOX_TYPE of rs232_uart_1_wrapper : component is "black_box";
  attribute BOX_TYPE of leds_8bit_wrapper : component is "black_box";
  attribute BOX_TYPE of sram_wrapper : component is "black_box";
  attribute BOX_TYPE of ddr2_sdram_wrapper : component is "black_box";
  attribute BOX_TYPE of sram_util_bus_split_0_wrapper : component is "black_box";
  attribute BOX_TYPE of ddr2_sdram_util_bus_split_1_wrapper : component is "black_box";
  attribute BOX_TYPE of ddr2_sdram_util_bus_split_2_wrapper : component is "black_box";
  attribute BOX_TYPE of clock_generator_0_wrapper : component is "black_box";
  attribute BOX_TYPE of jtagppc_cntlr_0_wrapper : component is "black_box";
  attribute BOX_TYPE of proc_sys_reset_0_wrapper : component is "black_box";
  attribute BOX_TYPE of xps_intc_0_wrapper : component is "black_box";
  attribute BOX_TYPE of plbv46_opb_bridge_0_wrapper : component is "black_box";
  attribute BOX_TYPE of opb_plbv46_bridge_0_wrapper : component is "black_box";
  attribute BOX_TYPE of opb_v20_0_wrapper : component is "black_box";
  attribute BOX_TYPE of opb_bram_if_cntlr_1_wrapper : component is "black_box";
  attribute BOX_TYPE of bram_block_0_wrapper : component is "black_box";
  attribute BOX_TYPE of xps_bram_if_cntlr_0_wrapper : component is "black_box";
  attribute BOX_TYPE of plb_hthread_reset_core_0_wrapper : component is "black_box";
  attribute BOX_TYPE of thread_manager_wrapper : component is "black_box";
  attribute BOX_TYPE of scheduler_wrapper : component is "black_box";
  attribute BOX_TYPE of synch_manager_wrapper : component is "black_box";
  attribute BOX_TYPE of cond_vars_wrapper : component is "black_box";
  attribute BOX_TYPE of xps_timer_0_wrapper : component is "black_box";
  attribute BOX_TYPE of xps_hw_thread_bram_cntlr_wrapper : component is "black_box";
  attribute BOX_TYPE of hw_thread_bram_wrapper : component is "black_box";
  attribute BOX_TYPE of microblaze_0_wrapper : component is "black_box";
  attribute BOX_TYPE of mb_ilmb_wrapper : component is "black_box";
  attribute BOX_TYPE of mb_dlmb_wrapper : component is "black_box";
  attribute BOX_TYPE of ilmb_cntlr_wrapper : component is "black_box";
  attribute BOX_TYPE of dlmb_cntlr_wrapper : component is "black_box";
  attribute BOX_TYPE of mb_bram_wrapper : component is "black_box";
  attribute BOX_TYPE of mdm_0_wrapper : component is "black_box";
  attribute BOX_TYPE of microblaze_1_wrapper : component is "black_box";
  attribute BOX_TYPE of mb_ilmb1_wrapper : component is "black_box";
  attribute BOX_TYPE of mb_dlmb1_wrapper : component is "black_box";
  attribute BOX_TYPE of ilmb_cntlr1_wrapper : component is "black_box";
  attribute BOX_TYPE of dlmb_cntlr1_wrapper : component is "black_box";
  attribute BOX_TYPE of mb_bram1_wrapper : component is "black_box";
  attribute BOX_TYPE of mb0_plb_bridge_wrapper : component is "black_box";
  attribute BOX_TYPE of mb0_plb_bus_wrapper : component is "black_box";
  attribute BOX_TYPE of mb1_plb_bridge_wrapper : component is "black_box";
  attribute BOX_TYPE of mb1_plb_bus_wrapper : component is "black_box";
  attribute BOX_TYPE of microblaze_2_wrapper : component is "black_box";
  attribute BOX_TYPE of mb_ilmb2_wrapper : component is "black_box";
  attribute BOX_TYPE of mb_dlmb2_wrapper : component is "black_box";
  attribute BOX_TYPE of ilmb_cntlr2_wrapper : component is "black_box";
  attribute BOX_TYPE of dlmb_cntlr2_wrapper : component is "black_box";
  attribute BOX_TYPE of mb_bram2_wrapper : component is "black_box";
  attribute BOX_TYPE of mb2_plb_bridge_wrapper : component is "black_box";
  attribute BOX_TYPE of mb2_plb_bus_wrapper : component is "black_box";
  attribute BOX_TYPE of microblaze_mb3_wrapper : component is "black_box";
  attribute BOX_TYPE of mb_ilmb_mb3_wrapper : component is "black_box";
  attribute BOX_TYPE of mb_dlmb_mb3_wrapper : component is "black_box";
  attribute BOX_TYPE of ilmb_cntlr_mb3_wrapper : component is "black_box";
  attribute BOX_TYPE of dlmb_cntlr_mb3_wrapper : component is "black_box";
  attribute BOX_TYPE of mb3_bram_wrapper : component is "black_box";
  attribute BOX_TYPE of mb3_plb_bridge_wrapper : component is "black_box";
  attribute BOX_TYPE of mb3_plb_bus_wrapper : component is "black_box";
  attribute BOX_TYPE of microblaze_mb4_wrapper : component is "black_box";
  attribute BOX_TYPE of mb_ilmb_mb4_wrapper : component is "black_box";
  attribute BOX_TYPE of mb_dlmb_mb4_wrapper : component is "black_box";
  attribute BOX_TYPE of ilmb_cntlr_mb4_wrapper : component is "black_box";
  attribute BOX_TYPE of dlmb_cntlr_mb4_wrapper : component is "black_box";
  attribute BOX_TYPE of mb4_bram_wrapper : component is "black_box";
  attribute BOX_TYPE of mb4_plb_bridge_wrapper : component is "black_box";
  attribute BOX_TYPE of mb4_plb_bus_wrapper : component is "black_box";
  attribute BOX_TYPE of microblaze_mb5_wrapper : component is "black_box";
  attribute BOX_TYPE of mb_ilmb_mb5_wrapper : component is "black_box";
  attribute BOX_TYPE of mb_dlmb_mb5_wrapper : component is "black_box";
  attribute BOX_TYPE of ilmb_cntlr_mb5_wrapper : component is "black_box";
  attribute BOX_TYPE of dlmb_cntlr_mb5_wrapper : component is "black_box";
  attribute BOX_TYPE of mb5_bram_wrapper : component is "black_box";
  attribute BOX_TYPE of mb5_plb_bus_wrapper : component is "black_box";
  attribute BOX_TYPE of mb5_plb_bridge_wrapper : component is "black_box";

begin

  -- Internal assignments

  fpga_0_RS232_Uart_1_RX <= fpga_0_RS232_Uart_1_RX_pin;
  fpga_0_RS232_Uart_1_TX_pin <= fpga_0_RS232_Uart_1_TX;
  fpga_0_SRAM_Mem_A_pin <= fpga_0_SRAM_Mem_A;
  fpga_0_SRAM_Mem_BEN_pin <= fpga_0_SRAM_Mem_BEN;
  fpga_0_SRAM_Mem_OEN_pin <= fpga_0_SRAM_Mem_OEN(0);
  fpga_0_SRAM_Mem_CEN_pin <= fpga_0_SRAM_Mem_CEN(0);
  fpga_0_SRAM_Mem_ADV_LDN_pin <= fpga_0_SRAM_Mem_ADV_LDN;
  fpga_0_SRAM_Mem_WEN_pin <= fpga_0_SRAM_Mem_WEN;
  fpga_0_DDR2_SDRAM_DDR2_ODT_pin <= fpga_0_DDR2_SDRAM_DDR2_ODT;
  fpga_0_DDR2_SDRAM_DDR2_Addr_pin <= fpga_0_DDR2_SDRAM_DDR2_Addr;
  fpga_0_DDR2_SDRAM_DDR2_BankAddr_pin <= fpga_0_DDR2_SDRAM_DDR2_BankAddr;
  fpga_0_DDR2_SDRAM_DDR2_CAS_n_pin <= fpga_0_DDR2_SDRAM_DDR2_CAS_n;
  fpga_0_DDR2_SDRAM_DDR2_CE_pin(0 to 0) <= fpga_0_DDR2_SDRAM_DDR2_CE(0 to 0);
  fpga_0_DDR2_SDRAM_DDR2_CS_n_pin(0 to 0) <= fpga_0_DDR2_SDRAM_DDR2_CS_n(0 to 0);
  fpga_0_DDR2_SDRAM_DDR2_RAS_n_pin <= fpga_0_DDR2_SDRAM_DDR2_RAS_n;
  fpga_0_DDR2_SDRAM_DDR2_WE_n_pin <= fpga_0_DDR2_SDRAM_DDR2_WE_n;
  fpga_0_DDR2_SDRAM_DDR2_Clk_pin <= fpga_0_DDR2_SDRAM_DDR2_Clk;
  fpga_0_DDR2_SDRAM_DDR2_Clk_n_pin <= fpga_0_DDR2_SDRAM_DDR2_Clk_n;
  fpga_0_DDR2_SDRAM_DDR2_DM_pin <= fpga_0_DDR2_SDRAM_DDR2_DM;
  fpga_0_SRAM_CLK <= ZBT_CLK_OUT_s;
  ZBT_CLK_FB_s <= fpga_0_SRAM_CLK_FB;
  dcm_clk_s <= sys_clk_pin;
  sys_rst_s <= sys_rst_pin;
  opb_v20_0_M_DBus(32 to 63) <= B"00000000000000000000000000000000";
  opb_v20_0_M_DBus(64 to 95) <= B"00000000000000000000000000000000";
  opb_v20_0_M_DBus(96 to 127) <= B"00000000000000000000000000000000";
  net_gnd0 <= '0';
  net_gnd1(0 to 0) <= B"0";
  net_gnd10(0 to 9) <= B"0000000000";
  net_gnd128(0 to 127) <= B"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
  net_gnd16(0 to 15) <= B"0000000000000000";
  net_gnd2(0 to 1) <= B"00";
  net_gnd3(0 to 2) <= B"000";
  net_gnd32(0 to 31) <= B"00000000000000000000000000000000";
  net_gnd36(0 to 35) <= B"000000000000000000000000000000000000";
  net_gnd4(0 to 3) <= B"0000";
  net_gnd5(0 to 4) <= B"00000";
  net_gnd6(0 to 5) <= B"000000";
  net_gnd64(0 to 63) <= B"0000000000000000000000000000000000000000000000000000000000000000";
  net_gnd8(0 to 7) <= B"00000000";
  net_vcc0 <= '1';
  net_vcc4(0 to 3) <= B"1111";
  net_vcc6(0 to 5) <= B"111111";

  ppc440_0 : ppc440_0_wrapper
    port map (
      CPMC440CLK => proc_clk_s,
      CPMC440CLKEN => net_vcc0,
      CPMINTERCONNECTCLK => proc_clk_s,
      CPMINTERCONNECTCLKEN => net_vcc0,
      CPMINTERCONNECTCLKNTO1 => net_vcc0,
      CPMC440CORECLOCKINACTIVE => net_gnd0,
      CPMC440TIMERCLOCK => net_vcc0,
      C440MACHINECHECK => open,
      C440CPMCORESLEEPREQ => open,
      C440CPMDECIRPTREQ => open,
      C440CPMFITIRPTREQ => open,
      C440CPMMSRCE => open,
      C440CPMMSREE => open,
      C440CPMTIMERRESETREQ => open,
      C440CPMWDIRPTREQ => open,
      PPCCPMINTERCONNECTBUSY => open,
      DBGC440DEBUGHALT => net_gnd0,
      DBGC440DEBUGHALTNEG => net_vcc0,
      DBGC440SYSTEMSTATUS => net_gnd5,
      DBGC440UNCONDDEBUGEVENT => net_gnd0,
      C440DBGSYSTEMCONTROL => open,
      SPLB0_Error => open,
      SPLB1_Error => open,
      EICC440CRITIRQ => net_gnd0,
      EICC440EXTIRQ => net_gnd0,
      PPCEICINTERCONNECTIRQ => open,
      CPMDCRCLK => net_vcc0,
      DCRPPCDMACK => net_gnd0,
      DCRPPCDMDBUSIN => net_gnd32,
      DCRPPCDMTIMEOUTWAIT => net_gnd0,
      PPCDMDCRREAD => open,
      PPCDMDCRWRITE => open,
      PPCDMDCRABUS => open,
      PPCDMDCRDBUSOUT => open,
      DCRPPCDSREAD => net_gnd0,
      DCRPPCDSWRITE => net_gnd0,
      DCRPPCDSABUS => net_gnd10,
      DCRPPCDSDBUSOUT => net_gnd32,
      PPCDSDCRACK => open,
      PPCDSDCRDBUSIN => open,
      PPCDSDCRTIMEOUTWAIT => open,
      CPMFCMCLK => net_vcc0,
      FCMAPUCR => net_gnd4,
      FCMAPUDONE => net_gnd0,
      FCMAPUEXCEPTION => net_gnd0,
      FCMAPUFPSCRFEX => net_gnd0,
      FCMAPURESULT => net_gnd32,
      FCMAPURESULTVALID => net_gnd0,
      FCMAPUSLEEPNOTREADY => net_gnd0,
      FCMAPUCONFIRMINSTR => net_gnd0,
      FCMAPUSTOREDATA => net_gnd128,
      APUFCMDECNONAUTON => open,
      APUFCMDECFPUOP => open,
      APUFCMDECLDSTXFERSIZE => open,
      APUFCMDECLOAD => open,
      APUFCMNEXTINSTRREADY => open,
      APUFCMDECSTORE => open,
      APUFCMDECUDI => open,
      APUFCMDECUDIVALID => open,
      APUFCMENDIAN => open,
      APUFCMFLUSH => open,
      APUFCMINSTRUCTION => open,
      APUFCMINSTRVALID => open,
      APUFCMLOADBYTEADDR => open,
      APUFCMLOADDATA => open,
      APUFCMLOADDVALID => open,
      APUFCMOPERANDVALID => open,
      APUFCMRADATA => open,
      APUFCMRBDATA => open,
      APUFCMWRITEBACKOK => open,
      APUFCMMSRFE0 => open,
      APUFCMMSRFE1 => open,
      JTGC440TCK => jtagppc_cntlr_0_0_JTGC405TCK,
      JTGC440TDI => jtagppc_cntlr_0_0_JTGC405TDI,
      JTGC440TMS => jtagppc_cntlr_0_0_JTGC405TMS,
      JTGC440TRSTNEG => jtagppc_cntlr_0_0_JTGC405TRSTNEG,
      C440JTGTDO => jtagppc_cntlr_0_0_C405JTGTDO,
      C440JTGTDOEN => jtagppc_cntlr_0_0_C405JTGTDOEN,
      CPMMCCLK => sys_clk_s,
      MCMIREADDATA => ppc440_0_PPC440MC0_MCMIREADDATA,
      MCMIREADDATAVALID => ppc440_0_PPC440MC0_MCMIREADDATAVALID,
      MCMIREADDATAERR => ppc440_0_PPC440MC0_MCMIREADDATAERR,
      MCMIADDRREADYTOACCEPT => ppc440_0_PPC440MC0_MCMIADDRREADYTOACCEPT,
      MIMCREADNOTWRITE => ppc440_0_PPC440MC0_MIMCREADNOTWRITE,
      MIMCADDRESS => ppc440_0_PPC440MC0_MIMCADDRESS,
      MIMCADDRESSVALID => ppc440_0_PPC440MC0_MIMCADDRESSVALID,
      MIMCWRITEDATA => ppc440_0_PPC440MC0_MIMCWRITEDATA,
      MIMCWRITEDATAVALID => ppc440_0_PPC440MC0_MIMCWRITEDATAVALID,
      MIMCBYTEENABLE => ppc440_0_PPC440MC0_MIMCBYTEENABLE,
      MIMCBANKCONFLICT => ppc440_0_PPC440MC0_MIMCBANKCONFLICT,
      MIMCROWCONFLICT => ppc440_0_PPC440MC0_MIMCROWCONFLICT,
      CPMPPCMPLBCLK => sys_clk_s,
      PLBPPCMMBUSY => plb_v46_0_PLB_MBusy(0),
      PLBPPCMMIRQ => plb_v46_0_PLB_MIRQ(0),
      PLBPPCMMRDERR => plb_v46_0_PLB_MRdErr(0),
      PLBPPCMMWRERR => plb_v46_0_PLB_MWrErr(0),
      PLBPPCMADDRACK => plb_v46_0_PLB_MAddrAck(0),
      PLBPPCMRDBTERM => plb_v46_0_PLB_MRdBTerm(0),
      PLBPPCMRDDACK => plb_v46_0_PLB_MRdDAck(0),
      PLBPPCMRDDBUS => plb_v46_0_PLB_MRdDBus(0 to 127),
      PLBPPCMRDWDADDR => plb_v46_0_PLB_MRdWdAddr(0 to 3),
      PLBPPCMREARBITRATE => plb_v46_0_PLB_MRearbitrate(0),
      PLBPPCMSSIZE => plb_v46_0_PLB_MSSize(0 to 1),
      PLBPPCMTIMEOUT => plb_v46_0_PLB_MTimeout(0),
      PLBPPCMWRBTERM => plb_v46_0_PLB_MWrBTerm(0),
      PLBPPCMWRDACK => plb_v46_0_PLB_MWrDAck(0),
      PLBPPCMRDPENDPRI => plb_v46_0_PLB_rdPendPri,
      PLBPPCMRDPENDREQ => plb_v46_0_PLB_rdPendReq,
      PLBPPCMREQPRI => plb_v46_0_PLB_reqPri,
      PLBPPCMWRPENDPRI => plb_v46_0_PLB_wrPendPri,
      PLBPPCMWRPENDREQ => plb_v46_0_PLB_wrPendReq,
      PPCMPLBABORT => plb_v46_0_M_abort(0),
      PPCMPLBABUS => plb_v46_0_M_ABus(0 to 31),
      PPCMPLBBE => plb_v46_0_M_BE(0 to 15),
      PPCMPLBBUSLOCK => plb_v46_0_M_busLock(0),
      PPCMPLBLOCKERR => plb_v46_0_M_lockErr(0),
      PPCMPLBMSIZE => plb_v46_0_M_MSize(0 to 1),
      PPCMPLBPRIORITY => plb_v46_0_M_priority(0 to 1),
      PPCMPLBRDBURST => plb_v46_0_M_rdBurst(0),
      PPCMPLBREQUEST => plb_v46_0_M_request(0),
      PPCMPLBRNW => plb_v46_0_M_RNW(0),
      PPCMPLBSIZE => plb_v46_0_M_size(0 to 3),
      PPCMPLBTATTRIBUTE => plb_v46_0_M_TAttribute(0 to 15),
      PPCMPLBTYPE => plb_v46_0_M_type(0 to 2),
      PPCMPLBUABUS => plb_v46_0_M_UABus(0 to 31),
      PPCMPLBWRBURST => plb_v46_0_M_wrBurst(0),
      PPCMPLBWRDBUS => plb_v46_0_M_wrDBus(0 to 127),
      CPMPPCS0PLBCLK => sys_clk_s,
      PLBPPCS0MASTERID => net_gnd1(0 to 0),
      PLBPPCS0PAVALID => net_gnd0,
      PLBPPCS0SAVALID => net_gnd0,
      PLBPPCS0RDPENDREQ => net_gnd0,
      PLBPPCS0WRPENDREQ => net_gnd0,
      PLBPPCS0RDPENDPRI => net_gnd2,
      PLBPPCS0WRPENDPRI => net_gnd2,
      PLBPPCS0REQPRI => net_gnd2,
      PLBPPCS0RDPRIM => net_gnd0,
      PLBPPCS0WRPRIM => net_gnd0,
      PLBPPCS0BUSLOCK => net_gnd0,
      PLBPPCS0ABORT => net_gnd0,
      PLBPPCS0RNW => net_gnd0,
      PLBPPCS0BE => net_gnd16,
      PLBPPCS0SIZE => net_gnd4,
      PLBPPCS0TYPE => net_gnd3,
      PLBPPCS0TATTRIBUTE => net_gnd16,
      PLBPPCS0LOCKERR => net_gnd0,
      PLBPPCS0MSIZE => net_gnd2,
      PLBPPCS0UABUS => net_gnd32,
      PLBPPCS0ABUS => net_gnd32,
      PLBPPCS0WRDBUS => net_gnd128,
      PLBPPCS0WRBURST => net_gnd0,
      PLBPPCS0RDBURST => net_gnd0,
      PPCS0PLBADDRACK => open,
      PPCS0PLBWAIT => open,
      PPCS0PLBREARBITRATE => open,
      PPCS0PLBWRDACK => open,
      PPCS0PLBWRCOMP => open,
      PPCS0PLBRDDBUS => open,
      PPCS0PLBRDWDADDR => open,
      PPCS0PLBRDDACK => open,
      PPCS0PLBRDCOMP => open,
      PPCS0PLBRDBTERM => open,
      PPCS0PLBWRBTERM => open,
      PPCS0PLBMBUSY => open,
      PPCS0PLBMRDERR => open,
      PPCS0PLBMWRERR => open,
      PPCS0PLBMIRQ => open,
      PPCS0PLBSSIZE => open,
      CPMPPCS1PLBCLK => net_vcc0,
      PLBPPCS1MASTERID => net_gnd1(0 to 0),
      PLBPPCS1PAVALID => net_gnd0,
      PLBPPCS1SAVALID => net_gnd0,
      PLBPPCS1RDPENDREQ => net_gnd0,
      PLBPPCS1WRPENDREQ => net_gnd0,
      PLBPPCS1RDPENDPRI => net_gnd2,
      PLBPPCS1WRPENDPRI => net_gnd2,
      PLBPPCS1REQPRI => net_gnd2,
      PLBPPCS1RDPRIM => net_gnd0,
      PLBPPCS1WRPRIM => net_gnd0,
      PLBPPCS1BUSLOCK => net_gnd0,
      PLBPPCS1ABORT => net_gnd0,
      PLBPPCS1RNW => net_gnd0,
      PLBPPCS1BE => net_gnd16,
      PLBPPCS1SIZE => net_gnd4,
      PLBPPCS1TYPE => net_gnd3,
      PLBPPCS1TATTRIBUTE => net_gnd16,
      PLBPPCS1LOCKERR => net_gnd0,
      PLBPPCS1MSIZE => net_gnd2,
      PLBPPCS1UABUS => net_gnd32,
      PLBPPCS1ABUS => net_gnd32,
      PLBPPCS1WRDBUS => net_gnd128,
      PLBPPCS1WRBURST => net_gnd0,
      PLBPPCS1RDBURST => net_gnd0,
      PPCS1PLBADDRACK => open,
      PPCS1PLBWAIT => open,
      PPCS1PLBREARBITRATE => open,
      PPCS1PLBWRDACK => open,
      PPCS1PLBWRCOMP => open,
      PPCS1PLBRDDBUS => open,
      PPCS1PLBRDWDADDR => open,
      PPCS1PLBRDDACK => open,
      PPCS1PLBRDCOMP => open,
      PPCS1PLBRDBTERM => open,
      PPCS1PLBWRBTERM => open,
      PPCS1PLBMBUSY => open,
      PPCS1PLBMRDERR => open,
      PPCS1PLBMWRERR => open,
      PPCS1PLBMIRQ => open,
      PPCS1PLBSSIZE => open,
      CPMDMA0LLCLK => net_vcc0,
      LLDMA0TXDSTRDYN => net_vcc0,
      LLDMA0RXD => net_gnd32,
      LLDMA0RXREM => net_gnd4,
      LLDMA0RXSOFN => net_vcc0,
      LLDMA0RXEOFN => net_vcc0,
      LLDMA0RXSOPN => net_vcc0,
      LLDMA0RXEOPN => net_vcc0,
      LLDMA0RXSRCRDYN => net_vcc0,
      LLDMA0RSTENGINEREQ => net_gnd0,
      DMA0LLTXD => open,
      DMA0LLTXREM => open,
      DMA0LLTXSOFN => open,
      DMA0LLTXEOFN => open,
      DMA0LLTXSOPN => open,
      DMA0LLTXEOPN => open,
      DMA0LLTXSRCRDYN => open,
      DMA0LLRXDSTRDYN => open,
      DMA0LLRSTENGINEACK => open,
      DMA0TXIRQ => open,
      DMA0RXIRQ => open,
      CPMDMA1LLCLK => net_vcc0,
      LLDMA1TXDSTRDYN => net_vcc0,
      LLDMA1RXD => net_gnd32,
      LLDMA1RXREM => net_gnd4,
      LLDMA1RXSOFN => net_vcc0,
      LLDMA1RXEOFN => net_vcc0,
      LLDMA1RXSOPN => net_vcc0,
      LLDMA1RXEOPN => net_vcc0,
      LLDMA1RXSRCRDYN => net_vcc0,
      LLDMA1RSTENGINEREQ => net_gnd0,
      DMA1LLTXD => open,
      DMA1LLTXREM => open,
      DMA1LLTXSOFN => open,
      DMA1LLTXEOFN => open,
      DMA1LLTXSOPN => open,
      DMA1LLTXEOPN => open,
      DMA1LLTXSRCRDYN => open,
      DMA1LLRXDSTRDYN => open,
      DMA1LLRSTENGINEACK => open,
      DMA1TXIRQ => open,
      DMA1RXIRQ => open,
      CPMDMA2LLCLK => net_vcc0,
      LLDMA2TXDSTRDYN => net_vcc0,
      LLDMA2RXD => net_gnd32,
      LLDMA2RXREM => net_gnd4,
      LLDMA2RXSOFN => net_vcc0,
      LLDMA2RXEOFN => net_vcc0,
      LLDMA2RXSOPN => net_vcc0,
      LLDMA2RXEOPN => net_vcc0,
      LLDMA2RXSRCRDYN => net_vcc0,
      LLDMA2RSTENGINEREQ => net_gnd0,
      DMA2LLTXD => open,
      DMA2LLTXREM => open,
      DMA2LLTXSOFN => open,
      DMA2LLTXEOFN => open,
      DMA2LLTXSOPN => open,
      DMA2LLTXEOPN => open,
      DMA2LLTXSRCRDYN => open,
      DMA2LLRXDSTRDYN => open,
      DMA2LLRSTENGINEACK => open,
      DMA2TXIRQ => open,
      DMA2RXIRQ => open,
      CPMDMA3LLCLK => net_vcc0,
      LLDMA3TXDSTRDYN => net_vcc0,
      LLDMA3RXD => net_gnd32,
      LLDMA3RXREM => net_gnd4,
      LLDMA3RXSOFN => net_vcc0,
      LLDMA3RXEOFN => net_vcc0,
      LLDMA3RXSOPN => net_vcc0,
      LLDMA3RXEOPN => net_vcc0,
      LLDMA3RXSRCRDYN => net_vcc0,
      LLDMA3RSTENGINEREQ => net_gnd0,
      DMA3LLTXD => open,
      DMA3LLTXREM => open,
      DMA3LLTXSOFN => open,
      DMA3LLTXEOFN => open,
      DMA3LLTXSOPN => open,
      DMA3LLTXEOPN => open,
      DMA3LLTXSRCRDYN => open,
      DMA3LLRXDSTRDYN => open,
      DMA3LLRSTENGINEACK => open,
      DMA3TXIRQ => open,
      DMA3RXIRQ => open,
      RSTC440RESETCORE => ppc_reset_bus_RstcPPCresetcore,
      RSTC440RESETCHIP => ppc_reset_bus_RstsPPCresetchip,
      RSTC440RESETSYSTEM => ppc_reset_bus_RstcPPCresetsys,
      C440RSTCORERESETREQ => ppc_reset_bus_Core_Reset_Req,
      C440RSTCHIPRESETREQ => ppc_reset_bus_Chip_Reset_Req,
      C440RSTSYSTEMRESETREQ => ppc_reset_bus_System_Reset_Req,
      TRCC440TRACEDISABLE => net_gnd0,
      TRCC440TRIGGEREVENTIN => net_gnd0,
      C440TRCBRANCHSTATUS => open,
      C440TRCCYCLE => open,
      C440TRCEXECUTIONSTATUS => open,
      C440TRCTRACESTATUS => open,
      C440TRCTRIGGEREVENTOUT => open,
      C440TRCTRIGGEREVENTTYPE => open
    );

  plb_v46_0 : plb_v46_0_wrapper
    port map (
      PLB_Clk => sys_clk_s,
      SYS_Rst => sys_bus_reset(0),
      PLB_Rst => open,
      SPLB_Rst => plb_v46_0_SPLB_Rst,
      MPLB_Rst => plb_v46_0_MPLB_Rst,
      PLB_dcrAck => open,
      PLB_dcrDBus => open,
      DCR_ABus => net_gnd10,
      DCR_DBus => net_gnd32,
      DCR_Read => net_gnd0,
      DCR_Write => net_gnd0,
      M_ABus => plb_v46_0_M_ABus,
      M_UABus => plb_v46_0_M_UABus,
      M_BE => plb_v46_0_M_BE,
      M_RNW => plb_v46_0_M_RNW,
      M_abort => plb_v46_0_M_abort,
      M_busLock => plb_v46_0_M_busLock,
      M_TAttribute => plb_v46_0_M_TAttribute,
      M_lockErr => plb_v46_0_M_lockErr,
      M_MSize => plb_v46_0_M_MSize,
      M_priority => plb_v46_0_M_priority,
      M_rdBurst => plb_v46_0_M_rdBurst,
      M_request => plb_v46_0_M_request,
      M_size => plb_v46_0_M_size,
      M_type => plb_v46_0_M_type,
      M_wrBurst => plb_v46_0_M_wrBurst,
      M_wrDBus => plb_v46_0_M_wrDBus,
      Sl_addrAck => plb_v46_0_Sl_addrAck,
      Sl_MRdErr => plb_v46_0_Sl_MRdErr,
      Sl_MWrErr => plb_v46_0_Sl_MWrErr,
      Sl_MBusy => plb_v46_0_Sl_MBusy,
      Sl_rdBTerm => plb_v46_0_Sl_rdBTerm,
      Sl_rdComp => plb_v46_0_Sl_rdComp,
      Sl_rdDAck => plb_v46_0_Sl_rdDAck,
      Sl_rdDBus => plb_v46_0_Sl_rdDBus,
      Sl_rdWdAddr => plb_v46_0_Sl_rdWdAddr,
      Sl_rearbitrate => plb_v46_0_Sl_rearbitrate,
      Sl_SSize => plb_v46_0_Sl_SSize,
      Sl_wait => plb_v46_0_Sl_wait,
      Sl_wrBTerm => plb_v46_0_Sl_wrBTerm,
      Sl_wrComp => plb_v46_0_Sl_wrComp,
      Sl_wrDAck => plb_v46_0_Sl_wrDAck,
      Sl_MIRQ => plb_v46_0_Sl_MIRQ,
      PLB_MIRQ => plb_v46_0_PLB_MIRQ,
      PLB_ABus => plb_v46_0_PLB_ABus,
      PLB_UABus => plb_v46_0_PLB_UABus,
      PLB_BE => plb_v46_0_PLB_BE,
      PLB_MAddrAck => plb_v46_0_PLB_MAddrAck,
      PLB_MTimeout => plb_v46_0_PLB_MTimeout,
      PLB_MBusy => plb_v46_0_PLB_MBusy,
      PLB_MRdErr => plb_v46_0_PLB_MRdErr,
      PLB_MWrErr => plb_v46_0_PLB_MWrErr,
      PLB_MRdBTerm => plb_v46_0_PLB_MRdBTerm,
      PLB_MRdDAck => plb_v46_0_PLB_MRdDAck,
      PLB_MRdDBus => plb_v46_0_PLB_MRdDBus,
      PLB_MRdWdAddr => plb_v46_0_PLB_MRdWdAddr,
      PLB_MRearbitrate => plb_v46_0_PLB_MRearbitrate,
      PLB_MWrBTerm => plb_v46_0_PLB_MWrBTerm,
      PLB_MWrDAck => plb_v46_0_PLB_MWrDAck,
      PLB_MSSize => plb_v46_0_PLB_MSSize,
      PLB_PAValid => plb_v46_0_PLB_PAValid,
      PLB_RNW => plb_v46_0_PLB_RNW,
      PLB_SAValid => plb_v46_0_PLB_SAValid,
      PLB_abort => plb_v46_0_PLB_abort,
      PLB_busLock => plb_v46_0_PLB_busLock,
      PLB_TAttribute => plb_v46_0_PLB_TAttribute,
      PLB_lockErr => plb_v46_0_PLB_lockErr,
      PLB_masterID => plb_v46_0_PLB_masterID,
      PLB_MSize => plb_v46_0_PLB_MSize,
      PLB_rdPendPri => plb_v46_0_PLB_rdPendPri,
      PLB_wrPendPri => plb_v46_0_PLB_wrPendPri,
      PLB_rdPendReq => plb_v46_0_PLB_rdPendReq,
      PLB_wrPendReq => plb_v46_0_PLB_wrPendReq,
      PLB_rdBurst => plb_v46_0_PLB_rdBurst,
      PLB_rdPrim => plb_v46_0_PLB_rdPrim,
      PLB_reqPri => plb_v46_0_PLB_reqPri,
      PLB_size => plb_v46_0_PLB_size,
      PLB_type => plb_v46_0_PLB_type,
      PLB_wrBurst => plb_v46_0_PLB_wrBurst,
      PLB_wrDBus => plb_v46_0_PLB_wrDBus,
      PLB_wrPrim => plb_v46_0_PLB_wrPrim,
      PLB_SaddrAck => open,
      PLB_SMRdErr => open,
      PLB_SMWrErr => open,
      PLB_SMBusy => open,
      PLB_SrdBTerm => open,
      PLB_SrdComp => open,
      PLB_SrdDAck => open,
      PLB_SrdDBus => open,
      PLB_SrdWdAddr => open,
      PLB_Srearbitrate => open,
      PLB_Sssize => open,
      PLB_Swait => open,
      PLB_SwrBTerm => open,
      PLB_SwrComp => open,
      PLB_SwrDAck => open,
      Bus_Error_Det => open
    );

  xps_bram_if_cntlr_1 : xps_bram_if_cntlr_1_wrapper
    port map (
      SPLB_Clk => sys_clk_s,
      SPLB_Rst => plb_v46_0_SPLB_Rst(0),
      PLB_ABus => plb_v46_0_PLB_ABus,
      PLB_UABus => plb_v46_0_PLB_UABus,
      PLB_PAValid => plb_v46_0_PLB_PAValid,
      PLB_SAValid => plb_v46_0_PLB_SAValid,
      PLB_rdPrim => plb_v46_0_PLB_rdPrim(0),
      PLB_wrPrim => plb_v46_0_PLB_wrPrim(0),
      PLB_masterID => plb_v46_0_PLB_masterID,
      PLB_abort => plb_v46_0_PLB_abort,
      PLB_busLock => plb_v46_0_PLB_busLock,
      PLB_RNW => plb_v46_0_PLB_RNW,
      PLB_BE => plb_v46_0_PLB_BE,
      PLB_MSize => plb_v46_0_PLB_MSize,
      PLB_size => plb_v46_0_PLB_size,
      PLB_type => plb_v46_0_PLB_type,
      PLB_lockErr => plb_v46_0_PLB_lockErr,
      PLB_wrDBus => plb_v46_0_PLB_wrDBus,
      PLB_wrBurst => plb_v46_0_PLB_wrBurst,
      PLB_rdBurst => plb_v46_0_PLB_rdBurst,
      PLB_wrPendReq => plb_v46_0_PLB_wrPendReq,
      PLB_rdPendReq => plb_v46_0_PLB_rdPendReq,
      PLB_wrPendPri => plb_v46_0_PLB_wrPendPri,
      PLB_rdPendPri => plb_v46_0_PLB_rdPendPri,
      PLB_reqPri => plb_v46_0_PLB_reqPri,
      PLB_TAttribute => plb_v46_0_PLB_TAttribute,
      Sl_addrAck => plb_v46_0_Sl_addrAck(0),
      Sl_SSize => plb_v46_0_Sl_SSize(0 to 1),
      Sl_wait => plb_v46_0_Sl_wait(0),
      Sl_rearbitrate => plb_v46_0_Sl_rearbitrate(0),
      Sl_wrDAck => plb_v46_0_Sl_wrDAck(0),
      Sl_wrComp => plb_v46_0_Sl_wrComp(0),
      Sl_wrBTerm => plb_v46_0_Sl_wrBTerm(0),
      Sl_rdDBus => plb_v46_0_Sl_rdDBus(0 to 127),
      Sl_rdWdAddr => plb_v46_0_Sl_rdWdAddr(0 to 3),
      Sl_rdDAck => plb_v46_0_Sl_rdDAck(0),
      Sl_rdComp => plb_v46_0_Sl_rdComp(0),
      Sl_rdBTerm => plb_v46_0_Sl_rdBTerm(0),
      Sl_MBusy => plb_v46_0_Sl_MBusy(0 to 7),
      Sl_MWrErr => plb_v46_0_Sl_MWrErr(0 to 7),
      Sl_MRdErr => plb_v46_0_Sl_MRdErr(0 to 7),
      Sl_MIRQ => plb_v46_0_Sl_MIRQ(0 to 7),
      BRAM_Rst => xps_bram_if_cntlr_1_port_BRAM_Rst,
      BRAM_Clk => xps_bram_if_cntlr_1_port_BRAM_Clk,
      BRAM_EN => xps_bram_if_cntlr_1_port_BRAM_EN,
      BRAM_WEN => xps_bram_if_cntlr_1_port_BRAM_WEN,
      BRAM_Addr => xps_bram_if_cntlr_1_port_BRAM_Addr,
      BRAM_Din => xps_bram_if_cntlr_1_port_BRAM_Din,
      BRAM_Dout => xps_bram_if_cntlr_1_port_BRAM_Dout
    );

  xps_bram_if_cntlr_1_bram : xps_bram_if_cntlr_1_bram_wrapper
    port map (
      BRAM_Rst_A => xps_bram_if_cntlr_1_port_BRAM_Rst,
      BRAM_Clk_A => xps_bram_if_cntlr_1_port_BRAM_Clk,
      BRAM_EN_A => xps_bram_if_cntlr_1_port_BRAM_EN,
      BRAM_WEN_A => xps_bram_if_cntlr_1_port_BRAM_WEN,
      BRAM_Addr_A => xps_bram_if_cntlr_1_port_BRAM_Addr,
      BRAM_Din_A => xps_bram_if_cntlr_1_port_BRAM_Din,
      BRAM_Dout_A => xps_bram_if_cntlr_1_port_BRAM_Dout,
      BRAM_Rst_B => net_gnd0,
      BRAM_Clk_B => net_gnd0,
      BRAM_EN_B => net_gnd0,
      BRAM_WEN_B => net_gnd8,
      BRAM_Addr_B => net_gnd32,
      BRAM_Din_B => open,
      BRAM_Dout_B => net_gnd64
    );

  RS232_Uart_1 : rs232_uart_1_wrapper
    port map (
      SPLB_Clk => sys_clk_s,
      SPLB_Rst => plb_v46_0_SPLB_Rst(1),
      PLB_ABus => plb_v46_0_PLB_ABus,
      PLB_PAValid => plb_v46_0_PLB_PAValid,
      PLB_masterID => plb_v46_0_PLB_masterID,
      PLB_RNW => plb_v46_0_PLB_RNW,
      PLB_BE => plb_v46_0_PLB_BE,
      PLB_size => plb_v46_0_PLB_size,
      PLB_type => plb_v46_0_PLB_type,
      PLB_wrDBus => plb_v46_0_PLB_wrDBus,
      PLB_UABus => plb_v46_0_PLB_UABus,
      PLB_SAValid => plb_v46_0_PLB_SAValid,
      PLB_rdPrim => plb_v46_0_PLB_rdPrim(1),
      PLB_wrPrim => plb_v46_0_PLB_wrPrim(1),
      PLB_abort => plb_v46_0_PLB_abort,
      PLB_busLock => plb_v46_0_PLB_busLock,
      PLB_MSize => plb_v46_0_PLB_MSize,
      PLB_lockErr => plb_v46_0_PLB_lockErr,
      PLB_wrBurst => plb_v46_0_PLB_wrBurst,
      PLB_rdBurst => plb_v46_0_PLB_rdBurst,
      PLB_wrPendReq => plb_v46_0_PLB_wrPendReq,
      PLB_rdPendReq => plb_v46_0_PLB_rdPendReq,
      PLB_wrPendPri => plb_v46_0_PLB_wrPendPri,
      PLB_rdPendPri => plb_v46_0_PLB_rdPendPri,
      PLB_reqPri => plb_v46_0_PLB_reqPri,
      PLB_TAttribute => plb_v46_0_PLB_TAttribute,
      Sl_addrAck => plb_v46_0_Sl_addrAck(1),
      Sl_SSize => plb_v46_0_Sl_SSize(2 to 3),
      Sl_wait => plb_v46_0_Sl_wait(1),
      Sl_rearbitrate => plb_v46_0_Sl_rearbitrate(1),
      Sl_wrDAck => plb_v46_0_Sl_wrDAck(1),
      Sl_wrComp => plb_v46_0_Sl_wrComp(1),
      Sl_rdDBus => plb_v46_0_Sl_rdDBus(128 to 255),
      Sl_rdDAck => plb_v46_0_Sl_rdDAck(1),
      Sl_rdComp => plb_v46_0_Sl_rdComp(1),
      Sl_MBusy => plb_v46_0_Sl_MBusy(8 to 15),
      Sl_MWrErr => plb_v46_0_Sl_MWrErr(8 to 15),
      Sl_MRdErr => plb_v46_0_Sl_MRdErr(8 to 15),
      Sl_wrBTerm => plb_v46_0_Sl_wrBTerm(1),
      Sl_rdWdAddr => plb_v46_0_Sl_rdWdAddr(4 to 7),
      Sl_rdBTerm => plb_v46_0_Sl_rdBTerm(1),
      Sl_MIRQ => plb_v46_0_Sl_MIRQ(8 to 15),
      RX => fpga_0_RS232_Uart_1_RX,
      TX => fpga_0_RS232_Uart_1_TX,
      Interrupt => uart_interrupt(0)
    );

  LEDs_8Bit : leds_8bit_wrapper
    port map (
      SPLB_Clk => sys_clk_s,
      SPLB_Rst => plb_v46_0_SPLB_Rst(2),
      PLB_ABus => plb_v46_0_PLB_ABus,
      PLB_UABus => plb_v46_0_PLB_UABus,
      PLB_PAValid => plb_v46_0_PLB_PAValid,
      PLB_SAValid => plb_v46_0_PLB_SAValid,
      PLB_rdPrim => plb_v46_0_PLB_rdPrim(2),
      PLB_wrPrim => plb_v46_0_PLB_wrPrim(2),
      PLB_masterID => plb_v46_0_PLB_masterID,
      PLB_abort => plb_v46_0_PLB_abort,
      PLB_busLock => plb_v46_0_PLB_busLock,
      PLB_RNW => plb_v46_0_PLB_RNW,
      PLB_BE => plb_v46_0_PLB_BE,
      PLB_MSize => plb_v46_0_PLB_MSize,
      PLB_size => plb_v46_0_PLB_size,
      PLB_type => plb_v46_0_PLB_type,
      PLB_lockErr => plb_v46_0_PLB_lockErr,
      PLB_wrDBus => plb_v46_0_PLB_wrDBus,
      PLB_wrBurst => plb_v46_0_PLB_wrBurst,
      PLB_rdBurst => plb_v46_0_PLB_rdBurst,
      PLB_wrPendReq => plb_v46_0_PLB_wrPendReq,
      PLB_rdPendReq => plb_v46_0_PLB_rdPendReq,
      PLB_wrPendPri => plb_v46_0_PLB_wrPendPri,
      PLB_rdPendPri => plb_v46_0_PLB_rdPendPri,
      PLB_reqPri => plb_v46_0_PLB_reqPri,
      PLB_TAttribute => plb_v46_0_PLB_TAttribute,
      Sl_addrAck => plb_v46_0_Sl_addrAck(2),
      Sl_SSize => plb_v46_0_Sl_SSize(4 to 5),
      Sl_wait => plb_v46_0_Sl_wait(2),
      Sl_rearbitrate => plb_v46_0_Sl_rearbitrate(2),
      Sl_wrDAck => plb_v46_0_Sl_wrDAck(2),
      Sl_wrComp => plb_v46_0_Sl_wrComp(2),
      Sl_wrBTerm => plb_v46_0_Sl_wrBTerm(2),
      Sl_rdDBus => plb_v46_0_Sl_rdDBus(256 to 383),
      Sl_rdWdAddr => plb_v46_0_Sl_rdWdAddr(8 to 11),
      Sl_rdDAck => plb_v46_0_Sl_rdDAck(2),
      Sl_rdComp => plb_v46_0_Sl_rdComp(2),
      Sl_rdBTerm => plb_v46_0_Sl_rdBTerm(2),
      Sl_MBusy => plb_v46_0_Sl_MBusy(16 to 23),
      Sl_MWrErr => plb_v46_0_Sl_MWrErr(16 to 23),
      Sl_MRdErr => plb_v46_0_Sl_MRdErr(16 to 23),
      Sl_MIRQ => plb_v46_0_Sl_MIRQ(16 to 23),
      IP2INTC_Irpt => open,
      GPIO_IO_I => fpga_0_LEDs_8Bit_GPIO_IO_I,
      GPIO_IO_O => fpga_0_LEDs_8Bit_GPIO_IO_O,
      GPIO_IO_T => fpga_0_LEDs_8Bit_GPIO_IO_T,
      GPIO_in => net_gnd8,
      GPIO_d_out => open,
      GPIO_t_out => open,
      GPIO2_IO_I => net_gnd8,
      GPIO2_IO_O => open,
      GPIO2_IO_T => open,
      GPIO2_in => net_gnd8,
      GPIO2_d_out => open,
      GPIO2_t_out => open
    );

  SRAM : sram_wrapper
    port map (
      MCH_PLB_Clk => sys_clk_s,
      RdClk => sys_clk_s,
      MCH_PLB_Rst => plb_v46_0_SPLB_Rst(3),
      MCH0_Access_Control => net_gnd0,
      MCH0_Access_Data => net_gnd32,
      MCH0_Access_Write => net_gnd0,
      MCH0_Access_Full => open,
      MCH0_ReadData_Control => open,
      MCH0_ReadData_Data => open,
      MCH0_ReadData_Read => net_gnd0,
      MCH0_ReadData_Exists => open,
      MCH1_Access_Control => net_gnd0,
      MCH1_Access_Data => net_gnd32,
      MCH1_Access_Write => net_gnd0,
      MCH1_Access_Full => open,
      MCH1_ReadData_Control => open,
      MCH1_ReadData_Data => open,
      MCH1_ReadData_Read => net_gnd0,
      MCH1_ReadData_Exists => open,
      MCH2_Access_Control => net_gnd0,
      MCH2_Access_Data => net_gnd32,
      MCH2_Access_Write => net_gnd0,
      MCH2_Access_Full => open,
      MCH2_ReadData_Control => open,
      MCH2_ReadData_Data => open,
      MCH2_ReadData_Read => net_gnd0,
      MCH2_ReadData_Exists => open,
      MCH3_Access_Control => net_gnd0,
      MCH3_Access_Data => net_gnd32,
      MCH3_Access_Write => net_gnd0,
      MCH3_Access_Full => open,
      MCH3_ReadData_Control => open,
      MCH3_ReadData_Data => open,
      MCH3_ReadData_Read => net_gnd0,
      MCH3_ReadData_Exists => open,
      PLB_ABus => plb_v46_0_PLB_ABus,
      PLB_UABus => plb_v46_0_PLB_UABus,
      PLB_PAValid => plb_v46_0_PLB_PAValid,
      PLB_SAValid => plb_v46_0_PLB_SAValid,
      PLB_rdPrim => plb_v46_0_PLB_rdPrim(3),
      PLB_wrPrim => plb_v46_0_PLB_wrPrim(3),
      PLB_masterID => plb_v46_0_PLB_masterID,
      PLB_abort => plb_v46_0_PLB_abort,
      PLB_busLock => plb_v46_0_PLB_busLock,
      PLB_RNW => plb_v46_0_PLB_RNW,
      PLB_BE => plb_v46_0_PLB_BE,
      PLB_MSize => plb_v46_0_PLB_MSize,
      PLB_size => plb_v46_0_PLB_size,
      PLB_type => plb_v46_0_PLB_type,
      PLB_lockErr => plb_v46_0_PLB_lockErr,
      PLB_wrDBus => plb_v46_0_PLB_wrDBus,
      PLB_wrBurst => plb_v46_0_PLB_wrBurst,
      PLB_rdBurst => plb_v46_0_PLB_rdBurst,
      PLB_wrPendReq => plb_v46_0_PLB_wrPendReq,
      PLB_rdPendReq => plb_v46_0_PLB_rdPendReq,
      PLB_wrPendPri => plb_v46_0_PLB_wrPendPri,
      PLB_rdPendPri => plb_v46_0_PLB_rdPendPri,
      PLB_reqPri => plb_v46_0_PLB_reqPri,
      PLB_TAttribute => plb_v46_0_PLB_TAttribute,
      Sl_addrAck => plb_v46_0_Sl_addrAck(3),
      Sl_SSize => plb_v46_0_Sl_SSize(6 to 7),
      Sl_wait => plb_v46_0_Sl_wait(3),
      Sl_rearbitrate => plb_v46_0_Sl_rearbitrate(3),
      Sl_wrDAck => plb_v46_0_Sl_wrDAck(3),
      Sl_wrComp => plb_v46_0_Sl_wrComp(3),
      Sl_wrBTerm => plb_v46_0_Sl_wrBTerm(3),
      Sl_rdDBus => plb_v46_0_Sl_rdDBus(384 to 511),
      Sl_rdWdAddr => plb_v46_0_Sl_rdWdAddr(12 to 15),
      Sl_rdDAck => plb_v46_0_Sl_rdDAck(3),
      Sl_rdComp => plb_v46_0_Sl_rdComp(3),
      Sl_rdBTerm => plb_v46_0_Sl_rdBTerm(3),
      Sl_MBusy => plb_v46_0_Sl_MBusy(24 to 31),
      Sl_MWrErr => plb_v46_0_Sl_MWrErr(24 to 31),
      Sl_MRdErr => plb_v46_0_Sl_MRdErr(24 to 31),
      Sl_MIRQ => plb_v46_0_Sl_MIRQ(24 to 31),
      Mem_DQ_I => fpga_0_SRAM_Mem_DQ_I,
      Mem_DQ_O => fpga_0_SRAM_Mem_DQ_O,
      Mem_DQ_T => fpga_0_SRAM_Mem_DQ_T,
      Mem_A => fpga_0_SRAM_Mem_A_split,
      Mem_RPN => open,
      Mem_CEN => fpga_0_SRAM_Mem_CEN(0 to 0),
      Mem_OEN => fpga_0_SRAM_Mem_OEN(0 to 0),
      Mem_WEN => fpga_0_SRAM_Mem_WEN,
      Mem_QWEN => open,
      Mem_BEN => fpga_0_SRAM_Mem_BEN,
      Mem_CE => open,
      Mem_ADV_LDN => fpga_0_SRAM_Mem_ADV_LDN,
      Mem_LBON => open,
      Mem_CKEN => open,
      Mem_RNW => open
    );

  DDR2_SDRAM : ddr2_sdram_wrapper
    port map (
      FSL0_M_Clk => net_vcc0,
      FSL0_M_Write => net_gnd0,
      FSL0_M_Data => net_gnd32,
      FSL0_M_Control => net_gnd0,
      FSL0_M_Full => open,
      FSL0_S_Clk => net_gnd0,
      FSL0_S_Read => net_gnd0,
      FSL0_S_Data => open,
      FSL0_S_Control => open,
      FSL0_S_Exists => open,
      SPLB0_Clk => net_vcc0,
      SPLB0_Rst => net_gnd0,
      SPLB0_PLB_ABus => net_gnd32,
      SPLB0_PLB_PAValid => net_gnd0,
      SPLB0_PLB_SAValid => net_gnd0,
      SPLB0_PLB_masterID => net_gnd1(0 to 0),
      SPLB0_PLB_RNW => net_gnd0,
      SPLB0_PLB_BE => net_gnd8,
      SPLB0_PLB_UABus => net_gnd32,
      SPLB0_PLB_rdPrim => net_gnd0,
      SPLB0_PLB_wrPrim => net_gnd0,
      SPLB0_PLB_abort => net_gnd0,
      SPLB0_PLB_busLock => net_gnd0,
      SPLB0_PLB_MSize => net_gnd2,
      SPLB0_PLB_size => net_gnd4,
      SPLB0_PLB_type => net_gnd3,
      SPLB0_PLB_lockErr => net_gnd0,
      SPLB0_PLB_wrPendReq => net_gnd0,
      SPLB0_PLB_wrPendPri => net_gnd2,
      SPLB0_PLB_rdPendReq => net_gnd0,
      SPLB0_PLB_rdPendPri => net_gnd2,
      SPLB0_PLB_reqPri => net_gnd2,
      SPLB0_PLB_TAttribute => net_gnd16,
      SPLB0_PLB_rdBurst => net_gnd0,
      SPLB0_PLB_wrBurst => net_gnd0,
      SPLB0_PLB_wrDBus => net_gnd64,
      SPLB0_Sl_addrAck => open,
      SPLB0_Sl_SSize => open,
      SPLB0_Sl_wait => open,
      SPLB0_Sl_rearbitrate => open,
      SPLB0_Sl_wrDAck => open,
      SPLB0_Sl_wrComp => open,
      SPLB0_Sl_wrBTerm => open,
      SPLB0_Sl_rdDBus => open,
      SPLB0_Sl_rdWdAddr => open,
      SPLB0_Sl_rdDAck => open,
      SPLB0_Sl_rdComp => open,
      SPLB0_Sl_rdBTerm => open,
      SPLB0_Sl_MBusy => open,
      SPLB0_Sl_MRdErr => open,
      SPLB0_Sl_MWrErr => open,
      SPLB0_Sl_MIRQ => open,
      SDMA0_Clk => net_gnd0,
      SDMA0_Rx_IntOut => open,
      SDMA0_Tx_IntOut => open,
      SDMA0_RstOut => open,
      SDMA0_TX_D => open,
      SDMA0_TX_Rem => open,
      SDMA0_TX_SOF => open,
      SDMA0_TX_EOF => open,
      SDMA0_TX_SOP => open,
      SDMA0_TX_EOP => open,
      SDMA0_TX_Src_Rdy => open,
      SDMA0_TX_Dst_Rdy => net_vcc0,
      SDMA0_RX_D => net_gnd32,
      SDMA0_RX_Rem => net_vcc4,
      SDMA0_RX_SOF => net_vcc0,
      SDMA0_RX_EOF => net_vcc0,
      SDMA0_RX_SOP => net_vcc0,
      SDMA0_RX_EOP => net_vcc0,
      SDMA0_RX_Src_Rdy => net_vcc0,
      SDMA0_RX_Dst_Rdy => open,
      SDMA_CTRL0_Clk => net_vcc0,
      SDMA_CTRL0_Rst => net_gnd0,
      SDMA_CTRL0_PLB_ABus => net_gnd32,
      SDMA_CTRL0_PLB_PAValid => net_gnd0,
      SDMA_CTRL0_PLB_SAValid => net_gnd0,
      SDMA_CTRL0_PLB_masterID => net_gnd1(0 to 0),
      SDMA_CTRL0_PLB_RNW => net_gnd0,
      SDMA_CTRL0_PLB_BE => net_gnd8,
      SDMA_CTRL0_PLB_UABus => net_gnd32,
      SDMA_CTRL0_PLB_rdPrim => net_gnd0,
      SDMA_CTRL0_PLB_wrPrim => net_gnd0,
      SDMA_CTRL0_PLB_abort => net_gnd0,
      SDMA_CTRL0_PLB_busLock => net_gnd0,
      SDMA_CTRL0_PLB_MSize => net_gnd2,
      SDMA_CTRL0_PLB_size => net_gnd4,
      SDMA_CTRL0_PLB_type => net_gnd3,
      SDMA_CTRL0_PLB_lockErr => net_gnd0,
      SDMA_CTRL0_PLB_wrPendReq => net_gnd0,
      SDMA_CTRL0_PLB_wrPendPri => net_gnd2,
      SDMA_CTRL0_PLB_rdPendReq => net_gnd0,
      SDMA_CTRL0_PLB_rdPendPri => net_gnd2,
      SDMA_CTRL0_PLB_reqPri => net_gnd2,
      SDMA_CTRL0_PLB_TAttribute => net_gnd16,
      SDMA_CTRL0_PLB_rdBurst => net_gnd0,
      SDMA_CTRL0_PLB_wrBurst => net_gnd0,
      SDMA_CTRL0_PLB_wrDBus => net_gnd64,
      SDMA_CTRL0_Sl_addrAck => open,
      SDMA_CTRL0_Sl_SSize => open,
      SDMA_CTRL0_Sl_wait => open,
      SDMA_CTRL0_Sl_rearbitrate => open,
      SDMA_CTRL0_Sl_wrDAck => open,
      SDMA_CTRL0_Sl_wrComp => open,
      SDMA_CTRL0_Sl_wrBTerm => open,
      SDMA_CTRL0_Sl_rdDBus => open,
      SDMA_CTRL0_Sl_rdWdAddr => open,
      SDMA_CTRL0_Sl_rdDAck => open,
      SDMA_CTRL0_Sl_rdComp => open,
      SDMA_CTRL0_Sl_rdBTerm => open,
      SDMA_CTRL0_Sl_MBusy => open,
      SDMA_CTRL0_Sl_MRdErr => open,
      SDMA_CTRL0_Sl_MWrErr => open,
      SDMA_CTRL0_Sl_MIRQ => open,
      PIM0_Addr => net_gnd32(0 to 31),
      PIM0_AddrReq => net_gnd0,
      PIM0_AddrAck => open,
      PIM0_RNW => net_gnd0,
      PIM0_Size => net_gnd4(0 to 3),
      PIM0_RdModWr => net_gnd0,
      PIM0_WrFIFO_Data => net_gnd64(0 to 63),
      PIM0_WrFIFO_BE => net_gnd8(0 to 7),
      PIM0_WrFIFO_Push => net_gnd0,
      PIM0_RdFIFO_Data => open,
      PIM0_RdFIFO_Pop => net_gnd0,
      PIM0_RdFIFO_RdWdAddr => open,
      PIM0_WrFIFO_Empty => open,
      PIM0_WrFIFO_AlmostFull => open,
      PIM0_WrFIFO_Flush => net_gnd0,
      PIM0_RdFIFO_Empty => open,
      PIM0_RdFIFO_Flush => net_gnd0,
      PIM0_RdFIFO_Latency => open,
      PIM0_InitDone => open,
      PPC440MC0_MIMCReadNotWrite => ppc440_0_PPC440MC0_MIMCREADNOTWRITE,
      PPC440MC0_MIMCAddress => ppc440_0_PPC440MC0_MIMCADDRESS,
      PPC440MC0_MIMCAddressValid => ppc440_0_PPC440MC0_MIMCADDRESSVALID,
      PPC440MC0_MIMCWriteData => ppc440_0_PPC440MC0_MIMCWRITEDATA,
      PPC440MC0_MIMCWriteDataValid => ppc440_0_PPC440MC0_MIMCWRITEDATAVALID,
      PPC440MC0_MIMCByteEnable => ppc440_0_PPC440MC0_MIMCBYTEENABLE,
      PPC440MC0_MIMCBankConflict => ppc440_0_PPC440MC0_MIMCBANKCONFLICT,
      PPC440MC0_MIMCRowConflict => ppc440_0_PPC440MC0_MIMCROWCONFLICT,
      PPC440MC0_MCMIReadData => ppc440_0_PPC440MC0_MCMIREADDATA,
      PPC440MC0_MCMIReadDataValid => ppc440_0_PPC440MC0_MCMIREADDATAVALID,
      PPC440MC0_MCMIReadDataErr => ppc440_0_PPC440MC0_MCMIREADDATAERR,
      PPC440MC0_MCMIAddrReadyToAccept => ppc440_0_PPC440MC0_MCMIADDRREADYTOACCEPT,
      VFBC0_Cmd_Clk => net_gnd0,
      VFBC0_Cmd_Reset => net_gnd0,
      VFBC0_Cmd_Data => net_gnd32(0 to 31),
      VFBC0_Cmd_Write => net_gnd0,
      VFBC0_Cmd_End => net_gnd0,
      VFBC0_Cmd_Full => open,
      VFBC0_Cmd_Almost_Full => open,
      VFBC0_Cmd_Idle => open,
      VFBC0_Wd_Clk => net_gnd0,
      VFBC0_Wd_Reset => net_gnd0,
      VFBC0_Wd_Write => net_gnd0,
      VFBC0_Wd_End_Burst => net_gnd0,
      VFBC0_Wd_Flush => net_gnd0,
      VFBC0_Wd_Data => net_gnd32(0 to 31),
      VFBC0_Wd_Data_BE => net_gnd4(0 to 3),
      VFBC0_Wd_Full => open,
      VFBC0_Wd_Almost_Full => open,
      VFBC0_Rd_Clk => net_gnd0,
      VFBC0_Rd_Reset => net_gnd0,
      VFBC0_Rd_Read => net_gnd0,
      VFBC0_Rd_End_Burst => net_gnd0,
      VFBC0_Rd_Flush => net_gnd0,
      VFBC0_Rd_Data => open,
      VFBC0_Rd_Empty => open,
      VFBC0_Rd_Almost_Empty => open,
      FSL1_M_Clk => microblaze_0_IXCL_FSL_M_Clk,
      FSL1_M_Write => microblaze_0_IXCL_FSL_M_Write,
      FSL1_M_Data => microblaze_0_IXCL_FSL_M_Data,
      FSL1_M_Control => microblaze_0_IXCL_FSL_M_Control,
      FSL1_M_Full => microblaze_0_IXCL_FSL_M_Full,
      FSL1_S_Clk => microblaze_0_IXCL_FSL_S_Clk,
      FSL1_S_Read => microblaze_0_IXCL_FSL_S_Read,
      FSL1_S_Data => microblaze_0_IXCL_FSL_S_Data,
      FSL1_S_Control => microblaze_0_IXCL_FSL_S_Control,
      FSL1_S_Exists => microblaze_0_IXCL_FSL_S_Exists,
      SPLB1_Clk => net_vcc0,
      SPLB1_Rst => net_gnd0,
      SPLB1_PLB_ABus => net_gnd32,
      SPLB1_PLB_PAValid => net_gnd0,
      SPLB1_PLB_SAValid => net_gnd0,
      SPLB1_PLB_masterID => net_gnd1(0 to 0),
      SPLB1_PLB_RNW => net_gnd0,
      SPLB1_PLB_BE => net_gnd8,
      SPLB1_PLB_UABus => net_gnd32,
      SPLB1_PLB_rdPrim => net_gnd0,
      SPLB1_PLB_wrPrim => net_gnd0,
      SPLB1_PLB_abort => net_gnd0,
      SPLB1_PLB_busLock => net_gnd0,
      SPLB1_PLB_MSize => net_gnd2,
      SPLB1_PLB_size => net_gnd4,
      SPLB1_PLB_type => net_gnd3,
      SPLB1_PLB_lockErr => net_gnd0,
      SPLB1_PLB_wrPendReq => net_gnd0,
      SPLB1_PLB_wrPendPri => net_gnd2,
      SPLB1_PLB_rdPendReq => net_gnd0,
      SPLB1_PLB_rdPendPri => net_gnd2,
      SPLB1_PLB_reqPri => net_gnd2,
      SPLB1_PLB_TAttribute => net_gnd16,
      SPLB1_PLB_rdBurst => net_gnd0,
      SPLB1_PLB_wrBurst => net_gnd0,
      SPLB1_PLB_wrDBus => net_gnd64,
      SPLB1_Sl_addrAck => open,
      SPLB1_Sl_SSize => open,
      SPLB1_Sl_wait => open,
      SPLB1_Sl_rearbitrate => open,
      SPLB1_Sl_wrDAck => open,
      SPLB1_Sl_wrComp => open,
      SPLB1_Sl_wrBTerm => open,
      SPLB1_Sl_rdDBus => open,
      SPLB1_Sl_rdWdAddr => open,
      SPLB1_Sl_rdDAck => open,
      SPLB1_Sl_rdComp => open,
      SPLB1_Sl_rdBTerm => open,
      SPLB1_Sl_MBusy => open,
      SPLB1_Sl_MRdErr => open,
      SPLB1_Sl_MWrErr => open,
      SPLB1_Sl_MIRQ => open,
      SDMA1_Clk => net_gnd0,
      SDMA1_Rx_IntOut => open,
      SDMA1_Tx_IntOut => open,
      SDMA1_RstOut => open,
      SDMA1_TX_D => open,
      SDMA1_TX_Rem => open,
      SDMA1_TX_SOF => open,
      SDMA1_TX_EOF => open,
      SDMA1_TX_SOP => open,
      SDMA1_TX_EOP => open,
      SDMA1_TX_Src_Rdy => open,
      SDMA1_TX_Dst_Rdy => net_vcc0,
      SDMA1_RX_D => net_gnd32,
      SDMA1_RX_Rem => net_vcc4,
      SDMA1_RX_SOF => net_vcc0,
      SDMA1_RX_EOF => net_vcc0,
      SDMA1_RX_SOP => net_vcc0,
      SDMA1_RX_EOP => net_vcc0,
      SDMA1_RX_Src_Rdy => net_vcc0,
      SDMA1_RX_Dst_Rdy => open,
      SDMA_CTRL1_Clk => net_vcc0,
      SDMA_CTRL1_Rst => net_gnd0,
      SDMA_CTRL1_PLB_ABus => net_gnd32,
      SDMA_CTRL1_PLB_PAValid => net_gnd0,
      SDMA_CTRL1_PLB_SAValid => net_gnd0,
      SDMA_CTRL1_PLB_masterID => net_gnd1(0 to 0),
      SDMA_CTRL1_PLB_RNW => net_gnd0,
      SDMA_CTRL1_PLB_BE => net_gnd8,
      SDMA_CTRL1_PLB_UABus => net_gnd32,
      SDMA_CTRL1_PLB_rdPrim => net_gnd0,
      SDMA_CTRL1_PLB_wrPrim => net_gnd0,
      SDMA_CTRL1_PLB_abort => net_gnd0,
      SDMA_CTRL1_PLB_busLock => net_gnd0,
      SDMA_CTRL1_PLB_MSize => net_gnd2,
      SDMA_CTRL1_PLB_size => net_gnd4,
      SDMA_CTRL1_PLB_type => net_gnd3,
      SDMA_CTRL1_PLB_lockErr => net_gnd0,
      SDMA_CTRL1_PLB_wrPendReq => net_gnd0,
      SDMA_CTRL1_PLB_wrPendPri => net_gnd2,
      SDMA_CTRL1_PLB_rdPendReq => net_gnd0,
      SDMA_CTRL1_PLB_rdPendPri => net_gnd2,
      SDMA_CTRL1_PLB_reqPri => net_gnd2,
      SDMA_CTRL1_PLB_TAttribute => net_gnd16,
      SDMA_CTRL1_PLB_rdBurst => net_gnd0,
      SDMA_CTRL1_PLB_wrBurst => net_gnd0,
      SDMA_CTRL1_PLB_wrDBus => net_gnd64,
      SDMA_CTRL1_Sl_addrAck => open,
      SDMA_CTRL1_Sl_SSize => open,
      SDMA_CTRL1_Sl_wait => open,
      SDMA_CTRL1_Sl_rearbitrate => open,
      SDMA_CTRL1_Sl_wrDAck => open,
      SDMA_CTRL1_Sl_wrComp => open,
      SDMA_CTRL1_Sl_wrBTerm => open,
      SDMA_CTRL1_Sl_rdDBus => open,
      SDMA_CTRL1_Sl_rdWdAddr => open,
      SDMA_CTRL1_Sl_rdDAck => open,
      SDMA_CTRL1_Sl_rdComp => open,
      SDMA_CTRL1_Sl_rdBTerm => open,
      SDMA_CTRL1_Sl_MBusy => open,
      SDMA_CTRL1_Sl_MRdErr => open,
      SDMA_CTRL1_Sl_MWrErr => open,
      SDMA_CTRL1_Sl_MIRQ => open,
      PIM1_Addr => net_gnd32(0 to 31),
      PIM1_AddrReq => net_gnd0,
      PIM1_AddrAck => open,
      PIM1_RNW => net_gnd0,
      PIM1_Size => net_gnd4(0 to 3),
      PIM1_RdModWr => net_gnd0,
      PIM1_WrFIFO_Data => net_gnd64(0 to 63),
      PIM1_WrFIFO_BE => net_gnd8(0 to 7),
      PIM1_WrFIFO_Push => net_gnd0,
      PIM1_RdFIFO_Data => open,
      PIM1_RdFIFO_Pop => net_gnd0,
      PIM1_RdFIFO_RdWdAddr => open,
      PIM1_WrFIFO_Empty => open,
      PIM1_WrFIFO_AlmostFull => open,
      PIM1_WrFIFO_Flush => net_gnd0,
      PIM1_RdFIFO_Empty => open,
      PIM1_RdFIFO_Flush => net_gnd0,
      PIM1_RdFIFO_Latency => open,
      PIM1_InitDone => open,
      PPC440MC1_MIMCReadNotWrite => net_gnd0,
      PPC440MC1_MIMCAddress => net_gnd36,
      PPC440MC1_MIMCAddressValid => net_gnd0,
      PPC440MC1_MIMCWriteData => net_gnd128,
      PPC440MC1_MIMCWriteDataValid => net_gnd0,
      PPC440MC1_MIMCByteEnable => net_gnd16,
      PPC440MC1_MIMCBankConflict => net_gnd0,
      PPC440MC1_MIMCRowConflict => net_gnd0,
      PPC440MC1_MCMIReadData => open,
      PPC440MC1_MCMIReadDataValid => open,
      PPC440MC1_MCMIReadDataErr => open,
      PPC440MC1_MCMIAddrReadyToAccept => open,
      VFBC1_Cmd_Clk => net_gnd0,
      VFBC1_Cmd_Reset => net_gnd0,
      VFBC1_Cmd_Data => net_gnd32(0 to 31),
      VFBC1_Cmd_Write => net_gnd0,
      VFBC1_Cmd_End => net_gnd0,
      VFBC1_Cmd_Full => open,
      VFBC1_Cmd_Almost_Full => open,
      VFBC1_Cmd_Idle => open,
      VFBC1_Wd_Clk => net_gnd0,
      VFBC1_Wd_Reset => net_gnd0,
      VFBC1_Wd_Write => net_gnd0,
      VFBC1_Wd_End_Burst => net_gnd0,
      VFBC1_Wd_Flush => net_gnd0,
      VFBC1_Wd_Data => net_gnd32(0 to 31),
      VFBC1_Wd_Data_BE => net_gnd4(0 to 3),
      VFBC1_Wd_Full => open,
      VFBC1_Wd_Almost_Full => open,
      VFBC1_Rd_Clk => net_gnd0,
      VFBC1_Rd_Reset => net_gnd0,
      VFBC1_Rd_Read => net_gnd0,
      VFBC1_Rd_End_Burst => net_gnd0,
      VFBC1_Rd_Flush => net_gnd0,
      VFBC1_Rd_Data => open,
      VFBC1_Rd_Empty => open,
      VFBC1_Rd_Almost_Empty => open,
      FSL2_M_Clk => microblaze_1_IXCL_FSL_M_Clk,
      FSL2_M_Write => microblaze_1_IXCL_FSL_M_Write,
      FSL2_M_Data => microblaze_1_IXCL_FSL_M_Data,
      FSL2_M_Control => microblaze_1_IXCL_FSL_M_Control,
      FSL2_M_Full => microblaze_1_IXCL_FSL_M_Full,
      FSL2_S_Clk => microblaze_1_IXCL_FSL_S_Clk,
      FSL2_S_Read => microblaze_1_IXCL_FSL_S_Read,
      FSL2_S_Data => microblaze_1_IXCL_FSL_S_Data,
      FSL2_S_Control => microblaze_1_IXCL_FSL_S_Control,
      FSL2_S_Exists => microblaze_1_IXCL_FSL_S_Exists,
      SPLB2_Clk => net_vcc0,
      SPLB2_Rst => net_gnd0,
      SPLB2_PLB_ABus => net_gnd32,
      SPLB2_PLB_PAValid => net_gnd0,
      SPLB2_PLB_SAValid => net_gnd0,
      SPLB2_PLB_masterID => net_gnd1(0 to 0),
      SPLB2_PLB_RNW => net_gnd0,
      SPLB2_PLB_BE => net_gnd8,
      SPLB2_PLB_UABus => net_gnd32,
      SPLB2_PLB_rdPrim => net_gnd0,
      SPLB2_PLB_wrPrim => net_gnd0,
      SPLB2_PLB_abort => net_gnd0,
      SPLB2_PLB_busLock => net_gnd0,
      SPLB2_PLB_MSize => net_gnd2,
      SPLB2_PLB_size => net_gnd4,
      SPLB2_PLB_type => net_gnd3,
      SPLB2_PLB_lockErr => net_gnd0,
      SPLB2_PLB_wrPendReq => net_gnd0,
      SPLB2_PLB_wrPendPri => net_gnd2,
      SPLB2_PLB_rdPendReq => net_gnd0,
      SPLB2_PLB_rdPendPri => net_gnd2,
      SPLB2_PLB_reqPri => net_gnd2,
      SPLB2_PLB_TAttribute => net_gnd16,
      SPLB2_PLB_rdBurst => net_gnd0,
      SPLB2_PLB_wrBurst => net_gnd0,
      SPLB2_PLB_wrDBus => net_gnd64,
      SPLB2_Sl_addrAck => open,
      SPLB2_Sl_SSize => open,
      SPLB2_Sl_wait => open,
      SPLB2_Sl_rearbitrate => open,
      SPLB2_Sl_wrDAck => open,
      SPLB2_Sl_wrComp => open,
      SPLB2_Sl_wrBTerm => open,
      SPLB2_Sl_rdDBus => open,
      SPLB2_Sl_rdWdAddr => open,
      SPLB2_Sl_rdDAck => open,
      SPLB2_Sl_rdComp => open,
      SPLB2_Sl_rdBTerm => open,
      SPLB2_Sl_MBusy => open,
      SPLB2_Sl_MRdErr => open,
      SPLB2_Sl_MWrErr => open,
      SPLB2_Sl_MIRQ => open,
      SDMA2_Clk => net_gnd0,
      SDMA2_Rx_IntOut => open,
      SDMA2_Tx_IntOut => open,
      SDMA2_RstOut => open,
      SDMA2_TX_D => open,
      SDMA2_TX_Rem => open,
      SDMA2_TX_SOF => open,
      SDMA2_TX_EOF => open,
      SDMA2_TX_SOP => open,
      SDMA2_TX_EOP => open,
      SDMA2_TX_Src_Rdy => open,
      SDMA2_TX_Dst_Rdy => net_vcc0,
      SDMA2_RX_D => net_gnd32,
      SDMA2_RX_Rem => net_vcc4,
      SDMA2_RX_SOF => net_vcc0,
      SDMA2_RX_EOF => net_vcc0,
      SDMA2_RX_SOP => net_vcc0,
      SDMA2_RX_EOP => net_vcc0,
      SDMA2_RX_Src_Rdy => net_vcc0,
      SDMA2_RX_Dst_Rdy => open,
      SDMA_CTRL2_Clk => net_vcc0,
      SDMA_CTRL2_Rst => net_gnd0,
      SDMA_CTRL2_PLB_ABus => net_gnd32,
      SDMA_CTRL2_PLB_PAValid => net_gnd0,
      SDMA_CTRL2_PLB_SAValid => net_gnd0,
      SDMA_CTRL2_PLB_masterID => net_gnd1(0 to 0),
      SDMA_CTRL2_PLB_RNW => net_gnd0,
      SDMA_CTRL2_PLB_BE => net_gnd8,
      SDMA_CTRL2_PLB_UABus => net_gnd32,
      SDMA_CTRL2_PLB_rdPrim => net_gnd0,
      SDMA_CTRL2_PLB_wrPrim => net_gnd0,
      SDMA_CTRL2_PLB_abort => net_gnd0,
      SDMA_CTRL2_PLB_busLock => net_gnd0,
      SDMA_CTRL2_PLB_MSize => net_gnd2,
      SDMA_CTRL2_PLB_size => net_gnd4,
      SDMA_CTRL2_PLB_type => net_gnd3,
      SDMA_CTRL2_PLB_lockErr => net_gnd0,
      SDMA_CTRL2_PLB_wrPendReq => net_gnd0,
      SDMA_CTRL2_PLB_wrPendPri => net_gnd2,
      SDMA_CTRL2_PLB_rdPendReq => net_gnd0,
      SDMA_CTRL2_PLB_rdPendPri => net_gnd2,
      SDMA_CTRL2_PLB_reqPri => net_gnd2,
      SDMA_CTRL2_PLB_TAttribute => net_gnd16,
      SDMA_CTRL2_PLB_rdBurst => net_gnd0,
      SDMA_CTRL2_PLB_wrBurst => net_gnd0,
      SDMA_CTRL2_PLB_wrDBus => net_gnd64,
      SDMA_CTRL2_Sl_addrAck => open,
      SDMA_CTRL2_Sl_SSize => open,
      SDMA_CTRL2_Sl_wait => open,
      SDMA_CTRL2_Sl_rearbitrate => open,
      SDMA_CTRL2_Sl_wrDAck => open,
      SDMA_CTRL2_Sl_wrComp => open,
      SDMA_CTRL2_Sl_wrBTerm => open,
      SDMA_CTRL2_Sl_rdDBus => open,
      SDMA_CTRL2_Sl_rdWdAddr => open,
      SDMA_CTRL2_Sl_rdDAck => open,
      SDMA_CTRL2_Sl_rdComp => open,
      SDMA_CTRL2_Sl_rdBTerm => open,
      SDMA_CTRL2_Sl_MBusy => open,
      SDMA_CTRL2_Sl_MRdErr => open,
      SDMA_CTRL2_Sl_MWrErr => open,
      SDMA_CTRL2_Sl_MIRQ => open,
      PIM2_Addr => net_gnd32(0 to 31),
      PIM2_AddrReq => net_gnd0,
      PIM2_AddrAck => open,
      PIM2_RNW => net_gnd0,
      PIM2_Size => net_gnd4(0 to 3),
      PIM2_RdModWr => net_gnd0,
      PIM2_WrFIFO_Data => net_gnd64(0 to 63),
      PIM2_WrFIFO_BE => net_gnd8(0 to 7),
      PIM2_WrFIFO_Push => net_gnd0,
      PIM2_RdFIFO_Data => open,
      PIM2_RdFIFO_Pop => net_gnd0,
      PIM2_RdFIFO_RdWdAddr => open,
      PIM2_WrFIFO_Empty => open,
      PIM2_WrFIFO_AlmostFull => open,
      PIM2_WrFIFO_Flush => net_gnd0,
      PIM2_RdFIFO_Empty => open,
      PIM2_RdFIFO_Flush => net_gnd0,
      PIM2_RdFIFO_Latency => open,
      PIM2_InitDone => open,
      PPC440MC2_MIMCReadNotWrite => net_gnd0,
      PPC440MC2_MIMCAddress => net_gnd36,
      PPC440MC2_MIMCAddressValid => net_gnd0,
      PPC440MC2_MIMCWriteData => net_gnd128,
      PPC440MC2_MIMCWriteDataValid => net_gnd0,
      PPC440MC2_MIMCByteEnable => net_gnd16,
      PPC440MC2_MIMCBankConflict => net_gnd0,
      PPC440MC2_MIMCRowConflict => net_gnd0,
      PPC440MC2_MCMIReadData => open,
      PPC440MC2_MCMIReadDataValid => open,
      PPC440MC2_MCMIReadDataErr => open,
      PPC440MC2_MCMIAddrReadyToAccept => open,
      VFBC2_Cmd_Clk => net_gnd0,
      VFBC2_Cmd_Reset => net_gnd0,
      VFBC2_Cmd_Data => net_gnd32(0 to 31),
      VFBC2_Cmd_Write => net_gnd0,
      VFBC2_Cmd_End => net_gnd0,
      VFBC2_Cmd_Full => open,
      VFBC2_Cmd_Almost_Full => open,
      VFBC2_Cmd_Idle => open,
      VFBC2_Wd_Clk => net_gnd0,
      VFBC2_Wd_Reset => net_gnd0,
      VFBC2_Wd_Write => net_gnd0,
      VFBC2_Wd_End_Burst => net_gnd0,
      VFBC2_Wd_Flush => net_gnd0,
      VFBC2_Wd_Data => net_gnd32(0 to 31),
      VFBC2_Wd_Data_BE => net_gnd4(0 to 3),
      VFBC2_Wd_Full => open,
      VFBC2_Wd_Almost_Full => open,
      VFBC2_Rd_Clk => net_gnd0,
      VFBC2_Rd_Reset => net_gnd0,
      VFBC2_Rd_Read => net_gnd0,
      VFBC2_Rd_End_Burst => net_gnd0,
      VFBC2_Rd_Flush => net_gnd0,
      VFBC2_Rd_Data => open,
      VFBC2_Rd_Empty => open,
      VFBC2_Rd_Almost_Empty => open,
      FSL3_M_Clk => microblaze_2_IXCL_FSL_M_Clk,
      FSL3_M_Write => microblaze_2_IXCL_FSL_M_Write,
      FSL3_M_Data => microblaze_2_IXCL_FSL_M_Data,
      FSL3_M_Control => microblaze_2_IXCL_FSL_M_Control,
      FSL3_M_Full => microblaze_2_IXCL_FSL_M_Full,
      FSL3_S_Clk => microblaze_2_IXCL_FSL_S_Clk,
      FSL3_S_Read => microblaze_2_IXCL_FSL_S_Read,
      FSL3_S_Data => microblaze_2_IXCL_FSL_S_Data,
      FSL3_S_Control => microblaze_2_IXCL_FSL_S_Control,
      FSL3_S_Exists => microblaze_2_IXCL_FSL_S_Exists,
      SPLB3_Clk => net_vcc0,
      SPLB3_Rst => net_gnd0,
      SPLB3_PLB_ABus => net_gnd32,
      SPLB3_PLB_PAValid => net_gnd0,
      SPLB3_PLB_SAValid => net_gnd0,
      SPLB3_PLB_masterID => net_gnd1(0 to 0),
      SPLB3_PLB_RNW => net_gnd0,
      SPLB3_PLB_BE => net_gnd8,
      SPLB3_PLB_UABus => net_gnd32,
      SPLB3_PLB_rdPrim => net_gnd0,
      SPLB3_PLB_wrPrim => net_gnd0,
      SPLB3_PLB_abort => net_gnd0,
      SPLB3_PLB_busLock => net_gnd0,
      SPLB3_PLB_MSize => net_gnd2,
      SPLB3_PLB_size => net_gnd4,
      SPLB3_PLB_type => net_gnd3,
      SPLB3_PLB_lockErr => net_gnd0,
      SPLB3_PLB_wrPendReq => net_gnd0,
      SPLB3_PLB_wrPendPri => net_gnd2,
      SPLB3_PLB_rdPendReq => net_gnd0,
      SPLB3_PLB_rdPendPri => net_gnd2,
      SPLB3_PLB_reqPri => net_gnd2,
      SPLB3_PLB_TAttribute => net_gnd16,
      SPLB3_PLB_rdBurst => net_gnd0,
      SPLB3_PLB_wrBurst => net_gnd0,
      SPLB3_PLB_wrDBus => net_gnd64,
      SPLB3_Sl_addrAck => open,
      SPLB3_Sl_SSize => open,
      SPLB3_Sl_wait => open,
      SPLB3_Sl_rearbitrate => open,
      SPLB3_Sl_wrDAck => open,
      SPLB3_Sl_wrComp => open,
      SPLB3_Sl_wrBTerm => open,
      SPLB3_Sl_rdDBus => open,
      SPLB3_Sl_rdWdAddr => open,
      SPLB3_Sl_rdDAck => open,
      SPLB3_Sl_rdComp => open,
      SPLB3_Sl_rdBTerm => open,
      SPLB3_Sl_MBusy => open,
      SPLB3_Sl_MRdErr => open,
      SPLB3_Sl_MWrErr => open,
      SPLB3_Sl_MIRQ => open,
      SDMA3_Clk => net_gnd0,
      SDMA3_Rx_IntOut => open,
      SDMA3_Tx_IntOut => open,
      SDMA3_RstOut => open,
      SDMA3_TX_D => open,
      SDMA3_TX_Rem => open,
      SDMA3_TX_SOF => open,
      SDMA3_TX_EOF => open,
      SDMA3_TX_SOP => open,
      SDMA3_TX_EOP => open,
      SDMA3_TX_Src_Rdy => open,
      SDMA3_TX_Dst_Rdy => net_vcc0,
      SDMA3_RX_D => net_gnd32,
      SDMA3_RX_Rem => net_vcc4,
      SDMA3_RX_SOF => net_vcc0,
      SDMA3_RX_EOF => net_vcc0,
      SDMA3_RX_SOP => net_vcc0,
      SDMA3_RX_EOP => net_vcc0,
      SDMA3_RX_Src_Rdy => net_vcc0,
      SDMA3_RX_Dst_Rdy => open,
      SDMA_CTRL3_Clk => net_vcc0,
      SDMA_CTRL3_Rst => net_gnd0,
      SDMA_CTRL3_PLB_ABus => net_gnd32,
      SDMA_CTRL3_PLB_PAValid => net_gnd0,
      SDMA_CTRL3_PLB_SAValid => net_gnd0,
      SDMA_CTRL3_PLB_masterID => net_gnd1(0 to 0),
      SDMA_CTRL3_PLB_RNW => net_gnd0,
      SDMA_CTRL3_PLB_BE => net_gnd8,
      SDMA_CTRL3_PLB_UABus => net_gnd32,
      SDMA_CTRL3_PLB_rdPrim => net_gnd0,
      SDMA_CTRL3_PLB_wrPrim => net_gnd0,
      SDMA_CTRL3_PLB_abort => net_gnd0,
      SDMA_CTRL3_PLB_busLock => net_gnd0,
      SDMA_CTRL3_PLB_MSize => net_gnd2,
      SDMA_CTRL3_PLB_size => net_gnd4,
      SDMA_CTRL3_PLB_type => net_gnd3,
      SDMA_CTRL3_PLB_lockErr => net_gnd0,
      SDMA_CTRL3_PLB_wrPendReq => net_gnd0,
      SDMA_CTRL3_PLB_wrPendPri => net_gnd2,
      SDMA_CTRL3_PLB_rdPendReq => net_gnd0,
      SDMA_CTRL3_PLB_rdPendPri => net_gnd2,
      SDMA_CTRL3_PLB_reqPri => net_gnd2,
      SDMA_CTRL3_PLB_TAttribute => net_gnd16,
      SDMA_CTRL3_PLB_rdBurst => net_gnd0,
      SDMA_CTRL3_PLB_wrBurst => net_gnd0,
      SDMA_CTRL3_PLB_wrDBus => net_gnd64,
      SDMA_CTRL3_Sl_addrAck => open,
      SDMA_CTRL3_Sl_SSize => open,
      SDMA_CTRL3_Sl_wait => open,
      SDMA_CTRL3_Sl_rearbitrate => open,
      SDMA_CTRL3_Sl_wrDAck => open,
      SDMA_CTRL3_Sl_wrComp => open,
      SDMA_CTRL3_Sl_wrBTerm => open,
      SDMA_CTRL3_Sl_rdDBus => open,
      SDMA_CTRL3_Sl_rdWdAddr => open,
      SDMA_CTRL3_Sl_rdDAck => open,
      SDMA_CTRL3_Sl_rdComp => open,
      SDMA_CTRL3_Sl_rdBTerm => open,
      SDMA_CTRL3_Sl_MBusy => open,
      SDMA_CTRL3_Sl_MRdErr => open,
      SDMA_CTRL3_Sl_MWrErr => open,
      SDMA_CTRL3_Sl_MIRQ => open,
      PIM3_Addr => net_gnd32(0 to 31),
      PIM3_AddrReq => net_gnd0,
      PIM3_AddrAck => open,
      PIM3_RNW => net_gnd0,
      PIM3_Size => net_gnd4(0 to 3),
      PIM3_RdModWr => net_gnd0,
      PIM3_WrFIFO_Data => net_gnd64(0 to 63),
      PIM3_WrFIFO_BE => net_gnd8(0 to 7),
      PIM3_WrFIFO_Push => net_gnd0,
      PIM3_RdFIFO_Data => open,
      PIM3_RdFIFO_Pop => net_gnd0,
      PIM3_RdFIFO_RdWdAddr => open,
      PIM3_WrFIFO_Empty => open,
      PIM3_WrFIFO_AlmostFull => open,
      PIM3_WrFIFO_Flush => net_gnd0,
      PIM3_RdFIFO_Empty => open,
      PIM3_RdFIFO_Flush => net_gnd0,
      PIM3_RdFIFO_Latency => open,
      PIM3_InitDone => open,
      PPC440MC3_MIMCReadNotWrite => net_gnd0,
      PPC440MC3_MIMCAddress => net_gnd36,
      PPC440MC3_MIMCAddressValid => net_gnd0,
      PPC440MC3_MIMCWriteData => net_gnd128,
      PPC440MC3_MIMCWriteDataValid => net_gnd0,
      PPC440MC3_MIMCByteEnable => net_gnd16,
      PPC440MC3_MIMCBankConflict => net_gnd0,
      PPC440MC3_MIMCRowConflict => net_gnd0,
      PPC440MC3_MCMIReadData => open,
      PPC440MC3_MCMIReadDataValid => open,
      PPC440MC3_MCMIReadDataErr => open,
      PPC440MC3_MCMIAddrReadyToAccept => open,
      VFBC3_Cmd_Clk => net_gnd0,
      VFBC3_Cmd_Reset => net_gnd0,
      VFBC3_Cmd_Data => net_gnd32(0 to 31),
      VFBC3_Cmd_Write => net_gnd0,
      VFBC3_Cmd_End => net_gnd0,
      VFBC3_Cmd_Full => open,
      VFBC3_Cmd_Almost_Full => open,
      VFBC3_Cmd_Idle => open,
      VFBC3_Wd_Clk => net_gnd0,
      VFBC3_Wd_Reset => net_gnd0,
      VFBC3_Wd_Write => net_gnd0,
      VFBC3_Wd_End_Burst => net_gnd0,
      VFBC3_Wd_Flush => net_gnd0,
      VFBC3_Wd_Data => net_gnd32(0 to 31),
      VFBC3_Wd_Data_BE => net_gnd4(0 to 3),
      VFBC3_Wd_Full => open,
      VFBC3_Wd_Almost_Full => open,
      VFBC3_Rd_Clk => net_gnd0,
      VFBC3_Rd_Reset => net_gnd0,
      VFBC3_Rd_Read => net_gnd0,
      VFBC3_Rd_End_Burst => net_gnd0,
      VFBC3_Rd_Flush => net_gnd0,
      VFBC3_Rd_Data => open,
      VFBC3_Rd_Empty => open,
      VFBC3_Rd_Almost_Empty => open,
      FSL4_M_Clk => microblaze_mb3_IXCL_FSL_M_Clk,
      FSL4_M_Write => microblaze_mb3_IXCL_FSL_M_Write,
      FSL4_M_Data => microblaze_mb3_IXCL_FSL_M_Data,
      FSL4_M_Control => microblaze_mb3_IXCL_FSL_M_Control,
      FSL4_M_Full => microblaze_mb3_IXCL_FSL_M_Full,
      FSL4_S_Clk => microblaze_mb3_IXCL_FSL_S_Clk,
      FSL4_S_Read => microblaze_mb3_IXCL_FSL_S_Read,
      FSL4_S_Data => microblaze_mb3_IXCL_FSL_S_Data,
      FSL4_S_Control => microblaze_mb3_IXCL_FSL_S_Control,
      FSL4_S_Exists => microblaze_mb3_IXCL_FSL_S_Exists,
      SPLB4_Clk => net_vcc0,
      SPLB4_Rst => net_gnd0,
      SPLB4_PLB_ABus => net_gnd32,
      SPLB4_PLB_PAValid => net_gnd0,
      SPLB4_PLB_SAValid => net_gnd0,
      SPLB4_PLB_masterID => net_gnd1(0 to 0),
      SPLB4_PLB_RNW => net_gnd0,
      SPLB4_PLB_BE => net_gnd8,
      SPLB4_PLB_UABus => net_gnd32,
      SPLB4_PLB_rdPrim => net_gnd0,
      SPLB4_PLB_wrPrim => net_gnd0,
      SPLB4_PLB_abort => net_gnd0,
      SPLB4_PLB_busLock => net_gnd0,
      SPLB4_PLB_MSize => net_gnd2,
      SPLB4_PLB_size => net_gnd4,
      SPLB4_PLB_type => net_gnd3,
      SPLB4_PLB_lockErr => net_gnd0,
      SPLB4_PLB_wrPendReq => net_gnd0,
      SPLB4_PLB_wrPendPri => net_gnd2,
      SPLB4_PLB_rdPendReq => net_gnd0,
      SPLB4_PLB_rdPendPri => net_gnd2,
      SPLB4_PLB_reqPri => net_gnd2,
      SPLB4_PLB_TAttribute => net_gnd16,
      SPLB4_PLB_rdBurst => net_gnd0,
      SPLB4_PLB_wrBurst => net_gnd0,
      SPLB4_PLB_wrDBus => net_gnd64,
      SPLB4_Sl_addrAck => open,
      SPLB4_Sl_SSize => open,
      SPLB4_Sl_wait => open,
      SPLB4_Sl_rearbitrate => open,
      SPLB4_Sl_wrDAck => open,
      SPLB4_Sl_wrComp => open,
      SPLB4_Sl_wrBTerm => open,
      SPLB4_Sl_rdDBus => open,
      SPLB4_Sl_rdWdAddr => open,
      SPLB4_Sl_rdDAck => open,
      SPLB4_Sl_rdComp => open,
      SPLB4_Sl_rdBTerm => open,
      SPLB4_Sl_MBusy => open,
      SPLB4_Sl_MRdErr => open,
      SPLB4_Sl_MWrErr => open,
      SPLB4_Sl_MIRQ => open,
      SDMA4_Clk => net_gnd0,
      SDMA4_Rx_IntOut => open,
      SDMA4_Tx_IntOut => open,
      SDMA4_RstOut => open,
      SDMA4_TX_D => open,
      SDMA4_TX_Rem => open,
      SDMA4_TX_SOF => open,
      SDMA4_TX_EOF => open,
      SDMA4_TX_SOP => open,
      SDMA4_TX_EOP => open,
      SDMA4_TX_Src_Rdy => open,
      SDMA4_TX_Dst_Rdy => net_vcc0,
      SDMA4_RX_D => net_gnd32,
      SDMA4_RX_Rem => net_vcc4,
      SDMA4_RX_SOF => net_vcc0,
      SDMA4_RX_EOF => net_vcc0,
      SDMA4_RX_SOP => net_vcc0,
      SDMA4_RX_EOP => net_vcc0,
      SDMA4_RX_Src_Rdy => net_vcc0,
      SDMA4_RX_Dst_Rdy => open,
      SDMA_CTRL4_Clk => net_vcc0,
      SDMA_CTRL4_Rst => net_gnd0,
      SDMA_CTRL4_PLB_ABus => net_gnd32,
      SDMA_CTRL4_PLB_PAValid => net_gnd0,
      SDMA_CTRL4_PLB_SAValid => net_gnd0,
      SDMA_CTRL4_PLB_masterID => net_gnd1(0 to 0),
      SDMA_CTRL4_PLB_RNW => net_gnd0,
      SDMA_CTRL4_PLB_BE => net_gnd8,
      SDMA_CTRL4_PLB_UABus => net_gnd32,
      SDMA_CTRL4_PLB_rdPrim => net_gnd0,
      SDMA_CTRL4_PLB_wrPrim => net_gnd0,
      SDMA_CTRL4_PLB_abort => net_gnd0,
      SDMA_CTRL4_PLB_busLock => net_gnd0,
      SDMA_CTRL4_PLB_MSize => net_gnd2,
      SDMA_CTRL4_PLB_size => net_gnd4,
      SDMA_CTRL4_PLB_type => net_gnd3,
      SDMA_CTRL4_PLB_lockErr => net_gnd0,
      SDMA_CTRL4_PLB_wrPendReq => net_gnd0,
      SDMA_CTRL4_PLB_wrPendPri => net_gnd2,
      SDMA_CTRL4_PLB_rdPendReq => net_gnd0,
      SDMA_CTRL4_PLB_rdPendPri => net_gnd2,
      SDMA_CTRL4_PLB_reqPri => net_gnd2,
      SDMA_CTRL4_PLB_TAttribute => net_gnd16,
      SDMA_CTRL4_PLB_rdBurst => net_gnd0,
      SDMA_CTRL4_PLB_wrBurst => net_gnd0,
      SDMA_CTRL4_PLB_wrDBus => net_gnd64,
      SDMA_CTRL4_Sl_addrAck => open,
      SDMA_CTRL4_Sl_SSize => open,
      SDMA_CTRL4_Sl_wait => open,
      SDMA_CTRL4_Sl_rearbitrate => open,
      SDMA_CTRL4_Sl_wrDAck => open,
      SDMA_CTRL4_Sl_wrComp => open,
      SDMA_CTRL4_Sl_wrBTerm => open,
      SDMA_CTRL4_Sl_rdDBus => open,
      SDMA_CTRL4_Sl_rdWdAddr => open,
      SDMA_CTRL4_Sl_rdDAck => open,
      SDMA_CTRL4_Sl_rdComp => open,
      SDMA_CTRL4_Sl_rdBTerm => open,
      SDMA_CTRL4_Sl_MBusy => open,
      SDMA_CTRL4_Sl_MRdErr => open,
      SDMA_CTRL4_Sl_MWrErr => open,
      SDMA_CTRL4_Sl_MIRQ => open,
      PIM4_Addr => net_gnd32(0 to 31),
      PIM4_AddrReq => net_gnd0,
      PIM4_AddrAck => open,
      PIM4_RNW => net_gnd0,
      PIM4_Size => net_gnd4(0 to 3),
      PIM4_RdModWr => net_gnd0,
      PIM4_WrFIFO_Data => net_gnd64(0 to 63),
      PIM4_WrFIFO_BE => net_gnd8(0 to 7),
      PIM4_WrFIFO_Push => net_gnd0,
      PIM4_RdFIFO_Data => open,
      PIM4_RdFIFO_Pop => net_gnd0,
      PIM4_RdFIFO_RdWdAddr => open,
      PIM4_WrFIFO_Empty => open,
      PIM4_WrFIFO_AlmostFull => open,
      PIM4_WrFIFO_Flush => net_gnd0,
      PIM4_RdFIFO_Empty => open,
      PIM4_RdFIFO_Flush => net_gnd0,
      PIM4_RdFIFO_Latency => open,
      PIM4_InitDone => open,
      PPC440MC4_MIMCReadNotWrite => net_gnd0,
      PPC440MC4_MIMCAddress => net_gnd36,
      PPC440MC4_MIMCAddressValid => net_gnd0,
      PPC440MC4_MIMCWriteData => net_gnd128,
      PPC440MC4_MIMCWriteDataValid => net_gnd0,
      PPC440MC4_MIMCByteEnable => net_gnd16,
      PPC440MC4_MIMCBankConflict => net_gnd0,
      PPC440MC4_MIMCRowConflict => net_gnd0,
      PPC440MC4_MCMIReadData => open,
      PPC440MC4_MCMIReadDataValid => open,
      PPC440MC4_MCMIReadDataErr => open,
      PPC440MC4_MCMIAddrReadyToAccept => open,
      VFBC4_Cmd_Clk => net_gnd0,
      VFBC4_Cmd_Reset => net_gnd0,
      VFBC4_Cmd_Data => net_gnd32(0 to 31),
      VFBC4_Cmd_Write => net_gnd0,
      VFBC4_Cmd_End => net_gnd0,
      VFBC4_Cmd_Full => open,
      VFBC4_Cmd_Almost_Full => open,
      VFBC4_Cmd_Idle => open,
      VFBC4_Wd_Clk => net_gnd0,
      VFBC4_Wd_Reset => net_gnd0,
      VFBC4_Wd_Write => net_gnd0,
      VFBC4_Wd_End_Burst => net_gnd0,
      VFBC4_Wd_Flush => net_gnd0,
      VFBC4_Wd_Data => net_gnd32(0 to 31),
      VFBC4_Wd_Data_BE => net_gnd4(0 to 3),
      VFBC4_Wd_Full => open,
      VFBC4_Wd_Almost_Full => open,
      VFBC4_Rd_Clk => net_gnd0,
      VFBC4_Rd_Reset => net_gnd0,
      VFBC4_Rd_Read => net_gnd0,
      VFBC4_Rd_End_Burst => net_gnd0,
      VFBC4_Rd_Flush => net_gnd0,
      VFBC4_Rd_Data => open,
      VFBC4_Rd_Empty => open,
      VFBC4_Rd_Almost_Empty => open,
      FSL5_M_Clk => microblaze_mb4_IXCL_FSL_M_Clk,
      FSL5_M_Write => microblaze_mb4_IXCL_FSL_M_Write,
      FSL5_M_Data => microblaze_mb4_IXCL_FSL_M_Data,
      FSL5_M_Control => microblaze_mb4_IXCL_FSL_M_Control,
      FSL5_M_Full => microblaze_mb4_IXCL_FSL_M_Full,
      FSL5_S_Clk => microblaze_mb4_IXCL_FSL_S_Clk,
      FSL5_S_Read => microblaze_mb4_IXCL_FSL_S_Read,
      FSL5_S_Data => microblaze_mb4_IXCL_FSL_S_Data,
      FSL5_S_Control => microblaze_mb4_IXCL_FSL_S_Control,
      FSL5_S_Exists => microblaze_mb4_IXCL_FSL_S_Exists,
      SPLB5_Clk => net_vcc0,
      SPLB5_Rst => net_gnd0,
      SPLB5_PLB_ABus => net_gnd32,
      SPLB5_PLB_PAValid => net_gnd0,
      SPLB5_PLB_SAValid => net_gnd0,
      SPLB5_PLB_masterID => net_gnd1(0 to 0),
      SPLB5_PLB_RNW => net_gnd0,
      SPLB5_PLB_BE => net_gnd8,
      SPLB5_PLB_UABus => net_gnd32,
      SPLB5_PLB_rdPrim => net_gnd0,
      SPLB5_PLB_wrPrim => net_gnd0,
      SPLB5_PLB_abort => net_gnd0,
      SPLB5_PLB_busLock => net_gnd0,
      SPLB5_PLB_MSize => net_gnd2,
      SPLB5_PLB_size => net_gnd4,
      SPLB5_PLB_type => net_gnd3,
      SPLB5_PLB_lockErr => net_gnd0,
      SPLB5_PLB_wrPendReq => net_gnd0,
      SPLB5_PLB_wrPendPri => net_gnd2,
      SPLB5_PLB_rdPendReq => net_gnd0,
      SPLB5_PLB_rdPendPri => net_gnd2,
      SPLB5_PLB_reqPri => net_gnd2,
      SPLB5_PLB_TAttribute => net_gnd16,
      SPLB5_PLB_rdBurst => net_gnd0,
      SPLB5_PLB_wrBurst => net_gnd0,
      SPLB5_PLB_wrDBus => net_gnd64,
      SPLB5_Sl_addrAck => open,
      SPLB5_Sl_SSize => open,
      SPLB5_Sl_wait => open,
      SPLB5_Sl_rearbitrate => open,
      SPLB5_Sl_wrDAck => open,
      SPLB5_Sl_wrComp => open,
      SPLB5_Sl_wrBTerm => open,
      SPLB5_Sl_rdDBus => open,
      SPLB5_Sl_rdWdAddr => open,
      SPLB5_Sl_rdDAck => open,
      SPLB5_Sl_rdComp => open,
      SPLB5_Sl_rdBTerm => open,
      SPLB5_Sl_MBusy => open,
      SPLB5_Sl_MRdErr => open,
      SPLB5_Sl_MWrErr => open,
      SPLB5_Sl_MIRQ => open,
      SDMA5_Clk => net_gnd0,
      SDMA5_Rx_IntOut => open,
      SDMA5_Tx_IntOut => open,
      SDMA5_RstOut => open,
      SDMA5_TX_D => open,
      SDMA5_TX_Rem => open,
      SDMA5_TX_SOF => open,
      SDMA5_TX_EOF => open,
      SDMA5_TX_SOP => open,
      SDMA5_TX_EOP => open,
      SDMA5_TX_Src_Rdy => open,
      SDMA5_TX_Dst_Rdy => net_vcc0,
      SDMA5_RX_D => net_gnd32,
      SDMA5_RX_Rem => net_vcc4,
      SDMA5_RX_SOF => net_vcc0,
      SDMA5_RX_EOF => net_vcc0,
      SDMA5_RX_SOP => net_vcc0,
      SDMA5_RX_EOP => net_vcc0,
      SDMA5_RX_Src_Rdy => net_vcc0,
      SDMA5_RX_Dst_Rdy => open,
      SDMA_CTRL5_Clk => net_vcc0,
      SDMA_CTRL5_Rst => net_gnd0,
      SDMA_CTRL5_PLB_ABus => net_gnd32,
      SDMA_CTRL5_PLB_PAValid => net_gnd0,
      SDMA_CTRL5_PLB_SAValid => net_gnd0,
      SDMA_CTRL5_PLB_masterID => net_gnd1(0 to 0),
      SDMA_CTRL5_PLB_RNW => net_gnd0,
      SDMA_CTRL5_PLB_BE => net_gnd8,
      SDMA_CTRL5_PLB_UABus => net_gnd32,
      SDMA_CTRL5_PLB_rdPrim => net_gnd0,
      SDMA_CTRL5_PLB_wrPrim => net_gnd0,
      SDMA_CTRL5_PLB_abort => net_gnd0,
      SDMA_CTRL5_PLB_busLock => net_gnd0,
      SDMA_CTRL5_PLB_MSize => net_gnd2,
      SDMA_CTRL5_PLB_size => net_gnd4,
      SDMA_CTRL5_PLB_type => net_gnd3,
      SDMA_CTRL5_PLB_lockErr => net_gnd0,
      SDMA_CTRL5_PLB_wrPendReq => net_gnd0,
      SDMA_CTRL5_PLB_wrPendPri => net_gnd2,
      SDMA_CTRL5_PLB_rdPendReq => net_gnd0,
      SDMA_CTRL5_PLB_rdPendPri => net_gnd2,
      SDMA_CTRL5_PLB_reqPri => net_gnd2,
      SDMA_CTRL5_PLB_TAttribute => net_gnd16,
      SDMA_CTRL5_PLB_rdBurst => net_gnd0,
      SDMA_CTRL5_PLB_wrBurst => net_gnd0,
      SDMA_CTRL5_PLB_wrDBus => net_gnd64,
      SDMA_CTRL5_Sl_addrAck => open,
      SDMA_CTRL5_Sl_SSize => open,
      SDMA_CTRL5_Sl_wait => open,
      SDMA_CTRL5_Sl_rearbitrate => open,
      SDMA_CTRL5_Sl_wrDAck => open,
      SDMA_CTRL5_Sl_wrComp => open,
      SDMA_CTRL5_Sl_wrBTerm => open,
      SDMA_CTRL5_Sl_rdDBus => open,
      SDMA_CTRL5_Sl_rdWdAddr => open,
      SDMA_CTRL5_Sl_rdDAck => open,
      SDMA_CTRL5_Sl_rdComp => open,
      SDMA_CTRL5_Sl_rdBTerm => open,
      SDMA_CTRL5_Sl_MBusy => open,
      SDMA_CTRL5_Sl_MRdErr => open,
      SDMA_CTRL5_Sl_MWrErr => open,
      SDMA_CTRL5_Sl_MIRQ => open,
      PIM5_Addr => net_gnd32(0 to 31),
      PIM5_AddrReq => net_gnd0,
      PIM5_AddrAck => open,
      PIM5_RNW => net_gnd0,
      PIM5_Size => net_gnd4(0 to 3),
      PIM5_RdModWr => net_gnd0,
      PIM5_WrFIFO_Data => net_gnd64(0 to 63),
      PIM5_WrFIFO_BE => net_gnd8(0 to 7),
      PIM5_WrFIFO_Push => net_gnd0,
      PIM5_RdFIFO_Data => open,
      PIM5_RdFIFO_Pop => net_gnd0,
      PIM5_RdFIFO_RdWdAddr => open,
      PIM5_WrFIFO_Empty => open,
      PIM5_WrFIFO_AlmostFull => open,
      PIM5_WrFIFO_Flush => net_gnd0,
      PIM5_RdFIFO_Empty => open,
      PIM5_RdFIFO_Flush => net_gnd0,
      PIM5_RdFIFO_Latency => open,
      PIM5_InitDone => open,
      PPC440MC5_MIMCReadNotWrite => net_gnd0,
      PPC440MC5_MIMCAddress => net_gnd36,
      PPC440MC5_MIMCAddressValid => net_gnd0,
      PPC440MC5_MIMCWriteData => net_gnd128,
      PPC440MC5_MIMCWriteDataValid => net_gnd0,
      PPC440MC5_MIMCByteEnable => net_gnd16,
      PPC440MC5_MIMCBankConflict => net_gnd0,
      PPC440MC5_MIMCRowConflict => net_gnd0,
      PPC440MC5_MCMIReadData => open,
      PPC440MC5_MCMIReadDataValid => open,
      PPC440MC5_MCMIReadDataErr => open,
      PPC440MC5_MCMIAddrReadyToAccept => open,
      VFBC5_Cmd_Clk => net_gnd0,
      VFBC5_Cmd_Reset => net_gnd0,
      VFBC5_Cmd_Data => net_gnd32(0 to 31),
      VFBC5_Cmd_Write => net_gnd0,
      VFBC5_Cmd_End => net_gnd0,
      VFBC5_Cmd_Full => open,
      VFBC5_Cmd_Almost_Full => open,
      VFBC5_Cmd_Idle => open,
      VFBC5_Wd_Clk => net_gnd0,
      VFBC5_Wd_Reset => net_gnd0,
      VFBC5_Wd_Write => net_gnd0,
      VFBC5_Wd_End_Burst => net_gnd0,
      VFBC5_Wd_Flush => net_gnd0,
      VFBC5_Wd_Data => net_gnd32(0 to 31),
      VFBC5_Wd_Data_BE => net_gnd4(0 to 3),
      VFBC5_Wd_Full => open,
      VFBC5_Wd_Almost_Full => open,
      VFBC5_Rd_Clk => net_gnd0,
      VFBC5_Rd_Reset => net_gnd0,
      VFBC5_Rd_Read => net_gnd0,
      VFBC5_Rd_End_Burst => net_gnd0,
      VFBC5_Rd_Flush => net_gnd0,
      VFBC5_Rd_Data => open,
      VFBC5_Rd_Empty => open,
      VFBC5_Rd_Almost_Empty => open,
      FSL6_M_Clk => microblaze_mb5_IXCL_FSL_M_Clk,
      FSL6_M_Write => microblaze_mb5_IXCL_FSL_M_Write,
      FSL6_M_Data => microblaze_mb5_IXCL_FSL_M_Data,
      FSL6_M_Control => microblaze_mb5_IXCL_FSL_M_Control,
      FSL6_M_Full => microblaze_mb5_IXCL_FSL_M_Full,
      FSL6_S_Clk => microblaze_mb5_IXCL_FSL_S_Clk,
      FSL6_S_Read => microblaze_mb5_IXCL_FSL_S_Read,
      FSL6_S_Data => microblaze_mb5_IXCL_FSL_S_Data,
      FSL6_S_Control => microblaze_mb5_IXCL_FSL_S_Control,
      FSL6_S_Exists => microblaze_mb5_IXCL_FSL_S_Exists,
      SPLB6_Clk => net_vcc0,
      SPLB6_Rst => net_gnd0,
      SPLB6_PLB_ABus => net_gnd32,
      SPLB6_PLB_PAValid => net_gnd0,
      SPLB6_PLB_SAValid => net_gnd0,
      SPLB6_PLB_masterID => net_gnd1(0 to 0),
      SPLB6_PLB_RNW => net_gnd0,
      SPLB6_PLB_BE => net_gnd8,
      SPLB6_PLB_UABus => net_gnd32,
      SPLB6_PLB_rdPrim => net_gnd0,
      SPLB6_PLB_wrPrim => net_gnd0,
      SPLB6_PLB_abort => net_gnd0,
      SPLB6_PLB_busLock => net_gnd0,
      SPLB6_PLB_MSize => net_gnd2,
      SPLB6_PLB_size => net_gnd4,
      SPLB6_PLB_type => net_gnd3,
      SPLB6_PLB_lockErr => net_gnd0,
      SPLB6_PLB_wrPendReq => net_gnd0,
      SPLB6_PLB_wrPendPri => net_gnd2,
      SPLB6_PLB_rdPendReq => net_gnd0,
      SPLB6_PLB_rdPendPri => net_gnd2,
      SPLB6_PLB_reqPri => net_gnd2,
      SPLB6_PLB_TAttribute => net_gnd16,
      SPLB6_PLB_rdBurst => net_gnd0,
      SPLB6_PLB_wrBurst => net_gnd0,
      SPLB6_PLB_wrDBus => net_gnd64,
      SPLB6_Sl_addrAck => open,
      SPLB6_Sl_SSize => open,
      SPLB6_Sl_wait => open,
      SPLB6_Sl_rearbitrate => open,
      SPLB6_Sl_wrDAck => open,
      SPLB6_Sl_wrComp => open,
      SPLB6_Sl_wrBTerm => open,
      SPLB6_Sl_rdDBus => open,
      SPLB6_Sl_rdWdAddr => open,
      SPLB6_Sl_rdDAck => open,
      SPLB6_Sl_rdComp => open,
      SPLB6_Sl_rdBTerm => open,
      SPLB6_Sl_MBusy => open,
      SPLB6_Sl_MRdErr => open,
      SPLB6_Sl_MWrErr => open,
      SPLB6_Sl_MIRQ => open,
      SDMA6_Clk => net_gnd0,
      SDMA6_Rx_IntOut => open,
      SDMA6_Tx_IntOut => open,
      SDMA6_RstOut => open,
      SDMA6_TX_D => open,
      SDMA6_TX_Rem => open,
      SDMA6_TX_SOF => open,
      SDMA6_TX_EOF => open,
      SDMA6_TX_SOP => open,
      SDMA6_TX_EOP => open,
      SDMA6_TX_Src_Rdy => open,
      SDMA6_TX_Dst_Rdy => net_vcc0,
      SDMA6_RX_D => net_gnd32,
      SDMA6_RX_Rem => net_vcc4,
      SDMA6_RX_SOF => net_vcc0,
      SDMA6_RX_EOF => net_vcc0,
      SDMA6_RX_SOP => net_vcc0,
      SDMA6_RX_EOP => net_vcc0,
      SDMA6_RX_Src_Rdy => net_vcc0,
      SDMA6_RX_Dst_Rdy => open,
      SDMA_CTRL6_Clk => net_vcc0,
      SDMA_CTRL6_Rst => net_gnd0,
      SDMA_CTRL6_PLB_ABus => net_gnd32,
      SDMA_CTRL6_PLB_PAValid => net_gnd0,
      SDMA_CTRL6_PLB_SAValid => net_gnd0,
      SDMA_CTRL6_PLB_masterID => net_gnd1(0 to 0),
      SDMA_CTRL6_PLB_RNW => net_gnd0,
      SDMA_CTRL6_PLB_BE => net_gnd8,
      SDMA_CTRL6_PLB_UABus => net_gnd32,
      SDMA_CTRL6_PLB_rdPrim => net_gnd0,
      SDMA_CTRL6_PLB_wrPrim => net_gnd0,
      SDMA_CTRL6_PLB_abort => net_gnd0,
      SDMA_CTRL6_PLB_busLock => net_gnd0,
      SDMA_CTRL6_PLB_MSize => net_gnd2,
      SDMA_CTRL6_PLB_size => net_gnd4,
      SDMA_CTRL6_PLB_type => net_gnd3,
      SDMA_CTRL6_PLB_lockErr => net_gnd0,
      SDMA_CTRL6_PLB_wrPendReq => net_gnd0,
      SDMA_CTRL6_PLB_wrPendPri => net_gnd2,
      SDMA_CTRL6_PLB_rdPendReq => net_gnd0,
      SDMA_CTRL6_PLB_rdPendPri => net_gnd2,
      SDMA_CTRL6_PLB_reqPri => net_gnd2,
      SDMA_CTRL6_PLB_TAttribute => net_gnd16,
      SDMA_CTRL6_PLB_rdBurst => net_gnd0,
      SDMA_CTRL6_PLB_wrBurst => net_gnd0,
      SDMA_CTRL6_PLB_wrDBus => net_gnd64,
      SDMA_CTRL6_Sl_addrAck => open,
      SDMA_CTRL6_Sl_SSize => open,
      SDMA_CTRL6_Sl_wait => open,
      SDMA_CTRL6_Sl_rearbitrate => open,
      SDMA_CTRL6_Sl_wrDAck => open,
      SDMA_CTRL6_Sl_wrComp => open,
      SDMA_CTRL6_Sl_wrBTerm => open,
      SDMA_CTRL6_Sl_rdDBus => open,
      SDMA_CTRL6_Sl_rdWdAddr => open,
      SDMA_CTRL6_Sl_rdDAck => open,
      SDMA_CTRL6_Sl_rdComp => open,
      SDMA_CTRL6_Sl_rdBTerm => open,
      SDMA_CTRL6_Sl_MBusy => open,
      SDMA_CTRL6_Sl_MRdErr => open,
      SDMA_CTRL6_Sl_MWrErr => open,
      SDMA_CTRL6_Sl_MIRQ => open,
      PIM6_Addr => net_gnd32(0 to 31),
      PIM6_AddrReq => net_gnd0,
      PIM6_AddrAck => open,
      PIM6_RNW => net_gnd0,
      PIM6_Size => net_gnd4(0 to 3),
      PIM6_RdModWr => net_gnd0,
      PIM6_WrFIFO_Data => net_gnd64(0 to 63),
      PIM6_WrFIFO_BE => net_gnd8(0 to 7),
      PIM6_WrFIFO_Push => net_gnd0,
      PIM6_RdFIFO_Data => open,
      PIM6_RdFIFO_Pop => net_gnd0,
      PIM6_RdFIFO_RdWdAddr => open,
      PIM6_WrFIFO_Empty => open,
      PIM6_WrFIFO_AlmostFull => open,
      PIM6_WrFIFO_Flush => net_gnd0,
      PIM6_RdFIFO_Empty => open,
      PIM6_RdFIFO_Flush => net_gnd0,
      PIM6_RdFIFO_Latency => open,
      PIM6_InitDone => open,
      PPC440MC6_MIMCReadNotWrite => net_gnd0,
      PPC440MC6_MIMCAddress => net_gnd36,
      PPC440MC6_MIMCAddressValid => net_gnd0,
      PPC440MC6_MIMCWriteData => net_gnd128,
      PPC440MC6_MIMCWriteDataValid => net_gnd0,
      PPC440MC6_MIMCByteEnable => net_gnd16,
      PPC440MC6_MIMCBankConflict => net_gnd0,
      PPC440MC6_MIMCRowConflict => net_gnd0,
      PPC440MC6_MCMIReadData => open,
      PPC440MC6_MCMIReadDataValid => open,
      PPC440MC6_MCMIReadDataErr => open,
      PPC440MC6_MCMIAddrReadyToAccept => open,
      VFBC6_Cmd_Clk => net_gnd0,
      VFBC6_Cmd_Reset => net_gnd0,
      VFBC6_Cmd_Data => net_gnd32(0 to 31),
      VFBC6_Cmd_Write => net_gnd0,
      VFBC6_Cmd_End => net_gnd0,
      VFBC6_Cmd_Full => open,
      VFBC6_Cmd_Almost_Full => open,
      VFBC6_Cmd_Idle => open,
      VFBC6_Wd_Clk => net_gnd0,
      VFBC6_Wd_Reset => net_gnd0,
      VFBC6_Wd_Write => net_gnd0,
      VFBC6_Wd_End_Burst => net_gnd0,
      VFBC6_Wd_Flush => net_gnd0,
      VFBC6_Wd_Data => net_gnd32(0 to 31),
      VFBC6_Wd_Data_BE => net_gnd4(0 to 3),
      VFBC6_Wd_Full => open,
      VFBC6_Wd_Almost_Full => open,
      VFBC6_Rd_Clk => net_gnd0,
      VFBC6_Rd_Reset => net_gnd0,
      VFBC6_Rd_Read => net_gnd0,
      VFBC6_Rd_End_Burst => net_gnd0,
      VFBC6_Rd_Flush => net_gnd0,
      VFBC6_Rd_Data => open,
      VFBC6_Rd_Empty => open,
      VFBC6_Rd_Almost_Empty => open,
      FSL7_M_Clk => net_vcc0,
      FSL7_M_Write => net_gnd0,
      FSL7_M_Data => net_gnd32,
      FSL7_M_Control => net_gnd0,
      FSL7_M_Full => open,
      FSL7_S_Clk => net_gnd0,
      FSL7_S_Read => net_gnd0,
      FSL7_S_Data => open,
      FSL7_S_Control => open,
      FSL7_S_Exists => open,
      SPLB7_Clk => sys_clk_s,
      SPLB7_Rst => plb_v46_0_SPLB_Rst(4),
      SPLB7_PLB_ABus => plb_v46_0_PLB_ABus,
      SPLB7_PLB_PAValid => plb_v46_0_PLB_PAValid,
      SPLB7_PLB_SAValid => plb_v46_0_PLB_SAValid,
      SPLB7_PLB_masterID => plb_v46_0_PLB_masterID,
      SPLB7_PLB_RNW => plb_v46_0_PLB_RNW,
      SPLB7_PLB_BE => plb_v46_0_PLB_BE,
      SPLB7_PLB_UABus => plb_v46_0_PLB_UABus,
      SPLB7_PLB_rdPrim => plb_v46_0_PLB_rdPrim(4),
      SPLB7_PLB_wrPrim => plb_v46_0_PLB_wrPrim(4),
      SPLB7_PLB_abort => plb_v46_0_PLB_abort,
      SPLB7_PLB_busLock => plb_v46_0_PLB_busLock,
      SPLB7_PLB_MSize => plb_v46_0_PLB_MSize,
      SPLB7_PLB_size => plb_v46_0_PLB_size,
      SPLB7_PLB_type => plb_v46_0_PLB_type,
      SPLB7_PLB_lockErr => plb_v46_0_PLB_lockErr,
      SPLB7_PLB_wrPendReq => plb_v46_0_PLB_wrPendReq,
      SPLB7_PLB_wrPendPri => plb_v46_0_PLB_wrPendPri,
      SPLB7_PLB_rdPendReq => plb_v46_0_PLB_rdPendReq,
      SPLB7_PLB_rdPendPri => plb_v46_0_PLB_rdPendPri,
      SPLB7_PLB_reqPri => plb_v46_0_PLB_reqPri,
      SPLB7_PLB_TAttribute => plb_v46_0_PLB_TAttribute,
      SPLB7_PLB_rdBurst => plb_v46_0_PLB_rdBurst,
      SPLB7_PLB_wrBurst => plb_v46_0_PLB_wrBurst,
      SPLB7_PLB_wrDBus => plb_v46_0_PLB_wrDBus,
      SPLB7_Sl_addrAck => plb_v46_0_Sl_addrAck(4),
      SPLB7_Sl_SSize => plb_v46_0_Sl_SSize(8 to 9),
      SPLB7_Sl_wait => plb_v46_0_Sl_wait(4),
      SPLB7_Sl_rearbitrate => plb_v46_0_Sl_rearbitrate(4),
      SPLB7_Sl_wrDAck => plb_v46_0_Sl_wrDAck(4),
      SPLB7_Sl_wrComp => plb_v46_0_Sl_wrComp(4),
      SPLB7_Sl_wrBTerm => plb_v46_0_Sl_wrBTerm(4),
      SPLB7_Sl_rdDBus => plb_v46_0_Sl_rdDBus(512 to 639),
      SPLB7_Sl_rdWdAddr => plb_v46_0_Sl_rdWdAddr(16 to 19),
      SPLB7_Sl_rdDAck => plb_v46_0_Sl_rdDAck(4),
      SPLB7_Sl_rdComp => plb_v46_0_Sl_rdComp(4),
      SPLB7_Sl_rdBTerm => plb_v46_0_Sl_rdBTerm(4),
      SPLB7_Sl_MBusy => plb_v46_0_Sl_MBusy(32 to 39),
      SPLB7_Sl_MRdErr => plb_v46_0_Sl_MRdErr(32 to 39),
      SPLB7_Sl_MWrErr => plb_v46_0_Sl_MWrErr(32 to 39),
      SPLB7_Sl_MIRQ => plb_v46_0_Sl_MIRQ(32 to 39),
      SDMA7_Clk => net_gnd0,
      SDMA7_Rx_IntOut => open,
      SDMA7_Tx_IntOut => open,
      SDMA7_RstOut => open,
      SDMA7_TX_D => open,
      SDMA7_TX_Rem => open,
      SDMA7_TX_SOF => open,
      SDMA7_TX_EOF => open,
      SDMA7_TX_SOP => open,
      SDMA7_TX_EOP => open,
      SDMA7_TX_Src_Rdy => open,
      SDMA7_TX_Dst_Rdy => net_vcc0,
      SDMA7_RX_D => net_gnd32,
      SDMA7_RX_Rem => net_vcc4,
      SDMA7_RX_SOF => net_vcc0,
      SDMA7_RX_EOF => net_vcc0,
      SDMA7_RX_SOP => net_vcc0,
      SDMA7_RX_EOP => net_vcc0,
      SDMA7_RX_Src_Rdy => net_vcc0,
      SDMA7_RX_Dst_Rdy => open,
      SDMA_CTRL7_Clk => net_vcc0,
      SDMA_CTRL7_Rst => net_gnd0,
      SDMA_CTRL7_PLB_ABus => net_gnd32,
      SDMA_CTRL7_PLB_PAValid => net_gnd0,
      SDMA_CTRL7_PLB_SAValid => net_gnd0,
      SDMA_CTRL7_PLB_masterID => net_gnd1(0 to 0),
      SDMA_CTRL7_PLB_RNW => net_gnd0,
      SDMA_CTRL7_PLB_BE => net_gnd8,
      SDMA_CTRL7_PLB_UABus => net_gnd32,
      SDMA_CTRL7_PLB_rdPrim => net_gnd0,
      SDMA_CTRL7_PLB_wrPrim => net_gnd0,
      SDMA_CTRL7_PLB_abort => net_gnd0,
      SDMA_CTRL7_PLB_busLock => net_gnd0,
      SDMA_CTRL7_PLB_MSize => net_gnd2,
      SDMA_CTRL7_PLB_size => net_gnd4,
      SDMA_CTRL7_PLB_type => net_gnd3,
      SDMA_CTRL7_PLB_lockErr => net_gnd0,
      SDMA_CTRL7_PLB_wrPendReq => net_gnd0,
      SDMA_CTRL7_PLB_wrPendPri => net_gnd2,
      SDMA_CTRL7_PLB_rdPendReq => net_gnd0,
      SDMA_CTRL7_PLB_rdPendPri => net_gnd2,
      SDMA_CTRL7_PLB_reqPri => net_gnd2,
      SDMA_CTRL7_PLB_TAttribute => net_gnd16,
      SDMA_CTRL7_PLB_rdBurst => net_gnd0,
      SDMA_CTRL7_PLB_wrBurst => net_gnd0,
      SDMA_CTRL7_PLB_wrDBus => net_gnd64,
      SDMA_CTRL7_Sl_addrAck => open,
      SDMA_CTRL7_Sl_SSize => open,
      SDMA_CTRL7_Sl_wait => open,
      SDMA_CTRL7_Sl_rearbitrate => open,
      SDMA_CTRL7_Sl_wrDAck => open,
      SDMA_CTRL7_Sl_wrComp => open,
      SDMA_CTRL7_Sl_wrBTerm => open,
      SDMA_CTRL7_Sl_rdDBus => open,
      SDMA_CTRL7_Sl_rdWdAddr => open,
      SDMA_CTRL7_Sl_rdDAck => open,
      SDMA_CTRL7_Sl_rdComp => open,
      SDMA_CTRL7_Sl_rdBTerm => open,
      SDMA_CTRL7_Sl_MBusy => open,
      SDMA_CTRL7_Sl_MRdErr => open,
      SDMA_CTRL7_Sl_MWrErr => open,
      SDMA_CTRL7_Sl_MIRQ => open,
      PIM7_Addr => net_gnd32(0 to 31),
      PIM7_AddrReq => net_gnd0,
      PIM7_AddrAck => open,
      PIM7_RNW => net_gnd0,
      PIM7_Size => net_gnd4(0 to 3),
      PIM7_RdModWr => net_gnd0,
      PIM7_WrFIFO_Data => net_gnd64(0 to 63),
      PIM7_WrFIFO_BE => net_gnd8(0 to 7),
      PIM7_WrFIFO_Push => net_gnd0,
      PIM7_RdFIFO_Data => open,
      PIM7_RdFIFO_Pop => net_gnd0,
      PIM7_RdFIFO_RdWdAddr => open,
      PIM7_WrFIFO_Empty => open,
      PIM7_WrFIFO_AlmostFull => open,
      PIM7_WrFIFO_Flush => net_gnd0,
      PIM7_RdFIFO_Empty => open,
      PIM7_RdFIFO_Flush => net_gnd0,
      PIM7_RdFIFO_Latency => open,
      PIM7_InitDone => open,
      PPC440MC7_MIMCReadNotWrite => net_gnd0,
      PPC440MC7_MIMCAddress => net_gnd36,
      PPC440MC7_MIMCAddressValid => net_gnd0,
      PPC440MC7_MIMCWriteData => net_gnd128,
      PPC440MC7_MIMCWriteDataValid => net_gnd0,
      PPC440MC7_MIMCByteEnable => net_gnd16,
      PPC440MC7_MIMCBankConflict => net_gnd0,
      PPC440MC7_MIMCRowConflict => net_gnd0,
      PPC440MC7_MCMIReadData => open,
      PPC440MC7_MCMIReadDataValid => open,
      PPC440MC7_MCMIReadDataErr => open,
      PPC440MC7_MCMIAddrReadyToAccept => open,
      VFBC7_Cmd_Clk => net_gnd0,
      VFBC7_Cmd_Reset => net_gnd0,
      VFBC7_Cmd_Data => net_gnd32(0 to 31),
      VFBC7_Cmd_Write => net_gnd0,
      VFBC7_Cmd_End => net_gnd0,
      VFBC7_Cmd_Full => open,
      VFBC7_Cmd_Almost_Full => open,
      VFBC7_Cmd_Idle => open,
      VFBC7_Wd_Clk => net_gnd0,
      VFBC7_Wd_Reset => net_gnd0,
      VFBC7_Wd_Write => net_gnd0,
      VFBC7_Wd_End_Burst => net_gnd0,
      VFBC7_Wd_Flush => net_gnd0,
      VFBC7_Wd_Data => net_gnd32(0 to 31),
      VFBC7_Wd_Data_BE => net_gnd4(0 to 3),
      VFBC7_Wd_Full => open,
      VFBC7_Wd_Almost_Full => open,
      VFBC7_Rd_Clk => net_gnd0,
      VFBC7_Rd_Reset => net_gnd0,
      VFBC7_Rd_Read => net_gnd0,
      VFBC7_Rd_End_Burst => net_gnd0,
      VFBC7_Rd_Flush => net_gnd0,
      VFBC7_Rd_Data => open,
      VFBC7_Rd_Empty => open,
      VFBC7_Rd_Almost_Empty => open,
      MPMC_CTRL_Clk => net_vcc0,
      MPMC_CTRL_Rst => net_gnd0,
      MPMC_CTRL_PLB_ABus => net_gnd32,
      MPMC_CTRL_PLB_PAValid => net_gnd0,
      MPMC_CTRL_PLB_SAValid => net_gnd0,
      MPMC_CTRL_PLB_masterID => net_gnd1(0 to 0),
      MPMC_CTRL_PLB_RNW => net_gnd0,
      MPMC_CTRL_PLB_BE => net_gnd8,
      MPMC_CTRL_PLB_UABus => net_gnd32,
      MPMC_CTRL_PLB_rdPrim => net_gnd0,
      MPMC_CTRL_PLB_wrPrim => net_gnd0,
      MPMC_CTRL_PLB_abort => net_gnd0,
      MPMC_CTRL_PLB_busLock => net_gnd0,
      MPMC_CTRL_PLB_MSize => net_gnd2,
      MPMC_CTRL_PLB_size => net_gnd4,
      MPMC_CTRL_PLB_type => net_gnd3,
      MPMC_CTRL_PLB_lockErr => net_gnd0,
      MPMC_CTRL_PLB_wrPendReq => net_gnd0,
      MPMC_CTRL_PLB_wrPendPri => net_gnd2,
      MPMC_CTRL_PLB_rdPendReq => net_gnd0,
      MPMC_CTRL_PLB_rdPendPri => net_gnd2,
      MPMC_CTRL_PLB_reqPri => net_gnd2,
      MPMC_CTRL_PLB_TAttribute => net_gnd16,
      MPMC_CTRL_PLB_rdBurst => net_gnd0,
      MPMC_CTRL_PLB_wrBurst => net_gnd0,
      MPMC_CTRL_PLB_wrDBus => net_gnd64,
      MPMC_CTRL_Sl_addrAck => open,
      MPMC_CTRL_Sl_SSize => open,
      MPMC_CTRL_Sl_wait => open,
      MPMC_CTRL_Sl_rearbitrate => open,
      MPMC_CTRL_Sl_wrDAck => open,
      MPMC_CTRL_Sl_wrComp => open,
      MPMC_CTRL_Sl_wrBTerm => open,
      MPMC_CTRL_Sl_rdDBus => open,
      MPMC_CTRL_Sl_rdWdAddr => open,
      MPMC_CTRL_Sl_rdDAck => open,
      MPMC_CTRL_Sl_rdComp => open,
      MPMC_CTRL_Sl_rdBTerm => open,
      MPMC_CTRL_Sl_MBusy => open,
      MPMC_CTRL_Sl_MRdErr => open,
      MPMC_CTRL_Sl_MWrErr => open,
      MPMC_CTRL_Sl_MIRQ => open,
      MPMC_Clk0 => sys_clk_s,
      MPMC_Clk0_DIV2 => DDR2_SDRAM_MPMC_Clk_Div2,
      MPMC_Clk90 => DDR2_SDRAM_mpmc_clk_90_s,
      MPMC_Clk_200MHz => clk_200mhz_s,
      MPMC_Rst => sys_periph_reset(0),
      MPMC_Clk_Mem => net_vcc0,
      MPMC_Idelayctrl_Rdy_I => net_vcc0,
      MPMC_Idelayctrl_Rdy_O => open,
      MPMC_InitDone => open,
      MPMC_ECC_Intr => open,
      MPMC_DCM_PSEN => open,
      MPMC_DCM_PSINCDEC => open,
      MPMC_DCM_PSDONE => net_gnd0,
      SDRAM_Clk => open,
      SDRAM_CE => open,
      SDRAM_CS_n => open,
      SDRAM_RAS_n => open,
      SDRAM_CAS_n => open,
      SDRAM_WE_n => open,
      SDRAM_BankAddr => open,
      SDRAM_Addr => open,
      SDRAM_DQ => open,
      SDRAM_DM => open,
      DDR_Clk => open,
      DDR_Clk_n => open,
      DDR_CE => open,
      DDR_CS_n => open,
      DDR_RAS_n => open,
      DDR_CAS_n => open,
      DDR_WE_n => open,
      DDR_BankAddr => open,
      DDR_Addr => open,
      DDR_DQ => open,
      DDR_DM => open,
      DDR_DQS => open,
      DDR_DQS_Div_O => open,
      DDR_DQS_Div_I => net_gnd0,
      DDR2_Clk => fpga_0_DDR2_SDRAM_DDR2_Clk,
      DDR2_Clk_n => fpga_0_DDR2_SDRAM_DDR2_Clk_n,
      DDR2_CE => fpga_0_DDR2_SDRAM_DDR2_CE_split(0 to 1),
      DDR2_CS_n => fpga_0_DDR2_SDRAM_DDR2_CS_n_split(0 to 1),
      DDR2_ODT => fpga_0_DDR2_SDRAM_DDR2_ODT,
      DDR2_RAS_n => fpga_0_DDR2_SDRAM_DDR2_RAS_n,
      DDR2_CAS_n => fpga_0_DDR2_SDRAM_DDR2_CAS_n,
      DDR2_WE_n => fpga_0_DDR2_SDRAM_DDR2_WE_n,
      DDR2_BankAddr => fpga_0_DDR2_SDRAM_DDR2_BankAddr,
      DDR2_Addr => fpga_0_DDR2_SDRAM_DDR2_Addr,
      DDR2_DQ => fpga_0_DDR2_SDRAM_DDR2_DQ,
      DDR2_DM => fpga_0_DDR2_SDRAM_DDR2_DM,
      DDR2_DQS => fpga_0_DDR2_SDRAM_DDR2_DQS,
      DDR2_DQS_n => fpga_0_DDR2_SDRAM_DDR2_DQS_n,
      DDR2_DQS_Div_O => open,
      DDR2_DQS_Div_I => net_gnd0
    );

  SRAM_util_bus_split_0 : sram_util_bus_split_0_wrapper
    port map (
      Sig => fpga_0_SRAM_Mem_A_split,
      Out1 => fpga_0_SRAM_Mem_A,
      Out2 => open
    );

  DDR2_SDRAM_util_bus_split_1 : ddr2_sdram_util_bus_split_1_wrapper
    port map (
      Sig => fpga_0_DDR2_SDRAM_DDR2_CE_split,
      Out1 => open,
      Out2 => fpga_0_DDR2_SDRAM_DDR2_CE(0 to 0)
    );

  DDR2_SDRAM_util_bus_split_2 : ddr2_sdram_util_bus_split_2_wrapper
    port map (
      Sig => fpga_0_DDR2_SDRAM_DDR2_CS_n_split,
      Out1 => open,
      Out2 => fpga_0_DDR2_SDRAM_DDR2_CS_n(0 to 0)
    );

  clock_generator_0 : clock_generator_0_wrapper
    port map (
      CLKIN => dcm_clk_s,
      CLKFBIN => ZBT_CLK_FB_s,
      CLKOUT0 => proc_clk_s,
      CLKOUT1 => sys_clk_s,
      CLKOUT2 => DDR2_SDRAM_mpmc_clk_90_s,
      CLKOUT3 => clk_200mhz_s,
      CLKOUT4 => DDR2_SDRAM_MPMC_Clk_Div2,
      CLKOUT5 => open,
      CLKOUT6 => open,
      CLKOUT7 => open,
      CLKOUT8 => open,
      CLKOUT9 => open,
      CLKOUT10 => open,
      CLKOUT11 => open,
      CLKOUT12 => open,
      CLKOUT13 => open,
      CLKOUT14 => open,
      CLKOUT15 => open,
      CLKFBOUT => ZBT_CLK_OUT_s,
      RST => net_gnd0,
      LOCKED => Dcm_all_locked
    );

  jtagppc_cntlr_0 : jtagppc_cntlr_0_wrapper
    port map (
      TRSTNEG => net_vcc0,
      HALTNEG0 => net_vcc0,
      DBGC405DEBUGHALT0 => open,
      HALTNEG1 => net_vcc0,
      DBGC405DEBUGHALT1 => open,
      C405JTGTDO0 => jtagppc_cntlr_0_0_C405JTGTDO,
      C405JTGTDOEN0 => jtagppc_cntlr_0_0_C405JTGTDOEN,
      JTGC405TCK0 => jtagppc_cntlr_0_0_JTGC405TCK,
      JTGC405TDI0 => jtagppc_cntlr_0_0_JTGC405TDI,
      JTGC405TMS0 => jtagppc_cntlr_0_0_JTGC405TMS,
      JTGC405TRSTNEG0 => jtagppc_cntlr_0_0_JTGC405TRSTNEG,
      C405JTGTDO1 => net_gnd0,
      C405JTGTDOEN1 => net_gnd0,
      JTGC405TCK1 => open,
      JTGC405TDI1 => open,
      JTGC405TMS1 => open,
      JTGC405TRSTNEG1 => open
    );

  proc_sys_reset_0 : proc_sys_reset_0_wrapper
    port map (
      Slowest_sync_clk => sys_clk_s,
      Ext_Reset_In => sys_rst_s,
      Aux_Reset_In => net_gnd0,
      MB_Debug_Sys_Rst => Debug_SYS_Rst,
      Core_Reset_Req_0 => ppc_reset_bus_Core_Reset_Req,
      Chip_Reset_Req_0 => ppc_reset_bus_Chip_Reset_Req,
      System_Reset_Req_0 => ppc_reset_bus_System_Reset_Req,
      Core_Reset_Req_1 => net_gnd0,
      Chip_Reset_Req_1 => net_gnd0,
      System_Reset_Req_1 => net_gnd0,
      Dcm_locked => Dcm_all_locked,
      RstcPPCresetcore_0 => ppc_reset_bus_RstcPPCresetcore,
      RstcPPCresetchip_0 => ppc_reset_bus_RstsPPCresetchip,
      RstcPPCresetsys_0 => ppc_reset_bus_RstcPPCresetsys,
      RstcPPCresetcore_1 => open,
      RstcPPCresetchip_1 => open,
      RstcPPCresetsys_1 => open,
      MB_Reset => open,
      Bus_Struct_Reset => sys_bus_reset(0 to 0),
      Peripheral_Reset => sys_periph_reset(0 to 0)
    );

  xps_intc_0 : xps_intc_0_wrapper
    port map (
      SPLB_Clk => sys_clk_s,
      SPLB_Rst => plb_v46_0_SPLB_Rst(5),
      PLB_ABus => plb_v46_0_PLB_ABus,
      PLB_PAValid => plb_v46_0_PLB_PAValid,
      PLB_masterID => plb_v46_0_PLB_masterID,
      PLB_RNW => plb_v46_0_PLB_RNW,
      PLB_BE => plb_v46_0_PLB_BE,
      PLB_size => plb_v46_0_PLB_size,
      PLB_type => plb_v46_0_PLB_type,
      PLB_wrDBus => plb_v46_0_PLB_wrDBus,
      PLB_UABus => plb_v46_0_PLB_UABus,
      PLB_SAValid => plb_v46_0_PLB_SAValid,
      PLB_rdPrim => plb_v46_0_PLB_rdPrim(5),
      PLB_wrPrim => plb_v46_0_PLB_wrPrim(5),
      PLB_abort => plb_v46_0_PLB_abort,
      PLB_busLock => plb_v46_0_PLB_busLock,
      PLB_MSize => plb_v46_0_PLB_MSize,
      PLB_lockErr => plb_v46_0_PLB_lockErr,
      PLB_wrBurst => plb_v46_0_PLB_wrBurst,
      PLB_rdBurst => plb_v46_0_PLB_rdBurst,
      PLB_wrPendReq => plb_v46_0_PLB_wrPendReq,
      PLB_rdPendReq => plb_v46_0_PLB_rdPendReq,
      PLB_wrPendPri => plb_v46_0_PLB_wrPendPri,
      PLB_rdPendPri => plb_v46_0_PLB_rdPendPri,
      PLB_reqPri => plb_v46_0_PLB_reqPri,
      PLB_TAttribute => plb_v46_0_PLB_TAttribute,
      Sl_addrAck => plb_v46_0_Sl_addrAck(5),
      Sl_SSize => plb_v46_0_Sl_SSize(10 to 11),
      Sl_wait => plb_v46_0_Sl_wait(5),
      Sl_rearbitrate => plb_v46_0_Sl_rearbitrate(5),
      Sl_wrDAck => plb_v46_0_Sl_wrDAck(5),
      Sl_wrComp => plb_v46_0_Sl_wrComp(5),
      Sl_rdDBus => plb_v46_0_Sl_rdDBus(640 to 767),
      Sl_rdDAck => plb_v46_0_Sl_rdDAck(5),
      Sl_rdComp => plb_v46_0_Sl_rdComp(5),
      Sl_MBusy => plb_v46_0_Sl_MBusy(40 to 47),
      Sl_MWrErr => plb_v46_0_Sl_MWrErr(40 to 47),
      Sl_MRdErr => plb_v46_0_Sl_MRdErr(40 to 47),
      Sl_wrBTerm => plb_v46_0_Sl_wrBTerm(5),
      Sl_rdWdAddr => plb_v46_0_Sl_rdWdAddr(20 to 23),
      Sl_rdBTerm => plb_v46_0_Sl_rdBTerm(5),
      Sl_MIRQ => plb_v46_0_Sl_MIRQ(40 to 47),
      Intr => uart_interrupt(0 downto 0),
      Irq => open
    );

  plbv46_opb_bridge_0 : plbv46_opb_bridge_0_wrapper
    port map (
      SPLB_Clk => sys_clk_s,
      SPLB_Rst => plb_v46_0_SPLB_Rst(6),
      PLB_ABus => plb_v46_0_PLB_ABus,
      PLB_UABus => plb_v46_0_PLB_UABus,
      PLB_PAValid => plb_v46_0_PLB_PAValid,
      PLB_SAValid => plb_v46_0_PLB_SAValid,
      PLB_rdPrim => plb_v46_0_PLB_rdPrim(6),
      PLB_wrPrim => plb_v46_0_PLB_wrPrim(6),
      PLB_masterID => plb_v46_0_PLB_masterID,
      PLB_abort => plb_v46_0_PLB_abort,
      PLB_busLock => plb_v46_0_PLB_busLock,
      PLB_RNW => plb_v46_0_PLB_RNW,
      PLB_BE => plb_v46_0_PLB_BE,
      PLB_MSize => plb_v46_0_PLB_MSize,
      PLB_size => plb_v46_0_PLB_size,
      PLB_type => plb_v46_0_PLB_type,
      PLB_lockErr => plb_v46_0_PLB_lockErr,
      PLB_wrDBus => plb_v46_0_PLB_wrDBus,
      PLB_wrBurst => plb_v46_0_PLB_wrBurst,
      PLB_rdBurst => plb_v46_0_PLB_rdBurst,
      PLB_wrPendReq => plb_v46_0_PLB_wrPendReq,
      PLB_rdPendReq => plb_v46_0_PLB_rdPendReq,
      PLB_wrPendPri => plb_v46_0_PLB_wrPendPri,
      PLB_rdPendPri => plb_v46_0_PLB_rdPendPri,
      PLB_reqPri => plb_v46_0_PLB_reqPri,
      PLB_TAttribute => plb_v46_0_PLB_TAttribute,
      Sl_addrAck => plb_v46_0_Sl_addrAck(6),
      Sl_SSize => plb_v46_0_Sl_SSize(12 to 13),
      Sl_wait => plb_v46_0_Sl_wait(6),
      Sl_rearbitrate => plb_v46_0_Sl_rearbitrate(6),
      Sl_wrDAck => plb_v46_0_Sl_wrDAck(6),
      Sl_wrComp => plb_v46_0_Sl_wrComp(6),
      Sl_wrBTerm => plb_v46_0_Sl_wrBTerm(6),
      Sl_rdDBus => plb_v46_0_Sl_rdDBus(768 to 895),
      Sl_rdWdAddr => plb_v46_0_Sl_rdWdAddr(24 to 27),
      Sl_rdDAck => plb_v46_0_Sl_rdDAck(6),
      Sl_rdComp => plb_v46_0_Sl_rdComp(6),
      Sl_rdBTerm => plb_v46_0_Sl_rdBTerm(6),
      Sl_MBusy => plb_v46_0_Sl_MBusy(48 to 55),
      Sl_MWrErr => plb_v46_0_Sl_MWrErr(48 to 55),
      Sl_MRdErr => plb_v46_0_Sl_MRdErr(48 to 55),
      Sl_MIRQ => plb_v46_0_Sl_MIRQ(48 to 55),
      OPB_Clk => sys_clk_s,
      OPB_Rst => opb_v20_0_OPB_Rst,
      Mn_request => opb_v20_0_M_request(0),
      Mn_busLock => opb_v20_0_M_busLock(0),
      Mn_select => opb_v20_0_M_select(0),
      Mn_RNW => opb_v20_0_M_RNW(0),
      Mn_BE => opb_v20_0_M_BE(0 to 3),
      Mn_seqAddr => opb_v20_0_M_seqAddr(0),
      Mn_DBus => opb_v20_0_M_DBus(0 to 31),
      Mn_ABus => opb_v20_0_M_ABus(0 to 31),
      OPB_MGrant => opb_v20_0_OPB_MGrant(0),
      OPB_xferAck => opb_v20_0_OPB_xferAck,
      OPB_errAck => opb_v20_0_OPB_errAck,
      OPB_retry => opb_v20_0_OPB_retry,
      OPB_timeout => opb_v20_0_OPB_timeout,
      OPB_DBus => opb_v20_0_OPB_DBus
    );

  opb_plbv46_bridge_0 : opb_plbv46_bridge_0_wrapper
    port map (
      MPLB_Clk => sys_clk_s,
      MPLB_Rst => plb_v46_0_MPLB_Rst(1),
      MD_Error => open,
      M_request => plb_v46_0_M_request(1),
      M_priority => plb_v46_0_M_priority(2 to 3),
      M_busLock => plb_v46_0_M_busLock(1),
      M_RNW => plb_v46_0_M_RNW(1),
      M_BE => plb_v46_0_M_BE(16 to 31),
      M_MSize => plb_v46_0_M_MSize(2 to 3),
      M_size => plb_v46_0_M_size(4 to 7),
      M_type => plb_v46_0_M_type(3 to 5),
      M_ABus => plb_v46_0_M_ABus(32 to 63),
      M_wrBurst => plb_v46_0_M_wrBurst(1),
      M_rdBurst => plb_v46_0_M_rdBurst(1),
      M_wrDBus => plb_v46_0_M_wrDBus(128 to 255),
      PLB_MAddrAck => plb_v46_0_PLB_MAddrAck(1),
      PLB_MSSize => plb_v46_0_PLB_MSSize(2 to 3),
      PLB_MRearbitrate => plb_v46_0_PLB_MRearbitrate(1),
      PLB_MTimeout => plb_v46_0_PLB_MTimeout(1),
      PLB_MRdErr => plb_v46_0_PLB_MRdErr(1),
      PLB_MWrErr => plb_v46_0_PLB_MWrErr(1),
      PLB_MRdDBus => plb_v46_0_PLB_MRdDBus(128 to 255),
      PLB_MRdDAck => plb_v46_0_PLB_MRdDAck(1),
      PLB_MRdBTerm => plb_v46_0_PLB_MRdBTerm(1),
      PLB_MWrDAck => plb_v46_0_PLB_MWrDAck(1),
      PLB_MWrBTerm => plb_v46_0_PLB_MWrBTerm(1),
      M_TAttribute => plb_v46_0_M_TAttribute(16 to 31),
      M_lockErr => plb_v46_0_M_lockErr(1),
      M_abort => plb_v46_0_M_abort(1),
      M_UABus => plb_v46_0_M_UABus(32 to 63),
      PLB_MBusy => plb_v46_0_PLB_MBusy(1),
      PLB_MIRQ => plb_v46_0_PLB_MIRQ(1),
      PLB_MRdWdAddr => plb_v46_0_PLB_MRdWdAddr(4 to 7),
      SOPB_rst => opb_v20_0_OPB_Rst,
      SOPB_clk => sys_clk_s,
      OPB_Select => opb_v20_0_OPB_select,
      OPB_RNW => opb_v20_0_OPB_RNW,
      OPB_BE => opb_v20_0_OPB_BE,
      OPB_seqAddr => opb_v20_0_OPB_seqAddr,
      OPB_DBus => opb_v20_0_OPB_DBus,
      OPB_ABus => opb_v20_0_OPB_ABus,
      Sl_xferAck => opb_v20_0_Sl_xferAck(0),
      Sl_errAck => opb_v20_0_Sl_errAck(0),
      Sl_retry => opb_v20_0_Sl_retry(0),
      Sl_ToutSup => opb_v20_0_Sl_toutSup(0),
      Sl_DBus => opb_v20_0_Sl_DBus(0 to 31)
    );

  opb_v20_0 : opb_v20_0_wrapper
    port map (
      OPB_Clk => sys_clk_s,
      OPB_Rst => opb_v20_0_OPB_Rst,
      SYS_Rst => sys_rst_s,
      Debug_SYS_Rst => net_gnd0,
      WDT_Rst => net_gnd0,
      M_ABus => opb_v20_0_M_ABus,
      M_BE => opb_v20_0_M_BE,
      M_beXfer => net_gnd4,
      M_busLock => opb_v20_0_M_busLock,
      M_DBus => opb_v20_0_M_DBus,
      M_DBusEn => net_gnd4,
      M_DBusEn32_63 => net_vcc4,
      M_dwXfer => net_gnd4,
      M_fwXfer => net_gnd4,
      M_hwXfer => net_gnd4,
      M_request => opb_v20_0_M_request,
      M_RNW => opb_v20_0_M_RNW,
      M_select => opb_v20_0_M_select,
      M_seqAddr => opb_v20_0_M_seqAddr,
      Sl_beAck => net_gnd6,
      Sl_DBus => opb_v20_0_Sl_DBus,
      Sl_DBusEn => net_vcc6,
      Sl_DBusEn32_63 => net_vcc6,
      Sl_errAck => opb_v20_0_Sl_errAck,
      Sl_dwAck => net_gnd6,
      Sl_fwAck => net_gnd6,
      Sl_hwAck => net_gnd6,
      Sl_retry => opb_v20_0_Sl_retry,
      Sl_toutSup => opb_v20_0_Sl_toutSup,
      Sl_xferAck => opb_v20_0_Sl_xferAck,
      OPB_MRequest => open,
      OPB_ABus => opb_v20_0_OPB_ABus,
      OPB_BE => opb_v20_0_OPB_BE,
      OPB_beXfer => open,
      OPB_beAck => open,
      OPB_busLock => open,
      OPB_rdDBus => open,
      OPB_wrDBus => open,
      OPB_DBus => opb_v20_0_OPB_DBus,
      OPB_errAck => opb_v20_0_OPB_errAck,
      OPB_dwAck => open,
      OPB_dwXfer => open,
      OPB_fwAck => open,
      OPB_fwXfer => open,
      OPB_hwAck => open,
      OPB_hwXfer => open,
      OPB_MGrant => opb_v20_0_OPB_MGrant,
      OPB_pendReq => open,
      OPB_retry => opb_v20_0_OPB_retry,
      OPB_RNW => opb_v20_0_OPB_RNW,
      OPB_select => opb_v20_0_OPB_select,
      OPB_seqAddr => opb_v20_0_OPB_seqAddr,
      OPB_timeout => opb_v20_0_OPB_timeout,
      OPB_toutSup => open,
      OPB_xferAck => opb_v20_0_OPB_xferAck
    );

  opb_bram_if_cntlr_1 : opb_bram_if_cntlr_1_wrapper
    port map (
      opb_clk => sys_clk_s,
      opb_rst => opb_v20_0_OPB_Rst,
      opb_abus => opb_v20_0_OPB_ABus,
      opb_dbus => opb_v20_0_OPB_DBus,
      sln_dbus => opb_v20_0_Sl_DBus(128 to 159),
      opb_select => opb_v20_0_OPB_select,
      opb_rnw => opb_v20_0_OPB_RNW,
      opb_seqaddr => opb_v20_0_OPB_seqAddr,
      opb_be => opb_v20_0_OPB_BE,
      sln_xferack => opb_v20_0_Sl_xferAck(4),
      sln_errack => opb_v20_0_Sl_errAck(4),
      sln_toutsup => opb_v20_0_Sl_toutSup(4),
      sln_retry => opb_v20_0_Sl_retry(4),
      bram_rst => opb_bram_if_cntlr_1_PORTA_BRAM_Rst,
      bram_clk => opb_bram_if_cntlr_1_PORTA_BRAM_Clk,
      bram_en => opb_bram_if_cntlr_1_PORTA_BRAM_EN,
      bram_wen => opb_bram_if_cntlr_1_PORTA_BRAM_WEN,
      bram_addr => opb_bram_if_cntlr_1_PORTA_BRAM_Addr,
      bram_din => opb_bram_if_cntlr_1_PORTA_BRAM_Din,
      bram_dout => opb_bram_if_cntlr_1_PORTA_BRAM_Dout
    );

  bram_block_0 : bram_block_0_wrapper
    port map (
      BRAM_Rst_A => xps_bram_if_cntlr_0_PORTA_BRAM_Rst,
      BRAM_Clk_A => xps_bram_if_cntlr_0_PORTA_BRAM_Clk,
      BRAM_EN_A => xps_bram_if_cntlr_0_PORTA_BRAM_EN,
      BRAM_WEN_A => xps_bram_if_cntlr_0_PORTA_BRAM_WEN,
      BRAM_Addr_A => xps_bram_if_cntlr_0_PORTA_BRAM_Addr,
      BRAM_Din_A => xps_bram_if_cntlr_0_PORTA_BRAM_Din,
      BRAM_Dout_A => xps_bram_if_cntlr_0_PORTA_BRAM_Dout,
      BRAM_Rst_B => opb_bram_if_cntlr_1_PORTA_BRAM_Rst,
      BRAM_Clk_B => opb_bram_if_cntlr_1_PORTA_BRAM_Clk,
      BRAM_EN_B => opb_bram_if_cntlr_1_PORTA_BRAM_EN,
      BRAM_WEN_B => opb_bram_if_cntlr_1_PORTA_BRAM_WEN,
      BRAM_Addr_B => opb_bram_if_cntlr_1_PORTA_BRAM_Addr,
      BRAM_Din_B => opb_bram_if_cntlr_1_PORTA_BRAM_Din,
      BRAM_Dout_B => opb_bram_if_cntlr_1_PORTA_BRAM_Dout
    );

  xps_bram_if_cntlr_0 : xps_bram_if_cntlr_0_wrapper
    port map (
      SPLB_Clk => sys_clk_s,
      SPLB_Rst => plb_v46_0_SPLB_Rst(7),
      PLB_ABus => plb_v46_0_PLB_ABus,
      PLB_UABus => plb_v46_0_PLB_UABus,
      PLB_PAValid => plb_v46_0_PLB_PAValid,
      PLB_SAValid => plb_v46_0_PLB_SAValid,
      PLB_rdPrim => plb_v46_0_PLB_rdPrim(7),
      PLB_wrPrim => plb_v46_0_PLB_wrPrim(7),
      PLB_masterID => plb_v46_0_PLB_masterID,
      PLB_abort => plb_v46_0_PLB_abort,
      PLB_busLock => plb_v46_0_PLB_busLock,
      PLB_RNW => plb_v46_0_PLB_RNW,
      PLB_BE => plb_v46_0_PLB_BE,
      PLB_MSize => plb_v46_0_PLB_MSize,
      PLB_size => plb_v46_0_PLB_size,
      PLB_type => plb_v46_0_PLB_type,
      PLB_lockErr => plb_v46_0_PLB_lockErr,
      PLB_wrDBus => plb_v46_0_PLB_wrDBus,
      PLB_wrBurst => plb_v46_0_PLB_wrBurst,
      PLB_rdBurst => plb_v46_0_PLB_rdBurst,
      PLB_wrPendReq => plb_v46_0_PLB_wrPendReq,
      PLB_rdPendReq => plb_v46_0_PLB_rdPendReq,
      PLB_wrPendPri => plb_v46_0_PLB_wrPendPri,
      PLB_rdPendPri => plb_v46_0_PLB_rdPendPri,
      PLB_reqPri => plb_v46_0_PLB_reqPri,
      PLB_TAttribute => plb_v46_0_PLB_TAttribute,
      Sl_addrAck => plb_v46_0_Sl_addrAck(7),
      Sl_SSize => plb_v46_0_Sl_SSize(14 to 15),
      Sl_wait => plb_v46_0_Sl_wait(7),
      Sl_rearbitrate => plb_v46_0_Sl_rearbitrate(7),
      Sl_wrDAck => plb_v46_0_Sl_wrDAck(7),
      Sl_wrComp => plb_v46_0_Sl_wrComp(7),
      Sl_wrBTerm => plb_v46_0_Sl_wrBTerm(7),
      Sl_rdDBus => plb_v46_0_Sl_rdDBus(896 to 1023),
      Sl_rdWdAddr => plb_v46_0_Sl_rdWdAddr(28 to 31),
      Sl_rdDAck => plb_v46_0_Sl_rdDAck(7),
      Sl_rdComp => plb_v46_0_Sl_rdComp(7),
      Sl_rdBTerm => plb_v46_0_Sl_rdBTerm(7),
      Sl_MBusy => plb_v46_0_Sl_MBusy(56 to 63),
      Sl_MWrErr => plb_v46_0_Sl_MWrErr(56 to 63),
      Sl_MRdErr => plb_v46_0_Sl_MRdErr(56 to 63),
      Sl_MIRQ => plb_v46_0_Sl_MIRQ(56 to 63),
      BRAM_Rst => xps_bram_if_cntlr_0_PORTA_BRAM_Rst,
      BRAM_Clk => xps_bram_if_cntlr_0_PORTA_BRAM_Clk,
      BRAM_EN => xps_bram_if_cntlr_0_PORTA_BRAM_EN,
      BRAM_WEN => xps_bram_if_cntlr_0_PORTA_BRAM_WEN,
      BRAM_Addr => xps_bram_if_cntlr_0_PORTA_BRAM_Addr,
      BRAM_Din => xps_bram_if_cntlr_0_PORTA_BRAM_Din,
      BRAM_Dout => xps_bram_if_cntlr_0_PORTA_BRAM_Dout
    );

  plb_hthread_reset_core_0 : plb_hthread_reset_core_0_wrapper
    port map (
      reset_port0 => open,
      reset_response_port0 => hthread_resp_sched,
      reset_port1 => hthread_rst_sched,
      reset_response_port1 => hthread_resp_sched,
      reset_port2 => hthread_rst_synch,
      reset_response_port2 => hthread_resp_synch,
      reset_port3 => hthread_rst_condvar,
      reset_response_port3 => hthread_resp_condvar,
      SPLB_Clk => sys_clk_s,
      SPLB_Rst => plb_v46_0_SPLB_Rst(8),
      PLB_ABus => plb_v46_0_PLB_ABus,
      PLB_UABus => plb_v46_0_PLB_UABus,
      PLB_PAValid => plb_v46_0_PLB_PAValid,
      PLB_SAValid => plb_v46_0_PLB_SAValid,
      PLB_rdPrim => plb_v46_0_PLB_rdPrim(8),
      PLB_wrPrim => plb_v46_0_PLB_wrPrim(8),
      PLB_masterID => plb_v46_0_PLB_masterID,
      PLB_abort => plb_v46_0_PLB_abort,
      PLB_busLock => plb_v46_0_PLB_busLock,
      PLB_RNW => plb_v46_0_PLB_RNW,
      PLB_BE => plb_v46_0_PLB_BE,
      PLB_MSize => plb_v46_0_PLB_MSize,
      PLB_size => plb_v46_0_PLB_size,
      PLB_type => plb_v46_0_PLB_type,
      PLB_lockErr => plb_v46_0_PLB_lockErr,
      PLB_wrDBus => plb_v46_0_PLB_wrDBus,
      PLB_wrBurst => plb_v46_0_PLB_wrBurst,
      PLB_rdBurst => plb_v46_0_PLB_rdBurst,
      PLB_wrPendReq => plb_v46_0_PLB_wrPendReq,
      PLB_rdPendReq => plb_v46_0_PLB_rdPendReq,
      PLB_wrPendPri => plb_v46_0_PLB_wrPendPri,
      PLB_rdPendPri => plb_v46_0_PLB_rdPendPri,
      PLB_reqPri => plb_v46_0_PLB_reqPri,
      PLB_TAttribute => plb_v46_0_PLB_TAttribute,
      Sl_addrAck => plb_v46_0_Sl_addrAck(8),
      Sl_SSize => plb_v46_0_Sl_SSize(16 to 17),
      Sl_wait => plb_v46_0_Sl_wait(8),
      Sl_rearbitrate => plb_v46_0_Sl_rearbitrate(8),
      Sl_wrDAck => plb_v46_0_Sl_wrDAck(8),
      Sl_wrComp => plb_v46_0_Sl_wrComp(8),
      Sl_wrBTerm => plb_v46_0_Sl_wrBTerm(8),
      Sl_rdDBus => plb_v46_0_Sl_rdDBus(1024 to 1151),
      Sl_rdWdAddr => plb_v46_0_Sl_rdWdAddr(32 to 35),
      Sl_rdDAck => plb_v46_0_Sl_rdDAck(8),
      Sl_rdComp => plb_v46_0_Sl_rdComp(8),
      Sl_rdBTerm => plb_v46_0_Sl_rdBTerm(8),
      Sl_MBusy => plb_v46_0_Sl_MBusy(64 to 71),
      Sl_MWrErr => plb_v46_0_Sl_MWrErr(64 to 71),
      Sl_MRdErr => plb_v46_0_Sl_MRdErr(64 to 71),
      Sl_MIRQ => plb_v46_0_Sl_MIRQ(64 to 71)
    );

  thread_manager : thread_manager_wrapper
    port map (
      OPB_Clk => sys_clk_s,
      OPB_Rst => opb_v20_0_OPB_Rst,
      OPB_ABus => opb_v20_0_OPB_ABus,
      OPB_BE => opb_v20_0_OPB_BE,
      OPB_DBus => opb_v20_0_OPB_DBus,
      OPB_RNW => opb_v20_0_OPB_RNW,
      OPB_select => opb_v20_0_OPB_select,
      OPB_seqAddr => opb_v20_0_OPB_seqAddr,
      Sln_DBus => opb_v20_0_Sl_DBus(160 to 191),
      Sln_errAck => opb_v20_0_Sl_errAck(5),
      Sln_retry => opb_v20_0_Sl_retry(5),
      Sln_toutSup => opb_v20_0_Sl_toutSup(5),
      Sln_xferAck => opb_v20_0_Sl_xferAck(5),
      Access_Intr => open,
      Scheduler_Reset => open,
      Scheduler_Reset_Done => net_gnd0,
      Semaphore_Reset => open,
      Semaphore_Reset_Done => net_gnd0,
      SpinLock_Reset => open,
      SpinLock_Reset_Done => net_gnd0,
      User_IP_Reset => open,
      User_IP_Reset_Done => net_gnd0,
      Soft_Stop => soft_stop,
      tm2sch_cpu_thread_id => core_tm2sch_cpu_thread_id,
      tm2sch_opcode => core_tm2sch_opcode,
      tm2sch_data => core_tm2sch_data,
      tm2sch_request => core_tm2sch_request,
      sch2tm_busy => core_sch2tm_busy,
      sch2tm_data => core_sch2tm_data,
      sch2tm_next_id => core_sch2tm_next_id,
      sch2tm_next_id_valid => core_sch2tm_next_id_valid,
      tm2sch_DOB => core_tm2sch_dob,
      sch2tm_ADDRB => core_sch2tm_addrb,
      sch2tm_DIB => core_sch2tm_dib,
      sch2tm_ENB => core_sch2tm_enb,
      sch2tm_WEB => core_sch2tm_web
    );

  scheduler : scheduler_wrapper
    port map (
      Soft_Reset => hthread_rst_sched,
      Reset_Done => hthread_resp_sched,
      Soft_Stop => soft_stop,
      SWTM_DOB => core_tm2sch_dob,
      SWTM_ADDRB => core_sch2tm_addrb,
      SWTM_DIB => core_sch2tm_dib,
      SWTM_ENB => core_sch2tm_enb,
      SWTM_WEB => core_sch2tm_web,
      TM2SCH_current_cpu_tid => core_tm2sch_cpu_thread_id,
      TM2SCH_opcode => core_tm2sch_opcode,
      TM2SCH_data => core_tm2sch_data,
      TM2SCH_request => core_tm2sch_request,
      SCH2TM_busy => core_sch2tm_busy,
      SCH2TM_data => core_sch2tm_data,
      SCH2TM_next_cpu_tid => core_sch2tm_next_id,
      SCH2TM_next_tid_valid => core_sch2tm_next_id_valid,
      Preemption_Interrupt => open,
      OPB_Clk => sys_clk_s,
      OPB_Rst => opb_v20_0_OPB_Rst,
      Sl_DBus => opb_v20_0_Sl_DBus(32 to 63),
      Sl_errAck => opb_v20_0_Sl_errAck(1),
      Sl_retry => opb_v20_0_Sl_retry(1),
      Sl_toutSup => opb_v20_0_Sl_toutSup(1),
      Sl_xferAck => opb_v20_0_Sl_xferAck(1),
      OPB_ABus => opb_v20_0_OPB_ABus,
      OPB_BE => opb_v20_0_OPB_BE,
      OPB_DBus => opb_v20_0_OPB_DBus,
      OPB_RNW => opb_v20_0_OPB_RNW,
      OPB_select => opb_v20_0_OPB_select,
      OPB_seqAddr => opb_v20_0_OPB_seqAddr,
      M_ABus => opb_v20_0_M_ABus(32 to 63),
      M_BE => opb_v20_0_M_BE(4 to 7),
      M_busLock => opb_v20_0_M_busLock(1),
      M_request => opb_v20_0_M_request(1),
      M_RNW => opb_v20_0_M_RNW(1),
      M_select => opb_v20_0_M_select(1),
      M_seqAddr => opb_v20_0_M_seqAddr(1),
      OPB_errAck => opb_v20_0_OPB_errAck,
      OPB_MGrant => opb_v20_0_OPB_MGrant(1),
      OPB_retry => opb_v20_0_OPB_retry,
      OPB_timeout => opb_v20_0_OPB_timeout,
      OPB_xferAck => opb_v20_0_OPB_xferAck
    );

  synch_manager : synch_manager_wrapper
    port map (
      OPB_Clk => sys_clk_s,
      OPB_Rst => opb_v20_0_OPB_Rst,
      Sl_DBus => opb_v20_0_Sl_DBus(64 to 95),
      Sl_errAck => opb_v20_0_Sl_errAck(2),
      Sl_retry => opb_v20_0_Sl_retry(2),
      Sl_toutSup => opb_v20_0_Sl_toutSup(2),
      Sl_xferAck => opb_v20_0_Sl_xferAck(2),
      OPB_ABus => opb_v20_0_OPB_ABus,
      OPB_BE => opb_v20_0_OPB_BE,
      OPB_DBus => opb_v20_0_OPB_DBus,
      OPB_RNW => opb_v20_0_OPB_RNW,
      OPB_select => opb_v20_0_OPB_select,
      OPB_seqAddr => opb_v20_0_OPB_seqAddr,
      M_ABus => opb_v20_0_M_ABus(64 to 95),
      M_BE => opb_v20_0_M_BE(8 to 11),
      M_busLock => opb_v20_0_M_busLock(2),
      M_request => opb_v20_0_M_request(2),
      M_RNW => opb_v20_0_M_RNW(2),
      M_select => opb_v20_0_M_select(2),
      M_seqAddr => opb_v20_0_M_seqAddr(2),
      OPB_errAck => opb_v20_0_OPB_errAck,
      OPB_MGrant => opb_v20_0_OPB_MGrant(2),
      OPB_retry => opb_v20_0_OPB_retry,
      OPB_timeout => opb_v20_0_OPB_timeout,
      OPB_xferAck => opb_v20_0_OPB_xferAck,
      system_reset => hthread_rst_synch,
      system_resetdone => hthread_resp_synch
    );

  cond_vars : cond_vars_wrapper
    port map (
      OPB_Clk => sys_clk_s,
      OPB_Rst => opb_v20_0_OPB_Rst,
      Interrupt => open,
      IP2Bus_IntrEvent => net_gnd1(0 to 0),
      OPB_ABus => opb_v20_0_OPB_ABus,
      OPB_DBus => opb_v20_0_OPB_DBus,
      OPB_BE => opb_v20_0_OPB_BE,
      OPB_RNW => opb_v20_0_OPB_RNW,
      OPB_select => opb_v20_0_OPB_select,
      OPB_seqAddr => opb_v20_0_OPB_seqAddr,
      OPB_errAck => opb_v20_0_OPB_errAck,
      OPB_MnGrant => opb_v20_0_OPB_MGrant(3),
      OPB_retry => opb_v20_0_OPB_retry,
      OPB_timeout => opb_v20_0_OPB_timeout,
      OPB_xferAck => opb_v20_0_OPB_xferAck,
      Mn_request => opb_v20_0_M_request(3),
      Mn_busLock => opb_v20_0_M_busLock(3),
      Mn_select => opb_v20_0_M_select(3),
      Mn_RNW => opb_v20_0_M_RNW(3),
      Mn_BE => opb_v20_0_M_BE(12 to 15),
      Mn_seqAddr => opb_v20_0_M_seqAddr(3),
      Mn_ABus => opb_v20_0_M_ABus(96 to 127),
      Sln_xferAck => opb_v20_0_Sl_xferAck(3),
      Sln_errAck => opb_v20_0_Sl_errAck(3),
      Sln_retry => opb_v20_0_Sl_retry(3),
      Sln_toutSup => opb_v20_0_Sl_toutSup(3),
      Sln_DBus => opb_v20_0_Sl_DBus(96 to 127),
      Sema_Reset => hthread_rst_condvar,
      Sema_Rst_Ack => hthread_resp_condvar
    );

  xps_timer_0 : xps_timer_0_wrapper
    port map (
      CaptureTrig0 => net_gnd0,
      CaptureTrig1 => net_gnd0,
      GenerateOut0 => open,
      GenerateOut1 => open,
      PWM0 => open,
      Interrupt => open,
      Freeze => net_gnd0,
      SPLB_Clk => sys_clk_s,
      SPLB_Rst => plb_v46_0_SPLB_Rst(9),
      PLB_ABus => plb_v46_0_PLB_ABus,
      PLB_PAValid => plb_v46_0_PLB_PAValid,
      PLB_masterID => plb_v46_0_PLB_masterID,
      PLB_RNW => plb_v46_0_PLB_RNW,
      PLB_BE => plb_v46_0_PLB_BE,
      PLB_size => plb_v46_0_PLB_size,
      PLB_type => plb_v46_0_PLB_type,
      PLB_wrDBus => plb_v46_0_PLB_wrDBus,
      Sl_addrAck => plb_v46_0_Sl_addrAck(9),
      Sl_SSize => plb_v46_0_Sl_SSize(18 to 19),
      Sl_wait => plb_v46_0_Sl_wait(9),
      Sl_rearbitrate => plb_v46_0_Sl_rearbitrate(9),
      Sl_wrDAck => plb_v46_0_Sl_wrDAck(9),
      Sl_wrComp => plb_v46_0_Sl_wrComp(9),
      Sl_rdDBus => plb_v46_0_Sl_rdDBus(1152 to 1279),
      Sl_rdDAck => plb_v46_0_Sl_rdDAck(9),
      Sl_rdComp => plb_v46_0_Sl_rdComp(9),
      Sl_MBusy => plb_v46_0_Sl_MBusy(72 to 79),
      Sl_MWrErr => plb_v46_0_Sl_MWrErr(72 to 79),
      Sl_MRdErr => plb_v46_0_Sl_MRdErr(72 to 79),
      PLB_UABus => plb_v46_0_PLB_UABus,
      PLB_SAValid => plb_v46_0_PLB_SAValid,
      PLB_rdPrim => plb_v46_0_PLB_rdPrim(9),
      PLB_wrPrim => plb_v46_0_PLB_wrPrim(9),
      PLB_abort => plb_v46_0_PLB_abort,
      PLB_busLock => plb_v46_0_PLB_busLock,
      PLB_MSize => plb_v46_0_PLB_MSize,
      PLB_lockErr => plb_v46_0_PLB_lockErr,
      PLB_wrBurst => plb_v46_0_PLB_wrBurst,
      PLB_rdBurst => plb_v46_0_PLB_rdBurst,
      PLB_wrPendReq => plb_v46_0_PLB_wrPendReq,
      PLB_rdPendReq => plb_v46_0_PLB_rdPendReq,
      PLB_wrPendPri => plb_v46_0_PLB_wrPendPri,
      PLB_rdPendPri => plb_v46_0_PLB_rdPendPri,
      PLB_reqPri => plb_v46_0_PLB_reqPri,
      PLB_TAttribute => plb_v46_0_PLB_TAttribute,
      Sl_wrBTerm => plb_v46_0_Sl_wrBTerm(9),
      Sl_rdWdAddr => plb_v46_0_Sl_rdWdAddr(36 to 39),
      Sl_rdBTerm => plb_v46_0_Sl_rdBTerm(9),
      Sl_MIRQ => plb_v46_0_Sl_MIRQ(72 to 79)
    );

  xps_hw_thread_bram_cntlr : xps_hw_thread_bram_cntlr_wrapper
    port map (
      SPLB_Clk => sys_clk_s,
      SPLB_Rst => plb_v46_0_SPLB_Rst(10),
      PLB_ABus => plb_v46_0_PLB_ABus,
      PLB_UABus => plb_v46_0_PLB_UABus,
      PLB_PAValid => plb_v46_0_PLB_PAValid,
      PLB_SAValid => plb_v46_0_PLB_SAValid,
      PLB_rdPrim => plb_v46_0_PLB_rdPrim(10),
      PLB_wrPrim => plb_v46_0_PLB_wrPrim(10),
      PLB_masterID => plb_v46_0_PLB_masterID,
      PLB_abort => plb_v46_0_PLB_abort,
      PLB_busLock => plb_v46_0_PLB_busLock,
      PLB_RNW => plb_v46_0_PLB_RNW,
      PLB_BE => plb_v46_0_PLB_BE,
      PLB_MSize => plb_v46_0_PLB_MSize,
      PLB_size => plb_v46_0_PLB_size,
      PLB_type => plb_v46_0_PLB_type,
      PLB_lockErr => plb_v46_0_PLB_lockErr,
      PLB_wrDBus => plb_v46_0_PLB_wrDBus,
      PLB_wrBurst => plb_v46_0_PLB_wrBurst,
      PLB_rdBurst => plb_v46_0_PLB_rdBurst,
      PLB_wrPendReq => plb_v46_0_PLB_wrPendReq,
      PLB_rdPendReq => plb_v46_0_PLB_rdPendReq,
      PLB_wrPendPri => plb_v46_0_PLB_wrPendPri,
      PLB_rdPendPri => plb_v46_0_PLB_rdPendPri,
      PLB_reqPri => plb_v46_0_PLB_reqPri,
      PLB_TAttribute => plb_v46_0_PLB_TAttribute,
      Sl_addrAck => plb_v46_0_Sl_addrAck(10),
      Sl_SSize => plb_v46_0_Sl_SSize(20 to 21),
      Sl_wait => plb_v46_0_Sl_wait(10),
      Sl_rearbitrate => plb_v46_0_Sl_rearbitrate(10),
      Sl_wrDAck => plb_v46_0_Sl_wrDAck(10),
      Sl_wrComp => plb_v46_0_Sl_wrComp(10),
      Sl_wrBTerm => plb_v46_0_Sl_wrBTerm(10),
      Sl_rdDBus => plb_v46_0_Sl_rdDBus(1280 to 1407),
      Sl_rdWdAddr => plb_v46_0_Sl_rdWdAddr(40 to 43),
      Sl_rdDAck => plb_v46_0_Sl_rdDAck(10),
      Sl_rdComp => plb_v46_0_Sl_rdComp(10),
      Sl_rdBTerm => plb_v46_0_Sl_rdBTerm(10),
      Sl_MBusy => plb_v46_0_Sl_MBusy(80 to 87),
      Sl_MWrErr => plb_v46_0_Sl_MWrErr(80 to 87),
      Sl_MRdErr => plb_v46_0_Sl_MRdErr(80 to 87),
      Sl_MIRQ => plb_v46_0_Sl_MIRQ(80 to 87),
      BRAM_Rst => xps_hw_thread_bram_cntlr_PORTA_BRAM_Rst,
      BRAM_Clk => xps_hw_thread_bram_cntlr_PORTA_BRAM_Clk,
      BRAM_EN => xps_hw_thread_bram_cntlr_PORTA_BRAM_EN,
      BRAM_WEN => xps_hw_thread_bram_cntlr_PORTA_BRAM_WEN,
      BRAM_Addr => xps_hw_thread_bram_cntlr_PORTA_BRAM_Addr,
      BRAM_Din => xps_hw_thread_bram_cntlr_PORTA_BRAM_Din,
      BRAM_Dout => xps_hw_thread_bram_cntlr_PORTA_BRAM_Dout
    );

  hw_thread_bram : hw_thread_bram_wrapper
    port map (
      BRAM_Rst_A => net_gnd0,
      BRAM_Clk_A => net_gnd0,
      BRAM_EN_A => net_gnd0,
      BRAM_WEN_A => net_gnd4,
      BRAM_Addr_A => net_gnd32,
      BRAM_Din_A => open,
      BRAM_Dout_A => net_gnd32,
      BRAM_Rst_B => xps_hw_thread_bram_cntlr_PORTA_BRAM_Rst,
      BRAM_Clk_B => xps_hw_thread_bram_cntlr_PORTA_BRAM_Clk,
      BRAM_EN_B => xps_hw_thread_bram_cntlr_PORTA_BRAM_EN,
      BRAM_WEN_B => xps_hw_thread_bram_cntlr_PORTA_BRAM_WEN,
      BRAM_Addr_B => xps_hw_thread_bram_cntlr_PORTA_BRAM_Addr,
      BRAM_Din_B => xps_hw_thread_bram_cntlr_PORTA_BRAM_Din,
      BRAM_Dout_B => xps_hw_thread_bram_cntlr_PORTA_BRAM_Dout
    );

  microblaze_0 : microblaze_0_wrapper
    port map (
      CLK => sys_clk_s,
      RESET => mb_dlmb_OPB_Rst,
      MB_RESET => net_gnd0,
      INTERRUPT => net_gnd0,
      EXT_BRK => Ext_BRK,
      EXT_NM_BRK => Ext_NM_BRK,
      DBG_STOP => net_gnd0,
      MB_Halted => open,
      INSTR => mb_ilmb_LMB_ReadDBus,
      I_ADDRTAG => open,
      IREADY => mb_ilmb_LMB_Ready,
      IWAIT => net_gnd0,
      INSTR_ADDR => mb_ilmb_M_ABus,
      IFETCH => mb_ilmb_M_ReadStrobe,
      I_AS => mb_ilmb_M_AddrStrobe,
      IPLB_M_ABort => mb0_plb_bus_M_ABort(1),
      IPLB_M_ABus => mb0_plb_bus_M_ABus(32 to 63),
      IPLB_M_UABus => mb0_plb_bus_M_UABus(32 to 63),
      IPLB_M_BE => mb0_plb_bus_M_BE(4 to 7),
      IPLB_M_busLock => mb0_plb_bus_M_busLock(1),
      IPLB_M_lockErr => mb0_plb_bus_M_lockErr(1),
      IPLB_M_MSize => mb0_plb_bus_M_MSize(2 to 3),
      IPLB_M_priority => mb0_plb_bus_M_priority(2 to 3),
      IPLB_M_rdBurst => mb0_plb_bus_M_rdBurst(1),
      IPLB_M_request => mb0_plb_bus_M_request(1),
      IPLB_M_RNW => mb0_plb_bus_M_RNW(1),
      IPLB_M_size => mb0_plb_bus_M_size(4 to 7),
      IPLB_M_TAttribute => mb0_plb_bus_M_TAttribute(16 to 31),
      IPLB_M_type => mb0_plb_bus_M_type(3 to 5),
      IPLB_M_wrBurst => mb0_plb_bus_M_wrBurst(1),
      IPLB_M_wrDBus => mb0_plb_bus_M_wrDBus(32 to 63),
      IPLB_MBusy => mb0_plb_bus_PLB_MBusy(1),
      IPLB_MRdErr => mb0_plb_bus_PLB_MRdErr(1),
      IPLB_MWrErr => mb0_plb_bus_PLB_MWrErr(1),
      IPLB_MIRQ => mb0_plb_bus_PLB_MIRQ(1),
      IPLB_MWrBTerm => mb0_plb_bus_PLB_MWrBTerm(1),
      IPLB_MWrDAck => mb0_plb_bus_PLB_MWrDAck(1),
      IPLB_MAddrAck => mb0_plb_bus_PLB_MAddrAck(1),
      IPLB_MRdBTerm => mb0_plb_bus_PLB_MRdBTerm(1),
      IPLB_MRdDAck => mb0_plb_bus_PLB_MRdDAck(1),
      IPLB_MRdDBus => mb0_plb_bus_PLB_MRdDBus(32 to 63),
      IPLB_MRdWdAddr => mb0_plb_bus_PLB_MRdWdAddr(4 to 7),
      IPLB_MRearbitrate => mb0_plb_bus_PLB_MRearbitrate(1),
      IPLB_MSSize => mb0_plb_bus_PLB_MSSize(2 to 3),
      IPLB_MTimeout => mb0_plb_bus_PLB_MTimeout(1),
      DATA_READ => mb_dlmb_LMB_ReadDBus,
      DREADY => mb_dlmb_LMB_Ready,
      DWAIT => net_gnd0,
      DATA_WRITE => mb_dlmb_M_DBus,
      DATA_ADDR => mb_dlmb_M_ABus,
      D_ADDRTAG => open,
      D_AS => mb_dlmb_M_AddrStrobe,
      READ_STROBE => mb_dlmb_M_ReadStrobe,
      WRITE_STROBE => mb_dlmb_M_WriteStrobe,
      BYTE_ENABLE => mb_dlmb_M_BE,
      DM_ABUS => open,
      DM_BE => open,
      DM_BUSLOCK => open,
      DM_DBUS => open,
      DM_REQUEST => open,
      DM_RNW => open,
      DM_SELECT => open,
      DM_SEQADDR => open,
      DOPB_DBUS => net_gnd32,
      DOPB_ERRACK => net_gnd0,
      DOPB_MGRANT => net_gnd0,
      DOPB_RETRY => net_gnd0,
      DOPB_TIMEOUT => net_gnd0,
      DOPB_XFERACK => net_gnd0,
      DPLB_M_ABort => mb0_plb_bus_M_ABort(0),
      DPLB_M_ABus => mb0_plb_bus_M_ABus(0 to 31),
      DPLB_M_UABus => mb0_plb_bus_M_UABus(0 to 31),
      DPLB_M_BE => mb0_plb_bus_M_BE(0 to 3),
      DPLB_M_busLock => mb0_plb_bus_M_busLock(0),
      DPLB_M_lockErr => mb0_plb_bus_M_lockErr(0),
      DPLB_M_MSize => mb0_plb_bus_M_MSize(0 to 1),
      DPLB_M_priority => mb0_plb_bus_M_priority(0 to 1),
      DPLB_M_rdBurst => mb0_plb_bus_M_rdBurst(0),
      DPLB_M_request => mb0_plb_bus_M_request(0),
      DPLB_M_RNW => mb0_plb_bus_M_RNW(0),
      DPLB_M_size => mb0_plb_bus_M_size(0 to 3),
      DPLB_M_TAttribute => mb0_plb_bus_M_TAttribute(0 to 15),
      DPLB_M_type => mb0_plb_bus_M_type(0 to 2),
      DPLB_M_wrBurst => mb0_plb_bus_M_wrBurst(0),
      DPLB_M_wrDBus => mb0_plb_bus_M_wrDBus(0 to 31),
      DPLB_MBusy => mb0_plb_bus_PLB_MBusy(0),
      DPLB_MRdErr => mb0_plb_bus_PLB_MRdErr(0),
      DPLB_MWrErr => mb0_plb_bus_PLB_MWrErr(0),
      DPLB_MIRQ => mb0_plb_bus_PLB_MIRQ(0),
      DPLB_MWrBTerm => mb0_plb_bus_PLB_MWrBTerm(0),
      DPLB_MWrDAck => mb0_plb_bus_PLB_MWrDAck(0),
      DPLB_MAddrAck => mb0_plb_bus_PLB_MAddrAck(0),
      DPLB_MRdBTerm => mb0_plb_bus_PLB_MRdBTerm(0),
      DPLB_MRdDAck => mb0_plb_bus_PLB_MRdDAck(0),
      DPLB_MRdDBus => mb0_plb_bus_PLB_MRdDBus(0 to 31),
      DPLB_MRdWdAddr => mb0_plb_bus_PLB_MRdWdAddr(0 to 3),
      DPLB_MRearbitrate => mb0_plb_bus_PLB_MRearbitrate(0),
      DPLB_MSSize => mb0_plb_bus_PLB_MSSize(0 to 1),
      DPLB_MTimeout => mb0_plb_bus_PLB_MTimeout(0),
      IM_ABUS => open,
      IM_BE => open,
      IM_BUSLOCK => open,
      IM_DBUS => open,
      IM_REQUEST => open,
      IM_RNW => open,
      IM_SELECT => open,
      IM_SEQADDR => open,
      IOPB_DBUS => net_gnd32,
      IOPB_ERRACK => net_gnd0,
      IOPB_MGRANT => net_gnd0,
      IOPB_RETRY => net_gnd0,
      IOPB_TIMEOUT => net_gnd0,
      IOPB_XFERACK => net_gnd0,
      DBG_CLK => microblaze_0_MBDEBUG_Dbg_Clk,
      DBG_TDI => microblaze_0_MBDEBUG_Dbg_TDI,
      DBG_TDO => microblaze_0_MBDEBUG_Dbg_TDO,
      DBG_REG_EN => microblaze_0_MBDEBUG_Dbg_Reg_En,
      DBG_SHIFT => microblaze_0_MBDEBUG_Dbg_Shift,
      DBG_CAPTURE => microblaze_0_MBDEBUG_Dbg_Capture,
      DBG_UPDATE => microblaze_0_MBDEBUG_Dbg_Update,
      DEBUG_RST => microblaze_0_MBDEBUG_Debug_Rst,
      Trace_Instruction => open,
      Trace_Valid_Instr => open,
      Trace_PC => open,
      Trace_Reg_Write => open,
      Trace_Reg_Addr => open,
      Trace_MSR_Reg => open,
      Trace_PID_Reg => open,
      Trace_New_Reg_Value => open,
      Trace_Exception_Taken => open,
      Trace_Exception_Kind => open,
      Trace_Jump_Taken => open,
      Trace_Delay_Slot => open,
      Trace_Data_Address => open,
      Trace_Data_Access => open,
      Trace_Data_Read => open,
      Trace_Data_Write => open,
      Trace_Data_Write_Value => open,
      Trace_Data_Byte_Enable => open,
      Trace_DCache_Req => open,
      Trace_DCache_Hit => open,
      Trace_ICache_Req => open,
      Trace_ICache_Hit => open,
      Trace_OF_PipeRun => open,
      Trace_EX_PipeRun => open,
      Trace_MEM_PipeRun => open,
      Trace_MB_Halted => open,
      FSL0_S_CLK => open,
      FSL0_S_READ => open,
      FSL0_S_DATA => net_gnd32,
      FSL0_S_CONTROL => net_gnd0,
      FSL0_S_EXISTS => net_gnd0,
      FSL0_M_CLK => open,
      FSL0_M_WRITE => open,
      FSL0_M_DATA => open,
      FSL0_M_CONTROL => open,
      FSL0_M_FULL => net_gnd0,
      FSL1_S_CLK => open,
      FSL1_S_READ => open,
      FSL1_S_DATA => net_gnd32,
      FSL1_S_CONTROL => net_gnd0,
      FSL1_S_EXISTS => net_gnd0,
      FSL1_M_CLK => open,
      FSL1_M_WRITE => open,
      FSL1_M_DATA => open,
      FSL1_M_CONTROL => open,
      FSL1_M_FULL => net_gnd0,
      FSL2_S_CLK => open,
      FSL2_S_READ => open,
      FSL2_S_DATA => net_gnd32,
      FSL2_S_CONTROL => net_gnd0,
      FSL2_S_EXISTS => net_gnd0,
      FSL2_M_CLK => open,
      FSL2_M_WRITE => open,
      FSL2_M_DATA => open,
      FSL2_M_CONTROL => open,
      FSL2_M_FULL => net_gnd0,
      FSL3_S_CLK => open,
      FSL3_S_READ => open,
      FSL3_S_DATA => net_gnd32,
      FSL3_S_CONTROL => net_gnd0,
      FSL3_S_EXISTS => net_gnd0,
      FSL3_M_CLK => open,
      FSL3_M_WRITE => open,
      FSL3_M_DATA => open,
      FSL3_M_CONTROL => open,
      FSL3_M_FULL => net_gnd0,
      FSL4_S_CLK => open,
      FSL4_S_READ => open,
      FSL4_S_DATA => net_gnd32,
      FSL4_S_CONTROL => net_gnd0,
      FSL4_S_EXISTS => net_gnd0,
      FSL4_M_CLK => open,
      FSL4_M_WRITE => open,
      FSL4_M_DATA => open,
      FSL4_M_CONTROL => open,
      FSL4_M_FULL => net_gnd0,
      FSL5_S_CLK => open,
      FSL5_S_READ => open,
      FSL5_S_DATA => net_gnd32,
      FSL5_S_CONTROL => net_gnd0,
      FSL5_S_EXISTS => net_gnd0,
      FSL5_M_CLK => open,
      FSL5_M_WRITE => open,
      FSL5_M_DATA => open,
      FSL5_M_CONTROL => open,
      FSL5_M_FULL => net_gnd0,
      FSL6_S_CLK => open,
      FSL6_S_READ => open,
      FSL6_S_DATA => net_gnd32,
      FSL6_S_CONTROL => net_gnd0,
      FSL6_S_EXISTS => net_gnd0,
      FSL6_M_CLK => open,
      FSL6_M_WRITE => open,
      FSL6_M_DATA => open,
      FSL6_M_CONTROL => open,
      FSL6_M_FULL => net_gnd0,
      FSL7_S_CLK => open,
      FSL7_S_READ => open,
      FSL7_S_DATA => net_gnd32,
      FSL7_S_CONTROL => net_gnd0,
      FSL7_S_EXISTS => net_gnd0,
      FSL7_M_CLK => open,
      FSL7_M_WRITE => open,
      FSL7_M_DATA => open,
      FSL7_M_CONTROL => open,
      FSL7_M_FULL => net_gnd0,
      FSL8_S_CLK => open,
      FSL8_S_READ => open,
      FSL8_S_DATA => net_gnd32,
      FSL8_S_CONTROL => net_gnd0,
      FSL8_S_EXISTS => net_gnd0,
      FSL8_M_CLK => open,
      FSL8_M_WRITE => open,
      FSL8_M_DATA => open,
      FSL8_M_CONTROL => open,
      FSL8_M_FULL => net_gnd0,
      FSL9_S_CLK => open,
      FSL9_S_READ => open,
      FSL9_S_DATA => net_gnd32,
      FSL9_S_CONTROL => net_gnd0,
      FSL9_S_EXISTS => net_gnd0,
      FSL9_M_CLK => open,
      FSL9_M_WRITE => open,
      FSL9_M_DATA => open,
      FSL9_M_CONTROL => open,
      FSL9_M_FULL => net_gnd0,
      FSL10_S_CLK => open,
      FSL10_S_READ => open,
      FSL10_S_DATA => net_gnd32,
      FSL10_S_CONTROL => net_gnd0,
      FSL10_S_EXISTS => net_gnd0,
      FSL10_M_CLK => open,
      FSL10_M_WRITE => open,
      FSL10_M_DATA => open,
      FSL10_M_CONTROL => open,
      FSL10_M_FULL => net_gnd0,
      FSL11_S_CLK => open,
      FSL11_S_READ => open,
      FSL11_S_DATA => net_gnd32,
      FSL11_S_CONTROL => net_gnd0,
      FSL11_S_EXISTS => net_gnd0,
      FSL11_M_CLK => open,
      FSL11_M_WRITE => open,
      FSL11_M_DATA => open,
      FSL11_M_CONTROL => open,
      FSL11_M_FULL => net_gnd0,
      FSL12_S_CLK => open,
      FSL12_S_READ => open,
      FSL12_S_DATA => net_gnd32,
      FSL12_S_CONTROL => net_gnd0,
      FSL12_S_EXISTS => net_gnd0,
      FSL12_M_CLK => open,
      FSL12_M_WRITE => open,
      FSL12_M_DATA => open,
      FSL12_M_CONTROL => open,
      FSL12_M_FULL => net_gnd0,
      FSL13_S_CLK => open,
      FSL13_S_READ => open,
      FSL13_S_DATA => net_gnd32,
      FSL13_S_CONTROL => net_gnd0,
      FSL13_S_EXISTS => net_gnd0,
      FSL13_M_CLK => open,
      FSL13_M_WRITE => open,
      FSL13_M_DATA => open,
      FSL13_M_CONTROL => open,
      FSL13_M_FULL => net_gnd0,
      FSL14_S_CLK => open,
      FSL14_S_READ => open,
      FSL14_S_DATA => net_gnd32,
      FSL14_S_CONTROL => net_gnd0,
      FSL14_S_EXISTS => net_gnd0,
      FSL14_M_CLK => open,
      FSL14_M_WRITE => open,
      FSL14_M_DATA => open,
      FSL14_M_CONTROL => open,
      FSL14_M_FULL => net_gnd0,
      FSL15_S_CLK => open,
      FSL15_S_READ => open,
      FSL15_S_DATA => net_gnd32,
      FSL15_S_CONTROL => net_gnd0,
      FSL15_S_EXISTS => net_gnd0,
      FSL15_M_CLK => open,
      FSL15_M_WRITE => open,
      FSL15_M_DATA => open,
      FSL15_M_CONTROL => open,
      FSL15_M_FULL => net_gnd0,
      ICACHE_FSL_IN_CLK => microblaze_0_IXCL_FSL_S_Clk,
      ICACHE_FSL_IN_READ => microblaze_0_IXCL_FSL_S_Read,
      ICACHE_FSL_IN_DATA => microblaze_0_IXCL_FSL_S_Data,
      ICACHE_FSL_IN_CONTROL => microblaze_0_IXCL_FSL_S_Control,
      ICACHE_FSL_IN_EXISTS => microblaze_0_IXCL_FSL_S_Exists,
      ICACHE_FSL_OUT_CLK => microblaze_0_IXCL_FSL_M_Clk,
      ICACHE_FSL_OUT_WRITE => microblaze_0_IXCL_FSL_M_Write,
      ICACHE_FSL_OUT_DATA => microblaze_0_IXCL_FSL_M_Data,
      ICACHE_FSL_OUT_CONTROL => microblaze_0_IXCL_FSL_M_Control,
      ICACHE_FSL_OUT_FULL => microblaze_0_IXCL_FSL_M_Full,
      DCACHE_FSL_IN_CLK => open,
      DCACHE_FSL_IN_READ => open,
      DCACHE_FSL_IN_DATA => net_gnd32,
      DCACHE_FSL_IN_CONTROL => net_gnd0,
      DCACHE_FSL_IN_EXISTS => net_gnd0,
      DCACHE_FSL_OUT_CLK => open,
      DCACHE_FSL_OUT_WRITE => open,
      DCACHE_FSL_OUT_DATA => open,
      DCACHE_FSL_OUT_CONTROL => open,
      DCACHE_FSL_OUT_FULL => net_gnd0
    );

  mb_ilmb : mb_ilmb_wrapper
    port map (
      LMB_Clk => sys_clk_s,
      SYS_Rst => sys_bus_reset(0),
      LMB_Rst => mb_ilmb_OPB_Rst,
      M_ABus => mb_ilmb_M_ABus,
      M_ReadStrobe => mb_ilmb_M_ReadStrobe,
      M_WriteStrobe => net_gnd0,
      M_AddrStrobe => mb_ilmb_M_AddrStrobe,
      M_DBus => net_gnd32,
      M_BE => net_gnd4,
      Sl_DBus => mb_ilmb_Sl_DBus,
      Sl_Ready => mb_ilmb_Sl_Ready(0 to 0),
      LMB_ABus => mb_ilmb_LMB_ABus,
      LMB_ReadStrobe => mb_ilmb_LMB_ReadStrobe,
      LMB_WriteStrobe => mb_ilmb_LMB_WriteStrobe,
      LMB_AddrStrobe => mb_ilmb_LMB_AddrStrobe,
      LMB_ReadDBus => mb_ilmb_LMB_ReadDBus,
      LMB_WriteDBus => mb_ilmb_LMB_WriteDBus,
      LMB_Ready => mb_ilmb_LMB_Ready,
      LMB_BE => mb_ilmb_LMB_BE
    );

  mb_dlmb : mb_dlmb_wrapper
    port map (
      LMB_Clk => sys_clk_s,
      SYS_Rst => sys_bus_reset(0),
      LMB_Rst => mb_dlmb_OPB_Rst,
      M_ABus => mb_dlmb_M_ABus,
      M_ReadStrobe => mb_dlmb_M_ReadStrobe,
      M_WriteStrobe => mb_dlmb_M_WriteStrobe,
      M_AddrStrobe => mb_dlmb_M_AddrStrobe,
      M_DBus => mb_dlmb_M_DBus,
      M_BE => mb_dlmb_M_BE,
      Sl_DBus => mb_dlmb_Sl_DBus,
      Sl_Ready => mb_dlmb_Sl_Ready(0 to 0),
      LMB_ABus => mb_dlmb_LMB_ABus,
      LMB_ReadStrobe => mb_dlmb_LMB_ReadStrobe,
      LMB_WriteStrobe => mb_dlmb_LMB_WriteStrobe,
      LMB_AddrStrobe => mb_dlmb_LMB_AddrStrobe,
      LMB_ReadDBus => mb_dlmb_LMB_ReadDBus,
      LMB_WriteDBus => mb_dlmb_LMB_WriteDBus,
      LMB_Ready => mb_dlmb_LMB_Ready,
      LMB_BE => mb_dlmb_LMB_BE
    );

  ilmb_cntlr : ilmb_cntlr_wrapper
    port map (
      LMB_Clk => sys_clk_s,
      LMB_Rst => mb_ilmb_OPB_Rst,
      LMB_ABus => mb_ilmb_LMB_ABus,
      LMB_WriteDBus => mb_ilmb_LMB_WriteDBus,
      LMB_AddrStrobe => mb_ilmb_LMB_AddrStrobe,
      LMB_ReadStrobe => mb_ilmb_LMB_ReadStrobe,
      LMB_WriteStrobe => mb_ilmb_LMB_WriteStrobe,
      LMB_BE => mb_ilmb_LMB_BE,
      Sl_DBus => mb_ilmb_Sl_DBus,
      Sl_Ready => mb_ilmb_Sl_Ready(0),
      BRAM_Rst_A => ilmb_cntlr_BRAM_PORT_BRAM_Rst,
      BRAM_Clk_A => ilmb_cntlr_BRAM_PORT_BRAM_Clk,
      BRAM_EN_A => ilmb_cntlr_BRAM_PORT_BRAM_EN,
      BRAM_WEN_A => ilmb_cntlr_BRAM_PORT_BRAM_WEN,
      BRAM_Addr_A => ilmb_cntlr_BRAM_PORT_BRAM_Addr,
      BRAM_Din_A => ilmb_cntlr_BRAM_PORT_BRAM_Din,
      BRAM_Dout_A => ilmb_cntlr_BRAM_PORT_BRAM_Dout
    );

  dlmb_cntlr : dlmb_cntlr_wrapper
    port map (
      LMB_Clk => sys_clk_s,
      LMB_Rst => mb_dlmb_OPB_Rst,
      LMB_ABus => mb_dlmb_LMB_ABus,
      LMB_WriteDBus => mb_dlmb_LMB_WriteDBus,
      LMB_AddrStrobe => mb_dlmb_LMB_AddrStrobe,
      LMB_ReadStrobe => mb_dlmb_LMB_ReadStrobe,
      LMB_WriteStrobe => mb_dlmb_LMB_WriteStrobe,
      LMB_BE => mb_dlmb_LMB_BE,
      Sl_DBus => mb_dlmb_Sl_DBus,
      Sl_Ready => mb_dlmb_Sl_Ready(0),
      BRAM_Rst_A => dlmb_cntlr_BRAM_PORT_BRAM_Rst,
      BRAM_Clk_A => dlmb_cntlr_BRAM_PORT_BRAM_Clk,
      BRAM_EN_A => dlmb_cntlr_BRAM_PORT_BRAM_EN,
      BRAM_WEN_A => dlmb_cntlr_BRAM_PORT_BRAM_WEN,
      BRAM_Addr_A => dlmb_cntlr_BRAM_PORT_BRAM_Addr,
      BRAM_Din_A => dlmb_cntlr_BRAM_PORT_BRAM_Din,
      BRAM_Dout_A => dlmb_cntlr_BRAM_PORT_BRAM_Dout
    );

  mb_bram : mb_bram_wrapper
    port map (
      BRAM_Rst_A => ilmb_cntlr_BRAM_PORT_BRAM_Rst,
      BRAM_Clk_A => ilmb_cntlr_BRAM_PORT_BRAM_Clk,
      BRAM_EN_A => ilmb_cntlr_BRAM_PORT_BRAM_EN,
      BRAM_WEN_A => ilmb_cntlr_BRAM_PORT_BRAM_WEN,
      BRAM_Addr_A => ilmb_cntlr_BRAM_PORT_BRAM_Addr,
      BRAM_Din_A => ilmb_cntlr_BRAM_PORT_BRAM_Din,
      BRAM_Dout_A => ilmb_cntlr_BRAM_PORT_BRAM_Dout,
      BRAM_Rst_B => dlmb_cntlr_BRAM_PORT_BRAM_Rst,
      BRAM_Clk_B => dlmb_cntlr_BRAM_PORT_BRAM_Clk,
      BRAM_EN_B => dlmb_cntlr_BRAM_PORT_BRAM_EN,
      BRAM_WEN_B => dlmb_cntlr_BRAM_PORT_BRAM_WEN,
      BRAM_Addr_B => dlmb_cntlr_BRAM_PORT_BRAM_Addr,
      BRAM_Din_B => dlmb_cntlr_BRAM_PORT_BRAM_Din,
      BRAM_Dout_B => dlmb_cntlr_BRAM_PORT_BRAM_Dout
    );

  mdm_0 : mdm_0_wrapper
    port map (
      Interrupt => open,
      Debug_SYS_Rst => Debug_SYS_Rst,
      Ext_BRK => Ext_BRK,
      Ext_NM_BRK => Ext_NM_BRK,
      SPLB_Clk => sys_clk_s,
      SPLB_Rst => plb_v46_0_SPLB_Rst(11),
      PLB_ABus => plb_v46_0_PLB_ABus,
      PLB_UABus => plb_v46_0_PLB_UABus,
      PLB_PAValid => plb_v46_0_PLB_PAValid,
      PLB_SAValid => plb_v46_0_PLB_SAValid,
      PLB_rdPrim => plb_v46_0_PLB_rdPrim(11),
      PLB_wrPrim => plb_v46_0_PLB_wrPrim(11),
      PLB_masterID => plb_v46_0_PLB_masterID,
      PLB_abort => plb_v46_0_PLB_abort,
      PLB_busLock => plb_v46_0_PLB_busLock,
      PLB_RNW => plb_v46_0_PLB_RNW,
      PLB_BE => plb_v46_0_PLB_BE,
      PLB_MSize => plb_v46_0_PLB_MSize,
      PLB_size => plb_v46_0_PLB_size,
      PLB_type => plb_v46_0_PLB_type,
      PLB_lockErr => plb_v46_0_PLB_lockErr,
      PLB_wrDBus => plb_v46_0_PLB_wrDBus,
      PLB_wrBurst => plb_v46_0_PLB_wrBurst,
      PLB_rdBurst => plb_v46_0_PLB_rdBurst,
      PLB_wrPendReq => plb_v46_0_PLB_wrPendReq,
      PLB_rdPendReq => plb_v46_0_PLB_rdPendReq,
      PLB_wrPendPri => plb_v46_0_PLB_wrPendPri,
      PLB_rdPendPri => plb_v46_0_PLB_rdPendPri,
      PLB_reqPri => plb_v46_0_PLB_reqPri,
      PLB_TAttribute => plb_v46_0_PLB_TAttribute,
      Sl_addrAck => plb_v46_0_Sl_addrAck(11),
      Sl_SSize => plb_v46_0_Sl_SSize(22 to 23),
      Sl_wait => plb_v46_0_Sl_wait(11),
      Sl_rearbitrate => plb_v46_0_Sl_rearbitrate(11),
      Sl_wrDAck => plb_v46_0_Sl_wrDAck(11),
      Sl_wrComp => plb_v46_0_Sl_wrComp(11),
      Sl_wrBTerm => plb_v46_0_Sl_wrBTerm(11),
      Sl_rdDBus => plb_v46_0_Sl_rdDBus(1408 to 1535),
      Sl_rdWdAddr => plb_v46_0_Sl_rdWdAddr(44 to 47),
      Sl_rdDAck => plb_v46_0_Sl_rdDAck(11),
      Sl_rdComp => plb_v46_0_Sl_rdComp(11),
      Sl_rdBTerm => plb_v46_0_Sl_rdBTerm(11),
      Sl_MBusy => plb_v46_0_Sl_MBusy(88 to 95),
      Sl_MWrErr => plb_v46_0_Sl_MWrErr(88 to 95),
      Sl_MRdErr => plb_v46_0_Sl_MRdErr(88 to 95),
      Sl_MIRQ => plb_v46_0_Sl_MIRQ(88 to 95),
      OPB_Clk => net_gnd0,
      OPB_Rst => net_gnd0,
      OPB_ABus => net_gnd32,
      OPB_BE => net_gnd4,
      OPB_RNW => net_gnd0,
      OPB_select => net_gnd0,
      OPB_seqAddr => net_gnd0,
      OPB_DBus => net_gnd32,
      MDM_DBus => open,
      MDM_errAck => open,
      MDM_retry => open,
      MDM_toutSup => open,
      MDM_xferAck => open,
      Dbg_Clk_0 => microblaze_0_MBDEBUG_Dbg_Clk,
      Dbg_TDI_0 => microblaze_0_MBDEBUG_Dbg_TDI,
      Dbg_TDO_0 => microblaze_0_MBDEBUG_Dbg_TDO,
      Dbg_Reg_En_0 => microblaze_0_MBDEBUG_Dbg_Reg_En,
      Dbg_Capture_0 => microblaze_0_MBDEBUG_Dbg_Capture,
      Dbg_Shift_0 => microblaze_0_MBDEBUG_Dbg_Shift,
      Dbg_Update_0 => microblaze_0_MBDEBUG_Dbg_Update,
      Dbg_Rst_0 => microblaze_0_MBDEBUG_Debug_Rst,
      Dbg_Clk_1 => microblaze_1_MBDEBUG_Dbg_Clk,
      Dbg_TDI_1 => microblaze_1_MBDEBUG_Dbg_TDI,
      Dbg_TDO_1 => microblaze_1_MBDEBUG_Dbg_TDO,
      Dbg_Reg_En_1 => microblaze_1_MBDEBUG_Dbg_Reg_En,
      Dbg_Capture_1 => microblaze_1_MBDEBUG_Dbg_Capture,
      Dbg_Shift_1 => microblaze_1_MBDEBUG_Dbg_Shift,
      Dbg_Update_1 => microblaze_1_MBDEBUG_Dbg_Update,
      Dbg_Rst_1 => microblaze_1_MBDEBUG_Debug_Rst,
      Dbg_Clk_2 => microblaze_2_MBDEBUG_Dbg_Clk,
      Dbg_TDI_2 => microblaze_2_MBDEBUG_Dbg_TDI,
      Dbg_TDO_2 => microblaze_2_MBDEBUG_Dbg_TDO,
      Dbg_Reg_En_2 => microblaze_2_MBDEBUG_Dbg_Reg_En,
      Dbg_Capture_2 => microblaze_2_MBDEBUG_Dbg_Capture,
      Dbg_Shift_2 => microblaze_2_MBDEBUG_Dbg_Shift,
      Dbg_Update_2 => microblaze_2_MBDEBUG_Dbg_Update,
      Dbg_Rst_2 => microblaze_2_MBDEBUG_Debug_Rst,
      Dbg_Clk_3 => open,
      Dbg_TDI_3 => open,
      Dbg_TDO_3 => net_gnd0,
      Dbg_Reg_En_3 => open,
      Dbg_Capture_3 => open,
      Dbg_Shift_3 => open,
      Dbg_Update_3 => open,
      Dbg_Rst_3 => open,
      Dbg_Clk_4 => open,
      Dbg_TDI_4 => open,
      Dbg_TDO_4 => net_gnd0,
      Dbg_Reg_En_4 => open,
      Dbg_Capture_4 => open,
      Dbg_Shift_4 => open,
      Dbg_Update_4 => open,
      Dbg_Rst_4 => open,
      Dbg_Clk_5 => open,
      Dbg_TDI_5 => open,
      Dbg_TDO_5 => net_gnd0,
      Dbg_Reg_En_5 => open,
      Dbg_Capture_5 => open,
      Dbg_Shift_5 => open,
      Dbg_Update_5 => open,
      Dbg_Rst_5 => open,
      Dbg_Clk_6 => open,
      Dbg_TDI_6 => open,
      Dbg_TDO_6 => net_gnd0,
      Dbg_Reg_En_6 => open,
      Dbg_Capture_6 => open,
      Dbg_Shift_6 => open,
      Dbg_Update_6 => open,
      Dbg_Rst_6 => open,
      Dbg_Clk_7 => open,
      Dbg_TDI_7 => open,
      Dbg_TDO_7 => net_gnd0,
      Dbg_Reg_En_7 => open,
      Dbg_Capture_7 => open,
      Dbg_Shift_7 => open,
      Dbg_Update_7 => open,
      Dbg_Rst_7 => open,
      bscan_tdi => open,
      bscan_reset => open,
      bscan_shift => open,
      bscan_update => open,
      bscan_capture => open,
      bscan_sel1 => open,
      bscan_drck1 => open,
      bscan_tdo1 => net_gnd0,
      FSL0_S_CLK => open,
      FSL0_S_READ => open,
      FSL0_S_DATA => net_gnd32,
      FSL0_S_CONTROL => net_gnd0,
      FSL0_S_EXISTS => net_gnd0,
      FSL0_M_CLK => open,
      FSL0_M_WRITE => open,
      FSL0_M_DATA => open,
      FSL0_M_CONTROL => open,
      FSL0_M_FULL => net_gnd0,
      Ext_JTAG_DRCK => open,
      Ext_JTAG_RESET => open,
      Ext_JTAG_SEL => open,
      Ext_JTAG_CAPTURE => open,
      Ext_JTAG_SHIFT => open,
      Ext_JTAG_UPDATE => open,
      Ext_JTAG_TDI => open,
      Ext_JTAG_TDO => net_gnd0
    );

  microblaze_1 : microblaze_1_wrapper
    port map (
      CLK => sys_clk_s,
      RESET => mb_dlmb1_OPB_Rst,
      MB_RESET => net_gnd0,
      INTERRUPT => net_gnd0,
      EXT_BRK => Ext_BRK,
      EXT_NM_BRK => Ext_NM_BRK,
      DBG_STOP => net_gnd0,
      MB_Halted => open,
      INSTR => mb_ilmb1_LMB_ReadDBus,
      I_ADDRTAG => open,
      IREADY => mb_ilmb1_LMB_Ready,
      IWAIT => net_gnd0,
      INSTR_ADDR => mb_ilmb1_M_ABus,
      IFETCH => mb_ilmb1_M_ReadStrobe,
      I_AS => mb_ilmb1_M_AddrStrobe,
      IPLB_M_ABort => mb1_plb_bus_M_ABort(1),
      IPLB_M_ABus => mb1_plb_bus_M_ABus(32 to 63),
      IPLB_M_UABus => mb1_plb_bus_M_UABus(32 to 63),
      IPLB_M_BE => mb1_plb_bus_M_BE(4 to 7),
      IPLB_M_busLock => mb1_plb_bus_M_busLock(1),
      IPLB_M_lockErr => mb1_plb_bus_M_lockErr(1),
      IPLB_M_MSize => mb1_plb_bus_M_MSize(2 to 3),
      IPLB_M_priority => mb1_plb_bus_M_priority(2 to 3),
      IPLB_M_rdBurst => mb1_plb_bus_M_rdBurst(1),
      IPLB_M_request => mb1_plb_bus_M_request(1),
      IPLB_M_RNW => mb1_plb_bus_M_RNW(1),
      IPLB_M_size => mb1_plb_bus_M_size(4 to 7),
      IPLB_M_TAttribute => mb1_plb_bus_M_TAttribute(16 to 31),
      IPLB_M_type => mb1_plb_bus_M_type(3 to 5),
      IPLB_M_wrBurst => mb1_plb_bus_M_wrBurst(1),
      IPLB_M_wrDBus => mb1_plb_bus_M_wrDBus(32 to 63),
      IPLB_MBusy => mb1_plb_bus_PLB_MBusy(1),
      IPLB_MRdErr => mb1_plb_bus_PLB_MRdErr(1),
      IPLB_MWrErr => mb1_plb_bus_PLB_MWrErr(1),
      IPLB_MIRQ => mb1_plb_bus_PLB_MIRQ(1),
      IPLB_MWrBTerm => mb1_plb_bus_PLB_MWrBTerm(1),
      IPLB_MWrDAck => mb1_plb_bus_PLB_MWrDAck(1),
      IPLB_MAddrAck => mb1_plb_bus_PLB_MAddrAck(1),
      IPLB_MRdBTerm => mb1_plb_bus_PLB_MRdBTerm(1),
      IPLB_MRdDAck => mb1_plb_bus_PLB_MRdDAck(1),
      IPLB_MRdDBus => mb1_plb_bus_PLB_MRdDBus(32 to 63),
      IPLB_MRdWdAddr => mb1_plb_bus_PLB_MRdWdAddr(4 to 7),
      IPLB_MRearbitrate => mb1_plb_bus_PLB_MRearbitrate(1),
      IPLB_MSSize => mb1_plb_bus_PLB_MSSize(2 to 3),
      IPLB_MTimeout => mb1_plb_bus_PLB_MTimeout(1),
      DATA_READ => mb_dlmb1_LMB_ReadDBus,
      DREADY => mb_dlmb1_LMB_Ready,
      DWAIT => net_gnd0,
      DATA_WRITE => mb_dlmb1_M_DBus,
      DATA_ADDR => mb_dlmb1_M_ABus,
      D_ADDRTAG => open,
      D_AS => mb_dlmb1_M_AddrStrobe,
      READ_STROBE => mb_dlmb1_M_ReadStrobe,
      WRITE_STROBE => mb_dlmb1_M_WriteStrobe,
      BYTE_ENABLE => mb_dlmb1_M_BE,
      DM_ABUS => open,
      DM_BE => open,
      DM_BUSLOCK => open,
      DM_DBUS => open,
      DM_REQUEST => open,
      DM_RNW => open,
      DM_SELECT => open,
      DM_SEQADDR => open,
      DOPB_DBUS => net_gnd32,
      DOPB_ERRACK => net_gnd0,
      DOPB_MGRANT => net_gnd0,
      DOPB_RETRY => net_gnd0,
      DOPB_TIMEOUT => net_gnd0,
      DOPB_XFERACK => net_gnd0,
      DPLB_M_ABort => mb1_plb_bus_M_ABort(0),
      DPLB_M_ABus => mb1_plb_bus_M_ABus(0 to 31),
      DPLB_M_UABus => mb1_plb_bus_M_UABus(0 to 31),
      DPLB_M_BE => mb1_plb_bus_M_BE(0 to 3),
      DPLB_M_busLock => mb1_plb_bus_M_busLock(0),
      DPLB_M_lockErr => mb1_plb_bus_M_lockErr(0),
      DPLB_M_MSize => mb1_plb_bus_M_MSize(0 to 1),
      DPLB_M_priority => mb1_plb_bus_M_priority(0 to 1),
      DPLB_M_rdBurst => mb1_plb_bus_M_rdBurst(0),
      DPLB_M_request => mb1_plb_bus_M_request(0),
      DPLB_M_RNW => mb1_plb_bus_M_RNW(0),
      DPLB_M_size => mb1_plb_bus_M_size(0 to 3),
      DPLB_M_TAttribute => mb1_plb_bus_M_TAttribute(0 to 15),
      DPLB_M_type => mb1_plb_bus_M_type(0 to 2),
      DPLB_M_wrBurst => mb1_plb_bus_M_wrBurst(0),
      DPLB_M_wrDBus => mb1_plb_bus_M_wrDBus(0 to 31),
      DPLB_MBusy => mb1_plb_bus_PLB_MBusy(0),
      DPLB_MRdErr => mb1_plb_bus_PLB_MRdErr(0),
      DPLB_MWrErr => mb1_plb_bus_PLB_MWrErr(0),
      DPLB_MIRQ => mb1_plb_bus_PLB_MIRQ(0),
      DPLB_MWrBTerm => mb1_plb_bus_PLB_MWrBTerm(0),
      DPLB_MWrDAck => mb1_plb_bus_PLB_MWrDAck(0),
      DPLB_MAddrAck => mb1_plb_bus_PLB_MAddrAck(0),
      DPLB_MRdBTerm => mb1_plb_bus_PLB_MRdBTerm(0),
      DPLB_MRdDAck => mb1_plb_bus_PLB_MRdDAck(0),
      DPLB_MRdDBus => mb1_plb_bus_PLB_MRdDBus(0 to 31),
      DPLB_MRdWdAddr => mb1_plb_bus_PLB_MRdWdAddr(0 to 3),
      DPLB_MRearbitrate => mb1_plb_bus_PLB_MRearbitrate(0),
      DPLB_MSSize => mb1_plb_bus_PLB_MSSize(0 to 1),
      DPLB_MTimeout => mb1_plb_bus_PLB_MTimeout(0),
      IM_ABUS => open,
      IM_BE => open,
      IM_BUSLOCK => open,
      IM_DBUS => open,
      IM_REQUEST => open,
      IM_RNW => open,
      IM_SELECT => open,
      IM_SEQADDR => open,
      IOPB_DBUS => net_gnd32,
      IOPB_ERRACK => net_gnd0,
      IOPB_MGRANT => net_gnd0,
      IOPB_RETRY => net_gnd0,
      IOPB_TIMEOUT => net_gnd0,
      IOPB_XFERACK => net_gnd0,
      DBG_CLK => microblaze_1_MBDEBUG_Dbg_Clk,
      DBG_TDI => microblaze_1_MBDEBUG_Dbg_TDI,
      DBG_TDO => microblaze_1_MBDEBUG_Dbg_TDO,
      DBG_REG_EN => microblaze_1_MBDEBUG_Dbg_Reg_En,
      DBG_SHIFT => microblaze_1_MBDEBUG_Dbg_Shift,
      DBG_CAPTURE => microblaze_1_MBDEBUG_Dbg_Capture,
      DBG_UPDATE => microblaze_1_MBDEBUG_Dbg_Update,
      DEBUG_RST => microblaze_1_MBDEBUG_Debug_Rst,
      Trace_Instruction => open,
      Trace_Valid_Instr => open,
      Trace_PC => open,
      Trace_Reg_Write => open,
      Trace_Reg_Addr => open,
      Trace_MSR_Reg => open,
      Trace_PID_Reg => open,
      Trace_New_Reg_Value => open,
      Trace_Exception_Taken => open,
      Trace_Exception_Kind => open,
      Trace_Jump_Taken => open,
      Trace_Delay_Slot => open,
      Trace_Data_Address => open,
      Trace_Data_Access => open,
      Trace_Data_Read => open,
      Trace_Data_Write => open,
      Trace_Data_Write_Value => open,
      Trace_Data_Byte_Enable => open,
      Trace_DCache_Req => open,
      Trace_DCache_Hit => open,
      Trace_ICache_Req => open,
      Trace_ICache_Hit => open,
      Trace_OF_PipeRun => open,
      Trace_EX_PipeRun => open,
      Trace_MEM_PipeRun => open,
      Trace_MB_Halted => open,
      FSL0_S_CLK => open,
      FSL0_S_READ => open,
      FSL0_S_DATA => net_gnd32,
      FSL0_S_CONTROL => net_gnd0,
      FSL0_S_EXISTS => net_gnd0,
      FSL0_M_CLK => open,
      FSL0_M_WRITE => open,
      FSL0_M_DATA => open,
      FSL0_M_CONTROL => open,
      FSL0_M_FULL => net_gnd0,
      FSL1_S_CLK => open,
      FSL1_S_READ => open,
      FSL1_S_DATA => net_gnd32,
      FSL1_S_CONTROL => net_gnd0,
      FSL1_S_EXISTS => net_gnd0,
      FSL1_M_CLK => open,
      FSL1_M_WRITE => open,
      FSL1_M_DATA => open,
      FSL1_M_CONTROL => open,
      FSL1_M_FULL => net_gnd0,
      FSL2_S_CLK => open,
      FSL2_S_READ => open,
      FSL2_S_DATA => net_gnd32,
      FSL2_S_CONTROL => net_gnd0,
      FSL2_S_EXISTS => net_gnd0,
      FSL2_M_CLK => open,
      FSL2_M_WRITE => open,
      FSL2_M_DATA => open,
      FSL2_M_CONTROL => open,
      FSL2_M_FULL => net_gnd0,
      FSL3_S_CLK => open,
      FSL3_S_READ => open,
      FSL3_S_DATA => net_gnd32,
      FSL3_S_CONTROL => net_gnd0,
      FSL3_S_EXISTS => net_gnd0,
      FSL3_M_CLK => open,
      FSL3_M_WRITE => open,
      FSL3_M_DATA => open,
      FSL3_M_CONTROL => open,
      FSL3_M_FULL => net_gnd0,
      FSL4_S_CLK => open,
      FSL4_S_READ => open,
      FSL4_S_DATA => net_gnd32,
      FSL4_S_CONTROL => net_gnd0,
      FSL4_S_EXISTS => net_gnd0,
      FSL4_M_CLK => open,
      FSL4_M_WRITE => open,
      FSL4_M_DATA => open,
      FSL4_M_CONTROL => open,
      FSL4_M_FULL => net_gnd0,
      FSL5_S_CLK => open,
      FSL5_S_READ => open,
      FSL5_S_DATA => net_gnd32,
      FSL5_S_CONTROL => net_gnd0,
      FSL5_S_EXISTS => net_gnd0,
      FSL5_M_CLK => open,
      FSL5_M_WRITE => open,
      FSL5_M_DATA => open,
      FSL5_M_CONTROL => open,
      FSL5_M_FULL => net_gnd0,
      FSL6_S_CLK => open,
      FSL6_S_READ => open,
      FSL6_S_DATA => net_gnd32,
      FSL6_S_CONTROL => net_gnd0,
      FSL6_S_EXISTS => net_gnd0,
      FSL6_M_CLK => open,
      FSL6_M_WRITE => open,
      FSL6_M_DATA => open,
      FSL6_M_CONTROL => open,
      FSL6_M_FULL => net_gnd0,
      FSL7_S_CLK => open,
      FSL7_S_READ => open,
      FSL7_S_DATA => net_gnd32,
      FSL7_S_CONTROL => net_gnd0,
      FSL7_S_EXISTS => net_gnd0,
      FSL7_M_CLK => open,
      FSL7_M_WRITE => open,
      FSL7_M_DATA => open,
      FSL7_M_CONTROL => open,
      FSL7_M_FULL => net_gnd0,
      FSL8_S_CLK => open,
      FSL8_S_READ => open,
      FSL8_S_DATA => net_gnd32,
      FSL8_S_CONTROL => net_gnd0,
      FSL8_S_EXISTS => net_gnd0,
      FSL8_M_CLK => open,
      FSL8_M_WRITE => open,
      FSL8_M_DATA => open,
      FSL8_M_CONTROL => open,
      FSL8_M_FULL => net_gnd0,
      FSL9_S_CLK => open,
      FSL9_S_READ => open,
      FSL9_S_DATA => net_gnd32,
      FSL9_S_CONTROL => net_gnd0,
      FSL9_S_EXISTS => net_gnd0,
      FSL9_M_CLK => open,
      FSL9_M_WRITE => open,
      FSL9_M_DATA => open,
      FSL9_M_CONTROL => open,
      FSL9_M_FULL => net_gnd0,
      FSL10_S_CLK => open,
      FSL10_S_READ => open,
      FSL10_S_DATA => net_gnd32,
      FSL10_S_CONTROL => net_gnd0,
      FSL10_S_EXISTS => net_gnd0,
      FSL10_M_CLK => open,
      FSL10_M_WRITE => open,
      FSL10_M_DATA => open,
      FSL10_M_CONTROL => open,
      FSL10_M_FULL => net_gnd0,
      FSL11_S_CLK => open,
      FSL11_S_READ => open,
      FSL11_S_DATA => net_gnd32,
      FSL11_S_CONTROL => net_gnd0,
      FSL11_S_EXISTS => net_gnd0,
      FSL11_M_CLK => open,
      FSL11_M_WRITE => open,
      FSL11_M_DATA => open,
      FSL11_M_CONTROL => open,
      FSL11_M_FULL => net_gnd0,
      FSL12_S_CLK => open,
      FSL12_S_READ => open,
      FSL12_S_DATA => net_gnd32,
      FSL12_S_CONTROL => net_gnd0,
      FSL12_S_EXISTS => net_gnd0,
      FSL12_M_CLK => open,
      FSL12_M_WRITE => open,
      FSL12_M_DATA => open,
      FSL12_M_CONTROL => open,
      FSL12_M_FULL => net_gnd0,
      FSL13_S_CLK => open,
      FSL13_S_READ => open,
      FSL13_S_DATA => net_gnd32,
      FSL13_S_CONTROL => net_gnd0,
      FSL13_S_EXISTS => net_gnd0,
      FSL13_M_CLK => open,
      FSL13_M_WRITE => open,
      FSL13_M_DATA => open,
      FSL13_M_CONTROL => open,
      FSL13_M_FULL => net_gnd0,
      FSL14_S_CLK => open,
      FSL14_S_READ => open,
      FSL14_S_DATA => net_gnd32,
      FSL14_S_CONTROL => net_gnd0,
      FSL14_S_EXISTS => net_gnd0,
      FSL14_M_CLK => open,
      FSL14_M_WRITE => open,
      FSL14_M_DATA => open,
      FSL14_M_CONTROL => open,
      FSL14_M_FULL => net_gnd0,
      FSL15_S_CLK => open,
      FSL15_S_READ => open,
      FSL15_S_DATA => net_gnd32,
      FSL15_S_CONTROL => net_gnd0,
      FSL15_S_EXISTS => net_gnd0,
      FSL15_M_CLK => open,
      FSL15_M_WRITE => open,
      FSL15_M_DATA => open,
      FSL15_M_CONTROL => open,
      FSL15_M_FULL => net_gnd0,
      ICACHE_FSL_IN_CLK => microblaze_1_IXCL_FSL_S_Clk,
      ICACHE_FSL_IN_READ => microblaze_1_IXCL_FSL_S_Read,
      ICACHE_FSL_IN_DATA => microblaze_1_IXCL_FSL_S_Data,
      ICACHE_FSL_IN_CONTROL => microblaze_1_IXCL_FSL_S_Control,
      ICACHE_FSL_IN_EXISTS => microblaze_1_IXCL_FSL_S_Exists,
      ICACHE_FSL_OUT_CLK => microblaze_1_IXCL_FSL_M_Clk,
      ICACHE_FSL_OUT_WRITE => microblaze_1_IXCL_FSL_M_Write,
      ICACHE_FSL_OUT_DATA => microblaze_1_IXCL_FSL_M_Data,
      ICACHE_FSL_OUT_CONTROL => microblaze_1_IXCL_FSL_M_Control,
      ICACHE_FSL_OUT_FULL => microblaze_1_IXCL_FSL_M_Full,
      DCACHE_FSL_IN_CLK => open,
      DCACHE_FSL_IN_READ => open,
      DCACHE_FSL_IN_DATA => net_gnd32,
      DCACHE_FSL_IN_CONTROL => net_gnd0,
      DCACHE_FSL_IN_EXISTS => net_gnd0,
      DCACHE_FSL_OUT_CLK => open,
      DCACHE_FSL_OUT_WRITE => open,
      DCACHE_FSL_OUT_DATA => open,
      DCACHE_FSL_OUT_CONTROL => open,
      DCACHE_FSL_OUT_FULL => net_gnd0
    );

  mb_ilmb1 : mb_ilmb1_wrapper
    port map (
      LMB_Clk => sys_clk_s,
      SYS_Rst => sys_bus_reset(0),
      LMB_Rst => mb_ilmb1_OPB_Rst,
      M_ABus => mb_ilmb1_M_ABus,
      M_ReadStrobe => mb_ilmb1_M_ReadStrobe,
      M_WriteStrobe => net_gnd0,
      M_AddrStrobe => mb_ilmb1_M_AddrStrobe,
      M_DBus => net_gnd32,
      M_BE => net_gnd4,
      Sl_DBus => mb_ilmb1_Sl_DBus,
      Sl_Ready => mb_ilmb1_Sl_Ready(0 to 0),
      LMB_ABus => mb_ilmb1_LMB_ABus,
      LMB_ReadStrobe => mb_ilmb1_LMB_ReadStrobe,
      LMB_WriteStrobe => mb_ilmb1_LMB_WriteStrobe,
      LMB_AddrStrobe => mb_ilmb1_LMB_AddrStrobe,
      LMB_ReadDBus => mb_ilmb1_LMB_ReadDBus,
      LMB_WriteDBus => mb_ilmb1_LMB_WriteDBus,
      LMB_Ready => mb_ilmb1_LMB_Ready,
      LMB_BE => mb_ilmb1_LMB_BE
    );

  mb_dlmb1 : mb_dlmb1_wrapper
    port map (
      LMB_Clk => sys_clk_s,
      SYS_Rst => sys_bus_reset(0),
      LMB_Rst => mb_dlmb1_OPB_Rst,
      M_ABus => mb_dlmb1_M_ABus,
      M_ReadStrobe => mb_dlmb1_M_ReadStrobe,
      M_WriteStrobe => mb_dlmb1_M_WriteStrobe,
      M_AddrStrobe => mb_dlmb1_M_AddrStrobe,
      M_DBus => mb_dlmb1_M_DBus,
      M_BE => mb_dlmb1_M_BE,
      Sl_DBus => mb_dlmb1_Sl_DBus,
      Sl_Ready => mb_dlmb1_Sl_Ready(0 to 0),
      LMB_ABus => mb_dlmb1_LMB_ABus,
      LMB_ReadStrobe => mb_dlmb1_LMB_ReadStrobe,
      LMB_WriteStrobe => mb_dlmb1_LMB_WriteStrobe,
      LMB_AddrStrobe => mb_dlmb1_LMB_AddrStrobe,
      LMB_ReadDBus => mb_dlmb1_LMB_ReadDBus,
      LMB_WriteDBus => mb_dlmb1_LMB_WriteDBus,
      LMB_Ready => mb_dlmb1_LMB_Ready,
      LMB_BE => mb_dlmb1_LMB_BE
    );

  ilmb_cntlr1 : ilmb_cntlr1_wrapper
    port map (
      LMB_Clk => sys_clk_s,
      LMB_Rst => mb_ilmb1_OPB_Rst,
      LMB_ABus => mb_ilmb1_LMB_ABus,
      LMB_WriteDBus => mb_ilmb1_LMB_WriteDBus,
      LMB_AddrStrobe => mb_ilmb1_LMB_AddrStrobe,
      LMB_ReadStrobe => mb_ilmb1_LMB_ReadStrobe,
      LMB_WriteStrobe => mb_ilmb1_LMB_WriteStrobe,
      LMB_BE => mb_ilmb1_LMB_BE,
      Sl_DBus => mb_ilmb1_Sl_DBus,
      Sl_Ready => mb_ilmb1_Sl_Ready(0),
      BRAM_Rst_A => ilmb_cntlr_BRAM_PORT1_BRAM_Rst,
      BRAM_Clk_A => ilmb_cntlr_BRAM_PORT1_BRAM_Clk,
      BRAM_EN_A => ilmb_cntlr_BRAM_PORT1_BRAM_EN,
      BRAM_WEN_A => ilmb_cntlr_BRAM_PORT1_BRAM_WEN,
      BRAM_Addr_A => ilmb_cntlr_BRAM_PORT1_BRAM_Addr,
      BRAM_Din_A => ilmb_cntlr_BRAM_PORT1_BRAM_Din,
      BRAM_Dout_A => ilmb_cntlr_BRAM_PORT1_BRAM_Dout
    );

  dlmb_cntlr1 : dlmb_cntlr1_wrapper
    port map (
      LMB_Clk => sys_clk_s,
      LMB_Rst => mb_dlmb1_OPB_Rst,
      LMB_ABus => mb_dlmb1_LMB_ABus,
      LMB_WriteDBus => mb_dlmb1_LMB_WriteDBus,
      LMB_AddrStrobe => mb_dlmb1_LMB_AddrStrobe,
      LMB_ReadStrobe => mb_dlmb1_LMB_ReadStrobe,
      LMB_WriteStrobe => mb_dlmb1_LMB_WriteStrobe,
      LMB_BE => mb_dlmb1_LMB_BE,
      Sl_DBus => mb_dlmb1_Sl_DBus,
      Sl_Ready => mb_dlmb1_Sl_Ready(0),
      BRAM_Rst_A => dlmb_cntlr_BRAM_PORT1_BRAM_Rst,
      BRAM_Clk_A => dlmb_cntlr_BRAM_PORT1_BRAM_Clk,
      BRAM_EN_A => dlmb_cntlr_BRAM_PORT1_BRAM_EN,
      BRAM_WEN_A => dlmb_cntlr_BRAM_PORT1_BRAM_WEN,
      BRAM_Addr_A => dlmb_cntlr_BRAM_PORT1_BRAM_Addr,
      BRAM_Din_A => dlmb_cntlr_BRAM_PORT1_BRAM_Din,
      BRAM_Dout_A => dlmb_cntlr_BRAM_PORT1_BRAM_Dout
    );

  mb_bram1 : mb_bram1_wrapper
    port map (
      BRAM_Rst_A => ilmb_cntlr_BRAM_PORT1_BRAM_Rst,
      BRAM_Clk_A => ilmb_cntlr_BRAM_PORT1_BRAM_Clk,
      BRAM_EN_A => ilmb_cntlr_BRAM_PORT1_BRAM_EN,
      BRAM_WEN_A => ilmb_cntlr_BRAM_PORT1_BRAM_WEN,
      BRAM_Addr_A => ilmb_cntlr_BRAM_PORT1_BRAM_Addr,
      BRAM_Din_A => ilmb_cntlr_BRAM_PORT1_BRAM_Din,
      BRAM_Dout_A => ilmb_cntlr_BRAM_PORT1_BRAM_Dout,
      BRAM_Rst_B => dlmb_cntlr_BRAM_PORT1_BRAM_Rst,
      BRAM_Clk_B => dlmb_cntlr_BRAM_PORT1_BRAM_Clk,
      BRAM_EN_B => dlmb_cntlr_BRAM_PORT1_BRAM_EN,
      BRAM_WEN_B => dlmb_cntlr_BRAM_PORT1_BRAM_WEN,
      BRAM_Addr_B => dlmb_cntlr_BRAM_PORT1_BRAM_Addr,
      BRAM_Din_B => dlmb_cntlr_BRAM_PORT1_BRAM_Din,
      BRAM_Dout_B => dlmb_cntlr_BRAM_PORT1_BRAM_Dout
    );

  mb0_plb_bridge : mb0_plb_bridge_wrapper
    port map (
      SPLB_Clk => sys_clk_s,
      SPLB_Rst => mb0_plb_bus_SPLB_Rst(0),
      IP2INTC_Irpt => open,
      PLB_ABus => mb0_plb_bus_PLB_ABus,
      PLB_UABus => mb0_plb_bus_PLB_UABus,
      PLB_PAValid => mb0_plb_bus_PLB_PAValid,
      PLB_SAValid => mb0_plb_bus_PLB_SAValid,
      PLB_rdPrim => mb0_plb_bus_PLB_rdPrim(0),
      PLB_wrPrim => mb0_plb_bus_PLB_wrPrim(0),
      PLB_masterID => mb0_plb_bus_PLB_masterID(0 to 0),
      PLB_abort => mb0_plb_bus_PLB_abort,
      PLB_busLock => mb0_plb_bus_PLB_busLock,
      PLB_RNW => mb0_plb_bus_PLB_RNW,
      PLB_BE => mb0_plb_bus_PLB_BE,
      PLB_MSize => mb0_plb_bus_PLB_MSize,
      PLB_size => mb0_plb_bus_PLB_size,
      PLB_type => mb0_plb_bus_PLB_type,
      PLB_lockErr => mb0_plb_bus_PLB_lockErr,
      PLB_wrDBus => mb0_plb_bus_PLB_wrDBus,
      PLB_wrBurst => mb0_plb_bus_PLB_wrBurst,
      PLB_rdBurst => mb0_plb_bus_PLB_rdBurst,
      PLB_wrPendReq => mb0_plb_bus_PLB_wrPendReq,
      PLB_rdPendReq => mb0_plb_bus_PLB_rdPendReq,
      PLB_wrPendPri => mb0_plb_bus_PLB_wrPendPri,
      PLB_rdPendPri => mb0_plb_bus_PLB_rdPendPri,
      PLB_reqPri => mb0_plb_bus_PLB_reqPri,
      PLB_TAttribute => mb0_plb_bus_PLB_TAttribute,
      Sl_addrAck => mb0_plb_bus_Sl_addrAck(0),
      Sl_SSize => mb0_plb_bus_Sl_SSize,
      Sl_wait => mb0_plb_bus_Sl_wait(0),
      Sl_rearbitrate => mb0_plb_bus_Sl_rearbitrate(0),
      Sl_wrDAck => mb0_plb_bus_Sl_wrDAck(0),
      Sl_wrComp => mb0_plb_bus_Sl_wrComp(0),
      Sl_wrBTerm => mb0_plb_bus_Sl_wrBTerm(0),
      Sl_rdDBus => mb0_plb_bus_Sl_rdDBus,
      Sl_rdWdAddr => mb0_plb_bus_Sl_rdWdAddr,
      Sl_rdDAck => mb0_plb_bus_Sl_rdDAck(0),
      Sl_rdComp => mb0_plb_bus_Sl_rdComp(0),
      Sl_rdBTerm => mb0_plb_bus_Sl_rdBTerm(0),
      Sl_MBusy => mb0_plb_bus_Sl_MBusy,
      Sl_MWrErr => mb0_plb_bus_Sl_MWrErr,
      Sl_MRdErr => mb0_plb_bus_Sl_MRdErr,
      Sl_MIRQ => mb0_plb_bus_Sl_MIRQ,
      MPLB_Clk => sys_clk_s,
      MPLB_Rst => plb_v46_0_MPLB_Rst(2),
      M_request => plb_v46_0_M_request(2),
      M_priority => plb_v46_0_M_priority(4 to 5),
      M_busLock => plb_v46_0_M_busLock(2),
      M_RNW => plb_v46_0_M_RNW(2),
      M_BE => plb_v46_0_M_BE(32 to 47),
      M_MSize => plb_v46_0_M_MSize(4 to 5),
      M_size => plb_v46_0_M_size(8 to 11),
      M_type => plb_v46_0_M_type(6 to 8),
      M_ABus => plb_v46_0_M_ABus(64 to 95),
      M_wrBurst => plb_v46_0_M_wrBurst(2),
      M_rdBurst => plb_v46_0_M_rdBurst(2),
      M_wrDBus => plb_v46_0_M_wrDBus(256 to 383),
      PLB_MAddrAck => plb_v46_0_PLB_MAddrAck(2),
      PLB_MSSize => plb_v46_0_PLB_MSSize(4 to 5),
      PLB_MRearbitrate => plb_v46_0_PLB_MRearbitrate(2),
      PLB_MTimeout => plb_v46_0_PLB_MTimeout(2),
      PLB_MRdErr => plb_v46_0_PLB_MRdErr(2),
      PLB_MWrErr => plb_v46_0_PLB_MWrErr(2),
      PLB_MRdDBus => plb_v46_0_PLB_MRdDBus(256 to 383),
      PLB_MRdDAck => plb_v46_0_PLB_MRdDAck(2),
      PLB_MRdBTerm => plb_v46_0_PLB_MRdBTerm(2),
      PLB_MWrDAck => plb_v46_0_PLB_MWrDAck(2),
      PLB_MWrBTerm => plb_v46_0_PLB_MWrBTerm(2),
      M_TAttribute => plb_v46_0_M_TAttribute(32 to 47),
      M_lockErr => plb_v46_0_M_lockErr(2),
      M_abort => plb_v46_0_M_abort(2),
      M_UABus => plb_v46_0_M_UABus(64 to 95),
      PLB_MBusy => plb_v46_0_PLB_MBusy(2),
      PLB_MIRQ => plb_v46_0_PLB_MIRQ(2),
      PLB_MRdWdAddr => plb_v46_0_PLB_MRdWdAddr(8 to 11)
    );

  mb0_plb_bus : mb0_plb_bus_wrapper
    port map (
      PLB_Clk => sys_clk_s,
      SYS_Rst => sys_bus_reset(0),
      PLB_Rst => open,
      SPLB_Rst => mb0_plb_bus_SPLB_Rst(0 to 0),
      MPLB_Rst => open,
      PLB_dcrAck => open,
      PLB_dcrDBus => open,
      DCR_ABus => net_gnd10,
      DCR_DBus => net_gnd32,
      DCR_Read => net_gnd0,
      DCR_Write => net_gnd0,
      M_ABus => mb0_plb_bus_M_ABus,
      M_UABus => mb0_plb_bus_M_UABus,
      M_BE => mb0_plb_bus_M_BE,
      M_RNW => mb0_plb_bus_M_RNW,
      M_abort => mb0_plb_bus_M_ABort,
      M_busLock => mb0_plb_bus_M_busLock,
      M_TAttribute => mb0_plb_bus_M_TAttribute,
      M_lockErr => mb0_plb_bus_M_lockErr,
      M_MSize => mb0_plb_bus_M_MSize,
      M_priority => mb0_plb_bus_M_priority,
      M_rdBurst => mb0_plb_bus_M_rdBurst,
      M_request => mb0_plb_bus_M_request,
      M_size => mb0_plb_bus_M_size,
      M_type => mb0_plb_bus_M_type,
      M_wrBurst => mb0_plb_bus_M_wrBurst,
      M_wrDBus => mb0_plb_bus_M_wrDBus,
      Sl_addrAck => mb0_plb_bus_Sl_addrAck(0 to 0),
      Sl_MRdErr => mb0_plb_bus_Sl_MRdErr,
      Sl_MWrErr => mb0_plb_bus_Sl_MWrErr,
      Sl_MBusy => mb0_plb_bus_Sl_MBusy,
      Sl_rdBTerm => mb0_plb_bus_Sl_rdBTerm(0 to 0),
      Sl_rdComp => mb0_plb_bus_Sl_rdComp(0 to 0),
      Sl_rdDAck => mb0_plb_bus_Sl_rdDAck(0 to 0),
      Sl_rdDBus => mb0_plb_bus_Sl_rdDBus,
      Sl_rdWdAddr => mb0_plb_bus_Sl_rdWdAddr,
      Sl_rearbitrate => mb0_plb_bus_Sl_rearbitrate(0 to 0),
      Sl_SSize => mb0_plb_bus_Sl_SSize,
      Sl_wait => mb0_plb_bus_Sl_wait(0 to 0),
      Sl_wrBTerm => mb0_plb_bus_Sl_wrBTerm(0 to 0),
      Sl_wrComp => mb0_plb_bus_Sl_wrComp(0 to 0),
      Sl_wrDAck => mb0_plb_bus_Sl_wrDAck(0 to 0),
      Sl_MIRQ => mb0_plb_bus_Sl_MIRQ,
      PLB_MIRQ => mb0_plb_bus_PLB_MIRQ,
      PLB_ABus => mb0_plb_bus_PLB_ABus,
      PLB_UABus => mb0_plb_bus_PLB_UABus,
      PLB_BE => mb0_plb_bus_PLB_BE,
      PLB_MAddrAck => mb0_plb_bus_PLB_MAddrAck,
      PLB_MTimeout => mb0_plb_bus_PLB_MTimeout,
      PLB_MBusy => mb0_plb_bus_PLB_MBusy,
      PLB_MRdErr => mb0_plb_bus_PLB_MRdErr,
      PLB_MWrErr => mb0_plb_bus_PLB_MWrErr,
      PLB_MRdBTerm => mb0_plb_bus_PLB_MRdBTerm,
      PLB_MRdDAck => mb0_plb_bus_PLB_MRdDAck,
      PLB_MRdDBus => mb0_plb_bus_PLB_MRdDBus,
      PLB_MRdWdAddr => mb0_plb_bus_PLB_MRdWdAddr,
      PLB_MRearbitrate => mb0_plb_bus_PLB_MRearbitrate,
      PLB_MWrBTerm => mb0_plb_bus_PLB_MWrBTerm,
      PLB_MWrDAck => mb0_plb_bus_PLB_MWrDAck,
      PLB_MSSize => mb0_plb_bus_PLB_MSSize,
      PLB_PAValid => mb0_plb_bus_PLB_PAValid,
      PLB_RNW => mb0_plb_bus_PLB_RNW,
      PLB_SAValid => mb0_plb_bus_PLB_SAValid,
      PLB_abort => mb0_plb_bus_PLB_abort,
      PLB_busLock => mb0_plb_bus_PLB_busLock,
      PLB_TAttribute => mb0_plb_bus_PLB_TAttribute,
      PLB_lockErr => mb0_plb_bus_PLB_lockErr,
      PLB_masterID => mb0_plb_bus_PLB_masterID(0 to 0),
      PLB_MSize => mb0_plb_bus_PLB_MSize,
      PLB_rdPendPri => mb0_plb_bus_PLB_rdPendPri,
      PLB_wrPendPri => mb0_plb_bus_PLB_wrPendPri,
      PLB_rdPendReq => mb0_plb_bus_PLB_rdPendReq,
      PLB_wrPendReq => mb0_plb_bus_PLB_wrPendReq,
      PLB_rdBurst => mb0_plb_bus_PLB_rdBurst,
      PLB_rdPrim => mb0_plb_bus_PLB_rdPrim(0 to 0),
      PLB_reqPri => mb0_plb_bus_PLB_reqPri,
      PLB_size => mb0_plb_bus_PLB_size,
      PLB_type => mb0_plb_bus_PLB_type,
      PLB_wrBurst => mb0_plb_bus_PLB_wrBurst,
      PLB_wrDBus => mb0_plb_bus_PLB_wrDBus,
      PLB_wrPrim => mb0_plb_bus_PLB_wrPrim(0 to 0),
      PLB_SaddrAck => open,
      PLB_SMRdErr => open,
      PLB_SMWrErr => open,
      PLB_SMBusy => open,
      PLB_SrdBTerm => open,
      PLB_SrdComp => open,
      PLB_SrdDAck => open,
      PLB_SrdDBus => open,
      PLB_SrdWdAddr => open,
      PLB_Srearbitrate => open,
      PLB_Sssize => open,
      PLB_Swait => open,
      PLB_SwrBTerm => open,
      PLB_SwrComp => open,
      PLB_SwrDAck => open,
      Bus_Error_Det => open
    );

  mb1_plb_bridge : mb1_plb_bridge_wrapper
    port map (
      SPLB_Clk => sys_clk_s,
      SPLB_Rst => mb1_plb_bus_SPLB_Rst(0),
      IP2INTC_Irpt => open,
      PLB_ABus => mb1_plb_bus_PLB_ABus,
      PLB_UABus => mb1_plb_bus_PLB_UABus,
      PLB_PAValid => mb1_plb_bus_PLB_PAValid,
      PLB_SAValid => mb1_plb_bus_PLB_SAValid,
      PLB_rdPrim => mb1_plb_bus_PLB_rdPrim(0),
      PLB_wrPrim => mb1_plb_bus_PLB_wrPrim(0),
      PLB_masterID => mb1_plb_bus_PLB_masterID(0 to 0),
      PLB_abort => mb1_plb_bus_PLB_abort,
      PLB_busLock => mb1_plb_bus_PLB_busLock,
      PLB_RNW => mb1_plb_bus_PLB_RNW,
      PLB_BE => mb1_plb_bus_PLB_BE,
      PLB_MSize => mb1_plb_bus_PLB_MSize,
      PLB_size => mb1_plb_bus_PLB_size,
      PLB_type => mb1_plb_bus_PLB_type,
      PLB_lockErr => mb1_plb_bus_PLB_lockErr,
      PLB_wrDBus => mb1_plb_bus_PLB_wrDBus,
      PLB_wrBurst => mb1_plb_bus_PLB_wrBurst,
      PLB_rdBurst => mb1_plb_bus_PLB_rdBurst,
      PLB_wrPendReq => mb1_plb_bus_PLB_wrPendReq,
      PLB_rdPendReq => mb1_plb_bus_PLB_rdPendReq,
      PLB_wrPendPri => mb1_plb_bus_PLB_wrPendPri,
      PLB_rdPendPri => mb1_plb_bus_PLB_rdPendPri,
      PLB_reqPri => mb1_plb_bus_PLB_reqPri,
      PLB_TAttribute => mb1_plb_bus_PLB_TAttribute,
      Sl_addrAck => mb1_plb_bus_Sl_addrAck(0),
      Sl_SSize => mb1_plb_bus_Sl_SSize,
      Sl_wait => mb1_plb_bus_Sl_wait(0),
      Sl_rearbitrate => mb1_plb_bus_Sl_rearbitrate(0),
      Sl_wrDAck => mb1_plb_bus_Sl_wrDAck(0),
      Sl_wrComp => mb1_plb_bus_Sl_wrComp(0),
      Sl_wrBTerm => mb1_plb_bus_Sl_wrBTerm(0),
      Sl_rdDBus => mb1_plb_bus_Sl_rdDBus,
      Sl_rdWdAddr => mb1_plb_bus_Sl_rdWdAddr,
      Sl_rdDAck => mb1_plb_bus_Sl_rdDAck(0),
      Sl_rdComp => mb1_plb_bus_Sl_rdComp(0),
      Sl_rdBTerm => mb1_plb_bus_Sl_rdBTerm(0),
      Sl_MBusy => mb1_plb_bus_Sl_MBusy,
      Sl_MWrErr => mb1_plb_bus_Sl_MWrErr,
      Sl_MRdErr => mb1_plb_bus_Sl_MRdErr,
      Sl_MIRQ => mb1_plb_bus_Sl_MIRQ,
      MPLB_Clk => sys_clk_s,
      MPLB_Rst => plb_v46_0_MPLB_Rst(3),
      M_request => plb_v46_0_M_request(3),
      M_priority => plb_v46_0_M_priority(6 to 7),
      M_busLock => plb_v46_0_M_busLock(3),
      M_RNW => plb_v46_0_M_RNW(3),
      M_BE => plb_v46_0_M_BE(48 to 63),
      M_MSize => plb_v46_0_M_MSize(6 to 7),
      M_size => plb_v46_0_M_size(12 to 15),
      M_type => plb_v46_0_M_type(9 to 11),
      M_ABus => plb_v46_0_M_ABus(96 to 127),
      M_wrBurst => plb_v46_0_M_wrBurst(3),
      M_rdBurst => plb_v46_0_M_rdBurst(3),
      M_wrDBus => plb_v46_0_M_wrDBus(384 to 511),
      PLB_MAddrAck => plb_v46_0_PLB_MAddrAck(3),
      PLB_MSSize => plb_v46_0_PLB_MSSize(6 to 7),
      PLB_MRearbitrate => plb_v46_0_PLB_MRearbitrate(3),
      PLB_MTimeout => plb_v46_0_PLB_MTimeout(3),
      PLB_MRdErr => plb_v46_0_PLB_MRdErr(3),
      PLB_MWrErr => plb_v46_0_PLB_MWrErr(3),
      PLB_MRdDBus => plb_v46_0_PLB_MRdDBus(384 to 511),
      PLB_MRdDAck => plb_v46_0_PLB_MRdDAck(3),
      PLB_MRdBTerm => plb_v46_0_PLB_MRdBTerm(3),
      PLB_MWrDAck => plb_v46_0_PLB_MWrDAck(3),
      PLB_MWrBTerm => plb_v46_0_PLB_MWrBTerm(3),
      M_TAttribute => plb_v46_0_M_TAttribute(48 to 63),
      M_lockErr => plb_v46_0_M_lockErr(3),
      M_abort => plb_v46_0_M_abort(3),
      M_UABus => plb_v46_0_M_UABus(96 to 127),
      PLB_MBusy => plb_v46_0_PLB_MBusy(3),
      PLB_MIRQ => plb_v46_0_PLB_MIRQ(3),
      PLB_MRdWdAddr => plb_v46_0_PLB_MRdWdAddr(12 to 15)
    );

  mb1_plb_bus : mb1_plb_bus_wrapper
    port map (
      PLB_Clk => sys_clk_s,
      SYS_Rst => sys_bus_reset(0),
      PLB_Rst => open,
      SPLB_Rst => mb1_plb_bus_SPLB_Rst(0 to 0),
      MPLB_Rst => open,
      PLB_dcrAck => open,
      PLB_dcrDBus => open,
      DCR_ABus => net_gnd10,
      DCR_DBus => net_gnd32,
      DCR_Read => net_gnd0,
      DCR_Write => net_gnd0,
      M_ABus => mb1_plb_bus_M_ABus,
      M_UABus => mb1_plb_bus_M_UABus,
      M_BE => mb1_plb_bus_M_BE,
      M_RNW => mb1_plb_bus_M_RNW,
      M_abort => mb1_plb_bus_M_ABort,
      M_busLock => mb1_plb_bus_M_busLock,
      M_TAttribute => mb1_plb_bus_M_TAttribute,
      M_lockErr => mb1_plb_bus_M_lockErr,
      M_MSize => mb1_plb_bus_M_MSize,
      M_priority => mb1_plb_bus_M_priority,
      M_rdBurst => mb1_plb_bus_M_rdBurst,
      M_request => mb1_plb_bus_M_request,
      M_size => mb1_plb_bus_M_size,
      M_type => mb1_plb_bus_M_type,
      M_wrBurst => mb1_plb_bus_M_wrBurst,
      M_wrDBus => mb1_plb_bus_M_wrDBus,
      Sl_addrAck => mb1_plb_bus_Sl_addrAck(0 to 0),
      Sl_MRdErr => mb1_plb_bus_Sl_MRdErr,
      Sl_MWrErr => mb1_plb_bus_Sl_MWrErr,
      Sl_MBusy => mb1_plb_bus_Sl_MBusy,
      Sl_rdBTerm => mb1_plb_bus_Sl_rdBTerm(0 to 0),
      Sl_rdComp => mb1_plb_bus_Sl_rdComp(0 to 0),
      Sl_rdDAck => mb1_plb_bus_Sl_rdDAck(0 to 0),
      Sl_rdDBus => mb1_plb_bus_Sl_rdDBus,
      Sl_rdWdAddr => mb1_plb_bus_Sl_rdWdAddr,
      Sl_rearbitrate => mb1_plb_bus_Sl_rearbitrate(0 to 0),
      Sl_SSize => mb1_plb_bus_Sl_SSize,
      Sl_wait => mb1_plb_bus_Sl_wait(0 to 0),
      Sl_wrBTerm => mb1_plb_bus_Sl_wrBTerm(0 to 0),
      Sl_wrComp => mb1_plb_bus_Sl_wrComp(0 to 0),
      Sl_wrDAck => mb1_plb_bus_Sl_wrDAck(0 to 0),
      Sl_MIRQ => mb1_plb_bus_Sl_MIRQ,
      PLB_MIRQ => mb1_plb_bus_PLB_MIRQ,
      PLB_ABus => mb1_plb_bus_PLB_ABus,
      PLB_UABus => mb1_plb_bus_PLB_UABus,
      PLB_BE => mb1_plb_bus_PLB_BE,
      PLB_MAddrAck => mb1_plb_bus_PLB_MAddrAck,
      PLB_MTimeout => mb1_plb_bus_PLB_MTimeout,
      PLB_MBusy => mb1_plb_bus_PLB_MBusy,
      PLB_MRdErr => mb1_plb_bus_PLB_MRdErr,
      PLB_MWrErr => mb1_plb_bus_PLB_MWrErr,
      PLB_MRdBTerm => mb1_plb_bus_PLB_MRdBTerm,
      PLB_MRdDAck => mb1_plb_bus_PLB_MRdDAck,
      PLB_MRdDBus => mb1_plb_bus_PLB_MRdDBus,
      PLB_MRdWdAddr => mb1_plb_bus_PLB_MRdWdAddr,
      PLB_MRearbitrate => mb1_plb_bus_PLB_MRearbitrate,
      PLB_MWrBTerm => mb1_plb_bus_PLB_MWrBTerm,
      PLB_MWrDAck => mb1_plb_bus_PLB_MWrDAck,
      PLB_MSSize => mb1_plb_bus_PLB_MSSize,
      PLB_PAValid => mb1_plb_bus_PLB_PAValid,
      PLB_RNW => mb1_plb_bus_PLB_RNW,
      PLB_SAValid => mb1_plb_bus_PLB_SAValid,
      PLB_abort => mb1_plb_bus_PLB_abort,
      PLB_busLock => mb1_plb_bus_PLB_busLock,
      PLB_TAttribute => mb1_plb_bus_PLB_TAttribute,
      PLB_lockErr => mb1_plb_bus_PLB_lockErr,
      PLB_masterID => mb1_plb_bus_PLB_masterID(0 to 0),
      PLB_MSize => mb1_plb_bus_PLB_MSize,
      PLB_rdPendPri => mb1_plb_bus_PLB_rdPendPri,
      PLB_wrPendPri => mb1_plb_bus_PLB_wrPendPri,
      PLB_rdPendReq => mb1_plb_bus_PLB_rdPendReq,
      PLB_wrPendReq => mb1_plb_bus_PLB_wrPendReq,
      PLB_rdBurst => mb1_plb_bus_PLB_rdBurst,
      PLB_rdPrim => mb1_plb_bus_PLB_rdPrim(0 to 0),
      PLB_reqPri => mb1_plb_bus_PLB_reqPri,
      PLB_size => mb1_plb_bus_PLB_size,
      PLB_type => mb1_plb_bus_PLB_type,
      PLB_wrBurst => mb1_plb_bus_PLB_wrBurst,
      PLB_wrDBus => mb1_plb_bus_PLB_wrDBus,
      PLB_wrPrim => mb1_plb_bus_PLB_wrPrim(0 to 0),
      PLB_SaddrAck => open,
      PLB_SMRdErr => open,
      PLB_SMWrErr => open,
      PLB_SMBusy => open,
      PLB_SrdBTerm => open,
      PLB_SrdComp => open,
      PLB_SrdDAck => open,
      PLB_SrdDBus => open,
      PLB_SrdWdAddr => open,
      PLB_Srearbitrate => open,
      PLB_Sssize => open,
      PLB_Swait => open,
      PLB_SwrBTerm => open,
      PLB_SwrComp => open,
      PLB_SwrDAck => open,
      Bus_Error_Det => open
    );

  microblaze_2 : microblaze_2_wrapper
    port map (
      CLK => sys_clk_s,
      RESET => mb_dlmb2_OPB_Rst,
      MB_RESET => net_gnd0,
      INTERRUPT => net_gnd0,
      EXT_BRK => Ext_BRK,
      EXT_NM_BRK => Ext_NM_BRK,
      DBG_STOP => net_gnd0,
      MB_Halted => open,
      INSTR => mb_ilmb2_LMB_ReadDBus,
      I_ADDRTAG => open,
      IREADY => mb_ilmb2_LMB_Ready,
      IWAIT => net_gnd0,
      INSTR_ADDR => mb_ilmb2_M_ABus,
      IFETCH => mb_ilmb2_M_ReadStrobe,
      I_AS => mb_ilmb2_M_AddrStrobe,
      IPLB_M_ABort => mb2_plb_bus_M_ABort(1),
      IPLB_M_ABus => mb2_plb_bus_M_ABus(32 to 63),
      IPLB_M_UABus => mb2_plb_bus_M_UABus(32 to 63),
      IPLB_M_BE => mb2_plb_bus_M_BE(4 to 7),
      IPLB_M_busLock => mb2_plb_bus_M_busLock(1),
      IPLB_M_lockErr => mb2_plb_bus_M_lockErr(1),
      IPLB_M_MSize => mb2_plb_bus_M_MSize(2 to 3),
      IPLB_M_priority => mb2_plb_bus_M_priority(2 to 3),
      IPLB_M_rdBurst => mb2_plb_bus_M_rdBurst(1),
      IPLB_M_request => mb2_plb_bus_M_request(1),
      IPLB_M_RNW => mb2_plb_bus_M_RNW(1),
      IPLB_M_size => mb2_plb_bus_M_size(4 to 7),
      IPLB_M_TAttribute => mb2_plb_bus_M_TAttribute(16 to 31),
      IPLB_M_type => mb2_plb_bus_M_type(3 to 5),
      IPLB_M_wrBurst => mb2_plb_bus_M_wrBurst(1),
      IPLB_M_wrDBus => mb2_plb_bus_M_wrDBus(32 to 63),
      IPLB_MBusy => mb2_plb_bus_PLB_MBusy(1),
      IPLB_MRdErr => mb2_plb_bus_PLB_MRdErr(1),
      IPLB_MWrErr => mb2_plb_bus_PLB_MWrErr(1),
      IPLB_MIRQ => mb2_plb_bus_PLB_MIRQ(1),
      IPLB_MWrBTerm => mb2_plb_bus_PLB_MWrBTerm(1),
      IPLB_MWrDAck => mb2_plb_bus_PLB_MWrDAck(1),
      IPLB_MAddrAck => mb2_plb_bus_PLB_MAddrAck(1),
      IPLB_MRdBTerm => mb2_plb_bus_PLB_MRdBTerm(1),
      IPLB_MRdDAck => mb2_plb_bus_PLB_MRdDAck(1),
      IPLB_MRdDBus => mb2_plb_bus_PLB_MRdDBus(32 to 63),
      IPLB_MRdWdAddr => mb2_plb_bus_PLB_MRdWdAddr(4 to 7),
      IPLB_MRearbitrate => mb2_plb_bus_PLB_MRearbitrate(1),
      IPLB_MSSize => mb2_plb_bus_PLB_MSSize(2 to 3),
      IPLB_MTimeout => mb2_plb_bus_PLB_MTimeout(1),
      DATA_READ => mb_dlmb2_LMB_ReadDBus,
      DREADY => mb_dlmb2_LMB_Ready,
      DWAIT => net_gnd0,
      DATA_WRITE => mb_dlmb2_M_DBus,
      DATA_ADDR => mb_dlmb2_M_ABus,
      D_ADDRTAG => open,
      D_AS => mb_dlmb2_M_AddrStrobe,
      READ_STROBE => mb_dlmb2_M_ReadStrobe,
      WRITE_STROBE => mb_dlmb2_M_WriteStrobe,
      BYTE_ENABLE => mb_dlmb2_M_BE,
      DM_ABUS => open,
      DM_BE => open,
      DM_BUSLOCK => open,
      DM_DBUS => open,
      DM_REQUEST => open,
      DM_RNW => open,
      DM_SELECT => open,
      DM_SEQADDR => open,
      DOPB_DBUS => net_gnd32,
      DOPB_ERRACK => net_gnd0,
      DOPB_MGRANT => net_gnd0,
      DOPB_RETRY => net_gnd0,
      DOPB_TIMEOUT => net_gnd0,
      DOPB_XFERACK => net_gnd0,
      DPLB_M_ABort => mb2_plb_bus_M_ABort(0),
      DPLB_M_ABus => mb2_plb_bus_M_ABus(0 to 31),
      DPLB_M_UABus => mb2_plb_bus_M_UABus(0 to 31),
      DPLB_M_BE => mb2_plb_bus_M_BE(0 to 3),
      DPLB_M_busLock => mb2_plb_bus_M_busLock(0),
      DPLB_M_lockErr => mb2_plb_bus_M_lockErr(0),
      DPLB_M_MSize => mb2_plb_bus_M_MSize(0 to 1),
      DPLB_M_priority => mb2_plb_bus_M_priority(0 to 1),
      DPLB_M_rdBurst => mb2_plb_bus_M_rdBurst(0),
      DPLB_M_request => mb2_plb_bus_M_request(0),
      DPLB_M_RNW => mb2_plb_bus_M_RNW(0),
      DPLB_M_size => mb2_plb_bus_M_size(0 to 3),
      DPLB_M_TAttribute => mb2_plb_bus_M_TAttribute(0 to 15),
      DPLB_M_type => mb2_plb_bus_M_type(0 to 2),
      DPLB_M_wrBurst => mb2_plb_bus_M_wrBurst(0),
      DPLB_M_wrDBus => mb2_plb_bus_M_wrDBus(0 to 31),
      DPLB_MBusy => mb2_plb_bus_PLB_MBusy(0),
      DPLB_MRdErr => mb2_plb_bus_PLB_MRdErr(0),
      DPLB_MWrErr => mb2_plb_bus_PLB_MWrErr(0),
      DPLB_MIRQ => mb2_plb_bus_PLB_MIRQ(0),
      DPLB_MWrBTerm => mb2_plb_bus_PLB_MWrBTerm(0),
      DPLB_MWrDAck => mb2_plb_bus_PLB_MWrDAck(0),
      DPLB_MAddrAck => mb2_plb_bus_PLB_MAddrAck(0),
      DPLB_MRdBTerm => mb2_plb_bus_PLB_MRdBTerm(0),
      DPLB_MRdDAck => mb2_plb_bus_PLB_MRdDAck(0),
      DPLB_MRdDBus => mb2_plb_bus_PLB_MRdDBus(0 to 31),
      DPLB_MRdWdAddr => mb2_plb_bus_PLB_MRdWdAddr(0 to 3),
      DPLB_MRearbitrate => mb2_plb_bus_PLB_MRearbitrate(0),
      DPLB_MSSize => mb2_plb_bus_PLB_MSSize(0 to 1),
      DPLB_MTimeout => mb2_plb_bus_PLB_MTimeout(0),
      IM_ABUS => open,
      IM_BE => open,
      IM_BUSLOCK => open,
      IM_DBUS => open,
      IM_REQUEST => open,
      IM_RNW => open,
      IM_SELECT => open,
      IM_SEQADDR => open,
      IOPB_DBUS => net_gnd32,
      IOPB_ERRACK => net_gnd0,
      IOPB_MGRANT => net_gnd0,
      IOPB_RETRY => net_gnd0,
      IOPB_TIMEOUT => net_gnd0,
      IOPB_XFERACK => net_gnd0,
      DBG_CLK => microblaze_2_MBDEBUG_Dbg_Clk,
      DBG_TDI => microblaze_2_MBDEBUG_Dbg_TDI,
      DBG_TDO => microblaze_2_MBDEBUG_Dbg_TDO,
      DBG_REG_EN => microblaze_2_MBDEBUG_Dbg_Reg_En,
      DBG_SHIFT => microblaze_2_MBDEBUG_Dbg_Shift,
      DBG_CAPTURE => microblaze_2_MBDEBUG_Dbg_Capture,
      DBG_UPDATE => microblaze_2_MBDEBUG_Dbg_Update,
      DEBUG_RST => microblaze_2_MBDEBUG_Debug_Rst,
      Trace_Instruction => open,
      Trace_Valid_Instr => open,
      Trace_PC => open,
      Trace_Reg_Write => open,
      Trace_Reg_Addr => open,
      Trace_MSR_Reg => open,
      Trace_PID_Reg => open,
      Trace_New_Reg_Value => open,
      Trace_Exception_Taken => open,
      Trace_Exception_Kind => open,
      Trace_Jump_Taken => open,
      Trace_Delay_Slot => open,
      Trace_Data_Address => open,
      Trace_Data_Access => open,
      Trace_Data_Read => open,
      Trace_Data_Write => open,
      Trace_Data_Write_Value => open,
      Trace_Data_Byte_Enable => open,
      Trace_DCache_Req => open,
      Trace_DCache_Hit => open,
      Trace_ICache_Req => open,
      Trace_ICache_Hit => open,
      Trace_OF_PipeRun => open,
      Trace_EX_PipeRun => open,
      Trace_MEM_PipeRun => open,
      Trace_MB_Halted => open,
      FSL0_S_CLK => open,
      FSL0_S_READ => open,
      FSL0_S_DATA => net_gnd32,
      FSL0_S_CONTROL => net_gnd0,
      FSL0_S_EXISTS => net_gnd0,
      FSL0_M_CLK => open,
      FSL0_M_WRITE => open,
      FSL0_M_DATA => open,
      FSL0_M_CONTROL => open,
      FSL0_M_FULL => net_gnd0,
      FSL1_S_CLK => open,
      FSL1_S_READ => open,
      FSL1_S_DATA => net_gnd32,
      FSL1_S_CONTROL => net_gnd0,
      FSL1_S_EXISTS => net_gnd0,
      FSL1_M_CLK => open,
      FSL1_M_WRITE => open,
      FSL1_M_DATA => open,
      FSL1_M_CONTROL => open,
      FSL1_M_FULL => net_gnd0,
      FSL2_S_CLK => open,
      FSL2_S_READ => open,
      FSL2_S_DATA => net_gnd32,
      FSL2_S_CONTROL => net_gnd0,
      FSL2_S_EXISTS => net_gnd0,
      FSL2_M_CLK => open,
      FSL2_M_WRITE => open,
      FSL2_M_DATA => open,
      FSL2_M_CONTROL => open,
      FSL2_M_FULL => net_gnd0,
      FSL3_S_CLK => open,
      FSL3_S_READ => open,
      FSL3_S_DATA => net_gnd32,
      FSL3_S_CONTROL => net_gnd0,
      FSL3_S_EXISTS => net_gnd0,
      FSL3_M_CLK => open,
      FSL3_M_WRITE => open,
      FSL3_M_DATA => open,
      FSL3_M_CONTROL => open,
      FSL3_M_FULL => net_gnd0,
      FSL4_S_CLK => open,
      FSL4_S_READ => open,
      FSL4_S_DATA => net_gnd32,
      FSL4_S_CONTROL => net_gnd0,
      FSL4_S_EXISTS => net_gnd0,
      FSL4_M_CLK => open,
      FSL4_M_WRITE => open,
      FSL4_M_DATA => open,
      FSL4_M_CONTROL => open,
      FSL4_M_FULL => net_gnd0,
      FSL5_S_CLK => open,
      FSL5_S_READ => open,
      FSL5_S_DATA => net_gnd32,
      FSL5_S_CONTROL => net_gnd0,
      FSL5_S_EXISTS => net_gnd0,
      FSL5_M_CLK => open,
      FSL5_M_WRITE => open,
      FSL5_M_DATA => open,
      FSL5_M_CONTROL => open,
      FSL5_M_FULL => net_gnd0,
      FSL6_S_CLK => open,
      FSL6_S_READ => open,
      FSL6_S_DATA => net_gnd32,
      FSL6_S_CONTROL => net_gnd0,
      FSL6_S_EXISTS => net_gnd0,
      FSL6_M_CLK => open,
      FSL6_M_WRITE => open,
      FSL6_M_DATA => open,
      FSL6_M_CONTROL => open,
      FSL6_M_FULL => net_gnd0,
      FSL7_S_CLK => open,
      FSL7_S_READ => open,
      FSL7_S_DATA => net_gnd32,
      FSL7_S_CONTROL => net_gnd0,
      FSL7_S_EXISTS => net_gnd0,
      FSL7_M_CLK => open,
      FSL7_M_WRITE => open,
      FSL7_M_DATA => open,
      FSL7_M_CONTROL => open,
      FSL7_M_FULL => net_gnd0,
      FSL8_S_CLK => open,
      FSL8_S_READ => open,
      FSL8_S_DATA => net_gnd32,
      FSL8_S_CONTROL => net_gnd0,
      FSL8_S_EXISTS => net_gnd0,
      FSL8_M_CLK => open,
      FSL8_M_WRITE => open,
      FSL8_M_DATA => open,
      FSL8_M_CONTROL => open,
      FSL8_M_FULL => net_gnd0,
      FSL9_S_CLK => open,
      FSL9_S_READ => open,
      FSL9_S_DATA => net_gnd32,
      FSL9_S_CONTROL => net_gnd0,
      FSL9_S_EXISTS => net_gnd0,
      FSL9_M_CLK => open,
      FSL9_M_WRITE => open,
      FSL9_M_DATA => open,
      FSL9_M_CONTROL => open,
      FSL9_M_FULL => net_gnd0,
      FSL10_S_CLK => open,
      FSL10_S_READ => open,
      FSL10_S_DATA => net_gnd32,
      FSL10_S_CONTROL => net_gnd0,
      FSL10_S_EXISTS => net_gnd0,
      FSL10_M_CLK => open,
      FSL10_M_WRITE => open,
      FSL10_M_DATA => open,
      FSL10_M_CONTROL => open,
      FSL10_M_FULL => net_gnd0,
      FSL11_S_CLK => open,
      FSL11_S_READ => open,
      FSL11_S_DATA => net_gnd32,
      FSL11_S_CONTROL => net_gnd0,
      FSL11_S_EXISTS => net_gnd0,
      FSL11_M_CLK => open,
      FSL11_M_WRITE => open,
      FSL11_M_DATA => open,
      FSL11_M_CONTROL => open,
      FSL11_M_FULL => net_gnd0,
      FSL12_S_CLK => open,
      FSL12_S_READ => open,
      FSL12_S_DATA => net_gnd32,
      FSL12_S_CONTROL => net_gnd0,
      FSL12_S_EXISTS => net_gnd0,
      FSL12_M_CLK => open,
      FSL12_M_WRITE => open,
      FSL12_M_DATA => open,
      FSL12_M_CONTROL => open,
      FSL12_M_FULL => net_gnd0,
      FSL13_S_CLK => open,
      FSL13_S_READ => open,
      FSL13_S_DATA => net_gnd32,
      FSL13_S_CONTROL => net_gnd0,
      FSL13_S_EXISTS => net_gnd0,
      FSL13_M_CLK => open,
      FSL13_M_WRITE => open,
      FSL13_M_DATA => open,
      FSL13_M_CONTROL => open,
      FSL13_M_FULL => net_gnd0,
      FSL14_S_CLK => open,
      FSL14_S_READ => open,
      FSL14_S_DATA => net_gnd32,
      FSL14_S_CONTROL => net_gnd0,
      FSL14_S_EXISTS => net_gnd0,
      FSL14_M_CLK => open,
      FSL14_M_WRITE => open,
      FSL14_M_DATA => open,
      FSL14_M_CONTROL => open,
      FSL14_M_FULL => net_gnd0,
      FSL15_S_CLK => open,
      FSL15_S_READ => open,
      FSL15_S_DATA => net_gnd32,
      FSL15_S_CONTROL => net_gnd0,
      FSL15_S_EXISTS => net_gnd0,
      FSL15_M_CLK => open,
      FSL15_M_WRITE => open,
      FSL15_M_DATA => open,
      FSL15_M_CONTROL => open,
      FSL15_M_FULL => net_gnd0,
      ICACHE_FSL_IN_CLK => microblaze_2_IXCL_FSL_S_Clk,
      ICACHE_FSL_IN_READ => microblaze_2_IXCL_FSL_S_Read,
      ICACHE_FSL_IN_DATA => microblaze_2_IXCL_FSL_S_Data,
      ICACHE_FSL_IN_CONTROL => microblaze_2_IXCL_FSL_S_Control,
      ICACHE_FSL_IN_EXISTS => microblaze_2_IXCL_FSL_S_Exists,
      ICACHE_FSL_OUT_CLK => microblaze_2_IXCL_FSL_M_Clk,
      ICACHE_FSL_OUT_WRITE => microblaze_2_IXCL_FSL_M_Write,
      ICACHE_FSL_OUT_DATA => microblaze_2_IXCL_FSL_M_Data,
      ICACHE_FSL_OUT_CONTROL => microblaze_2_IXCL_FSL_M_Control,
      ICACHE_FSL_OUT_FULL => microblaze_2_IXCL_FSL_M_Full,
      DCACHE_FSL_IN_CLK => open,
      DCACHE_FSL_IN_READ => open,
      DCACHE_FSL_IN_DATA => net_gnd32,
      DCACHE_FSL_IN_CONTROL => net_gnd0,
      DCACHE_FSL_IN_EXISTS => net_gnd0,
      DCACHE_FSL_OUT_CLK => open,
      DCACHE_FSL_OUT_WRITE => open,
      DCACHE_FSL_OUT_DATA => open,
      DCACHE_FSL_OUT_CONTROL => open,
      DCACHE_FSL_OUT_FULL => net_gnd0
    );

  mb_ilmb2 : mb_ilmb2_wrapper
    port map (
      LMB_Clk => sys_clk_s,
      SYS_Rst => sys_bus_reset(0),
      LMB_Rst => mb_ilmb2_OPB_Rst,
      M_ABus => mb_ilmb2_M_ABus,
      M_ReadStrobe => mb_ilmb2_M_ReadStrobe,
      M_WriteStrobe => net_gnd0,
      M_AddrStrobe => mb_ilmb2_M_AddrStrobe,
      M_DBus => net_gnd32,
      M_BE => net_gnd4,
      Sl_DBus => mb_ilmb2_Sl_DBus,
      Sl_Ready => mb_ilmb2_Sl_Ready(0 to 0),
      LMB_ABus => mb_ilmb2_LMB_ABus,
      LMB_ReadStrobe => mb_ilmb2_LMB_ReadStrobe,
      LMB_WriteStrobe => mb_ilmb2_LMB_WriteStrobe,
      LMB_AddrStrobe => mb_ilmb2_LMB_AddrStrobe,
      LMB_ReadDBus => mb_ilmb2_LMB_ReadDBus,
      LMB_WriteDBus => mb_ilmb2_LMB_WriteDBus,
      LMB_Ready => mb_ilmb2_LMB_Ready,
      LMB_BE => mb_ilmb2_LMB_BE
    );

  mb_dlmb2 : mb_dlmb2_wrapper
    port map (
      LMB_Clk => sys_clk_s,
      SYS_Rst => sys_bus_reset(0),
      LMB_Rst => mb_dlmb2_OPB_Rst,
      M_ABus => mb_dlmb2_M_ABus,
      M_ReadStrobe => mb_dlmb2_M_ReadStrobe,
      M_WriteStrobe => mb_dlmb2_M_WriteStrobe,
      M_AddrStrobe => mb_dlmb2_M_AddrStrobe,
      M_DBus => mb_dlmb2_M_DBus,
      M_BE => mb_dlmb2_M_BE,
      Sl_DBus => mb_dlmb2_Sl_DBus,
      Sl_Ready => mb_dlmb2_Sl_Ready(0 to 0),
      LMB_ABus => mb_dlmb2_LMB_ABus,
      LMB_ReadStrobe => mb_dlmb2_LMB_ReadStrobe,
      LMB_WriteStrobe => mb_dlmb2_LMB_WriteStrobe,
      LMB_AddrStrobe => mb_dlmb2_LMB_AddrStrobe,
      LMB_ReadDBus => mb_dlmb2_LMB_ReadDBus,
      LMB_WriteDBus => mb_dlmb2_LMB_WriteDBus,
      LMB_Ready => mb_dlmb2_LMB_Ready,
      LMB_BE => mb_dlmb2_LMB_BE
    );

  ilmb_cntlr2 : ilmb_cntlr2_wrapper
    port map (
      LMB_Clk => sys_clk_s,
      LMB_Rst => mb_ilmb2_OPB_Rst,
      LMB_ABus => mb_ilmb2_LMB_ABus,
      LMB_WriteDBus => mb_ilmb2_LMB_WriteDBus,
      LMB_AddrStrobe => mb_ilmb2_LMB_AddrStrobe,
      LMB_ReadStrobe => mb_ilmb2_LMB_ReadStrobe,
      LMB_WriteStrobe => mb_ilmb2_LMB_WriteStrobe,
      LMB_BE => mb_ilmb2_LMB_BE,
      Sl_DBus => mb_ilmb2_Sl_DBus,
      Sl_Ready => mb_ilmb2_Sl_Ready(0),
      BRAM_Rst_A => ilmb_cntlr_BRAM_PORT2_BRAM_Rst,
      BRAM_Clk_A => ilmb_cntlr_BRAM_PORT2_BRAM_Clk,
      BRAM_EN_A => ilmb_cntlr_BRAM_PORT2_BRAM_EN,
      BRAM_WEN_A => ilmb_cntlr_BRAM_PORT2_BRAM_WEN,
      BRAM_Addr_A => ilmb_cntlr_BRAM_PORT2_BRAM_Addr,
      BRAM_Din_A => ilmb_cntlr_BRAM_PORT2_BRAM_Din,
      BRAM_Dout_A => ilmb_cntlr_BRAM_PORT2_BRAM_Dout
    );

  dlmb_cntlr2 : dlmb_cntlr2_wrapper
    port map (
      LMB_Clk => sys_clk_s,
      LMB_Rst => mb_dlmb2_OPB_Rst,
      LMB_ABus => mb_dlmb2_LMB_ABus,
      LMB_WriteDBus => mb_dlmb2_LMB_WriteDBus,
      LMB_AddrStrobe => mb_dlmb2_LMB_AddrStrobe,
      LMB_ReadStrobe => mb_dlmb2_LMB_ReadStrobe,
      LMB_WriteStrobe => mb_dlmb2_LMB_WriteStrobe,
      LMB_BE => mb_dlmb2_LMB_BE,
      Sl_DBus => mb_dlmb2_Sl_DBus,
      Sl_Ready => mb_dlmb2_Sl_Ready(0),
      BRAM_Rst_A => dlmb_cntlr_BRAM_PORT2_BRAM_Rst,
      BRAM_Clk_A => dlmb_cntlr_BRAM_PORT2_BRAM_Clk,
      BRAM_EN_A => dlmb_cntlr_BRAM_PORT2_BRAM_EN,
      BRAM_WEN_A => dlmb_cntlr_BRAM_PORT2_BRAM_WEN,
      BRAM_Addr_A => dlmb_cntlr_BRAM_PORT2_BRAM_Addr,
      BRAM_Din_A => dlmb_cntlr_BRAM_PORT2_BRAM_Din,
      BRAM_Dout_A => dlmb_cntlr_BRAM_PORT2_BRAM_Dout
    );

  mb_bram2 : mb_bram2_wrapper
    port map (
      BRAM_Rst_A => ilmb_cntlr_BRAM_PORT2_BRAM_Rst,
      BRAM_Clk_A => ilmb_cntlr_BRAM_PORT2_BRAM_Clk,
      BRAM_EN_A => ilmb_cntlr_BRAM_PORT2_BRAM_EN,
      BRAM_WEN_A => ilmb_cntlr_BRAM_PORT2_BRAM_WEN,
      BRAM_Addr_A => ilmb_cntlr_BRAM_PORT2_BRAM_Addr,
      BRAM_Din_A => ilmb_cntlr_BRAM_PORT2_BRAM_Din,
      BRAM_Dout_A => ilmb_cntlr_BRAM_PORT2_BRAM_Dout,
      BRAM_Rst_B => dlmb_cntlr_BRAM_PORT2_BRAM_Rst,
      BRAM_Clk_B => dlmb_cntlr_BRAM_PORT2_BRAM_Clk,
      BRAM_EN_B => dlmb_cntlr_BRAM_PORT2_BRAM_EN,
      BRAM_WEN_B => dlmb_cntlr_BRAM_PORT2_BRAM_WEN,
      BRAM_Addr_B => dlmb_cntlr_BRAM_PORT2_BRAM_Addr,
      BRAM_Din_B => dlmb_cntlr_BRAM_PORT2_BRAM_Din,
      BRAM_Dout_B => dlmb_cntlr_BRAM_PORT2_BRAM_Dout
    );

  mb2_plb_bridge : mb2_plb_bridge_wrapper
    port map (
      SPLB_Clk => sys_clk_s,
      SPLB_Rst => mb2_plb_bus_SPLB_Rst(0),
      IP2INTC_Irpt => open,
      PLB_ABus => mb2_plb_bus_PLB_ABus,
      PLB_UABus => mb2_plb_bus_PLB_UABus,
      PLB_PAValid => mb2_plb_bus_PLB_PAValid,
      PLB_SAValid => mb2_plb_bus_PLB_SAValid,
      PLB_rdPrim => mb2_plb_bus_PLB_rdPrim(0),
      PLB_wrPrim => mb2_plb_bus_PLB_wrPrim(0),
      PLB_masterID => mb2_plb_bus_PLB_masterID(0 to 0),
      PLB_abort => mb2_plb_bus_PLB_abort,
      PLB_busLock => mb2_plb_bus_PLB_busLock,
      PLB_RNW => mb2_plb_bus_PLB_RNW,
      PLB_BE => mb2_plb_bus_PLB_BE,
      PLB_MSize => mb2_plb_bus_PLB_MSize,
      PLB_size => mb2_plb_bus_PLB_size,
      PLB_type => mb2_plb_bus_PLB_type,
      PLB_lockErr => mb2_plb_bus_PLB_lockErr,
      PLB_wrDBus => mb2_plb_bus_PLB_wrDBus,
      PLB_wrBurst => mb2_plb_bus_PLB_wrBurst,
      PLB_rdBurst => mb2_plb_bus_PLB_rdBurst,
      PLB_wrPendReq => mb2_plb_bus_PLB_wrPendReq,
      PLB_rdPendReq => mb2_plb_bus_PLB_rdPendReq,
      PLB_wrPendPri => mb2_plb_bus_PLB_wrPendPri,
      PLB_rdPendPri => mb2_plb_bus_PLB_rdPendPri,
      PLB_reqPri => mb2_plb_bus_PLB_reqPri,
      PLB_TAttribute => mb2_plb_bus_PLB_TAttribute,
      Sl_addrAck => mb2_plb_bus_Sl_addrAck(0),
      Sl_SSize => mb2_plb_bus_Sl_SSize,
      Sl_wait => mb2_plb_bus_Sl_wait(0),
      Sl_rearbitrate => mb2_plb_bus_Sl_rearbitrate(0),
      Sl_wrDAck => mb2_plb_bus_Sl_wrDAck(0),
      Sl_wrComp => mb2_plb_bus_Sl_wrComp(0),
      Sl_wrBTerm => mb2_plb_bus_Sl_wrBTerm(0),
      Sl_rdDBus => mb2_plb_bus_Sl_rdDBus,
      Sl_rdWdAddr => mb2_plb_bus_Sl_rdWdAddr,
      Sl_rdDAck => mb2_plb_bus_Sl_rdDAck(0),
      Sl_rdComp => mb2_plb_bus_Sl_rdComp(0),
      Sl_rdBTerm => mb2_plb_bus_Sl_rdBTerm(0),
      Sl_MBusy => mb2_plb_bus_Sl_MBusy,
      Sl_MWrErr => mb2_plb_bus_Sl_MWrErr,
      Sl_MRdErr => mb2_plb_bus_Sl_MRdErr,
      Sl_MIRQ => mb2_plb_bus_Sl_MIRQ,
      MPLB_Clk => sys_clk_s,
      MPLB_Rst => plb_v46_0_MPLB_Rst(4),
      M_request => plb_v46_0_M_request(4),
      M_priority => plb_v46_0_M_priority(8 to 9),
      M_busLock => plb_v46_0_M_busLock(4),
      M_RNW => plb_v46_0_M_RNW(4),
      M_BE => plb_v46_0_M_BE(64 to 79),
      M_MSize => plb_v46_0_M_MSize(8 to 9),
      M_size => plb_v46_0_M_size(16 to 19),
      M_type => plb_v46_0_M_type(12 to 14),
      M_ABus => plb_v46_0_M_ABus(128 to 159),
      M_wrBurst => plb_v46_0_M_wrBurst(4),
      M_rdBurst => plb_v46_0_M_rdBurst(4),
      M_wrDBus => plb_v46_0_M_wrDBus(512 to 639),
      PLB_MAddrAck => plb_v46_0_PLB_MAddrAck(4),
      PLB_MSSize => plb_v46_0_PLB_MSSize(8 to 9),
      PLB_MRearbitrate => plb_v46_0_PLB_MRearbitrate(4),
      PLB_MTimeout => plb_v46_0_PLB_MTimeout(4),
      PLB_MRdErr => plb_v46_0_PLB_MRdErr(4),
      PLB_MWrErr => plb_v46_0_PLB_MWrErr(4),
      PLB_MRdDBus => plb_v46_0_PLB_MRdDBus(512 to 639),
      PLB_MRdDAck => plb_v46_0_PLB_MRdDAck(4),
      PLB_MRdBTerm => plb_v46_0_PLB_MRdBTerm(4),
      PLB_MWrDAck => plb_v46_0_PLB_MWrDAck(4),
      PLB_MWrBTerm => plb_v46_0_PLB_MWrBTerm(4),
      M_TAttribute => plb_v46_0_M_TAttribute(64 to 79),
      M_lockErr => plb_v46_0_M_lockErr(4),
      M_abort => plb_v46_0_M_abort(4),
      M_UABus => plb_v46_0_M_UABus(128 to 159),
      PLB_MBusy => plb_v46_0_PLB_MBusy(4),
      PLB_MIRQ => plb_v46_0_PLB_MIRQ(4),
      PLB_MRdWdAddr => plb_v46_0_PLB_MRdWdAddr(16 to 19)
    );

  mb2_plb_bus : mb2_plb_bus_wrapper
    port map (
      PLB_Clk => sys_clk_s,
      SYS_Rst => sys_bus_reset(0),
      PLB_Rst => open,
      SPLB_Rst => mb2_plb_bus_SPLB_Rst(0 to 0),
      MPLB_Rst => open,
      PLB_dcrAck => open,
      PLB_dcrDBus => open,
      DCR_ABus => net_gnd10,
      DCR_DBus => net_gnd32,
      DCR_Read => net_gnd0,
      DCR_Write => net_gnd0,
      M_ABus => mb2_plb_bus_M_ABus,
      M_UABus => mb2_plb_bus_M_UABus,
      M_BE => mb2_plb_bus_M_BE,
      M_RNW => mb2_plb_bus_M_RNW,
      M_abort => mb2_plb_bus_M_ABort,
      M_busLock => mb2_plb_bus_M_busLock,
      M_TAttribute => mb2_plb_bus_M_TAttribute,
      M_lockErr => mb2_plb_bus_M_lockErr,
      M_MSize => mb2_plb_bus_M_MSize,
      M_priority => mb2_plb_bus_M_priority,
      M_rdBurst => mb2_plb_bus_M_rdBurst,
      M_request => mb2_plb_bus_M_request,
      M_size => mb2_plb_bus_M_size,
      M_type => mb2_plb_bus_M_type,
      M_wrBurst => mb2_plb_bus_M_wrBurst,
      M_wrDBus => mb2_plb_bus_M_wrDBus,
      Sl_addrAck => mb2_plb_bus_Sl_addrAck(0 to 0),
      Sl_MRdErr => mb2_plb_bus_Sl_MRdErr,
      Sl_MWrErr => mb2_plb_bus_Sl_MWrErr,
      Sl_MBusy => mb2_plb_bus_Sl_MBusy,
      Sl_rdBTerm => mb2_plb_bus_Sl_rdBTerm(0 to 0),
      Sl_rdComp => mb2_plb_bus_Sl_rdComp(0 to 0),
      Sl_rdDAck => mb2_plb_bus_Sl_rdDAck(0 to 0),
      Sl_rdDBus => mb2_plb_bus_Sl_rdDBus,
      Sl_rdWdAddr => mb2_plb_bus_Sl_rdWdAddr,
      Sl_rearbitrate => mb2_plb_bus_Sl_rearbitrate(0 to 0),
      Sl_SSize => mb2_plb_bus_Sl_SSize,
      Sl_wait => mb2_plb_bus_Sl_wait(0 to 0),
      Sl_wrBTerm => mb2_plb_bus_Sl_wrBTerm(0 to 0),
      Sl_wrComp => mb2_plb_bus_Sl_wrComp(0 to 0),
      Sl_wrDAck => mb2_plb_bus_Sl_wrDAck(0 to 0),
      Sl_MIRQ => mb2_plb_bus_Sl_MIRQ,
      PLB_MIRQ => mb2_plb_bus_PLB_MIRQ,
      PLB_ABus => mb2_plb_bus_PLB_ABus,
      PLB_UABus => mb2_plb_bus_PLB_UABus,
      PLB_BE => mb2_plb_bus_PLB_BE,
      PLB_MAddrAck => mb2_plb_bus_PLB_MAddrAck,
      PLB_MTimeout => mb2_plb_bus_PLB_MTimeout,
      PLB_MBusy => mb2_plb_bus_PLB_MBusy,
      PLB_MRdErr => mb2_plb_bus_PLB_MRdErr,
      PLB_MWrErr => mb2_plb_bus_PLB_MWrErr,
      PLB_MRdBTerm => mb2_plb_bus_PLB_MRdBTerm,
      PLB_MRdDAck => mb2_plb_bus_PLB_MRdDAck,
      PLB_MRdDBus => mb2_plb_bus_PLB_MRdDBus,
      PLB_MRdWdAddr => mb2_plb_bus_PLB_MRdWdAddr,
      PLB_MRearbitrate => mb2_plb_bus_PLB_MRearbitrate,
      PLB_MWrBTerm => mb2_plb_bus_PLB_MWrBTerm,
      PLB_MWrDAck => mb2_plb_bus_PLB_MWrDAck,
      PLB_MSSize => mb2_plb_bus_PLB_MSSize,
      PLB_PAValid => mb2_plb_bus_PLB_PAValid,
      PLB_RNW => mb2_plb_bus_PLB_RNW,
      PLB_SAValid => mb2_plb_bus_PLB_SAValid,
      PLB_abort => mb2_plb_bus_PLB_abort,
      PLB_busLock => mb2_plb_bus_PLB_busLock,
      PLB_TAttribute => mb2_plb_bus_PLB_TAttribute,
      PLB_lockErr => mb2_plb_bus_PLB_lockErr,
      PLB_masterID => mb2_plb_bus_PLB_masterID(0 to 0),
      PLB_MSize => mb2_plb_bus_PLB_MSize,
      PLB_rdPendPri => mb2_plb_bus_PLB_rdPendPri,
      PLB_wrPendPri => mb2_plb_bus_PLB_wrPendPri,
      PLB_rdPendReq => mb2_plb_bus_PLB_rdPendReq,
      PLB_wrPendReq => mb2_plb_bus_PLB_wrPendReq,
      PLB_rdBurst => mb2_plb_bus_PLB_rdBurst,
      PLB_rdPrim => mb2_plb_bus_PLB_rdPrim(0 to 0),
      PLB_reqPri => mb2_plb_bus_PLB_reqPri,
      PLB_size => mb2_plb_bus_PLB_size,
      PLB_type => mb2_plb_bus_PLB_type,
      PLB_wrBurst => mb2_plb_bus_PLB_wrBurst,
      PLB_wrDBus => mb2_plb_bus_PLB_wrDBus,
      PLB_wrPrim => mb2_plb_bus_PLB_wrPrim(0 to 0),
      PLB_SaddrAck => open,
      PLB_SMRdErr => open,
      PLB_SMWrErr => open,
      PLB_SMBusy => open,
      PLB_SrdBTerm => open,
      PLB_SrdComp => open,
      PLB_SrdDAck => open,
      PLB_SrdDBus => open,
      PLB_SrdWdAddr => open,
      PLB_Srearbitrate => open,
      PLB_Sssize => open,
      PLB_Swait => open,
      PLB_SwrBTerm => open,
      PLB_SwrComp => open,
      PLB_SwrDAck => open,
      Bus_Error_Det => open
    );

  microblaze_mb3 : microblaze_mb3_wrapper
    port map (
      CLK => sys_clk_s,
      RESET => mb_dlmb_mb3_OPB_Rst,
      MB_RESET => net_gnd0,
      INTERRUPT => net_gnd0,
      EXT_BRK => Ext_BRK,
      EXT_NM_BRK => Ext_NM_BRK,
      DBG_STOP => net_gnd0,
      MB_Halted => open,
      INSTR => mb_ilmb_mb3_LMB_ReadDBus,
      I_ADDRTAG => open,
      IREADY => mb_ilmb_mb3_LMB_Ready,
      IWAIT => net_gnd0,
      INSTR_ADDR => mb_ilmb_mb3_M_ABus,
      IFETCH => mb_ilmb_mb3_M_ReadStrobe,
      I_AS => mb_ilmb_mb3_M_AddrStrobe,
      IPLB_M_ABort => mb3_plb_bus_M_ABort(1),
      IPLB_M_ABus => mb3_plb_bus_M_ABus(32 to 63),
      IPLB_M_UABus => mb3_plb_bus_M_UABus(32 to 63),
      IPLB_M_BE => mb3_plb_bus_M_BE(4 to 7),
      IPLB_M_busLock => mb3_plb_bus_M_busLock(1),
      IPLB_M_lockErr => mb3_plb_bus_M_lockErr(1),
      IPLB_M_MSize => mb3_plb_bus_M_MSize(2 to 3),
      IPLB_M_priority => mb3_plb_bus_M_priority(2 to 3),
      IPLB_M_rdBurst => mb3_plb_bus_M_rdBurst(1),
      IPLB_M_request => mb3_plb_bus_M_request(1),
      IPLB_M_RNW => mb3_plb_bus_M_RNW(1),
      IPLB_M_size => mb3_plb_bus_M_size(4 to 7),
      IPLB_M_TAttribute => mb3_plb_bus_M_TAttribute(16 to 31),
      IPLB_M_type => mb3_plb_bus_M_type(3 to 5),
      IPLB_M_wrBurst => mb3_plb_bus_M_wrBurst(1),
      IPLB_M_wrDBus => mb3_plb_bus_M_wrDBus(32 to 63),
      IPLB_MBusy => mb3_plb_bus_PLB_MBusy(1),
      IPLB_MRdErr => mb3_plb_bus_PLB_MRdErr(1),
      IPLB_MWrErr => mb3_plb_bus_PLB_MWrErr(1),
      IPLB_MIRQ => mb3_plb_bus_PLB_MIRQ(1),
      IPLB_MWrBTerm => mb3_plb_bus_PLB_MWrBTerm(1),
      IPLB_MWrDAck => mb3_plb_bus_PLB_MWrDAck(1),
      IPLB_MAddrAck => mb3_plb_bus_PLB_MAddrAck(1),
      IPLB_MRdBTerm => mb3_plb_bus_PLB_MRdBTerm(1),
      IPLB_MRdDAck => mb3_plb_bus_PLB_MRdDAck(1),
      IPLB_MRdDBus => mb3_plb_bus_PLB_MRdDBus(32 to 63),
      IPLB_MRdWdAddr => mb3_plb_bus_PLB_MRdWdAddr(4 to 7),
      IPLB_MRearbitrate => mb3_plb_bus_PLB_MRearbitrate(1),
      IPLB_MSSize => mb3_plb_bus_PLB_MSSize(2 to 3),
      IPLB_MTimeout => mb3_plb_bus_PLB_MTimeout(1),
      DATA_READ => mb_dlmb_mb3_LMB_ReadDBus,
      DREADY => mb_dlmb_mb3_LMB_Ready,
      DWAIT => net_gnd0,
      DATA_WRITE => mb_dlmb_mb3_M_DBus,
      DATA_ADDR => mb_dlmb_mb3_M_ABus,
      D_ADDRTAG => open,
      D_AS => mb_dlmb_mb3_M_AddrStrobe,
      READ_STROBE => mb_dlmb_mb3_M_ReadStrobe,
      WRITE_STROBE => mb_dlmb_mb3_M_WriteStrobe,
      BYTE_ENABLE => mb_dlmb_mb3_M_BE,
      DM_ABUS => open,
      DM_BE => open,
      DM_BUSLOCK => open,
      DM_DBUS => open,
      DM_REQUEST => open,
      DM_RNW => open,
      DM_SELECT => open,
      DM_SEQADDR => open,
      DOPB_DBUS => net_gnd32,
      DOPB_ERRACK => net_gnd0,
      DOPB_MGRANT => net_gnd0,
      DOPB_RETRY => net_gnd0,
      DOPB_TIMEOUT => net_gnd0,
      DOPB_XFERACK => net_gnd0,
      DPLB_M_ABort => mb3_plb_bus_M_ABort(0),
      DPLB_M_ABus => mb3_plb_bus_M_ABus(0 to 31),
      DPLB_M_UABus => mb3_plb_bus_M_UABus(0 to 31),
      DPLB_M_BE => mb3_plb_bus_M_BE(0 to 3),
      DPLB_M_busLock => mb3_plb_bus_M_busLock(0),
      DPLB_M_lockErr => mb3_plb_bus_M_lockErr(0),
      DPLB_M_MSize => mb3_plb_bus_M_MSize(0 to 1),
      DPLB_M_priority => mb3_plb_bus_M_priority(0 to 1),
      DPLB_M_rdBurst => mb3_plb_bus_M_rdBurst(0),
      DPLB_M_request => mb3_plb_bus_M_request(0),
      DPLB_M_RNW => mb3_plb_bus_M_RNW(0),
      DPLB_M_size => mb3_plb_bus_M_size(0 to 3),
      DPLB_M_TAttribute => mb3_plb_bus_M_TAttribute(0 to 15),
      DPLB_M_type => mb3_plb_bus_M_type(0 to 2),
      DPLB_M_wrBurst => mb3_plb_bus_M_wrBurst(0),
      DPLB_M_wrDBus => mb3_plb_bus_M_wrDBus(0 to 31),
      DPLB_MBusy => mb3_plb_bus_PLB_MBusy(0),
      DPLB_MRdErr => mb3_plb_bus_PLB_MRdErr(0),
      DPLB_MWrErr => mb3_plb_bus_PLB_MWrErr(0),
      DPLB_MIRQ => mb3_plb_bus_PLB_MIRQ(0),
      DPLB_MWrBTerm => mb3_plb_bus_PLB_MWrBTerm(0),
      DPLB_MWrDAck => mb3_plb_bus_PLB_MWrDAck(0),
      DPLB_MAddrAck => mb3_plb_bus_PLB_MAddrAck(0),
      DPLB_MRdBTerm => mb3_plb_bus_PLB_MRdBTerm(0),
      DPLB_MRdDAck => mb3_plb_bus_PLB_MRdDAck(0),
      DPLB_MRdDBus => mb3_plb_bus_PLB_MRdDBus(0 to 31),
      DPLB_MRdWdAddr => mb3_plb_bus_PLB_MRdWdAddr(0 to 3),
      DPLB_MRearbitrate => mb3_plb_bus_PLB_MRearbitrate(0),
      DPLB_MSSize => mb3_plb_bus_PLB_MSSize(0 to 1),
      DPLB_MTimeout => mb3_plb_bus_PLB_MTimeout(0),
      IM_ABUS => open,
      IM_BE => open,
      IM_BUSLOCK => open,
      IM_DBUS => open,
      IM_REQUEST => open,
      IM_RNW => open,
      IM_SELECT => open,
      IM_SEQADDR => open,
      IOPB_DBUS => net_gnd32,
      IOPB_ERRACK => net_gnd0,
      IOPB_MGRANT => net_gnd0,
      IOPB_RETRY => net_gnd0,
      IOPB_TIMEOUT => net_gnd0,
      IOPB_XFERACK => net_gnd0,
      DBG_CLK => net_gnd0,
      DBG_TDI => net_gnd0,
      DBG_TDO => open,
      DBG_REG_EN => net_gnd5,
      DBG_SHIFT => net_gnd0,
      DBG_CAPTURE => net_gnd0,
      DBG_UPDATE => net_gnd0,
      DEBUG_RST => net_gnd0,
      Trace_Instruction => open,
      Trace_Valid_Instr => open,
      Trace_PC => open,
      Trace_Reg_Write => open,
      Trace_Reg_Addr => open,
      Trace_MSR_Reg => open,
      Trace_PID_Reg => open,
      Trace_New_Reg_Value => open,
      Trace_Exception_Taken => open,
      Trace_Exception_Kind => open,
      Trace_Jump_Taken => open,
      Trace_Delay_Slot => open,
      Trace_Data_Address => open,
      Trace_Data_Access => open,
      Trace_Data_Read => open,
      Trace_Data_Write => open,
      Trace_Data_Write_Value => open,
      Trace_Data_Byte_Enable => open,
      Trace_DCache_Req => open,
      Trace_DCache_Hit => open,
      Trace_ICache_Req => open,
      Trace_ICache_Hit => open,
      Trace_OF_PipeRun => open,
      Trace_EX_PipeRun => open,
      Trace_MEM_PipeRun => open,
      Trace_MB_Halted => open,
      FSL0_S_CLK => open,
      FSL0_S_READ => open,
      FSL0_S_DATA => net_gnd32,
      FSL0_S_CONTROL => net_gnd0,
      FSL0_S_EXISTS => net_gnd0,
      FSL0_M_CLK => open,
      FSL0_M_WRITE => open,
      FSL0_M_DATA => open,
      FSL0_M_CONTROL => open,
      FSL0_M_FULL => net_gnd0,
      FSL1_S_CLK => open,
      FSL1_S_READ => open,
      FSL1_S_DATA => net_gnd32,
      FSL1_S_CONTROL => net_gnd0,
      FSL1_S_EXISTS => net_gnd0,
      FSL1_M_CLK => open,
      FSL1_M_WRITE => open,
      FSL1_M_DATA => open,
      FSL1_M_CONTROL => open,
      FSL1_M_FULL => net_gnd0,
      FSL2_S_CLK => open,
      FSL2_S_READ => open,
      FSL2_S_DATA => net_gnd32,
      FSL2_S_CONTROL => net_gnd0,
      FSL2_S_EXISTS => net_gnd0,
      FSL2_M_CLK => open,
      FSL2_M_WRITE => open,
      FSL2_M_DATA => open,
      FSL2_M_CONTROL => open,
      FSL2_M_FULL => net_gnd0,
      FSL3_S_CLK => open,
      FSL3_S_READ => open,
      FSL3_S_DATA => net_gnd32,
      FSL3_S_CONTROL => net_gnd0,
      FSL3_S_EXISTS => net_gnd0,
      FSL3_M_CLK => open,
      FSL3_M_WRITE => open,
      FSL3_M_DATA => open,
      FSL3_M_CONTROL => open,
      FSL3_M_FULL => net_gnd0,
      FSL4_S_CLK => open,
      FSL4_S_READ => open,
      FSL4_S_DATA => net_gnd32,
      FSL4_S_CONTROL => net_gnd0,
      FSL4_S_EXISTS => net_gnd0,
      FSL4_M_CLK => open,
      FSL4_M_WRITE => open,
      FSL4_M_DATA => open,
      FSL4_M_CONTROL => open,
      FSL4_M_FULL => net_gnd0,
      FSL5_S_CLK => open,
      FSL5_S_READ => open,
      FSL5_S_DATA => net_gnd32,
      FSL5_S_CONTROL => net_gnd0,
      FSL5_S_EXISTS => net_gnd0,
      FSL5_M_CLK => open,
      FSL5_M_WRITE => open,
      FSL5_M_DATA => open,
      FSL5_M_CONTROL => open,
      FSL5_M_FULL => net_gnd0,
      FSL6_S_CLK => open,
      FSL6_S_READ => open,
      FSL6_S_DATA => net_gnd32,
      FSL6_S_CONTROL => net_gnd0,
      FSL6_S_EXISTS => net_gnd0,
      FSL6_M_CLK => open,
      FSL6_M_WRITE => open,
      FSL6_M_DATA => open,
      FSL6_M_CONTROL => open,
      FSL6_M_FULL => net_gnd0,
      FSL7_S_CLK => open,
      FSL7_S_READ => open,
      FSL7_S_DATA => net_gnd32,
      FSL7_S_CONTROL => net_gnd0,
      FSL7_S_EXISTS => net_gnd0,
      FSL7_M_CLK => open,
      FSL7_M_WRITE => open,
      FSL7_M_DATA => open,
      FSL7_M_CONTROL => open,
      FSL7_M_FULL => net_gnd0,
      FSL8_S_CLK => open,
      FSL8_S_READ => open,
      FSL8_S_DATA => net_gnd32,
      FSL8_S_CONTROL => net_gnd0,
      FSL8_S_EXISTS => net_gnd0,
      FSL8_M_CLK => open,
      FSL8_M_WRITE => open,
      FSL8_M_DATA => open,
      FSL8_M_CONTROL => open,
      FSL8_M_FULL => net_gnd0,
      FSL9_S_CLK => open,
      FSL9_S_READ => open,
      FSL9_S_DATA => net_gnd32,
      FSL9_S_CONTROL => net_gnd0,
      FSL9_S_EXISTS => net_gnd0,
      FSL9_M_CLK => open,
      FSL9_M_WRITE => open,
      FSL9_M_DATA => open,
      FSL9_M_CONTROL => open,
      FSL9_M_FULL => net_gnd0,
      FSL10_S_CLK => open,
      FSL10_S_READ => open,
      FSL10_S_DATA => net_gnd32,
      FSL10_S_CONTROL => net_gnd0,
      FSL10_S_EXISTS => net_gnd0,
      FSL10_M_CLK => open,
      FSL10_M_WRITE => open,
      FSL10_M_DATA => open,
      FSL10_M_CONTROL => open,
      FSL10_M_FULL => net_gnd0,
      FSL11_S_CLK => open,
      FSL11_S_READ => open,
      FSL11_S_DATA => net_gnd32,
      FSL11_S_CONTROL => net_gnd0,
      FSL11_S_EXISTS => net_gnd0,
      FSL11_M_CLK => open,
      FSL11_M_WRITE => open,
      FSL11_M_DATA => open,
      FSL11_M_CONTROL => open,
      FSL11_M_FULL => net_gnd0,
      FSL12_S_CLK => open,
      FSL12_S_READ => open,
      FSL12_S_DATA => net_gnd32,
      FSL12_S_CONTROL => net_gnd0,
      FSL12_S_EXISTS => net_gnd0,
      FSL12_M_CLK => open,
      FSL12_M_WRITE => open,
      FSL12_M_DATA => open,
      FSL12_M_CONTROL => open,
      FSL12_M_FULL => net_gnd0,
      FSL13_S_CLK => open,
      FSL13_S_READ => open,
      FSL13_S_DATA => net_gnd32,
      FSL13_S_CONTROL => net_gnd0,
      FSL13_S_EXISTS => net_gnd0,
      FSL13_M_CLK => open,
      FSL13_M_WRITE => open,
      FSL13_M_DATA => open,
      FSL13_M_CONTROL => open,
      FSL13_M_FULL => net_gnd0,
      FSL14_S_CLK => open,
      FSL14_S_READ => open,
      FSL14_S_DATA => net_gnd32,
      FSL14_S_CONTROL => net_gnd0,
      FSL14_S_EXISTS => net_gnd0,
      FSL14_M_CLK => open,
      FSL14_M_WRITE => open,
      FSL14_M_DATA => open,
      FSL14_M_CONTROL => open,
      FSL14_M_FULL => net_gnd0,
      FSL15_S_CLK => open,
      FSL15_S_READ => open,
      FSL15_S_DATA => net_gnd32,
      FSL15_S_CONTROL => net_gnd0,
      FSL15_S_EXISTS => net_gnd0,
      FSL15_M_CLK => open,
      FSL15_M_WRITE => open,
      FSL15_M_DATA => open,
      FSL15_M_CONTROL => open,
      FSL15_M_FULL => net_gnd0,
      ICACHE_FSL_IN_CLK => microblaze_mb3_IXCL_FSL_S_Clk,
      ICACHE_FSL_IN_READ => microblaze_mb3_IXCL_FSL_S_Read,
      ICACHE_FSL_IN_DATA => microblaze_mb3_IXCL_FSL_S_Data,
      ICACHE_FSL_IN_CONTROL => microblaze_mb3_IXCL_FSL_S_Control,
      ICACHE_FSL_IN_EXISTS => microblaze_mb3_IXCL_FSL_S_Exists,
      ICACHE_FSL_OUT_CLK => microblaze_mb3_IXCL_FSL_M_Clk,
      ICACHE_FSL_OUT_WRITE => microblaze_mb3_IXCL_FSL_M_Write,
      ICACHE_FSL_OUT_DATA => microblaze_mb3_IXCL_FSL_M_Data,
      ICACHE_FSL_OUT_CONTROL => microblaze_mb3_IXCL_FSL_M_Control,
      ICACHE_FSL_OUT_FULL => microblaze_mb3_IXCL_FSL_M_Full,
      DCACHE_FSL_IN_CLK => open,
      DCACHE_FSL_IN_READ => open,
      DCACHE_FSL_IN_DATA => net_gnd32,
      DCACHE_FSL_IN_CONTROL => net_gnd0,
      DCACHE_FSL_IN_EXISTS => net_gnd0,
      DCACHE_FSL_OUT_CLK => open,
      DCACHE_FSL_OUT_WRITE => open,
      DCACHE_FSL_OUT_DATA => open,
      DCACHE_FSL_OUT_CONTROL => open,
      DCACHE_FSL_OUT_FULL => net_gnd0
    );

  mb_ilmb_mb3 : mb_ilmb_mb3_wrapper
    port map (
      LMB_Clk => sys_clk_s,
      SYS_Rst => sys_bus_reset(0),
      LMB_Rst => mb_ilmb_mb3_OPB_Rst,
      M_ABus => mb_ilmb_mb3_M_ABus,
      M_ReadStrobe => mb_ilmb_mb3_M_ReadStrobe,
      M_WriteStrobe => net_gnd0,
      M_AddrStrobe => mb_ilmb_mb3_M_AddrStrobe,
      M_DBus => net_gnd32,
      M_BE => net_gnd4,
      Sl_DBus => mb_ilmb_mb3_Sl_DBus,
      Sl_Ready => mb_ilmb_mb3_Sl_Ready(0 to 0),
      LMB_ABus => mb_ilmb_mb3_LMB_ABus,
      LMB_ReadStrobe => mb_ilmb_mb3_LMB_ReadStrobe,
      LMB_WriteStrobe => mb_ilmb_mb3_LMB_WriteStrobe,
      LMB_AddrStrobe => mb_ilmb_mb3_LMB_AddrStrobe,
      LMB_ReadDBus => mb_ilmb_mb3_LMB_ReadDBus,
      LMB_WriteDBus => mb_ilmb_mb3_LMB_WriteDBus,
      LMB_Ready => mb_ilmb_mb3_LMB_Ready,
      LMB_BE => mb_ilmb_mb3_LMB_BE
    );

  mb_dlmb_mb3 : mb_dlmb_mb3_wrapper
    port map (
      LMB_Clk => sys_clk_s,
      SYS_Rst => sys_bus_reset(0),
      LMB_Rst => mb_dlmb_mb3_OPB_Rst,
      M_ABus => mb_dlmb_mb3_M_ABus,
      M_ReadStrobe => mb_dlmb_mb3_M_ReadStrobe,
      M_WriteStrobe => mb_dlmb_mb3_M_WriteStrobe,
      M_AddrStrobe => mb_dlmb_mb3_M_AddrStrobe,
      M_DBus => mb_dlmb_mb3_M_DBus,
      M_BE => mb_dlmb_mb3_M_BE,
      Sl_DBus => mb_dlmb_mb3_Sl_DBus,
      Sl_Ready => mb_dlmb_mb3_Sl_Ready(0 to 0),
      LMB_ABus => mb_dlmb_mb3_LMB_ABus,
      LMB_ReadStrobe => mb_dlmb_mb3_LMB_ReadStrobe,
      LMB_WriteStrobe => mb_dlmb_mb3_LMB_WriteStrobe,
      LMB_AddrStrobe => mb_dlmb_mb3_LMB_AddrStrobe,
      LMB_ReadDBus => mb_dlmb_mb3_LMB_ReadDBus,
      LMB_WriteDBus => mb_dlmb_mb3_LMB_WriteDBus,
      LMB_Ready => mb_dlmb_mb3_LMB_Ready,
      LMB_BE => mb_dlmb_mb3_LMB_BE
    );

  ilmb_cntlr_mb3 : ilmb_cntlr_mb3_wrapper
    port map (
      LMB_Clk => sys_clk_s,
      LMB_Rst => mb_ilmb_mb3_OPB_Rst,
      LMB_ABus => mb_ilmb_mb3_LMB_ABus,
      LMB_WriteDBus => mb_ilmb_mb3_LMB_WriteDBus,
      LMB_AddrStrobe => mb_ilmb_mb3_LMB_AddrStrobe,
      LMB_ReadStrobe => mb_ilmb_mb3_LMB_ReadStrobe,
      LMB_WriteStrobe => mb_ilmb_mb3_LMB_WriteStrobe,
      LMB_BE => mb_ilmb_mb3_LMB_BE,
      Sl_DBus => mb_ilmb_mb3_Sl_DBus,
      Sl_Ready => mb_ilmb_mb3_Sl_Ready(0),
      BRAM_Rst_A => ilmb_cntlr_BRAM_PORT_mb3_BRAM_Rst,
      BRAM_Clk_A => ilmb_cntlr_BRAM_PORT_mb3_BRAM_Clk,
      BRAM_EN_A => ilmb_cntlr_BRAM_PORT_mb3_BRAM_EN,
      BRAM_WEN_A => ilmb_cntlr_BRAM_PORT_mb3_BRAM_WEN,
      BRAM_Addr_A => ilmb_cntlr_BRAM_PORT_mb3_BRAM_Addr,
      BRAM_Din_A => ilmb_cntlr_BRAM_PORT_mb3_BRAM_Din,
      BRAM_Dout_A => ilmb_cntlr_BRAM_PORT_mb3_BRAM_Dout
    );

  dlmb_cntlr_mb3 : dlmb_cntlr_mb3_wrapper
    port map (
      LMB_Clk => sys_clk_s,
      LMB_Rst => mb_dlmb_mb3_OPB_Rst,
      LMB_ABus => mb_dlmb_mb3_LMB_ABus,
      LMB_WriteDBus => mb_dlmb_mb3_LMB_WriteDBus,
      LMB_AddrStrobe => mb_dlmb_mb3_LMB_AddrStrobe,
      LMB_ReadStrobe => mb_dlmb_mb3_LMB_ReadStrobe,
      LMB_WriteStrobe => mb_dlmb_mb3_LMB_WriteStrobe,
      LMB_BE => mb_dlmb_mb3_LMB_BE,
      Sl_DBus => mb_dlmb_mb3_Sl_DBus,
      Sl_Ready => mb_dlmb_mb3_Sl_Ready(0),
      BRAM_Rst_A => dlmb_cntlr_BRAM_PORT_mb3_BRAM_Rst,
      BRAM_Clk_A => dlmb_cntlr_BRAM_PORT_mb3_BRAM_Clk,
      BRAM_EN_A => dlmb_cntlr_BRAM_PORT_mb3_BRAM_EN,
      BRAM_WEN_A => dlmb_cntlr_BRAM_PORT_mb3_BRAM_WEN,
      BRAM_Addr_A => dlmb_cntlr_BRAM_PORT_mb3_BRAM_Addr,
      BRAM_Din_A => dlmb_cntlr_BRAM_PORT_mb3_BRAM_Din,
      BRAM_Dout_A => dlmb_cntlr_BRAM_PORT_mb3_BRAM_Dout
    );

  mb3_bram : mb3_bram_wrapper
    port map (
      BRAM_Rst_A => ilmb_cntlr_BRAM_PORT_mb3_BRAM_Rst,
      BRAM_Clk_A => ilmb_cntlr_BRAM_PORT_mb3_BRAM_Clk,
      BRAM_EN_A => ilmb_cntlr_BRAM_PORT_mb3_BRAM_EN,
      BRAM_WEN_A => ilmb_cntlr_BRAM_PORT_mb3_BRAM_WEN,
      BRAM_Addr_A => ilmb_cntlr_BRAM_PORT_mb3_BRAM_Addr,
      BRAM_Din_A => ilmb_cntlr_BRAM_PORT_mb3_BRAM_Din,
      BRAM_Dout_A => ilmb_cntlr_BRAM_PORT_mb3_BRAM_Dout,
      BRAM_Rst_B => dlmb_cntlr_BRAM_PORT_mb3_BRAM_Rst,
      BRAM_Clk_B => dlmb_cntlr_BRAM_PORT_mb3_BRAM_Clk,
      BRAM_EN_B => dlmb_cntlr_BRAM_PORT_mb3_BRAM_EN,
      BRAM_WEN_B => dlmb_cntlr_BRAM_PORT_mb3_BRAM_WEN,
      BRAM_Addr_B => dlmb_cntlr_BRAM_PORT_mb3_BRAM_Addr,
      BRAM_Din_B => dlmb_cntlr_BRAM_PORT_mb3_BRAM_Din,
      BRAM_Dout_B => dlmb_cntlr_BRAM_PORT_mb3_BRAM_Dout
    );

  mb3_plb_bridge : mb3_plb_bridge_wrapper
    port map (
      SPLB_Clk => sys_clk_s,
      SPLB_Rst => mb3_plb_bus_SPLB_Rst(0),
      IP2INTC_Irpt => open,
      PLB_ABus => mb3_plb_bus_PLB_ABus,
      PLB_UABus => mb3_plb_bus_PLB_UABus,
      PLB_PAValid => mb3_plb_bus_PLB_PAValid,
      PLB_SAValid => mb3_plb_bus_PLB_SAValid,
      PLB_rdPrim => mb3_plb_bus_PLB_rdPrim(0),
      PLB_wrPrim => mb3_plb_bus_PLB_wrPrim(0),
      PLB_masterID => mb3_plb_bus_PLB_masterID(0 to 0),
      PLB_abort => mb3_plb_bus_PLB_abort,
      PLB_busLock => mb3_plb_bus_PLB_busLock,
      PLB_RNW => mb3_plb_bus_PLB_RNW,
      PLB_BE => mb3_plb_bus_PLB_BE,
      PLB_MSize => mb3_plb_bus_PLB_MSize,
      PLB_size => mb3_plb_bus_PLB_size,
      PLB_type => mb3_plb_bus_PLB_type,
      PLB_lockErr => mb3_plb_bus_PLB_lockErr,
      PLB_wrDBus => mb3_plb_bus_PLB_wrDBus,
      PLB_wrBurst => mb3_plb_bus_PLB_wrBurst,
      PLB_rdBurst => mb3_plb_bus_PLB_rdBurst,
      PLB_wrPendReq => mb3_plb_bus_PLB_wrPendReq,
      PLB_rdPendReq => mb3_plb_bus_PLB_rdPendReq,
      PLB_wrPendPri => mb3_plb_bus_PLB_wrPendPri,
      PLB_rdPendPri => mb3_plb_bus_PLB_rdPendPri,
      PLB_reqPri => mb3_plb_bus_PLB_reqPri,
      PLB_TAttribute => mb3_plb_bus_PLB_TAttribute,
      Sl_addrAck => mb3_plb_bus_Sl_addrAck(0),
      Sl_SSize => mb3_plb_bus_Sl_SSize,
      Sl_wait => mb3_plb_bus_Sl_wait(0),
      Sl_rearbitrate => mb3_plb_bus_Sl_rearbitrate(0),
      Sl_wrDAck => mb3_plb_bus_Sl_wrDAck(0),
      Sl_wrComp => mb3_plb_bus_Sl_wrComp(0),
      Sl_wrBTerm => mb3_plb_bus_Sl_wrBTerm(0),
      Sl_rdDBus => mb3_plb_bus_Sl_rdDBus,
      Sl_rdWdAddr => mb3_plb_bus_Sl_rdWdAddr,
      Sl_rdDAck => mb3_plb_bus_Sl_rdDAck(0),
      Sl_rdComp => mb3_plb_bus_Sl_rdComp(0),
      Sl_rdBTerm => mb3_plb_bus_Sl_rdBTerm(0),
      Sl_MBusy => mb3_plb_bus_Sl_MBusy,
      Sl_MWrErr => mb3_plb_bus_Sl_MWrErr,
      Sl_MRdErr => mb3_plb_bus_Sl_MRdErr,
      Sl_MIRQ => mb3_plb_bus_Sl_MIRQ,
      MPLB_Clk => sys_clk_s,
      MPLB_Rst => plb_v46_0_MPLB_Rst(5),
      M_request => plb_v46_0_M_request(5),
      M_priority => plb_v46_0_M_priority(10 to 11),
      M_busLock => plb_v46_0_M_busLock(5),
      M_RNW => plb_v46_0_M_RNW(5),
      M_BE => plb_v46_0_M_BE(80 to 95),
      M_MSize => plb_v46_0_M_MSize(10 to 11),
      M_size => plb_v46_0_M_size(20 to 23),
      M_type => plb_v46_0_M_type(15 to 17),
      M_ABus => plb_v46_0_M_ABus(160 to 191),
      M_wrBurst => plb_v46_0_M_wrBurst(5),
      M_rdBurst => plb_v46_0_M_rdBurst(5),
      M_wrDBus => plb_v46_0_M_wrDBus(640 to 767),
      PLB_MAddrAck => plb_v46_0_PLB_MAddrAck(5),
      PLB_MSSize => plb_v46_0_PLB_MSSize(10 to 11),
      PLB_MRearbitrate => plb_v46_0_PLB_MRearbitrate(5),
      PLB_MTimeout => plb_v46_0_PLB_MTimeout(5),
      PLB_MRdErr => plb_v46_0_PLB_MRdErr(5),
      PLB_MWrErr => plb_v46_0_PLB_MWrErr(5),
      PLB_MRdDBus => plb_v46_0_PLB_MRdDBus(640 to 767),
      PLB_MRdDAck => plb_v46_0_PLB_MRdDAck(5),
      PLB_MRdBTerm => plb_v46_0_PLB_MRdBTerm(5),
      PLB_MWrDAck => plb_v46_0_PLB_MWrDAck(5),
      PLB_MWrBTerm => plb_v46_0_PLB_MWrBTerm(5),
      M_TAttribute => plb_v46_0_M_TAttribute(80 to 95),
      M_lockErr => plb_v46_0_M_lockErr(5),
      M_abort => plb_v46_0_M_abort(5),
      M_UABus => plb_v46_0_M_UABus(160 to 191),
      PLB_MBusy => plb_v46_0_PLB_MBusy(5),
      PLB_MIRQ => plb_v46_0_PLB_MIRQ(5),
      PLB_MRdWdAddr => plb_v46_0_PLB_MRdWdAddr(20 to 23)
    );

  mb3_plb_bus : mb3_plb_bus_wrapper
    port map (
      PLB_Clk => sys_clk_s,
      SYS_Rst => sys_bus_reset(0),
      PLB_Rst => open,
      SPLB_Rst => mb3_plb_bus_SPLB_Rst(0 to 0),
      MPLB_Rst => open,
      PLB_dcrAck => open,
      PLB_dcrDBus => open,
      DCR_ABus => net_gnd10,
      DCR_DBus => net_gnd32,
      DCR_Read => net_gnd0,
      DCR_Write => net_gnd0,
      M_ABus => mb3_plb_bus_M_ABus,
      M_UABus => mb3_plb_bus_M_UABus,
      M_BE => mb3_plb_bus_M_BE,
      M_RNW => mb3_plb_bus_M_RNW,
      M_abort => mb3_plb_bus_M_ABort,
      M_busLock => mb3_plb_bus_M_busLock,
      M_TAttribute => mb3_plb_bus_M_TAttribute,
      M_lockErr => mb3_plb_bus_M_lockErr,
      M_MSize => mb3_plb_bus_M_MSize,
      M_priority => mb3_plb_bus_M_priority,
      M_rdBurst => mb3_plb_bus_M_rdBurst,
      M_request => mb3_plb_bus_M_request,
      M_size => mb3_plb_bus_M_size,
      M_type => mb3_plb_bus_M_type,
      M_wrBurst => mb3_plb_bus_M_wrBurst,
      M_wrDBus => mb3_plb_bus_M_wrDBus,
      Sl_addrAck => mb3_plb_bus_Sl_addrAck(0 to 0),
      Sl_MRdErr => mb3_plb_bus_Sl_MRdErr,
      Sl_MWrErr => mb3_plb_bus_Sl_MWrErr,
      Sl_MBusy => mb3_plb_bus_Sl_MBusy,
      Sl_rdBTerm => mb3_plb_bus_Sl_rdBTerm(0 to 0),
      Sl_rdComp => mb3_plb_bus_Sl_rdComp(0 to 0),
      Sl_rdDAck => mb3_plb_bus_Sl_rdDAck(0 to 0),
      Sl_rdDBus => mb3_plb_bus_Sl_rdDBus,
      Sl_rdWdAddr => mb3_plb_bus_Sl_rdWdAddr,
      Sl_rearbitrate => mb3_plb_bus_Sl_rearbitrate(0 to 0),
      Sl_SSize => mb3_plb_bus_Sl_SSize,
      Sl_wait => mb3_plb_bus_Sl_wait(0 to 0),
      Sl_wrBTerm => mb3_plb_bus_Sl_wrBTerm(0 to 0),
      Sl_wrComp => mb3_plb_bus_Sl_wrComp(0 to 0),
      Sl_wrDAck => mb3_plb_bus_Sl_wrDAck(0 to 0),
      Sl_MIRQ => mb3_plb_bus_Sl_MIRQ,
      PLB_MIRQ => mb3_plb_bus_PLB_MIRQ,
      PLB_ABus => mb3_plb_bus_PLB_ABus,
      PLB_UABus => mb3_plb_bus_PLB_UABus,
      PLB_BE => mb3_plb_bus_PLB_BE,
      PLB_MAddrAck => mb3_plb_bus_PLB_MAddrAck,
      PLB_MTimeout => mb3_plb_bus_PLB_MTimeout,
      PLB_MBusy => mb3_plb_bus_PLB_MBusy,
      PLB_MRdErr => mb3_plb_bus_PLB_MRdErr,
      PLB_MWrErr => mb3_plb_bus_PLB_MWrErr,
      PLB_MRdBTerm => mb3_plb_bus_PLB_MRdBTerm,
      PLB_MRdDAck => mb3_plb_bus_PLB_MRdDAck,
      PLB_MRdDBus => mb3_plb_bus_PLB_MRdDBus,
      PLB_MRdWdAddr => mb3_plb_bus_PLB_MRdWdAddr,
      PLB_MRearbitrate => mb3_plb_bus_PLB_MRearbitrate,
      PLB_MWrBTerm => mb3_plb_bus_PLB_MWrBTerm,
      PLB_MWrDAck => mb3_plb_bus_PLB_MWrDAck,
      PLB_MSSize => mb3_plb_bus_PLB_MSSize,
      PLB_PAValid => mb3_plb_bus_PLB_PAValid,
      PLB_RNW => mb3_plb_bus_PLB_RNW,
      PLB_SAValid => mb3_plb_bus_PLB_SAValid,
      PLB_abort => mb3_plb_bus_PLB_abort,
      PLB_busLock => mb3_plb_bus_PLB_busLock,
      PLB_TAttribute => mb3_plb_bus_PLB_TAttribute,
      PLB_lockErr => mb3_plb_bus_PLB_lockErr,
      PLB_masterID => mb3_plb_bus_PLB_masterID(0 to 0),
      PLB_MSize => mb3_plb_bus_PLB_MSize,
      PLB_rdPendPri => mb3_plb_bus_PLB_rdPendPri,
      PLB_wrPendPri => mb3_plb_bus_PLB_wrPendPri,
      PLB_rdPendReq => mb3_plb_bus_PLB_rdPendReq,
      PLB_wrPendReq => mb3_plb_bus_PLB_wrPendReq,
      PLB_rdBurst => mb3_plb_bus_PLB_rdBurst,
      PLB_rdPrim => mb3_plb_bus_PLB_rdPrim(0 to 0),
      PLB_reqPri => mb3_plb_bus_PLB_reqPri,
      PLB_size => mb3_plb_bus_PLB_size,
      PLB_type => mb3_plb_bus_PLB_type,
      PLB_wrBurst => mb3_plb_bus_PLB_wrBurst,
      PLB_wrDBus => mb3_plb_bus_PLB_wrDBus,
      PLB_wrPrim => mb3_plb_bus_PLB_wrPrim(0 to 0),
      PLB_SaddrAck => open,
      PLB_SMRdErr => open,
      PLB_SMWrErr => open,
      PLB_SMBusy => open,
      PLB_SrdBTerm => open,
      PLB_SrdComp => open,
      PLB_SrdDAck => open,
      PLB_SrdDBus => open,
      PLB_SrdWdAddr => open,
      PLB_Srearbitrate => open,
      PLB_Sssize => open,
      PLB_Swait => open,
      PLB_SwrBTerm => open,
      PLB_SwrComp => open,
      PLB_SwrDAck => open,
      Bus_Error_Det => open
    );

  microblaze_mb4 : microblaze_mb4_wrapper
    port map (
      CLK => sys_clk_s,
      RESET => mb_dlmb_mb4_OPB_Rst,
      MB_RESET => net_gnd0,
      INTERRUPT => net_gnd0,
      EXT_BRK => Ext_BRK,
      EXT_NM_BRK => Ext_NM_BRK,
      DBG_STOP => net_gnd0,
      MB_Halted => open,
      INSTR => mb_ilmb_mb4_LMB_ReadDBus,
      I_ADDRTAG => open,
      IREADY => mb_ilmb_mb4_LMB_Ready,
      IWAIT => net_gnd0,
      INSTR_ADDR => mb_ilmb_mb4_M_ABus,
      IFETCH => mb_ilmb_mb4_M_ReadStrobe,
      I_AS => mb_ilmb_mb4_M_AddrStrobe,
      IPLB_M_ABort => mb4_plb_bus_M_ABort(1),
      IPLB_M_ABus => mb4_plb_bus_M_ABus(32 to 63),
      IPLB_M_UABus => mb4_plb_bus_M_UABus(32 to 63),
      IPLB_M_BE => mb4_plb_bus_M_BE(4 to 7),
      IPLB_M_busLock => mb4_plb_bus_M_busLock(1),
      IPLB_M_lockErr => mb4_plb_bus_M_lockErr(1),
      IPLB_M_MSize => mb4_plb_bus_M_MSize(2 to 3),
      IPLB_M_priority => mb4_plb_bus_M_priority(2 to 3),
      IPLB_M_rdBurst => mb4_plb_bus_M_rdBurst(1),
      IPLB_M_request => mb4_plb_bus_M_request(1),
      IPLB_M_RNW => mb4_plb_bus_M_RNW(1),
      IPLB_M_size => mb4_plb_bus_M_size(4 to 7),
      IPLB_M_TAttribute => mb4_plb_bus_M_TAttribute(16 to 31),
      IPLB_M_type => mb4_plb_bus_M_type(3 to 5),
      IPLB_M_wrBurst => mb4_plb_bus_M_wrBurst(1),
      IPLB_M_wrDBus => mb4_plb_bus_M_wrDBus(32 to 63),
      IPLB_MBusy => mb4_plb_bus_PLB_MBusy(1),
      IPLB_MRdErr => mb4_plb_bus_PLB_MRdErr(1),
      IPLB_MWrErr => mb4_plb_bus_PLB_MWrErr(1),
      IPLB_MIRQ => mb4_plb_bus_PLB_MIRQ(1),
      IPLB_MWrBTerm => mb4_plb_bus_PLB_MWrBTerm(1),
      IPLB_MWrDAck => mb4_plb_bus_PLB_MWrDAck(1),
      IPLB_MAddrAck => mb4_plb_bus_PLB_MAddrAck(1),
      IPLB_MRdBTerm => mb4_plb_bus_PLB_MRdBTerm(1),
      IPLB_MRdDAck => mb4_plb_bus_PLB_MRdDAck(1),
      IPLB_MRdDBus => mb4_plb_bus_PLB_MRdDBus(32 to 63),
      IPLB_MRdWdAddr => mb4_plb_bus_PLB_MRdWdAddr(4 to 7),
      IPLB_MRearbitrate => mb4_plb_bus_PLB_MRearbitrate(1),
      IPLB_MSSize => mb4_plb_bus_PLB_MSSize(2 to 3),
      IPLB_MTimeout => mb4_plb_bus_PLB_MTimeout(1),
      DATA_READ => mb_dlmb_mb4_LMB_ReadDBus,
      DREADY => mb_dlmb_mb4_LMB_Ready,
      DWAIT => net_gnd0,
      DATA_WRITE => mb_dlmb_mb4_M_DBus,
      DATA_ADDR => mb_dlmb_mb4_M_ABus,
      D_ADDRTAG => open,
      D_AS => mb_dlmb_mb4_M_AddrStrobe,
      READ_STROBE => mb_dlmb_mb4_M_ReadStrobe,
      WRITE_STROBE => mb_dlmb_mb4_M_WriteStrobe,
      BYTE_ENABLE => mb_dlmb_mb4_M_BE,
      DM_ABUS => open,
      DM_BE => open,
      DM_BUSLOCK => open,
      DM_DBUS => open,
      DM_REQUEST => open,
      DM_RNW => open,
      DM_SELECT => open,
      DM_SEQADDR => open,
      DOPB_DBUS => net_gnd32,
      DOPB_ERRACK => net_gnd0,
      DOPB_MGRANT => net_gnd0,
      DOPB_RETRY => net_gnd0,
      DOPB_TIMEOUT => net_gnd0,
      DOPB_XFERACK => net_gnd0,
      DPLB_M_ABort => mb4_plb_bus_M_ABort(0),
      DPLB_M_ABus => mb4_plb_bus_M_ABus(0 to 31),
      DPLB_M_UABus => mb4_plb_bus_M_UABus(0 to 31),
      DPLB_M_BE => mb4_plb_bus_M_BE(0 to 3),
      DPLB_M_busLock => mb4_plb_bus_M_busLock(0),
      DPLB_M_lockErr => mb4_plb_bus_M_lockErr(0),
      DPLB_M_MSize => mb4_plb_bus_M_MSize(0 to 1),
      DPLB_M_priority => mb4_plb_bus_M_priority(0 to 1),
      DPLB_M_rdBurst => mb4_plb_bus_M_rdBurst(0),
      DPLB_M_request => mb4_plb_bus_M_request(0),
      DPLB_M_RNW => mb4_plb_bus_M_RNW(0),
      DPLB_M_size => mb4_plb_bus_M_size(0 to 3),
      DPLB_M_TAttribute => mb4_plb_bus_M_TAttribute(0 to 15),
      DPLB_M_type => mb4_plb_bus_M_type(0 to 2),
      DPLB_M_wrBurst => mb4_plb_bus_M_wrBurst(0),
      DPLB_M_wrDBus => mb4_plb_bus_M_wrDBus(0 to 31),
      DPLB_MBusy => mb4_plb_bus_PLB_MBusy(0),
      DPLB_MRdErr => mb4_plb_bus_PLB_MRdErr(0),
      DPLB_MWrErr => mb4_plb_bus_PLB_MWrErr(0),
      DPLB_MIRQ => mb4_plb_bus_PLB_MIRQ(0),
      DPLB_MWrBTerm => mb4_plb_bus_PLB_MWrBTerm(0),
      DPLB_MWrDAck => mb4_plb_bus_PLB_MWrDAck(0),
      DPLB_MAddrAck => mb4_plb_bus_PLB_MAddrAck(0),
      DPLB_MRdBTerm => mb4_plb_bus_PLB_MRdBTerm(0),
      DPLB_MRdDAck => mb4_plb_bus_PLB_MRdDAck(0),
      DPLB_MRdDBus => mb4_plb_bus_PLB_MRdDBus(0 to 31),
      DPLB_MRdWdAddr => mb4_plb_bus_PLB_MRdWdAddr(0 to 3),
      DPLB_MRearbitrate => mb4_plb_bus_PLB_MRearbitrate(0),
      DPLB_MSSize => mb4_plb_bus_PLB_MSSize(0 to 1),
      DPLB_MTimeout => mb4_plb_bus_PLB_MTimeout(0),
      IM_ABUS => open,
      IM_BE => open,
      IM_BUSLOCK => open,
      IM_DBUS => open,
      IM_REQUEST => open,
      IM_RNW => open,
      IM_SELECT => open,
      IM_SEQADDR => open,
      IOPB_DBUS => net_gnd32,
      IOPB_ERRACK => net_gnd0,
      IOPB_MGRANT => net_gnd0,
      IOPB_RETRY => net_gnd0,
      IOPB_TIMEOUT => net_gnd0,
      IOPB_XFERACK => net_gnd0,
      DBG_CLK => net_gnd0,
      DBG_TDI => net_gnd0,
      DBG_TDO => open,
      DBG_REG_EN => net_gnd5,
      DBG_SHIFT => net_gnd0,
      DBG_CAPTURE => net_gnd0,
      DBG_UPDATE => net_gnd0,
      DEBUG_RST => net_gnd0,
      Trace_Instruction => open,
      Trace_Valid_Instr => open,
      Trace_PC => open,
      Trace_Reg_Write => open,
      Trace_Reg_Addr => open,
      Trace_MSR_Reg => open,
      Trace_PID_Reg => open,
      Trace_New_Reg_Value => open,
      Trace_Exception_Taken => open,
      Trace_Exception_Kind => open,
      Trace_Jump_Taken => open,
      Trace_Delay_Slot => open,
      Trace_Data_Address => open,
      Trace_Data_Access => open,
      Trace_Data_Read => open,
      Trace_Data_Write => open,
      Trace_Data_Write_Value => open,
      Trace_Data_Byte_Enable => open,
      Trace_DCache_Req => open,
      Trace_DCache_Hit => open,
      Trace_ICache_Req => open,
      Trace_ICache_Hit => open,
      Trace_OF_PipeRun => open,
      Trace_EX_PipeRun => open,
      Trace_MEM_PipeRun => open,
      Trace_MB_Halted => open,
      FSL0_S_CLK => open,
      FSL0_S_READ => open,
      FSL0_S_DATA => net_gnd32,
      FSL0_S_CONTROL => net_gnd0,
      FSL0_S_EXISTS => net_gnd0,
      FSL0_M_CLK => open,
      FSL0_M_WRITE => open,
      FSL0_M_DATA => open,
      FSL0_M_CONTROL => open,
      FSL0_M_FULL => net_gnd0,
      FSL1_S_CLK => open,
      FSL1_S_READ => open,
      FSL1_S_DATA => net_gnd32,
      FSL1_S_CONTROL => net_gnd0,
      FSL1_S_EXISTS => net_gnd0,
      FSL1_M_CLK => open,
      FSL1_M_WRITE => open,
      FSL1_M_DATA => open,
      FSL1_M_CONTROL => open,
      FSL1_M_FULL => net_gnd0,
      FSL2_S_CLK => open,
      FSL2_S_READ => open,
      FSL2_S_DATA => net_gnd32,
      FSL2_S_CONTROL => net_gnd0,
      FSL2_S_EXISTS => net_gnd0,
      FSL2_M_CLK => open,
      FSL2_M_WRITE => open,
      FSL2_M_DATA => open,
      FSL2_M_CONTROL => open,
      FSL2_M_FULL => net_gnd0,
      FSL3_S_CLK => open,
      FSL3_S_READ => open,
      FSL3_S_DATA => net_gnd32,
      FSL3_S_CONTROL => net_gnd0,
      FSL3_S_EXISTS => net_gnd0,
      FSL3_M_CLK => open,
      FSL3_M_WRITE => open,
      FSL3_M_DATA => open,
      FSL3_M_CONTROL => open,
      FSL3_M_FULL => net_gnd0,
      FSL4_S_CLK => open,
      FSL4_S_READ => open,
      FSL4_S_DATA => net_gnd32,
      FSL4_S_CONTROL => net_gnd0,
      FSL4_S_EXISTS => net_gnd0,
      FSL4_M_CLK => open,
      FSL4_M_WRITE => open,
      FSL4_M_DATA => open,
      FSL4_M_CONTROL => open,
      FSL4_M_FULL => net_gnd0,
      FSL5_S_CLK => open,
      FSL5_S_READ => open,
      FSL5_S_DATA => net_gnd32,
      FSL5_S_CONTROL => net_gnd0,
      FSL5_S_EXISTS => net_gnd0,
      FSL5_M_CLK => open,
      FSL5_M_WRITE => open,
      FSL5_M_DATA => open,
      FSL5_M_CONTROL => open,
      FSL5_M_FULL => net_gnd0,
      FSL6_S_CLK => open,
      FSL6_S_READ => open,
      FSL6_S_DATA => net_gnd32,
      FSL6_S_CONTROL => net_gnd0,
      FSL6_S_EXISTS => net_gnd0,
      FSL6_M_CLK => open,
      FSL6_M_WRITE => open,
      FSL6_M_DATA => open,
      FSL6_M_CONTROL => open,
      FSL6_M_FULL => net_gnd0,
      FSL7_S_CLK => open,
      FSL7_S_READ => open,
      FSL7_S_DATA => net_gnd32,
      FSL7_S_CONTROL => net_gnd0,
      FSL7_S_EXISTS => net_gnd0,
      FSL7_M_CLK => open,
      FSL7_M_WRITE => open,
      FSL7_M_DATA => open,
      FSL7_M_CONTROL => open,
      FSL7_M_FULL => net_gnd0,
      FSL8_S_CLK => open,
      FSL8_S_READ => open,
      FSL8_S_DATA => net_gnd32,
      FSL8_S_CONTROL => net_gnd0,
      FSL8_S_EXISTS => net_gnd0,
      FSL8_M_CLK => open,
      FSL8_M_WRITE => open,
      FSL8_M_DATA => open,
      FSL8_M_CONTROL => open,
      FSL8_M_FULL => net_gnd0,
      FSL9_S_CLK => open,
      FSL9_S_READ => open,
      FSL9_S_DATA => net_gnd32,
      FSL9_S_CONTROL => net_gnd0,
      FSL9_S_EXISTS => net_gnd0,
      FSL9_M_CLK => open,
      FSL9_M_WRITE => open,
      FSL9_M_DATA => open,
      FSL9_M_CONTROL => open,
      FSL9_M_FULL => net_gnd0,
      FSL10_S_CLK => open,
      FSL10_S_READ => open,
      FSL10_S_DATA => net_gnd32,
      FSL10_S_CONTROL => net_gnd0,
      FSL10_S_EXISTS => net_gnd0,
      FSL10_M_CLK => open,
      FSL10_M_WRITE => open,
      FSL10_M_DATA => open,
      FSL10_M_CONTROL => open,
      FSL10_M_FULL => net_gnd0,
      FSL11_S_CLK => open,
      FSL11_S_READ => open,
      FSL11_S_DATA => net_gnd32,
      FSL11_S_CONTROL => net_gnd0,
      FSL11_S_EXISTS => net_gnd0,
      FSL11_M_CLK => open,
      FSL11_M_WRITE => open,
      FSL11_M_DATA => open,
      FSL11_M_CONTROL => open,
      FSL11_M_FULL => net_gnd0,
      FSL12_S_CLK => open,
      FSL12_S_READ => open,
      FSL12_S_DATA => net_gnd32,
      FSL12_S_CONTROL => net_gnd0,
      FSL12_S_EXISTS => net_gnd0,
      FSL12_M_CLK => open,
      FSL12_M_WRITE => open,
      FSL12_M_DATA => open,
      FSL12_M_CONTROL => open,
      FSL12_M_FULL => net_gnd0,
      FSL13_S_CLK => open,
      FSL13_S_READ => open,
      FSL13_S_DATA => net_gnd32,
      FSL13_S_CONTROL => net_gnd0,
      FSL13_S_EXISTS => net_gnd0,
      FSL13_M_CLK => open,
      FSL13_M_WRITE => open,
      FSL13_M_DATA => open,
      FSL13_M_CONTROL => open,
      FSL13_M_FULL => net_gnd0,
      FSL14_S_CLK => open,
      FSL14_S_READ => open,
      FSL14_S_DATA => net_gnd32,
      FSL14_S_CONTROL => net_gnd0,
      FSL14_S_EXISTS => net_gnd0,
      FSL14_M_CLK => open,
      FSL14_M_WRITE => open,
      FSL14_M_DATA => open,
      FSL14_M_CONTROL => open,
      FSL14_M_FULL => net_gnd0,
      FSL15_S_CLK => open,
      FSL15_S_READ => open,
      FSL15_S_DATA => net_gnd32,
      FSL15_S_CONTROL => net_gnd0,
      FSL15_S_EXISTS => net_gnd0,
      FSL15_M_CLK => open,
      FSL15_M_WRITE => open,
      FSL15_M_DATA => open,
      FSL15_M_CONTROL => open,
      FSL15_M_FULL => net_gnd0,
      ICACHE_FSL_IN_CLK => microblaze_mb4_IXCL_FSL_S_Clk,
      ICACHE_FSL_IN_READ => microblaze_mb4_IXCL_FSL_S_Read,
      ICACHE_FSL_IN_DATA => microblaze_mb4_IXCL_FSL_S_Data,
      ICACHE_FSL_IN_CONTROL => microblaze_mb4_IXCL_FSL_S_Control,
      ICACHE_FSL_IN_EXISTS => microblaze_mb4_IXCL_FSL_S_Exists,
      ICACHE_FSL_OUT_CLK => microblaze_mb4_IXCL_FSL_M_Clk,
      ICACHE_FSL_OUT_WRITE => microblaze_mb4_IXCL_FSL_M_Write,
      ICACHE_FSL_OUT_DATA => microblaze_mb4_IXCL_FSL_M_Data,
      ICACHE_FSL_OUT_CONTROL => microblaze_mb4_IXCL_FSL_M_Control,
      ICACHE_FSL_OUT_FULL => microblaze_mb4_IXCL_FSL_M_Full,
      DCACHE_FSL_IN_CLK => open,
      DCACHE_FSL_IN_READ => open,
      DCACHE_FSL_IN_DATA => net_gnd32,
      DCACHE_FSL_IN_CONTROL => net_gnd0,
      DCACHE_FSL_IN_EXISTS => net_gnd0,
      DCACHE_FSL_OUT_CLK => open,
      DCACHE_FSL_OUT_WRITE => open,
      DCACHE_FSL_OUT_DATA => open,
      DCACHE_FSL_OUT_CONTROL => open,
      DCACHE_FSL_OUT_FULL => net_gnd0
    );

  mb_ilmb_mb4 : mb_ilmb_mb4_wrapper
    port map (
      LMB_Clk => sys_clk_s,
      SYS_Rst => sys_bus_reset(0),
      LMB_Rst => mb_ilmb_mb4_OPB_Rst,
      M_ABus => mb_ilmb_mb4_M_ABus,
      M_ReadStrobe => mb_ilmb_mb4_M_ReadStrobe,
      M_WriteStrobe => net_gnd0,
      M_AddrStrobe => mb_ilmb_mb4_M_AddrStrobe,
      M_DBus => net_gnd32,
      M_BE => net_gnd4,
      Sl_DBus => mb_ilmb_mb4_Sl_DBus,
      Sl_Ready => mb_ilmb_mb4_Sl_Ready(0 to 0),
      LMB_ABus => mb_ilmb_mb4_LMB_ABus,
      LMB_ReadStrobe => mb_ilmb_mb4_LMB_ReadStrobe,
      LMB_WriteStrobe => mb_ilmb_mb4_LMB_WriteStrobe,
      LMB_AddrStrobe => mb_ilmb_mb4_LMB_AddrStrobe,
      LMB_ReadDBus => mb_ilmb_mb4_LMB_ReadDBus,
      LMB_WriteDBus => mb_ilmb_mb4_LMB_WriteDBus,
      LMB_Ready => mb_ilmb_mb4_LMB_Ready,
      LMB_BE => mb_ilmb_mb4_LMB_BE
    );

  mb_dlmb_mb4 : mb_dlmb_mb4_wrapper
    port map (
      LMB_Clk => sys_clk_s,
      SYS_Rst => sys_bus_reset(0),
      LMB_Rst => mb_dlmb_mb4_OPB_Rst,
      M_ABus => mb_dlmb_mb4_M_ABus,
      M_ReadStrobe => mb_dlmb_mb4_M_ReadStrobe,
      M_WriteStrobe => mb_dlmb_mb4_M_WriteStrobe,
      M_AddrStrobe => mb_dlmb_mb4_M_AddrStrobe,
      M_DBus => mb_dlmb_mb4_M_DBus,
      M_BE => mb_dlmb_mb4_M_BE,
      Sl_DBus => mb_dlmb_mb4_Sl_DBus,
      Sl_Ready => mb_dlmb_mb4_Sl_Ready(0 to 0),
      LMB_ABus => mb_dlmb_mb4_LMB_ABus,
      LMB_ReadStrobe => mb_dlmb_mb4_LMB_ReadStrobe,
      LMB_WriteStrobe => mb_dlmb_mb4_LMB_WriteStrobe,
      LMB_AddrStrobe => mb_dlmb_mb4_LMB_AddrStrobe,
      LMB_ReadDBus => mb_dlmb_mb4_LMB_ReadDBus,
      LMB_WriteDBus => mb_dlmb_mb4_LMB_WriteDBus,
      LMB_Ready => mb_dlmb_mb4_LMB_Ready,
      LMB_BE => mb_dlmb_mb4_LMB_BE
    );

  ilmb_cntlr_mb4 : ilmb_cntlr_mb4_wrapper
    port map (
      LMB_Clk => sys_clk_s,
      LMB_Rst => mb_ilmb_mb4_OPB_Rst,
      LMB_ABus => mb_ilmb_mb4_LMB_ABus,
      LMB_WriteDBus => mb_ilmb_mb4_LMB_WriteDBus,
      LMB_AddrStrobe => mb_ilmb_mb4_LMB_AddrStrobe,
      LMB_ReadStrobe => mb_ilmb_mb4_LMB_ReadStrobe,
      LMB_WriteStrobe => mb_ilmb_mb4_LMB_WriteStrobe,
      LMB_BE => mb_ilmb_mb4_LMB_BE,
      Sl_DBus => mb_ilmb_mb4_Sl_DBus,
      Sl_Ready => mb_ilmb_mb4_Sl_Ready(0),
      BRAM_Rst_A => ilmb_cntlr_BRAM_PORT_mb4_BRAM_Rst,
      BRAM_Clk_A => ilmb_cntlr_BRAM_PORT_mb4_BRAM_Clk,
      BRAM_EN_A => ilmb_cntlr_BRAM_PORT_mb4_BRAM_EN,
      BRAM_WEN_A => ilmb_cntlr_BRAM_PORT_mb4_BRAM_WEN,
      BRAM_Addr_A => ilmb_cntlr_BRAM_PORT_mb4_BRAM_Addr,
      BRAM_Din_A => ilmb_cntlr_BRAM_PORT_mb4_BRAM_Din,
      BRAM_Dout_A => ilmb_cntlr_BRAM_PORT_mb4_BRAM_Dout
    );

  dlmb_cntlr_mb4 : dlmb_cntlr_mb4_wrapper
    port map (
      LMB_Clk => sys_clk_s,
      LMB_Rst => mb_dlmb_mb4_OPB_Rst,
      LMB_ABus => mb_dlmb_mb4_LMB_ABus,
      LMB_WriteDBus => mb_dlmb_mb4_LMB_WriteDBus,
      LMB_AddrStrobe => mb_dlmb_mb4_LMB_AddrStrobe,
      LMB_ReadStrobe => mb_dlmb_mb4_LMB_ReadStrobe,
      LMB_WriteStrobe => mb_dlmb_mb4_LMB_WriteStrobe,
      LMB_BE => mb_dlmb_mb4_LMB_BE,
      Sl_DBus => mb_dlmb_mb4_Sl_DBus,
      Sl_Ready => mb_dlmb_mb4_Sl_Ready(0),
      BRAM_Rst_A => dlmb_cntlr_BRAM_PORT_mb4_BRAM_Rst,
      BRAM_Clk_A => dlmb_cntlr_BRAM_PORT_mb4_BRAM_Clk,
      BRAM_EN_A => dlmb_cntlr_BRAM_PORT_mb4_BRAM_EN,
      BRAM_WEN_A => dlmb_cntlr_BRAM_PORT_mb4_BRAM_WEN,
      BRAM_Addr_A => dlmb_cntlr_BRAM_PORT_mb4_BRAM_Addr,
      BRAM_Din_A => dlmb_cntlr_BRAM_PORT_mb4_BRAM_Din,
      BRAM_Dout_A => dlmb_cntlr_BRAM_PORT_mb4_BRAM_Dout
    );

  mb4_bram : mb4_bram_wrapper
    port map (
      BRAM_Rst_A => ilmb_cntlr_BRAM_PORT_mb4_BRAM_Rst,
      BRAM_Clk_A => ilmb_cntlr_BRAM_PORT_mb4_BRAM_Clk,
      BRAM_EN_A => ilmb_cntlr_BRAM_PORT_mb4_BRAM_EN,
      BRAM_WEN_A => ilmb_cntlr_BRAM_PORT_mb4_BRAM_WEN,
      BRAM_Addr_A => ilmb_cntlr_BRAM_PORT_mb4_BRAM_Addr,
      BRAM_Din_A => ilmb_cntlr_BRAM_PORT_mb4_BRAM_Din,
      BRAM_Dout_A => ilmb_cntlr_BRAM_PORT_mb4_BRAM_Dout,
      BRAM_Rst_B => dlmb_cntlr_BRAM_PORT_mb4_BRAM_Rst,
      BRAM_Clk_B => dlmb_cntlr_BRAM_PORT_mb4_BRAM_Clk,
      BRAM_EN_B => dlmb_cntlr_BRAM_PORT_mb4_BRAM_EN,
      BRAM_WEN_B => dlmb_cntlr_BRAM_PORT_mb4_BRAM_WEN,
      BRAM_Addr_B => dlmb_cntlr_BRAM_PORT_mb4_BRAM_Addr,
      BRAM_Din_B => dlmb_cntlr_BRAM_PORT_mb4_BRAM_Din,
      BRAM_Dout_B => dlmb_cntlr_BRAM_PORT_mb4_BRAM_Dout
    );

  mb4_plb_bridge : mb4_plb_bridge_wrapper
    port map (
      SPLB_Clk => sys_clk_s,
      SPLB_Rst => mb4_plb_bus_SPLB_Rst(0),
      IP2INTC_Irpt => open,
      PLB_ABus => mb4_plb_bus_PLB_ABus,
      PLB_UABus => mb4_plb_bus_PLB_UABus,
      PLB_PAValid => mb4_plb_bus_PLB_PAValid,
      PLB_SAValid => mb4_plb_bus_PLB_SAValid,
      PLB_rdPrim => mb4_plb_bus_PLB_rdPrim(0),
      PLB_wrPrim => mb4_plb_bus_PLB_wrPrim(0),
      PLB_masterID => mb4_plb_bus_PLB_masterID(0 to 0),
      PLB_abort => mb4_plb_bus_PLB_abort,
      PLB_busLock => mb4_plb_bus_PLB_busLock,
      PLB_RNW => mb4_plb_bus_PLB_RNW,
      PLB_BE => mb4_plb_bus_PLB_BE,
      PLB_MSize => mb4_plb_bus_PLB_MSize,
      PLB_size => mb4_plb_bus_PLB_size,
      PLB_type => mb4_plb_bus_PLB_type,
      PLB_lockErr => mb4_plb_bus_PLB_lockErr,
      PLB_wrDBus => mb4_plb_bus_PLB_wrDBus,
      PLB_wrBurst => mb4_plb_bus_PLB_wrBurst,
      PLB_rdBurst => mb4_plb_bus_PLB_rdBurst,
      PLB_wrPendReq => mb4_plb_bus_PLB_wrPendReq,
      PLB_rdPendReq => mb4_plb_bus_PLB_rdPendReq,
      PLB_wrPendPri => mb4_plb_bus_PLB_wrPendPri,
      PLB_rdPendPri => mb4_plb_bus_PLB_rdPendPri,
      PLB_reqPri => mb4_plb_bus_PLB_reqPri,
      PLB_TAttribute => mb4_plb_bus_PLB_TAttribute,
      Sl_addrAck => mb4_plb_bus_Sl_addrAck(0),
      Sl_SSize => mb4_plb_bus_Sl_SSize,
      Sl_wait => mb4_plb_bus_Sl_wait(0),
      Sl_rearbitrate => mb4_plb_bus_Sl_rearbitrate(0),
      Sl_wrDAck => mb4_plb_bus_Sl_wrDAck(0),
      Sl_wrComp => mb4_plb_bus_Sl_wrComp(0),
      Sl_wrBTerm => mb4_plb_bus_Sl_wrBTerm(0),
      Sl_rdDBus => mb4_plb_bus_Sl_rdDBus,
      Sl_rdWdAddr => mb4_plb_bus_Sl_rdWdAddr,
      Sl_rdDAck => mb4_plb_bus_Sl_rdDAck(0),
      Sl_rdComp => mb4_plb_bus_Sl_rdComp(0),
      Sl_rdBTerm => mb4_plb_bus_Sl_rdBTerm(0),
      Sl_MBusy => mb4_plb_bus_Sl_MBusy,
      Sl_MWrErr => mb4_plb_bus_Sl_MWrErr,
      Sl_MRdErr => mb4_plb_bus_Sl_MRdErr,
      Sl_MIRQ => mb4_plb_bus_Sl_MIRQ,
      MPLB_Clk => sys_clk_s,
      MPLB_Rst => plb_v46_0_MPLB_Rst(6),
      M_request => plb_v46_0_M_request(6),
      M_priority => plb_v46_0_M_priority(12 to 13),
      M_busLock => plb_v46_0_M_busLock(6),
      M_RNW => plb_v46_0_M_RNW(6),
      M_BE => plb_v46_0_M_BE(96 to 111),
      M_MSize => plb_v46_0_M_MSize(12 to 13),
      M_size => plb_v46_0_M_size(24 to 27),
      M_type => plb_v46_0_M_type(18 to 20),
      M_ABus => plb_v46_0_M_ABus(192 to 223),
      M_wrBurst => plb_v46_0_M_wrBurst(6),
      M_rdBurst => plb_v46_0_M_rdBurst(6),
      M_wrDBus => plb_v46_0_M_wrDBus(768 to 895),
      PLB_MAddrAck => plb_v46_0_PLB_MAddrAck(6),
      PLB_MSSize => plb_v46_0_PLB_MSSize(12 to 13),
      PLB_MRearbitrate => plb_v46_0_PLB_MRearbitrate(6),
      PLB_MTimeout => plb_v46_0_PLB_MTimeout(6),
      PLB_MRdErr => plb_v46_0_PLB_MRdErr(6),
      PLB_MWrErr => plb_v46_0_PLB_MWrErr(6),
      PLB_MRdDBus => plb_v46_0_PLB_MRdDBus(768 to 895),
      PLB_MRdDAck => plb_v46_0_PLB_MRdDAck(6),
      PLB_MRdBTerm => plb_v46_0_PLB_MRdBTerm(6),
      PLB_MWrDAck => plb_v46_0_PLB_MWrDAck(6),
      PLB_MWrBTerm => plb_v46_0_PLB_MWrBTerm(6),
      M_TAttribute => plb_v46_0_M_TAttribute(96 to 111),
      M_lockErr => plb_v46_0_M_lockErr(6),
      M_abort => plb_v46_0_M_abort(6),
      M_UABus => plb_v46_0_M_UABus(192 to 223),
      PLB_MBusy => plb_v46_0_PLB_MBusy(6),
      PLB_MIRQ => plb_v46_0_PLB_MIRQ(6),
      PLB_MRdWdAddr => plb_v46_0_PLB_MRdWdAddr(24 to 27)
    );

  mb4_plb_bus : mb4_plb_bus_wrapper
    port map (
      PLB_Clk => sys_clk_s,
      SYS_Rst => sys_bus_reset(0),
      PLB_Rst => open,
      SPLB_Rst => mb4_plb_bus_SPLB_Rst(0 to 0),
      MPLB_Rst => open,
      PLB_dcrAck => open,
      PLB_dcrDBus => open,
      DCR_ABus => net_gnd10,
      DCR_DBus => net_gnd32,
      DCR_Read => net_gnd0,
      DCR_Write => net_gnd0,
      M_ABus => mb4_plb_bus_M_ABus,
      M_UABus => mb4_plb_bus_M_UABus,
      M_BE => mb4_plb_bus_M_BE,
      M_RNW => mb4_plb_bus_M_RNW,
      M_abort => mb4_plb_bus_M_ABort,
      M_busLock => mb4_plb_bus_M_busLock,
      M_TAttribute => mb4_plb_bus_M_TAttribute,
      M_lockErr => mb4_plb_bus_M_lockErr,
      M_MSize => mb4_plb_bus_M_MSize,
      M_priority => mb4_plb_bus_M_priority,
      M_rdBurst => mb4_plb_bus_M_rdBurst,
      M_request => mb4_plb_bus_M_request,
      M_size => mb4_plb_bus_M_size,
      M_type => mb4_plb_bus_M_type,
      M_wrBurst => mb4_plb_bus_M_wrBurst,
      M_wrDBus => mb4_plb_bus_M_wrDBus,
      Sl_addrAck => mb4_plb_bus_Sl_addrAck(0 to 0),
      Sl_MRdErr => mb4_plb_bus_Sl_MRdErr,
      Sl_MWrErr => mb4_plb_bus_Sl_MWrErr,
      Sl_MBusy => mb4_plb_bus_Sl_MBusy,
      Sl_rdBTerm => mb4_plb_bus_Sl_rdBTerm(0 to 0),
      Sl_rdComp => mb4_plb_bus_Sl_rdComp(0 to 0),
      Sl_rdDAck => mb4_plb_bus_Sl_rdDAck(0 to 0),
      Sl_rdDBus => mb4_plb_bus_Sl_rdDBus,
      Sl_rdWdAddr => mb4_plb_bus_Sl_rdWdAddr,
      Sl_rearbitrate => mb4_plb_bus_Sl_rearbitrate(0 to 0),
      Sl_SSize => mb4_plb_bus_Sl_SSize,
      Sl_wait => mb4_plb_bus_Sl_wait(0 to 0),
      Sl_wrBTerm => mb4_plb_bus_Sl_wrBTerm(0 to 0),
      Sl_wrComp => mb4_plb_bus_Sl_wrComp(0 to 0),
      Sl_wrDAck => mb4_plb_bus_Sl_wrDAck(0 to 0),
      Sl_MIRQ => mb4_plb_bus_Sl_MIRQ,
      PLB_MIRQ => mb4_plb_bus_PLB_MIRQ,
      PLB_ABus => mb4_plb_bus_PLB_ABus,
      PLB_UABus => mb4_plb_bus_PLB_UABus,
      PLB_BE => mb4_plb_bus_PLB_BE,
      PLB_MAddrAck => mb4_plb_bus_PLB_MAddrAck,
      PLB_MTimeout => mb4_plb_bus_PLB_MTimeout,
      PLB_MBusy => mb4_plb_bus_PLB_MBusy,
      PLB_MRdErr => mb4_plb_bus_PLB_MRdErr,
      PLB_MWrErr => mb4_plb_bus_PLB_MWrErr,
      PLB_MRdBTerm => mb4_plb_bus_PLB_MRdBTerm,
      PLB_MRdDAck => mb4_plb_bus_PLB_MRdDAck,
      PLB_MRdDBus => mb4_plb_bus_PLB_MRdDBus,
      PLB_MRdWdAddr => mb4_plb_bus_PLB_MRdWdAddr,
      PLB_MRearbitrate => mb4_plb_bus_PLB_MRearbitrate,
      PLB_MWrBTerm => mb4_plb_bus_PLB_MWrBTerm,
      PLB_MWrDAck => mb4_plb_bus_PLB_MWrDAck,
      PLB_MSSize => mb4_plb_bus_PLB_MSSize,
      PLB_PAValid => mb4_plb_bus_PLB_PAValid,
      PLB_RNW => mb4_plb_bus_PLB_RNW,
      PLB_SAValid => mb4_plb_bus_PLB_SAValid,
      PLB_abort => mb4_plb_bus_PLB_abort,
      PLB_busLock => mb4_plb_bus_PLB_busLock,
      PLB_TAttribute => mb4_plb_bus_PLB_TAttribute,
      PLB_lockErr => mb4_plb_bus_PLB_lockErr,
      PLB_masterID => mb4_plb_bus_PLB_masterID(0 to 0),
      PLB_MSize => mb4_plb_bus_PLB_MSize,
      PLB_rdPendPri => mb4_plb_bus_PLB_rdPendPri,
      PLB_wrPendPri => mb4_plb_bus_PLB_wrPendPri,
      PLB_rdPendReq => mb4_plb_bus_PLB_rdPendReq,
      PLB_wrPendReq => mb4_plb_bus_PLB_wrPendReq,
      PLB_rdBurst => mb4_plb_bus_PLB_rdBurst,
      PLB_rdPrim => mb4_plb_bus_PLB_rdPrim(0 to 0),
      PLB_reqPri => mb4_plb_bus_PLB_reqPri,
      PLB_size => mb4_plb_bus_PLB_size,
      PLB_type => mb4_plb_bus_PLB_type,
      PLB_wrBurst => mb4_plb_bus_PLB_wrBurst,
      PLB_wrDBus => mb4_plb_bus_PLB_wrDBus,
      PLB_wrPrim => mb4_plb_bus_PLB_wrPrim(0 to 0),
      PLB_SaddrAck => open,
      PLB_SMRdErr => open,
      PLB_SMWrErr => open,
      PLB_SMBusy => open,
      PLB_SrdBTerm => open,
      PLB_SrdComp => open,
      PLB_SrdDAck => open,
      PLB_SrdDBus => open,
      PLB_SrdWdAddr => open,
      PLB_Srearbitrate => open,
      PLB_Sssize => open,
      PLB_Swait => open,
      PLB_SwrBTerm => open,
      PLB_SwrComp => open,
      PLB_SwrDAck => open,
      Bus_Error_Det => open
    );

  microblaze_mb5 : microblaze_mb5_wrapper
    port map (
      CLK => sys_clk_s,
      RESET => mb_dlmb_mb5_OPB_Rst,
      MB_RESET => net_gnd0,
      INTERRUPT => net_gnd0,
      EXT_BRK => Ext_BRK,
      EXT_NM_BRK => Ext_NM_BRK,
      DBG_STOP => net_gnd0,
      MB_Halted => open,
      INSTR => mb_ilmb_mb5_LMB_ReadDBus,
      I_ADDRTAG => open,
      IREADY => mb_ilmb_mb5_LMB_Ready,
      IWAIT => net_gnd0,
      INSTR_ADDR => mb_ilmb_mb5_M_ABus,
      IFETCH => mb_ilmb_mb5_M_ReadStrobe,
      I_AS => mb_ilmb_mb5_M_AddrStrobe,
      IPLB_M_ABort => mb5_plb_bus_M_ABort(1),
      IPLB_M_ABus => mb5_plb_bus_M_ABus(32 to 63),
      IPLB_M_UABus => mb5_plb_bus_M_UABus(32 to 63),
      IPLB_M_BE => mb5_plb_bus_M_BE(4 to 7),
      IPLB_M_busLock => mb5_plb_bus_M_busLock(1),
      IPLB_M_lockErr => mb5_plb_bus_M_lockErr(1),
      IPLB_M_MSize => mb5_plb_bus_M_MSize(2 to 3),
      IPLB_M_priority => mb5_plb_bus_M_priority(2 to 3),
      IPLB_M_rdBurst => mb5_plb_bus_M_rdBurst(1),
      IPLB_M_request => mb5_plb_bus_M_request(1),
      IPLB_M_RNW => mb5_plb_bus_M_RNW(1),
      IPLB_M_size => mb5_plb_bus_M_size(4 to 7),
      IPLB_M_TAttribute => mb5_plb_bus_M_TAttribute(16 to 31),
      IPLB_M_type => mb5_plb_bus_M_type(3 to 5),
      IPLB_M_wrBurst => mb5_plb_bus_M_wrBurst(1),
      IPLB_M_wrDBus => mb5_plb_bus_M_wrDBus(32 to 63),
      IPLB_MBusy => mb5_plb_bus_PLB_MBusy(1),
      IPLB_MRdErr => mb5_plb_bus_PLB_MRdErr(1),
      IPLB_MWrErr => mb5_plb_bus_PLB_MWrErr(1),
      IPLB_MIRQ => mb5_plb_bus_PLB_MIRQ(1),
      IPLB_MWrBTerm => mb5_plb_bus_PLB_MWrBTerm(1),
      IPLB_MWrDAck => mb5_plb_bus_PLB_MWrDAck(1),
      IPLB_MAddrAck => mb5_plb_bus_PLB_MAddrAck(1),
      IPLB_MRdBTerm => mb5_plb_bus_PLB_MRdBTerm(1),
      IPLB_MRdDAck => mb5_plb_bus_PLB_MRdDAck(1),
      IPLB_MRdDBus => mb5_plb_bus_PLB_MRdDBus(32 to 63),
      IPLB_MRdWdAddr => mb5_plb_bus_PLB_MRdWdAddr(4 to 7),
      IPLB_MRearbitrate => mb5_plb_bus_PLB_MRearbitrate(1),
      IPLB_MSSize => mb5_plb_bus_PLB_MSSize(2 to 3),
      IPLB_MTimeout => mb5_plb_bus_PLB_MTimeout(1),
      DATA_READ => mb_dlmb_mb5_LMB_ReadDBus,
      DREADY => mb_dlmb_mb5_LMB_Ready,
      DWAIT => net_gnd0,
      DATA_WRITE => mb_dlmb_mb5_M_DBus,
      DATA_ADDR => mb_dlmb_mb5_M_ABus,
      D_ADDRTAG => open,
      D_AS => mb_dlmb_mb5_M_AddrStrobe,
      READ_STROBE => mb_dlmb_mb5_M_ReadStrobe,
      WRITE_STROBE => mb_dlmb_mb5_M_WriteStrobe,
      BYTE_ENABLE => mb_dlmb_mb5_M_BE,
      DM_ABUS => open,
      DM_BE => open,
      DM_BUSLOCK => open,
      DM_DBUS => open,
      DM_REQUEST => open,
      DM_RNW => open,
      DM_SELECT => open,
      DM_SEQADDR => open,
      DOPB_DBUS => net_gnd32,
      DOPB_ERRACK => net_gnd0,
      DOPB_MGRANT => net_gnd0,
      DOPB_RETRY => net_gnd0,
      DOPB_TIMEOUT => net_gnd0,
      DOPB_XFERACK => net_gnd0,
      DPLB_M_ABort => mb5_plb_bus_M_ABort(0),
      DPLB_M_ABus => mb5_plb_bus_M_ABus(0 to 31),
      DPLB_M_UABus => mb5_plb_bus_M_UABus(0 to 31),
      DPLB_M_BE => mb5_plb_bus_M_BE(0 to 3),
      DPLB_M_busLock => mb5_plb_bus_M_busLock(0),
      DPLB_M_lockErr => mb5_plb_bus_M_lockErr(0),
      DPLB_M_MSize => mb5_plb_bus_M_MSize(0 to 1),
      DPLB_M_priority => mb5_plb_bus_M_priority(0 to 1),
      DPLB_M_rdBurst => mb5_plb_bus_M_rdBurst(0),
      DPLB_M_request => mb5_plb_bus_M_request(0),
      DPLB_M_RNW => mb5_plb_bus_M_RNW(0),
      DPLB_M_size => mb5_plb_bus_M_size(0 to 3),
      DPLB_M_TAttribute => mb5_plb_bus_M_TAttribute(0 to 15),
      DPLB_M_type => mb5_plb_bus_M_type(0 to 2),
      DPLB_M_wrBurst => mb5_plb_bus_M_wrBurst(0),
      DPLB_M_wrDBus => mb5_plb_bus_M_wrDBus(0 to 31),
      DPLB_MBusy => mb5_plb_bus_PLB_MBusy(0),
      DPLB_MRdErr => mb5_plb_bus_PLB_MRdErr(0),
      DPLB_MWrErr => mb5_plb_bus_PLB_MWrErr(0),
      DPLB_MIRQ => mb5_plb_bus_PLB_MIRQ(0),
      DPLB_MWrBTerm => mb5_plb_bus_PLB_MWrBTerm(0),
      DPLB_MWrDAck => mb5_plb_bus_PLB_MWrDAck(0),
      DPLB_MAddrAck => mb5_plb_bus_PLB_MAddrAck(0),
      DPLB_MRdBTerm => mb5_plb_bus_PLB_MRdBTerm(0),
      DPLB_MRdDAck => mb5_plb_bus_PLB_MRdDAck(0),
      DPLB_MRdDBus => mb5_plb_bus_PLB_MRdDBus(0 to 31),
      DPLB_MRdWdAddr => mb5_plb_bus_PLB_MRdWdAddr(0 to 3),
      DPLB_MRearbitrate => mb5_plb_bus_PLB_MRearbitrate(0),
      DPLB_MSSize => mb5_plb_bus_PLB_MSSize(0 to 1),
      DPLB_MTimeout => mb5_plb_bus_PLB_MTimeout(0),
      IM_ABUS => open,
      IM_BE => open,
      IM_BUSLOCK => open,
      IM_DBUS => open,
      IM_REQUEST => open,
      IM_RNW => open,
      IM_SELECT => open,
      IM_SEQADDR => open,
      IOPB_DBUS => net_gnd32,
      IOPB_ERRACK => net_gnd0,
      IOPB_MGRANT => net_gnd0,
      IOPB_RETRY => net_gnd0,
      IOPB_TIMEOUT => net_gnd0,
      IOPB_XFERACK => net_gnd0,
      DBG_CLK => net_gnd0,
      DBG_TDI => net_gnd0,
      DBG_TDO => open,
      DBG_REG_EN => net_gnd5,
      DBG_SHIFT => net_gnd0,
      DBG_CAPTURE => net_gnd0,
      DBG_UPDATE => net_gnd0,
      DEBUG_RST => net_gnd0,
      Trace_Instruction => open,
      Trace_Valid_Instr => open,
      Trace_PC => open,
      Trace_Reg_Write => open,
      Trace_Reg_Addr => open,
      Trace_MSR_Reg => open,
      Trace_PID_Reg => open,
      Trace_New_Reg_Value => open,
      Trace_Exception_Taken => open,
      Trace_Exception_Kind => open,
      Trace_Jump_Taken => open,
      Trace_Delay_Slot => open,
      Trace_Data_Address => open,
      Trace_Data_Access => open,
      Trace_Data_Read => open,
      Trace_Data_Write => open,
      Trace_Data_Write_Value => open,
      Trace_Data_Byte_Enable => open,
      Trace_DCache_Req => open,
      Trace_DCache_Hit => open,
      Trace_ICache_Req => open,
      Trace_ICache_Hit => open,
      Trace_OF_PipeRun => open,
      Trace_EX_PipeRun => open,
      Trace_MEM_PipeRun => open,
      Trace_MB_Halted => open,
      FSL0_S_CLK => open,
      FSL0_S_READ => open,
      FSL0_S_DATA => net_gnd32,
      FSL0_S_CONTROL => net_gnd0,
      FSL0_S_EXISTS => net_gnd0,
      FSL0_M_CLK => open,
      FSL0_M_WRITE => open,
      FSL0_M_DATA => open,
      FSL0_M_CONTROL => open,
      FSL0_M_FULL => net_gnd0,
      FSL1_S_CLK => open,
      FSL1_S_READ => open,
      FSL1_S_DATA => net_gnd32,
      FSL1_S_CONTROL => net_gnd0,
      FSL1_S_EXISTS => net_gnd0,
      FSL1_M_CLK => open,
      FSL1_M_WRITE => open,
      FSL1_M_DATA => open,
      FSL1_M_CONTROL => open,
      FSL1_M_FULL => net_gnd0,
      FSL2_S_CLK => open,
      FSL2_S_READ => open,
      FSL2_S_DATA => net_gnd32,
      FSL2_S_CONTROL => net_gnd0,
      FSL2_S_EXISTS => net_gnd0,
      FSL2_M_CLK => open,
      FSL2_M_WRITE => open,
      FSL2_M_DATA => open,
      FSL2_M_CONTROL => open,
      FSL2_M_FULL => net_gnd0,
      FSL3_S_CLK => open,
      FSL3_S_READ => open,
      FSL3_S_DATA => net_gnd32,
      FSL3_S_CONTROL => net_gnd0,
      FSL3_S_EXISTS => net_gnd0,
      FSL3_M_CLK => open,
      FSL3_M_WRITE => open,
      FSL3_M_DATA => open,
      FSL3_M_CONTROL => open,
      FSL3_M_FULL => net_gnd0,
      FSL4_S_CLK => open,
      FSL4_S_READ => open,
      FSL4_S_DATA => net_gnd32,
      FSL4_S_CONTROL => net_gnd0,
      FSL4_S_EXISTS => net_gnd0,
      FSL4_M_CLK => open,
      FSL4_M_WRITE => open,
      FSL4_M_DATA => open,
      FSL4_M_CONTROL => open,
      FSL4_M_FULL => net_gnd0,
      FSL5_S_CLK => open,
      FSL5_S_READ => open,
      FSL5_S_DATA => net_gnd32,
      FSL5_S_CONTROL => net_gnd0,
      FSL5_S_EXISTS => net_gnd0,
      FSL5_M_CLK => open,
      FSL5_M_WRITE => open,
      FSL5_M_DATA => open,
      FSL5_M_CONTROL => open,
      FSL5_M_FULL => net_gnd0,
      FSL6_S_CLK => open,
      FSL6_S_READ => open,
      FSL6_S_DATA => net_gnd32,
      FSL6_S_CONTROL => net_gnd0,
      FSL6_S_EXISTS => net_gnd0,
      FSL6_M_CLK => open,
      FSL6_M_WRITE => open,
      FSL6_M_DATA => open,
      FSL6_M_CONTROL => open,
      FSL6_M_FULL => net_gnd0,
      FSL7_S_CLK => open,
      FSL7_S_READ => open,
      FSL7_S_DATA => net_gnd32,
      FSL7_S_CONTROL => net_gnd0,
      FSL7_S_EXISTS => net_gnd0,
      FSL7_M_CLK => open,
      FSL7_M_WRITE => open,
      FSL7_M_DATA => open,
      FSL7_M_CONTROL => open,
      FSL7_M_FULL => net_gnd0,
      FSL8_S_CLK => open,
      FSL8_S_READ => open,
      FSL8_S_DATA => net_gnd32,
      FSL8_S_CONTROL => net_gnd0,
      FSL8_S_EXISTS => net_gnd0,
      FSL8_M_CLK => open,
      FSL8_M_WRITE => open,
      FSL8_M_DATA => open,
      FSL8_M_CONTROL => open,
      FSL8_M_FULL => net_gnd0,
      FSL9_S_CLK => open,
      FSL9_S_READ => open,
      FSL9_S_DATA => net_gnd32,
      FSL9_S_CONTROL => net_gnd0,
      FSL9_S_EXISTS => net_gnd0,
      FSL9_M_CLK => open,
      FSL9_M_WRITE => open,
      FSL9_M_DATA => open,
      FSL9_M_CONTROL => open,
      FSL9_M_FULL => net_gnd0,
      FSL10_S_CLK => open,
      FSL10_S_READ => open,
      FSL10_S_DATA => net_gnd32,
      FSL10_S_CONTROL => net_gnd0,
      FSL10_S_EXISTS => net_gnd0,
      FSL10_M_CLK => open,
      FSL10_M_WRITE => open,
      FSL10_M_DATA => open,
      FSL10_M_CONTROL => open,
      FSL10_M_FULL => net_gnd0,
      FSL11_S_CLK => open,
      FSL11_S_READ => open,
      FSL11_S_DATA => net_gnd32,
      FSL11_S_CONTROL => net_gnd0,
      FSL11_S_EXISTS => net_gnd0,
      FSL11_M_CLK => open,
      FSL11_M_WRITE => open,
      FSL11_M_DATA => open,
      FSL11_M_CONTROL => open,
      FSL11_M_FULL => net_gnd0,
      FSL12_S_CLK => open,
      FSL12_S_READ => open,
      FSL12_S_DATA => net_gnd32,
      FSL12_S_CONTROL => net_gnd0,
      FSL12_S_EXISTS => net_gnd0,
      FSL12_M_CLK => open,
      FSL12_M_WRITE => open,
      FSL12_M_DATA => open,
      FSL12_M_CONTROL => open,
      FSL12_M_FULL => net_gnd0,
      FSL13_S_CLK => open,
      FSL13_S_READ => open,
      FSL13_S_DATA => net_gnd32,
      FSL13_S_CONTROL => net_gnd0,
      FSL13_S_EXISTS => net_gnd0,
      FSL13_M_CLK => open,
      FSL13_M_WRITE => open,
      FSL13_M_DATA => open,
      FSL13_M_CONTROL => open,
      FSL13_M_FULL => net_gnd0,
      FSL14_S_CLK => open,
      FSL14_S_READ => open,
      FSL14_S_DATA => net_gnd32,
      FSL14_S_CONTROL => net_gnd0,
      FSL14_S_EXISTS => net_gnd0,
      FSL14_M_CLK => open,
      FSL14_M_WRITE => open,
      FSL14_M_DATA => open,
      FSL14_M_CONTROL => open,
      FSL14_M_FULL => net_gnd0,
      FSL15_S_CLK => open,
      FSL15_S_READ => open,
      FSL15_S_DATA => net_gnd32,
      FSL15_S_CONTROL => net_gnd0,
      FSL15_S_EXISTS => net_gnd0,
      FSL15_M_CLK => open,
      FSL15_M_WRITE => open,
      FSL15_M_DATA => open,
      FSL15_M_CONTROL => open,
      FSL15_M_FULL => net_gnd0,
      ICACHE_FSL_IN_CLK => microblaze_mb5_IXCL_FSL_S_Clk,
      ICACHE_FSL_IN_READ => microblaze_mb5_IXCL_FSL_S_Read,
      ICACHE_FSL_IN_DATA => microblaze_mb5_IXCL_FSL_S_Data,
      ICACHE_FSL_IN_CONTROL => microblaze_mb5_IXCL_FSL_S_Control,
      ICACHE_FSL_IN_EXISTS => microblaze_mb5_IXCL_FSL_S_Exists,
      ICACHE_FSL_OUT_CLK => microblaze_mb5_IXCL_FSL_M_Clk,
      ICACHE_FSL_OUT_WRITE => microblaze_mb5_IXCL_FSL_M_Write,
      ICACHE_FSL_OUT_DATA => microblaze_mb5_IXCL_FSL_M_Data,
      ICACHE_FSL_OUT_CONTROL => microblaze_mb5_IXCL_FSL_M_Control,
      ICACHE_FSL_OUT_FULL => microblaze_mb5_IXCL_FSL_M_Full,
      DCACHE_FSL_IN_CLK => open,
      DCACHE_FSL_IN_READ => open,
      DCACHE_FSL_IN_DATA => net_gnd32,
      DCACHE_FSL_IN_CONTROL => net_gnd0,
      DCACHE_FSL_IN_EXISTS => net_gnd0,
      DCACHE_FSL_OUT_CLK => open,
      DCACHE_FSL_OUT_WRITE => open,
      DCACHE_FSL_OUT_DATA => open,
      DCACHE_FSL_OUT_CONTROL => open,
      DCACHE_FSL_OUT_FULL => net_gnd0
    );

  mb_ilmb_mb5 : mb_ilmb_mb5_wrapper
    port map (
      LMB_Clk => sys_clk_s,
      SYS_Rst => sys_bus_reset(0),
      LMB_Rst => mb_ilmb_mb5_OPB_Rst,
      M_ABus => mb_ilmb_mb5_M_ABus,
      M_ReadStrobe => mb_ilmb_mb5_M_ReadStrobe,
      M_WriteStrobe => net_gnd0,
      M_AddrStrobe => mb_ilmb_mb5_M_AddrStrobe,
      M_DBus => net_gnd32,
      M_BE => net_gnd4,
      Sl_DBus => mb_ilmb_mb5_Sl_DBus,
      Sl_Ready => mb_ilmb_mb5_Sl_Ready(0 to 0),
      LMB_ABus => mb_ilmb_mb5_LMB_ABus,
      LMB_ReadStrobe => mb_ilmb_mb5_LMB_ReadStrobe,
      LMB_WriteStrobe => mb_ilmb_mb5_LMB_WriteStrobe,
      LMB_AddrStrobe => mb_ilmb_mb5_LMB_AddrStrobe,
      LMB_ReadDBus => mb_ilmb_mb5_LMB_ReadDBus,
      LMB_WriteDBus => mb_ilmb_mb5_LMB_WriteDBus,
      LMB_Ready => mb_ilmb_mb5_LMB_Ready,
      LMB_BE => mb_ilmb_mb5_LMB_BE
    );

  mb_dlmb_mb5 : mb_dlmb_mb5_wrapper
    port map (
      LMB_Clk => sys_clk_s,
      SYS_Rst => sys_bus_reset(0),
      LMB_Rst => mb_dlmb_mb5_OPB_Rst,
      M_ABus => mb_dlmb_mb5_M_ABus,
      M_ReadStrobe => mb_dlmb_mb5_M_ReadStrobe,
      M_WriteStrobe => mb_dlmb_mb5_M_WriteStrobe,
      M_AddrStrobe => mb_dlmb_mb5_M_AddrStrobe,
      M_DBus => mb_dlmb_mb5_M_DBus,
      M_BE => mb_dlmb_mb5_M_BE,
      Sl_DBus => mb_dlmb_mb5_Sl_DBus,
      Sl_Ready => mb_dlmb_mb5_Sl_Ready(0 to 0),
      LMB_ABus => mb_dlmb_mb5_LMB_ABus,
      LMB_ReadStrobe => mb_dlmb_mb5_LMB_ReadStrobe,
      LMB_WriteStrobe => mb_dlmb_mb5_LMB_WriteStrobe,
      LMB_AddrStrobe => mb_dlmb_mb5_LMB_AddrStrobe,
      LMB_ReadDBus => mb_dlmb_mb5_LMB_ReadDBus,
      LMB_WriteDBus => mb_dlmb_mb5_LMB_WriteDBus,
      LMB_Ready => mb_dlmb_mb5_LMB_Ready,
      LMB_BE => mb_dlmb_mb5_LMB_BE
    );

  ilmb_cntlr_mb5 : ilmb_cntlr_mb5_wrapper
    port map (
      LMB_Clk => sys_clk_s,
      LMB_Rst => mb_ilmb_mb5_OPB_Rst,
      LMB_ABus => mb_ilmb_mb5_LMB_ABus,
      LMB_WriteDBus => mb_ilmb_mb5_LMB_WriteDBus,
      LMB_AddrStrobe => mb_ilmb_mb5_LMB_AddrStrobe,
      LMB_ReadStrobe => mb_ilmb_mb5_LMB_ReadStrobe,
      LMB_WriteStrobe => mb_ilmb_mb5_LMB_WriteStrobe,
      LMB_BE => mb_ilmb_mb5_LMB_BE,
      Sl_DBus => mb_ilmb_mb5_Sl_DBus,
      Sl_Ready => mb_ilmb_mb5_Sl_Ready(0),
      BRAM_Rst_A => ilmb_cntlr_BRAM_PORT_mb5_BRAM_Rst,
      BRAM_Clk_A => ilmb_cntlr_BRAM_PORT_mb5_BRAM_Clk,
      BRAM_EN_A => ilmb_cntlr_BRAM_PORT_mb5_BRAM_EN,
      BRAM_WEN_A => ilmb_cntlr_BRAM_PORT_mb5_BRAM_WEN,
      BRAM_Addr_A => ilmb_cntlr_BRAM_PORT_mb5_BRAM_Addr,
      BRAM_Din_A => ilmb_cntlr_BRAM_PORT_mb5_BRAM_Din,
      BRAM_Dout_A => ilmb_cntlr_BRAM_PORT_mb5_BRAM_Dout
    );

  dlmb_cntlr_mb5 : dlmb_cntlr_mb5_wrapper
    port map (
      LMB_Clk => sys_clk_s,
      LMB_Rst => mb_dlmb_mb5_OPB_Rst,
      LMB_ABus => mb_dlmb_mb5_LMB_ABus,
      LMB_WriteDBus => mb_dlmb_mb5_LMB_WriteDBus,
      LMB_AddrStrobe => mb_dlmb_mb5_LMB_AddrStrobe,
      LMB_ReadStrobe => mb_dlmb_mb5_LMB_ReadStrobe,
      LMB_WriteStrobe => mb_dlmb_mb5_LMB_WriteStrobe,
      LMB_BE => mb_dlmb_mb5_LMB_BE,
      Sl_DBus => mb_dlmb_mb5_Sl_DBus,
      Sl_Ready => mb_dlmb_mb5_Sl_Ready(0),
      BRAM_Rst_A => dlmb_cntlr_BRAM_PORT_mb5_BRAM_Rst,
      BRAM_Clk_A => dlmb_cntlr_BRAM_PORT_mb5_BRAM_Clk,
      BRAM_EN_A => dlmb_cntlr_BRAM_PORT_mb5_BRAM_EN,
      BRAM_WEN_A => dlmb_cntlr_BRAM_PORT_mb5_BRAM_WEN,
      BRAM_Addr_A => dlmb_cntlr_BRAM_PORT_mb5_BRAM_Addr,
      BRAM_Din_A => dlmb_cntlr_BRAM_PORT_mb5_BRAM_Din,
      BRAM_Dout_A => dlmb_cntlr_BRAM_PORT_mb5_BRAM_Dout
    );

  mb5_bram : mb5_bram_wrapper
    port map (
      BRAM_Rst_A => ilmb_cntlr_BRAM_PORT_mb5_BRAM_Rst,
      BRAM_Clk_A => ilmb_cntlr_BRAM_PORT_mb5_BRAM_Clk,
      BRAM_EN_A => ilmb_cntlr_BRAM_PORT_mb5_BRAM_EN,
      BRAM_WEN_A => ilmb_cntlr_BRAM_PORT_mb5_BRAM_WEN,
      BRAM_Addr_A => ilmb_cntlr_BRAM_PORT_mb5_BRAM_Addr,
      BRAM_Din_A => ilmb_cntlr_BRAM_PORT_mb5_BRAM_Din,
      BRAM_Dout_A => ilmb_cntlr_BRAM_PORT_mb5_BRAM_Dout,
      BRAM_Rst_B => dlmb_cntlr_BRAM_PORT_mb5_BRAM_Rst,
      BRAM_Clk_B => dlmb_cntlr_BRAM_PORT_mb5_BRAM_Clk,
      BRAM_EN_B => dlmb_cntlr_BRAM_PORT_mb5_BRAM_EN,
      BRAM_WEN_B => dlmb_cntlr_BRAM_PORT_mb5_BRAM_WEN,
      BRAM_Addr_B => dlmb_cntlr_BRAM_PORT_mb5_BRAM_Addr,
      BRAM_Din_B => dlmb_cntlr_BRAM_PORT_mb5_BRAM_Din,
      BRAM_Dout_B => dlmb_cntlr_BRAM_PORT_mb5_BRAM_Dout
    );

  mb5_plb_bus : mb5_plb_bus_wrapper
    port map (
      PLB_Clk => sys_clk_s,
      SYS_Rst => sys_bus_reset(0),
      PLB_Rst => open,
      SPLB_Rst => mb5_plb_bus_SPLB_Rst(0 to 0),
      MPLB_Rst => open,
      PLB_dcrAck => open,
      PLB_dcrDBus => open,
      DCR_ABus => net_gnd10,
      DCR_DBus => net_gnd32,
      DCR_Read => net_gnd0,
      DCR_Write => net_gnd0,
      M_ABus => mb5_plb_bus_M_ABus,
      M_UABus => mb5_plb_bus_M_UABus,
      M_BE => mb5_plb_bus_M_BE,
      M_RNW => mb5_plb_bus_M_RNW,
      M_abort => mb5_plb_bus_M_ABort,
      M_busLock => mb5_plb_bus_M_busLock,
      M_TAttribute => mb5_plb_bus_M_TAttribute,
      M_lockErr => mb5_plb_bus_M_lockErr,
      M_MSize => mb5_plb_bus_M_MSize,
      M_priority => mb5_plb_bus_M_priority,
      M_rdBurst => mb5_plb_bus_M_rdBurst,
      M_request => mb5_plb_bus_M_request,
      M_size => mb5_plb_bus_M_size,
      M_type => mb5_plb_bus_M_type,
      M_wrBurst => mb5_plb_bus_M_wrBurst,
      M_wrDBus => mb5_plb_bus_M_wrDBus,
      Sl_addrAck => mb5_plb_bus_Sl_addrAck(0 to 0),
      Sl_MRdErr => mb5_plb_bus_Sl_MRdErr,
      Sl_MWrErr => mb5_plb_bus_Sl_MWrErr,
      Sl_MBusy => mb5_plb_bus_Sl_MBusy,
      Sl_rdBTerm => mb5_plb_bus_Sl_rdBTerm(0 to 0),
      Sl_rdComp => mb5_plb_bus_Sl_rdComp(0 to 0),
      Sl_rdDAck => mb5_plb_bus_Sl_rdDAck(0 to 0),
      Sl_rdDBus => mb5_plb_bus_Sl_rdDBus,
      Sl_rdWdAddr => mb5_plb_bus_Sl_rdWdAddr,
      Sl_rearbitrate => mb5_plb_bus_Sl_rearbitrate(0 to 0),
      Sl_SSize => mb5_plb_bus_Sl_SSize,
      Sl_wait => mb5_plb_bus_Sl_wait(0 to 0),
      Sl_wrBTerm => mb5_plb_bus_Sl_wrBTerm(0 to 0),
      Sl_wrComp => mb5_plb_bus_Sl_wrComp(0 to 0),
      Sl_wrDAck => mb5_plb_bus_Sl_wrDAck(0 to 0),
      Sl_MIRQ => mb5_plb_bus_Sl_MIRQ,
      PLB_MIRQ => mb5_plb_bus_PLB_MIRQ,
      PLB_ABus => mb5_plb_bus_PLB_ABus,
      PLB_UABus => mb5_plb_bus_PLB_UABus,
      PLB_BE => mb5_plb_bus_PLB_BE,
      PLB_MAddrAck => mb5_plb_bus_PLB_MAddrAck,
      PLB_MTimeout => mb5_plb_bus_PLB_MTimeout,
      PLB_MBusy => mb5_plb_bus_PLB_MBusy,
      PLB_MRdErr => mb5_plb_bus_PLB_MRdErr,
      PLB_MWrErr => mb5_plb_bus_PLB_MWrErr,
      PLB_MRdBTerm => mb5_plb_bus_PLB_MRdBTerm,
      PLB_MRdDAck => mb5_plb_bus_PLB_MRdDAck,
      PLB_MRdDBus => mb5_plb_bus_PLB_MRdDBus,
      PLB_MRdWdAddr => mb5_plb_bus_PLB_MRdWdAddr,
      PLB_MRearbitrate => mb5_plb_bus_PLB_MRearbitrate,
      PLB_MWrBTerm => mb5_plb_bus_PLB_MWrBTerm,
      PLB_MWrDAck => mb5_plb_bus_PLB_MWrDAck,
      PLB_MSSize => mb5_plb_bus_PLB_MSSize,
      PLB_PAValid => mb5_plb_bus_PLB_PAValid,
      PLB_RNW => mb5_plb_bus_PLB_RNW,
      PLB_SAValid => mb5_plb_bus_PLB_SAValid,
      PLB_abort => mb5_plb_bus_PLB_abort,
      PLB_busLock => mb5_plb_bus_PLB_busLock,
      PLB_TAttribute => mb5_plb_bus_PLB_TAttribute,
      PLB_lockErr => mb5_plb_bus_PLB_lockErr,
      PLB_masterID => mb5_plb_bus_PLB_masterID(0 to 0),
      PLB_MSize => mb5_plb_bus_PLB_MSize,
      PLB_rdPendPri => mb5_plb_bus_PLB_rdPendPri,
      PLB_wrPendPri => mb5_plb_bus_PLB_wrPendPri,
      PLB_rdPendReq => mb5_plb_bus_PLB_rdPendReq,
      PLB_wrPendReq => mb5_plb_bus_PLB_wrPendReq,
      PLB_rdBurst => mb5_plb_bus_PLB_rdBurst,
      PLB_rdPrim => mb5_plb_bus_PLB_rdPrim(0 to 0),
      PLB_reqPri => mb5_plb_bus_PLB_reqPri,
      PLB_size => mb5_plb_bus_PLB_size,
      PLB_type => mb5_plb_bus_PLB_type,
      PLB_wrBurst => mb5_plb_bus_PLB_wrBurst,
      PLB_wrDBus => mb5_plb_bus_PLB_wrDBus,
      PLB_wrPrim => mb5_plb_bus_PLB_wrPrim(0 to 0),
      PLB_SaddrAck => open,
      PLB_SMRdErr => open,
      PLB_SMWrErr => open,
      PLB_SMBusy => open,
      PLB_SrdBTerm => open,
      PLB_SrdComp => open,
      PLB_SrdDAck => open,
      PLB_SrdDBus => open,
      PLB_SrdWdAddr => open,
      PLB_Srearbitrate => open,
      PLB_Sssize => open,
      PLB_Swait => open,
      PLB_SwrBTerm => open,
      PLB_SwrComp => open,
      PLB_SwrDAck => open,
      Bus_Error_Det => open
    );

  mb5_plb_bridge : mb5_plb_bridge_wrapper
    port map (
      SPLB_Clk => sys_clk_s,
      SPLB_Rst => mb5_plb_bus_SPLB_Rst(0),
      IP2INTC_Irpt => open,
      PLB_ABus => mb5_plb_bus_PLB_ABus,
      PLB_UABus => mb5_plb_bus_PLB_UABus,
      PLB_PAValid => mb5_plb_bus_PLB_PAValid,
      PLB_SAValid => mb5_plb_bus_PLB_SAValid,
      PLB_rdPrim => mb5_plb_bus_PLB_rdPrim(0),
      PLB_wrPrim => mb5_plb_bus_PLB_wrPrim(0),
      PLB_masterID => mb5_plb_bus_PLB_masterID(0 to 0),
      PLB_abort => mb5_plb_bus_PLB_abort,
      PLB_busLock => mb5_plb_bus_PLB_busLock,
      PLB_RNW => mb5_plb_bus_PLB_RNW,
      PLB_BE => mb5_plb_bus_PLB_BE,
      PLB_MSize => mb5_plb_bus_PLB_MSize,
      PLB_size => mb5_plb_bus_PLB_size,
      PLB_type => mb5_plb_bus_PLB_type,
      PLB_lockErr => mb5_plb_bus_PLB_lockErr,
      PLB_wrDBus => mb5_plb_bus_PLB_wrDBus,
      PLB_wrBurst => mb5_plb_bus_PLB_wrBurst,
      PLB_rdBurst => mb5_plb_bus_PLB_rdBurst,
      PLB_wrPendReq => mb5_plb_bus_PLB_wrPendReq,
      PLB_rdPendReq => mb5_plb_bus_PLB_rdPendReq,
      PLB_wrPendPri => mb5_plb_bus_PLB_wrPendPri,
      PLB_rdPendPri => mb5_plb_bus_PLB_rdPendPri,
      PLB_reqPri => mb5_plb_bus_PLB_reqPri,
      PLB_TAttribute => mb5_plb_bus_PLB_TAttribute,
      Sl_addrAck => mb5_plb_bus_Sl_addrAck(0),
      Sl_SSize => mb5_plb_bus_Sl_SSize,
      Sl_wait => mb5_plb_bus_Sl_wait(0),
      Sl_rearbitrate => mb5_plb_bus_Sl_rearbitrate(0),
      Sl_wrDAck => mb5_plb_bus_Sl_wrDAck(0),
      Sl_wrComp => mb5_plb_bus_Sl_wrComp(0),
      Sl_wrBTerm => mb5_plb_bus_Sl_wrBTerm(0),
      Sl_rdDBus => mb5_plb_bus_Sl_rdDBus,
      Sl_rdWdAddr => mb5_plb_bus_Sl_rdWdAddr,
      Sl_rdDAck => mb5_plb_bus_Sl_rdDAck(0),
      Sl_rdComp => mb5_plb_bus_Sl_rdComp(0),
      Sl_rdBTerm => mb5_plb_bus_Sl_rdBTerm(0),
      Sl_MBusy => mb5_plb_bus_Sl_MBusy,
      Sl_MWrErr => mb5_plb_bus_Sl_MWrErr,
      Sl_MRdErr => mb5_plb_bus_Sl_MRdErr,
      Sl_MIRQ => mb5_plb_bus_Sl_MIRQ,
      MPLB_Clk => sys_clk_s,
      MPLB_Rst => plb_v46_0_MPLB_Rst(7),
      M_request => plb_v46_0_M_request(7),
      M_priority => plb_v46_0_M_priority(14 to 15),
      M_busLock => plb_v46_0_M_busLock(7),
      M_RNW => plb_v46_0_M_RNW(7),
      M_BE => plb_v46_0_M_BE(112 to 127),
      M_MSize => plb_v46_0_M_MSize(14 to 15),
      M_size => plb_v46_0_M_size(28 to 31),
      M_type => plb_v46_0_M_type(21 to 23),
      M_ABus => plb_v46_0_M_ABus(224 to 255),
      M_wrBurst => plb_v46_0_M_wrBurst(7),
      M_rdBurst => plb_v46_0_M_rdBurst(7),
      M_wrDBus => plb_v46_0_M_wrDBus(896 to 1023),
      PLB_MAddrAck => plb_v46_0_PLB_MAddrAck(7),
      PLB_MSSize => plb_v46_0_PLB_MSSize(14 to 15),
      PLB_MRearbitrate => plb_v46_0_PLB_MRearbitrate(7),
      PLB_MTimeout => plb_v46_0_PLB_MTimeout(7),
      PLB_MRdErr => plb_v46_0_PLB_MRdErr(7),
      PLB_MWrErr => plb_v46_0_PLB_MWrErr(7),
      PLB_MRdDBus => plb_v46_0_PLB_MRdDBus(896 to 1023),
      PLB_MRdDAck => plb_v46_0_PLB_MRdDAck(7),
      PLB_MRdBTerm => plb_v46_0_PLB_MRdBTerm(7),
      PLB_MWrDAck => plb_v46_0_PLB_MWrDAck(7),
      PLB_MWrBTerm => plb_v46_0_PLB_MWrBTerm(7),
      M_TAttribute => plb_v46_0_M_TAttribute(112 to 127),
      M_lockErr => plb_v46_0_M_lockErr(7),
      M_abort => plb_v46_0_M_abort(7),
      M_UABus => plb_v46_0_M_UABus(224 to 255),
      PLB_MBusy => plb_v46_0_PLB_MBusy(7),
      PLB_MIRQ => plb_v46_0_PLB_MIRQ(7),
      PLB_MRdWdAddr => plb_v46_0_PLB_MRdWdAddr(28 to 31)
    );

  iobuf_0 : IOBUF
    port map (
      I => fpga_0_LEDs_8Bit_GPIO_IO_O(0),
      IO => fpga_0_LEDs_8Bit_GPIO_IO_pin(0),
      O => fpga_0_LEDs_8Bit_GPIO_IO_I(0),
      T => fpga_0_LEDs_8Bit_GPIO_IO_T(0)
    );

  iobuf_1 : IOBUF
    port map (
      I => fpga_0_LEDs_8Bit_GPIO_IO_O(1),
      IO => fpga_0_LEDs_8Bit_GPIO_IO_pin(1),
      O => fpga_0_LEDs_8Bit_GPIO_IO_I(1),
      T => fpga_0_LEDs_8Bit_GPIO_IO_T(1)
    );

  iobuf_2 : IOBUF
    port map (
      I => fpga_0_LEDs_8Bit_GPIO_IO_O(2),
      IO => fpga_0_LEDs_8Bit_GPIO_IO_pin(2),
      O => fpga_0_LEDs_8Bit_GPIO_IO_I(2),
      T => fpga_0_LEDs_8Bit_GPIO_IO_T(2)
    );

  iobuf_3 : IOBUF
    port map (
      I => fpga_0_LEDs_8Bit_GPIO_IO_O(3),
      IO => fpga_0_LEDs_8Bit_GPIO_IO_pin(3),
      O => fpga_0_LEDs_8Bit_GPIO_IO_I(3),
      T => fpga_0_LEDs_8Bit_GPIO_IO_T(3)
    );

  iobuf_4 : IOBUF
    port map (
      I => fpga_0_LEDs_8Bit_GPIO_IO_O(4),
      IO => fpga_0_LEDs_8Bit_GPIO_IO_pin(4),
      O => fpga_0_LEDs_8Bit_GPIO_IO_I(4),
      T => fpga_0_LEDs_8Bit_GPIO_IO_T(4)
    );

  iobuf_5 : IOBUF
    port map (
      I => fpga_0_LEDs_8Bit_GPIO_IO_O(5),
      IO => fpga_0_LEDs_8Bit_GPIO_IO_pin(5),
      O => fpga_0_LEDs_8Bit_GPIO_IO_I(5),
      T => fpga_0_LEDs_8Bit_GPIO_IO_T(5)
    );

  iobuf_6 : IOBUF
    port map (
      I => fpga_0_LEDs_8Bit_GPIO_IO_O(6),
      IO => fpga_0_LEDs_8Bit_GPIO_IO_pin(6),
      O => fpga_0_LEDs_8Bit_GPIO_IO_I(6),
      T => fpga_0_LEDs_8Bit_GPIO_IO_T(6)
    );

  iobuf_7 : IOBUF
    port map (
      I => fpga_0_LEDs_8Bit_GPIO_IO_O(7),
      IO => fpga_0_LEDs_8Bit_GPIO_IO_pin(7),
      O => fpga_0_LEDs_8Bit_GPIO_IO_I(7),
      T => fpga_0_LEDs_8Bit_GPIO_IO_T(7)
    );

  iobuf_8 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(0),
      IO => fpga_0_SRAM_Mem_DQ_pin(0),
      O => fpga_0_SRAM_Mem_DQ_I(0),
      T => fpga_0_SRAM_Mem_DQ_T(0)
    );

  iobuf_9 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(1),
      IO => fpga_0_SRAM_Mem_DQ_pin(1),
      O => fpga_0_SRAM_Mem_DQ_I(1),
      T => fpga_0_SRAM_Mem_DQ_T(1)
    );

  iobuf_10 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(2),
      IO => fpga_0_SRAM_Mem_DQ_pin(2),
      O => fpga_0_SRAM_Mem_DQ_I(2),
      T => fpga_0_SRAM_Mem_DQ_T(2)
    );

  iobuf_11 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(3),
      IO => fpga_0_SRAM_Mem_DQ_pin(3),
      O => fpga_0_SRAM_Mem_DQ_I(3),
      T => fpga_0_SRAM_Mem_DQ_T(3)
    );

  iobuf_12 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(4),
      IO => fpga_0_SRAM_Mem_DQ_pin(4),
      O => fpga_0_SRAM_Mem_DQ_I(4),
      T => fpga_0_SRAM_Mem_DQ_T(4)
    );

  iobuf_13 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(5),
      IO => fpga_0_SRAM_Mem_DQ_pin(5),
      O => fpga_0_SRAM_Mem_DQ_I(5),
      T => fpga_0_SRAM_Mem_DQ_T(5)
    );

  iobuf_14 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(6),
      IO => fpga_0_SRAM_Mem_DQ_pin(6),
      O => fpga_0_SRAM_Mem_DQ_I(6),
      T => fpga_0_SRAM_Mem_DQ_T(6)
    );

  iobuf_15 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(7),
      IO => fpga_0_SRAM_Mem_DQ_pin(7),
      O => fpga_0_SRAM_Mem_DQ_I(7),
      T => fpga_0_SRAM_Mem_DQ_T(7)
    );

  iobuf_16 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(8),
      IO => fpga_0_SRAM_Mem_DQ_pin(8),
      O => fpga_0_SRAM_Mem_DQ_I(8),
      T => fpga_0_SRAM_Mem_DQ_T(8)
    );

  iobuf_17 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(9),
      IO => fpga_0_SRAM_Mem_DQ_pin(9),
      O => fpga_0_SRAM_Mem_DQ_I(9),
      T => fpga_0_SRAM_Mem_DQ_T(9)
    );

  iobuf_18 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(10),
      IO => fpga_0_SRAM_Mem_DQ_pin(10),
      O => fpga_0_SRAM_Mem_DQ_I(10),
      T => fpga_0_SRAM_Mem_DQ_T(10)
    );

  iobuf_19 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(11),
      IO => fpga_0_SRAM_Mem_DQ_pin(11),
      O => fpga_0_SRAM_Mem_DQ_I(11),
      T => fpga_0_SRAM_Mem_DQ_T(11)
    );

  iobuf_20 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(12),
      IO => fpga_0_SRAM_Mem_DQ_pin(12),
      O => fpga_0_SRAM_Mem_DQ_I(12),
      T => fpga_0_SRAM_Mem_DQ_T(12)
    );

  iobuf_21 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(13),
      IO => fpga_0_SRAM_Mem_DQ_pin(13),
      O => fpga_0_SRAM_Mem_DQ_I(13),
      T => fpga_0_SRAM_Mem_DQ_T(13)
    );

  iobuf_22 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(14),
      IO => fpga_0_SRAM_Mem_DQ_pin(14),
      O => fpga_0_SRAM_Mem_DQ_I(14),
      T => fpga_0_SRAM_Mem_DQ_T(14)
    );

  iobuf_23 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(15),
      IO => fpga_0_SRAM_Mem_DQ_pin(15),
      O => fpga_0_SRAM_Mem_DQ_I(15),
      T => fpga_0_SRAM_Mem_DQ_T(15)
    );

  iobuf_24 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(16),
      IO => fpga_0_SRAM_Mem_DQ_pin(16),
      O => fpga_0_SRAM_Mem_DQ_I(16),
      T => fpga_0_SRAM_Mem_DQ_T(16)
    );

  iobuf_25 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(17),
      IO => fpga_0_SRAM_Mem_DQ_pin(17),
      O => fpga_0_SRAM_Mem_DQ_I(17),
      T => fpga_0_SRAM_Mem_DQ_T(17)
    );

  iobuf_26 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(18),
      IO => fpga_0_SRAM_Mem_DQ_pin(18),
      O => fpga_0_SRAM_Mem_DQ_I(18),
      T => fpga_0_SRAM_Mem_DQ_T(18)
    );

  iobuf_27 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(19),
      IO => fpga_0_SRAM_Mem_DQ_pin(19),
      O => fpga_0_SRAM_Mem_DQ_I(19),
      T => fpga_0_SRAM_Mem_DQ_T(19)
    );

  iobuf_28 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(20),
      IO => fpga_0_SRAM_Mem_DQ_pin(20),
      O => fpga_0_SRAM_Mem_DQ_I(20),
      T => fpga_0_SRAM_Mem_DQ_T(20)
    );

  iobuf_29 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(21),
      IO => fpga_0_SRAM_Mem_DQ_pin(21),
      O => fpga_0_SRAM_Mem_DQ_I(21),
      T => fpga_0_SRAM_Mem_DQ_T(21)
    );

  iobuf_30 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(22),
      IO => fpga_0_SRAM_Mem_DQ_pin(22),
      O => fpga_0_SRAM_Mem_DQ_I(22),
      T => fpga_0_SRAM_Mem_DQ_T(22)
    );

  iobuf_31 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(23),
      IO => fpga_0_SRAM_Mem_DQ_pin(23),
      O => fpga_0_SRAM_Mem_DQ_I(23),
      T => fpga_0_SRAM_Mem_DQ_T(23)
    );

  iobuf_32 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(24),
      IO => fpga_0_SRAM_Mem_DQ_pin(24),
      O => fpga_0_SRAM_Mem_DQ_I(24),
      T => fpga_0_SRAM_Mem_DQ_T(24)
    );

  iobuf_33 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(25),
      IO => fpga_0_SRAM_Mem_DQ_pin(25),
      O => fpga_0_SRAM_Mem_DQ_I(25),
      T => fpga_0_SRAM_Mem_DQ_T(25)
    );

  iobuf_34 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(26),
      IO => fpga_0_SRAM_Mem_DQ_pin(26),
      O => fpga_0_SRAM_Mem_DQ_I(26),
      T => fpga_0_SRAM_Mem_DQ_T(26)
    );

  iobuf_35 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(27),
      IO => fpga_0_SRAM_Mem_DQ_pin(27),
      O => fpga_0_SRAM_Mem_DQ_I(27),
      T => fpga_0_SRAM_Mem_DQ_T(27)
    );

  iobuf_36 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(28),
      IO => fpga_0_SRAM_Mem_DQ_pin(28),
      O => fpga_0_SRAM_Mem_DQ_I(28),
      T => fpga_0_SRAM_Mem_DQ_T(28)
    );

  iobuf_37 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(29),
      IO => fpga_0_SRAM_Mem_DQ_pin(29),
      O => fpga_0_SRAM_Mem_DQ_I(29),
      T => fpga_0_SRAM_Mem_DQ_T(29)
    );

  iobuf_38 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(30),
      IO => fpga_0_SRAM_Mem_DQ_pin(30),
      O => fpga_0_SRAM_Mem_DQ_I(30),
      T => fpga_0_SRAM_Mem_DQ_T(30)
    );

  iobuf_39 : IOBUF
    port map (
      I => fpga_0_SRAM_Mem_DQ_O(31),
      IO => fpga_0_SRAM_Mem_DQ_pin(31),
      O => fpga_0_SRAM_Mem_DQ_I(31),
      T => fpga_0_SRAM_Mem_DQ_T(31)
    );

end architecture STRUCTURE;

