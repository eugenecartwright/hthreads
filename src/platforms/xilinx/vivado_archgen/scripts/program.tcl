open_hw
connect_hw_server -host localhost -port 60001 -url localhost:3121
current_hw_target [get_hw_targets ]
set_property PARAM.FREQUENCY 15000000 [get_hw_targets ]
open_hw_target
current_hw_device [lindex [get_hw_devices] 0]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices] 0]
set_property PROGRAM.FILE ../design/design.sdk/system_wrapper_hw_platform_0/download.bit [lindex [get_hw_devices] 0]
program_hw_devices [lindex [get_hw_devices] 0]
