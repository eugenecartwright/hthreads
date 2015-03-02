#!/usr/bin/python
import commands,re,sys

class parser:
    """Author: Eugene Cartwright"""

    #-----------------------------------------------------------#
    #_______________________Class Variables_____________________

    # ELF symbol table extraction tool
    elf_symtab="empty_string"
    #elf_symtab="mb-nm -ln"
    
    #-----------------------------------------------------------#

    # Constructor/Init function for each object of this class
    def __init__(self, elf_sym_cmd):
        self.elf_symtab = elf_sym_cmd

    #-------------------------------------------------------#
    # Make some list of size 'size' and initialize to zeros #
    #-------------------------------------------------------#
    def make_list(self,size):
        """Creates a list of size, filling with zeros. 
        For example:
        
        >>>list = []
        >>>size = 5
        >>>for i in range(0,size):
        ...     list.append(0) 
        >>>print list
        [0, 0, 0, 0, 0]
        """   

        # Create an empty list
        row = []
        for i in range(size):
            row.append(0)
        return row 
    
    #-----------------------------------------------------#
    # Makes a list of lists, or a matrix, and returns it. #
    #-----------------------------------------------------#
    def make_matrix(self,row,cols):
        """Creates a list of lists. Example:

        >>> rows = 3
        >>> cols = 3
        >>> matrix = []
        >>> temp_list = []
        >>> for i in range(0,cols):
        ...     temp_list.append(0)
        >>> for i in range(0,rows):
        ...     matrix.append(temp_list)
        >>> print matrix
        [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
        """
        
        # Create an empty list
        matrix = []
        # Create a list/row with size cols
        for i in range(row):
            matrix.append(self.make_list(cols))
        return matrix

    #-------------------------------------------------------------------#
    # This function, given a function name & a starting line number,    #
    # searches each line starting at src_lines[starting_line] until     #
    # finds the "beginning" of the function definition.                 #
    #-------------------------------------------------------------------#
    def get_function_start_line(self,src_lines,function_name, starting_line):
        """Function searches in reverse, beginning with starting_line
        where the opening bracket for the function definition. '{', 
        should be. Function must take into account a variable number
        of spaces, asterisks, and handle any user/system defined
        datatype. 

        Note: Example not provided in order to keep this section short
        """

        # starting_line is given as an integer, whose line numbers 
        # start @ 1, and not 0. Therefore, decrement this number
        # since lists work with indexes beginning at 0
        line_num = starting_line - 1
        
        # Grab line number and store it in count
        count = line_num
        # Using count/line_num, grab the current line & begin your search
        line = src_lines[count]
        
        # We need to search for 4 things in reverse
        #   0. ')' and then '('
        #   1. function name
        #   2. asterisks (if any. If so, how many?)
        #   3. datatype (user or system_defined)
        
        # ----------This block of code searches for '(' and ')' -------------#
        # First of all, detect that there is only 1 '{
        line = line.split('{')
        if (len(line) != 2):
            print "ERROR! Please have only 1 '{' on this line please!" 
            print "Offending Line Number: " + str((count + 1))
            print "-----> " + line
            sys.exit(2)
        # Next, grab the first part of this split line and discard the rest
        line = line[0]
       
        # Now let's start searching for ')' and '(' 
        arg_bracket_counter = 0
        temp_line = line
        while (count >= 0):
            # Let's check that we never stumble into analyzing another block
            # of code (i.e., we should not encounter '}') 
            if (re.search('}',temp_line) > -1):
                print "ERROR! Please move the '}' from the previous block to its own line"
                print "Offending Line Number: " + str((count + 1))
                print "-----> " + line
                sys.exit(2)
            # How many of ')'? Increment counter
            temp_lineB = temp_line.split(')')
            arg_bracket_counter += len(temp_lineB) - 1
            # How many of ')'? Decrement counter
            temp_lineB = temp_line.split('(')
            arg_bracket_counter -= len(temp_lineB) - 1
            # If we have not finished accounting for all '(' & ')'
            if (arg_bracket_counter > 0):
                count -= 1  # Go to previous line
                temp_line = src_lines[count]
            # if we have, reset line to src_lines[count] but
            # remove everything to the right of opening bracket
            # for args (
            else:
                line = src_lines[count]
                line = re.sub('^\s*\(.*','',line)
                break
        #------------------------------------------------------------------------#

        # Now we either have passed the point of where the declaraed their
        # arguments to this function, or we are on the same line as where the
        # arguments begin and the function name resides.

        #-----------------------------Main While-Loop----------------------------#
        # While we have not reached the beginning of the file
        while (count >= 0):
            # search for function name on current line-->line
            hit = re.search(function_name, line)
            
            # If we found the function name
            if (hit > -1):
                # Further break up the line to ease in searching for
                # asterisks(if any) and datatype. When done, we can
                # ignore everything to the right of this split line
                # (i.e., ignore splitUpLine[1], but keep splitUpLine[0])
                line = line.split(function_name)
                
                # Should not reach here! If you do, that means the
                # programmer has the function declaration and a call
                # to that same function on the same line. For example,
                #   void * foo2() { 
                #   foo(); } void * foo (.....) {
                #       // code
                #   }
                #
                if (len(line) > 2):
                    print "ERROR: Found " + function_name + " multiple times on line " + str(count+1) 
                    print "Please move the function declaration to its own line."
                    sys.exit(2)
                # If we did find it, it should have split this line in two
                else:
                    # We just need to search first element of list as indicated above
                    line = line[0]
                    
                    #-------------------------While-Loop----------------------------#
                    # while we have still not reached the beginning of the file                        
                    while (count >= 0):

                        # Before we split the line, does it have any '}' brackets
                        # from previous function definition. If so, I will not
                        # tolerate this.
                        if (re.search('}',line) > -1):
                            print "ERROR! Please move the '}' from the previous function to its own line"
                            print "Offending Line Number: " + str((count + 1))
                            print "-----> " + line
                            sys.exit(2)
                        
                        # Split the line up by asterisk(s), if any
                        line = line.split('*')
                        
                        # if this line had asterisks or none, we always grab the first
                        # element of this new list. For example, if we had the two strings
                        #   line = "void *foo()" --> line.split('*') = ['void ', 'foo()']
                        #   line = "void foo()" --> line.split('*') = ['void foo()']
                        # We grab line[0] in both cases.
                        line = line[0]  # Reset to string literal
                        
                        # Did we find any non-whitespace character (our datatype)?
                        if (re.search('\S+',line) > -1):
                            # We did! Return line number + 1(+1 in order to 
                            # convert the 0,1,2,...n-1 indexing to 1,2.3..n indexing)
                            return (count + 1)
                        # We did not find the datatype. Go to line above
                        else:
                            count -= 1
                            line = src_lines[count]
                    #---------------------------While-Loop----------------------------#
            
            # If we did not find the function name on this line at all, decrement line
            # number (count), and grab next line
            else:
                count -= 1
                line = src_lines[count]

    #-------------------------------------------------------------------#
    # This function, given a function name & a starting line number,    #
    # searches each line starting at src_lines[starting_line] until it  #
    # finds the closing bracket for that function.                      #
    #-------------------------------------------------------------------#
    def get_function_end_line(self, src_lines, function_name, starting_line):
        """ Searchs the list for the end of the function. For example:
        >>> src_lines = []
        >>> src_lines.append("void * foo()")
        >>> src_lines.append("{")
        >>> src_lines.append("\t//Do some work")
        >>> src_lines.append("\ta[i] = b[i] + c[i]")
        >>> src_lines.append("}")
        >>> count = -1
        >>> starting_line = src_lines.index('{')
        >>> for i in range(starting_line,len(src_lines)):
        ...     if src_lines[i] == '}':
        ...             count = i
        ... 
        >>> print count
        4
        """

        # this variable is used for keeping track of how many
        # curly brackets we have to close. In other words, for
        # every {, increment this variable, and for every
        # }, decrement, until we hit 0 --return the resulting line
        more_brackets = 0
        done = 0    # will be used to simulate a do-while loop

        # starting_line is given as an integer, whose line numbers 
        # start @ 1, and not 0. Therefore, decrement this number
        # since lists work with indexes beginning at 0
        count = starting_line - 1

        #-------------------------While-Loop--------------------------#
        # While we have not reached the end of the list/EOF
        while ( (count < len(src_lines)) & done != 1):

            # Assign line to the current line we are looking at.
            line = src_lines[count]

            # First, let's search for opening brackets since they
            # should always come First. We will split the current
            # line using this delimeter to quickly find how many.
            lineSplit = line.split('{')
        
            # If we only have 1 opening curly bracket ('{'), the
            # line will split into 2. Therefore, decrement this
            # number and add it to more_brackets
            more_brackets += len(lineSplit) - 1

            # Second, repeat the last two steps, but now search for
            # '}', and decrement more_brackets instead of adding.
            lineSplit = line.split('}')
            more_brackets -= len(lineSplit) - 1

            # If we have reached the end of this function
            if (more_brackets == 0):
                #convert back from 0,1,2,3...n-1 to 1,2,3,...n format
                return (count + 1) 
            else: # Go to next line
                count += 1
        #-------------------------While-Loop--------------------------#

        # Should not reach here! If we never encountered the end, EXIT!!!
        if (count != 0):
            print "\tERROR: get_function_end_line did not find equal number of '{' and '}'"
            sys.exit(2)

    #------------------------------------------------------------------------#
    # Given master list, I can give you function (and other blocks of code)  #
    # line ranges (i.e. 0,14,15,27,28,30). 0-14 represent includes, #defines,#
    # 15-27 represent first function: foo, 28-30 represent empty main. More  #
    # info about what I return is highlighted below.                         #
    #------------------------------------------------------------------------#
    def get_function_range(self, dependency_list, function_list, src_lines):

        """ As stated in the main function, function_list is organized as follows:    
                
            address,    function_name,  starting_line_number,  ending_line_number
            
            The dependency_list is list of dependencies of one function. It is not 
            needed to know which function these dependencies were resolved for 
            (that function is also included in this list/it is a dependent of itself)
            because this is typically done by another function (figure_all_dependencies).
            
            What is returned is a list that is the size of the amount of lines in 
            the file. More specifically, it is len(src_lines). For every line that
            needs to be written to a file (w.r.t. the dependency list), we write a
            value of 0.

            PROCEDURE: 
            We start this function by initilializing this list to all zeros (write
            all lines). We want to make sure we write any preprocessor directives,
            typedefs, structs, unions, and other stuff we don't search for, but
            may be needed within functions, or functions another function may call.

            Next, since we have the master list/ function_list, which holds all
            of our functions, their start and end lines, we mark each one not to
            write (a value of -1).

            Finally, we use our dependency list (to get the functions we are 
            interested in writing to a file) along with the function list to get
            start and end line numbers, and switch those back to a value of 0.
        """

        
        # Create lines_to_write list of size len(src_lines) with
        # initial value of 0. A value of 0 = write line
        lines_to_write = range(0,len(src_lines))
        for i in range(0,len(src_lines)):
            lines_to_write[i] = 0

        # Now for all the functions we have available, mask them
        # off with -1's. A value of -1 = do not write line
        count = 0
        while (count*4 < len(function_list)):
            # for this particular function, the start line is...
            # Note: start/end lines are reported as numbers
            # beginning at 1,2,3...n. Our list works from 0,1,2...
            start_line = function_list[4*count+2] - 1
            # for this particular function, the ending line is...
            end_line = function_list[4*count+3] - 1
            for i in range(start_line,end_line+1):
                lines_to_write[i] = -1
            count += 1
        
        # Now switch the lines of functions within dependency list
        # to 0's. For every function in dependency list....
        for dependency in dependency_list:
            # retreive the index for dependency name in function_list,
            # Adding 1 to index moves you over to start line  value, 
            # and 2 gets you end line value
            index = function_list.index(dependency)
             
            start_line = function_list[index + 1] - 1
            end_line = function_list[index + 2] - 1
            for i in range(start_line,end_line+1):
                lines_to_write[i] = 0
        return lines_to_write

    #--------------------------------------------------------------------#
    # This function creates an initial table with 1st level dependencies #
    # (i.e., functions who are called immediately within the function in #
    # question. This function returns a table
    #--------------------------------------------------------------------#
    def figure_initial_dependencies(self, src_lines, function_list, function_cnt, table, rows, cols):
        
        """ This function receives an empty 2-D array that for each function/row,
            there is a marking in each column to indicate that it calls to the
            respective function (that particular column header). Column headers
            are found in the first row table[0][j] which includes the same functions
            found in the first column table[i][0]. For example,
    
                         ----------------callee functions---------------
            +-----------+-----------+-----------+-----------+-----------+
            |           | function1 | function2 | function3 | function4 |
            +-----------+-----------+-----------+-----------+-----------+
            | function1 |         1 |         0 |         0 |         0 |
            | function2 |         1 |         1 |         1 |         0 |
            | function3 |         0 |         0 |         1 |         0 |
            | function4 |         0 |         0 |         0 |         1 |
            +-----------+-----------+-----------+-----------+-----------+
    
            As an example to reading this: looking on the left side, function2
            calls itself (turned on by default) as well as function3. function3
            calls only itself (default).

            This function fills in this table given the source file lines, and
            for every function, it figures out what other functions it calls and
            marks these positions in the table as 1. Others are left at 0.
        """

        # The first row and col are labels
        count = 1
        if (len(table) != rows):
            print "figure_all_dependencies: Incorrect parameter for table rows"
            sys.exit(2)
        if (len(table[0]) != cols):
            print "figure_all_dependencies: Incorrect parameter for table columns"
            sys.exit(2)
        
    
        count = 0
        # For all the functions....
        while (count < function_cnt):
            dependency_list = []
            
            # Grab the name for this function, start & end line 
            function_name = function_list[4*count+1] 
            function_start = function_list[4*count+2] 
            function_end = function_list[4*count+3] 

            # By default, assuming the the caller placed the function labels
            # in sequential order as found in function_list, then 
            # function_name should equal table[count+1][0]
            if (function_name != table[count+1][0]):
                print "Incorrect ordering for dependency search"
                sys.exit(2)

            current_line_number = function_start
            # For each line in this function we are currently searching, 
            # until the end of the function
            while (current_line_number <= function_end):
                count3 = 0
                # For each line, we search for each function call
                line = src_lines[current_line_number - 1]
                while(count3 < function_cnt):
                    # Match any function call, that has
                    #   - any number of pointers/asterisks in front of it--> why again? TODO
                    #   - any number of spaces
                    #   - no alphanumeric characters. This is to remove the case
                    #   of searching for foo() in barfoo()
                    if (re.search("\**\s*[^a-z,0-9]*" + function_list[4*count3+1] + "\s*\(",line) > -1):
                        dependency_list.append(function_list[4*count3+1])
                        
                        # Since your table is symmetric, and you are searching 
                        # sequentially, here, you can just write a 1 directly
                        # to the table rather than doing another loop again below.
                        # You would need to make sure you mark "main" as a 1 for
                        # each row in the table
                        #
                        #table[count+1][count3+1] = 1
                    count3 += 1
                current_line_number += 1
            # Now we have the dependency list
            # Make sure to append main for each
            dependency_list.append("main")
            count2 = 0
            # Step through each column (count2) for this row (count)
            while (count2 < function_cnt):
                count3 = 0
                # Now ask for each column, is there a dependency in the list?
                while (count3 < len(dependency_list)):
                    if (table[0][count2+1] == dependency_list[count3]):
                        table[count+1][count2+1] = 1
                    count3 += 1
                count2 += 1
            count += 1
        return table

    #--------------------------------------------------------------------#
    # This function takes a table of size rows x cols, and a function    #
    # and returns a list of the functions it calls, those functions that #
    # may call other functions, etc. More info below.                    #
    #--------------------------------------------------------------------#
    def figure_all_dependencies(self, table,function_name,rows,cols):

        """ This function receives a 2-D array that shows for each function/row,
            there is a marking in each column to indicate that it calls to the
            respective function (that particular column header). Column headers
            are found in the first row table[0][j] which includes the same functions
            found in the first column table[i][0]. For example,
    
                         ----------------callee functions---------------
            +-----------+-----------+-----------+-----------+-----------+
            |           | function1 | function2 | function3 | function4 |
            +-----------+-----------+-----------+-----------+-----------+
            | function1 |         1 |         0 |         0 |         0 |
            | function2 |         1 |         1 |         1 |         0 |
            | function3 |         0 |         0 |         1 |         0 |
            | function4 |         0 |         0 |         0 |         1 |
            +-----------+-----------+-----------+-----------+-----------+
    
            As an example to reading this: looking on the left side, function2
            calls itself (turned on by default) as well as function3. function3
            calls only itself (default).

            This table and its markings (0's and 1's) are done by the caller.
            This function achieves to stich together a final list of dependencies
            for function_name. For example, if function_name = function2. Then a
            list is formed by appending to an empty list, function1,2,and 3. It 
            then searches function1 and 3's dependencies in this table, and grabs
            those.....and so on.
        """


        # The first row and col are labels
        count = 1
        if (len(table) != rows):
            print "figure_all_dependencies: Incorrect parameter for table rows"
            sys.exit(2)
        if (len(table[0]) != cols):
            print "figure_all_dependencies: Incorrect parameter for table columns"
            sys.exit(2)

        # Make sure function_name exists in table. 
        # Throws an error if not. We can use this index
        # to know which row since this table should be
        index = 0
        try:
            table[0].index(function_name)
        except ValueError:
            print "ERROR: figure_all_dependencies()"
            print "\tCannot find " + function_name + " in table"
            sys.exit(2)
        else:
            pass
    
        # Now that we have our starting position, we must create two lists:     #
        #   1. Dependency List - will be used to stored the final result        #
        #   2. Buffer/Pending List - will be used to process pending functions  #
        #      in case a function calls more than one.                          #
        final_list = []
        buffer_list = []
        # Append function_name by default, to buffer list
        buffer_list.append(function_name)
        
        # Now that we have an initial buffer_list, we can begin.
        while (len(buffer_list) > 0):
            # Remove last item from buffer
            dependency = buffer_list.pop()
            # Check to make sure it is not added already
            try:
                final_list.index(dependency)
            except ValueError:
                # if that dependency was not in the final list
                # Place it in the final list
                final_list.append(dependency)
                # Now add this dependency's dependencies to buffer_list
                # by figuring out 1) what row it resides, and then searching
                # through each of the row's cols for 1's as done earlier.
                try:
                    index = table[0].index(dependency)
                except ValueError:
                    # Should not reach here
                    print "Could not find dependency in name in this list:"
                    print table[0]
                    sys.exit(2)
                else:
                    # Found row depedency is located in = index
                    column = 1
                    while (column < cols):
                        # do not check diagonal of table
                        if (index == column):
                            pass #skip
                        elif (table[index][column] == 1):
                            buffer_list.append(table[0][column])
                        column += 1
            else:
                pass
        return final_list
    
    #-----------------------------------------------------------#
    # This function checks if there were any error messages     #
    # returned from the previously executed command(s).Modified # 
    # to print warnings only and complete messages in case of   #
    # errors.                                                   #
    # Author: Jason Agron, Eugene Cartwright (modifications)    #
    #-----------------------------------------------------------#
    def error_check(status, message):
        # If status has error, print message and exit
        if (status != 0):
            print "\nERROR - Command failed!"
            print message
        else:
            # print warnings only
            message = message.split('\n')
            for i, line in enumerate (message):
                if (re.search("warning",line) > -1):
                    print line
        
        return status
     
    #----------------------------------------------------------#
    # This function is used to run a series of commands in the #
    # the terminal and receive any output from those commands  #
    # Author: Jason Agron                                      #
    #----------------------------------------------------------#
    def run_command(self, command_list):
        # Form a single command line entry using '&&' to 
        # separate individual commands
        
        # Initialize command string
        command = command_list[0]

        # Concatenate the rest of the commands
        for c in command_list[1::]:
            command = command + " && " + c

        # Invoke command, and check status
        #status = os.system(command)
        ret_tuple = commands.getstatusoutput(command)
        status = self.error_check(ret_tuple[0], ret_tuple[1])

        return status


    #---------------------------------------------------------#
    # This function will grab functions defined in the file,  #
    # the address associated with them, and the line numbers. #
    # It is important that you did not have any optimization  #
    # flags turned on when you compiled the original (source) #
    # file. This can lead to incorrect line numbers reported  #
    # the various GNU binutils tool suite.                    #
    #---------------------------------------------------------#
    def get_functions(self, file):
        # First, grab the name of file
        file_name = file + ".c"
        file_name = file_name.split('/')
        file_name = file_name[-1]
        # Now search for symbols defined in "file_name"
        command = self.elf_symtab + " " + file + " | grep -e \"\sT\s.*"  + file_name + "\""
        ret_sym = commands.getstatusoutput(command)
        # Check for any error
        if (ret_sym[0] != 0):
            # if there is a message, print it
            if (len(ret_sym[1]) > 0): 
                print "ERROR: " + ret_sym[1]
            # if there wasn't a message (because we 
            # didn't find anything during grep)
            else:
                print "Did you enable the debugging option for slave processors (-g or -ggdb)?"
                print "This flag can be specified in $PLATFORM/config/Jamrules file."
                print "This option generally applies to Split-BRAM systems"
            sys.exit(ret_sym[0])
        
        # Now separate output into tuples, where each relates
        # to one symbol of original source file
        splitUp_sym = ret_sym[1].split('\n')
        
        # Now loop through each finding those with symbol type = T
        function_list = []
        function_cnt = 0
        #for i in enumerate(splitUp_sym):
        for i in range(len(splitUp_sym)):
            # Split up using delimeter spaces
            splitUp_item = splitUp_sym[i].split(' ')
            symOffset = splitUp_item[0]     # First is symbol offset
            symType = splitUp_item[1]       # Symbol type (T = function)
            symName     = splitUp_item[2]   # Symbol name. Futher stripping needed
            # Fixup synName - output currently looks like this:
            # foo\tPath/to/file.c:34"
            function_name = (symName.split('\t'))[0]    #split "name" and "path_to_file:line"
            line_num = (symName.split(':'))[-1]         #split "line_num" "name\tpath_to_file"
            if ((symType == 'T') and (symName[0] != "_")):
                function_list.append('0x' + symOffset)
                function_list.append(function_name)
                function_list.append(line_num)  # Placement for starting line number
                function_list.append(line_num)  # Placement for ending line number
                function_cnt += 1
        function_list.append(function_cnt)
        return function_list

    #---------------------------------------------------------------#
    # Removes C/C++ comments in the file in order to make searching #
    # for functions and their dependencies a lot easier. Reduces    #
    # the chances for false positives. This function acceps all the #
    # source lines of your file.                                    #
    #---------------------------------------------------------------#
    def remove_comments(self, lines):
        # Regular expressions strings stored in local variables
        # for easier code reading.
        single_comment_regex = '\s*//.*\s*'
        multi_comment_regex =  '\s*/\*.*'
        end_multi_comment_regex = '.*\*/\s*'
        
        # Will be used to stored source code lines without comments
        new_lines = []
        count = 0
        again = 0
        for line in lines:
            # This variable, again will be used to check if we need to 
            # continue searching for the terminating '*/' in a multiline
            # comment.
            if (again):
                # Have we reached end of multi-
                # line comment?
                multiple_line_end = re.search(end_multi_comment_regex ,line)
                if (multiple_line_end > -1):
                    # Yes, we have
                    new_lines.append(re.sub(end_multi_comment_regex,'', line))
                    again = 0
                    
                    # If whole line was removed, add \n
                    if (len(new_lines[-1]) == 0):
                        new_lines[-1] = '\n'
                    # is there a single-line
                    # comment for some odd 
                    # reason?
                    else:
                        new_lines[-1] = re.sub(single_comment_regex,'\n', new_lines[-1])
                else:
                    new_lines.append('\n')
                    again = 1
            # If again == 0, we need to search 1st for a single line
            # comment since that dictates everything after it is a 
            # comment (even //--->  /*multiline comment*/), and then 
            # search  for multiline comments.
            else:            
                # We need to get rid of single line 
                # comments (i.e. //bla).
                original = line 
                line = re.sub(single_comment_regex,'', line )
                
                # Next, we need to catch multi-line comments
                # after taken care of those single lines
                multiple_line_start = re.search(multi_comment_regex ,line)
                multiple_line_end = re.search(end_multi_comment_regex ,line)
                if (multiple_line_start > -1):
                    # If the multi-line comment is only on 1
                    # line, try to remove it all now
                    if (multiple_line_end > -1):
                        new_lines.append(re.sub(multi_comment_regex + end_multi_comment_regex,'', line))
                        again = 0
                        
                        # If whole line was removed, add \n
                        if (len(new_lines[-1]) == 0):
                            new_lines[-1] = '\n'
                        # is there a single-line
                        # comment for some odd 
                        # reason?
                        else:                        
                            new_lines[-1] = re.sub(single_comment_regex,'\n', new_lines[-1])
                    else:
                        new_lines.append(re.sub(multi_comment_regex,'', line))
                        again = 1
                else:
                    if (original != line):
                        # we removed \n
                        new_lines.append(line + '\n')
                    else:
                        # Just add original string
                        new_lines.append(line)
        return new_lines
