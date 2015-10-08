#!/bin/bash

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
#Getting rid of all ICAP definitions
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

xsct sdk.tcl    
 


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

# Alternatively, you may be able to run 'updatemem -force -meminfo file.bmm -bit file.bit -data file1.elf -proc group0/slave0/microblaze0 -out final.bit




#===============================================================
#some more cleaning
#rm temp files.
cp Jamfile ./design
#rm -f  ../../../../hal/src/test/system/*.c*  ../../../../src/test/system/*.c*   
rm -fr ./scripts/.hw ./scripts/.Xil   
#rm scripts/vivado_pid*


#vivado -mode tcl -source ./program.tcl
