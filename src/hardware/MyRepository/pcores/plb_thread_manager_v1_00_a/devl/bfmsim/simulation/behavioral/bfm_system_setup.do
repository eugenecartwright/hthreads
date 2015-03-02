#  Simulation Model Generator
#  Xilinx EDK 10.1.03 EDK_K_SP3.6
#  Copyright (c) 1995-2008 Xilinx, Inc.  All rights reserved.
#
#  File     bfm_system_setup.do (Fri Apr 24 15:41:43 2009)
#
#  Simulation Setup DO Script File
#
#  The Simulation Setup DO script file defines macros and
#  commands to load a design and automate the setup of
#  signal displays for viewing.
#
#  Comment or uncomment commands in the DO files below
#  to change the set of signals viewed.
#
#  Because EDK did not create the testbench, the user
#  specifies the path to the device under test, $tbpath.
#  Compile and simulation load commands must also change.
#
#  xcmdc and xcmds are used by the list.do and wave.do
#  scripts for error checking (user does not set them).
#  Set xcmdc variable to 1 when 'c' command is called.
#  Set xcmds variable to 1 when 's' command is called.
#
echo  "Setting up simulation commands ..."

alias c   "do bfm_system.do; set xcmdc 1"
alias s   "vsim -novopt -t ps bfm_system; set xcmds 1"
alias l   "do bfm_system_list.do"
alias w   "do bfm_system_wave.do"

# Set up clock waveforms

proc clk_setup {} {
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}bfm_system" }
}
# Set up reset waveforms

proc rst_setup {} {
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}bfm_system" }
}
alias h "
echo **********************************************************************
echo **********************************************************************
echo ***
echo ***   Simulation Setup Macros (bfm_system_setup.do)
echo ***
echo ***   Because EDK did not create the testbench, the compile and load
echo ***   commands need changes to work with the user-generated testbench.
echo ***   For example, edit the testbench name in the vsim command.
echo ***
echo ***   c   =>  compile the design by running the EDK compile script.
echo ***           Assumes ISE and EDK libraries were compiled earlier
echo ***           for ModelSim.  (see bfm_system.do)
echo ***
echo ***   s   =>  load the design for simulation. (ModelSim 'vsim'
echo ***           command with 'bfm_system') After loading the design,
echo ***           set up signal displays (optional) and run the simulation.
echo ***           (ModelSim 'run' command)
echo ***
echo ***   l   =>  set up signal list display and launch a list window.
echo ***           ModelSim 'add -list' commands are found in *_list.do
echo ***           scripts. (see bfm_system_list.do)
echo ***
echo ***   w   =>  set up signal wave display and launch a waveform window.
echo ***           ModelSim 'add -wave' commands are found in *_wave.do
echo ***           scripts. (see bfm_system_wave.do)
echo ***
echo ***   h   =>  print this message
echo ***
echo **********************************************************************
echo **********************************************************************"

h
