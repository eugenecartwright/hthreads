set slave $group/slave_$i
set ROW 2
set COL 2
set BRAM_NAME_LIST {10 11 20 21 30 31 40 41}
set FIFO_NAME_LIST {C00 C01 C02 C10 C11 C12 R00 R01 R02 R10 R11 R12}
set SWITCH_NAME_LIST {00 01 10 11}

create_bd_cell -type hier $slave
create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:9.3 $slave/microblaze_1
set_property -dict [list CONFIG.C_FSL_LINKS [expr $ROW*$COL] CONFIG.C_USE_EXTENDED_FSL_INSTR {1}] [get_bd_cells $slave/microblaze_1]
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 $slave/global_vhwti_cntrl_[expr $j * $C + $i]
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 $slave/local_vhwti_cntrl
create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.2 $slave/blk_mem_gen_0
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 $slave/group1_bus
copy_bd_objs $slave  [get_bd_cells {host_local_memory}] 
set_property name microblaze_0_local_memory [get_bd_cells $slave/host_local_memory]
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 $slave/dma_bus
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_cdma:4.1 $slave/local_dma

# #################################################################
set CLK host_Clk
set RstName peripherals_peripheral_reset
set nRstName S00_ARESETN_1
# #################################################################

#for {set jj 0} {$jj < [expr $ROW * $COL]} {incr jj} \
#{
#	set cmdname cmd_[lindex $SWITCH_NAME_LIST $jj]
#	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/$cmdname
#	set respname resp_[lindex $SWITCH_NAME_LIST $jj]
#	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/$respname
#}

#set LIST_LEN [llength $BRAM_NAME_LIST]
#for {set ii 0} {$ii < $LIST_LEN} {incr ii} \
#{
#	set sAXIsname sAXIs_[lindex $BRAM_NAME_LIST $ii]
#	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 $tmpname/$sAXIsname
#}

set tmpname $slave/SFA_ARRAY_00
create_bd_cell -type hier $tmpname
create_bd_pin -dir I $tmpname/rsta
create_bd_pin -dir I $tmpname/s_axi_aclk
create_bd_pin -dir I $tmpname/s_axi_aresetn

set slave $slave/SFA_ARRAY_00
# #################################################################
# BRAMs
# #################################################################
#set BRAM_NAME_LIST {10 11 20 21 30 31 40 41}
set LIST_LEN [llength $BRAM_NAME_LIST]
for {set ii 0} {$ii < $LIST_LEN} {incr ii} \
{
	set tmpname BRAM[lindex $BRAM_NAME_LIST $ii]
	set ctrlname AXI_BRAM_CTRL_[lindex $BRAM_NAME_LIST $ii]
	set bramname ACC_BIF_BRAM_[lindex $BRAM_NAME_LIST $ii]
	set bifname  ACC_BIF_[lindex $BRAM_NAME_LIST $ii]
	
	set sAXIsname sAXIs_[lindex $BRAM_NAME_LIST $ii]
	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 $slave/$sAXIsname

	set tmpname $slave/$tmpname
	create_bd_cell -type hier $tmpname

	create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 $tmpname/$ctrlname
	set_property -dict [list CONFIG.SINGLE_PORT_BRAM {1}] [get_bd_cells $tmpname/$ctrlname]
	set_property -dict [list CONFIG.PROTOCOL {AXI4}] [get_bd_cells $tmpname/$ctrlname]
	create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.2 $tmpname/$bramname
	set_property -dict [list CONFIG.Memory_Type {True_Dual_Port_RAM}] [get_bd_cells $tmpname/$bramname]
	create_bd_cell -type ip -vlnv xilinx.com:hls:acc_bif:1.0 $tmpname/$bifname

	connect_bd_intf_net [get_bd_intf_pins $tmpname/$ctrlname/BRAM_PORTA] [get_bd_intf_pins $tmpname/$bramname/BRAM_PORTB]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/$bifname/bram_PORTA] [get_bd_intf_pins $tmpname/$bramname/BRAM_PORTA]

	create_bd_pin -dir I $tmpname/rsta
	connect_bd_net [get_bd_pins $tmpname/rsta] [get_bd_pins $tmpname/$bramname/rsta]
	create_bd_pin -dir I $tmpname/s_axi_aclk
	connect_bd_net [get_bd_pins $tmpname/s_axi_aclk] [get_bd_pins $tmpname/$bifname/ap_clk]
	connect_bd_net [get_bd_pins $tmpname/s_axi_aclk] [get_bd_pins $tmpname/$ctrlname/s_axi_aclk]
	create_bd_pin -dir I $tmpname/s_axi_aresetn
	connect_bd_net [get_bd_pins $tmpname/s_axi_aresetn] [get_bd_pins $tmpname/$ctrlname/s_axi_aresetn]
	connect_bd_net -net [get_bd_nets $tmpname/s_axi_aresetn_1] [get_bd_pins $tmpname/s_axi_aresetn] [get_bd_pins $tmpname/$bifname/ap_rst_n]

	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 $tmpname/S_AXI
	connect_bd_intf_net [get_bd_intf_pins $tmpname/S_AXI] [get_bd_intf_pins $tmpname/$ctrlname/S_AXI]
	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/cmd
	connect_bd_intf_net [get_bd_intf_pins $tmpname/cmd] [get_bd_intf_pins $tmpname/$bifname/cmd]
	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/sBIF
	connect_bd_intf_net [get_bd_intf_pins $tmpname/sBIF] [get_bd_intf_pins $tmpname/$bifname/sBIF]
	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/mBIF
	connect_bd_intf_net [get_bd_intf_pins $tmpname/mBIF] [get_bd_intf_pins $tmpname/$bifname/mBIF]
	
	connect_bd_intf_net 	[get_bd_intf_pins $slave/$sAXIsname] 	[get_bd_intf_pins $tmpname/S_AXI]
	connect_bd_net 		[get_bd_pins $slave/rsta] 		[get_bd_pins $tmpname/rsta]
	connect_bd_net 		[get_bd_pins $slave/s_axi_aclk] 	[get_bd_pins $tmpname/s_axi_aclk]
	connect_bd_net 		[get_bd_pins $slave/s_axi_aresetn] 	[get_bd_pins $tmpname/s_axi_aresetn]
	
	
	#set tmpbram SEG_$ctrlname\_Mem0
	#set num [lindex $BRAM_NAME_LIST $ii]
	#set tmpaddress 0xE[expr $num]00000
	#apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/microblaze_0 (Periph)" Clk "Auto" }  [get_bd_intf_pins $tmpname/S_AXI]
	#set_property range 16K		[get_bd_addr_segs microblaze_0/Data/$tmpbram]
	#set_property offset $tmpaddress [get_bd_addr_segs microblaze_0/Data/$tmpbram]
	#set_property range 16K 		[get_bd_addr_segs microblaze_0/Instruction/$tmpbram]
	#set_property offset $tmpaddress [get_bd_addr_segs microblaze_0/Instruction/$tmpbram]
	#set_property range 16K 		[get_bd_addr_segs axi_cdma_0/Data/$tmpbram]
	#set_property offset $tmpaddress [get_bd_addr_segs axi_cdma_0/Data/$tmpbram]
}

# #################################################################
# FIFOs Between BIF and Nodes
# #################################################################
#set FIFO_NAME_LIST {C00 C01 C02 C10 C11 C12 R00 R01 R02 R10 R11 R12}
set LIST_LEN [llength $FIFO_NAME_LIST]
for {set ii 0} {$ii< $LIST_LEN} {incr ii} \
{
	set tmpname ACC_FF_[lindex $FIFO_NAME_LIST $ii]

	set tmpname $slave/$tmpname
	create_bd_cell -type hier $tmpname

	create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:12.0 $tmpname/ACC_FIFO_IN
	set_property -dict [list CONFIG.INTERFACE_TYPE {AXI_STREAM} CONFIG.TDATA_NUM_BYTES {4} CONFIG.TUSER_WIDTH {0} CONFIG.Input_Depth_axis {16}] [get_bd_cells $tmpname/ACC_FIFO_IN]

	create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:12.0 $tmpname/ACC_FIFO_OUT
	set_property -dict [list CONFIG.INTERFACE_TYPE {AXI_STREAM} CONFIG.TDATA_NUM_BYTES {4} CONFIG.TUSER_WIDTH {0} CONFIG.Input_Depth_axis {16}] [get_bd_cells $tmpname/ACC_FIFO_OUT]

	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/sFIFO_I
	connect_bd_intf_net [get_bd_intf_pins $tmpname/sFIFO_I] [get_bd_intf_pins $tmpname/ACC_FIFO_IN/S_AXIS]

	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/sFIFO_O
	connect_bd_intf_net [get_bd_intf_pins $tmpname/sFIFO_O] [get_bd_intf_pins $tmpname/ACC_FIFO_OUT/S_AXIS]

	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/mFIFO_I
	connect_bd_intf_net [get_bd_intf_pins $tmpname/mFIFO_I] [get_bd_intf_pins $tmpname/ACC_FIFO_IN/M_AXIS]

	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/mFIFO_O
	connect_bd_intf_net [get_bd_intf_pins $tmpname/mFIFO_O] [get_bd_intf_pins $tmpname/ACC_FIFO_OUT/M_AXIS]

	create_bd_pin -dir I $tmpname/s_axi_aclk
	connect_bd_net [get_bd_pins $tmpname/s_axi_aclk] [get_bd_pins $tmpname/ACC_FIFO_IN/s_aclk]
	connect_bd_net [get_bd_pins $tmpname/s_axi_aclk] [get_bd_pins $tmpname/ACC_FIFO_OUT/s_aclk]
	create_bd_pin -dir I $tmpname/s_axi_aresetn
	connect_bd_net [get_bd_pins $tmpname/s_axi_aresetn] [get_bd_pins $tmpname/ACC_FIFO_IN/s_aresetn]
	connect_bd_net [get_bd_pins $tmpname/s_axi_aresetn] [get_bd_pins $tmpname/ACC_FIFO_OUT/s_aresetn]

	connect_bd_net 	[get_bd_pins $slave/s_axi_aclk] 	[get_bd_pins $tmpname/s_axi_aclk]
	connect_bd_net 	[get_bd_pins $slave/s_axi_aresetn] 	[get_bd_pins $tmpname/s_axi_aresetn]
}


# #################################################################
# SWITCH
# #################################################################
#set SWITCH_NAME_LIST {00 01 10 11}
set LIST_LEN [llength $SWITCH_NAME_LIST]
for {set ii 0} {$ii < $LIST_LEN} {incr ii} \
{
	set tmpname ACC_SWITCH_[lindex $SWITCH_NAME_LIST $ii]
	set tmpname $slave/$tmpname
	create_bd_cell -type hier $tmpname

	# #################################################################
	# SWITCH - FIFO
	# #################################################################

	create_bd_cell -type hier $tmpname/ACC_BR_FIFO_IN1

	create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:12.0 $tmpname/ACC_BR_FIFO_IN1/ACC_FIFO_N
	set_property -dict [list CONFIG.INTERFACE_TYPE {AXI_STREAM} CONFIG.TDATA_NUM_BYTES {4} CONFIG.TUSER_WIDTH {0} CONFIG.Input_Depth_axis {16}] [get_bd_cells $tmpname/ACC_BR_FIFO_IN1/ACC_FIFO_N]
	create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:12.0 $tmpname/ACC_BR_FIFO_IN1/ACC_FIFO_E
	set_property -dict [list CONFIG.INTERFACE_TYPE {AXI_STREAM} CONFIG.TDATA_NUM_BYTES {4} CONFIG.TUSER_WIDTH {0} CONFIG.Input_Depth_axis {16}] [get_bd_cells $tmpname/ACC_BR_FIFO_IN1/ACC_FIFO_E]
	create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:12.0 $tmpname/ACC_BR_FIFO_IN1/ACC_FIFO_S
	set_property -dict [list CONFIG.INTERFACE_TYPE {AXI_STREAM} CONFIG.TDATA_NUM_BYTES {4} CONFIG.TUSER_WIDTH {0} CONFIG.Input_Depth_axis {16}] [get_bd_cells $tmpname/ACC_BR_FIFO_IN1/ACC_FIFO_S]
	create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:12.0 $tmpname/ACC_BR_FIFO_IN1/ACC_FIFO_W
	set_property -dict [list CONFIG.INTERFACE_TYPE {AXI_STREAM} CONFIG.TDATA_NUM_BYTES {4} CONFIG.TUSER_WIDTH {0} CONFIG.Input_Depth_axis {16}] [get_bd_cells $tmpname/ACC_BR_FIFO_IN1/ACC_FIFO_W]

	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/ACC_BR_FIFO_IN1/IN_N
	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/ACC_BR_FIFO_IN1/IN_E
	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/ACC_BR_FIFO_IN1/IN_S
	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/ACC_BR_FIFO_IN1/IN_W

	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/ACC_BR_FIFO_IN1/OUT_N
	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/ACC_BR_FIFO_IN1/OUT_E
	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/ACC_BR_FIFO_IN1/OUT_S
	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/ACC_BR_FIFO_IN1/OUT_W

	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN1/IN_N] [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN1/ACC_FIFO_N/S_AXIS]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN1/IN_E] [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN1/ACC_FIFO_E/S_AXIS]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN1/IN_S] [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN1/ACC_FIFO_S/S_AXIS]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN1/IN_W] [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN1/ACC_FIFO_W/S_AXIS]

	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN1/OUT_N] [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN1/ACC_FIFO_N/M_AXIS]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN1/OUT_E] [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN1/ACC_FIFO_E/M_AXIS]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN1/OUT_S] [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN1/ACC_FIFO_S/M_AXIS]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN1/OUT_W] [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN1/ACC_FIFO_W/M_AXIS]

	create_bd_pin -dir I $tmpname/ACC_BR_FIFO_IN1/s_axi_aclk
	connect_bd_net [get_bd_pins $tmpname/ACC_BR_FIFO_IN1/s_axi_aclk] [get_bd_pins $tmpname/ACC_BR_FIFO_IN1/ACC_FIFO_N/s_aclk]
	connect_bd_net [get_bd_pins $tmpname/ACC_BR_FIFO_IN1/s_axi_aclk] [get_bd_pins $tmpname/ACC_BR_FIFO_IN1/ACC_FIFO_E/s_aclk]
	connect_bd_net [get_bd_pins $tmpname/ACC_BR_FIFO_IN1/s_axi_aclk] [get_bd_pins $tmpname/ACC_BR_FIFO_IN1/ACC_FIFO_S/s_aclk]
	connect_bd_net [get_bd_pins $tmpname/ACC_BR_FIFO_IN1/s_axi_aclk] [get_bd_pins $tmpname/ACC_BR_FIFO_IN1/ACC_FIFO_W/s_aclk]

	create_bd_pin -dir I $tmpname/ACC_BR_FIFO_IN1/s_axi_aresetn
	connect_bd_net [get_bd_pins $tmpname/ACC_BR_FIFO_IN1/s_axi_aresetn] [get_bd_pins $tmpname/ACC_BR_FIFO_IN1/ACC_FIFO_N/s_aresetn]
	connect_bd_net [get_bd_pins $tmpname/ACC_BR_FIFO_IN1/s_axi_aresetn] [get_bd_pins $tmpname/ACC_BR_FIFO_IN1/ACC_FIFO_E/s_aresetn]
	connect_bd_net [get_bd_pins $tmpname/ACC_BR_FIFO_IN1/s_axi_aresetn] [get_bd_pins $tmpname/ACC_BR_FIFO_IN1/ACC_FIFO_S/s_aresetn]
	connect_bd_net [get_bd_pins $tmpname/ACC_BR_FIFO_IN1/s_axi_aresetn] [get_bd_pins $tmpname/ACC_BR_FIFO_IN1/ACC_FIFO_W/s_aresetn]

	# -----------------------------------------------------------

	create_bd_cell -type hier $tmpname/ACC_BR_FIFO_IN2

	create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:12.0 $tmpname/ACC_BR_FIFO_IN2/ACC_FIFO_N
	set_property -dict [list CONFIG.INTERFACE_TYPE {AXI_STREAM} CONFIG.TDATA_NUM_BYTES {4} CONFIG.TUSER_WIDTH {0} CONFIG.Input_Depth_axis {16}] [get_bd_cells $tmpname/ACC_BR_FIFO_IN2/ACC_FIFO_N]
	create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:12.0 $tmpname/ACC_BR_FIFO_IN2/ACC_FIFO_E
	set_property -dict [list CONFIG.INTERFACE_TYPE {AXI_STREAM} CONFIG.TDATA_NUM_BYTES {4} CONFIG.TUSER_WIDTH {0} CONFIG.Input_Depth_axis {16}] [get_bd_cells $tmpname/ACC_BR_FIFO_IN2/ACC_FIFO_E]
	create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:12.0 $tmpname/ACC_BR_FIFO_IN2/ACC_FIFO_S
	set_property -dict [list CONFIG.INTERFACE_TYPE {AXI_STREAM} CONFIG.TDATA_NUM_BYTES {4} CONFIG.TUSER_WIDTH {0} CONFIG.Input_Depth_axis {16}] [get_bd_cells $tmpname/ACC_BR_FIFO_IN2/ACC_FIFO_S]
	create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:12.0 $tmpname/ACC_BR_FIFO_IN2/ACC_FIFO_W
	set_property -dict [list CONFIG.INTERFACE_TYPE {AXI_STREAM} CONFIG.TDATA_NUM_BYTES {4} CONFIG.TUSER_WIDTH {0} CONFIG.Input_Depth_axis {16}] [get_bd_cells $tmpname/ACC_BR_FIFO_IN2/ACC_FIFO_W]

	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/ACC_BR_FIFO_IN2/IN_N
	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/ACC_BR_FIFO_IN2/IN_E
	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/ACC_BR_FIFO_IN2/IN_S
	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/ACC_BR_FIFO_IN2/IN_W

	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/ACC_BR_FIFO_IN2/OUT_N
	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/ACC_BR_FIFO_IN2/OUT_E
	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/ACC_BR_FIFO_IN2/OUT_S
	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/ACC_BR_FIFO_IN2/OUT_W

	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN2/IN_N] [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN2/ACC_FIFO_N/S_AXIS]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN2/IN_E] [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN2/ACC_FIFO_E/S_AXIS]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN2/IN_S] [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN2/ACC_FIFO_S/S_AXIS]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN2/IN_W] [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN2/ACC_FIFO_W/S_AXIS]

	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN2/OUT_N] [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN2/ACC_FIFO_N/M_AXIS]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN2/OUT_E] [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN2/ACC_FIFO_E/M_AXIS]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN2/OUT_S] [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN2/ACC_FIFO_S/M_AXIS]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN2/OUT_W] [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN2/ACC_FIFO_W/M_AXIS]

	create_bd_pin -dir I $tmpname/ACC_BR_FIFO_IN2/s_axi_aclk
	connect_bd_net [get_bd_pins $tmpname/ACC_BR_FIFO_IN2/s_axi_aclk] [get_bd_pins $tmpname/ACC_BR_FIFO_IN2/ACC_FIFO_N/s_aclk]
	connect_bd_net [get_bd_pins $tmpname/ACC_BR_FIFO_IN2/s_axi_aclk] [get_bd_pins $tmpname/ACC_BR_FIFO_IN2/ACC_FIFO_E/s_aclk]
	connect_bd_net [get_bd_pins $tmpname/ACC_BR_FIFO_IN2/s_axi_aclk] [get_bd_pins $tmpname/ACC_BR_FIFO_IN2/ACC_FIFO_S/s_aclk]
	connect_bd_net [get_bd_pins $tmpname/ACC_BR_FIFO_IN2/s_axi_aclk] [get_bd_pins $tmpname/ACC_BR_FIFO_IN2/ACC_FIFO_W/s_aclk]

	create_bd_pin -dir I $tmpname/ACC_BR_FIFO_IN2/s_axi_aresetn
	connect_bd_net [get_bd_pins $tmpname/ACC_BR_FIFO_IN2/s_axi_aresetn] [get_bd_pins $tmpname/ACC_BR_FIFO_IN2/ACC_FIFO_N/s_aresetn]
	connect_bd_net [get_bd_pins $tmpname/ACC_BR_FIFO_IN2/s_axi_aresetn] [get_bd_pins $tmpname/ACC_BR_FIFO_IN2/ACC_FIFO_E/s_aresetn]
	connect_bd_net [get_bd_pins $tmpname/ACC_BR_FIFO_IN2/s_axi_aresetn] [get_bd_pins $tmpname/ACC_BR_FIFO_IN2/ACC_FIFO_S/s_aresetn]
	connect_bd_net [get_bd_pins $tmpname/ACC_BR_FIFO_IN2/s_axi_aresetn] [get_bd_pins $tmpname/ACC_BR_FIFO_IN2/ACC_FIFO_W/s_aresetn]

	# connect_bd_net -net [get_bd_nets microblaze_0_Clk] [get_bd_pins ACC_BR_FIFO_IN2/s_axi_aclk] [get_bd_pins clk_wiz_1/clk_out1]
	# connect_bd_net -net [get_bd_nets rst_clk_wiz_1_100M_peripheral_aresetn] [get_bd_pins ACC_BR_FIFO_IN2/s_axi_aresetn] [get_bd_pins rst_clk_wiz_1_100M/peripheral_aresetn]

	# #################################################################
	# SWITCH - FIFO Group2
	# #################################################################
	create_bd_cell -type hier $tmpname/ACC_PR_FIFO
	create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:12.0 $tmpname/ACC_PR_FIFO/ACC_FIFO_IN1
	set_property -dict [list CONFIG.INTERFACE_TYPE {AXI_STREAM} CONFIG.TDATA_NUM_BYTES {4} CONFIG.TUSER_WIDTH {0} CONFIG.Input_Depth_axis {16}] [get_bd_cells $tmpname/ACC_PR_FIFO/ACC_FIFO_IN1]
	create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:12.0 $tmpname/ACC_PR_FIFO/ACC_FIFO_IN2
	set_property -dict [list CONFIG.INTERFACE_TYPE {AXI_STREAM} CONFIG.TDATA_NUM_BYTES {4} CONFIG.TUSER_WIDTH {0} CONFIG.Input_Depth_axis {16}] [get_bd_cells $tmpname/ACC_PR_FIFO/ACC_FIFO_IN2]
	create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:12.0 $tmpname/ACC_PR_FIFO/ACC_FIFO_OUT
	set_property -dict [list CONFIG.INTERFACE_TYPE {AXI_STREAM} CONFIG.TDATA_NUM_BYTES {4} CONFIG.TUSER_WIDTH {0} CONFIG.Input_Depth_axis {16}] [get_bd_cells $tmpname/ACC_PR_FIFO/ACC_FIFO_OUT]
	create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:12.0 $tmpname/ACC_PR_FIFO/ACC_FIFO_CTRL_PR
	set_property -dict [list CONFIG.INTERFACE_TYPE {AXI_STREAM} CONFIG.TDATA_NUM_BYTES {4} CONFIG.TUSER_WIDTH {0} CONFIG.Input_Depth_axis {16}] [get_bd_cells $tmpname/ACC_PR_FIFO/ACC_FIFO_CTRL_PR]
	create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:12.0 $tmpname/ACC_PR_FIFO/ACC_FIFO_CTRL_PR_RESP
	set_property -dict [list CONFIG.INTERFACE_TYPE {AXI_STREAM} CONFIG.TDATA_NUM_BYTES {4} CONFIG.TUSER_WIDTH {0} CONFIG.Input_Depth_axis {16}] [get_bd_cells $tmpname/ACC_PR_FIFO/ACC_FIFO_CTRL_PR_RESP]
	create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:12.0 $tmpname/ACC_PR_FIFO/ACC_FIFO_SP
	set_property -dict [list CONFIG.INTERFACE_TYPE {AXI_STREAM} CONFIG.TDATA_NUM_BYTES {4} CONFIG.TUSER_WIDTH {0} CONFIG.Input_Depth_axis {16}] [get_bd_cells $tmpname/ACC_PR_FIFO/ACC_FIFO_SP]

	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/ACC_PR_FIFO/FF_sIN1
	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/ACC_PR_FIFO/FF_sIN2
	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/ACC_PR_FIFO/FF_sOUT

	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/ACC_PR_FIFO/FF_sCTRL
	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/ACC_PR_FIFO/FF_sCTRL_RESP
	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/ACC_PR_FIFO/FF_sSP

	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/ACC_PR_FIFO/FF_mIN1
	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/ACC_PR_FIFO/FF_mIN2
	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/ACC_PR_FIFO/FF_mOUT

	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/ACC_PR_FIFO/FF_mCTRL
	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/ACC_PR_FIFO/FF_mCTRL_RESP
	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/ACC_PR_FIFO/FF_mSP

	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_PR_FIFO/FF_sIN1] [get_bd_intf_pins $tmpname/ACC_PR_FIFO/ACC_FIFO_IN1/S_AXIS]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_PR_FIFO/FF_sIN2] [get_bd_intf_pins $tmpname/ACC_PR_FIFO/ACC_FIFO_IN2/S_AXIS]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_PR_FIFO/FF_sOUT] [get_bd_intf_pins $tmpname/ACC_PR_FIFO/ACC_FIFO_OUT/S_AXIS]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_PR_FIFO/FF_mIN1] [get_bd_intf_pins $tmpname/ACC_PR_FIFO/ACC_FIFO_IN1/M_AXIS]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_PR_FIFO/FF_mIN2] [get_bd_intf_pins $tmpname/ACC_PR_FIFO/ACC_FIFO_IN2/M_AXIS]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_PR_FIFO/FF_mOUT] [get_bd_intf_pins $tmpname/ACC_PR_FIFO/ACC_FIFO_OUT/M_AXIS]

	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_PR_FIFO/FF_sCTRL] [get_bd_intf_pins $tmpname/ACC_PR_FIFO/ACC_FIFO_CTRL_PR/S_AXIS]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_PR_FIFO/FF_sCTRL_RESP] [get_bd_intf_pins $tmpname/ACC_PR_FIFO/ACC_FIFO_CTRL_PR_RESP/S_AXIS]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_PR_FIFO/FF_sSP] [get_bd_intf_pins $tmpname/ACC_PR_FIFO/ACC_FIFO_SP/S_AXIS]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_PR_FIFO/FF_mCTRL] [get_bd_intf_pins $tmpname/ACC_PR_FIFO/ACC_FIFO_CTRL_PR/M_AXIS]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_PR_FIFO/FF_mCTRL_RESP] [get_bd_intf_pins $tmpname/ACC_PR_FIFO/ACC_FIFO_CTRL_PR_RESP/M_AXIS]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_PR_FIFO/FF_mSP] [get_bd_intf_pins $tmpname/ACC_PR_FIFO/ACC_FIFO_SP/M_AXIS]

	create_bd_pin -dir I $tmpname/ACC_PR_FIFO/s_axi_aclk
	connect_bd_net [get_bd_pins $tmpname/ACC_PR_FIFO/s_axi_aclk] [get_bd_pins $tmpname/ACC_PR_FIFO/ACC_FIFO_IN1/s_aclk]
	connect_bd_net [get_bd_pins $tmpname/ACC_PR_FIFO/s_axi_aclk] [get_bd_pins $tmpname/ACC_PR_FIFO/ACC_FIFO_IN2/s_aclk]
	connect_bd_net [get_bd_pins $tmpname/ACC_PR_FIFO/s_axi_aclk] [get_bd_pins $tmpname/ACC_PR_FIFO/ACC_FIFO_OUT/s_aclk]

	connect_bd_net [get_bd_pins $tmpname/ACC_PR_FIFO/s_axi_aclk] [get_bd_pins $tmpname/ACC_PR_FIFO/ACC_FIFO_CTRL_PR/s_aclk]
	connect_bd_net [get_bd_pins $tmpname/ACC_PR_FIFO/s_axi_aclk] [get_bd_pins $tmpname/ACC_PR_FIFO/ACC_FIFO_CTRL_PR_RESP/s_aclk]
	connect_bd_net [get_bd_pins $tmpname/ACC_PR_FIFO/s_axi_aclk] [get_bd_pins $tmpname/ACC_PR_FIFO/ACC_FIFO_SP/s_aclk]

	create_bd_pin -dir I $tmpname/ACC_PR_FIFO/s_axi_aresetn
	connect_bd_net [get_bd_pins $tmpname/ACC_PR_FIFO/s_axi_aresetn] [get_bd_pins $tmpname/ACC_PR_FIFO/ACC_FIFO_IN1/s_aresetn]
	connect_bd_net [get_bd_pins $tmpname/ACC_PR_FIFO/s_axi_aresetn] [get_bd_pins $tmpname/ACC_PR_FIFO/ACC_FIFO_IN2/s_aresetn]
	connect_bd_net [get_bd_pins $tmpname/ACC_PR_FIFO/s_axi_aresetn] [get_bd_pins $tmpname/ACC_PR_FIFO/ACC_FIFO_OUT/s_aresetn]

	connect_bd_net [get_bd_pins $tmpname/ACC_PR_FIFO/s_axi_aresetn] [get_bd_pins $tmpname/ACC_PR_FIFO/ACC_FIFO_CTRL_PR/s_aresetn]
	connect_bd_net [get_bd_pins $tmpname/ACC_PR_FIFO/s_axi_aresetn] [get_bd_pins $tmpname/ACC_PR_FIFO/ACC_FIFO_CTRL_PR_RESP/s_aresetn]
	connect_bd_net [get_bd_pins $tmpname/ACC_PR_FIFO/s_axi_aresetn] [get_bd_pins $tmpname/ACC_PR_FIFO/ACC_FIFO_SP/s_aresetn]

	# connect_bd_net -net [get_bd_nets microblaze_0_Clk] [get_bd_pins ACC_PR_FIFO/s_axi_aclk] [get_bd_pins clk_wiz_1/clk_out1]
	# connect_bd_net -net [get_bd_nets rst_clk_wiz_1_100M_peripheral_aresetn] [get_bd_pins ACC_PR_FIFO/s_axi_aresetn] [get_bd_pins rst_clk_wiz_1_100M/peripheral_aresetn]
	# #################################################################
	# SWITCH - Broadcast
	# #################################################################
	create_bd_cell -type ip -vlnv xilinx.com:hls:acc_broadcast:1.0 $tmpname/ACC_BC_N
	create_bd_cell -type ip -vlnv xilinx.com:hls:acc_broadcast:1.0 $tmpname/ACC_BC_E
	create_bd_cell -type ip -vlnv xilinx.com:hls:acc_broadcast:1.0 $tmpname/ACC_BC_S
	create_bd_cell -type ip -vlnv xilinx.com:hls:acc_broadcast:1.0 $tmpname/ACC_BC_W

	# connect_bd_net -net [get_bd_nets microblaze_0_Clk] [get_bd_pins $tmpname/ACC_BC_N/ap_clk] [get_bd_pins clk_wiz_1/clk_out1]
	# connect_bd_net -net [get_bd_nets rst_clk_wiz_1_100M_peripheral_aresetn] [get_bd_pins $tmpname/ACC_BC_N/ap_rst_n] [get_bd_pins rst_clk_wiz_1_100M/peripheral_aresetn]

	# connect_bd_net -net [get_bd_nets microblaze_0_Clk] [get_bd_pins $tmpname/ACC_BC_E/ap_clk] [get_bd_pins clk_wiz_1/clk_out1]
	# connect_bd_net -net [get_bd_nets rst_clk_wiz_1_100M_peripheral_aresetn] [get_bd_pins $tmpname/ACC_BC_E/ap_rst_n] [get_bd_pins rst_clk_wiz_1_100M/peripheral_aresetn]

	# connect_bd_net -net [get_bd_nets microblaze_0_Clk] [get_bd_pins $tmpname/ACC_BC_S/ap_clk] [get_bd_pins clk_wiz_1/clk_out1]
	# connect_bd_net -net [get_bd_nets rst_clk_wiz_1_100M_peripheral_aresetn] [get_bd_pins $tmpname/ACC_BC_S/ap_rst_n] [get_bd_pins rst_clk_wiz_1_100M/peripheral_aresetn]

	# connect_bd_net -net [get_bd_nets microblaze_0_Clk] [get_bd_pins $tmpname/ACC_BC_W/ap_clk] [get_bd_pins clk_wiz_1/clk_out1]
	# connect_bd_net -net [get_bd_nets rst_clk_wiz_1_100M_peripheral_aresetn] [get_bd_pins $tmpname/ACC_BC_W/ap_rst_n] [get_bd_pins rst_clk_wiz_1_100M/peripheral_aresetn]

	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_BC_N/mO1] -boundary_type upper [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN1/IN_N]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_BC_E/mO1] -boundary_type upper [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN1/IN_E]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_BC_S/mO1] -boundary_type upper [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN1/IN_S]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_BC_W/mO1] -boundary_type upper [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN1/IN_W]

	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_BC_N/mO2] -boundary_type upper [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN2/IN_N]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_BC_E/mO2] -boundary_type upper [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN2/IN_E]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_BC_S/mO2] -boundary_type upper [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN2/IN_S]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_BC_W/mO2] -boundary_type upper [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN2/IN_W]


	# #################################################################
	# SWITCH - in switch
	# #################################################################
	create_bd_cell -type ip -vlnv xilinx.com:hls:acc_in_switch:1.0 $tmpname/ACC_IN1_SWITCH

	# connect_bd_net -net [get_bd_nets microblaze_0_Clk] [get_bd_pins ACC_IN1_SWITCH/ap_clk] [get_bd_pins clk_wiz_1/clk_out1]
	# connect_bd_net -net [get_bd_nets rst_clk_wiz_1_100M_peripheral_aresetn] [get_bd_pins ACC_IN1_SWITCH/ap_rst_n] [get_bd_pins rst_clk_wiz_1_100M/peripheral_aresetn]

	create_bd_cell -type ip -vlnv xilinx.com:hls:acc_in_switch:1.0 $tmpname/ACC_IN2_SWITCH

	# connect_bd_net -net [get_bd_nets microblaze_0_Clk] [get_bd_pins ACC_IN2_SWITCH/ap_clk] [get_bd_pins clk_wiz_1/clk_out1]
	# connect_bd_net -net [get_bd_nets rst_clk_wiz_1_100M_peripheral_aresetn] [get_bd_pins ACC_IN2_SWITCH/ap_rst_n] [get_bd_pins rst_clk_wiz_1_100M/peripheral_aresetn]

	connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN1/OUT_N] [get_bd_intf_pins $tmpname/ACC_IN1_SWITCH/sN]
	connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN1/OUT_E] [get_bd_intf_pins $tmpname/ACC_IN1_SWITCH/sE]
	connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN1/OUT_S] [get_bd_intf_pins $tmpname/ACC_IN1_SWITCH/sS]
	connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN1/OUT_W] [get_bd_intf_pins $tmpname/ACC_IN1_SWITCH/sW]

	connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN2/OUT_N] [get_bd_intf_pins $tmpname/ACC_IN2_SWITCH/sN]
	connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN2/OUT_E] [get_bd_intf_pins $tmpname/ACC_IN2_SWITCH/sE]
	connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN2/OUT_S] [get_bd_intf_pins $tmpname/ACC_IN2_SWITCH/sS]
	connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmpname/ACC_BR_FIFO_IN2/OUT_W] [get_bd_intf_pins $tmpname/ACC_IN2_SWITCH/sW]
	# #################################################################
	# SWITCH - out switch
	# #################################################################
	create_bd_cell -type ip -vlnv xilinx.com:hls:acc_out_switch:1.0 $tmpname/ACC_OUT_SWITCH

	# connect_bd_net -net [get_bd_nets microblaze_0_Clk] [get_bd_pins ACC_OUT_SWITCH/ap_clk] [get_bd_pins clk_wiz_1/clk_out1]
	# connect_bd_net -net [get_bd_nets rst_clk_wiz_1_100M_peripheral_aresetn] [get_bd_pins ACC_OUT_SWITCH/ap_rst_n] [get_bd_pins rst_clk_wiz_1_100M/peripheral_aresetn]

	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_IN1_SWITCH/mSP] -boundary_type upper [get_bd_intf_pins $tmpname/ACC_PR_FIFO/FF_sSP]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_OUT_SWITCH/sSP] -boundary_type upper [get_bd_intf_pins $tmpname/ACC_PR_FIFO/FF_mSP]

	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_IN1_SWITCH/mI] -boundary_type upper [get_bd_intf_pins $tmpname/ACC_PR_FIFO/FF_sIN1]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_IN2_SWITCH/mI] -boundary_type upper [get_bd_intf_pins $tmpname/ACC_PR_FIFO/FF_sIN2]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_OUT_SWITCH/sO] -boundary_type upper [get_bd_intf_pins $tmpname/ACC_PR_FIFO/FF_mOUT]


	# #################################################################
	# SWITCH - Ctrl
	# #################################################################
	create_bd_cell -type ip -vlnv xilinx.com:hls:acc_ctrl:1.0 $tmpname/ACC_CTRL

	# connect_bd_net -net [get_bd_nets microblaze_0_Clk] [get_bd_pins ACC_CTRL/ap_clk] [get_bd_pins clk_wiz_1/clk_out1]
	# connect_bd_net -net [get_bd_nets rst_clk_wiz_1_100M_peripheral_aresetn] [get_bd_pins ACC_CTRL/ap_rst_n] [get_bd_pins rst_clk_wiz_1_100M/peripheral_aresetn]

	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_CTRL/ctrl_Is1] [get_bd_intf_pins $tmpname/ACC_IN1_SWITCH/cmd]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_CTRL/ctrl_Is2] [get_bd_intf_pins $tmpname/ACC_IN2_SWITCH/cmd]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_CTRL/ctrl_Os1] [get_bd_intf_pins $tmpname/ACC_OUT_SWITCH/cmd]

	# #################################################################
	# SWITCH - GROUP
	# #################################################################
	# group_bd_cells ACC_SWITCH00 [get_bd_cells ACC_BC_N] [get_bd_cells ACC_CTRL] [get_bd_cells ACC_IN1_SWITCH] [get_bd_cells ACC_BC_E] [get_bd_cells ACC_BC_S] [get_bd_cells ACC_OUT_SWITCH] [get_bd_cells ACC_BC_W] [get_bd_cells ACC_IN2_SWITCH] [get_bd_cells ACC_BR_FIFO_IN1] [get_bd_cells ACC_BR_FIFO_IN2] [get_bd_cells ACC_PR_FIFO]
	set cmdname cmd_[lindex $SWITCH_NAME_LIST $ii]
	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 $slave/$cmdname

	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/cmd
	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/pr_resp
	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/sN
	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/sE
	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/sS
	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/sW
	create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/sPR
	create_bd_pin -dir I $tmpname/s_axi_aclk

	connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $slave/$cmdname] [get_bd_intf_pins $tmpname/cmd]
	connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmpname/cmd] [get_bd_intf_pins $tmpname/ACC_CTRL/cmd]
	connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmpname/sN] [get_bd_intf_pins $tmpname/ACC_BC_N/sI]
	connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmpname/sE] [get_bd_intf_pins $tmpname/ACC_BC_E/sI]
	connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmpname/sS] [get_bd_intf_pins $tmpname/ACC_BC_S/sI]
	connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmpname/sW] [get_bd_intf_pins $tmpname/ACC_BC_W/sI]
	connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmpname/sPR] [get_bd_intf_pins $tmpname/ACC_PR_FIFO/FF_sOUT]
	connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmpname/ACC_PR_FIFO/FF_sCTRL_RESP] [get_bd_intf_pins $tmpname/pr_resp] 
	connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmpname/ACC_PR_FIFO/FF_sCTRL] [get_bd_intf_pins $tmpname/ACC_CTRL/ctrl_pr] 

	connect_bd_net [get_bd_pins $tmpname/s_axi_aclk] [get_bd_pins $tmpname/ACC_BC_N/ap_clk]
	connect_bd_net [get_bd_pins $tmpname/s_axi_aclk] [get_bd_pins $tmpname/ACC_BC_E/ap_clk]
	connect_bd_net [get_bd_pins $tmpname/s_axi_aclk] [get_bd_pins $tmpname/ACC_BC_S/ap_clk]
	connect_bd_net [get_bd_pins $tmpname/s_axi_aclk] [get_bd_pins $tmpname/ACC_BC_W/ap_clk]
	connect_bd_net [get_bd_pins $tmpname/s_axi_aclk] [get_bd_pins $tmpname/ACC_BR_FIFO_IN1/s_axi_aclk] -boundary_type upper
	connect_bd_net [get_bd_pins $tmpname/s_axi_aclk] [get_bd_pins $tmpname/ACC_BR_FIFO_IN2/s_axi_aclk] -boundary_type upper
	connect_bd_net [get_bd_pins $tmpname/s_axi_aclk] [get_bd_pins $tmpname/ACC_IN2_SWITCH/ap_clk]
	connect_bd_net [get_bd_pins $tmpname/s_axi_aclk] [get_bd_pins $tmpname/ACC_IN1_SWITCH/ap_clk]
	connect_bd_net [get_bd_pins $tmpname/s_axi_aclk] [get_bd_pins $tmpname/ACC_CTRL/ap_clk]
	connect_bd_net [get_bd_pins $tmpname/s_axi_aclk] [get_bd_pins $tmpname/ACC_PR_FIFO/s_axi_aclk] -boundary_type upper
	connect_bd_net [get_bd_pins $tmpname/s_axi_aclk] [get_bd_pins $tmpname/ACC_OUT_SWITCH/ap_clk]

	set respname resp_[lindex $SWITCH_NAME_LIST $ii]
	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 $slave/$respname

	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/resp
	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/ctrl_pr
	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/BC1
	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/BC2
	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/mN
	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/mE
	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/mS
	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/mW
	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/mPR1
	create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 $tmpname/mPR2
	create_bd_pin -dir I $tmpname/s_axi_aresetn

	connect_bd_intf_net [get_bd_intf_pins $tmpname/resp] [get_bd_intf_pins $slave/$respname]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/resp] [get_bd_intf_pins $tmpname/ACC_CTRL/resp]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_CTRL/ctrl_pr_resp] -boundary_type upper [get_bd_intf_pins $tmpname/ACC_PR_FIFO/FF_mCTRL_RESP]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ctrl_pr] -boundary_type upper [get_bd_intf_pins $tmpname/ACC_PR_FIFO/FF_mCTRL]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/BC1] [get_bd_intf_pins $tmpname/ACC_CTRL/BC1]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/BC2] [get_bd_intf_pins $tmpname/ACC_CTRL/BC2]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/mN] [get_bd_intf_pins $tmpname/ACC_OUT_SWITCH/mN]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/mE] [get_bd_intf_pins $tmpname/ACC_OUT_SWITCH/mE]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/mS] [get_bd_intf_pins $tmpname/ACC_OUT_SWITCH/mS]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/mW] [get_bd_intf_pins $tmpname/ACC_OUT_SWITCH/mW]
	connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmpname/ACC_PR_FIFO/FF_mIN1] [get_bd_intf_pins $tmpname/mPR1]
	connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmpname/ACC_PR_FIFO/FF_mIN2] [get_bd_intf_pins $tmpname/mPR2]

	connect_bd_net [get_bd_pins $tmpname/s_axi_aresetn] [get_bd_pins $tmpname/ACC_BC_N/ap_rst_n]
	connect_bd_net [get_bd_pins $tmpname/s_axi_aresetn] [get_bd_pins $tmpname/ACC_BC_E/ap_rst_n]
	connect_bd_net [get_bd_pins $tmpname/s_axi_aresetn] [get_bd_pins $tmpname/ACC_BC_S/ap_rst_n]
	connect_bd_net [get_bd_pins $tmpname/s_axi_aresetn] [get_bd_pins $tmpname/ACC_BC_W/ap_rst_n]
	connect_bd_net [get_bd_pins $tmpname/s_axi_aresetn] [get_bd_pins $tmpname/ACC_BR_FIFO_IN1/s_axi_aresetn] -boundary_type upper
	connect_bd_net [get_bd_pins $tmpname/s_axi_aresetn] [get_bd_pins $tmpname/ACC_BR_FIFO_IN2/s_axi_aresetn] -boundary_type upper
	connect_bd_net [get_bd_pins $tmpname/s_axi_aresetn] [get_bd_pins $tmpname/ACC_IN1_SWITCH/ap_rst_n]
	connect_bd_net [get_bd_pins $tmpname/s_axi_aresetn] [get_bd_pins $tmpname/ACC_IN2_SWITCH/ap_rst_n]
	connect_bd_net [get_bd_pins $tmpname/s_axi_aresetn] [get_bd_pins $tmpname/ACC_CTRL/ap_rst_n]
	connect_bd_net [get_bd_pins $tmpname/s_axi_aresetn] [get_bd_pins $tmpname/ACC_PR_FIFO/s_axi_aresetn] -boundary_type upper
	connect_bd_net [get_bd_pins $tmpname/s_axi_aresetn] [get_bd_pins $tmpname/ACC_OUT_SWITCH/ap_rst_n]

	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_CTRL/ctrl_BC_N] [get_bd_intf_pins $tmpname/ACC_BC_N/cmd]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_CTRL/ctrl_BC_E] [get_bd_intf_pins $tmpname/ACC_BC_E/cmd]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_CTRL/ctrl_BC_S] [get_bd_intf_pins $tmpname/ACC_BC_S/cmd]
	connect_bd_intf_net [get_bd_intf_pins $tmpname/ACC_CTRL/ctrl_BC_W] [get_bd_intf_pins $tmpname/ACC_BC_W/cmd]

	connect_bd_net 	[get_bd_pins $slave/s_axi_aclk] 	[get_bd_pins $tmpname/s_axi_aclk]
	connect_bd_net 	[get_bd_pins $slave/s_axi_aresetn] 	[get_bd_pins $tmpname/s_axi_aresetn]

	#regenerate_bd_layout -hierarchy [get_bd_cell $slave/$tmpname]
	#connect_bd_net -net [get_bd_nets $CLK] [get_bd_pins $tmpname/s_axi_aclk]
	#connect_bd_net -net [get_bd_nets $nRstName] [get_bd_pins $tmpname/s_axi_aresetn]
	##connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmpname/cmd]  [get_bd_intf_pins microblaze_0/M[expr $ii]_AXIS] 
	##connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmpname/resp] [get_bd_intf_pins microblaze_0/S[expr $ii]_AXIS]
}

# #################################################################
# Connections
# #################################################################
set tmp1 BRAM10
set tmp2 ACC_FF_C00
set tmp3 ACC_SWITCH_00
set tmp1 $slave/$tmp1
set tmp2 $slave/$tmp2
set tmp3 $slave/$tmp3
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp1/mBIF] 		[get_bd_intf_pins $tmp2/sFIFO_I]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/mFIFO_I]	[get_bd_intf_pins $tmp3/sN]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp3/mN] 		[get_bd_intf_pins $tmp2/sFIFO_O]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/mFIFO_O] 	[get_bd_intf_pins $tmp1/sBIF]

set tmp1 BRAM11
set tmp2 ACC_FF_C10
set tmp3 ACC_SWITCH_01
set tmp1 $slave/$tmp1
set tmp2 $slave/$tmp2
set tmp3 $slave/$tmp3
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp1/mBIF] 		[get_bd_intf_pins $tmp2/sFIFO_I]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/mFIFO_I]	[get_bd_intf_pins $tmp3/sN]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp3/mN] 		[get_bd_intf_pins $tmp2/sFIFO_O]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/mFIFO_O] 	[get_bd_intf_pins $tmp1/sBIF]
# ----------------------------------------
set tmp1 BRAM30
set tmp2 ACC_FF_C02
set tmp3 ACC_SWITCH_10
set tmp1 $slave/$tmp1
set tmp2 $slave/$tmp2
set tmp3 $slave/$tmp3
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp1/mBIF] 		[get_bd_intf_pins $tmp2/sFIFO_I]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/mFIFO_I]	[get_bd_intf_pins $tmp3/sS]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp3/mS] 		[get_bd_intf_pins $tmp2/sFIFO_O]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/mFIFO_O] 	[get_bd_intf_pins $tmp1/sBIF]

set tmp1 BRAM31
set tmp2 ACC_FF_C12
set tmp3 ACC_SWITCH_11
set tmp1 $slave/$tmp1
set tmp2 $slave/$tmp2
set tmp3 $slave/$tmp3
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp1/mBIF] 		[get_bd_intf_pins $tmp2/sFIFO_I]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/mFIFO_I]	[get_bd_intf_pins $tmp3/sS]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp3/mS] 		[get_bd_intf_pins $tmp2/sFIFO_O]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/mFIFO_O] 	[get_bd_intf_pins $tmp1/sBIF]
# ==========================================
set tmp1 BRAM20
set tmp2 ACC_FF_R02
set tmp3 ACC_SWITCH_01
set tmp1 $slave/$tmp1
set tmp2 $slave/$tmp2
set tmp3 $slave/$tmp3
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp1/mBIF] 		[get_bd_intf_pins $tmp2/sFIFO_I]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/mFIFO_I]	[get_bd_intf_pins $tmp3/sE]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp3/mE] 		[get_bd_intf_pins $tmp2/sFIFO_O]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/mFIFO_O] 	[get_bd_intf_pins $tmp1/sBIF]

set tmp1 BRAM21
set tmp2 ACC_FF_R12
set tmp3 ACC_SWITCH_11
set tmp1 $slave/$tmp1
set tmp2 $slave/$tmp2
set tmp3 $slave/$tmp3
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp1/mBIF] 		[get_bd_intf_pins $tmp2/sFIFO_I]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/mFIFO_I]	[get_bd_intf_pins $tmp3/sE]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp3/mE] 		[get_bd_intf_pins $tmp2/sFIFO_O]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/mFIFO_O] 	[get_bd_intf_pins $tmp1/sBIF]
# ----------------------------------------
set tmp1 BRAM40
set tmp2 ACC_FF_R00
set tmp3 ACC_SWITCH_00
set tmp1 $slave/$tmp1
set tmp2 $slave/$tmp2
set tmp3 $slave/$tmp3
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp1/mBIF] 		[get_bd_intf_pins $tmp2/sFIFO_I]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/mFIFO_I]	[get_bd_intf_pins $tmp3/sW]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp3/mW] 		[get_bd_intf_pins $tmp2/sFIFO_O]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/mFIFO_O] 	[get_bd_intf_pins $tmp1/sBIF]

set tmp1 BRAM41
set tmp2 ACC_FF_R10
set tmp3 ACC_SWITCH_10
set tmp1 $slave/$tmp1
set tmp2 $slave/$tmp2
set tmp3 $slave/$tmp3
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp1/mBIF] 		[get_bd_intf_pins $tmp2/sFIFO_I]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/mFIFO_I]	[get_bd_intf_pins $tmp3/sW]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp3/mW] 		[get_bd_intf_pins $tmp2/sFIFO_O]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/mFIFO_O] 	[get_bd_intf_pins $tmp1/sBIF]
# ----------------------------------------

set tmp1 ACC_SWITCH_00
set tmp2 ACC_FF_C01
set tmp3 ACC_SWITCH_10
set tmp1 $slave/$tmp1
set tmp2 $slave/$tmp2
set tmp3 $slave/$tmp3
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp1/mS] 		[get_bd_intf_pins $tmp2/sFIFO_I]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/mFIFO_I]	[get_bd_intf_pins $tmp3/sN]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp3/mN] 		[get_bd_intf_pins $tmp2/sFIFO_O]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/mFIFO_O] 	[get_bd_intf_pins $tmp1/sS]

set tmp1 ACC_SWITCH_01
set tmp2 ACC_FF_C11
set tmp3 ACC_SWITCH_11
set tmp1 $slave/$tmp1
set tmp2 $slave/$tmp2
set tmp3 $slave/$tmp3
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp1/mS] 		[get_bd_intf_pins $tmp2/sFIFO_I]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/mFIFO_I]	[get_bd_intf_pins $tmp3/sN]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp3/mN] 		[get_bd_intf_pins $tmp2/sFIFO_O]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/mFIFO_O] 	[get_bd_intf_pins $tmp1/sS]

# ----------------------------------------
set tmp1 ACC_SWITCH_00
set tmp2 ACC_FF_R01
set tmp3 ACC_SWITCH_01
set tmp1 $slave/$tmp1
set tmp2 $slave/$tmp2
set tmp3 $slave/$tmp3
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp1/mE] 		[get_bd_intf_pins $tmp2/sFIFO_I]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/mFIFO_I]	[get_bd_intf_pins $tmp3/sW]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp3/mW] 		[get_bd_intf_pins $tmp2/sFIFO_O]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/mFIFO_O] 	[get_bd_intf_pins $tmp1/sE]

set tmp1 ACC_SWITCH_10
set tmp2 ACC_FF_R11
set tmp3 ACC_SWITCH_11
set tmp1 $slave/$tmp1
set tmp2 $slave/$tmp2
set tmp3 $slave/$tmp3
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp1/mE] 		[get_bd_intf_pins $tmp2/sFIFO_I]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/mFIFO_I]	[get_bd_intf_pins $tmp3/sW]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp3/mW] 		[get_bd_intf_pins $tmp2/sFIFO_O]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/mFIFO_O] 	[get_bd_intf_pins $tmp1/sE]
# ----------------------------------------

# ######################################
# PR
# ######################################
set tmpname $slave
create_bd_cell -type ip -vlnv xilinx.com:hls:acc_pr:1.0 $slave/ACC_PR00
create_bd_cell -type ip -vlnv xilinx.com:hls:acc_pr:1.0 $slave/ACC_PR01
create_bd_cell -type ip -vlnv xilinx.com:hls:acc_pr:1.0 $slave/ACC_PR10
create_bd_cell -type ip -vlnv xilinx.com:hls:acc_pr:1.0 $slave/ACC_PR11

set tmp1 ACC_PR00
set tmp2 ACC_SWITCH_00
set tmp1 $slave/$tmp1
set tmp2 $slave/$tmp2
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/mPR1] 		[get_bd_intf_pins $tmp1/sI1]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/mPR2] 		[get_bd_intf_pins $tmp1/sI2]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/sPR] 		[get_bd_intf_pins $tmp1/mO1] 
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/pr_resp]	[get_bd_intf_pins $tmp1/resp]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/ctrl_pr] 	[get_bd_intf_pins $tmp1/cmd]

set tmp1 ACC_PR01
set tmp2 ACC_SWITCH_01
set tmp1 $slave/$tmp1
set tmp2 $slave/$tmp2
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/mPR1] 		[get_bd_intf_pins $tmp1/sI1]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/mPR2] 		[get_bd_intf_pins $tmp1/sI2]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/sPR] 		[get_bd_intf_pins $tmp1/mO1] 
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/pr_resp]	[get_bd_intf_pins $tmp1/resp]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/ctrl_pr] 	[get_bd_intf_pins $tmp1/cmd]

set tmp1 ACC_PR10
set tmp2 ACC_SWITCH_10
set tmp1 $slave/$tmp1
set tmp2 $slave/$tmp2
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/mPR1] 		[get_bd_intf_pins $tmp1/sI1]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/mPR2] 		[get_bd_intf_pins $tmp1/sI2]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/sPR] 		[get_bd_intf_pins $tmp1/mO1] 
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/pr_resp]	[get_bd_intf_pins $tmp1/resp]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/ctrl_pr] 	[get_bd_intf_pins $tmp1/cmd]

set tmp1 ACC_PR11
set tmp2 ACC_SWITCH_11
set tmp1 $slave/$tmp1
set tmp2 $slave/$tmp2
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/mPR1] 		[get_bd_intf_pins $tmp1/sI1]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/mPR2] 		[get_bd_intf_pins $tmp1/sI2]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/sPR] 		[get_bd_intf_pins $tmp1/mO1] 
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/pr_resp]	[get_bd_intf_pins $tmp1/resp]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $tmp2/ctrl_pr] 	[get_bd_intf_pins $tmp1/cmd]
 
connect_bd_net [get_bd_pins $slave/s_axi_aclk] [get_bd_pins $slave/ACC_PR00/ap_clk]
connect_bd_net [get_bd_pins $slave/s_axi_aclk] [get_bd_pins $slave/ACC_PR01/ap_clk]
connect_bd_net [get_bd_pins $slave/s_axi_aclk] [get_bd_pins $slave/ACC_PR10/ap_clk]
connect_bd_net [get_bd_pins $slave/s_axi_aclk] [get_bd_pins $slave/ACC_PR11/ap_clk]

connect_bd_net [get_bd_pins $slave/s_axi_aresetn] [get_bd_pins $slave/ACC_PR00/ap_rst_n]
connect_bd_net [get_bd_pins $slave/s_axi_aresetn] [get_bd_pins $slave/ACC_PR01/ap_rst_n]
connect_bd_net [get_bd_pins $slave/s_axi_aresetn] [get_bd_pins $slave/ACC_PR10/ap_rst_n]
connect_bd_net [get_bd_pins $slave/s_axi_aresetn] [get_bd_pins $slave/ACC_PR11/ap_rst_n]

# #####################################
set S  ACC_SWITCH_00
set B1 BRAM10
set B2 BRAM40
set S $slave/$S
set B1 $slave/$B1
set B2 $slave/$B2
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $S/BC1] [get_bd_intf_pins $B1/cmd]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $S/BC2] [get_bd_intf_pins $B2/cmd]

set S  ACC_SWITCH_01
set B1 BRAM11
set B2 BRAM20
set S $slave/$S
set B1 $slave/$B1
set B2 $slave/$B2
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $S/BC1] [get_bd_intf_pins $B1/cmd]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $S/BC2] [get_bd_intf_pins $B2/cmd]

set S  ACC_SWITCH_11
set B1 BRAM31
set B2 BRAM21
set S $slave/$S
set B1 $slave/$B1
set B2 $slave/$B2
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $S/BC1] [get_bd_intf_pins $B1/cmd]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $S/BC2] [get_bd_intf_pins $B2/cmd]

set S  ACC_SWITCH_10
set B1 BRAM30
set B2 BRAM41
set S $slave/$S
set B1 $slave/$B1
set B2 $slave/$B2
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $S/BC1] [get_bd_intf_pins $B1/cmd]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $S/BC2] [get_bd_intf_pins $B2/cmd]
# #####################################













#Which accelerator?
#create_bd_cell -type ip -vlnv xilinx.com:hls:vectoradd:1.0 $slave/acc_0
create_bd_cell -type ip -vlnv user.org:user:hw_acc_vector:1.0 $slave/acc_0

if {0} \
{
   if {$i == 0} {
       create_bd_cell -type ip -vlnv xilinx.com:hls:matrix_m:1.0 $slave/acc_0
   } elseif {$i == 1} {
       create_bd_cell -type ip -vlnv user.org:user:hdl_crc:1.0 $slave/acc_0
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

set_property -dict [list CONFIG.NUM_SI {2} CONFIG.NUM_MI {4} CONFIG.ENABLE_ADVANCED_OPTIONS {1} CONFIG.XBAR_DATA_WIDTH.VALUE_SRC USER  CONFIG.XBAR_DATA_WIDTH {32}  ]  [get_bd_cells $slave/dma_bus] 


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
connect_bd_intf_net [get_bd_intf_pins $slave/acc_0/cmd]  [get_bd_intf_pins $slave/microblaze_1/M0_AXIS] 


connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $slave/group1_bus/M01_AXI] [get_bd_intf_pins $slave/local_dma/S_AXI_LITE]
connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $slave/group1_bus/M02_AXI] [get_bd_intf_pins  $slave/dma_bus/S00_AXI]


connect_bd_intf_net [get_bd_intf_pins $slave/local_dma/M_AXI] -boundary_type upper [get_bd_intf_pins $slave/dma_bus/S01_AXI]
connect_bd_intf_net [get_bd_intf_pins $slave/axi_bram_ctrl_a/S_AXI] -boundary_type upper [get_bd_intf_pins $slave/dma_bus/M01_AXI]
connect_bd_intf_net [get_bd_intf_pins $slave/axi_bram_ctrl_b/S_AXI] -boundary_type upper [get_bd_intf_pins $slave/dma_bus/M02_AXI]
connect_bd_intf_net [get_bd_intf_pins $slave/axi_bram_ctrl_result/S_AXI] -boundary_type upper [get_bd_intf_pins $slave/dma_bus/M03_AXI]



#clk and reset connections
connect_bd_net [get_bd_pins $slave/microblaze_1/Clk] [get_bd_pins ddr_bus/ACLK]
connect_bd_net [get_bd_pins $slave/microblaze_1/Reset] [get_bd_pins host/Reset]
connect_bd_net [get_bd_pins $slave/microblaze_0_local_memory/LMB_Rst] [get_bd_pins host_local_memory/LMB_Rst]
connect_bd_net [get_bd_pins $slave/global_vhwti_cntrl_[expr $j * $C + $i]/s_axi_aresetn] [get_bd_pins peripherals/peripheral_aresetn]
connect_bd_net [get_bd_pins $slave/group1_bus/aresetn] [get_bd_pins peripherals/interconnect_aresetn] -boundary_type upper


foreach module [list local_vhwti_cntrl axi_bram_ctrl_a axi_bram_ctrl_b axi_bram_ctrl_result ]\
{
   connect_bd_net -net [get_bd_nets $slave/s_axi_aresetn_1] [get_bd_pins $slave/s_axi_aresetn]  [get_bd_pins $slave/$module//s_axi_aresetn] 
}
connect_bd_net -net [get_bd_nets $slave/s_axi_aresetn_1] [get_bd_pins $slave/s_axi_aresetn] [get_bd_pins $slave/local_dma/s_axi_lite_aresetn]
connect_bd_net -net [get_bd_nets $slave/aresetn_1] [get_bd_pins $slave/aresetn] [get_bd_pins $slave/dma_bus/aresetn]
connect_bd_net -net [get_bd_nets $slave/s_axi_aresetn_1] [get_bd_pins $slave/s_axi_aresetn] [get_bd_pins $slave/acc_0/ap_rst_n]



foreach module [list acc_0/ap_clk  microblaze_0_local_memory/LMB_Clk  axi_bram_ctrl_a/s_axi_aclk axi_bram_ctrl_b/s_axi_aclk axi_bram_ctrl_result/s_axi_aclk dma_bus/aclk local_dma/m_axi_aclk local_dma/s_axi_lite_aclk local_vhwti_cntrl/s_axi_aclk global_vhwti_cntrl_[expr $j * $C + $i]/s_axi_aclk  group1_bus/aclk]\
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




