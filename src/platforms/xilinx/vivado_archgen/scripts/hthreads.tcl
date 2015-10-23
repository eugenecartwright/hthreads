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
#  \file       hthreads.tcl
#  \brief      Tcl script for instantiating hthread cores.
# 
#  \author     Alborz Sadeghian <sadeghia@uark.edu>
# 
#  FIXME: Add description

create_bd_cell -type hier hthread_core

create_bd_cell -type ip -vlnv user.org:user:axi_scheduler:1.0 hthread_core/axi_scheduler_0
create_bd_cell -type ip -vlnv user.org:user:axi_cond_vars:1.0 hthread_core/axi_cond_vars_0
create_bd_cell -type ip -vlnv user.org:user:axi_sync_manager:1.0 hthread_core/axi_sync_manager_0
create_bd_cell -type ip -vlnv user.org:user:axi_thread_manager:1.0 hthread_core/axi_thread_manager_0
create_bd_cell -type ip -vlnv user.org:user:axi_hthread_reset_core:1.0 hthread_core/axi_hthread_reset_core_0
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 hthread_core/core_bus_master
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 hthread_core/core_bus_slave


#Customize IPs
set_property -dict [list CONFIG.C_HIGHADDR {0x1117ffff} CONFIG.C_BASEADDR {0x11100000} CONFIG.C_S_AXI_MIN_SIZE {0x0007ffff}] [get_bd_cells hthread_core/axi_cond_vars_0]
set_property -dict [list CONFIG.C_HIGHADDR {0x12FFFFFF} CONFIG.C_BASEADDR {0x12000000}] [get_bd_cells hthread_core/axi_scheduler_0]
set_property -dict [list CONFIG.C_HIGHADDR {0x1400ffff} CONFIG.C_BASEADDR {0x14000000} CONFIG.C_DPHASE_TIMEOUT {0}] [get_bd_cells hthread_core/axi_hthread_reset_core_0]
set_property -dict [list CONFIG.C_HIGHADDR {0x13FFFFFF} CONFIG.C_BASEADDR {0x13000000} CONFIG.C_SCHED_HADDR {0x1103ffff} CONFIG.C_SCHED_BADDR {0x11000000}] [get_bd_cells hthread_core/axi_sync_manager_0]
set_property -dict [list CONFIG.C_HIGHADDR {0x1103ffff} CONFIG.C_BASEADDR {0x11000000}] [get_bd_cells hthread_core/axi_thread_manager_0]



set_property -dict [list CONFIG.NUM_SI {3} CONFIG.NUM_MI [expr $N +1] CONFIG.ENABLE_ADVANCED_OPTIONS {1} CONFIG.XBAR_DATA_WIDTH.VALUE_SRC USER  CONFIG.XBAR_DATA_WIDTH {32}  CONFIG.STRATEGY {1}]  [get_bd_cells hthread_core/core_bus_master] 

set_property -dict [list CONFIG.NUM_SI {2} CONFIG.NUM_MI {5}  CONFIG.ENABLE_ADVANCED_OPTIONS {1} CONFIG.XBAR_DATA_WIDTH.VALUE_SRC USER  CONFIG.XBAR_DATA_WIDTH {32}  CONFIG.STRATEGY {1}]  [get_bd_cells hthread_core/core_bus_slave] 




#Internal connections
connect_bd_intf_net [get_bd_intf_pins hthread_core/axi_sync_manager_0/m_axi_lite]   -boundary_type upper [get_bd_intf_pins hthread_core/core_bus_master/S00_AXI] 
connect_bd_intf_net [get_bd_intf_pins hthread_core/axi_cond_vars_0/m_axi_lite]      -boundary_type upper [get_bd_intf_pins hthread_core/core_bus_master/S01_AXI] 
connect_bd_intf_net [get_bd_intf_pins hthread_core/axi_scheduler_0/m_axi_lite]      -boundary_type upper [get_bd_intf_pins hthread_core/core_bus_master/S02_AXI] 

connect_bd_intf_net [get_bd_intf_pins hthread_core/core_bus_master/M00_AXI] [get_bd_intf_pins hthread_core/core_bus_slave/S00_AXI]


connect_bd_intf_net [get_bd_intf_pins hthread_core/axi_sync_manager_0/S_AXI]        -boundary_type upper [get_bd_intf_pins hthread_core/core_bus_slave/M00_AXI] 
connect_bd_intf_net [get_bd_intf_pins hthread_core/axi_cond_vars_0/S_AXI]           -boundary_type upper [get_bd_intf_pins hthread_core/core_bus_slave/M01_AXI] 
connect_bd_intf_net [get_bd_intf_pins hthread_core/axi_hthread_reset_core_0/S_AXI]  -boundary_type upper [get_bd_intf_pins hthread_core/core_bus_slave/M02_AXI] 
connect_bd_intf_net [get_bd_intf_pins hthread_core/axi_thread_manager_0/S_AXI]      -boundary_type upper [get_bd_intf_pins hthread_core/core_bus_slave/M03_AXI] 
connect_bd_intf_net [get_bd_intf_pins hthread_core/axi_scheduler_0/S_AXI]           -boundary_type upper [get_bd_intf_pins hthread_core/core_bus_slave/M04_AXI] 



connect_bd_net [get_bd_pins hthread_core/axi_sync_manager_0/system_reset]  [get_bd_pins hthread_core/axi_hthread_reset_core_0/reset_port2] 
connect_bd_net [get_bd_pins hthread_core/axi_sync_manager_0/system_resetdone]  [get_bd_pins hthread_core/axi_hthread_reset_core_0/reset_response_port2] 
connect_bd_net [get_bd_pins hthread_core/axi_cond_vars_0/Reset_Done]  [get_bd_pins hthread_core/axi_hthread_reset_core_0/reset_response_port3] 
connect_bd_net [get_bd_pins hthread_core/axi_scheduler_0/Reset_Done]  [get_bd_pins hthread_core/axi_hthread_reset_core_0/reset_response_port0] 
connect_bd_net -net [get_bd_nets hthread_core/axi_scheduler_0_Reset_Done]  [get_bd_pins hthread_core/axi_hthread_reset_core_0/reset_response_port1]  [get_bd_pins hthread_core/axi_scheduler_0/Reset_Done] 
connect_bd_net [get_bd_pins hthread_core/axi_hthread_reset_core_0/reset_port1]  [get_bd_pins hthread_core/axi_scheduler_0/Soft_Reset] 
connect_bd_net [get_bd_pins hthread_core/axi_cond_vars_0/Soft_Reset]  [get_bd_pins hthread_core/axi_hthread_reset_core_0/reset_port3] 
connect_bd_net [get_bd_pins hthread_core/axi_scheduler_0/SWTM_ADDRB]  [get_bd_pins hthread_core/axi_thread_manager_0/sch2tm_ADDRB] 
connect_bd_net [get_bd_pins hthread_core/axi_scheduler_0/SCH2TM_next_tid_valid]  [get_bd_pins hthread_core/axi_thread_manager_0/sch2tm_next_id_valid] 
connect_bd_net [get_bd_pins hthread_core/axi_scheduler_0/SCH2TM_next_cpu_tid]  [get_bd_pins hthread_core/axi_thread_manager_0/sch2tm_next_id] 
connect_bd_net [get_bd_pins hthread_core/axi_scheduler_0/SCH2TM_data]  [get_bd_pins hthread_core/axi_thread_manager_0/sch2tm_data] 
connect_bd_net [get_bd_pins hthread_core/axi_scheduler_0/SCH2TM_busy]  [get_bd_pins hthread_core/axi_thread_manager_0/sch2tm_busy] 
connect_bd_net [get_bd_pins hthread_core/axi_scheduler_0/SWTM_WEB]  [get_bd_pins hthread_core/axi_thread_manager_0/sch2tm_WEB] 
connect_bd_net [get_bd_pins hthread_core/axi_scheduler_0/SWTM_ENB]  [get_bd_pins hthread_core/axi_thread_manager_0/sch2tm_ENB] 
connect_bd_net [get_bd_pins hthread_core/axi_scheduler_0/SWTM_DIB]  [get_bd_pins hthread_core/axi_thread_manager_0/sch2tm_DIB] 
connect_bd_net [get_bd_pins hthread_core/axi_thread_manager_0/Soft_Stop]  [get_bd_pins hthread_core/axi_scheduler_0/Soft_Stop] 
connect_bd_net [get_bd_pins hthread_core/axi_thread_manager_0/tm2sch_cpu_thread_id]  [get_bd_pins hthread_core/axi_scheduler_0/TM2SCH_current_cpu_tid] 
connect_bd_net [get_bd_pins hthread_core/axi_thread_manager_0/tm2sch_opcode]  [get_bd_pins hthread_core/axi_scheduler_0/TM2SCH_opcode] 
connect_bd_net [get_bd_pins hthread_core/axi_thread_manager_0/tm2sch_data]  [get_bd_pins hthread_core/axi_scheduler_0/TM2SCH_data] 
connect_bd_net [get_bd_pins hthread_core/axi_thread_manager_0/tm2sch_request]  [get_bd_pins hthread_core/axi_scheduler_0/TM2SCH_request] 
connect_bd_net [get_bd_pins hthread_core/axi_thread_manager_0/tm2sch_DOB]  [get_bd_pins hthread_core/axi_scheduler_0/SWTM_DOB] 



#connect clk and reset
connect_bd_net [get_bd_pins hthread_core/core_bus_master/aclk] [get_bd_pins ddr_bus/ACLK]
connect_bd_net [get_bd_pins hthread_core/axi_thread_manager_0/S_AXI_ARESETN] [get_bd_pins peripherals/peripheral_aresetn] -boundary_type upper
connect_bd_net [get_bd_pins hthread_core/core_bus_master/aresetn] [get_bd_pins peripherals/interconnect_aresetn] -boundary_type upper


connect_bd_net -net [get_bd_nets hthread_core/aresetn_1] [get_bd_pins hthread_core/aresetn] [get_bd_pins hthread_core/core_bus_slave/aresetn]

connect_bd_net -net [get_bd_nets hthread_core/S_AXI_ARESETN_1] [get_bd_pins hthread_core/S_AXI_ARESETN] [get_bd_pins hthread_core/axi_scheduler_0/S_AXI_ARESETN] 
connect_bd_net -net [get_bd_nets hthread_core/S_AXI_ARESETN_1] [get_bd_pins hthread_core/S_AXI_ARESETN] [get_bd_pins hthread_core/axi_scheduler_0/m_axi_lite_aresetn] 
connect_bd_net -net [get_bd_nets hthread_core/S_AXI_ARESETN_1] [get_bd_pins hthread_core/S_AXI_ARESETN] [get_bd_pins hthread_core/axi_hthread_reset_core_0/S_AXI_ARESETN] 
connect_bd_net -net [get_bd_nets hthread_core/S_AXI_ARESETN_1] [get_bd_pins hthread_core/S_AXI_ARESETN] [get_bd_pins hthread_core/axi_cond_vars_0/S_AXI_ARESETN] 
connect_bd_net -net [get_bd_nets hthread_core/S_AXI_ARESETN_1] [get_bd_pins hthread_core/S_AXI_ARESETN] [get_bd_pins hthread_core/axi_cond_vars_0/m_axi_lite_aresetn] 
connect_bd_net -net [get_bd_nets hthread_core/S_AXI_ARESETN_1] [get_bd_pins hthread_core/S_AXI_ARESETN] [get_bd_pins hthread_core/axi_sync_manager_0/m_axi_lite_aresetn] 
connect_bd_net -net [get_bd_nets hthread_core/S_AXI_ARESETN_1] [get_bd_pins hthread_core/S_AXI_ARESETN] [get_bd_pins hthread_core/axi_sync_manager_0/S_AXI_ARESETN]

connect_bd_net -net [get_bd_nets hthread_core/aclk_1] [get_bd_pins hthread_core/aclk] [get_bd_pins hthread_core/core_bus_slave/aclk]
connect_bd_net -net [get_bd_nets hthread_core/ACLK_1] [get_bd_pins hthread_core/ACLK]  [get_bd_pins hthread_core/axi_scheduler_0/m_axi_lite_aclk] 
connect_bd_net -net [get_bd_nets hthread_core/ACLK_1] [get_bd_pins hthread_core/ACLK]  [get_bd_pins hthread_core/axi_scheduler_0/S_AXI_ACLK] 
connect_bd_net -net [get_bd_nets hthread_core/ACLK_1] [get_bd_pins hthread_core/ACLK]  [get_bd_pins hthread_core/axi_hthread_reset_core_0/S_AXI_ACLK] 
connect_bd_net -net [get_bd_nets hthread_core/ACLK_1] [get_bd_pins hthread_core/ACLK]  [get_bd_pins hthread_core/axi_cond_vars_0/S_AXI_ACLK] 
connect_bd_net -net [get_bd_nets hthread_core/ACLK_1] [get_bd_pins hthread_core/ACLK]  [get_bd_pins hthread_core/axi_cond_vars_0/m_axi_lite_aclk] 
connect_bd_net -net [get_bd_nets hthread_core/ACLK_1] [get_bd_pins hthread_core/ACLK]  [get_bd_pins hthread_core/axi_sync_manager_0/m_axi_lite_aclk] 
connect_bd_net -net [get_bd_nets hthread_core/ACLK_1] [get_bd_pins hthread_core/ACLK] [get_bd_pins hthread_core/axi_thread_manager_0/S_AXI_ACLK]
connect_bd_net -net [get_bd_nets hthread_core/ACLK_1] [get_bd_pins hthread_core/ACLK] [get_bd_pins hthread_core/axi_sync_manager_0/S_AXI_ACLK]

foreach module [list  hthread_core/core_bus_master  hthread_core/core_bus_slave ]\
{
 
 for {set i 0} {$i < 16} {incr i} \
   {
   
     connect_bd_net -quiet -net [get_bd_nets hthread_core/ACLK_1] [get_bd_pins hthread_core/ACLK] [get_bd_pins $module/S[format "%02d" [expr $i]]_ACLK]
     connect_bd_net -quiet -net [get_bd_nets hthread_core/ARESETN_1] [get_bd_pins hthread_core/ARESETN] [get_bd_pins $module/S[format "%02d" [expr $i]]_ARESETN]
      connect_bd_net -quiet -net [get_bd_nets hthread_core/ACLK_1] [get_bd_pins hthread_core/ACLK] [get_bd_pins $module/M[format "%02d" [expr $i]]_ACLK]
     connect_bd_net -quiet -net [get_bd_nets hthread_core/ARESETN_1] [get_bd_pins hthread_core/ARESETN] [get_bd_pins $module/M[format "%02d" [expr $i]]_ARESETN]

      
   } 
   
}
