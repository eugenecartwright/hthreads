#!/usr/bin/python
# ------------------------------------------------------------------ #
# This will be a module.... 
# ------------------------------------------------------------------ #

import sys, os, re, commands, pprint, subprocess, collections
from string import Template
from execute import *
import xml.etree.ElementTree as ET

#-----------------------------------------------------------#
#_______________________Module Variables_____________________

# C-Hex dump tool
hexdump_tool="xxd -i -c 4"

# ELF copy tools
objcopy_tool = {"mblaze":"mb-objcopy",
                "ppc440":"powerpc-eabi-objcopy",
                "arm":"arm-xilinx-linux-gnueabi-objcopy"
               }

# ELF Architecture NOTE: At this time, ARM does not have
# a determined target 
objcopy_arch = {"mblaze":"elf32-microblaze",
        "ppc440":"elf32-powerpc",
        "arm":""
       }

# ELF symbol table extraction tool
nm_tool = {"mblaze":"mb-nm -S",
           "ppc440":"powerpc-eabi-nm -S",
           "arm":"arm-xilinx-linux-gnueabi-nm"
          }


# ----------------------------------------- #
#             Embedding Function            #
# ----------------------------------------- #
def embed(elf_path, header_file, isa, processor_type):

   # define an intermediate file name based on processor name
   intermediate = processor_type+'_intermediate'
   
   # ----------------------------------------------- #
   # Create_intermediate function, converting the    #
   # ELF image to a binary format.                   #
   # ----------------------------------------------- #
   print '\t\t' +isa.upper()+ ': Creating intermediate file with binary ELF data...'
  
   # Grab appropriate ELF copy tool and architecture
   elf_copy = objcopy_tool[isa]
   elf_arch = objcopy_arch[isa]
   
   # Populate file with binary data.
   execute_cmd(elf_copy+' -I '+elf_arch+' -O binary '+elf_path+' '+intermediate)

   # ------------------------------------------------ #
   # Create a C header file that then can be included #
   # when compiling for another architecture          #
   # ------------------------------------------------ #
   print "\t\t" +isa.upper()+ ": Translating intermediate binary into a C header file..."

   # Populate header file with C-ified hexdump data (appending if needed).
   # This creates the header file if it does not exist yet.
   execute_cmd(hexdump_tool+' '+intermediate+' >> ' +header_file)

   # ------------------------------------------------ #
   # Inserts symbol/function information, such as     #
   # function offsets in order to aid in properly     #
   # resolving relocated code of different ISA.       #
   # ------------------------------------------------ #
   print "\t\t" +isa.upper()+ ": Resolving ELF symbols and inserting them in C header file..."

   # Grab symbols for this executable
   symbols = extract_symbol_info(elf_path,isa)
 
   if symbols == None:
       print "Error!"
       sys.exit(1)
    
   # Insert symbols into header file in order to make
   # send of previously written intermediate info.
   init_fcn_list, func_list, handle_list = \
       insert_function_info(symbols, elf_path, header_file, processor_type, intermediate)

   # Clean-up
   execute_cmd('rm -f ' + intermediate)

   # Return these three lists as callee will be
   # responsible for wrapping things up after embedding
   # all of the different ISA in header_file
   return init_fcn_list, func_list, handle_list, symbols


# ------------------------------------------------ #
# This function simply cals 'architecture-nm' to   #
# obtain sybmol information. What is returned is   #
# tuples containing each line of STDOUT. The '\n'  #
# character is stripped for convenience. The       #
# optional parameter, 'threads_only', directs      #
# symbol output consisting only of thread symbols  #
# as opposed to ALL symbols.                       #
# ------------------------------------------------ #
def extract_symbol_info(executable, isa, threads_only=True):
   # Check if the executable file exists
   if (os.path.isfile(executable) == False):
       print 'Extract Symbol Information: '+executable+' does not exist!'
       # Exit immediately
       return None

   # Grab the correct command based on architecture
   elf_symtab = nm_tool[isa]  

   # Execute command grabbing output NOTE: Need to get output of this command
   symbols = subprocess.check_output(elf_symtab+' '+executable+' | sort', shell=True)
   
   # Split into a list, using delimeter '\n'
   symbols = symbols.split('\n')

   # Extract threads from symbols only
   if (threads_only == True):
      thread_symbols = []
      for index, line in enumerate(symbols):
         # Clean up both ends of any spaces
         line = line.strip(' ')
         # Replace spaces with exactly one space
         line = re.sub('\s+', ' ', line)
         # Split line on spaces
         splitUp = line.split(' ')
         # Fast check to see if the line is worth
         # doing any processing on.
         if (len(splitUp) != 4):
            continue
         # Grab the different fields
         offset      = splitUp[0]
         sym_length  = splitUp[1]
         sym_type    = splitUp[2]
         sym_name    = splitUp[3]

         # Check to see if the symbol type is of interest (text section, no leading underscore)
         if (sym_type == "T"):
            # Run regex to only find threads functions
            match = re.search('_thread.*', sym_name)
            # If the symbol name does not begin
            # with "_" and there was a match.
            if ((sym_name[0] != "_") and (match > -1)):
               thread_symbols.append(splitUp);
      return thread_symbols

   # Return the symbol information
   return symbols

# ------------------------------------------------ #
# This function is responsible for flagging the    #
# ELF file for certain co-processor op-codes.      #
# ------------------------------------------------ #
def opcode_tagging(symbol, processor, elf_path):

   isa = processor['HTHREADS_ISA'] 

   # Grab appropriate ELF copy tool and architecture
   elf_copy = objcopy_tool[isa]
   elf_arch = objcopy_arch[isa]
   
   # Grab symbol metadata      
   offset      = symbol[0]
   sym_length  = symbol[1]
   sym_type    = symbol[2]
   sym_name    = symbol[3]

   # First, I need to copy elf file to binary format
   #mb-objdump -I elf32-microblaze -O binary ELF_FILE  output_FILE
   execute_cmd(elf_copy+' -I '+elf_arch+' -O binary '+elf_path+' _opcode.bin')
   
   # Next, reverse the bytes if this was Microblaze, it was
   # compiled in little endian and I find it easier to 
   # work in big endian
   if (isa == 'mblaze'):
      execute_cmd(elf_copy+' -I binary -O binary --reverse-bytes=4 _opcode.bin _opcode.bin')
   else:
      print "Opcode Taggin: Unsupported feature!"

   # Now you can xxd, seeking to that specific place, with a given length
   execute_cmd("xxd -c4 -s 0x" + offset + " -l 0x" + sym_length + " _opcode.bin | awk '{printf (\"%.2s\\n\", $2)}' > _opcode")

   # ------------------------------------------------------------------------------------------------------------------------- #

   # Now read in the temporary file, checking for opcodes
   with open('_opcode', 'r') as infile:
      lines = infile.readlines()
  
   # Parse XML document. TODO: I don't check processor version/hwversion
   tree = ET.parse('./compiler/'+isa+'/instructions.xml')
   root = tree.getroot()
   # Initialize an empty dictionary   
   temp_list = collections.OrderedDict()
   for core in root.iter('PARAMETER'):
      struct_entry = core.get('STRUCT_ENTRY')
      temp_list[struct_entry] = 0

   for line in lines:
      # Mask off lower 2 bits
      opcode = int(line, 16) & 0xFC
      
      for core in root.iter('PARAMETER'):
         # Use parameter name to index to processor's
         # value for that parameter
         name = core.get('NAME')
         value = core.get('VALUE')
         struct_entry = core.get('STRUCT_ENTRY')
         if (processor[name] >= value):
            target_opcode = core.get('OPCODE')
            # pad the end with 2 zeros to make it 8 bytes
            target_opcode+="00"
            # Compare opcode value with the target opcode
            if (int(target_opcode,2) == opcode):
               temp_list[struct_entry] = 1
   
   # File cleanup
   execute_cmd("rm -f _opcode") 
   execute_cmd("rm -f _opcode.bin") 
   
   return temp_list
        
# ------------------------------------------------ #
# Given a list of symbols (and their extra meta-   #
# data) for a particular ELF image, this function  #
# inserts the symbol in a formatted C code         #
# structure directly into a C header file.         #
# ------------------------------------------------ #
def insert_function_info(symbols, executable, header, processor_type, intermediate):
   init_fcn_list = []
   fcn_name_list = []
   handle_name_list = []
  
    
   # Open file in append mode, for writing into
   with open(header,"a") as infile:
      # Iterate over all symbols
      for index, line in enumerate(symbols):
         # Grab the different fields
         offset      = line[0]
         sym_length  = line[1]
         sym_type    = line[2]
         sym_name    = line[3]

         # Check to see if the symbol type is of interest (text section, no leading underscore)
         if (sym_type == "T"):
            # Run regex to only find threads functions
            match = re.search('_thread.*', sym_name)
            # If the symbol name does not begin
            # with "_" and there was a match.
            if ((sym_name[0] != "_") and (match > -1)):
               # For this particular ISA, add info to file
               offset_var_name = processor_type+"_"+sym_name+"_offset"
               sym_var_length = processor_type+"_"+sym_name+"_length"
               sym_var_name = processor_type+"_"+sym_name+"_HANDLE"
               sym_var_name_end = processor_type+"_"+sym_name+"_HANDLE_END"
               init_func_name = "init_"+sym_var_name 

               # Save initialization function names as we will
               # have to call them later in load_table() if we
               # want to resolve the symbol's HANDLE during runtime.
               init_fcn_list.append(init_func_name)
               # List to save the symbols we are concerned with.
               # No need to keep track of num_handles anymore.
               fcn_name_list.append(sym_name)
               # Handle list
               handle_name_list.append(sym_var_name)
              
               infile.write('\n\n// Offset into intermediate array...\n')
               infile.write('unsigned int '+offset_var_name+' = 0x'+str(offset)+';\n')	
               infile.write("unsigned int "+sym_var_length+" = 0x"+str(sym_length)+";\n")	
               infile.write("\n// Global Handle Variables for Function: " + sym_name+"\n")
               infile.write("unsigned int "+sym_var_name+" = -999; //("+offset_var_name+") + "+ "(unsigned int)(&"+intermediate+");\n")
               infile.write("unsigned int "+sym_var_name_end+" = -999; \n")
               infile.write("void "+init_func_name+"() {" + "\n")
               infile.write("\t"+sym_var_name+" = ("+offset_var_name+") + "+ "(unsigned int)(&"+intermediate+");\n")
               infile.write("\t"+sym_var_name_end+" = ("+offset_var_name+" + "+sym_var_length+") + "+ "(unsigned int)(&"+intermediate+");\n")
               infile.write("\treturn;\n")
               infile.write("}\n")
   infile.close()
   # What comes next is the thread table code (i.e. writing the 
   # FUNC_ID for all symbols) and the initialization of it 
   # (i.e. load_table() function). This should only run once and
   # only after 'embedding' all ISA's intermediate arrays and handles.
   # Therefore, return what is necessary to carry out these tasks.
   return init_fcn_list, fcn_name_list, handle_name_list
       

# ------------------------------------------------ #
# This function automatically builds the VHWTI     #
# addresses once statically defined in the table   #
# code template file.It also defines the parameter #
# NUM_AVAILABLE_HETERO_CPUS if needed.             #
# ------------------------------------------------ #
def create_hwti_array(base_addr, offset, num_of_processors, header_file):
   # Convert base_addr, and offset string into an integer
   base_addr_int = int(base_addr, 0)
   offset_int = int(offset,0)

   with open(header_file,"a") as infile:
      infile.write("\n// V-HWTI base addresses\n")
      for index in xrange(0,num_of_processors):
         address = hex(base_addr_int + offset_int*index) + "\n"
         infile.write("#define HWTI_BASEADDR" + str(index) + "\t" + address)
      
      # define this parameter if this system wasn't built using archgen
      infile.write("\n#ifndef NUM_AVAILABLE_HETERO_CPUS \n")
      infile.write("#define NUM_AVAILABLE_HETERO_CPUS " + str(num_of_processors) + "\n")
      infile.write("#endif\n")

      # create hwti_array (once called base_array)
      infile.write("Huint hwti_array[NUM_AVAILABLE_HETERO_CPUS] = {")
      for index in xrange(0,num_of_processors):
         address = hex(base_addr_int + offset_int*index) + "\n"
         infile.write("HWTI_BASEADDR" + str(index))
         if (index  != (num_of_processors-1)):
            infile.write(",")
      infile.write("};\n")
   infile.close()
         
# ------------------------------------------------ #
# This function automatically creates the slave    #
# (resource) table using information found at      #
# compile time such as processor type (ISA) and    #
# accelerators attached to processors.             #
# TODO: Error checking on key index lookup as it's #
# assumed the dictionary has the requested keys.   #
# ------------------------------------------------ #
def create_slave_table(processors, header_file):

   processor_configuration = {}  
   with open(header_file,"a") as infile:
      infile.write("#ifdef PR\n");
      infile.write("slave_t slave_table[NUM_AVAILABLE_HETERO_CPUS] = {\n")
      for index in xrange(0,len(processors)):
         infile.write("//" + processors[index]['NAME'] + "\n") 
         # Get processor configuration (that matches struct thread_profile_t)
         string = create_processor_configuration_profile(processors[index])
         processor_configuration[index] = string

         infile.write("{" + processors[index]['ACCELERATOR'] + "," + processors[index]['HEADERFILE_ISA'] + 
            ",HWTI_BASEADDR"+ str(index) + ", 1, " + string +"}")
         if (index  != (len(processors)-1)):
            infile.write(",")
         infile.write("\n")
      infile.write("};\n")
      
      infile.write("#else\n");

      infile.write("slave_t slave_table[NUM_AVAILABLE_HETERO_CPUS] = {\n")
      for index in xrange(0,len(processors)):
         infile.write("//" + processors[index]['NAME'] + "\n") 
         # Get processor configuration (that matches struct thread_profile_t)
         string = create_processor_configuration_profile(processors[index])

         infile.write("{" + processors[index]['ACCELERATOR'] + "," + processors[index]['HEADERFILE_ISA'] + 
            ",HWTI_BASEADDR"+ str(index) + ", 0, " + string +"}")
         if (index  != (len(processors)-1)):
            infile.write(",")
      
         infile.write("\n")
      infile.write("};\n")
      infile.write("#endif\n\n");
   infile.close()
   
   return processor_configuration

# ------------------------------------------------ #
# This function is responsible for creating        #
# processor configuration data structure.          #
# ------------------------------------------------ #
def create_processor_configuration_profile(processor):
 
   isa = processor['HTHREADS_ISA']

   # Parse XML document. TODO: I don't check processor version/hwversion
   tree = ET.parse('./compiler/'+isa+'/instructions.xml')
   root = tree.getroot()

   string = "{"
      
   for core in root.iter('PARAMETER'):
      # Use parameter name to index to processor's
      # value for that parameter
      name = core.get('NAME')
      value = core.get('VALUE')
      if (core.get('STRUCT_ENTRY') != None):
         if (processor[name] >= value):
            string+= "1,"
         else:
            string+="0,"
   # Append ratios (init to 0) and closing curly brace
   string += "0,0,0,0}"
   
   return string

