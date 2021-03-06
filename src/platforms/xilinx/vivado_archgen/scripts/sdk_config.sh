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
    printf "Correct Usage:\n"
    printf " ./sdk_config.sh   <Num of groups> <Num of Slaves>  <name of the system> <pr:Y,N>\n"
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
printf "#!/usr/bin/tclsh\n" >> ./sdk.tcl
printf "sdk setws ./design/design.sdk\n" >> ./sdk.tcl
printf "sdk createhw -name system_wrapper_hw_platform_0 -hwspec ./design/design.sdk/system_wrapper.hdf\n" >> ./sdk.tcl
printf "sdk createbsp -name host_bsp -proc host -hwproject system_wrapper_hw_platform_0 -os standalone\n" >> ./sdk.tcl
printf "sdk createapp -name host -proc host -hwproject system_wrapper_hw_platform_0 -bsp host_bsp -app {Hello World}\n" >> ./sdk.tcl

  

for (( j=0; j<$N; j++ ))
do
   for (( i=0; i<$C; i++ ))
   do
   
     printf "sdk createbsp -name group_"$j"_slave_"$i"_microblaze_"$j"_"$i"_bsp -proc group_"$j"_slave_"$i"_microblaze_"$j"_"$i" -hwproject system_wrapper_hw_platform_0 -os standalone\n" >> ./sdk.tcl
     printf "sdk createapp -name group_"$j"_slave_"$i"_microblaze_"$j"_"$i" -proc group_"$j"_slave_"$i"_microblaze_"$j"_"$i" -hwproject system_wrapper_hw_platform_0 -bsp group_"$j"_slave_"$i"_microblaze_"$j"_"$i"_bsp -app {Empty Application}\n" >> ./sdk.tcl     
      
       printf " sdk importsources -name group_"$j"_slave_"$i"_microblaze_"$j"_"$i" -path ./slave_src\n" >> ./sdk.tcl  
   done
done   
    
       
printf "sdk build_project -type all \n" >> ./sdk.tcl  
printf "exit \n" >> ./sdk.tcl      

# Run xsct with generated TCL script
xsct sdk.tcl    
 

printf "Now running the data2mem\n"
#===============================================================
#create the download.bit
#===============================================================
 cmd=" -bm ./design/design.sdk/system_wrapper_hw_platform_0/system_wrapper.bmm -bt ./design/design.sdk/system_wrapper_hw_platform_0/system_wrapper.bit    "
for (( j=0; j<$N; j++ ))
do
   for (( i=0; i<$C; i++ ))
   do
        temp=" -bd ./design/design.sdk/group_"$j"_slave_"$i"_microblaze_"$j"_"$i"/Release/group_"$j"_slave_"$i"_microblaze_"$j"_"$i".elf tag system_i_group_"$j"_slave_"$i"_microblaze_"$j"_"$i"" 
        cmd=$cmd$temp 
   done
done

cmd+="  -o b ./design/design.sdk/system_wrapper_hw_platform_0/download.bit "


data2mem $cmd

printf "Data2mem is completed\n"


#===============================================================
#some more cleaning
#rm temp files.
cp Jamfile ./design
cp exception.h ./design
#rm -f  ../../../../hal/src/test/system/*.c*  ../../../../src/test/system/*.c*   
rm -fr ./scripts/.hw ./scripts/.Xil   
#rm scripts/vivado_pid*


#vivado -mode tcl -source ./program.tcl
