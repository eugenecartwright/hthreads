###############################################################################
##
## (c) Copyright [2003] - [2012] Xilinx, Inc. All rights reserved.
## 
## This file contains confidential and proprietary information
## of Xilinx, Inc. and is protected under U.S. and 
## international copyright and other intellectual property
## laws.
## 
## DISCLAIMER
## This disclaimer is not a license and does not grant any
## rights to the materials distributed herewith. Except as
## otherwise provided in a valid license issued to you by
## Xilinx, and to the maximum extent permitted by applicable
## law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
## WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
## AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
## BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
## INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
## (2) Xilinx shall not be liable (whether in contract or tort,
## including negligence, or under any other theory of
## liability) for any loss or damage of any kind or nature
## related to, arising under or in connection with these
## materials, including for any direct, or any indirect,
## special, incidental, or consequential loss or damage
## (including loss of data, profits, goodwill, or any type of
## loss or damage suffered as a result of any action brought
## by a third party) even if such damage or loss was
## reasonably foreseeable or Xilinx had been advised of the
## possibility of the same.
## 
## CRITICAL APPLICATIONS
## Xilinx products are not designed or intended to be fail-
## safe, or for use in any application requiring fail-safe
## performance, such as life-support or safety devices or
## systems, Class III medical devices, nuclear facilities,
## applications related to the deployment of airbags, or any
## other applications that could lead to death, personal
## injury, or severe property or environmental damage
## (individually and collectively, "Critical
## Applications"). Customer assumes the sole risk and
## liability of any use of Xilinx products in Critical
## Applications, subject only to applicable laws and
## regulations governing limitations on product liability.
## 
## THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
## PART OF THIS FILE AT ALL TIMES
##
###############################################################################
##
## fsl_v20_v2_1_0.tcl
##
################################################################################


#***--------------------------------***------------------------------------***
#
# 		         SYSLEVEL_DRC_PROC
#
#***--------------------------------***------------------------------------***

#
#
proc check_syslevel_settings { mhsinst } {
  set mhs_handle [xget_hw_parent_handle $mhsinst]
  set retval 0
  set async_clks [xget_hw_parameter_value $mhsinst "C_ASYNC_CLKS"]
  if {$async_clks == 0} { 
    set fsl_clk_con [xget_hw_port_value $mhsinst "FSL_Clk"] 
    if {[llength $fsl_clk_con] > 0} {
      set fsl_clk_source [xget_connected_ports_handle $mhs_handle $fsl_clk_con "SOURCE"]
      if {[llength $fsl_clk_source] == 0} {
        error "FSL_Clk is incorrectly connected." "" "mdt_error"
        incr retval
      }
    } else {
      error "FSL_Clk is unconnected." "" "mdt_error"
      incr retval
    }
  } else {
    set fsl_m_clk_con [xget_hw_port_value $mhsinst "FSL_M_Clk"] 
    if {[llength $fsl_m_clk_con] > 0} {
      set fsl_m_clk_source [xget_connected_ports_handle $mhs_handle $fsl_m_clk_con "SOURCE"]
      if {[llength $fsl_m_clk_source] == 0} {
        error "FSL_M_Clk is incorrectly connected." "" "mdt_error"
        incr retval
      }
    } else {
      error "FSL_M_Clk is unconnected." "" "mdt_error"
      incr retval
    }
    set fsl_s_clk_con [xget_hw_port_value $mhsinst "FSL_S_Clk"] 
    if {[llength $fsl_s_clk_con] > 0} {
      set fsl_s_clk_source [xget_connected_ports_handle $mhs_handle $fsl_s_clk_con "SOURCE"]
      if {[llength $fsl_s_clk_source] == 0} {
        error "FSL_S_Clk is incorrectly connected." "" "mdt_error"
        incr retval
      }
    } else {
      error "FSL_S_Clk is unconnected." "" "mdt_error"
      incr retval
    }
  }
  return $retval
}

#***--------------------------------***-----------------------------------***
#
#			     CORE_LEVEL_CONSTRAINTS
#
#***--------------------------------***-----------------------------------***

proc generate_corelevel_ucf {mhsinst} {

    set  filePath [xget_ncf_dir $mhsinst]

    file mkdir    $filePath

    # specify file name
    set    instname   [xget_hw_parameter_value $mhsinst "INSTANCE"]
    set    name_lower [string 	  tolower    $instname]
    set    fileName   $name_lower
    append filePath   $fileName

    set read_clock_period [xget_hw_parameter_value $mhsinst "C_READ_CLOCK_PERIOD" ]  
    set async_clks        [xget_hw_parameter_value $mhsinst "C_ASYNC_CLKS" ]  
    set imp_style         [xget_hw_parameter_value $mhsinst "C_IMPL_STYLE" ]  
    set use_control       [xget_hw_parameter_value $mhsinst "C_USE_CONTROL" ]  

    # Open UCF file for writing and delete XDC file (if any)
    set outputFileUcf [open "${filePath}_wrapper.ucf" "w"]
    file delete -force "${filePath}.xdc"

    # Check if the FSL is implemented with asynchronous clocks and lutram

    if { ($async_clks == 1) && ($imp_style == 0) } {

        # The C_READ_CLOCK_PERIOD must be set
        if { ([string length $read_clock_period] == 0) || ($read_clock_period == 0) } {

            error "$instname parameter C_READ_CLOCK_PERIOD must have a valid period in (ps) when 'C_ASYNC_CLKS = 1' and 'C_IMPL_STYLE = 0'" "" "mdt_error"

        } else {

            # Open XDC file for writing
            set outputFileXdc [open "${filePath}.xdc" "w"]

            if {($use_control == 1)} {
                set fifo_name "Using_FIFO.Async_FIFO_Gen.Use_Control.Use_DPRAM1.Async_FIFO_I1"
            } else {
                set fifo_name "Using_FIFO.Async_FIFO_Gen.Use_Data.Use_DPRAM0.Async_FIFO_I1"
            }
            puts $outputFileUcf "INST \"${name_lower}/${fifo_name}/Mram*\" TNM = \"${name_lower}_fsl\"; "
            puts $outputFileUcf "TIMESPEC \"TS_ASYNC_FIFO_$name_lower\" = FROM \"${name_lower}_fsl\" $read_clock_period ps DATAPATHONLY; "
            puts $outputFileXdc "set_max_delay -from \[get_cells \"${fifo_name}/Memory_reg*/*\"\] ${read_clock_period}"

            # Close the XDC file
            close  $outputFileXdc
        }
    }

    # Close the UCF file
    close  $outputFileUcf

    puts   [xget_ncf_loc_info $mhsinst]

}

#***--------------------------------***-----------------------------------***
#
#			     CORE_LEVEL_DRC
#
#***--------------------------------***-----------------------------------***
proc check_iplevel_settings {mhsinst} {

  set retval     0
  set instname   [xget_hw_parameter_value $mhsinst "INSTANCE"]
  set async_clks [xget_hw_parameter_value $mhsinst "C_ASYNC_CLKS" ]  
  set fsl_depth  [xget_hw_parameter_value $mhsinst "C_FSL_DEPTH" ]  
  set imp_style  [xget_hw_parameter_value $mhsinst "C_IMPL_STYLE" ]  

  # Async Implementation doesn't allow non 2**n depths  
  if { ($async_clks == 1) } {
       
    # Check if power of two
    set is_non_power_of_two [expr ($fsl_depth & ($fsl_depth -1))]
    if {$is_non_power_of_two != 0} {
      error "$instname: C_FSL_DEPTH needs to be power of two when using asynchronous clocks" "" "mdt_error"
      incr retval
    }

    # Need to inform user to set ENABLE=reg_sr_o; 
    # Only need to do this for asynchronous LUTRAM configuration
    if { $imp_style == 0 } {
      puts -nonewline "WARNING *************************************************************"
      puts -nonewline "WARNING ** To get full timing path analysis when using asynchronous *"
      puts -nonewline "WARNING ** LUTRAM FSL FIFO (C_ASYNC_CLKS = 1, C_IMP_STYLE = 0)      *"
      puts -nonewline "WARNING ** include \"ENABLE=sr_reg_o;\" in the top level UCF file.    *"
      puts -nonewline "WARNING *************************************************************"   
    }
  }

  return $retval
}
