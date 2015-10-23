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
#  \file       connect_groups.tcl
#  \brief      Tcl script for connecting groups of nodes together.
# 
#  \author     Alborz Sadeghian <sadeghia@uark.edu>
# 
#  FIXME: Add description


if  { $C > 1 } \
  {
      for {set i 0} {$i < $N} {incr i} \
      {
         set group group_$i
         set main S[format "%02d" [expr $i+1]]_AXI
         set ddr S[format "%02d" [expr $i+5]]_AXI
         set dma S[format "%02d" [expr $i]]_AXI
         set vhwti_host  M[format "%02d" [expr $i+1]]_AXI
         set vhwti_cores M[format "%02d" [expr $i+1]]_AXI
         connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $group/main_bus/M00_AXI]       [get_bd_intf_pins main_bus/$main]
         connect_bd_intf_net [get_bd_intf_pins $group/ddr_bus/M00_AXI] -boundary_type upper    [get_bd_intf_pins ddr_bus/$ddr]
         connect_bd_intf_net -quiet [get_bd_intf_pins $group/dma_bus/M00_AXI] -boundary_type upper    [get_bd_intf_pins dma_bus/$dma]
         connect_bd_intf_net [get_bd_intf_pins $group/vhwti_bus/S00_AXI] -boundary_type upper [get_bd_intf_pins host_bus/$vhwti_host]
         connect_bd_intf_net [get_bd_intf_pins $group/vhwti_bus/S01_AXI] -boundary_type upper [get_bd_intf_pins hthread_core/core_bus_master/$vhwti_cores]

      }
  } \
else \
{ 
 
   #core&main bus to vhwti bus
   connect_bd_intf_net -boundary_type upper [get_bd_intf_pins hthread_core/core_bus_master/M01_AXI] [get_bd_intf_pins vhwti_bus/S01_AXI]
   connect_bd_intf_net -boundary_type upper [get_bd_intf_pins host_bus/M01_AXI] [get_bd_intf_pins vhwti_bus/S00_AXI]
   for {set i 0} {$i < $N} {incr i} \
      {
         set group group_$i
         set main S[format "%02d" [expr $i+1]]_AXI
         set ddr S[format "%02d" [expr $i+5]]_AXI
         set vhwti  M[format "%02d" [expr $i]]_AXI
         set dma S[format "%02d" [expr $i]]_AXI
         connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $group/slave_0/group1_bus/M00_AXI]       [get_bd_intf_pins main_bus/$main]
         connect_bd_intf_net [get_bd_intf_pins $group/slave_0/microblaze_1/M_AXI_IC] -boundary_type upper    [get_bd_intf_pins ddr_bus/$ddr]
         #connecting vhwti bus
         if { $node == "smp" || $node=="hemps_smp" } { 
               connect_bd_intf_net [get_bd_intf_pins $group/slave_0/global_vhwti_cntrl_[expr $i]/S_AXI]  [get_bd_intf_pins /vhwti_bus/$vhwti]   
         } elseif { $node == "numa" || $node=="hemps_numa"} {
               connect_bd_intf_net [get_bd_intf_pins $group/slave_0/dma_bus/S01_AXI]  [get_bd_intf_pins /vhwti_bus/$vhwti] }
         
         
       
         
         connect_bd_intf_net -quiet [get_bd_intf_pins $group/slave_0/tmp_dma_bus/M00_AXI] -boundary_type upper    [get_bd_intf_pins dma_bus/$dma]
      }
   }   
   

