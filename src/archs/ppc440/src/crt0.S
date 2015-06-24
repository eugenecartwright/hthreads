    .text
    .globl  _start
_start:
    // Allocate new stack for the current processor
    // FIXME: Stack Code below will need to be changed
    // bl _ppc405_alloc_stack

    // Load register 1 with a pointer to the stack
    lis     1, __stack@h
    ori     1, 1, __stack@l

    // Setup the initial stack frame
    addi    1, 1, -8
    lis     0, 0
    stw     0, 0(1)
    
    // Load the small data area into register 13
    lis     13, _SDA_BASE_@h
    ori     13, 13, _SDA_BASE_@l

    // Load the second small data area into register 2
    lis     2, _SDA2_BASE_@h
    ori     2, 2, _SDA2_BASE_@l
    
    // Set two reserved bits as per Xilinx PPC405 Errata
    bl _ppc405_xilinx_errata

    // Fill the sbss area with all zeros
    lis     3, __sbss_start@h
    ori     3, 3, __sbss_start@l
    lis     4, __sbss_end@h
    ori     4, 4, __sbss_end@l
    bl      _ppc405_clear
    
    // Fill the bss area with all zeros
    lis     3, __bss_start@h
    ori     3, 3, __bss_start@l
    lis     4, __bss_end@h
    ori     4, 4, __bss_end@l
    bl      _ppc405_clear

    // Initialize the timer to zero
    bl      _ppc405_setup_timer

    // Initialize the FPU if it is available
#ifdef HTHREADS_FPU
    bl      _ppc405_setup_fpu
#endif

    // Place the a global context in the SPRG4 register
    // intially. This is done because the reentrancy
    // structure is pull from the context stored in SPRG4
    // and we want reentrancy to work very quickly
    lis         3, __global_context@h
    ori         3, 3, __global_context@l
    mtusprg0    3

    // Initialize the libc locking/unlocking code
    bl      _libc_init

    // Setup the cpuid for the processor
    bl      _arch_cpuid_init

    // Setup STDIO for the main function
    bl      stdio_init

    // Call the hthreads initialization routine
    bl      hthread_init
        
    // Run the main function
    bl      main

    // Perform cleanup functions
    bl      __fini

    // Finish executing the program
    bl      exit
    
    .globl _exit
_exit:
    bl      stdio_destroy

_exitloop:
    b _exitloop
