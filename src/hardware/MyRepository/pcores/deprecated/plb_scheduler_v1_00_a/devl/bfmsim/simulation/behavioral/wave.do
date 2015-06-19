onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {BFM System Level Ports}
add wave -noupdate -format Logic /bfm_system/sys_clk
add wave -noupdate -format Logic /bfm_system/sys_reset
add wave -noupdate -divider {PLBv46 Bus Master Signals}
add wave -noupdate -format Literal /bfm_system/plb_bus_m_request
add wave -noupdate -format Literal /bfm_system/plb_bus_m_priority
add wave -noupdate -format Literal /bfm_system/plb_bus_m_buslock
add wave -noupdate -format Literal /bfm_system/plb_bus_m_rnw
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/plb_bus_m_be
add wave -noupdate -format Literal /bfm_system/plb_bus_m_msize
add wave -noupdate -format Literal /bfm_system/plb_bus_m_size
add wave -noupdate -format Literal /bfm_system/plb_bus_m_type
add wave -noupdate -format Literal /bfm_system/plb_bus_m_tattribute
add wave -noupdate -format Literal /bfm_system/plb_bus_m_lockerr
add wave -noupdate -format Literal /bfm_system/plb_bus_m_abort
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/plb_bus_m_uabus
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/plb_bus_m_abus
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/plb_bus_m_wrdbus
add wave -noupdate -format Literal /bfm_system/plb_bus_m_wrburst
add wave -noupdate -format Literal /bfm_system/plb_bus_m_rdburst
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_maddrack
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_mssize
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_mrearbitrate
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_mtimeout
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_mbusy
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_mrderr
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_mwrerr
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_mirq
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/plb_bus_plb_mrddbus
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/plb_bus_plb_mrdwdaddr
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_mrddack
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_mrdbterm
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_mwrdack
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_mwrbterm
add wave -noupdate -divider {PLBv46 Bus Slave Signals}
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/plb_bus_plb_abus
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/plb_bus_plb_uabus
add wave -noupdate -format Logic /bfm_system/plb_bus_plb_pavalid
add wave -noupdate -format Logic /bfm_system/plb_bus_plb_savalid
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_rdprim
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_wrprim
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_masterid
add wave -noupdate -format Logic /bfm_system/plb_bus_plb_abort
add wave -noupdate -format Logic /bfm_system/plb_bus_plb_buslock
add wave -noupdate -format Logic /bfm_system/plb_bus_plb_rnw
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/plb_bus_plb_be
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_msize
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_size
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_type
add wave -noupdate -format Logic /bfm_system/plb_bus_plb_lockerr
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/plb_bus_plb_wrdbus
add wave -noupdate -format Logic /bfm_system/plb_bus_plb_wrburst
add wave -noupdate -format Logic /bfm_system/plb_bus_plb_rdburst
add wave -noupdate -format Logic /bfm_system/plb_bus_plb_wrpendreq
add wave -noupdate -format Logic /bfm_system/plb_bus_plb_rdpendreq
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_wrpendpri
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_rdpendpri
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_reqpri
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_tattribute
add wave -noupdate -format Literal /bfm_system/plb_bus_sl_addrack
add wave -noupdate -format Literal /bfm_system/plb_bus_sl_ssize
add wave -noupdate -format Literal /bfm_system/plb_bus_sl_wait
add wave -noupdate -format Literal /bfm_system/plb_bus_sl_rearbitrate
add wave -noupdate -format Literal /bfm_system/plb_bus_sl_wrdack
add wave -noupdate -format Literal /bfm_system/plb_bus_sl_wrcomp
add wave -noupdate -format Literal /bfm_system/plb_bus_sl_wrbterm
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/plb_bus_sl_rddbus
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/plb_bus_sl_rdwdaddr
add wave -noupdate -format Literal /bfm_system/plb_bus_sl_rddack
add wave -noupdate -format Literal /bfm_system/plb_bus_sl_rdcomp
add wave -noupdate -format Literal /bfm_system/plb_bus_sl_rdbterm
add wave -noupdate -format Literal /bfm_system/plb_bus_sl_mbusy
add wave -noupdate -format Literal /bfm_system/plb_bus_sl_mwrerr
add wave -noupdate -format Literal /bfm_system/plb_bus_sl_mrderr
add wave -noupdate -format Literal /bfm_system/plb_bus_sl_mirq
add wave -noupdate -divider {BFM Synch Bus Signals}
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/synch_bus/synch_bus/from_synch_out
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/synch_bus/synch_bus/to_synch_in
add wave -noupdate -divider {plb_scheduler Peripheral Interface Signals}
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/splb_clk
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/splb_rst
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/plb_abus
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/plb_uabus
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_pavalid
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_savalid
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_rdprim
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_wrprim
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/plb_masterid
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_abort
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_buslock
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_rnw
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/plb_be
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/plb_msize
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/plb_size
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/plb_type
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_lockerr
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/plb_wrdbus
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_wrburst
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_rdburst
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_wrpendreq
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_rdpendreq
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/plb_wrpendpri
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/plb_rdpendpri
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/plb_reqpri
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/plb_tattribute
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/sl_addrack
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/sl_ssize
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/sl_wait
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/sl_rearbitrate
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/sl_wrdack
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/sl_wrcomp
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/sl_wrbterm
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/sl_rddbus
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/sl_rdwdaddr
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/sl_rddack
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/sl_rdcomp
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/sl_rdbterm
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/sl_mbusy
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/sl_mwrerr
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/sl_mrderr
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/sl_mirq
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/mplb_clk
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/mplb_rst
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/md_error
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/m_request
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/m_priority
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/m_buslock
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/m_rnw
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/m_be
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/m_msize
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/m_size
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/m_type
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/m_tattribute
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/m_lockerr
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/m_abort
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/m_uabus
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/m_abus
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/m_wrdbus
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/m_wrburst
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/m_rdburst
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_maddrack
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/plb_mssize
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_mrearbitrate
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_mtimeout
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_mbusy
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_mrderr
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_mwrerr
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_mirq
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/plb_mrddbus
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/plb_mrdwdaddr
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_mrddack
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_mrdbterm
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_mwrdack
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_mwrbterm
add wave -noupdate -divider {Peripheral Internal Signals}
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/ipif_bus2ip_clk
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/ipif_bus2ip_reset
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/ipif_ip2bus_data
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/ipif_ip2bus_wrack
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/ipif_ip2bus_rdack
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/ipif_ip2bus_error
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/ipif_bus2ip_addr
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/ipif_bus2ip_data
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/ipif_bus2ip_rnw
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/ipif_bus2ip_be
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/ipif_bus2ip_cs
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/ipif_bus2ip_rdce
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/ipif_bus2ip_wrce
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/ipif_ip2bus_mstrd_req
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/ipif_ip2bus_mstwr_req
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/ipif_ip2bus_mst_addr
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/ipif_ip2bus_mst_be
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/ipif_ip2bus_mst_lock
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/ipif_ip2bus_mst_reset
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/ipif_bus2ip_mst_cmdack
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/ipif_bus2ip_mst_cmplt
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/ipif_bus2ip_mst_error
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/ipif_bus2ip_mst_rearbitrate
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/ipif_bus2ip_mst_cmd_timeout
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/ipif_bus2ip_mstrd_d
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/ipif_bus2ip_mstrd_src_rdy_n
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/ipif_ip2bus_mstwr_d
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/ipif_bus2ip_mstwr_dst_rdy_n
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/user_bus2ip_rdce
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/user_bus2ip_wrce
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_ip2bus_data
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_ip2bus_rdack
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_ip2bus_wrack
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_ip2bus_error
add wave -noupdate -divider {User Logic Interface Signals}
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_clk
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_reset
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_addr
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_data
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_be
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_rdce
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_wrce
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/ip2bus_data
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/ip2bus_rdack
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/ip2bus_wrack
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/ip2bus_error
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/ip2bus_mstrd_req
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/ip2bus_mstwr_req
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/ip2bus_mst_addr
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/ip2bus_mst_be
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/ip2bus_mst_lock
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/ip2bus_mst_reset
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_mst_cmdack
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_mst_cmplt
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_mst_error
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_mst_rearbitrate
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_mst_cmd_timeout
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_mstrd_d
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_mstrd_src_rdy_n
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/ip2bus_mstwr_d
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_mstwr_dst_rdy_n
add wave -noupdate -divider {User Logic Internal Slave Space Signals}
add wave -noupdate -divider {User Logic Internal Master Space Signals}
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/mst_go
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/user_logic_i/mst_cmd_sm_state
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/mst_cmd_sm_rd_req
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/mst_cmd_sm_wr_req
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/mst_cmd_sm_reset
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/mst_cmd_sm_bus_lock
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/mst_cmd_sm_ip2bus_addr
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/mst_cmd_sm_ip2bus_be
add wave -noupdate -divider {BFM System Level Ports}
add wave -noupdate -format Logic /bfm_system/sys_clk
add wave -noupdate -format Logic /bfm_system/sys_reset
add wave -noupdate -divider {PLBv46 Bus Master Signals}
add wave -noupdate -format Literal /bfm_system/plb_bus_m_request
add wave -noupdate -format Literal /bfm_system/plb_bus_m_priority
add wave -noupdate -format Literal /bfm_system/plb_bus_m_buslock
add wave -noupdate -format Literal /bfm_system/plb_bus_m_rnw
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/plb_bus_m_be
add wave -noupdate -format Literal /bfm_system/plb_bus_m_msize
add wave -noupdate -format Literal /bfm_system/plb_bus_m_size
add wave -noupdate -format Literal /bfm_system/plb_bus_m_type
add wave -noupdate -format Literal /bfm_system/plb_bus_m_tattribute
add wave -noupdate -format Literal /bfm_system/plb_bus_m_lockerr
add wave -noupdate -format Literal /bfm_system/plb_bus_m_abort
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/plb_bus_m_uabus
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/plb_bus_m_abus
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/plb_bus_m_wrdbus
add wave -noupdate -format Literal /bfm_system/plb_bus_m_wrburst
add wave -noupdate -format Literal /bfm_system/plb_bus_m_rdburst
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_maddrack
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_mssize
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_mrearbitrate
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_mtimeout
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_mbusy
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_mrderr
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_mwrerr
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_mirq
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/plb_bus_plb_mrddbus
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/plb_bus_plb_mrdwdaddr
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_mrddack
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_mrdbterm
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_mwrdack
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_mwrbterm
add wave -noupdate -divider {PLBv46 Bus Slave Signals}
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/plb_bus_plb_abus
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/plb_bus_plb_uabus
add wave -noupdate -format Logic /bfm_system/plb_bus_plb_pavalid
add wave -noupdate -format Logic /bfm_system/plb_bus_plb_savalid
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_rdprim
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_wrprim
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_masterid
add wave -noupdate -format Logic /bfm_system/plb_bus_plb_abort
add wave -noupdate -format Logic /bfm_system/plb_bus_plb_buslock
add wave -noupdate -format Logic /bfm_system/plb_bus_plb_rnw
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/plb_bus_plb_be
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_msize
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_size
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_type
add wave -noupdate -format Logic /bfm_system/plb_bus_plb_lockerr
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/plb_bus_plb_wrdbus
add wave -noupdate -format Logic /bfm_system/plb_bus_plb_wrburst
add wave -noupdate -format Logic /bfm_system/plb_bus_plb_rdburst
add wave -noupdate -format Logic /bfm_system/plb_bus_plb_wrpendreq
add wave -noupdate -format Logic /bfm_system/plb_bus_plb_rdpendreq
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_wrpendpri
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_rdpendpri
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_reqpri
add wave -noupdate -format Literal /bfm_system/plb_bus_plb_tattribute
add wave -noupdate -format Literal /bfm_system/plb_bus_sl_addrack
add wave -noupdate -format Literal /bfm_system/plb_bus_sl_ssize
add wave -noupdate -format Literal /bfm_system/plb_bus_sl_wait
add wave -noupdate -format Literal /bfm_system/plb_bus_sl_rearbitrate
add wave -noupdate -format Literal /bfm_system/plb_bus_sl_wrdack
add wave -noupdate -format Literal /bfm_system/plb_bus_sl_wrcomp
add wave -noupdate -format Literal /bfm_system/plb_bus_sl_wrbterm
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/plb_bus_sl_rddbus
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/plb_bus_sl_rdwdaddr
add wave -noupdate -format Literal /bfm_system/plb_bus_sl_rddack
add wave -noupdate -format Literal /bfm_system/plb_bus_sl_rdcomp
add wave -noupdate -format Literal /bfm_system/plb_bus_sl_rdbterm
add wave -noupdate -format Literal /bfm_system/plb_bus_sl_mbusy
add wave -noupdate -format Literal /bfm_system/plb_bus_sl_mwrerr
add wave -noupdate -format Literal /bfm_system/plb_bus_sl_mrderr
add wave -noupdate -format Literal /bfm_system/plb_bus_sl_mirq
add wave -noupdate -divider {BFM Synch Bus Signals}
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/synch_bus/synch_bus/from_synch_out
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/synch_bus/synch_bus/to_synch_in
add wave -noupdate -divider {plb_scheduler Peripheral Interface Signals}
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/splb_clk
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/splb_rst
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/plb_abus
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/plb_uabus
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_pavalid
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_savalid
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_rdprim
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_wrprim
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/plb_masterid
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_abort
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_buslock
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_rnw
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/plb_be
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/plb_msize
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/plb_size
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/plb_type
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_lockerr
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/plb_wrdbus
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_wrburst
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_rdburst
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_wrpendreq
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_rdpendreq
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/plb_wrpendpri
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/plb_rdpendpri
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/plb_reqpri
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/plb_tattribute
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/sl_addrack
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/sl_ssize
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/sl_wait
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/sl_rearbitrate
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/sl_wrdack
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/sl_wrcomp
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/sl_wrbterm
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/sl_rddbus
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/sl_rdwdaddr
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/sl_rddack
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/sl_rdcomp
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/sl_rdbterm
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/sl_mbusy
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/sl_mwrerr
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/sl_mrderr
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/sl_mirq
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/mplb_clk
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/mplb_rst
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/md_error
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/m_request
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/m_priority
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/m_buslock
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/m_rnw
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/m_be
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/m_msize
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/m_size
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/m_type
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/m_tattribute
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/m_lockerr
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/m_abort
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/m_uabus
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/m_abus
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/m_wrdbus
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/m_wrburst
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/m_rdburst
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_maddrack
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/plb_mssize
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_mrearbitrate
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_mtimeout
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_mbusy
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_mrderr
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_mwrerr
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_mirq
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/plb_mrddbus
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/plb_mrdwdaddr
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_mrddack
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_mrdbterm
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_mwrdack
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/plb_mwrbterm
add wave -noupdate -divider {Peripheral Internal Signals}
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/ipif_bus2ip_clk
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/ipif_bus2ip_reset
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/ipif_ip2bus_data
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/ipif_ip2bus_wrack
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/ipif_ip2bus_rdack
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/ipif_ip2bus_error
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/ipif_bus2ip_addr
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/ipif_bus2ip_data
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/ipif_bus2ip_rnw
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/ipif_bus2ip_be
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/ipif_bus2ip_cs
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/ipif_bus2ip_rdce
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/ipif_bus2ip_wrce
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/ipif_ip2bus_mstrd_req
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/ipif_ip2bus_mstwr_req
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/ipif_ip2bus_mst_addr
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/ipif_ip2bus_mst_be
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/ipif_ip2bus_mst_lock
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/ipif_ip2bus_mst_reset
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/ipif_bus2ip_mst_cmdack
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/ipif_bus2ip_mst_cmplt
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/ipif_bus2ip_mst_error
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/ipif_bus2ip_mst_rearbitrate
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/ipif_bus2ip_mst_cmd_timeout
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/ipif_bus2ip_mstrd_d
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/ipif_bus2ip_mstrd_src_rdy_n
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/ipif_ip2bus_mstwr_d
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/ipif_bus2ip_mstwr_dst_rdy_n
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/user_bus2ip_rdce
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/user_bus2ip_wrce
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_ip2bus_data
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_ip2bus_rdack
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_ip2bus_wrack
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_ip2bus_error
add wave -noupdate -divider {User Logic Interface Signals}
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_clk
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_reset
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_addr
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_data
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_be
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_rdce
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_wrce
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/ip2bus_data
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/ip2bus_rdack
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/ip2bus_wrack
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/ip2bus_error
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/ip2bus_mstrd_req
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/ip2bus_mstwr_req
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/ip2bus_mst_addr
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/ip2bus_mst_be
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/ip2bus_mst_lock
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/ip2bus_mst_reset
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_mst_cmdack
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_mst_cmplt
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_mst_error
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_mst_rearbitrate
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_mst_cmd_timeout
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_mstrd_d
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_mstrd_src_rdy_n
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/ip2bus_mstwr_d
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_mstwr_dst_rdy_n
add wave -noupdate -divider {User Logic Internal Slave Space Signals}
add wave -noupdate -divider {User Logic Internal Master Space Signals}
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/mst_go
add wave -noupdate -format Literal /bfm_system/my_core/my_core/uut/user_logic_i/mst_cmd_sm_state
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/mst_cmd_sm_rd_req
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/mst_cmd_sm_wr_req
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/mst_cmd_sm_reset
add wave -noupdate -format Logic /bfm_system/my_core/my_core/uut/user_logic_i/mst_cmd_sm_bus_lock
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/mst_cmd_sm_ip2bus_addr
add wave -noupdate -divider {Scheduler Logic}
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/mst_cmd_sm_ip2bus_be
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/soft_reset
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/reset_done
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/soft_stop
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/swtm_dob
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/swtm_addrb
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/swtm_dib
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/swtm_enb
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/swtm_web
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/tm2sch_current_cpu_tid
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/tm2sch_opcode
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/tm2sch_data
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/tm2sch_request
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/sch2tm_busy
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/sch2tm_data
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/sch2tm_next_cpu_tid
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/sch2tm_next_tid_valid
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/preemption_interrupt
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_clk
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_reset
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_addr
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_data
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_be
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_rdce
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_wrce
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/ip2bus_data
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/ip2bus_rdack
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/ip2bus_wrack
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/ip2bus_error
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/ip2bus_mstrd_req
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/ip2bus_mstwr_req
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/ip2bus_mst_addr
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/ip2bus_mst_be
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/ip2bus_mst_lock
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/ip2bus_mst_reset
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_mst_cmdack
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_mst_cmplt
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_mst_error
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_mst_rearbitrate
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_mst_cmd_timeout
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_mstrd_d
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_mstrd_src_rdy_n
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/ip2bus_mstwr_d
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_mstwr_dst_rdy_n
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/next_thread_valid_reg
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/next_thread_valid_next
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/sched_busy
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/sched_busy_next
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/ip2bus_ack
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/reset_addr
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_rdce_concat
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/bus2ip_wrce_concat
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/tm_data_ready
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/tm_data_out
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/bus_data_ready
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/bus_ack_ready
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/bus_data_out
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/preemption_interrupt_line
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/preemption_interrupt_enable
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/preemption_interrupt_enable_next
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/tm2sch_current_cpu_tid_reg
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/next_thread_id_reg
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/next_thread_id_next
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/debug_reg
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/debug_reg_next
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/inside_reset
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/inside_reset_next
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/enqueue_request
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/dequeue_request
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/is_queued_request
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/is_empty_request
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/get_encoderoutput_request
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/set_schedparam_request
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/get_schedparam_request
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/check_schedparam_request
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/toggle_preemption_request
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/get_idlethread_request
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/set_idlethread_request
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/get_entry_request
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/default_priority_request
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/error_request
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/malloc_lock_request
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/lookup_entry
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/lookup_entry_next
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/dequeue_entry
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/dequeue_entry_next
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/enqueue_entry
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/enqueue_entry_next
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/enqueue_pri_entry
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/enqueue_pri_entry_next
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/deq_pri_entry
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/deq_pri_entry_next
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/sched_param
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/sched_param_next
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/old_tail_ptr
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/old_tail_ptr_next
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/current_entry_pri_value
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/current_entry_pri_value_next
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/old_priority
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/old_priority_next
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/new_priority
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/new_priority_next
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/lookup_id
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/lookup_id_next
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/idle_thread_id
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/idle_thread_id_next
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/idle_thread_valid
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/idle_thread_valid_next
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/temp_valid
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/temp_valid_next
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/doa
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/addra
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/dia
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/ena
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/wea
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/dob
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/addrb
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/dib
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/enb
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/web
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/dou
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/addru
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/diu
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/enu
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/weu
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/encoder_reset
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/encoder_input
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/encoder_input_next
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/encoder_output
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/encoder_enable_next
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/encoder_enable
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/lock_op
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/lock_op_next
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/lock_count
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/lock_count_next
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/malloc_mutex
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/malloc_mutex_next
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/malloc_mutex_holder
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/malloc_mutex_holder_next
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/current_state_master
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/next_state_master
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/mst_go
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/ip2bus_mstwrreq
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/mst_cmd_sm_state
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/mst_cmd_sm_rd_req
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/mst_cmd_sm_wr_req
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/mst_cmd_sm_reset
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/mst_cmd_sm_bus_lock
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/ip2bus_addr
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/mst_cmd_sm_ip2bus_addr
add wave -noupdate -format Literal -radix hexadecimal /bfm_system/my_core/my_core/uut/user_logic_i/mst_cmd_sm_ip2bus_be
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
configure wave -namecolwidth 305
configure wave -valuecolwidth 215
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {6276 ns}
