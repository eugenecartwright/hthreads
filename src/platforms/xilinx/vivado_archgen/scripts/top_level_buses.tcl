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
#  \file       top_level_buses.tcl
#  \brief      Tcl script for creating the top level buses 
# 
#  \author     Alborz Sadeghian <sadeghia@uark.edu>
# 
#  FIXME: Add description

create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:* main_bus
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:* ddr_bus
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:* host_bus

set_property -dict [list CONFIG.NUM_SI [expr $N+1 ]  CONFIG.NUM_MI {3} CONFIG.ENABLE_ADVANCED_OPTIONS {1} CONFIG.XBAR_DATA_WIDTH.VALUE_SRC USER  CONFIG.XBAR_DATA_WIDTH {32} CONFIG.STRATEGY {1}   ]  [get_bd_cells main_bus] 

set_property -dict [list CONFIG.NUM_SI {1} CONFIG.NUM_MI [expr $N +1] CONFIG.ENABLE_ADVANCED_OPTIONS {1} CONFIG.XBAR_DATA_WIDTH.VALUE_SRC USER  CONFIG.XBAR_DATA_WIDTH {32} CONFIG.STRATEGY {1} ]  [get_bd_cells host_bus] 

set_property -dict [list CONFIG.NUM_SI [expr $N+5 ]  CONFIG.NUM_MI {1} CONFIG.ENABLE_ADVANCED_OPTIONS {1} CONFIG.XBAR_DATA_WIDTH.VALUE_SRC USER  CONFIG.XBAR_DATA_WIDTH {32}  ]  [get_bd_cells ddr_bus] 


     create_bd_cell -type ip -vlnv  xilinx.com:ip:axi_interconnect:* dma_bus
     set_property -dict [list CONFIG.NUM_SI [expr $N ] CONFIG.NUM_MI {1} CONFIG.STRATEGY {1} CONFIG.ENABLE_ADVANCED_OPTIONS {1}  CONFIG.XBAR_DATA_WIDTH.VALUE_SRC USER  CONFIG.XBAR_DATA_WIDTH {32}] [get_bd_cells dma_bus]  
     
  
 #If there are only one slave in each group, then there is no intermideate buses. So, create vhwti bus
if  { $C == 1 } \
  {

   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:* vhwti_bus
   set_property -dict [list CONFIG.NUM_SI {2} CONFIG.NUM_MI [expr $N ] CONFIG.ENABLE_ADVANCED_OPTIONS {1} CONFIG.XBAR_DATA_WIDTH.VALUE_SRC USER  CONFIG.XBAR_DATA_WIDTH {32}  CONFIG.STRATEGY {1}]  [get_bd_cells vhwti_bus] 
     
 }

#clk and reset for Top level buses
foreach module [list host_bus  main_bus ddr_bus dma_bus vhwti_bus]\
{
 connect_bd_net -quiet -net [get_bd_nets microblaze_0_Clk] [get_bd_pins $module/aclk] [get_bd_pins mig_7series_0/ui_clk]
 connect_bd_net -quiet [get_bd_pins $module/aresetn] [get_bd_pins rst_mig_7series_0_100M/interconnect_aresetn]
 
 for {set i 0} {$i < 16} {incr i} \
   {
      connect_bd_net  -quiet -net [get_bd_nets microblaze_0_Clk] [get_bd_pins $module/S[format "%02d" [expr $i]]_ACLK] [get_bd_pins mig_7series_0/ui_clk]
      connect_bd_net  -quiet -net [get_bd_nets microblaze_0_Clk] [get_bd_pins $module/M[format "%02d" [expr $i]]_ACLK] [get_bd_pins mig_7series_0/ui_clk]      
      connect_bd_net -quiet [get_bd_pins $module/S[format "%02d" [expr $i]]_ARESETN] [get_bd_pins rst_mig_7series_0_100M/peripheral_aresetn]
      connect_bd_net -quiet [get_bd_pins $module/M[format "%02d" [expr $i]]_ARESETN] [get_bd_pins rst_mig_7series_0_100M/peripheral_aresetn]
   } 
   
}





