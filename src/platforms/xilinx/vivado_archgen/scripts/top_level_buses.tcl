create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 main_bus
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ddr_bus
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 host_bus

set_property -dict [list CONFIG.NUM_SI [expr $N+1 ]  CONFIG.NUM_MI {3} CONFIG.ENABLE_ADVANCED_OPTIONS {1} CONFIG.XBAR_DATA_WIDTH.VALUE_SRC USER  CONFIG.XBAR_DATA_WIDTH {32} CONFIG.STRATEGY {1}   ]  [get_bd_cells main_bus] 

set_property -dict [list CONFIG.NUM_SI {1} CONFIG.NUM_MI [expr $N +1] CONFIG.ENABLE_ADVANCED_OPTIONS {1} CONFIG.XBAR_DATA_WIDTH.VALUE_SRC USER  CONFIG.XBAR_DATA_WIDTH {32} CONFIG.STRATEGY {1} ]  [get_bd_cells host_bus] 

set_property -dict [list CONFIG.NUM_SI [expr $N+5 ]  CONFIG.NUM_MI {1} CONFIG.ENABLE_ADVANCED_OPTIONS {1} CONFIG.XBAR_DATA_WIDTH.VALUE_SRC USER  CONFIG.XBAR_DATA_WIDTH {32}  ]  [get_bd_cells ddr_bus] 


     create_bd_cell -type ip -vlnv  xilinx.com:ip:axi_interconnect:2.1 dma_bus
     set_property -dict [list CONFIG.NUM_SI [expr $N ] CONFIG.NUM_MI {1} CONFIG.STRATEGY {1} CONFIG.ENABLE_ADVANCED_OPTIONS {1}  CONFIG.XBAR_DATA_WIDTH.VALUE_SRC USER  CONFIG.XBAR_DATA_WIDTH {32}] [get_bd_cells dma_bus]  
     
  
 #If there are only one slave in each group, then there is no intermideate buses. So, create vhwti bus
if  { $C == 1 } \
  {

   create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 vhwti_bus
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





