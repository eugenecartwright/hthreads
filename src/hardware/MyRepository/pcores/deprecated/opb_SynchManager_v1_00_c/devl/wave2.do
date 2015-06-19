onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Test Bench Signals}
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
add wave -noupdate -format Literal /testbench/opb_be
add wave -noupdate -format Literal -radix hexadecimal /testbench/opb_dbus
add wave -noupdate -format Literal -radix hexadecimal /testbench/sl_dbus
add wave -noupdate -format Logic /testbench/sl_errack
add wave -noupdate -format Logic /testbench/sl_retry
add wave -noupdate -format Logic /testbench/sl_toutsup
add wave -noupdate -format Logic /testbench/sl_xferack
add wave -noupdate -format Literal -radix hexadecimal /testbench/m_abus
add wave -noupdate -format Literal /testbench/m_be
add wave -noupdate -format Logic /testbench/m_buslock
add wave -noupdate -format Logic /testbench/m_request
add wave -noupdate -format Logic /testbench/m_rnw
add wave -noupdate -format Logic /testbench/m_select
add wave -noupdate -format Logic /testbench/m_seqaddr
add wave -noupdate -format Logic /testbench/system_reset
add wave -noupdate -format Logic /testbench/system_resetdone
add wave -noupdate -divider {OPB Signals}
add wave -noupdate -format Logic /testbench/synch/system_reset
add wave -noupdate -format Logic /testbench/synch/system_resetdone
add wave -noupdate -format Logic /testbench/synch/opb_clk
add wave -noupdate -format Logic /testbench/synch/opb_rst
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/sl_dbus
add wave -noupdate -format Logic /testbench/synch/sl_errack
add wave -noupdate -format Logic /testbench/synch/sl_retry
add wave -noupdate -format Logic /testbench/synch/sl_toutsup
add wave -noupdate -format Logic /testbench/synch/sl_xferack
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/opb_abus
add wave -noupdate -format Literal /testbench/synch/opb_be
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/opb_dbus
add wave -noupdate -format Logic /testbench/synch/opb_rnw
add wave -noupdate -format Logic /testbench/synch/opb_select
add wave -noupdate -format Logic /testbench/synch/opb_seqaddr
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/m_abus
add wave -noupdate -format Literal /testbench/synch/m_be
add wave -noupdate -format Logic /testbench/synch/m_buslock
add wave -noupdate -format Logic /testbench/synch/m_request
add wave -noupdate -format Logic /testbench/synch/m_rnw
add wave -noupdate -format Logic /testbench/synch/m_select
add wave -noupdate -format Logic /testbench/synch/m_seqaddr
add wave -noupdate -format Logic /testbench/synch/opb_errack
add wave -noupdate -format Logic /testbench/synch/opb_mgrant
add wave -noupdate -format Logic /testbench/synch/opb_retry
add wave -noupdate -format Logic /testbench/synch/opb_timeout
add wave -noupdate -format Logic /testbench/synch/opb_xferack
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/iip2bus_addr
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/ibus2ip_addr
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/ibus2ip_data
add wave -noupdate -format Logic /testbench/synch/ibus2ip_rnw
add wave -noupdate -format Literal /testbench/synch/ibus2ip_rdce
add wave -noupdate -format Literal /testbench/synch/ibus2ip_wrce
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/iip2bus_data
add wave -noupdate -format Logic /testbench/synch/iip2bus_wrack
add wave -noupdate -format Logic /testbench/synch/iip2bus_rdack
add wave -noupdate -format Logic /testbench/synch/iip2bus_retry
add wave -noupdate -format Logic /testbench/synch/iip2bus_error
add wave -noupdate -format Logic /testbench/synch/iip2bus_toutsup
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/iip2ip_addr
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/zero_ip2rfifo_data
add wave -noupdate -format Literal /testbench/synch/iip2bus_mstbe
add wave -noupdate -format Logic /testbench/synch/iip2bus_mstwrreq
add wave -noupdate -format Logic /testbench/synch/iip2bus_mstrdreq
add wave -noupdate -format Logic /testbench/synch/iip2bus_mstburst
add wave -noupdate -format Logic /testbench/synch/iip2bus_mstbuslock
add wave -noupdate -format Logic /testbench/synch/ibus2ip_mstwrack
add wave -noupdate -format Logic /testbench/synch/ibus2ip_mstrdack
add wave -noupdate -format Logic /testbench/synch/ibus2ip_mstretry
add wave -noupdate -format Logic /testbench/synch/ibus2ip_msterror
add wave -noupdate -format Logic /testbench/synch/ibus2ip_msttimeout
add wave -noupdate -format Logic /testbench/synch/ibus2ip_mstlastack
add wave -noupdate -format Literal /testbench/synch/ibus2ip_be
add wave -noupdate -format Logic /testbench/synch/ibus2ip_wrreq
add wave -noupdate -format Logic /testbench/synch/ibus2ip_rdreq
add wave -noupdate -format Logic /testbench/synch/ibus2ip_clk
add wave -noupdate -format Logic /testbench/synch/ibus2ip_reset
add wave -noupdate -format Literal /testbench/synch/zero_ip2bus_intrevent
add wave -noupdate -format Literal /testbench/synch/ibus2ip_cs
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/ubus2ip_data
add wave -noupdate -format Literal /testbench/synch/ubus2ip_be
add wave -noupdate -format Literal /testbench/synch/ubus2ip_rdce
add wave -noupdate -format Literal /testbench/synch/ubus2ip_wrce
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/uip2bus_data
add wave -noupdate -format Literal /testbench/synch/uip2bus_mstbe
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/ubus2ip_ardata
add wave -noupdate -format Literal /testbench/synch/ubus2ip_arbe
add wave -noupdate -format Literal /testbench/synch/ubus2ip_arcs
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/uip2bus_ardata
add wave -noupdate -format Logic /testbench/synch/send_ena
add wave -noupdate -format Literal /testbench/synch/send_id
add wave -noupdate -format Logic /testbench/synch/send_ack
add wave -noupdate -format Logic /testbench/synch/master_resetdone
add wave -noupdate -format Logic /testbench/synch/slave_resetdone
add wave -noupdate -divider {Master Signals}
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
add wave -noupdate -format Logic /testbench/synch/master_logic_i/system_reset
add wave -noupdate -format Logic /testbench/synch/master_logic_i/system_resetdone
add wave -noupdate -format Logic /testbench/synch/master_logic_i/send_ena
add wave -noupdate -format Literal /testbench/synch/master_logic_i/send_id
add wave -noupdate -format Logic /testbench/synch/master_logic_i/send_ack
add wave -noupdate -format Literal /testbench/synch/master_logic_i/send_cs
add wave -noupdate -format Literal /testbench/synch/master_logic_i/send_ns
add wave -noupdate -format Literal /testbench/synch/master_logic_i/send_tid
add wave -noupdate -format Literal /testbench/synch/master_logic_i/send_nxt
add wave -noupdate -divider {Slave Signals}
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/bus2ip_clk
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/bus2ip_reset
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/bus2ip_addr
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/bus2ip_data
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/bus2ip_be
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
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/bus2ip_arbe
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/bus2ip_arcs
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/ip2bus_ardata
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/system_reset
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/system_resetdone
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/send_ena
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/send_id
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/send_ack
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/clk
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/rst
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/rnw
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/datain
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/lock_finish
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/unlock_finish
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/trylock_finish
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/count_finish
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/kind_finish
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/owner_finish
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/result_finish
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/lock_data
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/unlock_data
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/trylock_data
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/count_data
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/kind_data
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/owner_data
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/result_data
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/lock_maddr
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/unlock_maddr
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/trylock_maddr
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/count_maddr
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/kind_maddr
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/owner_maddr
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/lock_mena
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/unlock_mena
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/trylock_mena
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/count_mena
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/kind_mena
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/owner_mena
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/lock_mwea
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/unlock_mwea
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/trylock_mwea
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/count_mwea
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/kind_mwea
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/owner_mwea
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/lock_mowner
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/unlock_mowner
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/trylock_mowner
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/count_mowner
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/kind_mowner
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/owner_mowner
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/lock_mnext
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/unlock_mnext
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/trylock_mnext
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/count_mnext
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/kind_mnext
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/owner_mnext
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/lock_mlast
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/unlock_mlast
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/trylock_mlast
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/count_mlast
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/kind_mlast
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/owner_mlast
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/lock_mcount
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/unlock_mcount
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/trylock_mcount
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/count_mcount
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/kind_mcount
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/owner_mcount
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/lock_mkind
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/unlock_mkind
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/trylock_mkind
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/count_mkind
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/kind_mkind
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/owner_mkind
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/lock_taddr
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/unlock_taddr
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/trylock_taddr
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/count_taddr
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/kind_taddr
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/owner_taddr
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/lock_tena
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/unlock_tena
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/trylock_tena
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/count_tena
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/kind_tena
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/owner_tena
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/lock_twea
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/unlock_twea
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/trylock_twea
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/count_twea
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/kind_twea
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/owner_twea
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/lock_tnext
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/unlock_tnext
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/trylock_tnext
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/count_tnext
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/kind_tnext
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/owner_tnext
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/unlock_sena
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/unlock_sid
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/miaddr
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/miena
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/miwea
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/miowner
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/minext
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/milast
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/micount
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/mikind
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/moowner
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/monext
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/molast
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/mocount
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/mokind
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/tiaddr
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/tiena
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/tiwea
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/tinext
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/tonext
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/lock_resetdone
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/unlock_resetdone
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/trylock_resetdone
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/owner_resetdone
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/kind_resetdone
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/count_resetdone
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/result_resetdone
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/thread_resetdone
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/mutex_resetdone
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/cmd_number
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/thr_number
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/mtx_number
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/knd_number
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/result_start
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/count_start
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/kind_start
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/owner_start
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/trylock_start
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/unlock_start
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/lock_start
add wave -noupdate -divider {Lock Signals}
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/lock_i/clk
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/lock_i/rst
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/lock_i/start
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/lock_i/finish
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/lock_i/data
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/lock_i/mutex
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/lock_i/thread
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/lock_i/miowner
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/lock_i/minext
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/lock_i/milast
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/lock_i/micount
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/lock_i/mikind
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/lock_i/tinext
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/lock_i/moaddr
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/lock_i/moena
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/lock_i/mowea
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/lock_i/moowner
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/lock_i/monext
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/lock_i/molast
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/lock_i/mocount
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/lock_i/mokind
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/lock_i/sysrst
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/lock_i/rstdone
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/lock_i/toaddr
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/lock_i/toena
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/lock_i/towea
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/lock_i/tonext
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/lock_i/lock_cs
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/lock_i/lock_ns
add wave -noupdate -divider {Unlock Signals}
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/unlock_i/clk
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/unlock_i/rst
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/unlock_i/start
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/unlock_i/finish
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/unlock_i/data
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/unlock_i/mutex
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/unlock_i/thread
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/unlock_i/miowner
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/unlock_i/minext
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/unlock_i/milast
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/unlock_i/micount
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/unlock_i/mikind
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/unlock_i/tinext
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/unlock_i/moaddr
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/unlock_i/moena
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/unlock_i/mowea
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/unlock_i/moowner
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/unlock_i/monext
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/unlock_i/molast
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/unlock_i/mocount
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/unlock_i/mokind
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/unlock_i/toaddr
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/unlock_i/toena
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/unlock_i/towea
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/unlock_i/tonext
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/unlock_i/sysrst
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/unlock_i/rstdone
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/unlock_i/sena
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/unlock_i/sid
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/unlock_i/sack
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/unlock_i/unlock_cs
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/unlock_i/unlock_ns
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/unlock_i/hold_minext
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/unlock_i/hold_minext_nxt
add wave -noupdate -divider {Try Signals}
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/trylock_i/clk
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/trylock_i/rst
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/trylock_i/start
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/trylock_i/finish
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/trylock_i/data
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/trylock_i/mutex
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/trylock_i/thread
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/trylock_i/miowner
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/trylock_i/milast
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/trylock_i/minext
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/trylock_i/micount
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/trylock_i/mikind
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/trylock_i/tinext
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/trylock_i/moaddr
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/trylock_i/moena
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/trylock_i/mowea
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/trylock_i/moowner
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/trylock_i/monext
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/trylock_i/molast
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/trylock_i/mocount
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/trylock_i/mokind
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/trylock_i/sysrst
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/trylock_i/rstdone
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/trylock_i/toaddr
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/trylock_i/toena
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/trylock_i/towea
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/trylock_i/tonext
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/trylock_i/try_cs
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/trylock_i/try_ns
add wave -noupdate -divider {Count Signals}
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/count_i/clk
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/count_i/rst
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/count_i/start
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/count_i/finish
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/count_i/data
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/count_i/mutex
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/count_i/thread
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/count_i/miowner
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/count_i/minext
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/count_i/milast
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/count_i/micount
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/count_i/mikind
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/count_i/tinext
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/count_i/moaddr
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/count_i/moena
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/count_i/mowea
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/count_i/moowner
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/count_i/monext
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/count_i/molast
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/count_i/mocount
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/count_i/mokind
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/count_i/sysrst
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/count_i/rstdone
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/count_i/toaddr
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/count_i/toena
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/count_i/towea
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/count_i/tonext
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/count_i/count_cs
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/count_i/count_ns
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/count_i/cdata
add wave -noupdate -divider {Kind Signals}
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/kind_i/clk
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/kind_i/rst
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/kind_i/start
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/kind_i/finish
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/kind_i/rnw
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/kind_i/datain
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/kind_i/data
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/kind_i/mutex
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/kind_i/thread
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/kind_i/miowner
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/kind_i/minext
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/kind_i/milast
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/kind_i/micount
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/kind_i/mikind
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/kind_i/tinext
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/kind_i/moaddr
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/kind_i/moena
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/kind_i/mowea
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/kind_i/moowner
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/kind_i/monext
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/kind_i/molast
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/kind_i/mocount
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/kind_i/mokind
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/kind_i/sysrst
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/kind_i/rstdone
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/kind_i/toaddr
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/kind_i/toena
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/kind_i/towea
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/kind_i/tonext
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/kind_i/kind_cs
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/kind_i/kind_ns
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/kind_i/kodata
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/kind_i/kidata
add wave -noupdate -divider {Owner Signals}
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/owner_i/clk
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/owner_i/rst
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/owner_i/start
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/owner_i/finish
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/owner_i/data
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/owner_i/mutex
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/owner_i/thread
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/owner_i/miowner
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/owner_i/minext
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/owner_i/milast
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/owner_i/micount
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/owner_i/mikind
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/owner_i/tinext
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/owner_i/moaddr
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/owner_i/moena
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/owner_i/mowea
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/owner_i/moowner
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/owner_i/monext
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/owner_i/molast
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/owner_i/mocount
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/owner_i/mokind
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/owner_i/sysrst
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/owner_i/rstdone
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/owner_i/toaddr
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/owner_i/toena
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/owner_i/towea
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/owner_i/tonext
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/owner_i/owner_cs
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/owner_i/owner_ns
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/owner_i/odata
add wave -noupdate -divider {Thread Store}
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/thread_i/clk
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/thread_i/rst
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/thread_i/sysrst
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/thread_i/rstdone
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/thread_i/tiaddr
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/thread_i/tiena
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/thread_i/tiwea
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/thread_i/tinext
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/thread_i/tonext
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/thread_i/store
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/thread_i/tena
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/thread_i/twea
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/thread_i/taddr
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/thread_i/tinput
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/thread_i/toutput
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/thread_i/rst_cs
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/thread_i/rena
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/thread_i/rwea
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/thread_i/raddr
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/thread_i/raddrn
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/thread_i/rnext
add wave -noupdate -divider {Mutex Store}
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/mutex_i/clk
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/mutex_i/rst
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/mutex_i/miaddr
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/mutex_i/miena
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/mutex_i/miwea
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/mutex_i/miowner
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/mutex_i/minext
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/mutex_i/milast
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/mutex_i/mikind
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/mutex_i/micount
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/mutex_i/sysrst
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/mutex_i/rstdone
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/mutex_i/moowner
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/mutex_i/monext
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/mutex_i/molast
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/mutex_i/mokind
add wave -noupdate -format Literal -radix unsigned /testbench/synch/slave_logic_i/mutex_i/mocount
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/mutex_i/store
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/mutex_i/mena
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/mutex_i/mwea
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/mutex_i/maddr
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/mutex_i/minput
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/mutex_i/moutput
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/mutex_i/rena
add wave -noupdate -format Logic /testbench/synch/slave_logic_i/mutex_i/rwea
add wave -noupdate -format Literal /testbench/synch/slave_logic_i/mutex_i/rst_cs
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/mutex_i/raddr
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/mutex_i/raddrn
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/mutex_i/rowner
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/mutex_i/rnext
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/mutex_i/rlast
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/mutex_i/rkind
add wave -noupdate -format Literal -radix hexadecimal /testbench/synch/slave_logic_i/mutex_i/rcount
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3200 ns} 0}
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
WaveRestoreZoom {3036 ns} {3292 ns}
