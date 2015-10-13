set N   [lindex $argv 0]
#number of cpus per group
set C   [lindex $argv 1]

set name   [lindex $argv 2]

cd ../platforms/$name

#---------------------------------------------------------------------------------------------------
#creating the blanking configuraiton from static.dcp
#---------------------------------------------------------------------------------------------------
eval exec cp static.dcp blank_static.dcp
open_checkpoint ./blank_static.dcp

for {set j 0} {$j < $N} {incr j} \
    {     
       for {set i 0} {$i < $C} {incr i} \
       {   
         update_design -buffer_ports -cell system_i/group_[expr $j]/slave_[expr $i]/acc_0 
       }
    }

place_design
route_design
write_checkpoint -force ./blank.dcp
write_bitstream  -bin -file ./system_wrapper.bit -force
write_hwdef -file system_wrapper.hwdef
write_bmm  -force  ./system_wrapper.bmm
eval exec mkdir ./design.runs/impl_1
write_sysdef  -force -hwdef ./system_wrapper.hwdef -bitfile ./system_wrapper.bit -meminfo ./system_wrapper.bmm -file  ./design.runs/impl_1/system_wrapper.sysdef
close_project
eval exec rm blank_static.dcp
exit 
