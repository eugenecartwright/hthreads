#!/bin/bash

# Create necessary make files
xps -nw -scr build_system.tcl

# Compile software libraries for platform
make -f system.make program

# Create Bit file
make -f system.make init_bram

# Download Bit file
#make -f system.make download

