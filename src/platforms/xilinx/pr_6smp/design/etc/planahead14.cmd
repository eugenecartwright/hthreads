create_project project_1 . -part xc6vlx240tff1156-1
set_property design_mode GateLvl [current_fileset]
add_files -norecurse /home/abazar63/hthread/src/platforms/xilinx/pr_6smp/design/implementation/system.ngc
import_files -force -norecurse
import_files -fileset constrs_1 -force -norecurse /home/abazar63/hthread/src/platforms/xilinx/pr_6smp/design/implementation/system.ucf
set_property name config_1 [current_run]
set_property is_partial_reconfig true [current_project]
link_design -name netlist_1

-bm /home/abazar63/hthread/src/platforms/xilinx/pr_6smp/design/implementation/system.bmm -uc /home/abazar63/hthread/src/platforms/xilinx/pr_6smp/design/data/system.ucf

create_reconfig_module -name vector -cell {hw_acc_1}
save_design
create_reconfig_module -name vector -cell {hw_acc_2}
save_design
create_reconfig_module -name vector -cell {hw_acc_3}
save_design
create_reconfig_module -name vector -cell {hw_acc_4}
save_design
create_reconfig_module -name vector -cell {hw_acc_5}
save_design
create_reconfig_module -name vector -cell {hw_acc_6}
save_design




create_reconfig_module -name sort -cell {hw_acc_1}
set_property edif_top_file /home/abazar63/hthread/src/platforms/xilinx/pr_6smp/design/p14/sort.ngc [get_filesets hw_acc_1#sort]

create_reconfig_module -name sort -cell {hw_acc_2}
set_property edif_top_file /home/abazar63/hthread/src/platforms/xilinx/pr_6smp/design/p14/sort.ngc [get_filesets hw_acc_2#sort]

create_reconfig_module -name sort -cell {hw_acc_3}
set_property edif_top_file /home/abazar63/hthread/src/platforms/xilinx/pr_6smp/design/p14/sort.ngc [get_filesets hw_acc_3#sort]

create_reconfig_module -name sort -cell {hw_acc_4}
set_property edif_top_file /home/abazar63/hthread/src/platforms/xilinx/pr_6smp/design/p14/sort.ngc [get_filesets hw_acc_4#sort]

create_reconfig_module -name sort -cell {hw_acc_5}
set_property edif_top_file /home/abazar63/hthread/src/platforms/xilinx/pr_6smp/design/p14/sort.ngc [get_filesets hw_acc_5#sort]

create_reconfig_module -name sort -cell {hw_acc_6}
set_property edif_top_file /home/abazar63/hthread/src/platforms/xilinx/pr_6smp/design/p14/sort.ngc [get_filesets hw_acc_6#sort]



create_reconfig_module -name crc -cell {hw_acc_1}
set_property edif_top_file /home/abazar63/hthread/src/platforms/xilinx/pr_6smp/design/p14/crc.ngc [get_filesets hw_acc_1#crc]

create_reconfig_module -name crc -cell {hw_acc_2}
set_property edif_top_file /home/abazar63/hthread/src/platforms/xilinx/pr_6smp/design/p14/crc.ngc [get_filesets hw_acc_2#crc]

create_reconfig_module -name crc -cell {hw_acc_3}
set_property edif_top_file /home/abazar63/hthread/src/platforms/xilinx/pr_6smp/design/p14/crc.ngc [get_filesets hw_acc_3#crc]

create_reconfig_module -name crc -cell {hw_acc_4}
set_property edif_top_file /home/abazar63/hthread/src/platforms/xilinx/pr_6smp/design/p14/crc.ngc [get_filesets hw_acc_4#crc]

create_reconfig_module -name crc -cell {hw_acc_5}
set_property edif_top_file /home/abazar63/hthread/src/platforms/xilinx/pr_6smp/design/p14/crc.ngc [get_filesets hw_acc_5#crc]

create_reconfig_module -name crc -cell {hw_acc_6}
set_property edif_top_file /home/abazar63/hthread/src/platforms/xilinx/pr_6smp/design/p14/crc.ngc [get_filesets hw_acc_6#crc]




launch_runs config_1 -to_step Bitgen








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




