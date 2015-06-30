#!/usr/bin/python
import re,sys, os,fnmatch 
from execute import *
import xml.etree.ElementTree as ET

# Return error codes
SUCCESS = 0
FAILURE = 1

# List of available (HLS) accelerators. TODO: Update 
# whenever adding new accelerators
accelerators = ["crc", "vectoradd", "bubblesort", "mm", "vectormul"]

#------------------------------------------#
# A function responsible for extracting    #
# hardware definition file given the       #
# platform path.                           #
# Author: Eugene Cartwright                #
#------------------------------------------#
def get_hardware_file(platform_path, debugging=False):

   # create a temporary folder to unzip the hardware platform file
   tmp_folder = platform_path + "/design/.tmp"
   execute_cmd("rm -rf " + tmp_folder)
   execute_cmd("mkdir " + tmp_folder)

   matches = []
   for root, dirnames, filenames in os.walk(platform_path+"/design"):
      for filename in fnmatch.filter(filenames,'*.sysdef'):
         match = os.path.join(root,filename)
         if debugging:
            print '(get_hardware_file()): Found ' + os.path.basename(match)
         matches.append(match)

   if (len(matches) != 1):
      print "Found more than one sysdef file in platform direction"
      print matches
      return FAILURE, matches
  
   platform_file_path = matches[0]
   
   # Copy and unzip system definition file into temporary folder
   platform_file = os.path.basename(platform_file_path)
   execute_cmd("cp " + platform_file_path + " " + tmp_folder)
   execute_cmd("unzip " + tmp_folder + "/" + platform_file + " -d " + tmp_folder)

   if debugging:
      print "\tTesting whether sysdef.xml and system.hwh files exist..."
   
   # if deubbing, display board information
   if debugging:
      # Check for the sysdef.xml file before reading board info from it.
      if os.path.isfile(tmp_folder + "/sysdef.xml") == False:
         print "ERROR (get_hardware_file()): No sysdef.xml file found!"
         return FAILURE, matches
      
      # Parse Board/Project information file. NOTE: I assume only one
      # project version as this file supports multiple versions, and
      # hence, can support multiple *.hwh files. 
      tree = ET.parse(tmp_folder + "/sysdef.xml")
      root = tree.getroot()

      system_info = root.find('SYSTEMINFO')
      if (system_info != None):
         print '\t--------------------------------------------'
         print '\t|+ Board information for selected platform |'
         print '\t--------------------------------------------'
         print "\t\tArchitecture: ", system_info.get('ARCH')
         print "\t\tPackage: ", system_info.get('PACKAGE')
         print "\t\tDevice: ", system_info.get('DEVICE')
         print "\t\tSpeed Grade: ", system_info.get('SPEED')
      else:
         print "No SYSTEMINFO tag found when parsing XML document"
         

   # Check for the system.hwh file. NOTE: I assume it is called
   # system.hwh but can verify based on the *.xml file above.
   if os.path.isfile(tmp_folder + "/system.hwh") == False:
      print "No system hardware definition file found"
      return FAILURE, matches
   else:
      platform_file_path = tmp_folder + "/system.hwh"
   
   return SUCCESS, platform_file_path


#------------------------------------------#
# A function that parses the hardware      #
# definitions file and creates a list of   #
# dictionary objects which describe each   #
# processor in the system.                 #
# Author: Eugene Cartwright                #
#------------------------------------------#
def get_processors(hw_description_path):
   '''
      The data structure returned from this function
      looks like this:
      >>> processors = []
      >>> processors[0] = {"C_USE_FPU" : "0", "C_USE_HW_MUL": "1"}
      >>> processors[1] = {"C_USE_FPU" : "0", "C_USE_HW_MUL": "2"}
   '''

   # Parse XML document
   tree = ET.parse(hw_description_path)
   root = tree.getroot()
   
   # Create empty list of processors
   # where each index will store a
   # dictionary to hold processor params.
   processors = []

   for core in root.iter('MODULE'):
      # Get this module type
      proc_type = core.get('MODCLASS')
     
      # if module is not a processor, skip! 
      if (proc_type != 'PROCESSOR'):
         # Pass the rest of this loop iter
         continue
      
      # Create empty dictionary to store all
      # meta data for this module (processor).
      proc_metadata = {}

      hw_version = core.get('HWVERSION')
      # MODTYPE examples: microblaze, ppc405_virtex4,
      # ps7_cortexa9, ...
      isa = core.get('MODTYPE')
      proc_metadata['XILINX_ISA'] = isa
      # convert Xilinx ISA naming convention to Hthreads
      # naming convention for compilation purposes
      isa = Xil_to_Hthreads_ISA(isa)
      instance_name = core.get('INSTANCE')

      # Append info to dictionary
      proc_metadata['HTHREADS_ISA'] = isa
      proc_metadata['HWVERSION'] = hw_version
      proc_metadata['NAME'] = instance_name

      for parameter in core.iter('PARAMETER'):
         name = parameter.get('NAME')
         value = parameter.get('VALUE')
         # Append to dictionary
         proc_metadata[name] = value
      
      # Append processor meta data to processor list 
      processors.append(proc_metadata)

   # Done, return processor list
   return processors


#------------------------------------------#
# A function that parses the hardware      #
# definitions file and creates a list of   #
# dictionary objects which describe each   #
# accelerator in the system.               #
# Author: Eugene Cartwright                #
#------------------------------------------#
def get_accelerators(hw_description_path, processors):

   # Initialize all processors accelerator field with 'NO_ACC' 
   for index, processor in enumerate(processors):
      processors[index]['ACCELERATOR'] = 'NO_ACC'

   # Parse XML document
   tree = ET.parse(hw_description_path)
   root = tree.getroot()
   
   for core in root.iter('MODULE'):
      # Get this module type
      module_type = core.get('MODCLASS')
     
      # if module is not a Peripheral, skip! 
      if (module_type != 'PERIPHERAL'):
         # Pass the rest of this loop iter
         continue
     
      # Determine if the module in question is a supported Accelerator
      proposed_accelerator = core.get('MODTYPE')
      is_acc_connected = False
      for index, supported_accelerator in enumerate(accelerators):
         if (proposed_accelerator != supported_accelerator):
            continue
         else:
            is_acc_connected = True
            break          
         
      # If we didn't find a supported accelerator for this
      # Module (peripheral), continue to next module
      if (is_acc_connected == False):
         continue 

      # Assuming the user didn't connect an accelerator
      # to more than one processor instance, see what
      # it is connected to by reading its connections.
      accelerator = proposed_accelerator
      for connection in core.iter('CONNECTION'):
         instance = connection.get('INSTANCE')
         for index, processor in enumerate(processors):
            if (instance == processor['NAME']):
               # add to this processor's list
               accelerator = accelerator.upper()
               processors[index]['ACCELERATOR'] = accelerator
               break
             

   # Done, return processor list
   return processors


#------------------------------------------#
# Given a list of dictionaries (metadata)  #
# for each processor, I will compute the   #
# compiler flags appropriate for that      #
# processor configuration. I use a         #
# parameter-to-compiler flag xml document  #
# that can be extended as more ISAs are    #
# supported.                               #
# Author: Eugene Cartwright                #
#------------------------------------------#
def get_compiler_flags(processors):
   '''
      ' '.join(['Hello', 'World'])
      This will print the two words, 'Hello' and 'World'
      with a space inbetween them.

   '''
   compiler_flags = []

   for processor in processors:
      # Empty list to store flags for this processor
      temp_flags = []
      # Get processor compiler ISA (Hthreads)
      # to determine file path of XML document
      isa = processor['HTHREADS_ISA']
      hw_version = processor['HWVERSION']
      
      # Parse XML document
      tree = ET.parse('compiler/' + isa + '/compiler_flags.xml')
      root = tree.getroot()
      
      flag_tree = None
      # Find the processor we are interested in:
      for processor_flags in root.findall('PROCESSOR'):
         if isa == processor_flags.get('HTHREADS_ISA'):
            if hw_version == processor_flags.get('HWVERSION'):
               flag_tree = processor_flags
               break

      # Error checking: if we did not detect a listing of flags
      # for this processor/flag_tree is still == None
      if flag_tree == None:
         print "Did not detect compiler flags for ISA: " + isa + " HWVERSION: " + hw_version
         sys.exit(1)

      # For each parameter in the correct flag tree
      for parameter in flag_tree.iter('PARAMETER'):
         # Get the parameter's name as an index into this processor's metadata
         index = parameter.get('NAME')
         # Get the value of this processor's parameter
         value = processor[index]
         # Now retrieve the correct compiler flag for this value
         for option in parameter:
            candidate_value = option.get('VALUE')
            if candidate_value != value:
               continue
            else:
               # Found correct value for this option, get the flag
               flag = option.get('FLAG')
               temp_flags.append(flag)
               # break inner loop early
               break
      
      # Join all flags for this processor as one string 
      # before appending to top-level processor flags list
      temp_flags = ' '.join(temp_flags)
      compiler_flags.append(temp_flags)

   return compiler_flags

#------------------------------------------#
# Adds a new parameter to a processor's    #
# dictionary of parameters. Does some      #
# error checking as well. Returns modified #
# parameters.                              #
# Author: Eugene Cartwright                #
#------------------------------------------#
def add_processor_parameter(processor, parameter, value, exit_if_error=True):
   
   # check if entry(key) already exists for processor.
   if parameter in processor:
      print "A value for the parameter : " +parameter+" already exists for this processor"
      if exit_if_error:
         sys.exit(1)
   else:
      # Insert parameter and return modified processor parameters
      processor[parameter] = value
   
   return  processor


    


 
