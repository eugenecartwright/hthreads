#!/bin/bash

# Check arguments
if [ $# -ne 4 ]
then
    echo "Correct Usage:"
    echo " ./download_bitstream.sh   <Num of groups> <Num of Slaves> <The name of system> <Pr:Y,N>  "
    exit
fi

N=$1
C=$2
name=$3
let num_slaves=($N*$C)



#===============================================================
#create a soft link for design.
#===============================================================
#if [ $3 -ne 0  ]
#then
#    mystring+="Hemps"
#fi

mystring="./platforms/"
mystring+=$name

cd ..
rm -f design

ln -s "$mystring" design


#===============================================================
#change Num_available_hetero_cpus in include/config.h
#===============================================================
mystring=''
mystring='/#define ICAP/c\'$mystring
sed -i "$mystring" ./include/config.h


mystring='#define NUM_AVAILABLE_HETERO_CPUS '
mystring+=$num_slaves
if [ "$4" == "y" ]
then
mystring+='\n#define ICAP'
fi
mystring='/#define NUM_AVAILABLE_HETERO_CPUS/c\'$mystring
 sed -i "$mystring" ./include/config.h 



#===============================================================
#some more cleaning
#rm temp files.
cp Jamfile ./design
#rm -f  ../../../../hthread_hal/src/test/system/*.c*  ../../../../src/test/system/*.c*  *.log *.jou  *~ 1>/dev/null 
#rm -r .hw .Xil  1>/dev/null 
cd scripts
vivado -mode tcl -source ./program.tcl
