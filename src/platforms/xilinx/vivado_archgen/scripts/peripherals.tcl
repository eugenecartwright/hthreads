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
#  \file       peripherals.tcl
#  \brief      Tcl script for instantiating various peripherals.
# 
#  \author     Alborz Sadeghian <sadeghia@uark.edu>
# 
#  FIXME: Add description


create_bd_cell -type ip -vlnv xilinx.com:ip:axi_cdma:4.1 central_dma
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_0
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc_0
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 peripheral_interconnect_0

create_bd_cell -type ip -vlnv xilinx.com:ip:prc:1.0 prc_0
create_bd_cell -type ip -vlnv user.org:user:myicap:1.0 myicap_0




group_bd_cells peripherals [get_bd_cells mig_7series_0]  [get_bd_cells rst_mig_7series_0_100M]  [get_bd_cells axi_intc_0]  [get_bd_cells mdm_1]  [get_bd_cells axi_uartlite_0]   [get_bd_cells axi_timer_0]  [get_bd_cells peripheral_interconnect_0]  [get_bd_cells xlconcat_0]  [get_bd_cells central_dma]  [get_bd_cells prc_0]  [get_bd_cells myicap_0] 

#Custmoize IPs
#set_property -dict [list CONFIG.C_MB_DBG_PORTS {2} CONFIG.C_USE_UART {1}]  [get_bd_cells peripherals/mdm_1] 
set_property -dict [list CONFIG.C_MB_DBG_PORTS [expr $N * $C +1 ] CONFIG.C_USE_UART {1} CONFIG.C_DBG_REG_ACCESS {1}]  [get_bd_cells peripherals/mdm_1] 



set_property -dict [list CONFIG.NUM_SI {1}  CONFIG.NUM_MI {6} CONFIG.ENABLE_ADVANCED_OPTIONS {1} CONFIG.XBAR_DATA_WIDTH.VALUE_SRC USER  CONFIG.XBAR_DATA_WIDTH {32} CONFIG.STRATEGY {1} ]  [get_bd_cells peripherals/peripheral_interconnect_0]


set_property -dict [list CONFIG.C_M_AXI_MAX_BURST_LEN {256} CONFIG.C_INCLUDE_SG {0}]  [get_bd_cells peripherals/central_dma] 
set_property -dict [list CONFIG.NUM_PORTS {3}]  [get_bd_cells peripherals/xlconcat_0] 

  

set_property -dict [list CONFIG.ALL_PARAMS {HAS_AXI_LITE_IF 1 RESET_ACTIVE_LEVEL 0 CP_FIFO_DEPTH 2048 CP_FIFO_TYPE blockram CDC_STAGES 2 VS {VS_0 {ID 0 NAME VS_0 RM {RM_0 {ID 0 NAME RM_0 BS {0 {ID 0 ADDR 0 SIZE 0 CLEAR 0}}}} POR_RM RM_0 RMS_ALLOCATED 16 NUM_TRIGGERS_ALLOCATED 16} VS_1 {ID 1 NAME VS_1 RM {} RMS_ALLOCATED 16 NUM_TRIGGERS_ALLOCATED 16} VS_2 {ID 2 NAME VS_2 RM {} RMS_ALLOCATED 16 NUM_TRIGGERS_ALLOCATED 16} VS_3 {ID 3 NAME VS_3 RM {} RMS_ALLOCATED 16 NUM_TRIGGERS_ALLOCATED 16} VS_4 {ID 4 NAME VS_4 RM {} RMS_ALLOCATED 16 NUM_TRIGGERS_ALLOCATED 16} VS_5 {ID 5 NAME VS_5 RM {} RMS_ALLOCATED 16 NUM_TRIGGERS_ALLOCATED 16} VS_6 {ID 6 NAME VS_6 RM {} RMS_ALLOCATED 16 NUM_TRIGGERS_ALLOCATED 16} VS_7 {ID 7 NAME VS_7 RM {} RMS_ALLOCATED 16 NUM_TRIGGERS_ALLOCATED 16} VS_8 {ID 8 NAME VS_8 RM {} RMS_ALLOCATED 16 NUM_TRIGGERS_ALLOCATED 16} VS_9 {ID 9 NAME VS_9 RM {} RMS_ALLOCATED 16 NUM_TRIGGERS_ALLOCATED 16} VS_10 {ID 10 NAME VS_10 RM {} RMS_ALLOCATED 16 NUM_TRIGGERS_ALLOCATED 16} VS_11 {ID 11 NAME VS_11 RM {} RMS_ALLOCATED 16 NUM_TRIGGERS_ALLOCATED 16} VS_12 {ID 12 NAME VS_12 RM {} RMS_ALLOCATED 16 NUM_TRIGGERS_ALLOCATED 16} VS_13 {ID 13 NAME VS_13 RM {} RMS_ALLOCATED 16 NUM_TRIGGERS_ALLOCATED 16} VS_14 {ID 14 NAME VS_14 RM {} RMS_ALLOCATED 16 NUM_TRIGGERS_ALLOCATED 16} VS_15 {ID 15 NAME VS_15 RM {} RMS_ALLOCATED 16 NUM_TRIGGERS_ALLOCATED 16}} CP_FAMILY 7series} CONFIG.GUI_CDC_STAGES {2} CONFIG.GUI_CP_FIFO_DEPTH {2048} CONFIG.GUI_CP_FIFO_TYPE {blockram} CONFIG.GUI_SELECT_VS {9} CONFIG.GUI_VS_NUM_TRIGGERS_ALLOCATED {16} CONFIG.GUI_VS_NUM_RMS_ALLOCATED {16} CONFIG.GUI_VS_POR_RM {-1} CONFIG.GUI_SELECT_RM {-1} CONFIG.GUI_SELECT_TRIGGER_0 {-1} CONFIG.GUI_SELECT_TRIGGER_1 {-1} CONFIG.GUI_SELECT_TRIGGER_2 {-1} CONFIG.GUI_SELECT_TRIGGER_3 {-1}] [get_bd_cells peripherals/prc_0]







set_property -dict [list CONFIG.C_BAUDRATE $uartBaud_rate CONFIG.C_DATA_BITS $uartBits ] [get_bd_cells peripherals/axi_uartlite_0]







#Internal interfaces and connections
apply_bd_automation -rule xilinx.com:bd_rule:board -config {Board_Interface "rs232_uart" }  [get_bd_intf_pins peripherals/axi_uartlite_0/UART] 
apply_bd_automation -rule xilinx.com:bd_rule:board -config {Board_Interface "reset" }  [get_bd_pins peripherals/mig_7series_0/sys_rst] 


connect_bd_intf_net [get_bd_intf_pins ddr_bus/M00_AXI] [get_bd_intf_pins peripherals/mig_7series_0/S_AXI]


connect_bd_intf_net [get_bd_intf_pins peripherals/axi_intc_0/s_axi]  -boundary_type upper [get_bd_intf_pins peripherals/peripheral_interconnect_0/M00_AXI] 
connect_bd_intf_net [get_bd_intf_pins peripherals/axi_timer_0/S_AXI]  -boundary_type upper [get_bd_intf_pins peripherals/peripheral_interconnect_0/M01_AXI] 
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins peripherals/peripheral_interconnect_0/M02_AXI] [get_bd_intf_pins peripherals/prc_0/s_axi_reg]
connect_bd_intf_net  [get_bd_intf_pins peripherals/mdm_1/S_AXI]    -boundary_type upper    [get_bd_intf_pins peripherals/peripheral_interconnect_0/M03_AXI]  
connect_bd_intf_net [get_bd_intf_pins peripherals/axi_uartlite_0/S_AXI]  -boundary_type upper [get_bd_intf_pins peripherals/peripheral_interconnect_0/M04_AXI] 

connect_bd_intf_net -boundary_type upper [get_bd_intf_pins ddr_bus/S00_AXI] [get_bd_intf_pins peripherals/central_dma/M_AXI]
connect_bd_intf_net [get_bd_intf_pins peripherals/prc_0/m_axi_mem] -boundary_type upper [get_bd_intf_pins ddr_bus/S04_AXI]


connect_bd_intf_net [get_bd_intf_pins peripherals/central_dma/S_AXI_LITE]  -boundary_type upper [get_bd_intf_pins peripherals/peripheral_interconnect_0/M05_AXI]
connect_bd_net [get_bd_pins peripherals/axi_timer_0/interrupt]  [get_bd_pins peripherals/xlconcat_0/In0] 
connect_bd_net [get_bd_pins peripherals/axi_intc_0/intr]  [get_bd_pins peripherals/xlconcat_0/dout] 

connect_bd_intf_net [get_bd_intf_pins peripherals/prc_0/ICAP] [get_bd_intf_pins peripherals/myicap_0/icap]
connect_bd_net -net [get_bd_nets peripherals/host_Clk] [get_bd_pins peripherals/myicap_0/clk] [get_bd_pins peripherals/mig_7series_0/ui_clk]



#connect clk and reset
connect_bd_net -net [get_bd_nets peripherals/microblaze_0_Clk] [get_bd_pins peripherals/mdm_1/S_AXI_ACLK] [get_bd_pins peripherals/mig_7series_0/ui_clk]
connect_bd_net [get_bd_pins peripherals/mdm_1/S_AXI_ARESETN] [get_bd_pins peripherals/rst_mig_7series_0_100M/peripheral_aresetn]
connect_bd_net -net [get_bd_nets peripherals/microblaze_0_Clk] [get_bd_pins peripherals/central_dma/s_axi_lite_aclk] [get_bd_pins peripherals/mig_7series_0/ui_clk]
connect_bd_net -net [get_bd_nets peripherals/microblaze_0_Clk] [get_bd_pins peripherals/central_dma/m_axi_aclk] [get_bd_pins peripherals/mig_7series_0/ui_clk]
connect_bd_net -net [get_bd_nets peripherals/rst_mig_7series_0_100M_peripheral_aresetn] [get_bd_pins peripherals/central_dma/s_axi_lite_aresetn] [get_bd_pins peripherals/rst_mig_7series_0_100M/peripheral_aresetn]
connect_bd_net -net [get_bd_nets peripherals/rst_mig_7series_0_100M_peripheral_aresetn] [get_bd_pins peripherals/axi_uartlite_0/s_axi_aresetn] [get_bd_pins peripherals/rst_mig_7series_0_100M/peripheral_aresetn]
connect_bd_net -net [get_bd_nets peripherals/rst_mig_7series_0_100M_peripheral_aresetn] [get_bd_pins peripherals/axi_timer_0/s_axi_aresetn] [get_bd_pins peripherals/rst_mig_7series_0_100M/peripheral_aresetn]
connect_bd_net -net [get_bd_nets peripherals/rst_mig_7series_0_100M_peripheral_aresetn] [get_bd_pins peripherals/axi_intc_0/s_axi_aresetn] [get_bd_pins peripherals/rst_mig_7series_0_100M/peripheral_aresetn]
connect_bd_net -net [get_bd_nets peripherals/rst_mig_7series_0_100M_peripheral_aresetn] [get_bd_pins peripherals/mig_7series_0/aresetn] [get_bd_pins peripherals/rst_mig_7series_0_100M/peripheral_aresetn]
connect_bd_net -net [get_bd_nets peripherals/microblaze_0_Clk] [get_bd_pins peripherals/axi_uartlite_0/s_axi_aclk] [get_bd_pins peripherals/mig_7series_0/ui_clk]

connect_bd_net -net [get_bd_nets peripherals/microblaze_0_Clk] [get_bd_pins peripherals/axi_timer_0/s_axi_aclk] [get_bd_pins peripherals/mig_7series_0/ui_clk]
connect_bd_net -net [get_bd_nets peripherals/microblaze_0_Clk] [get_bd_pins peripherals/axi_intc_0/s_axi_aclk] [get_bd_pins peripherals/mig_7series_0/ui_clk]
connect_bd_net -net [get_bd_nets peripherals/microblaze_0_Clk] [get_bd_pins peripherals/peripheral_interconnect_0/aclk] [get_bd_pins peripherals/mig_7series_0/ui_clk]
connect_bd_net -net [get_bd_nets peripherals/rst_mig_7series_0_100M_interconnect_aresetn] [get_bd_pins peripherals/peripheral_interconnect_0/aresetn] [get_bd_pins peripherals/rst_mig_7series_0_100M/interconnect_aresetn]

connect_bd_net -net [get_bd_nets peripherals/host_Clk] [get_bd_pins peripherals/prc_0/clk] [get_bd_pins peripherals/mig_7series_0/ui_clk]
connect_bd_net -net [get_bd_nets peripherals/host_Clk] [get_bd_pins peripherals/prc_0/icap_clk] [get_bd_pins peripherals/mig_7series_0/ui_clk]
connect_bd_net -net [get_bd_nets peripherals/S00_ARESETN_1] [get_bd_pins peripherals/prc_0/icap_reset] [get_bd_pins peripherals/rst_mig_7series_0_100M/peripheral_aresetn]
connect_bd_net -net [get_bd_nets peripherals/S00_ARESETN_1] [get_bd_pins peripherals/prc_0/reset] [get_bd_pins peripherals/rst_mig_7series_0_100M/peripheral_aresetn]




 for {set i 0} {$i < 16} {incr i} \
     {
      connect_bd_net -quiet -net [get_bd_nets peripherals/microblaze_0_Clk] [get_bd_pins peripherals/peripheral_interconnect_0/S[format "%02d" [expr $i]]_ACLK] [get_bd_pins peripherals/mig_7series_0/ui_clk]
connect_bd_net  -quiet -net [get_bd_nets peripherals/S00_ARESETN_1] [get_bd_pins peripherals/peripheral_interconnect_0/S[format "%02d" [expr $i]]_ARESETN] [get_bd_pins peripherals/rst_mig_7series_0_100M/peripheral_aresetn]
connect_bd_net  -quiet -net [get_bd_nets peripherals/microblaze_0_Clk] [get_bd_pins peripherals/peripheral_interconnect_0/M[format "%02d" [expr $i]]_ACLK] [get_bd_pins peripherals/mig_7series_0/ui_clk]
connect_bd_net  -quiet -net [get_bd_nets peripherals/S00_ARESETN_1] [get_bd_pins peripherals/peripheral_interconnect_0/M[format "%02d" [expr $i]]_ARESETN] [get_bd_pins peripherals/rst_mig_7series_0_100M/peripheral_aresetn]
     } 




startgroup
create_bd_port -dir O -from 0 -to 0 -type rst peripheral_reset
connect_bd_net [get_bd_pins /peripherals/rst_mig_7series_0_100M/peripheral_reset] [get_bd_ports peripheral_reset]
endgroup
startgroup
create_bd_port -dir O -from 0 -to 0 -type rst peripheral_aresetn
connect_bd_net [get_bd_pins /peripherals/rst_mig_7series_0_100M/peripheral_aresetn] [get_bd_ports peripheral_aresetn]
endgroup





