#  Simulation Model Generator
#  Xilinx EDK 9.1.02 EDK_J_SP2.4
#  Copyright (c) 1995-2007 Xilinx, Inc.  All rights reserved.
#
#  File     plb2opb_list.do (Wed Apr 09 16:49:13 2008)
#
#  Module   plb2opb_wrapper
#  Instance plb2opb
#  Because EDK did not create the testbench, the user
#  specifies the path to the device under test, $tbpath.
#
set binopt {-bin}
set hexopt {-hex}
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}bfm_system" }

# eval add list $binopt $tbpath${ps}plb2opb${ps}PLB_Clk
# eval add list $binopt $tbpath${ps}plb2opb${ps}OPB_Clk
# eval add list $binopt $tbpath${ps}plb2opb${ps}PLB_Rst
# eval add list $binopt $tbpath${ps}plb2opb${ps}OPB_Rst
# eval add list $binopt $tbpath${ps}plb2opb${ps}Bus_Error_Det
  eval add list $binopt $tbpath${ps}plb2opb${ps}BGI_Trans_Abort
# eval add list $binopt $tbpath${ps}plb2opb${ps}BGO_dcrAck
# eval add list $hexopt $tbpath${ps}plb2opb${ps}BGO_dcrDBus
# eval add list $hexopt $tbpath${ps}plb2opb${ps}DCR_ABus
# eval add list $hexopt $tbpath${ps}plb2opb${ps}DCR_DBus
# eval add list $binopt $tbpath${ps}plb2opb${ps}DCR_Read
# eval add list $binopt $tbpath${ps}plb2opb${ps}DCR_Write
  eval add list $binopt $tbpath${ps}plb2opb${ps}BGO_addrAck
  eval add list $hexopt $tbpath${ps}plb2opb${ps}BGO_MErr
  eval add list $hexopt $tbpath${ps}plb2opb${ps}BGO_MBusy
  eval add list $binopt $tbpath${ps}plb2opb${ps}BGO_rdBTerm
  eval add list $binopt $tbpath${ps}plb2opb${ps}BGO_rdComp
  eval add list $binopt $tbpath${ps}plb2opb${ps}BGO_rdDAck
  eval add list $hexopt $tbpath${ps}plb2opb${ps}BGO_rdDBus
  eval add list $hexopt $tbpath${ps}plb2opb${ps}BGO_rdWdAddr
  eval add list $binopt $tbpath${ps}plb2opb${ps}BGO_rearbitrate
  eval add list $hexopt $tbpath${ps}plb2opb${ps}BGO_SSize
  eval add list $binopt $tbpath${ps}plb2opb${ps}BGO_wait
  eval add list $binopt $tbpath${ps}plb2opb${ps}BGO_wrBTerm
  eval add list $binopt $tbpath${ps}plb2opb${ps}BGO_wrComp
  eval add list $binopt $tbpath${ps}plb2opb${ps}BGO_wrDAck
# eval add list $binopt $tbpath${ps}plb2opb${ps}PLB_abort
# eval add list $hexopt $tbpath${ps}plb2opb${ps}PLB_ABus
# eval add list $hexopt $tbpath${ps}plb2opb${ps}PLB_BE
# eval add list $binopt $tbpath${ps}plb2opb${ps}PLB_busLock
# eval add list $binopt $tbpath${ps}plb2opb${ps}PLB_compress
# eval add list $binopt $tbpath${ps}plb2opb${ps}PLB_guarded
# eval add list $binopt $tbpath${ps}plb2opb${ps}PLB_lockErr
# eval add list $hexopt $tbpath${ps}plb2opb${ps}PLB_masterID
# eval add list $hexopt $tbpath${ps}plb2opb${ps}PLB_MSize
# eval add list $binopt $tbpath${ps}plb2opb${ps}PLB_ordered
# eval add list $binopt $tbpath${ps}plb2opb${ps}PLB_PAValid
# eval add list $binopt $tbpath${ps}plb2opb${ps}PLB_rdBurst
# eval add list $binopt $tbpath${ps}plb2opb${ps}PLB_rdPrim
# eval add list $binopt $tbpath${ps}plb2opb${ps}PLB_RNW
# eval add list $binopt $tbpath${ps}plb2opb${ps}PLB_SAValid
# eval add list $hexopt $tbpath${ps}plb2opb${ps}PLB_size
# eval add list $hexopt $tbpath${ps}plb2opb${ps}PLB_type
# eval add list $binopt $tbpath${ps}plb2opb${ps}PLB_wrBurst
# eval add list $hexopt $tbpath${ps}plb2opb${ps}PLB_wrDBus
# eval add list $binopt $tbpath${ps}plb2opb${ps}PLB_wrPrim
  eval add list $binopt $tbpath${ps}plb2opb${ps}PLB2OPB_rearb
  eval add list $hexopt $tbpath${ps}plb2opb${ps}BGO_ABus
  eval add list $hexopt $tbpath${ps}plb2opb${ps}BGO_BE
  eval add list $binopt $tbpath${ps}plb2opb${ps}BGO_busLock
  eval add list $hexopt $tbpath${ps}plb2opb${ps}BGO_DBus
  eval add list $binopt $tbpath${ps}plb2opb${ps}BGO_request
  eval add list $binopt $tbpath${ps}plb2opb${ps}BGO_RNW
  eval add list $binopt $tbpath${ps}plb2opb${ps}BGO_select
  eval add list $binopt $tbpath${ps}plb2opb${ps}BGO_seqAddr
# eval add list $hexopt $tbpath${ps}plb2opb${ps}OPB_DBus
# eval add list $binopt $tbpath${ps}plb2opb${ps}OPB_errAck
# eval add list $binopt $tbpath${ps}plb2opb${ps}OPB_MnGrant
# eval add list $binopt $tbpath${ps}plb2opb${ps}OPB_retry
# eval add list $binopt $tbpath${ps}plb2opb${ps}OPB_timeout
# eval add list $binopt $tbpath${ps}plb2opb${ps}OPB_xferAck

