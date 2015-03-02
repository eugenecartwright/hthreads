#---------------------------------------------------------------------------------------------------
#Maybe we just start from here, with start.dcp file + all dcp files for accelerators that users selected.
#In a folder named PR, we will have all these dcp files.
#---------------------------------------------------------------------------------------------------
set N 1
set C 2
open_checkpoint system/N1C2.dcp
set fpga vc707
set list_acc { vector crc }






#---------------------------------------------------------------------------------------------------
#Defining the regions
#---------------------------------------------------------------------------------------------------
 for {set j 0} {$j < 8 } {incr j} \
 { 
    create_pblock pr_[expr $j]
    set_property SNAPPING_MODE ON [get_pblocks pr_[expr $j]]
    set_property RESET_AFTER_RECONFIG 1 [get_pblocks pr_[expr $j]]
}



#FPGA dependent 
   if {$fpga == "vc707"} {
       source  ./vc707.tcl
   } elseif {$fpga == "zedborad"} {
       source ./zedboard.tcl
   } elseif {$fpga == "artix7"} {
      source ./artix7.tcl
   } elseif {$fpga == "zynq7"} {
       source ./zynq7.tcl
   } elseif {$fpga == "kintex7"} {
       source ./kintex7.tcl         
   }    


 for {set j [expr $N * $C]} {$j < 8 } {incr j} \
 { 
    delete_pblock [get_pblocks  pr_[expr $j]]

 }





#---------------------------------------------------------------------------------------------------
#Assigning PR capabilitiy + Pr_region to each accelerator
#---------------------------------------------------------------------------------------------------
 for {set j 0} {$j < $N} {incr j} \
 {     
    for {set i 0} {$i < $C} {incr i} \
    {       
      set_property HD.RECONFIGURABLE 1 [get_cells system_i/group_[expr $j]/slave_[expr $i]/acc_0]
      add_cells_to_pblock  pr_[expr $j * $C + $i] [get_cells [list system_i/group_[expr $j]/slave_[expr $i]/acc_0]] -clear_locs
      update_design -cell system_i/group_[expr $j]/slave_[expr $i]/acc_0 -black_box
    }
 }





#---------------------------------------------------------------------------------------------------
#Implemnting the first configuration#0 
#---------------------------------------------------------------------------------------------------
for {set j 0} {$j < $N} {incr j} \
 {     
    for {set i 0} {$i < $C} {incr i} \
    {   
      read_checkpoint -cell system_i/group_[expr $j]/slave_[expr $i]/acc_0 ./acc/[lindex $list_acc 0].dcp
    }
 }


report_drc -name drc_1
opt_design
place_design 
route_design 
write_checkpoint  -force system_[lindex $list_acc 0].dcp






#---------------------------------------------------------------------------------------------------
#Creating the Static Configuration (static.dcp)
#---------------------------------------------------------------------------------------------------
for {set j 0} {$j < $N} {incr j} \
 {     
    for {set i 0} {$i < $C} {incr i} \
    {   
      update_design -cell system_i/group_[expr $j]/slave_[expr $i]/acc_0 -black_box
    }
 }

lock_design -level routing
write_checkpoint   static.dcp
#write_bmm static_wrapper_bd.bmm add by Mark Feb. 5th
close_project 





#---------------------------------------------------------------------------------------------------
#FCreating the other  Configurations  
#---------------------------------------------------------------------------------------------------
foreach module [lrange $list_acc 1 [llength $list_acc]-1] \
{
   open_checkpoint static.dcp
   for {set j 0} {$j < $N} {incr j} \
    {     
       for {set i 0} {$i < $C} {incr i} \
       {   
         read_checkpoint -cell system_i/group_[expr $j]/slave_[expr $i]/acc_0 ./acc/$module.dcp
       }
    }
   report_drc -name drc_1
   opt_design
   place_design 
   route_design 
   write_checkpoint  -force system_$module.dcp
   close_project 
}






#pr_verify system_vector.dcp system_crc.dcp 
#---------------------------------------------------------------------------------------------------
#For each dcp file, generate the bitstream
#---------------------------------------------------------------------------------------------------
foreach module $list_acc \
{
open_checkpoint system_$module.dcp
write_bitstream -file ./system_$module.bit
close_project 
}



#---------------------------------------------------------------------------------------------------
#scripts to create one big header file  containg all partial bitstreams
#---------------------------------------------------------------------------------------------------

foreach module $list_acc \
{
   for {set j 0} {$j < $N * $C} {incr j} \
    {
       mv system_[expr {$module}]_pr_[expr $j ]_partial.bit [expr {$module}]_[expr $j ].bit
       xxd -i -c 4 [expr {$module}]_[expr $j ].bit  [expr {$module}]_[expr $j ].h
    }
}    

eval exec cat [glob *.h] > partial
cp system_[lindex $list_acc 0].bit full

eval exec rm [glob *.h]
eval exec rm [glob *.bit]
eval exec rm [glob *.*ml]
eval exec rm [glob *.dcp]

mv partial partial_bitstream.h
mv full system_wrapper.bit















