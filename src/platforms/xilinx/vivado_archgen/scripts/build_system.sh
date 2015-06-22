#!/bin/bash

# Check arguments
if [ $# -ne 5 ]
then
    echo "Correct Usage:"
    echo " ./build_system.sh   <N. groups> <Nodes. Per group>  < board> <system's name> <PR:y,n>"
    exit
fi

N=$1
C=$2
board=$3
name=$4
pr=$5


vivado -nojournal -nolog -mode batch -source ./run_clusters.tcl -tclargs $N $C $board $name $pr


##=====================================================================
##SDK launcning
##=====================================================================
./sdk_config.sh $N  $C $name $pr
