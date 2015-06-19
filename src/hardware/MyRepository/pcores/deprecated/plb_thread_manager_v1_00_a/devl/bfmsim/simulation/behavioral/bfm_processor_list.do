#  Simulation Model Generator
#  Xilinx EDK 10.1.03 EDK_K_SP3.6
#  Copyright (c) 1995-2008 Xilinx, Inc.  All rights reserved.
#
#  File     bfm_processor_list.do (Fri Apr 24 15:41:43 2009)
#
#  Module   bfm_processor_wrapper
#  Instance bfm_processor
#  Because EDK did not create the testbench, the user
#  specifies the path to the device under test, $tbpath.
#
set binopt {-bin}
set hexopt {-hex}
if { [info exists PathSeparator] } { set ps $PathSeparator } else { set ps "/" }
if { ![info exists tbpath] } { set tbpath "${ps}bfm_system" }

# eval add list $binopt $tbpath${ps}bfm_processor${ps}PLB_CLK
# eval add list $binopt $tbpath${ps}bfm_processor${ps}PLB_RESET
  eval add list $hexopt $tbpath${ps}bfm_processor${ps}SYNCH_OUT
  eval add list $hexopt $tbpath${ps}bfm_processor${ps}SYNCH_IN
# eval add list $binopt $tbpath${ps}bfm_processor${ps}PLB_MAddrAck
# eval add list $hexopt $tbpath${ps}bfm_processor${ps}PLB_MSsize
# eval add list $binopt $tbpath${ps}bfm_processor${ps}PLB_MRearbitrate
# eval add list $binopt $tbpath${ps}bfm_processor${ps}PLB_MTimeout
# eval add list $binopt $tbpath${ps}bfm_processor${ps}PLB_MBusy
# eval add list $binopt $tbpath${ps}bfm_processor${ps}PLB_MRdErr
# eval add list $binopt $tbpath${ps}bfm_processor${ps}PLB_MWrErr
# eval add list $binopt $tbpath${ps}bfm_processor${ps}PLB_MIRQ
# eval add list $binopt $tbpath${ps}bfm_processor${ps}PLB_MWrDAck
# eval add list $hexopt $tbpath${ps}bfm_processor${ps}PLB_MRdDBus
# eval add list $hexopt $tbpath${ps}bfm_processor${ps}PLB_MRdWdAddr
# eval add list $binopt $tbpath${ps}bfm_processor${ps}PLB_MRdDAck
# eval add list $binopt $tbpath${ps}bfm_processor${ps}PLB_MRdBTerm
# eval add list $binopt $tbpath${ps}bfm_processor${ps}PLB_MWrBTerm
  eval add list $binopt $tbpath${ps}bfm_processor${ps}M_request
  eval add list $hexopt $tbpath${ps}bfm_processor${ps}M_priority
  eval add list $binopt $tbpath${ps}bfm_processor${ps}M_buslock
  eval add list $binopt $tbpath${ps}bfm_processor${ps}M_RNW
  eval add list $hexopt $tbpath${ps}bfm_processor${ps}M_BE
  eval add list $hexopt $tbpath${ps}bfm_processor${ps}M_msize
  eval add list $hexopt $tbpath${ps}bfm_processor${ps}M_size
  eval add list $hexopt $tbpath${ps}bfm_processor${ps}M_type
  eval add list $hexopt $tbpath${ps}bfm_processor${ps}M_TAttribute
  eval add list $binopt $tbpath${ps}bfm_processor${ps}M_lockErr
  eval add list $binopt $tbpath${ps}bfm_processor${ps}M_abort
  eval add list $hexopt $tbpath${ps}bfm_processor${ps}M_UABus
  eval add list $hexopt $tbpath${ps}bfm_processor${ps}M_ABus
  eval add list $hexopt $tbpath${ps}bfm_processor${ps}M_wrDBus
  eval add list $binopt $tbpath${ps}bfm_processor${ps}M_wrBurst
  eval add list $binopt $tbpath${ps}bfm_processor${ps}M_rdBurst

