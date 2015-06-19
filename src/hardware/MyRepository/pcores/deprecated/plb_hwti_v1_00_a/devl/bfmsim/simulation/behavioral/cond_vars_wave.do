#  Simulation Model Generator
#  Xilinx EDK 9.1.02 EDK_J_SP2.4
#  Copyright (c) 1995-2007 Xilinx, Inc.  All rights reserved.
#
#  File     cond_vars_wave.do (Wed Apr 09 16:49:13 2008)
#
#  Module   cond_vars_wrapper
#  Instance cond_vars
#  Because EDK did not create the testbench, the user
#  specifies the path to the device under test, $tbpath.
#
set binopt {-logic}
set hexopt {-literal -hex}
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}bfm_system" }

  eval add wave -noupdate -divider {"cond_vars"}
# eval add wave -noupdate $binopt $tbpath${ps}cond_vars${ps}OPB_Clk
# eval add wave -noupdate $binopt $tbpath${ps}cond_vars${ps}OPB_Rst
# eval add wave -noupdate $binopt $tbpath${ps}cond_vars${ps}Interrupt
  eval add wave -noupdate $binopt $tbpath${ps}cond_vars${ps}IP2Bus_IntrEvent
# eval add wave -noupdate $hexopt $tbpath${ps}cond_vars${ps}OPB_ABus
# eval add wave -noupdate $hexopt $tbpath${ps}cond_vars${ps}OPB_DBus
# eval add wave -noupdate $hexopt $tbpath${ps}cond_vars${ps}OPB_BE
# eval add wave -noupdate $binopt $tbpath${ps}cond_vars${ps}OPB_RNW
# eval add wave -noupdate $binopt $tbpath${ps}cond_vars${ps}OPB_select
# eval add wave -noupdate $binopt $tbpath${ps}cond_vars${ps}OPB_seqAddr
# eval add wave -noupdate $binopt $tbpath${ps}cond_vars${ps}OPB_errAck
# eval add wave -noupdate $binopt $tbpath${ps}cond_vars${ps}OPB_MnGrant
# eval add wave -noupdate $binopt $tbpath${ps}cond_vars${ps}OPB_retry
# eval add wave -noupdate $binopt $tbpath${ps}cond_vars${ps}OPB_timeout
# eval add wave -noupdate $binopt $tbpath${ps}cond_vars${ps}OPB_xferAck
  eval add wave -noupdate $binopt $tbpath${ps}cond_vars${ps}Mn_request
  eval add wave -noupdate $binopt $tbpath${ps}cond_vars${ps}Mn_busLock
  eval add wave -noupdate $binopt $tbpath${ps}cond_vars${ps}Mn_select
  eval add wave -noupdate $binopt $tbpath${ps}cond_vars${ps}Mn_RNW
  eval add wave -noupdate $hexopt $tbpath${ps}cond_vars${ps}Mn_BE
  eval add wave -noupdate $binopt $tbpath${ps}cond_vars${ps}Mn_seqAddr
  eval add wave -noupdate $hexopt $tbpath${ps}cond_vars${ps}Mn_ABus
  eval add wave -noupdate $binopt $tbpath${ps}cond_vars${ps}Sln_xferAck
  eval add wave -noupdate $binopt $tbpath${ps}cond_vars${ps}Sln_errAck
  eval add wave -noupdate $binopt $tbpath${ps}cond_vars${ps}Sln_retry
  eval add wave -noupdate $binopt $tbpath${ps}cond_vars${ps}Sln_toutSup
  eval add wave -noupdate $hexopt $tbpath${ps}cond_vars${ps}Sln_DBus
  eval add wave -noupdate $binopt $tbpath${ps}cond_vars${ps}Sema_Reset
# eval add wave -noupdate $binopt $tbpath${ps}cond_vars${ps}Sema_Rst_Ack

