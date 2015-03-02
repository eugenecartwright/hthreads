set slave $group/slave_$i
 
create_bd_cell -type hier $slave

create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:9.3 $slave/microblaze_1
create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.2 $slave/i_bram
create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.2 $slave/d_bram
create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 $slave/ilmb_bram_if_cntlr
create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 $slave/ilmb_v10_0
create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 $slave/dlmb_bram_if_cntlr
create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 $slave/dlmb_v10_0
create_bd_cell -type hier $slave/microblaze_0_local_memory
move_bd_cells [get_bd_cells $slave/microblaze_0_local_memory] [get_bd_cells $slave/dlmb_bram_if_cntlr] [get_bd_cells $slave/ilmb_v10_0] [get_bd_cells $slave/ilmb_bram_if_cntlr] [get_bd_cells $slave/i_bram] [get_bd_cells $slave/dlmb_v10_0] [get_bd_cells $slave/d_bram]

create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 $slave/group1_bus
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 $slave/dma_bus
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_cdma:4.1 $slave/local_dma

create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 $slave/global_vhwti_cntrl_[expr $j * $C + $i]







set_property -dict [list CONFIG.NUM_SI {1}  CONFIG.NUM_MI {2} CONFIG.ENABLE_ADVANCED_OPTIONS {1} CONFIG.XBAR_DATA_WIDTH.VALUE_SRC USER  CONFIG.XBAR_DATA_WIDTH {32}  CONFIG.STRATEGY {1}]  [get_bd_cells $slave/group1_bus] 

set_property -dict [list CONFIG.NUM_SI {2} CONFIG.NUM_MI {2} CONFIG.ENABLE_ADVANCED_OPTIONS {1} CONFIG.XBAR_DATA_WIDTH.VALUE_SRC USER  CONFIG.XBAR_DATA_WIDTH {32}  ]  [get_bd_cells $slave/dma_bus] 


set_property -dict [list CONFIG.C_D_AXI {1} CONFIG.C_USE_BARREL {1} CONFIG.C_PVR {2} CONFIG.C_PVR_USER2 {0x00001000}  CONFIG.C_PVR_USER1 0x[format "%02x" [expr $j * $C + $i]]  CONFIG.C_USE_ICACHE {1}]  [get_bd_cells $slave/microblaze_1] 
set_property -dict [list CONFIG.Memory_Type {Single_Port_RAM}]  [get_bd_cells $slave/microblaze_0_local_memory/i_bram] 
set_property -dict [list CONFIG.Memory_Type {True_Dual_Port_RAM}]  [get_bd_cells $slave/microblaze_0_local_memory/d_bram] 
set_property -dict [list CONFIG.SINGLE_PORT_BRAM {1} CONFIG.PROTOCOL {AXI4}]  [get_bd_cells $slave/global_vhwti_cntrl_[expr $j * $C + $i]] 
set_property -dict [list CONFIG.C_M_AXI_MAX_BURST_LEN {256} CONFIG.C_INCLUDE_SG {0}]  [get_bd_cells  $slave/local_dma] 



#connecting internal ports
connect_bd_intf_net [get_bd_intf_pins $slave/microblaze_0_local_memory/ilmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins $slave/microblaze_0_local_memory/i_bram/BRAM_PORTA]
connect_bd_intf_net [get_bd_intf_pins $slave/microblaze_0_local_memory/ilmb_bram_if_cntlr/SLMB] [get_bd_intf_pins $slave/microblaze_0_local_memory/ilmb_v10_0/LMB_Sl_0]
connect_bd_intf_net [get_bd_intf_pins $slave/microblaze_0_local_memory/ilmb_v10_0/LMB_M] [get_bd_intf_pins $slave/microblaze_1/ILMB]
connect_bd_intf_net [get_bd_intf_pins $slave/microblaze_1/DLMB] [get_bd_intf_pins $slave/microblaze_0_local_memory/dlmb_v10_0/LMB_M]
connect_bd_intf_net [get_bd_intf_pins $slave/microblaze_0_local_memory/dlmb_v10_0/LMB_Sl_0] [get_bd_intf_pins $slave/microblaze_0_local_memory/dlmb_bram_if_cntlr/SLMB]
connect_bd_intf_net [get_bd_intf_pins $slave/microblaze_0_local_memory/dlmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins $slave/microblaze_0_local_memory/d_bram/BRAM_PORTA]
connect_bd_intf_net [get_bd_intf_pins $slave/microblaze_1/M_AXI_DP] -boundary_type upper [get_bd_intf_pins $slave/group1_bus/S00_AXI]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $slave/group1_bus/M01_AXI] [get_bd_intf_pins $slave/local_dma/S_AXI_LITE]
connect_bd_intf_net [get_bd_intf_pins $slave/local_dma/M_AXI] -boundary_type upper [get_bd_intf_pins $slave/dma_bus/S00_AXI]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $slave/dma_bus/M01_AXI] [get_bd_intf_pins $slave/global_vhwti_cntrl_[expr $j * $C + $i]/S_AXI]
connect_bd_intf_net [get_bd_intf_pins $slave/global_vhwti_cntrl_[expr $j * $C + $i]/BRAM_PORTA] [get_bd_intf_pins $slave/microblaze_0_local_memory/d_bram/BRAM_PORTB]




#clk and reset connections
connect_bd_net [get_bd_pins $slave/microblaze_1/Clk] [get_bd_pins ddr_bus/ACLK]
connect_bd_net [get_bd_pins $slave/microblaze_1/Reset] [get_bd_pins host/Reset]
connect_bd_net [get_bd_pins $slave/global_vhwti_cntrl_[expr $j * $C + $i]/s_axi_aresetn] [get_bd_pins peripherals/peripheral_aresetn]
connect_bd_net [get_bd_pins $slave/group1_bus/aresetn] [get_bd_pins peripherals/interconnect_aresetn] -boundary_type upper
connect_bd_net [get_bd_pins $slave/microblaze_0_local_memory/dlmb_bram_if_cntlr/LMB_Rst] [get_bd_pins host_local_memory/LMB_Rst]

foreach module [list  local_dma/s_axi_lite_aresetn   ]\
{
   connect_bd_net -net [get_bd_nets $slave/s_axi_aresetn_1] [get_bd_pins $slave/s_axi_aresetn]  [get_bd_pins $slave/$module] 
}

connect_bd_net -net [get_bd_nets $slave/ARESETN_1] [get_bd_pins $slave/ARESETN] [get_bd_pins $slave/dma_bus/ARESETN]

foreach module [list local_dma/m_axi_aclk global_vhwti_cntrl_[expr $j * $C + $i]/s_axi_aclk local_dma/s_axi_lite_aclk group1_bus/aclk dma_bus/ACLK   ]\
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


connect_bd_net -net [get_bd_nets $slave/microblaze_0_local_memory/LMB_Rst_1] [get_bd_pins $slave/microblaze_0_local_memory/LMB_Rst] [get_bd_pins $slave/microblaze_0_local_memory/dlmb_v10_0/SYS_Rst]
connect_bd_net -net [get_bd_nets $slave/microblaze_0_local_memory/LMB_Rst_1] [get_bd_pins $slave/microblaze_0_local_memory/LMB_Rst] [get_bd_pins $slave/microblaze_0_local_memory/ilmb_v10_0/SYS_Rst]
connect_bd_net -net [get_bd_nets $slave/microblaze_0_local_memory/LMB_Rst_1] [get_bd_pins $slave/microblaze_0_local_memory/LMB_Rst] [get_bd_pins $slave/microblaze_0_local_memory/ilmb_bram_if_cntlr/LMB_Rst]

connect_bd_net [get_bd_pins $slave/Clk] [get_bd_pins $slave/microblaze_0_local_memory/ilmb_v10_0/LMB_Clk]

connect_bd_net -net [get_bd_nets $slave/microblaze_0_local_memory/LMB_Clk_1] [get_bd_pins $slave/microblaze_0_local_memory/LMB_Clk] [get_bd_pins $slave/microblaze_0_local_memory/dlmb_v10_0/LMB_Clk]
connect_bd_net -net [get_bd_nets $slave/microblaze_0_local_memory/LMB_Clk_1] [get_bd_pins $slave/microblaze_0_local_memory/LMB_Clk] [get_bd_pins $slave/microblaze_0_local_memory/ilmb_bram_if_cntlr/LMB_Clk]
connect_bd_net -net [get_bd_nets $slave/microblaze_0_local_memory/LMB_Clk_1] [get_bd_pins $slave/microblaze_0_local_memory/LMB_Clk] [get_bd_pins $slave/microblaze_0_local_memory/dlmb_bram_if_cntlr/LMB_Clk]

