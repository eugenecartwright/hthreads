open_hw
connect_hw_server
open_hw_target [lindex [get_hw_targets -of_objects [get_hw_servers localhost]] 0]
current_hw_device [lindex [get_hw_devices] 0]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices] 0]
set_property PROBES.FILE {} [lindex [get_hw_devices] 0]
set_property PROGRAM.FILE ../design/design.sdk/system_wrapper_hw_platform_0/download.bit [lindex [get_hw_devices] 0]
program_hw_devices [lindex [get_hw_devices] 0]
exit
