#!/bin/bash

# Check arguments
if [ $# -ne 1 ]
then
    echo "Correct Usage:"
    #echo " ./build_system.sh   <N. groups> <Nodes. Per group>  < board> <system's name> <PR:y,n>"
    echo " ./build_system.sh   <Config.txt>"
    exit
fi

cp "$1" "$1".bk
sed -i 's/^[^:]*:/:/' "$1" 
sed -i 's/^.//' "$1"
sed -i 's/-------------/-/g' "$1"


i=0
while IFS='' read -r line || [[ -n "$line" ]]; do
    data[i]=$line
    let i+=1    
done < "$1"


N=${data[0]}
C=${data[1]}
board=${data[2]}
name=${data[3]}
pr=${data[4]}
bram_size=${data[6]}
uart=${data[7]}

host=${data[10]}
mb0=${data[11]}
mb1=${data[12]}
mb2=${data[13]}
mb3=${data[14]}
mb4=${data[15]}
mb5=${data[16]}
mb6=${data[17]}
mb7=${data[18]}
mb8=${data[19]}
mb9=${data[20]}
mb10=${data[21]}
mb11=${data[22]}
mb12=${data[23]}
mb13=${data[24]}
mb14=${data[25]}
mb15=${data[26]}
mb16=${data[27]}
mb17=${data[28]}
mb18=${data[29]}
mb19=${data[30]}
mb20=${data[31]}
mb21=${data[32]}
mb22=${data[33]}
mb23=${data[34]}
mb24=${data[35]}
mb25=${data[36]}
mb26=${data[37]}
mb27=${data[38]}
mb28=${data[39]}
mb29=${data[40]}
mb30=${data[41]}
mb31=${data[42]}

list_acc=(${data[5]})
length=$(expr ${#list_acc[@]} - 1)

   for (( j=0; j<=$length; j++ ))
   do
      i=${list_acc[j]}
      i="${i//\'}"
      i="${i//\[}" 
      i="${i//\,}" 
      i="${i//\]}"
      list_acc[j]=$i
   done    




mv "$1".bk   "$1"



##=====================================================================
##PR flow
##=====================================================================
vivado -nolog -nojournal -mode batch -source ./run_clusters.tcl -tclargs $N $C $board $name $pr $bram_size $uart $host $mb0 $mb1 $mb2 $mb3 $mb4 $mb5  $mb6 $mb7 $mb8 $mb9 $mb10 $mb11 $mb12 $mb13 $mb14 $mb15 $mb16 $mb17 $mb18 $mb19 $mb20 $mb21 $mb22 $mb23 $mb24 $mb25 $mb26 $mb27 $mb28 $mb29 $mb30 $mb31 #Static System

# echo return code from last command
rc=$?; 
if [[ $rc != 0 ]]; 
then
   echo "Vivado Failed!!!" 
   exit $rc; 
fi


if [ $pr="y" ]
then
   for moudle in  "${list_acc[@]}"
   do
       vivado -nolog -nojournal -mode batch -source ./pr_acc_config.tcl -tclargs $N $C $moudle $name &   #PR for each accelerator
   done 
   vivado -nolog -nojournal -mode batch -source ./pr_blank_config.tcl -tclargs $N $C $name    #Blank PR
   wait
fi

##=====================================================================
##Generating Headers
##=====================================================================

if [ $pr="y" ]
then
   cd ../platforms/$name 
   for var in  "${list_acc[@]}"
   do
      module=$var    
      for (( i=0; i<$N *$C; i++ ))
      do
         j=$i
         cp ${module}_pr_${j}_partial.bin ${module}_${j}.bin
         xxd -i -c 4 ${module}_${j}.bin  ${module}_${j}.bin.h
      done
   done   

   cat *.h > ./partial
   mkdir ./temp
   mv *.h  ./temp
   mv *.bit ./temp
   mv *.dcp ./temp
   mv *.bin ./temp
   mv ./partial ./bitstream.h
   rm webtalk*
   cd ../../scripts/
fi

##=====================================================================
##SDK launcning
##=====================================================================
./sdk_config.sh $N  $C $name $pr
