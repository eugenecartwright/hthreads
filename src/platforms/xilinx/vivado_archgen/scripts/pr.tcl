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
#  \file       pr.tcl
#  \brief      Tcl script for adding PR capability to design.
# 
#  \author     Alborz Sadeghian <sadeghia@uark.edu>
# 
#  FIXME: Add description



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
