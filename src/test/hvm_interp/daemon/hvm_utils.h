/*

   Header File Used to Help Define HVM Applications

   */

#include <stdio.h>
#include "interpreter/isa.h"
#include "common/types.h"

// Operator that concatenates OPCODES to ARGUMENTS
#define op_cat(x,y)     (x##y)

// Definitions for TRUE and FALSE (b/c MB compiler doesn't support bools)
#define TRUE    1
#define FALSE   0

// Pseudonym for END OF PROGRAM
#define END_PROG() 0xFF

// Definitions for HVM Memory
#define HVM_PROG_MEM_BASE    0x62000000
#define HVM_STATE_MEM_BASE   0x64000000
volatile byte *hvm_prog_mem = (byte*)HVM_PROG_MEM_BASE;
volatile byte *hvm_state_mem = (byte*)HVM_STATE_MEM_BASE;

// Definitions for HVM Controller
#define HVM_CONTROL_BASE    0x63000000
volatile int *hvm_control_pointer = (int*)HVM_CONTROL_BASE;
volatile int *hvm_go = (int*)HVM_CONTROL_BASE + 0;
volatile int *hvm_mode = (int*)HVM_CONTROL_BASE + 1;
volatile int *hvm_rst = (int*)HVM_CONTROL_BASE + 2;
volatile int *hvm_done = (int*)HVM_CONTROL_BASE + 3;

// Definitions for LEDS
#define LED_BASE            0x40000000
#define LED_OUTPUT_MODE     0x00000000
volatile int *led_data = (int*)LED_BASE;
volatile int *led_tri  = (int*)LED_BASE + 1;

// HVM Mode Commands
#define HVM_MODE_NOOP       0x00
#define HVM_MODE_INTERPRET  0x03
#define HVM_MODE_EXPORT     0x02
#define HVM_MODE_IMPORT     0x01

// Function used to inject delay
void delay(int dl)
{
    int x;
    for (x = 0; x < dl; x ++);
    return;
}

// Function used to initialize a block of contiguous memory with a specific value
void clear_memory(volatile byte *mem_ptr, int length, byte clear_value)
{
    volatile byte *index;

    // Write the clear_value to each memory location
    for (index = mem_ptr; index < (mem_ptr + length); index++)
    {
        *index = clear_value;
    }

    return;
}

// Function used to initialize a block of contiguous memory with a set of values
void load_memory(volatile byte *mem_ptr, int length, byte *value_set)
{
    volatile byte *index;

    // Load the block of memory with the set of values
    for (index = mem_ptr; index < (mem_ptr + length); index++)
    {
        *index = *value_set;
        value_set++;
    }

    return;
}

// Function used to display a block of contiguous memory values
void show_memory(volatile byte *mem_ptr, int length)
{
    volatile int *index;

    // Write the clear_value to each memory location
    for (index = (int*)mem_ptr; index < (int*)(mem_ptr + length); index = index + 1)
    {
        printf("MEM(0x%08x) = 0x%08x\r\n",(unsigned int)index,(unsigned int)*index);  
    }

    return;
}

// Function used to check to see if HVM is finished
int is_HVM_done()
{
    int ret;
    if (*hvm_done == 0)
        ret = FALSE;
    else
        ret = TRUE;

    return ret;
}

// Function used to wait for HVM to finish
void wait_HVM()
{
    while (is_HVM_done() != TRUE);

    return;
}
// Function used to tell HVM to import it's state
void import_state_HVM(ExportBuffer *cpuState, byte *progState)
{
    int counter;

    // A word-addressable version of the hvm state memory
    word * hvm_reg_file = (word*)(hvm_state_mem);

    // The current stack pointer ("current" end of data)
    word stackPointer = cpuState->register_file[SP];

    // Halt the interpreter
    *hvm_mode = HVM_MODE_NOOP;
    *hvm_go = 1;

    // Copy all CPU state into state mem
    for (counter = 0; counter < NUMBER_REGISTERS; counter = counter + 1)
    {
        hvm_reg_file[counter] = cpuState->register_file[counter];

        if (hvm_reg_file[counter] != cpuState->register_file[counter])
        {
            printf("\nMigration error, register %d doesn't match!\n",counter);
            printf("HVM = 0x%08x, Buffer = 0x%08x\n",hvm_reg_file[counter],cpuState->register_file[counter]);
        }
    }
    
    // Copy all program state into prog. mem (instructions and data)
    for (counter = 0; counter < stackPointer; counter = counter + 1)
    {
        hvm_prog_mem[counter] = progState[counter];

        if (hvm_prog_mem[counter] != progState[counter])
        {
            printf("Migration error, address %d doesn't match!\n",counter);
        }
    }

    // Import state command
    *hvm_mode = HVM_MODE_IMPORT;
    *hvm_go = 1;
}

// Function used to tell HVM to export it's state
void export_state_HVM()
{
    int reg_of_interest = PC*4;
    volatile int* pc_reg = (int*)(hvm_state_mem + reg_of_interest);

    // Init. the PC to all 0's (so that wait for export will have initialized data)
    *pc_reg = 0x00000000;

    // Export state command (this should set the pc_reg to be all F's when complete)
    *hvm_mode = HVM_MODE_EXPORT;
    *hvm_go = 1;

    return;
}

// Function used to wait for HVM to finish exporting state (waits until PC in state mem is all F's)
void wait_export_complete_HVM()
{
    int reg_of_interest = PC*4;
    volatile int* pc_reg = (int*)(hvm_state_mem + reg_of_interest);

    // Wait for export to push out the PC
    while (*pc_reg != 0xFFFFFFFF);

    return;
}

// Function used to get the current SP out of the exported state (for use in exporting/importing data from HVM, note export must be complete)
int get_current_SP_HVM()
{
    int reg_of_interest = SP*4;
    volatile int* sp_reg = (int*)(hvm_state_mem + reg_of_interest);

    return *sp_reg;
}

void migrate_HVM_registers_to_buffer(ImportBuffer* buffer) {
  unsigned int index;

  // A word-addressable version of the hvm state memory
  word * hvm_reg_file = (word*)(hvm_state_mem);

  for ( index = 0 ; index < NUMBER_REGISTERS ; ++ index )
  {
	buffer->register_file[index] = hvm_reg_file[index];
  }
}


// Function used to get return value from HVM
// NOTE : You must first export the interpreter's state before running this function
int get_HVM_return_value()
{
    int ret_val;
    int reg_of_interest = RET_VAL*4;
    volatile int* ret_reg = (int*)(hvm_state_mem + reg_of_interest);

    // Dereference the register of interest
    ret_val = *ret_reg;

    // Debug info
    //printf("Return value (addr = 0x%08x) = 0x%08x\r\n",(unsigned int)ret_reg,(unsigned int)ret_val);

    // Return the result
    return ret_val;
}

void light_LED(int n)
{
    // Set up LEDs
    *led_tri = LED_OUTPUT_MODE;

    // Light up LED-n (LEDs are negative logic)
    *led_data = ~n; 

    return;
}

// Function used to reset HVM
void reset_HVM()
{
    int reg_of_interest = PC*4;
    volatile int* pc_reg = (int*)(hvm_state_mem + reg_of_interest);

    // Create a rising edge pulse on the reset line (LSB)
    *hvm_rst = 0;
    *hvm_rst = 1;
    *hvm_rst = 0;

    // Halt HVM
    *hvm_mode = HVM_MODE_NOOP;
    *hvm_go = 0;

    // Init. the PC to all 0's (so that wait for export will have initialized data)
    *pc_reg = 0x00000000;

    return;
}

// Function used to run HVM
void run_HVM()
{
    // Create a rising edge pulse on the reset line (LSB)
    *hvm_mode = HVM_MODE_INTERPRET;
    *hvm_go = 1;

    return;
}

// Function used to run an entire app on the HVM (uses the pre-defined globals for programs)
// * Resets the processor, loads and runs the program
// * Waits for program to finish
// * Exports state and grabs return value
int run_HVM_app(byte * program_array, int prog_size)
{
  // Variable to hold program size and return value
  int program_size  = prog_size;
  int ret_val;

  // Display memory-map
  print("\r\n**************************************************\r\n");
  print("           HVM (HIF Virtual Machine)                  \r\n");
  print("**************************************************\r\n");
  print("              Memory Map\r\n");
  print("**************************************************\r\n");
  printf("base_controller        = 0x%08x\r\n",(unsigned int)hvm_control_pointer);
  printf("\thvm_go         = 0x%08x\r\n",(unsigned int)hvm_go);
  printf("\thvm_mode       = 0x%08x\r\n",(unsigned int)hvm_mode);
  printf("\thvm_rst        = 0x%08x\r\n",(unsigned int)hvm_rst);
  printf("\thvm_done       = 0x%08x\r\n",(unsigned int)hvm_done);
  printf("base_HVM_PROG_MEM      = 0x%08x\r\n",(unsigned int)hvm_prog_mem);
  printf("base_HVM_STATE_MEM     = 0x%08x\r\n",(unsigned int)hvm_state_mem);
  print("**************************************************\r\n");

  // Clear out program memory
  print("Clearing HVM program memory...\r\n");
  clear_memory(hvm_prog_mem, program_size*2, 0);

  // Load program into program memory
  print("Loading program code into HVM program memory...\r\n");
  load_memory(hvm_prog_mem, program_size, &program_array[0]);

  // Show program contents
  //print("Displaying HVM program in memory...\r\n");
  //show_memory(hvm_prog_mem,program_size);

  // Reset HVM processor (Active-high pulse)
  print("Resetting HVM processor...\r\n");
  reset_HVM();

  // Run the HVM processor
  print("Starting execution of HVM processor...\r\n");
  run_HVM();

  // Wait for HVM to complete execution
  print("Waiting for HVM to complete...\r\n");
  wait_HVM();
  print("HVM COMPLETE!\r\n");

  // Export and display HVM state
  export_state_HVM();
  
  // Wait a bit...
  wait_export_complete_HVM();

  // Get the HVM return value and display it
  ret_val = get_HVM_return_value();
  printf("Program Return value = 0x%08x\r\n",ret_val);
  
  return ret_val;
}

