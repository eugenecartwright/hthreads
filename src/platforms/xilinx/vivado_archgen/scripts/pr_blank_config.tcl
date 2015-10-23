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
#  \file       pr_blank_config.tcl
#  \brief      Tcl script for generating blank slots for PR regious.
# 
#  \author     Alborz Sadeghian <sadeghia@uark.edu>
# 
#  FIXME: Add description

set N   [lindex $argv 0]
#number of cpus per group
set C   [lindex $argv 1]

set name   [lindex $argv 2]

cd ../platforms/$name

#---------------------------------------------------------------------------------------------------
#creating the blanking configuraiton from static.dcp
#---------------------------------------------------------------------------------------------------
eval exec cp static.dcp blank_static.dcp
open_checkpoint ./blank_static.dcp

for {set j 0} {$j < $N} {incr j} \
    {     
       for {set i 0} {$i < $C} {incr i} \
       {   
         update_design -buffer_ports -cell system_i/group_[expr $j]/slave_[expr $i]/acc_0 
       }
    }

place_design
route_design
write_checkpoint -force ./blank.dcp
write_bitstream  -bin -file ./system_wrapper.bit -force
write_hwdef -file system_wrapper.hwdef
write_bmm  -force  ./system_wrapper.bmm
eval exec mkdir ./design.runs/impl_1
write_sysdef  -force -hwdef ./system_wrapper.hwdef -bitfile ./system_wrapper.bit -meminfo ./system_wrapper.bmm -file  ./design.runs/impl_1/system_wrapper.sysdef
close_project
eval exec rm blank_static.dcp
exit 
