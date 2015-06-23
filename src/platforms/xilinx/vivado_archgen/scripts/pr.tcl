#---------------------------------------------------------------------------------------------------
#Maybe we just start from here, with start.dcp file + all dcp files for accelerators that users selected.
#In a folder named PR, we will have all these dcp files.
#---------------------------------------------------------------------------------------------------
set list_acc { crc  bubblesort vectoradd vectormul mm  }


#---------------------------------------------------------------------------------------------------
#Defining the regions
#---------------------------------------------------------------------------------------------------

#boarddependent 
   if {$board== "vc707"} {
       source  ./vc707.tcl
   } elseif {$board== "zedborad"} {
       source ./zedboard.tcl
   } elseif {$board== "artix7"} {
      source ./artix7.tcl
   } elseif {$board== "zynq7"} {
       source ./zynq7.tcl
   } elseif {$board== "kintex7"} {
       source ./kintex7.tcl         
   }    


cd $project_dir
#---------------------------------------------------------------------------------------------------
#Assigning PR capabilitiy + Pr_region to each accelerator and Implemnting the first configuration#0 
#---------------------------------------------------------------------------------------------------
 for {set j 0} {$j < $N} {incr j} \
 {     
    for {set i 0} {$i < $C} {incr i} \
    {       
      set_property HD.RECONFIGURABLE 1 [get_cells system_i/group_[expr $j]/slave_[expr $i]/acc_0]
      
      set tmp pr_[expr $j * $C + $i]
      set tmploc pr_rect[expr $j * $C + $i]
      startgroup
      create_pblock $tmp
      resize_pblock $tmp -add [set $tmploc] 
      add_cells_to_pblock  $tmp [get_cells [list system_i/group_[expr $j]/slave_[expr $i]/acc_0]] -clear_locs
      set_property RESET_AFTER_RECONFIG 1 [get_pblocks $tmp]
      set_property SNAPPING_MODE ON [get_pblocks $tmp]
      endgroup

    }
 }

report_drc -name drc_1
opt_design
place_design 
route_design 
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
write_checkpoint -force  ./static.dcp
write_bitstream   -file ./system_wrapper.bit
write_hwdef -file system_wrapper.hwdef
write_bmm  -force  ./system_wrapper.bmm
eval exec mkdir ./design.runs/impl_1
write_sysdef  -force -hwdef ./system_wrapper.hwdef -bitfile ./system_wrapper.bit -meminfo ./system_wrapper.bmm -file  ./design.runs/impl_1/system_wrapper.sysdef
close_project 



#---------------------------------------------------------------------------------------------------
#FCreating the other  Configurations  
#---------------------------------------------------------------------------------------------------
#foreach module [lrange $list_acc 1 [llength $list_acc]-1] 
foreach module $list_acc \
{
   open_checkpoint ./static.dcp
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
   write_bitstream -file ./$module.bit
   close_project 
}


#pr_verify system_vector.dcp system_crc.dcp 

#---------------------------------------------------------------------------------------------------
#scripts to create one big header file  containg all partial bitstreams
#---------------------------------------------------------------------------------------------------

foreach module $list_acc \
{
   for {set j 0} {$j < $N * $C} {incr j} \
    {
       mv [expr {$module}]_pr_[expr $j ]_partial.bit [expr {$module}]_[expr $j ].bit
       xxd -i -c 4 [expr {$module}]_[expr $j ].bit  [expr {$module}]_[expr $j ].h
    }
}    

eval exec cat [glob ./*.h] > ./partial
eval exec rm [glob ./*.h]
eval exec rm [glob ./*.bit]
eval exec rm [glob ./*.dcp]
mv ./partial ./bitstream.h
cd ../../scripts/

