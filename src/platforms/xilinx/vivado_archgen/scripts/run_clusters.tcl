#*****************************************************************************************************************
##Host &memory & top level buses
#*****************************************************************************************************************

#number of groups
set N   [lindex $argv 0]
#number of cpus per group
set C   [lindex $argv 1]

set board [lindex $argv 2]
set node hemps_smp

set project_dir ../platforms/N[expr $N]C[ expr $C]$node

if {$board == "kc705"} {
       set part xc7k325tffg900-2
   } elseif {$board == "ac701"} {
      set part xc7a200tfbg676-2
   } elseif {$board == "vc709"} {
       set part xc7vx690tffg1761-2
   } elseif {$board == "zc702"} {
       set part xc7z020clg484-1
   } elseif {$board == "zc706"} {
       set part xc7z045ffg900-2  
   } elseif {$board == "microzed"} {
       set part xc7z010clg400-1
   } elseif {$board == "zed"} {
       set part  xc7z020clg484-1
   } elseif {$board == "vc707"} {
       set part xc7vx485tffg1761-2 
   }    

#Create the project
create_project design $project_dir -part $part
set_property board_part xilinx.com:$board:part0:1.0 [current_project] 


#Add system bd
create_bd_design "system"
create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series:2.1 mig_7series_0
create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:9.3 host


#Run block automation for DDR controller + microblaze
apply_bd_automation -rule xilinx.com:bd_rule:mig_7series -config {Board_Interface "ddr3_sdram" }  [get_bd_cells mig_7series_0] 
apply_bd_automation -rule xilinx.com:bd_rule:microblaze -config {local_mem "64KB" ecc "None" cache "8KB" debug_module "Debug Only" axi_periph "Enabled" axi_intc "0" clk "/mig_7series_0/ui_clk (100 MHz)" }  [get_bd_cells host]
set_property -dict [list CONFIG.C_USE_BARREL {1} CONFIG.C_PVR {2} CONFIG.C_USE_DCACHE {0}]  [get_bd_cells host ] 

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
connect_bd_intf_net [get_bd_intf_pins group_0/slave_0/microblaze_1/DEBUG]                            [get_bd_intf_pins peripherals/mdm_1/MBDEBUG_1]


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
#open_run synth_1 -name netlist_1
#write_checkpoint ../pr/system/N[expr $N]C[ expr $C].dcp


launch_runs impl_1 -to_step write_bitstream -jobs 8 -email_to [list sadeghia@uark.edu dandrews@uark.edu]
wait_on_run  impl_1

exit


