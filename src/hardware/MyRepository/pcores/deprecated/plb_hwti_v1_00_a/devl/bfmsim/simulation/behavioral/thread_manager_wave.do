#  Simulation Model Generator
#  Xilinx EDK 9.1.02 EDK_J_SP2.4
#  Copyright (c) 1995-2007 Xilinx, Inc.  All rights reserved.
#
#  File     thread_manager_wave.do (Wed Apr 09 16:49:13 2008)
#
#  Module   thread_manager_wrapper
#  Instance thread_manager
#  Because EDK did not create the testbench, the user
#  specifies the path to the device under test, $tbpath.
#
set binopt {-logic}
set hexopt {-literal -hex}
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}bfm_system" }

  eval add wave -noupdate -divider {"thread_manager"}
# eval add wave -noupdate $binopt $tbpath${ps}thread_manager${ps}OPB_Clk
# eval add wave -noupdate $binopt $tbpath${ps}thread_manager${ps}OPB_Rst
# eval add wave -noupdate $hexopt $tbpath${ps}thread_manager${ps}OPB_ABus
# eval add wave -noupdate $hexopt $tbpath${ps}thread_manager${ps}OPB_BE
# eval add wave -noupdate $hexopt $tbpath${ps}thread_manager${ps}OPB_DBus
# eval add wave -noupdate $binopt $tbpath${ps}thread_manager${ps}OPB_RNW
# eval add wave -noupdate $binopt $tbpath${ps}thread_manager${ps}OPB_select
# eval add wave -noupdate $binopt $tbpath${ps}thread_manager${ps}OPB_seqAddr
  eval add wave -noupdate $hexopt $tbpath${ps}thread_manager${ps}Sln_DBus
  eval add wave -noupdate $binopt $tbpath${ps}thread_manager${ps}Sln_errAck
  eval add wave -noupdate $binopt $tbpath${ps}thread_manager${ps}Sln_retry
  eval add wave -noupdate $binopt $tbpath${ps}thread_manager${ps}Sln_toutSup
  eval add wave -noupdate $binopt $tbpath${ps}thread_manager${ps}Sln_xferAck
# eval add wave -noupdate $binopt $tbpath${ps}thread_manager${ps}Access_Intr
  eval add wave -noupdate $binopt $tbpath${ps}thread_manager${ps}Scheduler_Reset
  eval add wave -noupdate $binopt $tbpath${ps}thread_manager${ps}Scheduler_Reset_Done
# eval add wave -noupdate $binopt $tbpath${ps}thread_manager${ps}Semaphore_Reset
  eval add wave -noupdate $binopt $tbpath${ps}thread_manager${ps}Semaphore_Reset_Done
# eval add wave -noupdate $binopt $tbpath${ps}thread_manager${ps}SpinLock_Reset
  eval add wave -noupdate $binopt $tbpath${ps}thread_manager${ps}SpinLock_Reset_Done
  eval add wave -noupdate $binopt $tbpath${ps}thread_manager${ps}User_IP_Reset
  eval add wave -noupdate $binopt $tbpath${ps}thread_manager${ps}User_IP_Reset_Done
  eval add wave -noupdate $binopt $tbpath${ps}thread_manager${ps}Soft_Stop
  eval add wave -noupdate $hexopt $tbpath${ps}thread_manager${ps}tm2sch_cpu_thread_id
  eval add wave -noupdate $hexopt $tbpath${ps}thread_manager${ps}tm2sch_opcode
  eval add wave -noupdate $hexopt $tbpath${ps}thread_manager${ps}tm2sch_data
  eval add wave -noupdate $binopt $tbpath${ps}thread_manager${ps}tm2sch_request
  eval add wave -noupdate $binopt $tbpath${ps}thread_manager${ps}sch2tm_busy
  eval add wave -noupdate $hexopt $tbpath${ps}thread_manager${ps}sch2tm_data
  eval add wave -noupdate $hexopt $tbpath${ps}thread_manager${ps}sch2tm_next_id
  eval add wave -noupdate $binopt $tbpath${ps}thread_manager${ps}sch2tm_next_id_valid
  eval add wave -noupdate $hexopt $tbpath${ps}thread_manager${ps}tm2sch_DOB
  eval add wave -noupdate $hexopt $tbpath${ps}thread_manager${ps}sch2tm_ADDRB
  eval add wave -noupdate $hexopt $tbpath${ps}thread_manager${ps}sch2tm_DIB
  eval add wave -noupdate $binopt $tbpath${ps}thread_manager${ps}sch2tm_ENB
  eval add wave -noupdate $binopt $tbpath${ps}thread_manager${ps}sch2tm_WEB

