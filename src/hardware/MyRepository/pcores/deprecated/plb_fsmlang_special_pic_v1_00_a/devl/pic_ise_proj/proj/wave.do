onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Interrupt Signals}
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/internalcore/intc_logic/interrupts_in
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/internalcore/intc_logic/ier_in
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/internalcore/intc_logic/iar_in
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/internalcore/intc_logic/interrupts_out
add wave -noupdate -divider {Channel Data}
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/msg_chan_channeldatain
add wave -noupdate -divider {Internal PIC Logic}
add wave -noupdate -format Literal -radix hexadecimal -expand /user_logic_tb/uut/internalcore/pic_logic/array_bram/bram_data
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/msg_chan_channeldataout
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/msg_chan_exists
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/msg_chan_full
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/msg_chan_channelread
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/msg_chan_channelwrite
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/go
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/ack
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/tid_in
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/iid_in
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/cmd_in
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/rupt_in
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/ier_out
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/iar_out
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/ret_out
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/tid_out
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/clock_sig
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/reset_sig
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/currenty_state
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/next_state
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/mem_addr_counter
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/mem_addr_counter_next
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/cur_mem_reg
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/cur_mem_reg_next
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/retcode
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/retcode_next
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/reg_out
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/reg_out_next
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/busy
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/busy_next
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/rupt_addr_counter
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/rupt_addr_counter_next
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/ier_sig
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/ier_sig_next
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/iar_sig
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/iar_sig_next
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/array_addr0
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/array_din0
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/array_dout0
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/array_rena0
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/array_wena0
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/array_addr1
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/array_din1
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/array_dout1
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/array_rena1
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/internalcore/pic_logic/array_wena1
add wave -noupdate -divider {User Logic Signals}
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/soft_reset
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/reset_done
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/interrupts_in
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
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/bus2ip_rdce_concat
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/bus2ip_wrce_concat
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/bus_data_ready
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/bus_ack_ready
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/bus_data_out
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/inside_reset
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/inside_reset_next
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/opwrite_request
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/opread_request
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/opclear_request
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/error_request
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/current_state
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/next_state
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/msg_chan_channeldataout
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/msg_chan_exists
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/msg_chan_full
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/cmd
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/opcode
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/iid
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/tid
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/reset_sig
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/msg_chan_channeldatain
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/msg_chan_channelread
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/msg_chan_channelwrite
add wave -noupdate -format Logic -radix hexadecimal /user_logic_tb/uut/ack
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/ret_out
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/tid_out
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
add wave -noupdate -format Literal -radix hexadecimal /user_logic_tb/uut/mst_cmd_sm_ip2bus_be
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2205000 ps} 0}
configure wave -namecolwidth 511
configure wave -valuecolwidth 126
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
WaveRestoreZoom {0 ps} {2521088 ps}
