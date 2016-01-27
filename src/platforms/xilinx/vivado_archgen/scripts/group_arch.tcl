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
#  \file       group_arch.tcl
#  \brief      Tcl script for creating the architecture of a group.
# 
#  \author     Alborz Sadeghian <sadeghia@uark.edu>
# 
#  FIXME: Add description

for {set j 0} {$j < $N} {incr j} \
{
   set group group_$j 
   create_bd_cell -type hier $group
   #create C slaves in each group
   for {set i 0} {$i < $C} {incr i} \
   {   
      if {$node == "smp"} {
            source ./nodes_arch/smp_node.tcl  
      } elseif {$node == "numa"} {
            source ./nodes_arch/numa_node.tcl   
      } elseif {$node == "hemps_smp"} {
            source ./nodes_arch/hemps_smp_node.tcl   
      } elseif {$node == "hemps_numa"} {
           source ./nodes_arch/hemps_numa_node.tcl   
      }    

   }
   
   
  



   #If there are only one slave in each group, then there is no need to create the intermediate buses.
   if  { $C > 1 } \
   {
      #inside group buses & connections
      create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:* $group/vhwti_bus         
      create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:* $group/main_bus
      create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:* $group/ddr_bus

      set_property -dict [list CONFIG.NUM_SI [expr $C ]  CONFIG.NUM_MI {1} CONFIG.ENABLE_ADVANCED_OPTIONS {1} CONFIG.XBAR_DATA_WIDTH.VALUE_SRC USER  CONFIG.XBAR_DATA_WIDTH {32}  CONFIG.STRATEGY {1}]  [get_bd_cells $group/main_bus] 

      set_property -dict [list CONFIG.NUM_SI {2} CONFIG.NUM_MI [expr $C ] CONFIG.ENABLE_ADVANCED_OPTIONS {1} CONFIG.XBAR_DATA_WIDTH.VALUE_SRC USER  CONFIG.XBAR_DATA_WIDTH {32}  CONFIG.STRATEGY {1}]  [get_bd_cells $group/vhwti_bus] 

      set_property -dict [list CONFIG.NUM_SI [expr $C ]  CONFIG.NUM_MI {1} CONFIG.ENABLE_ADVANCED_OPTIONS {1} CONFIG.XBAR_DATA_WIDTH.VALUE_SRC USER  CONFIG.XBAR_DATA_WIDTH {32}  ]  [get_bd_cells $group/ddr_bus] 

      
         create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:* $group/dma_bus
         set_property -dict [list CONFIG.NUM_SI [expr $C ]  CONFIG.NUM_MI {1} CONFIG.ENABLE_ADVANCED_OPTIONS {1} CONFIG.XBAR_DATA_WIDTH.VALUE_SRC USER  CONFIG.XBAR_DATA_WIDTH {32}  ]  [get_bd_cells $group/dma_bus]          
     
      #clk and reset for Top level buses
      foreach module [list vhwti_bus  main_bus ddr_bus dma_bus]\
      {
         connect_bd_net  -quiet -net [get_bd_nets $group/Clk_1] [get_bd_pins $group/Clk] [get_bd_pins $group/$module/aclk] 
         connect_bd_net  -quiet -net [get_bd_nets $group/ARESETN_1] [get_bd_pins $group/ARESETN] [get_bd_pins $group/$module/aresetn]
         for {set i 0} {$i < 16} {incr i} \
         {
           connect_bd_net  -quiet -net [get_bd_nets $group/Clk_1] [get_bd_pins $group/Clk] [get_bd_pins $group/$module/M[format "%02d" [expr $i]]_ACLK]
           connect_bd_net -quiet -net [get_bd_nets $group/s_axi_aresetn_1] [get_bd_pins $group/s_axi_aresetn] [get_bd_pins $group/$module/M[format "%02d" [expr $i]]_ARESETN]
           connect_bd_net  -quiet -net [get_bd_nets $group/Clk_1] [get_bd_pins $group/Clk] [get_bd_pins $group/$module/S[format "%02d" [expr $i]]_ACLK]
           connect_bd_net -quiet -net [get_bd_nets $group/s_axi_aresetn_1] [get_bd_pins $group/s_axi_aresetn] [get_bd_pins $group/$module/S[format "%02d" [expr $i]]_ARESETN]
                   
         } 
       }      
      

      for {set i 0} {$i < $C} {incr i} \
      {
         set slave slave_$i
         set main S[format "%02d" $i]_AXI
         set ddr S[format "%02d" $i]_AXI
         set vhwti M[format "%02d" $i]_AXI
         set dma S[format "%02d" $i]_AXI
         connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $group/$slave/group1_bus/M00_AXI]       [get_bd_intf_pins $group/main_bus/$main]
         connect_bd_intf_net [get_bd_intf_pins $group/$slave/microblaze_1/M_AXI_IC] -boundary_type upper    [get_bd_intf_pins $group/ddr_bus/$ddr]
         if { $node == "smp" || $node=="hemps_smp" } { 
              connect_bd_intf_net [get_bd_intf_pins $group/$slave/global_vhwti_cntrl_[expr $j * $C + $i]/S_AXI] -boundary_type upper [get_bd_intf_pins $group/vhwti_bus/$vhwti]
         } elseif { $node == "numa" || $node=="hemps_numa"} {
              connect_bd_intf_net [get_bd_intf_pins $group/$slave/dma_bus/S01_AXI] -boundary_type upper [get_bd_intf_pins $group/vhwti_bus/$vhwti] }
         
         
         connect_bd_intf_net -quiet [get_bd_intf_pins $group/$slave/tmp_dma_bus/M00_AXI] -boundary_type upper [get_bd_intf_pins $group/dma_bus/$dma]
      }
      
      
   }   

}


