#!/usr/bin/python
from types import StringTypes
import re,sys,subprocess, os

# Return error codes
# 0 is used for SUCCESS due to bash
SUCCESS = 0
FAILURE = 1

# Dictionary of architectures where the
# the key = Xilinx naming convention and
# the value = Hthreads naming convention.
supported_arch = {
   "microblaze":"mblaze",
   "ps7_cortexa9":"arm",
}

#------------------------------------------#
# A generic function that simply executes  #
# a list of commands one at a time and     #
# checks for CalledProcessError exception. #
# STDOUT is not displayed to the screen    #
# but STDERR is.                           # 
# Author: Eugene Cartwright                #
#------------------------------------------#
def execute_cmd(cmd_list, debugging=False, exit_if_error=True):
   """Execute the given list of commands"""

   # Create an empty list
   commands = []

   # Check if the cmd_list was passed as a single string
   # i.e., if the user just wanted to execute one cmd.
   if isinstance(cmd_list,StringTypes):
      commands.append(cmd_list)
   else:
      commands = cmd_list
   
   for index, cmd in enumerate(commands):
      if debugging:
         print "Executing Command: " + cmd
      try:
         stdout = subprocess.check_output(cmd,stderr=subprocess.STDOUT, shell=True)
         if debugging:
            print stdout
         # -------------------------------------#
         # Determine if there were any warnings #
         # -------------------------------------#
         warnings_found = False
         if(len(stdout) > 0):
            lines = stdout.split('\n')
            for index, stdout_line in enumerate(lines):
               match = re.search("warning", stdout_line)
               if (match > -1):
                  # Toggle the Warnings header to display
                  # it only once per command.
                  if (warnings_found == False):
                     warnings_found = True
                     print "\n+-+-+-+-+-+-+-+-+"
                     print "|W|A|R|N|I|N|G|S|"
                     print "+-+-+-+-+-+-+-+-+"
                  print stdout_line
      except subprocess.CalledProcessError, e:
         print 'Error('+str(e.returncode)+'): Command --> '+e.cmd
         print e.output
         if exit_if_error:
            sys.exit(e.returncode)
         else:
            return e.returncode

   return SUCCESS


#-------------------------------------------------#
# This function is simply a wrapper for checking  #
# if the path exists and prints an error if it    #
# it does not exist.                              #
# Author: Jason Agron                             #
# Modified: Eugene Cartwright                     #
#         + Updated Error messages to be generic. #
#         + Changed to use command os.path.isfile # 
#           Using os.path.exists returns True for #
#           a correct file and a 'folder'.        #
#-------------------------------------------------#
def checkInput(source, debugging=False):
   """Check whether the argument is a file."""

   if debugging:
      print 'Checking if ' +source+ ' exists'

   if (os.path.isfile(source)):
      if debugging:
         print 'Done.'
      return SUCCESS
   else:
      print 'Error: \''+source+'\' doesn\'t exist'
      return FAILURE

#-------------------------------------------------#
# This function is a quick check for making sure  #
# function calls occur successfully. This is only #
# used to prevent many redundant if-else state-   #
# ments when wanting to check a functions return  #
# value.                                          #
# Author: Eugene Cartwright                       #
#-------------------------------------------------#
def assertCheck(returnCode, debugging=False):
   """Assert the argument if not successful"""
   
   if debugging:
      print 'Checking return code: ' + str(returnCode)
   
   if (returnCode != SUCCESS):
      print 'Error: function call failed! ...exiting'
      sys.exit(returnCode)


#-------------------------------------------------#
# This function parses the config/settings to get #
# a certain field (e.g. platform selected).       #
#-------------------------------------------------#
def read_config_settings(search_string, file_path, exit_if_error=True):

   field_value = None
   with open(file_path, "r") as infile:
      for line in infile:
         # Look at beginning of string (skip comments)
         match = re.search('^\s*' + search_string +'\s*', line)
         if (match > -1):
            # Remove beginning part of this line
            # (e.g.  'PLATFORM_BOARD    =  ')
            line = re.sub('^\s*.*=\s*', '',line)
            # Remove last part of this line
            field_value = re.sub('\s*;\s*$', '', line)
            break
   infile.close()

   if (field_value == None):
      print search_string + ": Field not found in config/settings file!"
      if exit_if_error:
         sys.exit(1)

   return field_value

#-------------------------------------------------#
# This function parses the config/settings to     #
# write a certain field (e.g. platform selected). #
#-------------------------------------------------#
def write_config_settings(search_string, input_text, file_path, exit_if_error=True):

   changed = False
   # Not as memory efficient, but replacing
   # lines as I am reading is becoming too complex
   with open(file_path, 'r') as infile:
      lines = infile.readlines()

   with open(file_path, 'w') as infile:
      for line in lines:
         # Look at beginning of string (and skip comments)
         match = re.search('^\s*' + search_string +'\s*', line)
         if (match > -1):
            changed = True
            infile.write(search_string + "\t=\t" +input_text+ " ;\n")
         else:
            infile.write(line)
  
   if (changed == False):
      print search_string + ": Field not found in config/settings file!"
      if exit_if_error:
         sys.exit(1)

#-------------------------------------------------#
# Translates Xilinx's naming convention for ISA   #
# Hthreads naming convention (i.e. microblaze to  #
# mblaze.)                                        #
#-------------------------------------------------#
def Xil_to_Hthreads_ISA(xilinx_isa, exit_if_error=True):
   hthreads_isa = ""
   try:
      hthreads_isa = supported_arch[xilinx_isa]
   except KeyError, e:
      print "\t\tCurrently, " + xilinx_isa + " is not supported.\n"
      print "\t\tList of supported architectures (Xiling:Hthreads): "
      for index, key in enumerate(supported_arch):
         print key + ":" + supported_arch[key]
      if exit_if_error:
         sys.exit(1)

   return hthreads_isa

#-------------------------------------------------#
# Function reads into a copied Jamrules template  #
# and appends compiler flags and substitutes      #
# processor name wherever it encounters the magic #
# keyword: DEADBEEF. The end result of the        #
# substitution is processor specific paths within #
# the platform's design folder.                   #
#-------------------------------------------------#
def create_Jamfile(template, compiler_flags, processor_name):

   # Write the appropriate flags to this copied Jamrules file
   execute_cmd("echo -e 'CCFLAGS += " + compiler_flags + " ;' >> " + template)

   # Update this template file to include processor specific paths 
   # to the SDK's generated libraries and include folders.
   with open(template, 'r') as infile:
      lines = infile.readlines()

   with open (template, "w") as infile:
      for line in lines:
         # substitute processor's name if magic key 
         # is found on current line
         line = re.sub("DEADBEEF",processor_name, line) 
         # write line back to the file
         infile.write(line)

   
