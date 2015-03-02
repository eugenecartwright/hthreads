#num of segments
set n 0

##=====================================================================
##Hthread cores
##=====================================================================
foreach module [ list hthread_core/axi_cond_vars_0/m_axi_lite  hthread_core/axi_scheduler_0/m_axi_lite  hthread_core/axi_sync_manager_0/m_axi_lite]\
{
   #hthread cores:
   create_bd_addr_seg   -range 16M -offset 0x12000000 [get_bd_addr_spaces  $module] [get_bd_addr_segs hthread_core/axi_scheduler_0/S_AXI/reg0] SEG[expr $n]
   incr n
   create_bd_addr_seg   -range 16M -offset 0x13000000 [get_bd_addr_spaces  $module] [get_bd_addr_segs hthread_core/axi_sync_manager_0/S_AXI/reg0] SEG[expr $n]
   incr n
   create_bd_addr_seg   -range 512k -offset 0x11100000 [get_bd_addr_spaces  $module] [get_bd_addr_segs hthread_core/axi_cond_vars_0/S_AXI/reg0] SEG[expr $n]
   incr n
   create_bd_addr_seg   -range 256k -offset 0x11000000 [get_bd_addr_spaces  $module] [get_bd_addr_segs hthread_core/axi_thread_manager_0/S_AXI/reg0] SEG[expr $n]
   incr n
   create_bd_addr_seg   -range 64k -offset 0x14000000 [get_bd_addr_spaces  $module] [get_bd_addr_segs hthread_core/axi_hthread_reset_core_0/S_AXI/reg0] SEG[expr $n]
   incr n
# Global vhwti brams
      for {set j 0} {$j < $N} {incr j} \
      {     
      for {set i 0} {$i < $C} {incr i} \
      {     
      create_bd_addr_seg   -range 4k -offset 0xC0[format "%02x" [expr $j * $C + $i]]0000 [get_bd_addr_spaces  $module] [get_bd_addr_segs group_[expr $j]/slave_[expr $i]/global_vhwti_cntrl_[expr $j * $C + $i]/S_AXI/Mem0] SEG[expr $n]
      incr n 
     }
     }
}




##=====================================================================
##Host CPU
##=====================================================================
set module host
#Hthread cores
   create_bd_addr_seg   -range 16M -offset 0x12000000 [get_bd_addr_spaces  $module/Data] [get_bd_addr_segs hthread_core/axi_scheduler_0/S_AXI/reg0] SEG[expr $n]
     incr n 
   create_bd_addr_seg   -range 16M -offset 0x13000000 [get_bd_addr_spaces  $module/Data] [get_bd_addr_segs hthread_core/axi_sync_manager_0/S_AXI/reg0] SEG[expr $n]
     incr n 
   create_bd_addr_seg   -range 512k -offset 0x11100000 [get_bd_addr_spaces  $module/Data] [get_bd_addr_segs hthread_core/axi_cond_vars_0/S_AXI/reg0] SEG[expr $n]
     incr n 
   create_bd_addr_seg   -range 256k -offset 0x11000000 [get_bd_addr_spaces  $module/Data] [get_bd_addr_segs hthread_core/axi_thread_manager_0/S_AXI/reg0] SEG[expr $n]
     incr n 
   create_bd_addr_seg   -range 64k -offset 0x14000000 [get_bd_addr_spaces  $module/Data] [get_bd_addr_segs hthread_core/axi_hthread_reset_core_0/S_AXI/reg0] SEG[expr $n]
      incr n 

#global vhwti brams
for {set j 0} {$j < $N} {incr j} \
      {     
      for {set i 0} {$i < $C} {incr i} \
      {     
      create_bd_addr_seg   -range 4k -offset 0xC0[format "%02x" [expr $j * $C + $i]]0000 [get_bd_addr_spaces  $module/Data] [get_bd_addr_segs group_[expr $j]/slave_[expr $i]/global_vhwti_cntrl_[expr $j * $C + $i]/S_AXI/Mem0] SEG[expr $n]
         incr n 
     }
     }
#Memory & peripherals     
#create_bd_addr_seg   -range 64k -offset   0x00000000 [get_bd_addr_spaces $module/Data] [get_bd_addr_segs host_local_memory/dlmb_bram_if_cntlr/SLMB/Mem] SEG[expr $n]
#    incr n 
create_bd_addr_seg   -range 1G -offset    0x80000000 [get_bd_addr_spaces $module/Data] [get_bd_addr_segs peripherals/mig_7series_0/memmap/memaddr ] SEG[expr $n]
     incr n 
create_bd_addr_seg   -range 64k -offset   0x41200000 [get_bd_addr_spaces $module/Data] [get_bd_addr_segs peripherals/axi_intc_0/s_axi/Reg] SEG[expr $n]
     incr n 
create_bd_addr_seg   -range 64k -offset   0x40600000 [get_bd_addr_spaces $module/Data] [get_bd_addr_segs peripherals/axi_uartlite_0/S_AXI/Reg] SEG[expr $n]
     incr n 
create_bd_addr_seg   -range 64k -offset   0x40200000 [get_bd_addr_spaces $module/Data] [get_bd_addr_segs peripherals/axi_hwicap_0/S_AXI_LITE/Reg] SEG[expr $n]
     incr n 
create_bd_addr_seg   -range 64k -offset   0x41C00000 [get_bd_addr_spaces $module/Data] [get_bd_addr_segs peripherals/axi_timer_0/S_AXI/Reg] SEG[expr $n]
     incr n 
create_bd_addr_seg   -range 64k -offset   0x44A00000 [get_bd_addr_spaces $module/Data] [get_bd_addr_segs peripherals/central_dma/S_AXI_LITE/Reg] SEG[expr $n]
    incr n 
create_bd_addr_seg   -range 64k -offset   0x41400000 [get_bd_addr_spaces $module/Data] [get_bd_addr_segs peripherals/mdm_1/S_AXI/Reg] SEG[expr $n]
      incr n 
#create_bd_addr_seg   -range 64k -offset   0x00000000 [get_bd_addr_spaces  $module/Instruction] [get_bd_addr_segs host_local_memory/ilmb_bram_if_cntlr/SLMB/Mem] SEG[expr $n]
#     incr n 
create_bd_addr_seg   -range 1G -offset    0x80000000 [get_bd_addr_spaces  $module/Instruction] [get_bd_addr_segs peripherals/mig_7series_0/memmap/memaddr] SEG[expr $n]
    incr n 





##=====================================================================
##Slave CPUS
##=====================================================================
for {set j 0} {$j < $N} {incr j} \
{   
for {set i 0} {$i < $C} {incr i} \
{
set group group_$j 
set slave slave_$i
set module $group/$slave/microblaze_1
#Hthread cores
create_bd_addr_seg   -range 16M -offset    0x12000000 [get_bd_addr_spaces  $module/Data] [get_bd_addr_segs hthread_core/axi_scheduler_0/S_AXI/reg0] SEG[expr $n]
 incr n 
create_bd_addr_seg   -range 16M -offset    0x13000000 [get_bd_addr_spaces  $module/Data] [get_bd_addr_segs hthread_core/axi_sync_manager_0/S_AXI/reg0] SEG[expr $n] 
 incr n 
create_bd_addr_seg   -range 512k -offset   0x11100000 [get_bd_addr_spaces  $module/Data] [get_bd_addr_segs hthread_core/axi_cond_vars_0/S_AXI/reg0] SEG[expr $n]
 incr n 
create_bd_addr_seg   -range 256k -offset   0x11000000 [get_bd_addr_spaces  $module/Data] [get_bd_addr_segs hthread_core/axi_thread_manager_0/S_AXI/reg0] SEG[expr $n]
  incr n 
create_bd_addr_seg   -range 64k -offset    0x14000000 [get_bd_addr_spaces  $module/Data] [get_bd_addr_segs hthread_core/axi_hthread_reset_core_0/S_AXI/reg0] SEG[expr $n]
 incr n 

#local VHWTI addresses
if { $node == "smp" || $node=="hemps_smp" } {
   create_bd_addr_seg   -range 4k -offset    0xC0000000 [get_bd_addr_spaces  $module/Data] [get_bd_addr_segs $group/$slave/local_vhwti_cntrl/S_AXI/Mem0] SEG[expr $n]
   }
incr n 

#memory and peripherals   
create_bd_addr_seg   -range 8k -offset   0x00000000 [get_bd_addr_spaces $module/Data] [get_bd_addr_segs $group/$slave/microblaze_0_local_memory/dlmb_bram_if_cntlr/SLMB/Mem] SEG[expr $n]
 incr n 
 create_bd_addr_seg   -range 8k -offset   0x00000000 [get_bd_addr_spaces $module/Instruction] [get_bd_addr_segs $group/$slave/microblaze_0_local_memory/ilmb_bram_if_cntlr/SLMB/Mem] SEG[expr $n]
 incr n 
create_bd_addr_seg   -range 1G -offset    0x80000000 [get_bd_addr_spaces $module/Data] [get_bd_addr_segs peripherals/mig_7series_0/memmap/memaddr ] SEG[expr $n]
 incr n 
create_bd_addr_seg   -range 64k -offset   0x41200000 [get_bd_addr_spaces $module/Data] [get_bd_addr_segs peripherals/axi_intc_0/s_axi/Reg] SEG[expr $n]
  incr n 
create_bd_addr_seg   -range 64k -offset   0x40600000 [get_bd_addr_spaces $module/Data] [get_bd_addr_segs peripherals/axi_uartlite_0/S_AXI/Reg] SEG[expr $n]
  incr n 
create_bd_addr_seg   -range 64k -offset   0x40200000 [get_bd_addr_spaces $module/Data] [get_bd_addr_segs peripherals/axi_hwicap_0/S_AXI_LITE/Reg] SEG[expr $n]
 incr n 
create_bd_addr_seg   -range 64k -offset   0x41C00000 [get_bd_addr_spaces $module/Data] [get_bd_addr_segs peripherals/axi_timer_0/S_AXI/Reg] SEG[expr $n]
 incr n 
create_bd_addr_seg   -range 64k -offset   0x44A00000 [get_bd_addr_spaces $module/Data] [get_bd_addr_segs peripherals/central_dma/S_AXI_LITE/Reg] SEG[expr $n]
 incr n 
create_bd_addr_seg   -range 64k -offset   0x41400000 [get_bd_addr_spaces $module/Data] [get_bd_addr_segs peripherals/mdm_1/S_AXI/Reg] SEG[expr $n]
  incr n 

create_bd_addr_seg   -range 1G -offset    0x80000000 [get_bd_addr_spaces $module/Instruction] [get_bd_addr_segs peripherals/mig_7series_0/memmap/memaddr] SEG[expr $n]
 incr n 
   
}
}

##=====================================================================
##Local dma engines in a hemps system
##=====================================================================

if  { $node == "hemps_smp" } \
{

   for {set j 0} {$j < $N} {incr j} \
   {   
   for {set i 0} {$i < $C} {incr i} \
   {
      set group group_$j 
      set slave slave_$i
      set module $group/$slave/local_dma/Data
      set mb     $group/$slave/microblaze_1/Data

      create_bd_addr_seg   -range 1G -offset    0x80000000 [get_bd_addr_spaces $module] [get_bd_addr_segs peripherals/mig_7series_0/memmap/memaddr ] SEG[expr $n]
      incr n 
      create_bd_addr_seg   -range 16k -offset    0xE0000000 [get_bd_addr_spaces $module] [get_bd_addr_segs $group/$slave/axi_bram_ctrl_a/S_AXI/Mem0 ] SEG[expr $n]
      incr n 
      create_bd_addr_seg   -range 16k -offset    0xE0010000 [get_bd_addr_spaces $module] [get_bd_addr_segs $group/$slave/axi_bram_ctrl_b/S_AXI/Mem0 ] SEG[expr $n]
      incr n
      create_bd_addr_seg   -range 16k -offset    0xE0020000 [get_bd_addr_spaces $module] [get_bd_addr_segs $group/$slave/axi_bram_ctrl_result/S_AXI/Mem0 ] SEG[expr $n]
      incr n
      
      create_bd_addr_seg   -range 64k -offset    0xF1000000 [get_bd_addr_spaces $mb] [get_bd_addr_segs $group/$slave/local_dma/S_AXI_LITE/Reg ] SEG[expr $n]
      incr n 
      create_bd_addr_seg   -range 16k -offset    0xE0000000 [get_bd_addr_spaces $mb] [get_bd_addr_segs $group/$slave/axi_bram_ctrl_a/S_AXI/Mem0 ] SEG[expr $n]
      incr n 
      create_bd_addr_seg   -range 16k -offset    0xE0010000 [get_bd_addr_spaces $mb] [get_bd_addr_segs $group/$slave/axi_bram_ctrl_b/S_AXI/Mem0 ] SEG[expr $n]
      incr n
      create_bd_addr_seg   -range 16k -offset    0xE0020000 [get_bd_addr_spaces $mb] [get_bd_addr_segs $group/$slave/axi_bram_ctrl_result/S_AXI/Mem0 ] SEG[expr $n]
      incr n


   }
   }


}

if  { $node == "smp" } \
{

   for {set j 0} {$j < $N} {incr j} \
   {   
   for {set i 0} {$i < $C} {incr i} \
   {
      set group group_$j 
      set slave slave_$i
      set module $group/$slave/local_dma/Data
      set mb     $group/$slave/microblaze_1/Data

      create_bd_addr_seg   -range 1G -offset    0x80000000 [get_bd_addr_spaces $module] [get_bd_addr_segs peripherals/mig_7series_0/memmap/memaddr ] SEG[expr $n]
      incr n 
      create_bd_addr_seg   -range 16k -offset    0xE0000000 [get_bd_addr_spaces $module] [get_bd_addr_segs $group/$slave/axi_bram_ctrl_a_dma_bus/S_AXI/Mem0 ] SEG[expr $n]
      incr n     
      
      create_bd_addr_seg   -range 64k -offset    0xF1000000 [get_bd_addr_spaces $mb] [get_bd_addr_segs $group/$slave/local_dma/S_AXI_LITE/Reg ] SEG[expr $n]
      incr n 
      create_bd_addr_seg   -range 4k -offset    0xE0000000 [get_bd_addr_spaces $mb] [get_bd_addr_segs $group/$slave/axi_bram_ctrl_a_mb/S_AXI/Mem0 ] SEG[expr $n]
      incr n 


   }
   }


}

if  { $node == "numa" } \
{

   for {set j 0} {$j < $N} {incr j} \
   {   
   for {set i 0} {$i < $C} {incr i} \
   {
      set group group_$j 
      set slave slave_$i
      set module $group/$slave/local_dma/Data
      set mb     $group/$slave/microblaze_1/Data

      create_bd_addr_seg   -range 1G -offset    0x80000000 [get_bd_addr_spaces $module] [get_bd_addr_segs peripherals/mig_7series_0/memmap/memaddr ] SEG[expr $n]
      incr n 
      create_bd_addr_seg   -range 16k -offset    0xC0[format "%02x" [expr $j * $C + $i]]0000 [get_bd_addr_spaces $module] [get_bd_addr_segs $group/$slave/global_vhwti_cntrl_[expr $j * $C + $i]/S_AXI/Mem0 ] SEG[expr $n]
      incr n           
      create_bd_addr_seg   -range 64k -offset    0xF1000000 [get_bd_addr_spaces $mb] [get_bd_addr_segs $group/$slave/local_dma/S_AXI_LITE/Reg ] SEG[expr $n]
      incr n      


   }
   }


}


