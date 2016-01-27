#************************************************************************************
# Copyright (c) 2015, University of Arkansas - Hybridthreads Group
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
#     * Redistributions of source code must retain the above copyright notice,
#       this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright notice,
#       this list of conditions and the following disclaimer in the documentation
#       and/or other materials provided with the distribution.
#     * Neither the name of the University of Arkansas nor the name of the
#       Hybridthreads Group nor the names of its contributors may be used to
#       endorse or promote products derived from this software without specific
#       prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#***********************************************************************************/

#  \internal
#  \file       run_clusters.tcl
#  \brief      Tcl script for .....
# 
#  \author     Alborz Sadeghian <sadeghia@uark.edu>
# 
#  FIXME: Add description

#*****************************************************************************************************************
##Host &memory & top level buses
#*****************************************************************************************************************
set N             [lindex $argv 0]   
set C             [lindex $argv 1]   
set board         [lindex $argv 2]
set part          [lindex $argv 3]
set name          [lindex $argv 4]
set PR            [lindex $argv 5]
set bram_size     [lindex $argv 6]
set uartBaud_rate [lindex $argv 7]
set uartBits      [lindex $argv 8]
set uartParity    [lindex $argv 9]
set hostBS     [lindex $argv 10]
set hostMul    [lindex $argv 11]
set hostDiv    [lindex $argv 12]
set hostFPU    [lindex $argv 13]
set hostPCMP   [lindex $argv 14]
set hostICache [lindex $argv 15]

set slaves {}
for {set i 0} {$i< $N*$C} {incr i} {
    set fields [split [lindex $argv [expr $i+16 ]] "-" ]
    lappend slaves $fields
}


set node hemps_smp

set project_dir ../platforms/$name


#Create the project
create_project design $project_dir -part $part
if { $board == "zed"} \
{
set_property board_part em.avnet.com:$board:part0:1.3 [current_project] 
} \
else \
{
#set_property board_part xilinx.com:$board:part0:1.0 [current_project] 
set_property board_part xilinx.com:$board:part0:1.2 [current_project] 
}


#Add system bd
create_bd_design "system"

create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series:* mig_7series_0
create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:* host


#Run block automation for DDR controller + microblaze
# TODO: Doesn't work with Zedboard - Eugene
apply_bd_automation -rule xilinx.com:bd_rule:mig_7series -config {Board_Interface "ddr3_sdram" }  [get_bd_cells mig_7series_0] 
apply_bd_automation -rule xilinx.com:bd_rule:microblaze -config {local_mem "64KB" ecc "None" cache "8KB" debug_module "Debug Only" axi_periph "Enabled" axi_intc "0" clk "/mig_7series_0/ui_clk (100 MHz)" }  [get_bd_cells host]
set_property -dict [list   CONFIG.C_USE_PCMP_INSTR $hostPCMP    CONFIG.C_USE_BARREL $hostBS  CONFIG.C_USE_DIV $hostDiv CONFIG.C_USE_HW_MUL $hostMul CONFIG.C_USE_FPU $hostFPU       CONFIG.C_PVR {2} CONFIG.C_USE_DCACHE {0} CONFIG.C_CACHE_BYTE_SIZE $hostICache ]  [get_bd_cells host ] 



#set_property ip_repo_paths  { $ip_rep_path }  [current_fileset] 

set_property ip_repo_paths  {../../../../../src/hardware/MyRepository/pcores/axi_hthread_cores/ ../../../../../src/hardware/MyRepository/pcores/vivado_cores } [current_fileset]
update_ip_catalog


##=====================================================================
#Top level buses
##=====================================================================
source ./top_level_buses.tcl


##=====================================================================
##Peripherals
##=====================================================================
source ./peripherals.tcl



##=====================================================================
##Hthread_cores
##=====================================================================
source ./hthreads.tcl




##=====================================================================
##Creates  G groups. each group has C slaves in it.
##=====================================================================
source ./group_arch.tcl



##=====================================================================
##External Connections between blocks
##=====================================================================

#interrupt connections from Hthread cores
connect_bd_net [get_bd_pins /peripherals/xlconcat_0/In2] [get_bd_pins /hthread_core/axi_thread_manager_0/Access_Intr]
connect_bd_net [get_bd_pins /peripherals/xlconcat_0/In1]  [get_bd_pins /hthread_core/axi_scheduler_0/Preemption_Interrupt]
connect_bd_intf_net [get_bd_intf_pins peripherals/axi_intc_0/interrupt]  [get_bd_intf_pins host/INTERRUPT] 

for {set j 0} {$j < $N} {incr j} \
   {   
   for {set i 0} {$i < $C} {incr i} \
   {
      set group group_$j 
      set slave slave_$i      
      connect_bd_intf_net [get_bd_intf_pins $group/$slave/microblaze_1/DEBUG]   [get_bd_intf_pins peripherals/mdm_1/MBDEBUG_[expr $j * $C + $i +1]]     
   }
   }





# Host to DDr and host_bus
connect_bd_intf_net [get_bd_intf_pins host/M_AXI_DP] [get_bd_intf_pins host_bus/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins host/M_AXI_IC] [get_bd_intf_pins ddr_bus/S02_AXI]
connect_bd_intf_net [get_bd_intf_pins host_bus/M00_AXI] [get_bd_intf_pins main_bus/S00_AXI]


#DMA bus to DDR bus
connect_bd_intf_net  -quiet -boundary_type upper [get_bd_intf_pins dma_bus/M00_AXI] [get_bd_intf_pins ddr_bus/S01_AXI]



#Main bus to peripherals
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins main_bus/M00_AXI] [get_bd_intf_pins peripherals/peripheral_interconnect_0/S00_AXI]
#Main bus to DDR bus.
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins main_bus/M01_AXI] [get_bd_intf_pins  ddr_bus/S03_AXI]
#Main bus to hthread cores
connect_bd_intf_net [get_bd_intf_pins hthread_core/core_bus_slave/S01_AXI] [get_bd_intf_pins main_bus/M02_AXI]



#Slaves AXI interfaces to the rest of the system.
source ./connect_groups.tcl


  

delete_bd_objs [get_bd_ports peripheral_aresetn]
delete_bd_objs [get_bd_ports peripheral_reset]

##=====================================================================
##Create Addresses
##=====================================================================
source ./assign_address.tcl



##=====================================================================
##Generate bitstream
##=====================================================================
save_bd_design 
validate_bd_design  
reset_target all [get_files     ./$project_dir/design.srcs/sources_1/bd/system/system.bd]   
generate_target all [get_files  ./$project_dir/design.srcs/sources_1/bd/system/system.bd] 
make_wrapper -files [get_files  ./$project_dir/design.srcs/sources_1/bd/system/system.bd]  -top
add_files -norecurse ./$project_dir/design.srcs/sources_1/bd/system/hdl/system_wrapper.v
update_compile_order -fileset sources_1
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

#For reducing Negative slack for big systems.
#if  {  ( ($HEMPS==1)&& ([expr $N * $C]>12) ) || ([expr $N * $C]>36) } 
if  {  ([expr $N * $C]>12) } \
{
  set_property strategy Performance_ExploreSLLs [get_runs impl_1]
  set_property STEPS.POST_ROUTE_PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
}
reset_run synth_1

#Writing the DCP file for PR flow
launch_runs synth_1 -jobs 8
wait_on_run  synth_1

if { $PR == "y"} \
{
open_run synth_1 -name netlist_1
write_checkpoint $project_dir/$name.dcp
close_project
open_checkpoint  $project_dir/$name.dcp
source ./pr.tcl
}\
else \
{
launch_runs impl_1 -to_step route_design -jobs 8 
wait_on_run  impl_1
open_run impl_1

write_hwdef -file ./$project_dir/system_wrapper.hwdef
write_bmm  -force  ./$project_dir/system_wrapper.bmm
write_bitstream   -file ./$project_dir/system_wrapper.bit

write_sysdef  -force -hwdef ./$project_dir/system_wrapper.hwdef -bitfile ./$project_dir/system_wrapper.bit -meminfo ./$project_dir/system_wrapper.bmm -file  ./$project_dir/design.runs/impl_1/system_wrapper.sysdef

exit
}
