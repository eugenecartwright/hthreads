#!/usr/bin/python
# *****************************************************************************
#                                  hcompile
#
#                           Authors: Jason Agron, Eugene Cartwright
# *****************************************************************************
import sys, os, re, commands, subprocess, filecmp
from string import Template
from compiler.common.execute import *
from compiler.common.platform_interpreter import *
from compiler.common import parser, hetero_utils



logo = "\
  _    _ _______ _    _ _____  ______          _____   _____ \n\
 | |  | |__   __| |  | |  __ \|  ____|   /\   |  __ \ / ____|\n\
 | |__| |  | |  | |__| | |__) | |__     /  \  | |  | | (___  \n\
 |  __  |  | |  |  __  |  _  /|  __|   / /\ \ | |  | |\___ \ \n\
 | |  | |  | |  | |  | | | \ \| |____ / ____ \| |__| |____) |\n\
 |_|  |_|  |_|  |_|  |_|_|  \_\______/_/    \_\_____/|_____/ \n\
"
                                                             
                                                             


# *****************************************************************************
# Internal Locations
# *****************************************************************************
host_platform_dir = "src/platforms/xilinx/"
hetero_platform_dir = "hal/src/platforms/xilinx/"
 
host_build_dir = "src/test/system/"
hetero_build_dir = "hal/src/test/system/" 
hetero_exec_dir = "hal/test/system/"
hetero_root_dir = "hal/"

# *****************************************************************************
# Internal Commands
# *****************************************************************************
# Embedded binary extension
EMBED_EXTENSION="_prog.h"

# Copy files
copy="cp -f "
rcopy="cp -r "
sys_mv="mv -f "

# Make folder
mkdir="mkdir -p "

# Run build system
run_build="jam clobber && jam -q "

table_code_template_file="./compiler/common/table_code_template.c"
typedef_file="./compiler/common/typedefs.c"
includes_file="./compiler/common/includes.c"

# Name of host processor
host_name = "host"

# V-HWTI addresses
VHWTI_base = "0xC0000000"
VHWTI_offset = "0x00010000"

#-----------------------------------------------------------------------------#
#                             Main program                                    #
#-----------------------------------------------------------------------------#
def main():

   print logo
   os.system("sleep 1")
   
   print "~~~ Compiler Initiated ~~~\n\n"
   #-----------------------------------------------------------------------------#
   # Initial checks:                                                             #
   #  * Arugment list                                                            #
   #  * Compilation Tools                                                        #
   #-----------------------------------------------------------------------------#
   # Check for Jam build systyem
   execute_cmd('jam -v')

   # Check command line argument
   num_args = len(sys.argv)

   # Check to make sure that there are enough args
   if (num_args >= 2):
      # Save filenames
      SRC_FILE_PATH = sys.argv[1]
      # Check if valid C file supplied
      match = re.search("\.c$", os.path.basename(SRC_FILE_PATH))
      if (match > -1):
         pass
      else:
         print "Invalid C source file supplied (Missing '.c' extension)."
         sys.exit(2)
   else:
      # Insufficient number of args, exit with error
      print "Incorrect argument usage!! Aborting..."
      print "Correct usage :\n    ./hcompile.py <src>\n"
      sys.exit(1)
   
   print "\t-----------------------------------"
   print "\t|+ Checking if source file exists |"
   print "\t-----------------------------------"
   assertCheck(checkInput(SRC_FILE_PATH))
   print "\t\t...Done"



   #-----------------------------------------------------------------------------#
   # Copy selected program to host build directory and slave build directory.    #
   # Also, extract program name and generate header file.                        #
   #-----------------------------------------------------------------------------#
   print "\t-----------------------------------------------------------"
   print "\t|+ Copying selected source file into host build directory |"
   print "\t-----------------------------------------------------------"
   cmd_list = []
   execute_cmd(copy + SRC_FILE_PATH + " " + host_build_dir)
   print "\t\t...Done"
   print "\t------------------------------------------------------------"
   print "\t|+ Copying selected source file into slave build directory |"
   print "\t------------------------------------------------------------"
   execute_cmd(copy + SRC_FILE_PATH + " " + hetero_build_dir)
   print "\t\t...Done"

   print "\t------------------------------------------------------"
   print "\t|+ Generating header file name for input source file |"
   print "\t------------------------------------------------------"
   # Extract just the source name
   SRC_FILE = os.path.basename(SRC_FILE_PATH)

   # Save the original source path without the name of source file
   # This will be used to copy the generated header file to this path
   # in case the user wants to view the generated header file.
   OLD_SRC_FILE_PATH = os.path.dirname(SRC_FILE_PATH)

   # Now modify the source path to reflect where we copied it above
   SRC_FILE_PATH = host_build_dir + SRC_FILE

   # Form what will be the the name of the associated header file
   # in order to clean up at the end of hcompile
   HEADER_FILE_PATH = re.sub("\.c$",EMBED_EXTENSION,SRC_FILE_PATH)

   # Remove and create empty header file
   execute_cmd('rm -f '+HEADER_FILE_PATH+' && touch ' +HEADER_FILE_PATH)

   # At the end of hcompile, remove the copied sources and the associated header file
   print "\t\t ...Done\n"
   
   #-----------------------------------------------------------------------------#
   # Appending "int main() { return 0; }" into source file for the user.         #
   #-----------------------------------------------------------------------------#
   print "\t---------------------------------" 
   print "\t|+ Appending to HAL source file |"
   print "\t---------------------------------"
   cmd = "echo -e 'int main() {\n\treturn 0;\n}' >> " + hetero_build_dir + "/" + SRC_FILE
   status = execute_cmd(cmd)
   if (status != 0):
      print "\t\t -> Unable to append 'int main()...' to HAL source ..."
      sys.exit(1)
   print "\t\t -> Appended to HAL Source File Successfully."
   print "\t\t...Done"
   
   #-----------------------------------------------------------------------------#
   # Read in selected platform, update the HAL config/settings, and copy         #
   # platform into HAL platform folders.                                         #
   #-----------------------------------------------------------------------------#
   print "\t-----------------------------------------"
   print "\t|+ Reading in Platform Selected By User |"
   print "\t-----------------------------------------"
   platform_name = read_config_settings("PLATFORM_BOARD","config/settings")
   print "\t\tPlatform = " + platform_name + "\n"
   
   print "\t-------------------------------------------------------------"
   print "\t|+ Updating HAL config/settings file with selected platform |"
   print "\t-------------------------------------------------------------"
   write_config_settings("PLATFORM_BOARD", platform_name, hetero_root_dir+"/config/settings")
   print "\t\t...Done"
   
   print "\t-----------------------------------------------------"
   print "\t|+ Copying platform to the slave's build directory. |"
   print "\t-----------------------------------------------------"
   execute_cmd(mkdir+hetero_platform_dir+platform_name+"/config")
   execute_cmd(mkdir+hetero_platform_dir+platform_name+"/design")
   execute_cmd(mkdir+hetero_platform_dir+platform_name+"/include")

   execute_cmd(copy+host_platform_dir+platform_name+"/include/* " + 
         hetero_platform_dir+platform_name+"/include/.")
   execute_cmd(copy+host_platform_dir+platform_name+"/design/Jamfile " + 
         hetero_platform_dir+platform_name+"/design/.")
   execute_cmd(copy+host_platform_dir+platform_name+"/config/* " + 
         hetero_platform_dir+platform_name+"/config/.")
   print "\t\t...Done"
   
   #-----------------------------------------------------------------------------#
   # Read hardware description file from selected platform to determine          #
   # parameters such as:                                                         #
   #  * number of processors                                                     #
   #  * ISA for each processor                                                   #
   #  * compiler flags                                                           #
   #-----------------------------------------------------------------------------#
   print "\t----------------------------------------------"
   print "\t|+ Loading details for the selected platform |"
   print "\t----------------------------------------------"
   platform_path = host_platform_dir+platform_name
   # Extract the hardware description file
   check, hw_file_path = get_hardware_file(platform_path)
   assertCheck(check)
  
   # Get number of processors
   PROCESSORS = get_processors(hw_file_path)
   print "\t\tFound " + str(len(PROCESSORS)) + " processors"
   for index,processor in enumerate(PROCESSORS):
      print "\t\t\t " +str(index)+": " + processor['NAME']
   print "\n"
   
   if (len(PROCESSORS) == 1):
      print "\n\n\tPlatform: " + platform_name + " only contains one processor!"
      print "\tYou should run 'jam' only TO COMPILE!"
      os.system("sleep 1")
      sys.exit(1)

   print "\t--------------------------------------------------"
   print "\t|+ Determining compiler flags for each processor |"
   print "\t--------------------------------------------------"
   # Determine Compiler flags for each processor
   COMPILER_FLAGS = get_compiler_flags(PROCESSORS)
   print "\t\t...Done"

   #-----------------------------------------------------------------------------#
   # Determine the targetted ISA for the host.                                   #
   # * If no processor's name matches 'host', default to first processor's ISA   #
   #-----------------------------------------------------------------------------#
   host_compilation_isa = None
   host_index = 0
   print "\t----------------------------------------"
   print "\t|+ Determining ISA for Host processor. |"
   print "\t----------------------------------------"
   for index,processor in enumerate(PROCESSORS):
      if processor['NAME'] == host_name:
         host_index = index
         host_compilation_isa = processor['HTHREADS_ISA']
         break
   
   if host_compilation_isa == None:
      print "\t\t+-+-+-+-+-+-+-+"
      print "\t\t|W|A|R|N|I|N|G|"
      print "\t\t+-+-+-+-+-+-+-+"
      print "\t\tDid not find host processor under the name: " + host_name
      print "\t\tDefaulting to processor: " + PROCESSORS[0]['NAME']
      host_compilation_isa = PROCESSORS[0]['HTHREADS_ISA']

   # Remove host processor from list of all processors
   host_processor = PROCESSORS.pop(host_index)

   # Remove host processor's compiler flags from list of compiler flags
   host_flags = COMPILER_FLAGS.pop(host_index)

   # Add HEADERFILE_ISA parameter for the host
   modified_processor_parameters = \
      add_processor_parameter(host_processor,'HEADERFILE_ISA', 'TYPE_HOST')
   host_processor = modified_processor_parameters
   
   
   #-----------------------------------------------------------------------------#
   # Determine similar processors based on compiler flags & linkerscript.        #
   # * Since the processor list (compiler flags list, etc) is ordered the same,  #
   #   there is no need to check for similar processors once I have come to the  #
   #   point in the nested loops where inner_index == outer_index. Therefore,    #
   #   the first slave processor will break out immediately which makes sense as #
   #   there won't be any previously built slave processor images --yes, ELF     #
   #   images are built/examined in the same order.                              #
   #- - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - - - - - - #
   # Also, create a new ISA each time a processor is found to have no similar    #
   # processors. Even if the platform is all MicroBlaze, this indicates that     #
   # they are configured differently.                                            #
   #-----------------------------------------------------------------------------#
   print "\t----------------------------------------------"
   print "\t|+ Checking which processors are identical   |"
   print "\t|+ to each other and generating an ISA list. |"
   print "\t----------------------------------------------"
   SDK_WORKSPACE = host_platform_dir+platform_name+"/design/design.sdk/"
   SIMILAR_PROCESSORS = {}
   # Data structure to keep track of all Processor types that will be embedded
   # into the header file
   HEADERFILE_ISAs = []

   # Add the host HEADERFILE ISA before continuing
   HEADERFILE_ISAs.append(host_processor['HEADERFILE_ISA'])
   
   new_isa = None
   for outer_index, outer_processor in enumerate(PROCESSORS):
      # For this processor, create a list of similar processors
      tmp_list = []
   
      for inner_index, inner_processor in enumerate(PROCESSORS[:outer_index]):
         # check if they are of the same isa and version/revision
         if inner_processor['HTHREADS_ISA'] == outer_processor['HTHREADS_ISA']:
            if inner_processor['HWVERSION'] == outer_processor['HWVERSION']:
               # if compiler flags are the same
               if COMPILER_FLAGS[outer_index] == COMPILER_FLAGS[inner_index]:
                  # if processor linkerscripts are the same
                  # NOTE: Only checks for files that are exactly the same.
                  # In the future, you can parse the linkerscript to compare.
                  inner_lscript = SDK_WORKSPACE + inner_processor['NAME']+"/src/lscript.ld"
                  outer_lscript = SDK_WORKSPACE + outer_processor['NAME']+"/src/lscript.ld"
                  if filecmp.cmp(inner_lscript, outer_lscript) == True:
                     tmp_list.append(inner_processor['NAME'])
                     new_isa = inner_processor['HEADERFILE_ISA']
                     # NOTE: I can break here and stop at first match if need be.
                     # break
   
      # if no similar processors found, then we found a new ISA.
      if len(tmp_list) == 0:
         new_isa = 'ISA'+str(len(HEADERFILE_ISAs))
         HEADERFILE_ISAs.append(new_isa)

      # Add new parameter for this processor
      processor_parameters = PROCESSORS[outer_index]
      modified_processor_parameters = \
         add_processor_parameter(processor_parameters,'HEADERFILE_ISA', new_isa)
      PROCESSORS[outer_index] = modified_processor_parameters
      # Append temporary list from this round of comparisons
      SIMILAR_PROCESSORS[outer_processor['NAME']] = tmp_list
      new_isa = None
   print "\t\t...Done"
   
   #-----------------------------------------------------------------------------#
   # For each slave processor, we should configure the HAL folder:               #
   #  * Configure the slave's config/settings file: PLATFORM_ARCH                #
   #  * Create a Jamrules file with the processor's specific compilation flags.  #
   #  * Extract symbols, handle names, and handle init functions                 #
   #  * Compile!                                                                 #
   #-----------------------------------------------------------------------------#
   # For Embedding purposes later
   SYMBOLS = []   # Everyone is assumed to have same _thread symbols
   HANDLE_LIST = {}
   INIT_FUNC_LIST = {}
   INTERMEDIATES = {}
   INTERMEDIATES_SIZE = {}

   for index, processor in enumerate(PROCESSORS):
      # Embedding list for this processor
      init_fcn_list = []
      func_list = []
      handle_list = []
      print "\t----------------------------------" + "-" * len(processor['NAME']) + "-"
      print "\t|+ Building source for processor: " + processor['NAME'] + "|"
      print "\t----------------------------------" + "-" * len(processor['NAME']) + "-"
      
      #-----------------------------------------------------------------------------#
      # Check whether we should build any sources for this slave processor or just  #
      # link it to a previously, similarly built ELF file.                          #
      #-----------------------------------------------------------------------------#
      other_similar_processors = SIMILAR_PROCESSORS[processor['NAME']]
      # if this list is empty, build this ELF file
      if len(other_similar_processors) == 0:
         #-----------------------------------------------------------------------------#
         # Update slave config/setting file. PLATFORM_BOARD has already been set above #
         #-----------------------------------------------------------------------------#
         slave_isa = processor['HTHREADS_ISA']
         # Write ISA to config/settings
         write_config_settings("PLATFORM_ARCH", slave_isa, hetero_root_dir+"/config/settings")
         # TODO: I can probably remove this PLATFORM_CREATE_TO_ARCH parameter
         write_config_settings("PLATFORM_CREATE_TO_ARCH", slave_isa, hetero_root_dir+"/config/settings")
         
         #-----------------------------------------------------------------------------#
         # Create a Jamfile specific for this processor. This will overwrite the       #
         # previously copied Jamefile from the host & previous slaves build directory. #
         #-----------------------------------------------------------------------------#
         # Copy the ISA-specific Jamrules template to the slave's platform folder
         Jamfile_path = hetero_platform_dir+platform_name+"/config/Jamrules"
         execute_cmd(copy + "compiler/common/slave_Jamrules " + Jamfile_path)

         # Create the Jamfile
         create_Jamfile(Jamfile_path, COMPILER_FLAGS[index], processor['NAME'])

         #-----------------------------------------------------------------------------#
         # Copy linkerscript specific for this processor from platform's folder.       #
         #-----------------------------------------------------------------------------#
         slave_lscript_path = hetero_platform_dir+platform_name+"/config/lscript.ld"
         slave_template_lscript_path = host_platform_dir+platform_name+"/config/linkscript_slave.ld"
         execute_cmd(copy + slave_template_lscript_path + " " + slave_lscript_path)

         #-----------------------------------------------------------------------------#
         # Build source in HAL folder for this particular ISA.                         # 
         #-----------------------------------------------------------------------------#
         cmd_list = []
         # Save current directory
         old_path = os.getcwd()
         # Change directory to slave compilation folder
         os.chdir(hetero_root_dir)
         # Execute command in changed folder
         hal_cmd_status = execute_cmd(run_build, exit_if_error=False)
         # Change to old path
         os.chdir(old_path)
         if (hal_cmd_status != SUCCESS):
            print "\t\t" + processor['NAME']
            print "\t\t -> Build Unsuccessful. Rolling back..."
            # Undo changes you made such as copying the source files
            file_to_remove = hetero_build_dir + SRC_FILE
            execute_cmd("rm -f " + file_to_remove)
            execute_cmd("rm -f " + SRC_FILE_PATH)
            # Exit immediately
            sys.exit(1)
         

         #-----------------------------------------------------------------------------#
         # Append each ISA ELF into existing Header file                               #
         #-----------------------------------------------------------------------------#
         # Form path to where the ELF image resides for this ISA
         elf_image = hetero_exec_dir+ SRC_FILE.rstrip('.c')

         # Embed this ISA
         init_fcn_list, func_list, handle_list = \
               hetero_utils.embed(elf_image,HEADER_FILE_PATH,slave_isa,processor['HEADERFILE_ISA'])

         # Grab the lists and append it to top level lists
         # TODO: Check to make sure func_list match 
         SYMBOLS = func_list
         HANDLE_LIST[processor['HEADERFILE_ISA']] = handle_list
         INIT_FUNC_LIST[processor['HEADERFILE_ISA']] = init_fcn_list
         INTERMEDIATES[processor['HEADERFILE_ISA']] = processor['HEADERFILE_ISA']+'_intermediate'
         INTERMEDIATES_SIZE[processor['HEADERFILE_ISA']] = INTERMEDIATES[processor['HEADERFILE_ISA']]+'_len'
         print "\t\tDone"
      
      # Found other similar processors
      else:
         print "\t\tSkipping..."
            

   # Once all slave code has been compiled, remove copied source
   file_to_remove = hetero_build_dir + SRC_FILE
   execute_cmd("rm -f " + file_to_remove)

   # Append Host information to handle, init_function, and intermediate lists
   # Add function handles for the host (which is just the Symbols minus the '_HANDLE'
   HANDLE_LIST[host_processor['HEADERFILE_ISA']] = SYMBOLS
   INIT_FUNC_LIST[host_processor['HEADERFILE_ISA']] = []
   INTERMEDIATES[host_processor['HEADERFILE_ISA']] = 'NULL'
   INTERMEDIATES_SIZE[host_processor['HEADERFILE_ISA']] = '0'
   
   #-----------------------------------------------------------------------------#
   # Now use all of the symbols you collected to finish header file              #
   # NOTE: The following code assumes all slaves and host source files see the   #
   # same number of thread functions (Grabbing the symbols for the first slave). #
   #-----------------------------------------------------------------------------#
   # Now finish writing the _prog.h file with FUNC_ID's, the
   # template header file, and the load_my_table() function.
   f = open(HEADER_FILE_PATH, 'a')
   f.write("\n// Thread Table Code:\n")
   # The number of architectures we are targetting 
   f.write("#define MAX_HANDLES_PER_ENTRY\t"+str(len(HEADERFILE_ISAs))+"\n")
   # TODO: Assuming that all of the ISA types had the same number of thread functions
   f.write("#define MAX_ENTRIES_PER_TABLE\t"+str(len(SYMBOLS))+"\n")
   f.write("\n// Function IDs:\n")
   for index, func_id in enumerate(SYMBOLS):
      # Append _FUNC_ID, and write to file
      f.write("#define "+func_id+"_FUNC_ID\t"+str(index)+"\n")
   f.close()
   
   #-----------------------------------------------------------------------------#
   # Write out generated/header file ISA                                         #
   #-----------------------------------------------------------------------------#
   f = open(HEADER_FILE_PATH, 'a')
   f.write("\n// Processor Types/ISAs:\n")
   for index, processor_type in enumerate(HEADERFILE_ISAs):
      f.write("#define " + processor_type + "\t("+ str(index) + ")\n")
   f.close()

   #--------------------------------#
   # Append includes to header file #
   #--------------------------------#
   subprocess.check_call('cat '+includes_file+' >> '+HEADER_FILE_PATH, shell=True)

   #-----------------------------------------#
   # Append Typdef structures to header file #
   #-----------------------------------------#
   subprocess.check_call('cat '+typedef_file+' >> '+HEADER_FILE_PATH, shell=True)
   
   #---------------------------------------#
   # Create processor array in header file #
   #---------------------------------------#
   hetero_utils.create_hwti_array(VHWTI_base, VHWTI_offset,len(PROCESSORS) ,HEADER_FILE_PATH)

   #---------------------------------------------#
   # Create Slave/Resource Table with known data #
   #---------------------------------------------#
   PROCESSORS = get_accelerators(hw_file_path, PROCESSORS)
   # print PROCESSORS
   hetero_utils.create_slave_table(PROCESSORS, HEADER_FILE_PATH)

   #------------------------------------#
   # Now write table_code_template_file #
   #------------------------------------#
   subprocess.check_call('cat '+table_code_template_file+' >> '+HEADER_FILE_PATH, shell=True)
   

   # ----------------------------------#
   # Insert "load_my_table()" function #
   # ----------------------------------#
   f = open(HEADER_FILE_PATH, 'a')
   f.write("\n\nvoid load_my_table() {\n")
  
   # For all ISAs, #NOTE: Assuming each ISA/Type has same number of handles
   for i, processor_type in enumerate(HEADERFILE_ISAs):
      f.write("\t// ISA: "+processor_type+"\n")
      # For each processor type, write out each init_handle function and insert_table_entry
      init_functions = INIT_FUNC_LIST[processor_type]
      intermediate = INTERMEDIATES[processor_type]
      intermediate_size = INTERMEDIATES_SIZE[processor_type]
      for j, handle in enumerate(HANDLE_LIST[processor_type]):
         temp_intermediate = intermediate
         # if this is a slave, it should have a init handle function
         if (len(init_functions) > 0):
            # Write the initialization function call for this HANDLE
            f.write("\t" + init_functions[j]+"();\n")
            temp_intermediate = "(void *) &" + intermediate
         else:
            pass # No init handle func for Host
         # Write code for inserting this symbol into global_thread_table
         f.write("\tinsert_table_entry(&global_thread_table, "+SYMBOLS[j]+"_FUNC_ID, "+processor_type+\
               ", (void*)"+handle+", "+temp_intermediate+", " +intermediate_size+");\n")
   f.write("}\n\n")
   f.close()
      
   print "\t\t -> Routine returned successfully."




   

   #-----------------------------Building HOST-----------------------------------#

   #-----------------------------------------------------------------------------#
   # Update host config/setting file. PLATFORM_BOARD has already been set.       #
   #-----------------------------------------------------------------------------#
   host_isa = host_processor['HTHREADS_ISA']
   # Write ISA to config/settings
   write_config_settings("PLATFORM_ARCH", host_isa, "config/settings")
   
   #-----------------------------------------------------------------------------#
   # Create a Jamfile specific for this processor. This will overwrite the       #
   # previously copied Jamefile from the host & previous slaves build directory. #
   #-----------------------------------------------------------------------------#
   # Copy the ISA-specific Jamrules template to the slave's platform folder
   Jamfile_path = host_platform_dir+platform_name+"/config/Jamrules"
   execute_cmd(copy + "compiler/common/host_Jamrules " + Jamfile_path)

   # Create the Jamfile
   create_Jamfile(Jamfile_path, host_flags, host_processor['NAME'])

   #-----------------------------------------------------------------------------#
   # Copy linkerscript specific for this processor from platform's folder.       #
   # TODO: Assumed to have an lscript in config folder already.                  #
   #-----------------------------------------------------------------------------#
   #lscript_path = hetero_platform_dir+platform_name+"/config/"
   #execute_cmd(copy + SDK_WORKSPACE + processor['NAME'] +"/src/lscript.ld " + lscript_path)

   # *****************************************************************************
   # Build Application for host, now that you have the header file.
   # *****************************************************************************
   print "\t-----------------------------------"
   print "\t|+ Compiling application for Host |"
   print "\t-----------------------------------"
   print "\t\t -> Header file created, compiling source file for Host processor(s)..."
   # Recompile host code that will not include the auto-generated header
   host_build_status = execute_cmd(run_build, exit_if_error=False)
   if (host_build_status != SUCCESS):
      print "\t\t" + host_processor['NAME']
      print "\t\t -> Build Unsuccessful. Rolling back..."
      # Undo changes you made such as copying the source files
      execute_cmd("rm -f " + SRC_FILE_PATH)
      # Copy the headerfile you created earlier for examining
      print "\t\t NOTE: Moving generated headerfile to the path: " + OLD_SRC_FILE_PATH
      execute_cmd(sys_mv + HEADER_FILE_PATH + " " + OLD_SRC_FILE_PATH)
      # Exit immediately
      sys.exit(1)
   else:
      print "\t\t -> The compilation was successful."
         

   # *****************************************************************************
   # Remove copied heterogeneous application from src/test/system/ and its
   # associated header file. File cleanup.
   # *****************************************************************************
   print "\t---------------------------------------------------------"
   print "\t|+ Cleaning up (Removing copied header and source file) |"
   print "\t---------------------------------------------------------"
   cmd_list = []
   # Remove source file that was copied originally
   cmd_list.append("rm -f " + SRC_FILE_PATH);
   # Copy the associated header file to the original source file path.
   # Remove the file name from this variable
   cmd_list.append(sys_mv + HEADER_FILE_PATH + " " + OLD_SRC_FILE_PATH)
   # Execute command 
   execute_cmd(cmd_list)
   print"\t\t Done"

   print "\n~~~ Compiler Completed ~~~" 
 

if __name__ == "__main__":
   main()  
