#---------------------------------------------------------------------------------------------------
#Maybe we just start from here, with start.dcp file + all dcp files for accelerators that users selected.
#In a folder named PR, we will have all these dcp files.
#---------------------------------------------------------------------------------------------------
#set list_acc { crc bubblesort vectoradd vectormul matrix_mul  }

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

#report_drc -name drc_1
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

exit
