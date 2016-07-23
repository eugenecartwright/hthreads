##############################################
# Project settings
set part [lindex $argv 0]
set pr [lindex $argv 1]

# Create a project
open_project	-reset parity_prj

# The source file and test bench
add_files			parity_top.c

# Specify the top-level function for synthesis
set_top		parity

###########################
# Solution settings

if { $pr == "y"} \
{
# Create solution
open_solution -reset dcp_solution

# Specify a Xilinx device and clock period
# - Do not specify a clock uncertainty (margin)
# - Let the  margin to default to 12.5% of clock period
set_part $part
create_clock -period 10
#set_clock_uncertainty 1.25

# Simulate the C code 
#csim_design

csynth_design
export_design -format syn_dcp
eval exec cp parity_prj/dcp_solution/impl/ip/parity.dcp ../.
}
# Create solution1
open_solution -reset solution1

# Specify a Xilinx device and clock period
# - Do not specify a clock uncertainty (margin)
# - Let the  margin to default to 12.5% of clock period
#set_part  {xc7vx485tffg1761-2}  
set_part $part    
create_clock -period 10
#set_clock_uncertainty 1.25

# Simulate the C code 
#csim_design

csynth_design
export_design  -format ip_catalog

# Do not perform any other steps
# - The basic project will be opened in the GUI 
exit

