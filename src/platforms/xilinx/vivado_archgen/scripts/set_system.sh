#!/bin/bash

# Check arguments
if [ $# -ne 3 ]
then
    echo "Correct Usage:"
    echo " ./set_system.sh   <Num of processors>  <name of the system> <pr:Y,N> "
    exit
fi

num_slaves=$1
name=$2



#===============================================================
#create a soft link for design.
#===============================================================
mystring="./platforms/"
mystring+=$name
cd ..
rm -f design
ln -s "$mystring" design

#===============================================================
#change Num_available_hetero_cpus in include/config.h
#===============================================================
#Getting rid of all ICAP definitions
mystring=''
mystring='/#define PR  /c\'$mystring
sed -i "$mystring" ./include/config.h


mystring='#define NUM_AVAILABLE_HETERO_CPUS '
mystring+=$num_slaves
if [ "$3" == "y" ]
then
mystring+='\n#define PR  '
fi
mystring='/#define NUM_AVAILABLE_HETERO_CPUS/c\'$mystring
 sed -i "$mystring" ./include/config.h 

