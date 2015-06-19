#  Simulation Model Generator
#  Xilinx EDK 10.1.03 EDK_K_SP3.6
#  Copyright (c) 1995-2008 Xilinx, Inc.  All rights reserved.
#
#  File     bfm_system.do (Fri Apr 24 15:41:43 2009)
#
vmap XilinxCoreLib "/home/jstevens/simlib/EDK10.1.02_mti_se_linux/ISE_Lib/XilinxCoreLib/"
vmap XilinxCoreLib_ver "/home/jstevens/simlib/EDK10.1.02_mti_se_linux/ISE_Lib/XilinxCoreLib_ver/"
vmap secureip "/home/jstevens/simlib/EDK10.1.02_mti_se_linux/ISE_Lib/secureip/"
vmap simprim "/home/jstevens/simlib/EDK10.1.02_mti_se_linux/ISE_Lib/simprim/"
vmap simprims_ver "/home/jstevens/simlib/EDK10.1.02_mti_se_linux/ISE_Lib/simprims_ver/"
vmap unisim "/home/jstevens/simlib/EDK10.1.02_mti_se_linux/ISE_Lib/unisim/"
vmap unisims_ver "/home/jstevens/simlib/EDK10.1.02_mti_se_linux/ISE_Lib/unisims_ver/"
vmap plbv46_bfm "/home/jstevens/simlib/EDK10.1.02_mti_se_linux/EDK_Lib/plbv46_bfm/"
vmap plbv46_master_bfm_v1_00_a "/home/jstevens/simlib/EDK10.1.02_mti_se_linux/EDK_Lib/plbv46_master_bfm_v1_00_a/"
vmap plbv46_slave_bfm_v1_00_a "/home/jstevens/simlib/EDK10.1.02_mti_se_linux/EDK_Lib/plbv46_slave_bfm_v1_00_a/"
vmap plbv46_monitor_bfm_v1_00_a "/home/jstevens/simlib/EDK10.1.02_mti_se_linux/EDK_Lib/plbv46_monitor_bfm_v1_00_a/"
vmap bfm_synch_v1_00_a "/home/jstevens/simlib/EDK10.1.02_mti_se_linux/EDK_Lib/bfm_synch_v1_00_a/"
vmap proc_common_v2_00_a "/home/jstevens/simlib/EDK10.1.02_mti_se_linux/EDK_Lib/proc_common_v2_00_a/"
vmap plb_v46_v1_00_a "/home/jstevens/simlib/EDK10.1.02_mti_se_linux/EDK_Lib/plb_v46_v1_00_a/"
vmap plbv46_slave_single_v1_00_a "/home/jstevens/simlib/EDK10.1.02_mti_se_linux/EDK_Lib/plbv46_slave_single_v1_00_a/"
vlib plb_thread_manager_v1_00_a
vmap plb_thread_manager_v1_00_a plb_thread_manager_v1_00_a
vlib plb_thread_manager_tb_v1_00_a
vmap plb_thread_manager_tb_v1_00_a plb_thread_manager_tb_v1_00_a
vlib work
vmap work work
vcom -novopt -93 -work plb_thread_manager_v1_00_a "/home/jstevens/tmp/plb_cores/test_system/edk_user_repository/MyProcessorIPLib/pcores/plb_thread_manager_v1_00_a/hdl/vhdl/infer_bram_dual_port.vhd"
vcom -novopt -93 -work plb_thread_manager_v1_00_a "/home/jstevens/tmp/plb_cores/test_system/edk_user_repository/MyProcessorIPLib/pcores/plb_thread_manager_v1_00_a/hdl/vhdl/user_logic.vhd"
vcom -novopt -93 -work plb_thread_manager_v1_00_a "/home/jstevens/tmp/plb_cores/test_system/edk_user_repository/MyProcessorIPLib/pcores/plb_thread_manager_v1_00_a/hdl/vhdl/plb_thread_manager.vhd"
vcom -novopt -93 -work plb_thread_manager_tb_v1_00_a "/home/jstevens/tmp/plb_cores/test_system/edk_user_repository/MyProcessorIPLib/pcores/plb_thread_manager_v1_00_a/devl/bfmsim/pcores/plb_thread_manager_tb_v1_00_a/simhdl/vhdl/plb_thread_manager_tb.vhd"
vcom -novopt -93 -work work "bfm_processor_wrapper.vhd"
vcom -novopt -93 -work work "bfm_memory_wrapper.vhd"
vcom -novopt -93 -work work "bfm_monitor_wrapper.vhd"
vcom -novopt -93 -work work "synch_bus_wrapper.vhd"
vcom -novopt -93 -work work "plb_bus_wrapper.vhd"
vcom -novopt -93 -work work "my_core_wrapper.vhd"
vcom -novopt -93 -work work "bfm_system.vhd"
