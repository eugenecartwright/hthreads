#  Simulation Model Generator
#  Xilinx EDK 9.1.02 EDK_J_SP2.4
#  Copyright (c) 1995-2007 Xilinx, Inc.  All rights reserved.
#
#  File     my_core_wave.do (Wed Apr 09 16:49:13 2008)
#
#  Module   my_core_wrapper
#  Instance my_core
#  Because EDK did not create the testbench, the user
#  specifies the path to the device under test, $tbpath.
#
set binopt {-logic}
set hexopt {-literal -hex}
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}bfm_system" }

  eval add wave -noupdate -divider {"my_core"}
# eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}PLB_Clk
# eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}PLB_Rst
  eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}Sl_addrAck
  eval add wave -noupdate $hexopt $tbpath${ps}my_core${ps}Sl_MBusy
  eval add wave -noupdate $hexopt $tbpath${ps}my_core${ps}Sl_MErr
  eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}Sl_rdBTerm
  eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}Sl_rdComp
  eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}Sl_rdDAck
  eval add wave -noupdate $hexopt $tbpath${ps}my_core${ps}Sl_rdDBus
  eval add wave -noupdate $hexopt $tbpath${ps}my_core${ps}Sl_rdWdAddr
  eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}Sl_rearbitrate
  eval add wave -noupdate $hexopt $tbpath${ps}my_core${ps}Sl_SSize
  eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}Sl_wait
  eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}Sl_wrBTerm
  eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}Sl_wrComp
  eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}Sl_wrDAck
# eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}PLB_abort
# eval add wave -noupdate $hexopt $tbpath${ps}my_core${ps}PLB_ABus
# eval add wave -noupdate $hexopt $tbpath${ps}my_core${ps}PLB_BE
# eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}PLB_busLock
# eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}PLB_compress
# eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}PLB_guarded
# eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}PLB_lockErr
# eval add wave -noupdate $hexopt $tbpath${ps}my_core${ps}PLB_masterID
# eval add wave -noupdate $hexopt $tbpath${ps}my_core${ps}PLB_MSize
# eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}PLB_ordered
# eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}PLB_PAValid
# eval add wave -noupdate $hexopt $tbpath${ps}my_core${ps}PLB_pendPri
# eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}PLB_pendReq
# eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}PLB_rdBurst
# eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}PLB_rdPrim
# eval add wave -noupdate $hexopt $tbpath${ps}my_core${ps}PLB_reqPri
# eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}PLB_RNW
# eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}PLB_SAValid
# eval add wave -noupdate $hexopt $tbpath${ps}my_core${ps}PLB_size
# eval add wave -noupdate $hexopt $tbpath${ps}my_core${ps}PLB_type
# eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}PLB_wrBurst
# eval add wave -noupdate $hexopt $tbpath${ps}my_core${ps}PLB_wrDBus
# eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}PLB_wrPrim
  eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}M_abort
  eval add wave -noupdate $hexopt $tbpath${ps}my_core${ps}M_ABus
  eval add wave -noupdate $hexopt $tbpath${ps}my_core${ps}M_BE
  eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}M_busLock
  eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}M_compress
  eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}M_guarded
  eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}M_lockErr
  eval add wave -noupdate $hexopt $tbpath${ps}my_core${ps}M_MSize
  eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}M_ordered
  eval add wave -noupdate $hexopt $tbpath${ps}my_core${ps}M_priority
  eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}M_rdBurst
  eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}M_request
  eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}M_RNW
  eval add wave -noupdate $hexopt $tbpath${ps}my_core${ps}M_size
  eval add wave -noupdate $hexopt $tbpath${ps}my_core${ps}M_type
  eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}M_wrBurst
  eval add wave -noupdate $hexopt $tbpath${ps}my_core${ps}M_wrDBus
# eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}PLB_MBusy
# eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}PLB_MErr
# eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}PLB_MWrBTerm
# eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}PLB_MWrDAck
# eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}PLB_MAddrAck
# eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}PLB_MRdBTerm
# eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}PLB_MRdDAck
# eval add wave -noupdate $hexopt $tbpath${ps}my_core${ps}PLB_MRdDBus
# eval add wave -noupdate $hexopt $tbpath${ps}my_core${ps}PLB_MRdWdAddr
# eval add wave -noupdate $binopt $tbpath${ps}my_core${ps}PLB_MRearbitrate
# eval add wave -noupdate $hexopt $tbpath${ps}my_core${ps}PLB_MSSize
  eval add wave -noupdate $hexopt $tbpath${ps}my_core${ps}SYNCH_IN
  eval add wave -noupdate $hexopt $tbpath${ps}my_core${ps}SYNCH_OUT

