for {set j 0} {$j < $N} {incr j} \
{
   set group group_$j 
   create_bd_cell -type hier $group
   #create C slaves in each group
   for {set i 0} {$i < $C} {incr i} \
   {   
      if {$node == "smp"} {
            source ./nodes_arch/smp_node.tcl  
      } elseif {$node == "numa"} {
            source ./nodes_arch/numa_node.tcl   
      } elseif {$node == "hemps_smp"} {
            source ./nodes_arch/hemps_smp_node.tcl   
      } elseif {$node == "hemps_numa"} {
           source ./nodes_arch/hemps_numa_node.tcl   
      }    

   }
   
   
  



   #If there are only one slave in each group, then there is no need to create the intermediate buses.
   if  { $C > 1 } \
   {
      #inside group buses & connections
      create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 $group/vhwti_bus         
      create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 $group/main_bus
      create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 $group/ddr_bus

      set_property -dict [list CONFIG.NUM_SI [expr $C ]  CONFIG.NUM_MI {1} CONFIG.ENABLE_ADVANCED_OPTIONS {1} CONFIG.XBAR_DATA_WIDTH.VALUE_SRC USER  CONFIG.XBAR_DATA_WIDTH {32}  CONFIG.STRATEGY {1}]  [get_bd_cells $group/main_bus] 

      set_property -dict [list CONFIG.NUM_SI {2} CONFIG.NUM_MI [expr $C ] CONFIG.ENABLE_ADVANCED_OPTIONS {1} CONFIG.XBAR_DATA_WIDTH.VALUE_SRC USER  CONFIG.XBAR_DATA_WIDTH {32}  CONFIG.STRATEGY {1}]  [get_bd_cells $group/vhwti_bus] 

      set_property -dict [list CONFIG.NUM_SI [expr $C ]  CONFIG.NUM_MI {1} CONFIG.ENABLE_ADVANCED_OPTIONS {1} CONFIG.XBAR_DATA_WIDTH.VALUE_SRC USER  CONFIG.XBAR_DATA_WIDTH {32}  ]  [get_bd_cells $group/ddr_bus] 

      
         create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 $group/dma_bus
         set_property -dict [list CONFIG.NUM_SI [expr $C ]  CONFIG.NUM_MI {1} CONFIG.ENABLE_ADVANCED_OPTIONS {1} CONFIG.XBAR_DATA_WIDTH.VALUE_SRC USER  CONFIG.XBAR_DATA_WIDTH {32}  ]  [get_bd_cells $group/dma_bus]          
     
      #clk and reset for Top level buses
      foreach module [list vhwti_bus  main_bus ddr_bus dma_bus]\
      {
         connect_bd_net  -quiet -net [get_bd_nets $group/Clk_1] [get_bd_pins $group/Clk] [get_bd_pins $group/$module/aclk] 
         connect_bd_net  -quiet -net [get_bd_nets $group/ARESETN_1] [get_bd_pins $group/ARESETN] [get_bd_pins $group/$module/aresetn]
         for {set i 0} {$i < 16} {incr i} \
         {
           connect_bd_net  -quiet -net [get_bd_nets $group/Clk_1] [get_bd_pins $group/Clk] [get_bd_pins $group/$module/M[format "%02d" [expr $i]]_ACLK]
           connect_bd_net -quiet -net [get_bd_nets $group/s_axi_aresetn_1] [get_bd_pins $group/s_axi_aresetn] [get_bd_pins $group/$module/M[format "%02d" [expr $i]]_ARESETN]
           connect_bd_net  -quiet -net [get_bd_nets $group/Clk_1] [get_bd_pins $group/Clk] [get_bd_pins $group/$module/S[format "%02d" [expr $i]]_ACLK]
           connect_bd_net -quiet -net [get_bd_nets $group/s_axi_aresetn_1] [get_bd_pins $group/s_axi_aresetn] [get_bd_pins $group/$module/S[format "%02d" [expr $i]]_ARESETN]
                   
         } 
       }      
      

      for {set i 0} {$i < $C} {incr i} \
      {
         set slave slave_$i
         set main S[format "%02d" $i]_AXI
         set ddr S[format "%02d" $i]_AXI
         set vhwti M[format "%02d" $i]_AXI
         set dma S[format "%02d" $i]_AXI
         connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $group/$slave/group1_bus/M00_AXI]       [get_bd_intf_pins $group/main_bus/$main]
         connect_bd_intf_net [get_bd_intf_pins $group/$slave/microblaze_1/M_AXI_IC] -boundary_type upper    [get_bd_intf_pins $group/ddr_bus/$ddr]
         if { $node == "smp" || $node=="hemps_smp" } { 
              connect_bd_intf_net [get_bd_intf_pins $group/$slave/global_vhwti_cntrl_[expr $j * $C + $i]/S_AXI] -boundary_type upper [get_bd_intf_pins $group/vhwti_bus/$vhwti]
         } elseif { $node == "numa" || $node=="hemps_numa"} {
              connect_bd_intf_net [get_bd_intf_pins $group/$slave/dma_bus/S01_AXI] -boundary_type upper [get_bd_intf_pins $group/vhwti_bus/$vhwti] }
         
         
         connect_bd_intf_net -quiet [get_bd_intf_pins $group/$slave/dma_bus/M00_AXI] -boundary_type upper [get_bd_intf_pins $group/dma_bus/$dma]
      }
      
      
   }   

}


