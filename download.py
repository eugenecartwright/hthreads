#!/usr/bin/python
# *****************************************************************************
# Filename: download.py
# Author: Eugene Cartwright
# Date: 4/26/2013
# Description: Responsible for wrapping all of the previous download shell
#               scripts into one. Therefore, this can be used to download
#               to the PowerPC, Microblaze, ARM, etc. Can be used to 
#               download to a PR system, since as of right now, the system
#               bit file does not embedd the slave kernel code.
# *****************************************************************************
import sys, glob, re, subprocess, os
from string import Template
from compiler.common import parser, execute

# Using 'subprocess' package instead of 'commands'. Commands package
# has been removed in Python v3

tempFile="extra/download.opt"

def main():
    # Flag to indicate whether I should 
    # download the bit file or not.
    download_platform = 1

    # Check command line arguments
    if (len(sys.argv) < 2 or len(sys.argv) > 3):
        print "Correct Usage: ./download.py <path_to_executable> " \
            "<0 or 1 (Optional flag - download bit file?>"
        sys.exit(1)

    # Grab executable path from command line
    executable = sys.argv[1]
    if (len(sys.argv) == 3):
        if (sys.argv[2].isdigit() == False):
            print "Last argument Needs to be a 0 (don't download bit file)" \
                " or a 1 (download bit file - default)"
            sys.exit(1)
    
        download_platform = sys.argv[2]

    # ------------------------------------------------------------------- #
    #                   Determine if this is a PR system                  #
    # ------------------------------------------------------------------- #
    # 1. Get name of platform we are targetting
    settingsFile = open("config/settings", "r")
    lines = settingsFile.readlines() 
    settingsFile.close()
    
    for line in lines:
        # Look at beginning of string (skip comments)
        match = re.search('^\s*PLATFORM_BOARD\s*', line)
        if (match > -1):
            # Remove ALL whitespace, newline, 
            # carriage returns on both ends.
            line = line.strip(' \t\r\n;')
            # Remove first part of line
            platform_name = re.sub('^PLATFORM_BOARD\s*=\s*','', line)
            print "Platform = " + platform_name + "\n"
            break 
   
    # Store current directory
    root_directory = os.getcwd()

    # Change directory to platform in order to run impact
    os.chdir("src/platforms/xilinx/" + platform_name +"/design/")

    # Warn the user about making sure they copied their bit file
    # and ran make -f system.make init_bram
    print "Note: If this is a PR system, make sure to follow README " \
           "file located in the platform's design folder"
    
    # Run impact -batch etc/download.cmd, if user specified
    if (download_platform == 1):
        subprocess.check_call(["impact", "-batch", "etc/download.cmd"])
        # Sleep for 5 seconds
        subprocess.check_call(['sleep', '3'])

    # Return to root
    os.chdir(root_directory)

    # ------------------------------------------------------------------- #
    #                  Download executable to host Processor              #
    # ------------------------------------------------------------------- #
    
    # Determine what is the target ISA
    settingsFile = open("config/settings", "r")
    lines = settingsFile.readlines() 
    settingsFile.close()
    
    for line in lines:
        # Look at beginning of string (skip comments)
        match = re.search('^\s*PLATFORM_ARCH\s*', line)
        if (match > -1):
            # Remove ALL whitespace, newline, 
            # carriage returns on both ends.
            line = line.strip(' \t\r\n;')
            # Remove first part of line
            arch = re.sub('^PLATFORM_ARCH\s*=\s*','', line)
            print "Targetted Architecture = " + arch + "\n"
            break 
   
    # Create a temporary download script to pass to XMD
    print "Creating XMD script..."
    subprocess.check_call(["touch", tempFile])

    if (arch == "mblaze"):
        subprocess.check_call(['echo "connect mb mdm -debugdevice cpunr 1"'  
                ' > ' + tempFile], shell=True)
    elif(arch == "ppc440"):
        subprocess.check_call(['echo "ppcc" > ' + tempFile], shell=True)
    else:
        print "Unsupported architecture: " + arch
        sys.exit(1)

    subprocess.check_call(['echo "debugconfig -reset_on_run disable"' 
                ' >> '+ tempFile], shell=True)
    subprocess.check_call(['echo stop >> ' + tempFile], shell=True)
    subprocess.check_call(['echo rst >> ' + tempFile], shell=True)
    subprocess.check_call(['echo dow ' + executable + '>>' + tempFile], shell=True)
    subprocess.check_call(['echo run >> ' + tempFile], shell=True)
    subprocess.check_call(['echo exit >> ' +tempFile], shell=True)

    print "Downloading executable/Running XMD script..."
    subprocess.check_call(['xmd', '-opt', tempFile])
    print "Complete"

    # Remove .opt file
    subprocess.check_call('rm -f ' + tempFile, shell=True)
  
if __name__ == "__main__":
    main()	


