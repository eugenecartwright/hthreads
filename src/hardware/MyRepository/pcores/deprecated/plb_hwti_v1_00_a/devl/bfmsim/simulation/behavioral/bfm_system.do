#  Simulation Model Generator
#  Xilinx EDK 9.1.02 EDK_J_SP2.4
#  Copyright (c) 1995-2007 Xilinx, Inc.  All rights reserved.
#
#  File     bfm_system.do (Wed Apr 09 16:48:56 2008)
#
vlib opb_threadCore_v1_00_a
vmap opb_threadCore_v1_00_a opb_threadCore_v1_00_a
vlib opb_Scheduler_Master_v1_00_a
vmap opb_Scheduler_Master_v1_00_a opb_Scheduler_Master_v1_00_a
vlib opb_SynchManager_v1_00_c
vmap opb_SynchManager_v1_00_c opb_SynchManager_v1_00_c
vlib opb_blk_mcvar_v1_00_b
vmap opb_blk_mcvar_v1_00_b opb_blk_mcvar_v1_00_b
vlib hwti_common_v1_00_a
vmap hwti_common_v1_00_a hwti_common_v1_00_a
vlib plb_hwti_v1_00_a
vmap plb_hwti_v1_00_a plb_hwti_v1_00_a
vlib plb_hwt_tb_v1_00_a
vmap plb_hwt_tb_v1_00_a plb_hwt_tb_v1_00_a
vlib work
vmap work work
vcom -93 -work opb_threadCore_v1_00_a "H:/Projects/research/hthreads/src/hardware/MyRepository/pcores/opb_threadCore_v1_00_a/hdl/vhdl/user_logic.vhd"
vcom -93 -work opb_threadCore_v1_00_a "H:/Projects/research/hthreads/src/hardware/MyRepository/pcores/opb_threadCore_v1_00_a/hdl/vhdl/opb_threadCore.vhd"
vcom -93 -work opb_threadCore_v1_00_a "H:/Projects/research/hthreads/src/hardware/MyRepository/pcores/opb_threadCore_v1_00_a/hdl/vhdl/infer_bram_dual_port.vhd"
vcom -93 -work opb_Scheduler_Master_v1_00_a "H:/Projects/research/hthreads/src/hardware/MyRepository/pcores/opb_Scheduler_Master_v1_00_a/hdl/vhdl/parallel.vhd"
vcom -93 -work opb_Scheduler_Master_v1_00_a "H:/Projects/research/hthreads/src/hardware/MyRepository/pcores/opb_Scheduler_Master_v1_00_a/hdl/vhdl/infer_bram.vhd"
vcom -93 -work opb_Scheduler_Master_v1_00_a "H:/Projects/research/hthreads/src/hardware/MyRepository/pcores/opb_Scheduler_Master_v1_00_a/hdl/vhdl/user_logic.vhd"
vcom -93 -work opb_Scheduler_Master_v1_00_a "H:/Projects/research/hthreads/src/hardware/MyRepository/pcores/opb_Scheduler_Master_v1_00_a/hdl/vhdl/opb_Scheduler_Master.vhd"
vcom -93 -work opb_SynchManager_v1_00_c "H:/Projects/research/hthreads/src/hardware/MyRepository/pcores/opb_SynchManager_v1_00_c/hdl/vhdl/common.vhd"
vcom -93 -work opb_SynchManager_v1_00_c "H:/Projects/research/hthreads/src/hardware/MyRepository/pcores/opb_SynchManager_v1_00_c/hdl/vhdl/lock_fsm.vhd"
vcom -93 -work opb_SynchManager_v1_00_c "H:/Projects/research/hthreads/src/hardware/MyRepository/pcores/opb_SynchManager_v1_00_c/hdl/vhdl/unlock_fsm.vhd"
vcom -93 -work opb_SynchManager_v1_00_c "H:/Projects/research/hthreads/src/hardware/MyRepository/pcores/opb_SynchManager_v1_00_c/hdl/vhdl/trylock_fsm.vhd"
vcom -93 -work opb_SynchManager_v1_00_c "H:/Projects/research/hthreads/src/hardware/MyRepository/pcores/opb_SynchManager_v1_00_c/hdl/vhdl/owner_fsm.vhd"
vcom -93 -work opb_SynchManager_v1_00_c "H:/Projects/research/hthreads/src/hardware/MyRepository/pcores/opb_SynchManager_v1_00_c/hdl/vhdl/kind_fsm.vhd"
vcom -93 -work opb_SynchManager_v1_00_c "H:/Projects/research/hthreads/src/hardware/MyRepository/pcores/opb_SynchManager_v1_00_c/hdl/vhdl/count_fsm.vhd"
vcom -93 -work opb_SynchManager_v1_00_c "H:/Projects/research/hthreads/src/hardware/MyRepository/pcores/opb_SynchManager_v1_00_c/hdl/vhdl/result_fsm.vhd"
vcom -93 -work opb_SynchManager_v1_00_c "H:/Projects/research/hthreads/src/hardware/MyRepository/pcores/opb_SynchManager_v1_00_c/hdl/vhdl/mutex_store.vhd"
vcom -93 -work opb_SynchManager_v1_00_c "H:/Projects/research/hthreads/src/hardware/MyRepository/pcores/opb_SynchManager_v1_00_c/hdl/vhdl/thread_store.vhd"
vcom -93 -work opb_SynchManager_v1_00_c "H:/Projects/research/hthreads/src/hardware/MyRepository/pcores/opb_SynchManager_v1_00_c/hdl/vhdl/send_store.vhd"
vcom -93 -work opb_SynchManager_v1_00_c "H:/Projects/research/hthreads/src/hardware/MyRepository/pcores/opb_SynchManager_v1_00_c/hdl/vhdl/slave.vhd"
vcom -93 -work opb_SynchManager_v1_00_c "H:/Projects/research/hthreads/src/hardware/MyRepository/pcores/opb_SynchManager_v1_00_c/hdl/vhdl/master.vhd"
vcom -93 -work opb_SynchManager_v1_00_c "H:/Projects/research/hthreads/src/hardware/MyRepository/pcores/opb_SynchManager_v1_00_c/hdl/vhdl/opb_SynchManager.vhd"
vcom -93 -work opb_blk_mcvar_v1_00_b "H:/Projects/research/hthreads/src/hardware/MyRepository/pcores/opb_blk_mcvar_v1_00_b/hdl/vhdl/pend_queue.vhd"
vcom -93 -work opb_blk_mcvar_v1_00_b "H:/Projects/research/hthreads/src/hardware/MyRepository/pcores/opb_blk_mcvar_v1_00_b/hdl/vhdl/blk_mcvar_slv.vhd"
vcom -93 -work opb_blk_mcvar_v1_00_b "H:/Projects/research/hthreads/src/hardware/MyRepository/pcores/opb_blk_mcvar_v1_00_b/hdl/vhdl/blk_mcvar_msc.vhd"
vcom -93 -work opb_blk_mcvar_v1_00_b "H:/Projects/research/hthreads/src/hardware/MyRepository/pcores/opb_blk_mcvar_v1_00_b/hdl/vhdl/opb_blk_mcvar.vhd"
vcom -93 -work hwti_common_v1_00_a "H:/Projects/research/hthreads/src/hardware/MyRepository/pcores/hwti_common_v1_00_a/hdl/vhdl/common.vhd"
vcom -93 -work hwti_common_v1_00_a "H:/Projects/research/hthreads/src/hardware/MyRepository/pcores/hwti_common_v1_00_a/hdl/vhdl/command.vhd"
vcom -93 -work hwti_common_v1_00_a "H:/Projects/research/hthreads/src/hardware/MyRepository/pcores/hwti_common_v1_00_a/hdl/vhdl/hwtireg.vhd"
vcom -93 -work plb_hwti_v1_00_a "H:/Projects/research/hthreads/src/hardware/MyRepository/pcores/plb_hwti_v1_00_a/hdl/vhdl/memory.vhd"
vcom -93 -work plb_hwti_v1_00_a "H:/Projects/research/hthreads/src/hardware/MyRepository/pcores/plb_hwti_v1_00_a/hdl/vhdl/user_logic.vhd"
vcom -93 -work plb_hwti_v1_00_a "H:/Projects/research/hthreads/src/hardware/MyRepository/pcores/plb_hwti_v1_00_a/hdl/vhdl/plb_hwti.vhd"
vcom -93 -work plb_hwt_tb_v1_00_a "H:/Projects/research/hthreads/src/hardware/MyRepository/pcores/plb_hwti_v1_00_a/devl/bfmsim/pcores/plb_hwt_tb_v1_00_a/simhdl/vhdl/plb_hwt_tb.vhd"
vcom -93 -work work "bfm_processor_wrapper.vhd"
vcom -93 -work work "bfm_memory_wrapper.vhd"
vcom -93 -work work "bfm_monitor_wrapper.vhd"
vcom -93 -work work "synch_bus_wrapper.vhd"
vcom -93 -work work "plb_bus_wrapper.vhd"
vcom -93 -work work "opb_wrapper.vhd"
vcom -93 -work work "plb2opb_wrapper.vhd"
vcom -93 -work work "opb2plb_wrapper.vhd"
vcom -93 -work work "thread_manager_wrapper.vhd"
vcom -93 -work work "scheduler_wrapper.vhd"
vcom -93 -work work "synch_manager_wrapper.vhd"
vcom -93 -work work "cond_vars_wrapper.vhd"
vcom -93 -work work "my_core_wrapper.vhd"
vcom -93 -work work "bfm_system.vhd"
