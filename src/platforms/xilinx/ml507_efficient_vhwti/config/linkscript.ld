_STACK_SIZE = DEFINED(_STACK_SIZE) ? _STACK_SIZE : 64K;
_HEAP_SIZE  = DEFINED(_HEAP_SIZE)  ? _HEAP_SIZE  : 250M;
_MEM_SIZE   = DEFINED(_MEM_SIZE) ? _MEM_SIZE : 256M;

MEMORY
{
   memory : ORIGIN = 0xa0000000, LENGTH = 256M
   boot0  : ORIGIN = 0xFFFFE000, LENGTH = 0x1FFF - 4
   boot   : ORIGIN = 0xFFFFFFFC, LENGTH = 4
}

PHDRS
{
    ivector PT_LOAD ;
    program PT_LOAD ;
    data1   PT_LOAD ;
    data2   PT_LOAD ;
    stack   PT_LOAD ;
    heap    PT_LOAD ;
    boot0   PT_LOAD ;
    boot    PT_LOAD ;
}

STARTUP(boot.o)
ENTRY(_boot)

SECTIONS
{
    .hvectors :
    {
        . = ALIGN( 64k );
        *(.hvectors)
    } > memory : ivector

    .rel.dyn :
    {
        *(.rel.init)
        *(.rel.text .rel.text.* .rel.gnu.linkonce.t.*)
        *(.rel.fini)
        *(.rel.rodata .rel.rodata.* .rel.gnu.linkonce.r.*)
        *(.rel.data .rel.data.* .rel.gnu.linkonce.d.*)
        *(.rel.tdata .rel.tdata.* .rel.gnu.linkonce.td.*)
        *(.rel.tbss .rel.tbss.* .rel.gnu.linkonce.tb.*)
        *(.rel.ctors)
        *(.rel.dtors)
        *(.rel.got)
        *(.rel.sdata .rel.sdata.* .rel.gnu.linkonce.s.*)
        *(.rel.sbss .rel.sbss.* .rel.gnu.linkonce.sb.*)
        *(.rel.sdata2 .rel.sdata2.* .rel.gnu.linkonce.s2.*)
        *(.rel.sbss2 .rel.sbss2.* .rel.gnu.linkonce.sb2.*)
        *(.rel.bss .rel.bss.* .rel.gnu.linkonce.b.*)
    } > memory

    .rela.dyn :
    {
        *(.rela.init)
        *(.rela.text .rela.text.* .rela.gnu.linkonce.t.*)
        *(.rela.fini)
        *(.rela.rodata .rela.rodata.* .rela.gnu.linkonce.r.*)
        *(.rela.data .rela.data.* .rela.gnu.linkonce.d.*)
        *(.rela.tdata .rela.tdata.* .rela.gnu.linkonce.td.*)
        *(.rela.tbss .rela.tbss.* .rela.gnu.linkonce.tb.*)
        *(.rela.ctors)
        *(.rela.dtors)
        *(.rela.got)
        *(.rela.toc)
        *(.rela.sdata .rela.sdata.* .rela.gnu.linkonce.s.*)
        *(.rela.sbss .rela.sbss.* .rela.gnu.linkonce.sb.*)
        *(.rela.sdata2 .rela.sdata2.* .rela.gnu.linkonce.s2.*)
        *(.rela.sbss2 .rela.sbss2.* .rela.gnu.linkonce.sb2.*)
        *(.rela.bss .rela.bss.* .rela.gnu.linkonce.b.*)
    } > memory

    .rel.plt : 
    { 
        *(.rel.plt) 
    } > memory
    
    .rela.plt : 
    { 
        *(.rela.plt) 
    } > memory

    .text : 
    {
        *(.text)
        *(.text.*)
        *(.gnu.linkonce.t.*)
        *(.glink)
    } > memory : program

    .interp :
    { 
        *(.interp)
    } > memory : program

    .hash : 
    { 
        *(.hash) 
    } > memory

    .dynsym : 
    { 
        *(.dynsym) 
    } > memory

    .dynstr : 
    { 
        *(.dynstr)
    } > memory

    .gnu.version    :
    { 
        *(.gnu.version)
    } > memory
    
    .gnu.version_d  : 
    { 
        *(.gnu.version_d)
    } > memory
    
    .gnu.version_r :
    { 
        *(.gnu.version_r)
    } > memory

    .init :
    {
        KEEP (*(.init))
    } > memory : program

    .fini : 
    {
        KEEP (*(.fini))
    } > memory : program

    .rodata :
    {
        __rodata_start = .;
        *(.rodata)
        *(.rodata.*)
        *(.gnu.linkonce.r.*)
        __rodata_end = .;
    } > memory : data1

    .sdata2 : 
    {
        __sdata2_start = .;
        *(.sdata2)
        *(.gnu.linkonce.s2.*)
        __sdata2_end = .;
    } > memory

    .sbss2 : 
    {
        __sbss2_start = .;
        *(.sbss2)
        *(.gnu.linkonce.sb2.*)
        __sbss2_end = .;
    } > memory

    .eh_frame_hdr : 
    { 
        *(.eh_frame_hdr)
    } > memory

    .dynamic :
    {
        *(.dynamic)
    } > memory

    .data : 
    {
        __data_start = .;
        *(.data)
        *(.data.*)
        *(.gnu.linkonce.d.*)
        __data_end = .;
    } > memory : data2

    .got : 
    {
        *(.got)
    } > memory

    .got1 : 
    {
        *(.got1)
    } > memory

    .got2 : 
    {
        *(.got2)
    } > memory

    .ctors : 
    {
        __CTOR_LIST__ = .;
        ___CTORS_LIST___ = .;
        KEEP (*crtbegin.o(.ctors))
        KEEP (*(EXCLUDE_FILE(*crtend.o) .ctors))
        KEEP (*(SORT(.ctors.*)))
        KEEP (*(.ctors))
        __CTOR_END__ = .;
        ___CTORS_END___ = .;
    } > memory : data1

    .dtors : 
    {
        __DTOR_LIST__ = .;
        ___DTORS_LIST___ = .;
        KEEP (*crtbegin.o(.dtors))
        KEEP (*(EXCLUDE_FILE(*crtend.o) .dtors))
        KEEP (*(SORT(.dtors.*)))
        KEEP (*(.dtors))
        __DTOR_END__ = .;
        ___DTORS_END___ = .;
    } > memory : data1

    .fixup : 
    {
        __fixup_start = .;
        *(.fixup)
        __fixup_end = .;
    } > memory

    .eh_frame : 
    {
        *(.eh_frame)
    } > memory

    .jcr : 
    {
        *(.jcr)
    } > memory

    .gcc_except_table : 
    {
        *(.gcc_except_table)
    } > memory

    .sdata : 
    {
        __sdata_start = .;
        *(.sdata)
        *(.gnu.linkonce.s.*)
        __sdata_end = .;
    } > memory

    .sbss : 
    {
        __sbss_start = .;
        *(.dynsbss)
        *(.sbss)
        *(.gnu.linkonce.sb.*)
        *(.scommon)
        __sbss_end = .;
    } > memory

    .tdata : 
    {
        __tdata_start = .;
        *(.tdata)
        *(.gnu.linkonce.td.*)
        __tdata_end = .;
    } > memory

    .tbss : 
    {
        __tbss_start = .;
        *(.tbss)
        *(.gnu.linkonce.tb.*)
        __tbss_end = .;
    } > memory

/*
    .plt :
    { 
        *(.plt)
    } > memory
*/
    .bss : 
    {
        __bss_start = .;
        *(.dynbss)
        *(.bss)
        *(.gnu.linkonce.b.*)
        *(COMMON)
        . = ALIGN(4);
        __bss_end = .;
    } > memory

    bss_stack : 
    {
        . += _STACK_SIZE;
        . = ALIGN(16);
        __stack = .;
    } > memory : stack

    bss_heap : 
    {
        . = ALIGN(16);
        _heap_start = .;
        /*. += _HEAP_SIZE;*/
        /*. = ABSOLUTE(0x0FFFFFFF);*/
        /*. = ALIGN(16);*/
        /* . += _MEM_SIZE - __stack - 1;*/
        /* . += _MEM_SIZE - __stack;*/
        /*. += 0x40000; */
        . += _HEAP_SIZE;
        _heap_end = .;
    } > memory : heap

    .boot0 : 
    {
        __boot0_start = .;
        *(.boot0)
        __boot0_end = .;
    } > boot0 : boot0

    .boot : 
    {
        __boot_start = .;
        *(.boot)
        __boot_end = .;
    } > boot : boot


    PROVIDE(_SDA_BASE_ = __sdata_start + (__sbss_end - __sdata_start / 2 ));
    PROVIDE(_SDA2_BASE_ = __sdata2_start + (__sbss2_end - __sdata2_start / 2 ));

}

