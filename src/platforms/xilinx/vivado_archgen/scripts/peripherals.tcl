
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_cdma:4.1 central_dma
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_timer:2.0 axi_timer_0
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc_0
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_hwicap:3.0 axi_hwicap_0
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 peripheral_interconnect_0







group_bd_cells peripherals [get_bd_cells mig_7series_0]  [get_bd_cells rst_mig_7series_0_100M]  [get_bd_cells axi_intc_0]  [get_bd_cells mdm_1]  [get_bd_cells axi_uartlite_0]  [get_bd_cells axi_hwicap_0]  [get_bd_cells axi_timer_0]  [get_bd_cells peripheral_interconnect_0]  [get_bd_cells xlconcat_0]  [get_bd_cells central_dma] 

#Custmoize IPs
#set_property -dict [list CONFIG.C_MB_DBG_PORTS {2} CONFIG.C_USE_UART {1}]  [get_bd_cells peripherals/mdm_1] 
set_property -dict [list CONFIG.C_MB_DBG_PORTS [expr $N * $C +1 ] CONFIG.C_USE_UART {1} CONFIG.C_DBG_REG_ACCESS {1}]  [get_bd_cells peripherals/mdm_1] 



set_property -dict [list CONFIG.NUM_SI {1}  CONFIG.NUM_MI {6} CONFIG.ENABLE_ADVANCED_OPTIONS {1} CONFIG.XBAR_DATA_WIDTH.VALUE_SRC USER  CONFIG.XBAR_DATA_WIDTH {32} CONFIG.STRATEGY {1} ]  [get_bd_cells peripherals/peripheral_interconnect_0]


set_property -dict [list CONFIG.C_M_AXI_MAX_BURST_LEN {256} CONFIG.C_INCLUDE_SG {0}]  [get_bd_cells peripherals/central_dma] 
set_property -dict [list CONFIG.NUM_PORTS {3}]  [get_bd_cells peripherals/xlconcat_0] 
set_property -dict [list CONFIG.C_WRITE_FIFO_DEPTH {1024} CONFIG.C_INCLUDE_STARTUP {1}]  [get_bd_cells peripherals/axi_hwicap_0] 


#Internal interfaces and connections
apply_bd_automation -rule xilinx.com:bd_rule:board -config {Board_Interface "rs232_uart" }  [get_bd_intf_pins peripherals/axi_uartlite_0/UART] 
apply_bd_automation -rule xilinx.com:bd_rule:board -config {Board_Interface "reset" }  [get_bd_pins peripherals/mig_7series_0/sys_rst] 


connect_bd_intf_net [get_bd_intf_pins ddr_bus/M00_AXI] [get_bd_intf_pins peripherals/mig_7series_0/S_AXI]


connect_bd_intf_net [get_bd_intf_pins peripherals/axi_intc_0/s_axi]  -boundary_type upper [get_bd_intf_pins peripherals/peripheral_interconnect_0/M00_AXI] 
connect_bd_intf_net [get_bd_intf_pins peripherals/axi_timer_0/S_AXI]  -boundary_type upper [get_bd_intf_pins peripherals/peripheral_interconnect_0/M01_AXI] 
connect_bd_intf_net [get_bd_intf_pins peripherals/axi_hwicap_0/S_AXI_LITE]  -boundary_type upper [get_bd_intf_pins peripherals/peripheral_interconnect_0/M02_AXI] 
connect_bd_intf_net  [get_bd_intf_pins peripherals/mdm_1/S_AXI]    -boundary_type upper    [get_bd_intf_pins peripherals/peripheral_interconnect_0/M03_AXI]  
connect_bd_intf_net [get_bd_intf_pins peripherals/axi_uartlite_0/S_AXI]  -boundary_type upper [get_bd_intf_pins peripherals/peripheral_interconnect_0/M04_AXI] 

connect_bd_intf_net -boundary_type upper [get_bd_intf_pins ddr_bus/S00_AXI] [get_bd_intf_pins peripherals/central_dma/M_AXI]


connect_bd_intf_net [get_bd_intf_pins peripherals/central_dma/S_AXI_LITE]  -boundary_type upper [get_bd_intf_pins peripherals/peripheral_interconnect_0/M05_AXI]
connect_bd_net [get_bd_pins peripherals/axi_timer_0/interrupt]  [get_bd_pins peripherals/xlconcat_0/In0] 
connect_bd_net [get_bd_pins peripherals/axi_intc_0/intr]  [get_bd_pins peripherals/xlconcat_0/dout] 


#connect clk and reset
connect_bd_net -net [get_bd_nets peripherals/microblaze_0_Clk] [get_bd_pins peripherals/mdm_1/S_AXI_ACLK] [get_bd_pins peripherals/mig_7series_0/ui_clk]
connect_bd_net [get_bd_pins peripherals/mdm_1/S_AXI_ARESETN] [get_bd_pins peripherals/rst_mig_7series_0_100M/peripheral_aresetn]
connect_bd_net -net [get_bd_nets peripherals/microblaze_0_Clk] [get_bd_pins peripherals/central_dma/s_axi_lite_aclk] [get_bd_pins peripherals/mig_7series_0/ui_clk]
connect_bd_net -net [get_bd_nets peripherals/microblaze_0_Clk] [get_bd_pins peripherals/central_dma/m_axi_aclk] [get_bd_pins peripherals/mig_7series_0/ui_clk]
connect_bd_net -net [get_bd_nets peripherals/rst_mig_7series_0_100M_peripheral_aresetn] [get_bd_pins peripherals/central_dma/s_axi_lite_aresetn] [get_bd_pins peripherals/rst_mig_7series_0_100M/peripheral_aresetn]
connect_bd_net -net [get_bd_nets peripherals/rst_mig_7series_0_100M_peripheral_aresetn] [get_bd_pins peripherals/axi_uartlite_0/s_axi_aresetn] [get_bd_pins peripherals/rst_mig_7series_0_100M/peripheral_aresetn]
connect_bd_net -net [get_bd_nets peripherals/rst_mig_7series_0_100M_peripheral_aresetn] [get_bd_pins peripherals/axi_hwicap_0/s_axi_aresetn] [get_bd_pins peripherals/rst_mig_7series_0_100M/peripheral_aresetn]
connect_bd_net -net [get_bd_nets peripherals/rst_mig_7series_0_100M_peripheral_aresetn] [get_bd_pins peripherals/axi_timer_0/s_axi_aresetn] [get_bd_pins peripherals/rst_mig_7series_0_100M/peripheral_aresetn]
connect_bd_net -net [get_bd_nets peripherals/rst_mig_7series_0_100M_peripheral_aresetn] [get_bd_pins peripherals/axi_intc_0/s_axi_aresetn] [get_bd_pins peripherals/rst_mig_7series_0_100M/peripheral_aresetn]
connect_bd_net -net [get_bd_nets peripherals/rst_mig_7series_0_100M_peripheral_aresetn] [get_bd_pins peripherals/mig_7series_0/aresetn] [get_bd_pins peripherals/rst_mig_7series_0_100M/peripheral_aresetn]
connect_bd_net -net [get_bd_nets peripherals/microblaze_0_Clk] [get_bd_pins peripherals/axi_uartlite_0/s_axi_aclk] [get_bd_pins peripherals/mig_7series_0/ui_clk]
connect_bd_net -net [get_bd_nets peripherals/microblaze_0_Clk] [get_bd_pins peripherals/axi_hwicap_0/s_axi_aclk] [get_bd_pins peripherals/mig_7series_0/ui_clk]
connect_bd_net -net [get_bd_nets peripherals/microblaze_0_Clk] [get_bd_pins peripherals/axi_hwicap_0/icap_clk] [get_bd_pins peripherals/mig_7series_0/ui_clk]
connect_bd_net -net [get_bd_nets peripherals/microblaze_0_Clk] [get_bd_pins peripherals/axi_timer_0/s_axi_aclk] [get_bd_pins peripherals/mig_7series_0/ui_clk]
connect_bd_net -net [get_bd_nets peripherals/microblaze_0_Clk] [get_bd_pins peripherals/axi_intc_0/s_axi_aclk] [get_bd_pins peripherals/mig_7series_0/ui_clk]
connect_bd_net -net [get_bd_nets peripherals/microblaze_0_Clk] [get_bd_pins peripherals/peripheral_interconnect_0/aclk] [get_bd_pins peripherals/mig_7series_0/ui_clk]
connect_bd_net -net [get_bd_nets peripherals/rst_mig_7series_0_100M_interconnect_aresetn] [get_bd_pins peripherals/peripheral_interconnect_0/aresetn] [get_bd_pins peripherals/rst_mig_7series_0_100M/interconnect_aresetn]




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

