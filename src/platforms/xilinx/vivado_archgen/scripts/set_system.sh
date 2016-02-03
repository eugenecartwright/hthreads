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
#  \file       set_system.sh
#  \brief      Shell script for configuring config.h file for the current design
# 
#  \author     Alborz Sadeghian <sadeghia@uark.edu>
# 
#  FIXME: Add description

# Check arguments
if [ $# -ne 3 ]
then
    printf "Correct Usage:\n"
    printf " ./set_system.sh   <Num of processors>  <name of the system> <pr:Y,N>\n"
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

