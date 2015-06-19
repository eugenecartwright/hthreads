#  Simulation Model Generator
#  Xilinx EDK 9.1.02 EDK_J_SP2.4
#  Copyright (c) 1995-2007 Xilinx, Inc.  All rights reserved.
#
#  File     bfm_system_list.do (Wed Apr 09 16:49:13 2008)
#
#  List Window DO Script File
#
#  List Window DO script files setup the ModelSim List window
#  display for viewing results of the simulation in a tabular
#  format. Comment or uncomment commands to change the set of
#  data values viewed.
#
echo  "Setting up List window display ..."

if { ![info exists xcmdc] } {echo "Warning : c compile command was not run"}
if { ![info exists xcmds] } {echo "Warning : s simulate command was not run"}

onerror { resume }

#  Because EDK did not create the testbench, the user
#  specifies the path to the device under test, $tbpath.
#
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}bfm_system" }

#
#  Display top-level ports
#
set binopt {-bin}
set hexopt {-hex}
eval add list $binopt $tbpath${ps}sys_reset
eval add list $binopt $tbpath${ps}sys_clk

#
#  Display bus signal ports
#
do plb_bus_list.do

do opb_list.do

#
#  Display processor ports
#
#
#  Display processor registers
#

#
#  Display IP and peripheral ports
#
do bfm_processor_list.do

do bfm_memory_list.do

do bfm_monitor_list.do

do synch_bus_list.do

do plb2opb_list.do

do opb2plb_list.do

do thread_manager_list.do

do scheduler_list.do

do synch_manager_list.do

do cond_vars_list.do

do my_core_list.do


#  List window configuration information
#
configure list -delta                 none
configure list -usesignaltriggers     0

#  Define the simulation strobe and period, if used.

configure list -usestrobe             0
configure list -strobestart           {0 ps}  -strobeperiod {0 ps}

configure list -usegating             1
configure list -gateexpr              $tbpath${ps}sys_clk'rising

#  List window setup complete
#
echo  "List window display setup done."
