#  Simulation Model Generator
#  Xilinx EDK 9.1.02 EDK_J_SP2.4
#  Copyright (c) 1995-2007 Xilinx, Inc.  All rights reserved.
#
#  File     opb2plb_list.do (Wed Apr 09 16:49:13 2008)
#
#  Module   opb2plb_wrapper
#  Instance opb2plb
#  Because EDK did not create the testbench, the user
#  specifies the path to the device under test, $tbpath.
#
set binopt {-bin}
set hexopt {-hex}
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}bfm_system" }

# eval add list $binopt $tbpath${ps}opb2plb${ps}OPB_Clk
# eval add list $binopt $tbpath${ps}opb2plb${ps}PLB_Clk
# eval add list $binopt $tbpath${ps}opb2plb${ps}OPB_Rst
# eval add list $binopt $tbpath${ps}opb2plb${ps}PLB_Rst
  eval add list $binopt $tbpath${ps}opb2plb${ps}BGI_Trans_Abort
# eval add list $binopt $tbpath${ps}opb2plb${ps}Bus_Error_Det
# eval add list $binopt $tbpath${ps}opb2plb${ps}OPB_select
# eval add list $hexopt $tbpath${ps}opb2plb${ps}OPB_ABus
# eval add list $binopt $tbpath${ps}opb2plb${ps}OPB_RNW
# eval add list $hexopt $tbpath${ps}opb2plb${ps}OPB_BE
# eval add list $hexopt $tbpath${ps}opb2plb${ps}OPB_DBus
# eval add list $binopt $tbpath${ps}opb2plb${ps}OPB_seqAddr
  eval add list $hexopt $tbpath${ps}opb2plb${ps}BGI_DBus
  eval add list $binopt $tbpath${ps}opb2plb${ps}BGI_retry
  eval add list $binopt $tbpath${ps}opb2plb${ps}BGI_toutSup
  eval add list $binopt $tbpath${ps}opb2plb${ps}BGI_xferAck
  eval add list $binopt $tbpath${ps}opb2plb${ps}BGI_errAck
  eval add list $binopt $tbpath${ps}opb2plb${ps}BGI_request
  eval add list $hexopt $tbpath${ps}opb2plb${ps}BGI_ABus
  eval add list $binopt $tbpath${ps}opb2plb${ps}BGI_RNW
  eval add list $hexopt $tbpath${ps}opb2plb${ps}BGI_BE
  eval add list $hexopt $tbpath${ps}opb2plb${ps}BGI_size
  eval add list $hexopt $tbpath${ps}opb2plb${ps}BGI_type
  eval add list $hexopt $tbpath${ps}opb2plb${ps}BGI_priority
  eval add list $binopt $tbpath${ps}opb2plb${ps}BGI_rdBurst
  eval add list $binopt $tbpath${ps}opb2plb${ps}BGI_wrBurst
  eval add list $binopt $tbpath${ps}opb2plb${ps}BGI_busLock
  eval add list $binopt $tbpath${ps}opb2plb${ps}BGI_abort
  eval add list $binopt $tbpath${ps}opb2plb${ps}BGI_lockErr
  eval add list $hexopt $tbpath${ps}opb2plb${ps}BGI_mSize
  eval add list $binopt $tbpath${ps}opb2plb${ps}BGI_ordered
  eval add list $binopt $tbpath${ps}opb2plb${ps}BGI_compress
  eval add list $binopt $tbpath${ps}opb2plb${ps}BGI_guarded
  eval add list $hexopt $tbpath${ps}opb2plb${ps}BGI_wrDBus
# eval add list $hexopt $tbpath${ps}opb2plb${ps}PLB_RdWdAddr
# eval add list $hexopt $tbpath${ps}opb2plb${ps}PLB_RdDBus
# eval add list $binopt $tbpath${ps}opb2plb${ps}PLB_AddrAck
# eval add list $binopt $tbpath${ps}opb2plb${ps}PLB_RdDAck
# eval add list $binopt $tbpath${ps}opb2plb${ps}PLB_WrDAck
# eval add list $binopt $tbpath${ps}opb2plb${ps}PLB_rearbitrate
# eval add list $binopt $tbpath${ps}opb2plb${ps}PLB_Busy
# eval add list $binopt $tbpath${ps}opb2plb${ps}PLB_Err
# eval add list $binopt $tbpath${ps}opb2plb${ps}PLB_RdBTerm
# eval add list $binopt $tbpath${ps}opb2plb${ps}PLB_WrBTerm
# eval add list $hexopt $tbpath${ps}opb2plb${ps}PLB_sSize
# eval add list $binopt $tbpath${ps}opb2plb${ps}PLB_pendReq
# eval add list $hexopt $tbpath${ps}opb2plb${ps}PLB_pendPri
# eval add list $hexopt $tbpath${ps}opb2plb${ps}PLB_reqPri
# eval add list $binopt $tbpath${ps}opb2plb${ps}DCR_Read
# eval add list $binopt $tbpath${ps}opb2plb${ps}DCR_Write
# eval add list $hexopt $tbpath${ps}opb2plb${ps}DCR_ABus
# eval add list $hexopt $tbpath${ps}opb2plb${ps}DCR_DBus
# eval add list $hexopt $tbpath${ps}opb2plb${ps}BGI_dcr_DBus
# eval add list $binopt $tbpath${ps}opb2plb${ps}BGI_ack

