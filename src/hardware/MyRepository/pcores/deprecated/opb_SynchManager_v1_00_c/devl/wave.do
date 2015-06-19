onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {OPB Synch Signals}
add wave -noupdate -format Logic /testbench/opb_clk
add wave -noupdate -format Logic /testbench/opb_rst
add wave -noupdate -format Logic /testbench/opb_rnw
add wave -noupdate -format Logic /testbench/opb_select
add wave -noupdate -format Logic /testbench/opb_seqaddr
add wave -noupdate -format Logic /testbench/opb_errack
add wave -noupdate -format Logic /testbench/opb_mgrant
add wave -noupdate -format Logic /testbench/opb_retry
add wave -noupdate -format Logic /testbench/opb_timeout
add wave -noupdate -format Logic /testbench/opb_xferack
add wave -noupdate -format Literal -radix hexadecimal /testbench/opb_abus
add wave -noupdate -format Literal -radix hexadecimal /testbench/opb_be
add wave -noupdate -format Literal -radix hexadecimal /testbench/opb_dbus
add wave -noupdate -format Literal -radix hexadecimal /testbench/sl_dbus
add wave -noupdate -format Logic /testbench/sl_errack
add wave -noupdate -format Logic /testbench/sl_retry
add wave -noupdate -format Logic /testbench/sl_toutsup
add wave -noupdate -format Logic /testbench/sl_xferack
add wave -noupdate -format Literal -radix hexadecimal /testbench/m_abus
add wave -noupdate -format Literal -radix hexadecimal /testbench/m_be
add wave -noupdate -format Logic /testbench/m_buslock
add wave -noupdate -format Logic /testbench/m_request
add wave -noupdate -format Logic /testbench/m_rnw
add wave -noupdate -format Logic /testbench/m_select
add wave -noupdate -format Logic /testbench/m_seqaddr
add wave -noupdate -divider {Slave Signals}
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/c_num_threads
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/c_num_mutexes
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/c_awidth
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/c_dwidth
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/c_max_ar_dwidth
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/c_num_addr_rng
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/c_num_ce
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/bus2ip_clk
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/bus2ip_reset
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/bus2ip_addr
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/bus2ip_data
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/bus2ip_be
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/bus2ip_rnw
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/bus2ip_rdce
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/bus2ip_wrce
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/bus2ip_rdreq
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/bus2ip_wrreq
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/ip2bus_data
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/ip2bus_retry
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/ip2bus_error
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/ip2bus_toutsup
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/ip2bus_rdack
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/ip2bus_wrack
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/bus2ip_ardata
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/bus2ip_arbe
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/bus2ip_arcs
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/ip2bus_ardata
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/mutex_kind
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/mutex_number
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/thread_number
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/command_number
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/result_nxt
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/result_cur
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/kind_mdata
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/kind_mwea
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/kind_mena
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/kind_mutex
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/kind_data
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/kind_finish
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/kind_start
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/kind_ns
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/kind_cs
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/count_mdata
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/count_mwea
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/count_mena
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/count_mutex
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/count_data
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/count_finish
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/count_start
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/count_ns
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/count_cs
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/owner_mdata
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/owner_mwea
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/owner_mena
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/owner_mutex
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/owner_data
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/owner_finish
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/owner_start
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/owner_ns
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/owner_cs
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/try_tdata
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/try_twea
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/try_tena
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/try_thread
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/try_mdata
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/try_mwea
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/try_mena
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/try_mutex
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/try_data
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/try_finish
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/try_start
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/try_ns
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/try_cs
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/unlock_tdata
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/unlock_twea
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/unlock_tena
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/unlock_thread
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/unlock_mdata
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/unlock_mwea
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/unlock_mena
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/unlock_mutex
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/unlock_data
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/unlock_finish
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/unlock_start
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/unlock_ns
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/unlock_cs
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/lock_tdata
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/lock_twea
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/lock_tena
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/lock_thread
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/lock_mdata
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/lock_mwea
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/lock_mena
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/lock_mutex
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/lock_data
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/lock_finish
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/lock_start
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/lock_ns
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/lock_cs
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/bus_ns
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/bus_cs
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/thread_data_out
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/thread_data_in
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/thread_addr
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/thread_wea
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/thread_ena
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/thread_store
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/mutex_data_out
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/mutex_data_in
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/mutex_addr
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/mutex_wea
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/mutex_ena
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/mutex_store
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/send_ack
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/send_id
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/send_ena
add wave -noupdate -divider {Master Signals}
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/master_logic_i/c_baseaddr
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/master_logic_i/c_highaddr
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/master_logic_i/c_sched_baseaddr
add wave -noupdate -format Literal /testbench/synch/master_logic_i/c_num_threads
add wave -noupdate -format Literal /testbench/synch/master_logic_i/c_num_mutexes
add wave -noupdate -format Literal /testbench/synch/master_logic_i/c_awidth
add wave -noupdate -format Literal /testbench/synch/master_logic_i/c_dwidth
add wave -noupdate -format Literal /testbench/synch/master_logic_i/c_max_ar_dwidth
add wave -noupdate -format Literal /testbench/synch/master_logic_i/c_num_addr_rng
add wave -noupdate -format Literal /testbench/synch/master_logic_i/c_num_ce
add wave -noupdate -format Logic /testbench/synch/master_logic_i/bus2ip_clk
add wave -noupdate -format Logic /testbench/synch/master_logic_i/bus2ip_reset
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/master_logic_i/bus2ip_addr
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/master_logic_i/bus2ip_data
add wave -noupdate -format Literal /testbench/synch/master_logic_i/bus2ip_be
add wave -noupdate -format Logic /testbench/synch/master_logic_i/bus2ip_rnw
add wave -noupdate -format Literal /testbench/synch/master_logic_i/bus2ip_rdce
add wave -noupdate -format Literal /testbench/synch/master_logic_i/bus2ip_wrce
add wave -noupdate -format Logic /testbench/synch/master_logic_i/bus2ip_rdreq
add wave -noupdate -format Logic /testbench/synch/master_logic_i/bus2ip_wrreq
add wave -noupdate -format Logic /testbench/synch/master_logic_i/bus2ip_msterror
add wave -noupdate -format Logic /testbench/synch/master_logic_i/bus2ip_mstlastack
add wave -noupdate -format Logic /testbench/synch/master_logic_i/bus2ip_mstrdack
add wave -noupdate -format Logic /testbench/synch/master_logic_i/bus2ip_mstwrack
add wave -noupdate -format Logic /testbench/synch/master_logic_i/bus2ip_mstretry
add wave -noupdate -format Logic /testbench/synch/master_logic_i/bus2ip_msttimeout
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/master_logic_i/ip2bus_addr
add wave -noupdate -format Literal /testbench/synch/master_logic_i/ip2bus_mstbe
add wave -noupdate -format Logic /testbench/synch/master_logic_i/ip2bus_mstburst
add wave -noupdate -format Logic /testbench/synch/master_logic_i/ip2bus_mstbuslock
add wave -noupdate -format Logic /testbench/synch/master_logic_i/ip2bus_mstrdreq
add wave -noupdate -format Logic /testbench/synch/master_logic_i/ip2bus_mstwrreq
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/master_logic_i/ip2ip_addr
add wave -noupdate -format Logic /testbench/synch/master_logic_i/send_ena
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/master_logic_i/send_id
add wave -noupdate -format Logic /testbench/synch/master_logic_i/send_ack
add wave -noupdate -format Literal /testbench/synch/master_logic_i/send_cs
add wave -noupdate -format Literal /testbench/synch/master_logic_i/send_ns
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {110000 ps} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
update
WaveRestoreZoom {0 ps} {256 ns}
