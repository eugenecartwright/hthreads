#  Simulation Model Generator
#  Xilinx EDK 9.1.02 EDK_J_SP2.4
#  Copyright (c) 1995-2007 Xilinx, Inc.  All rights reserved.
#
#  File     plb2opb_wave.do (Wed Apr 09 16:49:12 2008)
#
#  Module   plb2opb_wrapper
#  Instance plb2opb
#  Because EDK did not create the testbench, the user
#  specifies the path to the device under test, $tbpath.
#
set binopt {-logic}
set hexopt {-literal -hex}
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}bfm_system" }

  eval add wave -noupdate -divider {"plb2opb"}
# eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}PLB_Clk
# eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}OPB_Clk
# eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}PLB_Rst
# eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}OPB_Rst
# eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}Bus_Error_Det
  eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}BGI_Trans_Abort
# eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}BGO_dcrAck
# eval add wave -noupdate $hexopt $tbpath${ps}plb2opb${ps}BGO_dcrDBus
# eval add wave -noupdate $hexopt $tbpath${ps}plb2opb${ps}DCR_ABus
# eval add wave -noupdate $hexopt $tbpath${ps}plb2opb${ps}DCR_DBus
# eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}DCR_Read
# eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}DCR_Write
  eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}BGO_addrAck
  eval add wave -noupdate $hexopt $tbpath${ps}plb2opb${ps}BGO_MErr
  eval add wave -noupdate $hexopt $tbpath${ps}plb2opb${ps}BGO_MBusy
  eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}BGO_rdBTerm
  eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}BGO_rdComp
  eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}BGO_rdDAck
  eval add wave -noupdate $hexopt $tbpath${ps}plb2opb${ps}BGO_rdDBus
  eval add wave -noupdate $hexopt $tbpath${ps}plb2opb${ps}BGO_rdWdAddr
  eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}BGO_rearbitrate
  eval add wave -noupdate $hexopt $tbpath${ps}plb2opb${ps}BGO_SSize
  eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}BGO_wait
  eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}BGO_wrBTerm
  eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}BGO_wrComp
  eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}BGO_wrDAck
# eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}PLB_abort
# eval add wave -noupdate $hexopt $tbpath${ps}plb2opb${ps}PLB_ABus
# eval add wave -noupdate $hexopt $tbpath${ps}plb2opb${ps}PLB_BE
# eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}PLB_busLock
# eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}PLB_compress
# eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}PLB_guarded
# eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}PLB_lockErr
# eval add wave -noupdate $hexopt $tbpath${ps}plb2opb${ps}PLB_masterID
# eval add wave -noupdate $hexopt $tbpath${ps}plb2opb${ps}PLB_MSize
# eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}PLB_ordered
# eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}PLB_PAValid
# eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}PLB_rdBurst
# eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}PLB_rdPrim
# eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}PLB_RNW
# eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}PLB_SAValid
# eval add wave -noupdate $hexopt $tbpath${ps}plb2opb${ps}PLB_size
# eval add wave -noupdate $hexopt $tbpath${ps}plb2opb${ps}PLB_type
# eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}PLB_wrBurst
# eval add wave -noupdate $hexopt $tbpath${ps}plb2opb${ps}PLB_wrDBus
# eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}PLB_wrPrim
  eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}PLB2OPB_rearb
  eval add wave -noupdate $hexopt $tbpath${ps}plb2opb${ps}BGO_ABus
  eval add wave -noupdate $hexopt $tbpath${ps}plb2opb${ps}BGO_BE
  eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}BGO_busLock
  eval add wave -noupdate $hexopt $tbpath${ps}plb2opb${ps}BGO_DBus
  eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}BGO_request
  eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}BGO_RNW
  eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}BGO_select
  eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}BGO_seqAddr
# eval add wave -noupdate $hexopt $tbpath${ps}plb2opb${ps}OPB_DBus
# eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}OPB_errAck
# eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}OPB_MnGrant
# eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}OPB_retry
# eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}OPB_timeout
# eval add wave -noupdate $binopt $tbpath${ps}plb2opb${ps}OPB_xferAck

