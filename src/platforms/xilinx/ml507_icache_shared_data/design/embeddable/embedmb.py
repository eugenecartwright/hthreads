#!/usr/bin/python
# **************************
# embedmb
# **************************
import sys, os, re
from string import Template

# *****************************************************************************
# Internal Variables
# *****************************************************************************
# Filename definition for intermediate file
#  *NOTE* - use a single string with no .'s or _'s so that hexdump (xxd) will use a single string
#  This makes it easy to calculate the address of the generated array (no string mangling)
intermediateFile="intermediate"

# ELF symbol table extraction tool
elf_symtab="mb-nm"	

# ELF info extraction tool
elf_info="mb-readelf -h"	

# ELF copy tool
elf_copy="mb-objcopy"

# Input ELF architecture
elf_arch = "elf32-microblaze"

# C-hexdump tool
hexdump_tool="xxd -i -c 4"

# *****************************************************************************
# Main program
# *****************************************************************************

def main():
    # Check command line argument
    num_args = len(sys.argv)
    if num_args >= 5:
        # Save filename
        HANDLE_NAME = sys.argv[1]
        FCN_NAME = sys.argv[2]
        EXEC_FILE = sys.argv[3]
        OUTPUT_FILE = sys.argv[4]
    else:
        # Insufficient number of args, exit with error
        print "Incorrect argument usage!! Aborting..."
        print "Correct usage :\n    /embedmb.py <handleName> <fcnName> <executable> <output.c>\n"
        sys.exit(2)

    # *****************************************************************************
    # Create an intermediate file that contains a binarized ELF
    # *****************************************************************************
    # Create a new file file
    status = os.system('rm -f '+intermediateFile+' && touch '+intermediateFile)
    
    # Fill file with info
    status = os.system(elf_copy+" -I "+elf_arch+" -O binary "+EXEC_FILE+" "+intermediateFile)

    # *****************************************************************************
    # Create a C file that can be re-compiled with a different architecture
    # *****************************************************************************
    # Create a new file for the output file
    status = os.system('rm -f '+OUTPUT_FILE+' && touch '+OUTPUT_FILE)
    
    # Fill OUTPUT file with the C-ified hexdump
    status = os.system(hexdump_tool+" "+intermediateFile+" "+OUTPUT_FILE)

    # *****************************************************************************
    # Add extra symbol information to C file that contains "code offsets" for
    # functions that are to be used by the programmer
    # *****************************************************************************

    # Initialize offset and found flag
    offset = 0
    found_flag = 0

    # Find offset in original executable (put in intermediateFile)
    status = os.system(elf_symtab+" "+EXEC_FILE+" > "+intermediateFile)

    # Read in file and extract symbol offset
    infile = open(intermediateFile,"r")
    lines = infile.readlines()
    infile.close()

    # Delete file (no longer needed)
    status = os.system('rm -f '+intermediateFile)

    for line in lines:
        # Search for function name in symbol table
        m = re.search("(.*) "+FCN_NAME+"\n",line)

        # Grab offset
        if m:
            # Assert found
            found_flag = 1

            print "Thread function found:"

            # Grab the offset
            print m.group()
            offset = (m.group().split(' ')[0])

    # Check to see if Function Name was found in symbol table
    if (found_flag == 0):
        print "ERROR: function name ("+FCN_NAME+") not found in symbol table!"
        sys.exit(3)

    # Define a C variable name
    offset_var_name = HANDLE_NAME+"_offset"    

    # Concatenate offset info into file
    status = os.system("echo \"unsigned int "+offset_var_name+" = 0x"+str(offset)+";\" >> "+OUTPUT_FILE)

    # Concatenate offset info into file
    status = os.system("echo \"\n\n// Code to copy:\" >> "+OUTPUT_FILE)
    status = os.system("echo \"//extern unsigned int "+offset_var_name+";\" >> "+OUTPUT_FILE)
    status = os.system("echo \"//extern unsigned char "+intermediateFile+"[];\" >> "+OUTPUT_FILE)
    status = os.system("echo \"unsigned int "+HANDLE_NAME+" ;//= ("+offset_var_name+") + "+ "(unsigned int)(&"+intermediateFile+");\" >> "+OUTPUT_FILE)

    # Create intializer function
    func = []
    func.append("\nvoid _initialize_handles(){\n")
    func.append("   "+HANDLE_NAME+" = ("+offset_var_name+") + "+ "(unsigned int)(&"+intermediateFile+");\n")
    func.append("}\n")

    for line in func:
        status = os.system("echo \""+line+"\" >> "+OUTPUT_FILE)
        
   
if __name__ == "__main__":
    main()	
