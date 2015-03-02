set slave $group/slave_$i
 
create_bd_cell -type hier $slave

create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:9.3 $slave/microblaze_1
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 $slave/global_vhwti_cntrl_[expr $j * $C + $i]
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 $slave/local_vhwti_cntrl
create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.2 $slave/blk_mem_gen_0
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 $slave/group1_bus
copy_bd_objs $slave  [get_bd_cells {host_local_memory}] 
set_property name microblaze_0_local_memory [get_bd_cells $slave/host_local_memory]

create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 $slave/dma_bus
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_cdma:4.1 $slave/local_dma
create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.2 $slave/blk_mem_a
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 $slave/axi_bram_ctrl_a_mb
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 $slave/axi_bram_ctrl_a_dma_bus


set_property -dict [list CONFIG.NUM_SI {1}  CONFIG.NUM_MI {4} CONFIG.ENABLE_ADVANCED_OPTIONS {1} CONFIG.XBAR_DATA_WIDTH.VALUE_SRC USER  CONFIG.XBAR_DATA_WIDTH {32}  CONFIG.STRATEGY {1}]  [get_bd_cells $slave/group1_bus] 


set_property -dict [list CONFIG.C_D_AXI {1} CONFIG.C_USE_BARREL {1} CONFIG.C_PVR {2} CONFIG.C_PVR_USER2 {0xC0000000}  CONFIG.C_PVR_USER1 0x[format "%02x" [expr $j * $C + $i]]  CONFIG.C_USE_ICACHE {1}]  [get_bd_cells $slave/microblaze_1] 
set_property -dict [list CONFIG.Memory_Type {True_Dual_Port_RAM}]  [get_bd_cells $slave/blk_mem_gen_0] 
set_property -dict [list CONFIG.SINGLE_PORT_BRAM {1} CONFIG.PROTOCOL {AXI4LITE}]  [get_bd_cells $slave/global_vhwti_cntrl_[expr $j * $C + $i]] 
set_property -dict [list CONFIG.SINGLE_PORT_BRAM {1} CONFIG.PROTOCOL {AXI4LITE}]  [get_bd_cells $slave/local_vhwti_cntrl] 


set_property -dict [list CONFIG.NUM_SI {1} CONFIG.NUM_MI {2} CONFIG.ENABLE_ADVANCED_OPTIONS {1} CONFIG.XBAR_DATA_WIDTH.VALUE_SRC USER  CONFIG.XBAR_DATA_WIDTH {32}  ]  [get_bd_cells $slave/dma_bus] 
set_property -dict [list CONFIG.Memory_Type {True_Dual_Port_RAM}]  [get_bd_cells $slave/blk_mem_a] 
set_property -dict [list CONFIG.SINGLE_PORT_BRAM {1} CONFIG.PROTOCOL {AXI4LITE}]  [get_bd_cells $slave/axi_bram_ctrl_a_mb]
set_property -dict [list CONFIG.SINGLE_PORT_BRAM {1} CONFIG.PROTOCOL {AXI4LITE}]  [get_bd_cells $slave/axi_bram_ctrl_a_dma_bus]
set_property -dict [list CONFIG.C_M_AXI_MAX_BURST_LEN {256} CONFIG.C_INCLUDE_SG {0}]  [get_bd_cells  $slave/local_dma] 



#connecting internal ports
connect_bd_intf_net [get_bd_intf_pins $slave/local_vhwti_cntrl/S_AXI]  -boundary_type upper [get_bd_intf_pins $slave/group1_bus/M01_AXI] 
connect_bd_intf_net [get_bd_intf_pins $slave/blk_mem_gen_0/BRAM_PORTA]  [get_bd_intf_pins $slave/global_vhwti_cntrl_[expr $j * $C + $i]/BRAM_PORTA] 
connect_bd_intf_net [get_bd_intf_pins $slave/blk_mem_gen_0/BRAM_PORTB]  [get_bd_intf_pins $slave/local_vhwti_cntrl/BRAM_PORTA] 
connect_bd_intf_net [get_bd_intf_pins $slave/microblaze_1/M_AXI_DP]  -boundary_type upper [get_bd_intf_pins $slave/group1_bus/S00_AXI] 
connect_bd_intf_net [get_bd_intf_pins $slave/microblaze_1/DLMB]  -boundary_type upper [get_bd_intf_pins $slave/microblaze_0_local_memory/DLMB] 
connect_bd_intf_net [get_bd_intf_pins $slave/microblaze_1/ILMB]  -boundary_type upper [get_bd_intf_pins $slave/microblaze_0_local_memory/ILMB] 

connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $slave/dma_bus/M01_AXI] [get_bd_intf_pins $slave/axi_bram_ctrl_a_dma_bus/S_AXI]
connect_bd_intf_net [get_bd_intf_pins $slave/axi_bram_ctrl_a_dma_bus/BRAM_PORTA] [get_bd_intf_pins $slave/blk_mem_a/BRAM_PORTA]
connect_bd_intf_net [get_bd_intf_pins $slave/axi_bram_ctrl_a_mb/BRAM_PORTA] [get_bd_intf_pins $slave/blk_mem_a/BRAM_PORTB]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $slave/dma_bus/S00_AXI] [get_bd_intf_pins $slave/local_dma/M_AXI]
connect_bd_intf_net [get_bd_intf_pins $slave/local_dma/S_AXI_LITE] -boundary_type upper [get_bd_intf_pins $slave/group1_bus/M02_AXI]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $slave/group1_bus/M03_AXI] [get_bd_intf_pins $slave/axi_bram_ctrl_a_mb/S_AXI]

#clk and reset connections
connect_bd_net [get_bd_pins $slave/microblaze_1/Clk] [get_bd_pins ddr_bus/ACLK]
connect_bd_net [get_bd_pins $slave/microblaze_1/Reset] [get_bd_pins host/Reset]
connect_bd_net [get_bd_pins $slave/microblaze_0_local_memory/LMB_Rst] [get_bd_pins host_local_memory/LMB_Rst]
connect_bd_net [get_bd_pins $slave/global_vhwti_cntrl_[expr $j * $C + $i]/s_axi_aresetn] [get_bd_pins peripherals/peripheral_aresetn]
connect_bd_net [get_bd_pins $slave/group1_bus/aresetn] [get_bd_pins peripherals/interconnect_aresetn] -boundary_type upper


foreach module [list local_vhwti_cntrl/s_axi_aresetn axi_bram_ctrl_a_dma_bus/s_axi_aresetn axi_bram_ctrl_a_mb/s_axi_aresetn   ]\
{
   connect_bd_net -net [get_bd_nets $slave/s_axi_aresetn_1] [get_bd_pins $slave/s_axi_aresetn]  [get_bd_pins $slave/$module] 
}

foreach module [list microblaze_0_local_memory/LMB_Clk local_vhwti_cntrl/s_axi_aclk global_vhwti_cntrl_[expr $j * $C + $i]/s_axi_aclk  group1_bus/aclk]\
{
   connect_bd_net  -net [get_bd_nets $slave/Clk_1]  [get_bd_pins $slave/Clk]  [get_bd_pins $slave/$module] 
}



foreach module [list group1_bus  dma_bus ]\
{
 
 for {set k 0} {$k < 16} {incr k} \
   {
      connect_bd_net -quiet -net [get_bd_nets  $slave/Clk_1] [get_bd_pins $slave/Clk] [get_bd_pins $slave/$module/S[format "%02d" [expr $k]]_ACLK]
      connect_bd_net  -quiet -net [get_bd_nets $slave/s_axi_aresetn_1] [get_bd_pins $slave/s_axi_aresetn] [get_bd_pins $slave/$module/S[format "%02d" [expr $k]]_ARESETN]
      connect_bd_net  -quiet -net [get_bd_nets $slave/Clk_1] [get_bd_pins $slave/Clk] [get_bd_pins $slave/$module/M[format "%02d" [expr $k]]_ACLK]
      connect_bd_net  -quiet -net [get_bd_nets $slave/s_axi_aresetn_1] [get_bd_pins $slave/s_axi_aresetn] [get_bd_pins $slave/$module/M[format "%02d" [expr $k]]_ARESETN]
   } 
   
}

#other reset and clk connections
connect_bd_net -net [get_bd_nets $slave/Clk_1] [get_bd_pins $slave/Clk] [get_bd_pins $slave/axi_bram_ctrl_a_mb/s_axi_aclk]
connect_bd_net -net [get_bd_nets $slave/Clk_1] [get_bd_pins $slave/Clk] [get_bd_pins $slave/axi_bram_ctrl_a_dma_bus/s_axi_aclk]
connect_bd_net -net [get_bd_nets $slave/Clk_1] [get_bd_pins $slave/Clk] [get_bd_pins $slave/dma_bus/ACLK]
connect_bd_net -net [get_bd_nets $slave/ARESETN_1] [get_bd_pins $slave/ARESETN] [get_bd_pins $slave/dma_bus/ARESETN]
connect_bd_net -net [get_bd_nets $slave/Clk_1] [get_bd_pins $slave/Clk] [get_bd_pins $slave/local_dma/m_axi_aclk]
connect_bd_net -net [get_bd_nets $slave/Clk_1] [get_bd_pins $slave/Clk] [get_bd_pins $slave/local_dma/s_axi_lite_aclk]
connect_bd_net -net [get_bd_nets $slave/s_axi_aresetn_1] [get_bd_pins $slave/s_axi_aresetn] [get_bd_pins $slave/local_dma/s_axi_lite_aresetn]
