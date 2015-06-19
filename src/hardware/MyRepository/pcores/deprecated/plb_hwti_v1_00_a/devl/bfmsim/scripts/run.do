##############################################################################
## Filename:          C:\edk_user_repository\MyProcessorIPLib/pcores/plb_fsm_wrapper_v1_00_a/devl/bfmsim/scripts/run.do
## Description:       ModelSim Run Script - modify with your discretion
## Date:              Thu Mar 27 10:44:34 2008 (by Create and Import Peripheral Wizard)
##############################################################################


# Compile BFM test modules
do bfm_system.do

# Load BFM test platform
vsim bfm_system

# Load Wave window
do ../../scripts/wave.do

# Load BFL
do ../../scripts/sample.do

# Start system clock and reset system
force -freeze sim:/bfm_system/sys_clk 1 0, 0 {10 ns} -r 20 ns
force -freeze sim:/bfm_system/sys_reset 1
force -freeze sim:/bfm_system/sys_reset 0 100 ns, 1 {200 ns}

# Run test time
run 200 us

# Release ModelSim simulation license
#quit -sim

# Close previous dataset if it exists
#if {[dataset info exists bfm_test]} {dataset close bfm_test}
#if {[dataset info exists sim]} {dataset close sim}

# Open and view waveform
#dataset open vsim.wlf bfm_test
#dataset open vsim2.wlf sim

#do ../../scripts/wave.do
