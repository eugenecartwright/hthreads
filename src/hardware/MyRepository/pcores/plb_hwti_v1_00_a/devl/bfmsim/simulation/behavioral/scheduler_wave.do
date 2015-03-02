#  Simulation Model Generator
#  Xilinx EDK 9.1.02 EDK_J_SP2.4
#  Copyright (c) 1995-2007 Xilinx, Inc.  All rights reserved.
#
#  File     scheduler_wave.do (Wed Apr 09 16:49:13 2008)
#
#  Module   scheduler_wrapper
#  Instance scheduler
#  Because EDK did not create the testbench, the user
#  specifies the path to the device under test, $tbpath.
#
set binopt {-logic}
set hexopt {-literal -hex}
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}bfm_system" }

  eval add wave -noupdate -divider {"scheduler"}
  eval add wave -noupdate $binopt $tbpath${ps}scheduler${ps}Soft_Reset
  eval add wave -noupdate $binopt $tbpath${ps}scheduler${ps}Reset_Done
  eval add wave -noupdate $binopt $tbpath${ps}scheduler${ps}Soft_Stop
  eval add wave -noupdate $hexopt $tbpath${ps}scheduler${ps}SWTM_DOB
  eval add wave -noupdate $hexopt $tbpath${ps}scheduler${ps}SWTM_ADDRB
  eval add wave -noupdate $hexopt $tbpath${ps}scheduler${ps}SWTM_DIB
  eval add wave -noupdate $binopt $tbpath${ps}scheduler${ps}SWTM_ENB
  eval add wave -noupdate $binopt $tbpath${ps}scheduler${ps}SWTM_WEB
  eval add wave -noupdate $hexopt $tbpath${ps}scheduler${ps}TM2SCH_current_cpu_tid
  eval add wave -noupdate $hexopt $tbpath${ps}scheduler${ps}TM2SCH_opcode
  eval add wave -noupdate $hexopt $tbpath${ps}scheduler${ps}TM2SCH_data
  eval add wave -noupdate $binopt $tbpath${ps}scheduler${ps}TM2SCH_request
  eval add wave -noupdate $binopt $tbpath${ps}scheduler${ps}SCH2TM_busy
  eval add wave -noupdate $hexopt $tbpath${ps}scheduler${ps}SCH2TM_data
  eval add wave -noupdate $hexopt $tbpath${ps}scheduler${ps}SCH2TM_next_cpu_tid
  eval add wave -noupdate $binopt $tbpath${ps}scheduler${ps}SCH2TM_next_tid_valid
# eval add wave -noupdate $binopt $tbpath${ps}scheduler${ps}Preemption_Interrupt
# eval add wave -noupdate $binopt $tbpath${ps}scheduler${ps}OPB_Clk
# eval add wave -noupdate $binopt $tbpath${ps}scheduler${ps}OPB_Rst
  eval add wave -noupdate $hexopt $tbpath${ps}scheduler${ps}Sl_DBus
  eval add wave -noupdate $binopt $tbpath${ps}scheduler${ps}Sl_errAck
  eval add wave -noupdate $binopt $tbpath${ps}scheduler${ps}Sl_retry
  eval add wave -noupdate $binopt $tbpath${ps}scheduler${ps}Sl_toutSup
  eval add wave -noupdate $binopt $tbpath${ps}scheduler${ps}Sl_xferAck
# eval add wave -noupdate $hexopt $tbpath${ps}scheduler${ps}OPB_ABus
# eval add wave -noupdate $hexopt $tbpath${ps}scheduler${ps}OPB_BE
# eval add wave -noupdate $hexopt $tbpath${ps}scheduler${ps}OPB_DBus
# eval add wave -noupdate $binopt $tbpath${ps}scheduler${ps}OPB_RNW
# eval add wave -noupdate $binopt $tbpath${ps}scheduler${ps}OPB_select
# eval add wave -noupdate $binopt $tbpath${ps}scheduler${ps}OPB_seqAddr
  eval add wave -noupdate $hexopt $tbpath${ps}scheduler${ps}M_ABus
  eval add wave -noupdate $hexopt $tbpath${ps}scheduler${ps}M_BE
  eval add wave -noupdate $binopt $tbpath${ps}scheduler${ps}M_busLock
  eval add wave -noupdate $binopt $tbpath${ps}scheduler${ps}M_request
  eval add wave -noupdate $binopt $tbpath${ps}scheduler${ps}M_RNW
  eval add wave -noupdate $binopt $tbpath${ps}scheduler${ps}M_select
  eval add wave -noupdate $binopt $tbpath${ps}scheduler${ps}M_seqAddr
# eval add wave -noupdate $binopt $tbpath${ps}scheduler${ps}OPB_errAck
# eval add wave -noupdate $binopt $tbpath${ps}scheduler${ps}OPB_MGrant
# eval add wave -noupdate $binopt $tbpath${ps}scheduler${ps}OPB_retry
# eval add wave -noupdate $binopt $tbpath${ps}scheduler${ps}OPB_timeout
# eval add wave -noupdate $binopt $tbpath${ps}scheduler${ps}OPB_xferAck

