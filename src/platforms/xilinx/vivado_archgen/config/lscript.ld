/* Sen Ma Modify in on 7/26/2013 to use it in kc705 */

_STACK_SIZE = DEFINED(_STACK_SIZE) ? _STACK_SIZE : 64k;
_HEAP_SIZE = DEFINED(_HEAP_SIZE) ? _HEAP_SIZE : 250M;

/* Define Memories in the system */

MEMORY
{
   microblaze_0_i_bram_ctrl_microblaze_0_d_bram_ctrl : ORIGIN = 0x00000050, LENGTH = 0x0000FFB0
   ddr3_sdram_S_AXI_BASEADDR : ORIGIN = 0x80000000, LENGTH = 0x40000000
   //axi_bram_ctrl_0_S_AXI_BASEADDR : ORIGIN = 0xB0000000, LENGTH = 0x00004000
   thread : ORIGIN = 0x80000000, LENGTH = 1M
}

/* Specify the default entry point to the program */

STARTUP(crt0.o)
ENTRY(_start)

/* Define the sections, and where they are mapped in memory */

SECTIONS
{
.vectors.reset 0x00000000 : {
   KEEP(*(.vectors.reset))
} 

.vectors.sw_exception 0x00000008 : {
   KEEP(*(.vectors.sw_exception))
} 

.vectors.interrupt 0x00000010 : {
   KEEP(*(.vectors.interrupt))
} 

.vectors.hw_exception 0x00000020 : {
   KEEP(*(.vectors.hw_exception))
} 

.text : {
   *(.text)
   *(.text.*)
   *(.gnu.linkonce.t.*)
} > ddr3_sdram_S_AXI_BASEADDR

.init : {
   KEEP (*(.init))
} > ddr3_sdram_S_AXI_BASEADDR

.fini : {
   KEEP (*(.fini))
} > ddr3_sdram_S_AXI_BASEADDR

.ctors : {
   __CTOR_LIST__ = .;
   ___CTORS_LIST___ = .;
   KEEP (*crtbegin.o(.ctors))
   KEEP (*(EXCLUDE_FILE(*crtend.o) .ctors))
   KEEP (*(SORT(.ctors.*)))
   KEEP (*(.ctors))
   __CTOR_END__ = .;
   ___CTORS_END___ = .;
} > ddr3_sdram_S_AXI_BASEADDR

.dtors : {
   __DTOR_LIST__ = .;
   ___DTORS_LIST___ = .;
   KEEP (*crtbegin.o(.dtors))
   KEEP (*(EXCLUDE_FILE(*crtend.o) .dtors))
   KEEP (*(SORT(.dtors.*)))
   KEEP (*(.dtors))
   PROVIDE(__DTOR_END__ = .);
   PROVIDE(___DTORS_END___ = .);
} > ddr3_sdram_S_AXI_BASEADDR

.rodata : {
   __rodata_start = .;
   *(.rodata)
   *(.rodata.*)
   *(.gnu.linkonce.r.*)
   __rodata_end = .;
} > ddr3_sdram_S_AXI_BASEADDR

.sdata2 : {
   . = ALIGN(8);
   __sdata2_start = .;
   *(.sdata2)
   *(.sdata2.*)
   *(.gnu.linkonce.s2.*)
   . = ALIGN(8);
   __sdata2_end = .;
} > ddr3_sdram_S_AXI_BASEADDR

.sbss2 : {
   __sbss2_start = .;
   *(.sbss2)
   *(.sbss2.*)
   *(.gnu.linkonce.sb2.*)
   __sbss2_end = .;
} > ddr3_sdram_S_AXI_BASEADDR

.data : {
   . = ALIGN(4);
   __data_start = .;
   *(.data)
   *(.data.*)
   *(.gnu.linkonce.d.*)
   __data_end = .;
} > ddr3_sdram_S_AXI_BASEADDR

.got : {
   *(.got)
} > ddr3_sdram_S_AXI_BASEADDR

.got1 : {
   *(.got1)
} > ddr3_sdram_S_AXI_BASEADDR

.got2 : {
   *(.got2)
} > ddr3_sdram_S_AXI_BASEADDR

.eh_frame : {
   *(.eh_frame)
} > ddr3_sdram_S_AXI_BASEADDR

.jcr : {
   *(.jcr)
} > ddr3_sdram_S_AXI_BASEADDR

.gcc_except_table : {
   *(.gcc_except_table)
} > ddr3_sdram_S_AXI_BASEADDR

.sdata : {
   . = ALIGN(8);
   __sdata_start = .;
   *(.sdata)
   *(.sdata.*)
   *(.gnu.linkonce.s.*)
   __sdata_end = .;
} > ddr3_sdram_S_AXI_BASEADDR

.sbss (NOLOAD) : {
   . = ALIGN(4);
   __sbss_start = .;
   *(.sbss)
   *(.sbss.*)
   *(.gnu.linkonce.sb.*)
   . = ALIGN(8);
   __sbss_end = .;
} > ddr3_sdram_S_AXI_BASEADDR

.tdata : {
   __tdata_start = .;
   *(.tdata)
   *(.tdata.*)
   *(.gnu.linkonce.td.*)
   __tdata_end = .;
} > ddr3_sdram_S_AXI_BASEADDR

.tbss : {
   __tbss_start = .;
   *(.tbss)
   *(.tbss.*)
   *(.gnu.linkonce.tb.*)
   __tbss_end = .;
} > ddr3_sdram_S_AXI_BASEADDR

.bss (NOLOAD) : {
   . = ALIGN(4);
   __bss_start = .;
   *(.bss)
   *(.bss.*)
   *(.gnu.linkonce.b.*)
   *(COMMON)
   . = ALIGN(4);
   __bss_end = .;
} > ddr3_sdram_S_AXI_BASEADDR

_SDA_BASE_ = __sdata_start + ((__sbss_end - __sdata_start) / 2 );

_SDA2_BASE_ = __sdata2_start + ((__sbss2_end - __sdata2_start) / 2 );

/* Generate Stack and Heap definitions */

.heap (NOLOAD) : {
   . = ALIGN(8);
   _heap = .;
   _heap_start = .;
   . += _HEAP_SIZE;
   _heap_end = .;
} > ddr3_sdram_S_AXI_BASEADDR

.stack (NOLOAD) : {
   _stack_end = .;
   . += _STACK_SIZE;
   . = ALIGN(8);
   __stack0 = .;
   . += _STACK_SIZE;
   . = ALIGN(8);
   __stack1 = .;
} > ddr3_sdram_S_AXI_BASEADDR

.thread : 
{
    __thread_start = .;
    *(thread)
    __thread_end = .;
} > thread

_end = .;
}
