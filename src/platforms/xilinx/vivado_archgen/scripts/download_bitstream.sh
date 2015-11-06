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
#  \file       download_bitstream.sh
#  \brief      Top level shell script for downloading platform to board
# 
#  \author     Alborz Sadeghian <sadeghia@uark.edu>
# 
#  FIXME: Add description

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
#some more cleaning
#rm temp files.
cp Jamfile ./design
#rm -f  ../../../../hthread_hal/src/test/system/*.c*  ../../../../src/test/system/*.c*  *.log *.jou  *~ 1>/dev/null 
#rm -r .hw .Xil  1>/dev/null 
cd scripts
vivado -mode tcl -source ./program.tcl
