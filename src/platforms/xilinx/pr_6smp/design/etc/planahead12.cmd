create_project planahead12 /home/abazar63/hthread/src/platforms/xilinx/pr_6smp/design/planahead12 -part xc6vlx240tff1156-1
set_property design_mode GateLvl [get_property srcset [current_run]]
set_property edif_top_file /home/abazar63/hthread/src/platforms/xilinx/pr_6smp/design/implementation/system.ngc [get_property srcset [current_run]]
import_files -force -norecurse /home/abazar63/hthread/src/platforms/xilinx/pr_6smp/design/implementation
import_files -fileset [get_property constrset [current_run]] -force -norecurse /home/abazar63/hthread/src/platforms/xilinx/pr_6smp/design/implementation/system.ucf
set_property target_ucf /home/abazar63/hthread/src/platforms/xilinx/pr_6smp/design/planahead12/planahead12.srcs/constrs_1/imports/system.ucf [get_property constrset [current_run]]
set_property name config_1 [current_run]
set_property is_partial_reconfig true [current_project]
open_netlist_design -name netlist_1

add_reconfig_module -name vector -cell {hw_acc_1}
save_design
add_reconfig_module -name vector -cell {hw_acc_2}

save_design

add_reconfig_module -name vector -cell {hw_acc_3}

save_design

add_reconfig_module -name vector -cell {hw_acc_4}

save_design

add_reconfig_module -name vector -cell {hw_acc_5}

save_design

add_reconfig_module -name vector -cell {hw_acc_6}

save_design

add_reconfig_module -name {crc} -cell {hw_acc_1} -file {/home/abazar63/hthread/src/platforms/xilinx/pr_6smp/design/netlist/crc.ngc}

promote_run -run {config_2} -partition_names {  {hw_acc_1} {hw_acc_2} {hw_acc_3} {hw_acc_4} {hw_acc_5} {hw_acc_6} }
launch_runs -runs config_3 -jobs 2 -dir /home/abazar63/hthread/src/platforms/xilinx/pr_6smp/design/planahead12/planahead12.runs


verify_config -runs {  {config_1} {config_2} {config_3} } -file {/home/abazar63/pr_verify.log}


set_property add_step Bitgen [get_runs config_1]
launch_runs -runs config_1 -jobs 2 -dir /home/abazar63/hthread/src/platforms/xilinx/pr_6smp/design/planahead12/planahead12.runs




resize_pblock pblock_hw_acc_1 -add {SLICE_X16Y202:SLICE_X23Y219 DSP48_X1Y82:DSP48_X1Y87} -locs keep_all -replace
save_constraints
resize_pblock pblock_hw_acc_2 -add {SLICE_X16Y162:SLICE_X23Y179 DSP48_X1Y66:DSP48_X1Y71} -locs keep_all -replace
save_constraints
resize_pblock pblock_hw_acc_3 -add {SLICE_X16Y122:SLICE_X23Y139 DSP48_X1Y50:DSP48_X1Y55} -locs keep_all -replace
save_constraints
resize_pblock pblock_hw_acc_4 -add {SLICE_X16Y82:SLICE_X23Y99 DSP48_X1Y34:DSP48_X1Y39} -locs keep_all -replace
save_constraints
resize_pblock pblock_hw_acc_5 -add {SLICE_X16Y42:SLICE_X23Y59 DSP48_X1Y18:DSP48_X1Y23} -locs keep_all -replace
save_constraints
resize_pblock pblock_hw_acc_6 -add {SLICE_X16Y2:SLICE_X23Y19 DSP48_X1Y2:DSP48_X1Y7} -locs keep_all -replace
save_constraints

