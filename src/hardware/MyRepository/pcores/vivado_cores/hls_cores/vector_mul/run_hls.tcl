##############################################
# Project settings

# Create a project
open_project	-reset vectormul_prj

# The source file and test bench
add_files			vectormul_top.c

# Specify the top-level function for synthesis
set_top		vectormul

###########################
# Solution settings

# Create solution1
open_solution -reset solution1

# Specify a Xilinx device and clock period
# - Do not specify a clock uncertainty (margin)
# - Let the  margin to default to 12.5% of clock period
set_part  {xc7vx485tffg1761-2}

create_clock -period 10
#set_clock_uncertainty 1.25

# Simulate the C code 
#csim_design

csynth_design
export_design  -format ip_catalog

# Do not perform any other steps
# - The basic project will be opened in the GUI 
exit

