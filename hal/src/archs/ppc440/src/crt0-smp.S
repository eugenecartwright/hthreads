	.text
	.globl	_start
_start:
    // Allocate new stack for the current processor
    // FIXME: Stack Code below will need to be changed
    // bl _ppc405_alloc_stack

    // Get the CPUID number from the thread manager
    lis     9, 0x6000
    ori     9, 9, 0x7C00
    lwz     0, 0(9)
    mtsprg7 0

    // Determine which stack to use
    cmpwi   0, 0
    bne     _start_setup_stack1

_start_setup_stack0:
    // Load register 1 with a pointer to the stack
    lis     1, __stack0@h
    ori     1, 1, __stack0@l
    b       _start_stack_done

_start_setup_stack1:
    // Load register 1 with a pointer to the stack
    lis     1, __stack1@h
    ori     1, 1, __stack1@l

_start_stack_done:
    // Setup the initial stack frame
	addi	1, 1, -8
	lis	    0, 0
	stw	    0, 0(1)
    
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

    // Initialize the libc locking/unlocking code
    bl      _libc_init

    // Initialize the FPU if it is available
#ifdef HTHREADS_FPU
    bl      _ppc405_setup_fpu
#endif

    // Setup the cpuid for the processor
    //bl      _arch_cpuid_init

    // Setup STDIO for the main function
    bl      stdio_init

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
