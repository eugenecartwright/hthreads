#  Simulation Model Generator
#  Xilinx EDK 9.1.02 EDK_J_SP2.4
#  Copyright (c) 1995-2007 Xilinx, Inc.  All rights reserved.
#
#  File     opb2plb_wave.do (Wed Apr 09 16:49:12 2008)
#
#  Module   opb2plb_wrapper
#  Instance opb2plb
#  Because EDK did not create the testbench, the user
#  specifies the path to the device under test, $tbpath.
#
set binopt {-logic}
set hexopt {-literal -hex}
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}bfm_system" }

  eval add wave -noupdate -divider {"opb2plb"}
# eval add wave -noupdate $binopt $tbpath${ps}opb2plb${ps}OPB_Clk
# eval add wave -noupdate $binopt $tbpath${ps}opb2plb${ps}PLB_Clk
# eval add wave -noupdate $binopt $tbpath${ps}opb2plb${ps}OPB_Rst
# eval add wave -noupdate $binopt $tbpath${ps}opb2plb${ps}PLB_Rst
  eval add wave -noupdate $binopt $tbpath${ps}opb2plb${ps}BGI_Trans_Abort
# eval add wave -noupdate $binopt $tbpath${ps}opb2plb${ps}Bus_Error_Det
# eval add wave -noupdate $binopt $tbpath${ps}opb2plb${ps}OPB_select
# eval add wave -noupdate $hexopt $tbpath${ps}opb2plb${ps}OPB_ABus
# eval add wave -noupdate $binopt $tbpath${ps}opb2plb${ps}OPB_RNW
# eval add wave -noupdate $hexopt $tbpath${ps}opb2plb${ps}OPB_BE
# eval add wave -noupdate $hexopt $tbpath${ps}opb2plb${ps}OPB_DBus
# eval add wave -noupdate $binopt $tbpath${ps}opb2plb${ps}OPB_seqAddr
  eval add wave -noupdate $hexopt $tbpath${ps}opb2plb${ps}BGI_DBus
  eval add wave -noupdate $binopt $tbpath${ps}opb2plb${ps}BGI_retry
  eval add wave -noupdate $binopt $tbpath${ps}opb2plb${ps}BGI_toutSup
  eval add wave -noupdate $binopt $tbpath${ps}opb2plb${ps}BGI_xferAck
  eval add wave -noupdate $binopt $tbpath${ps}opb2plb${ps}BGI_errAck
  eval add wave -noupdate $binopt $tbpath${ps}opb2plb${ps}BGI_request
  eval add wave -noupdate $hexopt $tbpath${ps}opb2plb${ps}BGI_ABus
  eval add wave -noupdate $binopt $tbpath${ps}opb2plb${ps}BGI_RNW
  eval add wave -noupdate $hexopt $tbpath${ps}opb2plb${ps}BGI_BE
  eval add wave -noupdate $hexopt $tbpath${ps}opb2plb${ps}BGI_size
  eval add wave -noupdate $hexopt $tbpath${ps}opb2plb${ps}BGI_type
  eval add wave -noupdate $hexopt $tbpath${ps}opb2plb${ps}BGI_priority
  eval add wave -noupdate $binopt $tbpath${ps}opb2plb${ps}BGI_rdBurst
  eval add wave -noupdate $binopt $tbpath${ps}opb2plb${ps}BGI_wrBurst
  eval add wave -noupdate $binopt $tbpath${ps}opb2plb${ps}BGI_busLock
  eval add wave -noupdate $binopt $tbpath${ps}opb2plb${ps}BGI_abort
  eval add wave -noupdate $binopt $tbpath${ps}opb2plb${ps}BGI_lockErr
  eval add wave -noupdate $hexopt $tbpath${ps}opb2plb${ps}BGI_mSize
  eval add wave -noupdate $binopt $tbpath${ps}opb2plb${ps}BGI_ordered
  eval add wave -noupdate $binopt $tbpath${ps}opb2plb${ps}BGI_compress
  eval add wave -noupdate $binopt $tbpath${ps}opb2plb${ps}BGI_guarded
  eval add wave -noupdate $hexopt $tbpath${ps}opb2plb${ps}BGI_wrDBus
# eval add wave -noupdate $hexopt $tbpath${ps}opb2plb${ps}PLB_RdWdAddr
# eval add wave -noupdate $hexopt $tbpath${ps}opb2plb${ps}PLB_RdDBus
# eval add wave -noupdate $binopt $tbpath${ps}opb2plb${ps}PLB_AddrAck
# eval add wave -noupdate $binopt $tbpath${ps}opb2plb${ps}PLB_RdDAck
# eval add wave -noupdate $binopt $tbpath${ps}opb2plb${ps}PLB_WrDAck
# eval add wave -noupdate $binopt $tbpath${ps}opb2plb${ps}PLB_rearbitrate
# eval add wave -noupdate $binopt $tbpath${ps}opb2plb${ps}PLB_Busy
# eval add wave -noupdate $binopt $tbpath${ps}opb2plb${ps}PLB_Err
# eval add wave -noupdate $binopt $tbpath${ps}opb2plb${ps}PLB_RdBTerm
# eval add wave -noupdate $binopt $tbpath${ps}opb2plb${ps}PLB_WrBTerm
# eval add wave -noupdate $hexopt $tbpath${ps}opb2plb${ps}PLB_sSize
# eval add wave -noupdate $binopt $tbpath${ps}opb2plb${ps}PLB_pendReq
# eval add wave -noupdate $hexopt $tbpath${ps}opb2plb${ps}PLB_pendPri
# eval add wave -noupdate $hexopt $tbpath${ps}opb2plb${ps}PLB_reqPri
# eval add wave -noupdate $binopt $tbpath${ps}opb2plb${ps}DCR_Read
# eval add wave -noupdate $binopt $tbpath${ps}opb2plb${ps}DCR_Write
# eval add wave -noupdate $hexopt $tbpath${ps}opb2plb${ps}DCR_ABus
# eval add wave -noupdate $hexopt $tbpath${ps}opb2plb${ps}DCR_DBus
# eval add wave -noupdate $hexopt $tbpath${ps}opb2plb${ps}BGI_dcr_DBus
# eval add wave -noupdate $binopt $tbpath${ps}opb2plb${ps}BGI_ack

