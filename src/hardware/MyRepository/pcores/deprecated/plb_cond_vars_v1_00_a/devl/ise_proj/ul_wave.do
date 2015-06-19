onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Top-Level Interface}
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/soft_reset
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/reset_done
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/bus2ip_clk
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/bus2ip_reset
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/bus2ip_addr
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/bus2ip_data
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/bus2ip_be
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/bus2ip_rdce
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/bus2ip_wrce
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/ip2bus_data
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/ip2bus_rdack
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/ip2bus_wrack
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/ip2bus_error
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/ip2bus_mstrd_req
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/ip2bus_mstwr_req
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/ip2bus_mst_addr
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/ip2bus_mst_be
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/ip2bus_mst_lock
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/ip2bus_mst_reset
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/bus2ip_mst_cmdack
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/bus2ip_mst_cmplt
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/bus2ip_mst_error
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/bus2ip_mst_rearbitrate
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/bus2ip_mst_cmd_timeout
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/bus2ip_mstrd_d
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/bus2ip_mstrd_src_rdy_n
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/ip2bus_mstwr_d
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/bus2ip_mstwr_dst_rdy_n
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/ip2bus_ack
add wave -noupdate -divider {FSM Signals}
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/bus2ip_rdce_concat
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/bus2ip_wrce_concat
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/bus_data_ready
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/bus_ack_ready
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/bus_data_out
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/inside_reset
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/inside_reset_next
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/enqueue_request
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/dequeue_request
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/dequeue_all_request
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/error_request
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/current_state
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/next_state
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/msg_chan_channeldataout
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/msg_chan_exists
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/msg_chan_full
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/cmd
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/opcode
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/cvar
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/tid
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/reset_sig
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/msg_chan_channeldatain
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/msg_chan_channelread
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/msg_chan_channelwrite
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/ack
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/fsl_s_read
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/fsl_s_exists
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/fsl_has_data
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/fsl_data
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/mst_go
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/mst_cmd_sm_state
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/mst_cmd_sm_rd_req
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/mst_cmd_sm_wr_req
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/mst_cmd_sm_reset
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/mst_cmd_sm_bus_lock
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/mst_cmd_sm_ip2bus_addr
add wave -noupdate -divider {CV Core}
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/mst_cmd_sm_ip2bus_be
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/cvcore/msg_chan_channeldatain
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/cvcore/msg_chan_channeldataout
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/cvcore/msg_chan_exists
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/cvcore/msg_chan_full
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/cvcore/msg_chan_channelread
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/cvcore/msg_chan_channelwrite
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/cvcore/cmd
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/cvcore/opcode
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/cvcore/cvar
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/cvcore/tid
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/cvcore/ack
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/cvcore/clock_sig
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/cvcore/reset_sig
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/cvcore/current_state
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/cvcore/next_state
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/cvcore/addr_counter
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/cvcore/addr_counter_next
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/cvcore/arg_cvar
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/cvcore/arg_cvar_next
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/cvcore/arg_tid
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/cvcore/arg_tid_next
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/cvcore/entry
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/cvcore/entry_next
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/cvcore/done
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/cvcore/done_next
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/cvcore/table_addr0
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/cvcore/table_din0
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/cvcore/table_dout0
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/cvcore/table_rena0
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/cvcore/table_wena0
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/cvcore/table_addr1
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/cvcore/table_din1
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/cvcore/table_dout1
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/cvcore/table_rena1
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/cvcore/table_wena1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {25915 ps} 0}
configure wave -namecolwidth 357
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {371968 ps}
