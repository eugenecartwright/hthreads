/*
  ------------------------------------------------------------------
  hvm_app_loader.c
  ------------------------------------------------------------------
  A program used to bootstrap HVM applications:
  * Loads an application into the HVM instruction memory (IM)
  * Runs the application, and prints the return value
  ------------------------------------------------------------------
*/

#include "hvm_utils.h"
#include "program.h"

int main()
{ 
    int ret_val;

    // Run included program
    ret_val = run_HVM_app(&program_array[0], prog_size);
    
    return 0;
}

