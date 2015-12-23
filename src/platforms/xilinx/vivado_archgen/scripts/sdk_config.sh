#!/bin/bash
#************************************************************************************
# Copyright (c) 2015, University of Arkansas - Hybridthreads Group
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
#     * Redistributions of source code must retain the above copyright notice,
#       this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright notice,
#       this list of conditions and the following disclaimer in the documentation
#       and/or other materials provided with the distribution.
#     * Neither the name of the University of Arkansas nor the name of the
#       Hybridthreads Group nor the names of its contributors may be used to
#       endorse or promote products derived from this software without specific
#       prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#***********************************************************************************/

#  \internal
#  \file       sdk_config.sh
#  \brief      Top level shell script for creating SDK project for design
# 
#  \author     Alborz Sadeghian <sadeghia@uark.edu>
# 
#  FIXME: Add description

# Check arguments
if [ $# -ne 4 ]
then
    echo "Correct Usage:"
    echo " ./sdk_config.sh   <Num of groups> <Num of Slaves>  <name of the system> <pr:Y,N> "
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

rm -fr ./design/design.sdk  
mkdir ./design/design.sdk
cp ./design/design.runs/impl_1/system_wrapper.sysdef ./design/design.sdk/system_wrapper.hdf



#===============================================================
#change Num_available_hetero_cpus in include/config.h
#===============================================================
# Eugene (10/29/2015): Added regular expressions to sed commands
#Getting rid of all PR definitions
sed -i "/#define *PR *$/d" ./include/config.h

mystring='#define NUM_AVAILABLE_HETERO_CPUS '
mystring+=$num_slaves
if [ "$4" == "y" ]
then
mystring+='\n#define PR'
fi
mystring='s/#define *NUM_AVAILABLE_HETERO_CPUS.*/'$mystring'/'
sed -i "$mystring" ./include/config.h 


 
 
  
#===============================================================
#Creating Script xml file
#===============================================================
rm ./sdk.tcl
touch ./sdk.tcl
echo "#!/usr/bin/tclsh" >> ./sdk.tcl
echo "sdk set_workspace ./design/design.sdk" >> ./sdk.tcl
echo "sdk create_hw_project -name system_wrapper_hw_platform_0 -hwspec ./design/design.sdk/system_wrapper.hdf" >> ./sdk.tcl
echo "sdk create_bsp_project -name host_bsp -proc host -hwproject system_wrapper_hw_platform_0 -os standalone" >> ./sdk.tcl
echo "sdk create_app_project -name host -proc host -hwproject system_wrapper_hw_platform_0 -bsp host_bsp -app {Hello World}" >> ./sdk.tcl

  

for (( j=0; j<$N; j++ ))
do
   for (( i=0; i<$C; i++ ))
   do
   
     echo "sdk create_bsp_project -name group_"$j"_slave_"$i"_microblaze_1_bsp -proc group_"$j"_slave_"$i"_microblaze_1 -hwproject system_wrapper_hw_platform_0 -os standalone" >> ./sdk.tcl
     echo "sdk create_app_project -name group_"$j"_slave_"$i"_microblaze_1 -proc group_"$j"_slave_"$i"_microblaze_1 -hwproject system_wrapper_hw_platform_0 -bsp group_"$j"_slave_"$i"_microblaze_1_bsp -app {Empty Application}" >> ./sdk.tcl     
      
       echo " sdk import_sources -name group_"$j"_slave_"$i"_microblaze_1 -path ./slave_src" >> ./sdk.tcl  
   done
done   
    
       
echo "sdk build_project -type all " >> ./sdk.tcl  
echo "exit " >> ./sdk.tcl      

# Run xsct with generated TCL script
xsct sdk.tcl    
 

echo "Now running the data2mem"
#===============================================================
#create the download.bit
#===============================================================
 cmd=" -bm ./design/design.sdk/system_wrapper_hw_platform_0/system_wrapper.bmm -bt ./design/design.sdk/system_wrapper_hw_platform_0/system_wrapper.bit    "
for (( j=0; j<$N; j++ ))
do
   for (( i=0; i<$C; i++ ))
   do
        temp=" -bd ./design/design.sdk/group_"$j"_slave_"$i"_microblaze_1/Release/group_"$j"_slave_"$i"_microblaze_1.elf tag system_i_group_"$j"_slave_"$i"_microblaze_1"
        cmd=$cmd$temp 
   done
done

cmd+="  -o b ./design/design.sdk/system_wrapper_hw_platform_0/download.bit "


data2mem $cmd

echo "Data2mem is completed"


#===============================================================
#some more cleaning
#rm temp files.
cp Jamfile ./design
cp exception.h ./design
#rm -f  ../../../../hal/src/test/system/*.c*  ../../../../src/test/system/*.c*   
rm -fr ./scripts/.hw ./scripts/.Xil   
#rm scripts/vivado_pid*


#vivado -mode tcl -source ./program.tcl
