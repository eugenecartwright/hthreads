#  Simulation Model Generator
#  Xilinx EDK 9.1.02 EDK_J_SP2.4
#  Copyright (c) 1995-2007 Xilinx, Inc.  All rights reserved.
#
#  File     thread_manager_list.do (Wed Apr 09 16:49:13 2008)
#
#  Module   thread_manager_wrapper
#  Instance thread_manager
#  Because EDK did not create the testbench, the user
#  specifies the path to the device under test, $tbpath.
#
set binopt {-bin}
set hexopt {-hex}
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}bfm_system" }

# eval add list $binopt $tbpath${ps}thread_manager${ps}OPB_Clk
# eval add list $binopt $tbpath${ps}thread_manager${ps}OPB_Rst
# eval add list $hexopt $tbpath${ps}thread_manager${ps}OPB_ABus
# eval add list $hexopt $tbpath${ps}thread_manager${ps}OPB_BE
# eval add list $hexopt $tbpath${ps}thread_manager${ps}OPB_DBus
# eval add list $binopt $tbpath${ps}thread_manager${ps}OPB_RNW
# eval add list $binopt $tbpath${ps}thread_manager${ps}OPB_select
# eval add list $binopt $tbpath${ps}thread_manager${ps}OPB_seqAddr
  eval add list $hexopt $tbpath${ps}thread_manager${ps}Sln_DBus
  eval add list $binopt $tbpath${ps}thread_manager${ps}Sln_errAck
  eval add list $binopt $tbpath${ps}thread_manager${ps}Sln_retry
  eval add list $binopt $tbpath${ps}thread_manager${ps}Sln_toutSup
  eval add list $binopt $tbpath${ps}thread_manager${ps}Sln_xferAck
# eval add list $binopt $tbpath${ps}thread_manager${ps}Access_Intr
  eval add list $binopt $tbpath${ps}thread_manager${ps}Scheduler_Reset
  eval add list $binopt $tbpath${ps}thread_manager${ps}Scheduler_Reset_Done
# eval add list $binopt $tbpath${ps}thread_manager${ps}Semaphore_Reset
  eval add list $binopt $tbpath${ps}thread_manager${ps}Semaphore_Reset_Done
# eval add list $binopt $tbpath${ps}thread_manager${ps}SpinLock_Reset
  eval add list $binopt $tbpath${ps}thread_manager${ps}SpinLock_Reset_Done
  eval add list $binopt $tbpath${ps}thread_manager${ps}User_IP_Reset
  eval add list $binopt $tbpath${ps}thread_manager${ps}User_IP_Reset_Done
  eval add list $binopt $tbpath${ps}thread_manager${ps}Soft_Stop
  eval add list $hexopt $tbpath${ps}thread_manager${ps}tm2sch_cpu_thread_id
  eval add list $hexopt $tbpath${ps}thread_manager${ps}tm2sch_opcode
  eval add list $hexopt $tbpath${ps}thread_manager${ps}tm2sch_data
  eval add list $binopt $tbpath${ps}thread_manager${ps}tm2sch_request
  eval add list $binopt $tbpath${ps}thread_manager${ps}sch2tm_busy
  eval add list $hexopt $tbpath${ps}thread_manager${ps}sch2tm_data
  eval add list $hexopt $tbpath${ps}thread_manager${ps}sch2tm_next_id
  eval add list $binopt $tbpath${ps}thread_manager${ps}sch2tm_next_id_valid
  eval add list $hexopt $tbpath${ps}thread_manager${ps}tm2sch_DOB
  eval add list $hexopt $tbpath${ps}thread_manager${ps}sch2tm_ADDRB
  eval add list $hexopt $tbpath${ps}thread_manager${ps}sch2tm_DIB
  eval add list $binopt $tbpath${ps}thread_manager${ps}sch2tm_ENB
  eval add list $binopt $tbpath${ps}thread_manager${ps}sch2tm_WEB

