#  Simulation Model Generator
#  Xilinx EDK 9.1.02 EDK_J_SP2.4
#  Copyright (c) 1995-2007 Xilinx, Inc.  All rights reserved.
#
#  File     opb_wave.do (Wed Apr 09 16:49:12 2008)
#
#  Module   opb_wrapper
#  Instance opb
#  Because EDK did not create the testbench, the user
#  specifies the path to the device under test, $tbpath.
#
set binopt {-logic}
set hexopt {-literal -hex}
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}bfm_system" }

  eval add wave -noupdate -divider {"opb"}
# eval add wave -noupdate $binopt $tbpath${ps}opb${ps}OPB_Clk
  eval add wave -noupdate $binopt $tbpath${ps}opb${ps}OPB_Rst
# eval add wave -noupdate $binopt $tbpath${ps}opb${ps}SYS_Rst
# eval add wave -noupdate $binopt $tbpath${ps}opb${ps}Debug_SYS_Rst
# eval add wave -noupdate $binopt $tbpath${ps}opb${ps}WDT_Rst
# eval add wave -noupdate $hexopt $tbpath${ps}opb${ps}M_ABus
# eval add wave -noupdate $hexopt $tbpath${ps}opb${ps}M_BE
# eval add wave -noupdate $hexopt $tbpath${ps}opb${ps}M_beXfer
# eval add wave -noupdate $hexopt $tbpath${ps}opb${ps}M_busLock
# eval add wave -noupdate $hexopt $tbpath${ps}opb${ps}M_DBus
# eval add wave -noupdate $hexopt $tbpath${ps}opb${ps}M_DBusEn
# eval add wave -noupdate $hexopt $tbpath${ps}opb${ps}M_DBusEn32_63
# eval add wave -noupdate $hexopt $tbpath${ps}opb${ps}M_dwXfer
# eval add wave -noupdate $hexopt $tbpath${ps}opb${ps}M_fwXfer
# eval add wave -noupdate $hexopt $tbpath${ps}opb${ps}M_hwXfer
# eval add wave -noupdate $hexopt $tbpath${ps}opb${ps}M_request
# eval add wave -noupdate $hexopt $tbpath${ps}opb${ps}M_RNW
# eval add wave -noupdate $hexopt $tbpath${ps}opb${ps}M_select
# eval add wave -noupdate $hexopt $tbpath${ps}opb${ps}M_seqAddr
# eval add wave -noupdate $hexopt $tbpath${ps}opb${ps}Sl_beAck
# eval add wave -noupdate $hexopt $tbpath${ps}opb${ps}Sl_DBus
# eval add wave -noupdate $hexopt $tbpath${ps}opb${ps}Sl_DBusEn
# eval add wave -noupdate $hexopt $tbpath${ps}opb${ps}Sl_DBusEn32_63
# eval add wave -noupdate $hexopt $tbpath${ps}opb${ps}Sl_errAck
# eval add wave -noupdate $hexopt $tbpath${ps}opb${ps}Sl_dwAck
# eval add wave -noupdate $hexopt $tbpath${ps}opb${ps}Sl_fwAck
# eval add wave -noupdate $hexopt $tbpath${ps}opb${ps}Sl_hwAck
# eval add wave -noupdate $hexopt $tbpath${ps}opb${ps}Sl_retry
# eval add wave -noupdate $hexopt $tbpath${ps}opb${ps}Sl_toutSup
# eval add wave -noupdate $hexopt $tbpath${ps}opb${ps}Sl_xferAck
# eval add wave -noupdate $hexopt $tbpath${ps}opb${ps}OPB_MRequest
  eval add wave -noupdate $hexopt $tbpath${ps}opb${ps}OPB_ABus
  eval add wave -noupdate $hexopt $tbpath${ps}opb${ps}OPB_BE
# eval add wave -noupdate $binopt $tbpath${ps}opb${ps}OPB_beXfer
# eval add wave -noupdate $binopt $tbpath${ps}opb${ps}OPB_beAck
# eval add wave -noupdate $binopt $tbpath${ps}opb${ps}OPB_busLock
# eval add wave -noupdate $hexopt $tbpath${ps}opb${ps}OPB_rdDBus
# eval add wave -noupdate $hexopt $tbpath${ps}opb${ps}OPB_wrDBus
  eval add wave -noupdate $hexopt $tbpath${ps}opb${ps}OPB_DBus
  eval add wave -noupdate $binopt $tbpath${ps}opb${ps}OPB_errAck
# eval add wave -noupdate $binopt $tbpath${ps}opb${ps}OPB_dwAck
# eval add wave -noupdate $binopt $tbpath${ps}opb${ps}OPB_dwXfer
# eval add wave -noupdate $binopt $tbpath${ps}opb${ps}OPB_fwAck
# eval add wave -noupdate $binopt $tbpath${ps}opb${ps}OPB_fwXfer
# eval add wave -noupdate $binopt $tbpath${ps}opb${ps}OPB_hwAck
# eval add wave -noupdate $binopt $tbpath${ps}opb${ps}OPB_hwXfer
  eval add wave -noupdate $hexopt $tbpath${ps}opb${ps}OPB_MGrant
# eval add wave -noupdate $hexopt $tbpath${ps}opb${ps}OPB_pendReq
  eval add wave -noupdate $binopt $tbpath${ps}opb${ps}OPB_retry
  eval add wave -noupdate $binopt $tbpath${ps}opb${ps}OPB_RNW
  eval add wave -noupdate $binopt $tbpath${ps}opb${ps}OPB_select
  eval add wave -noupdate $binopt $tbpath${ps}opb${ps}OPB_seqAddr
  eval add wave -noupdate $binopt $tbpath${ps}opb${ps}OPB_timeout
# eval add wave -noupdate $binopt $tbpath${ps}opb${ps}OPB_toutSup
  eval add wave -noupdate $binopt $tbpath${ps}opb${ps}OPB_xferAck

