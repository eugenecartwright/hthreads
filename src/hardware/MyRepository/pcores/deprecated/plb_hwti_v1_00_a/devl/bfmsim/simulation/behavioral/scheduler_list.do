#  Simulation Model Generator
#  Xilinx EDK 9.1.02 EDK_J_SP2.4
#  Copyright (c) 1995-2007 Xilinx, Inc.  All rights reserved.
#
#  File     scheduler_list.do (Wed Apr 09 16:49:13 2008)
#
#  Module   scheduler_wrapper
#  Instance scheduler
#  Because EDK did not create the testbench, the user
#  specifies the path to the device under test, $tbpath.
#
set binopt {-bin}
set hexopt {-hex}
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}bfm_system" }

  eval add list $binopt $tbpath${ps}scheduler${ps}Soft_Reset
  eval add list $binopt $tbpath${ps}scheduler${ps}Reset_Done
  eval add list $binopt $tbpath${ps}scheduler${ps}Soft_Stop
  eval add list $hexopt $tbpath${ps}scheduler${ps}SWTM_DOB
  eval add list $hexopt $tbpath${ps}scheduler${ps}SWTM_ADDRB
  eval add list $hexopt $tbpath${ps}scheduler${ps}SWTM_DIB
  eval add list $binopt $tbpath${ps}scheduler${ps}SWTM_ENB
  eval add list $binopt $tbpath${ps}scheduler${ps}SWTM_WEB
  eval add list $hexopt $tbpath${ps}scheduler${ps}TM2SCH_current_cpu_tid
  eval add list $hexopt $tbpath${ps}scheduler${ps}TM2SCH_opcode
  eval add list $hexopt $tbpath${ps}scheduler${ps}TM2SCH_data
  eval add list $binopt $tbpath${ps}scheduler${ps}TM2SCH_request
  eval add list $binopt $tbpath${ps}scheduler${ps}SCH2TM_busy
  eval add list $hexopt $tbpath${ps}scheduler${ps}SCH2TM_data
  eval add list $hexopt $tbpath${ps}scheduler${ps}SCH2TM_next_cpu_tid
  eval add list $binopt $tbpath${ps}scheduler${ps}SCH2TM_next_tid_valid
# eval add list $binopt $tbpath${ps}scheduler${ps}Preemption_Interrupt
# eval add list $binopt $tbpath${ps}scheduler${ps}OPB_Clk
# eval add list $binopt $tbpath${ps}scheduler${ps}OPB_Rst
  eval add list $hexopt $tbpath${ps}scheduler${ps}Sl_DBus
  eval add list $binopt $tbpath${ps}scheduler${ps}Sl_errAck
  eval add list $binopt $tbpath${ps}scheduler${ps}Sl_retry
  eval add list $binopt $tbpath${ps}scheduler${ps}Sl_toutSup
  eval add list $binopt $tbpath${ps}scheduler${ps}Sl_xferAck
# eval add list $hexopt $tbpath${ps}scheduler${ps}OPB_ABus
# eval add list $hexopt $tbpath${ps}scheduler${ps}OPB_BE
# eval add list $hexopt $tbpath${ps}scheduler${ps}OPB_DBus
# eval add list $binopt $tbpath${ps}scheduler${ps}OPB_RNW
# eval add list $binopt $tbpath${ps}scheduler${ps}OPB_select
# eval add list $binopt $tbpath${ps}scheduler${ps}OPB_seqAddr
  eval add list $hexopt $tbpath${ps}scheduler${ps}M_ABus
  eval add list $hexopt $tbpath${ps}scheduler${ps}M_BE
  eval add list $binopt $tbpath${ps}scheduler${ps}M_busLock
  eval add list $binopt $tbpath${ps}scheduler${ps}M_request
  eval add list $binopt $tbpath${ps}scheduler${ps}M_RNW
  eval add list $binopt $tbpath${ps}scheduler${ps}M_select
  eval add list $binopt $tbpath${ps}scheduler${ps}M_seqAddr
# eval add list $binopt $tbpath${ps}scheduler${ps}OPB_errAck
# eval add list $binopt $tbpath${ps}scheduler${ps}OPB_MGrant
# eval add list $binopt $tbpath${ps}scheduler${ps}OPB_retry
# eval add list $binopt $tbpath${ps}scheduler${ps}OPB_timeout
# eval add list $binopt $tbpath${ps}scheduler${ps}OPB_xferAck

