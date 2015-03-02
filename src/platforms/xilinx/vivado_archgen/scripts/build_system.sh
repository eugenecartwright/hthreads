#!/bin/bash

# Check arguments
if [ $# -ne 3 ]
then
    echo "Correct Usage:"
    echo " ./build_system.sh   <Num of groups> <Num of nodes in each group>  <Type of board:kc705,ac701, vc709,vc707, zed,microzed,zc702,zc706> "
    exit
fi

N=$1
C=$2
board=$3

vivado  -source ./run_clusters.tcl -tclargs $N $C $board

##=====================================================================
##SDK launcning
##=====================================================================
./sdk_config.sh $N  $C 
