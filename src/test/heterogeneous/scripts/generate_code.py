#!/usr/bin/python
import sys, re, random
from string import Template

# number of data sizes
num_of_data_sizes = 8

def main():

    # Read in all the lines from the file
    infile = open("call_template", "r")
    lines = infile.readlines()
    infile.close()

    CALL_LIST = []

    TOTAL_MAX = 0
    # Determine number of calls/rows we have
    num_of_calls = 0
    for i,line in enumerate(lines):
        # No call should be less than 6 characters long.
        # I.e. "f(); 8" --> a valid call with max number.
        match = re.search(';',line)
        if (match > -1):
            # increment number of calls
            num_of_calls+1

            # also grab the max for this call
            # Remove all of the extra information b4 number
            number_string = re.sub(".*;\s*","", line)
            number_string = re.sub("\s*$","",number_string)

            # The function call to repeat max times
            function_call = re.sub(";\s*.*\s*$",";", line)
         
            number_max = 0
            # Convert to number
            if(number_string.isdigit()):
                number_max = int(number_string)
            else:
                print "ERROR! Could not find a max for a call"
                print number_string
                print function_call
                sys.exit(1)
           
            # Add to the total max 
            TOTAL_MAX += number_max
            # Add this function call to the 
            # CALL LIST number_max times
            for j in xrange(0, number_max):
                CALL_LIST.append(function_call)

    # Open file for writing
    outfile = open("file_to_open.c", "w")

    '''
        Declare TOTAL_MAX threads and attributes
    '''
    outfile.write("\t// Instantiate threads and thread attribute structures\n")
    outfile.write("\ththread_t threads[" + str(TOTAL_MAX) + "];\n")    
    outfile.write("\ththread_attr_t attr[" + str(TOTAL_MAX) + "];\n")

    outfile.write("\tunsigned int ee = 0;\n");
    outfile.write("\tfor(ee = 0; ee < " + str(TOTAL_MAX) + "; ee++) {\n")
    outfile.write("\t\ththread_attr_init(&attr[ee]);\n")
    outfile.write("\t\ththread_attr_setdetachstate(&attr[ee], HTHREAD_CREATE_DETACHED);\n")
    outfile.write("\t}\n\n")
    #print >> outfile "\t\ththread_attr_setdetachstate(&attr[e], HTHREAD_CREATE_DETACHED);"

    '''
        Declaring  TOTAL_MAX Data packages
    '''
    # Now for all of TOTAL_MAX, we should create TOTAL_MAX Structures
    outfile.write("\tvolatile Data package[" + str(TOTAL_MAX) + "];\n")

    '''
        Initializing all Data packages with random sizes
    '''

    # TODO: We should then initialize here
    infile = open("struct_init_template", "r")
    lines = infile.readlines()
    infile.close()

    data_size_list = [64, 512, 1024, 2048, 4095, 3500]

    for i in xrange(0, TOTAL_MAX):
        random.seed(None)
        size = 0
        count = 0
        for line in lines:
            # For every line, replace "#" with i
            line = re.sub("#", str(i), line)

            # Search for $1, $2, $3. We will assign random number
            # to each. TODO: Later, you should remove hardcoding
            # this, and get loop through number of accelerators.
            # i.e. $0, $1, ... $(n-1)
            match  = re.search("\$3", line)
            if (match > -1):
               if count == 0:
                  index = random.randrange(0,len(data_size_list))
                  size = data_size_list[index]
                  line = re.sub("\$[0-9]+", str(size), line)
               else:
                  line = re.sub("\$[0-9]+", str(size), line)
               count += 1
            else:
               match  = re.search("\$[0-9]", line)
               if (match > -1):
                  index = random.randrange(0,len(data_size_list))
                  size = data_size_list[index]
                  line = re.sub("\$[0-9]+", str(size), line)

            outfile.write("\t" + line)
   
    '''
        Writing for loop to malloc data for random sizes
        above, and initialize data with random values.
    ''' 
    # TODO: We should then initialize here
    infile = open("initialization_template", "r")
    lines = infile.readlines()
    infile.close()
    for line in lines:
        line = re.sub("@", str(TOTAL_MAX), line)
        outfile.write("\t" + line)
            
    outfile.write('\n')        
    
    '''
        Doing a two step shuffle of all of the function calls
        Since the original CALL LIST has each function call
        repeated n number of times, consecutively, we then
        create a NEW CALL LIST that chooses from the old 
        CALL LIST randomly, in order to shuffle the order of 
        calls.
    '''
    # We should shuffle CALL LIST so we can make it truly random
    NEW_CALL_LIST = []
    for i in xrange(0, TOTAL_MAX):
        # Just use system time as seed
        random.seed(None)
        
        # Get a random number from the list
        j = random.randrange(0, len(CALL_LIST))

        # Pop the random index, j from original CALL_LIST
        NEW_CALL_LIST.append(CALL_LIST.pop(j))

    # Start timer
    outfile.write("\tstart = hthread_time_get();\n\n")

    '''
        Now that we have a shuffled list of function calls, 
        we will now choose an index at random and write to file.
    '''
    # Now we should also write out all of the calls in a random order
    for i in xrange(0, TOTAL_MAX):
        # Just use system time as seed
        random.seed(None)
        
        # Get a random number from the list
        j = random.randrange(0, len(NEW_CALL_LIST))

        # Get function call
        call = NEW_CALL_LIST.pop(j)

        # Now replace # with i. We can do this since
        # we randomly sorted the orginal SORT_LIST
        call = re.sub("#",str(i),call)

        # Now write this call out to a file
        outfile.write("\t" + call + "\n")
    
    # Write check for if active threads is still greater than > 0
    outfile.write("\n\twhile(get_num_free_slaves() < NUM_AVAILABLE_HETERO_CPUS);\n")

    # Stop timer
    outfile.write("\n\tstop = hthread_time_get();\n\n")

    # Write checking for results code
    infile = open("check_results_template", "r")
    lines = infile.readlines()
    infile.close()

    for line in lines:
        line = re.sub("@", str(TOTAL_MAX), line)
        outfile.write("\t" + line)
    

    # Write code to print out final execution time
    outfile.write("\ththread_time_t diff;\n")
    outfile.write("\ththread_time_diff(diff, stop, start);\n")
    outfile.write("\tprintf(\"Total Execution Time: %.2f ms\\n\", hthread_time_msec(diff));\n")
    outfile.write("\tprintf(\"Total Execution Time: %.2f us\\n\", hthread_time_usec(diff));\n")
    outfile.close()

    infile = open("main_template.c", "r")
    lines = infile.readlines()
    infile.close

    infile = open("file_to_open.c", "r")
    lines2 = infile.readlines()
    infile.close

    outfile = open("../fpl2013.c", "w")
    for line in lines:
        match = re.search("0xDEADBEEF", line)
        if (match > -1):
            for lineA in lines2:
                outfile.write(lineA)
        line = re.sub("0xDEADBEEF", "", line)
        outfile.write(line)
            
if __name__ == "__main__":
    main()	
