#ifndef INTERPRET_H
#define INTERPRET_H

#include "common/types.h"
#include "common/tcb.h"
#include "interpreter/isa.h"


/* Define the size of each software thread's address space */
#define ADDRESS_SPACE_SIZE 8000


typedef int ErrorCode;
#define NO_ERROR 0x0
#define ERROR_FETCH 0x010
#define ERROR_LOAD 0x0100
#define ERROR_STORE 0x01000
#define ERROR_DEAD_CODE 0x010000




typedef struct {
  byte opcode;
  byte byte0;
  byte byte1;
  byte byte2;
} Instruction;




typedef unsigned int VirtualAddress;




#define TIME_SLICE_SIZE (1000)



void print_register_file(word* register_file);

ErrorCode interpreter(TCB* tcb, word * register_file);

void* interpreter_entry_point(void* tcb);
void* interpreter_entry_point_import(void* tcb);



#endif

