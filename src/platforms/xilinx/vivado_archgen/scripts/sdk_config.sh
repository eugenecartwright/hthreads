#!/bin/bash

# Check arguments
if [ $# -ne 2 ]
then
    echo "Correct Usage:"
    echo " ./sdk_config.sh   <Num of groups> <Num of Slaves>   "
    exit
fi

N=$1
C=$2
let num_slaves=($N*$C)

#===============================================================
#create a soft link for design.
#===============================================================
#if [ $3 -ne 0  ]
#then
#    mystring+="Hemps"
#fi
mystring="./platforms/"
mystring+="N"
mystring+="$N"
mystring+="C"
mystring+="$C"
mystring+="hemps_smp"

cd ..
rm design

ln -s "$mystring" design

rm -r ./design/design.sdk  
mkdir ./design/design.sdk
cp ./design/design.runs/impl_1/system_wrapper.sysdef ./design/design.sdk/system_wrapper.hdf



#===============================================================
#change Num_available_hetero_cpus in include/config.h
#===============================================================
mystring='#define NUM_AVAILABLE_HETERO_CPUS '
mystring+=$num_slaves
mystring='/#define NUM_AVAILABLE_HETERO_CPUS/c\'$mystring
 sed -i "$mystring" ./include/config.h
 
 
 
 
  
#===============================================================
#Creating Script xml file
#===============================================================
rm ./script.xml
touch ./script.xml
echo "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>" >> ./script.xml
echo "<project name=\"SDK Script\" default=\"main\">" >> ./script.xml

   echo "   <target name=\"main\">" >> ./script.xml

      echo "      <createHwProject projname=\"system_wrapper_hw_platform_0\" hwspecpath=\"./design/design.sdk/system_wrapper.hdf\"/>" >> ./script.xml
      echo "      <createAppProject projname=\"host\" hwprojname=\"system_wrapper_hw_platform_0\" processor=\"host\" os=\"standalone\" bspprojname=\"host_bsp\"   template=\"Hello World\" language=\"C\"/> " >> ./script.xml        
           

for (( j=0; j<$N; j++ ))
do
   for (( i=0; i<$C; i++ ))
   do
      echo "      <createAppProject projname=\"group_"$j"_slave_"$i"_microblaze_1\" hwprojname=\"system_wrapper_hw_platform_0\" processor=\"group_"$j"_slave_"$i"_microblaze_1\" os=\"standalone\" bspprojname=\"group_"$j"_slave_"$i"_microblaze_1_bsp\" template=\"Empty Application\" language=\"C\"/>  " >> ./script.xml      
   done
done         
       
echo "</target>" >> ./script.xml 
echo "</project> " >> ./script.xml      



#===============================================================
#Creating the SDK projects for host and slaves
#===============================================================
   xsdk -wait -script ./script.xml -workspace ./design/design.sdk

for (( j=0; j<$N; j++ ))
do
   for (( i=0; i<$C; i++ ))
   do
         cp   ./slave_src/* ./design/design.sdk/group_"$j"_slave_"$i"_microblaze_1/src/
   done
done   
  
   
    xsdk -wait -eclipseargs -nosplash -application org.eclipse.cdt.managedbuilder.core.headlessbuild -build all -data ./design/design.sdk -vmargs -Dorg.eclipse.cdt.core.console=org.eclipse.cdt.core.systemConsole  
    
#===============================================================
#create the download.bit
#===============================================================
 cmd=" -bm ./design/design.sdk/system_wrapper_hw_platform_0/system_wrapper_bd.bmm -bt ./design/design.sdk/system_wrapper_hw_platform_0/system_wrapper.bit    "
for (( j=0; j<$N; j++ ))
do
   for (( i=0; i<$C; i++ ))
   do
        temp=" -bd ./design/design.sdk/group_"$j"_slave_"$i"_microblaze_1/Debug/group_"$j"_slave_"$i"_microblaze_1.elf tag system_i_group_"$j"_slave_"$i"_microblaze_1"
        cmd=$cmd$temp 
   done
done

cmd+="  -o b ./design/design.sdk/system_wrapper_hw_platform_0/download.bit "

data2mem $cmd




#===============================================================
#some more cleaning
#rm temp files.
cp Jamfile ./design
rm -f  ../../../../hthread_hal/src/test/system/*.c*  ../../../../src/test/system/*.c*  *.log *.jou  *~ 1>/dev/null 
rm -r .hw .Xil  1>/dev/null 
rm scripts/vivado_pid*


#vivado -mode tcl -source ./program.tcl
