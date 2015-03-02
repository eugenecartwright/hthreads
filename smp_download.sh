#!/bin/bash
# *************************************
# Script to aid in downloading
# and executing SMP code
# *************************************
# Usage:
#" ./smp_download.sh <executableName>"
# *************************************

# Check arguments
if [ $# -ne 1 ]
then
    echo "Correct Usage:"
    echo " ./smp_download.sh <executableName>"
    exit
fi

# Grab command line arg
execName=$1

# Initialize processor number
pnum=2

# Create temporary file
tempName="extra/temp_smp$pnum.opt"
touch $tempName

# Write file contents
echo "connect mb mdm -debugdevice cpunr $pnum" > $tempName
echo "debugconfig -reset_on_run disable" >> $tempName
echo "stop" >> $tempName
echo "rst -processor" >> $tempName
echo "dow $execName" >> $tempName
echo "run" >> $tempName
echo "exit" >> $tempName

# Invoke XMD
echo "Downloading to $pnum..."
xmd -opt $tempName
echo "Complete"

# Adjust processor number
((pnum--))

# Create temporary file
tempName="extra/temp_smp$pnum.opt"
touch $tempName

# Write file contents
echo "connect mb mdm -debugdevice cpunr $pnum" > $tempName
echo "debugconfig -reset_on_run disable" >> $tempName
echo "stop" >> $tempName
echo "rst -processor" >> $tempName
echo "dow $execName" >> $tempName
echo "run" >> $tempName
#echo "exit" >> $tempName

# Invoke XMD
echo "Downloading to $pnum..."
xmd -opt $tempName
echo "Complete"
