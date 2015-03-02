#!/bin/sh

# Name of MicroBlaze executable
execName=$1
# Name of header file to produce
outName=$2

# Temporary name for intermediate .o file
tempName="junk.o"

# Turn ELF into a binary that preserves layout info
mb-objcopy -I elf32-microblaze -O binary $execName $tempName

# Transform binary into a C file that can be re-compiled
xxd -i -c 4 $tempName $outName

# Delete intermediate file
rm -f $tempName


