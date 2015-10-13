set N   [lindex $argv 0]
#number of cpus per group
set C   [lindex $argv 1]

set module [lindex $argv 2]

set name   [lindex $argv 3]

cd ../platforms/$name

eval exec cp static.dcp [expr {$module}]_static.dcp


open_checkpoint [expr {$module}]_static.dcp
   for {set j 0} {$j < $N} {incr j} \
    {     
       for {set i 0} {$i < $C} {incr i} \
       {   
         read_checkpoint -cell system_i/group_[expr $j]/slave_[expr $i]/acc_0 ../../pr/acc/$module.dcp
       }
    }
  
   opt_design
   place_design 
   route_design 
   write_checkpoint  -force ./$module.dcp
   write_bitstream  -bin -file ./$module.bit -force
   close_project 
   eval exec rm [expr {$module}]_static.dcp
   exit



