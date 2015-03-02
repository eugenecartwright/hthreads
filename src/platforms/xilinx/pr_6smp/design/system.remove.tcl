cd /home/abazar63/hthread/src/platforms/xilinx/pr_6smp/design
if { [ catch { xload xmp system.xmp } result ] } {
  exit 10
}
xset intstyle default
save proj
exit 0
