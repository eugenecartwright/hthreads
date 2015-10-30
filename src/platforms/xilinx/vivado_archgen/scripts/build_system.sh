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
#  \file       build_system.sh
#  \brief      Top level script for system building.
# 
#  \author     Alborz Sadeghian <sadeghia@uark.edu>
# 
#  FIXME: Add description

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

# (Eugene 10/22/2015): echo return code from last command
rc=$?; 
if [[ $rc != 0 ]]; 
then
   echo "Vivado Failed!!!" 
   exit $rc; 
fi


if [ $pr="y" ]
then
   for module in  "${list_acc[@]}"
   do
      echo -e "----------------------------------------------------------------\n\n"
      echo "Building $module PR file"
      vivado -nolog -nojournal -verbose -mode batch -source ./pr_acc_config.tcl -tclargs $N $C $module $name    #PR for each accelerator
      rc=$?; 
      if [[ $rc != 0 ]]; 
      then
         echo "Failed to build PR regionds for $module" 
         exit $rc; 
      fi
   done 
   vivado -nolog -nojournal -verbose -mode batch -source ./pr_blank_config.tcl -tclargs $N $C $name    #Blank PR
   wait
fi

# (Eugene 10/22/2015): echo return code from last command if failure
rc=$?; 
if [[ $rc != 0 ]]; 
then
   echo "Vivado PR Failed!!!" 
   exit $rc; 
fi

##=====================================================================
##Generating Headers
##=====================================================================

if [ $pr="y" ]
then
   cd ../platforms/$name 
   for module in  "${list_acc[@]}"
   do
      for (( j=0; j<$N *$C; j++ ))
      do
         cp ${module}_pr_${j}_partial.bin ${module}_${j}.bin
         # Eugene (10/21/2016): Change from little to Big endian
         mb-objcopy -I binary -O binary --reverse-bytes=4 ${module}_${j}.bin ${module}_${j}.bin
         xxd -i -c 4 ${module}_${j}.bin  ${module}_${j}.bin.h
      done
   done   

   cat *.h > ./partial
   mkdir ./temp
   mv *.h  ./temp
   mv *.bit ./temp
   mv *.dcp ./temp
   mv *.bin ./temp
   # Eugene (10/23/2016): Change from little to Big endian
   echo "#ifndef  _BITSTREAM_H" > bitstream.h
   echo "#define  _BITSTREAM_H" >> bitstream.h
   cat ./partial >> ./bitstream.h
   rm -f webtalk*

#---------------------------------------------------------------------------------------------------
# Adding in appropriate data structures and methods for such bitstreams
# Author: Eugene Cartwright
#---------------------------------------------------------------------------------------------------
   echo "#include <accelerator.h>" >> bitstream.h

   # Adding in PR structures into this header file so the
   # generated hcompile header stays fairly system independent
   #num_accelerators=$(expr ${#list_acc[@]})
   echo "unsigned char * accelerators_bit[NUM_ACCELERATORS][NUM_AVAILABLE_HETERO_CPUS] = {" >> bitstream.h
   j=0
   for module in  "${list_acc[@]}"; do
      i=0
      while [ $i -lt $(($N * $C)) ]; do
         if [ $i == 0 ]; then
            echo -n -e "\t{(&${module}_${i}_bin[0])" >> bitstream.h
         else 
            echo -n ", (&${module}_${i}_bin[0])" >> bitstream.h
         fi
         let i=i+1
      done
      let j=j+1
      if [ $j == $num_accelerators ]; then
         echo "}" >> bitstream.h
      else
         echo "}," >> bitstream.h
      fi
   done
   echo "};" >> bitstream.h
   echo "" >> bitstream.h

   #---------------------------------------------------------------------------------------------------
   # Adding in PR initialization routines
   #---------------------------------------------------------------------------------------------------
   i=0
   echo "void pr_config_mb() {" >> bitstream.h
   # Loop over all processors
   while [ $i -lt $(($N * $C)) ]; do
      echo -e "\n\t/* ------------------------------------------------------------------ *" >> bitstream.h
      printf  "\t *                          MicroBlaze %02d                             *\n" $i >> bitstream.h
      echo -e "\t * ------------------------------------------------------------------ */\n" >> bitstream.h
      echo -e "\t// Placing PRC in Shutdown mode..." >> bitstream.h
      echo -e "\tXil_Out32(MB_${i}_CONTROL,0);" >> bitstream.h
      echo -e "\twhile(!(Xil_In32(MB_${i}_STATUS)&0x80));" >> bitstream.h

      j=0
      echo -e "\n\t// Initializing RM bitstream address and size registers" >> bitstream.h
      for module in "${list_acc[@]}"; do 
         echo -e "\tXil_Out32(MB_${i}_BS_ADDRESS${j},(Huint) (&${module}_${i}_bin[0]));" >> bitstream.h
         echo -e "\tXil_Out32(MB_${i}_BS_SIZE${j},${module}_${i}_bin_len);" >> bitstream.h
         let j=j+1
      done
      
      j=0
      echo -e "\n\t// Initializing RM trigger ID registers" >> bitstream.h
      for module in "${list_acc[@]}"; do 
         echo -e "\tXil_Out32(MB_${i}_TRIGGER${j},${j});" >> bitstream.h
         let j=j+1
      done
      
      j=0
      echo -e "\n\t// Initializing RM address and control registers" >> bitstream.h
      for module in "${list_acc[@]}"; do 
         echo -e "\tXil_Out32(MB_${i}_RM_BS_INDEX${j},${j});" >> bitstream.h
         let j=j+1
      done

      echo -e "\n\t// Placing PRC in 'Restart with Status' Mode" >> bitstream.h
      echo -e "\tXil_Out32(MB_${i}_CONTROL,2);" >> bitstream.h
   
      let i=i+1
   done
   echo "}" >> bitstream.h
   echo "#endif" >> bitstream.h
fi


##=====================================================================
##SDK launcning
##=====================================================================
cd ../../scripts/
./sdk_config.sh $N  $C $name $pr

