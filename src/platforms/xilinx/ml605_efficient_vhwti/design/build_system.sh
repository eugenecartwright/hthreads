#!/bin/bash

LOG=build_system.log
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

##################
function if_error
##################
{
    if [[ $? -ne 0 ]]; then # check return code passed to function
        print "$1 TIME:$TIME" | tee -a $LOG # if rc > 0 then print error msg and quit
        exit $?
    fi
}

# Create necessary make files
xps -nw -scr build_system.tcl

# Compile software libraries for platform
make -f system.make program

# Create Bit file
make -f system.make init_bram

# Download Bit file
#make -f system.make download

