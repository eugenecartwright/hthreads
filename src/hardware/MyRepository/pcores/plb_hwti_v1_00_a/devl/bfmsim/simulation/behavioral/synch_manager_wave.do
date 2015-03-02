#  Simulation Model Generator
#  Xilinx EDK 9.1.02 EDK_J_SP2.4
#  Copyright (c) 1995-2007 Xilinx, Inc.  All rights reserved.
#
#  File     synch_manager_wave.do (Wed Apr 09 16:49:13 2008)
#
#  Module   synch_manager_wrapper
#  Instance synch_manager
#  Because EDK did not create the testbench, the user
#  specifies the path to the device under test, $tbpath.
#
set binopt {-logic}
set hexopt {-literal -hex}
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}bfm_system" }

  eval add wave -noupdate -divider {"synch_manager"}
# eval add wave -noupdate $binopt $tbpath${ps}synch_manager${ps}OPB_Clk
# eval add wave -noupdate $binopt $tbpath${ps}synch_manager${ps}OPB_Rst
  eval add wave -noupdate $hexopt $tbpath${ps}synch_manager${ps}Sl_DBus
  eval add wave -noupdate $binopt $tbpath${ps}synch_manager${ps}Sl_errAck
  eval add wave -noupdate $binopt $tbpath${ps}synch_manager${ps}Sl_retry
  eval add wave -noupdate $binopt $tbpath${ps}synch_manager${ps}Sl_toutSup
  eval add wave -noupdate $binopt $tbpath${ps}synch_manager${ps}Sl_xferAck
# eval add wave -noupdate $hexopt $tbpath${ps}synch_manager${ps}OPB_ABus
# eval add wave -noupdate $hexopt $tbpath${ps}synch_manager${ps}OPB_BE
# eval add wave -noupdate $hexopt $tbpath${ps}synch_manager${ps}OPB_DBus
# eval add wave -noupdate $binopt $tbpath${ps}synch_manager${ps}OPB_RNW
# eval add wave -noupdate $binopt $tbpath${ps}synch_manager${ps}OPB_select
# eval add wave -noupdate $binopt $tbpath${ps}synch_manager${ps}OPB_seqAddr
  eval add wave -noupdate $hexopt $tbpath${ps}synch_manager${ps}M_ABus
  eval add wave -noupdate $hexopt $tbpath${ps}synch_manager${ps}M_BE
  eval add wave -noupdate $binopt $tbpath${ps}synch_manager${ps}M_busLock
  eval add wave -noupdate $binopt $tbpath${ps}synch_manager${ps}M_request
  eval add wave -noupdate $binopt $tbpath${ps}synch_manager${ps}M_RNW
  eval add wave -noupdate $binopt $tbpath${ps}synch_manager${ps}M_select
  eval add wave -noupdate $binopt $tbpath${ps}synch_manager${ps}M_seqAddr
# eval add wave -noupdate $binopt $tbpath${ps}synch_manager${ps}OPB_errAck
# eval add wave -noupdate $binopt $tbpath${ps}synch_manager${ps}OPB_MGrant
# eval add wave -noupdate $binopt $tbpath${ps}synch_manager${ps}OPB_retry
# eval add wave -noupdate $binopt $tbpath${ps}synch_manager${ps}OPB_timeout
# eval add wave -noupdate $binopt $tbpath${ps}synch_manager${ps}OPB_xferAck
  eval add wave -noupdate $binopt $tbpath${ps}synch_manager${ps}system_reset
  eval add wave -noupdate $binopt $tbpath${ps}synch_manager${ps}system_resetdone

