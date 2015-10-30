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
#  \file       pr_acc_config.tcl
#  \brief      Tcl script for configuring generating PR bit files for accelerators.
# 
#  \author     Alborz Sadeghian <sadeghia@uark.edu>
# 
#  FIXME: Add description


set N   [lindex $argv 0]
#number of cpus per group
set C   [lindex $argv 1]

set module [lindex $argv 2]

set name   [lindex $argv 3]

cd ../platforms/$name

eval exec cp static.dcp [expr {$module}]_static.dcp


open_checkpoint -verbose [expr {$module}]_static.dcp
   for {set j 0} {$j < $N} {incr j} \
    {     
       for {set i 0} {$i < $C} {incr i} \
       {   
         read_checkpoint -verbose -cell system_i/group_[expr $j]/slave_[expr $i]/acc_0 ../../pr/acc/$module.dcp
       }
    }
  
   opt_design
   place_design 
   route_design 
   write_checkpoint  -force ./$module.dcp
   write_bitstream  -bin -file ./$module.bit -force
   close_project 
   eval exec rm [expr {$module}]_static.dcp
   exit



