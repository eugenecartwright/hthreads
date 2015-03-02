
if  { $C > 1 } \
  {
      for {set i 0} {$i < $N} {incr i} \
      {
         set group group_$i
         set main S[format "%02d" [expr $i+1]]_AXI
         set ddr S[format "%02d" [expr $i+4]]_AXI
         set dma S[format "%02d" [expr $i]]_AXI
         set vhwti_host  M[format "%02d" [expr $i+1]]_AXI
         set vhwti_cores M[format "%02d" [expr $i+1]]_AXI
         connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $group/main_bus/M00_AXI]       [get_bd_intf_pins main_bus/$main]
         connect_bd_intf_net [get_bd_intf_pins $group/ddr_bus/M00_AXI] -boundary_type upper    [get_bd_intf_pins ddr_bus/$ddr]
         connect_bd_intf_net -quiet [get_bd_intf_pins $group/dma_bus/M00_AXI] -boundary_type upper    [get_bd_intf_pins dma_bus/$dma]
         connect_bd_intf_net [get_bd_intf_pins $group/vhwti_bus/S00_AXI] -boundary_type upper [get_bd_intf_pins host_bus/$vhwti_host]
         connect_bd_intf_net [get_bd_intf_pins $group/vhwti_bus/S01_AXI] -boundary_type upper [get_bd_intf_pins hthread_core/core_bus_master/$vhwti_cores]

      }
  } \
else \
{ 
 
   #core&main bus to vhwti bus
   connect_bd_intf_net -boundary_type upper [get_bd_intf_pins hthread_core/core_bus_master/M01_AXI] [get_bd_intf_pins vhwti_bus/S01_AXI]
   connect_bd_intf_net -boundary_type upper [get_bd_intf_pins host_bus/M01_AXI] [get_bd_intf_pins vhwti_bus/S00_AXI]
   for {set i 0} {$i < $N} {incr i} \
      {
         set group group_$i
         set main S[format "%02d" [expr $i+1]]_AXI
         set ddr S[format "%02d" [expr $i+4]]_AXI
         set vhwti  M[format "%02d" [expr $i]]_AXI
         set dma S[format "%02d" [expr $i]]_AXI
         connect_bd_intf_net -boundary_type upper [get_bd_intf_pins $group/slave_0/group1_bus/M00_AXI]       [get_bd_intf_pins main_bus/$main]
         connect_bd_intf_net [get_bd_intf_pins $group/slave_0/microblaze_1/M_AXI_IC] -boundary_type upper    [get_bd_intf_pins ddr_bus/$ddr]
         #connecting vhwti bus
         if { $node == "smp" || $node=="hemps_smp" } { 
               connect_bd_intf_net [get_bd_intf_pins $group/slave_0/global_vhwti_cntrl_[expr $i]/S_AXI]  [get_bd_intf_pins /vhwti_bus/$vhwti]   
         } elseif { $node == "numa" || $node=="hemps_numa"} {
               connect_bd_intf_net [get_bd_intf_pins $group/slave_0/dma_bus/S01_AXI]  [get_bd_intf_pins /vhwti_bus/$vhwti] }
         
         
       
         
         connect_bd_intf_net -quiet [get_bd_intf_pins $group/slave_0/dma_bus/M00_AXI] -boundary_type upper    [get_bd_intf_pins dma_bus/$dma]
      }
   }   
   

