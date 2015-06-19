#  Simulation Model Generator
#  Xilinx EDK 9.1.02 EDK_J_SP2.4
#  Copyright (c) 1995-2007 Xilinx, Inc.  All rights reserved.
#
#  File     synch_manager_list.do (Wed Apr 09 16:49:13 2008)
#
#  Module   synch_manager_wrapper
#  Instance synch_manager
#  Because EDK did not create the testbench, the user
#  specifies the path to the device under test, $tbpath.
#
set binopt {-bin}
set hexopt {-hex}
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}bfm_system" }

# eval add list $binopt $tbpath${ps}synch_manager${ps}OPB_Clk
# eval add list $binopt $tbpath${ps}synch_manager${ps}OPB_Rst
  eval add list $hexopt $tbpath${ps}synch_manager${ps}Sl_DBus
  eval add list $binopt $tbpath${ps}synch_manager${ps}Sl_errAck
  eval add list $binopt $tbpath${ps}synch_manager${ps}Sl_retry
  eval add list $binopt $tbpath${ps}synch_manager${ps}Sl_toutSup
  eval add list $binopt $tbpath${ps}synch_manager${ps}Sl_xferAck
# eval add list $hexopt $tbpath${ps}synch_manager${ps}OPB_ABus
# eval add list $hexopt $tbpath${ps}synch_manager${ps}OPB_BE
# eval add list $hexopt $tbpath${ps}synch_manager${ps}OPB_DBus
# eval add list $binopt $tbpath${ps}synch_manager${ps}OPB_RNW
# eval add list $binopt $tbpath${ps}synch_manager${ps}OPB_select
# eval add list $binopt $tbpath${ps}synch_manager${ps}OPB_seqAddr
  eval add list $hexopt $tbpath${ps}synch_manager${ps}M_ABus
  eval add list $hexopt $tbpath${ps}synch_manager${ps}M_BE
  eval add list $binopt $tbpath${ps}synch_manager${ps}M_busLock
  eval add list $binopt $tbpath${ps}synch_manager${ps}M_request
  eval add list $binopt $tbpath${ps}synch_manager${ps}M_RNW
  eval add list $binopt $tbpath${ps}synch_manager${ps}M_select
  eval add list $binopt $tbpath${ps}synch_manager${ps}M_seqAddr
# eval add list $binopt $tbpath${ps}synch_manager${ps}OPB_errAck
# eval add list $binopt $tbpath${ps}synch_manager${ps}OPB_MGrant
# eval add list $binopt $tbpath${ps}synch_manager${ps}OPB_retry
# eval add list $binopt $tbpath${ps}synch_manager${ps}OPB_timeout
# eval add list $binopt $tbpath${ps}synch_manager${ps}OPB_xferAck
  eval add list $binopt $tbpath${ps}synch_manager${ps}system_reset
  eval add list $binopt $tbpath${ps}synch_manager${ps}system_resetdone

