onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Global
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/sys_clk
add wave -noupdate -format Logic -radix hexadecimal /bfm_system/sys_reset
add wave -noupdate -divider {FSL Links}
add wave -noupdate -group USER2HWTI
add wave -noupdate -group USER2HWTI -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/u2hlow_m_write
add wave -noupdate -group USER2HWTI -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/u2hlow_m_data
add wave -noupdate -group USER2HWTI -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/u2hlow_m_control
add wave -noupdate -group USER2HWTI -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/u2hlow_m_full
add wave -noupdate -group USER2HWTI -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/u2hhigh_m_write
add wave -noupdate -group USER2HWTI -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/u2hhigh_m_data
add wave -noupdate -group USER2HWTI -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/u2hhigh_m_control
add wave -noupdate -group USER2HWTI -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/u2hhigh_m_full
add wave -noupdate -group HWTI2USER
add wave -noupdate -group HWTI2USER -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/h2ulow_s_read
add wave -noupdate -group HWTI2USER -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/h2ulow_s_data
add wave -noupdate -group HWTI2USER -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/h2ulow_s_control
add wave -noupdate -group HWTI2USER -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/h2ulow_s_exists
add wave -noupdate -group HWTI2USER -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/h2uhigh_s_read
add wave -noupdate -group HWTI2USER -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/h2uhigh_s_data
add wave -noupdate -group HWTI2USER -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/h2uhigh_s_control
add wave -noupdate -group HWTI2USER -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/h2uhigh_s_exists
add wave -noupdate -group USER_LOW
add wave -noupdate -group USER_LOW -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user2hwtil_s_read
add wave -noupdate -group USER_LOW -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user2hwtil_s_data
add wave -noupdate -group USER_LOW -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user2hwtil_s_control
add wave -noupdate -group USER_LOW -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user2hwtil_s_exists
add wave -noupdate -group USER_LOW -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user2hwtil_m_write
add wave -noupdate -group USER_LOW -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user2hwtil_m_data
add wave -noupdate -group USER_LOW -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user2hwtil_m_control
add wave -noupdate -group USER_LOW -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user2hwtil_m_full
add wave -noupdate -group USER_HIGH
add wave -noupdate -group USER_HIGH -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user2hwtih_s_read
add wave -noupdate -group USER_HIGH -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user2hwtih_s_data
add wave -noupdate -group USER_HIGH -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user2hwtih_s_control
add wave -noupdate -group USER_HIGH -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user2hwtih_s_exists
add wave -noupdate -group USER_HIGH -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user2hwtih_m_write
add wave -noupdate -group USER_HIGH -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user2hwtih_m_data
add wave -noupdate -group USER_HIGH -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user2hwtih_m_control
add wave -noupdate -group USER_HIGH -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user2hwtih_m_full
add wave -noupdate -group HWTI_LOW
add wave -noupdate -group HWTI_LOW -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/hwti2userl_s_read
add wave -noupdate -group HWTI_LOW -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/hwti2userl_s_data
add wave -noupdate -group HWTI_LOW -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/hwti2userl_s_control
add wave -noupdate -group HWTI_LOW -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/hwti2userl_s_exists
add wave -noupdate -group HWTI_LOW -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/hwti2userl_m_write
add wave -noupdate -group HWTI_LOW -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/hwti2userl_m_data
add wave -noupdate -group HWTI_LOW -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/hwti2userl_m_control
add wave -noupdate -group HWTI_LOW -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/hwti2userl_m_full
add wave -noupdate -group HWTI_HIGH
add wave -noupdate -group HWTI_HIGH -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/hwti2userh_s_read
add wave -noupdate -group HWTI_HIGH -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/hwti2userh_s_data
add wave -noupdate -group HWTI_HIGH -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/hwti2userh_s_control
add wave -noupdate -group HWTI_HIGH -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/hwti2userh_s_exists
add wave -noupdate -group HWTI_HIGH -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/hwti2userh_m_write
add wave -noupdate -group HWTI_HIGH -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/hwti2userh_m_data
add wave -noupdate -group HWTI_HIGH -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/hwti2userh_m_control
add wave -noupdate -group HWTI_HIGH -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/hwti2userh_m_full
add wave -noupdate -group H2U_INT
add wave -noupdate -group H2U_INT -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/hwti2user_s_read
add wave -noupdate -group H2U_INT -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/hwti2user_s_data
add wave -noupdate -group H2U_INT -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/hwti2user_s_control
add wave -noupdate -group H2U_INT -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/hwti2user_s_exists
add wave -noupdate -group H2U_INT -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/hwti2user_m_write
add wave -noupdate -group H2U_INT -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/hwti2user_m_data
add wave -noupdate -group H2U_INT -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/hwti2user_m_control
add wave -noupdate -group H2U_INT -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/hwti2user_m_full
add wave -noupdate -group U2H_INT
add wave -noupdate -group U2H_INT -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user2hwti_s_read
add wave -noupdate -group U2H_INT -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user2hwti_s_data
add wave -noupdate -group U2H_INT -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user2hwti_s_control
add wave -noupdate -group U2H_INT -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user2hwti_s_exists
add wave -noupdate -group U2H_INT -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user2hwti_m_write
add wave -noupdate -group U2H_INT -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user2hwti_m_data
add wave -noupdate -group U2H_INT -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user2hwti_m_control
add wave -noupdate -group U2H_INT -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user2hwti_m_full
add wave -noupdate -divider {HWTI Commands}
add wave -noupdate -group Commands
add wave -noupdate -group Commands -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/icommand/clk
add wave -noupdate -group Commands -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/icommand/rst
add wave -noupdate -group Commands -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/icommand/tid
add wave -noupdate -group Commands -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/icommand/opcode_read
add wave -noupdate -group Commands -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/icommand/opcode_data
add wave -noupdate -group Commands -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/icommand/opcode_control
add wave -noupdate -group Commands -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/icommand/opcode_exists
add wave -noupdate -group Commands -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/icommand/result_write
add wave -noupdate -group Commands -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/icommand/result_data
add wave -noupdate -group Commands -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/icommand/result_control
add wave -noupdate -group Commands -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/icommand/result_full
add wave -noupdate -group Commands -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/icommand/command
add wave -noupdate -group Commands -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/icommand/status
add wave -noupdate -group Commands -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/icommand/setsta
add wave -noupdate -group Commands -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/icommand/outsta
add wave -noupdate -group Commands -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/icommand/rd
add wave -noupdate -group Commands -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/icommand/wr
add wave -noupdate -group Commands -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/icommand/addr
add wave -noupdate -group Commands -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/icommand/data
add wave -noupdate -group Commands -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/icommand/ack
add wave -noupdate -group Commands -format Logic /bfm_system/my_core/my_core/hwti/user_logic_i/icommand/last
add wave -noupdate -group Commands -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/icommand/err
add wave -noupdate -group Commands -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/icommand/results
add wave -noupdate -group Commands -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/icommand/cmd_cs
add wave -noupdate -group Commands -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/icommand/cmd_ns
add wave -noupdate -group Commands -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/icommand/osta
add wave -noupdate -group Commands -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/icommand/opres
add wave -noupdate -group Commands -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/icommand/operr
add wave -noupdate -group Commands -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/icommand/oparg
add wave -noupdate -group Commands -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/icommand/opcmd
add wave -noupdate -group Commands -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/icommand/opdev
add wave -noupdate -group Commands -format Logic /bfm_system/my_core/my_core/hwti/user_logic_i/icommand/memrd
add wave -noupdate -group Commands -format Logic /bfm_system/my_core/my_core/hwti/user_logic_i/icommand/memwr
add wave -noupdate -group Commands -format Logic /bfm_system/my_core/my_core/hwti/user_logic_i/icommand/memrdack
add wave -noupdate -group Commands -format Logic /bfm_system/my_core/my_core/hwti/user_logic_i/icommand/memwrack
add wave -noupdate -divider {HWTI Memory}
add wave -noupdate -group Memory
add wave -noupdate -group Memory -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/imemory/clk
add wave -noupdate -group Memory -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/imemory/rst
add wave -noupdate -group Memory -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/imemory/rd
add wave -noupdate -group Memory -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/imemory/wr
add wave -noupdate -group Memory -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/imemory/addr
add wave -noupdate -group Memory -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/imemory/length
add wave -noupdate -group Memory -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/imemory/ack
add wave -noupdate -group Memory -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/imemory/bus2ip_msterror
add wave -noupdate -group Memory -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/imemory/bus2ip_mstlastack
add wave -noupdate -group Memory -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/imemory/bus2ip_mstrdack
add wave -noupdate -group Memory -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/imemory/bus2ip_mstwrack
add wave -noupdate -group Memory -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/imemory/bus2ip_mstretry
add wave -noupdate -group Memory -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/imemory/bus2ip_msttimeout
add wave -noupdate -group Memory -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/imemory/ip2bus_addr
add wave -noupdate -group Memory -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/imemory/ip2bus_mstbe
add wave -noupdate -group Memory -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/imemory/ip2bus_mstburst
add wave -noupdate -group Memory -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/imemory/ip2bus_mstbuslock
add wave -noupdate -group Memory -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/imemory/ip2bus_mstnum
add wave -noupdate -group Memory -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/imemory/ip2bus_mstrdreq
add wave -noupdate -group Memory -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/imemory/ip2bus_mstwrreq
add wave -noupdate -group Memory -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/imemory/ip2ip_addr
add wave -noupdate -group Memory -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/imemory/go
add wave -noupdate -group Memory -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/imemory/mem_cs
add wave -noupdate -group Memory -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/imemory/mem_ns
add wave -noupdate -group Memory -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/imemory/count_cv
add wave -noupdate -group Memory -format Literal -radix unsigned /bfm_system/my_core/my_core/hwti/user_logic_i/imemory/count_nv
add wave -noupdate -group Memory -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/imemory/baddr_cv
add wave -noupdate -group Memory -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/imemory/baddr_nv
add wave -noupdate -group Memory -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/imemory/burst_cv
add wave -noupdate -group Memory -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/imemory/burst_nv
add wave -noupdate -divider {HWTI PLB}
add wave -noupdate -expand -group {HWTI IPIF}
add wave -noupdate -group {HWTI IPIF} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/bus2ip_clk
add wave -noupdate -group {HWTI IPIF} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/bus2ip_reset
add wave -noupdate -group {HWTI IPIF} -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/bus2ip_data
add wave -noupdate -group {HWTI IPIF} -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/bus2ip_be
add wave -noupdate -group {HWTI IPIF} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/bus2ip_burst
add wave -noupdate -group {HWTI IPIF} -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/bus2ip_rdce
add wave -noupdate -group {HWTI IPIF} -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/bus2ip_wrce
add wave -noupdate -group {HWTI IPIF} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/bus2ip_rdreq
add wave -noupdate -group {HWTI IPIF} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/bus2ip_wrreq
add wave -noupdate -group {HWTI IPIF} -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/ip2bus_data
add wave -noupdate -group {HWTI IPIF} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/ip2bus_retry
add wave -noupdate -group {HWTI IPIF} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/ip2bus_error
add wave -noupdate -group {HWTI IPIF} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/ip2bus_toutsup
add wave -noupdate -group {HWTI IPIF} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/ip2bus_rdack
add wave -noupdate -group {HWTI IPIF} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/ip2bus_wrack
add wave -noupdate -group {HWTI IPIF} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/bus2ip_msterror
add wave -noupdate -group {HWTI IPIF} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/bus2ip_mstlastack
add wave -noupdate -group {HWTI IPIF} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/bus2ip_mstrdack
add wave -noupdate -group {HWTI IPIF} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/bus2ip_mstwrack
add wave -noupdate -group {HWTI IPIF} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/bus2ip_mstretry
add wave -noupdate -group {HWTI IPIF} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/bus2ip_msttimeout
add wave -noupdate -group {HWTI IPIF} -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/ip2bus_addr
add wave -noupdate -group {HWTI IPIF} -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/ip2bus_mstbe
add wave -noupdate -group {HWTI IPIF} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/ip2bus_mstburst
add wave -noupdate -group {HWTI IPIF} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/ip2bus_mstbuslock
add wave -noupdate -group {HWTI IPIF} -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/ip2bus_mstnum
add wave -noupdate -group {HWTI IPIF} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/ip2bus_mstrdreq
add wave -noupdate -group {HWTI IPIF} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/ip2bus_mstwrreq
add wave -noupdate -group {HWTI IPIF} -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/ip2ip_addr
add wave -noupdate -group {MEM Access}
add wave -noupdate -group {MEM Access} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/mem_rd
add wave -noupdate -group {MEM Access} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/mem_wr
add wave -noupdate -group {MEM Access} -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/mem_addr
add wave -noupdate -group {MEM Access} -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/mem_res
add wave -noupdate -group {MEM Access} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/mem_ack
add wave -noupdate -group {MEM Access} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/mem_err
add wave -noupdate -group {MEM Access} -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/mem_data
add wave -noupdate -group {REG Data}
add wave -noupdate -group {REG Data} -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/tid_data
add wave -noupdate -group {REG Data} -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/sta_data
add wave -noupdate -group {REG Data} -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/arg_data
add wave -noupdate -group {REG Data} -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/res_data
add wave -noupdate -group {REG Value}
add wave -noupdate -group {REG Value} -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/tid_value
add wave -noupdate -group {REG Value} -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/sta_value
add wave -noupdate -group {REG Value} -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/arg_value
add wave -noupdate -group {REG Value} -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/res_value
add wave -noupdate -group {REG Update}
add wave -noupdate -group {REG Update} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/cmd_wr
add wave -noupdate -group {REG Update} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/sta_wr
add wave -noupdate -group {REG Update} -format Literal -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/sta_wdata
add wave -noupdate -expand -group {REG Write}
add wave -noupdate -group {REG Write} -format Logic /bfm_system/my_core/my_core/hwti/user_logic_i/cmd_write
add wave -noupdate -group {REG Write} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/res_write
add wave -noupdate -group {REG Write} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/sta_write
add wave -noupdate -group {REG Write} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/arg_write
add wave -noupdate -group {REG Write} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/tid_write
add wave -noupdate -group {REG Write} -format Logic /bfm_system/my_core/my_core/hwti/user_logic_i/bus_write
add wave -noupdate -expand -group {REG Read}
add wave -noupdate -group {REG Read} -format Logic /bfm_system/my_core/my_core/hwti/user_logic_i/cmd_read
add wave -noupdate -group {REG Read} -format Logic /bfm_system/my_core/my_core/hwti/user_logic_i/bus_read
add wave -noupdate -group {REG Read} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/res_read
add wave -noupdate -group {REG Read} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/arg_read
add wave -noupdate -group {REG Read} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/sta_read
add wave -noupdate -group {REG Read} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/tid_read
add wave -noupdate -expand -group {READ Ack}
add wave -noupdate -group {READ Ack} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/tid_rdack
add wave -noupdate -group {READ Ack} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/sta_rdack
add wave -noupdate -group {READ Ack} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/arg_rdack
add wave -noupdate -group {READ Ack} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/res_rdack
add wave -noupdate -group {WRITE Ack}
add wave -noupdate -group {WRITE Ack} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/tid_wrack
add wave -noupdate -group {WRITE Ack} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/sta_wrack
add wave -noupdate -group {WRITE Ack} -format Logic -radix hexadecimal /bfm_system/my_core/my_core/hwti/user_logic_i/arg_wrack
add wave -noupdate -group Synch
add wave -noupdate -group Synch -format Literal -radix hexadecimal /bfm_system/my_core/my_core/synch_in
add wave -noupdate -group Synch -format Literal -radix hexadecimal /bfm_system/my_core/my_core/synch_out
add wave -noupdate -divider {Condition Variables}
add wave -noupdate -group {CV Slave}
add wave -noupdate -group {CV Slave} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/slv2msc_data
add wave -noupdate -group {CV Slave} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/slv2msc_addr
add wave -noupdate -group {CV Slave} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/msc2slv_data
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/slv2msc_xfer_bgnw
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/msc2slv_xferw_ack
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/slv2msc_xfer_bgn
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/msc2slv_xfer_ack
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/msc2slv_last_ack
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/bus2ip_reset
add wave -noupdate -group {CV Slave} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/bus2ip_addr
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/bus2ip_clk
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/bus2ip_rdreq
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/ip2bus_rdack
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/bus2ip_wrreq
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/ip2bus_wrack
add wave -noupdate -group {CV Slave} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/bus2ip_data
add wave -noupdate -group {CV Slave} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/bus2ip_reg_rdce
add wave -noupdate -group {CV Slave} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/bus2ip_reg_wrce
add wave -noupdate -group {CV Slave} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/ip2bus_data
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/sema_reset
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/sema_rst_ack
add wave -noupdate -group {CV Slave} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/sendout_cs
add wave -noupdate -group {CV Slave} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/sendout_ns
add wave -noupdate -group {CV Slave} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/debug_reg
add wave -noupdate -group {CV Slave} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/data_xfer_reg
add wave -noupdate -group {CV Slave} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/addr
add wave -noupdate -group {CV Slave} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/addr_full
add wave -noupdate -group {CV Slave} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/w_addr
add wave -noupdate -group {CV Slave} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/read_data
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/ip2bus_wrack_i
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/ip2bus_rdack_i
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/ip2bus_rdack_i2
add wave -noupdate -group {CV Slave} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/qcur_state
add wave -noupdate -group {CV Slave} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/qnext_state
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/q_enable
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/q_read_wr
add wave -noupdate -group {CV Slave} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/q_datain
add wave -noupdate -group {CV Slave} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/q_dataout
add wave -noupdate -group {CV Slave} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/q_addr
add wave -noupdate -group {CV Slave} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/qaddra_reg
add wave -noupdate -group {CV Slave} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/qdataa
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/enqueue
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/dequeue
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/broadcast
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/data_latch
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/busmsc_start
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/enque_done
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/deque_non
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/deque_done
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/que_opr_done
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/msc_done
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/deq_start
add wave -noupdate -group {CV Slave} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/cntql
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/cntql_decr
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/cntql_latch
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/transfer
add wave -noupdate -group {CV Slave} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/sem_id
add wave -noupdate -group {CV Slave} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/thr_id
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/que_rst_start
add wave -noupdate -group {CV Slave} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/que_ram_addr
add wave -noupdate -group {CV Slave} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/lock_addr_reg
add wave -noupdate -group {CV Slave} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/threadid_reg
add wave -noupdate -group {CV Slave} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/req_rel_thrid_reg
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/clock
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/read_enable
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/pwr
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/gnd
add wave -noupdate -group {CV Slave} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/gnd_bus
add wave -noupdate -group {CV Slave} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/data_out
add wave -noupdate -group {CV Slave} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/addr_out
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/do_compare
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/nrdwr_opr
add wave -noupdate -group {CV Slave} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/cv_event
add wave -noupdate -group {CV Slave} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/prev_status
add wave -noupdate -group {CV Slave} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/slv_entity_i/cur_status
add wave -noupdate -group {CV Master}
add wave -noupdate -group {CV Master} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/slv2msc_data
add wave -noupdate -group {CV Master} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/slv2msc_addr
add wave -noupdate -group {CV Master} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/msc2slv_data
add wave -noupdate -group {CV Master} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/slv2msc_xfer_bgnw
add wave -noupdate -group {CV Master} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/msc2slv_xferw_ack
add wave -noupdate -group {CV Master} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/slv2msc_xfer_bgn
add wave -noupdate -group {CV Master} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/msc2slv_xfer_ack
add wave -noupdate -group {CV Master} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/msc2slv_last_ack
add wave -noupdate -group {CV Master} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/msc_dbus_ctrl
add wave -noupdate -group {CV Master} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/bus2ip_clk
add wave -noupdate -group {CV Master} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/bus2ip_data
add wave -noupdate -group {CV Master} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/bus2ip_freeze
add wave -noupdate -group {CV Master} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/bus2ip_mstrdack
add wave -noupdate -group {CV Master} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/bus2ip_mstwrack
add wave -noupdate -group {CV Master} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/bus2ip_mstretry
add wave -noupdate -group {CV Master} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/bus2ip_msterror
add wave -noupdate -group {CV Master} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/bus2ip_msttimeout
add wave -noupdate -group {CV Master} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/bus2ip_mstlastack
add wave -noupdate -group {CV Master} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/bus2ip_reset
add wave -noupdate -group {CV Master} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/ip2bus_addr
add wave -noupdate -group {CV Master} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/ip2bus_data
add wave -noupdate -group {CV Master} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/ip2bus_mstbe
add wave -noupdate -group {CV Master} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/ip2bus_mstrdreq
add wave -noupdate -group {CV Master} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/ip2bus_mstwrreq
add wave -noupdate -group {CV Master} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/ip2bus_mstburst
add wave -noupdate -group {CV Master} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/ip2bus_mstbuslock
add wave -noupdate -group {CV Master} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/control_sm_cs
add wave -noupdate -group {CV Master} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/control_sm_ns
add wave -noupdate -group {CV Master} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/addr_count
add wave -noupdate -group {CV Master} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/read_write
add wave -noupdate -group {CV Master} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/read_reg
add wave -noupdate -group {CV Master} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/read_data_avail
add wave -noupdate -group {CV Master} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/data
add wave -noupdate -group {CV Master} -format Literal -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/address
add wave -noupdate -group {CV Master} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/read_wr_done
add wave -noupdate -group {CV Master} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/read_sw_mgr
add wave -noupdate -group {CV Master} -format Logic -radix hexadecimal /bfm_system/cond_vars/cond_vars/msc_entity_i/write_hw_thr
add wave -noupdate -divider Scheduler
add wave -noupdate -group {SCH Slave}
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/soft_reset
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/reset_done
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/soft_stop
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/swtm_dob
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/swtm_addrb
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/swtm_dib
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/swtm_enb
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/swtm_web
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/tm2sch_current_cpu_tid
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/tm2sch_opcode
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/tm2sch_data
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/tm2sch_request
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/sch2tm_busy
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/sch2tm_data
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/sch2tm_next_cpu_tid
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/sch2tm_next_tid_valid
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/preemption_interrupt
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/bus2ip_clk
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/bus2ip_reset
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/bus2ip_addr
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/bus2ip_data
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/bus2ip_be
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/bus2ip_rdce
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/bus2ip_wrce
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/bus2ip_rdreq
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/bus2ip_wrreq
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/ip2bus_data
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/ip2bus_retry
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/ip2bus_error
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/ip2bus_toutsup
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/ip2bus_ack
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/bus2ip_msterror
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/bus2ip_mstlastack
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/bus2ip_mstrdack
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/bus2ip_mstwrack
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/bus2ip_mstretry
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/bus2ip_msttimeout
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/ip2bus_addr
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/ip2bus_mstbe
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/ip2bus_mstburst
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/ip2bus_mstbuslock
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/ip2bus_mstrdreq
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/ip2bus_mstwrreq
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/ip2ip_addr
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/next_thread_valid_reg
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/next_thread_valid_next
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/sched_busy
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/sched_busy_next
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/reset_addr
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/bus2ip_rdce_concat
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/bus2ip_wrce_concat
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/tm_data_ready
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/tm_data_out
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/bus_data_ready
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/bus_ack_ready
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/bus_data_out
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/preemption_interrupt_line
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/preemption_interrupt_enable
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/preemption_interrupt_enable_next
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/tm2sch_current_cpu_tid_reg
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/next_thread_id_reg
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/next_thread_id_next
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/debug_reg
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/debug_reg_next
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/inside_reset
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/inside_reset_next
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/enqueue_request
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/dequeue_request
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/is_queued_request
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/is_empty_request
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/get_encoderoutput_request
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/set_schedparam_request
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/get_schedparam_request
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/check_schedparam_request
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/toggle_preemption_request
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/get_idlethread_request
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/set_idlethread_request
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/get_entry_request
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/default_priority_request
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/master_read_data_request
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/error_request
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/lookup_entry
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/lookup_entry_next
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/dequeue_entry
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/dequeue_entry_next
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/enqueue_entry
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/enqueue_entry_next
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/enqueue_pri_entry
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/enqueue_pri_entry_next
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/deq_pri_entry
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/deq_pri_entry_next
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/sched_param
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/sched_param_next
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/old_tail_ptr
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/old_tail_ptr_next
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/current_entry_pri_value
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/current_entry_pri_value_next
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/old_priority
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/old_priority_next
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/new_priority
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/new_priority_next
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/lookup_id
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/lookup_id_next
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/idle_thread_id
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/idle_thread_id_next
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/idle_thread_valid
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/idle_thread_valid_next
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/temp_valid
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/temp_valid_next
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/doa
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/addra
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/dia
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/ena
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/wea
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/dob
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/addrb
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/dib
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/enb
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/web
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/dou
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/addru
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/diu
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/enu
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/weu
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/encoder_reset
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/encoder_input
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/encoder_input_next
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/encoder_output
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/encoder_enable_next
add wave -noupdate -group {SCH Slave} -format Logic -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/encoder_enable
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/current_state_master
add wave -noupdate -group {SCH Slave} -format Literal -radix hexadecimal /bfm_system/scheduler/scheduler/user_logic_i/next_state_master
add wave -noupdate -divider {Thread Manager}
add wave -noupdate -group {TM Slave}
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/bus2ip_addr
add wave -noupdate -group {TM Slave} -format Logic -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/bus2ip_clk
add wave -noupdate -group {TM Slave} -format Logic -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/bus2ip_cs
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/bus2ip_data
add wave -noupdate -group {TM Slave} -format Logic -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/bus2ip_rdce
add wave -noupdate -group {TM Slave} -format Logic -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/bus2ip_reset
add wave -noupdate -group {TM Slave} -format Logic -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/bus2ip_wrce
add wave -noupdate -group {TM Slave} -format Logic -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/ip2bus_ack
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/ip2bus_data
add wave -noupdate -group {TM Slave} -format Logic -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/ip2bus_error
add wave -noupdate -group {TM Slave} -format Logic -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/ip2bus_postedwrinh
add wave -noupdate -group {TM Slave} -format Logic -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/ip2bus_retry
add wave -noupdate -group {TM Slave} -format Logic -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/ip2bus_toutsup
add wave -noupdate -group {TM Slave} -format Logic -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/access_intr
add wave -noupdate -group {TM Slave} -format Logic -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/scheduler_reset
add wave -noupdate -group {TM Slave} -format Logic -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/scheduler_reset_done
add wave -noupdate -group {TM Slave} -format Logic -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/semaphore_reset
add wave -noupdate -group {TM Slave} -format Logic -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/semaphore_reset_done
add wave -noupdate -group {TM Slave} -format Logic -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/spinlock_reset
add wave -noupdate -group {TM Slave} -format Logic -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/spinlock_reset_done
add wave -noupdate -group {TM Slave} -format Logic -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/user_ip_reset
add wave -noupdate -group {TM Slave} -format Logic -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/user_ip_reset_done
add wave -noupdate -group {TM Slave} -format Logic -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/soft_stop
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/tm2sch_cpu_thread_id
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/tm2sch_opcode
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/tm2sch_data
add wave -noupdate -group {TM Slave} -format Logic -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/tm2sch_request
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/tm2sch_dob
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/sch2tm_addrb
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/sch2tm_dib
add wave -noupdate -group {TM Slave} -format Logic -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/sch2tm_enb
add wave -noupdate -group {TM Slave} -format Logic -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/sch2tm_web
add wave -noupdate -group {TM Slave} -format Logic -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/sch2tm_busy
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/sch2tm_data
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/sch2tm_next_id
add wave -noupdate -group {TM Slave} -format Logic -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/sch2tm_next_id_valid
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/cycle_count
add wave -noupdate -group {TM Slave} -format Logic -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/timeout_expired
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/exception_address
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/exception_address_next
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/exception_cause
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/exception_cause_next
add wave -noupdate -group {TM Slave} -format Logic -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/access_error
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/soft_resets
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/soft_resets_next
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/resets_done
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/reset_status
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/reset_status_next
add wave -noupdate -group {TM Slave} -format Logic -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/core_stop
add wave -noupdate -group {TM Slave} -format Logic -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/core_stop_next
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/current_cpu_thread
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/current_cpu_thread_next
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/next_id
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/next_id_next
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/temp_thread_id
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/temp_thread_id_next
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/temp_thread_id2
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/temp_thread_id2_next
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/reset_id
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/current_state
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/next_state
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/return_state
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/return_state_next
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/bus_data_out
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/bus_data_out_next
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/current_status
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/current_status_next
add wave -noupdate -group {TM Slave} -format Logic -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/swtm_reset_done
add wave -noupdate -group {TM Slave} -format Logic -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/swtm_reset_done_next
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/new_id
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/new_id_next
add wave -noupdate -group {TM Slave} -format Logic -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/tm2sch_request_next
add wave -noupdate -group {TM Slave} -format Logic -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/tm2sch_request_reg
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/tm2sch_data_next
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/tm2sch_data_reg
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/tm2sch_opcode_next
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/tm2sch_opcode_reg
add wave -noupdate -group {TM Slave} -format Logic -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/ena
add wave -noupdate -group {TM Slave} -format Logic -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/wea
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/addra
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/dia
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/doa
add wave -noupdate -group {TM Slave} -format Literal -radix hexadecimal /bfm_system/thread_manager/thread_manager/user_logic_i/addr
add wave -noupdate -divider {Synch Manager}
add wave -noupdate -group {SYN Slave}
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/bus2ip_clk
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/bus2ip_reset
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/bus2ip_addr
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/bus2ip_data
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/bus2ip_be
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/bus2ip_rnw
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/bus2ip_rdce
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/bus2ip_wrce
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/bus2ip_rdreq
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/bus2ip_wrreq
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/ip2bus_data
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/ip2bus_retry
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/ip2bus_error
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/ip2bus_toutsup
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/ip2bus_rdack
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/ip2bus_wrack
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/bus2ip_ardata
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/bus2ip_arbe
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/bus2ip_arcs
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/ip2bus_ardata
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/system_reset
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/system_resetdone
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/send_ena
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/send_id
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/send_ack
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/siaddr
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/siena
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/siwea
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/sinext
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/sonext
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/clk
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/rst
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/rnw
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/datain
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/lock_finish
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/unlock_finish
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/trylock_finish
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/count_finish
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/kind_finish
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/owner_finish
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/result_finish
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/lock_data
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/unlock_data
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/trylock_data
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/count_data
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/kind_data
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/owner_data
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/result_data
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/lock_maddr
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/unlock_maddr
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/trylock_maddr
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/count_maddr
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/kind_maddr
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/owner_maddr
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/lock_mena
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/unlock_mena
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/trylock_mena
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/count_mena
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/kind_mena
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/owner_mena
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/lock_mwea
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/unlock_mwea
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/trylock_mwea
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/count_mwea
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/kind_mwea
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/owner_mwea
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/lock_mowner
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/unlock_mowner
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/trylock_mowner
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/count_mowner
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/kind_mowner
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/owner_mowner
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/lock_mnext
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/unlock_mnext
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/trylock_mnext
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/count_mnext
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/kind_mnext
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/owner_mnext
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/lock_mlast
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/unlock_mlast
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/trylock_mlast
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/count_mlast
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/kind_mlast
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/owner_mlast
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/lock_mcount
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/unlock_mcount
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/trylock_mcount
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/count_mcount
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/kind_mcount
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/owner_mcount
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/lock_mkind
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/unlock_mkind
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/trylock_mkind
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/count_mkind
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/kind_mkind
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/owner_mkind
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/lock_taddr
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/unlock_taddr
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/trylock_taddr
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/count_taddr
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/kind_taddr
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/owner_taddr
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/lock_tena
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/unlock_tena
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/trylock_tena
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/count_tena
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/kind_tena
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/owner_tena
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/lock_twea
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/unlock_twea
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/trylock_twea
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/count_twea
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/kind_twea
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/owner_twea
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/lock_tnext
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/unlock_tnext
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/trylock_tnext
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/count_tnext
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/kind_tnext
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/owner_tnext
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/unlock_sena
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/unlock_sid
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/miaddr
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/miena
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/miwea
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/miowner
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/minext
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/milast
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/micount
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/mikind
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/moowner
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/monext
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/molast
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/mocount
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/mokind
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/tiaddr
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/tiena
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/tiwea
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/tinext
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/tonext
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/lock_resetdone
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/unlock_resetdone
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/trylock_resetdone
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/owner_resetdone
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/kind_resetdone
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/count_resetdone
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/result_resetdone
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/thread_resetdone
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/send_resetdone
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/mutex_resetdone
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/cmd_number
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/thr_number
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/mtx_number
add wave -noupdate -group {SYN Slave} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/knd_number
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/result_start
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/count_start
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/kind_start
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/owner_start
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/trylock_start
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/unlock_start
add wave -noupdate -group {SYN Slave} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/slave_logic_i/lock_start
add wave -noupdate -group {SYN Master}
add wave -noupdate -group {SYN Master} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/bus2ip_clk
add wave -noupdate -group {SYN Master} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/bus2ip_reset
add wave -noupdate -group {SYN Master} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/bus2ip_addr
add wave -noupdate -group {SYN Master} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/bus2ip_data
add wave -noupdate -group {SYN Master} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/bus2ip_be
add wave -noupdate -group {SYN Master} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/bus2ip_rnw
add wave -noupdate -group {SYN Master} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/bus2ip_rdce
add wave -noupdate -group {SYN Master} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/bus2ip_wrce
add wave -noupdate -group {SYN Master} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/bus2ip_rdreq
add wave -noupdate -group {SYN Master} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/bus2ip_wrreq
add wave -noupdate -group {SYN Master} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/bus2ip_msterror
add wave -noupdate -group {SYN Master} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/bus2ip_mstlastack
add wave -noupdate -group {SYN Master} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/bus2ip_mstrdack
add wave -noupdate -group {SYN Master} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/bus2ip_mstwrack
add wave -noupdate -group {SYN Master} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/bus2ip_mstretry
add wave -noupdate -group {SYN Master} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/bus2ip_msttimeout
add wave -noupdate -group {SYN Master} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/ip2bus_addr
add wave -noupdate -group {SYN Master} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/ip2bus_mstbe
add wave -noupdate -group {SYN Master} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/ip2bus_mstburst
add wave -noupdate -group {SYN Master} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/ip2bus_mstbuslock
add wave -noupdate -group {SYN Master} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/ip2bus_mstrdreq
add wave -noupdate -group {SYN Master} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/ip2bus_mstwrreq
add wave -noupdate -group {SYN Master} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/ip2ip_addr
add wave -noupdate -group {SYN Master} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/system_reset
add wave -noupdate -group {SYN Master} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/system_resetdone
add wave -noupdate -group {SYN Master} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/send_ena
add wave -noupdate -group {SYN Master} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/send_id
add wave -noupdate -group {SYN Master} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/send_ack
add wave -noupdate -group {SYN Master} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/saddr
add wave -noupdate -group {SYN Master} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/sena
add wave -noupdate -group {SYN Master} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/swea
add wave -noupdate -group {SYN Master} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/sonext
add wave -noupdate -group {SYN Master} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/sinext
add wave -noupdate -group {SYN Master} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/send_cs
add wave -noupdate -group {SYN Master} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/send_ns
add wave -noupdate -group {SYN Master} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/queue_cs
add wave -noupdate -group {SYN Master} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/queue_ns
add wave -noupdate -group {SYN Master} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/send_rdy
add wave -noupdate -group {SYN Master} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/send_valid
add wave -noupdate -group {SYN Master} -format Logic -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/send_validn
add wave -noupdate -group {SYN Master} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/send_cur
add wave -noupdate -group {SYN Master} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/send_curn
add wave -noupdate -group {SYN Master} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/send_first
add wave -noupdate -group {SYN Master} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/send_firstn
add wave -noupdate -group {SYN Master} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/send_last
add wave -noupdate -group {SYN Master} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/send_lastn
add wave -noupdate -group {SYN Master} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/send_count
add wave -noupdate -group {SYN Master} -format Literal -radix hexadecimal /bfm_system/synch_manager/synch_manager/master_logic_i/send_countn
add wave -noupdate -divider {OPB -> PLB}
add wave -noupdate -group OPB2PLB
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/opb_clk
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/plb_clk
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/opb_rst
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/plb_rst
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/bgi_trans_abort
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/bus_error_det
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/opb_select
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/opb_abus
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/opb_rnw
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/opb_be
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/opb_dbus
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/opb_seqaddr
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/bgi_dbus
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/bgi_retry
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/bgi_toutsup
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/bgi_xferack
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/bgi_errack
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/bgi_request
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/bgi_abus
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/bgi_rnw
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/bgi_be
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/bgi_size
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/bgi_type
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/bgi_priority
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/bgi_rdburst
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/bgi_wrburst
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/bgi_buslock
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/bgi_abort
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/bgi_lockerr
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/bgi_msize
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/bgi_ordered
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/bgi_compress
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/bgi_guarded
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/bgi_wrdbus
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/plb_rdwdaddr
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/plb_rddbus
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/plb_addrack
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/plb_rddack
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/plb_wrdack
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/plb_rearbitrate
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/plb_busy
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/plb_err
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/plb_rdbterm
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/plb_wrbterm
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/plb_ssize
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/plb_pendreq
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/plb_pendpri
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/plb_reqpri
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/dcr_read
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/dcr_write
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/dcr_abus
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/dcr_dbus
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/bgi_dcr_dbus
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/bgi_ack
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/bgi_rst
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/reset
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/regs_addr
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/opb_regs_addr
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/dcr_regs_addr
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/regs_rd_en
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/opb_regs_rd_en
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/dcr_regs_rd_en
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/regs_wr_en
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/opb_regs_wr_en
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/dcr_regs_wr_en
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/regs_rd_data
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/opb_regs_rd_data
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/dcr_regs_rd_data
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/regs_wr_data
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/opb_regs_wr_data
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/dcr_regs_wr_data
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/regs_lockbit
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/regs_err_be
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/regs_err_addr
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/regs_err_rnw
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/check_cl_addr
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/opb_start
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/start_sync
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/start_plb
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/check_cl
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/opb_req_type
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/opb_brstbl_rng
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/plb_data_phs
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/data_phs_sync
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/plb_in_data_phs
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/plb_aborted
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/aborted_sync
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/plb_has_aborted
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/plb_in_idle
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/in_idle_sync
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/plb_is_idle
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/plb_done
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/done_sync
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/plb_is_done
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/plb_error
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/error_sync
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/plb_has_error
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/opb_rng_addr
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/opb_rng_be
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/opb_rng_rnw
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/buf_wd_sel
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/wr_wd_count
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/wrbuf_wr_adr
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/wrbuf_wr_data
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/wrbuf_wr_be
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/wrbuf_wr_en
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/wrbuf_rd_adr
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/wrbuf_burst
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/wrbuf_odd_wd
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/wrbuf_rd_data
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/plb_rdbuf_addr
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/plb_hi_addr
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/opb_rdbuf_addr
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/opb_rdbuf_data
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/plb_rdbuf_data
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/rdbuf_wr_en
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/opbretry
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/opbtoutsup
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/opbxferack
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/opberrack
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/request
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/abus
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/rnw
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/be
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/size
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/wrburst
add wave -noupdate -group OPB2PLB -format Logic -radix hexadecimal /bfm_system/opb2plb/opb2plb/abort
add wave -noupdate -group OPB2PLB -format Literal -radix hexadecimal /bfm_system/opb2plb/opb2plb/wrdbus
add wave -noupdate -divider {PLB -> OPB}
add wave -noupdate -group PLB2OPB
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_rst
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_clk
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/opb_rst
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/opb_clk
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/bus_error_det
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgi_trans_abort
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_abort
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_abus
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_be
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_buslock
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_compress
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_guarded
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_lockerr
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_masterid
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_msize
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_ordered
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_pavalid
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_rnw
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_size
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_type
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_addrack
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_mbusy
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_merr
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_rearbitrate
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_ssize
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_wait
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_rdprim
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_savalid
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_wrprim
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_wrburst
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_wrdbus
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_wrbterm
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_wrcomp
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_wrdack
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_rdburst
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_rdbterm
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_rdcomp
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_rddack
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_rddbus
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_rdwdaddr
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/opb_dbus
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/opb_errack
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/opb_mngrant
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/opb_retry
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/opb_timeout
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/opb_xferack
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_abus
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_be
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_buslock
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_dbus
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_request
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_rnw
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_select
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_seqaddr
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/dcr_abus
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/dcr_dbus
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/dcr_read
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/dcr_write
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_dcrack
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_dcrdbus
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb2opb_rearb
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/err_ack_det
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/err_addr
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/err_byte_enable
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/err_rd_wr_n
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/lock_err
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/master_id_decode
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/intr_en
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/opb_hold_buslock
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/opb_rcv_data
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/opb_rcv_data_strobe
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/opb_xfer_abort_ack
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/opb_xfer_abort_flag
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/opb_xfer_rd_addr
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/dout_xfer_rnw
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/opb_xfer_rd_data
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/opb_xfer_rd_data_rst1_int
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/opb_xfer_rd_data_rst1
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/opb_xfer_rd_data_rst2
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/opb_xfer_rd_data_rst3
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/opb_xfer_rd_en
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/opb_xfer_start_ack
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/opb_xfer_start_flag
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_hold_buslock
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_rcv_data
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_rcv_data_strobe
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_xfer_abort_ack
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_xfer_abort_flag
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_xfer_data
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_xfer_start_ack
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_xfer_start_flag
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_xfer_strobe
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/rst
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/sw_rst
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/timeout_det
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_rnw_int
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_select_int
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_select_1dly
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_select_negedge
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/wait_on_rd
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/wait_on_rd_2dly
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/read_inprog
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/read_inprog_1dly
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/read_inprog_negedge
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/read_inprog_negedge_regd
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/read_inprog_negedge_regd_opbside
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/read_inprog_negedge_regd_synch1
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/read_inprog_negedge_regd_opbside_1dly
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/opbside_reset_read_inprog_negedge_regd
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_savalid_int
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_pavalid_int
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_pavalid_1dly
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_pavalid_neg_edge
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_rdburst_int
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_rddbus_int
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_rddbus_int_1dly
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_rddbus_int_2dly
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_rdwdaddr_int
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_rdwdaddr_1dly
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_rdwdaddr_2dly
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_rdbterm_int
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_rdbterm_int_1dly
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_rdbterm_int_2dly
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_rdcomp_int
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_rdcomp_int_1dly
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_rdcomp_int_2dly
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_rddack_int
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_rddack_int_1dly
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_rddack_int_2dly
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_addrack_int
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_addrack_dlydonrd
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_rnw_and_pavalid
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_rnw_and_pavalid_regd
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_rearbitrate_int
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_wait_int
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_size_int
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_mbusy_int
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_mbusy_int_1dly
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_mbusy_int_2dly
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_merr_int
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_merr_int_1dly
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_merr_int_2dly
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/opb_retry_onrd
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/opb_retry_onrd_ce
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/block_opb_retry_onrd
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/block_opb_retry_onrd_ce
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/opb_retry_onrd_regd
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/opb_retry_onrd_regd_synch1
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/hold_busy_til_rearb_onopbretry
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/opb_retry_onrd_plbside
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plbside_reset_opb_retry_onrd
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/opb_retry_onrd_plbside_1dly
add wave -noupdate -group PLB2OPB -format Literal -radix hexadecimal /bfm_system/plb2opb/plb2opb/bgo_ssize_int
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/opb_timeout_onrd
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/opb_timeout_onrd_regd
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/opb_timeout_onrd_regd_synch1
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/opb_timeout_onrd_plbside
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/block_on_opb_tout_onrd
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plbside_reset_opb_timeout_onrd
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/opb_timeout_onrd_plbside_1dly
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/block_on_term_rd_after_tout
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/block_on_term_rd_after_tout_en
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/block_on_term_rd_after_tout_ce
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_abort_int
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_abort_onrd
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_abort_onrd_regd
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_abort_regd_clear
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_abort_onrd_regd_synch1
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_abort_onrd_opbside
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/plb_abort_onrd_opbside_1dly
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/block_output_on_plbabort
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/block_output_on_plbabort_opbside
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/block_output_on_plbabort_regd
add wave -noupdate -group PLB2OPB -format Logic -radix hexadecimal /bfm_system/plb2opb/plb2opb/opb_rst_on_plb_abort
add wave -noupdate -divider {PLB Bus}
add wave -noupdate -group PLB
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_dcrack
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_dcrdbus
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/m_abus
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/m_be
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/m_rnw
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/m_abort
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/m_buslock
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/m_compress
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/m_guarded
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/m_lockerr
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/m_msize
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/m_ordered
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/m_priority
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/m_rdburst
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/m_request
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/m_size
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/m_type
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/m_wrburst
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/m_wrdbus
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_abus
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_be
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_maddrack
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_mbusy
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_merr
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_mrdbterm
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_mrddack
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_mrddbus
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_mrdwdaddr
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_mrearbitrate
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_mwrbterm
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_mwrdack
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_mssize
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_pavalid
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_rnw
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_savalid
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_abort
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_buslock
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_compress
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_guarded
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_lockerr
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_masterid
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_msize
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_ordered
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_pendpri
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_pendreq
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_rdburst
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_rdprim
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_reqpri
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_size
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_type
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_wrburst
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_wrdbus
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_wrprim
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/sl_addrack
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/sl_merr
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/sl_mbusy
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/sl_rdbterm
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/sl_rdcomp
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/sl_rddack
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/sl_rddbus
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/sl_rdwdaddr
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/sl_rearbitrate
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/sl_ssize
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/sl_wait
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/sl_wrbterm
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/sl_wrcomp
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/sl_wrdack
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_saddrack
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_smerr
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_smbusy
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_srdbterm
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_srdcomp
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_srddack
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_srddbus
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_srdwdaddr
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_srearbitrate
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_sssize
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_swait
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_swrbterm
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_swrcomp
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_swrdack
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb2opb_rearb
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/arbaddrvldreg
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/sys_rst
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/bus_error_det
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_rst
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_clk
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/arbaddrselreg
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/arbburstreq
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/arbprirdmasterregreg
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/arbpriwrmasterreg
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_abus_i
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_be_i
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_size_i
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_type_i
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_rst_i
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_saddrack_i
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_smerr_i
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_smbusy_i
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_srdbterm_i
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_srdcomp_i
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_srddack_i
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_srddbus_i
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_srdwdaddr_i
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_srearbitrate_i
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_sssize_i
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_swait_i
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_swrbterm_i
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_swrcomp_i
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_swrdack_i
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/wdtrddack
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/wdtwrdack
add wave -noupdate -group PLB -format Literal -radix hexadecimal /bfm_system/plb_bus/plb_bus/plb_rdwdaddrwdt
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/srl_time_out
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/ext_rst_i
add wave -noupdate -group PLB -format Logic -radix hexadecimal /bfm_system/plb_bus/plb_bus/por_ff_out
add wave -noupdate -divider {OPB Bus}
add wave -noupdate -group OPB
add wave -noupdate -group OPB -format Logic -radix hexadecimal /bfm_system/opb/opb/sys_rst
add wave -noupdate -group OPB -format Logic -radix hexadecimal /bfm_system/opb/opb/debug_sys_rst
add wave -noupdate -group OPB -format Logic -radix hexadecimal /bfm_system/opb/opb/wdt_rst
add wave -noupdate -group OPB -format Logic -radix hexadecimal /bfm_system/opb/opb/opb_clk
add wave -noupdate -group OPB -format Logic -radix hexadecimal /bfm_system/opb/opb/opb_rst
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/m_abus
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/m_be
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/m_bexfer
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/m_buslock
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/m_dbus
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/m_dbusen
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/m_dbusen32_63
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/m_dwxfer
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/m_fwxfer
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/m_hwxfer
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/m_request
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/m_rnw
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/m_select
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/m_seqaddr
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/sl_beack
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/sl_dbus
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/sl_dbusen
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/sl_dbusen32_63
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/sl_errack
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/sl_dwack
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/sl_fwack
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/sl_hwack
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/sl_retry
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/sl_toutsup
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/sl_xferack
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/opb_mrequest
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/opb_abus
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/opb_be
add wave -noupdate -group OPB -format Logic -radix hexadecimal /bfm_system/opb/opb/opb_bexfer
add wave -noupdate -group OPB -format Logic -radix hexadecimal /bfm_system/opb/opb/opb_beack
add wave -noupdate -group OPB -format Logic -radix hexadecimal /bfm_system/opb/opb/opb_buslock
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/opb_rddbus
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/opb_wrdbus
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/opb_dbus
add wave -noupdate -group OPB -format Logic -radix hexadecimal /bfm_system/opb/opb/opb_errack
add wave -noupdate -group OPB -format Logic -radix hexadecimal /bfm_system/opb/opb/opb_dwack
add wave -noupdate -group OPB -format Logic -radix hexadecimal /bfm_system/opb/opb/opb_dwxfer
add wave -noupdate -group OPB -format Logic -radix hexadecimal /bfm_system/opb/opb/opb_fwack
add wave -noupdate -group OPB -format Logic -radix hexadecimal /bfm_system/opb/opb/opb_fwxfer
add wave -noupdate -group OPB -format Logic -radix hexadecimal /bfm_system/opb/opb/opb_hwack
add wave -noupdate -group OPB -format Logic -radix hexadecimal /bfm_system/opb/opb/opb_hwxfer
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/opb_mgrant
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/opb_pendreq
add wave -noupdate -group OPB -format Logic -radix hexadecimal /bfm_system/opb/opb/opb_retry
add wave -noupdate -group OPB -format Logic -radix hexadecimal /bfm_system/opb/opb/opb_rnw
add wave -noupdate -group OPB -format Logic -radix hexadecimal /bfm_system/opb/opb/opb_select
add wave -noupdate -group OPB -format Logic -radix hexadecimal /bfm_system/opb/opb/opb_seqaddr
add wave -noupdate -group OPB -format Logic -radix hexadecimal /bfm_system/opb/opb/opb_timeout
add wave -noupdate -group OPB -format Logic -radix hexadecimal /bfm_system/opb/opb/opb_toutsup
add wave -noupdate -group OPB -format Logic -radix hexadecimal /bfm_system/opb/opb/opb_xferack
add wave -noupdate -group OPB -format Logic -radix hexadecimal /bfm_system/opb/opb/arb_timeout
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/arb_mgrant
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/arb_dbus
add wave -noupdate -group OPB -format Logic -radix hexadecimal /bfm_system/opb/opb/arb_errack
add wave -noupdate -group OPB -format Logic -radix hexadecimal /bfm_system/opb/opb/arb_retry
add wave -noupdate -group OPB -format Logic -radix hexadecimal /bfm_system/opb/opb/arb_toutsup
add wave -noupdate -group OPB -format Logic -radix hexadecimal /bfm_system/opb/opb/arb_xferack
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/opb_dbus_inputs
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/iopb_wrdbus
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/iopb_rddbus
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/iopb_bexfer
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/iopb_beack
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/iopb_buslock
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/iopb_errack
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/iopb_dwack
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/iopb_dwxfer
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/iopb_fwack
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/iopb_fwxfer
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/iopb_hwack
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/iopb_hwxfer
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/iopb_retry
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/iopb_rnw
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/iopb_select
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/iopb_seqaddr
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/iopb_toutsup
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/iopb_xferack
add wave -noupdate -group OPB -format Logic -radix hexadecimal /bfm_system/opb/opb/iopb_rst
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/iopb_abus
add wave -noupdate -group OPB -format Literal -radix hexadecimal /bfm_system/opb/opb/iopb_be
add wave -noupdate -group OPB -format Logic -radix hexadecimal /bfm_system/opb/opb/srl_time_out
add wave -noupdate -group OPB -format Logic -radix hexadecimal /bfm_system/opb/opb/sys_rst_i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {123693 ns} 0}
configure wave -namecolwidth 251
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
configure wave -timelineunits ns
update
WaveRestoreZoom {122580 ns} {123860 ns}
bookmark add wave {Burst Read 1st Ack} -none- 5
bookmark add wave {Burst Read Start} -none- 5
