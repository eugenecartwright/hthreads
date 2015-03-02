cd /home/abazar63/hthread/src/platforms/xilinx/pr_6smp/design
if { [ catch { xload xmp system.xmp } result ] } {
  exit 10
}
if { [xset hier top] != 0 } {
  exit -1
}
set bMisMatch false
set xpsArch [xget arch]
if { ! [ string equal -nocase $xpsArch "virtex6" ] } {
   set bMisMatch true
}
set xpsDev [xget dev]
if { ! [ string equal -nocase $xpsDev "xc6vlx240t" ] } {
   set bMisMatch true
}
set xpsPkg [xget package]
if { ! [ string equal -nocase $xpsPkg "ff1156" ] } {
   set bMisMatch true
}
set xpsSpd [xget speedgrade]
if { ! [ string equal -nocase $xpsSpd "-1" ] } {
   set bMisMatch true
}
if { $bMisMatch == true } {
   puts "Settings Mismatch:"
   puts "Current Project:"
   puts "	Family: virtex6"
   puts "	Device: xc6vlx240t"
   puts "	Package: ff1156"
   puts "	Speed: -1"
   puts "XPS File: "
   puts "	Family: $xpsArch"
   puts "	Device: $xpsDev"
   puts "	Package: $xpsPkg"
   puts "	Speed: $xpsSpd"
   exit 11
}
xset hdl verilog
xset intstyle ise
save proj
exit
