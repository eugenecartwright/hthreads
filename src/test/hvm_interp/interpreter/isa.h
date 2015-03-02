#ifndef ISA_H
#define ISA_H

#define NUMBER_REGISTERS 256

/* Registers required for interpreters */
#define           PC  0xC3
#define           SP  0xC0
#define      RET_VAL  0xC2

/* Instruction opcodes (first byte) */
#define          ADD  0x00
#define          SUB  0x01
#define          MUL  0x02
#define          AND  0x03
#define           OR  0x04
#define          XOR  0x05
#define         SHRA  0x06
#define         SHRL  0x07
#define          SHL  0x08
#define          JEZ  0x11
#define         LOAD  0x12
#define        STORE  0x13
#define         LDLO  0x14
#define         LDHI  0x15

#endif

