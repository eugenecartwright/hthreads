#  Simulation Model Generator
#  Xilinx EDK 10.1.03 EDK_K_SP3.6
#  Copyright (c) 1995-2008 Xilinx, Inc.  All rights reserved.
#
#  File     my_core_list.do (Mon Apr  6 16:25:57 2009)
#
#  Module   my_core_wrapper
#  Instance my_core
#  Because EDK did not create the testbench, the user
#  specifies the path to the device under test, $tbpath.
#
set binopt {-bin}
set hexopt {-hex}
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}bfm_system" }

# eval add list $binopt $tbpath${ps}my_core${ps}SPLB_Clk
# eval add list $binopt $tbpath${ps}my_core${ps}SPLB_Rst
# eval add list $hexopt $tbpath${ps}my_core${ps}PLB_ABus
# eval add list $hexopt $tbpath${ps}my_core${ps}PLB_UABus
# eval add list $binopt $tbpath${ps}my_core${ps}PLB_PAValid
# eval add list $binopt $tbpath${ps}my_core${ps}PLB_SAValid
# eval add list $binopt $tbpath${ps}my_core${ps}PLB_rdPrim
# eval add list $binopt $tbpath${ps}my_core${ps}PLB_wrPrim
# eval add list $binopt $tbpath${ps}my_core${ps}PLB_masterID
# eval add list $binopt $tbpath${ps}my_core${ps}PLB_abort
# eval add list $binopt $tbpath${ps}my_core${ps}PLB_busLock
# eval add list $binopt $tbpath${ps}my_core${ps}PLB_RNW
# eval add list $hexopt $tbpath${ps}my_core${ps}PLB_BE
# eval add list $hexopt $tbpath${ps}my_core${ps}PLB_MSize
# eval add list $hexopt $tbpath${ps}my_core${ps}PLB_size
# eval add list $hexopt $tbpath${ps}my_core${ps}PLB_type
# eval add list $binopt $tbpath${ps}my_core${ps}PLB_lockErr
# eval add list $hexopt $tbpath${ps}my_core${ps}PLB_wrDBus
# eval add list $binopt $tbpath${ps}my_core${ps}PLB_wrBurst
# eval add list $binopt $tbpath${ps}my_core${ps}PLB_rdBurst
# eval add list $binopt $tbpath${ps}my_core${ps}PLB_wrPendReq
# eval add list $binopt $tbpath${ps}my_core${ps}PLB_rdPendReq
# eval add list $hexopt $tbpath${ps}my_core${ps}PLB_wrPendPri
# eval add list $hexopt $tbpath${ps}my_core${ps}PLB_rdPendPri
# eval add list $hexopt $tbpath${ps}my_core${ps}PLB_reqPri
# eval add list $hexopt $tbpath${ps}my_core${ps}PLB_TAttribute
  eval add list $binopt $tbpath${ps}my_core${ps}Sl_addrAck
  eval add list $hexopt $tbpath${ps}my_core${ps}Sl_SSize
  eval add list $binopt $tbpath${ps}my_core${ps}Sl_wait
  eval add list $binopt $tbpath${ps}my_core${ps}Sl_rearbitrate
  eval add list $binopt $tbpath${ps}my_core${ps}Sl_wrDAck
  eval add list $binopt $tbpath${ps}my_core${ps}Sl_wrComp
  eval add list $binopt $tbpath${ps}my_core${ps}Sl_wrBTerm
  eval add list $hexopt $tbpath${ps}my_core${ps}Sl_rdDBus
  eval add list $hexopt $tbpath${ps}my_core${ps}Sl_rdWdAddr
  eval add list $binopt $tbpath${ps}my_core${ps}Sl_rdDAck
  eval add list $binopt $tbpath${ps}my_core${ps}Sl_rdComp
  eval add list $binopt $tbpath${ps}my_core${ps}Sl_rdBTerm
  eval add list $hexopt $tbpath${ps}my_core${ps}Sl_MBusy
  eval add list $hexopt $tbpath${ps}my_core${ps}Sl_MWrErr
  eval add list $hexopt $tbpath${ps}my_core${ps}Sl_MRdErr
  eval add list $hexopt $tbpath${ps}my_core${ps}Sl_MIRQ
# eval add list $binopt $tbpath${ps}my_core${ps}MPLB_Clk
# eval add list $binopt $tbpath${ps}my_core${ps}MPLB_Rst
  eval add list $binopt $tbpath${ps}my_core${ps}M_request
  eval add list $hexopt $tbpath${ps}my_core${ps}M_priority
  eval add list $binopt $tbpath${ps}my_core${ps}M_busLock
  eval add list $binopt $tbpath${ps}my_core${ps}M_RNW
  eval add list $hexopt $tbpath${ps}my_core${ps}M_BE
  eval add list $hexopt $tbpath${ps}my_core${ps}M_MSize
  eval add list $hexopt $tbpath${ps}my_core${ps}M_size
  eval add list $hexopt $tbpath${ps}my_core${ps}M_type
  eval add list $hexopt $tbpath${ps}my_core${ps}M_TAttribute
  eval add list $binopt $tbpath${ps}my_core${ps}M_lockErr
  eval add list $binopt $tbpath${ps}my_core${ps}M_abort
  eval add list $hexopt $tbpath${ps}my_core${ps}M_UABus
  eval add list $hexopt $tbpath${ps}my_core${ps}M_ABus
  eval add list $hexopt $tbpath${ps}my_core${ps}M_wrDBus
  eval add list $binopt $tbpath${ps}my_core${ps}M_wrBurst
  eval add list $binopt $tbpath${ps}my_core${ps}M_rdBurst
# eval add list $binopt $tbpath${ps}my_core${ps}PLB_MAddrAck
# eval add list $hexopt $tbpath${ps}my_core${ps}PLB_MSSize
# eval add list $binopt $tbpath${ps}my_core${ps}PLB_MRearbitrate
# eval add list $binopt $tbpath${ps}my_core${ps}PLB_MTimeout
# eval add list $binopt $tbpath${ps}my_core${ps}PLB_MBusy
# eval add list $binopt $tbpath${ps}my_core${ps}PLB_MRdErr
# eval add list $binopt $tbpath${ps}my_core${ps}PLB_MWrErr
# eval add list $binopt $tbpath${ps}my_core${ps}PLB_MIRQ
# eval add list $hexopt $tbpath${ps}my_core${ps}PLB_MRdDBus
# eval add list $hexopt $tbpath${ps}my_core${ps}PLB_MRdWdAddr
# eval add list $binopt $tbpath${ps}my_core${ps}PLB_MRdDAck
# eval add list $binopt $tbpath${ps}my_core${ps}PLB_MRdBTerm
# eval add list $binopt $tbpath${ps}my_core${ps}PLB_MWrDAck
# eval add list $binopt $tbpath${ps}my_core${ps}PLB_MWrBTerm
  eval add list $hexopt $tbpath${ps}my_core${ps}SYNCH_IN
  eval add list $hexopt $tbpath${ps}my_core${ps}SYNCH_OUT

