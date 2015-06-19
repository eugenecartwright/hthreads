set slave $group/slave_$i
 
create_bd_cell -type hier $slave

create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:9.5 $slave/microblaze_1
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 $slave/global_vhwti_cntrl_[expr $j * $C + $i]
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 $slave/local_vhwti_cntrl
create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.2 $slave/blk_mem_gen_0
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 $slave/group1_bus
copy_bd_objs $slave  [get_bd_cells {host_local_memory}] 
set_property name microblaze_0_local_memory [get_bd_cells $slave/host_local_memory]
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 $slave/dma_bus
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 $slave/tmp_dma_bus
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_cdma:4.1 $slave/local_dma
create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:12.0 $slave/fifo_generator_0





#Which accelerator?
#create_bd_cell -type ip -vlnv xilinx.com:hls:vectoradd:1.0 $slave/acc_0
create_bd_cell -type ip -vlnv xilinx.com:hls:crc:1.0 $slave/acc_0 

if {0} \
{
   if {$i == 0} {
       create_bd_cell -type ip -vlnv xilinx.com:hls:vectoradd:1.0 $slave/acc_0
   } elseif {$i == 1} {
       create_bd_cell -type ip -vlnv xilinx.com:hls:vectormul:1.0 $slave/acc_0
   } elseif {$i == 2} {
       create_bd_cell -type ip -vlnv user.org:user:hw_acc_vector:1.0 $slave/acc_0
   } elseif {$i == 3} {
       create_bd_cell -type ip -vlnv user.org:user:hw_acc_bubblesort:1.0 $slave/acc_0
    } elseif {$i == 4} {
       create_bd_cell -type ip -vlnv user.org:user:hw_acc_quicksort:1.0 $slave/acc_0     
       
   }    
}


create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 $slave/axi_bram_ctrl_a
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 $slave/axi_bram_ctrl_b
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 $slave/axi_bram_ctrl_result
create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.2 $slave/blk_mem_a
create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.2 $slave/blk_mem_b
create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.2 $slave/blk_mem_result




set_property -dict [list CONFIG.NUM_SI {1} CONFIG.NUM_MI {4} CONFIG.ENABLE_ADVANCED_OPTIONS {1} CONFIG.XBAR_DATA_WIDTH.VALUE_SRC USER  CONFIG.XBAR_DATA_WIDTH {32}  ]  [get_bd_cells $slave/group1_bus] 

set_property -dict [list CONFIG.NUM_SI {2} CONFIG.NUM_MI {3} CONFIG.ENABLE_ADVANCED_OPTIONS {1} CONFIG.XBAR_DATA_WIDTH.VALUE_SRC USER  CONFIG.XBAR_DATA_WIDTH {32}  ]  [get_bd_cells $slave/dma_bus] 

set_property -dict [list CONFIG.NUM_SI {1} CONFIG.NUM_MI {2} CONFIG.ENABLE_ADVANCED_OPTIONS {1} CONFIG.XBAR_DATA_WIDTH.VALUE_SRC USER  CONFIG.XBAR_DATA_WIDTH {32}  ]  [get_bd_cells $slave/tmp_dma_bus] 

set_property -dict [list CONFIG.INTERFACE_TYPE {AXI_STREAM} CONFIG.TDATA_NUM_BYTES {4} CONFIG.TUSER_WIDTH {0} CONFIG.Input_Depth_axis {16} CONFIG.TSTRB_WIDTH {4} CONFIG.TKEEP_WIDTH {4} CONFIG.FIFO_Implementation_wach {Common_Clock_Distributed_RAM} CONFIG.Full_Threshold_Assert_Value_wach {15} CONFIG.Empty_Threshold_Assert_Value_wach {14} CONFIG.FIFO_Implementation_wrch {Common_Clock_Distributed_RAM} CONFIG.Full_Threshold_Assert_Value_wrch {15} CONFIG.Empty_Threshold_Assert_Value_wrch {14} CONFIG.FIFO_Implementation_rach {Common_Clock_Distributed_RAM} CONFIG.Full_Threshold_Assert_Value_rach {15} CONFIG.Empty_Threshold_Assert_Value_rach {14} CONFIG.Full_Threshold_Assert_Value_axis {15} CONFIG.Empty_Threshold_Assert_Value_axis {14}] [get_bd_cells $slave/fifo_generator_0]


set_property -dict [list CONFIG.Memory_Type {True_Dual_Port_RAM}]  [get_bd_cells $slave/blk_mem_gen_0] 
set_property -dict [list CONFIG.Memory_Type {True_Dual_Port_RAM}]  [get_bd_cells $slave/blk_mem_a] 
set_property -dict [list CONFIG.Memory_Type {True_Dual_Port_RAM}]  [get_bd_cells $slave/blk_mem_b] 
set_property -dict [list CONFIG.Memory_Type {True_Dual_Port_RAM}]  [get_bd_cells $slave/blk_mem_result] 

set_property -dict [list CONFIG.SINGLE_PORT_BRAM {1} CONFIG.PROTOCOL {AXI4LITE}]  [get_bd_cells $slave/global_vhwti_cntrl_[expr $j * $C + $i]] 
set_property -dict [list CONFIG.SINGLE_PORT_BRAM {1} CONFIG.PROTOCOL {AXI4LITE}]  [get_bd_cells $slave/local_vhwti_cntrl] 
set_property -dict [list CONFIG.SINGLE_PORT_BRAM {1} CONFIG.PROTOCOL {AXI4}]  [get_bd_cells $slave/axi_bram_ctrl_a] 
set_property -dict [list CONFIG.SINGLE_PORT_BRAM {1} CONFIG.PROTOCOL {AXI4}]  [get_bd_cells $slave/axi_bram_ctrl_b] 
set_property -dict [list CONFIG.SINGLE_PORT_BRAM {1} CONFIG.PROTOCOL {AXI4}]  [get_bd_cells $slave/axi_bram_ctrl_result] 


set_property -dict [list CONFIG.C_M_AXI_MAX_BURST_LEN {256} CONFIG.C_INCLUDE_SG {0}]  [get_bd_cells  $slave/local_dma] 

set_property -dict [list  CONFIG.C_FSL_LINKS {1} CONFIG.C_D_AXI {1} CONFIG.C_USE_BARREL {1} CONFIG.C_PVR {2} CONFIG.C_PVR_USER2 {0xC0000000}  CONFIG.C_PVR_USER1 0x[format "%02x" [expr $j * $C + $i]]  CONFIG.C_USE_ICACHE {1}]  [get_bd_cells $slave/microblaze_1] 

#connecting internal ports
connect_bd_intf_net [get_bd_intf_pins $slave/local_vhwti_cntrl/S_AXI]  -boundary_type upper [get_bd_intf_pins $slave/group1_bus/M03_AXI] 
connect_bd_intf_net [get_bd_intf_pins $slave/blk_mem_gen_0/BRAM_PORTA]  [get_bd_intf_pins $slave/global_vhwti_cntrl_[expr $j * $C + $i]/BRAM_PORTA] 
connect_bd_intf_net [get_bd_intf_pins $slave/blk_mem_gen_0/BRAM_PORTB]  [get_bd_intf_pins $slave/local_vhwti_cntrl/BRAM_PORTA] 
connect_bd_intf_net [get_bd_intf_pins $slave/microblaze_1/M_AXI_DP]  -boundary_type upper [get_bd_intf_pins $slave/group1_bus/S00_AXI] 
connect_bd_intf_net [get_bd_intf_pins $slave/microblaze_1/DLMB]  -boundary_type upper [get_bd_intf_pins $slave/microblaze_0_local_memory/DLMB] 
connect_bd_intf_net [get_bd_intf_pins $slave/microblaze_1/ILMB]  -boundary_type upper [get_bd_intf_pins $slave/microblaze_0_local_memory/ILMB] 
connect_bd_intf_net [get_bd_intf_pins $slave/axi_bram_ctrl_a/BRAM_PORTA]  [get_bd_intf_pins $slave/blk_mem_a/BRAM_PORTA] 
connect_bd_intf_net [get_bd_intf_pins $slave/axi_bram_ctrl_b/BRAM_PORTA]  [get_bd_intf_pins $slave/blk_mem_b/BRAM_PORTA] 
connect_bd_intf_net [get_bd_intf_pins $slave/axi_bram_ctrl_result/BRAM_PORTA]  [get_bd_intf_pins $slave/blk_mem_result/BRAM_PORTA] 

#connecting accelerator ports
connect_bd_intf_net [get_bd_intf_pins $slave/acc_0/a_PORTA]  [get_bd_intf_pins $slave/blk_mem_a/BRAM_PORTB] 
connect_bd_intf_net [get_bd_intf_pins $slave/acc_0/b_PORTA]  [get_bd_intf_pins $slave/blk_mem_b/BRAM_PORTB] 
connect_bd_intf_net [get_bd_intf_pins $slave/acc_0/result_PORTA]  [get_bd_intf_pins $slave/blk_mem_result/BRAM_PORTB] 
connect_bd_intf_net [get_bd_intf_pins $slave/acc_0/resp]  [get_bd_intf_pins $slave/microblaze_1/S0_AXIS] 
connect_bd_intf_net [get_bd_intf_pins $slave/microblaze_1/M0_AXIS] [get_bd_intf_pins $slave/fifo_generator_0/S_AXIS]
connect_bd_intf_net [get_bd_intf_pins $slave/fifo_generator_0/M_AXIS] [get_bd_intf_pins $slave/acc_0/cmd]

 


connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $slave/group1_bus/M01_AXI] [get_bd_intf_pins $slave/local_dma/S_AXI_LITE]


connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $slave/group1_bus/M02_AXI] [get_bd_intf_pins  $slave/dma_bus/S00_AXI]

connect_bd_intf_net [get_bd_intf_pins $slave/tmp_dma_bus/M01_AXI] -boundary_type upper [get_bd_intf_pins $slave/dma_bus/S01_AXI]
connect_bd_intf_net [get_bd_intf_pins $slave/local_dma/M_AXI] -boundary_type upper [get_bd_intf_pins $slave/tmp_dma_bus/S00_AXI]



connect_bd_intf_net [get_bd_intf_pins $slave/axi_bram_ctrl_a/S_AXI] -boundary_type upper [get_bd_intf_pins $slave/dma_bus/M00_AXI]
connect_bd_intf_net [get_bd_intf_pins $slave/axi_bram_ctrl_b/S_AXI] -boundary_type upper [get_bd_intf_pins $slave/dma_bus/M01_AXI]
connect_bd_intf_net [get_bd_intf_pins $slave/axi_bram_ctrl_result/S_AXI] -boundary_type upper [get_bd_intf_pins $slave/dma_bus/M02_AXI]



#clk and reset connections
connect_bd_net [get_bd_pins $slave/microblaze_1/Clk] [get_bd_pins ddr_bus/ACLK]
connect_bd_net [get_bd_pins $slave/microblaze_1/Reset] [get_bd_pins host/Reset]
connect_bd_net [get_bd_pins $slave/microblaze_0_local_memory/SYS_Rst] [get_bd_pins host_local_memory/SYS_Rst]
connect_bd_net [get_bd_pins $slave/global_vhwti_cntrl_[expr $j * $C + $i]/s_axi_aresetn] [get_bd_pins peripherals/peripheral_aresetn]
connect_bd_net [get_bd_pins $slave/group1_bus/aresetn] [get_bd_pins peripherals/interconnect_aresetn] -boundary_type upper

connect_bd_net -net [get_bd_nets $slave/Clk_1] [get_bd_pins $slave/Clk] [get_bd_pins $slave/fifo_generator_0/s_aclk]
connect_bd_net -net [get_bd_nets $slave/s_axi_aresetn_1] [get_bd_pins $slave/s_axi_aresetn] [get_bd_pins $slave/fifo_generator_0/s_aresetn]


foreach module [list local_vhwti_cntrl axi_bram_ctrl_a axi_bram_ctrl_b axi_bram_ctrl_result ]\
{
   connect_bd_net -net [get_bd_nets $slave/s_axi_aresetn_1] [get_bd_pins $slave/s_axi_aresetn]  [get_bd_pins $slave/$module//s_axi_aresetn] 
}
connect_bd_net -net [get_bd_nets $slave/s_axi_aresetn_1] [get_bd_pins $slave/s_axi_aresetn] [get_bd_pins $slave/local_dma/s_axi_lite_aresetn]
connect_bd_net -net [get_bd_nets $slave/aresetn_1] [get_bd_pins $slave/aresetn] [get_bd_pins $slave/dma_bus/aresetn]
connect_bd_net -net [get_bd_nets $slave/aresetn_1] [get_bd_pins $slave/aresetn] [get_bd_pins $slave/tmp_dma_bus/aresetn]
connect_bd_net -net [get_bd_nets $slave/s_axi_aresetn_1] [get_bd_pins $slave/s_axi_aresetn] [get_bd_pins $slave/acc_0/ap_rst_n]



foreach module [list acc_0/ap_clk  microblaze_0_local_memory/LMB_Clk  axi_bram_ctrl_a/s_axi_aclk axi_bram_ctrl_b/s_axi_aclk axi_bram_ctrl_result/s_axi_aclk dma_bus/aclk tmp_dma_bus/aclk local_dma/m_axi_aclk local_dma/s_axi_lite_aclk local_vhwti_cntrl/s_axi_aclk global_vhwti_cntrl_[expr $j * $C + $i]/s_axi_aclk  group1_bus/aclk]\
{
connect_bd_net  -net [get_bd_nets $slave/Clk_1]  [get_bd_pins $slave/Clk]  [get_bd_pins $slave/$module] 
}

#brams need their own clk(For PR) and reset(for hls bug)
connect_bd_net -net [get_bd_nets $slave/Clk_1] [get_bd_pins $slave/Clk] [get_bd_pins $slave/blk_mem_a/clkb]
connect_bd_net -net [get_bd_nets $slave/Clk_1] [get_bd_pins $slave/Clk] [get_bd_pins $slave/blk_mem_b/clkb]
connect_bd_net -net [get_bd_nets $slave/Clk_1] [get_bd_pins $slave/Clk] [get_bd_pins $slave/blk_mem_result/clkb]
connect_bd_net [get_bd_pins $slave/blk_mem_a/rstb] [get_bd_pins peripherals/peripheral_reset]
connect_bd_net [get_bd_pins $slave/blk_mem_b/rstb] [get_bd_pins peripherals/peripheral_reset]
connect_bd_net [get_bd_pins $slave/blk_mem_result/rstb] [get_bd_pins peripherals/peripheral_reset]


foreach module [list group1_bus  dma_bus tmp_dma_bus ]\
{
 
 for {set k 0} {$k < 16} {incr k} \
   {
      connect_bd_net -quiet -net [get_bd_nets  $slave/Clk_1] [get_bd_pins $slave/Clk] [get_bd_pins $slave/$module/S[format "%02d" [expr $k]]_ACLK]
      connect_bd_net  -quiet -net [get_bd_nets $slave/s_axi_aresetn_1] [get_bd_pins $slave/s_axi_aresetn] [get_bd_pins $slave/$module/S[format "%02d" [expr $k]]_ARESETN]
      connect_bd_net  -quiet -net [get_bd_nets $slave/Clk_1] [get_bd_pins $slave/Clk] [get_bd_pins $slave/$module/M[format "%02d" [expr $k]]_ACLK]
      connect_bd_net  -quiet -net [get_bd_nets $slave/s_axi_aresetn_1] [get_bd_pins $slave/s_axi_aresetn] [get_bd_pins $slave/$module/M[format "%02d" [expr $k]]_ARESETN]
   } 
   
}




